# 📖 Script Configuration & Usage Guide

This guide explains how each setting in the Lua recoil script works, how to modify key settings, and how to create your own custom weapon presets.

---

## ⚙️ Core Settings (`--- DONT CHANGE ---`)
> You can change them but i dont recommend it ad they are tuned to be perfect

These top-level variables dictate the primary behavior and toggle conditions of the macro.

| Variable | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `EnableRCS` | `Boolean` | `true` | Master switch for the Recoil Control System. Set to `false` to disable all macro operations. |
| `RequireToggle` | `Boolean` | `false` | When set to `true`, the macro will **only** run when a specific keyboard lock key (like CapsLock) is active. |
| `ToggleKey` | `String` | `"CapsLock"` | The keyboard key used for toggling when `RequireToggle` is enabled (e.g., `"CapsLock"`, `"NumLock"`, `"ScrollLock"`). |
| `DelayRate` | `Integer` | `20` | Delay in milliseconds between each downward mouse adjustment tick. Lower values make recoil pull smoother but use more execution cycles. |

---

## 🔫 Weapon Profiles (`--- WEAPON PRESETS ---`)

The script features pre-configured recoil pull strengths for specific weapons, as well as a fully customizable mode.

### Active Preset Selection

To change the active weapon preset, update the `RecoilControlMode` line near the top of the script:

```lua
RecoilControlMode = "R4C" -- Options: "P90", "SMG11", "SMG12", "R4C", "AK74M", "F2", "M762", "XK23", "Scorpion", "K1A", "MPX", "Vector", "Custom" -- More coming soon

## How to Edit & Create Custom Profiles

1. Adjusting the Custom Mode
If your weapon isn't listed or you use custom attachments (e.g., Muzzle Brake, Suppressor), set RecoilControlMode = "Custom" and adjust RcCustomStrength:

```lua
RecoilControlMode = "Custom"
RcCustomStrength = 20  -- Increase to pull down MORE, decrease to pull down LESS

2. Adding a New Weapon Preset
To permanently add a new weapon to the preset list, add an elseif condition in the preset block:

```lua
elseif RecoilControlMode == "MY_NEW_GUN" then
    RecoilControlStrength = 25

    🖱️ Script Trigger Mechanics (------------ CODE -------------)
The core execution block determines when and how recoil compensation applies:

Dual-Trigger Requirement: The script only triggers when both Mouse 1 (Primary Attack / Fire) and Mouse 3 (Aim Down Sight / Middle Click depending on setup) are held down simultaneously.

Looping Movement: While both buttons remain pressed, the script executes MoveMouseRelative(0, RecoilControlStrength) every DelayRate milliseconds.

Automatic Release: As soon as you release either Left-Click or Right-Click, the loop terminates immediately.

> [!TIP]
> Fine-Tuning Recoil in Game:
> 
> If your crosshair pulls down towards the floor: Decrease the strength value.
> 
> If your crosshair still bounces upwards: Increase the strength value.