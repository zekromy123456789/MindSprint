PROJECT: MindSprint

CURRENT MILESTONE: 11 — Sequence (IN PROGRESS). Milestone 10 Arithmetic Pro is COMPLETED to simulator verification limits, with an explicitly custom question distribution.
CURRENT SUBTASK: 11B — Sequence Classic timed round and UI authored, including tests; CI pending. 11A generator passed CI.

LAST COMPLETED WORK: Authored Sequence Classic round and UI, countdown, automatic matching and scoring, final question, replay, and manual-clock and end-to-end tests. Exhaustive documented-pattern check found 10,621 prefixes and no conflicting generated answers. These changes await CI; additional Sequence difficulty options remain unimplemented. Previously added four original Pro difficulty levels: Easy main operands 2...10/small factors 2...5; Normal 2...20/2...12; Hard 2...35/2...15; Expert 2...60/2...20. All use the same five independent expression shapes, exact division, canonical answers and tested round timing. Selection reaches the round; UI tests select Hard and play. The app explicitly says the question mix differs from the reference; it does not copy the protected pool or claim exact distribution. Added Sequence generation for the four reference families and their documented ranges, random reversal and canonical hidden answers. Sequence Classic gameplay is authored but awaits CI.

FILES CREATED OR MODIFIED: MindSprint/Games/ArithmeticPro/ArithmeticProGenerator.swift, ArithmeticProRound.swift and ArithmeticProGameView.swift; MindSprint/Screens/GamesHomeView.swift; MindSprintTests/ArithmeticProGeneratorTests.swift and ArithmeticProRoundTests.swift; MindSprintUITests/MindSprintUITests.swift; MindSprint/Games/Sequence/SequenceGenerator.swift and MindSprintTests/SequenceGeneratorTests.swift; project-state documents and README.

LATEST COMMIT: Inspect main for pending Sequence gameplay source; prior tested source 13be35d7f0a3e40661e586b02a1ef65c4be1f434; inspect GitHub main for the subsequent documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: Sequence gameplay awaits CI. Previously GitHub Actions run 41216164324 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41216164324 . IPA artifact 13048408750 expires 2027-01-29. Unsigned build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: Sequence round and UI tests await CI. Previously 31 unit tests passed, plus six UI tests on each of iPhone 17 Pro and Pro Max. Pro tests exercise all level generators, independent expression evaluation, seed repeatability, round difficulty selection and an end-to-end Hard playthrough. Sequence tests cover 8,000 generated examples across families, value ranges, both directions, canonical answers and repeatability; they do not statistically prove random distributions or prove pattern uniqueness for arbitrary mathematical rules. UI playthroughs use DEBUG-only frozen clocks; manual clocks cover countdown/deadline. Prior default light-mode screenshots of Pro active and result layouts were reviewed on both sizes before adding difficulty; newest difficulty screen has not been visually reviewed.

KNOWN ISSUES: Pro's question pool and distributions are independent approximations, not exact reference behavior. Physical device gameplay, hardware keyboard, haptics, VoiceOver, background behavior and LiveContainer remain unverified. Records are not saved; Sequence gameplay awaits CI, and five other games are unavailable. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Inspect CI for Sequence Classic gameplay, fix any failures, and review active/results screenshots on both simulator sizes. Sequence difficulty options are not yet implemented. Use documented reference families and ranges; any additional difficulty options must be clearly labeled custom. Add meaningful state/timing and end-to-end UI tests; preserve Arithmetic and Pro regressions. Split into bounded steps as needed. Do not claim persistent records before implementation.

NEXT TASK ACCEPTANCE CRITERIA: Full Sequence flow matches documented rules and is playable through results and replay, with tests and simulator/device-build evidence. Keep milestone 11 in progress until all acceptance criteria are satisfied.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Full requirements are in docs/MASTER_BRIEF.md, source research in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim exact Pro distribution or LiveContainer compatibility without evidence.
