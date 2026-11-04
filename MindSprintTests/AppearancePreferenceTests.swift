import XCTest
import SwiftUI
@testable import MindSprint

final class AppearancePreferenceTests: XCTestCase {
    func testEachPreferenceUsesTheExpectedColorScheme() {
        XCTAssertNil(AppearancePreference.system.colorScheme)
        XCTAssertEqual(AppearancePreference.light.colorScheme, .light)
        XCTAssertEqual(AppearancePreference.dark.colorScheme, .dark)
        XCTAssertEqual(AppearancePreference.allCases.map(\.rawValue), ["system", "light", "dark"])
    }
}
