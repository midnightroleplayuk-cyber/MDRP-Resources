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

local function getJob()
    local fw = detect()
    local pd
    if fw == 'qbx' then pd = exports.qbx_core:GetPlayerData()
    elseif fw == 'qb' then pd = QBCore.Functions.GetPlayerData()
    elseif fw == 'esx' then pd = ESX.GetPlayerData()
    else return nil end
    local j = pd and pd.job
    if not j then return nil end
    if fw == 'esx' then return j.name, j.grade or 0, true end
    return j.name, (j.grade and j.grade.level) or 0, j.onduty ~= false
end

--- Client-side check used for showing target options. The server re-checks everything.
--- @param kind 'police'|'review'
function Bridge.HasAccess(kind)
    if detect() == 'standalone' then return Access[kind] == true end
    local map = kind == 'review' and Config.ReviewJobs or Config.PoliceJobs
    local job, grade, onDuty = getJob()
    local min = job and map[job]
    if min == nil then return false end
    if Config.RequireOnDuty and not onDuty then return false end
    return grade >= min
end
