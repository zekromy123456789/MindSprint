PROJECT: MindSprint

CURRENT MILESTONE: 17 — Local leaderboards and statistics (IN PROGRESS). Milestone 16 Letter Speed is completed to simulator verification limits.
CURRENT SUBTASK: 17D–17G — Arithmetic and Arithmetic Pro result saving plus game-filtered Records UI authored; CI run 41515826851 is queued and has not executed. Five other games remain unconnected.

LAST COMPLETED WORK: Letter Speed completion creates a stable session UUID and finish date, records score, difficulty and correct/incorrect counts, and saves to a versioned SQLite database in Application Support. Timeouts are not incorrectly counted as wrong answers; timings not collected are left absent. Duplicate attempts with the same UUID and payload are idempotent; conflicting data is rejected. Save errors appear on the results screen with retry; replay is disabled while a save has failed. A Records tab displays completed Letter Speed sessions, personal best, count and average separately for each difficulty and matching rules. UI tests use a separate temporary database, and test save, replay, difficulty filtering and app relaunch. First run 41400603042 failed only because an old navigation test expected the former placeholder; corrected run 41401651147 passed. No other game writes records yet; abandoned sessions are not saved. Records screen screenshots and real-device behavior have not been visually reviewed.

FILES CREATED OR MODIFIED: MindSprint/Records/LetterSpeedRecord.swift, RecordsManager.swift and RecordStore.swift; MindSprint/Screens/RecordsView.swift; MindSprint/ContentView.swift; LetterSpeedRound.swift and LetterSpeedGameView.swift; MindSprintTests/LetterSpeedRecordTests.swift and MindSprintUITests.swift; project-state files.

LATEST COMMIT: Tested source fd56e4ae2e17d680cc217fb52f8aea8379d67c66; inspect main for documentation checkpoint. Local Git history remains unsynchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41401651147 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41401651147 . IPA artifact 13122885729 expires 2027-01-31. Installation and LiveContainer compatibility are unverified.

TEST STATUS: 80 unit tests and 12 UI tests on each of iPhone 17 Pro and Pro Max passed. Tests cover save-once, conflict, failure reporting, database reopen, completed/abandoned handling, per-difficulty selection and app relaunch. UI failure presentation, accessibility, dark mode, small phones, concurrent store calls, actual interruption and physical-device persistence remain unverified.

KNOWN ISSUES: Arithmetic and Arithmetic Pro saving is authored but awaiting CI; five other games and abandoned sessions do not save records; response times and total elapsed are not collected by this integration. Records UI supports Letter Speed only and lacks broader filtering, charts and ranking. Schema 1 is an initial baseline, not a migration from an older app database; backups/import are not implemented. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Check queued CI run 41515826851 (source 9582230a730150590e812e2cc76006511320f5c8) for Arithmetic and Arithmetic Pro completed-result saving and game/difficulty filtering; fix failures. Preserve test isolation and do not fabricate response times or outcomes. Continue incrementally across the remaining games, then implement histories, rankings, statistics, migration and backups as required.

NEXT TASK ACCEPTANCE CRITERIA: The chosen additional game's completed result persists exactly once and survives relaunch, its difficulty/mode stays separate, errors are surfaced, and appropriate tests pass. Milestone 17 remains incomplete until all required games and statistics are covered.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
