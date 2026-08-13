# Troubleshooting

## The G HUB console does not display `LOADED`

Save and run the script from the G HUB script editor. If the console shows an error, copy the full message into a bug report along with the G HUB version and your mouse model. If no message appears, confirm that the script is attached to the active game profile.

## The script never activates

Check the following:

1. `EnableRCS` is set to `true`.
2. If `RequireToggle` is `true`, the configured `ToggleKey` is enabled.
3. Your in-game fire and aim bindings match the inputs expected by the script.
4. The correct Logitech G HUB game profile is active.
5. Both required mouse-button inputs are held at the same time.

## The script activates, but there is no movement

Ensure that `RecoilControlMode` exactly matches one of the documented preset names or `Custom`. An unrecognized name selects a strength of `0` in the current script. For `Custom`, also confirm that `RcCustomStrength` is a non-zero number.

## The profile-switch button does not cycle profiles

Confirm that `ProfileSwitchButton` is set to the mouse-button number you are pressing, then save and run the script again in G HUB. The default is button `5`, which is commonly a side button. Do not set it to `1` or `3`, as those inputs are used for the fire-and-aim trigger. Each successful press writes the active profile to the G HUB output console.

## Recoil control remains disabled after using the temporary toggle

Press the same `TemporaryToggleButton` again, or press the Logitech G-key set by `TemporaryToggleGKey`. The temporary toggle retains the active profile and prints it when recoil control is re-enabled. If recoil still does not run, check that `EnableRCS` is `true` and, when enabled, the `RequireToggle` lock-key condition is satisfied.

## The on-screen profile popup does not appear

The popup requires Windows, Python 3, and `scripts/ProfilePopup.pyw` to be running. Start it once per session, then confirm that **RRC Profile Popup** is visible in the Windows system tray. Right-click the icon and select **Test profile popup** first. If `Profile: TEST` does not appear, the overlay is blocked or hidden; use borderless/windowed fullscreen instead of exclusive fullscreen. If the test works but Mouse 5 does not cycle the popup, ensure Mouse 5 has not been remapped or intercepted by another program. Also confirm that `INITIAL_PROFILE` in `ProfilePopup.pyw` matches `RecoilControlMode` in `RRSCRIPT.lua` before the helper starts.

## The result is inconsistent

Preset values are sensitive to changes in attachment, in-game sensitivity, DPI, resolution, and game updates. Retest with one consistent configuration. The current values assume a Flash Hider; if your setup differs, use a custom profile and record the conditions before requesting a preset update.

## The wrong profile is selected

Set `RecoilControlMode` near the top of `RRSCRIPT.lua`, save the script, and rerun it in G HUB. Profile names are case-sensitive. The full built-in preset list is in the [usage guide](HOWTOUSE.md).

## Still need help?

Open a bug report with the information requested in [Contributing](CONTRIBUTING.md). Do not publish account details or other private information.
