# Known issues and limitations

- The app is a minimal scaffold with no gameplay. All reference mechanics remain unresearched.
- GitHub Actions run 41080417640 passed simulator test and unsigned arm64 device build, ZIP validation and IPA upload. The artifact expires 2027-01-28. An unsigned IPA and archive checks do not establish installation or LiveContainer compatibility; no physical-device test has been performed.
- Git status and commit locally are blocked by Git's dubious-ownership check: workspace and `.git` have different Windows owners. Remote changes use the GitHub connector; local and remote Git histories are not synchronized.
- Local Windows environment lacks Xcode and iOS SDK. CI installs an unpinned XcodeGen version; runner or dependency changes can affect reproducibility.
