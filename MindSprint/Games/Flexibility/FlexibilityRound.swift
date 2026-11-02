import Foundation

enum FlexibilityColor: String, CaseIterable { case blue, black, red }

struct FlexibilityQuestion: Equatable {
    let leftWord: FlexibilityColor
    let leftColor: FlexibilityColor
    let rightWord: FlexibilityColor
    let rightColor: FlexibilityColor

    // Compare meaning on the left to ink color on the right.
    var isMatch: Bool { leftWord == rightColor }
}

struct FlexibilityGenerator {
    func next<R: RandomNumberGenerator>(using random: inout R) -> FlexibilityQuestion {
        let colors = FlexibilityColor.allCases
        let leftWord = colors.randomElement(using: &random)!
        let leftColor = colors.randomElement(using: &random)!
        let rightWord = colors.randomElement(using: &random)!
        let rightColor = (colors + [leftWord]).randomElement(using: &random)!
        return FlexibilityQuestion(leftWord: leftWord, leftColor: leftColor,
                                   rightWord: rightWord, rightColor: rightColor)
    }
}

enum FlexibilityPhase: Equatable { case ready, countdown, active, completed, abandoned }

struct FlexibilityRound {
    static let countdownDuration: TimeInterval = 3
    static let roundDuration: TimeInterval = 60

    let sessionID = UUID()
    private(set) var finishedAt: Date?
    private(set) var hasPlayed = false
    private let clock: any SessionClock
    private var random: SeededRandomNumberGenerator
    private var session: GameSession
    private var countdownEndsAt: TimeInterval?
    private(set) var phase: FlexibilityPhase = .ready
    private(set) var question: FlexibilityQuestion?
    private(set) var questionID = 0
    private(set) var correctCount = 0
    private(set) var incorrectCount = 0

    init(clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.clock = clock
        random = SeededRandomNumberGenerator(seed: seed)
        session = GameSession(configuration: SessionConfiguration(game: .flexibility, difficulty: .classic,
                                                                  duration: Self.roundDuration), clock: clock)
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
            if session.phase == .active { advance() }
        }
        if phase == .active {
            session.refresh()
            if session.phase == .completed { phase = .completed; finishedAt = Date(); question = nil }
        }
    }

    @discardableResult
    mutating func answer(_ matches: Bool, forQuestion token: Int) -> Bool {
        refresh()
        guard phase == .active, token == questionID, let question else { return false }
        let correct = matches == question.isMatch
        guard session.award(correct ? 1 : -1) else { refresh(); return false }
        if correct { correctCount += 1 } else { incorrectCount += 1 }
        advance()
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

    private mutating func advance() {
        question = FlexibilityGenerator().next(using: &random)
        questionID += 1
    }
}
