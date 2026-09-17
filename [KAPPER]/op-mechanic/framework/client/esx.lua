if Config.Framework ~= 'esx' then return end

CreateThread(function()
    while not Framework do
        local ok, obj = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok and obj then
            Framework = obj
        end
        Wait(100)
    end
end)

function Fr.GetPlayerJob()
    if not Framework then return { name = 'unemployed', grade = 0, label = 'Unemployed' } end
    local data = Framework.GetPlayerData()
    local job = data and data.job or {}
    return {
        name = job.name or 'unemployed',
        grade = job.grade or 0,
        label = job.label or job.name or 'Unemployed',
    }
end