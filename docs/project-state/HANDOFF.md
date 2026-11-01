PROJECT: MindSprint

CURRENT MILESTONE: 11 — Sequence (IN PROGRESS). Milestone 10 Arithmetic Pro is completed to simulator verification limits, with an explicitly custom question distribution.
CURRENT SUBTASK: 11C — Custom Sequence difficulty options and tests authored; CI pending. Sequence Classic generator, timed round and UI passed CI.

LAST COMPLETED WORK: Connected Sequence Classic generator to a three-second countdown, 120-second monotonic session, four visible terms, numeric keypad, canonical answer matching with automatic +1 progression, timer control, final question/results and replay. Manual-clock tests cover countdown, correct/incorrect answers, stale callbacks, expiry and abandonment. An exhaustive finite-domain test enumerates all documented Classic generator parameters and both directions, finding 10,621 distinct four-term prefixes and no conflicting generated fifth term. This does not prove uniqueness among arbitrary mathematical rules. End-to-end UI tests pass for a complete round and replay. Sequence currently offers Classic only; the master brief includes difficulty and milestone 11 remains open.

FILES CREATED OR MODIFIED: MindSprint/Games/Sequence/SequenceRound.swift and SequenceGameView.swift; MindSprintTests/SequenceRoundTests.swift and SequenceGeneratorTests.swift; MindSprint/Screens/GamesHomeView.swift; MindSprintUITests/MindSprintUITests.swift; project-state documents and README.

LATEST COMMIT: Inspect main for Sequence difficulty source; prior tested source fd32a2840eb6b4769b14135d7d976124016a883b; inspect GitHub main for the subsequent documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: Sequence difficulty changes await CI. Previously GitHub Actions run 41217634479 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41217634479 . IPA artifact 13049032202 expires 2027-01-29. Unsigned build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: New difficulty tests await CI. Previously 36 unit tests passed, plus seven UI tests on each of iPhone 17 Pro and Pro Max. UI tests cover wrong/correct answers, score, results, last question and replay with DEBUG-only frozen clocks; manual-clock tests cover deadlines. Captured default light-mode Sequence active and result screens were visually reviewed on both sizes with no observed clipping. Captures include DEBUG-only controls and sample only one question; worst-case long sequences, larger text, dark mode, physical devices, VoiceOver and actual background behavior remain unverified.

KNOWN ISSUES: Sequence custom difficulties are authored but not yet verified. Pro's question pool and distributions are independent approximations, not exact reference behavior. Physical device gameplay, hardware keyboard, haptics and LiveContainer remain unverified. Records are not saved; five other games are unavailable. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Verify Sequence difficulty changes in CI, fix failures, and close milestone 11 only if acceptance criteria pass. Then begin Optiver generator work. Guarantee that generated four-term prefixes do not have conflicting answers within each offered generator domain; prefer subsets of the verified Classic domain or exhaustively check any expanded domain. Ensure difficulty choices meaningfully differ, document mechanics, connect selection through generator/round/view and replay, and add deterministic tests and UI coverage. Verify worst-case long sequences and accessibility sizes where feasible. Run CI; only close milestone 11 when the brief's full acceptance criteria pass.

NEXT TASK ACCEPTANCE CRITERIA: Documented levels produce valid unambiguous generated questions, selection actually affects each round and replay, Classic remains unchanged, existing Sequence and Arithmetic regression tests pass, and simulator/device build evidence is recorded.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Full requirements are in docs/MASTER_BRIEF.md, source research in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim exact Pro distribution or LiveContainer compatibility without evidence.
