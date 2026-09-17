if Config.Framework ~= 'standalone' then return end

function Fr.GetPlayerJob()
    return { name = 'mechanic', grade = 4, label = 'Mechanic' }
end

function Fr.HasJob(jobName, minGrade)
    local job = Fr.GetPlayerJob()
    if not job or job.name ~= jobName then
        return false
    end
    return (job.grade or 0) >= (minGrade or 0)
end

function Fr.GetPlayerName()
    return GetPlayerName(PlayerId()) or 'Unknown'
end

if OPM and OPM.Utils and OPM.Utils.Debug then
    OPM.Utils.Debug('Using standalone client framework')
end