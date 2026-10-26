Framework = Framework or {}

CreateThread(function()
    if Config.Framework ~= 'qbcore' then
        return
    end

    function Framework:getCore()
        return exports['qb-core']:GetCoreObject()
    end

    local QBCore = Framework:getCore()

    function Framework:getCharacterIdentifier()
        return QBCore.Functions.GetPlayerData().citizenid
    end

    function Framework:Notify(message)
        QBCore.Functions.Notify(message)
    end

    function Framework:isPlayerDead()
        local isDead, playerData = false, QBCore.Functions.GetPlayerData()

        if not playerData.metadata['isdead']
            and not playerData.metadata['inlaststand']
            and not playerData.metadata['ishandcuffed']
            and not IsPauseMenuActive() then
            isDead = true
        end

        return isDead
    end

    function Framework:isCurrentJob(jobName)
        local isJob, playerData = false, QBCore.Functions.GetPlayerData()

        if playerData and playerData.job.name == jobName then
            isJob = true
        end

        return isJob
    end

    function Framework:canOpenMenu()
        -- Add your custom logic here

        return true
    end

    function Framework:canPlayAnimation(animationName)
        -- Add your custom logic here

        return true
    end

    function Framework:onPlayAnimation(animationName)
        -- Add your custom logic here
    end

    function Framework:onCancelAnimation(animationName)
        -- Add your custom logic here
    end

    function Framework:canCancelAnimation()
        -- Add your custom logic here
        return true
    end

    function Framework:canAcceptAnimationRequest(animationName)
        -- Add your custom logic here
        return true
    end

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        Citizen.Wait(3000)

        while not Main.NUIReady do
            Citizen.Wait(100)
        end

        Main:Init()

        Citizen.Wait(2000)

        local animationData, isNew = Main:getCache()

        if not isNew then
            Main:playAnimation(cache.ped, animationData.walkingstyle or nil, false, true)
            Main:playAnimation(cache.ped, animationData.expression or nil, false, true)
            Main:playAnimation(cache.ped, animationData.weaponstyle or nil, false, true)
        end
    end)
end)
