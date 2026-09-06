-- ─────────────────────────────────────────────────────────────────────────
-- OTHERPLANET / OP Multicharacter - Main Configuration File
-- (Information) ► This file controls language, clothing integration, currency,
--                 spawn selector, starter items, notifications and scenes.
-- (Information) ► Do not rename fields or change structure unless you know
--                 exactly how the script reads this config.
-- ─────────────────────────────────────────────────────────────────────────

Config = {}

-- ─────────────────────────────────────────────────────────────────────────
-- Locale & Debug                                                             
-- (Information) ► Locale controls which translation file is loaded.
-- (Information) ► Debug enables extra prints/logs for troubleshooting.
-- ─────────────────────────────────────────────────────────────────────────
Config.Locale = "en" -- Supported: EN / FR / HR / HU / LT / SK / SL / CZ / SV / TR / DE / EL / ES / PL
Config.Debug = false
Config.DisableBlackScreens = true
Config.DisableBugHunter = true
Config.EnableNativeBlackScreens = false -- Enabled DoScreenFadeIn and DoScreenFadeOut

-- IMPORTANT: DisableBlackScreens will disable all fade in/out animations, additional loading screens etc!

-- ─────────────────────────────────────────────────────────────────────────
-- Clothing & Tattoo System Detection                                             
-- (Information) ► Following clothing scripts will not start cutscene/spawn selector after character created: tgiann-clothing
-- ─────────────────────────────────────────────────────────────────────────

-- SUPPORTED CLOTHING SCRIPTS
-- op-clothing (https://otherplanet.dev/product/clothing)
-- skinchanger
-- crm-appearance
-- fivem-appearance
-- illenium-appearance
-- qb-clothing
-- rcore_clothing
-- tgiann-clothing
-- qs-appearance
-- qf_skinmenu
-- qf_skinmenu_v2 
-- p_appearance
-- sn_appearance
-- origen_clothing
-- 4bit_appearance
-- bl_appearance
-- aty_clothing (integration is in beta phase)
-- um-clothing

Config.Clothing = "op-clothing"

-- SUPPORTED TATTOOS SCRIPTS
-- rcore_tattoos

Config.Tattoos = "none" -- none / rcore_tattoos

-- SUPPORTED PRISON SCRIPTS
-- rcore_prison
-- (Information) ► When enabled, inmates skip spawn selector and are handed off
--                 to the prison resource after character select.

Config.Prison = "none" -- none / rcore_prison

-- ─────────────────────────────────────────────────────────────────────────
-- Weather Sync                                                               
-- (Information) ► While the player is inside multichar scenes / scene creator,
--                 the selected weather sync resource is paused
-- ─────────────────────────────────────────────────────────────────────────
-- SUPPORTED:
-- none
-- qb-weathersync
-- qbx_weathersync
-- weathersync
-- cd_easytime
-- vSync
-- Renewed-Weathersync
-- av_weather
-- ft_qb_weathersystem   (FT Scripts QB - https://github.com/ftscripts/weathersystem)
-- ft_weathersystem      (FT Scripts ESX)
Config.WeatherResource = "qbx_weathersync"

-- ─────────────────────────────────────────────────────────────────────────
-- Housing System Detection                                                  
-- (Information) ► Set your housing script to give started house for player
-- ─────────────────────────────────────────────────────────────────────────
-- SUPPORTED HOUSING SCRIPTS
-- nolag_properties
-- vms_housing
-- rtx_housing
-- bcs_housing
-- rcore_housing

Config.Housing = "none" 

-- ─────────────────────────────────────────────────────────────────────────
-- Notify System Detection                                                  
-- (Information) ► Set your notification script
-- ─────────────────────────────────────────────────────────────────────────
-- Notify scripts:
-- okokNotify
-- vms_notify
-- ox_lib
-- brutal_notify
-- op_hud
-- ESX
-- QBCORE
-- QBOX

Config.Notify = "ox_lib"

-- ─────────────────────────────────────────────────────────────────────────
-- Currency Formatting                                                       
-- (Information) ► Visual currency format used in UI (JS Intl.NumberFormat).
-- (Information) ► Does not change actual economy, only how numbers are shown.
-- ─────────────────────────────────────────────────────────────────────────
Config.CurrencySettings = {
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat
    currency = "GBP",
    style    = "currency",
    format   = "en-GB"
}

-- ─────────────────────────────────────────────────────────────────────────
-- Start Cutscene                                                            
-- (Information) ► Enables or disables the initial intro cutscene for players.
-- ─────────────────────────────────────────────────────────────────────────
Config.EnableStartCutScene = true
Config.CutSceneData = {
    welcomeTextHeader = "Midnight Roleplay",
    welcomeTextDesc = "British City | Real Roleplay."
}

-- ─────────────────────────────────────────────────────────────────────────
-- Player Switch Function                                                           
-- (Information) ► Enables or disables the player switch (Map zoom and zoom-out).
-- (Information) ► If you disabled Spawn Selector you can also adjust start
-- coordinates here!
-- ─────────────────────────────────────────────────────────────────────────
Config.SwitchPlayer = {
    enable = false, -- This will work only if spawn selector is disabled!
    startCoords = vec4(-1037.6252, -2737.7544, 19.1693, 326.5721), -- This will work only if spawn selector is disabled!
    disableSwitchOnNewCharacter = true, -- Disables switch on new character
}

-- ─────────────────────────────────────────────────────────────────────────
-- Wake Up Animation
-- (Information) ► Optional "wake up" cinematic played whenever a player spawns
--                 into the world (with OR without the spawn selector).
-- (Information) ► The character gets up from the ground (GTA peyote wakeup)
--                 with a cinematic camera that blends smoothly back to gameplay.
-- ─────────────────────────────────────────────────────────────────────────
Config.Wakeup = {
    enable = false,
    dict = "random@peyote@generic",
    anim = "wakeup",
    flag = 0,          -- animation flag (0 = play once and stand up)
    camFov = 42.0,     -- cinematic camera field of view
    blendBack = 2000,  -- ms of smooth blend back to the gameplay camera (0 = instant cut)
    testCommand = false, -- dev preview only; registers when Config.Debug = true (never bind X to this in FiveM key binds)
}

-- ─────────────────────────────────────────────────────────────────────────
-- Spawn Selector                                                             
-- (Information) ► Controls the spawn menu that appears after character select.
-- (Information) ► "isLastLocation = true" will use last saved coordinates.
-- (Information) ► "spawnCoords = vec4(...)" defines static spawn locations.
-- (Information) ► Classic mode uses `classic.locations` with explicit camera:
--                 camCoords, camLookAt, camFov, spawnCoords per location.
-- (Information) ► Tablet mode uses `locations` below (taxi + DUI tablet).
-- ─────────────────────────────────────────────────────────────────────────
Config.SpawnSelector = {
    enable = false, 
    enableOnlyForNewCharacters = false,
    cameraDuration = 3000,
    -- Mode:
    -- "tablet"  -> taxi + tablet (DUI)
    -- "classic" -> full-screen NUI + camera preview per location
    mode = "tablet",
    scene = {
        taxiCoords = vec4(179.9604, -1013.4479, 28.2737, 198.6579),
        baseTaxiCoords = vec4(179.9604, -1013.4479, 28.2737, 198.6579),
        baseTabletCoords = vec4(179.86762272057, -1013.1270742881, 29.255701065063, 198.6579),
        baseTabletRotation = vec3(2.2, -91.3, -162.4),
        taxiModel = "taxi",
        passengerSeat = 2,
        driverModel = "mp_m_waremech_01",
        -- Optional overrides (usually leave false to use auto-calibration)
        tabletAttachOffset = false,
        tabletOffset = false,
        tabletRotation = false,
        tabletCoords = false,
        -- Camera: vehicle-local offsets (x=right, y=forward, z=up).
        -- Thanks to this you change ONLY taxiCoords and everything still lines up.
        cameraStartOffset = vec3(0.0, -1.4, 0.6),
        cameraEndOffset = vec3(0.0, -0.72, 0.33),
        cameraFov = 45.0,
    },
    -- Classic mode: separate locations with explicit camera + spawn coords (tablet uses `locations` below).
    classic = {
        defaultCamFov = 40.0,
        locationFadeMs = 250, -- quick fade out/in when switching classic preview locations
        entryLoaderMs = 1200, -- bottom-right spinner after character select, before spawn selector opens
        -- Auto camera for "Last Location"
        lastLocationCam = {
            backDistance  = 45.0, -- units behind saved heading
            sideDistance  = -4.0, -- units to the right (+) / left (-)
            height        = 7.0,  -- units above spawn Z (Sandy Shores uses ~6)
            lookHeight    = 0.0,  -- look-at height offset from spawn Z
            minHorizontal = 28.0, -- never closer horizontally (prevents bird's-eye)
            maxPitchDeg   = 22.0, -- max downward angle from camera to target
        },
        locations = {
            ["1"] = {
                isLastLocation = true,
                label = "Last Location",
            },
            ["2"] = {
                label       = "Los Santos",
                spawnCoords = vec4(286.9098, -1586.8276, 32.0752, 0.6636),
                camCoords   = vec3(278.8723, -1523.3781, 38.6604),
                camLookAt   = vec3(286.9098, -1586.8276, 32.0752),
                camFov      = 42.0,
            },
            ["3"] = {
                label       = "Paleto Bay",
                spawnCoords = vec4(-19.8265, 6497.2964, 30.5491, 51.6798),
                camCoords   = vec3(-48.7945, 6534.9106, 39.8024),
                camLookAt   = vec3(-19.8265, 6497.2964, 30.5491),
                camFov      = 42.0,
            },
            ["4"] = {
                label       = "Sandy Shores",
                spawnCoords = vec4(1527.3490, 3774.9458, 33.5113, 193.8923),
                camCoords   = vec3(1523.8767, 3728.5447, 39.5782),
                camLookAt   = vec3(1527.3490, 3774.9458, 33.5113),
                camFov      = 42.0,
            },
        },
    },
    -- Tablet mode locations (taxi + DUI tablet).
    locations = {
        ["1"] = {
            isLastLocation = true,
            spawnCoords    = false,
            label          = "Last Location",
            image          = "https://data.otherplanet.dev/spawnselector/lastloc.png"
        },
        ["2"] = {
            isLastLocation = false,
            spawnCoords    = vec4(-268.8336, -956.3636, 30.2231, 205.1087),
            label          = "Los Santos",
            image          = "https://data.otherplanet.dev/spawnselector/lossantos.png"
        },
        ["3"] = {
            isLastLocation = false,
            spawnCoords    = vec4(-19.8265, 6497.2964, 30.5491, 51.6798),
            label          = "Paleto Bay",
            image          = "https://data.otherplanet.dev/spawnselector/paleto.png"
        },
        ["4"] = {
            isLastLocation = false,
            spawnCoords    = vec4(1527.3490, 3774.9458, 33.5113, 193.8923),
            label          = "Sandy Shores",
            image          = "https://data.otherplanet.dev/spawnselector/sandy.png"
        },
    }
}

-- ─────────────────────────────────────────────────────────────────────────
-- Server Branding (UI Text & Logos)                                          
-- (Information) ► Controls server name, description and logo in the UI.
-- ─────────────────────────────────────────────────────────────────────────
Config.ServerDetails = {
    serverName        = "Midnight Roleplay",
    serverCreatorDesc = "British City | Real Roleplay",
    serverLogo        = "https://iili.io/n9xtpj4.png",
    -- Soft drop-shadow glow on the center loader logo.
    -- Set true for a sharp logo with no glow.
    disableGlowOnLogo = false,
}

-- ─────────────────────────────────────────────────────────────────────────
-- Starter Items                                                              
-- (Information) ► Optional items/money granted to new characters.
-- (Information) ► Works separately from itemShop in Config.Misc.
-- ─────────────────────────────────────────────────────────────────────────
Config.StarterItems = {
    enable = false,
    list = {
        {
            type      = "item",
            nameSpawn = "bread",
            quanity   = 3
        },
        {
            type      = "money", -- money, bank
            nameSpawn = "",      -- leave blank
            quanity   = 5000
        }
    }
}

-- ─────────────────────────────────────────────────────────────────────────
-- Character selection menu (V2)
-- Player defaults (preset, music, camera) → ONLY in `defaults` below.
-- preset: "classic" | "modern" | "interactive" (DUI panel anchored to ped head)
-- Music: YouTube URL and/or local mp3 (put files in /sounds and list in fxmanifest files{})
-- preset: "classic" | "modern" | "interactive" (DUI panel anchored to ped head)
-- ─────────────────────────────────────────────────────────────────────────
Config.CharacterMenu = {
    settingsEnabled = false, -- false = hide settings gear / panel
    musicEnabled = false,    -- false = disable music globally (no player UI + no playback)
    music = {
        defaultYoutube = "https://youtu.be/nCBASt507WA?si=wvq-jDrVVph0g-Wf",
        tracks = {
            {
                id = "default",
                label = "Run To You",
                artist = "Bryan Adams",
                youtube = "https://youtu.be/nCBASt507WA?si=wvq-jDrVVph0g-Wf",
            },
            {
                id = "ambient",
                label = "From Nowhere",
                artist = "Dan Croll",
                youtube = "https://youtu.be/kcWNepO_r44?si=ffm4xowIa35ON4lb",
            },
            -- Local mp3 example (uncomment + drop file into /sounds):
            -- {
            --     id = "local_ambient",
            --     label = "Local Ambient",
            --     artist = "Server",
            --     file = "sounds/ambient.mp3", -- or full https:// / nui:// URL
            -- },
        },
    },
    -- GTA V timecycle modifiers (SetTimecycleModifier) - multichar only, cleared on spawn
    cameraEffects = {
        { id = "none",       label = "Off",           timecycle = false },
        { id = "vignette",   label = "Vignette",      timecycle = "Bloom" },
        { id = "film",       label = "Cinematic",     timecycle = "cinema" },
        { id = "noir",       label = "Noir",          timecycle = "NG_filmnoir_BW01" },
        { id = "dof",        label = "Depth blur",    timecycle = "MP_corona_heist_DOF" },
        { id = "dark",       label = "Dark",          timecycle = "CS1_railwayDark" },
        { id = "blackout",   label = "Blackout",      timecycle = "NG_blackout" },
        { id = "phone",      label = "Phone cam",     timecycle = "phone_cam1" },
        { id = "broadcast",  label = "Broadcast",     timecycle = "spectator1" },
        { id = "trippy",     label = "Trippy",        timecycle = "drug_drive_blend01" },
        { id = "desaturate", label = "Desaturated",   timecycle = "dying" },
        { id = "tunnel",     label = "Tunnel",        timecycle = "tunnel" },
        { id = "redmist",    label = "Red mist",      timecycle = "REDMIST" },
        { id = "underwater", label = "Underwater",    timecycle = "underwater" },
        { id = "gritty",     label = "Gritty",        timecycle = "pollution" },
        { id = "superdark",  label = "Super dark",    timecycle = "superDARK" },
        { id = "warm",       label = "Warm glow",     timecycle = "INT_smshop" },
        { id = "forest",     label = "Forest tint",   timecycle = "forest" },
        { id = "contrast",   label = "High contrast", timecycle = "MP_Killstreak" },
        { id = "blur",       label = "Soft blur",     timecycle = "hud_def_blur" },
    },
    defaults = {
        preset = "interactive",
        musicEnabled = false,
        musicVolume = 0.25,
        musicTrack = "default",
        musicPlayerStyle = "classic", -- "minimal" | "classic"
        cameraEffect = "none",
    },
}

-- ─────────────────────────────────────────────────────────────────────────
-- Miscellaneous Settings                                                     
-- (Information) ► General behaviour: notifications, character slots and
--                 optional item shop available on character creation.
-- ─────────────────────────────────────────────────────────────────────────
Config.Misc = {
    DefaultCharsAmount = 1,
    AllowCharacterDelete = true,
    -- Character creator UI: "classic" | "modern"
    creatorPreset = "modern",
    -- Birthday field display (Intl.DateTimeFormat). Overrides locale file when set.
    -- locale: BCP47 tag — e.g. "pl-PL" (04.07.2026), "en-US" (7/4/26), "en-GB" (04/07/2026)
    --         false = follow translation file locale_bcp47 (matches Config.Locale)
    -- style:  "short" | "medium" | "long"
    dateFormat = {
        locale = false,
        style = "short",
    },
    itemShop = {
        enable = false,
        money  = 6500, -- Starting budget for shop purchases
        items  = {
            {
                type      = "item",
                nameSpawn = "bread",
                label     = "Sandwich",
                price     = 500,
                maxQuanity = 5,
                image     = "https://data.otherplanet.dev/fivemicons/%5bfood%5d/hornsandwich.png",
            },
            {
                type      = "item",
                nameSpawn = "water",
                label     = "Water",
                price     = 250,
                maxQuanity = 5,
                image     = "https://data.otherplanet.dev/fivemicons/%5bfood%5d/water_bottle.png",
            },
            {
                type      = "item",
                nameSpawn = "phone",
                label     = "Phone",
                price     = 1500,
                maxQuanity = 1,
                image     = "https://data.otherplanet.dev/fivemicons/%5belectronics%5d/ifruit_blue.png",
            },
            {
                type      = "item",
                nameSpawn = "energydrink",
                label     = "Energy Drink",
                price     = 750,
                maxQuanity = 3,
                image     = "https://data.otherplanet.dev/fivemicons/%5bfood%5d/sprunk.png",
            },
            {
                type      = "car",
                nameSpawn = "blista",
                label     = "Blista",
                price     = 2000,
                maxQuanity = 1,
                image     = "https://cdn.majestic-files.com/public/master/static/img/vehicles/blista.png",
            },
            {
                type      = "car",
                nameSpawn = "bmx",
                label     = "BMX",
                price     = 800,
                maxQuanity = 1,
                image     = "https://cdn.majestic-files.com/public/master/static/img/vehicles/bmx.png",
            },
        }
    }
}

-- ─────────────────────────────────────────────────────────────────────────
-- Scene Creator (Admin)                                                      
-- (Information) ► In-game editor for Config.Scenes with live preview.
-- (Information) ► Requires ACE or framework group (see ServerConfig.SceneCreator).
-- (Information) ► Saved scenes are stored in data/scenes_store.json and
--                 optionally merged into Config.Scenes at runtime.
-- ─────────────────────────────────────────────────────────────────────────
Config.SceneCreator = {
    enable          = true,
    command         = "scenecreator",
    mergeJsonScenes = true,  -- Merge data/scenes_store.json into Config.Scenes
    defaultMaxSlots = 3,     -- Default charactersPlacement slots in new scenes
    previewPedModel = "mp_m_freemode_01",
}

-- ──────────────────────────────────────────────────────────────────────────────
-- HUD Switch                                                    
-- (Information) ► Function will toggle hud when needed to provide best user experience!
-- ──────────────────────────────────────────────────────────────────────────────

Config.SwitchHud = function(toggle)
    if toggle then
        DisplayRadar(true)
        TriggerEvent('op-hud:toggleHud', true)
        -- Display HUD
    else
        -- Hide immediately — a delayed hide left the HUD visible when the
        -- clothing creator opened (and other resources can re-show it meanwhile).
        DisplayRadar(false)
        TriggerEvent('op-hud:toggleHud', false)
    end
end