-- ──────────────────────────────────────────────────────────────────────────────
-- Dependency Check Helper                                                     
-- (Information) ► Returns the first matching started resource alias from provided table.
-- (Information) ► Used by Fuel/Keys/TextUI/Inventory/Target detection above.
-- ──────────────────────────────────────────────────────────────────────────────
function scriptCheck(data)            -- Do not modify unless you know what you're doing.
    for k, v in pairs(data) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

-- ──────────────────────────────────────────────────────────────────────────────
--  OTHERPLANET / OP Gangs 3.0 Main CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────
--  This configuration file controls all customizable behaviour of OP Gangs 3.0.
--  Always make a backup before editing.
--  Wrong edits can break the resource.
-- ──────────────────────────────────────────────────────────────────────────────

Config = {}                           

-- ──────────────────────────────────────────────────────────────────────────────
-- Locale & Debug                                                             
-- (Information) ► Locale controls which language file from locales/* will be used.
-- (Information) ► Debug enables extra logging to help with issue tracking.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Locale = "en"                  -- Supported: PL / ES / LT / HU / EN / FR / IT / PT / SK / TW / HR / EL / CZ / SI / AR / TR / DE / SV / NL / NO
Config.Debug  = false                 -- true = verbose debug output in console.

-- ──────────────────────────────────────────────────────────────────────────────
-- TIMEZONE                                                         
-- (Information) ► Full list of timezones is available in AvailableTimeZones.json
-- ──────────────────────────────────────────────────────────────────────────────

Config.TimeZone = "Europe/Warsaw"

-- ──────────────────────────────────────────────────────────────────────────────
-- Fuel Dependency Detection                                                   
-- (Information) ► Auto-detects your active fuel resource.
-- (Information) ► To add support for another fuel script, extend the list below and 
-- (Information) ► handle logic in the integrations where fuel is used.
-- ──────────────────────────────────────────────────────────────────────────────
local fuelScripts = {                 
    ['cdn-fuel']        = "cdn-fuel",
    ['ox_fuel']         = "ox-fuel",
    ['LegacyFuel']      = "LegacyFuel",
    ['rcore_fuel']      = "rcore-fuel",
    ['codem-xfuel']     = "codem-xfuel",
    ['lc_fuel']         = "lc_fuel",
    ['stg-fuel']        = "stg-fuel",
}
Config.FuelDependency = scriptCheck(fuelScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Vehicle Keys Dependency Detection                                           
-- (Information) ► Auto-detects supported vehicle key systems.
-- (Information) ► If none is found, script will behave as if no key system is present.
-- ──────────────────────────────────────────────────────────────────────────────
local keyScripts = {                  
    ['brutal_keys']        = "brutal_keys",
    ['qbx_vehiclekeys'] = "qb-keys",
    ['qb-vehiclekeys']            = "qb-keys",
    ['wasabi_carlock']     = "wasabi_carlock",
    ['sna-vehiclekeys']    = "sna-vehiclekeys",
    ['dusa_vehiclekeys']   = "dusa_vehiclekeys",
    ['Renewed-Vehiclekeys']= "Renewed-Vehiclekeys",
    ['tgiann-hotwire']     = "tgiann-keys",
    ['ak47_vehiclekeys']   = "ak47_vehiclekeys",
    ['ak47_qb_vehiclekeys']= "ak47_qb_vehiclekeys",
    ['mVehicle']           = "mVehicle",
    ['sy_carkeys']         = "sy_carkeys",
    ['MrNewbVehicleKeys']  = "MrNewbVehicleKeys",
    ['vehicles_keys']      = "vehicles_keys",
}
Config.KeysDependency = scriptCheck(keyScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Text UI Dependency Detection                                                
-- (Information) ► Auto-detects supported 3D/2D Text UI libraries.
-- (Information) ► If none is found, some prompts may fallback to default behaviour.
-- ──────────────────────────────────────────────────────────────────────────────
local textUIScripts = {              
    ['ox_lib']        = "ox_lib",
    ['jg-textui']     = "jg-textui",
    ['okokTextUI']    = "okokTextUI",
    ['brutal_textui'] = "brutal_textui",
    ['0r-textui']     = "0r-textui",
}
Config.TextUI = scriptCheck(textUIScripts) or 'none' 

-- ──────────────────────────────────────────────────────────────────────────────
-- Garage Script                                                               
-- (Information) ► Manual selection of external garage script integration.
-- (Information) ► If set to 'none', OP-Crime will handle garage logic internally where applicable.
-- ──────────────────────────────────────────────────────────────────────────────
Config.GarageScript = 'op-garages'          -- Options: 'none', 'op-garages', 'jg-advancedgarages'

-- ──────────────────────────────────────────────────────────────────────────────
-- Ambulance / Medical Script Detection                                        
-- (Information) ► Auto-detects the started ambulance job used by revivePlayer().
-- (Information) ► To support more ambulance scripts, extend the list and add a
--        matching handler in integrations/server/utils/reviveFunction.lua.
-- (Information) ► If none is found, revive falls back to the framework default
--        (ESX / QBCore / QBox).
-- ──────────────────────────────────────────────────────────────────────────────
local ambulanceScripts = {           
    ['wasabi_ambulance']   = "wasabi_ambulance",
    ['wasabi_ambulance_v2'] = "wasabi_ambulance_v2",
    ['esx_ambulancejob']   = "esx_ambulancejob",
    ['qb-ambulancejob']    = "qb-ambulancejob",
    ['qbx_medical']        = "qbx_medical",
    ['p_ambulancejob']     = "p_ambulancejob",
    ['tk_ambulancejob']    = "tk_ambulancejob",
    ['osp_ambulance']      = "osp_ambulance",
    ['sky_ambulancejob']   = "sky_ambulancejob",
    ['0r_ambulancejob']    = "0r_ambulancejob",
    ['brutal_ambulancejob']= "brutal_ambulancejob",
}
Config.AmbulanceJob = scriptCheck(ambulanceScripts) or 'framework'

-- ──────────────────────────────────────────────────────────────────────────────
-- Additional Script Integrations                                              
-- (Information) ► Toggle support for optional helper resources.
-- ──────────────────────────────────────────────────────────────────────────────
Config.AdditionalScripts = {         
    kq_shellcreator  = false,         -- (Information) ► true if you are using kq_shellcreator.
    advancedParking  = false          -- (Information) ► true if you use AdvancedParking.
}

local dispatchScripts = {            
    ['cd_dispatch']        = "cd_dispatch",
    ['codem_dispatch']     = "codem_dispatch",
    ['kartik-mdt']         = "kartik-mdt",
    ['lb-tablet']          = "lb-tablet",
    ['ps-dispatch']        = "ps-dispatch",
    ['rcore_dispatch']     = "rcore_dispatch",
    ['aty_dispatchv2']     = "aty_dispatchv2",
    ['frkn-dispatch']      = "frkn-dispatch",
    ['tk_dispatch']        = "tk_dispatch",
    ['origen_police']      = "origen_police",
    ['sky_jobs_base']      = "sky_jobs_base",
}
Config.dispatchScript = scriptCheck(dispatchScripts) or 'LG_Dispatch'

-- ──────────────────────────────────────────────────────────────────────────────
-- Inventory System Detection                                                  
-- (Information) ► Auto-detects currently started inventory system.
-- (Information) ► To support more inventories, extend the list and update inventory integration.
-- ──────────────────────────────────────────────────────────────────────────────
local inventoryScripts = {            
    ['ox_inventory']     = "ox_inventory",
    ['qb-inventory']     = "qb-inventory",
    ['codem-inventory']  = "codem-inventory",
    ['tgiann-inventory'] = "tgiann_inventory",
    ['origen_inventory'] = "origen_inventory",
    ['one_inventory']    = "one_inventory"
}

-- If you're using QB Inventory and it's not working properly set below option to:
-- Config.Inventory = {                  
--     inventoryScript = 'old-qb-inventory'
-- }

Config.Inventory = {                  
    inventoryScript = scriptCheck(inventoryScripts) or 'none'
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Currency Formatting                                                         
-- (Information) ► Visual formatting of money values in the UI (JS Intl.NumberFormat).
-- (Information) ► This does NOT change internal game currency logic, only display.
-- ──────────────────────────────────────────────────────────────────────────────
Config.CurrencySettings = {           
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat
    currency = "GBP",                 -- 'USD','EUR','PLN', etc.
    style    = "currency",            -- 'currency','decimal','percent','unit'
    format   = "en-GB"                -- Locale string for formatting.
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Dirty Money Handling                                                        
-- (Information) ► ESX: Uses default 'black_money' account automatically.
-- (Information) ► QB/QBOX: Uses configured item as dirty cash equivalent.
-- ──────────────────────────────────────────────────────────────────────────────
Config.DirtyMoney = {                 
    itemName = "dirty_money" -- Dirty money item name on QB/QBOX.
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ MISC CONFIGURATION ⚒️                                                   
-- (Information) ► General behaviour, markers, notifications, ranking limits, etc.
-- ──────────────────────────────────────────────────────────────────────────────

local targets = { -- Target libraries detection
    ['ox_target'] = "ox-target",
    ['qb-target'] = "qb-target"
}

local notifyScripts = { -- Notify libraries detection
    ['op-hud'] = "op_hud",
    ['okokNotify'] = "okokNotify",
    ['vms_notify'] = "vms_notify",
    ['ox_lib'] = "ox_lib",
    ['brutal_notify'] = "brutal_notify",
}

Config.Misc = {                       
    AccessMethod = scriptCheck(targets) or 'none', --  'ox-target' / 'qb-target' / 'none'
    zoneSize = 1.2,                   -- Marker radius for interaction zones.
    zoneColor = {                     -- Marker color (RGB).
        r = 219,
        g = 0,
        b = 0,
    },
    TowingTime = 5,                                -- Towing time in seconds.
    Notify = scriptCheck(notifyScripts) or 'none', -- Notify system: none / ESX / QBCORE / QBOX or auto detected from list 'notifyScripts'
    stashCapacityUpgradePer = 5,                   -- One stash upgrade = +X KG. Note: Changing this requires your changes in Locale file! UI description (will still display that upgrade adds 5kg until you adjust translation)
    ranksLimit   = 5,                              -- Max number of ranks per organisation.
    membersLimit = 20,                             -- Max number of members per organisation.
    limitBossMenu = false,                         -- true = only one player can access bossmenu at once. Note: You can limit bossmenu to one player at a time!
    disableGarage = false,                         -- true = completely disable garages & vehicle shop in bossmenu.
    disableDarkChat = false,                       -- true = disable darkchat in crime tablet.
    disableDarkChatNotificationAboveMap = false,   -- true = disable on-screen darkchat notifications.
    disableRanking = false,                        -- true = disable ranking page in tablet.
    defaultStashWeight = 2,                        -- Default Stash KG for new Gangs.
    defaultRanksSlotsAmount = 2,                   -- Default Ranks Slots for new Gangs.
    defaultRanksMembersAmount = 2,                 -- Default Member Slots for new Gangs.
    useDirtyMoneyInBossmenu = false,               -- Use Dirty money to purchase upgrades in bossmenu.
    useDirtyMoneyInVehicleShop = false,            -- true = vehicle shop buy/sell uses org dirty money instead of clean balance.
    disableGangBlip = false,                       -- Disables Gang Location Blip on gta Map
    disableStashes = false,                        -- Disable Stashes

    -- ── Per-organisation Discord webhooks (free upgrade) ──────────────────
    -- Each org can configure its own Discord webhook URLs from bossmenu
    -- ► Upgrades ► Discord Webhooks. Anyone with `bossmenu_access` can
    -- change them. Set the flags below to `false` to completely disable a
    -- given webhook category server-wide (no HTTP request will be sent
    -- even if a URL is configured).
    EnableOrgWebhooks = true,           -- Master switch for all per-org webhooks.
    EnableOrgWebhookSafe = true,           -- Safe deposits / withdraws / item purchases / upgrade purchases.
    EnableOrgWebhookZoneTake = true,           -- Notification when one of the gang members captures a turf zone.
    EnableOrgWebhookZoneActions = true,           -- Significant events inside turf zones
} 

Config.SellVehiclePercentage = 20     -- Percentage of original vehicle price when selling in bossmenu.

-- ──────────────────────────────────────────────────────────────────────────────
-- Admin Commands & Permissions                                                
-- (Information) ► Configure admin commands and who is allowed to use them.
-- ──────────────────────────────────────────────────────────────────────────────
Config.AdminPanelCommand   = "crimeadmin"   -- Command for Crime Admin Panel.
Config.SetJobCommand       = "setcrimejob"  -- Command to set selected player's crime job.
Config.AddCrimeVehicle     = "addcrimecar"  -- Command to add vehicle to selected organisation.
Config.FireCommand         = "firemember"   -- Command to fire member from current organisation.
Config.ResetGangsStats     = "resetgangstats" -- Wipes all gangs stats (zones, missions, etc.) used in ranking.
Config.ResetGangStats      = "resetgangstat"  -- Wipes stats for one gang. Usage: /resetgangstat <gangId>
Config.ResetGangMissions   = "resetgangmissions" -- Cancels active missions for one gang. Usage: /resetgangmissions <gangId>

-- List of allowed identifiers to use admin Commands /setcrimejob and /addcrimecar
-- (Information) ► Use identifiers from txAdmin -> IDs (no hardware IDs!).
-- (Information) ► You can also use character identifiers or citizenid on QBOX/QB.
-- E.g.: char1:7e0ec7b80d186fd8c29f6631e4377e75812fe8fd
Config.AdminCommandsPlayers = {      
    ['license:94792cad7ae764305aae8f1372d3cd287848ae7c'] = true,
    ['discord:571105311251890186'] = true,
}

-- List of allowed identifiers to use /crimeadmin
-- Same rules as above (txAdmin IDs / character identifiers / citizenid).
Config.AdminPanelPlayers = {          
    ['license:94792cad7ae764305aae8f1372d3cd287848ae7c'] = true,
    ['discord:571105311251890186'] = true,
}

-- List of allowed Ranks to use Admin Commands and Admin Panel.
Config.RanksPermissions = {
    AdminCommandsPlayers = {
        ['esx'] = {'superadmin', 'admin', 'mod', },
        ['qbcore'] = {'god', 'admin', },
        ['qbox'] = {'god', 'admin', },
    },
    AdminPanelPlayers = {
        ['esx'] = {'superadmin', 'admin', 'mod', },
        ['qbcore'] = {'god', 'admin', },
        ['qbox'] = {'god', 'admin', },
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- 📱 TABLET CONFIGURATION 📱                                                 
-- (Information) ► Controls how crime tablet is accessed and how missions are handled.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Tablet = {                     
    tabletASItem = false,             -- true = tablet is usable item, false = command-based.
    commandName = "crimetablet",      -- Command used when tabletASItem is false.
    item = {
        name = "crime_tablet"         -- Required item name if tabletASItem is true.
    },
    MissionsPerRestart = 15,           -- How many missions per organisation per update.
    DisableSeasonPass = false,        -- true = disable season pass feature Completly (As well from Boss Menu and Admin Panel).
    DisableFrames = false,            -- true = hide tablet frame UI elements.
    Animation = { -- Tablet Animation
        enable = true,
        dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
        name = "idle_a",
        prop = { -- Replace prop table with false (prop = false) if you want to disable it!
            Prop = "prop_cs_tablet",
            PropBone = 28422,
            PropPlacement = {
                -0.05,
                0.0,
                0.0,
                0.0,
                -90.0,
                0.0
            }
        }
    }
}

Config.SeasonPass = {
    -- To disable/enable season pass check Config.Tablet.DisableSeasonPass
    -- Configure custom currency exports in `op-crime/integrations/server/utils/customCurrency.lua`
    enableCustomCurrency = false, 
    customCurrencyLabel = "GC", -- Label of coins, example: Purchase for 950GC
}

-- ──────────────────────────────────────────────────────────────────────────────
-- 🌍 BLIPS CONFIGURATION 🌍                                                  
-- (Information) ► Map blips for organisations, garages, zones and money laundry.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Blips = {                      
    BlipScale = 0.8,                  -- Global blip scale.
    ShowBlipsOnMap = true,            -- false = hide money laundry, garages and illegal medic blips.
    ZonesShowBlipsOnMap = true,       -- false = hide PVP/turf zone blips.
    Medic = { blipId = 51, blipColor = 7 },
    Organisation = { blipId = 437, blipColor = 1 },
    Zone = { blipId = 379, blipColor = 3 },
    Garage = { blipId = 357, blipColor = 2 },
    MoneyLaundry = { blipId = 318, blipColor = 25 },
    MoneyLaundryLocation = { blipId = 478, blipColor = 1 },
    LaundryLocationRadiusBlip = { 
        Color = 49,
        Alpha = 222,
        Radius = 60.0
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- 🧼 MONEY LAUNDRY CONFIGURATION 🧼                                         
-- (Information) ► Settings for dirty money washing missions.
-- ──────────────────────────────────────────────────────────────────────────────
Config.MoneyLaundry = {               
    Disable = false,                  -- true = disable entire money laundry feature.
    laundryAmountPerOneStop = 20000,  -- Amount of dirty money cleaned per location.
    laundryPercentage = 15,           -- Tax percentage taken from laundered amount.
    -- Fail the job if player leaves the laundry truck and stays too far for too long.
    Abandon = {
        Enable = true,
        Distance = 75.0,              -- Max distance from the laundry vehicle (meters).
        TimeSeconds = 60,             -- Seconds allowed outside that range before auto-cancel.
    },
    Ped = {                           -- Set to false to disable ped (Ped = false,).
        model = "a_m_m_afriamer_01",
        gender = "male", -- options: male/female
    },
    laundryMisc = {
        location = vec4(78.8508, 112.5588, 80.1682, 161.7077),
        vehicleSpawnCoords = vec4(68.4445, 119.2293, 79.1232, 161.5234),
        vehicleModel = 'boxville4',
        -- LAUNDRY MISSION OUTFIT IS LOCATED NOW IN config/ClothingConfig.lua
    },
    laundryLocations = {
        {
            coords = vec4(237.7540, 22.6503, 82.6137, 341.4727)
        },
        {
            coords = vec4(-77.5555, -1200.6666, 26.6352, 92.4784)
        },
        {
            coords = vec4(232.4930, -1771.4315, 27.6610, 48.4330)
        },
        {
            coords = vec4(967.5204, -1823.1718, 30.0824, 229.1019)
        },
        {
            coords = vec4(947.5532, -1698.1992, 29.0851, 84.8497)
        },
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- 🏥 MEDIC CONFIGURATION 🏥                                                 
-- (Information) ► Illegal medic / healing spot configuration.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Medic = {                      
    Disable = false,                  -- true = disable this feature.
    HealingTime = 10,                 -- Healing time in seconds.
    Ped = {
        model = "s_m_m_scientist_01",
        gender = "male",
        animation = {
            Dict = "missheistdockssetup1clipboard@base",
            Lib  = "base",
            Prop = {
                Prop = 'prop_notepad_01',
                PropBone = 18905,
                PropPlacement = {
                    0.1,
                    0.02,
                    0.05,
                    10.0,
                    0.0,
                    0.0
                }
            }
        }
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- 📍 PVP ZONES CONFIGURATION 📍                                             
-- (Information) ► Non-turf PVP zones. For Turf Zones see: config/TurfConfig.lua
-- ──────────────────────────────────────────────────────────────────────────────

-- THIS IS SECTION FOR PVP ZONES (NO TURFZONES)
-- IF YOU WANT TO CONFIGURE TURF ZONES - GO TO config/TurfConfig.lua

Config.ZonesMisc = {                 
    PerOnePlayerInside = 0.3,           -- Time (in seconds) for 1% capture progress for one org.
    -- If there are 2 organisations in zone the zone capturing percentage will stop.
    ZonesCooldown   = 15,             -- Cooldown time (in minutes) after a capture.
    ZoneCaptureEXP  = 150,            -- EXP given per zone capture.
    Disable         = false,          -- true = disable PVP zones completely.
    ZoneTimers = {
        -- Time window when zones can be captured
        enable = false,
        -- WARNING: Make sure you configured correct Config.TimeZone in MainConfig.lua
        -- INFORMATION: Use 24 hours time format
        startTime = "02:00",
        endTime   = "11:00",
    }
}

Config.Zones = {                      -- Add custom PVP zones here.
    -- To create new zones use /pzcreate poly
    -- To add new point to created poly use /pzadd 
    -- More info: https://github.com/mkafrin/PolyZone
    {
        label = "Sandy Scrapy Yard",
        index = "sandyscrapy",
        coords = vec3(2404.2021, 3104.1765, 48.1648),
        rewards = {
            enable = false,
            list = {
                {
                    rewardType = "item",       ---@param rewardType "item" | "money" | "blackmoney"
                    itemName   = "spray_can",
                    amount     = 10,
                    -- EXAMPLE OF METADATA USAGE (only for ox_inv):
                    -- metadata   = {
                    --     testmeta = 69
                    -- }
                },
            }
        },
        Zone = function()
            return PolyZone:Create({
                vector2(2329.3020019532, 3053.681640625),
                vector2(2330.888671875, 3081.3254394532),
                vector2(2361.8330078125, 3087.1943359375),
                vector2(2379.0219726562, 3105.4108886718),
                vector2(2404.3395996094, 3163.1628417968),
                vector2(2437.2124023438, 3160.5307617188),
                vector2(2434.8149414062, 3024.4143066406),
                vector2(2329.9057617188, 3024.9143066406)
            }, {
                name = "SandyScrapyYard",
            })
        end,
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ROPE MENU                                                                 
-- (Information) ► Enables rope item / keybind usage with optional target integration.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Rope = {                       
    Enable = true, -- false = disable rope completly
    Item = {
        Enable   = false,
        ItemName = "rope",             -- Rope item name.
        RemoveItem = false            -- Remove item when tie/untie
    },
    Keybind = {
        Enable = false,
        Bind   = "F6"                 -- Keybind used for rope menu when enabled.
    },
    Target = {
        RequireItemInInventory = false, 
        RequiredItemName = "rope",
        Enable = true                 -- true = add target options to every player.
        -- When it's enabled - will add options to every player on the server.
    },
    -- Server-side death check cache TTL (ms) used when opening rope menu / tying players.
    DeathCheckCacheMs = 5000,
    DeathStateKeys = {
        'dead', 'isDead', 'isdead', 'InLaststand', 'inlaststand', 'isInLaststand', 'incoma', 'isDown', 'isUnconscious',
    },
    -- Optional client-side death animations (dict + clip) for custom ambulance scripts.
    DeathAnimations = {
        { dict = 'mini@cpr@char_b@cpr_def', clip = 'cpr_pumpchest_idle' },
        { dict = 'dead', clip = 'dead_a' },
        { dict = 'combat@damage@writhe', clip = 'writhe_loop' },
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- GANG WARS                                                               
-- (Information) ► All configuration for Gang Wars.
-- ──────────────────────────────────────────────────────────────────────────────
Config.GangWars = {
    enable = true, -- Enable/Disable Gangwars
    requiredLevel = 1, -- Required minimum level to use gangwars!
    disableKillWars = false, 
    disableDrugWars = false
}

-- ──────────────────────────────────────────────────────────────────────────────
-- AIRDROPS                                                                  
-- (Information) ► Global configuration for Airdrop events, guards and rewards.
-- ──────────────────────────────────────────────────────────────────────────────
Config.AirDrop = {                    
    Guards = {
        enable = true,
        amount = 8, 
        weaponsList = {
            `weapon_SNSPISTOL`,
            `WEAPON_SNSPISTOL_MK2`,
            `WEAPON_VINTAGEPISTOL`,
            `WEAPON_PISTOL`
        },
        guardModels = { 
            "s_m_y_blackops_01", 
            "s_m_y_blackops_02", 
            "s_m_m_armoured_01", 
            "s_m_m_marine_01" 
        },
        taskRadius = 250.0, -- Players within this range receive guard AI setup (not only gang members).
        spawnTriggerRadius = 500.0, -- Closest player within this range spawns networked guards client-side.
        maxAiClients = 8, -- Cap how many clients drive guard AI (prevents entity-control storms on 100+ player servers).
        aiRefreshMs = 15000, -- How often nearby clients are re-assigned guard AI tasks.
    },
    RequiredItems = {
        --["crowbar"] = {
        --    itemName = "crowbar",
        --    quanity = 1
        --},
    },
    SpawnTimeWindow = {
        -- Time window when Air Drops are auto started.
        enable = false,
        -- WARNING: Make sure you configured correct Config.TimeZone in MainConfig.lua
        -- INFORMATION: Use 24 hours time format
        startTime = "17:00",
        endTime   = "23:00",
    },
    StartCommand = {
        Enable = true,               -- Allow your admins to start AirDrop manually.
        CommandName = "startAirDrop" -- Command name to start Airdrop.
    },
    TimeToLand = 2,                  -- Time in minutes before airdrop starts going down.
    Enable = true,                   -- Master toggle for Airdrop system.
    VisibleToEveryone = false,       -- true = all players can see and open airdrops. false = only gang members.
    BroadcastBatchSize = 8,          -- Clients notified per server tick (prevents PL spike on 100+ pop landings).
    FallAnimDistance = 400.0,        -- Only clients within this range play the falling-crate animation.
    Timer = 2,                       -- Interval in hours between automatic airdrops.
    DespawnTime = 25,                -- Minutes after which unopened airdrop will despawn.
    Locations = {
        vec4(470.7527, 2942.3884, 40.7600, 95.2011),
        vec4(1350.2504, 4354.7686, 42.7147, 315.9569),
        vec4(2034.9507, 4764.8198, 40.0590, 290.3700),
        vec4(3700.1226, 4533.2456, 22.2974, 193.3774),
        vec4(1518.1498, 6341.2002, 23.0057, 171.9430),
        vec4(-70.5034, 1910.8385, 195.1936, 196.7471),
    },
    Exp = 100,                       -- EXP given for opening Airdrop.
    Blip = {
        EnableRadiusBlip = true,     -- Master toggle for the on-map radius highlight.
        Blip       = 550,            -- Sprite for the main airdrop blip (location pin).
        BlipColor  = 3,              -- Color for the main airdrop blip.
        RadiusBlipSize  = 60.0,      -- Radius (in game units) of the highlighted area on the map.
        RadiusBlipColor = 49,        -- Color of the radius blip (see GTA blip color table).
        RadiusBlipAlpha = 222,       -- Alpha/transparency of the radius blip (0-255).
    },
    Dispatch = {
        enable = true,                -- Send a dispatch alert to police when an airdrop is starting.
        title = "Airdrop Spotted",
        message = "Unidentified cargo is being air-dropped. Possible high-value contraband incoming.",
        type = "Airdrop",             -- Must exist in your dispatch script config (ps-dispatch: alerts.lua). Use e.g. "Robbery" if unsure.
        blip = {
            color  = 1,
            sprite = 161,
        }
    },
    RewardsAmount = 3,               -- Number of random rewards per airdrop.
    Rewards = {

        {
            rewardType = "item",       ---@param rewardType "item" | "money" | "blackmoney"
            itemName   = "spray_can",
            amount     = 10,
            chance     = 50,
        },
        {
            rewardType = "item",       ---@param rewardType "item" | "money" | "blackmoney"
            itemName   = "spray_remover",
            amount     = 10,
            chance     = 50,
        },
        {
            rewardType = "blackmoney", ---@param rewardType "item" | "money" | "blackmoney"
            itemName   = "black_money",
            amount     = 100000,
            chance     = 50,
        },
        --[[
        EXAMPLE ITEM WITH METADATA:
        {
            rewardType = "item",       --@param rewardType "item" | "money" | "blackmoney"
            itemName   = "testitem",
            amount     = 15,
            chance     = 50,
            metadata   = {
                testmeta = 69
            }
        },--]]
        -- [Note]: Metadata currently works only for ox_inventory. 
        -- If you want metadata compatible with your inventory script:
        -- Files that need to be edited: `integrations/server/inventory/`
        -- and one of `framework/server` functions Fr.AddItem
    },
    ProgressTime = 10000,            -- Time in milliseconds for opening progress bar.
    SkillCheck = function()          -- Custom skill check function (uses ox_lib by default).
        return lib.skillCheck({'easy', 'easy', 'medium', 'easy', 'medium'}, {'w', 'a', 's', 'd'})
    end,
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Garage Disable Marker Helper                                               
-- (Information) ► Some external garage scripts manage their own markers/blips.
-- (Information) ► This helper allows OP-Crime to disable its own markers when needed.
-- ──────────────────────────────────────────────────────────────────────────────
-- Do not touch function below if you don't know what you're changing!
Config.GarageDisableMarker = function() 
    if Config.GarageScript == 'jg-advancedgarages' then 
        return true
    else 
        return false
    end
end

Config.DisableMissionCreatorNotify = true -- disables notification about mission creator detection in tx console. 