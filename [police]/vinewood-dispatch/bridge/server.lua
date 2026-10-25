Bridge = {}

local QBCore, ESX

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if GetResourceState('qbx_core') == 'started' then return 'qbx' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    return 'standalone'
end

Bridge.Framework = detect()

if Bridge.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Bridge.Framework == 'esx' then
    ESX = exports.es_extended:getSharedObject()
end

local jobToService = {}
for key, svc in pairs(Config.Services) do
    for _, job in ipairs(svc.jobs) do
        jobToService[job] = key
    end
end

local function getQbPlayer(src)
    if Bridge.Framework == 'qbx' then
        return exports.qbx_core:GetPlayer(src)
    end
    return QBCore.Functions.GetPlayer(src)
end

---Returns job name and duty state for a player
local function getJob(src)
    if Bridge.Framework == 'qbx' or Bridge.Framework == 'qb' then
        local player = getQbPlayer(src)
        if not player then return end
        local job = player.PlayerData.job
        return job.name, job.onduty
    elseif Bridge.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end
        return xPlayer.job.name, true
    end
end

---@return string|nil service, boolean onDuty
function Bridge.GetService(src)
    if Bridge.Framework == 'standalone' then
        for key in pairs(Config.Services) do
            if IsPlayerAceAllowed(src, ('vinewood.dispatch.%s'):format(key)) then
                return key, true
            end
        end
        return nil, false
    end

    local job, onDuty = getJob(src)
    local service = job and jobToService[job]
    if not service then return nil, false end
    if not Config.Services[service].requireDuty then onDuty = true end
    return service, onDuty == true
end

local function externalCallsign(src)
    for _, provider in ipairs(Config.CallsignExports or {}) do
        if GetResourceState(provider.resource) == 'started' then
            local ok, callsign = pcall(function()
                return exports[provider.resource][provider.export](nil, src)
            end)
            if ok and type(callsign) == 'string' and callsign ~= '' then return callsign end
        end
    end
end

---@return string name, string|nil callsign, string|nil phone
function Bridge.GetIdentity(src)
    local name, callsign, phone = Bridge.GetBaseIdentity(src)
    local saved = Config.Callsigns.enabled and Callsigns and Callsigns.Get(src)
    return name, saved or externalCallsign(src) or callsign, phone
end

---Stable per-character id for saving callsigns
function Bridge.GetCharId(src)
    if Bridge.Framework == 'qbx' or Bridge.Framework == 'qb' then
        local player = getQbPlayer(src)
        return player and player.PlayerData.citizenid
    elseif Bridge.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.identifier
    end
    return GetPlayerIdentifierByType(src, 'license')
end

function Bridge.GetBaseIdentity(src)
    if Bridge.Framework == 'qbx' or Bridge.Framework == 'qb' then
        local player = getQbPlayer(src)
        if player then
            local data = player.PlayerData
            local info = data.charinfo or {}
            local callsign = data.metadata and data.metadata.callsign
            if callsign == 'NO CALLSIGN' or callsign == '' then callsign = nil end
            return ('%s %s'):format(info.firstname or '', info.lastname or ''), callsign, info.phone
        end
    elseif Bridge.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.getName(), nil, nil
        end
    end
    return GetPlayerName(src) or 'Unknown', nil, nil
end
