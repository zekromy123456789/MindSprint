import Foundation

enum SequenceRoundPhase: Equatable {
    case ready, countdown, active, completed, abandoned
}

// A round owns progression; the UI must refresh on ticks and app resume.
struct SequenceRound {
    static let countdownDuration: TimeInterval = 3
    static let roundDuration: TimeInterval = 120

    private let clock: any SessionClock
    private let generator: SequenceGenerator
    private var random: SeededRandomNumberGenerator
    private var session: GameSession
    private var countdownEndsAt: TimeInterval?
    private(set) var phase: SequenceRoundPhase = .ready
    private(set) var question: SequenceQuestion?
    private(set) var lastQuestion: SequenceQuestion?
    private(set) var questionID = 0

    init(clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.clock = clock
        generator = SequenceGenerator()
        random = SeededRandomNumberGenerator(seed: seed)
        session = GameSession(configuration: SessionConfiguration(
            game: .sequence, difficulty: .classic, duration: Self.roundDuration), clock: clock)
    }

    var score: Int { session.score }
    var remaining: TimeInterval { session.remaining ?? 0 }
    var countdownRemaining: TimeInterval {
        guard phase == .countdown, let end = countdownEndsAt else { return 0 }
        return max(0, end - clock.now)
    }

    mutating func start() {
        guard phase == .ready else { return }
        countdownEndsAt = clock.now + Self.countdownDuration
        phase = .countdown
    }

    mutating func refresh() {
        if phase == .countdown, let end = countdownEndsAt, clock.now >= end {
            guard session.start(at: end) else { return }
            phase = .active
            session.refresh()
            if session.phase == .active { advanceQuestion() }
        }
        if phase == .active {
            session.refresh()
            if session.phase == .completed {
                phase = .completed
                lastQuestion = question
                question = nil
            }
        }
    }

    // A question token prevents a delayed callback from scoring the next question.
    @discardableResult
    mutating func accept(_ text: String, forQuestion id: Int) -> Bool {
        refresh()
        guard phase == .active, id == questionID, let question,
              question.accepts(text), session.award(1) else {
            refresh()
            return false
        }
        advanceQuestion()
        return true
    }

    mutating func abandon() {
        guard phase == .ready || phase == .countdown || phase == .active else { return }
        refresh()
        guard phase != .completed else { return }
        session.abandon()
        phase = .abandoned
        question = nil
    }

    private mutating func advanceQuestion() {
        question = generator.next(using: &random)
        questionID += 1
    }
}
