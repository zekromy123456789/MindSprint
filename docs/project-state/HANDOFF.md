PROJECT: MindSprint

CURRENT MILESTONE: 3 — Research Arithmetic and Arithmetic Pro (IN PROGRESS)
CURRENT SUBTASK: Investigate generator rules and remaining input/timing edge cases; public script access remains limited.

LAST COMPLETED WORK: On 2026-10-30, additional direct tests showed Arithmetic `0528` for `66 * 8` and pasted `88.0` for `85 + 3` did not advance, but canonical integer strings did. Pro `031` and `31.0` for `(8 * 3) + 6 + 1` did not advance, but `31` did; `16 - (4 + 3) * (14 + 1) = -89` was accepted. Hiding the Arithmetic timer did not pause the sampled session. These suggest, but do not prove, string-sensitive validation. Public page script name identified; browser asset export excludes scripts and web retrieval failed. Documented optional user-side DevTools route for obtaining public bundle; avoid credentials and network captures.

FILES CREATED OR MODIFIED: docs/OPENQUANT_GAME_MECHANICS.md, project-state HANDOFF.md, PROJECT_STATE.md, RESEARCH_STATE.md and KNOWN_ISSUES.md.

LATEST COMMIT: Inspect GitHub main for checkpoint. Local Git history is not synchronized to GitHub due to ownership mismatch. Last tested app source 9a11f27bccf50b649539bbc9a7c9844cd7e387ef.

BUILD STATUS: GitHub Actions run 41080417640 passed device build and IPA checks; artifact expires 2027-01-28. Documentation-only changes; no new build needed.

TEST STATUS: One XCTest passed in run 41080417640. Direct gameplay observations recorded with concrete cases; no automated gameplay tests yet.

KNOWN ISSUES: Generator ranges, operator weights, full Pro grammar, zero and other input edge cases, background/expiry behavior remain unverified. No games implemented; no physical LiveContainer verification. See KNOWN_ISSUES.md.

CURRENT BLOCKERS: Public JavaScript bundle could not be read via available web tool; browser asset exporter does not support scripts. Anonymous gameplay works. User can optionally provide public page JavaScript from DevTools Sources (not private credentials or HAR files); continue productive direct research independently.

NEXT EXACT TASK: Continue milestone 3 only. If public bundle supplied, inspect independently and record evidence without copying implementation; otherwise collect further game samples and test remaining practical edge cases, document legitimate limits. Finalize both detailed evidence-labelled specs, ranges where known, timing, scoring, progression and examples; mark complete only when acceptance criteria are met. Do not start milestone 4 in same session.

NEXT TASK ACCEPTANCE CRITERIA: Detailed specs for both games covering generation, ranges, scoring, timing, answers, progression, difficulty, end conditions and edge cases, with verified and inferred rules distinguished, mathematical examples and explicit remaining uncertainties.

IMPORTANT CONTEXT: Read this file first on continuation, then ROADMAP.md, verify actual repository and build. Full requirements in docs/MASTER_BRIEF.md. One milestone or bounded subtask per session. User approved public repository; all eight games mandatory. Never claim LiveContainer compatibility without physical verification.
