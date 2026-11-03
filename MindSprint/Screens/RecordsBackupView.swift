import SwiftUI
import UniformTypeIdentifiers

private struct BackupDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var data: Data
    init(data: Data) { self.data = data }
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
        self.data = data
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

struct RecordsBackupView: View {
    @EnvironmentObject private var records: RecordsManager
    @State private var document: BackupDocument?
    @State private var exporting = false
    @State private var importing = false
    @State private var message: String?
    private let maxBackupBytes = 10 * 1024 * 1024

    var body: some View {
        Form {
            Section("Your records") {
                Text("Export a JSON copy of your saved sessions. Import adds new sessions and keeps existing ones. If an ID conflicts, nothing is imported.")
                Button("Export backup") {
                    do {
                        document = BackupDocument(data: try records.exportBackup())
                        exporting = true
                    } catch { message = "Could not prepare the backup. Check that your records are saved and try again." }
                }
                Button("Import backup") { importing = true }
            }
            if let message { Section { Text(message) } }
        }
        .navigationTitle("Records backup")
        .fileExporter(isPresented: $exporting, document: document, contentType: .json,
                      defaultFilename: "MindSprint-records") { result in
            switch result {
            case .success: message = "Backup exported."
            case .failure: message = "Could not export the backup. Please try again."
            }
        }
        .fileImporter(isPresented: $importing, allowedContentTypes: [.json]) { result in
            do {
                let url = try result.get()
                let accessed = url.startAccessingSecurityScopedResource()
                defer { if accessed { url.stopAccessingSecurityScopedResource() } }
                let size = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize
                guard let size, size <= maxBackupBytes else { throw RecordBackupError.fileTooLarge }
                let data = try Data(contentsOf: url)
                guard data.count <= maxBackupBytes else { throw RecordBackupError.fileTooLarge }
                let count = try records.importBackup(data)
                message = "Imported \(count) new \(count == 1 ? "session" : "sessions"). Existing sessions were kept."
            } catch {
                message = "Import could not be completed. Check the file and your records, save any pending results, and try again."
            }
        }
    }
}
