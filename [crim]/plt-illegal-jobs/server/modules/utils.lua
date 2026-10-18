local Utils = {}

local actionCooldowns = {} -- [source] = { [actionKey] = expireMs }

function Utils.getPoliceCount()
    local count = 0
    for _, playerId in pairs(GetPlayers()) do
        local xPlayerJob = server.getPlayerJob(tonumber(playerId))
        if xPlayerJob and Config.PoliceJobName[string.lower(xPlayerJob.name)] then
            count = count + 1
        end
    end
    return count
end

---@param source number
---@param title string
---@param type string
---@param description string
---@param duration number
function Utils.server_notify(source, title, type, description, duration)
    TriggerClientEvent(_e('client:notify'), source, title, type, description, duration)
end

--- Return true and consume a cooldown slot, or false if still cooling down.
---@param source number
---@param actionKey string
---@param cooldownMs number|nil default 1500
---@return boolean
function Utils.consumeActionCooldown(source, actionKey, cooldownMs)
    cooldownMs = cooldownMs or 1500
    source = tonumber(source)
    if not source or not actionKey then return false end

    local now = GetGameTimer()
    actionCooldowns[source] = actionCooldowns[source] or {}
    local untilMs = actionCooldowns[source][actionKey] or 0
    if now < untilMs then
        return false
    end
    actionCooldowns[source][actionKey] = now + cooldownMs
    return true
end

AddEventHandler('playerDropped', function()
    local src = source
    if actionCooldowns[src] then actionCooldowns[src] = nil end
end)

local function toVec3(coords)
    if not coords then return nil end
    local t = type(coords)
    if t == 'vector3' then return coords end
    if t == 'vector4' then return vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0) end
    if t ~= 'table' then return nil end

    if coords.coords then return toVec3(coords.coords) end

    -- Prefer named fields. Only fall back to [1]/[2]/[3] when they are numbers —
    -- arrays of vector3/vector4 must NOT be treated as a single coordinate
    -- (that caused "invalid vector dimensions" when landing_points was passed in).
    local x, y, z = coords.x, coords.y, coords.z
    if type(x) ~= 'number' and type(coords[1]) == 'number' then
        x, y, z = coords[1], coords[2], coords[3]
    end
    if type(x) == 'number' and type(y) == 'number' and type(z) == 'number' then
        return vector3(x + 0.0, y + 0.0, z + 0.0)
    end
    return nil
end

--- True if player ped is within maxDistance of any listed coordinate.
---@param source number
---@param coords any vector3/vector4/table or list of those
---@param maxDistance number|nil default 12.0
---@return boolean
function Utils.isPlayerNearCoords(source, coords, maxDistance)
    maxDistance = maxDistance or 12.0
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end
    local playerCoords = GetEntityCoords(ped)

    local list
    local asVec = toVec3(coords)
    if asVec then
        list = { asVec }
    elseif type(coords) == 'table' then
        list = coords
    else
        return false
    end

    for _, entry in pairs(list) do
        local pos = toVec3(entry)
        if pos and #(playerCoords - pos) <= maxDistance then
            return true
        end
    end
    return false
end

--- True if player is within maxDistance of a networked entity.
---@param source number
---@param netId number
---@param maxDistance number|nil
---@return boolean
function Utils.isPlayerNearNetId(source, netId, maxDistance)
    maxDistance = maxDistance or 5.0
    netId = tonumber(netId)
    if not netId then return false end
    local ent = NetworkGetEntityFromNetworkId(netId)
    if not ent or ent == 0 or not DoesEntityExist(ent) then return false end
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - GetEntityCoords(ent)) <= maxDistance
end

--- Shared gate for job action callbacks: lobby membership + job name + rate limit.
---@return table|nil lobby, string|nil err
function Utils.assertJobMember(source, lobbyId, jobKey, actionKey, cooldownMs)
    if not Lobby.isPlayerInLobby(lobbyId, source) then
        return nil, 'not_member'
    end
    local lobby = Lobby.getLobbyById(lobbyId)
    if not lobby or not lobby.currentJob then
        return nil, 'no_job'
    end
    if jobKey and lobby.currentJob.name ~= jobKey then
        return nil, 'wrong_job'
    end
    if actionKey and not Utils.consumeActionCooldown(source, actionKey, cooldownMs) then
        return nil, 'cooldown'
    end
    return lobby, nil
end

---@param params any
---@return number, number
function Utils.spawnVehicle(params)
    local model = params.model
    if type(model) == 'string' then
        model = joaat(model)
    end
    local coords = params.coords
    if type(coords) == 'vector3' then
        coords = vector4(coords.x, coords.y, coords.z, 0.0)
    elseif type(coords) == 'table' and (coords.x or coords[1]) then
        local x = coords.x or coords[1]
        local y = coords.y or coords[2]
        local z = coords.z or coords[3]
        local w = coords.w or coords[4] or 0.0
        if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then
            return 0, 0
        end
        coords = vector4(x + 0.0, y + 0.0, z + 0.0, w + 0.0)
    end
    if not coords then return 0, 0 end

    local vehType = params.type
    if not vehType and GetVehicleTypeFromName then
        local ok, resolved = pcall(GetVehicleTypeFromName, model)
        if ok and type(resolved) == 'string' and resolved ~= '' then
            vehType = resolved
        end
    end
    vehType = vehType or 'automobile'

    local veh = 0
    if CreateVehicleServerSetter then
        veh = CreateVehicleServerSetter(model, vehType, coords.x, coords.y, coords.z, coords.w or 0.0)
        -- Wait for the server-setter entity before falling back (avoids double-spawn).
        if veh and veh ~= 0 then
            local timeout = GetGameTimer() + 3000
            while not DoesEntityExist(veh) and GetGameTimer() < timeout do
                Wait(0)
            end
        end
    end
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        veh = CreateVehicle(model, coords.x, coords.y, coords.z + 0.5, coords.w or 0.0, true, true)
        local timeout = GetGameTimer() + 5000
        while (not veh or veh == 0 or not DoesEntityExist(veh)) and GetGameTimer() < timeout do
            Wait(0)
        end
    end
    if not veh or veh == 0 or not DoesEntityExist(veh) then
        return 0, 0
    end

    SetEntityCoords(veh, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(veh, coords.w or 0.0)

    -- SetNetworkIdExistsOnAllMachines / SetNetworkIdCanMigrate are CLIENT-only natives.
    -- Calling them on the server crashes (nil global). Networked CreateVehicle is enough.
    local netId = NetworkGetNetworkIdFromEntity(veh)
    local deadline = GetGameTimer() + 3000
    while (not netId or netId == 0) and GetGameTimer() < deadline do
        Wait(50)
        netId = NetworkGetNetworkIdFromEntity(veh)
    end
    return netId or 0, veh
end

return Utils
