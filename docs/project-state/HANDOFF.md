PROJECT: MindSprint

CURRENT MILESTONE: 14 — Risk (NOT STARTED). Milestone 13 Memory is COMPLETED to simulator verification limits, with documented presentation pacing and safety deviations.
CURRENT SUBTASK: 14A — Risk seeded round rules, scoring and probabilities (NOT STARTED).

LAST COMPLETED WORK: Implemented Memory's original, reversed and ascending stages, string-preserving digits including leading zeros, three-digit starting length, explicit submission, +1 on success, increasing length, two failures per stage and results/replay. Uses a three-second countdown per stage and separate cards revealed in sequence; one-second lead-in and one second per digit are independent pacing choices because exact source spring settling duration was not established. Unlike the source's suspected premature-submit behavior, input is strictly gated until presentation finishes. Background interruption restarts countdown/presentation. A stronger UI test found card display did not update; fixed by storing the visible card index and verified each card in order. Run 41277730498 passed. Default light-mode screenshots of a visible card and results on two simulator sizes were reviewed without observed clipping. Test-only controls appear in captures.

FILES CREATED OR MODIFIED: MindSprint/Games/Memory/MemoryRound.swift and MemoryGameView.swift; MindSprintTests/MemoryRoundTests.swift; MindSprint/Screens/GamesHomeView.swift; MindSprintUITests/MindSprintUITests.swift; project-state documents and README.

LATEST COMMIT: Tested source bf33e0bbf078ef4c565c7e49f8fa5f531df11190; inspect GitHub main for the following documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41277730498 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41277730498 . IPA artifact 13072546062 expires 2027-01-30. Unsigned build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: 53 unit tests passed, plus nine UI tests on each of iPhone 17 Pro and Pro Max. Memory tests cover leading zeros/duplicates and all recall orders, correct and two-failure progressions, gated submission, stale actions, stage transitions, explicit card indices and interruption recovery with a manual clock. UI tests use a DEBUG-only frozen clock to advance cards, verify the first three reveals and input gating, complete stages and replay. Real-time UI playback, very long sequences, actual device background behavior, VoiceOver, Dynamic Type and dark mode remain unverified. Source animation settling timing is not exactly reproduced or claimed equivalent.

KNOWN ISSUES: Pro question distribution differs from the reference. Optiver intentionally avoids zero divisors and ambiguous hidden-factor questions, uses fixed point and normalizes negative zero; exact source PRNG and binary rounding equivalence is not claimed. Records are not saved; Risk, Flexibility and Letter Speed are unavailable. Hardware keyboard, haptics, physical device play and LiveContainer remain unverified. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Review Risk research in docs/OPENQUANT_GAME_MECHANICS.md and milestone 14 of docs/MASTER_BRIEF.md. Build a testable seeded game engine with 20 rounds, one initial unbanked point, four colors, game-level shuffled probability assignment, pump/pop/collect behavior and scoring. Source inspection suggests a green-color probability fall-through; explicitly decide and document the Classic behavior against evidence, without silently claiming an unobserved defect is verified. Inject randomness, guard duplicate/stale actions and test all terminal transitions. Do not enable gameplay until UI is integrated. Split into bounded subtasks as needed.

NEXT TASK ACCEPTANCE CRITERIA: Deterministic tests cover probability assignment, pump outcomes, collecting, pop forfeiture, round count, stale actions and completion; source fidelity/deviations are evidence-labeled, CI passes and Memory regression tests remain green.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and source research in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
