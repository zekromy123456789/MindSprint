import Foundation

enum ArithmeticOperation: String, CaseIterable {
    case addition, subtraction, multiplication, division

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }
}

struct ArithmeticQuestion: Equatable {
    let first: Int
    let operation: ArithmeticOperation
    let second: Int
    let answer: Int

    // The reference compares a canonical integer string, not a floating-point value.
    func accepts(_ text: String) -> Bool { text == String(answer) }
}

struct ArithmeticGenerator {
    let difficulty: Difficulty

    private var limits: (main: ClosedRange<Int>, factor: ClosedRange<Int>) {
        switch difficulty {
        case .classic: return (2...99, 2...12)
        case .easy: return (2...20, 2...5)
        case .normal: return (2...50, 2...10)
        case .hard: return (2...199, 2...15)
        case .expert: return (2...999, 2...25)
        }
    }

    func next<R: RandomNumberGenerator>(using random: inout R) -> ArithmeticQuestion {
        let operation = ArithmeticOperation.allCases.randomElement(using: &random)!
        return make(operation, using: &random)
    }

    func make<R: RandomNumberGenerator>(_ operation: ArithmeticOperation, using random: inout R) -> ArithmeticQuestion {
        let ranges = limits
        switch operation {
        case .addition, .subtraction:
            let left = Int.random(in: ranges.main, using: &random)
            let right = Int.random(in: ranges.main, using: &random)
            return ArithmeticQuestion(first: left, operation: operation, second: right,
                                      answer: operation == .addition ? left + right : left - right)
        case .multiplication:
            let factor = Int.random(in: ranges.factor, using: &random)
            let other = Int.random(in: ranges.main, using: &random)
            let swap = Bool.random(using: &random)
            return ArithmeticQuestion(first: swap ? other : factor, operation: operation,
                                      second: swap ? factor : other, answer: factor * other)
        case .division:
            let quotient = Int.random(in: ranges.main, using: &random)
            let divisor = Int.random(in: ranges.factor, using: &random)
            return ArithmeticQuestion(first: quotient * divisor, operation: operation,
                                      second: divisor, answer: quotient)
        }
    }
}
