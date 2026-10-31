import SwiftUI

#if DEBUG
// Speeds up the complete-round UI test without changing release gameplay.
private final class ArithmeticProUITestClock: SessionClock {
    static let shared = ArithmeticProUITestClock()
    private let base = MonotonicSessionClock()
    var offset: TimeInterval = 0
    var now: TimeInterval { base.now + offset }
}
#endif

struct ArithmeticProGameView: View {
    @State private var round: ArithmeticProRound
    @State private var input = NumericInput(allowsNegative: true, allowsDecimal: false, maxDigits: 8)
    @State private var showTimer = true
    @Environment(\.scenePhase) private var scenePhase
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init() {
        _round = State(initialValue: Self.makeRound())
    }

    private static func makeRound() -> ArithmeticProRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-pro") {
            return ArithmeticProRound(clock: ArithmeticProUITestClock.shared, seed: 42)
        }
        #endif
        return ArithmeticProRound()
    }

    var body: some View {
        Group {
            switch round.phase {
            case .ready, .countdown:
                VStack(spacing: 12) {
                    Text("Get ready").font(.title2.bold())
                    Text("\(max(1, Int(ceil(round.countdownRemaining))))")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .accessibilityIdentifier("pro-countdown")
                }
            case .active:
                if let question = round.question {
                    ActiveGameLayout(score: "Score: \(round.score)", time: showTimer ? formattedTime : nil) {
                        VStack(spacing: 14) {
                            Button(showTimer ? "Hide timer" : "Show timer") { showTimer.toggle() }
                                .font(.footnote)
                            #if DEBUG
                            if ProcessInfo.processInfo.arguments.contains("--ui-test-pro") {
                                Button("Finish test round") {
                                    ArithmeticProUITestClock.shared.offset += ArithmeticProRound.roundDuration
                                    round.refresh()
                                }
                                .font(.footnote)
                            }
                            #endif
                            Text(question.prompt)
                                .font(.title2.bold().monospacedDigit())
                                .minimumScaleFactor(0.6)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("pro-question")
                                .accessibilityValue(testAnswer(question))
                            Text(input.text.isEmpty ? "?" : input.text)
                                .font(.title.monospacedDigit())
                                .accessibilityLabel("Answer: \(input.text.isEmpty ? "empty" : input.text)")
                                .accessibilityIdentifier("pro-answer")
                        }
                    } controls: {
                        NumericKeypad(input: $input, automatic: true, onInputChanged: answerChanged, onSubmit: { _ in })
                    }
                }
            case .completed:
                VStack(spacing: 16) {
                    Text("Session complete").font(.title2.bold())
                    Text("\(round.score)").font(.largeTitle.bold()).monospacedDigit()
                        .accessibilityIdentifier("pro-final-score")
                    Text("Correct answers").foregroundStyle(.secondary)
                    if let last = round.lastQuestion {
                        VStack(spacing: 5) {
                            Text("Last question").font(.headline)
                            Text("\(last.prompt) = \(last.answer)")
                                .font(.title3.monospacedDigit())
                                .minimumScaleFactor(0.6)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("pro-last-question")
                        }
                    }
                    Button("Play again", action: replay).buttonStyle(.borderedProminent)
                }
            case .abandoned:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Arithmetic Pro")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start() }
        .onDisappear { round.abandon() }
        .onReceive(tick) { _ in round.refresh() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { round.refresh() }
        }
    }

    private func testAnswer(_ question: ArithmeticProQuestion) -> String {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-pro") { return String(question.answer) }
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

    private func replay() {
        input.reset()
        var next = Self.makeRound()
        next.start()
        round = next
    }
}
