import Foundation

extension LetterSpeedRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed, let finishedAt, results.count == Self.questionCount else { return nil }
        let correct = results.filter { $0.selectedIndex == $0.question.correctIndex }.count
        let incorrect = results.filter { $0.selectedIndex != nil && $0.selectedIndex != $0.question.correctIndex }.count
        return SessionRecord(
            id: sessionID,
            configuration: RecordConfiguration(game: .letterSpeed, difficulty: difficulty,
                mode: "ten-round", rulesVersion: 1, durationLimit: Self.questionDuration),
            outcome: .completed, finishedAt: finishedAt, score: score,
            correct: correct, incorrect: incorrect
        )
    }
}
