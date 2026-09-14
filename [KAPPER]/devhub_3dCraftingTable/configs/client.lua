Config = {}
  
-- Enable developer command like /tablegenerator
Config.DeveloperMode = true 

-- Skill boosts configuration - these will apply when using the skill tree integration
-- Possible attributes:
-- "double_xp" - x% chance to get double XP from crafting
-- "xp_multiplier" - x% multiplier to XP gain
-- "double_reward" - x% chance to get double rewards
-- "needed_items_recover" - x% chance to get 50% of needed items back after crafting
Config.SkillTreeBoosts = {
    ["table_boost1"] = { -- skill uid from your skill tree
        attribute = "double_xp"
    },
    ["table_boost2"] = {
        attribute = "xp_multiplier"
    },
    ["table_boost3"] = {
        attribute = "double_reward"
    },
    ["table_boost4"] = {
        attribute = "needed_items_recover"
    }
}

Config.UseTableTargetText = "Use Table"

-- How often to check if player is near a crafting table (in milliseconds)
Config.TablesCheckInterval = 2000 

-- Sound volume for all crafting effects (0.0 - 1.0)
Config.SoundVolume = 0.5 

-- Camera position configuration for different table models
-- This controls the camera view when interacting with crafting tables
Config.CameraOffsets = {
    [`dh_alchemy_table`] = {
        cameraAimOffset = vec3(0.3, 0.0, 0.0), -- Where camera is pointing (relative to table)
        cameraOffset = vec3(0.3, -2.0, 1.75),  -- Camera position (relative to table)
    },
    [`h4_prop_h4_table_isl_01a`] = {
        cameraAimOffset = vec3(0.0, 0.0, 0.0),
        cameraOffset = vec3(0.3, -2.5, 2.6),
    },
    [`bkr_prop_weed_table_01b`] = {
        cameraAimOffset = vec3(0.0, 0.0, 0.0),
        cameraOffset = vec3(0.0, -2.0, 2.2),
    },
}

