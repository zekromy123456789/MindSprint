import XCTest
@testable import MindSprint

final class RecordBackupTests: XCTestCase {
    private let configuration = RecordConfiguration(game: .letterSpeed, difficulty: .classic,
        mode: "ten-round", rulesVersion: 1, durationLimit: 30)

    func testRoundTripPreservesRecordsAndRejectsFutureVersions() throws {
        let records = [SessionRecord(configuration: configuration, outcome: .completed,
            finishedAt: Date(timeIntervalSince1970: 123), score: 17, correct: 3, incorrect: 1, responseTimes: [0.5, 2.25]),
            SessionRecord(configuration: configuration, outcome: .abandoned, score: 4)]
        let data = try RecordBackup.encode(records)
        XCTAssertEqual(try RecordBackup.decode(data), records)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        object["version"] = 99
        XCTAssertThrowsError(try RecordBackup.decode(JSONSerialization.data(withJSONObject: object)))
        XCTAssertThrowsError(try RecordBackup.decode(Data("bad json".utf8)))
        XCTAssertThrowsError(try RecordBackup.decode(Data(repeating: 32, count: RecordBackup.maxBytes + 1)))
        let invalid = SessionRecord(configuration: configuration, outcome: .completed, score: 1, responseTimes: [-1])
        XCTAssertThrowsError(try RecordBackup.encode([invalid]))
    }

    func testMergeIsIdempotentAndConflictRollsBackEntireImport() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("records.sqlite")
        let original = SessionRecord(configuration: configuration, outcome: .completed, score: 10)
        let added = SessionRecord(configuration: configuration, outcome: .completed, score: 20)
        let later = SessionRecord(configuration: configuration, outcome: .completed, score: 30)
        let conflict = SessionRecord(id: original.id, configuration: configuration, outcome: .completed,
            finishedAt: original.finishedAt, score: 999)
        do {
            let store = try RecordStore(url: url)
            try store.insert(original)
            XCTAssertEqual(try store.importRecords([original, added, added]), 1)
            XCTAssertEqual(try store.importRecords([original, added]), 0)
            XCTAssertThrowsError(try store.importRecords([later, conflict]))
        }
        let reopened = try RecordStore(url: url).allRecords()
        XCTAssertEqual(Set(reopened.map(\.id)), Set([original.id, added.id]))
        XCTAssertTrue(reopened.contains(original))
        XCTAssertThrowsError(try RecordBackup.encode([original, conflict]))
    }
    @MainActor
    func testManagerExportsAndImportsSavedRecords() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let first = RecordsManager(databaseURL: directory.appendingPathComponent("first.sqlite"))
        let second = RecordsManager(databaseURL: directory.appendingPathComponent("second.sqlite"))
        let record = SessionRecord(configuration: configuration, outcome: .completed, score: 25, responseTimes: [1.5])
        XCTAssertTrue(first.save(record))
        let data = try first.exportBackup()
        XCTAssertEqual(try second.importBackup(data), 1)
        XCTAssertEqual(try second.importBackup(data), 0)
        XCTAssertEqual(second.records, [record])
    }

}
