PROJECT: MindSprint

CURRENT MILESTONE: 3 — Research Arithmetic and Arithmetic Pro (IN PROGRESS)
CURRENT SUBTASK: Further investigate question generators, distributions and untested input/timing edge cases.

LAST COMPLETED WORK: On 2026-10-30, observed two sessions each at https://openquant.co/math-game, including one timeout per mode. Both accepted correct input automatically with +1 per tested answer; wrong 999 and Enter did not advance in sampled cases. Arithmetic included negative subtraction and exact integer division; Pro included compound expressions and precedence. Result screens showed score and last question with solution. Detailed examples and uncertainties recorded in docs/OPENQUANT_GAME_MECHANICS.md. Web inspection could not access publicly loaded JS bundle; no restrictions bypassed.

FILES CREATED OR MODIFIED: docs/OPENQUANT_GAME_MECHANICS.md and docs/project-state/RESEARCH_STATE.md, ROADMAP.md, HANDOFF.md, PROJECT_STATE.md, KNOWN_ISSUES.md.

LATEST COMMIT: Inspect GitHub main for checkpoint. Local Git repository is not synchronized with remote due to ownership mismatch. Last tested app source 9a11f27bccf50b649539bbc9a7c9844cd7e387ef.

BUILD STATUS: Run 41080417640 passed device build and IPA checks; artifact expires 2027-01-28. Documentation-only changes; no new build needed.

TEST STATUS: One XCTest passed in run 41080417640. Research examples were directly checked against site responses; no automated gameplay tests yet.

KNOWN ISSUES: Generator ranges and distributions, full Pro grammar, wrong/malformed input edge cases, timer/background and race behavior remain unverified. No games implemented; no physical LiveContainer verification. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Public JavaScript bundle URL was inaccessible through web inspection tool. Anonymous gameplay worked; investigate further with supported browser tools and respect access controls.

NEXT EXACT TASK: Continue milestone 3 only. Examine additional Arithmetic and Pro question samples, negatives/zero/decimals and input edge cases, timer/expiry behavior, and investigate public implementation only if legitimately accessible. Establish supported generator details or document legitimate limitations. Update detailed specs and evidence with examples; mark milestone complete only when its acceptance criteria are met. Do not start milestone 4 in the same session.

NEXT TASK ACCEPTANCE CRITERIA: Detailed specs for both games covering generation, ranges, scoring, timing, answers, progression, difficulty, end conditions and edge cases, with verified and inferred rules distinguished, mathematical test examples and explicit remaining uncertainties.

IMPORTANT CONTEXT: Read this file first on continuation, then ROADMAP.md, verify actual repository and build. Full requirements in docs/MASTER_BRIEF.md. One milestone or bounded subtask per session. User approved public repository; all eight games mandatory. Never claim LiveContainer compatibility without physical verification.
