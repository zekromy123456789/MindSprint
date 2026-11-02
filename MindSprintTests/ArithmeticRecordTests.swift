import XCTest
@testable import MindSprint

private final class ArithmeticRecordClock: SessionClock { var now: TimeInterval = 0 }

final class ArithmeticRecordTests: XCTestCase {
    func testArithmeticCompletionIsStableAndSavedOnce() throws {
        let clock = ArithmeticRecordClock()
        var round = ArithmeticRound(difficulty: .easy, clock: clock, seed: 5)
        XCTAssertNil(round.completedRecord)
        round.start(); clock.now = 3; round.refresh()
        XCTAssertTrue(round.accept(String(round.question!.answer), forQuestion: round.questionID))
        clock.now = 123; round.refresh()
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .arithmetic)
        XCTAssertEqual(record.configuration.difficulty, .easy)
        XCTAssertEqual(record.configuration.durationLimit, 120)
        XCTAssertEqual(record.score, 1)
        XCTAssertEqual(record.correct, 1)
        XCTAssertNil(record.incorrect)
        XCTAssertNil(record.responseTimes)
        XCTAssertEqual(round.completedRecord, record)
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("records.sqlite")
        do {
            let store = try RecordStore(url: url)
            XCTAssertTrue(try store.insertOnce(record))
            XCTAssertFalse(try store.insertOnce(record))
        }
        XCTAssertEqual(try RecordStore(url: url).allRecords(), [record])
    }

    func testProRecordIsSeparateAndAbandonedIsNotCompleted() throws {
        let clock = ArithmeticRecordClock()
        var round = ArithmeticProRound(difficulty: .hard, clock: clock, seed: 5)
        round.start(); clock.now = 3; round.refresh()
        XCTAssertTrue(round.accept(String(round.question!.answer), forQuestion: round.questionID))
        clock.now = 123; round.refresh()
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .arithmeticPro)
        XCTAssertEqual(record.configuration.difficulty, .hard)
        XCTAssertEqual(record.score, 1)
        let arithmetic = RecordConfiguration(game: .arithmetic, difficulty: .hard, mode: "timed", rulesVersion: 1, durationLimit: 120)
        XCTAssertNil(RecordSummary(records: [record], configuration: arithmetic).bestScore)
        let clock2 = ArithmeticRecordClock()
        var abandoned = ArithmeticProRound(difficulty: .hard, clock: clock2, seed: 5)
        abandoned.start(); clock2.now = 3; abandoned.refresh(); abandoned.abandon()
        XCTAssertNil(abandoned.completedRecord)
    }
}
