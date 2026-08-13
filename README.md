# Rexzy — R6 Siege Recoil Control Script
> Custom Logitech G Hub macro engineered for minimal recoil across primary and secondary loadouts.

### Features:
* **Custom Profiles:** Built-in weapon presets + customizable Profiles.
* **Smart Toggles:** Configurable activation keys (e.g., Caps Lock) and custom delay rates.
---
###### *Credits to the original creator [@0CT1](https://github.com/0CT1)*

![Lua](https://img.shields.io/badge/Language-Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)
![Logitech](https://img.shields.io/badge/Logitech-G%20Hub-00B8FC?style=flat-square&logo=logitech&logoColor=white)
![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)

> [!IMPORTANT]
> ### Terms of Use & Disclaimer of Responsibility
> By downloading or using this script, you acknowledge that you are using it at your own discretion and risk. The software is provided "as-is" without warranty of any kind. Under no circumstances shall the author be held liable for any damages, account bans, or punitive actions taken by game developers or anti-cheat > systems.
___
## Requirements

> Before installing, ensure you have the following setup:

*  **Logitech G Mouse:** Any Logitech G-series mouse compatible with G HUB.
*  **Logitech G HUB:** Installed and running (Windows / macOS).
*  **In-Game Settings:** Primary shoot set to `Mouse 1` (Left-Click) and Aim Down Sight (ADS) set to `Mouse 3` (Right-Click).
---
## Installation Guide

Follow these steps to load the Lua script into Logitech G HUB:

**0.** **Install and Extract the Script**
   Install the Script from the Repository and extract it to your Desktop.

**1.** **Open Logitech G HUB**
   Launch the **Logitech G HUB** software on your PC. *(Running G HUB as Administrator is recommended).*

**2.** **Select Your Game Profile**
   Click on the active profile dropdown at the top center of the screen and choose Manage Profiles.

**3.** **Select your Rainbow 6 Siege Profile**
   Click on Rainbow 6 Siege then you will be within the Rainbow 6 Profile. Select the Profiles three dots which is set to `Default`.
   > #### Rainbow 6 Siege not Visible?
   > Simply choose add Games and Apps and Select Rainbow 6 Siege
   
**4.** **Creating a New Script**
   Click **Create Lua Script** and delete the existing Code.

**5.** **Setting up the Script**
   Delete any default text inside the editor window, then copy and paste the Lua script code into the editor, give it a Name in the Top middle where it says `New Script`.

**6.** **Save and Activate**
   Click **Script > Save & Run** from the top menu (or press `Ctrl + S`). Check the output console at the bottom to verify the script saved without errors.
> [!TIP]
> If done correctly the Output Console should show `LOADED`.
>
> **Quick Usage Tip:**
> * To adjust weapon profiles, change `RecoilControlMode = "Custom"` at the top of the script to your desired weapon (e.g., `RecoilControlMode = "R4C"`).
> * Remember to hit `Ctrl + S` in the script editor every time you edit values.
> * For a Full Tutorial, check out [How to use?](HOWTOUSE.md)
___
> [!NOTE]
> ## Contributing
> Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**!
> ### How to Get Started
> * Check out the [Contributing Guidelines](CONTRIBUTING.md) for step-by-step guidance on submitting pull requests and reporting bugs.
> * Please make sure to review and follow our [Code of Conduct](CODE_OF_CONDUCT.md) to keep this Script community welcoming and inclusive.
> 
> ### Ways You Can Help
> *  **Report Bugs:** Open an issue if you find a broken preset or script error.
> *  **Add Presets:** Share optimized recoil values for new or updated guns.
> *  **Improve Code:** Optimize performance or clean up existing Lua logic.
___
> [!TIP]
> ### Thanks for using my Script!
> **Need help About general inquiries?**
> * Send me an email at **[rexzy63@proton.me](mailto:rexzy63@proton.me)**!
