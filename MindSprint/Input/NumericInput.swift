struct NumericInput: Equatable {
    let allowsNegative: Bool
    let allowsDecimal: Bool
    let maxDigits: Int
    private(set) var text = ""
    private(set) var isSubmitted = false

    init(allowsNegative: Bool = true, allowsDecimal: Bool = false, maxDigits: Int = 18) {
        precondition(maxDigits > 0)
        self.allowsNegative = allowsNegative
        self.allowsDecimal = allowsDecimal
        self.maxDigits = maxDigits
    }

    mutating func appendDigit(_ digit: Int) {
        guard !isSubmitted, (0...9).contains(digit),
              text.filter({ $0.isNumber }).count < maxDigits else { return }
        text.append(String(digit))
    }

    mutating func appendDecimal() {
        guard !isSubmitted, allowsDecimal, !text.contains("."),
              text.filter({ $0.isNumber }).count < maxDigits else { return }
        if text.isEmpty { text = "0" }
        if text == "-" { text = "-0" }
        text.append(".")
    }

    mutating func toggleSign() {
        guard !isSubmitted, allowsNegative else { return }
        if text.hasPrefix("-") { text.removeFirst() } else { text.insert("-", at: text.startIndex) }
    }

    mutating func backspace() {
        guard !isSubmitted, !text.isEmpty else { return }
        text.removeLast()
    }

    mutating func clear() {
        guard !isSubmitted else { return }
        text = ""
    }

    // Submit only a complete string, and lock until the caller resolves the attempt.
    mutating func submit() -> String? {
        guard !isSubmitted, !text.isEmpty, text != "-", !text.hasSuffix(".") else { return nil }
        isSubmitted = true
        return text
    }

    // Call after a rejected attempt or when advancing to a new question.
    mutating func reset() {
        text = ""
        isSubmitted = false
    }
}
