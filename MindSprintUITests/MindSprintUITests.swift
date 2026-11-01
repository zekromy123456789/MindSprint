import XCTest

final class MindSprintUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testCatalogPreparationAndSettings() {
        let app = XCUIApplication()
        app.launch()
        let arithmetic = app.buttons["game-arithmetic"]
        XCTAssertTrue(arithmetic.waitForExistence(timeout: 15))
        capture("catalog")
        arithmetic.tap()
        XCTAssertTrue(app.staticTexts["How to play"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["start-arithmetic"].isEnabled)
        capture("preparation")
        app.navigationBars.buttons.firstMatch.tap()
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.switches["Haptics"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Records"].tap()
        XCTAssertTrue(app.staticTexts["No records yet"].waitForExistence(timeout: 5))
    }

    func testArithmeticRoundAndReplay() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-arithmetic-fast")
        app.launch()
        XCTAssertTrue(app.buttons["game-arithmetic"].waitForExistence(timeout: 15))
        app.buttons["game-arithmetic"].tap()
        app.buttons["start-arithmetic"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        let first = app.staticTexts["arithmetic-first"]
        XCTAssertTrue(first.waitForExistence(timeout: 10))
        app.buttons["Hide timer"].tap()
        XCTAssertTrue(app.buttons["Show timer"].exists)
        app.buttons["Show timer"].tap()
        let left = Int(first.label)!
        let right = Int(app.staticTexts["arithmetic-second"].label)!
        let operation = app.staticTexts["arithmetic-operation"].label
        let answer: Int
        switch operation {
        case "+": answer = left + right
        case "−": answer = left - right
        case "×": answer = left * right
        case "÷": answer = left / right
        default: XCTFail("Unexpected operation: \(operation)"); return
        }
        if answer < 0 { app.buttons["Change sign"].tap() }
        for digit in String(abs(answer)) { app.buttons[String(digit)].tap() }
        XCTAssertTrue(app.staticTexts["Score: 1"].waitForExistence(timeout: 5))
        capture("arithmetic-active")
        app.buttons["Finish test round"].tap()
        XCTAssertTrue(app.staticTexts["Session complete"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["arithmetic-final-score"].label, "1")
        XCTAssertTrue(app.staticTexts["arithmetic-last-question"].exists)
        capture("arithmetic-results")
        app.buttons["Play again"].tap()
        if !app.buttons["Start test round"].waitForExistence(timeout: 5),
           app.buttons["Play again"].exists {
            app.buttons["Play again"].tap()
        }
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        XCTAssertTrue(app.staticTexts["arithmetic-first"].waitForExistence(timeout: 10))
    }

    func testArithmeticProRoundAndReplay() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-pro")
        app.launch()
        XCTAssertTrue(app.buttons["game-arithmeticPro"].waitForExistence(timeout: 15))
        app.buttons["game-arithmeticPro"].tap()
        XCTAssertTrue(app.staticTexts["Original questions"].waitForExistence(timeout: 5))
        app.buttons["pro-difficulty"].tap()
        app.buttons["Hard"].tap()
        app.buttons["start-pro"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        let question = app.staticTexts["pro-question"]
        XCTAssertTrue(question.waitForExistence(timeout: 20))
        XCTAssertEqual(app.staticTexts["pro-level"].label, "Hard")
        guard let answerText = question.value as? String, let answer = Int(answerText) else {
            XCTFail("Test answer is unavailable"); return
        }
        let wrong = answer == 9 ? "8" : "9"
        app.buttons[wrong].tap()
        XCTAssertTrue(app.staticTexts["Score: 0"].exists)
        app.buttons["Clear answer"].tap()
        if answer < 0 { app.buttons["Change sign"].tap() }
        for digit in String(abs(answer)) { app.buttons[String(digit)].tap() }
        XCTAssertTrue(app.staticTexts["Score: 1"].waitForExistence(timeout: 5))
        capture("pro-active")
        app.buttons["Finish test round"].tap()
        XCTAssertTrue(app.staticTexts["Session complete"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["pro-final-score"].label, "1")
        XCTAssertTrue(app.staticTexts["pro-last-question"].exists)
        capture("pro-results")
        app.buttons["Play again"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        XCTAssertTrue(app.staticTexts["pro-question"].waitForExistence(timeout: 15))
    }

    func testSequenceRoundAndReplay() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-sequence")
        app.launch()
        XCTAssertTrue(app.buttons["game-sequence"].waitForExistence(timeout: 15))
        app.buttons["game-sequence"].tap()
        app.buttons["sequence-difficulty"].tap()
        app.buttons["Expert"].tap()
        app.buttons["start-sequence"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        let question = app.staticTexts["sequence-question"]
        XCTAssertTrue(question.waitForExistence(timeout: 15))
        XCTAssertEqual(app.staticTexts["sequence-level"].label, "Expert")
        guard let value = question.value as? String, let answer = Int(value) else {
            XCTFail("Test answer is unavailable"); return
        }
        let wrong = answer == 9 ? "8" : "9"
        app.buttons[wrong].tap()
        XCTAssertTrue(app.staticTexts["Score: 0"].exists)
        app.buttons["Clear answer"].tap()
        if answer < 0 { app.buttons["Change sign"].tap() }
        for digit in String(abs(answer)) { app.buttons[String(digit)].tap() }
        XCTAssertTrue(app.staticTexts["Score: 1"].waitForExistence(timeout: 5))
        capture("sequence-active")
        app.buttons["Finish test round"].tap()
        XCTAssertTrue(app.staticTexts["Session complete"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["sequence-final-score"].label, "1")
        XCTAssertTrue(app.staticTexts["sequence-last-question"].exists)
        capture("sequence-results")
        app.buttons["Play again"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        XCTAssertTrue(app.staticTexts["sequence-question"].waitForExistence(timeout: 15))
        XCTAssertEqual(app.staticTexts["sequence-level"].label, "Expert")
    }

    func testKeypadEditingSubmissionAndReset() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-keypad")
        app.launch()
        XCTAssertTrue(app.buttons["Change sign"].waitForExistence(timeout: 15))
        app.buttons["Change sign"].tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["Decimal point"].tap()
        app.buttons["3"].tap()
        XCTAssertEqual(app.staticTexts["input-value"].label, "-12.3")
        capture("keypad")
        app.buttons["Submit"].tap()
        XCTAssertEqual(app.staticTexts["submitted-value"].label, "-12.3")
        XCTAssertFalse(app.buttons["Submit"].isEnabled)
        app.buttons["Reset"].tap()
        app.buttons["9"].tap()
        app.buttons["Delete last character"].tap()
        XCTAssertEqual(app.staticTexts["input-value"].label, "Empty")
    }
    func testHardwareKeyEntryAndSubmission() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-keypad")
        app.launch()
        XCTAssertTrue(app.buttons["Submit"].waitForExistence(timeout: 15))
        app.typeText("-12.34")
        app.typeText(XCUIKeyboardKey.delete.rawValue)
        XCTAssertEqual(app.staticTexts["input-value"].label, "-12.3")
        app.typeText(XCUIKeyboardKey.return.rawValue)
        XCTAssertEqual(app.staticTexts["submitted-value"].label, "-12.3")
        XCTAssertFalse(app.buttons["Submit"].isEnabled)
    }

    func testHapticPreferencePersists() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Settings"].tap()
        let haptics = app.switches["Haptics"]
        XCTAssertTrue(haptics.waitForExistence(timeout: 10))
        let original = haptics.value as? String
        haptics.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        let changedPredicate = NSPredicate { _, _ in (haptics.value as? String) != original }
        expectation(for: changedPredicate, evaluatedWith: haptics)
        waitForExpectations(timeout: 5)
        let changed = haptics.value as? String
        app.terminate()
        app.launch()
        app.tabBars.buttons["Settings"].tap()
        XCTAssertEqual(app.switches["Haptics"].value as? String, changed)
        app.switches["Haptics"].coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
    }

}
