local MS = MissionShared

local findVehicleMarked = nil
local findVehicleBlip = nil
local findVehicleBlip2 = nil
local findVehicleCoords = vec4(232.4930, -1771.4315, 27.6610, 48.4330)
local findVehicleModel = "blista"

local function getNearbyVehicleByModel(modelHash, radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyVehicle = nil

    for vehicle in SH.EnumerateVehicles() do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehicleCoords)
            if distance <= radius and GetEntityModel(vehicle) == modelHash then
                nearbyVehicle = vehicle
                break
            end
        end
    end

    return nearbyVehicle
end

local function backWithVehicle()
    local vehicle = GetHashKey(findVehicleModel)
    local findVehicle = getNearbyVehicleByModel(vehicle, 15.0)

    if findVehicle then
        SH.RemoveMarkedCoords(findVehicleMarked)

        if findVehicleBlip then
            SetBlipDisplay(findVehicleBlip, 0)
            RemoveBlip(findVehicleBlip)
        end

        if findVehicleBlip2 then
            SetBlipDisplay(findVehicleBlip2, 0)
            RemoveBlip(findVehicleBlip2)
        end

        sendNotify(TranslateIt('vehicleMission_endSuccess'), "success", 5)
        TriggerServerEvent('op-crime:endMission', "find_vehicle")

        SH.fadeOutEntity(findVehicle, false)
        Wait(1000)
        Fr.DeleteVehicle(findVehicle)
    else
        sendNotify(TranslateIt('vehicleMission_noVehicleinradius', "Blista"), "error", 5)
    end
end

function startFindVehicleMission()
    local coords = findVehicleCoords
    local ped = {
        heading = coords.w,
        model = "a_m_m_afriamer_01",
        gender = "male",
    }

    findVehicleBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 60.0)
    SetBlipColour(findVehicleBlip, 49)
    SetBlipAlpha(findVehicleBlip, 222)

    local blipLabel = TranslateIt('mission_end_returnVehicle_blip')
    findVehicleBlip2 = SH.addBlip(coords.xyz, 523, 3, blipLabel)
    SetBlipAsShortRange(findVehicleBlip2, false)

    SetNewWaypoint(coords.x, coords.y)

    lib.alertDialog({
        header = TranslateIt('vehicleMission_header'),
        content = TranslateIt('vehicleMission_desc', "Blista"),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('vehicleMission_alert_Okay') }
    })

    findVehicleMarked = SH.MarkNewCoords(coords, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
    end, function()
        backWithVehicle()
    end, {
        name = "mission_find_vehicle_end",
        label = TranslateIt('mission_ped_returnVehicle'),
        icon = TranslateIt('mission_ped_returnVehicle_icon')
    })
end

