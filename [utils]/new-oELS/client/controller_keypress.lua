KeyPressController = {}
CurrentVehicleEnabled = false
UIEnabled = false
UIVisible = false
UIUpdating = false
CurrentGameTime = GetGameTimer()

function KeyPressController.MainThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            CurrentGameTime = GetGameTimer()

            KeyPressController.CurrentVehicleCheck()

		    MainController.CheckVehicleStates()

            LightsController.ProcessLights()

            KeyPressController.UpdateUI()
        end
    end)

    if Config.UIEnabled and Config.UIDefaultOn then
        ExecuteCommand(Config.UICommand)
    end
end

RegisterCommand(Config.UICommand, function()
    newState = not UIEnabled
    KeyPressController.ToggleUI(newState)
end)

function KeyPressController.ToggleUI(newState)
    MainController.DebugPrint("Switching UI enabled to " .. tostring(newState))
    UIEnabled = newState

    if UIEnabled then
        KeyPressController.UpdateUI()
    end
end

function KeyPressController.DisplayUI(newState)
    MainController.DebugPrint("Switching UI display to " .. tostring(newState))
    UIVisible = newState

    SendNUIMessage({
        PayloadType = "ToggleUI",
        Visible = newState
    })
end

function KeyPressController.UpdateUI()
    if not UIEnabled then
        if UIVisible then
            MainController.DebugPrint("UI was visible, sending request to make invisible.")
            KeyPressController.DisplayUI(false)
        end

        return
    end

    if not CurrentVehicleEnabled then
        if UIVisible then
            MainController.DebugPrint("UI was visible, sending request to make invisible.")
            KeyPressController.DisplayUI(false)
        end

        return
    elseif not UIVisible then
        MainController.DebugPrint("UI was not visible, sending request to make visible.")
        KeyPressController.DisplayUI(true)
    end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)

    local bullhornButton = false
    if vehicleData.bullhorn.State == 1 then bullhornButton = true end

    local Button999 = 0
    if vehicleData.lightStates.Primary.Enabled then
        Button999 = 1
    elseif vehicleData.lightStates.OnScene.Enabled then
        Button999 = 2
    end

    local LeftAlley = false
    local RightAlley = false

    if vehicleData.lightStates.AlleyLights == 1 or vehicleData.lightStates.AlleyLights == 3 then
        LeftAlley = true
    end

    if vehicleData.lightStates.AlleyLights == 2 or vehicleData.lightStates.AlleyLights == 3 then
        RightAlley = true
    end

    SendNUIMessage({
        PayloadType = "UpdateButtons",
        ButtonStates = {
            ["360Button"] = vehicleData.lightStates.Primary.Enabled,
            ["rearRedButton"] = vehicleData.lightStates.Secondary.Enabled,
            ["bullhornButton"] = bullhornButton,
            ["999Button"] = Button999,
            ["HLButton"] = vehicleData.lightStates.WigWags.Enabled,
            ["lAlleyButton"] = LeftAlley,
            ["rAlleyButton"] = RightAlley
        }
    })
end

function KeyPressController.CurrentVehicleCheck()
	local ownPed = PlayerPedId()
	local ownVehicle = GetVehiclePedIsIn(ownPed, false)

    if ownVehicle == 0 then CurrentVehicleEnabled = false return end
    if not MainController.isVehicleELS(ownVehicle) and not MainController.isVehicleNonELS(ownVehicle) then CurrentVehicleEnabled = false return end
    if not MainController.canPedControlELS(ownPed, ownVehicle) then CurrentVehicleEnabled = false return end
    if not IsVehicleDriveable(ownVehicle) then CurrentVehicleEnabled = false return end

    if ownVehicle ~= CurrentVehicleEnabled then
        MainController.GetVehicleDataUsingEntity(ownVehicle)
    end

    CurrentVehicleEnabled = ownVehicle

    DisableControlAction(0, 81, true)
	DisableControlAction(0, 82, true)
	DisableControlAction(0, 83, true)
	DisableControlAction(0, 84, true)
	DisableControlAction(0, 85, true)
	DisableControlAction(0, 86, true)

	SetVehRadioStation(ownVehicle, "OFF")
	SetVehicleRadioEnabled(ownVehicle, false)
	SetVehicleHasMutedSirens(ownVehicle, true)

    if GetLastInputMethod(0) then
        DisableControlAction(0, 52, true)
        DisableControlAction(0, 311, true)
        DisableControlAction(0, 182, true)
        DisableControlAction(0, 47, true)
        DisableControlAction(0, 80, true)
        DisableControlAction(0, 19, true)
        DisableControlAction(0, 73, true)
    else
        DisableControlAction(0, 52, true)
        DisableControlAction(0, 19, true)
        DisableControlAction(0, 80, true)
        DisableControlAction(0, 73, true)
    end
end

function KeyPressController.TogglePrimary()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if configData.misc and configData.misc.optiLink then
        if configData.misc.optiLink.enabled and not configData.misc.optiLink['999Mode'] then
            SendNUIMessage({
                PayloadType	= "LightToggle"
            })
        end
    else
        if Config.Optilink.Enabled then
            if not MainController.shouldUse999Mode(CurrentVehicleEnabled) then
                SendNUIMessage({
                    PayloadType	= "LightToggle"
                })
            end
        end
    end

    if vehicleData.lightStates.OnScene.Enabled then
        if vehicleData.lightStates.Warning.Enabled then
            TriggerServerEvent("oELS:toggleLights", "Warning", false)
        end

        if vehicleData.lightStates.Secondary.Enabled then
            TriggerServerEvent("oELS:toggleLights", "Secondary", false)
        end

        TriggerServerEvent("oELS:toggleLights", "OnScene", false)

        return MainController.DebugPrint("Sent request to disable OnScene Lighting.")
    elseif vehicleData.lightStates.Primary.Enabled then
        if vehicleData.lightStates.Warning.Enabled then
            TriggerServerEvent("oELS:toggleLights", "Warning", false)
        end

        TriggerServerEvent("oELS:toggleLights", "Primary", false)
        TriggerServerEvent("oELS:toggleSirens", 0)
        TriggerServerEvent("oELS:toggleSecondSirens", 0)
        TriggerServerEvent("oELS:toggleLights", "OnScene", true)
        TriggerServerEvent("oELS:toggleLights", "Secondary", true)

        return MainController.DebugPrint("Sent request to toggle OnScene Lighting.")
    else
        if configData.misc and configData.misc.optiLink then
            if configData.misc.optiLink.enabled and configData.misc.optiLink['999Mode'] then
                SendNUIMessage({
                    PayloadType	= "999Mode"
                })
            end
        else
            if Config.Optilink.Enabled then
                if MainController.shouldUse999Mode(CurrentVehicleEnabled) then
                    SendNUIMessage({
                        PayloadType	= "LightToggle"
                    })
                end
            end
        end

        if configData.lightSetup.warningWithPrimary then
            TriggerServerEvent("oELS:toggleLights", "Warning", true)
        end

        if configData.lightSetup.seconaryWithPrimary then
            TriggerServerEvent("oELS:toggleLights", "Secondary", true)
        end

        TriggerServerEvent("oELS:toggleLights", "Primary", true)

        return MainController.DebugPrint("Sent request to toggle Primary Lighting.")
    end
end

function KeyPressController.ToggleSecondary()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if configData.misc and configData.misc.optiLink then
        if configData.misc.optiLink.enabled then
            SendNUIMessage({
                PayloadType	= "LightToggle"
            })
        end
    else
        if Config.Optilink.Enabled then
            SendNUIMessage({
                PayloadType	= "LightToggle"
            })
        end
    end

    if vehicleData.lightStates.Secondary.Enabled then
        TriggerServerEvent("oELS:toggleLights", "Secondary", false)

        return MainController.DebugPrint("Sent request to disable Secondary Lighting.")
    else
        TriggerServerEvent("oELS:toggleLights", "Secondary", true)

        return MainController.DebugPrint("Sent request to enable Secondary Lighting.")
    end
end

function KeyPressController.ToggleWarning()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if configData.misc and configData.misc.optiLink then
        if configData.misc.optiLink.enabled then
            SendNUIMessage({
                PayloadType	= "LightToggle"
            })
        end
    else
        if Config.Optilink.Enabled then
            SendNUIMessage({
                PayloadType	= "LightToggle"
            })
        end
    end

    if vehicleData.lightStates.Warning.Enabled then
        TriggerServerEvent("oELS:toggleLights", "Warning", false)

        return MainController.DebugPrint("Sent request to disable Warning Lighting.")
    else
        TriggerServerEvent("oELS:toggleLights", "Warning", true)

        return MainController.DebugPrint("Sent request to enable Warning Lighting.")
    end
end

function KeyPressController.ToggleSirens()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if not configData.sirens or not configData.sirens.enabled or #configData.sirens.sounds == 0 then
        return MainController.DebugPrint("Vehicle has no sirens")
    end

    if not vehicleData.lightStates.Primary.Enabled then
        return MainController.DebugPrint("Primary Lights not Enabled")
    end

    SendNUIMessage({
        PayloadType	= "SirenSwitch"
    })

    if vehicleData.sirens.State > 0 then
        Citizen.Wait(200)

        SendNUIMessage({
            PayloadType	= "SirenSwitch"
        })

        TriggerServerEvent("oELS:toggleSirens", 0)

        return MainController.DebugPrint("Sent request to disable Sirens.")
    else
        TriggerServerEvent("oELS:toggleSirens", 1)

        return MainController.DebugPrint("Sent request to enable Sirens.")
    end
end

function KeyPressController.ChangeSirens()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if not configData.sirens or not configData.sirens.enabled or #configData.sirens.sounds == 0 then
        return MainController.DebugPrint("Vehicle has no sirens")
    end

    if not vehicleData.lightStates.Primary or vehicleData.sirens.State == 0 then
        return MainController.DebugPrint("Primary Lights & Sirens not Enabled")
    end

    SendNUIMessage({
        PayloadType	= "SirenSwitch"
    })

    newState = vehicleData.sirens.State + 1

    if newState > #configData.sirens.sounds then
        TriggerServerEvent("oELS:toggleSirens", 1)

        return MainController.DebugPrint("Sent request to change siren tone to 1")
    else
        TriggerServerEvent("oELS:toggleSirens", newState)

        return MainController.DebugPrint("Sent request to change siren tone to " .. newState)
    end
end

function KeyPressController.ToggleSecondSirens()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if not configData.dualSirens or not configData.dualSirens.enabled or #configData.dualSirens.sounds == 0 then
        return MainController.DebugPrint("Vehicle has no sirens")
    end

    if not vehicleData.lightStates.Primary.Enabled then
        return MainController.DebugPrint("Primary Lights not Enabled")
    end

    SendNUIMessage({
        PayloadType	= "SirenSwitch"
    })

    if vehicleData.dualSiren.State > 0 then
        Citizen.Wait(200)

        SendNUIMessage({
            PayloadType	= "SirenSwitch"
        })

        TriggerServerEvent("oELS:toggleSecondSirens", 0)

        return MainController.DebugPrint("Sent request to disable dualSiren.")
    else
        TriggerServerEvent("oELS:toggleSecondSirens", 1)

        return MainController.DebugPrint("Sent request to enable dualSiren.")
    end
end

function KeyPressController.ChangeSecondSirens()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if not configData.dualSirens or not configData.dualSirens.enabled or #configData.dualSirens.sounds == 0 then
        return MainController.DebugPrint("Vehicle has no sirens")
    end

    if not vehicleData.lightStates.Primary or vehicleData.dualSiren.State == 0 then
        return MainController.DebugPrint("Primary Lights & Sirens not Enabled")
    end

    SendNUIMessage({
        PayloadType	= "SirenSwitch"
    })

    newState = vehicleData.dualSiren.State + 1

    if newState > #configData.dualSirens.sounds then
        TriggerServerEvent("oELS:toggleSecondSirens", 1)

        return MainController.DebugPrint("Sent request to change siren tone to 1")
    else
        TriggerServerEvent("oELS:toggleSecondSirens", newState)

        return MainController.DebugPrint("Sent request to change siren tone to " .. newState)
    end
end

function KeyPressController.BullhornOn()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    TriggerServerEvent("oELS:toggleBullhorn", 1)

    return MainController.DebugPrint("Sent request to turn bullhorn on")
end

function KeyPressController.BullhornOff()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    TriggerServerEvent("oELS:toggleBullhorn", 0)

    return MainController.DebugPrint("Sent request to turn bullhorn off")
end

function KeyPressController.ToggleAlleyLeft()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if not configData.misc.alleyLight or not configData.misc.alleyLight.enabled then return MainController.DebugPrint("Vehicle does not have Alley Lights") end

    if vehicleData.lightStates.AlleyLights == 1 or vehicleData.lightStates.AlleyLights == 3 then
        TriggerServerEvent("oELS:toggleAlleyLights", vehicleData.lightStates.AlleyLights - 1)

        return MainController.DebugPrint("Sent request to turn left alley lights off")
    else
        TriggerServerEvent("oELS:toggleAlleyLights", vehicleData.lightStates.AlleyLights + 1)

        return MainController.DebugPrint("Sent request to turn left alley lights on")
    end
end

function KeyPressController.ToggleAlleyRight()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if not configData.misc.alleyLight or not configData.misc.alleyLight.enabled then return MainController.DebugPrint("Vehicle does not have Alley Lights") end

    if vehicleData.lightStates.AlleyLights == 2 or vehicleData.lightStates.AlleyLights == 3 then
        TriggerServerEvent("oELS:toggleAlleyLights", vehicleData.lightStates.AlleyLights - 2)

        return MainController.DebugPrint("Sent request to turn right alley lights off")
    else
        TriggerServerEvent("oELS:toggleAlleyLights", vehicleData.lightStates.AlleyLights + 2)

        return MainController.DebugPrint("Sent request to turn right alley lights on")
    end
end

function KeyPressController.ToggleIndicatorLeft()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if vehicleData.lightStates.Indicators == 1 then
        TriggerServerEvent("oELS:toggleIndicators", 0)

        return MainController.DebugPrint("Sent request to turn left indicator lights off")
    else
        TriggerServerEvent("oELS:toggleIndicators", 1)

        return MainController.DebugPrint("Sent request to turn left indicator lights on")
    end
end

function KeyPressController.ToggleIndicatorRight()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if vehicleData.lightStates.Indicators == 2 then
        TriggerServerEvent("oELS:toggleIndicators", 0)

        return MainController.DebugPrint("Sent request to turn right indicator lights off")
    else
        TriggerServerEvent("oELS:toggleIndicators", 2)

        return MainController.DebugPrint("Sent request to turn right indicator lights on")
    end
end

function KeyPressController.ToggleHazards()
    if not CurrentVehicleEnabled then return MainController.DebugPrint("Player is not in an ELS enabled vehicle.") end

    local vehicleData = MainController.GetVehicleDataUsingEntity(CurrentVehicleEnabled)
    local configData = StoredConfigs[GetEntityModel(CurrentVehicleEnabled)]

    if not configData then return MainController.DebugPrint("Unable to find the ELS config for current vehicle") end

    if vehicleData.lightStates.Indicators == 3 then
        TriggerServerEvent("oELS:toggleIndicators", 0)

        return MainController.DebugPrint("Sent request to turn hazard lights off")
    else
        TriggerServerEvent("oELS:toggleIndicators", 3)

        return MainController.DebugPrint("Sent request to turn hazard lights on")
    end
end

RegisterCommand("oELS_primaryLights", KeyPressController.TogglePrimary)
RegisterCommand("oELS_controller_primaryLights", KeyPressController.TogglePrimary)
RegisterKeyMapping('oELS_primaryLights', 'Primary Lights', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.PrimaryLights)
RegisterKeyMapping('oELS_controller_primaryLights', 'Controller - Primary Lights', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.PrimaryLights)

RegisterCommand("oELS_secondaryLights", KeyPressController.ToggleSecondary)
RegisterKeyMapping('oELS_secondaryLights', 'Secondary Lights', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.SecondaryLights)

RegisterCommand("oELS_warningLights", KeyPressController.ToggleWarning)
RegisterKeyMapping('oELS_warningLights', 'Warning Lights', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.WarningLights)

RegisterCommand("oELS_leftAlleyLight", KeyPressController.ToggleAlleyLeft)
RegisterKeyMapping('oELS_leftAlleyLight', 'Left Alley Light', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.LeftAlleyLight)

RegisterCommand("oELS_rightAlleyLight", KeyPressController.ToggleAlleyRight)
RegisterKeyMapping('oELS_rightAlleyLight', 'Right Alley Light', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.RightAlleyLight)

RegisterCommand("oELS_sirenToggle", KeyPressController.ToggleSirens)
RegisterCommand("oELS_controller_sirenToggle", KeyPressController.ToggleSirens)
RegisterKeyMapping('oELS_sirenToggle', 'Toggle Sirens', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.SirensToggle)
RegisterKeyMapping('oELS_controller_sirenToggle', 'Controller - Toggle Sirens', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.SirensToggle)

RegisterCommand("oELS_sirenSwitch", KeyPressController.ChangeSirens)
RegisterCommand("oELS_controller_sirenSwitch", KeyPressController.ChangeSirens)
RegisterKeyMapping('oELS_sirenSwitch', 'Switch Sirens', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.SirensSwitch)
RegisterKeyMapping('oELS_controller_sirenSwitch', 'Controller - Switch Sirens', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.SirensSwitch)

RegisterCommand("oELS_secondSirenToggle", KeyPressController.ToggleSecondSirens)
RegisterCommand("oELS_controller_secondSirenToggle", KeyPressController.ToggleSecondSirens)
RegisterKeyMapping('oELS_secondSirenToggle', 'Toggle Second Sirens', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.SecondSirenToggle)
RegisterKeyMapping('oELS_controller_secondSirenToggle', 'Controller - Toggle Second Sirens', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.SecondSirenToggle)

RegisterCommand("oELS_secondSirenSwitch", KeyPressController.ChangeSecondSirens)
RegisterCommand("oELS_controller_secondSirenSwitch", KeyPressController.ChangeSecondSirens)
RegisterKeyMapping('oELS_secondSirenSwitch', 'Switch Second Sirens', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.SecondSirenSwitch)
RegisterKeyMapping('oELS_controller_secondSirenSwitch', 'Controller - Switch Second Sirens', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.SecondSirenSwitch)

RegisterCommand("+oELS_bullhorn", KeyPressController.BullhornOn)
RegisterCommand("+oELS_controller_bullhorn", KeyPressController.BullhornOn)
RegisterCommand("-oELS_bullhorn", KeyPressController.BullhornOff)
RegisterCommand("-oELS_controller_bullhorn", KeyPressController.BullhornOff)
RegisterKeyMapping('+oELS_bullhorn', 'Bullhorn', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.Bullhorn)
RegisterKeyMapping('+oELS_controller_bullhorn', 'Controller - Bullhorn', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.Bullhorn)

RegisterCommand("oELS_indicatorLeft", KeyPressController.ToggleIndicatorLeft)
RegisterCommand("oELS_controller_indicatorLeft", KeyPressController.ToggleIndicatorLeft)
RegisterKeyMapping('oELS_indicatorLeft', 'Left Indicator', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.IndicatorsLeft)
RegisterKeyMapping('oELS_controller_indicatorLeft', 'Controller - Left Indicator', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.IndicatorsLeft)

RegisterCommand("oELS_indicatorRight", KeyPressController.ToggleIndicatorRight)
RegisterCommand("oELS_controller_indicatorRight", KeyPressController.ToggleIndicatorRight)
RegisterKeyMapping('oELS_indicatorRight', 'Right Indicator', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.IndicatorsRight)
RegisterKeyMapping('oELS_controller_indicatorRight', 'Controller - Right Indicator', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.IndicatorsRight)

RegisterCommand("oELS_hazards", KeyPressController.ToggleHazards)
RegisterCommand("oELS_controller_hazards", KeyPressController.ToggleHazards)
RegisterKeyMapping('oELS_hazards', 'Hazards', 'KEYBOARD', Config.DefaultKeybinds.Keyboard.Hazards)
RegisterKeyMapping('oELS_controller_hazards', 'Controller - Hazards', 'PAD_ANALOGBUTTON', Config.DefaultKeybinds.Controller.Hazards)
