# Preset calibration guide

This guide makes preset contributions reviewable and helps prevent old or incomplete values from being treated as universal defaults.

## Calibration principles

- Calibrate every new or updated weapon preset at **900 DPI, vertical sensitivity 10, and horizontal sensitivity 20**. This is mandatory so the script can scale the result for other settings.
- Use one repeatable setup for every test.
- Change only one variable at a time.
- State the game build or date tested, because game updates can change behavior.
- Record attachment, sensitivity, DPI, resolution, and any other relevant setting.
- Treat a result as configuration-specific, not a guarantee for every user.

## Submission record

Include this information in a **Preset calibration** issue or pull request:

| Field | What to provide |
| :--- | :--- |
| Preset name | Existing preset to update, or proposed new name |
| Game build/date | Version number if available, otherwise the test date |
| Proposed value | The integer strength value tested |
| Attachment | Exact attachment configuration |
| In-game settings | Vertical `10` and horizontal `20`, plus other relevant settings |
| Hardware | Mouse model and **900 DPI** |
| Display | Resolution and display mode, if relevant |
| Test method | Repeatable steps and test duration |
| Observed result | What happened and how consistent it was |
| Scope/limitations | Conditions under which the value should not be used |

## Review process

Maintainers should verify that the report is complete, assess whether it conflicts with an existing preset, and record the change in [CHANGELOG.md](../CHANGELOG.md) when merged. If there is not enough information to reproduce a result, request clarification rather than guessing.

## Keeping presets current

When a game update changes a preset's behavior, open a calibration issue even if a replacement value is not yet known. This creates a visible record that the existing value may be outdated.
