import Foundation

extension ArithmeticRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed, let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .arithmetic, difficulty: difficulty,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: .completed, finishedAt: finishedAt, score: score, correct: score)
    }
}

extension ArithmeticProRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed, let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .arithmeticPro, difficulty: difficulty,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: .completed, finishedAt: finishedAt, score: score, correct: score)
    }
}
