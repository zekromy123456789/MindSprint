import Foundation
import Combine

@MainActor
final class RecordsManager: ObservableObject {
    @Published private(set) var records: [SessionRecord] = []
    @Published private(set) var loadError: String?
    private let databaseURL: URL
    private var pending: [UUID: SessionRecord] = [:]
    @Published private(set) var pendingCount = 0

    init(databaseURL: URL) {
        self.databaseURL = databaseURL
        reload()
    }

    static func makeDefault() -> RecordsManager {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("--ui-test-records-chart") {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("mindsprint-chart-ui-test.sqlite")
            if arguments.contains("--reset-ui-test-records") { try? FileManager.default.removeItem(at: url) }
            let manager = RecordsManager(databaseURL: url)
            if arguments.contains("--reset-ui-test-records") {
                let config = RecordConfiguration(game: .letterSpeed, difficulty: .classic,
                    mode: "ten-round", rulesVersion: 1, durationLimit: 30)
                for (score, time, outcome) in [(10, 1.0, RecordOutcome.completed), (25, 2.0, .completed), (999, 3.0, .abandoned)] {
                    _ = manager.save(SessionRecord(configuration: config, outcome: outcome,
                        finishedAt: Date(timeIntervalSince1970: time), score: score))
                }
            }
            return manager
        }
        let testNames = [("--ui-test-letter-speed", "letter"), ("--ui-test-arithmetic-fast", "arithmetic"), ("--ui-test-pro", "pro"), ("--ui-test-sequence", "sequence"), ("--ui-test-optiver", "optiver"), ("--ui-test-memory", "memory"), ("--ui-test-risk", "risk"), ("--ui-test-flexibility", "flexibility"), ("--ui-test-live-clock", "live-clock")]
        if let test = testNames.first(where: { arguments.contains($0.0) }) {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("mindsprint-\(test.1)-ui-test.sqlite")
            if ProcessInfo.processInfo.arguments.contains("--reset-ui-test-records") {
                try? FileManager.default.removeItem(at: url)
            }
            return RecordsManager(databaseURL: url)
        }
        #endif
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return RecordsManager(databaseURL: directory.appendingPathComponent("MindSprint/records.sqlite"))
    }

    func reload() {
        do {
            try FileManager.default.createDirectory(at: databaseURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            records = try RecordStore(url: databaseURL).allRecords()
            loadError = pending.isEmpty ? nil : "Some results could not be saved. Please try again."
        } catch {
            loadError = "Records could not be loaded. Please try again."
        }
    }

    @discardableResult
    func save(_ record: SessionRecord) -> Bool {
        do {
            try FileManager.default.createDirectory(at: databaseURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            let store = try RecordStore(url: databaseURL)
            try store.insertOnce(record)
            records = try store.allRecords()
            pending.removeValue(forKey: record.id)
            pendingCount = pending.count
            loadError = pending.isEmpty ? nil : "Some results could not be saved. Please try again."
            return true
        } catch {
            pending[record.id] = record
            pendingCount = pending.count
            loadError = "Some results could not be saved. Please try again."
            return false
        }
    }

    func retryPending() {
        for record in Array(pending.values) { _ = save(record) }
        if pending.isEmpty { reload() }
    }
}
