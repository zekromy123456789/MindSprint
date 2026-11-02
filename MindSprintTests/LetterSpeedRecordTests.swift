import XCTest
@testable import MindSprint

private final class RecordIntegrationClock: SessionClock { var now: TimeInterval = 0 }

final class LetterSpeedRecordTests: XCTestCase {
    func testCompletedSessionPersistsOnceAcrossStoreReopen() throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let url = dir.appendingPathComponent("records.sqlite")
        let clock = RecordIntegrationClock()
        var round = LetterSpeedRound(difficulty: .expert, clock: clock, seed: 19)
        XCTAssertNil(round.completedRecord)
        round.start()
        clock.now = 3
        round.refresh()
        XCTAssertTrue(round.choose(round.question!.correctIndex, forQuestion: round.questionID))
        for _ in 0..<9 { clock.now += 30; round.refresh() }
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.difficulty, .expert)
        XCTAssertEqual(record.configuration.mode, "ten-round")
        XCTAssertEqual(record.score, 30)
        XCTAssertEqual(record.correct, 1)
        XCTAssertEqual(record.incorrect, 0)
        XCTAssertNil(record.responseTimes)
        XCTAssertEqual(round.completedRecord, record)
        do {
            let store = try RecordStore(url: url)
            XCTAssertTrue(try store.insertOnce(record))
            XCTAssertFalse(try store.insertOnce(record))
        }
        let reopened = try RecordStore(url: url)
        XCTAssertEqual(try reopened.allRecords(), [record])
        XCTAssertFalse(try reopened.insertOnce(record))
        let conflict = SessionRecord(id: record.id, configuration: record.configuration,
            outcome: .completed, finishedAt: record.finishedAt, score: 99)
        XCTAssertThrowsError(try reopened.insertOnce(conflict))
        XCTAssertEqual(try reopened.allRecords(), [record])
    }

    func testAbandonedRoundDoesNotCreateCompletedRecord() {
        let clock = RecordIntegrationClock()
        var round = LetterSpeedRound(clock: clock, seed: 1)
        round.start()
        clock.now = 3
        round.refresh()
        round.abandon()
        XCTAssertNil(round.completedRecord)
    }
    @MainActor
    func testSaveFailureIsReported() throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let blocked = dir.appendingPathComponent("not-a-directory")
        try Data().write(to: blocked)
        let manager = RecordsManager(databaseURL: blocked.appendingPathComponent("records.sqlite"))
        let configuration = RecordConfiguration(game: .letterSpeed, difficulty: .classic,
            mode: "ten-round", rulesVersion: 1, durationLimit: 30)
        let record = SessionRecord(configuration: configuration, outcome: .completed, score: 10)
        XCTAssertNotNil(manager.loadError)
        XCTAssertFalse(manager.save(record))
        XCTAssertNotNil(manager.loadError)
        XCTAssertTrue(manager.records.isEmpty)
    }

}
