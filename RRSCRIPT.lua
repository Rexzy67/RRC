-- If opened in a code editor, this file may show undefined global variable warnings because this script uses Logitech G HUB's Lua API.
-- Edit and run the script in Logitech G HUB to verify it.

--DO NOT CHANGE (BASELINE VALUES)---
BaselineDPI = 900
BaselineVerticalSensitivity = 10
BaselineHorizontalSensitivity = 20
------------------------------------

----- USER CONFIGURATION -----
EnableRCS = true
EnableHorizontalRCS = true  -- New: Enable horizontal recoil compensation
RequireToggle = false
ToggleKey = "CapsLock"
DelayRate = 20

-- Press this mouse-button number to cycle to the next weapon profile.
-- Mouse button 8 is commonly an extra side button. Do not use buttons 1 or 3 here.
ProfileSwitchButton = 8

-- Press this mouse button to return to the previous weapon profile.
-- Set to 0 to disable this control. Do not use buttons 1, 3, or ProfileSwitchButton.
PreviousProfileButton = 7

-- Optional Logitech G-key (G1 through G18) for the same previous-profile control.
-- Set to 0 when unused. Normal letter keys are not exposed to G HUB Lua scripts.
PreviousProfileGKey = 0

-- Profile switching debounce time (milliseconds) to prevent rapid cycling
-- Set to 0 to disable debouncing
ProfileSwitchDebounce = 50

-- Minimum delay rate (milliseconds) to prevent excessive CPU usage
-- Set to 0 to disable minimum delay validation
MinDelayRate = 10

----- DPI AND SENSITIVITY CALIBRATION -----
-- Presets are calibrated at 900 DPI, Vertical 10, and Horizontal 20.
-- Enter your own current mouse DPI and Rainbow Six Siege sensitivity below.
-- HorizontalSensitivity is recorded for calibration compatibility; this script moves both vertically and horizontally when enabled.
MouseDPI = 900
VerticalSensitivity = 10
HorizontalSensitivity = 20

----- WEAPON PRESETS -----
RecoilControlMode = "Custom"
RcCustomStrength = 32
HorizontalRcCustomStrength = 0  -- New: Horizontal strength for custom profile

ProfileOrder = {
    "416-C",
    "9x19",
    "F90",
    "K1A",
    "M762",
    "MP5",
    "MPX",
    "MP5K",
    "MP5SD",
    "MP7",
    "P10 Roni",
    "P90",
    "POF-9",
    "R4C",
    "Scorpion",
    "SMG11",
    "SMG12",
    "T-5",
    "T-95 LSW",
    "TCSG12",
    "UMP45",
    "UZK50GI",
    "Vector",
    "XK23",
    "AK-12",
    "AK74M",
    "C7E",
    "C8-SFW",
    "F2",
    "G36C",
    "L85A2",
    "M4",
    "PARA-308",
    "SPEAR .308",
    "SPEAR .308 HOLO",
    "V308",
    "552 COMMANDO",
    "556XI",
    "Custom"
}

ProfileStrengths = {
    P90 = 15,
    SMG11 = 26,
    SMG12 = 31,
    R4C = 45,
    AK74M = 23,
    F2 = 52,
    M762 = 37,
    XK23 = 26,
    Scorpion = 21,
    K1A = 15,
    MPX = 13,
    Vector = 18,
    ["T-5"] = 15,
    ["9x19"] = 14,
    TCSG12 = 60,
    MP7 = 17,
    UZK50GI = 17,
    MP5 = 14,
    MP5SD = 16,
    MP5K = 16,
    ["416-C"] = 13,
    UMP45 = 8,
    ["P10 Roni"] = 14,
    ["SPEAR .308"] = 33,
    ["SPEAR .308 HOLO"] = 13,
    ["PARA-308"] = 28,
    ["556XI"] = 24,
    L85A2 = 26,
    M4 = 35,
    ["AK-12"] = 37,
    ["552 COMMANDO"] = 30,
    ["C8-SFW"] = 41,
    V308 = 29,
    ["T-95 LSW"] = 32,
    C7E = 42,
    F90 = 33,
    G36C = 36,
    ["POF-9"] = 33,
    Custom = RcCustomStrength
}

-- New: Horizontal strengths for each weapon (default 0, meaning no horizontal compensation)
ProfileHorizontalStrengths = {
    P90 = 0,
    SMG11 = 1,
    SMG12 = 3,
    R4C = -2,
    AK74M = -1,
    F2 = -1,
    M762 = 1,
    XK23 = 2,
    Scorpion = 2,
    K1A = -1,
    MPX = 0,
    Vector = -1,
    ["T-5"] = 0,
    ["9x19"] = -1,
    TCSG12 = 0,
    MP7 = 0,
    UZK50GI = 0,
    MP5 = -1,
    MP5SD = -1,
    MP5K = 0,
    ["416-C"] = -1,
    UMP45 = -1,
    ["P10 Roni"] = 0,
    ["SPEAR .308"] = 0,
    ["SPEAR .308 HOLO"] = -1,
    ["PARA-308"] = -1,
    ["556XI"] = 2,
    L85A2 = 2,
    M4 = -2,
    ["AK-12"] = -3,
    ["552 COMMANDO"] = -1,
    ["C8-SFW"] = -1,
    V308 = 0,
    ["T-95 LSW"] = 0,
    C7E = -2,
    F90 = -2,
    G36C = 3,
    ["POF-9"] = -1,
    Custom = HorizontalRcCustomStrength
}

CalibrationIsValid = type(MouseDPI) == "number"
    and MouseDPI > 0
    and type(VerticalSensitivity) == "number"
    and VerticalSensitivity > 0
    and type(HorizontalSensitivity) == "number"
    and HorizontalSensitivity > 0

function ScaleRecoilStrength(baselineStrength, useVerticalSensitivity)
    if not CalibrationIsValid then
        return baselineStrength
    end

    local dpiScale = BaselineDPI / MouseDPI
    local sensitivityScale
    if useVerticalSensitivity then
        sensitivityScale = BaselineVerticalSensitivity / VerticalSensitivity
    else
        sensitivityScale = BaselineHorizontalSensitivity / HorizontalSensitivity
    end

    local scaledStrength = baselineStrength * dpiScale * sensitivityScale
    return scaledStrength
end

-- Apply minimum delay rate to prevent excessive CPU usage
function GetEffectiveDelayRate()
    if MinDelayRate > 0 and DelayRate < MinDelayRate then
        OutputLogMessage(string.format(
            "DelayRate (%d) is below minimum (%d). Using minimum value.\n",
            DelayRate, MinDelayRate
        ))
        return MinDelayRate
    end
    return DelayRate
end

function GetProfileIndex(profileName)
    for index, name in ipairs(ProfileOrder) do
        if name == profileName then
            return index
        end
    end

    return nil
end

function SetActiveProfile(profileName)
    RecoilControlMode = profileName
    BaselineRecoilControlStrength = ProfileStrengths[profileName] or 0
    BaselineHorizontalRecoilControlStrength = ProfileHorizontalStrengths[profileName] or 0
    RecoilControlStrength = ScaleRecoilStrength(BaselineRecoilControlStrength, true)
    HorizontalRecoilControlStrength = ScaleRecoilStrength(BaselineHorizontalRecoilControlStrength, false)
end

function PrintActiveProfile()
    OutputLogMessage(
        "Current weapon profile: %s (vertical strength: %.2f, horizontal strength: %.2f; 900 DPI/V10/H20 baseline: V%i, H%i)\n",
        tostring(RecoilControlMode),
        RecoilControlStrength,
        HorizontalRecoilControlStrength,
        BaselineRecoilControlStrength,
        BaselineHorizontalRecoilControlStrength
    )
end

-- Validate configuration
if ProfileSwitchButton == PreviousProfileButton then
    OutputLogMessage("Error: ProfileSwitchButton and PreviousProfileButton cannot be the same. Disabling profile switching.\n")
    ProfileSwitchButton = 0
    PreviousProfileButton = 0
end

if ProfileSwitchButton == 1 or ProfileSwitchButton == 3 then
    OutputLogMessage("Warning: ProfileSwitchButton is set to fire or aim button (1 or 3). This may interfere with gameplay.\n")
end

if PreviousProfileButton == 1 or PreviousProfileButton == 3 then
    OutputLogMessage("Warning: PreviousProfileButton is set to fire or aim button (1 or 3). This may interfere with gameplay.\n")
end

if PreviousProfileGKey < 0 or PreviousProfileGKey > 18 then
    OutputLogMessage("Warning: PreviousProfileGKey should be between 0 and 18. Setting to 0 (disabled).\n")
    PreviousProfileGKey = 0
end

-- Debounce tracking for profile switching
LastProfileSwitchTime = 0

CurrentProfileIndex = GetProfileIndex(RecoilControlMode)

if CurrentProfileIndex ~= nil then
    SetActiveProfile(ProfileOrder[CurrentProfileIndex])
else
    BaselineRecoilControlStrength = 0
    BaselineHorizontalRecoilControlStrength = 0
    RecoilControlStrength = 0
    HorizontalRecoilControlStrength = 0
end

function CycleProfile()
    -- Debounce profile switching
    local currentTime = GetRunningTime()
    if ProfileSwitchDebounce > 0 and (currentTime - LastProfileSwitchTime) < ProfileSwitchDebounce then
        return
    end
    LastProfileSwitchTime = currentTime

    if CurrentProfileIndex == nil then
        CurrentProfileIndex = 1
    else
        CurrentProfileIndex = (CurrentProfileIndex % #ProfileOrder) + 1
    end

    SetActiveProfile(ProfileOrder[CurrentProfileIndex])
    PrintActiveProfile()
end

function PreviousProfile()
    -- Debounce profile switching
    local currentTime = GetRunningTime()
    if ProfileSwitchDebounce > 0 and (currentTime - LastProfileSwitchTime) < ProfileSwitchDebounce then
        return
    end
    LastProfileSwitchTime = currentTime

    if CurrentProfileIndex == nil then
        CurrentProfileIndex = #ProfileOrder
    else
        CurrentProfileIndex = ((CurrentProfileIndex - 2) % #ProfileOrder) + 1
    end

    SetActiveProfile(ProfileOrder[CurrentProfileIndex])
    PrintActiveProfile()
end

function IsPreviousProfilePressed(event, arg)
    return (event == "MOUSE_BUTTON_PRESSED"
            and PreviousProfileButton > 0
            and arg == PreviousProfileButton)
        or (event == "G_PRESSED"
            and PreviousProfileGKey > 0
            and arg == PreviousProfileGKey)
end

------------ LOGITECH G HUB EVENTS -------------

EnablePrimaryMouseButtonEvents(true)

if not CalibrationIsValid then
    OutputLogMessage(
        "Invalid MouseDPI, VerticalSensitivity, or HorizontalSensitivity. Using unscaled 900 DPI/V10/H20 preset values.\n"
    )
end

PrintActiveProfile()

function OnEvent(event, arg)
    if IsPreviousProfilePressed(event, arg) then
        PreviousProfile()
        return
    end

    if event == "MOUSE_BUTTON_PRESSED" and arg == ProfileSwitchButton then
        CycleProfile()
        return
    end

    if not EnableRCS then
        return
    end

    if RequireToggle and not IsKeyLockOn(ToggleKey) then
        return
    end

    -- Recoil activation: works when either button is pressed while the other is held
-- This allows both "aim then shoot" and "shoot then aim" trigger patterns
if event == "MOUSE_BUTTON_PRESSED" then
    local isLeftButton = (arg == 1)
    local isRightButton = (arg == 3)
    local otherButtonHeld = isLeftButton and IsMouseButtonPressed(3) or isRightButton and IsMouseButtonPressed(1)

    if (isLeftButton or isRightButton) and otherButtonHeld then

        repeat
            if EnableHorizontalRCS then
                MoveMouseRelative(HorizontalRecoilControlStrength, RecoilControlStrength)
            else
                MoveMouseRelative(0, RecoilControlStrength)
            end
            Sleep(GetEffectiveDelayRate())
        until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
    end
end
end