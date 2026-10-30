enum NumericInputAction: Equatable {
    case digit(Int), decimal, toggleSign, backspace, clear, submit

    static func character(_ value: String) -> NumericInputAction? {
        guard value.count == 1, let character = value.first else { return nil }
        if let digit = character.wholeNumberValue, character.isASCII, (0...9).contains(digit) {
            return .digit(digit)
        }
        switch character {
        case ".": return .decimal
        case "-": return .toggleSign
        default: return nil
        }
    }
}

extension NumericInput {
    // Returns a submission only when input is complete and not already submitted.
    mutating func apply(_ action: NumericInputAction) -> String? {
        switch action {
        case .digit(let digit): appendDigit(digit)
        case .decimal: appendDecimal()
        case .toggleSign: toggleSign()
        case .backspace: backspace()
        case .clear: clear()
        case .submit: return submit()
        }
        return nil
    }
}
