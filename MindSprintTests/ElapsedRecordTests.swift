import XCTest
@testable import MindSprint

private final class ElapsedClock: SessionClock { var now: TimeInterval = 0 }

final class ElapsedRecordTests: XCTestCase {
    func testAllStartedGamesRecordTimeUntilAbandonment() throws {
        let clock = ElapsedClock()
        var a = ArithmeticRound(difficulty: .easy, clock: clock, seed: 1)
        var p = ArithmeticProRound(clock: clock, seed: 1)
        var s = SequenceRound(clock: clock, seed: 1)
        var o = OptiverRound(clock: clock, seed: 1)
        var l = LetterSpeedRound(clock: clock, seed: 1)
        var m = MemoryRound(clock: clock, seed: 1)
        var r = RiskRound(clock: clock, seed: 1)
        var f = FlexibilityRound(clock: clock, seed: 1)
        a.start(); p.start(); s.start(); o.start(); l.start(); m.beginStage(); r.start(); f.start()
        clock.now = 3
        a.refresh(); p.refresh(); s.refresh(); o.refresh(); l.refresh(); m.refresh(); r.refresh(); f.refresh()
        clock.now = 13
        a.abandon(); p.abandon(); s.abandon(); o.abandon(); l.abandon(); m.abandon(); r.abandon(); f.abandon()
        let records = try [XCTUnwrap(a.terminalRecord), XCTUnwrap(p.terminalRecord), XCTUnwrap(s.terminalRecord),
                           XCTUnwrap(o.terminalRecord), XCTUnwrap(l.terminalRecord), XCTUnwrap(m.terminalRecord),
                           XCTUnwrap(r.terminalRecord), XCTUnwrap(f.terminalRecord)]
        XCTAssertEqual(records.map(\.elapsed), Array(repeating: Optional(10.0), count: 8))
        clock.now = 100
        XCTAssertEqual(try XCTUnwrap(a.terminalRecord).elapsed, 10)
        XCTAssertEqual(try XCTUnwrap(m.terminalRecord).elapsed, 10)
    }

    func testTimedExpiryAndEarlyCompletionUseActualEnd() throws {
        let clock = ElapsedClock()
        var arithmetic = ArithmeticRound(difficulty: .easy, clock: clock, seed: 1)
        arithmetic.start(); clock.now = 3; arithmetic.refresh()
        clock.now = 150; arithmetic.refresh()
        XCTAssertEqual(try XCTUnwrap(arithmetic.completedRecord).elapsed, 120)
        let other = ElapsedClock()
        var optiver = OptiverRound(clock: other, seed: 2)
        optiver.start(); other.now = 3; optiver.refresh()
        other.now = 13
        for index in 0..<80 { XCTAssertTrue(optiver.choose(optiver.currentQuestion!.answer, forQuestion: index)) }
        other.now = 40
        XCTAssertEqual(try XCTUnwrap(optiver.completedRecord).elapsed, 10)
    }

    func testNonTimedCompletionAndPreplayExit() throws {
        let clock = ElapsedClock()
        var risk = RiskRound(clock: clock, seed: 3)
        risk.start(); clock.now = 3; risk.refresh(); clock.now = 15
        for _ in 0..<20 { XCTAssertTrue(risk.collect(forRound: risk.roundID)) }
        clock.now = 30
        XCTAssertEqual(try XCTUnwrap(risk.completedRecord).elapsed, 12)
        let second = ElapsedClock()
        var letters = LetterSpeedRound(clock: second, seed: 1)
        letters.start(); letters.abandon()
        XCTAssertNil(letters.terminalRecord)
    }
}
