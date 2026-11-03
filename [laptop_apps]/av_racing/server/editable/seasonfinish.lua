Config = Config or {}
Config.ResetCrewsAtSeasonEnd = true -- resets crews wins at season end, you can set it to false if you want to keep crews wins between seasons
Config.SeasonRewards = true -- true/false give money rewards for top racers at the end of the season
Config.TopRacersRewards = { -- Rewards for the top racers of the season
    -- Can I give items instead of money? 
    -- Short answer is No, we can't give items to offline players, inventories scripts doesn't support this
    -- Only prizes the script supports are money and vehicles
    [1] = { -- 1st place
        type = "vehicle", -- type can be "money" or "vehicle"
        prize = "coquette4", -- if using money the account name, for vehicles the vehicle model
        message = "You won an Invertero Coquette D10, you can find it at Pillbox Garage" -- msg for player
    },
    [2] = { -- 2nd place
        type = "money", -- type can be "money" or "vehicle"
        prize = "cosmo", -- if using money the account name, for vehicles the vehicle model
        amount = 1000, -- money to add, for vehicles is always 1
        message = "You received 1,000 Cosmo for finishing 2nd place last season." -- msg for player
    },
    [3] = { -- 3rd place
        type = "money", -- type can be "money" or "vehicle"
        prize = "cosmo", -- if using money the account name, for vehicles the vehicle model
        amount = 500, -- money to add, for vehicles is always 1
        message = "You received 500 Cosmo for finishing 3rd place last season." -- msg for player
    },
}

-- This function is triggered to reward the top 3 racers when a season ends, it receives the following parameters:
--[[
    position:number Racer position (1, 2 or 3)
    racer:table which contains = {
        identifier:string = racer framework identifier,
        name:string = racer nickname,
        elo:number = racer season elo
    },
    season:number = current season (just in case u need it)
]]
function addSeasonReward(position, racer, season)
    local identifier = racer and racer['identifier'] or false
    dbug('addSeasonReward(position, identifier, season)', position, identifier or "N/A", season)
    if not position or not identifier then
        warn('addReward received a null value (?)')
        return
    end
    local reward = Config.TopRacersRewards[position]
    if reward then
        if reward['type'] == "vehicle" then
            addVehicle(identifier, reward['prize'])
        end
        if reward['type'] == "money" then
            local playerId = exports['av_laptop']:getSourceByIdentifier(identifier)
            if playerId then
                exports['av_laptop']:addMoney(playerId, reward['prize'], reward['amount'])
            else
                exports['av_laptop']:addMoneyOffline(identifier, reward['prize'], reward['amount'])
            end
        end
        addNotification(identifier,reward['message'])
    else
        warn("Missing reward config for position:", position)
    end
end