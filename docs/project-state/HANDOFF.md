PROJECT: MindSprint

CURRENT MILESTONE: 17 — Local leaderboards and statistics (IN PROGRESS). Milestone 16 Letter Speed is completed to simulator verification limits.
CURRENT SUBTASK: 17L–17O — Abandoned-session records, history filter, retry handling and tests authored; CI pending. Advanced statistics remain unfinished.

LAST COMPLETED WORK: Memory, Risk and Flexibility completed sessions now save once with stable IDs, completion dates, actual scores and Classic configuration, and appear in the game-filtered Records tab. Memory records actual correct and incorrect submissions; Flexibility records actual correct and incorrect decisions; Risk does not invent accuracy counts. All three have save-error feedback and retry, plus isolated UI test stores. Unit tests cover actual scoring, completion, abandonment exclusion and persistence; UI tests cover completion, replay, filtering and app relaunch. All eight games now save completed sessions, separated by compatible game, mode, difficulty, rules version and duration. Response times and elapsed values not collected remain absent. CI run 41522584961 passed.

FILES CREATED OR MODIFIED: MemoryRound.swift, MemoryGameView.swift, RiskRound.swift, RiskGameView.swift, FlexibilityRound.swift, FlexibilityGameView.swift; MindSprint/Records/MemoryRiskFlexibilityRecords.swift and RecordsManager.swift; MindSprint/Screens/RecordsView.swift; RemainingGameRecordTests.swift and MindSprintUITests.swift; project-state files.

LATEST COMMIT: Tested source c32cf0365758d1cb2b1b51bcf56fd2b6d62a72f9; inspect main for documentation checkpoint. Local Git history remains unsynchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41522584961 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41522584961 . IPA artifact 13179179753 expires 2027-01-31. Installation and LiveContainer compatibility are unverified.

TEST STATUS: 90 unit tests and 12 UI tests on each of iPhone 17 Pro and Pro Max passed. UI tests cover completed records, replay, filtering and app relaunch for each game. Visual review of the updated Records screen, save-error UI, VoiceOver, dark mode, small phones, concurrent store use, actual interruption and physical-device persistence remain unverified.

KNOWN ISSUES: Abandoned-session saving is authored but awaits CI; response times and total elapsed are not collected by current integrations. Records lacks richer filtering, top rankings and charts/trends; backups/import and schema migration beyond the baseline are unfinished. Actual device persistence and interruption behavior are unverified. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Verify abandoned-session saving and history filtering in CI; repair failures. Design lifecycle handling carefully: completion and abandonment may race on expiry, save once per stable session, surface write errors, and test leaving early, expiry, replay and app restart. Continue with top rankings, statistics, trends, migration and backups afterward; do not invent missing timing or accuracy data.

NEXT TASK ACCEPTANCE CRITERIA: CI verifies abandoned attempts are retained where meaningful without duplicate completed records or leaderboard contamination; tests cover relevant lifecycle transitions, persistence and filtering. Milestone 17 remains incomplete until all required history and statistics are implemented and verified.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
