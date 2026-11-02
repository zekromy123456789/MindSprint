import Foundation

// Compatibility identifies records whose scores may be ranked together.
struct RecordConfiguration: Codable, Equatable, Hashable {
    let game: GameID
    let difficulty: Difficulty
    let mode: String
    let rulesVersion: Int
    let durationLimit: TimeInterval?

    var isValid: Bool {
        !mode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && rulesVersion > 0 &&
        (durationLimit.map { $0.isFinite && $0 > 0 } ?? true)
    }
}

enum RecordOutcome: String, Codable { case completed, abandoned, invalid }

struct SessionRecord: Codable, Equatable, Identifiable {
    let id: UUID
    let configuration: RecordConfiguration
    let outcome: RecordOutcome
    let finishedAt: Date
    let score: Int
    let elapsed: TimeInterval?
    let correct: Int?
    let incorrect: Int?
    let responseTimes: [TimeInterval]?

    init(id: UUID = UUID(), configuration: RecordConfiguration, outcome: RecordOutcome,
         finishedAt: Date = Date(), score: Int, elapsed: TimeInterval? = nil,
         correct: Int? = nil, incorrect: Int? = nil, responseTimes: [TimeInterval]? = nil) {
        self.id = id
        self.configuration = configuration
        self.outcome = outcome
        self.finishedAt = finishedAt
        self.score = score
        self.elapsed = elapsed
        self.correct = correct
        self.incorrect = incorrect
        self.responseTimes = responseTimes
    }

    var isValid: Bool {
        configuration.isValid && finishedAt.timeIntervalSince1970.isFinite &&
        (elapsed.map { $0.isFinite && $0 >= 0 } ?? true) &&
        (correct.map { $0 >= 0 } ?? true) && (incorrect.map { $0 >= 0 } ?? true) &&
        (responseTimes.map { $0.allSatisfy { $0.isFinite && $0 >= 0 } } ?? true)
    }
}

struct RecordSummary: Equatable {
    let completedCount: Int
    let bestScore: Int?
    let averageScore: Double?

    init(records: [SessionRecord], configuration: RecordConfiguration) {
        let scores = records.filter { $0.configuration == configuration && $0.outcome == .completed }.map(\.score)
        completedCount = scores.count
        bestScore = scores.max()
        averageScore = scores.isEmpty ? nil : scores.reduce(0.0) { $0 + Double($1) } / Double(scores.count)
    }
}
