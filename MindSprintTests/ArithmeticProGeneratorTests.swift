import XCTest
@testable import MindSprint

// Independent recursive parser checks the expression players actually see.
private struct ProTextEvaluator {
    private let chars: [Character]
    private var index = 0
    init(_ text: String) { chars = Array(text.filter { !$0.isWhitespace }) }

    mutating func evaluate() throws -> Int {
        let result = try expression()
        guard index == chars.count else { throw ParseError.invalid }
        return result
    }

    private mutating func expression() throws -> Int {
        guard index < chars.count else { throw ParseError.invalid }
        if chars[index] == "(" {
            index += 1
            let left = try expression()
            guard index < chars.count else { throw ParseError.invalid }
            let op = chars[index]; index += 1
            let right = try expression()
            guard index < chars.count, chars[index] == ")" else { throw ParseError.invalid }
            index += 1
            switch op {
            case "+": return left + right
            case "−": return left - right
            case "×": return left * right
            case "÷":
                guard right != 0, left % right == 0 else { throw ParseError.invalid }
                return left / right
            default: throw ParseError.invalid
            }
        }
        let start = index
        while index < chars.count, chars[index].isNumber { index += 1 }
        guard start < index, let value = Int(String(chars[start..<index])) else { throw ParseError.invalid }
        return value
    }
    private enum ParseError: Error { case invalid }
}

final class ArithmeticProGeneratorTests: XCTestCase {
    func testGeneratedPromptsEvaluateToTheirAnswers() throws {
        var seen = Set<String>()
        var negative = false
        var division = false
        for difficulty in ArithmeticProGenerator.difficulties {
            for seed in 0..<10 {
                var random = SeededRandomNumberGenerator(seed: UInt64(seed))
                for _ in 0..<100 {
                    let q = ArithmeticProGenerator(difficulty: difficulty).next(using: &random)
                    var parser = ProTextEvaluator(q.prompt)
                    XCTAssertEqual(try parser.evaluate(), q.answer, q.prompt)
                    XCTAssertTrue(q.accepts(String(q.answer)))
                    XCTAssertFalse(q.accepts(String(q.answer) + ".0"))
                    XCTAssertLessThan(abs(q.answer), 100_000_000)
                    seen.insert(q.prompt)
                    negative = negative || q.answer < 0
                    division = division || q.prompt.contains("÷")
                }
            }
        }
        XCTAssertTrue(negative)
        XCTAssertTrue(division)
        XCTAssertGreaterThan(seen.count, 100)
    }

    func testDifficultyChangesOperandBounds() {
        let maxima: [Difficulty: Int] = [.easy: 10, .normal: 20, .hard: 35, .expert: 60]
        var uniqueSequences = Set<String>()
        for difficulty in ArithmeticProGenerator.difficulties {
            var random = SeededRandomNumberGenerator(seed: 481)
            var prompts: [String] = []
            for _ in 0..<150 {
                let question = ArithmeticProGenerator(difficulty: difficulty).next(using: &random)
                let numbers = question.prompt.split { !$0.isNumber }.compactMap { Int($0) }
                XCTAssertFalse(numbers.isEmpty)
                XCTAssertTrue(numbers.allSatisfy { (2...maxima[difficulty]!).contains($0) })
                prompts.append(question.prompt)
            }
            uniqueSequences.insert(prompts.joined(separator: ";"))
        }
        XCTAssertEqual(uniqueSequences.count, 4)
    }

    func testSeededGenerationRepeatsAndCanonicalZeroIsRequired() {
        var first = SeededRandomNumberGenerator(seed: 31)
        var second = SeededRandomNumberGenerator(seed: 31)
        let generator = ArithmeticProGenerator()
        for _ in 0..<100 { XCTAssertEqual(generator.next(using: &first), generator.next(using: &second)) }
        let zero = ArithmeticProQuestion(expression: .subtract(.number(4), .number(4)))
        XCTAssertTrue(zero.accepts("0"))
        XCTAssertFalse(zero.accepts("-0"))
        XCTAssertFalse(zero.accepts("00"))
    }
}
