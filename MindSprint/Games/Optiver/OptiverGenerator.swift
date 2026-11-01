import Foundation

// Fixed hundredths keep generated equations and choices exact and avoid negative zero.
struct OptiverNumber: Hashable {
    let hundredths: Int

    var text: String {
        let magnitude = abs(hundredths)
        let sign = hundredths < 0 ? "−" : ""
        let whole = magnitude / 100
        let fraction = magnitude % 100
        if fraction == 0 { return sign + String(whole) }
        if fraction % 10 == 0 { return "\(sign)\(whole).\(fraction / 10)" }
        return "\(sign)\(whole).\(fraction < 10 ? "0" : "")\(fraction)"
    }

    var choiceStep: Int {
        if hundredths % 100 == 0 { return 100 }
        if hundredths % 10 == 0 { return 10 }
        return 1
    }
}

enum OptiverPosition: CaseIterable { case first, second, result }

struct OptiverQuestion: Equatable {
    let first: OptiverNumber
    let operation: ArithmeticOperation
    let second: OptiverNumber
    let result: OptiverNumber
    let hidden: OptiverPosition
    let choices: [OptiverNumber]

    var answer: OptiverNumber {
        switch hidden {
        case .first: return first
        case .second: return second
        case .result: return result
        }
    }

    var prompt: String { equation(reveal: false) }
    var solvedPrompt: String { equation(reveal: true) }

    private func equation(reveal: Bool) -> String {
        let a = !reveal && hidden == .first ? "?" : first.text
        let b = !reveal && hidden == .second ? "?" : second.text
        let c = !reveal && hidden == .result ? "?" : result.text
        return "\(a) \(operation.symbol) \(b) = \(c)"
    }
}

struct OptiverGenerator {
    let difficulty: Difficulty

    init(difficulty: Difficulty = .classic) { self.difficulty = difficulty }

    // Custom levels select operation subsets; Classic retains the full mix.
    var operations: [ArithmeticOperation] {
        switch difficulty {
        case .classic: return ArithmeticOperation.allCases
        case .easy: return [.addition, .subtraction]
        case .normal: return [.addition, .subtraction, .multiplication]
        case .hard: return [.multiplication, .division]
        case .expert: return [.division]
        }
    }

    // Integers occur twice as often as decimals. Decimal addition/subtraction uses
    // hundredths; factors use tenths. Choices are original, deterministic offsets,
    // not a claim of exact reference distractor/rounding distribution.
    func next<R: RandomNumberGenerator>(using random: inout R) -> OptiverQuestion {
        let op = operations.randomElement(using: &random)!
        return make(op, hidden: OptiverPosition.allCases.randomElement(using: &random)!, using: &random)
    }

    func make<R: RandomNumberGenerator>(_ op: ArithmeticOperation, hidden: OptiverPosition,
                                         using random: inout R) -> OptiverQuestion {
        let first: Int
        let second: Int
        let result: Int
        switch op {
        case .addition, .subtraction:
            let decimal = Int.random(in: 0..<3, using: &random) == 0
            first = decimal ? Int.random(in: 10...9900, using: &random) : Int.random(in: 2...99, using: &random) * 100
            second = decimal ? Int.random(in: 10...9900, using: &random) : Int.random(in: 2...99, using: &random) * 100
            result = op == .addition ? first + second : first - second
        case .multiplication, .division:
            func factor<RNG: RandomNumberGenerator>(_ random: inout RNG) -> Int {
                if Int.random(in: 0..<3, using: &random) == 0 {
                    return Int.random(in: -50...50, using: &random) * 10
                }
                return Int.random(in: 2...99, using: &random) * 100
            }
            var a = factor(&random)
            var b = factor(&random)
            // Avoid equations with multiple valid choices when a factor/divisor is hidden.
            while (op == .multiplication && hidden == .second && a == 0) ||
                  (op == .division && hidden == .second && a == 0) { a = factor(&random) }
            while op == .multiplication && hidden == .first && b == 0 { b = factor(&random) }
            while op == .division && b == 0 { b = factor(&random) }
            let product = (a * b) / 100
            first = op == .division ? product : a
            second = b
            result = op == .division ? a : product
        }
        let values = [OptiverNumber(hundredths: first), OptiverNumber(hundredths: second), OptiverNumber(hundredths: result)]
        let answer: OptiverNumber
        switch hidden {
        case .first: answer = values[0]
        case .second: answer = values[1]
        case .result: answer = values[2]
        }
        let step = answer.choiceStep
        var choices = [answer, OptiverNumber(hundredths: answer.hundredths + step),
                       OptiverNumber(hundredths: answer.hundredths + 2 * step),
                       OptiverNumber(hundredths: answer.hundredths - step)]
        choices.shuffle(using: &random)
        return OptiverQuestion(first: values[0], operation: op, second: values[1],
                               result: values[2], hidden: hidden, choices: choices)
    }
}
