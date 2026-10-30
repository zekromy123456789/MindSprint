# Known issues and limitations

- GitHub repository https://github.com/zekromy123456789/MindSprint was initially empty. The user explicitly approved its public visibility. Verify actual repository content and build status on continuation.
- Git status and commit are blocked by Git's dubious-ownership check: workspace and newly initialized `.git` have different Windows owners. Scoped trust attempts did not resolve it. No local commit or push has been made. The GitHub connector may support uploading directly once visibility is resolved.
- The XcodeGen project, simulator tests, device build and IPA packaging workflow have not been run on macOS. The Windows environment has no Swift, Xcode, XcodeGen or iOS SDK. The workflow installs an unpinned XcodeGen version; runner and dependency changes may affect reproducibility.
- No IPA artifact exists and LiveContainer compatibility is unverified on a physical device.
- All reference game mechanics are unresearched and unverified; no gameplay exists.

