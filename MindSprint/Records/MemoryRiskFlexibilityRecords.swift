import Foundation

extension MemoryRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .memory, difficulty: .classic,
                mode: "three-stage", rulesVersion: 1, durationLimit: nil),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, elapsed: elapsed,
            correct: score, incorrect: incorrectCount,
            responseTimes: responseTimes.isEmpty ? nil : responseTimes)
    }
}

extension RiskRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .risk, difficulty: .classic,
                mode: "20-balloon", rulesVersion: 1, durationLimit: nil),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, elapsed: elapsed)
    }
}

extension FlexibilityRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .flexibility, difficulty: .classic,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, elapsed: elapsed,
            correct: correctCount, incorrect: incorrectCount,
            responseTimes: responseTimes.isEmpty ? nil : responseTimes)
    }
}
