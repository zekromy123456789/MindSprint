PROJECT: MindSprint

CURRENT MILESTONE: 16 — Letter Speed (IN PROGRESS). Milestone 15 Flexibility is COMPLETED to simulator verification limits.
CURRENT SUBTASK: 16E — Letter Speed custom question domains passed CI. They are not yet connected to gameplay or the picker.

LAST COMPLETED WORK: Added four tappable ten-row letter grids, highest/lowest prompt, per-question timer, progress, ten-round score, result review and replay. The first UI run 41343951538 failed because the grid choices lacked an accessible button trait; explicit button traits fixed it in source 6f717d13585b8e9da1475d692cbbfc5f8a60f181. Run 41345066774 passed. DEBUG-only frozen-clock controls exercise a correct answer, wrong answer, eight timeouts, results and replay; they are not in release. Grids have spoken row labels but VoiceOver has not been tested. Default light-mode active and results screenshots on iPhone 17 Pro and Pro Max were visually reviewed; grids and visible result rows showed no clipping or overlap. DEBUG-only controls are visible in those captures. Wording was clarified for equal-value pairs; run 41347270311 passed both simulator suites and the unsigned app build. The subsequent Classic label passed in run 41349614809. Custom generator domains then passed CI in run 41349614809. Generator/round source handles ties with a 128-try fallback, and delayed callbacks time out only one question and start the next clock when processed.

FILES CREATED OR MODIFIED: MindSprint/Games/LetterSpeed/LetterSpeedGameView.swift, LetterSpeedGenerator.swift and LetterSpeedRound.swift; MindSprint/Screens/GamesHomeView.swift; MindSprintUITests/MindSprintUITests.swift; MindSprintTests/LetterSpeedGeneratorTests.swift and LetterSpeedRoundTests.swift; README and project-state documents.

LATEST COMMIT: Tested source 15d690bc7e550898f78143b2e9b409c1cbbee750; inspect GitHub main for the subsequent documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41349614809 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41349614809 . IPA artifact 13101378118 expires 2027-01-30. Unsigned build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: 72 unit tests passed, plus 12 UI tests on each of iPhone 17 Pro and Pro Max. Letter Speed UI automation covers correct and incorrect choices, timeouts, score, results and replay. Physical device use, VoiceOver, Dynamic Type, small-phone layout, dark mode and actual backgrounding remain unverified.

KNOWN ISSUES: All eight games are playable in simulator; records are not saved. Risk Classic preserves the reference source's green-to-red probability fall-through. Memory's discrete card timing approximates unmeasured source spring duration. Pro question distribution differs from reference. Optiver avoids zero divisors and ambiguous hidden factors; fixed-point and normalized negative zero differ from source. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Connect difficulty selection to the round, question generation, replay and preparation screen in a later bounded step. Classic uses A–Z unchanged; custom Easy A–F, Normal A–L, Hard H–Z and Expert N–Z are independently chosen letter domains, not reference rules or guaranteed strictly increasing difficulty. Keep per-round rules unchanged, label the distinctions clearly, and keep future records separate by difficulty. Records remain milestone 17.

NEXT TASK ACCEPTANCE CRITERIA: Custom-domain tests and full CI passed; integration must preserve each selection through replay and expose its actual range. Do not mark milestone 16 complete without meeting the brief's acceptance criteria.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
