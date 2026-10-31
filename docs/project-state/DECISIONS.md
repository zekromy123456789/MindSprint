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

- 2026-10-30: After simulator UI automation found no keyboard focus, 8E uses a UIKit first-responder receiver with an empty custom input view to forward hardware actions without the standard keyboard; this is a candidate pending CI and visual/device verification. Arithmetic custom difficulty ranges are independent product choices, not reference claims; Classic uses documented ranges.
