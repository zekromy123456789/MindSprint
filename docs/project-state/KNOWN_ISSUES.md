# Known issues and limitations

- No games implemented. All eight games have initial evidence-labelled research, but background/expiry races and input edge cases remain untested. The supplied Optiver generator can select a zero divisor; avoid invalid questions and document the deviation. Optiver rounding and rapid-tap behavior require tests. Source inspection suggests Risk green balloons use red probability due to fall-through, Memory may allow premature submission, and Letter Speed may briefly show a stale timer after an answer; none of these was independently reproduced as a defect. Full-session outcomes and correct Letter Speed time scoring remain incompletely observed. Pro selects from a protected fixed pool and has a potential out-of-range index in the supplied implementation; do not copy its pool or reproduce the crash. Exact independent Pro distribution remains unresolved.
- GitHub Actions run 41080417640 passed simulator test and unsigned arm64 device build, ZIP validation and IPA upload. Artifact expires 2027-01-28. IPA checks do not establish installation or LiveContainer compatibility; no physical-device test has been performed.
- Local Git status and commit are blocked by a Windows ownership mismatch. GitHub connector updates remote; local and remote Git histories are not synchronized.
- Local Windows environment lacks Xcode and iOS SDK. CI installs an unpinned XcodeGen version; runner or dependency changes can affect reproducibility.



