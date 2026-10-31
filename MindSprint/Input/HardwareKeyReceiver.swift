import SwiftUI
import UIKit

// A first-responder field forwards hardware keys without presenting the system keyboard.
// The actual answer remains in NumericInput and the on-screen keypad stays visible.
struct HardwareKeyReceiver: UIViewRepresentable {
    let isActive: Bool
    let onAction: (NumericInputAction) -> Void

    func makeUIView(context: Context) -> KeyField {
        let field = KeyField()
        field.delegate = context.coordinator
        field.inputView = UIView(frame: .zero)
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.accessibilityIdentifier = "hardware-key-input"
        #if DEBUG
        field.isAccessibilityElement = true
        #else
        field.isAccessibilityElement = false
        #endif
        return field
    }

    func updateUIView(_ field: KeyField, context: Context) {
        context.coordinator.onAction = onAction
        field.onDelete = { context.coordinator.onAction(.backspace) }
        field.onClear = { context.coordinator.onAction(.clear) }
        field.isActive = isActive
        DispatchQueue.main.async {
            guard field.window != nil else { return }
            if field.isActive && !field.isFirstResponder { field.becomeFirstResponder() }
            if !field.isActive && field.isFirstResponder { field.resignFirstResponder() }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(onAction: onAction) }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var onAction: (NumericInputAction) -> Void
        init(onAction: @escaping (NumericInputAction) -> Void) { self.onAction = onAction }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            for character in string {
                if let action = NumericInputAction.character(String(character)) { onAction(action) }
            }
            return false
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onAction(.submit)
            return false
        }
    }

    final class KeyField: UITextField {
        var isActive = false
        var onDelete: (() -> Void)?
        var onClear: (() -> Void)?
        override func deleteBackward() { onDelete?() }
        override var keyCommands: [UIKeyCommand]? {
            [UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(clearInput))]
        }
        @objc private func clearInput() { onClear?() }
    }
}
