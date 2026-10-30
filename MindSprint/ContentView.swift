import SwiftUI

struct ContentView: View {
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("keypressHapticsEnabled") private var keypressHapticsEnabled = true

    var body: some View {
        TabView {
            NavigationStack { GamesHomeView() }
                .tabItem { Label("Games", systemImage: "square.grid.2x2") }
            NavigationStack {
                ContentUnavailableView("No records yet", systemImage: "chart.line.uptrend.xyaxis", description: Text("Your results will appear here once games are available."))
                    .navigationTitle("Records")
            }
            .tabItem { Label("Records", systemImage: "chart.bar") }
            NavigationStack {
                List {
                    Section("Feedback") {
                        Toggle("Haptics", isOn: $hapticsEnabled)
                        Toggle("Keypress haptics", isOn: $keypressHapticsEnabled)
                            .disabled(!hapticsEnabled)
                    }
                    Section("MindSprint") {
                        LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Development")
                    }
                }
                .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(.teal)
    }
}
