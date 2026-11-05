Bridge = {}

local fw = Config.Framework
local QB, ESX

CreateThread(function()
    if fw == 'auto' then
        if GetResourceState('qbx_core') == 'started' then fw = 'qbx'
        elseif GetResourceState('qb-core') == 'started' then fw = 'qb'
        elseif GetResourceState('es_extended') == 'started' then fw = 'esx'
        else fw = 'standalone' end
    end
    if fw == 'qb' then QB = exports['qb-core']:GetCoreObject() end
    if fw == 'esx' then ESX = exports.es_extended:getSharedObject() end
    print(('[vinewood_firealarm] framework: %s'):format(fw))
end)

---@return string|nil job, number grade
function Bridge.GetJob(src)
    if fw == 'qbx' then
        local p = exports.qbx_core:GetPlayer(src)
        if p then return p.PlayerData.job.name, p.PlayerData.job.grade.level end
    elseif fw == 'qb' and QB then
        local p = QB.Functions.GetPlayer(src)
        if p then return p.PlayerData.job.name, p.PlayerData.job.grade.level end
    elseif fw == 'esx' and ESX then
        local p = ESX.GetPlayerFromId(src)
        if p then return p.job.name, p.job.grade end
    end
    return nil, 0
end

function Bridge.GetName(src)
    if fw == 'qbx' then
        local p = exports.qbx_core:GetPlayer(src)
        if p then return ('%s %s (%s)'):format(p.PlayerData.charinfo.firstname, p.PlayerData.charinfo.lastname, p.PlayerData.citizenid) end
    elseif fw == 'qb' and QB then
        local p = QB.Functions.GetPlayer(src)
        if p then return ('%s %s (%s)'):format(p.PlayerData.charinfo.firstname, p.PlayerData.charinfo.lastname, p.PlayerData.citizenid) end
    elseif fw == 'esx' and ESX then
        local p = ESX.GetPlayerFromId(src)
        if p then return ('%s (%s)'):format(p.getName(), p.identifier) end
    end
    return ('%s [%d]'):format(GetPlayerName(src) or 'Unknown', src)
end

function Bridge.IsAdmin(src)
    return IsPlayerAceAllowed(src, Config.AdminAce)
end
