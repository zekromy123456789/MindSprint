import XCTest
import SQLite3
@testable import MindSprint

final class RecordStoreTests: XCTestCase {
    private func temporaryDatabase() throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        addTeardownBlock { try? FileManager.default.removeItem(at: directory) }
        return directory.appendingPathComponent("records.sqlite")
    }

    private func config(_ difficulty: Difficulty = .classic, mode: String = "standard", duration: TimeInterval? = 30) -> RecordConfiguration {
        RecordConfiguration(game: .letterSpeed, difficulty: difficulty, mode: mode, rulesVersion: 1, durationLimit: duration)
    }

    func testRecordsSurviveReopeningAndRemainSorted() throws {
        let url = try temporaryDatabase()
        let older = SessionRecord(configuration: config(), outcome: .completed,
                                  finishedAt: Date(timeIntervalSince1970: 100), score: 20,
                                  elapsed: 12, correct: 3, incorrect: 1, responseTimes: [1.5, 2])
        let newer = SessionRecord(configuration: config(.expert), outcome: .abandoned,
                                  finishedAt: Date(timeIntervalSince1970: 200), score: 50)
        do {
            let store = try RecordStore(url: url)
            try store.insert(older)
            try store.insert(newer)
        }
        let reopened = try RecordStore(url: url)
        XCTAssertEqual(try reopened.allRecords(), [newer, older])
    }

    func testSummarySeparatesDifficultyModeAndDurationAndExcludesNonCompleted() {
        let base = config()
        let records = [
            SessionRecord(configuration: base, outcome: .completed, score: 10),
            SessionRecord(configuration: base, outcome: .completed, score: 30),
            SessionRecord(configuration: base, outcome: .abandoned, score: 300),
            SessionRecord(configuration: base, outcome: .invalid, score: 400),
            SessionRecord(configuration: config(.expert), outcome: .completed, score: 200),
            SessionRecord(configuration: config(mode: "practice"), outcome: .completed, score: 250),
            SessionRecord(configuration: config(duration: 60), outcome: .completed, score: 275)
        ]
        let summary = RecordSummary(records: records, configuration: base)
        XCTAssertEqual(summary.completedCount, 2)
        XCTAssertEqual(summary.bestScore, 30)
        XCTAssertEqual(summary.averageScore, 20)
        let empty = RecordSummary(records: [], configuration: base)
        XCTAssertNil(empty.bestScore)
        XCTAssertNil(empty.averageScore)
    }

    func testRejectsInvalidAndDuplicateWithoutOverwriting() throws {
        let store = try RecordStore(url: temporaryDatabase())
        let id = UUID()
        let original = SessionRecord(id: id, configuration: config(), outcome: .completed, score: 42)
        try store.insert(original)
        XCTAssertThrowsError(try store.insert(SessionRecord(id: id, configuration: config(), outcome: .completed, score: 99)))
        XCTAssertThrowsError(try store.insert(SessionRecord(configuration: config(), outcome: .completed, score: 0, elapsed: -1)))
        XCTAssertThrowsError(try store.insert(SessionRecord(configuration: config(), outcome: .completed, score: 0, responseTimes: [.infinity])))
        XCTAssertEqual(try store.allRecords(), [original])
    }

    func testFutureSchemaIsRejectedWithoutChangingVersion() throws {
        let url = try temporaryDatabase()
        var db: OpaquePointer?
        XCTAssertEqual(sqlite3_open(url.path, &db), SQLITE_OK)
        XCTAssertEqual(sqlite3_exec(db, "PRAGMA user_version = 99", nil, nil, nil), SQLITE_OK)
        XCTAssertEqual(sqlite3_close(db), SQLITE_OK)
        XCTAssertThrowsError(try RecordStore(url: url)) { error in
            guard let storeError = error as? RecordStoreError, case .unsupportedSchema(99) = storeError else {
                XCTFail("Unexpected error: \(error)"); return
            }
        }
        db = nil
        XCTAssertEqual(sqlite3_open(url.path, &db), SQLITE_OK)
        var stmt: OpaquePointer?
        XCTAssertEqual(sqlite3_prepare_v2(db, "PRAGMA user_version", -1, &stmt, nil), SQLITE_OK)
        XCTAssertEqual(sqlite3_step(stmt), SQLITE_ROW)
        XCTAssertEqual(sqlite3_column_int(stmt, 0), 99)
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }
}
