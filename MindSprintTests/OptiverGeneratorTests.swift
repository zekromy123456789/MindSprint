import XCTest
@testable import MindSprint

final class OptiverGeneratorTests: XCTestCase {
    private func satisfies(_ q: OptiverQuestion, using choice: OptiverNumber) -> Bool {
        let a = (q.hidden == .first ? choice : q.first).hundredths
        let b = (q.hidden == .second ? choice : q.second).hundredths
        let c = (q.hidden == .result ? choice : q.result).hundredths
        switch q.operation {
        case .addition: return a + b == c
        case .subtraction: return a - b == c
        case .multiplication: return a * b == c * 100
        case .division: return b != 0 && a * 100 == b * c
        }
    }

    func testEveryQuestionHasOneValidChoiceAndExactEquation() {
        var random = SeededRandomNumberGenerator(seed: 713)
        for op in ArithmeticOperation.allCases {
            for position in OptiverPosition.allCases {
                for _ in 0..<1000 {
                    let q = OptiverGenerator().make(op, hidden: position, using: &random)
                    XCTAssertEqual(q.choices.count, 4)
                    XCTAssertEqual(Set(q.choices).count, 4)
                    XCTAssertEqual(Set(q.choices.map(\.text)).count, 4)
                    XCTAssertEqual(q.choices.filter { satisfies(q, using: $0) }, [q.answer])
                    XCTAssertEqual(q.prompt.filter { $0 == "?" }.count, 1)
                    XCTAssertFalse(q.solvedPrompt.contains("?"))
                    if op == .division { XCTAssertNotEqual(q.second.hundredths, 0) }
                }
            }
        }
    }

    func testNumberFormattingAndSeededRepeatability() {
        XCTAssertEqual(OptiverNumber(hundredths: 0).text, "0")
        XCTAssertEqual(OptiverNumber(hundredths: -1).text, "−0.01")
        XCTAssertEqual(OptiverNumber(hundredths: 125).text, "1.25")
        XCTAssertEqual(OptiverNumber(hundredths: 120).text, "1.2")
        XCTAssertEqual(OptiverNumber(hundredths: -500).text, "−5")
        XCTAssertEqual(OptiverNumber(hundredths: 120, decimalPlaces: 2).text, "1.20")
        XCTAssertEqual(OptiverNumber(hundredths: 0, decimalPlaces: 1).text, "0.0")
        XCTAssertEqual(OptiverNumber(hundredths: -500, decimalPlaces: 2).text, "−5.00")
        var first = SeededRandomNumberGenerator(seed: 17)
        var second = SeededRandomNumberGenerator(seed: 17)
        for _ in 0..<200 {
            XCTAssertEqual(OptiverGenerator().next(using: &first), OptiverGenerator().next(using: &second))
        }
    }

    func testFixedPrecisionDisplayExamples() {
        let question = OptiverQuestion(
            first: OptiverNumber(hundredths: 120, decimalPlaces: 2),
            operation: .addition,
            second: OptiverNumber(hundredths: 230, decimalPlaces: 2),
            result: OptiverNumber(hundredths: 350, decimalPlaces: 2),
            hidden: .second,
            choices: [OptiverNumber(hundredths: 230, decimalPlaces: 2)]
        )
        XCTAssertEqual(question.prompt, "1.20 + ? = 3.50")
        XCTAssertEqual(question.solvedPrompt, "1.20 + 2.30 = 3.50")
        XCTAssertEqual(question.answer.text, "2.30")
    }

    func testPrecisionAndDistractorRangesForAllOperationsAndPositions() {
        var random = SeededRandomNumberGenerator(seed: 931)
        var precisionPairs = Set<String>()
        for op in ArithmeticOperation.allCases {
            for position in OptiverPosition.allCases {
                for _ in 0..<1000 {
                    let q = OptiverGenerator().make(op, hidden: position, using: &random)
                    if op == .addition || op == .subtraction {
                        XCTAssertEqual(q.first.decimalPlaces, q.second.decimalPlaces)
                        XCTAssertEqual(q.first.decimalPlaces, q.result.decimalPlaces)
                        XCTAssertTrue([0, 2].contains(q.first.decimalPlaces))
                    } else {
                        let factorA = op == .division ? q.second : q.first
                        let factorB = op == .division ? q.result : q.second
                        let product = op == .division ? q.first : q.result
                        XCTAssertEqual(product.decimalPlaces, factorA.decimalPlaces + factorB.decimalPlaces)
                        precisionPairs.insert("\(factorA.decimalPlaces),\(factorB.decimalPlaces)")
                    }
                    XCTAssertTrue(q.choices.allSatisfy { $0.decimalPlaces == q.answer.decimalPlaces })
                    let step = q.answer.choiceStep
                    let differences = q.choices.filter { $0 != q.answer }.map { ($0.hundredths - q.answer.hundredths) / step }
                    XCTAssertEqual(differences.filter { (1...9).contains($0) }.count, 1)
                    XCTAssertEqual(differences.filter { (-9 ... -1).contains($0) }.count, 1)
                    let maxFar = q.answer.decimalPlaces == 2 ? 100 : 90
                    XCTAssertEqual(differences.filter { (10...maxFar).contains($0) }.count, 1)
                }
            }
        }
        XCTAssertEqual(precisionPairs, Set(["0,0", "0,1", "1,0", "1,1"]))
    }

    func testDifficultyOperationsAreDistinctAndValid() {
        let expected: [Difficulty: Set<ArithmeticOperation>] = [
            .classic: [.addition, .subtraction, .multiplication, .division],
            .easy: [.addition, .subtraction],
            .normal: [.addition, .subtraction, .multiplication],
            .hard: [.multiplication, .division],
            .expert: [.division]
        ]
        for level in Difficulty.allCases {
            let generator = OptiverGenerator(difficulty: level)
            var random = SeededRandomNumberGenerator(seed: 52)
            var observed = Set<ArithmeticOperation>()
            for _ in 0..<300 {
                let q = generator.next(using: &random)
                observed.insert(q.operation)
                XCTAssertEqual(q.choices.filter { satisfies(q, using: $0) }, [q.answer])
            }
            XCTAssertEqual(observed, expected[level])
        }
    }
}
