import SwiftUI

struct NumericKeypad: View {
    @Binding var input: NumericInput
    var isEnabled = true
    let onSubmit: (String) -> Void
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("keypressHapticsEnabled") private var keypressHapticsEnabled = true
    @FocusState private var keyboardFocused: Bool

    private let rows = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                key("Clear", label: "Clear answer", action: .clear)
                key("⌫", label: "Delete last character", action: .backspace)
            }
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { digit in
                        key(String(digit), label: String(digit), action: .digit(digit))
                    }
                }
            }
            HStack(spacing: 8) {
                key("±", label: "Change sign", available: input.allowsNegative, action: .toggleSign)
                key("0", label: "0", action: .digit(0))
                key(".", label: "Decimal point", available: input.allowsDecimal, action: .decimal)
            }
            Button { perform(.submit) } label: {
                Text("Submit").font(.headline).frame(maxWidth: .infinity, minHeight: 56)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isEnabled || input.isSubmitted)
        }
        .disabled(!isEnabled || input.isSubmitted)
        .focusable()
        .focused($keyboardFocused)
        .onAppear {
            keyboardFocused = true
            HapticFeedback.shared.prepare()
        }
        .onChange(of: isEnabled) { _, enabled in
            if enabled { keyboardFocused = true }
        }
        .onKeyPress(phases: .down) { press in
            guard isEnabled, !input.isSubmitted, press.modifiers.isEmpty else { return .ignored }
            let action: NumericInputAction?
            if press.key == .return { action = .submit }
            else if press.key == .delete { action = .backspace }
            else if press.key == .escape { action = .clear }
            else { action = NumericInputAction.character(press.characters) }
            guard let action else { return .ignored }
            perform(action)
            return .handled
        }
    }

    private func perform(_ action: NumericInputAction) {
        guard isEnabled, !input.isSubmitted else { return }
        HapticFeedback.shared.keypress(enabled: hapticsEnabled && keypressHapticsEnabled)
        if let value = input.apply(action) { onSubmit(value) }
    }

    private func key(_ title: String, label: String, available: Bool = true, action: NumericInputAction) -> some View {
        Button { perform(action) } label: {
            Text(title).font(.title3.weight(.semibold)).frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(.bordered)
        .disabled(!available)
        .accessibilityLabel(label)
    }
}
