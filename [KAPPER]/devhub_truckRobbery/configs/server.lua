Config = {}

Config.MaxTaskTime = 20 -- 20min
Config.PersonalCooldownTime = 10 -- 10min
Config.AmountOfItemsToPickup = 5 -- Amount of items to pickup until you can collect rewards from crime traders app

function TriggerAlarm(source, coords)
    -- TODO implement your police call logic here (server side) or go to configs/client.lua to implement it client side
end

Config.DevHubSkillTreeEnabled = false --https://store.devhub.gg/product/6438994 Enable skill tree rewards for house robberies
Config.SkillTreeXP = {
    {
        uid = "laptop", -- crime traders skill tree
        amount = 25, -- how much xp you get
    }
}

Shared.MinPolice = 0 -- Minimum police required to start a truck robbery mission