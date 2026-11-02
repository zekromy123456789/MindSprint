import SwiftUI

#if DEBUG
private final class OptiverUITestClock: SessionClock {
    static let shared = OptiverUITestClock()
    var offset: TimeInterval = 0
    var now: TimeInterval { offset }
}
#endif

struct OptiverGameView: View {
    let difficulty: Difficulty
    @State private var round: OptiverRound
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var records: RecordsManager
    @State private var savedSessionID: UUID?
    @State private var saveFailed = false
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        _round = State(initialValue: Self.makeRound(difficulty))
    }

    private static func makeRound(_ difficulty: Difficulty) -> OptiverRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-optiver") {
            return OptiverRound(difficulty: difficulty, clock: OptiverUITestClock.shared, seed: 42)
        }
        #endif
        return OptiverRound(difficulty: difficulty)
    }

    var body: some View {
        Group {
            switch round.phase {
            case .ready, .countdown:
                VStack(spacing: 12) {
                    Text("Get ready").font(.title2.bold())
                    Text("\(max(1, Int(ceil(round.countdownRemaining))))")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                    #if DEBUG
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-optiver") {
                        Button("Start test round") {
                            OptiverUITestClock.shared.offset += OptiverRound.countdownDuration
                            round.refresh()
                        }
                    }
                    #endif
                }
            case .active:
                if let question = round.currentQuestion {
                    let token = round.index
                    ActiveGameLayout(score: "Score: \(round.score)", time: formattedTime) {
                        VStack(spacing: 16) {
                            Text(difficulty.rawValue.capitalized).font(.footnote).foregroundStyle(.secondary)
                                .accessibilityIdentifier("optiver-level")
                            Text("Question \(token + 1) / \(OptiverRound.questionCount)")
                                .font(.subheadline).foregroundStyle(.secondary)
                                .accessibilityIdentifier("optiver-progress")
                            #if DEBUG
                            if ProcessInfo.processInfo.arguments.contains("--ui-test-optiver") {
                                Button("Finish test round") {
                                    OptiverUITestClock.shared.offset += OptiverRound.roundDuration
                                    round.refresh()
                                }.font(.footnote)
                            }
                            #endif
                            Text(question.prompt).font(.title.bold().monospacedDigit())
                                .minimumScaleFactor(0.6).lineLimit(2).multilineTextAlignment(.center)
                                .accessibilityIdentifier("optiver-question")
                                .accessibilityValue(testAnswer(question))
                        }
                    } controls: {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(question.choices, id: \.self) { choice in
                                Button { _ = round.choose(choice, forQuestion: token) } label: {
                                    Text(choice.text).font(.title3.bold().monospacedDigit())
                                        .frame(maxWidth: .infinity, minHeight: 60)
                                }
                                .buttonStyle(.borderedProminent)
                                .accessibilityIdentifier("optiver-choice-\(choice.hundredths)")
                            }
                        }
                    }
                }
            case .completed:
                results
            case .abandoned:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Optiver 80 in 8")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start() }
        .onDisappear { round.abandon(); saveCompletedRound() }
        .onChange(of: round.phase) { _, phase in if phase == .completed { saveCompletedRound() } }
        .onReceive(tick) { _ in
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-optiver") { return }
            #endif
            round.refresh()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { round.refresh() }
        }
    }

    private var results: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Session complete").font(.title2.bold())
                Text("Score: \(round.score)").font(.largeTitle.bold().monospacedDigit())
                    .accessibilityIdentifier("optiver-final-score")
                Text("\(round.index) of \(OptiverRound.questionCount) answered")
                    .foregroundStyle(.secondary).accessibilityIdentifier("optiver-answered")
                if saveFailed {
                    Text("Your result could not be saved.").foregroundStyle(.red)
                    Button("Retry saving", action: saveCompletedRound)
                }
                Button("Play again", action: replay).buttonStyle(.borderedProminent).disabled(saveFailed)
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(round.questions.indices, id: \.self) { i in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Question \(i + 1)").font(.caption).foregroundStyle(.secondary)
                                Text(round.questions[i].solvedPrompt).font(.subheadline.monospacedDigit())
                            }
                            Spacer()
                            Text(status(at: i)).font(.footnote)
                                .accessibilityIdentifier("optiver-result-\(i)")
                        }
                        .padding(10)
                        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
            }.padding()
        }
    }

    private func status(at index: Int) -> String {
        guard let correct = round.responses[index] else { return "Unanswered" }
        return correct ? "Correct" : "Incorrect"
    }

    private var formattedTime: String {
        let seconds = Int(ceil(round.remaining))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func testAnswer(_ question: OptiverQuestion) -> String {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-optiver") {
            return String(question.answer.hundredths)
        }
        #endif
        return ""
    }

    private func saveCompletedRound() {
        guard let record = round.completedRecord, savedSessionID != record.id else { return }
        if records.save(record) {
            savedSessionID = record.id
            saveFailed = false
        } else {
            saveFailed = true
        }
    }

    private func replay() {
        var next = Self.makeRound(difficulty)
        next.start()
        round = next
    }
}
