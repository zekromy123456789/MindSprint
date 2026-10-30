import SwiftUI

struct ContentView: View {
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
                    Section("MindSprint") {
                        LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Development")
                        Text("Settings will be available as the games are added.")
                            .foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(.teal)
    }
}
