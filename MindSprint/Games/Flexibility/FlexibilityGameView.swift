import SwiftUI

#if DEBUG
private final class FlexibilityUITestClock: SessionClock {
    static let shared = FlexibilityUITestClock()
    var now: TimeInterval = 0
}
#endif

struct FlexibilityGameView: View {
    @State private var round: FlexibilityRound
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var records: RecordsManager
    @State private var savedSessionID: UUID?
    @State private var saveFailed = false
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init() { _round = State(initialValue: Self.makeRound()) }

    private static func makeRound() -> FlexibilityRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-flexibility") {
            return FlexibilityRound(clock: FlexibilityUITestClock.shared, seed: 42)
        }
        #endif
        return FlexibilityRound()
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
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-flexibility") {
                        Button("Start test round") {
                            FlexibilityUITestClock.shared.now += FlexibilityRound.countdownDuration
                            round.refresh()
                        }
                    }
                    #endif
                }
            case .active:
                if let question = round.question {
                    let token = round.questionID
                    ActiveGameLayout(score: "Score: \(round.score)", time: formattedTime) {
                        VStack(spacing: 18) {
                            Text("Does the left word match the right ink color?")
                                .font(.headline).multilineTextAlignment(.center)
                                .accessibilityIdentifier("flexibility-prompt")
                                .accessibilityValue(testAnswer(question))
                            HStack(spacing: 12) {
                                card(word: question.leftWord, ink: question.leftColor, side: "Left")
                                card(word: question.rightWord, ink: question.rightColor, side: "Right")
                            }
                            #if DEBUG
                            if ProcessInfo.processInfo.arguments.contains("--ui-test-flexibility") {
                                Button("Finish test round") {
                                    FlexibilityUITestClock.shared.now += FlexibilityRound.roundDuration
                                    round.refresh()
                                }.font(.footnote)
                            }
                            #endif
                        }
                    } controls: {
                        HStack(spacing: 12) {
                            Button { answer(false, token: token) } label: {
                                Text("No").font(.headline).frame(maxWidth: .infinity, minHeight: 64)
                            }.buttonStyle(.bordered)
                            Button { answer(true, token: token) } label: {
                                Text("Yes").font(.headline).frame(maxWidth: .infinity, minHeight: 64)
                            }.buttonStyle(.borderedProminent)
                        }
                    }
                    .background {
                        FlexibilityKeyReceiver(isActive: true) { answer($0, token: token) }
                            .frame(width: 1, height: 1).opacity(0.01)
                    }
                }
            case .completed:
                VStack(spacing: 16) {
                    Text("Session complete").font(.title2.bold())
                    Text("\(round.score)").font(.largeTitle.bold().monospacedDigit())
                        .accessibilityIdentifier("flexibility-final-score")
                    Text("Points").foregroundStyle(.secondary)
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
        .navigationTitle("Flexibility")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start(); HapticFeedback.shared.prepare() }
        .onDisappear { round.abandon(); saveCompletedRound() }
        .onChange(of: round.phase) { _, phase in if phase == .completed { saveCompletedRound() } }
        .onReceive(tick) { _ in
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-flexibility") { return }
            #endif
            round.refresh()
        }
        .onChange(of: scenePhase) { _, phase in if phase == .active { round.refresh() } }
    }

    private func card(word: FlexibilityColor, ink: FlexibilityColor, side: String) -> some View {
        Text(word.rawValue.uppercased())
            .font(.title2.bold()).minimumScaleFactor(0.65).lineLimit(1)
            .foregroundStyle(color(ink))
            .frame(maxWidth: .infinity, minHeight: 110)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(.secondary.opacity(0.3)))
            .accessibilityLabel("\(side) word \(word.rawValue), in \(ink.rawValue) ink")
            .accessibilityIdentifier("flexibility-\(side.lowercased())-card")
    }

    private func color(_ ink: FlexibilityColor) -> Color {
        switch ink { case .blue: return .blue; case .black: return .black; case .red: return .red }
    }

    private func testAnswer(_ question: FlexibilityQuestion) -> String {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-flexibility") { return question.isMatch ? "Yes" : "No" }
        #endif
        return ""
    }

    private var formattedTime: String {
        let seconds = Int(ceil(round.remaining))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func answer(_ matches: Bool, token: Int) {
        let correct = round.question?.isMatch == matches
        if round.answer(matches, forQuestion: token) {
            HapticFeedback.shared.result(correct ? .success : .error, enabled: hapticsEnabled)
        }
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
        var next = Self.makeRound()
        next.start()
        round = next
    }
}
