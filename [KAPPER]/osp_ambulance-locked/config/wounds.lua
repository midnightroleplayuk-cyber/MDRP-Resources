Config = Config or {}

Config.DamageRigorousness = 5 -- Amount of hp on a hit before damages gets applied

Config.Wounds = { -- These are major/critical injuries
    ["abrasion"] = {
        name = "abrasion",
        causes = { 
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['WILDLIFE']] = true,
        },
        bleeding = 0,
        pain = 0.2,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = false,
    },

    ["avulsion"] = {
        name = "avulsion",
        causes = { 
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['WILDLIFE']] = true,
            [Config.WeaponClasses['CUTTING']] = true,
        },
        bleeding = 0.05,
        pain = 0.5,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = true,
    },

    ["contusion"] = {
        name = "contusion",
        causes = { 
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['LIGHT_IMPACT']] = true,
        },
        bleeding = 0,
        pain = 0.3,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = false,
    },

    ["crush"] = {
        name = "crush",
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
        },
        bleeding = 0.08,
        pain = 1.0,
        causeLimping = 1, -- Will only cause limping if the legs are damaged
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        causeStaggering = 50, -- 100 = 100% chance
        needSewing = false,
    },

    ["cut"] = {
        name = "cut",
        causes = { 
            [Config.WeaponClasses['OTHER']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['CUTTING']] = true,
        },
        bleeding = 0.05,
        pain = 0.5,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = true,
    },

    ["laceration"] = {
        name = "laceration",
        causes = { 
            [Config.WeaponClasses['HEAVY_IMPACT']] = true,
            [Config.WeaponClasses['LIGHT_IMPACT']] = true,
        },
        bleeding = 0.05,
        pain = 0.5,
        reopeningTime = 160, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = true,
    },

    ["lowvelocitywound"] = {
        name = "lowvelocitywound",
        causes = { 
            [Config.WeaponClasses['SMALL_CALIBER']] = true,
        },
        bleeding = 0.1,
        pain = 2.0,
        causeLimping = 1, -- Will only cause limping if the legs are damaged
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        causeStaggering = 20, -- 100 = 100% chance
        needSewing = true,
    },

    ["mediumvelocitywound"] = {
        name = "mediumvelocitywound",
        causes = { 
            [Config.WeaponClasses['MEDIUM_CALIBER']] = true,
        },
        bleeding = 0.5,
        pain = 2.0,
        causeLimping = 1, -- Will only cause limping if the legs are damaged
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        causeStaggering = 20, -- 100 = 100% chance
        needSewing = true,
    },

    ["highvelocitywound"] = {
        name = "highvelocitywound",
        causes = { 
            [Config.WeaponClasses['HIGH_CALIBER']] = true,
        },
        bleeding = 0.7,
        pain = 2.0,
        causeLimping = 1,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        causeStaggering = 20, -- 100 = 100% chance
        needSewing = true,
    },

    ["velocitywound"] = {
        name = "velocitywound",
        causes = { 
            [Config.WeaponClasses['EXPLOSIVE']] = true,
            [Config.WeaponClasses['SHOTGUN']] = true,
        },
        bleeding = 0.3,
        pain = 2.0,
        causeLimping = 1, -- Will only cause limping if the legs are damaged
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        causeStaggering = 20, -- 100 = 100% chance
        needSewing = true,
    },

    ["puncturewound"] = {
        name = "puncturewound",
        causes = { 
            [Config.WeaponClasses['CUTTING']] = true,
            [Config.WeaponClasses['EXPLOSIVE']] = true,
        },
        bleeding = 0.3,
        pain = 1.0,
        causeLimping = 1, -- Will only cause limping if the legs are damaged
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        causeStaggering = 50, -- 100 = 100% chance
        needSewing = true,
    },

    ["burn"] = {
        name = "burn",
        causes = { 
            [Config.WeaponClasses['FIRE']] = true,
        },
        bleeding = 0,
        pain = 2.0,
        bodyTemp = 0.9,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = false,
    },
}

Config.MinorWounds = { -- These are minor wounds that might happen during soft collisions, falling over etc, the script will randomly pick one of the following wounds and apply them to the players body part
    ["abrasion"] = {
        name = "abrasion",
        bleeding = 0,
        pain = 1.0,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = false,
    },

    ["contusion"] = {
        name = "contusion",
        bleeding = 0,
        pain = 1.0,
        reopeningTime = 60, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
        needSewing = false,
    },

    -- ["laceration"] = {
    --     name = "laceration",
    --     bleeding = 0.2,
    --     pain = 2.2,
    --     reopeningTime = 160, -- base time in seconds before wound can reopen and then multiples by the bandage modifier
    --     needSewing = true,
    -- },
}


-- Patients with insurvivable injuries cannot be revived through CPR, defibrillation,
-- or hospital check-in. Only admin /revive and the emergency revive kit bypass this.
-- With skipLaststand = true they go straight to stage-2 death instead of laststand.
-- Add extra entries to rules, or override CustomInsurvivableCheck in client_open.lua.
Config.InsurvivableInjuries = {
    enabled = true,
    skipLaststand = true, -- false = laststand as usual, but still unrevivable

    -- Named wound lists that rules can reference by string (e.g. wounds = 'bulletWounds')
    bulletWounds = {
        'lowvelocitywound',
        'mediumvelocitywound',
        'highvelocitywound',
        'velocitywound',
    },

    -- match = 'any'  → any listed body part has any listed wound
    -- match = 'all'  → every listed body part has the listed wound(s)
    -- skipLaststandOnHit → also match at the moment of death via last bone + weapon class
    --                      (wounds may not be written yet when GTA health hits 0)
    rules = {
        {
            id = 'headGunshot',
            enabled = true,
            match = 'any',
            bodyParts = { 'Head' },
            wounds = 'bulletWounds',
            skipLaststandOnHit = true,
            weaponClasses = {
                Config.WeaponClasses['SMALL_CALIBER'],
                Config.WeaponClasses['MEDIUM_CALIBER'],
                Config.WeaponClasses['HIGH_CALIBER'],
                Config.WeaponClasses['SHOTGUN'],
                Config.WeaponClasses['EXPLOSIVE'],
            },
        },
        {
            id = 'fullBodyBurns',
            enabled = true,
            match = 'all',
            bodyParts = { 'Head', 'Torso', 'Larm', 'Rarm', 'Lleg', 'Rleg' },
            wounds = { 'burn' },
            minDamageSeverity = 3,
        },
        -- Example extra rule (disabled). Copy and enable as needed:
        -- {
        --     id = 'severeHeadTrauma',
        --     enabled = false,
        --     match = 'any',
        --     bodyParts = { 'Head' },
        --     wounds = { 'crush', 'avulsion' },
        --     minDamageSeverity = 3,
        -- },
    },
}
