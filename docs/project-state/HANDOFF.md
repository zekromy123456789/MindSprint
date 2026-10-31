PROJECT: MindSprint

CURRENT MILESTONE: 10 — Arithmetic Pro (NOT STARTED). Milestone 9 Arithmetic is COMPLETED to simulator verification limits.
CURRENT SUBTASK: 10A — Design and test an independent Arithmetic Pro generator; use the researched specification and document any fidelity limits.

LAST COMPLETED WORK: Implemented Arithmetic difficulty selection, countdown, timed rounds, touch and hardware-key numeric input, canonical matching with automatic progression, score, hideable timer, final unanswered question, results and replay. Classic uses documented reference ranges; custom difficulty ranges are product choices. UI tests run a round using a DEBUG-only controlled clock; production timing remains 3 seconds plus 120 seconds. Earlier larger-simulator replay failed; after an atomic replay transition, two subsequent passing runs each showed one tap per simulator. The UI test permits one retry, so intermittent issues cannot be ruled out. Earlier active and result screenshots on both sizes showed no obvious clipping; the final-question addition was not separately visually reviewed.

FILES CREATED OR MODIFIED: MindSprint/Games/Arithmetic/ArithmeticGenerator.swift, ArithmeticRound.swift, ArithmeticGameView.swift; MindSprint/Engine/GameSession.swift; MindSprint/Input/NumericKeypad.swift; MindSprint/Screens/GamesHomeView.swift and GameLayouts.swift; MindSprint/ContentView.swift; ArithmeticGeneratorTests.swift, ArithmeticRoundTests.swift, MindSprintUITests.swift; project-state files and README.

LATEST COMMIT: Tested source 09f7f7e9bc06e13c827331b77ba5e588a0b372f5. Inspect GitHub main for the following documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41170294927 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41170294927 . IPA artifact 13030972723 expires 2027-01-29. Unsigned build success does not establish installation or LiveContainer compatibility.

TEST STATUS: 20 unit tests passed, plus five UI tests on each of iPhone 17 Pro and Pro Max simulators. The playthrough checks timer toggle, one correct answer, results with final question and replay; test-only clock advancement ends the round. Manual-clock unit tests cover timing and expiry. A previous run failed because accelerated test time expired while the simulator waited for idleness; the controlled test clock resolved that harness failure. Screenshot review covers earlier default light-mode active and results screens, not all configurations. Generator tests do not directly test statistical distribution.

KNOWN ISSUES: Real-device gameplay, hardware keyboard, haptics, VoiceOver and LiveContainer are unverified. Records are not saved; other games remain unavailable. Dark mode, larger text, final results layout and other device sizes need review. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Local Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Begin milestone 10 with a bounded, testable independent Arithmetic Pro question generator. Review docs/OPENQUANT_GAME_MECHANICS.md and the master brief first. The reference selects from a protected fixed pool; never copy it. Independently authored expressions and their distribution must be identified as provisional/custom unless fidelity can be established. Support correct operator precedence, valid division, negative results and reproducible seeded tests as justified by research; do not claim exact distribution. Keep other games disabled and avoid regressions to Arithmetic.

NEXT TASK ACCEPTANCE CRITERIA: Generator evaluates correctly across independently generated expressions, avoids invalid arithmetic and out-of-range indexing, includes meaningful deterministic and edge-case tests, passes CI, and clearly documents fidelity limitations. Milestone 10 remains in progress until gameplay and its full acceptance criteria are met.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Full requirements are in docs/MASTER_BRIEF.md. The user approved a public repository. Do not copy protected question pools. Never claim LiveContainer compatibility without physical verification.
