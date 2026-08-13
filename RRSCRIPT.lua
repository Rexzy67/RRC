-- If opened in a code editor, this file may show API warnings because it uses Logitech G HUB's Lua API.
-- Edit and run the script in Logitech G HUB to verify it.

----- USER CONFIGURATION -----
EnableRCS = true
RequireToggle = false
ToggleKey = "CapsLock"
DelayRate = 20

-- Press this mouse-button number to cycle to the next weapon profile.
-- Mouse button 5 is commonly a side button. Do not use buttons 1 or 3 here.
ProfileSwitchButton = 5

----- WEAPON PRESETS -----
RecoilControlMode = "Custom"
RcCustomStrength = 20

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
    "Custom"
}

ProfileStrengths = {
    P90 = 15,
    SMG11 = 25,
    SMG12 = 31,
    R4C = 18,
    AK74M = 23,
    F2 = 52,
    M762 = 52,
    XK23 = 26,
    Scorpion = 18,
    K1A = 15,
    MPX = 13,
    Vector = 13,
    Custom = RcCustomStrength
}

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
    RecoilControlStrength = ProfileStrengths[profileName] or 0
end

function PrintActiveProfile()
    OutputLogMessage(
        "Current weapon profile: %s (strength: %s)\n",
        tostring(RecoilControlMode),
        tostring(RecoilControlStrength)
    )
end

CurrentProfileIndex = GetProfileIndex(RecoilControlMode)

if CurrentProfileIndex ~= nil then
    SetActiveProfile(ProfileOrder[CurrentProfileIndex])
else
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

------------ LOGITECH G HUB EVENTS -------------

EnablePrimaryMouseButtonEvents(true)
PrintActiveProfile()

function OnEvent(event, arg)
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
