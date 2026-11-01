import XCTest
@testable import MindSprint

private final class SequenceRoundTestClock: SessionClock {
    var now: TimeInterval = 0
}

final class SequenceRoundTests: XCTestCase {
    func testSelectedDifficultyDrivesRound() {
        let clock = SequenceRoundTestClock()
        var round = SequenceRound(difficulty: .expert, clock: clock, seed: 17)
        var random = SeededRandomNumberGenerator(seed: 17)
        let expected = SequenceGenerator(difficulty: .expert).next(using: &random)
        round.start()
        clock.now = 3
        round.refresh()
        XCTAssertEqual(round.question, expected)
        XCTAssertEqual(round.question?.family, .quadratic)
    }

    func testCountdownAndCorrectAnswersAdvanceOnlyOnce() {
        let clock = SequenceRoundTestClock()
        var round = SequenceRound(clock: clock, seed: 7)
        round.start()
        clock.now = 2
        round.refresh()
        XCTAssertEqual(round.phase, .countdown)
        XCTAssertEqual(round.countdownRemaining, 1)
        XCTAssertFalse(round.accept("1", forQuestion: 0))
        clock.now = 3
        round.refresh()
        XCTAssertEqual(round.phase, .active)
        let id = round.questionID
        let answer = String(round.question!.answer)
        XCTAssertFalse(round.accept(answer + "x", forQuestion: id))
        XCTAssertEqual(round.score, 0)
        XCTAssertTrue(round.accept(answer, forQuestion: id))
        XCTAssertEqual(round.score, 1)
        XCTAssertEqual(round.questionID, id + 1)
        XCTAssertFalse(round.accept(answer, forQuestion: id))
        XCTAssertEqual(round.score, 1)
    }

    func testDelayedRefreshUsesCountdownDeadlineAndRejectsLateAnswer() {
        let clock = SequenceRoundTestClock()
        var round = SequenceRound(clock: clock, seed: 4)
        round.start()
        clock.now = 100
        round.refresh()
        XCTAssertEqual(round.phase, .active)
        XCTAssertEqual(round.remaining, 23, accuracy: 0.0001)
        let id = round.questionID
        let lastQuestion = round.question
        let answer = String(round.question!.answer)
        clock.now = 123
        XCTAssertFalse(round.accept(answer, forQuestion: id))
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(round.score, 0)
        XCTAssertNil(round.question)
        XCTAssertEqual(round.lastQuestion, lastQuestion)
    }

    func testRoundCanExpireWhileAppIsInactiveAndCannotRestart() {
        let clock = SequenceRoundTestClock()
        var round = SequenceRound(clock: clock, seed: 1)
        round.start()
        clock.now = 500
        round.refresh()
        XCTAssertEqual(round.phase, .completed)
        XCTAssertNil(round.question)
        round.start()
        round.abandon()
        XCTAssertEqual(round.phase, .completed)
    }

    func testAbandonStopsCountdownAndActiveRound() {
        let clock = SequenceRoundTestClock()
        var waiting = SequenceRound(clock: clock, seed: 1)
        waiting.start()
        waiting.abandon()
        clock.now = 5
        waiting.refresh()
        XCTAssertEqual(waiting.phase, .abandoned)
        XCTAssertNil(waiting.question)

        var active = SequenceRound(clock: clock, seed: 2)
        active.start()
        clock.now = 8
        active.refresh()
        let id = active.questionID
        let answer = String(active.question!.answer)
        active.abandon()
        XCTAssertFalse(active.accept(answer, forQuestion: id))
        XCTAssertEqual(active.phase, .abandoned)
        XCTAssertEqual(active.score, 0)
    }
}
