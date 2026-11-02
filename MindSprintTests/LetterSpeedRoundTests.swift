import XCTest
@testable import MindSprint

private final class LetterSpeedTestClock: SessionClock { var now: TimeInterval = 0 }

final class LetterSpeedRoundTests: XCTestCase {
    func testTimeBasedScoringAndFreshTimer() {
        let clock = LetterSpeedTestClock()
        var round = LetterSpeedRound(clock: clock, seed: 7)
        round.start()
        XCTAssertFalse(round.choose(0, forQuestion: 0))
        clock.now = 3
        round.refresh()
        let token = round.questionID
        let answer = round.question!.correctIndex
        clock.now = 7.9
        XCTAssertTrue(round.choose(answer, forQuestion: token))
        XCTAssertEqual(round.score, 26)
        XCTAssertEqual(round.results[0].points, 26)
        XCTAssertEqual(round.results[0].selectedIndex, answer)
        XCTAssertEqual(round.remaining, 30, accuracy: 0.0001)
        XCTAssertEqual(round.roundNumber, 2)
        XCTAssertFalse(round.choose(answer, forQuestion: token))

        let next = round.question!
        let wrong = (next.correctIndex + 1) % 4
        XCTAssertTrue(round.choose(wrong, forQuestion: round.questionID))
        XCTAssertEqual(round.score, 26)
        XCTAssertEqual(round.results[1].points, 0)
        XCTAssertFalse(round.results[1].timedOut)
    }

    func testDeadlineRejectsLateTapAndStartsOnlyOneNewRound() {
        let clock = LetterSpeedTestClock()
        var round = LetterSpeedRound(clock: clock, seed: 9)
        round.start()
        clock.now = 3
        round.refresh()
        let token = round.questionID
        let answer = round.question!.correctIndex
        clock.now = 33
        XCTAssertFalse(round.choose(answer, forQuestion: token))
        XCTAssertEqual(round.results.count, 1)
        XCTAssertTrue(round.results[0].timedOut)
        XCTAssertNil(round.results[0].selectedIndex)
        XCTAssertEqual(round.remaining, 30, accuracy: 0.0001)
        clock.now = 500
        round.refresh()
        XCTAssertEqual(round.results.count, 2)
        XCTAssertEqual(round.remaining, 30, accuracy: 0.0001)
    }

    func testTenImmediateCorrectAnswersCompleteAt300() {
        let clock = LetterSpeedTestClock()
        var round = LetterSpeedRound(clock: clock, seed: 1)
        round.start()
        clock.now = 3
        round.refresh()
        for index in 1...10 {
            XCTAssertEqual(round.roundNumber, index)
            XCTAssertTrue(round.choose(round.question!.correctIndex, forQuestion: round.questionID))
        }
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(round.score, 300)
        XCTAssertEqual(round.results.count, 10)
        XCTAssertNil(round.question)
        XCTAssertFalse(round.choose(0, forQuestion: round.questionID))
    }

    func testLastMomentAndDelayedCountdown() {
        let clock = LetterSpeedTestClock()
        var round = LetterSpeedRound(clock: clock, seed: 22)
        round.start()
        clock.now = 100
        round.refresh()
        XCTAssertEqual(round.remaining, 30, accuracy: 0.0001)
        let token = round.questionID
        let answer = round.question!.correctIndex
        clock.now = 129.999
        XCTAssertTrue(round.choose(answer, forQuestion: token))
        XCTAssertEqual(round.score, 1)
        round.abandon()
        XCTAssertEqual(round.phase, .abandoned)
        XCTAssertFalse(round.choose(0, forQuestion: round.questionID))
    }

    func testInvalidChoiceDoesNotAdvance() {
        let clock = LetterSpeedTestClock()
        var round = LetterSpeedRound(clock: clock, seed: 4)
        round.start()
        clock.now = 3
        round.refresh()
        XCTAssertFalse(round.choose(-1, forQuestion: round.questionID))
        XCTAssertFalse(round.choose(4, forQuestion: round.questionID))
        XCTAssertTrue(round.results.isEmpty)
    }
    func testSelectedDifficultyAppliesThroughoutRound() {
        let clock = LetterSpeedTestClock()
        var round = LetterSpeedRound(difficulty: .expert, clock: clock, seed: 55)
        round.start()
        clock.now = 3
        round.refresh()
        for _ in 0..<10 {
            XCTAssertEqual(round.difficulty, .expert)
            for choice in round.question!.choices {
                for row in choice.rows {
                    if let a = row.first { XCTAssertTrue((14...26).contains(a)) }
                    if let b = row.second { XCTAssertTrue((14...26).contains(b)) }
                }
            }
            XCTAssertTrue(round.choose(round.question!.correctIndex, forQuestion: round.questionID))
        }
        XCTAssertEqual(round.phase, .completed)
    }

}
