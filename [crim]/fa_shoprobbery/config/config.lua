Config = {}

-- Enables additional debug output via ox_lib print helpers.
Config.Debug = false

-- Locale loaded from locales/*.json.
Config.Locale = 'en'

-- Framework bridge. auto checks qbx_core, qb-core, es_extended, then standalone.
Config.Framework = 'qbox' -- auto, qbox, qb, esx, standalone

-- Inventory bridge used for item and money handling.
Config.Inventory = 'auto' -- auto, ox_inventory, qb-inventory, qs-inventory, jaksam_inventory, tgiann-inventory, esx, custom

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
            --'WORLD_HUMAN_STAND_IMPATIENT',
            'WORLD_HUMAN_STAND_MOBILE',
            --'WORLD_HUMAN_AA_COFFEE'
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
Config.PoliceJobs = { 'police', }

-- Required online police count before a robbery action can begin.
Config.MinimumPolice = 0
-- You can configure police multiplier in config/rewards.lua

-- Controls the intended robbery order.
Config.Flow = {
    RequireClerkBeforeLoot = true, -- Requires the clerk to be intimidated/killed before the player can loot the store.
    RequireRegisterBeforeSafe = true, -- Requires at least one register to be looted before the player can loot the safe.
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
    RequireWeaponForClerk = false,
    AllowedWeapons = true,
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
        coords = vector3(-47.28, -1758.52, 28.42),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-47.2886, -1758.5280, 29.4210, 45.3676),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = `WEAPON_PBAT`,
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
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'ltd_little_seoul',
        label = 'LTD Gasoline - Little Seoul',
        profile = 'standard',
        coords = vector3(-706.01, -914.56, 18.22),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-706.0665, -914.6005, 19.2156, 82.3892),
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
        coords = vector3(1959.16, 3741.41, 31.34),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1959.1536, 3741.4165, 32.3437, 298.7749),
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
            
        },
        safe = {
            coords = vector3(1959.26, 3748.92, 32.34),
            heading = 30.0,
            methods = { 'drill' },
            prop = false
        },
        Cooldown = {
            StoreSeconds = 1800,
            PlayerSeconds = 900
        },
        -- Uses Rewards.Register[2], Rewards.Shelf[2] and Rewards.Safe[2]. You can also use rewardTier = 2.
        tier = 2
    },
    {
        id = 'twentyfour_vinewood',
        label = 'twentyfour - Vinewood',
        profile = 'standard',
        coords = vector3(372.64, 328.11, 102.57),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(372.8008, 328.1116, 103.5665, 262.1354),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(373.64, 328.64, 103.71),
            vector3(373.12, 326.27, 103.74)
        },
        shelves = {
            vector3(376.31, 327.7, 103.58),
        },
        safe = {
            coords = vector3(378.26, 333.96, 103.1),
            heading = 161.92,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_innocence',
        label = '247 convenient store - Innocence Boulevard',
        profile = 'standard',
        coords = vector3(24.49, -1345.6, 28.49),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(24.5062, -1345.5989, 29.4970, 263.3659),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(24.96, -1347.3, 29.69),
            vector3(25.01, -1344.98, 29.62)
        },
        shelves = {
            vector3(30.96, -1346.47, 29.69),
        },
        safe = {
            coords = vector3(28.23, -1338.49, 29.24),
            heading = 230,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_legionsquare',
        label = 'twentyfour - Legion Square',
        profile = 'standard',
        coords = vector3(209.48, -867.82, 30.28), 
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(209.49, -867.82, 31.29, 69.37),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(208.09, -868.99, 31.47),
            vector3(208.93, -866.82, 31.49)
        },
        shelves = {
            vector3(202.81, -866.8, 31.23),
        },
        safe = {
            coords = vector3(202.95, -874.02, 30.84),
            heading = 331.06,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'liquorstore_delperro',
        label = 'liquor store - Del Perro',
        profile = 'standard',
        coords = vector3(-1486.73, -377.59, 39.16),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-1486.7350, -377.5593, 40.1634, 132.9464),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(-1486.74, -378.54, 40.3)
        },
        shelves = {
            vector3(-1489.08, -380.02, 40.14),
        },
        safe = {
            coords = vector3(-1478.53, -375.74, 39.1),
            heading = 47.23,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'liquorstore_vespucci',
        label = 'Liquor store - Vespucci',
        profile = 'standard',
        coords = vector3(-1222.34, -907.77, 12.45),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-1221.45, -908.08, 12.31, 27.22),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(-1222.34, -907.77, 12.45)
        },
        shelves = {
            vector3(-1223.63, -904.81, 12.28),
        },
        safe = {
            coords = vector3(-1221.26, -916.27, 11.43),
            heading = 301.7,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
       id = 'ltd_grapeseed',
        label = 'LTD - Grapeseed',
        profile = 'standard',
        coords = vector3(1698.26, 4923.37, 42.22),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1697.76, 4922.94, 42.15, 325.54),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(1698.26, 4923.37, 42.22),
            vector3(1696.65, 4924.64, 42.21)
        },
        shelves = {
            vector3(1701.28, 4925.25, 41.96),
        },
        safe = {
            coords = vector3(1708.33, 4921.02, 41.57),
            heading = 331.06,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1 
    },
    {
        id = 'twentyfour_senorafreeway',
        label = 'twentyfour - senora freeway',
        profile = 'standard',
        coords = vector3(2676.31, 3280.95, 55.39),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(2676.5083, 3280.1863, 55.2411, 335.5104),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(2676.31, 3280.95, 55.39),
            vector3(2678.25, 3279.95, 55.4)
        },
        shelves = {
            vector3(2680.57, 3285.46, 55.41),
        },
        safe = {
            coords = vector3(2672.29, 3286.7, 54.87),
            heading = 331.06,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_route68',
        label = 'twentyfour - route 68',
        profile = 'standard',
        coords = vector3(548.77, 2668.93, 42.34),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(549.2471, 2669.6699, 42.1565, 96.9846),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(548.77, 2668.93, 42.34),
            vector3(548.54, 2671.28, 42.3)
        },
        shelves = {
            vector3(542.55, 2669.62, 42.28),
        },
        safe = {
            coords = vector3(546.51, 2662.29, 41.69),
            heading = 331.06,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_palaminofreeway',
        label = 'twentyfour - palamino freeway',
        profile = 'standard',
        coords = vector3(2554.85, 381.53, 108.79),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(2555.5110, 380.7313, 108.6229, 0.9597),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(2554.85, 381.53, 108.79),
            vector3(2557.28, 381.35, 108.76)
        },
        shelves = {
            vector3(2556.66, 387.58, 108.75),
        },
        safe = {
            coords = vector3(2548.73, 384.93, 108.16),
            heading = 331.06,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_paleto',
        label = 'twentyfour - paleto bay',
        profile = 'standard',
        coords = vector3(1729.3, 6417.09, 35.18),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1728.5699, 6416.7671, 35.0372, 243.3380),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(1729.3, 6417.09, 35.18),
            vector3(1728.52, 6414.95, 35.22)
        },
        shelves = {
            vector3(1734.14, 6412.97, 35.17),
        },
        safe = {
            coords = vector3(1735.03, 6421.43, 34.48),
            heading = 161.92,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_chumash',
        label = 'twentyfour - chumash',
        profile = 'standard',
        coords = vector3(-3243.92, 1000.06, 11.83),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-3243.9229, 1000.0519, 12.8307, 0.7583),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(-3244.6, 1000.69, 12.94),
            vector3(-3242.27, 1000.55, 12.98)
        },
        shelves = {
            vector3(-3242.45, 1006.54, 13.0),
        },
        safe = {
            coords = vector3(-3250.57, 1004.43, 12.33),
            heading = 161.92,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_greatocean',
        label = 'twentyfour - great ocean',
        profile = 'standard',
        coords = vector3(-3041.42, 584.37, 8.06),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-3040.5376, 583.9359, 7.9089, 17.7445),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(-3041.42, 584.37, 8.06),
            vector3(-3039.12, 584.98, 8.07)
        },
        shelves = {
            vector3(-3041.74, 590.56, 8.1),
        },
        safe = {
            coords = vector3(-3048.39, 585.46, 7.43),
            heading = 161.92,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'ranjeets_sandyshores',
        label = 'ranjeets - sandy shores',
        profile = 'standard',
        coords = vector3(1481.7, 3572.17, 36.77),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1481.7, 3572.17, 36.77, 287.85),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(1482.5, 3572.71, 36.94)
        },
        shelves = {
            vector3(1481.6, 3575.67, 36.97),
        },
        safe = {
            coords = vector3(1481.11, 3570.09, 36.82),
            heading = 199.96,
            methods = { 'drill' },
            prop = true
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'ltd_mirrorpark',
        label = 'ltd - mirror park',
        profile = 'standard',
        coords = vector3(1164.2, -322.93, 69.37),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1165.0068, -323.6485, 69.2051, 101.2836),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(1164.8, -322.5, 69.37),
            vector3(1164.4, -324.99, 69.38)
        },
        shelves = {
            vector3(1160.17, -323.12, 69.45),
        },
        safe = {
            coords = vector3(1158.81, -314.17, 68.81),
            heading = 199.96,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'bossmans_jamestown',
        label = 'bossmans - jamestown',
        profile = 'standard',
        coords = vector3(311.25, -2041.41, 19.27),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(311.2435, -2041.4139, 20.2700, 241.0878),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(311.67, -2041.99, 20.41)
        },
        shelves = {
            vector3(313.27, -2044.81, 20.32),
        },
        safe = {
            coords = vector3(305.35, -2046.82, 19.98),
            heading = 199.96,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'aceliquor_sandy',
        label = 'aceliquor - sandy shores',
        profile = 'standard',
        coords = vector3(1392.07, 3606.13, 33.98),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1392.0671, 3606.1155, 34.9809, 203.5101),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(1393.11, 3605.88, 35.12)
        },
        shelves = {
            vector3(1396.97, 3608.04, 35.27),
        },
        safe = {
            coords = vector3(1387.28, 3606.77, 34.94),
            heading = 289.0,
            methods = { 'drill' },
            prop = true
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'twentyfour_banhamcanyondr',
        label = 'twentyfour - banham canyon dr',
        profile = 'standard',
        coords = vector3(-1819.5, 793.6, 137.08),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-1819.4907, 793.5951, 138.0846, 132.5959),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(-1820.58, 793.7, 138.28),
            vector3(-1819.15, 792.23, 138.24)
        },
        shelves = {
            vector3(-1823.84, 791.45, 138.36),
        },
        safe = {
            coords = vector3(-1829.66, 798.34, 137.81),
            heading = 199.96,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'liquorstore_greatocean',
        label = 'liquor store - great ocean',
        profile = 'standard',
        coords = vector3(-2966.14, 391.67, 14.04),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(-2966.3162, 391.5883, 15.0433, 86.4455),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(-2967.25, 390.91, 15.15)
        },
        shelves = {
            vector3(-2970.19, 391.82, 15.02),
        },
        safe = {
            coords = vector3(-2959.66, 386.56, 14.09),
            heading = 199.96,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    },
    {
        id = 'liquorstore_greatocean',
        label = 'liquor store - great ocean',
        profile = 'standard',
        coords = vector3(1134.25, -983.07, 45.41),
        clerk = {
            model = 'mp_m_shopkeep_01',
            coords = vector4(1134.2589, -983.0569, 46.4158, 278.9547),
            -- Optional per-shop override. Remove this table to use Config.Clerk.Fight.Chance.
            Fight = {
                Enabled = true,
                Chance = 15,
                Weapon = WEAPON_BAT,
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
            vector3(1134.93, -982.34, 46.55)
        },
        shelves = {
            vector3(1138.01, -982.55, 46.36),
        },
        safe = {
            coords = vector3(1126.67, -979.49, 45.38),
            heading = 199.96,
            methods = { 'drill' },
            prop = false
        },
        -- Uses Rewards.Register[1], Rewards.Shelf[1] and Rewards.Safe[1]. You can also use rewardTier = 1.
        tier = 1
    }


}
