-- Normalises Qbox / QBCore / ESX into one shape: { source, citizenid, name }

Framework = {}

local fw = Config.Framework
if fw == 'auto' then
    if GetResourceState('qbx_core') ~= 'missing' then fw = 'qbox'
    elseif GetResourceState('qb-core') ~= 'missing' then fw = 'qbcore'
    elseif GetResourceState('es_extended') ~= 'missing' then fw = 'esx'
    end
end
Framework.name = fw

local QBCore, ESX
if fw == 'qbcore' then QBCore = exports['qb-core']:GetCoreObject() end
if fw == 'esx' then ESX = exports.es_extended:getSharedObject() end

local function fromQB(p)
    if not p then return nil end
    local d = p.PlayerData
    local ci = d.charinfo or {}
    return { source = d.source, citizenid = d.citizenid, name = ('%s %s'):format(ci.firstname or '', ci.lastname or '') }
end

local function fromESX(x)
    if not x then return nil end
    return { source = x.source, citizenid = x.identifier, name = x.getName and x.getName() or x.name }
end

function Framework.GetPlayer(src)
    if fw == 'qbox' then return fromQB(exports.qbx_core:GetPlayer(src)) end
    if fw == 'qbcore' then return fromQB(QBCore.Functions.GetPlayer(src)) end
    if fw == 'esx' then return fromESX(ESX.GetPlayerFromId(src)) end
end

function Framework.GetByCitizenId(cid)
    if fw == 'qbox' then return fromQB(exports.qbx_core:GetPlayerByCitizenId(cid)) end
    if fw == 'qbcore' then return fromQB(QBCore.Functions.GetPlayerByCitizenId(cid)) end
    if fw == 'esx' then return fromESX(ESX.GetPlayerFromIdentifier(cid)) end
end

if not fw or fw == 'auto' then
    print('^1[vinewood_mdt_mobile] No supported framework found. Set Config.Framework.^0')
else
    print(('[vinewood_mdt_mobile] Framework: %s'):format(fw))
end
