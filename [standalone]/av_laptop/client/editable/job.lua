PlayerJob = nil

function updateJob(job)
    PlayerJob = job
    TriggerEvent('av_laptop:jobUpdate', PlayerJob)
end

function refreshJob()
    while not Core do Wait(10) end
    if Config.Framework == "esx" then
        PlayerJob = Core.GetPlayerData().job
    end
    if Config.Framework == "qb" then
        Core.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
        end)
    end
    if Config.Framework == "qbox" then
        PlayerJob = QBX.PlayerData.job
    end
    return PlayerJob
end

function getGrade()
    if not PlayerJob then refreshJob() end
    if Config.Framework == "esx" then
        return PlayerJob and PlayerJob.grade
    end
    if Config.Framework == "qb" or Config.Framework == "qbox" then
        return PlayerJob.grade.level
    end
    return 0
end