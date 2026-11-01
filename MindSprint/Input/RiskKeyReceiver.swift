import SwiftUI
import UIKit

enum RiskKeyAction { case pump, collect }

// Hardware arrows work without showing the system keyboard.
struct RiskKeyReceiver: UIViewRepresentable {
    let isActive: Bool
    let onAction: (RiskKeyAction) -> Void

    func makeUIView(context: Context) -> KeyField {
        let field = KeyField()
        field.inputView = UIView(frame: .zero)
        field.isAccessibilityElement = false
        return field
    }

    func updateUIView(_ field: KeyField, context: Context) {
        field.onAction = onAction
        field.isActive = isActive
        DispatchQueue.main.async {
            guard field.window != nil else { return }
            if field.isActive && !field.isFirstResponder { field.becomeFirstResponder() }
            if !field.isActive && field.isFirstResponder { field.resignFirstResponder() }
        }
    }

    final class KeyField: UITextField {
        var isActive = false
        var onAction: ((RiskKeyAction) -> Void)?
        override var keyCommands: [UIKeyCommand]? {
            [UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(pump)),
             UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(collect))]
        }
        @objc private func pump() { if isActive { onAction?(.pump) } }
        @objc private func collect() { if isActive { onAction?(.collect) } }
    }
}
