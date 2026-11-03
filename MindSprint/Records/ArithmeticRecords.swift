import Foundation

extension ArithmeticRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .arithmetic, difficulty: difficulty,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, elapsed: elapsed, correct: score,
            responseTimes: responseTimes.isEmpty ? nil : responseTimes)
    }
}

extension ArithmeticProRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .arithmeticPro, difficulty: difficulty,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, elapsed: elapsed, correct: score,
            responseTimes: responseTimes.isEmpty ? nil : responseTimes)
    }
}
