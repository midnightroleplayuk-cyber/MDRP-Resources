Shared = {}

Shared.Debug = {
    Enabled = false,     -- set to false to disable ALL debug prints
    Levels = {
        Info    = true, -- step-by-step flow ("entered X", "branch taken", values)
        Success = true, -- something completed correctly
        Warning = true, -- unexpected but recoverable (missing player, empty list, ...)
        Error   = true, -- something is broken (nil Core, failed export, bad state)
    },
}

-- Minimum amount of police that must be online before a player can join the heist queue.
Shared.MinPolice = 1

-- ── Skill tree (devhub_laptop Crime Traders) ─────────────────────────────────
-- The Train Heist perks live in the laptop's Crime Traders skill tree, in the
-- ['trainheist'] section of devhub_laptop/configs/s.skillTree.lua. Players earn XP
-- for finishing heists and the perks they unlock there kick in automatically.
-- Needs the devhub_skillTree add-on; everything below quietly no-ops without it. 
-- https://devhub.gg/product/6440792-1
Shared.SkillTree = {
    enabled = true,      -- grant XP + apply the laptop perks (set false to ignore the skill tree)
    category = 'laptop', -- the laptop's skill tree category (do not change unless you renamed it)
    xpPerJob = 250,      -- base skill XP a player earns for completing a heist

    -- Which laptop perk feeds which bonus (laptop node uid -> bonus channel):
    --   xpBoost   : more XP per completed heist
    --   fastHands : pick up loot / search crates faster
    --   stealth   : lower chance to alert the police while raiding
    effects = {
        skill_50 = 'xpBoost',   skill_70 = 'xpBoost',
        skill_51 = 'fastHands', skill_71 = 'fastHands',
        skill_52 = 'stealth',   skill_72 = 'stealth',
    },
}

-- Requirements a player must meet to JOIN the heist queue.
-- Items listed with `consume = true` are removed when the mission actually starts (not when joining).
Shared.StartRequirements = {
    -- Item example:
    -- { name = "trainheist_laptop", amount = 1, consume = true },

    -- Custom handler example:
    -- {
    --     label = "Crew Membership",
    --     icon = "fas fa-users",
    --     check = function(source)
    --         return true
    --     end,
    --     action = function(source)
    --         -- runs once the mission actually starts
    --     end,
    -- },
}

-- NPC contact(s) the player can talk to in order to start / check the heist queue.
-- Set enabled = false to rely only on the laptop Crime Traders app.
Shared.PedSettings = {
    enabled = true,
    peds = {
        {
            model = "g_m_y_lost_01",
            coords = vector4(1400.6552, 2169.9309, 96.9115, 268.2721),
            blip = {
                enabled = false,
                sprite = 1,
                color = 2,
                scale = 0.8,
                label = "Train Heist Contact",
            },
        },
        -- Add more peds here:
        -- {
        --     model = "g_m_y_lost_01",
        --     coords = vector4(0.0, 0.0, 0.0, 0.0),
        --     blip = { enabled = false, sprite = 1, color = 2, scale = 0.8, label = "Train Heist Contact" },
        -- },
    },
}

-- devhub_laptop Crime Traders integration.
-- enabled = true  -> heist appears as a Crime Traders task; notifications use the laptop popup.
-- enabled = false -> heist is started only through the NPC; notifications use Core.Notify.
Shared.LaptopConfig = {
    enabled = true,
    traderId = 'trader_2',
    name = 'Train Heist',
    smallDescription = 'Hack the rail network, intercept a cargo train and raid its freight.',
    description = 'Join the queue and wait for your slot. Collect the heist vehicle from a depot, breach the rail network from an antenna, crack the access terminal, drive to the interception point and plant a device on the tracks. Once the train is forced to stop, raid the carriages, haul the cargo into your vehicle and deliver it to the drop-off.',
    -- Replace these with your own hosted images if you have them.
    bannerImage = 'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/trainHeist/taskImage.webp',
    images = {
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/trainHeist/taskImage.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/trainHeist/img_1.webp',
    },
    link = "https://store.devhub.gg",
    -- Bonus rewards claimed from the laptop after the heist (on top of the black money payout).
    rewards = {
        items = {},
        money = 1000,
        crimePoints = 500,
        xp = 250,
    },
    tasks = {
        ['uid_1'] = {
            name = 'Join the queue',
            description = 'Join the queue and wait for a free heist slot.',
            icon = 'fas fa-sign-in-alt',
            order = 1,
        },
        ['uid_2'] = {
            name = 'Collect the heist vehicle',
            description = 'Head to the depot marked on your map and get into the heist vehicle to begin.',
            icon = 'fas fa-car',
            order = 2,
        },
        ['uid_3'] = {
            name = 'Hack the antenna',
            description = 'Head to the antenna marked on your map and hack the monitor to breach the rail network.',
            icon = 'fas fa-satellite-dish',
            order = 3,
        },
        ['uid_4'] = {
            name = 'Crack the terminal',
            description = 'Go to the access terminal and enter the code generated during the antenna hack.',
            icon = 'fas fa-terminal',
            order = 4,
        },
        ['uid_5'] = {
            name = 'Reach the interception point',
            description = 'Travel to the interception point marked on your map.',
            icon = 'fas fa-location-crosshairs',
            order = 5,
        },
        ['uid_6'] = {
            name = 'Plant the device',
            description = 'Plant the device (C4, jammer or EMP) on the tracks to force the train to stop.',
            icon = 'fas fa-bomb',
            order = 6,
        },
        ['uid_7'] = {
            name = 'Raid the train',
            description = 'Once the train stops, loot the carriages, search the crates and load the cargo into your vehicle.',
            icon = 'fas fa-train',
            order = 7,
        },
        ['uid_8'] = {
            name = 'Deliver the cargo',
            description = 'Drive the loaded vehicle to the drop-off location to complete the heist.',
            icon = 'fas fa-flag-checkered',
            order = 8,
        },
    },
}

-- Loot pricing pool. Shared because the client spawns these props on the train
-- and the server prices the delivered cargo on drop-off.
-- zOffset = height above carriage origin where the prop sits (adjust per prop)
-- xClamp  = max absolute X offset to keep wide props inside the carriage (nil = no limit)
Shared.LootProps = {
    { model = "hei_prop_heist_emp",              zOffset = 0.0,   price = 2500, size = "big" },

    { model = "sm_prop_smug_crate_s_bones",      zOffset = 0.0,   xClamp = 0.3, price = 1800, size = "big" },

    { model = "ex_prop_adv_case_sm",             zOffset = -0.07, price = 3200, size = "small" },
    { model = "sf_prop_sf_weed_bigbag_01a",      zOffset = -0.3,  price = 1500, size = "small" },
    -- { model = "m23_2_prop_m32_bag_weapons_01a",  zOffset = -0.3,  price = 4000, size = "small" },
    { model = "ex_office_swag_drugbags",         zOffset = -0.3,  price = 2200, size = "small" },
    { model = "ex_office_swag_ivory2",           zOffset = -0.16, price = 3500, size = "small" },
    { model = "prop_mp_drug_pack_red",           zOffset = -0.5,  price = 1200, size = "small" },

    { model = "ch_prop_ch_crate_empty_01a",      zOffset = -0.3,  xClamp = 0.3, price = 800, size = "big" },

    { model = "bkr_prop_biker_case_shut",        zOffset = -0.25, price = 2000, size = "small" },
    { model = "h4_prop_h4_case_supp_01a",        zOffset = -0.31, price = 2800, size = "small" },
    { model = "prop_box_guncase_02a",            zOffset = -0.32, price = 3000, size = "small" },

    { model = "hei_p_attache_case_shut_s",       zOffset = -0.25, price = 4500, size = "small" },

    { model = "prop_ld_case_01_s",               zOffset = 0.05,  price = 1600, size = "small" },
    { model = "sf_prop_sf_flightcase_01b",       zOffset = -0.3,  price = 2600, size = "small" },
    { model = "sf_prop_sf_flightcase_01c",       zOffset = -0.3,  price = 2600, size = "small" },

    { model = "prop_suitcase_03b",               zOffset = 0.08,  price = 1900, size = "small" },
    { model = "w_am_case",                       zOffset = 0.05,  price = 3800, size = "small" },

    { model = "tr_prop_tr_adv_case_01a",         zOffset = -0.02, price = 2100, size = "big" },
}

-- Item pool a player can find when searching a crate (server-side search callback).
Shared.SearchLoot = {
    { item = "gold_bar", label = "Gold Bar", chance = 15 },
    { item = "diamond_ring", label = "Diamond Ring", chance = 10 },
    { item = "rolex", label = "Rolex Watch", chance = 12 },
    { item = "money_bag", label = "Money Bag", chance = 20 },
    { item = "electronic_parts", label = "Electronic Parts", chance = 25 },
    { item = "weapon_parts", label = "Weapon Parts", chance = 18 },
}
