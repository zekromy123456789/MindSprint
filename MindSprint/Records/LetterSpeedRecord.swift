import Foundation

extension LetterSpeedRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt,
              phase != .completed || results.count == Self.questionCount else { return nil }
        let correct = results.filter { $0.selectedIndex == $0.question.correctIndex }.count
        let incorrect = results.filter { $0.selectedIndex != nil && $0.selectedIndex != $0.question.correctIndex }.count
        return SessionRecord(
            id: sessionID,
            configuration: RecordConfiguration(game: .letterSpeed, difficulty: difficulty,
                mode: "ten-round", rulesVersion: 1, durationLimit: Self.questionDuration),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, elapsed: elapsed,
            correct: correct, incorrect: incorrect, responseTimes: responseTimes.isEmpty ? nil : responseTimes
        )
    }
}
