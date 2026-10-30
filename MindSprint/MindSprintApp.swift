import SwiftUI

@main
struct MindSprintApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--ui-test-keypad") {
                KeypadTestHarness()
            } else {
                ContentView()
            }
            #else
            ContentView()
            #endif
        }
    }
}

#if DEBUG
private struct KeypadTestHarness: View {
    @State private var input = NumericInput(allowsDecimal: true)
    @State private var submitted = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("Keypad test").font(.headline)
            Text(input.text.isEmpty ? "Empty" : input.text)
                .accessibilityIdentifier("input-value")
            Text(submitted.isEmpty ? "None" : submitted)
                .accessibilityIdentifier("submitted-value")
            Button("Reset") { input.reset(); submitted = "" }
            NumericKeypad(input: $input) { submitted = $0 }
        }
        .padding()
    }
}
#endif
