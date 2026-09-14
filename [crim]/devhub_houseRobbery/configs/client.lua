Config = {} 

-- Default location to teleport players to if they are in a house area without permission
Config.DefaultLocation = vec3(215.1511, -805.2712, 30.8125)

Config.ForceResetLocation = true -- Force reset players to default location if they are in a house area without permission

function TriggerAlarm(coords)
    -- TODO implement your police call logic here (client side) or go to configs/server.lua to implement it server side
end

-- Lockpick minigame configuration
Config.LockpickMinigame = {
    useCustom = false, -- Set to true to use custom minigame function below
}

-- Custom lockpick minigame function
-- @param tier string - House tier ("tier1", "tier2", "tier3")
-- @return boolean - true if minigame was successful, false if failed
function Config.CustomLockpickMinigame(tier)
    -- Example implementation:
    -- You can use any minigame here based on tier
    -- tier1 = easy, tier2 = medium, tier3 = hard
    
    -- Example with ox_lib:
    local difficulty = tier == "tier1" and "easy" or tier == "tier2" and "medium" or "hard"
    return lib.skillCheck(difficulty)
    
end
