import SwiftUI

enum AppearancePreference: String, CaseIterable {
    case system, light, dark

    var label: String { rawValue.capitalized }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct ContentView: View {
    @StateObject private var records = RecordsManager.makeDefault()
    @State private var showUnsavedAlert = false
    @AppStorage("appearancePreference") private var appearance: AppearancePreference = .system
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
                    Section("Appearance") {
                        Picker("Appearance", selection: $appearance) {
                            ForEach(AppearancePreference.allCases, id: \.self) { option in
                                Text(option.label).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityIdentifier("appearance-picker")
                    }
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
        .preferredColorScheme(appearance.colorScheme)
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
