import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 48))
                .accessibilityHidden(true)
            Text("MindSprint")
                .font(.largeTitle.bold())
            Text("Your mental training space is taking shape.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
