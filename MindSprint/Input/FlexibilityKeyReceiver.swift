import SwiftUI
import UIKit

// Arrow-key input uses a first responder without presenting the system keyboard.
struct FlexibilityKeyReceiver: UIViewRepresentable {
    let isActive: Bool
    let onChoice: (Bool) -> Void

    func makeUIView(context: Context) -> KeyField {
        let field = KeyField()
        field.inputView = UIView(frame: .zero)
        field.isAccessibilityElement = false
        return field
    }

    func updateUIView(_ field: KeyField, context: Context) {
        field.onChoice = onChoice
        field.isActive = isActive
        DispatchQueue.main.async {
            guard field.window != nil else { return }
            if field.isActive && !field.isFirstResponder { field.becomeFirstResponder() }
            if !field.isActive && field.isFirstResponder { field.resignFirstResponder() }
        }
    }

    final class KeyField: UITextField {
        var isActive = false
        var onChoice: ((Bool) -> Void)?
        override var keyCommands: [UIKeyCommand]? {
            [UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(no)),
             UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(yes))]
        }
        @objc private func no() { if isActive { onChoice?(false) } }
        @objc private func yes() { if isActive { onChoice?(true) } }
    }
}
