PROJECT: MindSprint

CURRENT MILESTONE: 7 — Shared game engine (NOT STARTED)
CURRENT SUBTASK: Design and implement minimal testable shared engine with deterministic randomness and controllable monotonic time; split into bounded subtasks if needed.

LAST COMPLETED WORK: Milestone 6 researched Flexibility and Letter Speed through unsigned-in play and supplied public script SHA-256 1a4b0c3c95ffb3bc6cdcd9de393a1cefe52530969185646be86d33850a919b51. Documented two-card color comparison, +1/-1 scoring and balanced answer generation; Letter Speed ten-round 4-option calculation, timing and scoring. All eight modes now have initial evidence-labelled specs and consolidated gaps in docs/OPENQUANT_GAME_MECHANICS.md. No source code copied.

FILES CREATED OR MODIFIED: docs/OPENQUANT_GAME_MECHANICS.md and docs/project-state/RESEARCH_STATE.md, ROADMAP.md, HANDOFF.md, PROJECT_STATE.md, KNOWN_ISSUES.md.

LATEST COMMIT: Inspect GitHub main for checkpoint. Last tested app source 9a11f27bccf50b649539bbc9a7c9844cd7e387ef. Local Git history not synchronized due to ownership mismatch.

BUILD STATUS: GitHub Actions run 41080417640 passed device build and IPA checks; artifact expires 2027-01-28. Documentation-only work; no new build needed.

TEST STATUS: One XCTest passed in run 41080417640. Live Flexibility samples confirmed correct/incorrect score and timeout screen. Letter Speed option selection and timeout advanced rounds; no full ten-round or correct time-score sample observed. Source-based mechanics and inferred limitations are labelled.

KNOWN ISSUES: No games implemented. Reference source defects and untested timing/input/device edge cases are in KNOWN_ISSUES.md and mechanics report. Arithmetic Pro fixed source pool cannot be copied; exact independent distribution unresolved. LiveContainer physical-device compatibility unverified.

CURRENT BLOCKERS: None identified for milestone 7. Local Windows lacks Swift and Xcode; use GitHub Actions for build/test. GitHub connector supports remote commits; local Git ownership mismatch remains.

NEXT EXACT TASK: Begin milestone 7 only. Inspect existing SwiftUI scaffold, project.yml, tests, CI and mechanics report. Design minimal UI-independent session state, difficulty/configuration, scoring, controllable monotonic clock, seeded random interface and transitions without forcing unrelated games into a single question model. Implement and add meaningful deterministic tests; run CI and inspect results. Split into bounded subtasks if necessary; update checkpoint and stop without starting milestone 8.

NEXT TASK ACCEPTANCE CRITERIA: Shared infrastructure compiles; deterministic unit tests pass; no unnecessary UI coupling; next game can use it without engine rewrite. Document build or CI blockers honestly.

IMPORTANT CONTEXT: Read HANDOFF then ROADMAP, verify actual repository and build. Full requirements in docs/MASTER_BRIEF.md. One milestone or bounded subtask per session. User approved public repository; independent implementations only. Use monotonic time even though reference uses wall clock; avoid copying original source/question lists. Never claim LiveContainer compatibility without physical verification.
