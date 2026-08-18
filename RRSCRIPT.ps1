Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# --- GUI Setup ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Logitech G HUB RCS Configurator"
$form.Size = New-Object System.Drawing.Size(400, 620)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Corrected variable scope for position math
$script:yPos = 20

# Helper function to add labels
function Add-Label($text) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Location = New-Object System.Drawing.Point(20, $script:yPos)
    $lbl.AutoSize = $true
    [void]$form.Controls.Add($lbl)
}

# Helper function to add numeric inputs
function Add-Numeric($text, $default, $max) {
    Add-Label $text
    $num = New-Object System.Windows.Forms.NumericUpDown
    $num.Location = New-Object System.Drawing.Point(200, ($script:yPos - 2))
    $num.Maximum = $max
    $num.Value = $default
    $num.Width = 120
    [void]$form.Controls.Add($num)
    $script:yPos += 30
    return $num
}

# Helper function to add dropdowns
function Add-Combo($text, $items, $default) {
    Add-Label $text
    $cmb = New-Object System.Windows.Forms.ComboBox
    $cmb.Location = New-Object System.Drawing.Point(200, ($script:yPos - 2))
    [void]$cmb.Items.AddRange($items)
    $cmb.SelectedItem = $default
    $cmb.DropDownStyle = 'DropDownList'
    $cmb.Width = 120
    [void]$form.Controls.Add($cmb)
    $script:yPos += 30
    return $cmb
}

# --- Core Settings ---
$chkEnableRCS = New-Object System.Windows.Forms.CheckBox
$chkEnableRCS.Text = "Enable RCS"
$chkEnableRCS.Location = New-Object System.Drawing.Point(20, $script:yPos)
$chkEnableRCS.Checked = $true
[void]$form.Controls.Add($chkEnableRCS)

$chkRequireToggle = New-Object System.Windows.Forms.CheckBox
$chkRequireToggle.Text = "Require Toggle"
$chkRequireToggle.Location = New-Object System.Drawing.Point(200, $script:yPos)
$chkRequireToggle.Checked = $false
[void]$form.Controls.Add($chkRequireToggle)
$script:yPos += 30

$cmbToggleKey = Add-Combo "Toggle Key" @("CapsLock", "ScrollLock", "NumLock") "CapsLock"
$numDelayRate = Add-Numeric "Delay Rate (ms)" 20 1000
$numProfileSwitch = Add-Numeric "Profile Switch Button" 8 20
$numPrevProfile = Add-Numeric "Previous Profile Button" 7 20
$numPrevGKey = Add-Numeric "Previous Profile G-Key" 0 20
$numProfileDebounce = Add-Numeric "Profile Switch Debounce (ms)" 200 1000
$numMinDelay = Add-Numeric "Minimum Delay Rate (ms)" 10 100

# Divider
$script:yPos += 10

# --- Calibration Settings ---
$numDPI = Add-Numeric "Mouse DPI" 900 32000
$numVertSens = Add-Numeric "Vertical Sensitivity" 10 100
$numHorizSens = Add-Numeric "Horizontal Sensitivity" 20 100

# Divider
$script:yPos += 10

# --- Humanizer Settings ---
$numHumanizer = Add-Numeric "Humanizer Strength" 1.0 5.0

# --- NEW FEATURE: Enable Horizontal RCS ---
$chkEnableHorizontalRCS = New-Object System.Windows.Forms.CheckBox
$chkEnableHorizontalRCS.Text = "Enable Horizontal RCS"
$chkEnableHorizontalRCS.Location = New-Object System.Drawing.Point(20, $script:yPos)
$chkEnableHorizontalRCS.Checked = $false
[void]$form.Controls.Add($chkEnableHorizontalRCS)
$script:yPos += 30

# Divider
$script:yPos += 10

# --- Weapon Settings ---
$profiles = @("P90","SMG11","SMG12","R4C","AK74M","F2","M762","XK23","Scorpion","K1A","MPX","Vector","T-5","9x19","TCSG12","MP7","UZK50GI","MP5","MP5SD","MP5K","416-C","UMP45","P10 Roni","SPEAR .308","PARA-308","556XI","L85A2","M4","AK-12","552 COMMANDO","C8-SFW","V308","T-95 LSW","C7E","F90","G36C","POF-9","Custom")
$cmbWeapon = Add-Combo "Default Weapon" $profiles "Custom"
$numCustomStr = Add-Numeric "Custom Strength" 32 500
$numCustomHorizStr = Add-Numeric "Custom Horizontal Strength" 0 500  # New: Horizontal strength for custom profile

$script:yPos += 20

# --- Save Button ---
$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save Configuration (.lua)"
$btnSave.Size = New-Object System.Drawing.Size(200, 40)
$btnSave.Location = New-Object System.Drawing.Point(85, $script:yPos)
$btnSave.BackColor = [System.Drawing.Color]::LightGreen
[void]$form.Controls.Add($btnSave)

# --- Lua Template ---
$luaTemplate = @"
-- If opened in a code editor, this file may show API warnings because it uses Logitech G HUB's Lua API.
-- Edit and run the script in Logitech G HUB to verify it.

--DO NOT CHANGE (BASELINE VALUES)---
BaselineDPI = 900
BaselineVerticalSensitivity = 10
BaselineHorizontalSensitivity = 20
------------------------------------

----- USER CONFIGURATION -----
EnableRCS = __ENABLE_RCS__
EnableHorizontalRCS = __ENABLE_HORIZONTAL_RCS__  -- New: Enable horizontal recoil compensation
RequireToggle = __REQUIRE_TOGGLE__
ToggleKey = "__TOGGLE_KEY__"
DelayRate = __DELAY_RATE__
HumanizerStrength = __HUMANIZER_STRENGTH__  -- Strength of humanizer effect (0.0 = disabled, higher = stronger)

-- Press this mouse-button number to cycle to the next weapon profile.
-- Mouse button 8 is commonly an extra side button. Do not use buttons 1 or 3 here.
ProfileSwitchButton = __SWITCH_BTN__

-- Press this mouse button to return to the previous weapon profile.
-- Set to 0 to disable this control. Do not use buttons 1, 3, or ProfileSwitchButton.
PreviousProfileButton = __PREV_BTN__

-- Optional Logitech G-key (G1 through G18) for the same previous-profile control.
-- Set to 0 when unused. Normal letter keys are not exposed to G HUB Lua scripts.
PreviousProfileGKey = __PREV_GKEY__

-- Profile switching debounce time (milliseconds) to prevent rapid cycling
-- Set to 0 to disable debouncing
ProfileSwitchDebounce = __PROFILE_DEBOUNCE__

-- Minimum delay rate (milliseconds) to prevent excessive CPU usage
-- Set to 0 to disable minimum delay validation
MinDelayRate = __MIN_DELAY_RATE__

----- DPI AND SENSITIVITY CALIBRATION -----
-- Presets are calibrated at 900 DPI, Vertical 10, and Horizontal 20.
-- Enter your own current mouse DPI and Rainbow Six Siege sensitivity below.
-- HorizontalSensitivity is recorded for calibration compatibility; this script moves both vertically and horizontally when enabled.
MouseDPI = __DPI__
VerticalSensitivity = __V_SENS__
HorizontalSensitivity = __H_SENS__

----- WEAPON PRESETS -----
RecoilControlMode = "__WEAPON__"
RcCustomStrength = __CUSTOM_STR__
HorizontalRcCustomStrength = __CUSTOM_HORIZ_STR__  -- New: Horizontal strength for custom profile

ProfileOrder = {
"SMG11", "SMG12", "C8-SFW", "F2", "R4C", "P90", "MP5", "MPX", "MP5K", "MP5SD", "MP7", "P10 Roni", "Vector", "XK23", "AK-12", "AK74M", "C7E", "416-C", "9x19", "F90", "K1A", "M762", "POF-9", "Scorpion", "T-5", "T-95 LSW", "TCSG12", "UMP45", "UZK50GI", "G36C", "L85A2", "M4", "PARA-308", "SPEAR .308", "SPEAR .308 HOLO", "V308", "552 COMMANDO", "556XI", "Custom"
}

ProfileStrengths = {
    P90 = 15, SMG11 = 25, SMG12 = 31, R4C = 18, AK74M = 23, F2 = 52, M762 = 37, XK23 = 26, Scorpion = 18, K1A = 15, MPX = 13, Vector = 13, ["T-5"] = 15, ["9x19"] = 14, TCSG12 = 60, MP7 = 17, UZK50GI = 17, MP5 = 14, MP5SD = 16, MP5K = 16, ["416-C"] = 13, UMP45 = 8, ["P10 Roni"] = 14, ["SPEAR .308"] = 33, ["PARA-308"] = 28, ["556XI"] = 24, L85A2 = 26, M4 = 35, ["AK-12"] = 37, ["552 COMMANDO"] = 37, ["C8-SFW"] = 41, V308 = 29, ["T-95 LSW"] = 32, C7E = 42, F90 = 31, G36C = 36, ["POF-9"] = 33, Custom = RcCustomStrength
}

-- New: Horizontal strengths for each weapon (default 0, meaning no horizontal compensation)
ProfileHorizontalStrengths = {
    P90 = 0, SMG11 = 0, SMG12 = 0, R4C = 0, AK74M = 0, F2 = 0, M762 = 0, XK23 = 0, Scorpion = 0, K1A = 0, MPX = 0, Vector = 0, ["T-5"] = 0, ["9x19"] = 0, TCSG12 = 0, MP7 = 0, UZK50GI = 0, MP5 = 0, MP5SD = 0, MP5K = 0, ["416-C"] = 0, UMP45 = 0, ["P10 Roni"] = 0, ["SPEAR .308"] = 0, ["PARA-308"] = 0, ["556XI"] = 0, L85A2 = 0, M4 = 0, ["AK-12"] = 0, ["552 COMMANDO"] = 0, ["C8-SFW"] = 0, V308 = 0, ["T-95 LSW"] = 0, C7E = 0, F90 = 0, G36C = 0, ["POF-9"] = 0, Custom = HorizontalRcCustomStrength
}

CalibrationIsValid = type(MouseDPI) == "number" and MouseDPI > 0 and type(VerticalSensitivity) == "number" and VerticalSensitivity > 0 and type(HorizontalSensitivity) == "number" and HorizontalSensitivity > 0

function ScaleRecoilStrength(baselineStrength, useVerticalSensitivity)
    if baselineStrength <= 0 then return 0 end
    if not CalibrationIsValid then return baselineStrength end
    local dpiScale = BaselineDPI / MouseDPI
    local sensitivityScale
    if useVerticalSensitivity then
        sensitivityScale = BaselineVerticalSensitivity / VerticalSensitivity
    else
        sensitivityScale = BaselineHorizontalSensitivity / HorizontalSensitivity
    end
    local scaledStrength = baselineStrength * dpiScale * sensitivityScale
    return math.max(1, math.floor(scaledStrength + 0.5))
end

function GetProfileIndex(profileName)
    for index, name in ipairs(ProfileOrder) do
        if name == profileName then return index end
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
    OutputLogMessage("Current weapon profile: %s (vertical strength: %s, horizontal strength: %s; 900 DPI/V10/H20 baseline: V%i, H%i)\n", tostring(RecoilControlMode), tostring(RecoilControlStrength), tostring(HorizontalRecoilControlStrength), tostring(BaselineRecoilControlStrength), tostring(BaselineHorizontalRecoilControlStrength))
end

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

-- Generate a random delay for humanizer effect (1-5ms * strength)
function GetHumanizerDelay()
    if HumanizerStrength <= 0 then
        return 0
    end
    -- Random value between 1-5 multiplied by strength
    return math.random(1, 5) * HumanizerStrength
end

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
    return (event == "MOUSE_BUTTON_PRESSED" and PreviousProfileButton > 0 and arg == PreviousProfileButton) or (event == "G_PRESSED" and PreviousProfileGKey > 0 and arg == PreviousProfileGKey)
end

------------ LOGITECH G HUB EVENTS -------------
EnablePrimaryMouseButtonEvents(true)

if not CalibrationIsValid then
    OutputLogMessage("Invalid MouseDPI, VerticalSensitivity, or HorizontalSensitivity. Using unscaled 900 DPI/V10/H20 preset values.\n")
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

    if not EnableRCS then return end
    if RequireToggle and not IsKeyLockOn(ToggleKey) then return end

    if event == "MOUSE_BUTTON_PRESSED" and (arg == 1 or arg == 3) and IsMouseButtonPressed(1) and IsMouseButtonPressed(3) then
            -- Minimum start delay (110-120ms) to prevent instant triggering
            Sleep(110 + math.random(0, 10))

            repeat
                if EnableHorizontalRCS then
                    MoveMouseRelative(HorizontalRecoilControlStrength, RecoilControlStrength)
                else
                    MoveMouseRelative(0, RecoilControlStrength)
                end
                -- Base delay + humanizer effect
                Sleep(GetEffectiveDelayRate() + GetHumanizerDelay())
            until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
        end
end
"@

# --- Save Event Logic ---
$btnSave.Add_Click({
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "Lua Files (*.lua)|*.lua|All Files (*.*)|*.*"
    $saveDialog.FileName = "RecoilScript.lua"

    if ($saveDialog.ShowDialog() -eq "OK") {
        # Process Variables
        $strEnable = if ($chkEnableRCS.Checked) { "true" } else { "false" }
        $strEnableHoriz = if ($chkEnableHorizontalRCS.Checked) { "true" } else { "false" }  # New: Horizontal RCS enable
        $strToggle = if ($chkRequireToggle.Checked) { "true" } else { "false" }
        $strHumanizer = $numHumanizer.Value.ToString()

        # Replace placeholders
        $outputScript = $luaTemplate -replace "__ENABLE_RCS__", $strEnable `
                                     -replace "__ENABLE_HORIZONTAL_RCS__", $strEnableHoriz `
                                     -replace "__REQUIRE_TOGGLE__", $strToggle `
                                     -replace "__TOGGLE_KEY__", $cmbToggleKey.SelectedItem `
                                     -replace "__DELAY_RATE__", $numDelayRate.Value `
                                     -replace "__HUMANIZER_STRENGTH__", $strHumanizer `
                                     -replace "__SWITCH_BTN__", $numProfileSwitch.Value `
                                     -replace "__PREV_BTN__", $numPrevProfile.Value `
                                     -replace "__PREV_GKEY__", $numPrevGKey.Value `
                                     -replace "__PROFILE_DEBOUNCE__", $numProfileDebounce.Value `
                                     -replace "__MIN_DELAY_RATE__", $numMinDelay.Value `
                                     -replace "__DPI__", $numDPI.Value `
                                     -replace "__V_SENS__", $numVertSens.Value `
                                     -replace "__H_SENS__", $numHorizSens.Value `
                                     -replace "__WEAPON__", $cmbWeapon.SelectedItem `
                                     -replace "__CUSTOM_STR__", $numCustomStr.Value `
                                     -replace "__CUSTOM_HORIZ_STR__", $numCustomHorizStr.Value `

        # Write to file
        [System.IO.File]::WriteAllText($saveDialog.FileName, $outputScript)

        [System.Windows.Forms.MessageBox]::Show("Script saved successfully to:`n" + $saveDialog.FileName, "Success", "OK", "Information")
    }
})

# Show App
[void]$form.ShowDialog()