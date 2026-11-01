import XCTest
@testable import MindSprint

private final class MemoryTestClock: SessionClock { var now: TimeInterval = 0 }

final class MemoryRoundTests: XCTestCase {
    func testAnswerOrdersPreserveZerosAndDuplicates() {
        let digits = [0, 2, 0, 1]
        XCTAssertEqual(MemoryStage.original.answer(for: digits), "0201")
        XCTAssertEqual(MemoryStage.reversed.answer(for: digits), "1020")
        XCTAssertEqual(MemoryStage.ascending.answer(for: digits), "0012")
    }

    func testPresentationGatesSubmissionAndCorrectAnswerAdvances() {
        let clock = MemoryTestClock()
        var round = MemoryRound(clock: clock, seed: 11)
        round.beginStage()
        XCTAssertEqual(round.phase, .countdown)
        let token = round.questionID
        let answer = round.stage.answer(for: round.digits)
        XCTAssertFalse(round.submit(answer, forQuestion: token))
        clock.now = 3
        round.refresh()
        XCTAssertNil(round.visibleDigit)
        clock.now = 4
        round.refresh()
        XCTAssertEqual(round.visibleDigit, round.digits[0])
        clock.now = 5
        round.refresh()
        XCTAssertEqual(round.visibleIndex, 1)
        XCTAssertEqual(round.visibleDigit, round.digits[1])
        clock.now = 6
        round.refresh()
        XCTAssertEqual(round.visibleIndex, 2)
        XCTAssertEqual(round.visibleDigit, round.digits[2])
        clock.now = 6.99
        XCTAssertFalse(round.submit(answer, forQuestion: token))
        clock.now = 7
        round.refresh()
        XCTAssertEqual(round.phase, .recall)
        XCTAssertNil(round.visibleIndex)
        XCTAssertTrue(round.submit(answer, forQuestion: token))
        XCTAssertEqual(round.score, 1)
        XCTAssertEqual(round.length, 4)
        XCTAssertEqual(round.attempt, 1)
        XCTAssertEqual(round.phase, .presenting)
        XCTAssertFalse(round.submit(answer, forQuestion: token))
    }

    func testTwoFailuresAdvanceStagesAndFinishWithoutPenalty() {
        let clock = MemoryTestClock()
        var round = MemoryRound(clock: clock, seed: 7)
        for stage in MemoryStage.allCases {
            XCTAssertEqual(round.stage, stage)
            XCTAssertEqual(round.phase, .instructions)
            round.beginStage()
            clock.now += 3
            round.refresh()
            for attempt in 1...2 {
                XCTAssertEqual(round.attempt, attempt)
                clock.now += 4
                round.refresh()
                let token = round.questionID
                let correct = stage.answer(for: round.digits)
                let wrong = (correct.first == "9" ? "8" : "9") + String(correct.dropFirst())
                XCTAssertTrue(round.submit(wrong, forQuestion: token))
                XCTAssertEqual(round.score, 0)
                if attempt == 1 {
                    XCTAssertEqual(round.length, 3)
                    XCTAssertEqual(round.phase, .presenting)
                    XCTAssertEqual(round.questionID, token + 1)
                }
            }
        }
        XCTAssertEqual(round.phase, .completed)
        XCTAssertFalse(round.submit("123", forQuestion: round.questionID))
    }

    func testBackgroundRestartsPresentationAndCountdown() {
        let clock = MemoryTestClock()
        var round = MemoryRound(clock: clock, seed: 4)
        round.beginStage()
        clock.now = 2
        round.suspend()
        clock.now = 100
        round.refresh()
        XCTAssertEqual(round.phase, .countdown)
        round.resume()
        XCTAssertEqual(round.countdownRemaining, 3)
        clock.now = 103
        round.refresh()
        clock.now = 105
        round.suspend()
        clock.now = 200
        round.refresh()
        XCTAssertFalse(round.submit(round.stage.answer(for: round.digits), forQuestion: round.questionID))
        round.resume()
        XCTAssertNil(round.visibleDigit)
        clock.now = 201
        round.refresh()
        XCTAssertEqual(round.visibleDigit, round.digits[0])
        clock.now = 204
        round.refresh()
        XCTAssertEqual(round.phase, .recall)
        round.abandon()
        XCTAssertEqual(round.phase, .abandoned)
    }

    func testSeededDigitsAreRepeatable() {
        var a = MemoryRound(clock: MemoryTestClock(), seed: 33)
        var b = MemoryRound(clock: MemoryTestClock(), seed: 33)
        a.beginStage(); b.beginStage()
        XCTAssertEqual(a.digits, b.digits)
        XCTAssertEqual(a.digits.count, 3)
        XCTAssertTrue(a.digits.allSatisfy { (0...9).contains($0) })
    }
}
