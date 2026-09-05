local MS = MissionShared

local isDeliverVanMission = false
local missionVeh = nil
local missionPeds = {}

local deliverVanBlip = nil
local deliverVanBlip2 = nil
local markedDeliverDestination = nil
local missionVehNetId = nil
local missionVehPlate = nil

local deliverVanCoordsRandom = {
    vec4(-534.7047, -2815.8403, 6.0004, 241.7177),
    vec4(-118.4501, -2668.7634, 6.0021, 5.3313),
    vec4(280.4062, -3219.1924, 5.7903, 265.1155),
    vec4(611.9205, -3175.1401, 6.0695, 355.3698),
    vec4(984.7985, -2542.1875, 28.3020, 356.1865),
    vec4(1717.1259, -1654.7063, 112.5039, 197.5105),
    vec4(2791.1785, -707.2554, 4.7015, 112.4764),
    vec4(2483.9858, 1583.2714, 32.7202, 334.9705),
    vec4(889.7740, 3652.7827, 32.8274, 157.2273),
}

local finalVanCoordsRandom = vec4(-488.8385, 6267.6802, 12.0418, 126.0662)

local function clearDeliverVanPeds()
    for i = #missionPeds, 1, -1 do
        local ped = missionPeds[i]
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
        missionPeds[i] = nil
    end
end

local function resetVanMissionState()
    if markedDeliverDestination then SH.RemoveMarkedCoords(markedDeliverDestination) end
    markedDeliverDestination = nil

    if deliverVanBlip then RemoveBlip(deliverVanBlip) end
    if deliverVanBlip2 then RemoveBlip(deliverVanBlip2) end
    deliverVanBlip = nil
    deliverVanBlip2 = nil

    missionVeh = nil
    missionVehNetId = nil
    missionVehPlate = nil
    isDeliverVanMission = false
    clearDeliverVanPeds()
end

local function backWithVan()
    local playerPed = PlayerPedId()
    local playerVehicle = MS.findNearbyMissionVehicle(playerPed, missionVeh, missionVehNetId, missionVehPlate, "rumpo3", 20.0)

    if MS.vehicleMatchesMission(playerVehicle, missionVeh, missionVehNetId, missionVehPlate, "rumpo3") then
        if missionVeh and DoesEntityExist(missionVeh) then
            Fr.DeleteVehicle(missionVeh)
        end

        if deliverVanBlip2 then RemoveBlip(deliverVanBlip2) end
        deliverVanBlip2 = nil
        SH.RemoveMarkedCoords(markedDeliverDestination)
        markedDeliverDestination = nil

        clearDeliverVanPeds()

        sendNotify(TranslateIt('drug_van_mission_end_notify'), "success", 10)
        TriggerServerEvent('op-crime:endMission', "steal_van")
        resetVanMissionState()
    else
        sendNotify(TranslateIt('drug_van_mission_end_notify_error'), "error", 10)
    end
end

function deliverVanMission()
    if isDeliverVanMission then return end

    lib.alertDialog({
        header = TranslateIt('drugVan_dialog_header'),
        content = TranslateIt('drugVan_dialog_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('drugVan_dialog_Okay') }
    })

    isDeliverVanMission = true
    MS.createRelationshipGroup()

    local randomCoords = deliverVanCoordsRandom[math.random(1, #deliverVanCoordsRandom)]
    if not randomCoords then
        resetVanMissionState()
        return
    end

    SetNewWaypoint(randomCoords.x, randomCoords.y)

    deliverVanBlip = AddBlipForRadius(randomCoords.x, randomCoords.y, randomCoords.z, 60.0)
    SetBlipColour(deliverVanBlip, 49)
    SetBlipAlpha(deliverVanBlip, 222)

    deliverVanBlip2 = SH.addBlip(randomCoords.xyz, 140, 2, TranslateIt('drug_van_blip'))
    SetBlipAsShortRange(deliverVanBlip2, false)

    Citizen.CreateThread(function()
        while isDeliverVanMission do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local cords = vec3(randomCoords.x, randomCoords.y, randomCoords.z)
            if #(cords - playerCoords) < 150 then
                break
            end
            Wait(50)
        end
        if not isDeliverVanMission then return end

        Fr.SpawnVehicle("rumpo3", randomCoords.xyz, randomCoords.w or 0.0, true, function(vehicle)
            if not isDeliverVanMission then
                if DoesEntityExist(vehicle) then Fr.DeleteVehicle(vehicle) end
                return
            end

            if not DoesEntityExist(vehicle) then
                sendNotify(TranslateIt('drug_van_mission_end_notify_error'), "error", 10)
                resetVanMissionState()
                return
            end

            missionVeh = vehicle
            local missionState = MS.createMissionVehicleState(vehicle, "rumpo3")
            missionVehNetId = missionState.netId
            missionVehPlate = missionState.plate

            local guardModels = { "s_m_y_blackops_01", "s_m_y_blackops_02", "s_m_m_armoured_01", "s_m_m_marine_01" }
            local positions = MS.getCirclePosAroundEntity(vehicle, 10, 8.0, 16.0)

            for i, pos in ipairs(positions) do
                local mdl = guardModels[(i % #guardModels) + 1]
                local ped = MS.spawnGuardAt(mdl, pos.x, pos.y, pos.z, pos.h)
                if ped then
                    table.insert(missionPeds, ped)
                end
                Wait(50)
            end

            MS.taskGuards(missionPeds)

            MS.waitForMissionVehicleEntry(missionState, {
                highlightCoords = randomCoords,
                isActive = function() return isDeliverVanMission end,
            }, function()
                if deliverVanBlip then RemoveBlip(deliverVanBlip) end
                if deliverVanBlip2 then RemoveBlip(deliverVanBlip2) end
                deliverVanBlip = nil
                deliverVanBlip2 = nil

                if not isDeliverVanMission then return end

                local ped = {
                    heading = finalVanCoordsRandom.w,
                    model = "csb_brucie2",
                    gender = "male",
                    weapon = "weapon_assaultrifle"
                }

                markedDeliverDestination = SH.MarkNewCoords(finalVanCoordsRandom, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
                end, function()
                    backWithVan()
                end, {
                    name = "mission_steal_drugs_end",
                    label = TranslateIt('drug_van_endMission_returnVeh'),
                    icon = TranslateIt('drug_van_endMission_returnVeh_icon')
                })

                sendNotify(TranslateIt('drug_van_inside'), "info", 10)
                SetNewWaypoint(finalVanCoordsRandom.x, finalVanCoordsRandom.y)
                deliverVanBlip2 = SH.addBlip(finalVanCoordsRandom.xyz, 280, 1, TranslateIt('drug_van_blip2'))
                SetBlipAsShortRange(deliverVanBlip2, false)
            end)
        end)
    end)
end

RegisterNetEvent('op-crime:cancelMissionClient')
AddEventHandler('op-crime:cancelMissionClient', function(missionIndex)
    if missionIndex and missionIndex ~= 'steal_van' and missionIndex ~= 'all' then return end
    if missionVeh and DoesEntityExist(missionVeh) then
        Fr.DeleteVehicle(missionVeh)
    end
    resetVanMissionState()
end)

