if not Config then Config = {} end

Config.MenuCommand = false -- string or false
Config.Keybind = "F7" -- string or false
Config.Item = false -- string or false | update 1.0.6
-- client event | devhub_skillTree:client:openSkillTree

Config.Theme = "modern" -- string | "legacy", "modern", "zombie", "fantasy"

Config.XpBoost = 1.0 -- float

Config.BaseXp = 100 -- int | Base xp for each level
Config.LevelBasedXp = 50 -- int | Xp increase for each level (BaseXp + (Level * LevelBasedXp))

function xpAlgorithm(level, categoryUid)
    return Config.BaseXp + (Config.LevelBasedXp * level)
end

Config.PointsPerLevel = 1 -- int | Points given for each level up

Config.CloseUiOnDeath = true -- bool | Close the UI when the player dies , disable ui while dead , must be configured in devhub_lib "dh_lib:client:setDeathStatus"

Config.HpRegenerationTimeout = 5000 -- int | If player has unlocked skill, every how many sec he should restore hp

Config.EnableGenerator = true -- bool | Enable the generator for the skill tree [ONLY EXCLUSIVE VERSION]

Config.EarnXpTick = 1000 -- int | Time in ms for each tick , check if players is doing actions from Config.EarnXp, keep it above 1000

Config.EarnXp = {
    -- if you want to disable option , just remove it
    ['running'] = {
        timeout = 10000, -- int | Timeout in ms , cooldown for receiving xp
        addTo = {
            ['personal'] = 5,
        }
    },
    ['swimming'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['melee'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['shooting'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['driving'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['climbing'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['parachuting'] = {
        timeout = 15000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['flying'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['boating'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['reloading'] = {
        timeout = 10000,
        addTo = {
            ['personal'] = 5,
        }
    },
    ['takingDamage'] = {
        timeout = 15000,
        addTo = {
            ['personal'] = 5,
        }
    },
}

Config.Debug = false -- bool | Enable debug messages

-- update 1.0.2

Config.SkillReset = { -- give the player the option to reset skills
    Enabled = false, -- bool | Enable the skill reset
    PaymentType = false, -- string , bool | Payment type ("cash" or "item", false to make it for free)
    Cash = 1000, -- int | Price for reseting the skills
    Item = {
        Name = "cash", -- string | Item name
        Amount = 1000 -- int | Amount of item
    },
    type = "reset", -- string | "reset" or "clear" , reset = reset skills but points , clear = clear skills, points, xp, level
}

-- update 1.0.4

Config.MaxLevel = {}

-- You can set up custom order for loading events on player loaded
-- Why? In database we store player data as hashmap, so we do not have control over the order of loading
-- Usually you do not need to change this, but sometimes you may want to load some events before others to make sure they overwrite some values
-- It only affect the loading order of events during first time player loading
-- First we execute events that are not in this table, after that we execute events in this table

Config.SkillLoadingOrder = {
    -- ['betterAccuracy_1'] = 1,
    -- ['betterAccuracy_2'] = 2,
    -- ['fasterReload_1'] = 3,
    -- ['fasterReload_2'] = 4,
}

-- update 1.0.9

Config.MeleeWeapons = { -- used in pre-made skills, uid: meleeDamageMultiplier
    ["weapon_hammer"] = true,
    ["weapon_wrench"] = true,
    ["weapon_stungun"] = true,
    ["weapon_nightstick"] = true,
    ["weapon_bat"] = true,
    ["weapon_bottle"] = true,
    ["weapon_flashlight"] = true,
    ["weapon_golfclub"] = true,
    ["weapon_hatchet"] = true,
    ["weapon_knuckle"] = true,
    ["weapon_crowbar"] = true,
    ["weapon_knife"] = true,
    ["weapon_machete"] = true,
    ["weapon_switchblade"] = true,
    ["weapon_battleaxe"] = true,
    ["weapon_poolcue"] = true,
    ["weapon_stone_hatchet"] = true, 
}

Config.SkillDefaultValues = { -- values that will be applied if player has not skill and is base for further calculations
    ['moreStamina'] = 100.0,
    ['moreMaxHp'] = 200,
    ['timeUnderwater'] = 10.0,
    ['feastDamageMultiplier'] = 1.0,
}

-- If you removed skill from personal category and you dont want default effect to by applied, set it to true 
-- Why only this skills? Because only this apply default value no matter if you have skill or not
-- DO NOT CHANGE THIS IF YOU HAVE NOT REMOVED A CORRESPONDING SKILL FROM "personal" CATEGORY

-- FROM UPDATE 2.2.0 this is detected automatically anything you do will be overwritten
Config.DisableDefaultSkillEffects = {}

Config.DisableRefreshOnPedOrPidChanged = false -- bool | Disable refreshing some player skills on ped change or pid change

-- update 2.0.1

Config.DisableXpEarnWhileDead = false -- bool | Disable earning xp while dead
-- To make it work you must have configured dh_lib:client:setDeathStatus inside devhub_lib

Config.UnlockHandlerForSkills = {
    -- ['CATEGORY_UID'] = { -- skill category uid
    --     ['SKILL_UID'] = {
    --         unlockRequirementMessage = 'You need to have energy drink to unlock this skill', -- string | Message shown when unlock fail and when they inspect skill in ui
    --         handler = function(source)
    --             -- this is triggered server side
    --             -- return false to prevent unlocking the skill
    --             -- to use devhub_lib core functions in here
    --             return false
    --         end
    --     },
    --     ['SKILL_UID_1,SKILL_UID_2'] = { -- multiple skills in one handler, separated by comma ","
    --         unlockRequirementMessage = 'You need to have energy drink to unlock this skill', -- string | Message shown when unlock fail and when they inspect skill in ui
    --         handler = function(source)
    --             -- this is triggered server side
    --             -- return false to prevent unlocking the skill
    --             -- to use devhub_lib core functions in here
    --             return false
    --         end
    --     },
    -- },
}

-- update 2.1.7

Config.XpCacheLimit = 15 -- int | Used for xp virtualization in all categories from Config.EarnXp, how many ticks should be cached before sending to server
-- How it works? When player earns xp, it is cached in client side and sent to server only when player has enough ticks to send

-- update 2.3.0

-- Daily XP Limit System
-- Limits how much XP a player can earn per day in each category.
-- To disable the entire system, set Config.DailyXpLimit = nil (or remove / comment out this block)
Config.DailyXpLimit = {
    ResetHour = 0, -- int (0-23) | Hour in server-local time when the daily XP resets (0 = midnight)
    Limits = {
    },
    DefaultLimit = 0, -- int | Default limit for categories not listed above (0 = unlimited)
}

-- update 3.0.0

-- Disable specific listener events for optimization
-- If no other resource listens to these events, you can disable them to reduce unnecessary network traffic
-- Each entry accepts any of these forms (normalized on load in escrowed/sh.config.lua):
--   false                            -> listener enabled (client + server fire)
--   true                             -> listener disabled (client + server suppressed)
--   { client = bool, server = bool } -> per-side control; an omitted side defaults to enabled (false)
-- Disabling a listener might break other resources/functionalities that rely on it, so only disable if you are sure no other resource uses it.
Config.DisabledListeners = {
    newXp = {client = true}, -- devhub_skillTree:client:listener:newXp (triggered every time player earns xp)
    levelUp = {client = false}, -- devhub_skillTree:client:listener:levelUp (triggered on level up)
    skillUnlocked = {client = false, server = false}, -- devhub_skillTree:client:listener:skillUnlocked & devhub_skillTree:server:listener:skillUnlocked
    skillReset = { server = false}, -- devhub_skillTree:client:listener:skillReset & devhub_skillTree:server:listener:skillReset, CLIENT event will always be enabled
    skillDegraded = {client = false, server = false}, -- devhub_skillTree:client:listener:skillDegraded & devhub_skillTree:server:listener:skillDegraded (fired when degradation hits 0)
    skillDegradedRecovered = {client = false, server = false}, -- devhub_skillTree:client:listener:skillDegradedRecovered & devhub_skillTree:server:listener:skillDegradedRecovered (fired when skill recovers from 0)
    -- Old dh_skillTree events (legacy compatibility, used in some older scripts)
    oldSkillUnlocked = {client = false}, -- dh_skillTree:client:listener:skillUnlocked (old event name)
    oldSkillReset = {client = false}, -- dh_skillTree:client:listener:skillReset (old event name)
}

-- Skill Degradation System
-- Optional per-skill mechanic. When enabled on a skill, the player must continuously earn XP to keep the skill effect active.
-- Degradation XP decreases by 'removePerCycle' every CycleInterval days. If it reaches 0, the skill effect is disabled.
-- Cycles are applied on player load based on stored timestamps and rechecked every hour for online players.
-- Any XP earned in the same category restores degradation XP by the same amount.
-- To disable the entire system, set Config.SkillDegradation = nil (or remove / comment out this block)
Config.SkillDegradation = {
    CycleInterval = 1, -- float | Default degradation cycle interval in days (1 = every 24h)
    MaxMissedCycles = 30, -- int | Max degradation cycles applied at once when a player reconnects after being offline. Example: if CycleInterval=1 and player was offline for 10 days, only 3 cycles worth of removePerCycle will be subtracted instead of 10. Prevents players from losing all degradation XP after a long break.

    -- Per-category overrides (optional). Any value set here overrides the default above for that category.
    -- Categories not listed here use the defaults.
    Categories = {},
}

-- Premium Currency System (global, not per-category)
-- Optional secondary currency required (or accepted) to unlock skills.
-- Each skill in the generator can specify a `premiumCurrency` amount.
--   type = "optional"  -> if a player pays the premium currency, regular `points` and Config.UnlockHandlerForSkills checks are SKIPPED
--   type = "required"  -> the premium currency cost is an ADDITIONAL requirement on top of points / unlock handlers
-- handler(amount, categoryUid, skillUid, source) is called server-side. It MUST:
--   - check if the player has enough currency
--   - deduct the currency if they do
--   - return true on success, false on failure (not enough currency / refused)
-- To disable the entire system, set Config.PremiumCurrency = nil
Config.PremiumCurrency = nil

-- Config.PremiumCurrency = {
--     type = "optional", -- "optional" or "required"
--     label = "PC",
--     icon = "fas fa-coin",
--     handler = function(amount, categoryUid, skillUid, source)
--         -- example using devhub_lib money:
--         -- if not Helpers.HasEnoughMoney(source, amount) then return false end
--         -- Helpers.RemoveMoney(source, amount)
--         return true
--     end,
-- }

-- Trigger events on skill unlock
-- When a skill is unlocked, these events will be triggered automatically
-- For each category, you can define per-skill event triggers
-- client: event name triggered on client with params (category, skillUid, effect)
-- server: event name triggered on server with params (source, category, skillUid, effect)
Config.TriggerOnSkillUnlock = {
    -- ['CATEGORY_UID'] = {
    --     ['SKILL_UID'] = { client = 'myResource:client:onSkillUnlock', server = 'myResource:server:onSkillUnlock' },
    -- },
}

-- Config Backup System
-- Automatic backups are created before each generator save.
-- Manual backups can be created from the admin panel.
-- When the limit is reached, the oldest backup is removed automatically.
Config.MaxBackups = 5 -- int | Maximum number of config backups to keep (0 = unlimited)
