PROJECT: MindSprint

CURRENT MILESTONE: 17 — Local leaderboards and statistics (IN PROGRESS). Milestone 16 Letter Speed is completed to simulator verification limits.
CURRENT SUBTASK: 17L–17O — Abandoned-session history, completed/abandoned filter and in-memory retry passed CI. Advanced statistics remain unfinished.

LAST COMPLETED WORK: Leaving a game after it has started records an abandoned session for all eight games using the same stable ID and actual score/configuration; leaving before play starts does not create history. Timed games refresh on exit, and if the deadline crosses between their two exit checks they record completion instead of abandonment. Completed and abandoned history are separately filterable; only completed sessions contribute to personal best, count and average. Failed saves remain in an in-memory retry queue with an app-level alert and a Retry saving button in Records. The queue is lost if the app terminates before retry; force termination is not recorded as an abandonment. Tests cover all eight games, pre-play exits, expiry races, duplicate prevention, retry, filtering and relaunch. CI run 41544443226 passed.

FILES CREATED OR MODIFIED: All eight game round and view files; MindSprint/Records/ArithmeticRecords.swift, LetterSpeedRecord.swift, SequenceOptiverRecords.swift, MemoryRiskFlexibilityRecords.swift and RecordsManager.swift; MindSprint/Screens/RecordsView.swift; MindSprint/ContentView.swift; MindSprintTests/AbandonedRecordTests.swift and MindSprintUITests.swift; project-state files.

LATEST COMMIT: Tested source 850c90ff606aa8103d28a431b0c71d2ed2650174; inspect main for documentation checkpoint. Local Git history remains unsynchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41544443226 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41544443226 . IPA artifact 13188474970 expires 2027-01-31. Installation and LiveContainer compatibility are unverified.

TEST STATUS: 95 unit tests and 12 UI tests on each of iPhone 17 Pro and Pro Max passed. Unit tests cover all eight abandoned records, pre-play exits, expiry races, duplicate prevention and failure retry. UI tests cover Letter Speed abandoned filtering and app relaunch. Error-alert UI, other games' abandoned history UI, actual background/termination behavior, VoiceOver, dark mode, small phones, concurrent store use and physical-device persistence remain unverified.

KNOWN ISSUES: Failed-save retry is held in memory only and can be lost on app termination. Force termination does not record an abandoned session. Response times and elapsed values are not collected by current integrations. Records lacks richer filtering, top rankings and charts/trends; backups/import and migration beyond schema baseline are unfinished. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Implement completed-session top rankings and useful statistics/trends in Records while preserving exact configuration separation and excluding abandoned/invalid entries. Define and test tie ordering, empty data, negative scores, per-game/difficulty filtering and stable timestamps. Do not infer missing response-time or accuracy statistics. Continue with database migrations, backups, accessibility and device QA afterward.

NEXT TASK ACCEPTANCE CRITERIA: Rankings and calculated statistics use only compatible completed sessions; ordering, ties, empty/negative scores and tests are verified. Milestone 17 remains incomplete until required history, statistics, migrations and acceptance criteria are addressed.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
