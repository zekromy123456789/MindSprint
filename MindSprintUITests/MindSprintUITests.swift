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
        XCTAssertFalse(app.buttons["Coming soon"].isEnabled)
        capture("preparation")
        app.navigationBars.buttons.firstMatch.tap()
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.switches["Haptics"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Records"].tap()
        XCTAssertTrue(app.staticTexts["No records yet"].waitForExistence(timeout: 5))
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
}
