PROJECT: MindSprint

CURRENT MILESTONE: 8 — Core UI and input system (IN PROGRESS)
CURRENT SUBTASK: 8C — Validate hardware key routing and haptic changes in CI; then UI/device verification remains.

LAST COMPLETED WORK: Added shared NumericInputAction mapping for digits, sign, decimal, delete, clear and submit; NumericKeypad routes iOS 17 hardware key events through it with focus, input-enabled and submission-lock gates. Added UIKit haptic feedback manager and persistent Haptics/Keypress haptics settings; touch and hardware keypad actions use optional light feedback. Two XCTest cases cover character mapping and input lock. Source is not yet compiled or tested on device; no game connects the keypad yet.

FILES CREATED OR MODIFIED: MindSprint/Input/NumericInputAction.swift, NumericKeypad.swift; MindSprint/Feedback/HapticFeedback.swift; MindSprint/ContentView.swift; MindSprintTests/NumericInputActionTests.swift; project-state HANDOFF.md, PROJECT_STATE.md, KNOWN_ISSUES.md and DECISIONS.md.

LATEST COMMIT: Inspect GitHub main for source and checkpoint. Local Git history is not synchronized due to ownership mismatch.

BUILD STATUS: New changes await CI. Last passing run 41089968056 at source 991467dc; ten tests and unsigned device build passed.

TEST STATUS: Two new action tests authored, not yet run. No hardware keyboard, haptic physical-device, navigation UI or multi-size visual checks performed.

KNOWN ISSUES: Keypad template is not yet reachable through a playable game; actual iOS focus and hardware key delivery not tested. No physical haptic validation. Game-specific calls to result feedback remain unintegrated. Records placeholders, gameplay absent, LiveContainer unverified. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Local Windows lacks Xcode/simulator; GitHub Actions can build and run XCTest. Visual and hardware-device checks require an appropriate environment.

NEXT EXACT TASK: Inspect CI for the 8C source commit; fix compile or test failures. After passing, update checkpoint and continue milestone 8 with simulator UI/navigation and keypad validation across screen sizes, plus hardware keyboard and haptic verification where feasible. Do not claim those checks passed without evidence; do not start milestone 9 until milestone 8 criteria are satisfied.

NEXT TASK ACCEPTANCE CRITERIA: 8C code compiles and relevant mapping tests pass; overall milestone 8 requires keypad/navigation interaction, hardware key support, haptics and multi-size usable layouts, with honest device limitations.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP and verify GitHub main/build. Full brief in docs/MASTER_BRIEF.md. One milestone or bounded subtask per session. Public repository approved. Never claim LiveContainer compatibility without physical verification.
