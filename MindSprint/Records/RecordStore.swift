import Foundation
import SQLite3

enum RecordStoreError: Error {
    case database(String)
    case unsupportedSchema(Int32)
    case invalidRecord
}

// One instance is used on one thread at a time. Callers handle failures rather
// than silently losing records or replacing a database from a newer version.
final class RecordStore {
    private var database: OpaquePointer?
    private let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    private static let schemaVersion: Int32 = 1

    init(url: URL) throws {
        let result = sqlite3_open_v2(url.path, &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil)
        guard result == SQLITE_OK else {
            let message = database.map { String(cString: sqlite3_errmsg($0)) } ?? "Unable to open database"
            if let database { sqlite3_close(database) }
            database = nil
            throw RecordStoreError.database(message)
        }
        do { try prepareSchema() } catch {
            if let database { sqlite3_close(database) }
            database = nil
            throw error
        }
    }

    deinit { if let database { sqlite3_close(database) } }

    private func prepareSchema() throws {
        guard let database else { throw RecordStoreError.database("Database is closed") }
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, "PRAGMA user_version", -1, &statement, nil) == SQLITE_OK else { throw failure() }
        defer { sqlite3_finalize(statement) }
        guard sqlite3_step(statement) == SQLITE_ROW else { throw failure() }
        let version = sqlite3_column_int(statement, 0)
        sqlite3_finalize(statement)
        statement = nil
        guard version >= 0, version <= Self.schemaVersion else { throw RecordStoreError.unsupportedSchema(version) }
        if version == 0 {
            try execute("BEGIN IMMEDIATE TRANSACTION")
            do {
                try execute("CREATE TABLE session_records (id TEXT PRIMARY KEY NOT NULL, payload BLOB NOT NULL)")
                try execute("PRAGMA user_version = 1")
                try execute("COMMIT")
            } catch {
                try? execute("ROLLBACK")
                throw error
            }
        }
    }

    func insert(_ record: SessionRecord) throws {
        guard record.isValid else { throw RecordStoreError.invalidRecord }
        guard let database else { throw RecordStoreError.database("Database is closed") }
        let payload = try JSONEncoder().encode(record)
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, "INSERT INTO session_records (id, payload) VALUES (?, ?)", -1, &statement, nil) == SQLITE_OK else { throw failure() }
        defer { sqlite3_finalize(statement) }
        guard sqlite3_bind_text(statement, 1, record.id.uuidString, -1, transient) == SQLITE_OK else { throw failure() }
        let bound = payload.withUnsafeBytes { buffer in
            sqlite3_bind_blob(statement, 2, buffer.baseAddress, Int32(buffer.count), transient)
        }
        guard bound == SQLITE_OK, sqlite3_step(statement) == SQLITE_DONE else { throw failure() }
    }

    // Retrying the same finished session is harmless; a conflicting payload
    // with the same identifier is never silently substituted.
    @discardableResult
    func insertOnce(_ record: SessionRecord) throws -> Bool {
        guard record.isValid else { throw RecordStoreError.invalidRecord }
        if let existing = try allRecords().first(where: { $0.id == record.id }) {
            guard existing == record else { throw RecordStoreError.invalidRecord }
            return false
        }
        try insert(record)
        return true
    }

    // Merge atomically: identical IDs are skipped, conflicting IDs reject the
    // entire import, and a failure leaves the existing database unchanged.
    @discardableResult
    func importRecords(_ imported: [SessionRecord]) throws -> Int {
        try execute("BEGIN IMMEDIATE TRANSACTION")
        do {
            var existing = Dictionary(uniqueKeysWithValues: try allRecords().map { ($0.id, $0) })
            var count = 0
            for record in imported {
                guard record.isValid else { throw RecordStoreError.invalidRecord }
                if let prior = existing[record.id] {
                    guard prior == record else { throw RecordBackupError.conflictingRecord }
                    continue
                }
                try insert(record)
                existing[record.id] = record
                count += 1
            }
            try execute("COMMIT")
            return count
        } catch {
            try? execute("ROLLBACK")
            throw error
        }
    }

    func allRecords() throws -> [SessionRecord] {
        guard let database else { throw RecordStoreError.database("Database is closed") }
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, "SELECT payload FROM session_records", -1, &statement, nil) == SQLITE_OK else { throw failure() }
        defer { sqlite3_finalize(statement) }
        var records: [SessionRecord] = []
        while true {
            let step = sqlite3_step(statement)
            if step == SQLITE_DONE { break }
            guard step == SQLITE_ROW, let bytes = sqlite3_column_blob(statement, 0) else { throw failure() }
            let length = Int(sqlite3_column_bytes(statement, 0))
            let record = try JSONDecoder().decode(SessionRecord.self, from: Data(bytes: bytes, count: length))
            guard record.isValid else { throw RecordStoreError.invalidRecord }
            records.append(record)
        }
        return records.sorted { a, b in
            if a.finishedAt != b.finishedAt { return a.finishedAt > b.finishedAt }
            return a.id.uuidString < b.id.uuidString
        }
    }

    private func execute(_ sql: String) throws {
        guard let database else { throw RecordStoreError.database("Database is closed") }
        guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else { throw failure() }
    }

    private func failure() -> RecordStoreError {
        .database(database.map { String(cString: sqlite3_errmsg($0)) } ?? "Database is closed")
    }
}
