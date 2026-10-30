import XCTest
@testable import MindSprint

final class NumericInputActionTests: XCTestCase {
    func testHardwareCharacterMappingIsRestricted() {
        XCTAssertEqual(NumericInputAction.character("0"), .digit(0))
        XCTAssertEqual(NumericInputAction.character("9"), .digit(9))
        XCTAssertEqual(NumericInputAction.character("-"), .toggleSign)
        XCTAssertEqual(NumericInputAction.character("."), .decimal)
        XCTAssertNil(NumericInputAction.character("12"))
        XCTAssertNil(NumericInputAction.character("a"))
        XCTAssertNil(NumericInputAction.character(""))
    }

    func testActionsRespectVariantsAndSubmissionLock() {
        var input = NumericInput(allowsNegative: false, allowsDecimal: false)
        XCTAssertNil(input.apply(.toggleSign))
        XCTAssertNil(input.apply(.decimal))
        XCTAssertNil(input.apply(.submit))
        XCTAssertNil(input.apply(.digit(2)))
        XCTAssertEqual(input.apply(.submit), "2")
        XCTAssertNil(input.apply(.digit(4)))
        XCTAssertNil(input.apply(.submit))
        XCTAssertEqual(input.text, "2")
        input.reset()
        _ = input.apply(.digit(3))
        _ = input.apply(.backspace)
        XCTAssertEqual(input.text, "")
    }
}
