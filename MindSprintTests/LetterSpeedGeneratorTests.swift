import XCTest
@testable import MindSprint

final class LetterSpeedGeneratorTests: XCTestCase {
    func testLetterValuesAndGridTotal() {
        XCTAssertEqual(LetterRow(first: 1, second: 7).value, 6)
        XCTAssertEqual(LetterRow(first: 24, second: nil).value, 24)
        XCTAssertEqual(LetterRow(first: nil, second: 26).value, 26)
        XCTAssertEqual(LetterRow(first: 9, second: 9).value, 0)
        XCTAssertEqual(LetterRow.display(1), "A")
        XCTAssertEqual(LetterRow.display(26), "Z")
        XCTAssertEqual(LetterRow.display(nil), "")
        let rows = [LetterRow(first: 1, second: 7), LetterRow(first: 24, second: nil)] +
                   (0..<8).map { _ in LetterRow(first: 1, second: 1) }
        XCTAssertEqual(LetterChoice(rows: rows).value, 30)
    }

    func testUniqueExtremeAndTieRejection() {
        func choice(_ number: Int) -> LetterChoice {
            LetterChoice(rows: (0..<10).map { _ in LetterRow(first: number, second: nil) })
        }
        let choices = [choice(1), choice(2), choice(3), choice(4)]
        XCTAssertEqual(LetterQuestion(target: .highest, choices: choices)?.correctIndex, 3)
        XCTAssertEqual(LetterQuestion(target: .lowest, choices: choices)?.correctIndex, 0)
        XCTAssertNil(LetterQuestion(target: .highest, choices: [choice(1), choice(2), choice(4), choice(4)]))
        XCTAssertNil(LetterQuestion(target: .lowest, choices: [choice(1), choice(1), choice(3), choice(4)]))
    }

    func testGeneratedGridsAreValidAndRepeatable() {
        var first = SeededRandomNumberGenerator(seed: 417)
        var second = SeededRandomNumberGenerator(seed: 417)
        var firstBlanks = 0
        var secondBlanks = 0
        var nonblankFirst = 0
        var highest = 0
        for _ in 0..<1000 {
            let question = LetterSpeedGenerator().next(using: &first)
            XCTAssertEqual(question, LetterSpeedGenerator().next(using: &second))
            XCTAssertEqual(question.choices.count, 4)
            if question.target == .highest { highest += 1 }
            let values = question.choices.map(\.value)
            let target = question.target == .highest ? values.max()! : values.min()!
            XCTAssertEqual(values.filter { $0 == target }.count, 1)
            XCTAssertEqual(values[question.correctIndex], target)
            for choice in question.choices {
                XCTAssertEqual(choice.rows.count, 10)
                for row in choice.rows {
                    XCTAssertTrue(row.first != nil || row.second != nil)
                    if row.first == nil { firstBlanks += 1 } else {
                        nonblankFirst += 1
                        if row.second == nil { secondBlanks += 1 }
                    }
                    let expected: Int
                    if let a = row.first, let b = row.second { expected = abs(a - b) }
                    else { expected = row.first ?? row.second! }
                    XCTAssertEqual(row.value, expected)
                }
            }
        }
        // Broad checks, not proof of an exact probability distribution.
        XCTAssertTrue((5_200...6_800).contains(firstBlanks))
        XCTAssertTrue((4_300...5_900).contains(secondBlanks))
        XCTAssertGreaterThan(nonblankFirst, 0)
        XCTAssertTrue((680...820).contains(highest))
    }
}
