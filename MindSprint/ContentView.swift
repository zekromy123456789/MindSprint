import SwiftUI

struct ContentView: View {
    @StateObject private var records = RecordsManager.makeDefault()
    @State private var showUnsavedAlert = false
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("keypressHapticsEnabled") private var keypressHapticsEnabled = true

    var body: some View {
        TabView {
            NavigationStack { GamesHomeView() }
                .tabItem { Label("Games", systemImage: "square.grid.2x2") }
            NavigationStack {
                RecordsView()
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
        .environmentObject(records)
        .onChange(of: records.pendingCount) { old, new in
            if new > old { showUnsavedAlert = true }
        }
        .alert("Result not saved", isPresented: $showUnsavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Open Records and tap Retry saving while the app remains open.")
        }
    }
}
