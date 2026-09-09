Config = {}
Config.Locale = "en" -- Supported: EN / PL / HU / SK / CZ / DE / TR / FR / SL / TW / AR / PT / HR / IT / ES
Config.FuelDependency = "lc_fuel" -- Options: none, cdn-fuel, ox-fuel, LegacyFuel, qs-fuel, rcore-fuel, codem-xfuel, lc_fuel
Config.KeysDependency = "qb-keys" -- Options: none, brutal_keys, qs-keys, qb-keys, wasabi_carlock, sna-vehiclekeys, dusa_vehiclekeys, Renewed-Vehiclekeys, tgiann-keys, ak47_vehiclekeys, ak47_qb_vehiclekeys, MrNewbVehicleKeys, p_carkeys, mVehicle, sy_carkeys
Config.TextUI = "ox_lib" -- Options: none, ox_lib, jg-textui, qs-textui, okokTextUI, brutal_textui, 0r-textui

Config.Misc = {
    Notify = "ox_lib", -- Supported: op_hud / okokNotify / vms_notify / brutal_notify / ox_lib / ESX / QBCORE / QBOX
    Target = "ox-target",  -- none / ox-target / qb-target
    zoneSize = 2.9, -- Marker radius.
    zoneColor = { -- Marker color.
        r = 52,
        g = 116,
        b = 235,
    },
    Icons = { -- OX Target / QB Target icons.
        informationPed = "fa-solid fa-question",
        containerTarget = "fa-solid fa-money-bill-wave",
    }, 
    DisableParticles = false,
}

Config.CurrencySettings = {
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat
    currency = "GBP",
    style = "currency",
    format = "en-GB"
}

----------------------------------------------------------------------------
-- ⚒️ TIMEZONE ⚒️
----------------------------------------------------------------------------

-- List of available TimeZones you can find in config/AvailableTimeZones.json
Config.TimeZone = "GMT" -- Script use our own api.

----------------------------------------------------------------------------
-- ⚒️ PED ON DOCS WITH INFORMATIONS ABOUT WARS. ⚒️
----------------------------------------------------------------------------

Config.Ped = {
    Coords = vec4(839.1903, -2924.0081, 4.8919, 267.4886),
    Disable = false,
    Ped = {
        model = "player_one",
        gender = "male"
    }
}

----------------------------------------------------------------------------
-- ⚒️ Blip Settings ⚒️
----------------------------------------------------------------------------

Config.Blip = {
    Coords = vec3(839.1903, -2924.0081, 4.8919),
    size = 1.2,
    blipId = 568, 
    blipColor = 1
}

----------------------------------------------------------------------------
-- ⚒️ PLANNED WARS TIME ⚒️
----------------------------------------------------------------------------

-- Here you can add wars that will start at selected time and day.
Config.PlannedWars = {
    ['cars_war'] = {
        disableStart = false, -- Disable auto start. Use this if you want to manually start war using command.
        containersAmount = 8, -- Min. 1 | Max. 8
        startDate = {
            -- War will start everyday at 18:00:
            weekDay = "all", -- all/monday/tuesday/wednesday/thursday/friday/saturday/sunday
            hour = "22:45", -- Hour of day in 24 format.
        },
        dropConfig = "drop_car_war",
        containerStartPrice = 100000,
        minimumEntry = 10000,
        extendTime = 30, -- Time in seconds of which war will be extended when player will bid in last 60 seconds. 
        warTime = 20, -- Time in Minutes of Total time war!
        showRewards = true, -- Show or Hide possible rewards in containers!
    }
}

----------------------------------------------------------------------------
-- ⚒️ ADMIN COMMANDS ⚒️
----------------------------------------------------------------------------

Config.StartWarCommand = "startwar" -- Allow administarator to start selected war immediatly 
-- Command will not work if there is on going war now. As well planned wars will not start.

-- List of allowed identifiers to use /startwar
-- You can use all identifiers from TXADMIN -> `IDs` (No Hardware IDs!)
-- You can also use character identifier to allow only selected character of administrator:
-- E.X: char1:7e0ec7b80d186fd8c29f6631e4377e75812fe8fd
-- OR ON QBOX/QB CITIZENID!!

Config.AdminCommandPlayers = {
    ['fivem:17286926'] = true, --KAPPER
    ['fivem:14369934'] = true, --KUZA
}

----------------------------------------------------------------------------
-- ⚒️ DROP CONFIG ⚒️
----------------------------------------------------------------------------

-- Configuration of possible drop in container.
Config.DropsConfig = {
    ['drop_car_war'] = {
        -- You can setup drop for each container.
        -- If you will setup only one container script will fill other containers with the same config. 
        -- In case if you will setup 2 containers and war will have 5 containers, rest will be filled with first container rewards.
        [1] = {
            {
                modelName = "zentorno",
                label = "Zentorno", 
                img = "https://data.otherplanet.dev/cars/zentorno.png",
                rarity = "red", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 1600000, -- resell price
            },
            {
                modelName = "thrax",
                label = "Thrax", 
                img = "https://data.otherplanet.dev/cars/thrax.png",
                rarity = "red", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 2400000, -- resell price
            },
            {
                modelName = "tenf2",
                label = "Obey Tenf", 
                img = "https://data.otherplanet.dev/cars/tenf2.png",
                rarity = "gold", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 3100000, -- resell price
            },
            {
                modelName = "tempesta",
                label = "Tempesta", 
                img = "https://data.otherplanet.dev/cars/tempesta.png",
                rarity = "gold", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 2900000, -- resell price
            },
            {
                modelName = "reaper",
                label = "Reaper", 
                img = "https://data.otherplanet.dev/cars/reaper.png",
                rarity = "red", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 1900000, -- resell price
            },
            {
                modelName = "italigto",
                label = "Itali GTO", 
                img = "https://data.otherplanet.dev/cars/italigto.png",
                rarity = "gold", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 2700000, -- resell price
            },
            {
                modelName = "comet7",
                label = "Comet", 
                img = "https://data.otherplanet.dev/cars/comet7.png",
                rarity = "purple", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 1700000, -- resell price
            },
            {
                modelName = "rebla",
                label = "Rebla GTS", 
                img = "https://data.otherplanet.dev/cars/rebla.png",
                rarity = "blue", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 500000, -- resell price
            },
            {
                modelName = "vd_buffalo4h",
                label = "Buffalo SXT", 
                img = "https://data.otherplanet.dev/cars/buffalo4.png",
                rarity = "purple", -- blue/purple/red/gold
                type = "car", -- item/car/money
                quantity = 1,
                price = 1500000, -- resell price
            },
        },
        [2] = {
            
            {
                modelName = "cryptomainer",
                --- @param multipleRewards is Optional! If its enabled it will not give reward model above, it will showcase only the item above in UI.
                --- Important: MultipleRewards can not be vehicles.
                multipleRewards = { 
                    {
                        modelName = "firework1",
                        type = "item",
                        quantity = 5,
                    },
                    {
                        modelName = "rolex",
                        type = "item",
                        quantity = 15,
                    },
                }, 
                label = "Crypto Mainer", 
                img = "https://cdn3d.iconscout.com/3d/premium/thumb/crypto-miner-3d-illustration-download-in-png-blend-fbx-gltf-file-formats--bitcoin-logo-gpu-mining-graphic-card-computer-part-pack-appliances-illustrations-4284306.png",
                rarity = "gold", -- blue/purple/red/gold
                type = "item", -- item/car/money
                quantity = 1,
                price = 0, -- resell price
            },
        }
    }
}

----------------------------------------------------------------------------
-- ⚒️ DROP CHANCE ⚒️
----------------------------------------------------------------------------

-- Drop chances assigned to selected rarity.
Config.DropChance = {
    blue = 10,
    purple = 10,
    red = 10,
    gold = 10
}

----------------------------------------------------------------------------
-- ⚒️ VEHICLE SPAWN POINTS (AFTER CLAIMING REWARD) ⚒️
----------------------------------------------------------------------------

Config.vehiclesSpawnPoints = {
    [1] = vec4(967.6500, -2911.4358, 5.9021, 181.0892),
    [2] = vec4(975.0701, -2911.2815, 5.9021, 184.7735),
    [3] = vec4(985.0701, -2911.2815, 5.9021, 184.7735),
    [4] = vec4(995.0701, -2911.2815, 5.9021, 184.7735),
    [5] = vec4(1005.0701, -2911.2815, 5.9021, 184.7735),
    [6] = vec4(1015.0701, -2911.2815, 5.9021, 184.7735),
    [7] = vec4(1025.0701, -2911.2815, 5.9021, 184.7735),
    [8] = vec4(1035.0701, -2911.2815, 5.9021, 184.7735)
}