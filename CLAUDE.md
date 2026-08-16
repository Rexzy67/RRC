# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains a Logitech G HUB Lua script for Rainbow Six Siege recoil control (RRSCRIPT.lua) and a PowerShell-based configuration generator (RRSCRIPT.ps1). The Lua script implements vertical recoil compensation using mouse movement, with configurable weapon profiles, toggle keys, and calibration for different DPI/sensitivity settings.

## Development

### Modifying the Recoil Control Script

The main logic is in `RRSCRIPT.lua`. This script is designed to be loaded into Logitech G HUB's Lua script editor.

To modify the recoil behavior:
1. Edit the `RRSCRIPT.lua` file directly, or
2. Use the `RRSCRIPT.ps1` PowerShell script to generate a new `RRSCRIPT.lua` with desired settings.

### Using the Configuration Generator

The `RRSCRIPT.ps1` script provides a Windows Forms GUI to adjust:
- Enable/disable RCS (recoil control system)
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

### RRSCRIPT.lua
- **Configuration section** (lines 10-34): User-adjustable settings (EnableRCS, ToggleKey, DelayRate, ProfileSwitchButton, etc.)
- **Calibration settings** (lines 28-34): Mouse DPI and sensitivity values used to scale recoil strength
- **Weapon presets** (lines 36-120): Profile ordering and predefined recoil strengths for various weapons
- **Helper functions**:
  - `ScaleRecoilStrength`: Adjusts base strength based on current DPI/sensitivity vs baseline (900 DPI, V10, H20)
  - `GetProfileIndex`: Returns index of a profile name in ProfileOrder
  - `SetActiveProfile`: Sets current profile and calculates scaled strength
  - `PrintActiveProfile`: Logs current profile and strength to G HUB console
  - `CycleProfile`/`PreviousProfile`: Functions for switching weapon profiles
  - `IsPreviousProfilePressed`: Checks for mouse/G-key events to trigger previous profile
- **Event handler** (lines 208-250): `OnEvent` function processes mouse button presses for:
  - Previous profile button
  - Profile switch button
  - Recoil compensation (when both mouse buttons 1 and 3 are pressed and RCS is enabled)

### RRSCRIPT.ps1
- **GUI setup**: Creates a Windows Forms application with controls for all configurable parameters
- **Helper functions**: `Add-Label`, `Add-Numeric`, `Add-Combo` simplify GUI creation
- **Lua template** (lines 99-228): Contains the full Lua script with placeholders for configuration values
- **Save logic** (lines 231-260): Replaces placeholders in the template with GUI values and writes to file
- **Event handling**: Save button click triggers the file generation and shows success message

## Notes

- The script is calibrated for 900 DPI, Vertical Sensitivity 10, Horizontal Sensitivity 20 (baseline values in lines 5-7)
- Adjust `MouseDPI` and `VerticalSensitivity` in the configuration to match your setup for proper scaling
- The script only handles vertical recoil compensation (horizontal movement is not implemented)
- Profile switching uses mouse buttons (default: button 8 for next, button 7 for previous) with optional G-key support
- Recoil activation requires both left and right mouse buttons pressed (unless `RequireToggle` is enabled and toggle key is active)

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