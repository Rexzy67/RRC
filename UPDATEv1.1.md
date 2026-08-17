# Improvements for RRSCRIPT V1.1

This document outlines the major new feature and improvements for version 1.1 of the Recoil Control Script.

## Major New Feature: Horizontal Recoil Compensation

### Overview
Version 1.03 adds full horizontal recoil compensation capability, allowing the script to counteract both vertical and horizontal recoil patterns for improved accuracy with weapons that have significant horizontal kick.

### RRSCRIPT.lua Improvements

#### New Features
1. **Horizontal Recoil Compensation Toggle**
   - Added `EnableHorizontalRCS` configuration option
   - When enabled, script applies both vertical and horizontal mouse movements
   - When disabled (default), maintains original vertical-only behavior for backward compatibility

2. **Horizontal Strength Configuration**
   - Added `HorizontalRcCustomStrength` for custom profile horizontal strength
   - Added `ProfileHorizontalStrengths` table defining horizontal recoil values for each weapon preset
   - Default horizontal strengths are set to 0 (no horizontal compensation) for all weapons

3. **Enhanced Scaling Function**
   - Updated `ScaleRecoilStrength()` to accept a `useVerticalSensitivity` parameter
   - Properly scales horizontal strength using horizontal sensitivity when needed
   - Maintains vertical scaling using vertical sensitivity

4. **Improved Profile Information**
   - Enhanced `PrintActiveProfile()` to display both vertical and horizontal strengths
   - Shows baseline values for both axes

5. **Updated Event Handling**
   - Modified `OnEvent` function to conditionally apply horizontal movement
   - Uses `MoveMouseRelative(HorizontalRecoilControlStrength, RecoilControlStrength)` when horizontal RCS is enabled
   - Falls back to `MoveMouseRelative(0, RecoilControlStrength)` when disabled

#### Configuration Improvements
1. Added validation for new horizontal sensitivity values
2. Updated calibration validation to include HorizontalSensitivity
3. Enhanced error messages to reflect new capabilities

### RRSCRIPT.ps1 Improvements

#### New GUI Elements
1. **Horizontal RCS Checkbox**
   - New "Enable Horizontal RCS" checkbox in Calibration Settings section
   - Defaults to unchecked (disabled) for backward compatibility

2. **Custom Horizontal Strength Control**
   - New "Custom Horizontal Strength" numeric input
   - Range: 0-500, default value 0
   - Only active when "Custom" weapon is selected

#### Updated Features
1. Updated Lua template to include all new placeholders:
   - `__ENABLE_HORIZONTAL_RCS__`
   - `__CUSTOM_HORIZ_STR__`
   - Enhanced ProfileHorizontalStrengths table
   - Updated ScaleRecoilStrength function
   - Enhanced PrintActiveProfile function
   - Updated OnEvent function with horizontal movement logic

2. Improved variable replacement logic in save event
3. Updated form size to accommodate new controls
4. Improved GUI organization with clear section dividers

### Backward Compatibility
- All existing configurations will continue to work unchanged
- Horizontal RCS is disabled by default
- When disabled, script behaves identically to previous versions
- No changes required to existing weapon profiles or strengths

### Usage Instructions
1. Run `RRSCRIPT.ps1`
2. Configure your settings as usual
3. To enable horizontal recoil compensation:
   - Check the new "Enable Horizontal RCS" box
   - Adjust horizontal strength values for your preferred weapons (optional)
   - For custom weapons, set both vertical and horizontal strength values
4. Save and load the script into Logitech G HUB as normal
5. The script will now compensate for both vertical and horizontal recoil when enabled

### Technical Details
- Horizontal compensation uses the same smoothing algorithm as vertical
- Scaling accounts for both DPI and horizontal sensitivity differences
- Debouncing and safety features (minimum delay, button validation) apply to both axes
- CPU usage impact is minimal when horizontal RCS is disabled
- When enabled, additional calculations are negligible on modern systems

## Bug Fixes (Included from v1.02)
All improvements from v1.02 are included:
1. Fixed grammar in error messages
2. Complete calibration validation (now includes HorizontalSensitivity)
3. Profile switching debouncing (200ms default)
4. Minimum delay rate protection (10ms default)
5. Button conflict validation (prevents buttons 1&3 conflicts)
6. Enhanced documentation throughout

These improvements make RRSCRIPT more robust, versatile, and user-friendly while maintaining full compatibility with existing setups.