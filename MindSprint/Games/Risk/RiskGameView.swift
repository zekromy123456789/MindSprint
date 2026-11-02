import SwiftUI

#if DEBUG
private final class RiskUITestClock: SessionClock {
    static let shared = RiskUITestClock()
    var now: TimeInterval = 0
}
#endif

struct RiskGameView: View {
    @State private var round: RiskRound
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var records: RecordsManager
    @State private var savedSessionID: UUID?
    @State private var saveFailed = false
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("keypressHapticsEnabled") private var keypressHapticsEnabled = true
    private let tick = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    init() { _round = State(initialValue: Self.makeRound()) }

    private static func makeRound() -> RiskRound {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-test-risk") {
            return RiskRound(clock: RiskUITestClock.shared, seed: 42)
        }
        #endif
        return RiskRound()
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
                    if ProcessInfo.processInfo.arguments.contains("--ui-test-risk") {
                        Button("Start test round") {
                            RiskUITestClock.shared.now += RiskRound.countdownDuration
                            round.refresh()
                        }
                    }
                    #endif
                }
            case .active:
                let token = round.roundID
                ActiveGameLayout(score: "Score: \(round.score)", time: nil) {
                    VStack(spacing: 16) {
                        Text("Round \(round.roundNumber) / \(RiskRound.totalRounds)")
                            .font(.headline).accessibilityIdentifier("risk-progress")
                        Image(systemName: "balloon.fill")
                            .font(.system(size: 100)).foregroundStyle(balloonColor)
                            .accessibilityHidden(true)
                        Text("\(round.color.rawValue.capitalized) balloon")
                            .font(.headline).accessibilityIdentifier("risk-color")
                        Text("Unbanked: \(round.unbanked)")
                            .font(.title2.bold().monospacedDigit()).accessibilityIdentifier("risk-unbanked")
                        if let outcome = round.lastOutcome {
                            Text(outcomeText(outcome)).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                } controls: {
                    HStack(spacing: 12) {
                        Button { perform(.pump, token: token) } label: {
                            Text("Pump").font(.headline).frame(maxWidth: .infinity, minHeight: 64)
                        }.buttonStyle(.bordered)
                        Button { perform(.collect, token: token) } label: {
                            Text("Collect").font(.headline).frame(maxWidth: .infinity, minHeight: 64)
                        }.buttonStyle(.borderedProminent)
                    }
                }
                .background {
                    RiskKeyReceiver(isActive: true) { perform($0, token: token) }
                        .frame(width: 1, height: 1).opacity(0.01)
                }
            case .completed:
                VStack(spacing: 16) {
                    Text("Session complete").font(.title2.bold())
                    Text("\(round.score)").font(.largeTitle.bold().monospacedDigit())
                        .accessibilityIdentifier("risk-final-score")
                    Text("Points collected").foregroundStyle(.secondary)
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
        .navigationTitle("Risk")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { round.start(); HapticFeedback.shared.prepare() }
        .onDisappear { round.abandon(); saveCompletedRound() }
        .onChange(of: round.phase) { _, phase in if phase == .completed { saveCompletedRound() } }
        .onReceive(tick) { _ in
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-risk") { return }
            #endif
            round.refresh()
        }
        .onChange(of: scenePhase) { _, phase in if phase == .active { round.refresh() } }
    }

    private var balloonColor: Color {
        switch round.color {
        case .blue: return .blue
        case .green: return .green
        case .red: return .red
        case .purple: return .purple
        }
    }

    private func outcomeText(_ outcome: RiskOutcome) -> String {
        switch outcome {
        case .collected(let points): return "Collected \(points)"
        case .popped: return "Balloon popped"
        }
    }

    private func perform(_ action: RiskKeyAction, token: Int) {
        switch action {
        case .pump:
            let previous = round.roundID
            if round.pump(forRound: token) {
                if round.roundID != previous || round.phase == .completed {
                    HapticFeedback.shared.result(.error, enabled: hapticsEnabled)
                } else {
                    HapticFeedback.shared.keypress(enabled: hapticsEnabled && keypressHapticsEnabled)
                }
            }
        case .collect:
            if round.collect(forRound: token) { HapticFeedback.shared.result(.success, enabled: hapticsEnabled) }
        }
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
        var next = Self.makeRound()
        next.start()
        round = next
    }
}
