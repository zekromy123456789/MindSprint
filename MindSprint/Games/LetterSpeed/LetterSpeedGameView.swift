import SwiftUI

#if DEBUG
private final class LetterSpeedUITestClock: SessionClock {
    static let shared = LetterSpeedUITestClock()
    var now: TimeInterval = 0
}
#endif

struct LetterSpeedGameView: View {
    let difficulty: Difficulty
    @State private var round: LetterSpeedRound
    @Environment(\.scenePhase) private var scenePhase
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init(difficulty: Difficulty = .classic) {
        self.difficulty = difficulty
        _round = State(initialValue: Self.makeRound(difficulty))
    }

    private static func makeRound(_ difficulty: Difficulty) -> LetterSpeedRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-letter-speed") {
            return LetterSpeedRound(difficulty: difficulty, clock: LetterSpeedUITestClock.shared, seed: 42)
        }
        #endif
        return LetterSpeedRound(difficulty: difficulty)
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
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-letter-speed") {
                        Button("Start test round") {
                            LetterSpeedUITestClock.shared.now += LetterSpeedRound.countdownDuration
                            round.refresh()
                        }
                    }
                    #endif
                }
            case .active:
                if let question = round.question { active(question) }
            case .completed:
                results
            case .abandoned:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Letter Speed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start() }
        .onDisappear { round.abandon() }
        .onReceive(tick) { _ in
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-letter-speed") { return }
            #endif
            round.refresh()
        }
        .onChange(of: scenePhase) { _, phase in if phase == .active { round.refresh() } }
    }

    private func active(_ question: LetterQuestion) -> some View {
        let token = round.questionID
        return ScrollView {
            VStack(spacing: 18) {
                HStack {
                    Text("Score: \(round.score)").accessibilityIdentifier("letter-score")
                    Spacer()
                    Text("\(Int(ceil(round.remaining)))s").monospacedDigit()
                        .accessibilityLabel("\(Int(ceil(round.remaining))) seconds remaining")
                        .accessibilityIdentifier("letter-time")
                }.font(.headline)
                Text(difficulty.rawValue.capitalized).font(.footnote).foregroundStyle(.secondary)
                    .accessibilityIdentifier("letter-level")
                Text("Round \(round.roundNumber) / \(LetterSpeedRound.questionCount)")
                    .font(.subheadline).foregroundStyle(.secondary)
                    .accessibilityIdentifier("letter-progress")
                Text(question.target == .highest ? "Choose the highest total" : "Choose the lowest total")
                    .font(.title3.bold()).multilineTextAlignment(.center)
                    .accessibilityIdentifier("letter-prompt")
                    .accessibilityValue(testAnswer(question))
                Text("A = 1, B = 2 … Z = 26. For pairs, subtract the smaller value from the larger; add the rows.")
                    .font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
                HStack(alignment: .top, spacing: 6) {
                    ForEach(question.choices.indices, id: \.self) { index in
                        Button { _ = round.choose(index, forQuestion: token) } label: {
                            VStack(spacing: 4) {
                                Text("\(index + 1)").font(.headline).padding(.bottom, 3)
                                ForEach(question.choices[index].rows.indices, id: \.self) { rowIndex in
                                    let row = question.choices[index].rows[rowIndex]
                                    HStack(spacing: 2) {
                                        Text(LetterRow.display(row.first)).frame(maxWidth: .infinity)
                                        Text(LetterRow.display(row.second)).frame(maxWidth: .infinity)
                                    }
                                    .font(.system(.body, design: .monospaced).weight(.medium))
                                    .lineLimit(1).minimumScaleFactor(0.7)
                                }
                            }
                            .padding(.vertical, 10).padding(.horizontal, 3)
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.teal.opacity(0.5)))
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel(choiceLabel(question.choices[index], index: index))
                        .accessibilityIdentifier("letter-choice-\(index)")
                    }
                }
                #if DEBUG
                if ProcessInfo.processInfo.arguments.contains("--ui-test-letter-speed") {
                    Button("Expire test question") {
                        LetterSpeedUITestClock.shared.now += LetterSpeedRound.questionDuration
                        round.refresh()
                    }.font(.footnote)
                }
                #endif
            }
            .padding()
            .frame(maxWidth: 650)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func choiceLabel(_ choice: LetterChoice, index: Int) -> String {
        let rows = choice.rows.enumerated().map { index, row in
            let first = row.first.map { LetterRow.display($0) } ?? "blank"
            let second = row.second.map { LetterRow.display($0) } ?? "blank"
            return "row \(index + 1), \(first), \(second)"
        }.joined(separator: "; ")
        return "Choice \(index + 1), \(rows)"
    }

    private var results: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Session complete").font(.title2.bold())
                Text("Score: \(round.score)").font(.largeTitle.bold().monospacedDigit())
                    .accessibilityIdentifier("letter-final-score")
                Text("out of 300 points").foregroundStyle(.secondary)
                Button("Play again", action: replay).buttonStyle(.borderedProminent)
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(round.results.indices, id: \.self) { index in
                        let result = round.results[index]
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Round \(index + 1) · \(result.points) points").font(.headline)
                            Text(result.timedOut ? "Time expired" : "Your choice: \((result.selectedIndex ?? 0) + 1)")
                            Text("Correct choice: \(result.question.correctIndex + 1) · Total: \(result.question.choices[result.question.correctIndex].value)")
                        }
                        .font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12).background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                        .accessibilityElement(children: .combine)
                        .accessibilityIdentifier("letter-result-\(index)")
                    }
                }
            }.padding()
        }
    }

    private func testAnswer(_ question: LetterQuestion) -> String {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-letter-speed") { return String(question.correctIndex) }
        #endif
        return ""
    }

    private func replay() {
        var next = Self.makeRound(difficulty)
        next.start()
        round = next
    }
}
