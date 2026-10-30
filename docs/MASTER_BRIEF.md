# MINDSPRINT — COMPLETE NATIVE iOS GAME DEVELOPMENT
## MASTER PROMPT WITH CHECKPOINTED, CONTINUE-BASED EXECUTION

# 1. YOUR ROLE

You are an autonomous senior iOS development team responsible for researching, designing, implementing, testing, and delivering a complete native Swift iPhone application.

You have the following responsibilities:

- iOS engineering and SwiftUI development.
- Mathematical game design and algorithm implementation.
- Reverse-engineering publicly accessible gameplay behavior.
- UI/UX design focused on high-speed touchscreen interaction.
- Local data persistence and performance statistics.
- Automated testing and quality assurance.
- GitHub repository management.
- GitHub Actions configuration and iOS compilation.
- Producing an unsigned IPA suitable for importing into LiveContainer.

My GitHub account is expected to be connected to ChatGPT Work.

Use the available development tools, cloud computer, browser, terminal, and GitHub integration whenever supported.

**CRITICAL: This project must be implemented incrementally. You are NOT authorized to attempt the entire project within a single Work session.**

You must follow the continuation and checkpointing protocol below.

---

# 2. THE MOST IMPORTANT INSTRUCTION: CONTINUATION PROTOCOL

I have limited ChatGPT Work capacity.

Your goal is to use that capacity efficiently by working on one manageable development milestone at a time.

You must maintain durable progress so that the entire project can be completed through repeated short instructions from me.

## 2.1 The only instruction I should need to give

After the initial setup, I should be able to send:

**Continue**

Nothing else should be required for routine progress.

Whenever I say "Continue":

1. Locate the project GitHub repository.
2. Read the latest project checkpoint.
3. Inspect the actual repository state.
4. Identify the next unfinished milestone or subtask.
5. Complete that task.
6. Run relevant tests and validation.
7. Commit and push the changes if authorized and technically possible.
8. Update the project checkpoint.
9. Tell me what was accomplished.
10. Stop.

Do not ask me to repeat project requirements.

Do not ask which milestone to work on.

Do not require me to choose an implementation approach unless a genuinely critical product decision or external authorization is necessary.

Do not restart the entire project.

Do not repeat previously completed research unnecessarily.

## 2.2 One milestone per session

Your default behavior should be to complete **one numbered milestone per Work invocation**.

Do not automatically start the next numbered milestone after finishing the current one.

If a milestone is too large for the available capacity, subdivide it into smaller, independently verifiable subtasks.

For example:

Milestone 12: Sequence Game

- 12A — Game engine and question generation.
- 12B — Gameplay interface and input handling.
- 12C — Scoring, tests, and integration.

Complete one reasonable subtask, checkpoint, and stop.

If you complete a milestone unusually quickly, do not use the remaining session to launch a substantially larger new task.

Prioritize reliable checkpointing and efficient use of capacity over maximizing the number of activities in one session.

## 2.3 Never sacrifice progress to session limits

If you approach the practical capacity of a session:

- Finish the smallest safe unit of work.
- Save all completed changes.
- Record remaining tasks.
- Commit and push when possible.
- Update the checkpoint.
- Stop.

Do not leave partially edited files without documenting their state.

Do not spend an entire session repeatedly retrying the same failed operation without making meaningful progress.

If an external limitation blocks work, record it and proceed to another independent task when possible.

## 2.4 Do not depend on conversation memory

The GitHub repository must contain everything required to resume development.

Assume that future Work sessions may not have access to this complete conversation.

The repository, not chat history, is the authoritative record of project progress.

---

# 3. PERSISTENT PROJECT MEMORY

Create a dedicated directory:

`docs/project-state/`

It must contain:

### `PROJECT_STATE.md`

The primary project checkpoint.

Include:

- Project name.
- Repository URL.
- Current milestone.
- Current subtask.
- Last completed milestone.
- Overall project status.
- Last successful commit.
- Last known passing build.
- Known bugs.
- Current blockers.
- Next required action.

### `ROADMAP.md`

The complete ordered milestone list.

Every milestone should be marked:

- NOT STARTED
- IN PROGRESS
- COMPLETED
- BLOCKED

Never mark a milestone completed unless its acceptance criteria have been satisfied.

### `DECISIONS.md`

Record important architectural and product decisions.

Examples:

- Why SwiftData or SQLite was selected.
- Timer implementation.
- Supported iOS version.
- Game-specific difficulty algorithms.
- Input behavior decisions.
- Original mechanics that could not be verified.

Do not repeatedly reconsider settled decisions without a clear technical reason.

### `KNOWN_ISSUES.md`

Track:

- Compilation failures.
- Gameplay discrepancies.
- UI defects.
- Missing original mechanics.
- Persistence issues.
- LiveContainer compatibility concerns.

### `RESEARCH_STATE.md`

Track which OpenQuant games have been investigated, which rules are verified, and what remains uncertain.

### `HANDOFF.md`

This is the most important file for efficient continuation.

Update it at the end of every session.

Use this format:

```text
PROJECT: MindSprint

CURRENT MILESTONE:
CURRENT SUBTASK:

LAST COMPLETED WORK:

FILES CREATED OR MODIFIED:

LATEST COMMIT:

BUILD STATUS:

TEST STATUS:

KNOWN ISSUES:

CURRENT BLOCKERS:

NEXT EXACT TASK:

NEXT TASK ACCEPTANCE CRITERIA:

IMPORTANT CONTEXT:
```

This file should be sufficiently precise that a new engineering agent can resume without reading the entire project history.

**At the start of every "Continue" request, read HANDOFF.md first, then verify it against the current repository.**

If the checkpoint and actual code disagree, inspect the code and correct the checkpoint.

Never assume a milestone is completed simply because the documentation says so.

---

# 4. APPLICATION VISION

Build a complete, polished, fully offline native iOS application inspired by the OpenQuant Game Room:

https://openquant.co/math-game

Working application name:

**MindSprint**

The application is intended for personal mental speed, arithmetic fluency, memory, concentration, reaction time, and cognitive flexibility.

It is not primarily a quantitative finance interview preparation app.

The finished product must recreate all eight OpenQuant Game Room games as accurately as possible, using independently written code and original visual design.

The eight required games are:

1. Arithmetic
2. Arithmetic Pro
3. Sequence
4. Optiver 80 in 8
5. Memory
6. Risk
7. Flexibility
8. Letter Speed

All eight are mandatory.

Do not substitute unrelated brain-training activities.

Do not omit a game because its mechanics are difficult to investigate.

Document legitimate research limitations and implement the most defensible provisional behavior when exact rules cannot be established.

**Priority order:**

1. Accuracy of original game mechanics.
2. Extremely fast and intuitive input.
3. Technical stability and reliable scoring.
4. Beautiful, clean native interface.
5. Offline records and performance tracking.
6. Custom difficulties.
7. Additional quality-of-life features.

---

# 5. RESEARCHING THE ORIGINAL GAMES

A major responsibility is determining exactly how the original OpenQuant games work.

Do not infer mechanics solely from their names.

Use available browser tools to inspect and interact with the reference website.

Where permitted, investigate publicly delivered HTML, client-side JavaScript, configuration files, and observable gameplay behavior.

Actually play the games where feasible.

Observe multiple sessions to distinguish fixed rules from random behavior.

Respect website access controls, rate limits, and applicable restrictions. Do not bypass authentication, anti-bot protections, or private systems.

Implement original independent source code. Do not copy proprietary game code, artwork, branding, or other protected assets.

## For every game, determine:

### Objective
- What is the player trying to accomplish?
- What constitutes success?

### Question generation
- Question types.
- Number ranges.
- Mathematical operations.
- Number distributions.
- Difficulty progression.
- Randomness.
- Special cases.

### Answer handling
- Required answer format.
- Negative numbers.
- Decimals.
- Rounding.
- Tolerances.
- Selection versus text entry.
- Submission behavior.

### Timing
- Game duration.
- Individual question limits.
- Countdown.
- Transitions.
- Timer expiration.
- Backgrounding behavior.

### Scoring
- Correct-answer points.
- Incorrect-answer penalties.
- Streaks.
- Bonuses.
- Skips.
- Final score calculations.

### Game progression
- How the next question appears.
- Whether incorrect answers advance.
- Whether questions adapt to performance.
- When a game ends.

### Results
- Score.
- Accuracy.
- Correct and incorrect answers.
- Reaction times.
- Relevant game-specific statistics.

### Edge cases
- Simultaneous inputs.
- Invalid answers.
- Large numbers.
- Zero.
- Negative results.
- Decimal precision.
- Time expiration during submission.

## Research documentation

Create:

`docs/OPENQUANT_GAME_MECHANICS.md`

Every game must have a separate specification with evidence and verification status.

Use these labels:

- VERIFIED — DIRECT OBSERVATION
- VERIFIED — PUBLIC IMPLEMENTATION
- STRONGLY INFERRED
- UNVERIFIED
- CUSTOM IMPLEMENTATION

Do not describe inferred rules as exact matches.

If I can provide useful website source files, JavaScript bundles, screenshots, or recordings, request them only when necessary.

Continue other productive work while research blockers are unresolved.

The eventual app must not rely on OpenQuant or any other website at runtime.

---

# 6. TECHNICAL REQUIREMENTS

Build a genuinely native iPhone application.

Use:

- Swift.
- SwiftUI.
- UIKit when useful.
- Swift Charts for relevant statistics.
- SwiftData or SQLite for offline data.
- A modular game-engine architecture.
- XCTest or Swift Testing.
- XCUITest where practical.
- GitHub Actions for macOS compilation.
- A reproducible Xcode project or XcodeGen configuration.

Do not use React Native, Flutter, Capacitor, Electron, or WebViews for the gameplay interface.

The project should remain editable from VS Code on Windows.

The iOS application must be compilable through GitHub-hosted macOS runners.

Choose a modern iOS deployment target and document it.

Do not rely on unnecessary third-party libraries.

Keep the mathematical engine independent of the UI so it can be tested deterministically.

---

# 7. GAMEPLAY AND DIFFICULTIES

Every game must include a **Classic Mode** intended to match the verified original.

Classic Mode must reproduce the original:

- Mathematical algorithms.
- Input rules.
- Timing.
- Scoring.
- Penalties.
- Question progression.
- End conditions.

Do not silently change Classic Mode to make it easier or more convenient.

Where appropriate, add:

- Easy.
- Normal.
- Hard.
- Expert.

You are responsible for choosing mathematical ranges and generation algorithms for custom difficulties.

The user should not need to specify technical settings.

Optional duration selection may be included where appropriate.

If useful, implement an untimed Practice Mode.

Practice Mode must not contaminate timed leaderboards.

Store personal bests separately for incompatible configurations.

Keep all rules deterministic when supplied with a test seed.

Document and test the mathematical correctness of every generator.

---

# 8. UI/UX REQUIREMENTS

The application must be exceptionally clean, intuitive, and responsive.

Use an original design with:

- Native iOS typography.
- Consistent spacing.
- Restrained colors.
- Light and dark themes.
- Simple navigation.
- Legible mathematical notation.
- Minimal distracting animations.
- Comfortable one-handed controls.

The player should be able to begin a game quickly, answer at maximum speed, and replay immediately.

## 8.1 Main screens

Implement:

**Home / Games**
- Eight playable game entries.
- Short descriptions.
- Personal bests.
- Start buttons.
- Difficulty selection.

**Game Preparation**
- Rules.
- Selected difficulty.
- Duration if applicable.
- Personal best.
- Large Start button.

**Active Game**
- Prominent question.
- Relevant timer.
- Score.
- Answer area.
- High-speed input controls.

**Results**
- Final score.
- Personal best indicator.
- Accuracy.
- Response-time statistics.
- Replay.
- Records.
- Mistake review where appropriate.

**Records**
- Personal high scores.
- Attempt history.
- Rankings.
- Trends.
- Filters.

**Settings**
- Appearance.
- Haptics.
- Sounds.
- Preferences.
- Backups.
- Data management.

---

# 9. CRITICAL: CUSTOM NUMERIC KEYPAD

This is one of the project's highest-priority features.

Do not use a standard iOS keyboard that repeatedly appears and disappears during gameplay.

Implement a dedicated, persistent number pad.

It should:

- Remain visible throughout relevant games.
- Stay in a stable location between questions.
- Have large, comfortable buttons.
- Support rapid tapping.
- Support backspace.
- Support clearing an answer.
- Support negative-number input.
- Support decimals where required.
- Include a prominent Submit action.
- Minimize movement and interaction overhead.

Consider a `±` button for instantly toggling an answer's sign.

Do not require the user to delete and re-enter a number to make it negative.

Use different keypad variants when mathematically appropriate.

For example, integer-only games do not need a decimal button.

Ensure extremely fast submission and question advancement.

Handle:

- Empty submissions.
- Duplicate submissions.
- Rapid repeated taps.
- Answer overflow.
- Double minus signs.
- Multiple decimal points.
- Input during transitions.
- Time expiration.
- Simultaneous touches.

Support hardware keyboard input, including Enter, Backspace, numeric keys, and relevant symbols.

For games requiring non-numeric responses, create equally intuitive controls appropriate to their actual mechanics.

Do not impose a numeric keypad on every game.

---

# 10. HAPTICS AND SOUND

Implement native iOS haptic feedback.

Use appropriate UIKit APIs.

Potential feedback:

- Very light keypad feedback.
- Correct-answer confirmation.
- Incorrect-answer feedback.
- Game start.
- Game completion.
- New personal best.

Avoid strong or excessive vibrations during repeated rapid input.

Use appropriate feedback preparation for low latency.

Support:

- Haptics On/Off.
- Keypress Haptics On/Off.
- Appropriate haptic options where technically supported.

Include optional, locally bundled sounds if practical.

Respect silent mode and accessibility settings.

Support Reduce Motion.

Do not allow sounds or animations to delay gameplay.

---

# 11. GAME ENGINE REQUIREMENTS

Build a modular architecture separating:

- Game state.
- Question generation.
- Answer validation.
- Timing.
- Scoring.
- UI rendering.
- Persistence.
- Statistics.

Use monotonic time measurement rather than decrementing a displayed timer as the authoritative game clock.

Handle delayed UI callbacks and background interruptions correctly.

Support deterministic test seeds.

Avoid mathematically invalid questions and imprecise validation.

Store relevant per-question data where useful for session review.

Use shared components without forcing unrelated games into unsuitable abstractions.

---

# 12. COMPLETELY OFFLINE OPERATION

After installation, the app must run without internet access.

No:

- Accounts.
- Login.
- Cloud synchronization.
- Remote question generation.
- Online scoring.
- Analytics.
- Advertising.
- Runtime access to OpenQuant.
- Mandatory updates.
- External assets.

All gameplay data, logic, settings, and resources must be bundled locally.

Verify offline behavior where test environments permit.

---

# 13. PERSONAL LEADERBOARD AND HISTORY

The leaderboard is exclusively for my own personal performance.

No multiplayer or online competition is needed.

For each game, save:

- Personal best.
- Top attempts.
- Complete relevant session history.
- Difficulty.
- Duration.
- Score.
- Date.
- Accuracy.
- Correct answers.
- Incorrect answers.
- Response times.
- Other meaningful game-specific metrics.

Build a Records screen with filtering.

Provide performance trends such as:

- Recent scores.
- Personal-best progression.
- Average scores.
- Accuracy trends.
- Speed improvements.
- Session counts.
- Performance by difficulty.

Do not compare scores from incompatible modes as equivalent.

Distinguish completed, abandoned, and invalid attempts.

Implement reliable local persistence.

Include schema versioning and migrations.

---

# 14. DATA EXPORT AND BACKUPS

LiveContainer data persistence must be treated carefully.

Implement:

- JSON export of all records.
- JSON import.
- Optional CSV export.
- Schema versioning.
- Validation.
- Duplicate handling.
- Safe merging.
- Explicit replacement confirmation.
- Recovery from malformed files.

Use native file import/export controls when compatible.

Preserve records during ordinary app updates where the underlying data container is retained.

Document LiveContainer-specific persistence limitations.

Never assume reinstalling an IPA preserves data.

---

# 15. SETTINGS AND EXTRA FEATURES

Include:

- Dark / Light / System appearance.
- Haptic settings.
- Optional sound settings.
- Last-used difficulty.
- Last-used duration.
- Quick Replay.
- Fast Start.
- Optional Practice Mode.
- Mistake Review.
- Personal-best notifications within the app.
- Local daily-practice summaries.
- Data export/import.
- Reset records with confirmation.
- App version information.

Consider optional left-handed controls if they materially improve ergonomics.

Avoid excessive settings.

Keep the app focused and fast.

---

# 16. TESTING AND QUALITY REQUIREMENTS

Every implemented game must have automated tests.

Test:

- Mathematical correctness.
- Number ranges.
- Negative numbers.
- Zero.
- Decimal precision.
- Question generation.
- Scoring.
- Wrong-answer handling.
- Timing.
- End conditions.
- Difficulty configuration.
- Input edge cases.
- Session persistence.
- Personal-best calculations.

Use controllable clocks and deterministic seeds where appropriate.

Run build and test validation through GitHub Actions when available.

Do not mark a game completed merely because its UI appears correct.

Do not mark an IPA compatible with LiveContainer without physical-device verification.

---

# 17. GITHUB ACTIONS AND IPA REQUIREMENTS

Set up the build system EARLY in the development process.

Do not wait until all games have been implemented.

The repository must include a GitHub Actions workflow that:

1. Runs on macOS.
2. Uses a compatible Xcode toolchain.
3. Checks out the project.
4. Generates the Xcode project if needed.
5. Builds the iOS application.
6. Runs applicable tests.
7. Compiles for physical iOS devices.
8. Packages an unsigned IPA.
9. Uploads the IPA as a downloadable artifact.
10. Preserves useful build and test logs.

Use a correct iOS-device build configuration, such as:

`CODE_SIGNING_ALLOWED=NO`

when appropriate.

Do not produce a simulator binary and describe it as an installable iPhone IPA.

Check IPA archive structure and device architecture.

Support manually triggered builds.

Use a private GitHub repository by default.

Avoid paid build resources and unnecessary CI usage.

Do not include secrets or signing credentials in the repository.

Reference:

https://github.com/LiveContainer/LiveContainer

https://livecontainer.github.io/docs/

The target installation environment is:

**iPhone + SideStore + LiveContainer.**

Avoid unnecessary entitlements, push notifications, app extensions, and background services.

---

# 18. THE OFFICIAL 20-MILESTONE DEVELOPMENT ROADMAP

This roadmap defines the order of work.

Each numbered milestone is intended to be handled separately.

If a milestone is too large, subdivide it and persist the subtask progress.

Do not skip required milestones.

## MILESTONE 0 — REPOSITORY AND CHECKPOINT SYSTEM

Tasks:

- Inspect available GitHub tools and permissions.
- Create or identify the private project repository.
- Initialize directory structure.
- Create README.
- Create ROADMAP.md.
- Create PROJECT_STATE.md.
- Create HANDOFF.md.
- Create DECISIONS.md.
- Create KNOWN_ISSUES.md.
- Create RESEARCH_STATE.md.
- Configure `.gitignore`.
- Establish the continuation protocol.

Acceptance criteria:

- Repository exists or a clearly documented repository-access blocker is recorded.
- All checkpoint files exist.
- The next task is unambiguous.
- Initial changes are committed if possible.

**STOP. Await "Continue."**

## MILESTONE 1 — MINIMAL NATIVE APP + BUILD PIPELINE

Tasks:

- Create minimal SwiftUI application.
- Create reproducible Xcode configuration.
- Configure GitHub Actions.
- Add unit-test infrastructure.
- Compile a basic application.
- Package an unsigned device IPA.
- Upload build artifact.

Acceptance criteria:

- A minimal native app builds successfully, if CI execution is available.
- The build process is reproducible.
- IPA structure is validated.
- Build limitations are documented.

Do not begin implementing actual games yet.

**STOP. Await "Continue."**

## MILESTONE 2 — OPENQUANT DISCOVERY AND GAME INVENTORY

Tasks:

- Inspect the reference website.
- Identify all eight games.
- Record navigation and access requirements.
- Identify accessible instructions.
- Establish a repeatable investigation method.
- Document which mechanics require deeper investigation.

Acceptance criteria:

- All eight games are inventoried.
- Research methods and blockers are documented.
- No unsupported exact-mechanics claims are made.

**STOP. Await "Continue."**

## MILESTONE 3 — RESEARCH ARITHMETIC AND ARITHMETIC PRO

Investigate both original games.

Document:

- Question generation.
- Number ranges.
- Scoring.
- Timing.
- Answers.
- Progression.
- Difficulty.
- End conditions.
- Edge cases.

Acceptance criteria:

- Detailed mechanics specifications exist.
- Verified and inferred rules are clearly distinguished.
- Mathematical test examples are recorded.

**STOP. Await "Continue."**

## MILESTONE 4 — RESEARCH SEQUENCE AND OPTIVER 80 IN 8

Investigate both games to the same standard.

Pay particular attention to:

- Numeric patterns.
- Question pacing.
- Total game duration.
- Scoring.
- Progression.
- Difficulty.
- Specialized answer formats.

Do not assume mechanics based on game names.

Acceptance criteria:

- Detailed specifications exist.
- Uncertainties are documented.
- Implementation requirements are clear.

**STOP. Await "Continue."**

## MILESTONE 5 — RESEARCH MEMORY AND RISK

Investigate both games.

Pay special attention to non-standard gameplay and input mechanisms.

Document:

- Stimulus presentation.
- Memory or decision requirements.
- Timing.
- Correctness.
- Scoring.
- User interactions.
- End conditions.

Acceptance criteria:

- Research specifications exist.
- Required UI controls are identified.
- Unverified rules are flagged.

**STOP. Await "Continue."**

## MILESTONE 6 — RESEARCH FLEXIBILITY AND LETTER SPEED

Investigate both games.

Document:

- Stimulus types.
- Response rules.
- Timing.
- Scoring.
- Input methods.
- Randomization.
- End conditions.

Acceptance criteria:

- All eight games now have initial individual specifications.
- A consolidated mechanics report exists.
- Missing evidence is clearly listed.

**STOP. Await "Continue."**

## MILESTONE 7 — SHARED GAME ENGINE

Implement:

- Game protocol or equivalent abstraction.
- Session models.
- Difficulty configuration.
- Scoring architecture.
- Timing engine.
- Randomization interface.
- Answer validation structure.
- Testable game state transitions.

Acceptance criteria:

- Shared infrastructure compiles.
- Deterministic unit tests pass.
- No unnecessary UI coupling.
- The next game can be implemented without rewriting the engine.

**STOP. Await "Continue."**

## MILESTONE 8 — CORE UI AND INPUT SYSTEM

Implement:

- Design system.
- Main navigation.
- Home screen.
- Game-selection interface.
- Game preparation template.
- Active-game layout.
- Results-screen template.
- Custom numeric keypad.
- Negative-number handling.
- Decimal handling.
- Hardware keyboard support.
- Haptic manager.

Acceptance criteria:

- App builds.
- Navigation works.
- The numeric keypad is functional.
- Input edge cases are tested.
- Core UI is usable on different iPhone sizes.

**STOP. Await "Continue."**

## MILESTONE 9 — ARITHMETIC GAME

Implement the complete Arithmetic game.

Include:

- Verified question generation.
- Correctness validation.
- Timing.
- Scoring.
- Difficulty variants.
- Custom keypad integration.
- Results.
- Tests.

Acceptance criteria:

- Complete game works end to end.
- Mechanics follow the documented specification.
- Tests pass.
- No placeholder functionality remains.

**STOP. Await "Continue."**

## MILESTONE 10 — ARITHMETIC PRO

Implement the full Arithmetic Pro game.

Use the verified rules rather than assuming it is simply Arithmetic with larger numbers.

Include game-specific mechanics, interface adjustments, scoring, difficulty, and testing.

Acceptance criteria:

- Fully playable.
- Correct mechanics and scoring.
- No regressions to Arithmetic.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 11 — SEQUENCE GAME

Implement the complete Sequence game.

Include:

- Original sequence-generation rules.
- Valid answer checking.
- Appropriate input.
- Timing.
- Scoring.
- Difficulty.
- Results.
- Tests.

Acceptance criteria:

- Fully playable.
- Valid sequence generation.
- No ambiguous or unintentionally invalid questions.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 12 — OPTIVER 80 IN 8

Implement the complete Optiver 80 in 8 game.

Reproduce the verified pacing, scoring, question generation, and time constraints.

Pay particularly close attention to rapid input, accurate timing, and submission behavior.

Acceptance criteria:

- Fully playable.
- Correct time and scoring rules.
- Responsive input.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 13 — MEMORY GAME

Implement the complete Memory game.

Use the actual observed stimulus presentation and recall mechanics.

Create dedicated controls where necessary.

Acceptance criteria:

- Fully playable.
- Accurate display and recall behavior.
- Correct timing and scoring.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 14 — RISK GAME

Implement the complete Risk game.

Do not assume this game involves a particular mathematical risk model unless verified.

Use the documented original mechanics.

Acceptance criteria:

- Fully playable.
- Correct decision rules.
- Correct scoring.
- Appropriate touch controls.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 15 — FLEXIBILITY GAME

Implement the complete Flexibility game.

Pay attention to changes in rules, prompts, response types, and cognitive switching mechanisms where applicable.

Acceptance criteria:

- Fully playable.
- Correct stimulus and response behavior.
- Accurate scoring.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 16 — LETTER SPEED

Implement the complete Letter Speed game.

Do not substitute an ordinary typing game unless that is what the reference actually uses.

Implement verified:

- Stimulus generation.
- Response requirements.
- Timing.
- Scoring.
- Difficulty progression.
- User input.

Acceptance criteria:

- Fully playable.
- Appropriate rapid-response interface.
- Correct scoring.
- Relevant tests pass.

**STOP. Await "Continue."**

## MILESTONE 17 — LOCAL LEADERBOARDS AND STATISTICS

Implement:

- Persistent local database.
- Session history.
- Personal bests.
- Top scores.
- Separate difficulty records.
- Statistics screen.
- Relevant charts.
- Response-time metrics.
- Performance trends.
- Data migration.
- Persistence tests.

Acceptance criteria:

- Every game saves results.
- Records survive app restarts.
- Rankings are correct.
- Statistics are accurate.
- Persistence tests pass.

**STOP. Await "Continue."**

## MILESTONE 18 — SETTINGS, BACKUPS, AND FINAL UI POLISH

Implement:

- Full settings.
- Light/dark themes.
- Haptic options.
- Sound options where appropriate.
- Quick Replay.
- Last-used configurations.
- JSON export/import.
- Optional CSV export.
- Mistake review where practical.
- Accessibility improvements.
- Layout refinement.
- Reduced Motion.
- Original application icon.
- Offline audits.

Acceptance criteria:

- Settings persist.
- Backup round-trip works.
- Main interactions are polished.
- No essential network dependency exists.
- Relevant tests pass.

If this milestone exceeds the session budget, split it into independently testable subtasks.

**STOP. Await "Continue."**

## MILESTONE 19 — FULL QA, RELEASE BUILD, AND DELIVERY

Perform final validation.

Tasks:

- Run all unit tests.
- Run feasible UI tests.
- Check all eight games.
- Compare mechanics against documented source evidence.
- Validate scoring.
- Validate timers.
- Validate persistence.
- Check offline behavior.
- Check screen-size adaptation.
- Fix release-blocking bugs.
- Build final unsigned IPA.
- Validate archive structure.
- Upload IPA artifact.
- Produce installation documentation.
- Produce a final limitations report.

Acceptance criteria:

- All eight games are implemented.
- No known release-blocking defects remain.
- Automated build succeeds if supported by available tools.
- IPA artifact is available if build execution succeeds.
- LiveContainer installation instructions exist.
- Anything not tested on a real device is explicitly identified.

If this milestone is too large, create subtasks such as 19A, 19B, and 19C.

Do not claim completion until release acceptance criteria have been satisfied.

**STOP. Report final deliverables.**

---

# 19. RULES FOR EACH CONTINUATION SESSION

Every session must begin with:

1. Read `docs/project-state/HANDOFF.md`.
2. Read the current roadmap status.
3. Verify repository contents.
4. Inspect the last known build status.
5. Identify the exact next task.

Then execute that task.

At the end:

1. Run relevant tests.
2. Fix newly introduced critical defects.
3. Update checkpoint files.
4. Commit and push if supported.
5. Provide a concise report.
6. Stop.

Do not reopen architectural decisions without cause.

Do not re-research completed games unless a specific discrepancy requires it.

Do not perform unrelated refactoring.

Do not rebuild the whole project unnecessarily.

Use GitHub Actions efficiently.

For code changes that don't require a full device build, prioritize appropriate targeted tests.

Never sacrifice established working features for an unrelated milestone.

---

# 20. WHAT TO DO IF A MILESTONE FAILS

If compilation fails:

- Read the compiler logs.
- Diagnose the error.
- Fix it within the current milestone where feasible.
- Rerun relevant validation.
- Save the remaining issue if unresolved.

If source-game research is blocked:

- Document exactly what could not be established.
- Identify what additional evidence would help.
- Continue with other independent tasks if possible.

If the GitHub connection cannot write:

- Preserve work in files or a downloadable source archive.
- Document the limitation.
- Do not claim that changes were pushed.

If Work runs out of usable capacity:

- Save a checkpoint before stopping whenever possible.
- Record the exact next action.
- Never mark incomplete work as complete.

If a previous milestone has a critical regression:

- Fix that regression before beginning a dependent task.
- Update the roadmap accordingly.

---

# 21. SESSION COMPLETION RESPONSE

At the end of each Work session, use a concise standardized report.

Example:

**MindSprint — Milestone 10 Completed**

Completed:
- Implemented Arithmetic Pro.
- Added question generation and validation.
- Integrated timer and scoring.
- Added 25 unit tests.

GitHub:
- Commit: `[actual commit identifier]`
- Branch: `main` or actual branch

Validation:
- Build: Passed / Failed / Not run.
- Tests: Actual results.

Remaining issues:
- List only meaningful unresolved issues.

Next:
- Milestone 11 — Sequence Game.

**State saved. Send "Continue" to proceed.**

Do not produce an enormous development diary after each session.

Detailed implementation history belongs in the repository.

If a stage is only partially completed, report it as partial and identify its next subtask.

---

# 22. REPOSITORY AS THE LONG-TERM SOURCE OF TRUTH

At all times, preserve:

- Completed source code.
- Architecture.
- Game specifications.
- Verified mechanics.
- Testing results.
- Known issues.
- Roadmap progress.
- Development decisions.
- Build workflows.
- Latest handoff instructions.

Every continuation must be safe even if the previous Work conversation is unavailable.

A new instance of ChatGPT Work should be able to inspect the repository and resume development logically.

If the user starts a new conversation with only:

**"Continue developing MindSprint using the repository checkpoint."**

that should be sufficient when the repository is accessible.

---

# 23. FINAL DELIVERY REQUIREMENTS

The complete project must ultimately provide:

1. A private GitHub repository containing the native Swift iOS application.
2. All eight implemented games.
3. Verified and documented game rules.
4. A fast, intuitive interface with persistent numerical input.
5. Native haptic feedback.
6. Offline gameplay.
7. Personal leaderboards and historical attempts.
8. Difficulty options.
9. Local statistics and performance trends.
10. Export/import backups.
11. Automated testing.
12. GitHub Actions compilation.
13. An unsigned iPhone-device IPA.
14. LiveContainer installation guidance.
15. A maintainable project for future upgrades.

Any unsupported or unverified functionality must be explicitly identified.

Do not present source-code completion as equivalent to a successfully compiled, tested iOS application.

---

# 24. INITIAL EXECUTION INSTRUCTION

**Start with Milestone 0 only.**

Do not attempt to research all eight games and write the entire application during this first session.

Set up the repository and durable checkpoint system.

Initialize the roadmap and documentation.

Verify your available GitHub access.

Commit the initial project state if possible.

Provide a concise report.

Then STOP.

The next message from me will simply be:

**Continue**

When that message arrives, execute the next unfinished milestone according to the saved checkpoint and this master prompt.

Continue this pattern until the entire application is complete.

Your success is measured not by how much you attempt in one Work session, but by how reliably the project advances toward a finished, tested, native iPhone application without losing work or wasting capacity.
