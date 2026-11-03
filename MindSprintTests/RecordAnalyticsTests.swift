import XCTest
@testable import MindSprint

final class RecordAnalyticsTests: XCTestCase {
    private let base = RecordConfiguration(game: .optiver, difficulty: .classic, mode: "timed-80", rulesVersion: 1, durationLimit: 480)

    private func record(_ score: Int, time: TimeInterval, id: String, config: RecordConfiguration? = nil,
                        outcome: RecordOutcome = .completed, correct: Int? = nil, incorrect: Int? = nil,
                        responses: [TimeInterval]? = nil) -> SessionRecord {
        SessionRecord(id: UUID(uuidString: id)!, configuration: config ?? base, outcome: outcome,
            finishedAt: Date(timeIntervalSince1970: time), score: score,
            correct: correct, incorrect: incorrect, responseTimes: responses)
    }

    func testRankingTiesNegativeScoresAndFiltering() {
        let a = record(-4, time: 10, id: "00000000-0000-0000-0000-000000000002")
        let b = record(5, time: 30, id: "00000000-0000-0000-0000-000000000003")
        let c = record(5, time: 20, id: "00000000-0000-0000-0000-000000000004")
        let d = record(5, time: 20, id: "00000000-0000-0000-0000-000000000001")
        let other = RecordConfiguration(game: .optiver, difficulty: .expert, mode: "timed-80", rulesVersion: 1, durationLimit: 480)
        let ignored = [record(999, time: 5, id: "00000000-0000-0000-0000-000000000005", config: other),
                       record(999, time: 5, id: "00000000-0000-0000-0000-000000000006", outcome: .abandoned),
                       record(999, time: 5, id: "00000000-0000-0000-0000-000000000007", outcome: .invalid)]
        let result = RecordAnalytics(records: [a,b,c,d] + ignored, configuration: base)
        XCTAssertEqual(result.ranked.map(\.record.id), [d.id,c.id,b.id,a.id])
        XCTAssertEqual(result.ranked.map(\.rank), [1,1,1,4])
        XCTAssertEqual(result.progress.map(\.record.id), [a.id,d.id,c.id,b.id])
        XCTAssertEqual(result.progress.map(\.bestScore), [-4,5,5,5])
    }

    func testMeasuredStatisticsExcludeMissingAndEmptyData() {
        let a = record(3, time: 1, id: "00000000-0000-0000-0000-000000000001", correct: 2, incorrect: 1, responses: [1,3])
        let b = record(5, time: 2, id: "00000000-0000-0000-0000-000000000002", correct: 1, incorrect: 2, responses: [2])
        let missing = record(0, time: 3, id: "00000000-0000-0000-0000-000000000003", correct: 100)
        let noAnswers = record(0, time: 4, id: "00000000-0000-0000-0000-000000000004", correct: 0, incorrect: 0)
        let result = RecordAnalytics(records: [a,b,missing,noAnswers], configuration: base)
        XCTAssertEqual(result.accuracy!, 0.5, accuracy: 0.00001)
        XCTAssertEqual(result.accuracySessionCount, 2)
        XCTAssertEqual(result.averageResponseTime!, 2, accuracy: 0.00001)
        XCTAssertEqual(result.responseCount, 3)
        XCTAssertEqual(result.accuracyProgress.map(\.value), [2.0 / 3.0, 1.0 / 3.0])
        XCTAssertEqual(result.responseProgress.map(\.value), [2, 2])
        let empty = RecordAnalytics(records: [missing,noAnswers], configuration: base)
        XCTAssertNil(empty.accuracy)
        XCTAssertNil(empty.averageResponseTime)
        XCTAssertEqual(empty.responseCount, 0)
        XCTAssertTrue(empty.accuracyProgress.isEmpty)
        XCTAssertTrue(empty.responseProgress.isEmpty)
    }

    func testDifferentModesRulesAndDurationsNeverMix() {
        let changes = [
            RecordConfiguration(game: .optiver, difficulty: .classic, mode: "practice", rulesVersion: 1, durationLimit: 480),
            RecordConfiguration(game: .optiver, difficulty: .classic, mode: "timed-80", rulesVersion: 2, durationLimit: 480),
            RecordConfiguration(game: .optiver, difficulty: .classic, mode: "timed-80", rulesVersion: 1, durationLimit: 300),
            RecordConfiguration(game: .sequence, difficulty: .classic, mode: "timed-80", rulesVersion: 1, durationLimit: 480)
        ]
        let records = changes.enumerated().map { index, config in
            record(100, time: Double(index), id: "00000000-0000-0000-0000-00000000000\(index + 1)", config: config)
        }
        let result = RecordAnalytics(records: records, configuration: base)
        XCTAssertTrue(result.ranked.isEmpty)
        XCTAssertTrue(result.progress.isEmpty)
        XCTAssertNil(result.accuracy)
    }
}
