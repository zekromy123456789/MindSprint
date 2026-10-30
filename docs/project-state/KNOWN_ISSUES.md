# Known issues and limitations

- GitHub repository https://github.com/zekromy123456789/MindSprint is public with explicit user approval. Source commit 9d0372e4fae6fcb474c1bc7a0a012aae9d65cee4 was uploaded through the connector. Check main for latest checkpoint and CI status.
- No GitHub Actions run appeared after the Git-data API ref update. The connector has no workflow dispatch operation. Windows computer use stopped because it could not determine the browser URL confidently enough to enforce policy. The workflow may be started manually in GitHub Actions; diagnose any execution failures.
- Git status and commit locally are blocked by Git's dubious-ownership check: workspace and newly initialized `.git` have different Windows owners. The remote was updated through GitHub connector, not a local push; local and remote Git histories are not synchronized.
- The XcodeGen project, simulator tests, device build and IPA packaging workflow have not been run on macOS. The Windows environment has no Swift, Xcode, XcodeGen or iOS SDK. The workflow installs an unpinned XcodeGen version; runner and dependency changes may affect reproducibility.
- No IPA artifact exists and LiveContainer compatibility is unverified on a physical device.
- All reference game mechanics are unresearched and unverified; no gameplay exists.
