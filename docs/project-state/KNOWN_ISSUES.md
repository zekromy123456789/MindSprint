# Known issues and limitations

- CI run 41079574187 passed one simulator XCTest and built an arm64 iOS device app, but packaging failed due to incorrect lipo argument order. Fixed in 9a11f27; corrected run 41080417640 was still in progress at checkpoint. No successful IPA artifact is yet verified.
- GitHub repository https://github.com/zekromy123456789/MindSprint is public with explicit user approval. Actions runs do start after GitHub API updates, although they may appear after a delay.
- Git status and commit locally are blocked by Git's dubious-ownership check: workspace and `.git` have different Windows owners. Remote changes use the GitHub connector; local and remote Git histories are not synchronized.
- Local Windows environment lacks Xcode and iOS SDK. XcodeGen is installed unpinned in CI; runner or dependency changes can affect reproducibility.
- LiveContainer compatibility is unverified on a physical device. No gameplay exists; reference mechanics are unresearched.
