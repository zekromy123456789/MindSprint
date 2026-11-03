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

    // Some file providers do not report a size. Read incrementally so those
    // files still work without loading an unbounded amount into memory.
    static func readFile(at url: URL) throws -> Data {
        if let size = (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize, size > maxBytes {
            throw RecordBackupError.fileTooLarge
        }
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }
        var data = Data()
        while data.count <= maxBytes {
            let chunk = try handle.read(upToCount: min(64 * 1024, maxBytes + 1 - data.count)) ?? Data()
            if chunk.isEmpty { return data }
            data.append(chunk)
        }
        throw RecordBackupError.fileTooLarge
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
