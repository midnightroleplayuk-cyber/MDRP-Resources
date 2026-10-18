
---@type Job
return {
    level = 1,
    label = locale('money_laundering.label'),
    description = locale('money_laundering.description'),
    image = 'laundering.png',
    reward = { exp = 0, money = 0 },
    information = locale('money_laundering.information'),
    -- NOT currently enforced: the lab is entered directly via placed props/NUI
    -- and never goes through server:jobs:startIllegalJob, so this field has
    -- no effect here (unlike every other job). Kept for config consistency.
    requiredMinCopCount = 0,
    steps = {
        { label = 'Buy lab gear from the Black Market' },
        { label = 'Place generator + washer in the lab' },
        { label = 'Load dirty money + chemical, then collect clean cash' },
    },
    blips = {
        lab_location = { sprite = 500, color = 2, text = locale('money_laundering.blips.lab_location') },
    },

    -- Lab system (replaces old instant wash mission)
    lab = {
        ipl = 'v_industrial_warehouse',
        entry = {
            enablePed = true,
            enableBlip = true,
            ped = 'a_m_m_prolhost_01',
            coords = vec4(1197.23, -3255.17, 7.1, 93.99),
            label = 'Enter Laundering Lab',
        },
        interior = vec4(-1114.32, -3377.94, -97.5, 6.71),
        exit = {
            coords = vec4(-1114.32, -3377.94, -97.5, 6.71),
            label = 'Exit Lab',
        },
        -- Hardware is sold on the Darknet Black Market only (no in-lab shop)
        -- Kept tight to the interior room so props can't be placed outside the lab
        activityRadius = 20.0,
        propSpawnRadius = 50.0,
        propDespawnRadius = 60.0,

        ownership = {
            mode = 'player', -- player | job | group | shared
            allowedJobs = {},
            groupExport = { resource = 'my-groups', export = 'GetPlayerGroupId' },
        },

        tickMs = 5000,
        baseHeatRate = 2,
        fanRadius = 10.0,
        heatDamageThreshold = 90,
        -- Wash rate multiplier (speed 300 → ~$1500 dirty per 5s tick at washScale 300)
        washScale = 300,
        -- 1 solvent bottle processes this much dirty money before being consumed
        dirtyPerChemical = 15000,
        autoWireNearest = true,

        placement = {
            maxDistance = 8.0,
            rotateStep = 5.0,
            groundOffset = 0.0,
        },

        equipment = {
            washer_basic = {
                label = 'Basic Washer',
                category = 'machine',
                prop_type = 'machine',
                model = 'bkr_prop_prtmachine_dryer',
                price = 8000,
                speed = 300,
                maxDirty = 25000,
                maxClean = 25000,
                maxDurability = 100,
                powerDraw = 1,
                description = 'Entry-level washing unit.',
            },
            washer_industrial = {
                label = 'Industrial Washer',
                category = 'machine',
                prop_type = 'machine',
                model = 'bkr_prop_prtmachine_dryer_spin',
                price = 18000,
                speed = 600,
                maxDirty = 75000,
                maxClean = 75000,
                maxDurability = 120,
                powerDraw = 2,
                description = 'Higher throughput washer.',
            },
            washer_heavy = {
                label = 'Heavy Washer',
                category = 'machine',
                prop_type = 'machine',
                model = 'bkr_prop_prtmachine_dryer_op',
                price = 35000,
                speed = 1000,
                maxDirty = 150000,
                maxClean = 150000,
                maxDurability = 150,
                powerDraw = 3,
                description = 'Heavy-duty washing unit.',
            },
            generator_small = {
                label = 'Small Generator',
                category = 'generator',
                prop_type = 'generator',
                model = 'prop_generator_01a',
                price = 12000,
                maxFuel = 100,
                -- ~14 hours on a full tank (tick every 5s)
                fuelBurnPerTick = 0.01,
                maxPower = 3,
                maxDurability = 100,
                description = 'Powers up to 3 load units. Full tank lasts ~14 hours.',
            },
            generator_large = {
                label = 'Large Generator',
                category = 'generator',
                prop_type = 'generator',
                model = 'prop_air_generator_01',
                price = 28000,
                maxFuel = 200,
                -- ~28 hours on a full tank (tick every 5s)
                fuelBurnPerTick = 0.01,
                maxPower = 8,
                maxDurability = 140,
                description = 'Industrial multi-machine generator. Full tank lasts ~28 hours.',
            },
            cooling_fan = {
                label = 'Cooling Fan',
                category = 'fan',
                prop_type = 'fan',
                model = 'prop_fan_01',
                price = 4500,
                coolRate = 4,
                powerDraw = 1,
                maxDurability = 100,
                description = 'Cools nearby washers.',
            },
            cash_press = {
                label = 'Money Printing Press',
                category = 'collector',
                prop_type = 'collector',
                model = 'bkr_prop_printmachine_4rollerpress',
                price = 10000,
                maxClean = 250000,
                maxDurability = 100,
                description = 'Printing press that stores cleaned cash from linked washers.',
            },
        },

        chemicals = {
            launder_chem_basic = {
                label = 'Basic Solvent',
                price = 500,
                efficiency = 0.80,
                description = '80% conversion. 1 bottle processes $15k dirty.',
            },
            launder_chem_premium = {
                label = 'Premium Solvent',
                price = 1200,
                efficiency = 0.95,
                description = '95% conversion. 1 bottle processes $15k dirty.',
            },
        },

        maintenance = {
            fuel_can = {
                label = 'Fuel Can',
                price = 350,
                fuelAmount = 50,
                description = 'Refuels a generator (+50 fuel).',
            },
            repair_kit = {
                label = 'Repair Kit',
                price = 800,
                repairAmount = 35,
                description = 'Restores unit durability.',
            },
        },
    },
}
