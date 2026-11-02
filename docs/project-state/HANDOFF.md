PROJECT: MindSprint

CURRENT MILESTONE: 17 — Local leaderboards and statistics (IN PROGRESS). Milestone 16 Letter Speed is COMPLETED to simulator verification limits.
CURRENT SUBTASK: 17B/17C — Letter Speed completed-session saving and difficulty-filtered Records UI authored; CI pending. Other games are not integrated.

LAST COMPLETED WORK: Letter Speed now offers Classic A–Z and independent custom domains Easy A–F, Normal A–L, Hard H–Z and Expert N–Z. The selected difficulty flows through round generation and replay; custom range difficulty is not proven strictly ordered. The reference snapshot has no adaptive progression. Added a SQLite-backed SessionRecord store with schema version 1, explicit rejection of future schema versions, duplicate and input validation, and summary grouping by game, difficulty, mode, rules version and duration. Completed sessions alone contribute to best and average; abandoned and invalid sessions remain representable. Records are not integrated into games or UI. CI run 41398019339 passed. Default light-mode Classic active/results screenshots from the earlier build were reviewed; the new difficulty picker was not visually reviewed. VoiceOver, small phones and actual background behavior remain unverified.

FILES CREATED OR MODIFIED: MindSprint/Records/SessionRecord.swift and RecordStore.swift; MindSprintTests/RecordStoreTests.swift; project.yml; LetterSpeedRound.swift, LetterSpeedGameView.swift, GamesHomeView.swift, LetterSpeedRoundTests.swift and MindSprintUITests.swift; project-state documents.

LATEST COMMIT: Tested source 48463c1911e2738fd3745118570a5836e8759ded; inspect main for the documentation checkpoint. Local Git history remains unsynchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41398019339 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41398019339 . IPA artifact 13120069129 expires 2027-01-31. Installation and LiveContainer compatibility are unverified.

TEST STATUS: 77 unit tests passed, plus 12 UI tests on each of iPhone 17 Pro and Pro Max. Letter Speed tests cover Expert domain throughout a round and selected difficulty through replay. Record tests cover SQLite reopening, duplicate rejection, invalid inputs, score grouping and unsupported future schema. Real-device persistence, concurrent access and upgrades from a future schema are unverified.

KNOWN ISSUES: Letter Speed records integration and the Records tab are authored but awaiting CI; the other games do not write session records. Schema 1 is an initial baseline, not a tested migration from an older application database. Physical device use, actual backgrounding, VoiceOver, Dynamic Type, dark mode and the new difficulty picker layout need QA. Risk preserves reference green-to-red probability fall-through; Memory timing approximates unmeasured source animation; Pro distribution differs from the reference; Optiver uses documented arithmetic safeguards. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Check CI for Letter Speed record saving and the Records tab; fix any failures. Saving uses a stable session UUID, completion time, difficulty and actual score/correct/incorrect counts; timeout counts are not treated as incorrect and uncollected timings remain absent. The UI-test database is isolated from production. Then integrate the remaining games and expand statistics incrementally.

NEXT TASK ACCEPTANCE CRITERIA: Verify that Letter Speed completed results survive app relaunch and are saved once, errors are surfaced, and incompatible difficulties remain separated. Milestone 17 is incomplete until all games, history, rankings, statistics, migration and acceptance criteria are addressed.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
