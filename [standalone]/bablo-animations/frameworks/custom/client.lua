Framework = Framework or {};

CreateThread(function()
    local identifier

    if Config.Framework ~= 'standalone' then
        return
    end

    function Framework:getCharacterIdentifier()
        if not identifier then
            local callback = TriggerServerCallback({
                eventName = eventName .. 'server:getIdentifier',
                args = {}
            })

            if callback.status then
                identifier = callback.identifier
            else
                Trace('Failed to get identifier')

                identifier = nil
            end
        end

        return identifier
    end

    function Framework:Notify(message)
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, true)
    end

    function Framework:isPlayerDead()
        local isDead = false

        if GetEntityHealth(PlayerPedId()) >= 1 then
            isDead = true
        end

        return isDead
    end

    function Framework:isCurrentJob(jobName)
        return false
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

    if IsResourceStartedOrStarting("spawnmanager") then
        RegisterNetEvent('playerSpawned', function()
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
    else
        Citizen.CreateThread(function()
            Citizen.Wait(5000)

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
    end
end)
