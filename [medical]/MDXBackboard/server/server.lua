local MODEL = `combicarrier2`
local PLACE_DIST = 20.0
local USE_DIST = 5.0

local placed = {}
local occupant = {}

local function notify(src, description, ntype)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Backboard',
        description = description,
        type = ntype or 'inform',
    })
end

local function inventoryReady()
    return GetResourceState('ox_inventory') == 'started'
end

local function canCarry(src)
    return inventoryReady() and exports.ox_inventory:CanCarryItem(src, Config.ItemName, 1) == true
end

local function giveItem(src)
    if not inventoryReady() then return false end
    return exports.ox_inventory:AddItem(src, Config.ItemName, 1) and true or false
end

local function takeItem(src)
    if not inventoryReady() then return false end
    local count = exports.ox_inventory:GetItemCount(src, Config.ItemName) or 0
    if count < 1 then return false end
    return exports.ox_inventory:RemoveItem(src, Config.ItemName, 1) and true or false
end

local function boardEntity(netId)
    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent and ent ~= 0 and DoesEntityExist(ent) and GetEntityModel(ent) == MODEL then
        return ent
    end
end

local function playerWithin(src, coords, dist)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - coords) <= dist
end

local function nearPlayer(src, targetId)
    local targetPed = GetPlayerPed(targetId)
    if not targetPed or targetPed == 0 then return false end
    return playerWithin(src, GetEntityCoords(targetPed), USE_DIST)
end

local function setPatientState(serverId, value)
    if GetPlayerPed(serverId) ~= 0 then
        Player(serverId).state:set('onBackboard', value, true)
    end
end

local function removeBoard(netId)
    local board = placed[netId]
    if not board then return end
    placed[netId] = nil
    if board.occupied then
        occupant[board.occupied] = nil
    end
    local ent = NetworkGetEntityFromNetworkId(netId)
    if ent and ent ~= 0 and DoesEntityExist(ent) and GetEntityModel(ent) == MODEL then
        DeleteEntity(ent)
    end
end

RegisterNetEvent('MDXBackboard:Server:placed', function(netId)
    local src = source
    netId = tonumber(netId)
    if not netId or netId <= 0 or placed[netId] then return end

    local ent
    local timeout = GetGameTimer() + 2500
    repeat
        ent = boardEntity(netId)
        if ent then break end
        Wait(100)
    until GetGameTimer() > timeout

    if placed[netId] then return end
    if not ent or not playerWithin(src, GetEntityCoords(ent), PLACE_DIST) then
        if ent then DeleteEntity(ent) end
        return
    end

    placed[netId] = { owner = src }
    if not takeItem(src) then
        placed[netId] = nil
        DeleteEntity(ent)
        notify(src, 'You do not have a backboard.', 'error')
        return
    end

    Entity(ent).state:set('placedBackboard', true, true)
    notify(src, 'Backboard placed.', 'success')
end)

RegisterNetEvent('MDXBackboard:Server:pickup', function(netId)
    local src = source
    netId = tonumber(netId)
    local board = netId and placed[netId]
    if not board then return end
    if board.occupied then
        notify(src, 'Take the patient off the backboard first.', 'error')
        return
    end

    local ent = boardEntity(netId)
    if not ent then
        placed[netId] = nil
        return
    end
    if not playerWithin(src, GetEntityCoords(ent), USE_DIST) then return end

    if not canCarry(src) or not giveItem(src) then
        notify(src, 'You cannot carry the backboard.', 'error')
        return
    end

    removeBoard(netId)
    notify(src, 'Backboard picked up.', 'success')
end)

RegisterNetEvent('MDXBackboard:Server:putOnBoard', function(targetServerId, netId)
    local src = source
    targetServerId = tonumber(targetServerId)
    netId = tonumber(netId)
    local board = netId and placed[netId]
    if not targetServerId or not board or targetServerId == src then return end

    local ent = boardEntity(netId)
    if not ent then
        placed[netId] = nil
        return
    end
    local boardCoords = GetEntityCoords(ent)
    local targetPed = GetPlayerPed(targetServerId)
    if not targetPed or targetPed == 0 then return end

    if board.occupied then
        notify(src, 'Someone is already on that backboard.', 'error')
        return
    end
    if occupant[targetServerId] then
        notify(src, 'That patient is already on a backboard.', 'error')
        return
    end
    if not playerWithin(src, boardCoords, USE_DIST)
        or #(GetEntityCoords(targetPed) - boardCoords) > USE_DIST then
        notify(src, 'No patient close enough.', 'error')
        return
    end

    board.occupied = targetServerId
    occupant[targetServerId] = netId
    setPatientState(targetServerId, true)
    Entity(ent).state:set('backboardOccupied', true, true)
    TriggerClientEvent('MDXBackboard:Client:OccupyBoard', targetServerId, netId)
    notify(src, 'Patient loaded onto the backboard.', 'success')
end)

RegisterNetEvent('MDXBackboard:Server:StopBackboard', function(targetServerId)
    local src = source
    targetServerId = tonumber(targetServerId)
    if not targetServerId or not nearPlayer(src, targetServerId) then return end

    local netId = occupant[targetServerId]
    if not netId then
        local state = Player(targetServerId).state
        if state.onBackboard then
            setPatientState(targetServerId, false)
            TriggerClientEvent('MDXBackboard:Client:StopBackboard', targetServerId)
        else
            notify(src, 'That patient is not on a backboard.', 'error')
        end
        return
    end

    if not canCarry(src) or not giveItem(src) then
        notify(src, 'You cannot carry the backboard.', 'error')
        return
    end

    removeBoard(netId)
    setPatientState(targetServerId, false)
    TriggerClientEvent('MDXBackboard:Client:StopBackboard', targetServerId)
    notify(src, 'Backboard removed.', 'success')
end)

RegisterNetEvent('MDXBackboard:Server:release', function()
    local src = source
    local netId = occupant[src]
    if netId then
        removeBoard(netId)
    end
    if Player(src).state.onBackboard then
        setPatientState(src, false)
        TriggerClientEvent('MDXBackboard:Client:StopBackboard', src)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local netId = occupant[src]
    if netId then
        removeBoard(netId)
    end
end)

CreateThread(function()
    while true do
        Wait(30000)
        for netId, board in pairs(placed) do
            if not boardEntity(netId) then
                if board.occupied then
                    occupant[board.occupied] = nil
                    if GetPlayerPed(board.occupied) ~= 0 then
                        setPatientState(board.occupied, false)
                        TriggerClientEvent('MDXBackboard:Client:StopBackboard', board.occupied)
                    end
                end
                placed[netId] = nil
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for netId in pairs(placed) do
        local occ = placed[netId].occupied
        removeBoard(netId)
        if occ then
            setPatientState(occ, false)
        end
    end
end)
