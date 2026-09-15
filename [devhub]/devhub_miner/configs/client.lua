Config = {}
  
Config.OreSpawnDistance = 60.0 -- Distance from the player to spawn ores

Config.DrillingTime = 8000 -- Time to drill the ore in ms

Config.SmeltingTime = 30000 -- Time to smelt the ore in ms

Config.MainPed = {
    model = "s_m_y_construct_02",
    coords = vec4(2832.3860, 2798.6382, 57.4497, 100.6738),
    sprite = 527, -- set to false if you don't want blip
    color = 5,
    scale = 0.8,
    name = "Miner Job",
}

Config.Smelting = {
    coords = vec3(1084.6836, -2002.9283, 31.3806),
    sprite = 618,
    color = 5,
    scale = 0.8,
    name = "Smelting",
} 

Config.Selling = {
    coords = vec3(-624.5422, -231.0968, 38.0570),
    sprite = 617,
    color = 5,
    scale = 0.8,
    name = "Selling",
}
 
-- IF YOU WANT TO CHANGE CHANGING CLOTHES SYSTEM, OPEN dh_lib/frameworks/c.clothing.lua
Config.Clothing = { -- max 3 per gender
    ["mp_m_freemode_01"] = { 
        {
            img = "https://cfx-nui-devhub_miner/html/host/miner_m1.png",
            clothes = {
                torso = {65, 3},
                tshirt = { 155, 0 },
                pants = { 38, 3 },
                boots = { 27, 0 },
                gloves = { 64, 0 },
                hat = { 144, 3 },
            }
        },
        {
            img = "https://cfx-nui-devhub_miner/html/host/miner_m2.png",
            clothes = {
                torso = {65, 0},
                tshirt = { 155, 0 },
                pants = { 38, 0 },
                boots = { 27, 0 },
                gloves = { 64, 0 },
                hat = { 0, 0 },
            }
        },
        {
            img = "https://cfx-nui-devhub_miner/html/host/miner_m3.png",
            clothes = {
                torso = {65, 1},
                tshirt = { 155, 0 },
                pants = { 38, 1 },
                boots = { 27, 0 },
                gloves = { 64, 0 },
                hat = { 145, 0 },
            }
        },
    },
    ["mp_f_freemode_01"] = {
        {
            img = "https://cfx-nui-devhub_miner/html/host/miner_f1.png",
            clothes = {
                torso = { 59, 3 },
                tshirt = { 191, 0 },
                pants = { 38, 3 },
                boots = { 26, 0 },
                gloves = { 75, 0 },
                hat = { 144, 3 },
            }
        },
        {
            img = "https://cfx-nui-devhub_miner/html/host/miner_f2.png",
            clothes = {
                torso = { 59, 0 },
                tshirt = { 191, 0 },
                pants = { 38, 0 },
                boots = { 26, 0 },
                gloves = { 75, 0 },
                hat = { 0, 0 },
            }
        },
        {
            img = "https://cfx-nui-devhub_miner/html/host/miner_f3.png",
            clothes = {
                torso = { 59, 1 },
                tshirt = { 191, 0 },
                pants = { 38, 1 },
                boots = { 26, 0 },
                gloves = { 75, 0 },
                hat = { 144, 2 },
            }
        },
    },
}
  
Config.Vehicles = { --max 2 vehicles
    -- { -- use it if you want to disable vehicle
        -- model = "none",
        -- price = 0,
        -- img = "https://cfx-nui-devhub_miner/html/host/none.png",
    -- },
    {
        model = "bodhi2",
        price = 100,
        img = "https://cfx-nui-devhub_miner/html/host/bodhi2.png",
    },
    {
        model = "sandking",
        price = 300,
        img = "https://cfx-nui-devhub_miner/html/host/sandking.png",
    },
}

Config.VehiclesSpawnPoints = {
    vec4(2827.2422, 2800.7427, 57.6350, 177.0261),
    vec4(2843.1853, 2790.4595, 59.6977, 212.7704),
    vec4(2839.3914, 2773.9546, 60.9099, 232.5432),
}
 
Config.NotificationsTypes = {
    ["info"] = "https://cfx-nui-devhub_miner/html/host/info.png",
    ["success"] = "https://cfx-nui-devhub_miner/html/host/success.png",
    ["error"] = "https://cfx-nui-devhub_miner/html/host/error.png",
}


-- HudPlacement can be a string ("bottom-right", "bottom-left", "top-right", "top-left") or a table for custom position:
-- Example: { left = 10, top = 20, snapTo = "left" } (percentages, snapTo: "left", "right", or "center")
-- You can also use right and/or bottom instead of left/top:
-- { right = 5, bottom = 10, snapTo = "center" }
-- If both left and right (or top and bottom) are set, left/top takes precedence.
Config.HudPlacement = "bottom-right" -- or set to { right = 5, bottom = 10, snapTo = "center" }

-- qb-core/shared/items.lua 
-- Copy
--  ["finger_scanner"] = {
--         ["name"] = "finger_scanner",                                                        
--         ["label"] = "Finger Scanner",
--         ["weight"] = 0,
--         ["type"] = "item",
--         ["image"] = "finger_scanner.png",
--         ["unique"] = false,
--         ["useable"] = true,
--         ["shouldClose"] = true,
--         ["combinable"] = nil,
--         ["description"] = ""
--     },
-- ox_inventory/data/items.lua
-- Copy
-- ['finger_scanner'] = {
--     label = 'Finger Scanner',
--     weight = 0,
--     stack = true,
--     close = true,
--     description = ""
-- },

Config.DisableFinishPopup = false -- disable finish popup, if set to true, finish popup will not be shown, it will be replaced with a notification
