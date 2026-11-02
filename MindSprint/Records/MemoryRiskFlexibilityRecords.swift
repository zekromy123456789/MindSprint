import Foundation

extension MemoryRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed, let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .memory, difficulty: .classic,
                mode: "three-stage", rulesVersion: 1, durationLimit: nil),
            outcome: .completed, finishedAt: finishedAt, score: score,
            correct: score, incorrect: incorrectCount)
    }
}

extension RiskRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed, let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .risk, difficulty: .classic,
                mode: "20-balloon", rulesVersion: 1, durationLimit: nil),
            outcome: .completed, finishedAt: finishedAt, score: score)
    }
}

extension FlexibilityRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed, let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .flexibility, difficulty: .classic,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: .completed, finishedAt: finishedAt, score: score,
            correct: correctCount, incorrect: incorrectCount)
    }
}
