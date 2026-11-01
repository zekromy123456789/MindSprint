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
        var first = SeededRandomNumberGenerator(seed: 17)
        var second = SeededRandomNumberGenerator(seed: 17)
        for _ in 0..<200 {
            XCTAssertEqual(OptiverGenerator().next(using: &first), OptiverGenerator().next(using: &second))
        }
    }
}
