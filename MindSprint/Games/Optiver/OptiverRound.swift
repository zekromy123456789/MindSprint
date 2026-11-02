import Foundation

enum OptiverRoundPhase: Equatable { case ready, countdown, active, completed, abandoned }

struct OptiverRound {
    static let countdownDuration: TimeInterval = 3
    static let roundDuration: TimeInterval = 480
    static let questionCount = 80

    private let clock: any SessionClock
    let difficulty: Difficulty
    let sessionID = UUID()
    private(set) var finishedAt: Date?
    private(set) var hasPlayed = false
    private var random: SeededRandomNumberGenerator
    private var session: GameSession
    private var countdownEndsAt: TimeInterval?
    private(set) var phase: OptiverRoundPhase = .ready
    private(set) var questions: [OptiverQuestion] = []
    private(set) var responses: [Bool?] = []
    private(set) var index = 0

    init(difficulty: Difficulty = .classic, clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.clock = clock
        self.difficulty = difficulty
        random = SeededRandomNumberGenerator(seed: seed)
        session = GameSession(configuration: SessionConfiguration(game: .optiver, difficulty: difficulty,
                                                                  duration: Self.roundDuration), clock: clock)
    }

    var score: Int { session.score }
    var remaining: TimeInterval { session.remaining ?? 0 }
    var countdownRemaining: TimeInterval {
        guard phase == .countdown, let end = countdownEndsAt else { return 0 }
        return max(0, end - clock.now)
    }
    var currentQuestion: OptiverQuestion? {
        guard phase == .active, index < questions.count else { return nil }
        return questions[index]
    }

    mutating func start() {
        guard phase == .ready else { return }
        let generator = OptiverGenerator(difficulty: difficulty)
        var generated: [OptiverQuestion] = []
        for _ in 0..<Self.questionCount { generated.append(generator.next(using: &random)) }
        questions = generated
        responses = Array(repeating: nil, count: Self.questionCount)
        countdownEndsAt = clock.now + Self.countdownDuration
        phase = .countdown
    }

    mutating func refresh() {
        if phase == .countdown, let end = countdownEndsAt, clock.now >= end {
            guard session.start(at: end) else { return }
            phase = .active
            hasPlayed = true
        }
        if phase == .active {
            session.refresh()
            if session.phase == .completed { phase = .completed; finishedAt = Date() }
        }
    }

    // The index token prevents a late tap from answering the following question.
    @discardableResult
    mutating func choose(_ choice: OptiverNumber, forQuestion token: Int) -> Bool {
        refresh()
        guard phase == .active, token == index, let question = currentQuestion,
              question.choices.contains(choice) else { return false }
        let correct = choice == question.answer
        guard session.award(correct ? 1 : -2) else { refresh(); return false }
        responses[index] = correct
        index += 1
        if index == Self.questionCount {
            session.finish()
            phase = .completed
            finishedAt = Date()
        }
        return true
    }

    mutating func abandon() {
        guard phase == .ready || phase == .countdown || phase == .active else { return }
        refresh()
        guard phase != .completed else { return }
        session.abandon()
        if hasPlayed { finishedAt = Date() }
        phase = .abandoned
    }
}
