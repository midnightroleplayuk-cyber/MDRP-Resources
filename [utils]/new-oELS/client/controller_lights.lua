LightsController = {}

RegisterNetEvent("oELS:toggleLights")

AddEventHandler("oELS:toggleLights", function(player, vehicle, lights, state)
    MainController.DebugPrint("[ToggleLights] Request from " .. player .. " to change " .. lights .. " to " .. tostring(state))

    vehicleData = MainController.GetVehicleData(vehicle)

    vehicleData.lightStates[lights].Enabled = state

    if lights == 'Primary' then
        if not state and vehicleData.lightStates.WigWags.Enabled then
            vehicleData.lightStates.WigWags.Enabled = false
        end

        if vehicleData.entity then
            SetVehicleSiren(vehicleData.entity, state)
        end
    end

    if not state then
        LightsController.DisableCurrentLightingStage(vehicleData, lights)
    else
        vehicleData.lightStates[lights].CurrentStage = 1
    end
end)

RegisterNetEvent("oELS:toggleAlleyLights")

AddEventHandler("oELS:toggleAlleyLights", function(player, vehicle, state)
    MainController.DebugPrint("[toggleAlleyLights] Request from " .. player .. " to change alley lights to " .. tostring(state))

    vehicleData = MainController.GetVehicleData(vehicle)
    vehicleData.lightStates.AlleyLights = state
    LightsController.AlleyLights(vehicleData)
end)

RegisterNetEvent("oELS:toggleIndicators")

AddEventHandler("oELS:toggleIndicators", function(player, vehicle, state)
    MainController.DebugPrint("[toggleIndicators] Request from " .. player .. " to change indicators to " .. tostring(state))

    vehicleData = MainController.GetVehicleData(vehicle)

    vehicleData.lightStates.Indicators = state

    LightsController.Indicators(vehicleData)
end)

function LightsController.Indicators(vehicleData)
    if MainController.isVehicleNonELS(vehicleData.entity) then
        return
    end

    if vehicleData.lightStates.Indicators == 3 then
        SetVehicleIndicatorLights(vehicleData.entity, 0, true)
        SetVehicleIndicatorLights(vehicleData.entity, 1, true)
    elseif vehicleData.lightStates.Indicators == 2 then
        SetVehicleIndicatorLights(vehicleData.entity, 0, true)
        SetVehicleIndicatorLights(vehicleData.entity, 1, false)
    elseif vehicleData.lightStates.Indicators == 1 then
        SetVehicleIndicatorLights(vehicleData.entity, 0, false)
        SetVehicleIndicatorLights(vehicleData.entity, 1, true)
    else
        SetVehicleIndicatorLights(vehicleData.entity, 0, false)
        SetVehicleIndicatorLights(vehicleData.entity, 1, false)
    end
end

function LightsController.CleanupVehicle(vehicleData)
    if not vehicleData.entity then return end
    local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]
    if not elsData then return end

    SetVehicleSiren(vehicleData.entity, false)

    for attempt = 1, 2 do
        for extra = 1, 12 do
            if elsData.extraControls and elsData.extraControls["extra" .. extra] and elsData.extraControls["extra" .. extra].enabled then
                SetVehicleExtra(vehicleData.entity, extra, true)
            end
        end
    end
end

function LightsController.AlleyLights(vehicleData)
    if not vehicleData.elsData then
        local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]
        if not elsData then return end
        SavedVehicles[vehicleData.networkedId].elsData = elsData

        vehicleData = SavedVehicles[vehicleData.networkedId]
    end

    if vehicleData.lightStates.AlleyLights == 0 then
        if vehicleData.elsData.misc.alleyLight.leftExtra and vehicleData.elsData.misc.alleyLight.leftExtra ~= "" then
            SetVehicleExtra(vehicleData.entity, tonumber(vehicleData.elsData.misc.alleyLight.leftExtra), true)
        end

        if vehicleData.elsData.misc.alleyLight.rightExtra and vehicleData.elsData.misc.alleyLight.rightExtra ~= "" then
            SetVehicleExtra(vehicleData.entity, tonumber(vehicleData.elsData.misc.alleyLight.rightExtra), true)
        end
    else
        if vehicleData.lightStates.AlleyLights == 1 or vehicleData.lightStates.AlleyLights == 3 then
            if vehicleData.elsData.misc.alleyLight.leftExtra and vehicleData.elsData.misc.alleyLight.leftExtra ~= "" then
                SetVehicleExtra(vehicleData.entity, tonumber(vehicleData.elsData.misc.alleyLight.leftExtra), false)
            end
        end

        if vehicleData.lightStates.AlleyLights == 2 or vehicleData.lightStates.AlleyLights == 3 then
            if vehicleData.elsData.misc.alleyLight.rightExtra and vehicleData.elsData.misc.alleyLight.rightExtra ~= "" then
                SetVehicleExtra(vehicleData.entity, tonumber(vehicleData.elsData.misc.alleyLight.rightExtra), false)
            end
        end
    end
end

function LightsController.EnvLighting(vehicleData, extras)
    if not vehicleData.entity then
        MainController.DebugPrint("[EnvLighting] Ending Env Lights due to entity not existing for " .. vehicleData.networkedId)
        return
    end

    local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]

    if not elsData then
        MainController.DebugPrint("[EnvLighting] Ending Env Lights due to not being able to find ELS data for " .. vehicleData.networkedId)
        return
    end

    if not elsData.extraControls then
        MainController.DebugPrint("[EnvLighting] Ending Env Lights due to malformed ELS data for " .. vehicleData.networkedId)
        return
    end

    for _, extra in pairs(extras) do
        if DoesExtraExist(vehicleData.entity, extra) and IsVehicleExtraTurnedOn(vehicleData.entity, extra) then
            if elsData.extraControls["extra" .. extra] and elsData.extraControls["extra" .. extra].enabled and elsData.extraControls["extra" .. extra].allowEnvLight then
                extaOptions = elsData.extraControls["extra" .. extra]
                local entityBone = GetEntityBoneIndexByName(vehicleData.entity, "extra_" .. extra)

                if extaOptions.directions then
                    for _, direction in pairs(extaOptions.directions) do
                        if direction == "front" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, 0.0, 1.0, 0.0, extaOptions.colour)
                        elseif direction == "frontRight" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, 1.0, 1.0, 0.0, extaOptions.colour)
                        elseif direction == "right" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, 5.0, 1.0, 0.0, extaOptions.colour)
                        elseif direction == "backRight" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, 1.0, -1.0, 0.0, extaOptions.colour)
                        elseif direction == "back" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, 0.0, -1.0, 0.0, extaOptions.colour)
                        elseif direction == "backLeft" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, -1.0, -1.0, 0.0, extaOptions.colour)
                        elseif direction == "left" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, -5.0, -1.0, 0.0, extaOptions.colour)
                        elseif direction == "frontLeft" then
                            CreateEnviromentLight(vehicleData.entity, entityBone, extaOptions.offset.offSetX, extaOptions.offset.offSetY, extaOptions.offset.offSetZ, -1.0, 1.0, 0.0, extaOptions.colour)
                        end
                    end
                end
            end
        end
    end
end

function CreateEnviromentLight(vehicle, entityBone, offsetX, offsetY, offsetZ, rotateX, rotateY, rotateZ, rawColour, radius)
    local radius = radius or 45.0
    local colour = string.lower(rawColour)

    local entityCoords = GetEntityCoords(vehicle)
    local coords = GetWorldPositionOfEntityBone(vehicle, entityBone)
    local offset = GetOffsetFromEntityInWorldCoords(vehicle, tonumber(rotateX), tonumber(rotateY), tonumber(rotateZ))
    local sometelse = offset - entityCoords
    local somethingelse = norm(sometelse)

    local pos = GetOffsetFromEntityGivenWorldCoords(vehicle, coords + vector3(tonumber(offsetX), tonumber(offsetY), tonumber(offsetZ)))
    local rotX, rotY, rotZ = table.unpack(GetWorldRotationOfEntityBone(vehicle, entityBone))

    if colour == 'blue' then
        DrawSpotLight(coords.x, coords.y, coords.z, somethingelse, 0, 0, 255, 60.0, 1.0, 0.0, radius, 100.0) -- Blue Lights
    elseif colour == 'red' then
        DrawSpotLight(coords.x, coords.y, coords.z, somethingelse, 255, 0, 0, 60.0, 1.0, 0.0, radius, 100.0) -- Red Lights
    elseif colour == 'green' then
        DrawSpotLight(coords.x, coords.y, coords.z, somethingelse, 0, 255, 0, 60.0, 1.0, 0.0, radius, 100.0) -- Green Lights
    elseif colour == 'white' then
        DrawSpotLight(coords.x, coords.y, coords.z, somethingelse, 255, 255, 255, 60.0, 1.0, 0.0, radius, 100.0) -- White Lights
    elseif colour == 'amber' then
        DrawSpotLight(coords.x, coords.y, coords.z, somethingelse, 255, 194, 0, 60.0, 1.0, 0.0, radius, 100.0) -- Amber Lights
    end
end

function RotAnglesToVec(rot) -- input vector3
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local lazyWigWagTable = {"headlight_l", "headlight_l", "headlight_r", "headlight_r"}

function LightsController.ProcessLights()
    for netId, _ in pairs(EnabledVehicles) do
        local vehicleData = SavedVehicles[netId]

        if not vehicleData or not vehicleData.entity or not IsEntityAVehicle(vehicleData.entity) then return end

        SetVehicleAutoRepairDisabled(vehicleData.entity, true)
		SetVehicleHasMutedSirens(vehicleData.entity, true)

        if not MainController.isVehicleNonELS(vehicleData.entity) then
            if not SavedVehicles[netId].elsData then
                local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]
                if not elsData then return end
                SavedVehicles[netId].elsData = elsData

                vehicleData = SavedVehicles[netId]
            end

            local patternEnabled = false

            for lightingType, lightingData in pairs(vehicleData.lightStates) do
                if lightingType ~= 'WigWags' and lightingType ~= 'AlleyLights' and lightingType ~= 'Indicators' and lightingData.Enabled then
                    patternEnabled = true
                    local CurrentPatternConfig = Config[lightingType .. "Patterns"][vehicleData.elsData.lightSetup.lightPattern];
                    if not CurrentPatternConfig then return end
                    local CurrentPatternStage = CurrentPatternConfig[vehicleData.lightStates[lightingType].CurrentStage]

                    if CurrentGameTime - vehicleData.lightStates[lightingType].LastUpdated > CurrentPatternStage[2] then
                        vehicleData.lightStates[lightingType].CurrentStage = vehicleData.lightStates[lightingType].CurrentStage + 1

                        if vehicleData.lightStates[lightingType].CurrentStage > #CurrentPatternConfig then
                            vehicleData.lightStates[lightingType].CurrentStage = 1
                        end

                        local NewPatternStage = CurrentPatternConfig[vehicleData.lightStates[lightingType].CurrentStage]

                        vehicleData.lightStates[lightingType].LastUpdated = CurrentGameTime

                        if lightingType == 'Primary' then
                            if vehicleData.elsData.misc.steadyBurns and vehicleData.elsData.misc.steadyBurns.enabled then
                                for _, extra in pairs(vehicleData.elsData.misc.steadyBurns.extras) do
                                    table.insert(NewPatternStage[1], extra)
                                end
                            end

                            if vehicleData.elsData.misc.wigWags ~= nil then
                                if vehicleData.elsData.misc.wigWags and not vehicleData.lightStates.WigWags.Enabled then
                                    vehicleData.lightStates.WigWags.Enabled = true
                                end
                            elseif Config.WigWags then
                                if not vehicleData.lightStates.WigWags.Enabled then
                                    vehicleData.lightStates.WigWags.Enabled = true
                                end
                            end
                        end

                        LightsController.SwapVehicleStage(vehicleData, CurrentPatternStage[1], NewPatternStage[1])

                        CurrentPatternStage = NewPatternStage
                    end

                    local patternExtras = CurrentPatternStage[1]

                    LightsController.EnvLighting(vehicleData, patternExtras)
                end
            end

            if patternEnabled then
                SetVehicleEngineOn(vehicleData.entity, true, true, false)

                if vehicleData.bullhorn.State == 1 then
                    SetVehicleSiren(vehicleData.entity, false)
                elseif not IsVehicleSirenOn(vehicleData.entity) then
                    SetVehicleSiren(vehicleData.entity, true)
                end
            elseif IsVehicleSirenOn(vehicleData.entity) then
                SetVehicleSiren(vehicleData.entity, false)
            end

            if vehicleData.lightStates.WigWags.Enabled then
                local wigWagData = vehicleData.lightStates.WigWags

                if CurrentGameTime - wigWagData.LastUpdated > 10 then
                    if (wigWagData.CurrentStage == 1 or wigWagData.CurrentStage == 3) and wigWagData.CurrentBrightness >= 36.0 then
                        wigWagData.CurrentStage = wigWagData.CurrentStage + 1
                    elseif (wigWagData.CurrentStage == 2 or wigWagData.CurrentStage == 4) and wigWagData.CurrentBrightness <= 0.0 then
                        wigWagData.CurrentStage = wigWagData.CurrentStage + 1
                    end

                    if wigWagData.CurrentStage > 4 then
                        wigWagData.CurrentStage = 1
                    end

                    if wigWagData.CurrentStage == 1 or wigWagData.CurrentStage == 3 then
                        wigWagData.CurrentBrightness = wigWagData.CurrentBrightness + 2.0
                    else
                        wigWagData.CurrentBrightness = wigWagData.CurrentBrightness - 2.0
                    end

                    wigWagData.LastUpdated = CurrentGameTime
                end

                local entityBone = GetEntityBoneIndexByName(vehicleData.entity, lazyWigWagTable[wigWagData.CurrentStage])
                local coords = GetWorldPositionOfEntityBone(vehicleData.entity, entityBone)
                local rotX, rotY, rotZ = table.unpack(RotAnglesToVec(GetEntityRotation(vehicleData.entity, 2)))

                DrawSpotLight(coords, rotX, rotY, rotZ, 255, 255, 255, 20.0, wigWagData.CurrentBrightness, 0.0, 45.0, 100.0)
            end

            if vehicleData.lightStates.AlleyLights == 1 or vehicleData.lightStates.AlleyLights == 3 then
                local targetBone = "door_dside_f"
                local offset = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.5
                }

                if vehicleData.elsData.misc.alleyLight.leftExtra and vehicleData.elsData.misc.alleyLight.leftExtra ~= "" then
                    targetBone = "extra_" .. vehicleData.elsData.misc.alleyLight.leftExtra
                    extaOptions = vehicleData.elsData.extraControls["extra" .. vehicleData.elsData.misc.alleyLight.leftExtra]

                    offset = {
                        x = extaOptions.offset.offSetX,
                        y = extaOptions.offset.offSetZ,
                        z = extaOptions.offset.offSetZ
                    }
                end

                local entityBone = GetEntityBoneIndexByName(vehicleData.entity, targetBone)

                CreateEnviromentLight(vehicleData.entity, entityBone, offset.x, offset.y, offset.z, -5.0, -1.0, 0.0, "white", 20.0)
            end

            if vehicleData.lightStates.AlleyLights == 2 or vehicleData.lightStates.AlleyLights == 3 then
                local targetBone = "door_pside_f"
                local offset = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.5
                }

                if vehicleData.elsData.misc.alleyLight.rightExtra and vehicleData.elsData.misc.alleyLight.rightExtra ~= "" then
                    targetBone = "extra_" .. vehicleData.elsData.misc.alleyLight.rightExtra
                    extaOptions = vehicleData.elsData.extraControls["extra" .. vehicleData.elsData.misc.alleyLight.rightExtra]

                    offset = {
                        x = extaOptions.offset.offSetX,
                        y = extaOptions.offset.offSetZ,
                        z = extaOptions.offset.offSetZ
                    }
                end

                local entityBone = GetEntityBoneIndexByName(vehicleData.entity, targetBone)

                CreateEnviromentLight(vehicleData.entity, entityBone, offset.x, offset.y, offset.z, 5.0, 1.0, 0.0, "white", 20.0)
            end
        else
            if not SavedVehicles[netId].elsData then
                local elsData = Config.NonELS[GetEntityModel(vehicleData.entity)]
                if not elsData then return end
                SavedVehicles[netId].elsData = elsData

                vehicleData = SavedVehicles[netId]
            end

            unusedExtras = {}
            usedExtras = {}
            usedExtrasCatch = {}

            for lightingType, lightingData in pairs(vehicleData.lightStates) do
                if lightingType ~= 'WigWags' and lightingType ~= 'AlleyLights' and lightingType ~= 'Indicators' then
                    for _, extra in pairs(vehicleData.elsData[lightingType .. 'Lights']) do
                        if lightingData.Enabled then
                            table.insert(usedExtras, extra)
                            usedExtrasCatch[extra] = true
                        else
                            table.insert(unusedExtras, extra)
                        end
                    end
                end
            end

            finalUnused = {}

            for _, extra in pairs(unusedExtras) do
                if not usedExtrasCatch[extra] then
                    table.insert(finalUnused, extra)
                end
            end

            if #usedExtras > 0 then
                if not IsVehicleSirenOn(vehicleData.entity) then
                    SetVehicleSiren(vehicleData.entity, true)
                elseif vehicleData.bullhorn.State == 1 then
                    SetVehicleSiren(vehicleData.entity, false)
                end
            else
                SetVehicleSiren(vehicleData.entity, false)
            end

            LightsController.SwapVehicleStage(vehicleData, finalUnused, usedExtras)
        end
    end
end

function LightsController.SwapVehicleStage(vehicleData, originalStage, newStage)
    for _, extra in pairs(originalStage) do
        SetVehicleExtra(vehicleData.entity, extra, true)
    end

    for _, extra in pairs(newStage) do
        SetVehicleExtra(vehicleData.entity, extra, false)
    end
end

function LightsController.DisableCurrentLightingStage(vehicleData, lightType)
    if not vehicleData.entity or not vehicleData.elsData then return end
    if MainController.isVehicleNonELS(vehicleData.entity) then return end

    local CurrentPatternConfig = Config[lightType .. "Patterns"][vehicleData.elsData.lightSetup.lightPattern];
    if not CurrentPatternConfig then return end
    local CurrentPatternStage = CurrentPatternConfig[vehicleData.lightStates[lightType].CurrentStage]

    LightsController.SwapVehicleStage(vehicleData, CurrentPatternStage[1], {})
end
