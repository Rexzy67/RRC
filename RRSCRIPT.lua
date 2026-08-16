-- If opened in a code editor, this file may show undefined global variable warnings because this script uses Logitech G HUB's Lua API.
-- Edit and run the script in Logitech G HUB to verify it.

--DO NOT CHANGE (BASELINE VALUES)---
BaselineDPI = 900
BaselineVerticalSensitivity = 10
BaselineHorizontalSensitivity = 20
------------------------------------

----- USER CONFIGURATION -----
EnableRCS = true
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

----- DPI AND SENSITIVITY CALIBRATION -----
-- Presets are calibrated at 900 DPI, Vertical 10, and Horizontal 20.
-- Enter your own current mouse DPI and Rainbow Six Siege sensitivity below.
-- HorizontalSensitivity is recorded for calibration compatibility; this script only moves vertically.
MouseDPI = 900
VerticalSensitivity = 10
HorizontalSensitivity = 20

----- WEAPON PRESETS -----
RecoilControlMode = "Custom"
RcCustomStrength = 32

ProfileOrder = {
    "P90",
    "SMG11",
    "SMG12",
    "R4C",
    "AK74M",
    "F2",
    "M762",
    "XK23",
    "Scorpion",
    "K1A",
    "MPX",
    "Vector",
    "T-5",
    "9x19",
    "TCSG12",
    "MP7",
    "UZK50GI",
    "MP5",
    "MP5SD",
    "MP5K",
    "416-C",
    "UMP45",
    "P10 Roni",
    "SPEAR .308",
    "PARA-308",
    "556XI",
    "L85A2",
    "M4",
    "AK-12",
    "552 COMMANDO",
    "C8-SFW",
    "V308",
    "T-95 LSW",
    "C7E",
    "F90",
    "G36C",
    "POF-9",
    "Custom"
}

ProfileStrengths = {
    P90 = 15,
    SMG11 = 25,
    SMG12 = 31,
    R4C = 18,
    AK74M = 23,
    F2 = 52,
    M762 = 37,
    XK23 = 26,
    Scorpion = 18,
    K1A = 15,
    MPX = 13,
    Vector = 13,
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
    ["PARA-308"] = 28,
    ["556XI"] = 24,
    L85A2 = 26,
    M4 = 35,
    ["AK-12"] = 37,
    ["552 COMMANDO"] = 37,
    ["C8-SFW"] = 41,
    V308 = 29,
    ["T-95 LSW"] = 32,
    C7E = 42,
    F90 = 31,
    G36C = 36,
    ["POF-9"] = 33,
    Custom = RcCustomStrength
}

CalibrationIsValid = type(MouseDPI) == "number"
    and MouseDPI > 0
    and type(VerticalSensitivity) == "number"
    and VerticalSensitivity > 0

function ScaleRecoilStrength(baselineStrength)
    if baselineStrength <= 0 then
        return 0
    end

    if not CalibrationIsValid then
        return baselineStrength
    end

    local scaledStrength = baselineStrength
        * (BaselineDPI / MouseDPI)
        * (BaselineVerticalSensitivity / VerticalSensitivity)

    return math.max(1, math.floor(scaledStrength + 0.5))
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
    RecoilControlStrength = ScaleRecoilStrength(BaselineRecoilControlStrength)
end

function PrintActiveProfile()
    OutputLogMessage(
        "Current weapon profile: %s (strength: %s; 900 DPI/V10/H20 baseline: %s)\n",
        tostring(RecoilControlMode),
        tostring(RecoilControlStrength),
        tostring(BaselineRecoilControlStrength)
    )
end

CurrentProfileIndex = GetProfileIndex(RecoilControlMode)

if CurrentProfileIndex ~= nil then
    SetActiveProfile(ProfileOrder[CurrentProfileIndex])
else
    BaselineRecoilControlStrength = 0
    RecoilControlStrength = 0
end

function CycleProfile()
    if CurrentProfileIndex == nil then
        CurrentProfileIndex = 1
    else
        CurrentProfileIndex = (CurrentProfileIndex % #ProfileOrder) + 1
    end

    SetActiveProfile(ProfileOrder[CurrentProfileIndex])
    PrintActiveProfile()
end

function PreviousProfile()
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
        "Invalid MouseDPI or VerticalSensitivity and or HorizontalSensitivity. Using unscaled 900 DPI/V10/H20 preset values.\n"
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

    if event == "MOUSE_BUTTON_PRESSED"
        and (arg == 1 or arg == 3)
        and IsMouseButtonPressed(1)
        and IsMouseButtonPressed(3) then

        repeat
            MoveMouseRelative(0, RecoilControlStrength)
            Sleep(DelayRate)
        until not IsMouseButtonPressed(1)
           or not IsMouseButtonPressed(3)
    end
end
