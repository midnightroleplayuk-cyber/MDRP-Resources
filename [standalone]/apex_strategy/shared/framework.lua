--[[
    apex_strategy, shared/framework.lua
    Bridge ESX Legacy / QBCore / QBox. Só precisamos de identidade e
    job: o quadro não mexe em dinheiro nem em inventário.

        Framework.GetPlayerJob(src)   -> { job, label, grade, gradeLabel, isBoss }
        Framework.GetPlayerName(src)
        Framework.PlayerIdentifier(src)
]]

Framework = Framework or {}

local function present(name) return GetResourceState(name) == 'started' end

local function detect()
    local want = (Config and Config.framework) or 'auto'
    if want ~= 'auto' then return want end
    -- qbx_core provide-a 'qb-core', por isso testa-se primeiro.
    if present('qbx_core')    then return 'qbx' end
    if present('qb-core')     then return 'qb'  end
    if present('es_extended') then return 'esx' end
    return 'esx'
end

Framework.Name  = detect()
Framework.IsESX = Framework.Name == 'esx'
Framework.IsQB  = Framework.Name == 'qb'
Framework.IsQBX = Framework.Name == 'qbx'

local ESX, QBCore, QBX
if IsDuplicityVersion() then
    if Framework.IsESX then
        ESX = exports.es_extended and exports.es_extended:getSharedObject()
    elseif Framework.IsQB then
        QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject()
    elseif Framework.IsQBX then
        QBX = exports.qbx_core
    end
end

local function esxPlayer(src) return ESX    and ESX.GetPlayerFromId(src) end
local function qbPlayer(src)  return QBCore and QBCore.Functions.GetPlayer(src) end
local function qbxPlayer(src) return QBX    and QBX:GetPlayer(src) end

function Framework.GetPlayerJob(src)
    if Framework.IsESX then
        local p = esxPlayer(src); if not p then return nil end
        local j = p.job or {}
        local g = tonumber(j.grade) or 0
        return {
            job        = j.name or 'unemployed',
            label      = j.label or 'Unemployed',
            grade      = g,
            gradeLabel = j.grade_label or ('Grade ' .. g),
            isBoss     = g >= 4,
        }
    end
    local p = Framework.IsQB and qbPlayer(src) or qbxPlayer(src)
    if not p or not p.PlayerData then return nil end
    local j = p.PlayerData.job or {}
    local grade = j.grade or {}
    return {
        job        = j.name or 'unemployed',
        label      = j.label or 'Unemployed',
        grade      = tonumber(grade.level) or 0,
        gradeLabel = grade.name or '',
        isBoss     = j.isboss == true,
    }
end

function Framework.GetPlayerName(src)
    if Framework.IsESX then
        local p = esxPlayer(src)
        if p then return (p.getName and p.getName()) or p.name end
    else
        local p = Framework.IsQB and qbPlayer(src) or qbxPlayer(src)
        local ci = p and p.PlayerData and p.PlayerData.charinfo
        if ci then return ('%s %s'):format(ci.firstname or '', ci.lastname or '') end
    end
    return GetPlayerName(src) or ('Player ' .. tostring(src))
end

function Framework.PlayerIdentifier(src)
    if Framework.IsESX then
        local p = esxPlayer(src); return p and p.identifier or nil
    end
    local p = Framework.IsQB and qbPlayer(src) or qbxPlayer(src)
    return p and p.PlayerData and p.PlayerData.citizenid or nil
end

--- Pode escrever no quadro?
function Framework.CanWrite(job)
    if not job then return false end
    return Config.access.jobs[job.job] == true
end

--- Pode apagar tudo / trancar / mexer no que os outros escreveram?
function Framework.IsSupervisor(job)
    if not Framework.CanWrite(job) then return false end
    if job.isBoss then return true end
    return (job.grade or 0) >= (Config.access.supervisorGrade or 3)
end

return Framework
