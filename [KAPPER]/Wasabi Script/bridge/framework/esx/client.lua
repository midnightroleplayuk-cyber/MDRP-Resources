if not GetResourceState('es_extended'):find('start') then return end

local ESX = exports['es_extended']:getSharedObject()

---@class BridgeClient
local bridge = {}

bridge.framework = 'esx'

function bridge.getGender()
    local data = ESX.GetPlayerData()
    local sex = data and data.sex
    return (sex == 1 or sex == 'f') and 'female' or 'male'
end

function bridge.getJob()
    local data = ESX.GetPlayerData()
    if not data or not data.job then return nil end
    return {
        name = data.job.name,
        label = data.job.label or data.job.name,
        grade = data.job.grade,
        gradeLabel = data.job.grade_label or data.job.grade_name or ('Grade ' .. data.job.grade),
        onDuty = data.job.onDuty ~= false,
    }
end

function bridge.hasGroup(filter)
    local data = ESX.GetPlayerData()
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

RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('wasabi_mdt:playerLoaded')
end)

RegisterNetEvent('esx:setJob', function(job)
    TriggerEvent('wasabi_mdt:setJob', {
        name = job.name,
        label = job.label or job.name,
        grade = job.grade,
        gradeLabel = job.grade_label or job.grade_name or ('Grade ' .. job.grade),
        onDuty = job.onDuty ~= false,
    })
end)

Modules.register('bridge', bridge)
