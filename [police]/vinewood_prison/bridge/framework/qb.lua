if Bridge.framework ~= 'qb' then return end

local QBCore = exports['qb-core']:GetCoreObject()

local function player(src)
    return QBCore.Functions.GetPlayer(src)
end

function Bridge.getIdentifier(src)
    local p = player(src)
    return p and p.PlayerData.citizenid or nil
end

function Bridge.getName(src)
    local p = player(src)
    if not p then return GetPlayerName(src) or ('Player %s'):format(src) end
    local c = p.PlayerData.charinfo
    return ('%s %s'):format(c.firstname, c.lastname)
end

function Bridge.getJob(src)
    local p = player(src)
    if not p then return nil end
    local j = p.PlayerData.job
    return { name = j.name, grade = j.grade and j.grade.level or 0, onDuty = j.onduty ~= false }
end

function Bridge.getSource(identifier)
    local p = QBCore.Functions.GetPlayerByCitizenId(identifier)
    return p and p.PlayerData.source or nil
end

function Bridge.getPhone(src)
    local p = QBCore.Functions.GetPlayer(src)
    return p and p.PlayerData.charinfo and p.PlayerData.charinfo.phone or nil
end

function Bridge.getLoadedSources()
    local out = {}
    for src in pairs(QBCore.Functions.GetQBPlayers() or {}) do out[#out + 1] = tonumber(src) end
    return out
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(p)
    if p and p.PlayerData then TriggerEvent('vinewood_prison:server:playerLoaded', p.PlayerData.source) end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    TriggerEvent('vinewood_prison:server:playerLoaded', source)
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    TriggerEvent('vinewood_prison:server:playerUnloaded', src)
end)
