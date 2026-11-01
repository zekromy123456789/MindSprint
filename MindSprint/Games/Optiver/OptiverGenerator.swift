import Foundation

// Fixed hundredths keep generated equations and choices exact and avoid negative zero.
struct OptiverNumber: Hashable {
    let hundredths: Int
    let decimalPlaces: Int

    init(hundredths: Int, decimalPlaces: Int? = nil) {
        let places = decimalPlaces ?? (hundredths % 100 == 0 ? 0 : (hundredths % 10 == 0 ? 1 : 2))
        precondition((0...2).contains(places))
        precondition(places == 2 || (places == 1 ? hundredths % 10 == 0 : hundredths % 100 == 0))
        self.hundredths = hundredths
        self.decimalPlaces = places
    }

    var text: String {
        let magnitude = abs(hundredths)
        let sign = hundredths < 0 ? "−" : ""
        let whole = magnitude / 100
        let fraction = magnitude % 100
        if decimalPlaces == 0 { return sign + String(whole) }
        if decimalPlaces == 1 { return "\(sign)\(whole).\(fraction / 10)" }
        return "\(sign)\(whole).\(fraction < 10 ? "0" : "")\(fraction)"
    }

    var choiceStep: Int {
        switch decimalPlaces {
        case 0: return 100
        case 1: return 10
        default: return 1
        }
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

    // Decimal inputs preserve source-observed precision. Exact fixed-point math
    // avoids floating-point artifacts; safety resampling is a deliberate deviation.
    func next<R: RandomNumberGenerator>(using random: inout R) -> OptiverQuestion {
        let op = operations.randomElement(using: &random)!
        return make(op, hidden: OptiverPosition.allCases.randomElement(using: &random)!, using: &random)
    }

    func make<R: RandomNumberGenerator>(_ op: ArithmeticOperation, hidden: OptiverPosition,
                                         using random: inout R) -> OptiverQuestion {
        let first: OptiverNumber
        let second: OptiverNumber
        let result: OptiverNumber
        func decimal<RNG: RandomNumberGenerator>(_ lower: Double, _ upper: Double,
                                                  places: Int, random: inout RNG) -> Int {
            let scale = places == 1 ? 10.0 : 100.0
            let sampled = Double.random(in: lower..<upper, using: &random)
            let rounded = Int(floor(sampled * scale + 0.5))
            return places == 1 ? rounded * 10 : rounded
        }
        switch op {
        case .addition, .subtraction:
            let places = Int.random(in: 0..<3, using: &random) == 0 ? 2 : 0
            let a = places == 2 ? decimal(0.1, 99, places: 2, random: &random) : Int.random(in: 2...99, using: &random) * 100
            let b = places == 2 ? decimal(0.1, 99, places: 2, random: &random) : Int.random(in: 2...99, using: &random) * 100
            first = OptiverNumber(hundredths: a, decimalPlaces: places)
            second = OptiverNumber(hundredths: b, decimalPlaces: places)
            result = OptiverNumber(hundredths: op == .addition ? a + b : a - b, decimalPlaces: places)
        case .multiplication, .division:
            func factor<RNG: RandomNumberGenerator>(_ random: inout RNG) -> OptiverNumber {
                if Int.random(in: 0..<3, using: &random) == 0 {
                    return OptiverNumber(hundredths: decimal(-5, 5, places: 1, random: &random), decimalPlaces: 1)
                }
                return OptiverNumber(hundredths: Int.random(in: 2...99, using: &random) * 100, decimalPlaces: 0)
            }
            var a = factor(&random)
            var b = factor(&random)
            // Avoid equations with multiple valid choices when a factor/divisor is hidden.
            while (op == .multiplication && hidden == .second && a.hundredths == 0) ||
                  (op == .division && a.hundredths == 0) { a = factor(&random) }
            while (op == .multiplication && hidden == .first && b.hundredths == 0) ||
                  (op == .division && hidden == .second && b.hundredths == 0) { b = factor(&random) }
            let product = OptiverNumber(hundredths: (a.hundredths * b.hundredths) / 100,
                                         decimalPlaces: a.decimalPlaces + b.decimalPlaces)
            first = op == .division ? product : a
            second = op == .division ? a : b
            result = op == .division ? b : product
        }
        let answer: OptiverNumber
        switch hidden {
        case .first: answer = first
        case .second: answer = second
        case .result: answer = result
        }
        let step = answer.choiceStep
        func offset<RNG: RandomNumberGenerator>(_ low: Int, _ high: Int, random: inout RNG) -> Int {
            if answer.decimalPlaces == 0 { return Int.random(in: low...high, using: &random) }
            let sample = Double.random(in: Double(low)..<Double(high), using: &random)
            return Int(floor(sample + 0.5))
        }
        let large = answer.decimalPlaces == 2 ? 100 : 90
        let plus = offset(1, 9, random: &random)
        let far = offset(10, large, random: &random)
        let minus = offset(1, 9, random: &random)
        var choices = [answer, OptiverNumber(hundredths: answer.hundredths + plus * step, decimalPlaces: answer.decimalPlaces),
                       OptiverNumber(hundredths: answer.hundredths + far * step, decimalPlaces: answer.decimalPlaces),
                       OptiverNumber(hundredths: answer.hundredths - minus * step, decimalPlaces: answer.decimalPlaces)]
        choices.shuffle(using: &random)
        return OptiverQuestion(first: first, operation: op, second: second,
                               result: result, hidden: hidden, choices: choices)
    }
}
