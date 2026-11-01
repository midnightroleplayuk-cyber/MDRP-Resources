Config = Config or {}

-- Minimum checkpoints required to consider the race valid for Elo calculations
Config.MinCheckpoints = 50
-- Minimum number of racers required in the lobby to enable Elo rewards/penalties
Config.MinEloRacers = 10
-- Minimum base Elo reward guaranteed for a race
Config.MinElo = 5
-- Maximum base Elo reward cap for a race
Config.MaxElo = 250
-- Maximum amount of Elo a player can lose in a single race
Config.MaxEloPenalty = 50
-- Positions at or above this number will start losing Elo (e.g., 4th place and below)
Config.RemoveEloAfter = 4

--[[
    Percentage of baseReward each position receives.
    Add or remove positions as needed.
    Positions not listed here receive 0 elo (neutral before RemoveEloAfter kicks in).
]]
Config.EloPositions = {
    [1] = 1.0, -- 100% 1st place
    [2] = 0.6, -- 60% 2nd place
    [3] = 0.3, -- 30% 3rd place
}

--[[
    Calculates rewards based on the lobby's average Elo, clamped by Min/Max limits.
    Returns a table keyed by position, plus averageElo and baseReward.
]]
function getEloTable(racersEloTable)
    local totalLobbyElo = 0
    local racerCount = 0
    local minElo = Config.MinElo or 5
    local maxElo = Config.MaxElo or 250
    local divisor = 10
    for _, racer in pairs(racersEloTable) do
        local elo = racer['elo'] and tonumber(racer['elo']) or 0
        totalLobbyElo = totalLobbyElo + elo
        racerCount = racerCount + 1
    end
    local averageElo = racerCount > 0 and (totalLobbyElo / racerCount) or 0
    local baseReward = math.max(minElo, math.min(maxElo, averageElo / divisor))
    local rewards = {}
    for position, factor in pairs(Config.EloPositions) do
        rewards[position] = Round(baseReward * factor)
    end
    dbug('getEloTable(rewards, average, base)', rewards, averageElo, baseReward)
    return rewards, averageElo, baseReward
end

function getWinnerReward(rewards, position)
    return rewards[position] or 0
end

function getLoserPenalty(baseReward, position, totalRacers)
    if position <= Config.RemoveEloAfter then return 0 end
    local maxWinPosition = 0
    for pos in pairs(Config.EloPositions) do
        if pos > maxWinPosition then maxWinPosition = pos end
    end
    local losersCount = totalRacers - maxWinPosition
    if losersCount <= 0 then return 0 end
    local relativePosition = position - maxWinPosition
    local penaltyFactor = relativePosition / losersCount
    local penalty = Round(baseReward * penaltyFactor)
    local maxPenalty = Config.MaxEloPenalty or 50
    return math.min(penalty, maxPenalty)
end