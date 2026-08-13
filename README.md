# Rexzy — R6 Siege Recoil Control Script

Custom Logitech G HUB Lua script with built-in presets and a configurable custom profile.

![Lua](https://img.shields.io/badge/Language-Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)
![Logitech](https://img.shields.io/badge/Logitech-G%20Hub-00B8FC?style=flat-square&logo=logitech&logoColor=white)
![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)

> [!IMPORTANT]
> ## Usage and compatibility
>
> Game rules, terms of service, and anti-cheat policies can change. Confirm that input automation is permitted in the environment where you play before using this project. Use is at your own discretion and risk; the software is provided as-is, without warranty. The maintainers are not responsible for account actions or other consequences arising from its use.

## Features

- Built-in weapon presets and a configurable `Custom` profile.
- Button-controlled profile cycling with console feedback and an optional standalone Windows popup beside the cursor.
- Configurable master switch, lock-key requirement, and delay rate.
- Logitech G HUB event handling that activates only while the configured fire and aim buttons are held.
- Documentation for installation, configuration, troubleshooting, and contributing calibrated presets.

## Requirements

- A Logitech G-series mouse compatible with Logitech G HUB.
- Logitech G HUB installed and running on Windows or macOS.
- In-game bindings that match the button assignments used by the script.
- The attachment and settings assumptions documented in the [usage guide](docs/HOWTOUSE.md).

## Installation

1. Download [RRSCRIPT.lua](RRSCRIPT.lua).
2. In Logitech G HUB, select or create the Rainbow Six Siege game profile.
3. Open the profile menu, choose **Create Lua Script**, and replace the default editor contents with `RRSCRIPT.lua`.
4. Save and run the script with **Script > Save & Run** (or <kbd>Ctrl</kbd>+<kbd>S</kbd>).
5. Confirm that the G HUB console displays `LOADED`, then configure the active profile as described in the [usage guide](docs/HOWTOUSE.md).

For step-by-step G HUB navigation and configuration, see [How to use](docs/HOWTOUSE.md). If something does not work, start with [Troubleshooting](docs/TROUBLESHOOTING.md).

## Documentation

- [Configuration and usage](docs/HOWTOUSE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Preset calibration guide](docs/CALIBRATION.md)
- [Contributing guidelines](docs/CONTRIBUTING.md)
- [Code of Conduct](docs/CODE_OF_CONDUCT.md)
- [Changelog](CHANGELOG.md)

## Contributing

Bug reports, documentation improvements, and preset calibration submissions are welcome. Please read the [contributing guidelines](docs/CONTRIBUTING.md) and [Code of Conduct](docs/CODE_OF_CONDUCT.md) before opening an issue or pull request.

## Credits

Original creator: [@0CT1](https://github.com/0CT1).

## License

Distributed under the [MIT License](LICENSE).
