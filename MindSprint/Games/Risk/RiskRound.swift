import Foundation

enum RiskColor: String, CaseIterable { case blue, green, red, purple }
enum RiskPhase: Equatable { case ready, countdown, active, completed, abandoned }
enum RiskOutcome: Equatable { case collected(Int), popped }

struct RiskRound {
    static let countdownDuration: TimeInterval = 3
    static let totalRounds = 20

    let sessionID = UUID()
    private(set) var finishedAt: Date?
    private(set) var hasPlayed = false
    private let clock: any SessionClock
    private var random: SeededRandomNumberGenerator
    private var countdownEndsAt: TimeInterval?
    private var playStartedAt: TimeInterval?
    private(set) var elapsed: TimeInterval?
    private(set) var phase: RiskPhase = .ready
    private(set) var probabilities: [RiskColor: Int] = [:]
    private(set) var roundNumber = 1
    private(set) var roundID = 0
    private(set) var color: RiskColor = .blue
    private(set) var unbanked = 1
    private(set) var score = 0
    private(set) var lastOutcome: RiskOutcome?

    init(clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.clock = clock
        random = SeededRandomNumberGenerator(seed: seed)
    }

    var countdownRemaining: TimeInterval {
        guard phase == .countdown, let end = countdownEndsAt else { return 0 }
        return max(0, end - clock.now)
    }

    // The inspected reference falls through from green to red. Classic preserves
    // that behavior; the unused green assignment is retained for faithful setup.
    func effectiveProbability(for color: RiskColor) -> Int? {
        probabilities[color == .green ? .red : color]
    }

    mutating func start() {
        guard phase == .ready else { return }
        var colors = RiskColor.allCases
        colors.shuffle(using: &random)
        let values = [Int.random(in: 15...20, using: &random),
                      Int.random(in: 8...12, using: &random),
                      Int.random(in: 8...12, using: &random),
                      Int.random(in: 5...10, using: &random)]
        for (color, value) in zip(colors, values) { probabilities[color] = value }
        newBalloon()
        countdownEndsAt = clock.now + Self.countdownDuration
        phase = .countdown
    }

    mutating func refresh() {
        if phase == .countdown, let end = countdownEndsAt, clock.now >= end {
            phase = .active
            hasPlayed = true
            playStartedAt = clock.now
        }
    }

    // A caller-supplied roll is useful for deterministic rule tests.
    @discardableResult
    mutating func pump(forRound token: Int, roll: Double? = nil) -> Bool {
        refresh()
        guard phase == .active, token == roundID, let probability = effectiveProbability(for: color) else { return false }
        let sample = roll ?? Double.random(in: 0..<1, using: &random)
        guard sample.isFinite, (0...1).contains(sample) else { return false }
        if sample <= Double(probability) / 100 {
            lastOutcome = .popped
            advance()
        } else {
            let (next, overflow) = unbanked.addingReportingOverflow(1)
            guard !overflow else { return false }
            unbanked = next
        }
        return true
    }

    @discardableResult
    mutating func collect(forRound token: Int) -> Bool {
        refresh()
        guard phase == .active, token == roundID else { return false }
        let (next, overflow) = score.addingReportingOverflow(unbanked)
        guard !overflow else { return false }
        score = next
        lastOutcome = .collected(unbanked)
        advance()
        return true
    }

    mutating func abandon() {
        guard phase != .completed, phase != .abandoned else { return }
        refresh()
        if hasPlayed {
            finishedAt = Date()
            elapsed = playStartedAt.map { max(0, clock.now - $0) }
        }
        phase = .abandoned
    }

    private mutating func advance() {
        if roundNumber == Self.totalRounds {
            phase = .completed
            finishedAt = Date()
            elapsed = playStartedAt.map { max(0, clock.now - $0) }
        } else {
            roundNumber += 1
            newBalloon()
        }
    }

    private mutating func newBalloon() {
        color = RiskColor.allCases.randomElement(using: &random)!
        unbanked = 1
        roundID += 1
    }
}
