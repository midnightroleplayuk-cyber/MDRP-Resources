while Framework == nil do Wait(5) end

local DEFAULT_DEATH_STATE_KEYS = {
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

local function getDeathStateKeys()
    if Config.Rope and type(Config.Rope.DeathStateKeys) == 'table' and #Config.Rope.DeathStateKeys > 0 then
        return Config.Rope.DeathStateKeys
    end
    return DEFAULT_DEATH_STATE_KEYS
end

local function isPlayerStateDead(playerId)
    local ply = Player(playerId)
    if not ply or not ply.state then return false end

    for _, key in ipairs(getDeathStateKeys()) do
        local value = ply.state[key]
        if value == true or value == 1 then
            return true
        end
    end

    return false
end

local function isPlayerPedDead(playerId)
    local ped = GetPlayerPed(playerId)
    if not ped or ped == 0 then return false end

    local health = GetEntityHealth(ped)
    if health and health > 0 and health <= 101 then
        return true
    end

    return false
end

function OpCrimeIsPlayerDead(playerId)
    playerId = tonumber(playerId)
    if not playerId or playerId <= 0 then return false end

    if Fr.IsPlayerDead and Fr.IsPlayerDead(playerId) then
        return true
    end

    if isPlayerStateDead(playerId) then
        return true
    end

    if isPlayerPedDead(playerId) then
        return true
    end

    return false
end