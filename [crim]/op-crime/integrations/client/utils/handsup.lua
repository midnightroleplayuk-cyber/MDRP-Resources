handsupDictonary = "random@mugging3"
handsupAnimation = "handsup_standing_base"
handsup = false

local targetDeathStatusCache = {}
local DEFAULT_CLIENT_DEATH_STATE_KEYS = {
    'dead',
    'isDead',
    'isdead',
    'InLaststand',
    'inlaststand',
    'isInLaststand',
    'incoma',
    'isDown',
    'isUnconscious',
}

local function getDeathCheckCacheMs()
    if Config.Rope and tonumber(Config.Rope.DeathCheckCacheMs) then
        return tonumber(Config.Rope.DeathCheckCacheMs)
    end
    return 5000
end

local function getClientDeathStateKeys()
    if Config.Rope and type(Config.Rope.DeathStateKeys) == 'table' and #Config.Rope.DeathStateKeys > 0 then
        return Config.Rope.DeathStateKeys
    end
    return DEFAULT_CLIENT_DEATH_STATE_KEYS
end

local function isTargetStateDead(playerId)
    local ply = Player(playerId)
    if not ply or not ply.state then return false end

    for _, key in ipairs(getClientDeathStateKeys()) do
        local value = ply.state[key]
        if value == true or value == 1 then
            return true
        end
    end

    return false
end

local function isPlayingConfiguredDeathAnim(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false end

    local animations = Config.Rope and Config.Rope.DeathAnimations
    if type(animations) ~= 'table' then return false end

    for _, anim in ipairs(animations) do
        if anim.dict and anim.clip and IsEntityPlayingAnim(ped, anim.dict, anim.clip, 3) then
            return true
        end
    end

    return false
end

function hasHandsUp(id, ped)
    return IsEntityPlayingAnim(ped, handsupDictonary, handsupAnimation, 3)
end

function isCuffed(id)
    return GlobalState.handcuffedPlayers[tostring(id)]
end

function isPedDead(Ped)
    if not Ped or Ped == 0 or not DoesEntityExist(Ped) then return false end

    if IsEntityDead(Ped) or IsPedDeadOrDying(Ped, true) then return true end

    local health = GetEntityHealth(Ped)
    if health and health > 0 and health <= 101 then
        return true
    end

    if isPlayingConfiguredDeathAnim(Ped) then
        return true
    end

    return false
end

function getCachedTargetDeathStatus(playerId)
    local entry = targetDeathStatusCache[tostring(playerId)]
    if entry and GetGameTimer() < entry.expires then
        return entry.dead
    end
    return nil
end

function setCachedTargetDeathStatus(playerId, dead)
    targetDeathStatusCache[tostring(playerId)] = {
        dead = dead == true,
        expires = GetGameTimer() + getDeathCheckCacheMs(),
    }
end

function fetchTargetDeathStatus(playerId, cb)
    local cached = getCachedTargetDeathStatus(playerId)
    if cached ~= nil then
        return cb(cached)
    end

    Fr.TriggerServerCallback('op-crime:checkDeathStatus', function(dead)
        local isDead = dead == true
        setCachedTargetDeathStatus(playerId, isDead)
        cb(isDead)
    end, playerId)
end

function prefetchTargetDeathStatus(playerId)
    if not playerId then return end
    if getCachedTargetDeathStatus(playerId) ~= nil then return end
    fetchTargetDeathStatus(playerId, function() end)
end

function prefetchClosestTargetDeathStatus(maxDistance)
    if type(GetClosestPed) ~= 'function' then return end

    local closestPed, closestDistance = GetClosestPed()
    local limit = maxDistance or 3.0
    if closestPed == -1 or closestDistance > limit then return end
    if not IsPedAPlayer(closestPed) then return end

    local player = NetworkGetPlayerIndexFromPed(closestPed)
    if not player then return end

    prefetchTargetDeathStatus(GetPlayerServerId(player))
end

function isTargetConsideredDead(playerId, ped, serverDead)
    if serverDead == true then return true end
    if isTargetStateDead(playerId) then return true end
    if ped and isPedDead(ped) then return true end
    return false
end

function canRestrainTarget(playerId, ped, cb)
    fetchTargetDeathStatus(playerId, function(serverDead)
        local dead = isTargetConsideredDead(playerId, ped, serverDead)
        local canTie = dead
            or hasHandsUp(playerId, ped)
            or IsEntityPlayingAnim(ped, handsupDictonary, handsupAnimation, 3)
            or IsPedCuffed(ped)
            or isCuffed(playerId)
            or IsPedBeingStunned(ped)

        cb(canTie, dead)
    end)
end

function isTargetRestrainedOrDead(playerId, ped, cb)
    fetchTargetDeathStatus(playerId, function(serverDead)
        local dead = isTargetConsideredDead(playerId, ped, serverDead)
        cb(dead or IsPedCuffed(ped) or isCuffed(playerId))
    end)
end

function ToggleHands()
    local playerPed = PlayerPedId()
    if isHandcuffed then return end
    if GetVehiclePedIsEntering(playerPed) == 0 and not IsPedReloading(playerPed) then
        handsup = not handsup
    end

    if handsup then 
        Citizen.CreateThread(function()
            while handsup and not isHandcuffed do
                local playerPed = PlayerPedId()
                if IsPedRagdoll(playerPed) or GetEntityHealth(playerPed) <= 0 then 
                    handsup = false
                end

                lockActions(playerPed, true)
                if IsPedInAnyVehicle(playerPed, false) then DisableControlAction(0, 59, true) end

                if not IsEntityPlayingAnim(playerPed, handsupDictonary, handsupAnimation, 3) then
                    RequestAnimDict(handsupDictonary)
                    while not HasAnimDictLoaded(handsupDictonary) do
                        Wait(100)
                    end
                    TaskPlayAnim(PlayerPedId(), handsupDictonary, handsupAnimation, 8.0, 8.0, -1, 50, 0, false, false, false)
                end

                Wait(0)
            end
        end)
    else
        if IsEntityPlayingAnim(playerPed, handsupDictonary, handsupAnimation, 3) then
            lockActions(playerPed, false)
            ClearPedTasks(playerPed)
        end
    end
end

function lockActions(ped, state)
    DisableControlAction(0, 45, state)
    DisableControlAction(0, 25, state) 
    DisableControlAction(0, 24, state)
    DisableControlAction(0, 141, state)
    DisableControlAction(0, 37, state) 
    DisableControlAction(0, 142, state) 
    DisableControlAction(0, 140, state) 
    DisablePlayerFiring(ped, state)
end

Citizen.CreateThread(function()
    if not Config.Rope.Enable then return end
    RegisterKeyMapping('handsup', "Hands Up", 'keyboard', "X")
    RegisterCommand('handsup', function() ToggleHands() end)
end)

Citizen.CreateThread(function()
    if not Config.Rope.Enable then return end

    while true do
        Wait(getDeathCheckCacheMs())
        if type(GetClosestPed) == 'function' then
            prefetchClosestTargetDeathStatus(3.0)
        end
    end
end)