import Foundation

enum GameID: String, Codable, CaseIterable {
    case arithmetic, arithmeticPro, sequence, optiver, memory, risk, flexibility, letterSpeed
}

enum Difficulty: String, Codable, CaseIterable {
    case classic, easy, normal, hard, expert
}

struct SessionConfiguration: Equatable {
    let game: GameID
    let difficulty: Difficulty
    // nil denotes untimed practice; callers must keep its records separate.
    let duration: TimeInterval?

    init(game: GameID, difficulty: Difficulty, duration: TimeInterval?) {
        precondition(duration == nil || (duration!.isFinite && duration! > 0))
        self.game = game
        self.difficulty = difficulty
        self.duration = duration
    }
}

enum SessionPhase: Equatable {
    case ready, active, completed, abandoned
}

struct ScoreRule: Equatable {
    let correct: Int
    let incorrect: Int

    func points(for isCorrect: Bool) -> Int {
        isCorrect ? correct : incorrect
    }
}

// Games can define their own question, answer, progression and scoring rules.
protocol GameRules {
    associatedtype Question
    associatedtype Answer
    mutating func nextQuestion() -> Question
    func isCorrect(_ answer: Answer, for question: Question) -> Bool
}
