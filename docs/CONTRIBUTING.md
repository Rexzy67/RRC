# Contributing guidelines

Thank you for considering a contribution. Documentation fixes, reproducible bug reports, and carefully recorded calibration updates all help keep the project useful.

Please review the [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

## Before opening an issue

- Read the [usage guide](HOWTOUSE.md) and [troubleshooting guide](TROUBLESHOOTING.md).
- Search existing issues to avoid duplicates.
- Do not include personal information, account details, or screenshots containing private data.

## Report a bug

Use the **Bug report** issue form and include:

- Logitech G HUB version and mouse model.
- Operating system version.
- The full G HUB console error, if present.
- The active script settings, except for any personal information.
- Clear steps to reproduce the behavior and the expected result.

## Submit a preset calibration

Preset values can become stale when game settings change. Use the **Preset calibration** issue form or submit a pull request that includes the information required by the [calibration guide](CALIBRATION.md). A useful submission records the game build, the exact attachment assumptions, sensitivity and DPI, the test method, and the observed result.

Do not present a calibration as universally valid. Hardware and game settings differ between users.

## Improve the code or documentation

1. Fork the repository and create a focused branch.

   ```bash
   git checkout -b docs/improve-installation-guide
   ```

2. Make one logical change per pull request where practical.
3. Update related documentation when behavior or supported presets change.
4. Run the repository checks locally:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Test-Documentation.ps1
   ```

5. Open a pull request using the supplied template. Explain what changed, why it changed, and how you verified it.

## Pull-request expectations

- Keep the Lua script compatible with Logitech G HUB's Lua environment.
- Keep user-editable settings grouped at the top of the script.
- Preserve or improve the documentation for every user-visible change.
- Do not include unrelated formatting-only changes.
- Ensure the GitHub validation workflow passes.

## Maintainer release checklist

Before publishing a release, maintainers should:

1. Confirm that `RRSCRIPT.lua` contains the intended script and is included in the release commit.
2. Run the documentation checks and Lua syntax check.
3. Review new or changed presets against their calibration records.
4. Update [CHANGELOG.md](../CHANGELOG.md).
5. Recheck the usage and compatibility notice for clarity.
