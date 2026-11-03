import Foundation

enum RecordBackupError: Error {
    case unsupportedVersion(Int)
    case invalidRecord
    case conflictingRecord
    case unsavedRecords
    case fileTooLarge
}

// Backups describe records, not a copy of the database or its internal schema.
struct RecordBackup: Codable {
    static let currentVersion = 1
    static let maxBytes = 10 * 1024 * 1024
    let version: Int
    let records: [SessionRecord]

    static func encode(_ records: [SessionRecord]) throws -> Data {
        try validate(records)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(RecordBackup(version: currentVersion, records: records))
        guard data.count <= maxBytes else { throw RecordBackupError.fileTooLarge }
        return data
    }

    static func decode(_ data: Data) throws -> [SessionRecord] {
        guard data.count <= maxBytes else { throw RecordBackupError.fileTooLarge }
        let backup = try JSONDecoder().decode(RecordBackup.self, from: data)
        guard backup.version == currentVersion else { throw RecordBackupError.unsupportedVersion(backup.version) }
        try validate(backup.records)
        return backup.records
    }

    private static func validate(_ records: [SessionRecord]) throws {
        var seen: [UUID: SessionRecord] = [:]
        for record in records {
            guard record.isValid else { throw RecordBackupError.invalidRecord }
            if let previous = seen[record.id], previous != record { throw RecordBackupError.conflictingRecord }
            seen[record.id] = record
        }
    }
}
