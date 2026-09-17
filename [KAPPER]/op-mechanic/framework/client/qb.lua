if Config.Framework ~= 'qb' then return end
if GetResourceState('qbx_core') == 'started' then return end

CreateThread(function()
    while not Framework do
        local ok, obj = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and obj then
            Framework = obj
        end
        Wait(100)
    end
end)

function Fr.GetPlayerJob()
    if not Framework then return { name = 'unemployed', grade = 0, label = 'Unemployed' } end
    local data = Framework.Functions.GetPlayerData()
    local job = data and data.job or {}
    return {
        name = job.name or 'unemployed',
        grade = job.grade and job.grade.level or job.grade or 0,
        label = job.label or job.name or 'Unemployed',
    }
end