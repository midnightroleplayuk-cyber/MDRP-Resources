local placement

local function canEdit(src)
    if not Config.EnablePlacementEditor then return false end
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier == Config.PlacementIdentifier then return true end
    end
    return false
end
local lastPressed = -Config.CooldownSeconds * 1000

local function validPlacement(p)
    return type(p) == 'table' and type(p.model) == 'string' and p.model == Config.DefaultModel
        and type(p.x) == 'number' and type(p.y) == 'number' and type(p.z) == 'number'
        and type(p.h) == 'number' and math.abs(p.x) < 10000 and math.abs(p.y) < 10000
        and math.abs(p.z) < 10000 and p.h >= 0 and p.h <= 360
        and (p.rx == nil or (type(p.rx) == 'number' and p.rx >= 0 and p.rx <= 360))
        and (p.ry == nil or (type(p.ry) == 'number' and p.ry >= 0 and p.ry <= 360))
end

local saved = LoadResourceFile(GetCurrentResourceName(), 'placement.json')
if saved and saved ~= '' then
    local ok, parsed = pcall(json.decode, saved)
    if ok and validPlacement(parsed) then placement = parsed end
end
if not placement then
    placement = {model = Config.DefaultModel, x = Config.DefaultCoords.x, y = Config.DefaultCoords.y, z = Config.DefaultCoords.z, h = Config.DefaultCoords.w}
end

RegisterNetEvent('hf1_policebell:server:sync', function()
    TriggerClientEvent('hf1_policebell:client:setPlacement', source, placement)
end)

RegisterNetEvent('hf1_policebell:server:startEditor', function()
    local src = source
    if not canEdit(src) then
        TriggerClientEvent('hf1_policebell:client:denied', src)
        return
    end
    TriggerClientEvent('hf1_policebell:client:edit', src, placement)
end)

RegisterNetEvent('hf1_policebell:server:save', function(p)
    local src = source
    if not canEdit(src) then return end
    if not validPlacement(p) then return end
    local encoded = json.encode(p)
    if not SaveResourceFile(GetCurrentResourceName(), 'placement.json', encoded, -1) then
        TriggerClientEvent('hf1_policebell:client:saveFailed', src)
        return
    end
    placement = p
    TriggerClientEvent('hf1_policebell:client:setPlacement', -1, placement)
    TriggerClientEvent('hf1_policebell:client:saved', src)
end)

RegisterNetEvent('hf1_policebell:server:press', function()
    local src = source
    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local distance = #(GetEntityCoords(ped) - vector3(placement.x, placement.y, placement.z))
    if distance > Config.InteractDistance + Config.TargetRadius + 1.0 then return end
    local now = GetGameTimer()
    local remaining = Config.CooldownSeconds * 1000 - (now - lastPressed)
    if remaining > 0 then
        TriggerClientEvent('hf1_policebell:client:cooldown', src, math.ceil(remaining / 1000))
        return
    end
    lastPressed = now
    TriggerClientEvent('hf1_policebell:client:pressed', src)
    -- Sound is only broadcast after a successful press, not during cooldown.
    TriggerClientEvent('hf1_policebell:client:playSound', -1, {x = placement.x, y = placement.y, z = placement.z})
    for _, id in ipairs(GetPlayers()) do
        local target = tonumber(id)
        local player = exports.qbx_core:GetPlayer(target)
        local job = player and player.PlayerData and player.PlayerData.job
        if job and Config.AlertJobs[job.name] and job.onduty then
            TriggerClientEvent('hf1_policebell:client:alertPolice', target)
        end
    end
end)
