if not Config.Modules['IdleAnimations'] then return end

local idleTimeout = 30000
local checkInterval = 500
local animName = "idle"

local isIdlePlaying = false
local lastActionTime = GetGameTimer()

local CanPerformIdleAction = function()
    local blockedAnims = {
        {
            'anim@gangops@morgue@table@',
            'body_search'
        }
    }

    for _, anim in ipairs(blockedAnims) do
        if IsEntityPlayingAnim(cache.ped, anim[1], anim[2], 3) then
            return false
        end
    end

    return true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(checkInterval)

        if Main and Main.disableModules then
            if isIdlePlaying then
                ClearPedTasks(cache.ped)
                isIdlePlaying = false
            end
            goto continue
        end

        local playerPed = cache.ped
        local playerId = PlayerId()
        local inVehicle = IsPedInAnyVehicle(playerPed, false)
        if CanPerformIdleAction() then
            if isIdlePlaying and not inVehicle and (IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)) then
                ClearPedTasks(playerPed)
                isIdlePlaying = false
            end

            if isIdlePlaying and inVehicle then
                isIdlePlaying = false
            end

            if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not inVehicle and not CanPerformIdleAction() then
                if IsControlPressed(0, 32) or
                    IsControlPressed(0, 33) or
                    IsControlPressed(0, 34) or
                    IsControlPressed(0, 35) or
                    IsControlJustPressed(0, 22) or
                    IsPlayerFreeAiming(playerId) or
                    IsPedShooting(playerPed) or
                    (GetFollowPedCamViewMode() ~= 4 and (IsControlPressed(1, 241) or IsControlPressed(1, 242)))
                then
                    lastActionTime = GetGameTimer()
                    if isIdlePlaying then
                        ClearPedTasks(playerPed)
                        isIdlePlaying = false
                    end
                else
                    if GetGameTimer() - lastActionTime > idleTimeout then
                        if not isIdlePlaying then
                            local canPlayIdle = true

                            if GetLocalStateBag('isInAnimation') then
                                canPlayIdle = false
                            end

                            if IsPedInAnyVehicle(playerPed, false) or
                                IsPedUsingAnyScenario(playerPed) or
                                IsPedRagdoll(playerPed) or
                                IsPedFalling(playerPed) or
                                IsPedDucking(playerPed) or
                                GetPedStealthMovement(playerPed)
                            then
                                canPlayIdle = false
                            end

                            if canPlayIdle then
                                local model = GetEntityModel(playerPed)
                                local animDict = "move_m@generic_idles@std"
                                if model == GetHashKey("mp_f_freemode_01") then
                                    animDict = "move_f@generic_idles@std"
                                end

                                RequestAnimDict(animDict)
                                local attempts = 0
                                while not HasAnimDictLoaded(animDict) and attempts < 10 do
                                    Citizen.Wait(100)
                                    attempts = attempts + 1
                                end

                                if HasAnimDictLoaded(animDict) then
                                    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
                                    isIdlePlaying = true
                                end
                            end
                        end
                    end
                end
            else
                if isIdlePlaying then
                    isIdlePlaying = false
                end
                lastActionTime = GetGameTimer()
            end
        end
        ::continue::
    end
end)