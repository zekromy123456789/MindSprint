import Foundation

struct RankedAttempt: Identifiable, Equatable {
    let rank: Int
    let record: SessionRecord
    var id: UUID { record.id }
}

struct BestProgressPoint: Identifiable, Equatable {
    let record: SessionRecord
    let bestScore: Int
    var id: UUID { record.id }
}

// Only exactly compatible, completed sessions are compared. Ties share a rank;
// earlier completion then UUID gives a deterministic order inside a tie.
struct RecordAnalytics {
    let ranked: [RankedAttempt]
    let progress: [BestProgressPoint]
    let accuracy: Double?
    let accuracySessionCount: Int
    let averageResponseTime: TimeInterval?
    let responseCount: Int

    init(records: [SessionRecord], configuration: RecordConfiguration) {
        let completed = records.filter {
            $0.configuration == configuration && $0.outcome == .completed && $0.isValid
        }
        let rankedRecords = completed.sorted {
            if $0.score != $1.score { return $0.score > $1.score }
            if $0.finishedAt != $1.finishedAt { return $0.finishedAt < $1.finishedAt }
            return $0.id.uuidString < $1.id.uuidString
        }
        var lastScore: Int?
        var rank = 0
        ranked = rankedRecords.enumerated().map { index, record in
            if lastScore != record.score { rank = index + 1; lastScore = record.score }
            return RankedAttempt(rank: rank, record: record)
        }
        let chronological = completed.sorted {
            if $0.finishedAt != $1.finishedAt { return $0.finishedAt < $1.finishedAt }
            return $0.id.uuidString < $1.id.uuidString
        }
        var best: Int?
        progress = chronological.map { record in
            best = max(best ?? record.score, record.score)
            return BestProgressPoint(record: record, bestScore: best!)
        }
        var totalCorrect = 0.0
        var totalAnswered = 0.0
        var measuredSessions = 0
        var responseMean = 0.0
        var measuredResponses = 0
        for record in completed {
            if let correct = record.correct, let incorrect = record.incorrect,
               correct > 0 || incorrect > 0 {
                totalCorrect += Double(correct)
                totalAnswered += Double(correct) + Double(incorrect)
                measuredSessions += 1
            }
            for time in record.responseTimes ?? [] {
                measuredResponses += 1
                responseMean += (time - responseMean) / Double(measuredResponses)
            }
        }
        accuracySessionCount = measuredSessions
        accuracy = totalAnswered > 0 ? totalCorrect / totalAnswered : nil
        responseCount = measuredResponses
        averageResponseTime = measuredResponses > 0 ? responseMean : nil
    }
}
