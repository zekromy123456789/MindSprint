# Decisions

- 2026-10-30: Preserve the user's full brief in `docs/MASTER_BRIEF.md`; it defines requirements and detailed milestone acceptance criteria.
- 2026-10-30: Use a private repository by default. The connected account is `zekromy123456789`; no existing MindSprint repository was found in the accessible installations. No repository creation operation is exposed by the available GitHub connector, and GitHub CLI is unavailable. Do not assume a remote exists.
- 2026-10-30: Use native Swift/SwiftUI and an offline architecture as required. Persistence technology and game mechanics remain to be decided in their respective milestones.
- 2026-10-30: Classic rules must be evidence-labelled; no mechanics are verified yet. Independent implementation and original visual design are required.
- 2026-10-30: Target iOS 17 initially, use XcodeGen as the project source and use a GitHub-hosted macOS runner. This supports modern SwiftUI and SwiftData if selected later, while leaving persistence choice open. The workflow and toolchain compatibility require an actual CI run; XcodeGen is installed via Homebrew and is not pinned, a reproducibility risk to resolve after the first build.

- 2026-10-30: The user created zekromy123456789/MindSprint. GitHub reports it is public and empty; wait for private visibility before uploading, unless the user explicitly changes the privacy requirement.

- 2026-10-30: User explicitly approved keeping the MindSprint repository public, superseding the initial private-by-default preference.

- 2026-10-30: Shared sessions use an injected ContinuousClock-based monotonic source including sleep, with an explicit refresh before scoring and on background return. Rules own question generation, validation and progression instead of forcing heterogeneous games into one question model. Seeded SplitMix64 supports reproducible tests; built-in bounded random selection is not promised stable across Swift versions. CI run 41086929248 passed six tests and the device build.


- 2026-10-30: Numeric input stores a bounded digit string to preserve leading zeros and avoid implicit floating-point parsing. Submit locks edits and repeat submissions until the caller resets after resolution. Per-game numeric validation, question transitions and timing remain the caller's responsibility. The reusable keypad is not yet connected to screens or hardware keyboard input.

- 2026-10-30: Numeric keypad shares a testable action mapping for touch and iOS 17 hardware keys. Key presses are gated by input availability and submission lock. Haptic settings persist via AppStorage; UIKit feedback is optional and prepared for low latency. Keyboard focus, delivery and physical feedback require device verification.

- 2026-10-30: After simulator UI automation found no keyboard focus, 8E uses a UIKit first-responder receiver with an empty custom input view to forward hardware actions without the standard keyboard; simulator keyboard delivery and six default light-mode screenshots passed in run 41165821335; physical keyboard, VoiceOver and haptics remain unverified. Arithmetic custom difficulty ranges are independent product choices, not reference claims; Classic uses documented ranges.

- 2026-10-30: Arithmetic custom difficulty ranges are Easy operands 2...20 and small factors 2...5, Normal 2...50 and 2...10, Hard 2...199 and 2...15, Expert 2...999 and 2...25. Division is constructed from a nonzero divisor and integer quotient. Classic auto-advance must be integrated separately from the keypad explicit-submit behavior.

- 2026-10-31: Arithmetic Pro uses independently authored expression templates with operands 2...20 and 2...12, including constructed exact division. This is a custom approximation; the protected reference pool and its distribution are not reproduced. Generator and independent prompt-evaluation tests passed in CI run 41173426893.

- 2026-10-31: Pro offers independently chosen Easy main 2...10/factor 2...5, Normal 2...20/2...12 (the original custom level), Hard 2...35/2...15, and Expert 2...60/2...20. The same five expression shapes are used across levels. No level is called Classic because the protected reference distribution is not reproduced. These changes passed CI run 41216164324.

- 2026-10-31: Sequence Classic generation independently implements the four documented families and random reversal; negative and zero values remain valid. Generator tests cover family rules and deterministic seeds; gameplay is a separate step.

- 2026-10-31: Sequence Classic is unchanged. Custom Easy samples arithmetic/special families; Normal arithmetic/geometric/special; Hard geometric/quadratic/special; Expert quadratic only. Each uses the same verified Classic parameter bounds and both directions, so each generated domain is a subset of the exhaustively checked Classic domain. These are custom family mixes, not reference difficulty settings. The Sequence level changes passed CI run 41262800653.

- 2026-11-01: Optiver uses exact integer hundredths for generated arithmetic, avoids zero divisors and ambiguous zero-factor hidden positions, and uses original distinct choice offsets and concise decimal formatting. Exact reference rounding and distractor distribution remain unverified; do not call these equivalent. Generator and round passed CI run 41262800653; UI is not yet integrated.

- 2026-11-01: Optiver Classic retains its full operation mix; custom Easy selects addition/subtraction, Normal addition/subtraction/multiplication, Hard multiplication/division, Expert division only. All use the same independently designed formatting and distractors; these level mixes are custom. UI, results and level tests passed CI run 41272947659; reference-generation fidelity remains an open requirement.

- 2026-11-01: After reinspection of the user-provided public snapshot, Optiver now preserves reference-style operand/result decimal places (0, 1, 2) and samples its observed small/large positive and negative distractor ranges. Fixed-point arithmetic, normalized negative zero, independent RNG, zero-divisor and ambiguous-factor resampling are intentional deviations; exact binary floating-point edge and random sequence equivalence are not claimed. CI run 41274133561 passed.

- 2026-11-01: Memory uses independent discrete card presentation (one-second lead-in and one second per digit), since exact source animation duration is not established. Input is strictly gated until all digits are presented; background interruption restarts the current countdown or presentation. These are documented safety/pacing choices. CI run 41277730498 and sample simulator screenshots passed; actual device behavior remains unverified.

- 2026-11-01: Reinspection of the user-provided Risk source confirmed its green branch falls through to red. Classic deliberately preserves the effective green=red probability, while retaining the independently assigned green setting as in that source. This is source-code evidence, not a separately observed statistical measurement. Risk engine/UI passed CI run 41331629289 attempt 2; physical keyboard and haptics remain unverified.

- 2026-11-01: Letter Speed retries whole questions with tied target totals up to 128 times, then uses a deterministic legal fallback to guarantee progress. On a delayed timer callback it times out one question and starts the next clock at processing time, rather than charging time for unseen questions. Simulator tests and the unsigned build passed in run 41340021945.

- 2026-11-01: Reinspection of the supplied Letter Speed snapshot found fixed generation and timing for all ten rounds, with no adaptive progression or difficulty selector in that path. Treat the current fixed rules as the Classic baseline; do not add a fictional automatic difficulty increase. The brief asks for explicitly named Classic mode and custom levels where appropriate; naming and any separately labeled custom modes remain implementation work.

- 2026-11-01: Authored independently selected Letter Speed custom letter domains: Easy A–F, Normal A–L, Hard H–Z, Expert N–Z, while Classic keeps A–Z. These retain the same ten-row grids, blank probabilities, target weighting, timing and scoring; domain choice is not proof of strictly increasing difficulty. Generator tests and the full workflow passed in run 41349614809; custom modes are not yet connected to the game or picker.

- 2026-11-02: Use an initial versioned SQLite records store to provide transactional local persistence without an additional dependency. Keep the existing database intact when an unknown newer schema is encountered. Compatible score groups include game, difficulty, mode, rules version and duration; only completed sessions contribute to best and average. CI run 41398019339 passed the store tests. This foundation is not yet connected to games or the Records screen; future schema migrations and app integration remain.

- 2026-11-02: Letter Speed saves completed sessions once using a stable UUID and finish timestamp, with actual score, difficulty and correct/incorrect counts; timeout and response-time information not captured by this integration is not invented. The Records tab currently shows only compatible Letter Speed completed sessions by difficulty. Save failures are surfaced with retry. A separate temporary database isolates UI tests. CI run 41401651147 passed; other games and abandoned sessions are not yet saved.

- 2026-11-02: Save completed Arithmetic, Arithmetic Pro, Sequence and Optiver sessions using stable IDs and the existing versioned store; separate by game, mode, difficulty and duration. Arithmetic, Pro and Sequence store correct counts only; Optiver stores actual correct and incorrect choice counts. UI tests use separate temporary stores. Both simulator suites and the unsigned build passed in run 41517688924. Memory, Risk, Flexibility and abandoned sessions remain unconnected.

- 2026-11-02: Completed Memory, Risk and Flexibility sessions now use the common stable-ID SQLite store and filtered Records UI. Memory tracks actual correct and incorrect submissions, Flexibility tracks actual decisions, and Risk stores no invented accuracy fields. CI run 41522584961 passed. All eight games now save completed sessions; abandoned history, richer statistics, migration and backups remain.
