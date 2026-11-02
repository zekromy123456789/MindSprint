import Foundation

enum ArithmeticProRoundPhase: Equatable {
    case ready, countdown, active, completed, abandoned
}

// A round owns progression; the UI must refresh on ticks and app resume.
struct ArithmeticProRound {
    static let countdownDuration: TimeInterval = 3
    static let roundDuration: TimeInterval = 120

    let difficulty: Difficulty
    let sessionID = UUID()
    private(set) var finishedAt: Date?
    private(set) var hasPlayed = false
    private let clock: any SessionClock
    private let generator: ArithmeticProGenerator
    private var random: SeededRandomNumberGenerator
    private var session: GameSession
    private var countdownEndsAt: TimeInterval?
    private(set) var phase: ArithmeticProRoundPhase = .ready
    private(set) var question: ArithmeticProQuestion?
    private(set) var lastQuestion: ArithmeticProQuestion?
    private(set) var questionID = 0

    init(difficulty: Difficulty = .normal, clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.difficulty = difficulty
        self.clock = clock
        generator = ArithmeticProGenerator(difficulty: difficulty)
        random = SeededRandomNumberGenerator(seed: seed)
        session = GameSession(configuration: SessionConfiguration(
            game: .arithmeticPro, difficulty: difficulty, duration: Self.roundDuration), clock: clock)
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
            hasPlayed = true
            session.refresh()
            if session.phase == .active { advanceQuestion() }
        }
        if phase == .active {
            session.refresh()
            if session.phase == .completed {
                phase = .completed
                finishedAt = Date()
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
        if hasPlayed { finishedAt = Date() }
        phase = .abandoned
        question = nil
    }

    private mutating func advanceQuestion() {
        question = generator.next(using: &random)
        questionID += 1
    }
}
