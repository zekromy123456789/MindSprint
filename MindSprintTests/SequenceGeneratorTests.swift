import XCTest
@testable import MindSprint

final class SequenceGeneratorTests: XCTestCase {
    func testClassicFamiliesAndDirections() {
        var directions = Set<Bool>()
        var seenFamilies = Set<SequenceFamily>()
        for seed in 0..<20 {
            var random = SeededRandomNumberGenerator(seed: UInt64(seed))
            for family in SequenceFamily.allCases {
                for _ in 0..<100 {
                    let q = SequenceGenerator().make(family, using: &random)
                    let v = q.isReversed ? Array(q.terms.reversed()) : q.terms
                    directions.insert(q.isReversed)
                    seenFamilies.insert(q.family)
                    XCTAssertEqual(q.visibleTerms, Array(q.terms.prefix(4)))
                    XCTAssertEqual(q.answer, q.terms[4])
                    XCTAssertTrue(q.accepts(String(q.answer)))
                    XCTAssertFalse(q.accepts(String(q.answer) + ".0"))
                    switch family {
                    case .arithmetic:
                        let step = v[1] - v[0]
                        XCTAssertTrue((5...22).contains(v[0]))
                        XCTAssertTrue((2...22).contains(step))
                        XCTAssertEqual(v, (0..<5).map { v[0] + $0 * step })
                    case .geometric:
                        XCTAssertTrue((5...22).contains(v[0]))
                        XCTAssertEqual(v[1] % v[0], 0)
                        let ratio = v[1] / v[0]
                        XCTAssertTrue((2...9).contains(ratio))
                        for i in 1..<5 { XCTAssertEqual(v[i], v[i - 1] * ratio) }
                    case .quadratic:
                        let second = v[2] - 2 * v[1] + v[0]
                        XCTAssertEqual(second % 2, 0)
                        let a = second / 2
                        let b = v[1] - v[0] - 3 * a
                        let c = v[0] - a - b
                        XCTAssertTrue((-8...8).contains(a) && (-8...8).contains(b) && (-8...8).contains(c))
                        XCTAssertEqual(v, (1...5).map { a * $0 * $0 + b * $0 + c })
                    case .special:
                        let candidates = (1...5).flatMap { start -> [[Int]] in
                            let indices = Array(start..<(start + 5))
                            return [indices.map { $0 * $0 }, indices.map { $0 * $0 * $0 },
                                    indices.map { $0 * ($0 + 1) / 2 }]
                        }
                        XCTAssertTrue(candidates.contains(v))
                    }
                }
            }
        }
        XCTAssertEqual(directions, Set([false, true]))
        XCTAssertEqual(seenFamilies.count, 4)
    }

    func testKnownSequencesAndCanonicalAnswers() {
        let examples: [[Int]] = [[5, 7, 9, 11, 13], [5, 10, 20, 40, 80],
                                 [1, 4, 9, 16, 25], [1, 3, 6, 10, 15], [25, 16, 9, 4, 1]]
        for terms in examples {
            let q = SequenceQuestion(family: .special, terms: terms, isReversed: false)
            XCTAssertEqual(q.visibleTerms.count, 4)
            XCTAssertTrue(q.accepts(String(terms[4])))
        }
        let zero = SequenceQuestion(family: .quadratic, terms: [4, 3, 2, 1, 0], isReversed: false)
        XCTAssertTrue(zero.accepts("0"))
        XCTAssertFalse(zero.accepts("00"))
        XCTAssertFalse(zero.accepts("-0"))
        let negative = SequenceQuestion(family: .quadratic, terms: [3, 2, 1, 0, -1], isReversed: false)
        XCTAssertTrue(negative.accepts("-1"))
        XCTAssertFalse(negative.accepts("-01"))
    }

    func testSeededSequenceIsRepeatableAndAllFamiliesAppear() {
        var first = SeededRandomNumberGenerator(seed: 17)
        var second = SeededRandomNumberGenerator(seed: 17)
        var families = Set<SequenceFamily>()
        for _ in 0..<400 {
            let question = SequenceGenerator().next(using: &first)
            XCTAssertEqual(question, SequenceGenerator().next(using: &second))
            families.insert(question.family)
        }
        XCTAssertEqual(families.count, 4)
    }

    func testEveryClassicPrefixHasOnlyOneGeneratedAnswer() {
        var answers: [[Int]: Int] = [:]
        var conflicts = 0
        func check(_ terms: [Int]) {
            for values in [terms, Array(terms.reversed())] {
                let prefix = Array(values.prefix(4))
                if let previous = answers[prefix], previous != values[4] { conflicts += 1 }
                answers[prefix] = values[4]
            }
        }
        for initial in 5...22 {
            for step in 2...22 { check((0..<5).map { initial + $0 * step }) }
            for ratio in 2...9 {
                var term = initial
                var values: [Int] = []
                for _ in 0..<5 { values.append(term); term *= ratio }
                check(values)
            }
        }
        for a in -8...8 {
            for b in -8...8 {
                for c in -8...8 { check((1...5).map { a * $0 * $0 + b * $0 + c }) }
            }
        }
        for start in 1...5 {
            let indices = Array(start..<(start + 5))
            check(indices.map { $0 * $0 })
            check(indices.map { $0 * $0 * $0 })
            check(indices.map { $0 * ($0 + 1) / 2 })
        }
        XCTAssertEqual(conflicts, 0)
        XCTAssertEqual(answers.count, 10_621)
    }
}
