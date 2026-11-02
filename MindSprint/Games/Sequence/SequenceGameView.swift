import SwiftUI

#if DEBUG
// Speeds up the complete-round UI test without changing release gameplay.
private final class SequenceUITestClock: SessionClock {
    static let shared = SequenceUITestClock()
    var offset: TimeInterval = 0
    var now: TimeInterval { offset }
}
#endif

struct SequenceGameView: View {
    let difficulty: Difficulty
    @State private var round: SequenceRound
    @State private var input = NumericInput(allowsNegative: true, allowsDecimal: false, maxDigits: 8)
    @State private var showTimer = true
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var records: RecordsManager
    @State private var savedSessionID: UUID?
    @State private var saveFailed = false
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        _round = State(initialValue: Self.makeRound(difficulty))
    }

    private static func makeRound(_ difficulty: Difficulty) -> SequenceRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-sequence") {
            return SequenceRound(difficulty: difficulty, clock: SequenceUITestClock.shared, seed: 42)
        }
        #endif
        return SequenceRound(difficulty: difficulty)
    }

    var body: some View {
        Group {
            switch round.phase {
            case .ready, .countdown:
                VStack(spacing: 12) {
                    Text("Get ready").font(.title2.bold())
                    Text("\(max(1, Int(ceil(round.countdownRemaining))))")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .accessibilityIdentifier("sequence-countdown")
                    #if DEBUG
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-sequence") {
                        Button("Start test round") {
                            SequenceUITestClock.shared.offset += SequenceRound.countdownDuration
                            round.refresh()
                        }
                    }
                    #endif
                }
            case .active:
                if let question = round.question {
                    ActiveGameLayout(score: "Score: \(round.score)", time: showTimer ? formattedTime : nil) {
                        VStack(spacing: 14) {
                            Text(difficulty.rawValue.capitalized)
                                .font(.footnote).foregroundStyle(.secondary)
                                .accessibilityIdentifier("sequence-level")
                            Button(showTimer ? "Hide timer" : "Show timer") { showTimer.toggle() }
                                .font(.footnote)
                            #if DEBUG
                            if ProcessInfo.processInfo.arguments.contains("--ui-test-sequence") {
                                Button("Finish test round") {
                                    SequenceUITestClock.shared.offset += SequenceRound.roundDuration
                                    round.refresh()
                                }
                                .font(.footnote)
                            }
                            #endif
                            Text(question.visibleTerms.map { String($0) }.joined(separator: ", ") + ", ?")
                                .font(.title2.bold().monospacedDigit())
                                .minimumScaleFactor(0.6)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("sequence-question")
                                .accessibilityValue(testAnswer(question))
                            Text(input.text.isEmpty ? "?" : input.text)
                                .font(.title.monospacedDigit())
                                .accessibilityLabel("Answer: \(input.text.isEmpty ? "empty" : input.text)")
                                .accessibilityIdentifier("sequence-answer")
                        }
                    } controls: {
                        NumericKeypad(input: $input, automatic: true, onInputChanged: answerChanged, onSubmit: { _ in })
                    }
                }
            case .completed:
                VStack(spacing: 16) {
                    Text("Session complete").font(.title2.bold())
                    Text("\(round.score)").font(.largeTitle.bold()).monospacedDigit()
                        .accessibilityIdentifier("sequence-final-score")
                    Text("Correct answers").foregroundStyle(.secondary)
                    if let last = round.lastQuestion {
                        VStack(spacing: 5) {
                            Text("Last question").font(.headline)
                            Text(last.terms.map { String($0) }.joined(separator: ", "))
                                .font(.title3.monospacedDigit())
                                .minimumScaleFactor(0.6)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("sequence-last-question")
                        }
                    }
                    if saveFailed {
                        Text("Your result could not be saved.").foregroundStyle(.red)
                        Button("Retry saving", action: saveCompletedRound)
                    }
                    Button("Play again", action: replay).buttonStyle(.borderedProminent).disabled(saveFailed)
                }
            case .abandoned:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Sequence")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start() }
        .onDisappear { round.abandon(); saveCompletedRound() }
        .onChange(of: round.phase) { _, phase in if phase == .completed { saveCompletedRound() } }
        .onReceive(tick) { _ in
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-sequence") { return }
            #endif
            round.refresh()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { round.refresh() }
        }
    }

    private func testAnswer(_ question: SequenceQuestion) -> String {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-sequence") { return String(question.answer) }
        #endif
        return ""
    }

    private var formattedTime: String {
        let seconds = Int(ceil(round.remaining))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func answerChanged(_ text: String) {
        let id = round.questionID
        if round.accept(text, forQuestion: id) { input.reset() }
    }

    private func saveCompletedRound() {
        guard let record = round.terminalRecord, savedSessionID != record.id else { return }
        if records.save(record) {
            savedSessionID = record.id
            saveFailed = false
        } else {
            saveFailed = true
        }
    }

    private func replay() {
        input.reset()
        var next = Self.makeRound(difficulty)
        next.start()
        round = next
    }
}
