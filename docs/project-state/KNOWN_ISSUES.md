# Known issues and limitations

- No games implemented. Arithmetic and Arithmetic Pro have limited direct gameplay samples and timeout observations; exact generators, distributions and many edge cases remain unknown. Public JS bundle could not be read through the web inspection tool. Other modes have only entry-screen inventory.
- GitHub Actions run 41080417640 passed simulator test and unsigned arm64 device build, ZIP validation and IPA upload. The artifact expires 2027-01-28. IPA checks do not establish installation or LiveContainer compatibility; no physical-device test has been performed.
- Local Git status and commit are blocked by a Windows ownership mismatch. GitHub connector updates remote; local and remote Git histories are not synchronized.
- Local Windows environment lacks Xcode and iOS SDK. CI installs an unpinned XcodeGen version; runner or dependency changes can affect reproducibility.
