# Project state

- Project: MindSprint
- Repository: https://github.com/zekromy123456789/MindSprint (public, approved by user).
- Last completed milestone: 11 — Sequence, verified to simulator limits.
- Current milestone: 12 — Optiver 80 in 8 (in progress); gameplay, results and custom operation levels passed simulator CI. Reference-style precision and distractor range changes await CI; exact binary rounding remains unproven.
- Next subtask: 12D — Verify reference-style precision and distractor range changes in CI; retain safety deviations.
- Overall status: Arithmetic, Arithmetic Pro, Sequence and Optiver are playable in simulator. Records are not saved.
- Last passing build: GitHub Actions run 41272947659, source commit a929d5e662aebf478f2e2e4955ac3d35cc4a78de.
- Known issues: see KNOWN_ISSUES.md.
- Current limitations: local Windows lacks Xcode/simulator; real-device gameplay, keyboard, haptics and LiveContainer remain unverified.
- Next required action: verify Optiver fidelity changes in CI, retaining safe zero and ambiguity handling.
