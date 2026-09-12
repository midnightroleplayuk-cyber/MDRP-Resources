--[[
    Start tgiann-core script after es_extented/qb-core/qbox/oxmysql script and before tgiann-* scripts

    - If you are having any problems, please check the channels on my discord. If your problem is not resolved, open a ticket.
    - Discord: http://dc.tgiann.com
    - Docs: https://tgiann.gitbook.io/tgiann
    - Core Exports: https://docs.tgiann.com/scripts/tgiann-core
]]

configCore = {}
config = {}

-- ⚠️ Please read this first! (https://tgiann.gitbook.io/tgiann/main/how-to-change-the-language-file)
config.lang = "en"

-- Here you can change the locale settings for money and time.
-- For example, if you want to show money in euro and time in german format, you can change the values like this de-DE and EUR
-- You can find the locale codes here: https://www.localeplanet.com/icu/
config.locale = {
    timeLocale = "en-GB",
    moneyLocale = "en-GB",
    moneyCurrency = "GBP",
}

-- number of online police needed to control
config.policeJobs = {
    "police",
}

-- Changes the main hud color of tgiann scripts.
config.defaultColor = { background = "#a536ff", color = "#252525" }

-- Default dark mode state of the core glass UIs (menu, text ui, input menu).
-- Players can toggle it with the darkmode command, their choice is saved on their client
config.darkMode = true

-- If true, the database will be created automatically. If false, you must create the database manually.
config.autoCreateDatabase = true

-- If true, instead of the text ui(eg: E | Open Shop) on the right, it appears as a target.
-- This setting is for those who want everything to work as a target, not designed for scripts. It can cause various interaction problems!
configCore.textUiAsTarget = true

---@type "left" | "right"
-- Choose which side you want to show the text ui(eg: E | Open Shop).
configCore.textUiLocation = "right"

-- Use tgiann's drawtext3d function instead of QB and ESX
configCore.tgiannDrawText3D = false
-- Check the artifact version of the server. (If you are using a broken version, it will give a warning in the console.)
configCore.checkArtifactVersion = true

configCore.playerOwnableLimits = {
    maxOwned = 2, -- how many businesses one player can own in total

    -- How many businesses of one script a player can own, on top of the total
    maxOwnedPerScript = {
        ["tgiann-mechanic"] = 1,     -- mechanic shops
        ["tgiann-food-jobs"] = 1,    -- food businesses
        ["tgiann-vehicleshop"] = 1,  -- vehicle shops
        ["tgiann-rent-vehicle"] = 1, -- rental offices
        ["tgiann-realparking"] = 1,  -- garages
        ["tgiann-clothing"] = 1,     -- clothing stores
        ["tgiann-inventory"] = 1,    -- laundries
        ["tgiann-bank"] = 1,         -- atms
    },

    maxEmployed = 1, -- how many different businesses one player can work at in total

    -- How many businesses of one script a player can work at, same format as maxOwnedPerScript
    maxEmployedPerScript = {
        -- ["tgiann-mechanic"] = 1,         -- mechanic shops
        -- ["tgiann-food-jobs"] = 1,        -- food businesses
        -- ["tgiann-vehicleshop"] = 1,      -- vehicle shops
        -- ["tgiann-rent-vehicle"] = 1,     -- rental offices
        -- ["tgiann-realparking"] = 1,      -- garages
        -- ["tgiann-clothing"] = 1,         -- clothing stores
        -- ["tgiann-inventory"] = 1,        -- laundries
        -- ["tgiann-bank"] = 1,             -- atms
    },

    ownerCountsAsWorkplace = true, -- true = owning a business also counts toward the work limits
}

-- The name and grade level of the unemployed job in your server.
configCore.unemployedJob = { name = "unemployed", grade = 0 }

configCore.commands = {
    changeLang = { -- it helps to change language in TGIANN scripts.
        name = "language",
        help = "CHANGE_LANGUAGE_COMMAND_DESC",
    },
    removeOwnableLocation = { -- it helps to remove ownable locations in TGIANN scripts.
        name = "removeOwnableLocation",
        help = "COMPANY_COMMAND_REMOVE_OWNABLE_LOCATION_DESC",
        perm = "group.admin"
    },
    addOwnableLocation = { -- gives an ownable location to a player as its boss or as an employee.
        name = "addOwnableLocation",
        help = "COMPANY_COMMAND_ADD_OWNABLE_LOCATION_DESC",
        perm = "group.admin"
    },
    darkMode = { -- toggles the dark mode of the core glass UIs (menu, text ui).
        name = "darkmode",
        help = "DARK_MODE_COMMAND_DESC",
    }
}

--Don't change this if you don't know what you are doing!
configCore.frameworkConfig = {
    esxScriptName = "es_extended",                  -- https://github.com/esx-framework/esx_core/tree/main/%5Bcore%5D/es_extended
    qbScriptName = "qb-core",                       -- https://github.com/qbcore-framework/qb-core
    qbxScriptName = "qbx_core",                     -- https://github.com/Qbox-project/qbx_core
    tgiannInventoryScriptName = "tgiann-inventory", -- https://store.tgiann.com/package/6251398
    oxInventoryScriptName = "ox_inventory",         -- https://github.com/overextended/ox_inventory
    codemInventoryScriptName = "codem-inventory",
    origenInventoryScriptName = "origen_inventory",
    coreInventoryScriptName = "core_inventory",
    oxMysqlScriptName = "oxmysql", -- https://github.com/overextended/oxmysql
    wasabiAmbulanceV2 = "wasabi_ambulance_v2",
    wasabiAmbulance = "wasabi_ambulance",
    oxTarget = "ox_target",
    qbTarget = "qb-target",
}

-- Shows the location of the menus created when the button is pressed.
configCore.showClosestMenuKey = "LMENU"
-- The distance at which the closest menu will be shown when the button is pressed.
configCore.showClosestMenuDistance = 20

configCore.custom = {
    customInventory = false, -- If you set this to true, you need to edit the files in folder client\inventory\custom\main.lua and server\inventory\custom\main.lua.
    deadReviveControl = {
        ---@type "event" | "statebag"
        -- if your ambulance script triggers qb and esx's default events when you die or get revived, use event here. if it changes state, make it "statebag".
        -- you may need to edit client/main.lua file.
        method = "event",
        custom = {
            active = false,                        -- if you are using a different ambulance script, make it true and edit the events (also u can change event from client/main.lua)
            deadEvent = "baseevents:onPlayerDied", -- https://docs.fivem.net/docs/resources/baseevents/events/onPlayerDied/
            reviveEvent = "playerSpawned",         -- https://docs.fivem.net/docs/resources/spawnmanager/events/playerSpawned/
        },
    },
    drawText = {
        active = false,
        ---@param uniqName string Unique name for the text
        ---@param button string Button text to display
        ---@param text string Text to display
        ---@diagnostic disable-next-line: unused-local
        openFunc = function(uniqName, button, text)
            lib.showTextUI(text)
        end,
        ---@param uniqName string Unique name for the text
        ---@diagnostic disable-next-line: unused-local
        closeFunc = function(uniqName)
            lib.hideTextUI()
        end
    },
    notif = {
        active = false, -- If you are using a different notify system, set active to true and edit the notify function
        ---@param msg string
        ---@param msgType? "primary" | "success" | "error"
        ---@param time? number
        func = function(msg, msgType, time)
            local _msgType = msgType --[[@as "info" | "success" | "error"]]
            if not _msgType or _msgType == "primary" then _msgType = "info" end
            lib.notify({
                title = 'Notification',
                description = msg,
                type = _msgType,
                duration = time or 5000,
            })
        end
    },
    uiDrawText3D = {
        active = false,           -- If you want to use something other than tgiann 3d draw text, you can activate this. (When true, some problems may arise!!!)
        triggerEveryTick = false, -- When true, the openFunc function is triggered every tick.
        ---@param uniqName string Unique name for the text
        ---@param data [string, string][] -- Data to display, where each item is a table with two strings: [1] = key, [2] = text
        ---@param coord vector3
        ---@param screenPos { x: number, y: number }
        ---@diagnostic disable-next-line: unused-local
        openFunc = function(uniqName, data, coord, screenPos)
            local text = ""
            local length = #data
            for i = 1, length do
                text = ("[%s] %s%s"):format(data[i][1], data[i][2], i < length and " " or "")
            end
            lib.showTextUI(text)
        end,
        ---@param uniqName string Unique name for the text
        ---@diagnostic disable-next-line: unused-local
        closeFunc = function(uniqName)
            lib.hideTextUI()
        end
    },
}

-- These keys are saved using RegisterKeyMapping and written to your FiveM cache.
-- If you enter the game and change these keys, you won't see the change in the game because the values ​​will be retrieved from your cache.
-- You need to change them in the GTA Keybinds section.
configCore.gizmoKeys = {
    translate = "E",
    rotate = "R",
    toggleRelative = "Q",
    toggleUiGizmo = "END",
}

-- Default gizmo type. true = UI (web) gizmo, false = native gizmo.
-- The player's last choice (toggled with the toggleUiGizmo key) is saved and overrides this default once they switch.
configCore.gizmoDefaultUiMode = true

-- Don't change these below.
config.test = false         -- Dont touch this
config.tgiannServer = false -- Dont touch this
configCore.langs = {}

exports("getConfig", function() return config end)
exports("GetConfig", function() return config end)
