# Improvements for RRSCRIPT V1.2

This document outlines the changes and fixes for version 1.2 of the Recoil Control Script.

## Changes Since v1.1

### Profile Order Updates (Commit 9d463bf)
- Fixed profile ordering in both RRSCRIPT.lua and RRSCRIPT.ps1 to better organize weapons by category
- Updated weapon lists to group similar weapon types together
- Moved several weapons to more logical positions in the profile order
- Updated `.github/PULL_REQUEST_TEMPLATE.md` to simplify verification instructions

### Build Workflow Improvements (Commit 04442b4)
- Removed outdated markdown syntax validation from GitHub Actions workflow
- Removed the `Test-Documentation.ps1` script validation step that was causing issues
- Updated `scripts/ProfilePopup.pyw` with the same profile order fixes as in the main scripts
- Cleaned up CI/CD configuration to focus on essential validations only

## Summary of Changes

**RRSCRIPT.lua:**
- Reordered weapon profiles in `ProfileOrder` table for better organization
- Fixed inconsistent weapon naming and grouping

**RRSCRIPT.ps1:**
- Updated weapon profile list in the GUI dropdown to match lua ordering
- Fixed profile order consistency between lua and powershell scripts

**Documentation:**
- Simplified pull request template verification instructions
- Removed outdated documentation validation workflow

**Support Files:**
- Updated `scripts/ProfilePopup.pyw` with corresponding profile order fixes

## Backward Compatibility
- All existing configurations continue to work unchanged
- No changes to core recoil control functionality or settings
- Profile names remain the same, only their order in the dropdown has changed
- No user action required when updating to this version

## Technical Notes
- Profile order changes affect only the dropdown sequence in the configuration GUI
- Weapon functionality and recoil values remain unchanged
- The reordering improves usability by grouping similar weapon types together
- All horizontal recoil compensation features from v1.1 remain fully functional