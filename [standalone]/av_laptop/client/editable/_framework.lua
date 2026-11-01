-- Events needed to run checks when a player login, logout or change job

-- For QBCore:
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- Triggered when a player spawns
    if Config.Framework == "qb" then
        local player = Core.Functions.GetPlayerData()
        updateJob(player.job)
    else
        updateJob(QBX.PlayerData.job)
    end
    TriggerEvent("av_laptop:loaded") -- notify other apps
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) -- Triggered when a player job is updated
    updateJob(JobInfo)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() -- Triggered when a player logout
    updateJob({})
    TriggerEvent("av_laptop:unload") -- notify other apps
end)

-- QBox
RegisterNetEvent('qbx_core:client:playerLoggedOut', function() 
    updateJob({})
    TriggerEvent("av_laptop:unload") -- notify other apps
end)

-- For ESX:
RegisterNetEvent('esx:playerLoaded', function(xPlayer) -- Triggered when a player spawns
    updateJob(xPlayer.job)
    TriggerEvent("av_laptop:loaded") -- notify other apps
end)

RegisterNetEvent('esx:onPlayerLogout', function() -- Triggered when a player logout
    updateJob({})
    TriggerEvent("av_laptop:unload") -- notify other apps
end)

RegisterNetEvent('esx:setJob', function(job) -- Triggered when a player job is updated
    updateJob(job)
end)

AddEventHandler('onResourceStart', function(resourceName) -- run job checks if av_laptop is restarted
    if (GetCurrentResourceName() ~= resourceName) then
        checkApps(resourceName)
        return
    end
    LocalPlayer.state:set("inLaptop", false, true)
    while not Core do Wait(50) end
    if Config.Framework == "qb" then
        local player = Core.Functions.GetPlayerData()
        updateJob(player.job)
    elseif Config.Framework == "qbox" then
        local player = QBX.PlayerData.job
        updateJob(player)
    elseif Config.Framework == "esx" then
        updateJob(Core.PlayerData.job)
    end
end)