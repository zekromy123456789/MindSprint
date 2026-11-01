# MindSprint

MindSprint is a planned, fully offline native iPhone mental-speed game inspired by OpenQuant's Game Room. The intended release includes eight independently implemented games, fast native input, local records, backups, and an unsigned device IPA for evaluation with LiveContainer.

All eight games, including Letter Speed, are playable in simulator. Arithmetic Pro is a provisional independently generated implementation. Pro has four custom difficulty levels and a question mix that differs from the reference; Sequence offers Classic and four custom family mixes; Optiver follows reference-style decimal precision and distractor ranges with documented safety and fixed-point differences. Local records and backups are in development.

## Resuming work

Read [HANDOFF](docs/project-state/HANDOFF.md) first, then the [roadmap](docs/project-state/ROADMAP.md), inspect the repository and build status, and complete only the next milestone or a bounded subtask. Update the checkpoint and validate the work before stopping. The full requirements and acceptance criteria are preserved in [MASTER_BRIEF](docs/MASTER_BRIEF.md). Repository state takes precedence over stale checkpoint claims.

GitHub repository: https://github.com/zekromy123456789/MindSprint. The user explicitly approved using this public repository. See the handoff for current build status.

## Building on macOS

Requirements: Xcode with an iOS simulator runtime, XcodeGen and Python 3. The configured deployment target is iOS 17. Generate the project with `xcodegen generate`; open `MindSprint.xcodeproj` or run `xcodebuild` with the `MindSprint` scheme. The GitHub Actions workflow runs simulator tests and separately builds for `iphoneos` with signing disabled, verifies an arm64 binary and ZIP integrity, and uploads the unsigned IPA and logs. It can also be started manually. GitHub Actions run 41345066774 passed simulator tests, built an unsigned arm64 device app, verified ZIP integrity, and uploaded an IPA. Physical-device installation and LiveContainer compatibility remain unverified. An unsigned IPA is not directly installable as a normally signed application. No signing credentials are included.

The project is generated from `project.yml`; do not edit the generated Xcode project as the source of truth.



