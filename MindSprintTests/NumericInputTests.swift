import XCTest
@testable import MindSprint

final class NumericInputTests: XCTestCase {
    func testNegativeToggleAndDeletion() {
        var input = NumericInput()
        input.toggleSign()
        XCTAssertNil(input.submit())
        input.appendDigit(4)
        input.appendDigit(2)
        XCTAssertEqual(input.text, "-42")
        input.toggleSign()
        XCTAssertEqual(input.text, "42")
        input.backspace()
        XCTAssertEqual(input.text, "4")
        input.clear()
        XCTAssertEqual(input.text, "")
    }

    func testDecimalsAreBoundedAndMustBeComplete() {
        var input = NumericInput(allowsDecimal: true, maxDigits: 3)
        input.toggleSign()
        input.appendDecimal()
        XCTAssertEqual(input.text, "-0.")
        XCTAssertNil(input.submit())
        input.appendDecimal()
        input.appendDigit(1)
        input.appendDigit(2)
        input.appendDigit(3)
        XCTAssertEqual(input.text, "-0.12")
        XCTAssertEqual(input.submit(), "-0.12")
    }

    func testEmptyAndDuplicateSubmissionsAreRejectedUntilReset() {
        var input = NumericInput()
        XCTAssertNil(input.submit())
        input.appendDigit(0)
        input.appendDigit(0)
        input.appendDigit(7)
        XCTAssertEqual(input.submit(), "007")
        XCTAssertNil(input.submit())
        input.backspace()
        input.clear()
        XCTAssertEqual(input.text, "007")
        input.reset()
        input.appendDigit(2)
        XCTAssertEqual(input.submit(), "2")
    }

    func testDisabledVariantsAndInvalidDigits() {
        var input = NumericInput(allowsNegative: false, allowsDecimal: false, maxDigits: 1)
        input.toggleSign()
        input.appendDecimal()
        input.appendDigit(-1)
        input.appendDigit(10)
        XCTAssertEqual(input.text, "")
        input.appendDigit(9)
        input.appendDigit(1)
        XCTAssertEqual(input.text, "9")
    }
}
