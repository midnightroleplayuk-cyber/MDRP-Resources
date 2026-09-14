Config = {}

Config.Framework = 'auto' -- options: 'qbcore', 'esx', or 'auto' for auto-detection

Config.TargetSystem = "ox_target" -- "ox_target" or "qb-target"

Config.LawEnforcementJobs = {
    ['police'] = true
}

Config.useLGModsMDT = true -- only enable this if you have the LGModsMDT resource installed

Config.StationName = "Sinner Street Station"

Config.AlarmTestDuration = 10

-- alarm config for sinner street station
Config.AlarmSound = {
    enabled = true,
    volume = 60,
    file = "sounds/alarm.mp3",
    distance = 100.0
}

Config.Inventory = {
    System = "ox_inventory", -- qb-inventory, ox_inventory, esx, codem-inventory, qs-inventory
    WeightUnit = "g", -- keep it as g
    UseSerialNumbers = true,
    SerialFormat = "UKPS-%d%d%d%d%d",
    Debug = false
}


-- alarm config for sandy station
Config.FireAlarmSound = {
    enabled = true,
    volume = 50,
    file = "sounds/fire_alarm.MP3",
    distance = 150.0
}

Config.FireAlarmLights = {
    enabled = true, -- set to false to disable red flashing lights on fire alarms
    flashOnDuration = 800,
    flashOffDuration = 400,
    lightColor = {255, 0, 0}, -- red
    lightRange = 3.0, 
    lightIntensity = 100.0 -- light intensity (0-255)
}

Config.ArmoryLocation = vector3(461.9, -980.88, 29.69)
Config.ArmoryPin = "1234"
Config.ArmoryRange = 1.5

Config.BodycamItem = "bodycam" -- item you get when you check out a bodycam

Config.TaserItem = "WEAPON_STUNGUN" -- item you get when you check out a taser

Config.Debug = true -- enable this to see debug messages in the console

Config.MugshotSystem = {
    DiscordWebhook = {
        enabled = true, -- Set to false to disable Discord integration
        url = "discord_webhook_here", -- Replace with your Discord webhook URL
        embedColor = 3447003, -- blue color (decimal)
    }
}

Config.ClothingStations = {
    {
        id = "sinner_street_station",
        location = ,
        heading = 5.0585,
        range = 2.0,
        menuTitle = "Sinner Street Station - Clothing",
        outfits = {
            {
                name = "Police Uniform",
                description = "Standard police officer uniform",
                components = {
                    ["torso"] = { drawableId = 610, textureId = 3, paletteId = 0 },
                    ["undershirt"] = { drawableId = 243, textureId = 0, paletteId = 0 },
                    ["legs"] = { drawableId = 233, textureId = 0, paletteId = 0 },
                    ["shoes"] = { drawableId = 160, textureId = 0, paletteId = 0 },
                    ["accessory"] = { drawableId = 217, textureId = 1, paletteId = 0 },
                    ["hat"] = { drawableId = 243, textureId = 2, paletteId = 0 }
                }
            },
            {
                name = "Detective Outfit",
                description = "Plain clothes detective outfit",
                components = {
                    ["torso"] = { drawableId = 4, textureId = 0, paletteId = 0 },
                    ["undershirt"] = { drawableId = 4, textureId = 0, paletteId = 0 },
                    ["legs"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["shoes"] = { drawableId = 1, textureId = 0, paletteId = 0 },
                    ["accessory"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["kevlar"] = { drawableId = 0, textureId = 0, paletteId = 0 }
                }
            },
            {
                name = "Tactical Gear",
                description = "Full tactical response equipment",
                components = {
                    ["torso"] = { drawableId = 18, textureId = 0, paletteId = 0 },
                    ["undershirt"] = { drawableId = 26, textureId = 0, paletteId = 0 },
                    ["legs"] = { drawableId = 32, textureId = 0, paletteId = 0 },
                    ["shoes"] = { drawableId = 25, textureId = 0, paletteId = 0 },
                    ["accessory"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["kevlar"] = { drawableId = 12, textureId = 0, paletteId = 0 }
                }
            }
        }
    },
    {
        id = "sinner_street_station",
        location = vector3(456.0962, -988.3626, 30.6898),
        heading = 5.0585,
        range = 2.0,
        menuTitle = "Sinner Street Station - Clothing",
        outfits = {
            {
                name = "Police Uniform",
                description = "Standard police officer uniform",
                components = {
                    ["torso"] = { drawableId = 11, textureId = 0, paletteId = 0 },
                    ["undershirt"] = { drawableId = 15, textureId = 0, paletteId = 0 },
                    ["legs"] = { drawableId = 4, textureId = 0, paletteId = 0 },
                    ["shoes"] = { drawableId = 10, textureId = 0, paletteId = 0 },
                    ["accessory"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["kevlar"] = { drawableId = 0, textureId = 0, paletteId = 0 }
                }
            },
            {
                name = "Detective Outfit",
                description = "Plain clothes detective outfit",
                components = {
                    ["torso"] = { drawableId = 4, textureId = 0, paletteId = 0 },
                    ["undershirt"] = { drawableId = 4, textureId = 0, paletteId = 0 },
                    ["legs"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["shoes"] = { drawableId = 1, textureId = 0, paletteId = 0 },
                    ["accessory"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["kevlar"] = { drawableId = 0, textureId = 0, paletteId = 0 }
                }
            },
            {
                name = "Tactical Gear",
                description = "Full tactical response equipment",
                components = {
                    ["torso"] = { drawableId = 18, textureId = 0, paletteId = 0 },
                    ["undershirt"] = { drawableId = 26, textureId = 0, paletteId = 0 },
                    ["legs"] = { drawableId = 32, textureId = 0, paletteId = 0 },
                    ["shoes"] = { drawableId = 25, textureId = 0, paletteId = 0 },
                    ["accessory"] = { drawableId = 0, textureId = 0, paletteId = 0 },
                    ["kevlar"] = { drawableId = 12, textureId = 0, paletteId = 0 }
                }
            }
        }
    }
}

Config.ClothingStation = Config.ClothingStations[1] -- leave this as is

-- Custody toilets
Config.FlushableItems = {
    'phone',
    'lockpick',
    'advancedlockpick',
    -- add things like drugs etc, small items too keep it realistic
}

Config.CellToilets = {
    {
        cellNumber = 1,
        flushButton = vector3(470.77, -995.01, 24.99),
        toilet = vector3(470.87, -994.8, 24.0),
        stashId = "cell_1_toilet"
    },
    {
        cellNumber = 2,
        flushButton = vector3(475.06, -995.01, 24.98),
        toilet = vector3(475.07, -994.8, 24.05),
        stashId = "cell_2_toilet"
    },
    {
        cellNumber = 3,
        flushButton = vector3(479.36, -995.01, 24.99),
        toilet = vector3(479.36, -994.75, 24.0),
        stashId = "cell_3_toilet"
    },
    {
        cellNumber = 4,
        flushButton = vector3(482.5, -1004.99, 24.99),
        toilet = vector3(482.46, -1005.21, 24.01),
        stashId = "cell_4_toilet"
    },
    {
        cellNumber = 5,
        flushButton = vector3(478.22, -1005.0, 24.98),
        toilet = vector3(478.13, -1005.22, 24.0),
        stashId = "cell_5_toilet"
    },
    {
        cellNumber = 6,
        flushButton = vector3(473.91, -1004.99, 24.98),
        toilet = vector3(473.85, -1005.22, 24.0),
        stashId = "cell_6_toilet"
    }
}

Config.ToiletStash = {
    maxWeight = 50000, -- 50kg in grams
    maxSlots = 3
}

Config.ToiletFlushSound = {
    enabled = true,
    range = 10.0,    -- distance in meters players can hear the flush up too
    volume = 0.5    
}