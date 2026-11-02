import Foundation
import Combine

@MainActor
final class RecordsManager: ObservableObject {
    @Published private(set) var records: [SessionRecord] = []
    @Published private(set) var loadError: String?
    private let databaseURL: URL

    init(databaseURL: URL) {
        self.databaseURL = databaseURL
        reload()
    }

    static func makeDefault() -> RecordsManager {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        let testNames = [("--ui-test-letter-speed", "letter"), ("--ui-test-arithmetic-fast", "arithmetic"), ("--ui-test-pro", "pro"), ("--ui-test-sequence", "sequence"), ("--ui-test-optiver", "optiver"), ("--ui-test-memory", "memory"), ("--ui-test-risk", "risk"), ("--ui-test-flexibility", "flexibility")]
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
            loadError = nil
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
            loadError = nil
            return true
        } catch {
            loadError = "Your result could not be saved. Please try again."
            return false
        }
    }
}
