Framework = Framework or {};

CreateThread(function()
    if Config.Framework ~= 'esx' then
        return
    end

    function Framework:getCore()
        return exports['es_extended']:getSharedObject();
    end

    local ESX = Framework:getCore();

    function Framework:getCharacterIdentifier()
        return ESX.GetPlayerData().identifier
    end

    function Framework:Notify(message)
        ESX.ShowNotification(message)
    end

    function Framework:isPlayerDead()
        local isDead = false

        if GetEntityHealth(PlayerPedId()) >= 1 then
            isDead = true
        end

        return isDead
    end

    function Framework:isCurrentJob(jobName)
        local isJob = false
        local playerData = ESX.GetPlayerData()

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

    function Framework:onCancelAnimation()
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

    RegisterNetEvent('esx:playerLoaded', function()
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
