local PlayerJob = nil

function updateJob(job)
    PlayerJob = job
end

function isCop()
    if not PlayerJob then refreshJob() end
    for _, name in pairs(Config.PoliceJobs) do
        if PlayerJob and (PlayerJob.name == name or PlayerJob.type == name) then
            return true
        end
    end
    return false
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
end