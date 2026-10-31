import XCTest
@testable import MindSprint

private final class ArithmeticTestClock: SessionClock {
    var now: TimeInterval = 0
}

final class ArithmeticRoundTests: XCTestCase {
    func testCountdownAndCorrectAnswersAdvanceOnlyOnce() {
        let clock = ArithmeticTestClock()
        var round = ArithmeticRound(difficulty: .classic, clock: clock, seed: 7)
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
        let clock = ArithmeticTestClock()
        var round = ArithmeticRound(difficulty: .normal, clock: clock, seed: 4)
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
        let clock = ArithmeticTestClock()
        var round = ArithmeticRound(difficulty: .hard, clock: clock, seed: 1)
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
        let clock = ArithmeticTestClock()
        var waiting = ArithmeticRound(difficulty: .easy, clock: clock, seed: 1)
        waiting.start()
        waiting.abandon()
        clock.now = 5
        waiting.refresh()
        XCTAssertEqual(waiting.phase, .abandoned)
        XCTAssertNil(waiting.question)

        var active = ArithmeticRound(difficulty: .expert, clock: clock, seed: 2)
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
