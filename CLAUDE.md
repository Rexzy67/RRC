# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains a Logitech G HUB Lua script for Rainbow Six Siege recoil control (RRSCRIPT.lua) and a PowerShell-based configuration generator (RRSCRIPT.ps1). The Lua script implements vertical and horizontal recoil compensation using mouse movement, with configurable weapon profiles, toggle keys, and calibration for different DPI/sensitivity settings.

## Development

### Modifying the Recoil Control Script

The main logic is in `RRSCRIPT.lua`. This script is designed to be loaded into Logitech G HUB's Lua script editor.

To modify the recoil behavior:
1. Edit the `RRSCRIPT.lua` file directly, or
2. Use the `RRSCRIPT.ps1` PowerShell script to generate a new `RRSCRIPT.lua` with desired settings.

### Using the Configuration Generator

The `RRSCRIPT.ps1` script provides a Windows Forms GUI to adjust:
- Enable/disable RCS (recoil control system)
- Enable/disable horizontal recoil compensation
- Toggle key requirements (CapsLock, ScrollLock, NumLock)
- Delay rate between mouse movements (ms)
- Mouse button assignments for profile switching (next/previous)
- DPI and sensitivity settings for calibration
- Default weapon profile and custom strength value

To generate a new Lua script:
1. Run `RRSCRIPT.ps1` (requires Windows PowerShell)
2. Adjust settings in the GUI
3. Click "Save Configuration (.lua)" to export the configured Lua script

### Testing

There are no automated tests. To test changes:
1. Load the generated or modified `RRSCRIPT.lua` into Logitech G HUB
2. Save and run the script in G HUB
3. Verify the output console shows "LOADED"
4. Test in-game with the configured weapon and settings

## Code Structure

- **Configuration section**: User-adjustable settings (EnableRCS, EnableHorizontalRCS, ToggleKey, DelayRate, ProfileSwitchButton, etc.)
- **Calibration settings**: Mouse DPI and sensitivity values used to scale recoil strength (both vertical and horizontal)
- **Weapon presets**: Profile ordering and predefined recoil strengths (both vertical and horizontal) for various weapons
- **Helper functions**:
  - `ScaleRecoilStrength`: Adjusts base strength based on current DPI/sensitivity vs baseline (900 DPI, V10, H20) and returns a decimal value for fine-tuned control
  - `GetProfileIndex`: Returns index of a profile name in ProfileOrder
  - `SetActiveProfile`: Sets current profile and calculates scaled vertical and horizontal strength
  - `PrintActiveProfile`: Logs current profile and strength to G HUB console (now shows two decimal places)
  - `CycleProfile`/`PreviousProfile`: Functions for switching weapon profiles
  - `IsPreviousProfilePressed`: Checks for mouse/G-key events to trigger previous profile
- **Event handler**: `OnEvent` function processes mouse button presses for:
  - Previous profile button
  - Profile switch button
  - Recoil compensation (when both mouse buttons 1 and 3 are pressed and RCS is enabled; supports both vertical and horizontal movement based on configuration)

## Notes

- The script is calibrated for 900 DPI, Vertical Sensitivity 10, Horizontal Sensitivity 20 (baseline values)
- Adjust `MouseDPI`, `VerticalSensitivity`, and `HorizontalSensitivity` in the configuration to match your setup for proper scaling
- The script handles both vertical and horizontal recoil compensation when `EnableHorizontalRCS` is set to true
- Profile switching uses mouse buttons (default: button 8 for next, button 7 for previous) with optional G-key support
- Recoil activation works when both mouse buttons are pressed, regardless of order (shoot then aim or aim then shoot)
- Decimal values are allowed for recoil strength to enable fine-tuned control

## Repository Structure

- `RRSCRIPT.lua`: Main Lua script for Logitech G HUB
- `RRSCRIPT.ps1`: PowerShell script to generate configured Lua script
- `README.md`: Installation and usage instructions
- `UPDATEv1.01.md`: Update notes and changelog
- `docs/CODE_OF_CONDUCT.md`: Contributor guidelines
- `.github/`: GitHub issue and pull request templates

## Commands

While there are no traditional build or test commands, the following are useful:

- **Launch configuration GUI**: `powershell -File RRSCRIPT.ps1`
- **View Lua script**: `Get-Content RRSCRIPT.lua` (PowerShell) or `cat RRSCRIPT.lua` (bash)
- **Check for updates**: Refer to `UPDATEv1.01.md` for version history

## Contributing

See [CODE_OF_CONDUCT.md](docs/CODE_OF_CONDUCT.md) for community guidelines.
Contributions are welcome via pull requests. Please:
- Report bugs in the Issues section
- Share optimized weapon presets for new or updated guns
- Submit improvements to the Lua logic (performance, readability) or configuration generator
- Follow the existing code style and commenting conventions