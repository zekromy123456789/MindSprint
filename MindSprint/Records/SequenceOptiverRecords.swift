import Foundation

extension SequenceRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .sequence, difficulty: difficulty,
                mode: "timed", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score, correct: score)
    }
}

extension OptiverRound {
    var completedRecord: SessionRecord? {
        guard phase == .completed else { return nil }
        return terminalRecord
    }
    var terminalRecord: SessionRecord? {
        guard (phase == .completed || phase == .abandoned), let finishedAt else { return nil }
        return SessionRecord(id: sessionID,
            configuration: RecordConfiguration(game: .optiver, difficulty: difficulty,
                mode: "timed-80", rulesVersion: 1, durationLimit: Self.roundDuration),
            outcome: phase == .completed ? .completed : .abandoned, finishedAt: finishedAt, score: score,
            correct: responses.filter { $0 == true }.count,
            incorrect: responses.filter { $0 == false }.count)
    }
}
