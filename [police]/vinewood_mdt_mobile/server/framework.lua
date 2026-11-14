-- Normalises Qbox / QBCore / ESX into one officer shape:
-- { source, citizenid, name, job, jobLabel, grade, gradeName, onDuty, callsign }

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

local function isPoliceJob(name, jobType)
    return jobType == 'leo' or name == 'police'
end

local function fromQB(p)
    if not p then return nil end
    local d = p.PlayerData
    local job = d.job or {}
    local grade = job.grade or {}
    local ci = d.charinfo or {}
    return {
        source    = d.source,
        citizenid = d.citizenid,
        name      = ('%s %s'):format(ci.firstname or '', ci.lastname or ''),
        job       = job.name,
        jobLabel  = job.label,
        grade     = tonumber(grade.level) or 0,
        gradeName = grade.name,
        onDuty    = job.onduty == true,
        callsign  = d.metadata and d.metadata.callsign or nil,
        isPolice  = isPoliceJob(job.name, job.type),
    }
end

local function fromESX(x)
    if not x then return nil end
    local job = x.getJob and x.getJob() or x.job or {}
    return {
        source    = x.source,
        citizenid = x.identifier,
        name      = x.getName and x.getName() or x.name,
        job       = job.name,
        jobLabel  = job.label,
        grade     = tonumber(job.grade) or 0,
        gradeName = job.grade_label,
        onDuty    = job.onDuty ~= false, -- ESX has no duty by default
        callsign  = nil,
        isPolice  = isPoliceJob(job.name, nil),
    }
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
