import Foundation

protocol SessionClock {
    // Seconds from an arbitrary monotonic origin, including time spent asleep.
    var now: TimeInterval { get }
}

struct MonotonicSessionClock: SessionClock {
    private let clock = ContinuousClock()
    private let origin: ContinuousClock.Instant

    init() {
        origin = ContinuousClock().now
    }

    var now: TimeInterval {
        let parts = origin.duration(to: clock.now).components
        return Double(parts.seconds) + Double(parts.attoseconds) / 1e18
    }
}

struct GameSession {
    let configuration: SessionConfiguration
    private(set) var phase: SessionPhase = .ready
    private(set) var score = 0
    private var startedAt: TimeInterval?
    private var endedAt: TimeInterval?
    private let clock: any SessionClock

    init(configuration: SessionConfiguration, clock: any SessionClock = MonotonicSessionClock()) {
        self.configuration = configuration
        self.clock = clock
    }

    @discardableResult
    mutating func start() -> Bool {
        start(at: clock.now)
    }

    // Allows a delayed refresh to preserve a countdown's actual end time.
    @discardableResult
    mutating func start(at time: TimeInterval) -> Bool {
        guard phase == .ready else { return false }
        guard time.isFinite, time <= clock.now else { return false }
        startedAt = time
        phase = .active
        return true
    }

    // The caller must refresh on returning from background and before processing input.
    mutating func refresh() {
        guard phase == .active, let duration = configuration.duration,
              let startedAt = startedAt else { return }
        let now = clock.now
        if now - startedAt >= duration {
            endedAt = startedAt + duration
            phase = .completed
        }
    }

    var remaining: TimeInterval? {
        guard let duration = configuration.duration else { return nil }
        guard let startedAt = startedAt else { return duration }
        return max(0, duration - max(0, (endedAt ?? clock.now) - startedAt))
    }

    // This includes time spent away, matching the monotonic game clock.
    var elapsed: TimeInterval? {
        guard let startedAt else { return nil }
        return max(0, (endedAt ?? clock.now) - startedAt)
    }

    // Rules own answer validation and progression; score changes only while active.
    @discardableResult
    mutating func award(_ points: Int) -> Bool {
        refresh()
        guard phase == .active else { return false }
        let (next, overflow) = score.addingReportingOverflow(points)
        guard !overflow else { return false }
        score = next
        return true
    }

    mutating func finish() {
        refresh()
        if phase == .active {
            endedAt = clock.now
            phase = .completed
        }
    }

    mutating func abandon() {
        refresh()
        if phase == .active || phase == .ready {
            endedAt = clock.now
            phase = .abandoned
        }
    }
}
