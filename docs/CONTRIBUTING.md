# Contributing Guidelines

First off, thank you for considering contributing to this project! 🎉

Whether you are adding new weapon recoil presets, fixing a bug, or improving documentation, all contributions help make this project better for everyone.

Please take a moment to review these guidelines before submitting a contribution.

---

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md). Please report any unacceptable behavior to the project maintainers.

---

## How Can You Contribute?

### 1. Adding or Updating Weapon Presets
Game balance patches frequently change weapon recoil patterns. If you have fine-tuned optimized values for existing guns or want to add support for new weapons:

1. Test your recoil values thoroughly in-game.
2. Edit the Lua script to include the new/updated `elseif` block with your tested values.
3. Open a Pull Request with a short description of the weapon and how the values were tested.

### 2. Reporting Bugs
If the script isn't triggering properly or you run into Lua compilation errors in Logitech G HUB:

* Check the **[Issues](../../issues)** tab to see if the problem has already been reported.
* If not, **open a new issue** and include:
  * Your Logitech G HUB version.
  * Your mouse model.
  * The exact error message from the G HUB console (if applicable).
  * Steps to reproduce the issue.

### 3. Requesting Features or Improvements
Have an idea for code optimization, new toggle keys, or a better activation method?
* Feel free to open a feature request under **[Issues](../../issues)** or submit a direct Pull Request.

---

## Submitting a Pull Request (PR)

Follow these steps to submit your changes:

1. **Fork** the repository.
2. **Create a new branch** for your feature or fix:
   ```bash
   git checkout -b feature/new-weapon-preset