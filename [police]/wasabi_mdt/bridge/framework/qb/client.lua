if not GetResourceState('qb-core'):find('start') then return end
if GetResourceState('qbx_core'):find('start') then return end

local QBCore = exports['qb-core']:GetCoreObject()

local bridge = {}

bridge.framework = 'qb'

function bridge.getGender()
    local data = QBCore.Functions.GetPlayerData()
    local gender = data and data.charinfo and data.charinfo.gender
    return gender == 1 and 'female' or 'male'
end

function bridge.getJob()
    local data = QBCore.Functions.GetPlayerData()
    if not data or not data.job then return nil end
    return {
        name = data.job.name,
        label = data.job.label or data.job.name,
        grade = data.job.grade.level,
        gradeLabel = data.job.grade.name or ('Grade ' .. data.job.grade.level),
        onDuty = data.job.onduty,
    }
end

function bridge.hasGroup(filter)
    local data = QBCore.Functions.GetPlayerData()
    if not data or not data.job then return false end
    local jobName = data.job.name
    if type(filter) == 'string' then return jobName == filter end
    if type(filter) == 'table' then
        for i = 1, #filter do
            if jobName == filter[i] then return true end
        end
    end
    return false
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('wasabi_mdt:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    TriggerEvent('wasabi_mdt:setJob', {
        name = job.name,
        label = job.label or job.name,
        grade = job.grade.level,
        gradeLabel = job.grade.name or ('Grade ' .. job.grade.level),
        onDuty = job.onduty,
    })
end)

Modules.register('bridge', bridge)
