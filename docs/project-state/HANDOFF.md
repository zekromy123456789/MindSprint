PROJECT: MindSprint

CURRENT MILESTONE: 8 — Core UI and input system (IN PROGRESS)
CURRENT SUBTASK: 8D — Validate new simulator UI tests and screenshots in CI; inspect visual results.

LAST COMPLETED WORK: Added debug-only keypad harness, XCUITest catalog/preparation/settings/records and keypad editing/submission checks, screenshot attachments, and standard/large iPhone simulator selection plus second UI test run. Release builds do not expose the harness. Changes await CI; no navigation, keypad visual layout, hardware keyboard or physical haptic verification is yet claimed.

FILES CREATED OR MODIFIED: MindSprint/MindSprintApp.swift, MindSprint/Screens/GamesHomeView.swift, MindSprintUITests/MindSprintUITests.swift, project.yml, scripts/select_simulator.py, .github/workflows/ios.yml; project-state HANDOFF.md, PROJECT_STATE.md and KNOWN_ISSUES.md.

LATEST COMMIT: Inspect GitHub main for UI-test source commit. Local Git history not synchronized due to ownership mismatch.

BUILD STATUS: New UI tests and two-simulator workflow await CI. Last passing run 41091082669 at source 68af9c3; twelve unit tests and unsigned device build passed.

TEST STATUS: New XCUITests authored, not yet run. YAML parsed locally. Simulator selection requires both a standard and a Max/Plus iPhone; if runner lacks either it fails explicitly.

KNOWN ISSUES: Test-only harness is DEBUG-only; real keypad remains unconnected to a playable game. Physical haptic feel, hardware key focus/delivery and LiveContainer are unverified. Screenshot attachments require inspection. No games implemented. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Local Windows lacks Xcode/simulator; GitHub Actions needed. Physical hardware and haptic validation require device.

NEXT EXACT TASK: Inspect CI for UI-test source commit. Fix build, selection or UI-test failures. On success, inspect retained screenshots from both xcresult bundles if tools permit; record exact devices and results, and document physical hardware limitations. Continue milestone 8 until acceptance criteria met; do not begin milestone 9 in same session.

NEXT TASK ACCEPTANCE CRITERIA: Catalog navigation and keypad interaction tested; layouts reviewed on different iPhone sizes where feasible; hardware and haptics validated to environment limits and unverified physical behavior explicit.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP, verify GitHub main/build. Full brief in docs/MASTER_BRIEF.md. One milestone or bounded subtask per session. Public repo approved. Never claim LiveContainer compatibility without physical verification.
