local MS = MissionShared

local isConvoyMission = false
local convoyVehicles = {}
local convoyDrivers = {}
local convoyPassengers = {}
local convoyTargetVehicle = nil
local convoyTargetNetId = nil
local convoyTargetPlate = nil
local convoyBlip = nil
local convoyDeliverBlip = nil
local convoyDeliverMark = nil
local convoyInCombat = false

local convoySpawnCoords = {
    vec4(1382.5742, -2077.0508, 52.0120, 45.2716),
    vec4(224.0515, -3008.9995, 5.7902, 271.1544),
    vec4(-456.7197, -2786.4014, 6.0004, 135.2986),
}

local convoyDeliverCoords = {
    vec4(-1119.11, 4918.06, 217.14, 358),
    vec4(1322.44, 4327.23, 37.18, 344),
    vec4(2709.39, 3452.32, 54.54, 153),
}

local function alertConvoyUnits(playerPed)
    for _, ped in ipairs(convoyDrivers) do
        if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
            MS.taskAggressiveAgainstPlayers(ped, playerPed)
        end
    end

    for _, ped in ipairs(convoyPassengers) do
        if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
            MS.taskAggressiveAgainstPlayers(ped, playerPed)
        end
    end
end

local function startConvoyTrackingBlip()
    if convoyBlip then
        RemoveBlip(convoyBlip)
        convoyBlip = nil
    end
    if not DoesEntityExist(convoyTargetVehicle) then return end

    local startCoords = GetEntityCoords(convoyTargetVehicle)
    convoyBlip = AddBlipForCoord(startCoords.x, startCoords.y, startCoords.z)
    SetBlipSprite(convoyBlip, 67)
    SetBlipColour(convoyBlip, 1)
    SetBlipScale(convoyBlip, 0.95)
    SetBlipAsShortRange(convoyBlip, false)
    SetBlipRoute(convoyBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TranslateIt('mission_convoy_target_blip'))
    EndTextCommandSetBlipName(convoyBlip)

    Citizen.CreateThread(function()
        while isConvoyMission and convoyBlip and DoesEntityExist(convoyTargetVehicle) do
            local coords = GetEntityCoords(convoyTargetVehicle)
            SetBlipCoords(convoyBlip, coords.x, coords.y, coords.z)
            Wait(5000)
        end
    end)
end

local function clearConvoyMissionState()
    if convoyBlip then RemoveBlip(convoyBlip) end
    if convoyDeliverBlip then RemoveBlip(convoyDeliverBlip) end
    if convoyDeliverMark then SH.RemoveMarkedCoords(convoyDeliverMark) end

    convoyBlip = nil
    convoyDeliverBlip = nil
    convoyDeliverMark = nil
    convoyTargetVehicle = nil
    convoyTargetNetId = nil
    convoyTargetPlate = nil
    convoyInCombat = false

    for i = #convoyDrivers, 1, -1 do
        local ped = convoyDrivers[i]
        if DoesEntityExist(ped) then DeletePed(ped) end
        convoyDrivers[i] = nil
    end

    for i = #convoyPassengers, 1, -1 do
        local ped = convoyPassengers[i]
        if DoesEntityExist(ped) then DeletePed(ped) end
        convoyPassengers[i] = nil
    end

    for _, veh in ipairs(convoyVehicles) do
        if DoesEntityExist(veh) then
            Fr.DeleteVehicle(veh)
        end
    end

    convoyVehicles = {}
    isConvoyMission = false
end

local function finishConvoyMission()
    local playerPed = PlayerPedId()
    local playerVehicle = MS.findNearbyMissionVehicle(playerPed, convoyTargetVehicle, convoyTargetNetId, convoyTargetPlate, "rumpo3", 20.0)

    if not MS.vehicleMatchesMission(playerVehicle, convoyTargetVehicle, convoyTargetNetId, convoyTargetPlate, "rumpo3") then
        sendNotify(TranslateIt('mission_convoy_wrong_vehicle'), "error", 7)
        return
    end

    clearConvoyMissionState()
    sendNotify(TranslateIt('mission_convoy_completed'), "success", 8)
    TriggerServerEvent('op-crime:endMission', "intercept_convoy")
end

function startConvoyInterceptMission()
    if isConvoyMission then return end

    lib.alertDialog({
        header = TranslateIt('mission_convoy_alert_header'),
        content = TranslateIt('mission_convoy_alert_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('mission_generic_understood') }
    })

    isConvoyMission = true
    MS.createRelationshipGroup()

    local spawn = convoySpawnCoords[math.random(1, #convoySpawnCoords)]
    convoyBlip = SH.addBlip(spawn.xyz, 67, 1, TranslateIt('mission_convoy_route_blip'))
    SetBlipAsShortRange(convoyBlip, false)
    SetNewWaypoint(spawn.x, spawn.y)

    Citizen.CreateThread(function()
        while isConvoyMission do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - spawn.xyz) < 220.0 then
                break
            end
            Wait(300)
        end
        if not isConvoyMission then return end

        local models = { "granger", "rumpo3", "baller4" }
        local convoyPedModels = { "s_m_y_blackops_01", "s_m_y_blackops_02" }
        for _, pedModel in ipairs(convoyPedModels) do
            if not MS.loadModel(pedModel) then
                sendNotify(TranslateIt('mission_convoy_load_error'), "error", 8)
                clearConvoyMissionState()
                return
            end
        end

        for i = 1, #models do
            local thisModel = models[i]
            local offset = (i - 2) * 9.0
            local x = spawn.x + math.cos(math.rad(spawn.w + 90.0)) * offset
            local y = spawn.y + math.sin(math.rad(spawn.w + 90.0)) * offset
            local z = MS.groundZ(x, y, spawn.z)

            Fr.SpawnVehicle(thisModel, vec3(x, y, z), spawn.w, true, function(vehicle)
                table.insert(convoyVehicles, vehicle)
                SetVehicleOnGroundProperly(vehicle)
                SetVehicleEngineOn(vehicle, true, true, false)

                local driver = CreatePedInsideVehicle(vehicle, 4, joaat(convoyPedModels[1]), -1, true, true)
                if DoesEntityExist(driver) then
                    table.insert(convoyDrivers, driver)
                    MS.setGuardCombatStats(driver)
                    MS.giveGuardWeapon(driver)
                    SetBlockingOfNonTemporaryEvents(driver, true)
                    SetDriverAbility(driver, 1.0)
                    SetDriverAggressiveness(driver, 0.9)
                    TaskVehicleDriveWander(driver, vehicle, 26.0, 786603)
                    SetPedKeepTask(driver, true)
                end

                local passenger = CreatePedInsideVehicle(vehicle, 4, joaat(convoyPedModels[2]), 0, true, true)
                if DoesEntityExist(passenger) then
                    table.insert(convoyPassengers, passenger)
                    MS.setGuardCombatStats(passenger)
                    MS.giveGuardWeapon(passenger)
                    SetBlockingOfNonTemporaryEvents(passenger, true)
                end

                if thisModel == "rumpo3" then
                    convoyTargetVehicle = vehicle
                    convoyTargetNetId = VehToNet(vehicle)
                    convoyTargetPlate = MS.normalizePlate(GetVehicleNumberPlateText(vehicle))
                    startConvoyTrackingBlip()
                end
            end)
            Wait(100)
        end

        for _, pedModel in ipairs(convoyPedModels) do
            MS.unloadModel(pedModel)
        end

        Citizen.CreateThread(function()
            while isConvoyMission do
                for idx, vehicle in ipairs(convoyVehicles) do
                    if DoesEntityExist(vehicle) then
                        local driver = convoyDrivers[idx]
                        if DoesEntityExist(driver) and not IsPedDeadOrDying(driver, true) then
                            if IsVehicleStopped(vehicle) then
                                TaskVehicleDriveWander(driver, vehicle, 26.0, 786603)
                            end
                        end
                    end
                end
                Wait(3000)
            end
        end)

        Citizen.CreateThread(function()
            while isConvoyMission do
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local spotted = false

                for _, ped in ipairs(convoyDrivers) do
                    if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                        local pedCoords = GetEntityCoords(ped)
                        local distance = #(playerCoords - pedCoords)
                        if (distance <= 70.0 and HasEntityClearLosToEntity(ped, playerPed, 17)) or (distance <= 110.0 and IsPedShooting(playerPed)) then
                            spotted = true
                            break
                        end
                    end
                end

                if not spotted then
                    for _, ped in ipairs(convoyPassengers) do
                        if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                            local pedCoords = GetEntityCoords(ped)
                            local distance = #(playerCoords - pedCoords)
                            if (distance <= 70.0 and HasEntityClearLosToEntity(ped, playerPed, 17)) or (distance <= 110.0 and IsPedShooting(playerPed)) then
                                spotted = true
                                break
                            end
                        end
                    end
                end

                if spotted then
                    convoyInCombat = true
                end

                if convoyInCombat then
                    alertConvoyUnits(playerPed)
                end

                Wait(convoyInCombat and 1500 or 500)
            end
        end)

        Citizen.CreateThread(function()
            while isConvoyMission do
                local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if MS.vehicleMatchesMission(playerVehicle, convoyTargetVehicle, convoyTargetNetId, convoyTargetPlate, "rumpo3") then
                    if convoyBlip then RemoveBlip(convoyBlip) end
                    convoyBlip = nil

                    local deliver = convoyDeliverCoords[math.random(1, #convoyDeliverCoords)]
                    convoyDeliverBlip = SH.addBlip(deliver.xyz, 280, 2, TranslateIt('mission_convoy_deliver_blip'))
                    SetBlipAsShortRange(convoyDeliverBlip, false)
                    SetNewWaypoint(deliver.x, deliver.y)

                    local ped = {
                        heading = deliver.w,
                        model = "g_m_importexport_01",
                        gender = "male",
                    }

                    convoyDeliverMark = SH.MarkNewCoords(deliver, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
                    end, function()
                        finishConvoyMission()
                    end, {
                        name = "mission_convoy_deliver",
                        label = TranslateIt('mission_convoy_deliver_label'),
                        icon = "fa-solid fa-truck-fast"
                    })

                    sendNotify(TranslateIt('mission_convoy_target_captured'), "info", 8)
                    break
                end
                Wait(500)
            end
        end)
    end)
end

