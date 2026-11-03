import XCTest
@testable import MindSprint

private final class RemainingRecordClock: SessionClock { var now: TimeInterval = 0 }

final class RemainingGameRecordTests: XCTestCase {
    func testMemoryCountsAttemptsAndPersistsOnce() throws {
        let clock = RemainingRecordClock()
        var round = MemoryRound(clock: clock, seed: 11)
        for stage in 0..<3 {
            XCTAssertEqual(round.stage.rawValue, stage)
            round.beginStage()
            clock.now += MemoryRound.countdownDuration; round.refresh()
            if stage == 0 {
                clock.now += MemoryRound.leadIn + Double(round.length); round.refresh()
                XCTAssertTrue(round.submit(round.stage.answer(for: round.digits), forQuestion: round.questionID))
            }
            for _ in 0..<2 {
                clock.now += MemoryRound.leadIn + Double(round.length); round.refresh()
                XCTAssertTrue(round.submit("invalid", forQuestion: round.questionID))
            }
        }
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .memory)
        XCTAssertEqual(record.configuration.mode, "three-stage")
        XCTAssertNil(record.configuration.durationLimit)
        XCTAssertEqual(record.score, 1)
        XCTAssertEqual(record.correct, 1)
        XCTAssertEqual(record.incorrect, 6)
        XCTAssertEqual(record.responseTimes, [0, 0, 0, 0, 0, 0, 0])
        try assertPersistsOnce(record)
    }

    func testRiskRecordsCollectedScoreWithoutInventingAccuracy() throws {
        let clock = RemainingRecordClock()
        var round = RiskRound(clock: clock, seed: 11)
        round.start(); clock.now = 3; round.refresh()
        for _ in 0..<20 { XCTAssertTrue(round.collect(forRound: round.roundID)) }
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .risk)
        XCTAssertEqual(record.configuration.mode, "20-balloon")
        XCTAssertEqual(record.score, 20)
        XCTAssertNil(record.correct)
        XCTAssertNil(record.incorrect)
        try assertPersistsOnce(record)
    }

    func testFlexibilityRecordsActualCorrectAndWrongAnswers() throws {
        let clock = RemainingRecordClock()
        var round = FlexibilityRound(clock: clock, seed: 11)
        round.start(); clock.now = 3; round.refresh()
        XCTAssertTrue(round.answer(round.question!.isMatch, forQuestion: round.questionID))
        XCTAssertTrue(round.answer(!round.question!.isMatch, forQuestion: round.questionID))
        clock.now = 63; round.refresh()
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .flexibility)
        XCTAssertEqual(record.configuration.durationLimit, 60)
        XCTAssertEqual(record.score, 0)
        XCTAssertEqual(record.correct, 1)
        XCTAssertEqual(record.incorrect, 1)
        XCTAssertEqual(round.completedRecord, record)
        try assertPersistsOnce(record)
    }

    func testAbandonedGamesDoNotCreateCompletedRecords() {
        let clock = RemainingRecordClock()
        var memory = MemoryRound(clock: clock, seed: 1); memory.abandon()
        var risk = RiskRound(clock: clock, seed: 1); risk.abandon()
        var flexibility = FlexibilityRound(clock: clock, seed: 1); flexibility.abandon()
        XCTAssertNil(memory.completedRecord)
        XCTAssertNil(risk.completedRecord)
        XCTAssertNil(flexibility.completedRecord)
    }

    private func assertPersistsOnce(_ record: SessionRecord) throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let url = dir.appendingPathComponent("records.sqlite")
        do {
            let store = try RecordStore(url: url)
            XCTAssertTrue(try store.insertOnce(record))
            XCTAssertFalse(try store.insertOnce(record))
        }
        XCTAssertEqual(try RecordStore(url: url).allRecords(), [record])
    }
}
