Bridge = {}

local framework, QBCore, ESX

local function detect()
    if framework then return framework end
    if Config.Framework ~= 'auto' then
        framework = Config.Framework
    elseif GetResourceState('qbx_core') == 'started' then
        framework = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        framework = 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        framework = 'esx'
    else
        framework = 'standalone'
    end
    if framework == 'qb' then QBCore = exports['qb-core']:GetCoreObject() end
    if framework == 'esx' then ESX = exports.es_extended:getSharedObject() end
    return framework
end

local function getPlayer(src)
    local fw = detect()
    if fw == 'qbx' then return exports.qbx_core:GetPlayer(src) end
    if fw == 'qb' then return QBCore.Functions.GetPlayer(src) end
    if fw == 'esx' then return ESX.GetPlayerFromId(src) end
end

function Bridge.Framework() return detect() end

--- @return string|nil job, number grade, boolean onDuty
function Bridge.GetJob(src)
    local fw = detect()
    local p = getPlayer(src)
    if not p then return nil, 0, false end
    if fw == 'qbx' or fw == 'qb' then
        local j = p.PlayerData.job
        return j.name, (j.grade and j.grade.level) or 0, j.onduty ~= false
    elseif fw == 'esx' then
        local j = p.job
        return j.name, j.grade or 0, true
    end
    return nil, 0, false
end

function Bridge.GetName(src)
    local fw = detect()
    local p = getPlayer(src)
    if p then
        if fw == 'qbx' or fw == 'qb' then
            local c = p.PlayerData.charinfo
            if c then return ('%s %s'):format(c.firstname, c.lastname) end
        elseif fw == 'esx' then
            return p.getName()
        end
    end
    return GetPlayerName(src) or ('Player %s'):format(src)
end

function Bridge.GetIdentifier(src)
    local fw = detect()
    local p = getPlayer(src)
    if p then
        if fw == 'qbx' or fw == 'qb' then return p.PlayerData.citizenid end
        if fw == 'esx' then return p.identifier end
    end
    return GetPlayerIdentifierByType(src, 'license') or tostring(src)
end
