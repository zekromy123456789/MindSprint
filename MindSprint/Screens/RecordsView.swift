import SwiftUI

private enum HistoryFilter: String, CaseIterable {
    case completed = "Completed"
    case abandoned = "Abandoned"
}

struct RecordsView: View {
    @EnvironmentObject private var records: RecordsManager
    @State private var game: GameID = .letterSpeed
    @State private var difficulty: Difficulty = .classic
    @State private var historyFilter: HistoryFilter = .completed

    private var configuration: RecordConfiguration {
        switch game {
        case .arithmetic, .arithmeticPro, .sequence:
            return RecordConfiguration(game: game, difficulty: difficulty, mode: "timed", rulesVersion: 1, durationLimit: 120)
        case .memory:
            return RecordConfiguration(game: .memory, difficulty: difficulty, mode: "three-stage", rulesVersion: 1, durationLimit: nil)
        case .risk:
            return RecordConfiguration(game: .risk, difficulty: difficulty, mode: "20-balloon", rulesVersion: 1, durationLimit: nil)
        case .flexibility:
            return RecordConfiguration(game: .flexibility, difficulty: difficulty, mode: "timed", rulesVersion: 1, durationLimit: 60)
        case .optiver:
            return RecordConfiguration(game: .optiver, difficulty: difficulty, mode: "timed-80", rulesVersion: 1, durationLimit: 480)
        default:
            return RecordConfiguration(game: .letterSpeed, difficulty: difficulty, mode: "ten-round", rulesVersion: 1, durationLimit: 30)
        }
    }
    private var difficulties: [Difficulty] {
        switch game {
        case .arithmeticPro: return [.easy, .normal, .hard, .expert]
        case .memory, .risk, .flexibility: return [.classic]
        default: return Difficulty.allCases
        }
    }
    private var attempts: [SessionRecord] {
        let outcome: RecordOutcome = historyFilter == .completed ? .completed : .abandoned
        return records.records.filter { $0.configuration == configuration && $0.outcome == outcome }
    }
    private var summary: RecordSummary { RecordSummary(records: records.records, configuration: configuration) }

    var body: some View {
        List {
            Section("Game and difficulty") {
                Picker("Game", selection: $game) {
                    Text("Letter Speed").tag(GameID.letterSpeed)
                    Text("Arithmetic").tag(GameID.arithmetic)
                    Text("Arithmetic Pro").tag(GameID.arithmeticPro)
                    Text("Sequence").tag(GameID.sequence)
                    Text("Optiver 80 in 8").tag(GameID.optiver)
                    Text("Memory").tag(GameID.memory)
                    Text("Risk").tag(GameID.risk)
                    Text("Flexibility").tag(GameID.flexibility)
                }.accessibilityIdentifier("records-game")
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(difficulties, id: \.self) { level in
                        Text(level.rawValue.capitalized).tag(level)
                    }
                }.accessibilityIdentifier("records-difficulty")
                if let error = records.loadError {
                    Text(error).foregroundStyle(.red)
                    if records.pendingCount > 0 {
                        Button("Retry saving") { records.retryPending() }
                    } else {
                        Button("Try again") { records.reload() }
                    }
                } else if summary.completedCount == 0 {
                    Text("No completed sessions at this difficulty yet.").foregroundStyle(.secondary)
                        .accessibilityIdentifier("records-empty")
                } else {
                    LabeledContent("Personal best", value: "\(summary.bestScore ?? 0)")
                        .accessibilityIdentifier("records-best")
                    LabeledContent("Completed sessions", value: "\(summary.completedCount)")
                        .accessibilityIdentifier("records-count")
                    if let average = summary.averageScore {
                        LabeledContent("Average score", value: average.formatted(.number.precision(.fractionLength(1))))
                    }
                }
            }
            Section("History") {
                Picker("Show", selection: $historyFilter) {
                    ForEach(HistoryFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }.accessibilityIdentifier("records-outcome")
                if attempts.isEmpty {
                    Text(historyFilter == .completed ? "No completed sessions to show." : "No abandoned sessions to show.")
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("records-history-empty")
                }
            }
            if !attempts.isEmpty {
                Section("Recent sessions") {
                    ForEach(attempts) { record in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(record.finishedAt, style: .date)
                                if record.outcome == .abandoned { Text("Abandoned").font(.caption).foregroundStyle(.secondary) }
                            }
                            Spacer()
                            Text("\(record.score) points").bold().monospacedDigit()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityIdentifier("record-\(record.id.uuidString)")
                    }
                }
            }
        }
        .navigationTitle("Records")
        .onAppear { records.reload() }
        .onChange(of: game) { _, selected in
            difficulty = selected == .arithmeticPro ? .normal : .classic
        }
    }
}
