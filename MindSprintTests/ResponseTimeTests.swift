import XCTest
@testable import MindSprint

private final class ResponseTimeClock: SessionClock { var now: TimeInterval = 0 }

final class ResponseTimeTests: XCTestCase {
    func testArithmeticAndProMeasureOnlyAcceptedAnswers() throws {
        let clock = ResponseTimeClock()
        var round = ArithmeticRound(difficulty: .easy, clock: clock, seed: 4)
        round.start(); clock.now = 3; round.refresh()
        let id = round.questionID
        clock.now = 4
        XCTAssertFalse(round.accept("invalid", forQuestion: id))
        clock.now = 5.5
        XCTAssertTrue(round.accept(String(round.question!.answer), forQuestion: id))
        XCTAssertFalse(round.accept("0", forQuestion: id))
        round.abandon()
        XCTAssertEqual(try XCTUnwrap(round.terminalRecord).responseTimes, [2.5])

        let proClock = ResponseTimeClock()
        var pro = ArithmeticProRound(clock: proClock, seed: 7)
        pro.start(); proClock.now = 3; pro.refresh()
        proClock.now = 4.25
        XCTAssertTrue(pro.accept(String(pro.question!.answer), forQuestion: pro.questionID))
        proClock.now = 123; pro.refresh()
        XCTAssertEqual(try XCTUnwrap(pro.completedRecord).responseTimes, [1.25])
    }

    func testSequenceAndOptiverMeasureAnswersAndRejectStaleActions() throws {
        let clock = ResponseTimeClock()
        var sequence = SequenceRound(clock: clock, seed: 5)
        sequence.start(); clock.now = 3; sequence.refresh()
        clock.now = 6
        XCTAssertTrue(sequence.accept(String(sequence.question!.answer), forQuestion: sequence.questionID))
        sequence.abandon()
        XCTAssertEqual(try XCTUnwrap(sequence.terminalRecord).responseTimes, [3])

        let optiverClock = ResponseTimeClock()
        var optiver = OptiverRound(clock: optiverClock, seed: 8)
        optiver.start(); optiverClock.now = 5; optiver.refresh()
        let first = optiver.currentQuestion!
        optiverClock.now = 6
        XCTAssertTrue(optiver.choose(first.answer, forQuestion: 0))
        XCTAssertFalse(optiver.choose(first.answer, forQuestion: 0))
        let second = optiver.currentQuestion!
        optiverClock.now = 8
        XCTAssertTrue(optiver.choose(second.choices.first { $0 != second.answer }!, forQuestion: 1))
        optiver.abandon()
        XCTAssertEqual(try XCTUnwrap(optiver.terminalRecord).responseTimes, [1, 2])
    }

    func testLetterSpeedExcludesTimeoutAndFlexibilityIncludesWrongAnswer() throws {
        let clock = ResponseTimeClock()
        var letters = LetterSpeedRound(clock: clock, seed: 5)
        letters.start(); clock.now = 3; letters.refresh()
        clock.now = 5
        XCTAssertTrue(letters.choose(letters.question!.correctIndex, forQuestion: letters.questionID))
        clock.now = 35; letters.refresh()
        letters.abandon()
        XCTAssertEqual(try XCTUnwrap(letters.terminalRecord).responseTimes, [2])

        let flexClock = ResponseTimeClock()
        var flex = FlexibilityRound(clock: flexClock, seed: 5)
        flex.start(); flexClock.now = 3; flex.refresh()
        flexClock.now = 4.5
        XCTAssertTrue(flex.answer(!flex.question!.isMatch, forQuestion: flex.questionID))
        flexClock.now = 63; flex.refresh()
        XCTAssertEqual(try XCTUnwrap(flex.completedRecord).responseTimes, [1.5])
    }
    func testMemoryMeasuresRecallAndExcludesInterruptedRecall() throws {
        let clock = ResponseTimeClock()
        var memory = MemoryRound(clock: clock, seed: 6)
        memory.beginStage(); clock.now = 3; memory.refresh()
        clock.now = 7; memory.refresh()
        clock.now = 9
        XCTAssertTrue(memory.submit(memory.stage.answer(for: memory.digits), forQuestion: memory.questionID))
        clock.now = 14; memory.refresh()
        memory.suspend(); clock.now = 30; memory.resume()
        XCTAssertTrue(memory.submit("wrong", forQuestion: memory.questionID))
        memory.abandon()
        XCTAssertEqual(try XCTUnwrap(memory.terminalRecord).responseTimes, [2])
    }

}
