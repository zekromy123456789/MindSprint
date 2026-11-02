PROJECT: MindSprint

CURRENT MILESTONE: 17 — Local leaderboards and statistics (IN PROGRESS). Milestone 16 Letter Speed is completed to simulator verification limits.
CURRENT SUBTASK: 17D–17G — Completed Arithmetic, Arithmetic Pro, Sequence and Optiver results now save alongside Letter Speed and appear in Records; CI passed. Memory, Risk and Flexibility remain unconnected.

LAST COMPLETED WORK: Each of the four newly supported games creates a stable completed-session ID and finish date, saves exactly once through the existing SQLite store, displays save errors and allows retry, and keeps incompatible game, difficulty and timing configurations separate. Arithmetic, Pro and Sequence record correct-answer counts but do not count partial typed inputs as incorrect. Optiver records actual correct and incorrect choices, leaving unanswered questions out. Uncollected response times and elapsed values remain absent. Records offers a game and difficulty selector, personal best, count, average and history. Test stores are isolated. UI tests cover completion, replay, filtering and app relaunch for each added game. Both Arithmetic-only run 41515826851 and combined run 41517688924 passed.

FILES CREATED OR MODIFIED: ArithmeticRound.swift, ArithmeticGameView.swift, ArithmeticProRound.swift, ArithmeticProGameView.swift, SequenceRound.swift, SequenceGameView.swift, OptiverRound.swift, OptiverGameView.swift; MindSprint/Records/ArithmeticRecords.swift, SequenceOptiverRecords.swift and RecordsManager.swift; MindSprint/Screens/RecordsView.swift; ArithmeticRecordTests.swift, SequenceOptiverRecordTests.swift and MindSprintUITests.swift; project-state documents.

LATEST COMMIT: Tested source 2b98843d5034ce403bafd8b086fd4dc63487873a; inspect main for documentation checkpoint. Local Git history remains unsynchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41517688924 passed both simulator suites and unsigned arm64 device app/IPA archive checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41517688924 . IPA artifact 13177807831 expires 2027-01-31. Installation and LiveContainer compatibility are unverified.

TEST STATUS: 86 unit tests and 12 UI tests on each of iPhone 17 Pro and Pro Max passed. UI tests cover each added game's completed result, replay, filtering and app relaunch. Visual review of the updated Records screen, save-error UI, VoiceOver, dark mode, small phones, concurrent store use, actual interruptions and physical-device persistence remain unverified.

KNOWN ISSUES: Memory, Risk and Flexibility do not save records; abandoned sessions are not saved for any game. Response times and elapsed values are not captured by the present integrations. Records lacks broader filtering, charts, ranking and support for remaining games. Schema 1 is an initial baseline; migration from an older app DB, backup/import and real-device persistence remain unverified. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Integrate completed records for Memory, Risk and Flexibility incrementally, preserving each game's actual score, outcome and relevant configuration; expand the Records selector and test persistence and replay. Avoid inventing incorrect counts or timings. Then handle abandoned sessions, history/rankings/statistics, migrations and backups as required. Isolate UI tests from normal data.

NEXT TASK ACCEPTANCE CRITERIA: New games persist their completed results once, survive relaunch, keep incompatible configurations separate, surface save failures and pass appropriate tests. Milestone 17 remains incomplete until all required games and statistics are covered.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim LiveContainer compatibility without evidence.
