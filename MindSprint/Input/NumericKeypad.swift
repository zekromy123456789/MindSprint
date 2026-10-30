import SwiftUI

struct NumericKeypad: View {
    @Binding var input: NumericInput
    var isEnabled = true
    let onSubmit: (String) -> Void

    private let rows = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                key("Clear", label: "Clear answer") { input.clear() }
                key("⌫", label: "Delete last character") { input.backspace() }
            }
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { digit in
                        key(String(digit), label: String(digit)) { input.appendDigit(digit) }
                    }
                }
            }
            HStack(spacing: 8) {
                key("±", label: "Change sign", available: input.allowsNegative) { input.toggleSign() }
                key("0", label: "0") { input.appendDigit(0) }
                key(".", label: "Decimal point", available: input.allowsDecimal) { input.appendDecimal() }
            }
            Button {
                if let value = input.submit() { onSubmit(value) }
            } label: {
                Text("Submit").font(.headline).frame(maxWidth: .infinity, minHeight: 56)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isEnabled || input.isSubmitted)
        }
        .disabled(!isEnabled || input.isSubmitted)
    }

    private func key(_ title: String, label: String, available: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.title3.weight(.semibold)).frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(.bordered)
        .disabled(!available)
        .accessibilityLabel(label)
    }
}
