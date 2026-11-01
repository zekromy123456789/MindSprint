import XCTest
@testable import MindSprint

private final class FlexibilityTestClock: SessionClock { var now: TimeInterval = 0 }

final class FlexibilityRoundTests: XCTestCase {
    func testComparisonIgnoresDistractingWordAndLeftColor() {
        for word in FlexibilityColor.allCases {
            for leftInk in FlexibilityColor.allCases {
                for rightWord in FlexibilityColor.allCases {
                    for rightInk in FlexibilityColor.allCases {
                        let question = FlexibilityQuestion(leftWord: word, leftColor: leftInk,
                                                           rightWord: rightWord, rightColor: rightInk)
                        XCTAssertEqual(question.isMatch, word == rightInk)
                    }
                }
            }
        }
    }

    func testSeededPromptsRepeatAndIncludeBothOutcomes() {
        var a = SeededRandomNumberGenerator(seed: 93)
        var b = SeededRandomNumberGenerator(seed: 93)
        var matches = 0
        for _ in 0..<10_000 {
            let q = FlexibilityGenerator().next(using: &a)
            XCTAssertEqual(q, FlexibilityGenerator().next(using: &b))
            if q.isMatch { matches += 1 }
        }
        // Broad deterministic check for the source's nominal half-match mechanism.
        XCTAssertTrue((4_700...5_300).contains(matches))
    }

    func testScoringProgressionAndStaleAnswer() {
        let clock = FlexibilityTestClock()
        var round = FlexibilityRound(clock: clock, seed: 18)
        round.start()
        XCTAssertFalse(round.answer(true, forQuestion: 0))
        clock.now = 3
        round.refresh()
        let token = round.questionID
        XCTAssertTrue(round.answer(round.question!.isMatch, forQuestion: token))
        XCTAssertEqual(round.score, 1)
        XCTAssertFalse(round.answer(true, forQuestion: token))
        let next = round.questionID
        XCTAssertTrue(round.answer(!round.question!.isMatch, forQuestion: next))
        XCTAssertEqual(round.score, 0)
        XCTAssertTrue(round.answer(!round.question!.isMatch, forQuestion: round.questionID))
        XCTAssertEqual(round.score, -1)
    }

    func testDeadlineAndBackgroundRefresh() {
        let clock = FlexibilityTestClock()
        var round = FlexibilityRound(clock: clock, seed: 8)
        round.start()
        clock.now = 62
        round.refresh()
        XCTAssertEqual(round.phase, .active)
        XCTAssertEqual(round.remaining, 1, accuracy: 0.0001)
        let token = round.questionID
        let answer = round.question!.isMatch
        clock.now = 63
        XCTAssertFalse(round.answer(answer, forQuestion: token))
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(round.score, 0)
        XCTAssertNil(round.question)

        var expired = FlexibilityRound(clock: clock, seed: 1)
        expired.start()
        clock.now = 200
        expired.refresh()
        XCTAssertEqual(expired.phase, .completed)
        XCTAssertNil(expired.question)
    }

    func testAbandonPreventsScoring() {
        let clock = FlexibilityTestClock()
        var round = FlexibilityRound(clock: clock, seed: 1)
        round.start()
        clock.now = 3
        round.refresh()
        let token = round.questionID
        round.abandon()
        XCTAssertEqual(round.phase, .abandoned)
        XCTAssertFalse(round.answer(true, forQuestion: token))
    }
}
