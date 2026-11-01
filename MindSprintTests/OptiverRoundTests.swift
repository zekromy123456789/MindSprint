import XCTest
@testable import MindSprint

private final class OptiverTestClock: SessionClock { var now: TimeInterval = 0 }

final class OptiverRoundTests: XCTestCase {
    func testSelectedDifficultyControlsGeneratedQuestions() {
        var round = OptiverRound(difficulty: .expert, clock: OptiverTestClock(), seed: 31)
        round.start()
        XCTAssertEqual(round.questions.count, 80)
        XCTAssertTrue(round.questions.allSatisfy { $0.operation == .division })
    }

    func testCorrectWrongAndStaleChoice() {
        let clock = OptiverTestClock()
        var round = OptiverRound(clock: clock, seed: 81)
        round.start()
        XCTAssertEqual(round.questions.count, 80)
        XCTAssertEqual(round.phase, .countdown)
        clock.now = 3
        round.refresh()
        let first = round.currentQuestion!
        XCTAssertTrue(round.choose(first.answer, forQuestion: 0))
        XCTAssertEqual(round.score, 1)
        XCTAssertFalse(round.choose(first.answer, forQuestion: 0))
        let second = round.currentQuestion!
        let wrong = second.choices.first { $0 != second.answer }!
        XCTAssertTrue(round.choose(wrong, forQuestion: 1))
        XCTAssertEqual(round.score, -1)
        XCTAssertEqual(round.responses[0], true)
        XCTAssertEqual(round.responses[1], false)
        XCTAssertNil(round.responses[2])
    }

    func testCompletesAfter80AndCannotScoreAgain() {
        let clock = OptiverTestClock()
        var round = OptiverRound(clock: clock, seed: 91)
        round.start()
        clock.now = 3
        round.refresh()
        for index in 0..<80 {
            XCTAssertTrue(round.choose(round.currentQuestion!.answer, forQuestion: index))
        }
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(round.score, 80)
        XCTAssertEqual(round.index, 80)
        XCTAssertNil(round.currentQuestion)
        XCTAssertFalse(round.choose(round.questions[79].answer, forQuestion: 79))
    }

    func testDelayedRefreshAndDeadlineRejectLateChoice() {
        let clock = OptiverTestClock()
        var round = OptiverRound(clock: clock, seed: 12)
        round.start()
        clock.now = 482
        round.refresh()
        XCTAssertEqual(round.phase, .active)
        XCTAssertEqual(round.remaining, 1, accuracy: 0.0001)
        let answer = round.currentQuestion!.answer
        clock.now = 483
        XCTAssertFalse(round.choose(answer, forQuestion: 0))
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(round.score, 0)
        XCTAssertNil(round.responses[0])
    }

    func testInvalidChoiceAndAbandonment() {
        let clock = OptiverTestClock()
        var round = OptiverRound(clock: clock, seed: 2)
        round.start()
        clock.now = 3
        round.refresh()
        XCTAssertFalse(round.choose(OptiverNumber(hundredths: 99_999_999), forQuestion: 0))
        XCTAssertEqual(round.index, 0)
        round.abandon()
        XCTAssertEqual(round.phase, .abandoned)
        XCTAssertFalse(round.choose(round.questions[0].answer, forQuestion: 0))
    }
}
