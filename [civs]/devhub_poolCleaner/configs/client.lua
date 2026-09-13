Config = {}
  
-- IF YOU WANT TO CHANGE CHANGING CLOTHES SYSTEM, OPEN devhub_lib
Config.Clothing = { -- max 3 per gender
    ["mp_m_freemode_01"] = { 
        {
            img = "https://cfx-nui-"..Shared.JobName.."/html/host/jobCloth_m1.webp",
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
            img = "https://cfx-nui-"..Shared.JobName.."/html/host/jobCloth_m2.webp",
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
            img = "https://cfx-nui-"..Shared.JobName.."/html/host/jobCloth_m3.webp",
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
            img = "https://cfx-nui-"..Shared.JobName.."/html/host/jobCloth_f1.webp",
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
            img = "https://cfx-nui-"..Shared.JobName.."/html/host/jobCloth_f2.webp",
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
            img = "https://cfx-nui-"..Shared.JobName.."/html/host/jobCloth_f3.webp",
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

Config.QuestsEnabled = true

-- if model = "none", vehicle will not spawn
Config.Vehicles = { --max 2 vehicles
    {
        model = "bodhi2",
        price = 0,
        img = "https://cfx-nui-"..Shared.JobName.."/html/host/bodhi2.webp",
    },
    {
        model = "sandking",
        price = 300,
        img = "https://cfx-nui-"..Shared.JobName.."/html/host/sandking.webp",
    },
}
Config.VehiclesSpawnPoints = {
    vec4(-1124.4052, -1432.7837, 5.1076, 300.7606),
    vec4(-1134.9561, -1439.5707, 4.8362, 303.0237),
    vec4(-1133.8962, -1449.1044, 4.9604, 35.0877),
}
 
Config.NotificationsTypes = {
    ["info"] = "https://cfx-nui-"..Shared.JobName.."/html/host/info.webp",
    ["success"] = "https://cfx-nui-"..Shared.JobName.."/html/host/success.webp",
    ["error"] = "https://cfx-nui-"..Shared.JobName.."/html/host/error.webp",
}
 
-- HudPlacement can be a string ("bottom-left", etc) or a table for custom position:
-- Example: { left = 10, top = 20, snapTo = "left" } (percentages, snapTo: "left", "right", or "center")
-- You can also use right and/or bottom instead of left/top:
-- { right = 5, bottom = 10, snapTo = "center" }
-- If both left and right (or top and bottom) are set, left/top takes precedence.
Config.HudPlacement = { right = 0, bottom = 0, snapTo = "right" } -- or set to { right = 5, bottom = 10, snapTo = "center" }

Config.MainPed = {
    model = "s_m_m_autoshop_01",
    coords = vec4(-1118.3071, -1439.8015, 5.1075, 307.7654),
    sprite = 677, -- set to false if you don't want blip
    color = 5,
    scale = 0.8,
    name = "Pool Cleaner Job",
}

Config.Selling = {
    coords = vec3(237.9128, -412.8228, 48.1119),
    blip = {
        sprite = 677,
        color = 5,
        scale = 0.8,
        name = "Sell Point",
    }
}

Config.DisableTaskNotification = false -- disable task notification, task + 1 will not be shown on the screen if set to true
Config.DisableHelpControls = false -- disable help controls, help controls will not be shown on the screen if set to true

------ Job

Config.PoolBlip = {
    sprite = 677,
    color = 5,
    scale = 0.8,
    name = "Job Location",
}

Config.ControlButtonsPosition = "top-left" -- "top-left" / "top-right" / "bottom-left" / "bottom-right"

-- update 1.0.2

Config.EnableTrash3dIcon = true -- enable 3D icons for trash props, set to false to disable, it might be helpful with finding trash props
Config.Trash3dIconDistance = 3.0 -- distance to show 3D icons, if player is closer than this distance, icon will be shown
Config.Trash3dIconRefreshRate = 500 -- how often to refresh 3D icons, in milliseconds

Config.DisableFinishPopup = false -- disable finish popup, if set to true, finish popup will not be shown, it will be replaced with a notification