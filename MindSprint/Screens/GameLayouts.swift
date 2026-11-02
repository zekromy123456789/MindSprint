import SwiftUI

// Reusable presentation containers. Games supply their own content and actions.
struct ActiveGameLayout<Question: View, Controls: View>: View {
    let score: String
    let time: String?
    @ViewBuilder let question: () -> Question
    @ViewBuilder let controls: () -> Controls

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(score).font(.headline).accessibilityIdentifier("game-score")
                Spacer()
                if let time { Text(time).font(.headline.monospacedDigit()).accessibilityIdentifier("game-timer") }
            }
            .accessibilityElement(children: .combine)
            Spacer(minLength: 8)
            question().frame(maxWidth: .infinity)
            Spacer(minLength: 8)
            controls()
        }
        .padding()
    }
}

struct GameResultSummary: View {
    let score: String
    let detail: String
    let onReplay: () -> Void
    let onRecords: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Session complete").font(.title2.bold())
            Text(score).font(.largeTitle.bold()).monospacedDigit()
            Text(detail).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button("Play again", action: onReplay).buttonStyle(.borderedProminent)
            Button("Records", action: onRecords).buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct NumericGameLayout<Question: View>: View {
    let score: String
    let time: String?
    @Binding var input: NumericInput
    let inputEnabled: Bool
    let onSubmit: (String) -> Void
    @ViewBuilder let question: () -> Question

    var body: some View {
        ActiveGameLayout(score: score, time: time) {
            question()
        } controls: {
            NumericKeypad(input: $input, isEnabled: inputEnabled, onSubmit: onSubmit)
        }
    }
}
