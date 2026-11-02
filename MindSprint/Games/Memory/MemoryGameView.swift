import SwiftUI

#if DEBUG
private final class MemoryUITestClock: SessionClock {
    static let shared = MemoryUITestClock()
    var now: TimeInterval = 0
}
#endif

struct MemoryGameView: View {
    @State private var round: MemoryRound
    @State private var input = NumericInput(allowsNegative: false, allowsDecimal: false, maxDigits: 3)
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var records: RecordsManager
    @State private var savedSessionID: UUID?
    @State private var saveFailed = false
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init() { _round = State(initialValue: Self.makeRound()) }

    private static func makeRound() -> MemoryRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-memory") {
            return MemoryRound(clock: MemoryUITestClock.shared, seed: 42)
        }
        #endif
        return MemoryRound()
    }

    var body: some View {
        Group {
            switch round.phase {
            case .instructions:
                VStack(spacing: 16) {
                    Text("Round \(round.stage.rawValue + 1) / 3").font(.title2.bold())
                    Text(round.stage.instruction).multilineTextAlignment(.center)
                    Text("You have two attempts at each length.").foregroundStyle(.secondary)
                    Button("Start round") { round.beginStage() }.buttonStyle(.borderedProminent)
                }.padding()
            case .countdown:
                VStack(spacing: 12) {
                    Text("Get ready").font(.title2.bold())
                    Text("\(max(1, Int(ceil(round.countdownRemaining))))")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                    #if DEBUG
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-memory") {
                        Button("Start test presentation") {
                            MemoryUITestClock.shared.now += MemoryRound.countdownDuration
                            round.refresh()
                        }
                    }
                    #endif
                }
            case .presenting:
                VStack(spacing: 20) {
                    status
                    Text("Watch the digits").font(.headline)
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 48), spacing: 8)], spacing: 8) {
                                ForEach(round.digits.indices, id: \.self) { index in
                                    let visible = round.visibleIndex == index
                                    Text(visible ? String(round.digits[index]) : "•")
                                        .font(.title.bold().monospacedDigit())
                                        .frame(maxWidth: .infinity, minHeight: 64)
                                        .background(.teal.opacity(0.14), in: RoundedRectangle(cornerRadius: 10))
                                        .accessibilityLabel(visible ? "Digit \(index + 1): \(round.digits[index])" : "Digit \(index + 1): hidden")
                                        .accessibilityIdentifier("memory-digit-\(index)")
                                        .id(index)
                                }
                            }
                        }
                        .onChange(of: round.visibleIndex) { _, index in
                            if let index { proxy.scrollTo(index, anchor: .center) }
                        }
                    }.frame(maxHeight: 260)
                    #if DEBUG
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-memory") {
                        Button("Advance test playback") {
                            MemoryUITestClock.shared.now += MemoryRound.digitDuration
                            round.refresh()
                        }
                        Button("Finish test presentation") {
                            MemoryUITestClock.shared.now += MemoryRound.leadIn + Double(round.length) * MemoryRound.digitDuration
                            round.refresh()
                        }
                    }
                    #endif
                }.padding()
            case .recall:
                ActiveGameLayout(score: "Score: \(round.score)", time: nil) {
                    VStack(spacing: 12) {
                        status
                        Text(round.stage.instruction).font(.headline).multilineTextAlignment(.center)
                        Text(input.text.isEmpty ? "?" : input.text)
                            .font(.title.monospacedDigit())
                            .accessibilityLabel("Answer: \(input.text.isEmpty ? "empty" : input.text)")
                            .accessibilityIdentifier("memory-answer")
                            .accessibilityValue(testAnswer)
                    }
                } controls: {
                    NumericKeypad(input: $input, onSubmit: submit)
                }
            case .completed:
                VStack(spacing: 16) {
                    Text("Session complete").font(.title2.bold())
                    Text("\(round.score)").font(.largeTitle.bold().monospacedDigit())
                        .accessibilityIdentifier("memory-final-score")
                    Text("Correct sequences").foregroundStyle(.secondary)
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
        .navigationTitle("Memory")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { if scenePhase != .active { round.suspend() } }
        .onDisappear { round.abandon(); saveCompletedRound() }
        .onChange(of: round.phase) { _, phase in if phase == .completed { saveCompletedRound() } }
        .onReceive(tick) { _ in
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-memory") { return }
            #endif
            round.refresh()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { round.resume(); round.refresh() } else { round.suspend() }
        }
    }

    private var status: some View {
        Text("Round \(round.stage.rawValue + 1) / 3 · Attempt \(round.attempt) / 2 · \(round.length) digits")
            .font(.subheadline).foregroundStyle(.secondary)
            .accessibilityIdentifier("memory-status")
    }

    private var testAnswer: String {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-memory") {
            return round.stage.answer(for: round.digits)
        }
        #endif
        return ""
    }

    private func submit(_ value: String) {
        let token = round.questionID
        if round.submit(value, forQuestion: token) {
            input = NumericInput(allowsNegative: false, allowsDecimal: false, maxDigits: round.length)
        } else {
            input.reset()
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
        input = NumericInput(allowsNegative: false, allowsDecimal: false, maxDigits: 3)
        round = Self.makeRound()
    }
}
