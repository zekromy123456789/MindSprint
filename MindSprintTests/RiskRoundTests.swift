import XCTest
@testable import MindSprint

private final class RiskTestClock: SessionClock { var now: TimeInterval = 0 }

final class RiskRoundTests: XCTestCase {
    func testProbabilitySetupAndReferenceGreenFallthrough() {
        for seed in 0..<100 {
            var round = RiskRound(clock: RiskTestClock(), seed: UInt64(seed))
            round.start()
            let values = round.probabilities.values.sorted()
            XCTAssertEqual(values.count, 4)
            XCTAssertTrue((5...10).contains(values[0]))
            XCTAssertTrue((8...12).contains(values[1]))
            XCTAssertTrue((8...12).contains(values[2]))
            XCTAssertTrue((15...20).contains(values[3]))
            XCTAssertEqual(round.effectiveProbability(for: .green), round.probabilities[.red])
            XCTAssertEqual(round.effectiveProbability(for: .blue), round.probabilities[.blue])
            XCTAssertEqual(round.effectiveProbability(for: .purple), round.probabilities[.purple])
        }
    }

    func testPumpCollectPopAndStaleActions() {
        let clock = RiskTestClock()
        var round = RiskRound(clock: clock, seed: 11)
        round.start()
        let first = round.roundID
        XCTAssertFalse(round.collect(forRound: first))
        clock.now = 3
        round.refresh()
        XCTAssertEqual(round.phase, .active)
        XCTAssertEqual(round.unbanked, 1)
        XCTAssertTrue(round.pump(forRound: first, roll: 1))
        XCTAssertEqual(round.unbanked, 2)
        XCTAssertTrue(round.collect(forRound: first))
        XCTAssertEqual(round.score, 2)
        XCTAssertEqual(round.lastOutcome, .collected(2))
        XCTAssertEqual(round.roundNumber, 2)
        XCTAssertFalse(round.collect(forRound: first))
        XCTAssertFalse(round.pump(forRound: first, roll: 1))
        let second = round.roundID
        let threshold = Double(round.effectiveProbability(for: round.color)!) / 100
        XCTAssertTrue(round.pump(forRound: second, roll: threshold))
        XCTAssertEqual(round.lastOutcome, .popped)
        XCTAssertEqual(round.score, 2)
        XCTAssertEqual(round.unbanked, 1)
        XCTAssertEqual(round.roundNumber, 3)
    }

    func testTwentyRoundsCompleteAndRejectFurtherActions() {
        let clock = RiskTestClock()
        var round = RiskRound(clock: clock, seed: 8)
        round.start()
        clock.now = 3
        round.refresh()
        for number in 1...20 {
            XCTAssertEqual(round.roundNumber, number)
            XCTAssertTrue(round.collect(forRound: round.roundID))
        }
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(round.score, 20)
        XCTAssertFalse(round.collect(forRound: round.roundID))
        XCTAssertFalse(round.pump(forRound: round.roundID, roll: 1))
    }

    func testInvalidRollAbandonmentAndSeedRepeatability() {
        let clock = RiskTestClock()
        var a = RiskRound(clock: clock, seed: 27)
        var b = RiskRound(clock: clock, seed: 27)
        a.start(); b.start()
        XCTAssertEqual(a.probabilities, b.probabilities)
        XCTAssertEqual(a.color, b.color)
        clock.now = 3
        a.refresh(); b.refresh()
        XCTAssertFalse(a.pump(forRound: a.roundID, roll: .nan))
        XCTAssertEqual(a.unbanked, 1)
        for _ in 0..<10 {
            XCTAssertEqual(a.color, b.color)
            XCTAssertTrue(a.collect(forRound: a.roundID))
            XCTAssertTrue(b.collect(forRound: b.roundID))
        }
        a.abandon()
        XCTAssertEqual(a.phase, .abandoned)
        XCTAssertFalse(a.collect(forRound: a.roundID))
    }
}
