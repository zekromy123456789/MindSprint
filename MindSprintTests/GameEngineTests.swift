import XCTest
@testable import MindSprint

private final class ManualClock: SessionClock {
    var now: TimeInterval = 0
}

final class GameEngineTests: XCTestCase {
    private func config(_ duration: TimeInterval? = 10) -> SessionConfiguration {
        SessionConfiguration(game: .arithmetic, difficulty: .classic, duration: duration)
    }

    func testSeededGeneratorIsRepeatableAndMatchesKnownVector() {
        var first = SeededRandomNumberGenerator(seed: 0)
        var second = SeededRandomNumberGenerator(seed: 0)
        XCTAssertEqual(first.next(), 0xE220A8397B1DCDAF)
        XCTAssertEqual(second.next(), 0xE220A8397B1DCDAF)
        XCTAssertEqual(first.next(), second.next())
        var other = SeededRandomNumberGenerator(seed: 1)
        XCTAssertNotEqual(other.next(), 0xE220A8397B1DCDAF)
    }

    func testDeadlineRejectsScoringEvenWithoutRefreshCallback() {
        let clock = ManualClock()
        var session = GameSession(configuration: config(), clock: clock)
        XCTAssertTrue(session.start())
        clock.now = 9.5
        XCTAssertEqual(session.remaining!, 0.5, accuracy: 0.0001)
        XCTAssertTrue(session.award(1))
        clock.now = 10
        XCTAssertFalse(session.award(5))
        XCTAssertEqual(session.phase, .completed)
        XCTAssertEqual(session.score, 1)
        XCTAssertEqual(session.remaining, 0)
    }

    func testUntimedSessionAndTerminalTransitions() {
        let clock = ManualClock()
        var session = GameSession(configuration: config(nil), clock: clock)
        XCTAssertFalse(session.award(1))
        XCTAssertTrue(session.start())
        XCTAssertFalse(session.start())
        clock.now = 1_000_000
        session.refresh()
        XCTAssertNil(session.remaining)
        XCTAssertTrue(session.award(-2))
        session.abandon()
        XCTAssertEqual(session.phase, .abandoned)
        XCTAssertFalse(session.award(10))
        session.finish()
        XCTAssertEqual(session.phase, .abandoned)
        XCTAssertEqual(session.score, -2)
    }

    func testCompletionAndOverflowCannotChangeScore() {
        var session = GameSession(configuration: config(nil), clock: ManualClock())
        XCTAssertTrue(session.start())
        XCTAssertTrue(session.award(Int.max))
        XCTAssertFalse(session.award(1))
        XCTAssertEqual(session.score, Int.max)
        session.finish()
        XCTAssertFalse(session.award(-1))
        XCTAssertEqual(session.phase, .completed)
    }

    func testScoringPolicySupportsDifferentPenalties() {
        let rule = ScoreRule(correct: 1, incorrect: -2)
        XCTAssertEqual(rule.points(for: true), 1)
        XCTAssertEqual(rule.points(for: false), -2)
    }
}
