local MS = MissionShared

local isArmoredHeistMission = false
local armoredTruckVeh = nil
local armoredTruckVehNetId = nil
local armoredTruckPlate = nil
local armoredPickupBlip = nil
local armoredBreachBlip = nil
local armoredDeliverBlip = nil
local armoredBreachMark = nil
local armoredDeliverMark = nil
local missionPeds = {}

local armoredTruckSpawnCoords = {
    vec4(1112.44, 248.96, 79.86, 54),
    vec4(997.20, -1954.35, 29.82, 355),
    vec4(-2043.10, -270.37, 22.39, 53),
}

local armoredTruckBreachCoords = {
    vec4(856.82, -1351.14, 25.07, 90),
    vec4(484.37, -1312.99, 28.21, 298),
    vec4(-1167.71, -2034.22, 12.32, 133),
}

local armoredTruckDeliverCoords = {
    vec4(1732.5676, 3308.6841, 40.2235, 190.0192),
    vec4(-445.78, 6147.38, 31.48, 229),
    vec4(2550.8540, 4669.7749, 33.0768, 309.0888),
}

local function clearArmoredMissionPeds()
    for i = #missionPeds, 1, -1 do
        local ped = missionPeds[i]
        if DoesEntityExist(ped) then DeletePed(ped) end
        missionPeds[i] = nil
    end
end

local function clearArmoredMissionState()
    if armoredPickupBlip then RemoveBlip(armoredPickupBlip) end
    if armoredBreachBlip then RemoveBlip(armoredBreachBlip) end
    if armoredDeliverBlip then RemoveBlip(armoredDeliverBlip) end
    if armoredBreachMark then SH.RemoveMarkedCoords(armoredBreachMark) end
    if armoredDeliverMark then SH.RemoveMarkedCoords(armoredDeliverMark) end

    armoredPickupBlip = nil
    armoredBreachBlip = nil
    armoredDeliverBlip = nil
    armoredBreachMark = nil
    armoredDeliverMark = nil
    armoredTruckVeh = nil
    armoredTruckVehNetId = nil
    armoredTruckPlate = nil
    isArmoredHeistMission = false
    clearArmoredMissionPeds()
end

local function finishArmoredTruckMission()
    local playerPed = PlayerPedId()
    local playerVehicle = MS.findNearbyMissionVehicle(playerPed, armoredTruckVeh, armoredTruckVehNetId, armoredTruckPlate, "stockade", 25.0)

    if not MS.vehicleMatchesMission(playerVehicle, armoredTruckVeh, armoredTruckVehNetId, armoredTruckPlate, "stockade") then
        sendNotify(TranslateIt('mission_armored_wrong_vehicle_end'), "error", 7)
        return
    end

    Fr.DeleteVehicle(armoredTruckVeh)
    clearArmoredMissionState()
    sendNotify(TranslateIt('mission_armored_completed'), "success", 8)
    TriggerServerEvent('op-crime:endMission', "armored_truck_heist")
end

local function startArmoredTruckBreach()
    local playerPed = PlayerPedId()
    local playerVehicle = MS.findNearbyMissionVehicle(playerPed, armoredTruckVeh, armoredTruckVehNetId, armoredTruckPlate, "stockade", 25.0)

    if not MS.vehicleMatchesMission(playerVehicle, armoredTruckVeh, armoredTruckVehNetId, armoredTruckPlate, "stockade") then
        sendNotify(TranslateIt('mission_armored_wrong_vehicle_breach'), "error", 7)
        return
    end

    local success = lib.progressCircle({
        duration = 12000,
        position = 'bottom',
        label = TranslateIt('mission_armored_breach_progress'),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true }
    })

    if not success then
        sendNotify(TranslateIt('mission_armored_breach_cancelled'), "error", 6)
        return
    end

    if armoredBreachMark then SH.RemoveMarkedCoords(armoredBreachMark) end
    if armoredBreachBlip then RemoveBlip(armoredBreachBlip) end
    armoredBreachMark = nil
    armoredBreachBlip = nil

    local deliverCoords = armoredTruckDeliverCoords[math.random(1, #armoredTruckDeliverCoords)]
    armoredDeliverBlip = SH.addBlip(deliverCoords.xyz, 478, 2, TranslateIt('mission_armored_deliver_blip'))
    SetBlipAsShortRange(armoredDeliverBlip, false)
    SetNewWaypoint(deliverCoords.x, deliverCoords.y)

    local ped = {
        heading = deliverCoords.w,
        model = "g_m_m_armboss_01",
        gender = "male",
    }

    armoredDeliverMark = SH.MarkNewCoords(deliverCoords, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
    end, function()
        finishArmoredTruckMission()
    end, {
        name = "mission_armored_truck_deliver",
        label = TranslateIt('mission_armored_deliver_label'),
        icon = "fa-solid fa-truck-ramp-box"
    })

    sendNotify(TranslateIt('mission_armored_opened_info'), "info", 8)
end

function startArmoredTruckHeistMission()
    if isArmoredHeistMission then return end

    lib.alertDialog({
        header = TranslateIt('mission_armored_alert_header'),
        content = TranslateIt('mission_armored_alert_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('mission_generic_understood') }
    })

    isArmoredHeistMission = true
    MS.createRelationshipGroup()

    local spawnCoords = armoredTruckSpawnCoords[math.random(1, #armoredTruckSpawnCoords)]
    local breachCoords = armoredTruckBreachCoords[math.random(1, #armoredTruckBreachCoords)]

    armoredPickupBlip = SH.addBlip(spawnCoords.xyz, 477, 1, TranslateIt('mission_armored_pickup_blip'))
    SetBlipAsShortRange(armoredPickupBlip, false)
    SetNewWaypoint(spawnCoords.x, spawnCoords.y)

    Citizen.CreateThread(function()
        while isArmoredHeistMission do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - spawnCoords.xyz) < 170.0 then
                break
            end
            Wait(250)
        end

        if not isArmoredHeistMission then return end

        Fr.SpawnVehicle("stockade", spawnCoords.xyz, spawnCoords.w, true, function(vehicle)
            if not isArmoredHeistMission then
                if DoesEntityExist(vehicle) then Fr.DeleteVehicle(vehicle) end
                return
            end

            if not DoesEntityExist(vehicle) then
                sendNotify(TranslateIt('mission_armored_wrong_vehicle_end'), "error", 7)
                clearArmoredMissionState()
                return
            end

            armoredTruckVeh = vehicle
            local missionState = MS.createMissionVehicleState(vehicle, "stockade")
            armoredTruckVehNetId = missionState.netId
            armoredTruckPlate = missionState.plate

            local guardModels = { "s_m_m_armoured_01", "s_m_y_blackops_01", "s_m_y_blackops_02" }
            local positions = MS.getCirclePosAroundEntity(vehicle, 8, 10.0, 18.0)

            for i, pos in ipairs(positions) do
                local mdl = guardModels[(i % #guardModels) + 1]
                local ped = MS.spawnGuardAt(mdl, pos.x, pos.y, pos.z, pos.h)
                if ped then table.insert(missionPeds, ped) end
            end
            MS.taskGuards(missionPeds)

            MS.waitForMissionVehicleEntry(missionState, {
                highlightCoords = spawnCoords,
                isActive = function() return isArmoredHeistMission end,
            }, function()
                if armoredPickupBlip then RemoveBlip(armoredPickupBlip) end
                armoredPickupBlip = nil

                armoredBreachBlip = SH.addBlip(breachCoords.xyz, 161, 3, TranslateIt('mission_armored_breach_blip'))
                SetBlipAsShortRange(armoredBreachBlip, false)
                SetBlipRoute(armoredBreachBlip, true)
                SetNewWaypoint(breachCoords.x, breachCoords.y)

                local breachPed = {
                    heading = breachCoords.w,
                    model = "s_m_m_security_01",
                    gender = "male",
                }

                armoredBreachMark = SH.MarkNewCoords(breachCoords, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, breachPed, function()
                end, function()
                    startArmoredTruckBreach()
                end, {
                    name = "mission_armored_truck_breach",
                    label = TranslateIt('mission_armored_breach_label'),
                    icon = "fa-solid fa-lock-open"
                })

                sendNotify(TranslateIt('mission_armored_stolen_info'), "info", 8)
            end)
        end)
    end)
end

RegisterNetEvent('op-crime:cancelMissionClient')
AddEventHandler('op-crime:cancelMissionClient', function(missionIndex)
    if missionIndex and missionIndex ~= 'armored_truck_heist' and missionIndex ~= 'all' then return end
    if armoredTruckVeh and DoesEntityExist(armoredTruckVeh) then
        Fr.DeleteVehicle(armoredTruckVeh)
    end
    clearArmoredMissionState()
end)

