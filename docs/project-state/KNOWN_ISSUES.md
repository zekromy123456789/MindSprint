# Known issues and limitations

- No games implemented. All eight games have initial evidence-labelled research, but background/expiry races and input edge cases remain untested. The supplied Optiver generator can select a zero divisor; avoid invalid questions and document the deviation. Optiver rounding and rapid-tap behavior require tests. Source inspection suggests Risk green balloons use red probability due to fall-through, Memory may allow premature submission, and Letter Speed may briefly show a stale timer after an answer; none of these was independently reproduced as a defect. Full-session outcomes and correct Letter Speed time scoring remain incompletely observed. Pro selects from a protected fixed pool and has a potential out-of-range index in the supplied implementation; do not copy its pool or reproduce the crash. Exact independent Pro distribution remains unresolved.
- GitHub Actions run 41080417640 passed simulator test and unsigned arm64 device build, ZIP validation and IPA upload. Artifact expires 2027-01-28. IPA checks do not establish installation or LiveContainer compatibility; no physical-device test has been performed.
- Local Git status and commit are blocked by a Windows ownership mismatch. GitHub connector updates remote; local and remote Git histories are not synchronized.
- Local Windows environment lacks Xcode and iOS SDK. CI installs an unpinned XcodeGen version; runner or dependency changes can affect reproducibility.




- Shared engine primitives passed CI run 41086929248. Callers must refresh a session when the app resumes; per-question duplicate submission protection and game-specific progression are not yet implemented.


- Milestone 8A numeric input and standalone keypad passed CI run 41088538679; they are not integrated into any screen. Hardware key routing and haptic settings now compile, but delivery and physical feedback have not been tested; device layout validation is also pending. Digit limit does not validate numeric conversion overflow; game validators must do so.


- 8B catalog and navigation plus reusable active/results templates compile in CI run 41089968056; navigation interaction and visual layout remain unverified. Games are disabled; records and settings are placeholders. Numeric template composes keypad but is not connected to real gameplay.


- 8C keyboard routing and haptic settings passed CI run 41091082669. The keypad is not in a reachable playable screen, so real iOS hardware-key focus, haptic feel and accessibility remain unverified. Haptic result feedback is available but not connected to games.


- 8D run 41092465371 passed 12 unit tests and two UI tests on each of iPhone 17 Pro and Pro Max. Screenshot attachments were retained but the GitHub artifact-download connector returned an internal error, so images have not been reviewed. Physical hardware-key focus and haptic behavior remain unverified.

