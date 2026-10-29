Config = {}

Config.Debug = true

Config.Language = "en" -- Language to use.

Config.RenderDistance = 100.0 -- Model Display Radius.

Config.InteractDistance = 2.0 -- Interact Radius

Config.UseTarget = true -- When set to true, it'll use targeting instead of key-presses to interact.

Config.NoModelTargeting = true -- When set to true and using Target, it'll spawn a small invisible prop so you can third-eye when no entity is defined.

Config.Marker = { -- This will only be used if enabled, not using target, and no model is defined in the interaction.
    enabled = true,
    id = 2,
    scale = 0.25, 
    color = {255, 255, 255, 127}
}

Config.GiveKeys = function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    -- Replace this line with your export / event to give keys for your vehicle.
end

Config.Fires = {
    flammable = true, -- Players catch on fire when near enough (determined by flame.fireRadius)
    damageUpdate = 2, -- Update server-side upon release or when damage applied reaches this number.
    requiredFirefighters = 1, -- Amount of firefighters to require after
    blip = {
        enabled = true,
        label = "Active Fire",
        id = 436,
        color = 1,
        scale = 0.75,
    },
    scenarios = {
        randomSpawn = true, -- Random scenarios will start.
        cooldown = 120, -- Check if last scenario is complete, if so, do the next one.
    },
    water = { -- Water Tank Settings
        capacity = 100, -- Max tank capacity.
        waterPerTick = 0.1, -- Water to decrease while spraying.
        damage = 0.5,
        range = 20.0
    },
    extinguisher = { -- Fire Extinguisher Settings
        hash = `WEAPON_FIREEXTINGUISHER`,
        damage = 0.25,
        range = 3.0
    },
    truck = { -- Firetruck Settings
        vehicles = { `firetruk` },
        damage = 0.5,
        range = 20.0,
    },
    rewards = { -- Rewards for putting out a fire, if multiple put a fire out, it is distributed based on the amount of damage done to it.
        {type = "cash", amount = 500},
        {type = "xp", name = "firefighter", amount = 1000},
    },
}

Config.XPEnabled = true -- When set to true, this will enable Pickle's XP compatibility, and enable xp rewards.

Config.XPCategories = { -- Registered XP Types for Pickle's XP.
    ["firefighter"] = {
        label = "Firefighter", 
        xpStart = 1000, 
        xpFactor = 0.2, 
        maxLevel = 2
    },
}

Config.Alerts = function(notifyType, data) -- Alerts used in the script, great for linking to dispatch systems.
    if notifyType == "startFire" then 
        ShowNotification(_L("fire_started"))
    elseif notifyType == "stopFire" then 
        -- No notification required.
    end
end

Config.Explosions = {
    explosionTypes = {3, 6, 7, 8, 9, 10, 17, 27, 28, 31, 49}, -- Add / Remove allowed explosion types (https://wiki.rage.mp/index.php?title=Explosions)
    explosionEvent = function(source, data) -- Callback for explosions that are defined above.
        local coords = vector3(data.posX, data.posY, data.posZ)
        local pcoords = GetEntityCoords(GetPlayerPed(source))
        local dist = #(coords-pcoords)
        if dist < 100.0 then 
            StartFire(coords)
        end
    end
}

Config.AdminPermissions = { -- Start / Stop Fires & Scenarios.
    jobs = {["firefighter"] = 3},
    groups = {"admin", "god"}
}

Config.Default = {
    permissions = { -- Permissions settings.
        duty = {
            jobs = {["firefighter"] = 0},
            groups = {"admin", "god"}
        },
    },
    outfit = { -- On-duty outfits.
        male = {
            ['arms'] = 17,
            ['tshirt_1'] = 15, 
            ['tshirt_2'] = 0,
            ['torso_1'] = 314, 
            ['torso_2'] = 0,
            ['bproof_1'] = 0,
            ['bproof_2'] = 0,
            ['decals_1'] = 0, 
            ['decals_2'] = 0,
            ['chain_1'] = 0,
            ['chain_2'] = 0,
            ['pants_1'] = 120, 
            ['pants_2'] = 0,
            ['shoes_1'] = 24, 
            ['shoes_2'] = 0,
            ['helmet_1'] = 45, 
            ['helmet_2'] = 0,
        },
        female = {
            ['arms'] = 17,
            ['tshirt_1'] = 15, 
            ['tshirt_2'] = 0,
            ['torso_1'] = 314, 
            ['torso_2'] = 0,
            ['bproof_1'] = 0,
            ['bproof_2'] = 0,
            ['decals_1'] = 0, 
            ['decals_2'] = 0,
            ['chain_1'] = 0,
            ['chain_2'] = 0,
            ['pants_1'] = 120, 
            ['pants_2'] = 0,
            ['shoes_1'] = 24, 
            ['shoes_2'] = 0,
            ['helmet_1'] = 45, 
            ['helmet_2'] = 0,
        }
    },
    flame = { -- Default flame for each fire.
        dict = "core",
        particle = "fire_object",
        stack = 3, -- Amount of flames to stack on eachother.
        height = 0.4, -- Each flame particle's height
        scale = 3.0,
        fireRadius = 1.25,
    },
    smoke = { -- Default smoke for each fire.
        dict = "des_gas_station",
        particle = "ent_ray_paleto_gas_plume_L",
        stack = 3, -- Amount of flames to stack on eachother.
        height = 6.0, -- Each flame particle's height
        scale = 1.0,
    }

}

Config.Departments = {
    {
        job = "firefighter", -- This is what the boss menu will be based on. It is recommended to only allow this job in this department.
        label = "Los Santos Fire Department", -- Department label for notifications & texts.
        permissions = nil, -- When nil, defaults to Config.Default.permissions.  
        outfit = nil, -- When nil, defaults to Config.Default.outfit.  
        blip = {
            label = "Los Santos Fire Department",
            coords = vector3(204.8514, -1652.1567, 29.8007),
            id = 60,
            color = 1,
            scale = 0.75,
        },
        boss = {
            coords = vector3(193.0856, -1641.4713, 29.8007),
            heading = 45.2183
        },
        duty = {
            model = {hash = `mp_m_boatstaff_01`},
            coords = vector3(198.8848, -1639.2321, 29.8008),
            heading = 273.0646
        },
        vehicles = {
            coords = vector3(214.9789, -1651.9619, 29.8007),
            heading = 50.5791,
            model = {hash = `s_m_y_fireman_01`},
            spawn = {
                coords = vector3(209.1309, -1647.2399, 29.8687),
                heading = 320.1417,
            },
            catalog = {
                {
                    label = "Firetruck", 
                    model = `firetruk`, 
                    description = "A great truck that gets the job done.",
                    required = {
                        {type = "cash", amount = 100},
                        {type = "xp", name = "firefighter", amount = 1}, -- Amount = Level
                    }
                },
            }
        },
        store = {
            coords = vector3(205.2619, -1641.4888, 29.8008),
            heading = 49.1569,
            catalog = {
                {
                    name = "watertank",
                    description = "A portable water tank to put out fires with.",
                    amount = 1,
                    required = {
                        {type = "cash", amount = 100},
                        {type = "xp", name = "firefighter", amount = 1}, -- Amount = Level
                    },
                },
            }
        },
    }
}

Config.Scenarios = { 
    {
        name = "franklin",
        fires = {
            {
                coords = vector3(-17.7840, -1443.3939, 30.6376),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-20.0744, -1435.5403, 30.6602),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-10.2389, -1426.4388, 30.6727),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-10.1611, -1443.3431, 30.6738),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-14.1288, -1441.7429, 30.1018),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-10.2170, -1439.2109, 30.1016),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-17.5458, -1436.6942, 30.1016),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-11.0510, -1433.4421, 30.1168),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-14.5996, -1427.4121, 30.1015),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
        }
    },
    {
        name = "forest",
        fires = {
            {
                coords = vector3(-435.2981, 5830.5811, 46.9693),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-435.2981, 5830.5811, 49.9693),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-460.0644, 5817.6553, 46.2260),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-460.0644, 5817.6553, 49.2260),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-449.6477, 5808.2983, 50.5812),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-449.6477, 5808.2983, 53.5812),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-446.1616, 5790.0830, 53.5636),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-446.1616, 5790.0830, 56.5636),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-433.9079, 5807.8237, 51.7966),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-433.8140, 5823.1353, 48.9123),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(-446.7181, 5837.4780, 42.0280),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
        }
    },
    {
        name = "bank",
        fires = {
            {
                coords = vector3(145.5394, -1037.5907, 28.3679),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(143.6929, -1043.0345, 28.3679),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(145.9486, -1044.4193, 28.3760),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(153.7933, -1037.7429, 36.0848),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(151.7776, -1037.2156, 35.1881),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(149.7964, -1036.1306, 35.7086),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
            {
                coords = vector3(148.3150, -1035.2568, 35.7621),
                data = nil, -- Change this to use custom fire & smoke settings.
            },
        }
    },
}