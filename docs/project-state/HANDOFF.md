PROJECT: MindSprint

CURRENT MILESTONE: 15 — Flexibility (NOT STARTED). Milestone 14 Risk is COMPLETED to simulator verification limits.
CURRENT SUBTASK: 15A — Flexibility prompt generation and timed scoring rules (NOT STARTED).

LAST COMPLETED WORK: Implemented Risk's 20 rounds, initial unbanked point, seeded four-color probability assignment, pump/pop/collect behavior, +1 on safe pump, banking and loss on pop, countdown, results and replay. Source reinspection confirmed the green case falls through to the red probability; Classic deliberately preserves that effective green=red behavior and retains the independently assigned green setting. This is source-code evidence, not a separately observed statistical measurement. Added large touch controls, color text and left/right arrow-key routing, plus deterministic tests and a full 20-round simulator playthrough. Initial CI attempt failed in an existing Arithmetic Pro test because the simulator lost its background assertion; the second attempt passed the full suite. Default light-mode Risk active/results screenshots on two simulator sizes were reviewed without obvious clipping.

FILES CREATED OR MODIFIED: MindSprint/Games/Risk/RiskRound.swift and RiskGameView.swift; MindSprint/Input/RiskKeyReceiver.swift; MindSprintTests/RiskRoundTests.swift; MindSprint/Screens/GamesHomeView.swift; MindSprintUITests/MindSprintUITests.swift; project-state files and README.

LATEST COMMIT: Tested source dc327d6a2023b89820b187d35556fe0174f912e9; inspect GitHub main for the following documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41331629289 attempt 2 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41331629289/attempts/2 . IPA artifact 13094955630 expires 2027-01-30. Unsigned build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: 57 unit tests passed, plus ten UI tests on each of iPhone 17 Pro and Pro Max. Risk unit tests cover probability assignment, green-to-red behavior, pump, pop, collect, score, 20 rounds, stale actions and deterministic seed; UI test exercises actual Pump, collecting through completion and replay with a DEBUG-only frozen countdown clock. Risk arrow-key routing is implemented but has not been tested with a physical keyboard or synthetic arrow events. Physical haptics, VoiceOver, Dynamic Type, dark mode, actual background behavior and real-device play remain unverified.

KNOWN ISSUES: Risk source green probability fall-through is intentionally preserved; exact source PRNG sequences are not reproduced. Memory's discrete card timing approximates unmeasured source spring duration. Pro question distribution differs from reference. Optiver avoids zero divisors and ambiguous hidden factors; fixed-point and normalized negative zero differ from source. Records are not saved; Flexibility and Letter Speed are unavailable. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Review Flexibility research in docs/OPENQUANT_GAME_MECHANICS.md and milestone 15 of docs/MASTER_BRIEF.md. Independently implement testable prompt generation: left word, left color and right word are independently selected from blue/black/red; right color samples those colors plus an extra left-word-color entry, producing nominal half matches. Correct answer compares left word to right text color; right word and left color are distractors. Use three-second countdown, 60-second monotonic session, +1/-1 scoring, token-based stale/expiry protection and seeded tests. Left arrow/No means unequal, right arrow/Yes means equal. Split engine/UI work into bounded steps; do not enable until integrated. Label any intentional deviations and preserve existing game regressions.

NEXT TASK ACCEPTANCE CRITERIA: Deterministic tests cover correct comparison, nominal selection mechanism, scoring, countdown, deadline, duplicate/stale actions and completion; CI passes. Milestone 15 remains in progress until UI, results, accessibility and other brief criteria are met.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
