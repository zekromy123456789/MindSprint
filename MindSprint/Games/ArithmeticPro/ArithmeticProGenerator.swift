import Foundation

// Independently authored templates; this is not the reference's fixed question pool.
indirect enum ProExpression: Equatable {
    case number(Int)
    case add(ProExpression, ProExpression)
    case subtract(ProExpression, ProExpression)
    case multiply(ProExpression, ProExpression)
    case divide(ProExpression, ProExpression)

    var value: Int {
        switch self {
        case .number(let n): return n
        case .add(let a, let b): return a.value + b.value
        case .subtract(let a, let b): return a.value - b.value
        case .multiply(let a, let b): return a.value * b.value
        case .divide(let a, let b): return a.value / b.value
        }
    }

    var text: String {
        switch self {
        case .number(let n): return String(n)
        case .add(let a, let b): return "(\(a.text) + \(b.text))"
        case .subtract(let a, let b): return "(\(a.text) − \(b.text))"
        case .multiply(let a, let b): return "(\(a.text) × \(b.text))"
        case .divide(let a, let b): return "(\(a.text) ÷ \(b.text))"
        }
    }
}

struct ArithmeticProQuestion: Equatable {
    let expression: ProExpression
    var answer: Int { expression.value }
    var prompt: String { expression.text }
    func accepts(_ text: String) -> Bool { text == String(answer) }
}

struct ArithmeticProGenerator {
    static let difficulties: [Difficulty] = [.easy, .normal, .hard, .expert]
    let difficulty: Difficulty

    init(difficulty: Difficulty = .normal) {
        precondition(Self.difficulties.contains(difficulty))
        self.difficulty = difficulty
    }

    // A small, original selection of expression shapes and operands. All division
    // is exact and nonzero; these distributions are not claimed to match Pro.
    func next<R: RandomNumberGenerator>(using random: inout R) -> ArithmeticProQuestion {
        let limits: (Int, Int)
        switch difficulty {
        case .easy: limits = (10, 5)
        case .normal: limits = (20, 12)
        case .hard: limits = (35, 15)
        case .expert: limits = (60, 20)
        case .classic: preconditionFailure("Pro has no reference-equivalent Classic level")
        }
        let a = Int.random(in: 2...limits.0, using: &random)
        let b = Int.random(in: 2...limits.1, using: &random)
        let c = Int.random(in: 2...limits.0, using: &random)
        let d = Int.random(in: 2...limits.1, using: &random)
        let n: (Int) -> ProExpression = { .number($0) }
        let expression: ProExpression
        switch Int.random(in: 0...4, using: &random) {
        case 0: expression = .multiply(n(a), .add(n(b), n(c)))
        case 1: expression = .subtract(n(a), .multiply(n(b), n(c)))
        case 2: expression = .add(.multiply(.subtract(n(a), n(b)), n(c)), n(d))
        case 3: expression = .subtract(.multiply(.add(n(a), n(b)), .add(n(c), n(d))), n(a))
        default: expression = .add(.divide(.multiply(n(a), n(b)), n(b)), .subtract(n(c), n(d)))
        }
        return ArithmeticProQuestion(expression: expression)
    }
}
