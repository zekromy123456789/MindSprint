import XCTest
@testable import MindSprint

private final class SequenceOptiverRecordClock: SessionClock { var now: TimeInterval = 0 }

final class SequenceOptiverRecordTests: XCTestCase {
    func testSequenceCompletionRecordsCorrectConfigurationAndPersistsOnce() throws {
        let clock = SequenceOptiverRecordClock()
        var round = SequenceRound(difficulty: .expert, clock: clock, seed: 9)
        XCTAssertNil(round.completedRecord)
        round.start(); clock.now = 3; round.refresh()
        XCTAssertTrue(round.accept(String(round.question!.answer), forQuestion: round.questionID))
        clock.now = 123; round.refresh()
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .sequence)
        XCTAssertEqual(record.configuration.difficulty, .expert)
        XCTAssertEqual(record.score, 1)
        XCTAssertEqual(record.correct, 1)
        XCTAssertNil(record.incorrect)
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let url = dir.appendingPathComponent("records.sqlite")
        do { let store = try RecordStore(url: url); XCTAssertTrue(try store.insertOnce(record)); XCTAssertFalse(try store.insertOnce(record)) }
        XCTAssertEqual(try RecordStore(url: url).allRecords(), [record])
    }

    func testOptiverCountsOnlyAnsweredAndSeparatesConfiguration() throws {
        let clock = SequenceOptiverRecordClock()
        var round = OptiverRound(difficulty: .easy, clock: clock, seed: 81)
        round.start(); clock.now = 3; round.refresh()
        let first = round.currentQuestion!
        XCTAssertTrue(round.choose(first.answer, forQuestion: 0))
        let second = round.currentQuestion!
        XCTAssertTrue(round.choose(second.choices.first { $0 != second.answer }!, forQuestion: 1))
        clock.now = 483; round.refresh()
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.configuration.game, .optiver)
        XCTAssertEqual(record.configuration.difficulty, .easy)
        XCTAssertEqual(record.configuration.durationLimit, 480)
        XCTAssertEqual(record.score, -1)
        XCTAssertEqual(record.correct, 1)
        XCTAssertEqual(record.incorrect, 1)
        XCTAssertNil(record.responseTimes)
        XCTAssertEqual(round.completedRecord, record)
        let sequence = RecordConfiguration(game: .sequence, difficulty: .easy, mode: "timed", rulesVersion: 1, durationLimit: 120)
        XCTAssertNil(RecordSummary(records: [record], configuration: sequence).bestScore)
    }

    func testOptiverCompletingAllQuestionsCreatesRecord() throws {
        let clock = SequenceOptiverRecordClock()
        var round = OptiverRound(clock: clock, seed: 91)
        round.start(); clock.now = 3; round.refresh()
        for index in 0..<80 {
            XCTAssertTrue(round.choose(round.currentQuestion!.answer, forQuestion: index))
        }
        let record = try XCTUnwrap(round.completedRecord)
        XCTAssertEqual(record.score, 80)
        XCTAssertEqual(record.correct, 80)
        XCTAssertEqual(record.incorrect, 0)
    }

    func testAbandonedSessionsDoNotCreateCompletedRecords() {
        let clock = SequenceOptiverRecordClock()
        var sequence = SequenceRound(clock: clock, seed: 5)
        sequence.start(); clock.now = 3; sequence.refresh(); sequence.abandon()
        XCTAssertNil(sequence.completedRecord)
        let clock2 = SequenceOptiverRecordClock()
        var optiver = OptiverRound(clock: clock2, seed: 5)
        optiver.start(); clock2.now = 3; optiver.refresh(); optiver.abandon()
        XCTAssertNil(optiver.completedRecord)
    }
}
