import XCTest
@testable import MindSprint

final class ArithmeticGeneratorTests: XCTestCase {
    func testClassicRangesAndMathematicalValidityAcrossSeeds() {
        for seed in 0..<20 {
            var random = SeededRandomNumberGenerator(seed: UInt64(seed))
            let generator = ArithmeticGenerator(difficulty: .classic)
            for operation in ArithmeticOperation.allCases {
                for _ in 0..<100 {
                    let q = generator.make(operation, using: &random)
                    switch operation {
                    case .addition:
                        XCTAssertTrue((2...99).contains(q.first) && (2...99).contains(q.second))
                        XCTAssertEqual(q.answer, q.first + q.second)
                    case .subtraction:
                        XCTAssertTrue((2...99).contains(q.first) && (2...99).contains(q.second))
                        XCTAssertEqual(q.answer, q.first - q.second)
                    case .multiplication:
                        XCTAssertTrue(((2...12).contains(q.first) && (2...99).contains(q.second)) ||
                                      ((2...99).contains(q.first) && (2...12).contains(q.second)))
                        XCTAssertEqual(q.answer, q.first * q.second)
                    case .division:
                        XCTAssertTrue((2...12).contains(q.second))
                        XCTAssertTrue((2...99).contains(q.answer))
                        XCTAssertEqual(q.first, q.answer * q.second)
                    }
                }
            }
        }
    }

    func testGeneratedSequenceRepeatsForTheSameSeed() {
        var first = SeededRandomNumberGenerator(seed: 42)
        var second = SeededRandomNumberGenerator(seed: 42)
        let generator = ArithmeticGenerator(difficulty: .classic)
        for _ in 0..<100 {
            XCTAssertEqual(generator.next(using: &first), generator.next(using: &second))
        }
    }

    func testCanonicalAnswersIncludingNegativeAndZero() {
        let negative = ArithmeticQuestion(first: 2, operation: .subtraction, second: 9, answer: -7)
        XCTAssertTrue(negative.accepts("-7"))
        XCTAssertFalse(negative.accepts("-07"))
        XCTAssertFalse(negative.accepts("-7.0"))
        XCTAssertFalse(negative.accepts(""))
        let zero = ArithmeticQuestion(first: 9, operation: .subtraction, second: 9, answer: 0)
        XCTAssertTrue(zero.accepts("0"))
        XCTAssertFalse(zero.accepts("-0"))
    }

    func testAllDifficultiesGenerateValidDivision() {
        for difficulty in Difficulty.allCases {
            var random = SeededRandomNumberGenerator(seed: 912)
            let generator = ArithmeticGenerator(difficulty: difficulty)
            for _ in 0..<200 {
                let q = generator.make(.division, using: &random)
                XCTAssertGreaterThan(q.second, 0)
                XCTAssertEqual(q.first, q.answer * q.second)
            }
        }
    }
}
