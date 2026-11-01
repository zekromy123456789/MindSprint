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

    func testOptiverRoundResultsAndReplay() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-optiver")
        app.launch()
        XCTAssertTrue(app.buttons["game-optiver"].waitForExistence(timeout: 15))
        app.buttons["game-optiver"].tap()
        app.buttons["optiver-difficulty"].tap()
        app.buttons["Easy"].tap()
        app.buttons["start-optiver"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        let question = app.staticTexts["optiver-question"]
        XCTAssertTrue(question.waitForExistence(timeout: 15))
        XCTAssertEqual(app.staticTexts["optiver-level"].label, "Easy")
        guard let value = question.value as? String, let answer = Int(value) else {
            XCTFail("Test answer is unavailable"); return
        }
        let buttons = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "optiver-choice-"))
        let wrong = buttons.allElementsBoundByIndex.first { $0.identifier != "optiver-choice-\(answer)" }
        XCTAssertNotNil(wrong)
        wrong?.tap()
        XCTAssertTrue(app.staticTexts["Score: -2"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["optiver-progress"].label, "Question 2 / 80")
        guard let nextValue = question.value as? String, let nextAnswer = Int(nextValue) else {
            XCTFail("Next test answer is unavailable"); return
        }
        app.buttons["optiver-choice-\(nextAnswer)"].tap()
        XCTAssertTrue(app.staticTexts["Score: -1"].waitForExistence(timeout: 5))
        capture("optiver-active")
        app.buttons["Finish test round"].tap()
        XCTAssertTrue(app.staticTexts["Session complete"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["optiver-final-score"].label, "Score: -1")
        XCTAssertEqual(app.staticTexts["optiver-answered"].label, "2 of 80 answered")
        XCTAssertEqual(app.staticTexts["optiver-result-0"].label, "Incorrect")
        XCTAssertEqual(app.staticTexts["optiver-result-1"].label, "Correct")
        XCTAssertEqual(app.staticTexts["optiver-result-2"].label, "Unanswered")
        capture("optiver-results")
        app.buttons["Play again"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        XCTAssertTrue(app.staticTexts["optiver-progress"].waitForExistence(timeout: 15))
        XCTAssertEqual(app.staticTexts["optiver-progress"].label, "Question 1 / 80")
        XCTAssertEqual(app.staticTexts["optiver-level"].label, "Easy")
    }

    func testMemoryStagesAndReplay() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-memory")
        app.launch()
        let memory = app.buttons["game-memory"]
        if !memory.isHittable { app.swipeUp() }
        XCTAssertTrue(memory.waitForExistence(timeout: 15))
        memory.tap()
        app.buttons["start-memory"].tap()
        XCTAssertTrue(app.staticTexts["Round 1 / 3"].waitForExistence(timeout: 10))
        for stage in 1...3 {
            XCTAssertTrue(app.staticTexts["Round \(stage) / 3"].waitForExistence(timeout: 10))
            app.buttons["Start round"].tap()
            app.buttons["Start test presentation"].tap()
            if stage == 1 {
                XCTAssertFalse(app.buttons["Submit"].exists)
                for index in 0..<3 {
                    app.buttons["Advance test playback"].tap()
                    let label = app.staticTexts["memory-digit-\(index)"].label
                    XCTAssertTrue(label.hasPrefix("Digit \(index + 1): "))
                    XCTAssertFalse(label.contains("hidden"))
                    if index == 0 { capture("memory-visible-digit") }
                    XCTAssertFalse(app.buttons["Submit"].exists)
                }
                app.buttons["Advance test playback"].tap()
                let answer = app.staticTexts["memory-answer"]
                XCTAssertTrue(answer.waitForExistence(timeout: 10))
                guard let correct = answer.value as? String else { XCTFail("Test answer is unavailable"); return }
                for digit in correct { app.buttons[String(digit)].tap() }
                app.buttons["Submit"].tap()
                XCTAssertTrue(app.staticTexts["memory-status"].label.contains("4 digits"))
            } else {
                capture("memory-stage-\(stage)")
            }
            for _ in 0..<2 {
                XCTAssertTrue(app.buttons["Finish test presentation"].waitForExistence(timeout: 10))
                app.buttons["Finish test presentation"].tap()
                let answer = app.staticTexts["memory-answer"]
                XCTAssertTrue(answer.waitForExistence(timeout: 10))
                guard let correct = answer.value as? String, let first = correct.first else {
                    XCTFail("Test answer is unavailable"); return
                }
                let wrong = (first == "9" ? "8" : "9") + String(correct.dropFirst())
                for digit in wrong { app.buttons[String(digit)].tap() }
                app.buttons["Submit"].tap()
            }
        }
        XCTAssertTrue(app.staticTexts["Session complete"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["memory-final-score"].label, "1")
        capture("memory-results")
        app.buttons["Play again"].tap()
        XCTAssertTrue(app.staticTexts["Round 1 / 3"].waitForExistence(timeout: 10))
    }

    func testRiskRoundAndReplay() {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-test-risk")
        app.launch()
        let risk = app.buttons["game-risk"]
        if !risk.isHittable { app.swipeUp() }
        XCTAssertTrue(risk.waitForExistence(timeout: 15))
        risk.tap()
        app.buttons["start-risk"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        XCTAssertTrue(app.staticTexts["risk-progress"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.staticTexts["risk-progress"].label, "Round 1 / 20")
        XCTAssertEqual(app.staticTexts["risk-unbanked"].label, "Unbanked: 1")
        capture("risk-active")
        app.buttons["Pump"].tap()
        for _ in 0..<20 {
            if app.staticTexts["Session complete"].exists { break }
            app.buttons["Collect"].tap()
        }
        XCTAssertTrue(app.staticTexts["Session complete"].waitForExistence(timeout: 10))
        XCTAssertTrue(["19", "21"].contains(app.staticTexts["risk-final-score"].label))
        capture("risk-results")
        app.buttons["Play again"].tap()
        XCTAssertTrue(app.buttons["Start test round"].waitForExistence(timeout: 10))
        app.buttons["Start test round"].tap()
        XCTAssertEqual(app.staticTexts["risk-progress"].label, "Round 1 / 20")
        XCTAssertEqual(app.staticTexts["risk-unbanked"].label, "Unbanked: 1")
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
