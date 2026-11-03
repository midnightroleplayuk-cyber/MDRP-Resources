Bridge = {}

local FW, Core

if GetResourceState('qbx_core') ~= 'missing' then
    FW = 'qbx'
elseif GetResourceState('qb-core') ~= 'missing' then
    FW = 'qb'
    Core = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') ~= 'missing' then
    FW = 'esx'
    Core = exports.es_extended:getSharedObject()
end

Bridge.Framework = FW

local function getPlayer(src)
    if FW == 'qbx' then return exports.qbx_core:GetPlayer(src) end
    if FW == 'qb' then return Core.Functions.GetPlayer(src) end
    if FW == 'esx' then return Core.GetPlayerFromId(src) end
end

---@return string? job, number grade, boolean onDuty, string? jobType
function Bridge.GetJob(src)
    local p = getPlayer(src)
    if not p then return nil, 0, false end

    if FW == 'esx' then
        return p.job.name, tonumber(p.job.grade) or 0, true, nil
    end

    local job = p.PlayerData.job
    if not job then return nil, 0, false end
    local grade = type(job.grade) == 'table' and (job.grade.level or 0) or tonumber(job.grade) or 0
    return job.name, grade, job.onduty == true, job.type
end

---@return string? gang
function Bridge.GetGang(src)
    if FW == 'esx' then return nil end
    local p = getPlayer(src)
    local g = p and p.PlayerData.gang
    return g and g.name or nil
end

function Bridge.GetIdentifier(src)
    local p = getPlayer(src)
    if p then
        if FW == 'esx' then return p.identifier end
        return p.PlayerData.citizenid
    end
    return GetPlayerIdentifierByType(src, 'license')
end

function Bridge.GetName(src)
    local p = getPlayer(src)
    if not p then return GetPlayerName(src) end
    if FW == 'esx' then return p.getName() end
    local c = p.PlayerData.charinfo
    return c and ('%s %s'):format(c.firstname, c.lastname) or GetPlayerName(src)
end

function Bridge.HasItem(src, item)
    if GetResourceState('ox_inventory') == 'started' then
        return (exports.ox_inventory:Search(src, 'count', item) or 0) > 0
    end
    local p = getPlayer(src)
    if not p then return false end
    if FW == 'esx' then
        local i = p.getInventoryItem(item)
        return i and i.count > 0
    end
    return p.Functions.GetItemByName(item) ~= nil
end

-- ox_inventory uses the client export in items.lua instead (see README)
function Bridge.RegisterUsableItem(item, cb)
    if GetResourceState('ox_inventory') == 'started' then return end
    if FW == 'qbx' then
        exports.qbx_core:CreateUseableItem(item, function(source) cb(source) end)
    elseif FW == 'qb' then
        Core.Functions.CreateUseableItem(item, function(source) cb(source) end)
    elseif FW == 'esx' then
        Core.RegisterUsableItem(item, function(source) cb(source) end)
    end
end
