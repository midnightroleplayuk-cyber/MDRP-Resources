-- Vinewood Studios :: Scrap Iron Horn (NUI version)
-- Travellervan custom horn, G key (press once), synced with spatial volume.

local TARGET_MODEL = `travellervan`
local MAX_HEAR_DISTANCE = 80.0
local MIN_FULL_VOLUME = 5.0
local HORN_DURATION_MS = 6400    -- mp3 length in ms

local activeHorns = {}
local cooldownUntil = 0

-- ============================================================
-- NUI helpers
-- ============================================================

local function nuiPlay(netId, volume)
    SendNUIMessage({ action = 'play', netId = netId, volume = volume })
end

local function nuiStop(netId)
    SendNUIMessage({ action = 'stop', netId = netId })
end

local function nuiVolume(netId, volume)
    SendNUIMessage({ action = 'volume', netId = netId, volume = volume })
end

-- ============================================================
-- Distance -> volume
-- ============================================================

local function calcVolume(vehCoords)
    local myCoords = GetEntityCoords(PlayerPedId())
    local dist = #(vehCoords - myCoords)

    if dist <= MIN_FULL_VOLUME then return 1.0 end
    if dist >= MAX_HEAR_DISTANCE then return 0.0 end

    local t = (dist - MIN_FULL_VOLUME) / (MAX_HEAR_DISTANCE - MIN_FULL_VOLUME)
    return 1.0 - t
end

-- ============================================================
-- Keybinding (single press)
-- ============================================================

RegisterCommand('+scrapironhorn', function()
    if GetGameTimer() < cooldownUntil then return end

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh ~= 0
       and GetPedInVehicleSeat(veh, -1) == ped
       and GetEntityModel(veh) == TARGET_MODEL then

        cooldownUntil = GetGameTimer() + HORN_DURATION_MS
        local netId = NetworkGetNetworkIdFromEntity(veh)
        TriggerServerEvent('scrapiron:trigger', netId)
    end
end, false)

RegisterCommand('-scrapironhorn', function() end, false)

RegisterKeyMapping('+scrapironhorn', 'Travellervan Custom Horn', 'keyboard', 'g')

-- ============================================================
-- Network sync
-- ============================================================

RegisterNetEvent('scrapiron:play', function(netId)
    if not NetworkDoesEntityExistWithNetworkId(netId) then return end

    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then return end

    if activeHorns[netId] then return end

    activeHorns[netId] = veh
    nuiPlay(netId, calcVolume(GetEntityCoords(veh)))

    SetTimeout(HORN_DURATION_MS, function()
        if activeHorns[netId] then
            nuiStop(netId)
            activeHorns[netId] = nil
        end
    end)
end)

-- ============================================================
-- Volume update loop
-- ============================================================

CreateThread(function()
    while true do
        local count = 0
        for netId, veh in pairs(activeHorns) do
            count = count + 1
            if not DoesEntityExist(veh)
               or not NetworkDoesEntityExistWithNetworkId(netId) then
                nuiStop(netId)
                activeHorns[netId] = nil
            else
                nuiVolume(netId, calcVolume(GetEntityCoords(veh)))
            end
        end
        Wait(count > 0 and 200 or 1000)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    SendNUIMessage({ action = 'stopAll' })
    activeHorns = {}
end)
