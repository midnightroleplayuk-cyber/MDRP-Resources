Config = {}

-- General
Config.Debug = false

-- /247coords helper (prints your position for adding shops to the config).
-- true = every player may use it (harmless, only shows their own position),
-- false = command is disabled
Config.CoordsCommand = true

-- Language, files live in locales/ ('de', 'en', 'pl', 'es', 'pt', 'th')
Config.Locale = 'en'

-- Interaction: 'auto' uses ox_target if running, otherwise E key with 3D text
-- 'ox_target' = force target, 'textui' = always E key
Config.Interaction = 'auto'

-- Overlay colors, applies to every UI element (minigames, hud)
Config.UI = {
    accent    = '#3ee07a',              -- main color (bars, borders, success)
    accentDim = '#1d5c38',              -- darker shade of the main color
    danger    = '#e0483c',              -- errors / dye pack
    bg        = 'rgba(10, 14, 11, 0.94)', -- window background
    text      = '#e9f4ec',              -- font color
}

-- Police
Config.Police = {
    jobs            = { 'police' },     -- jobs that count as police
    requiredCops    = 0,                -- min cops online to start a robbery
    riskBonusPerCop = 5,                -- % extra loot per cop online
    maxRiskBonus    = 50,               -- bonus cap
}

-- Dispatch: 'auto' detects ps-dispatch / cd_dispatch on its own,
-- otherwise the built-in alert runs (notify + blip for all cops)
-- 'ps' / 'cd' = force, 'internal' = built-in only, 'custom' = own hook below, 'none' = off
Config.Dispatch = 'auto'

-- Custom dispatch hook, runs server side when Config.Dispatch = 'custom'
-- data = { coords = vec3, label = 'shop name', kind = 'robbery' | 'silent' | 'noise' | 'prepfail' | 'cam' }
Config.DispatchCustom = function(data)
    -- TriggerEvent('my_dispatch:newCall', data)
end

-- Built-in alert
Config.InternalDispatch = {
    blipSprite = 161,
    blipColor  = 1,
    blipTime   = 60,                    -- seconds until the blip disappears
    flash      = true,
}

-- Robbery base rules
Config.Robbery = {
    requiredItem   = 'lockpick',        -- item needed to pick registers
    lockpickBreak  = 40,                -- % chance the lockpick snaps on a failed attempt
    cooldownShop   = 900,               -- seconds per shop after a robbery
    cooldownGlobal = 120,               -- seconds server wide between two robberies (0 = off)
    cooldownPlayer = 1800,              -- seconds per player (0 = off)
    maxPerHour     = 6,                 -- robberies per hour server wide (0 = off)
    crewRadius     = 20.0,              -- players this close at the start join the crew
    warnRadius     = 30.0,              -- distance where the come-back warning starts
    warnSeconds    = 20,                -- time to get back before you are out
    abortRadius    = 60.0,              -- past this you are out instantly
    timeout        = 600,               -- seconds until a stuck robbery resets itself
}

-- Prep: sabotaging the power box kills cameras and the silent alarm
-- works before the robbery (that arms the perfect bonus) or during it
Config.Prep = {
    window        = 600,                -- seconds the sabotage lasts
    perfectBonus  = 25,                 -- % bonus on the haul when sabotaged BEFORE the start
    camAlertDelay = 20,                 -- seconds until a live camera confirms the robbery to police
}

-- Clerk
Config.Clerk = {
    -- set false if your shop script already puts its own NPCs in the stores:
    -- this script then spawns NO clerk, the robbery starts by aiming your gun
    -- at your shop NPC instead. Hands up is attempted on the foreign NPC (your
    -- shop script may override it), the fight-back reaction is disabled
    -- automatically for foreign NPCs.
    spawn          = true,
    animateForeign = true,              -- attempt hands up on the foreign shop NPC
    model          = 'mp_m_shopkeep_01',
    invincible     = false,             -- own clerk can not die
    -- reaction on robbery, sum = 100 (fight = 0 -> never fights back)
    personality = {
        surrender = 70,                 -- gives up and opens the first register
        alarm     = 20,                 -- gives up but hits the silent alarm
        fight     = 10,                 -- pulls a gun
    },
    fightWeapon = 'WEAPON_PISTOL',      -- weapon used on fight
    alarmDelay  = 25,                   -- seconds until the silent alarm goes out
}

-- Discord logs, paste your webhook and you are done (empty = off)
Config.Logs = {
    webhook = '',
    name    = '247 Robbery',
}

-- Registers and the cash grab
Config.Registers = {
    grabsMin       = 4,                 -- bill stacks per register (min)
    grabsMax       = 6,                 -- bill stacks per register (max)
    grabValueMin   = 90,                -- value per stack (min)
    grabValueMax   = 260,               -- value per stack (max)
    dyeBaseChance  = 4,                 -- % dye pack chance on the first grab
    dyeGrowth      = 7,                 -- % added per further grab
    dyeLossPercent = 60,                -- % of the register haul lost when the pack pops
}

-- Shelves inside the store, searchable by the crew during a robbery
-- loot chances scale with the hits in the rummage minigame
Config.Shelves = {
    enabled = true,
    loot = {                            -- every line rolls on its own per shelf
        { name = 'cigarettes',     chance = 60, min = 1, max = 3 },
        { name = 'sprunk',         chance = 40, min = 1, max = 2 },
        { name = 'scratch_ticket', chance = 35, min = 1, max = 2 },
    },
}

-- Scratch tickets from the shelves, redeemed by using the item
Config.Scratch = {
    item   = 'scratch_ticket',
    payout = 'cash',                    -- 'cash' or 'black'
    prizes = {                          -- rolled top to bottom, the rest is a blank
        { chance = 3,  min = 500, max = 1500 },
        { chance = 12, min = 100, max = 300 },
        { chance = 30, min = 20,  max = 80 },
    },
}

-- Loot
Config.Reward = {
    type    = 'item',                   -- 'account' or 'item'
    account = 'black_money',
    item    = 'black_money',
}

-- Back room safe, pure bonus, not needed to finish the robbery
Config.Safe = {
    rewardMin = 2500,                   -- safe haul (min)
    rewardMax = 5000,                   -- safe haul (max)
}

-- Vending machines (soda/snacks/coffee) around the shop
-- only crackable during a running robbery and only by the crew
Config.Vending = {
    enabled  = true,
    radius   = 30.0,                    -- machine counts as part of the shop within this range
    maxPerRobbery = 6,                  -- machines that can be cracked per robbery (anti abuse cap)
    models   = {                        -- these props count as machines
        `prop_vend_soda_01`,
        `prop_vend_soda_02`,
        `prop_vend_coffe_01`,
    },
    cash     = { min = 40, max = 140 }, -- change from the coin box
    items    = {                        -- what can drop on top
        { name = 'sprunk', chance = 60, min = 1, max = 3 },
        { name = 'water',  chance = 40, min = 1, max = 2 },
    },
    fallPing = true,                    -- a tipped machine sends a noise alert
}

-- Minigame difficulty
Config.Minigames = {
    lockpick = {
        pins     = 4,                   -- pins per lock
        speed    = 1.0,                 -- base speed (higher = harder)
        window   = 18,                  -- hit window in % of the bar
        attempts = 3,                   -- misses until the lock stays shut
    },
    dial = {
        numbers    = 3,                 -- numbers in the combination
        strikes    = 3,                 -- wrong entries until the safe is done for
        warmRadius = 2,                 -- range where the faint ticking is audible
        speed      = 1.0,               -- turn speed while holding (higher = faster)
    },
    shake = {
        pushes    = 6,                  -- clean pushes until the machine gives in
        tiltLimit = 3,                  -- mistakes until the machine tips over
        speed     = 1.0,                -- swing speed (higher = harder)
    },
    keypad = {
        attempts = 4,                   -- tries per run
        lockout  = 60,                  -- seconds locked out when all tries are used
    },
    wires = {
        count = 6,                      -- wires in the power box
    },
    rummage = {
        keys    = 6,                    -- keys per shelf
        window  = 0.9,                  -- seconds per key
        speedup = 0.92,                 -- window shrinks per hit (factor)
    },
}

-- Shops, everything configurable per shop
Config.Shops = {
    {
        label = '24/7 Innocence Blvd',
        center = vec3(25.7, -1345.9, 29.5),         -- shop center for distance checks
        clerk = vec4(24.42, -1345.65, 28.66, 264.0), -- clerk position (ground level, w = heading)
        registers = {
            vec3(24.47, -1344.99, 29.6),
            vec3(24.45, -1347.37, 29.6),
        },
        safe = vec3(28.16, -1338.85, 29.0),         -- back room safe (bonus)
        -- safeKeypad = true,                       -- optional: worn-keypad stage before the dial
        powerBox = vec3(19.10, -1335.70, 28.9),     -- power box outside
        shelves = {                                 -- shelves
            vec3(25.40, -1338.90, 29.2),
            vec3(27.14, -1338.92, 29.2),
        },
    },

    --[[ Template for another shop: copy the block, uncomment it and fill the
         TODO positions ingame with /247coords. The command prints two lines:
         use the "clerk" line for the clerk, the "any prop" line for every
         other position (registers, safe, power box, shelves).
    {
        label = '24/7 Example',                     -- name shown in the UI and in logs
        center = vec3(0.0, 0.0, 0.0),               -- TODO shop center (distance checks)
        clerk = vec4(0.0, 0.0, 0.0, 0.0),           -- TODO clerk behind the counter, w = heading
        registers = {
            vec3(0.0, 0.0, 0.0),                    -- TODO register 1
            vec3(0.0, 0.0, 0.0),                    -- TODO register 2 (more lines = more registers)
        },
        safe = vec3(0.0, 0.0, 0.0),                 -- optional safe, delete the line if there is none
        safeKeypad = false,                         -- optional keypad stage in front of the safe
        powerBox = vec3(0.0, 0.0, 0.0),             -- optional power box (prep / perfect bonus)
        shelves = {                                 -- optional shelves
            vec3(0.0, 0.0, 0.0),                    -- TODO shelf 1
        },
    },
    ]]
}

-- Player facing texts live in locales/*.json, language via Config.Locale above

-- Custom notify hook, nil = ESX default
-- Config.Notify = function(msg) exports.my_hud:Notify(msg) end
Config.Notify = nil
