import SwiftUI

#if DEBUG
// Speeds up the complete-round UI test without changing release gameplay.
private struct ArithmeticUITestClock: SessionClock {
    private let base = MonotonicSessionClock()
    var now: TimeInterval { base.now * 4 }
}
#endif

struct ArithmeticGameView: View {
    let difficulty: Difficulty
    @State private var round: ArithmeticRound
    @State private var input = NumericInput(allowsNegative: true, allowsDecimal: false, maxDigits: 8)
    @Environment(\.scenePhase) private var scenePhase
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        _round = State(initialValue: Self.makeRound(difficulty))
    }

    private static func makeRound(_ difficulty: Difficulty) -> ArithmeticRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-arithmetic-fast") {
            return ArithmeticRound(difficulty: difficulty, clock: ArithmeticUITestClock(), seed: 42)
        }
        #endif
        return ArithmeticRound(difficulty: difficulty)
    }

    var body: some View {
        Group {
            switch round.phase {
            case .ready, .countdown:
                VStack(spacing: 12) {
                    Text("Get ready").font(.title2.bold())
                    Text("\(max(1, Int(ceil(round.countdownRemaining))))")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .accessibilityIdentifier("arithmetic-countdown")
                }
            case .active:
                if let question = round.question {
                    ActiveGameLayout(score: "Score: \(round.score)", time: formattedTime) {
                        VStack(spacing: 14) {
                            HStack(spacing: 8) {
                                Text("\(question.first)").accessibilityIdentifier("arithmetic-first")
                                Text(question.operation.symbol).accessibilityIdentifier("arithmetic-operation")
                                Text("\(question.second)").accessibilityIdentifier("arithmetic-second")
                            }
                            .font(.largeTitle.bold()).monospacedDigit()
                            Text(input.text.isEmpty ? "?" : input.text)
                                .font(.title.monospacedDigit())
                                .accessibilityLabel("Answer: \(input.text.isEmpty ? "empty" : input.text)")
                                .accessibilityIdentifier("arithmetic-answer")
                        }
                    } controls: {
                        NumericKeypad(input: $input, automatic: true, onInputChanged: answerChanged, onSubmit: { _ in })
                    }
                }
            case .completed:
                VStack(spacing: 16) {
                    Text("Session complete").font(.title2.bold())
                    Text("\(round.score)").font(.largeTitle.bold()).monospacedDigit()
                        .accessibilityIdentifier("arithmetic-final-score")
                    Text("Correct answers").foregroundStyle(.secondary)
                    Button("Play again", action: replay).buttonStyle(.borderedProminent)
                }
            case .abandoned:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Arithmetic")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start() }
        .onDisappear { round.abandon() }
        .onReceive(tick) { _ in round.refresh() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { round.refresh() }
        }
    }

    private var formattedTime: String {
        let seconds = Int(ceil(round.remaining))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func answerChanged(_ text: String) {
        let id = round.questionID
        if round.accept(text, forQuestion: id) { input.reset() }
    }

    private func replay() {
        input.reset()
        var next = Self.makeRound(difficulty)
        next.start()
        round = next
    }
}
