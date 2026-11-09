Config.Heists = {
    enabled = true,

    -- Heists themselves are built in game: /gangadmin > Heists. This file sets the rules they share.
    gangCooldown = 45,     -- minutes before the same gang can start another heist
    crewRadius   = 40.0,   -- crew must be this close to the start point to count towards "crew needed"
    stepRadius   = 2.0,    -- how close to a step you need to be to work on it
    escapeRadius = 250.0,  -- once everything's done, get this far from the start to finish
    retryDelay   = 10,     -- seconds before a failed step can be tried again
    failAlarm    = 0.5,    -- chance a failed minigame trips the alarm (a loud alert)
    silentDelay  = 45,     -- seconds before a silent alarm reaches the police

    -- Items a step needs. false = nothing needed. consume = used up when the step succeeds.
    tools = {
        hack        = { item = false },
        thermite    = { item = 'thermite', consume = true },
        drill       = { item = false },
        truck_doors = { item = 'thermite', consume = true },
    },

    -- What loot steps can hand out (chosen per loot step in the builder).
    --   money: paid into the gang's treasury (account = 'dirty' or 'clean'); item: given to whoever grabbed it
    lootTypes = {
        cash        = { label = 'Cash (to dirty treasury)', kind = 'money', account = 'dirty' },
        markedbills = { label = 'Marked bills (item)', kind = 'item', item = 'markedbills' },
        goldbar     = { label = 'Gold bars (item)', kind = 'item', item = 'goldbar' },
        jewels      = { label = 'Jewellery (item)', kind = 'item', item = 'rolex' },
    },

    -- Minigame difficulty: 1 easy, 2 medium, 3 hard. time = default seconds allowed.
    minigames = {
        hack     = { label = 'Hack',     time = 30 },
        thermite = { label = 'Thermite', time = 25 },
        drill    = { label = 'Drill',    time = 45 },
    },

    -- Armoured truck: what spawns for a 'truck' step.
    truck = {
        model        = 'stockade',
        guardModel   = 's_m_m_armoured_01',
        guardWeapon  = 'WEAPON_CARBINERIFLE',
        guards       = 2,
        stopHealth   = 400,  -- engine health at or below which the truck counts as stopped (or the driver's out)
        driveSpeed   = 18.0, -- m/s, roughly 40 mph
    },

    -- Step types the builder offers.
    stepTypes = {
        hack        = { label = 'Hack a panel', game = 'hack', anim = { dict = 'anim@heists@prison_heiststation@cop_reactions', clip = 'cop_b_idle' } },
        thermite    = { label = 'Thermite a door', game = 'thermite', anim = { dict = 'anim@heists@ornate_bank@thermal_charge', clip = 'thermal_charge' } },
        drill       = { label = 'Drill (vault or boxes)', game = 'drill', anim = { dict = 'anim@heists@fleeca_bank@drilling', clip = 'drill_straight_idle' } },
        loot        = { label = 'Grab loot', anim = { dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab' } },
        wait        = { label = 'Wait (time lock)' },
        truck       = { label = 'Armoured truck: stop it' },
        truck_doors = { label = 'Armoured truck: open the back', game = 'thermite', anim = { dict = 'anim@heists@ornate_bank@thermal_charge', clip = 'thermal_charge' } },
        -- NPC steps
        talk        = { label = 'Talk to someone (NPC)' },      -- walk up and press E; they say your line (can cost money or need an item)
        guards      = { label = 'Deal with guards (NPCs)' },    -- armed NPCs spawn around the spot; done when they're all down
        hostage     = { label = 'Intimidate someone (NPC)' },   -- aim at them until they comply; killing them sets off the loud alarm
    },

    -- Templates staff can start from. Positions are set in game.
    -- NPCs for the NPC steps (defaults the builder starts with; each step can use its own)
    npc = {
        ped          = 'a_m_m_business_01',  -- talk / intimidate
        guardPed     = 's_m_m_security_01',
        guardWeapon  = 'weapon_pistol',
        talkTime     = 4,     -- seconds the conversation takes
        aimDistance  = 12.0,  -- how close you need to be to intimidate someone
        spawnDistance = 120.0, -- NPCs appear when the crew gets this close
    },

    templates = {
        bank = {
            label = 'Bank vault', police = 4, crew = 3, cooldown = 120, timeLimit = 20,
            steps = {
                { type = 'talk', label = 'Inside man', ped = 'a_m_y_business_02', say = "Vault's on a time lock and the manager has the code. Get in there." },
                { type = 'hostage', label = 'Bank manager', ped = 'a_m_m_business_01', time = 8 },
                { type = 'hack', label = 'Security panel', difficulty = 2, alert = 'silent' },
                { type = 'thermite', label = 'Inner gate', difficulty = 2, alert = 'loud' },
                { type = 'drill', label = 'Vault door', difficulty = 3 },
                { type = 'loot', label = 'Cash trolley', loot = { type = 'cash', min = 15000, max = 25000 }, time = 20 },
                { type = 'loot', label = 'Deposit boxes', loot = { type = 'goldbar', min = 2, max = 4 }, time = 15 },
            },
        },
        truck = {
            label = 'Armoured truck', police = 3, crew = 3, cooldown = 90, timeLimit = 15,
            steps = {
                { type = 'truck', label = 'Stop the truck', alert = 'loud' },
                { type = 'truck_doors', label = 'Rear doors', difficulty = 2 },
                { type = 'loot', label = 'Cash bags', loot = { type = 'cash', min = 12000, max = 20000 }, time = 20 },
            },
        },
        store = {
            label = 'Store robbery', police = 2, crew = 1, cooldown = 45, timeLimit = 8,
            steps = {
                { type = 'loot', label = 'Till', loot = { type = 'cash', min = 800, max = 1600 }, time = 15, alert = 'silent' },
                { type = 'drill', label = 'Back-office safe', difficulty = 1 },
                { type = 'loot', label = 'Safe', loot = { type = 'cash', min = 2000, max = 4000 }, time = 10 },
            },
        },
        jewellery = {
            label = 'Jewellery store', police = 3, crew = 2, cooldown = 90, timeLimit = 10,
            steps = {
                { type = 'hack', label = 'Alarm panel', difficulty = 2, alert = 'loud' },
                { type = 'loot', label = 'Display case', loot = { type = 'jewels', min = 2, max = 4 }, time = 6 },
                { type = 'loot', label = 'Display case', loot = { type = 'jewels', min = 2, max = 4 }, time = 6 },
                { type = 'loot', label = 'Display case', loot = { type = 'jewels', min = 2, max = 4 }, time = 6 },
                { type = 'loot', label = 'Display case', loot = { type = 'jewels', min = 2, max = 4 }, time = 6 },
            },
        },
        custom = {
            label = 'Custom heist', police = 2, crew = 2, cooldown = 60, timeLimit = 15,
            steps = {},
        },
    },
}
