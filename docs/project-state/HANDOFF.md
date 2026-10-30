PROJECT: MindSprint

CURRENT MILESTONE: 8 — Core UI and input system (NOT STARTED)
CURRENT SUBTASK: Implement core navigation, design and input in bounded testable pieces; split as needed.

LAST COMPLETED WORK: Milestone 7 introduced UI-independent game IDs and difficulty configuration, game-rules protocol, score policy, session lifecycle, injectable ContinuousClock monotonic time and deterministic SplitMix64 RNG. Five new XCTest cases cover seeded output, expiry, lifecycle, scoring and overflow. GitHub Actions run 41086929248 at source commit 3c64e43bf73ec9d796e78f162bb8b93bd6198fe6 passed six total tests, device build, arm64/ZIP checks and IPA upload.

FILES CREATED OR MODIFIED: MindSprint/Engine/GameModels.swift, GameSession.swift, SeededRandomNumberGenerator.swift; MindSprintTests/GameEngineTests.swift; docs/project-state/ROADMAP.md, HANDOFF.md, PROJECT_STATE.md, DECISIONS.md, KNOWN_ISSUES.md.

LATEST COMMIT: Inspect GitHub main for checkpoint; last tested source commit 3c64e43bf73ec9d796e78f162bb8b93bd6198fe6. Local Git history is not synchronized to GitHub due to ownership mismatch.

BUILD STATUS: Passed run https://github.com/zekromy123456789/MindSprint/actions/runs/41086929248; unsigned arm64 IPA artifact https://github.com/zekromy123456789/MindSprint/actions/runs/41086929248/artifacts/12993300058 expires 2027-01-28. This remains a scaffold without playable games.

TEST STATUS: Six XCTest tests passed, zero failures (five engine plus one existing smoke test).

KNOWN ISSUES: No gameplay. Session callers must refresh on background return; per-question duplicate input prevention and progression are game-specific and not implemented. Reference discrepancies and risks remain in mechanics report. Physical LiveContainer compatibility unverified. XcodeGen unpinned. Local Git ownership mismatch persists.

CURRENT BLOCKERS: None identified for milestone 8; local Windows lacks Xcode, use GitHub Actions.

NEXT EXACT TASK: Begin milestone 8 only. Inspect scaffold and requirements in MASTER_BRIEF.md section 18 and keypad details in section 9. Build design/navigation, preparation, gameplay/results templates, persistent numeric keypad with sign/decimal/backspace/clear and hardware input, haptic manager. Split into independently testable subtasks if necessary; do not claim games are playable. Run appropriate tests and CI, update checkpoint and stop.

NEXT TASK ACCEPTANCE CRITERIA: App builds, navigation works, keypad functional with tested edge cases and hardware keyboard support, core UI usable across iPhone sizes, haptics available. Document unverified visual/device checks.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP, verify GitHub main/build. Full brief in docs/MASTER_BRIEF.md. One milestone or bounded subtask per session. User approved public repository. No runtime web dependency; use independently written code. Never claim LiveContainer compatibility without physical verification.
