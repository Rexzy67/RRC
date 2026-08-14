# RRC update notes

## Current update: configurable popup inputs

The standalone profile popup can now follow either keyboard keys assigned in Logitech G HUB or physical Windows mouse buttons.

### Added

- Added `INPUT_MODE` to `scripts/ProfilePopup.pyw` with two modes:
  - `"keyboard"` monitors assigned keys globally.
  - `"mouse"` monitors physical Mouse 1 through Mouse 5 buttons.
- Added configurable keyboard fields:
  - `PREVIOUS_PROFILE_KEY`
  - `NEXT_PROFILE_KEY`
- Keyboard mode supports letters, numbers, common punctuation, `Space`, `Tab`, `Enter`, `Backspace`, `Esc`, and `F1` through `F24`.
- Added input validation for unsupported keys, duplicate previous/next controls, invalid input modes, and invalid mouse-button numbers.
- Added key-repeat protection so holding a configured key advances only once until it is released and pressed again.

### Default configuration

- `RRSCRIPT.lua` still uses **Mouse 5** for the next profile and **Mouse 4** for the previous profile.
- The popup defaults to Mouse mode, matching the recommended Logitech G HUB assignments:
- The popup remains independent from G HUB and does not require G HUB to access external files.

### Alternative mouse mode

For mice that expose profile controls directly to Windows, set `INPUT_MODE = "mouse"` and configure `PREVIOUS_PROFILE_MOUSE_BUTTON` and `NEXT_PROFILE_MOUSE_BUTTON`. Mouse mode supports buttons `1` through `5`; avoid Mouse 1 and Mouse 3 unless the Lua fire-and-aim bindings have also been changed.

### Documentation and verification

- Updated setup and troubleshooting guidance for keyboard and mouse input modes.
- Validated the popup configuration, keyboard symbol mapping for `-` and `,`, repeated-key handling, Python syntax, and Markdown documentation.

## Overview

This release expands the Logitech G HUB recoil-control script with weapon profile navigation, sensitivity scaling, additional presets, and an independent Windows profile popup. It also adds setup, calibration, troubleshooting, and contribution guidance for GitHub.

## Added

### Profile navigation in Logitech G HUB

- **Mouse 5** moves to the next weapon profile.
- **Mouse 4** moves to the previous weapon profile.
- Both directions wrap around at the beginning and end of the profile list.
- `PreviousProfileGKey` can be set to a compatible Logitech G-key (`1` through `18`) as an alternative previous-profile control.
- Every profile change prints the current weapon and its scaled recoil strength in the G HUB script console.
- The profile controls stay available even when recoil control is disabled or the optional lock-key requirement is inactive.

> [!NOTE]
> Logitech G HUB's Lua API does not expose ordinary keyboard-letter press events to scripts. Profile navigation must therefore use a mouse button or supported Logitech G-key rather than a key such as `P`.

### Sensitivity and DPI scaling

- Added `MouseDPI`, `VerticalSensitivity`, and `HorizontalSensitivity` configuration values.
- All preset strengths are calibrated from the original **900 DPI**, **vertical sensitivity 10**, and **horizontal sensitivity 20** baseline.
- Vertical recoil compensation now scales automatically for the configured DPI and vertical sensitivity.
- Invalid DPI or vertical-sensitivity values are reported in the G HUB console and safely fall back to the original baseline strength.

### New weapon presets

The following calibrated profiles were added to the shared profile cycle.

#### Defenders

| Weapon | Operator | Baseline strength |
| :--- | :--- | ---: |
| `T-5` | Lesion | 15 |
| `9x19` | Kapkan | 14 |
| `TCSG12` | Kaid | 60 |
| `MP7` | Bandit | 17 |
| `UZK50GI` | Thorn | 17 |
| `MP5` | Melusi | 14 |
| `MP5SD` | Echo | 16 |
| `MP5K` | Mute | 16 |
| `416-C` | Jäger | 13 |
| `UMP45` | Castle | 8 |
| `P10 Roni` | Mozzie | 14 |

#### Attackers

| Weapon | Operator | Baseline strength |
| :--- | :--- | ---: |
| `SPEAR .308` | Finka | 33 |
| `PARA-308` | Brava | 28 |
| `556XI` | Thermite | 24 |
| `L85A2` | Thatcher | 26 |
| `M4` | Maverick | 35 |
| `AK-12` | Ace | 37 |
| `552 COMMANDO` | Grim | 37 |
| `C8-SFW` | Buck | 41 |
| `V308` | Lion | 29 |
| `T-95 LSW` | Ying | 32 |
| `C7E` | Jackal | 42 |
| `F90` | Gridlock | 31 |
| `G36C` | Iana | 36 |
| `POF-9` | Sens | 33 |

### Independent Windows profile popup

Added `scripts/ProfilePopup.pyw`, a standalone Windows helper that does not depend on G HUB reading external files or communicating with another process.

- Monitors physical Mouse 4 and Mouse 5 using Windows APIs and follows the same profile order as `RRSCRIPT.lua`.
- Displays the previous, current, and next weapon in a compact top-right popup.
- Uses opaque white background and black current-profile text; neighboring profiles use lower-contrast gray text.
- Positions the popup 50 pixels from the top and right screen edges.
- Sizes the popup to fit the longest displayed weapon name.
- Adds an **RRC Profile Popup** system-tray icon with startup help, an About dialog, a popup test action, and Exit.
- Adds **Set popup profile** to the tray menu. Select any weapon to manually re-sync the popup after it drifts from G HUB. This updates only the Python helper and does not change the Lua profile or send input to the game.

## Required setup

The shipped preset values require the following Rainbow Six Siege setup:

- **Flash Hider** equipped.
- **Vertical Grip** equipped.
- **Mouse ADS Sensitivity set to 40 on every scope.**

For the popup helper, start `scripts/ProfilePopup.pyw` before saving and running `RRSCRIPT.lua` in G HUB. Keep `INITIAL_PROFILE` in the Python helper aligned with `RecoilControlMode` in the Lua script. If they become desynchronized later, use **Set popup profile** from the tray menu.

## Documentation and community improvements

- Expanded the usage guide with configuration references, start-up checks, profile order, sensitivity scaling, popup setup, and re-sync instructions.
- Documented G HUB's `LOADED` message and common failure modes in troubleshooting guidance.
- Added a dedicated preset-calibration guide and a required baseline for contributed presets: **900 DPI**, **vertical sensitivity 10**, and **horizontal sensitivity 20**.
- Added contributor guidelines, a code of conduct, GitHub issue templates, and a pull-request template.
- Added a documentation validation script and GitHub Actions workflow to check Markdown links and documentation structure.

## Verification

- Validated the standalone popup configuration and Python syntax.
- Validated Mouse 4/Mouse 5 profile navigation, manual profile selection, surrounding-profile display, and tray-submenu creation.
- Validated repository Markdown documentation.
