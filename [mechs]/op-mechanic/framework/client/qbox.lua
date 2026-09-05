if Config.Framework ~= 'qbox' then return end

function Fr.GetPlayerJob()
    local ok, player = pcall(function()
        return exports.qbx_core:GetPlayerData()
    end)
    if not ok or not player then
        return { name = 'unemployed', grade = 0, label = 'Unemployed' }
    end
    local job = player.job or {}
    return {
        name = job.name or 'unemployed',
        grade = job.grade and job.grade.level or job.grade or 0,
        label = job.label or job.name or 'Unemployed',
    }
end