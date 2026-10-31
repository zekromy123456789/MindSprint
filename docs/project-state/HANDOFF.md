PROJECT: MindSprint

CURRENT MILESTONE: 10 — Arithmetic Pro (IN PROGRESS). Milestone 9 Arithmetic is completed to simulator verification limits.
CURRENT SUBTASK: 10C — Add and verify independently chosen Pro difficulty options; current Pro uses one custom question level.

LAST COMPLETED WORK: Added an independently authored Pro generator with five expression shapes, bounded operands, exact nonzero division, negative answers and canonical string matching. An independent parser checks 4,000 displayed generated expressions, and seeded tests check repeatability. Added Pro timed round, keypad, countdown, scoring, timer control, final question, results and replay. The preparation screen says its question mix differs from the reference. Pro and Arithmetic end-to-end playthroughs passed on both simulator sizes. The integrated build was visually reviewed using default light-mode active and results screenshots from run 41172831954, with no obvious clipping; DEBUG-only test controls appear in those captures. The app's game timing uses a monotonic clock. DEBUG-only UI clocks were subsequently frozen and controlled by tests after an older run failed when simulator idleness consumed the test round; production timing is unchanged.

FILES CREATED OR MODIFIED: MindSprint/Games/ArithmeticPro/ArithmeticProGenerator.swift, ArithmeticProRound.swift and ArithmeticProGameView.swift; MindSprintTests/ArithmeticProGeneratorTests.swift and ArithmeticProRoundTests.swift; MindSprint/Screens/GamesHomeView.swift; MindSprint/Games/Arithmetic/ArithmeticGameView.swift; MindSprintUITests/MindSprintUITests.swift; project-state documents and README.

LATEST COMMIT: Tested source d41b42b982ec5f46eca6f17349c7846484933814; inspect GitHub main for the subsequent documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41173426893 passed simulator suites and unsigned arm64 device app/IPA checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41173426893 . IPA artifact 13032263502 expires 2027-01-29. Build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: 26 unit tests passed, plus six UI tests on each of iPhone 17 Pro and Pro Max. Pro UI test covers wrong and correct answers, results, final question and replay, with a DEBUG-only frozen clock; manual-clock tests cover countdown and deadlines. Actual physical device, background handling, hardware keyboard, VoiceOver and haptics remain unverified. Prior Arithmetic replay UI failure did not recur, but its test permits one retry. Only captured default light-mode screens were visually reviewed; accessibility sizes, dark mode and other sizes need QA.

KNOWN ISSUES: Pro's generator is a custom approximation, not the protected fixed pool or its distribution, and offers only one level. Its internal session configuration uses .normal; no Classic fidelity claim is made. Pro and Arithmetic round/view code currently duplicate behavior and may need careful maintenance or later consolidation. Records are not saved and the remaining six games are unavailable. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Add independently chosen Pro difficulty variants to generator and preparation screen, with clear custom labeling and documentation of operand ranges and expression complexity; avoid implying the reference distribution has been reproduced. Preserve the current original level and canonical/timing/scoring behavior. Add deterministic tests covering every difficulty, exact division, negative/zero and bounded integer arithmetic, plus UI coverage of selection and round setup. Run CI and update checkpoint. Split further if appropriate.

NEXT TASK ACCEPTANCE CRITERIA: Each offered Pro level produces valid independently evaluated expressions within documented limits; selection actually affects generation, exact division and scoring remain correct, existing Arithmetic regression and Pro UI tests pass. Keep milestone 10 in progress until all brief acceptance criteria are met.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Full requirements are in docs/MASTER_BRIEF.md and source findings in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Do not copy protected question pools; never claim exact Pro distribution or LiveContainer compatibility without evidence.
