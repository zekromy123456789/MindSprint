PROJECT: MindSprint

CURRENT MILESTONE: 13 — Memory (NOT STARTED). Milestone 12 Optiver is COMPLETED to simulator verification limits, with documented reference deviations.
CURRENT SUBTASK: 13A — Memory sequence and rules engine with deterministic tests (NOT STARTED).

LAST COMPLETED WORK: Reinspected the user-provided public reference snapshot for Optiver. Updated operand/result precision to preserve observed integer, one-place and two-place display; sampled observed decimal ranges and small/large positive and negative distractor ranges; retained explicit output precision on choices. Fixed-point arithmetic, normalized negative zero, independent random sequence, resampling zero divisors, and resampling ambiguous hidden-factor zero cases are deliberate differences from the source. Floating-point boundary equivalence is not claimed. Tests cover 12,000 equations for exactly one valid answer plus 12,000 precision/distractor combinations, and UI tests cover difficulty, wrong/correct choice, timeout, results and replay. Both simulator sizes and unsigned build passed. Sample default-light screenshots with test-only controls were reviewed without observed clipping.

FILES CREATED OR MODIFIED: MindSprint/Games/Optiver/OptiverGenerator.swift; MindSprintTests/OptiverGeneratorTests.swift; MindSprint/Screens/GamesHomeView.swift; project-state files and README. Earlier Optiver round and UI are in MindSprint/Games/Optiver.

LATEST COMMIT: Tested source b8bc412e08f5cae583e9c3f8c8432cf6020a572a; inspect GitHub main for the following documentation checkpoint. Local Git history is not synchronized due to an ownership mismatch.

BUILD STATUS: GitHub Actions run 41274133561 passed both simulator suites and unsigned arm64 device app/IPA checks: https://github.com/zekromy123456789/MindSprint/actions/runs/41274133561 . IPA artifact 13071121979 expires 2027-01-30. Unsigned build success does not establish device installation or LiveContainer compatibility.

TEST STATUS: 48 unit tests passed, plus eight UI tests on each of iPhone 17 Pro and Pro Max. Optiver UI tests use a DEBUG-only frozen clock; manual-clock tests cover 80 questions, scoring, deadline and stale taps. Screenshots capture sample default light-mode screens only; worst-case values, Dynamic Type, dark mode, VoiceOver, physical haptics, hardware keyboard and actual background behavior remain unverified. JavaScript binary rounding and Swift fixed-point behavior have not been exhaustively compared at floating-point boundaries.

KNOWN ISSUES: Pro question pool/distribution remains independently generated and differs from reference. Optiver intentionally avoids zero divisors and ambiguous hidden-factor questions, uses fixed point and normalizes negative zero; exact source PRNG and binary rounding equivalence is not claimed. Records are not saved; Memory, Risk, Flexibility and Letter Speed are unavailable. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Windows lacks Xcode and the iOS simulator; use GitHub Actions. Physical checks require a device.

NEXT EXACT TASK: Review Memory research in docs/OPENQUANT_GAME_MECHANICS.md and milestone 13 of docs/MASTER_BRIEF.md. Implement an independently testable Memory sequence/rules engine: three stages (original, reversed, ascending), leading-zero-safe digit strings, length starts at 3, correct +1 and next length, first failure regenerates same length at attempt 2, second failure advances stage, final failure finishes. Explicitly guard submission until all stimulus playback is complete; use injected random/clock where helpful, test duplicate/rapid actions and do not expose a playable UI until integrated. Accurately document animation/background uncertainties and safe deviations. Split into bounded subtasks as needed.

NEXT TASK ACCEPTANCE CRITERIA: Deterministic tests cover original/reversed/sorted sequences, duplicates and leading zeros, both attempts, round transitions, scoring and playback gating. CI passes without regressions. Keep Memory milestone in progress until UI, presentation, results and all brief criteria are verified.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP; verify main/build. Requirements in docs/MASTER_BRIEF.md and evidence in docs/OPENQUANT_GAME_MECHANICS.md. User approved public repository. Never copy protected Pro question pools or claim exact binary Optiver or LiveContainer compatibility without evidence.
