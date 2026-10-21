Config = {}

-- Enables additional debug output via ox_lib print helpers.
Config.Debug = false

-- Locale loaded from locales/*.json.
Config.Locale = 'en'

-- Framework bridge. auto checks qbx_core, qb-core, es_extended, then standalone.
Config.Framework = 'qbox' -- auto, qbox, qb, esx, standalone

-- Inventory bridge used for item and money handling.
Config.Inventory = 'ox_inventory' -- auto, ox_inventory, qb-inventory, qs-inventory, jaksam_inventory, tgiann-inventory, esx, custom

-- Interaction system. none uses ox_lib TextUI + E fallback.
Config.Target = 'ox_target' -- auto, ox_target, qb-target, qtarget, none

-- Dispatch integration used when robbery alerts are sent.
Config.Dispatch = 'auto' -- auto, ps-dispatch, cd_dispatch, qs-dispatch, rcore_dispatch, tk_dispatch, p_mdt, qb, none, custom

-- Clerk intimidation mode: target, aim_weapon, both.
-- Target - you need to use the interaction system to intimidate the clerk.
-- Aim_weapon - you need to aim a weapon at the clerk to intimidate them. Uses a thread to check, may use more CPU ms
-- Both - you can use either method to intimidate the clerk.
Config.Clerk = {
    Enabled = true,
    IntimidationMode = 'both',
    AimCheckInterval = 500,
    AimCooldown = 5000,
    ---@type number or table<number, number> or true -- Number = one type, table = multiple types, true = any type
    RequiredWeaponDamageType = 3, -- What weapon damage type is required to intimidate the clerk, you can view weapon damage types here https://docs.fivem.net/natives/?_0x3BE0BB12D25FB305
    CodeChance = 35,
    Idle = {
        Enabled = true,
        Interval = 18000,
        Scenarios = {
            'WORLD_HUMAN_STAND_IMPATIENT',
            'WORLD_HUMAN_STAND_MOBILE',
            'WORLD_HUMAN_AA_COFFEE'
        }
    },
    SilentAlarm = {
        Enabled = true,
        Chance = 35,
        MinDelay = 2500,
        MaxDelay = 7000
    },
    Fight = {
        Enabled = true,
        Chance = 15,
        Weapon = `WEAPON_PISTOL`,
        Ammo = 60,
        Accuracy = 35,
        Armor = 0,
        CanDie = true,
        RemoveDroppedWeapon = true,
        ResetAfterTargetDeath = 10000,
        CombatAbility = 1,
        CombatMovement = 2,
        CombatRange = 2
    }
}

-- Groups that can use admin commands. Aces are granted automatically on resource start.
Config.AdminGroups = { 'admin', 'god', 'superadmin' }

-- Jobs counted as police for robbery requirements and dispatch recipients.
Config.PoliceJobs = { 'police', 'sheriff' }

-- Required online police count before a robbery action can begin.
Config.MinimumPolice = 0
-- You can configure police multiplier in config/rewards.lua

-- Controls the intended robbery order.
Config.Flow = {
    RequireClerkBeforeLoot = true, -- Requires the clerk to be intimidated/killed before the player can loot the store.
    RequireRegisterBeforeSafe = true -- Requires at least one register to be looted before the player can loot the safe.
}

-- Optional robbery session settings. TimeLimit can be false or seconds.
Config.Robbery = {
    TimeLimit = false, -- After this time limit, the robbery will fail and reset. Set to false to disable.
    ResetOnTimeout = false -- If true, the robbery will reset after the time limit is reached. If false, the robbery will continue until the player leaves the store or fails the robbery.
}

-- Distance checks used by client interactions and server reward validation.
Config.Distance = {
    Start = 3.0,
    ClerkStart = 6.0,
    Reward = 4.0,
    Cancel = 35.0
}

-- Cooldown configuration in seconds. Global can be false, true (uses StoreSeconds), or a number of seconds.
Config.Cooldown = {
    Global = false,
    StoreSeconds = 1800,
    PlayerSeconds = 900,
    FailedAttemptLimit = 3,
    FailedResetSeconds = 600,
    FailedAttemptScope = 'store' -- store, stage
}

-- Security checks. Set AllowedWeapons = true to allow every weapon.
Config.Security = {
    DropOnExploit = false,
    AlertPoliceOnStart = true,
    AlertPoliceOnSafeFail = true,
    AlertPoliceOnClerkFight = true,
    RequireWeaponForClerk = true,
    AllowedWeapons = false,
    AllowedWeapons = {
           ['WEAPON_SWITCHBLADE'] = true, 
    --     [`WEAPON_PISTOL`] = true,
    --     [`WEAPON_COMBATPISTOL`] = true,
    --     [`WEAPON_APPISTOL`] = true,
    --     [`WEAPON_SNSPISTOL`] = true,
    --     [`WEAPON_MICROSMG`] = true,
    --     [`WEAPON_SMG`] = true,
    --     [`WEAPON_PUMPSHOTGUN`] = true,
    },
}

-- Progress durations in milliseconds.
Config.Progress = {
    Intimidate = 9000,
    Register = 10000,
    Shelf = 6500,
    SafeFallback = 6500,
    SafeDrill = 9000
}

-- Built-in safe access options. Per-store safe settings override profiles, then these defaults.
Config.SafeAccess = {
    Keypad = {
        MaxAttempts = 3,
        Timeout = 30000
    },
    Drill = {
        Difficulty = 2,
        Timeout = 45000,
        MinCompletionMs = 6000
    }
}

-- Reusable profiles. Existing reward tiers and cooldowns stay independent.
Config.Profiles = {
    standard = {
        MinimumPolice = 0,
        Progress = {
            Intimidate = 9000,
            Register = 10000,
            Shelf = 6500,
            SafeFallback = 6500,
            SafeDrill = 9000
        },
        Safe = {
            Keypad = { MaxAttempts = 3, Timeout = 30000 },
            Drill = { Difficulty = 2, Timeout = 45000, MinCompletionMs = 6000 }
        },
        Clerk = {
            Fight = { Chance = 15 },
            SilentAlarm = { Enabled = true, Chance = 35, MinDelay = 2500, MaxDelay = 7000 }
        }
    }
}

-- Optional safe prop and synchronized opening scene.
Config.SafeProp = {
    Enabled = true,
    Model = `h4_prop_h4_safe_01a`,
    BagModel = `hei_p_m_bag_var22_arm_s`,
    HeadingOffset = -180.0,
    ZOffset = 0.0,
    UseNetworkScene = true,
    IdleDuration = 2600
}

-- Drill prop and animation settings used when a safe supports the drill method.
Config.SafeDrill = {
    Model = `hei_prop_heist_drill`,
    AnimDict = 'anim@heists@fleeca_bank@drilling',
    Anim = 'drill_straight_idle',
    AttachOffset = vector3(0.14, 0.0, -0.01),
    AttachRotation = vector3(90.0, -90.0, 180.0),
    CrouchDict = 'amb@medic@standing@kneel@base',
    CrouchAnim = 'base',
    CrouchFlag = 1,
    CrouchDrillFlag = 49,
    CrouchAttachOffset = vector3(0.16, 0.03, -0.04),
    CrouchAttachRotation = vector3(90.0, -80.0, 180.0)
}

-- Required items for each stage. Safe key is matched with store.safe.method.
Config.RequiredItems = {
    Register = 'lockpick',
    Shelf = nil,
    Safe = {
        lockpick = { item = 'lockpick', removeOnFailChance = 35 },
        drill = { item = 'drill', removeOnFailChance = 10 },
        thermite = { item = 'thermite', removeOnFailChance = 100 },
        keypad = nil
    }
}

-- Select which minigame is used for each robbery type.
-- Register: ox_skillcheck, lation_ui_skillcheck, lation_ui_patternlock, custom, none
-- Safe: fa_minigames, ox_input, ox_skillcheck, lation_ui_skillcheck, lation_ui_patternlock, custom, none
-- The fa_minigames safe preset selects Keypad or Drill from the configured safe method.
-- ox_input supports keypad-only safes and is also the automatic fallback when the bundled keypad cannot start.
-- Minigame difficulty, titles, keys and timing can be edited in bridge/client/minigames.lua.
Config.Minigames = {
    Register = 'ox_skillcheck',
    Safe = 'fa_minigames'
}

-- Store definitions. Add more stores using the same shape.
Config.Stores = {
    {
        id = 'ltd_grove',
        label = 'LTD Gasoline - Grove Street',
        profile = 'standard',
        coords = vector3(-47.35, -1758.67, 29.42),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-46.75, -1758.05, 29.42, 48.0),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = `WEAPON_PISTOL`,
                Ammo = 60,
                Accuracy = 35,
                Armor = 0,
                CanDie = true,
                RemoveDroppedWeapon = true,
                ResetAfterTargetDeath = 10000,
                CombatAbility = 1,
                CombatMovement = 2,
                CombatRange = 2
            }
        },
        registers = {
            vector3(-47.24, -1757.65, 29.42),
            vector3(-48.58, -1759.21, 29.42)
        },
        shelves = {
            vector3(-50.6, -1754.6, 29.42),
        },
        safe = {
            coords = vector3(-43.43, -1748.30, 28.42),
            heading = 230,
            methods = { 'drill' },
            prop = true
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'ltd_little_seoul',
        label = 'LTD Gasoline - Little Seoul',
        profile = 'standard',
        coords = vector3(-707.40, -914.50, 19.22),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-706.16, -914.55, 19.22, 88.0),
            Fight = {
                Chance = 15
            }
        },
        registers = {
            vector3(-706.08, -915.42, 19.22),
            vector3(-706.16, -913.50, 19.22)
        },
        shelves = {
            vector3(-711.7, -912.1, 19.22),
            vector3(-713.5, -915.7, 19.22)
        },
        safe = {
            coords = vector3(-709.74, -904.15, 19.22),
            heading = 229.5,
            methods = { 'drill' },
            prop = false
        },
        -- Optional minigame override for this store.
        -- Minigames = {
        --     Register = 'ox_skillcheck',
        --     Safe = 'fa_minigames'
        -- },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_sandy',
        label = '24/7 - Sandy Shores',
        profile = 'standard',
        coords = vector3(1961.16, 3740.74, 32.34),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1959.30, 3741.48, 32.34, 302.0),
            Fight = {
                Chance = 15
            }
        },
        registers = {
            vector3(1958.96, 3741.98, 32.34),
            vector3(1960.13, 3740.00, 32.34)
        },
        shelves = {
            vector3(1964.7, 3744.4, 32.34),
            vector3(1962.5, 3747.9, 32.34)
        },
        safe = {
            coords = vector3(1959.26, 3748.92, 32.34),
            heading = 30.0,
            methods = { 'drill' },
            prop = true
        },
        Cooldown = {
            StoreSeconds = 1800,
            PlayerSeconds = 900
        },
        -- Uses Rewards.Register[2], Rewards.Shelf[2] and Rewards.Safe[2]. You can also use rewardTier = 2.
        tier = 2
    }
}
