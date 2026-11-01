-- You can use this functions to reward extra prizes to racers and XP
local minRacersForExtraPrize = 6 -- Min racers needed in the event to give this extra prizes, prevents solo farmers
local enablePrizes = false -- true/false Enable this extra prizes settings
local prizePositions = {
    [1] = {prize = 100, accountName = "cosmo"},
    [2] = {prize = 50, accountName = "cosmo"},
    [3] = {prize = 20, accountName = "cosmo"},
}
local minRacersForXP = 1 -- Min racers needed to reward XP, prevents solo farmers
local baseXP = 5 -- base XP a racer will receive after completing a race, this doesn't apply for positions table
local xpPositions = { -- Will reward a random amount between min and max
    [1] = {min = 20, max = 30},
    [2] = {min = 15, max = 20},
    [3] = {min = 10, max = 15},
    [4] = {min = 5, max = 10},
}

-- This function is triggered when a racer finishes a race
--[[
    src: number = player server ID
    identifier:string = player framework identifier (citizenid)
    position:number = racer position
    raceId:string = race unique identifier, use it to access the event info using local eventData = allEvents[raceId]
]]--
function FinishedRace(src,identifier,position,raceId)
    local eventData = allEvents[raceId]

    if enablePrizes then
        if prizePositions[tonumber(position)] and (eventData and allEvents[raceId]['numRacers'] >= minRacersForExtraPrize) then
            exports['av_laptop']:addMoney(tonumber(src), prizePositions[tonumber(position)]['accountName'], prizePositions[tonumber(position)]['prize'])
        end
    end
    -- This gives XP to racer, is enabled by default:
    if (eventData and allEvents[raceId]['numRacers'] >= minRacersForXP) then
        if xpPositions[tonumber(position)] then
            local toAdd = math.random(xpPositions[tonumber(position)]['min'], xpPositions[tonumber(position)]['max'])
            addXP(src, toAdd)
        else
            -- Adds default XP
            addXP(src, baseXP)
        end
    end
end

-- This function gets triggered when a race is started, receives the race id
function RaceStarted(raceId)
    local raceData = allEvents[raceId]
    if raceData then
        -- print(json.encode(raceData, {indent = true}))
    end
end

-- This function gets triggered after race ends and right before it gets wipped
function ReadyToWipe(raceId)
    local raceData = allEvents[raceId]
    if raceData then
        -- print(json.encode(raceData, {indent = true}))
    end
end