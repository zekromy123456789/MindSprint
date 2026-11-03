import Foundation

enum LetterSpeedPhase: Equatable { case ready, countdown, active, completed, abandoned }

struct LetterSpeedResult: Equatable {
    let question: LetterQuestion
    let selectedIndex: Int?
    let points: Int
    let timedOut: Bool
}

struct LetterSpeedRound {
    static let countdownDuration: TimeInterval = 3
    static let questionDuration: TimeInterval = 30
    static let questionCount = 10

    let difficulty: Difficulty
    let sessionID = UUID()
    private(set) var finishedAt: Date?
    private(set) var hasPlayed = false
    private let clock: any SessionClock
    private var random: SeededRandomNumberGenerator
    private var countdownEndsAt: TimeInterval?
    private var questionStartedAt: TimeInterval?
    private var playStartedAt: TimeInterval?
    private(set) var elapsed: TimeInterval?
    private(set) var phase: LetterSpeedPhase = .ready
    private(set) var question: LetterQuestion?
    private(set) var questionID = 0
    private(set) var score = 0
    private(set) var results: [LetterSpeedResult] = []
    private(set) var responseTimes: [TimeInterval] = []

    init(difficulty: Difficulty = .classic,
         clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.difficulty = difficulty
        self.clock = clock
        random = SeededRandomNumberGenerator(seed: seed)
    }

    var roundNumber: Int { min(results.count + 1, Self.questionCount) }
    var remaining: TimeInterval {
        guard phase == .active, let start = questionStartedAt else {
            return phase == .completed ? 0 : Self.questionDuration
        }
        return max(0, Self.questionDuration - max(0, clock.now - start))
    }
    var countdownRemaining: TimeInterval {
        guard phase == .countdown, let end = countdownEndsAt else { return 0 }
        return max(0, end - clock.now)
    }

    mutating func start() {
        guard phase == .ready else { return }
        countdownEndsAt = clock.now + Self.countdownDuration
        phase = .countdown
    }

    mutating func refresh() { refresh(at: clock.now) }

    private mutating func refresh(at now: TimeInterval) {
        if phase == .countdown, let end = countdownEndsAt, now >= end {
            phase = .active
            hasPlayed = true
            playStartedAt = now
            nextQuestion(at: now)
        } else if phase == .active, let start = questionStartedAt,
                  now - start >= Self.questionDuration, let question {
            finishQuestion(LetterSpeedResult(question: question, selectedIndex: nil, points: 0, timedOut: true), at: now)
        }
    }

    // A delayed callback advances one timed-out round, then starts a fresh clock;
    // stale taps cannot answer the next grid.
    @discardableResult
    mutating func choose(_ index: Int, forQuestion token: Int) -> Bool {
        let now = clock.now
        refresh(at: now)
        guard phase == .active, token == questionID, let question,
              question.choices.indices.contains(index), let start = questionStartedAt else { return false }
        let elapsed = max(0, now - start)
        responseTimes.append(elapsed)
        let points = index == question.correctIndex ? max(0, 30 - Int(floor(elapsed))) : 0
        finishQuestion(LetterSpeedResult(question: question, selectedIndex: index, points: points, timedOut: false), at: now)
        return true
    }

    mutating func abandon() {
        guard phase == .ready || phase == .countdown || phase == .active else { return }
        refresh()
        guard phase != .completed else { return }
        if hasPlayed {
            finishedAt = Date()
            elapsed = playStartedAt.map { max(0, clock.now - $0) }
        }
        phase = .abandoned
        question = nil
    }

    private mutating func finishQuestion(_ result: LetterSpeedResult, at now: TimeInterval) {
        score += result.points
        results.append(result)
        if results.count == Self.questionCount {
            phase = .completed
            finishedAt = Date()
            elapsed = playStartedAt.map { max(0, now - $0) }
            question = nil
        } else {
            nextQuestion(at: now)
        }
    }

    private mutating func nextQuestion(at now: TimeInterval) {
        question = LetterSpeedGenerator(difficulty: difficulty).next(using: &random)
        questionStartedAt = now
        questionID += 1
    }
}
