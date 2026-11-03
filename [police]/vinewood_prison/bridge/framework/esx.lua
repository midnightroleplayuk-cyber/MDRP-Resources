if Bridge.framework ~= 'esx' then return end

local ESX = exports.es_extended:getSharedObject()

function Bridge.getIdentifier(src)
    local x = ESX.GetPlayerFromId(src)
    return x and x.identifier or nil
end

function Bridge.getName(src)
    local x = ESX.GetPlayerFromId(src)
    if not x then return GetPlayerName(src) or ('Player %s'):format(src) end
    return x.getName()
end

function Bridge.getJob(src)
    local x = ESX.GetPlayerFromId(src)
    if not x then return nil end
    -- Older ESX has no duty field; treat as on duty
    return { name = x.job.name, grade = x.job.grade or 0, onDuty = x.job.onDuty ~= false }
end

function Bridge.getSource(identifier)
    local x = ESX.GetPlayerFromIdentifier(identifier)
    return x and x.source or nil
end

function Bridge.getPhone(src)
    local x = ESX.GetPlayerFromId(src)
    if not x then return nil end
    local ok, meta = pcall(function() return x.getMeta and x.getMeta('phoneNumber') end)
    if ok and meta then return meta end
    return x.get and x.get('phoneNumber') or nil
end

function Bridge.getLoadedSources()
    local out = {}
    for _, x in pairs(ESX.GetExtendedPlayers()) do out[#out + 1] = x.source end
    return out
end

AddEventHandler('esx:playerLoaded', function(playerId)
    TriggerEvent('vinewood_prison:server:playerLoaded', playerId)
end)

AddEventHandler('esx:playerLogout', function(playerId)
    TriggerEvent('vinewood_prison:server:playerUnloaded', playerId)
end)
