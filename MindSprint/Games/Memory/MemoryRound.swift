import Foundation

enum MemoryStage: Int, CaseIterable {
    case original, reversed, ascending

    var instruction: String {
        switch self {
        case .original: return "Enter the digits in the order shown."
        case .reversed: return "Enter the digits in reverse order."
        case .ascending: return "Enter the digits in increasing order."
        }
    }

    func answer(for digits: [Int]) -> String {
        let ordered: [Int]
        switch self {
        case .original: ordered = digits
        case .reversed: ordered = Array(digits.reversed())
        case .ascending: ordered = digits.sorted()
        }
        return ordered.map { String($0) }.joined()
    }
}

enum MemoryPhase: Equatable { case instructions, countdown, presenting, recall, completed, abandoned }

// Playback starts after a one-second lead-in and shows each digit for one second.
// Animation duration in the source is not independently established; this is a
// deliberate, accessible pacing choice. A background interruption restarts playback.
struct MemoryRound {
    static let countdownDuration: TimeInterval = 3
    static let leadIn: TimeInterval = 1
    static let digitDuration: TimeInterval = 1

    let sessionID = UUID()
    private(set) var finishedAt: Date?
    private(set) var hasPlayed = false
    private let clock: any SessionClock
    private var random: SeededRandomNumberGenerator
    private var countdownEndsAt: TimeInterval?
    private var presentationStartedAt: TimeInterval?
    private(set) var phase: MemoryPhase = .instructions
    private(set) var stage: MemoryStage = .original
    private(set) var length = 3
    private(set) var attempt = 1
    private(set) var score = 0
    private(set) var incorrectCount = 0
    private(set) var digits: [Int] = []
    private(set) var questionID = 0
    private(set) var isSuspended = false
    private(set) var visibleIndex: Int?

    init(clock: any SessionClock = MonotonicSessionClock(),
         seed: UInt64 = UInt64.random(in: .min ... .max)) {
        self.clock = clock
        random = SeededRandomNumberGenerator(seed: seed)
    }

    var countdownRemaining: TimeInterval {
        guard phase == .countdown, let end = countdownEndsAt else { return 0 }
        return max(0, end - clock.now)
    }

    private func currentVisibleIndex() -> Int? {
        guard phase == .presenting, !isSuspended, let start = presentationStartedAt else { return nil }
        let elapsed = clock.now - start - Self.leadIn
        guard elapsed >= 0 else { return nil }
        let index = Int(elapsed / Self.digitDuration)
        guard digits.indices.contains(index) else { return nil }
        return index
    }

    var visibleDigit: Int? { visibleIndex.map { digits[$0] } }

    mutating func beginStage() {
        guard phase == .instructions, !isSuspended else { return }
        newQuestion()
        countdownEndsAt = clock.now + Self.countdownDuration
        phase = .countdown
    }

    mutating func refresh() {
        guard !isSuspended else { return }
        if phase == .countdown, let end = countdownEndsAt, clock.now >= end {
            presentationStartedAt = clock.now
            hasPlayed = true
            phase = .presenting
        }
        if phase == .presenting, let start = presentationStartedAt {
            if clock.now - start >= Self.leadIn + Double(digits.count) * Self.digitDuration {
                visibleIndex = nil
                phase = .recall
            } else {
                visibleIndex = currentVisibleIndex()
            }
        }
    }

    @discardableResult
    mutating func submit(_ answer: String, forQuestion token: Int) -> Bool {
        refresh()
        guard phase == .recall, !isSuspended, token == questionID else { return false }
        if answer == stage.answer(for: digits) {
            score += 1
            length += 1
            attempt = 1
            newQuestion()
            presentationStartedAt = clock.now
            visibleIndex = nil
            phase = .presenting
        } else if attempt == 1 {
            incorrectCount += 1
            attempt = 2
            newQuestion()
            presentationStartedAt = clock.now
            visibleIndex = nil
            phase = .presenting
        } else if let next = MemoryStage(rawValue: stage.rawValue + 1) {
            incorrectCount += 1
            stage = next
            length = 3
            attempt = 1
            digits = []
            phase = .instructions
        } else {
            incorrectCount += 1
            phase = .completed
            finishedAt = Date()
        }
        return true
    }

    mutating func suspend() {
        guard phase != .completed, phase != .abandoned else { return }
        isSuspended = true
        visibleIndex = nil
    }

    mutating func resume() {
        guard isSuspended else { return }
        isSuspended = false
        if phase == .countdown { countdownEndsAt = clock.now + Self.countdownDuration }
        if phase == .presenting { presentationStartedAt = clock.now; visibleIndex = nil }
    }

    mutating func abandon() {
        guard phase != .completed, phase != .abandoned else { return }
        if hasPlayed { finishedAt = Date() }
        phase = .abandoned
    }

    private mutating func newQuestion() {
        var generated: [Int] = []
        for _ in 0..<length { generated.append(Int.random(in: 0...9, using: &random)) }
        digits = generated
        questionID += 1
    }
}
