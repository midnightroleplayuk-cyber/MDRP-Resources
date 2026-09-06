--==============================================================================
-- 1. FRAMEWORK & CORE SYSTEMS
--==============================================================================
Settings.FrameworkSystems      = (FrameWork and FrameWork.FrameworkLoaded == true) or Framework ~= nil

-- -----------------------------------------------------------------------------
-- STRESS CONFIGURATION (Icon vs. System Logic)
-- -----------------------------------------------------------------------------
Settings.DisableStressIcon     = true -- Set to `true` to HIDE the stress icon from status HUD
Settings.EnableStressSystem    = false    -- Set to `true` to ENABLE stress gain logic (speeding, shooting)

-- Backwards compatibility aliases (do not modify)
Settings.DisableStress         = Settings.DisableStressIcon
Settings.StressSystem          = Settings.EnableStressSystem

-- Resource-wide nearest postal display
Settings.DisablePostal         = false

-- Text scramble animations on data changes (ID, Job, Time, Date, Money)
Settings.DisableTextAnimation  = false

-- Enable real time (system clock) for player info hud
Settings.RealTime              = true

-- Optional custom Server ID to isolate saved settings per server (empty = auto-generated)
Settings.ServerId              = ""

-- Enable debug logs in client console ([tuff-hud][DEBUG])
Settings.Debug                 = false

--==============================================================================
-- 2. FORMATTING & CURRENCY
--==============================================================================
Settings.Currency              = "£"        -- Currency symbol for cash & bank
Settings.DateFormat            = "%d/%m/%Y" -- Date format (%d = day, %m = month, %Y = year)
Settings.OxInventoryBlackMoney = true       -- Fetch black money from ox_inventory instead of framework accounts

--==============================================================================
-- 3. COMMANDS & KEYBINDINGS
--==============================================================================
-- Main HUD Settings Menu Command & Keybind
Settings.SettingsCommand = "hudsettings"
Settings.SettingsKeybind = {
    enabled = true,
    key = "i",
    description = "Open HUD settings menu"
}

-- Player Info HUD Toggle Command & Keybind (Top-Right HUD)
Settings.TogglePlayerInfoCommand = "toggleplayerinfo"
Settings.TogglePlayerInfoKeybind = {
    enabled = true,
    key = "o",
    description = "Toggle Player Info HUD"
}

--==============================================================================
-- 4. MINIMAP & MAP CONFIGURATION
--==============================================================================
Settings.CustomMap = {
    enabled = false,   -- Enable/Disable custom map
    radarZoom = 1100,  -- Radar zoom level (default 1100, higher values zoom out)
    refreshRate = 500, -- Radar position & zoom update interval in ms
}

Settings.MinimapOffset = {
    paddingX = 0.003953,  -- GTA V native HUD horizontal padding (empirically measured)
    paddingY = 0.0        -- Vertical offset compensation
}

Settings.DisableMapAlwaysOption = true  -- Set to true to hide "Always" option for minimap

Settings.MinimapTypes = {
    SQUARE = {
        moveX = 0.0,
        moveY = 0.0,
        defaultX = 0.015,
        defaultY = -0.09,
        width = 0.165,
        height = 0.205,
        blurOffsetX = -0.01,
        blurOffsetY = 0.081,
        blurWidthOffset = 0.102,
        blurHeightOffset = 0.135,
        clipType = 1,
        useSquareMask = true
    },
    CIRCLE = {
        moveX = 0.0,
        moveY = 0.0,
        defaultX = 0.015,
        defaultY = -0.09,
        width = 0.145,
        height = 0.215,
        blurOffsetX = -0.02,
        blurOffsetY = 0.01,
        blurWidthOffset = 0.03,
        blurHeightOffset = 0.03,
        clipType = 0,
        useSquareMask = false
    }
}

--==============================================================================
-- 5. VEHICLE & SEATBELT CONFIGURATION
--==============================================================================
Settings.FlyThroughtWindShield = true    -- Eject players through windshield on high speed crashes
Settings.SeatbeltCooldown      = 350     -- Seatbelt toggle cooldown in milliseconds (350ms)
Settings.LowFuelAlertThreshold = 20      -- Low fuel audio/visual alert threshold percentage
Settings.ShowNitroStatus       = "half"  -- Nitro status visibility (true = always, false = hidden, "half" = visible if > 0%)

Settings.SeatbeltDisabledVehicleClasses = { -- Vehicle classes where seatbelt is unavailable
    8,  -- Motorcycles
    13, -- Bicycles
}

Settings.SeatbeltDisabledVehicleModels = { -- Specific vehicle model names where seatbelt is unavailable
    -- "polmav",
    -- "seashark",
}

--==============================================================================
-- 6. SERVER OWNER HUD COMPONENT DISABLE TOGGLES
--==============================================================================
-- Set any of these to `true` to completely disable the component for all players
Settings.DisableSeatbelt   = false -- Set to `true` to completely DISABLE the entire seatbelt system (disables keybind, crash ejection, warning audio, vehicle HUD icon & settings option)
Settings.DisableEngine     = false -- Disable engine health & status on vehicle HUD
Settings.DisableLights     = false -- Disable headlights status on vehicle HUD
Settings.DisableDoorLock   = false -- Disable door lock status on vehicle HUD
Settings.DisableMileage    = false -- Disable vehicle odometer / mileage on vehicle HUD
Settings.DisableIndicators = false -- Disable turn signals & hazard lights on vehicle HUD

--==============================================================================
-- 7. GLOBAL SETTINGS LOCKS (Server Owner Admin Controls)
--==============================================================================
-- Set any of these to `true` to LOCK the setting for players.
-- When locked, players cannot change the setting in the HUD menu / HUD editor,
-- and the server forces the preset value from Settings.Default.
Settings.GlobalLocks = {
    -- --- General Settings Locks ---
    LockHudEditor        = false, -- Prevent players from opening HUD Editor / moving & scaling HUD elements
    LockResetSettings    = false, -- Prevent players from resetting their HUD settings to default
    LockPerformanceMode  = false, -- Lock FPS target selection (forces Settings.Default.FPS)
    LockMapType          = false, -- Lock Map shape (SQUARE / CIRCLE - forces Settings.Default.MAPTYPE)
    LockMapVisibility    = false, -- Lock Map visibility mode (forces Settings.Default.MAP)
    LockCompass          = false, -- Lock Compass visibility & color (forces Settings.Default.COMPASS & COMPASSCOLOR)
    LockWaypoint         = false, -- Lock Waypoint distance visibility & color (forces Settings.Default.WAYPOINT & WAYPOINTCOLOR)
    LockPostal           = false, -- Lock Nearest Postal visibility & color (forces Settings.Default.POSTAL & POSTALCOLOR)
    LockCinematicMode    = false, -- Prevent players from toggling Cinematic black bars (forces Settings.Default.CINEMATIC)

    -- --- Speedometer Settings Locks ---
    LockSpeedometerStyle = false, -- Prevent players from changing speedometer style (forces Settings.Default.SPEEDTYPE)
    LockSpeedometerColor = false, -- Prevent players from customizing speedometer colors
    LockSpeedUnit        = true, -- Lock speed unit to KMH or MPH (forces Settings.Default.SPEEDUNIT)
    LockHideSpeedometer  = false, -- Prevent players from hiding the speedometer (forces Settings.Default.HIDESPEED)
    LockSeatbeltAlert    = false, -- Prevent players from toggling seatbelt warning chime sound
    LockLowFuelAlert     = false, -- Prevent players from toggling low fuel alert sound

    -- --- Status & Player Info Settings Locks ---
    LockStatusStyle      = false, -- Prevent players from changing status bar style (forces Settings.Default.PLAYERINFO.STATUS.TYPE)
    LockStatusColors     = false, -- Prevent players from editing status icon colors
    LockStatusThresholds = false, -- Prevent players from editing status percentage visibility thresholds
    LockHideStatus       = false, -- Prevent players from hiding status bars (forces Settings.Default.PLAYERINFO.STATUS.HIDE)
    LockShowPlayerInfo   = false, -- Prevent players from toggling Player Info HUD visibility (forces Settings.Default.PLAYERINFO.SHOW)
    LockEditPlayerInfo   = false, -- Prevent players from customizing Player Info HUD positions & elements
}

--==============================================================================
-- 8. PLAYER INFO PERMISSIONS & LOCKS
--==============================================================================
-- "default": Player can toggle option in HUD settings menu
-- "always_show": Forced visible, cannot be hidden in settings
-- "always_hide": Forced hidden, cannot be shown in settings
Settings.PlayerInfoSpecificLocks = {
    LOGO       = "always_hide",
    ID         = "default",
    TIME       = "default",
    DATE       = "always_hide",
    BANK       = "always_hide",
    CASH       = "always_hide",
    BLACKMONEY = "always_hide",
    JOB        = "always_hide",
    GANG       = "always_hide",
    AMMO       = "always_hide",
}

-- Configure allowed visibility options per module in HUD settings ("ALWAYS", "CAR", "FOOT", "NEVER")
Settings.AllowedOptions = {
    COMPASS  = { "CAR" },
    WAYPOINT = { "NEVER" },
    POSTAL   = { "CAR", "FOOT" },
    MAP      = { "CAR" }
}

Settings.Logo = {
    width = "5vh",
    height = "5vh",
    rounded = "100px"
}

--==============================================================================
-- 9. DEFAULT PLAYER HUD PRESETS
--==============================================================================
Settings.Default = {
    FPS = "60",
    MAP = "ALWAYS",
    MAPTYPE = "SQUARE",
    COMPASS = "ALWAYS",
    COMPASSCOLOR = "#9748ff",
    WAYPOINT = "NEVER",
    WAYPOINTCOLOR = "#8e48ff",
    POSTAL = "ALWAYS",
    POSTALCOLOR = "#8e48ff",
    SPEEDUNIT = "mph",
    SPEEDTYPE = 1,
    HIDESPEED = 0,
    CINEMATIC = 0,
    SEATBELTWARNING = 1,
    LOWFUELWARNING = 1,
    DISABLESEATBELT = Settings.DisableSeatbelt == true and 1 or 0,
    DISABLEENGINE = Settings.DisableEngine == true and 1 or 0,
    DISABLELIGHTS = Settings.DisableLights == true and 1 or 0,
    DISABLEDOORLOCK = Settings.DisableDoorLock == true and 1 or 0,
    DISABLEMILEAGE = Settings.DisableMileage == true and 1 or 0,
    DISABLEINDICATORS = Settings.DisableIndicators == true and 1 or 0,
    SPEEDOMETER_COLORS = {},
    PLAYERINFO = {
        SHOW = true,
        SPECIFIC = {
            LOGO = false,
            ID = true,
            TIME = true,
            DATE = false,
            BANK = false,
            CASH = false,
            BLACKMONEY = false,
            JOB = false,
            GANG = false,
            AMMO = false
        },
        COLORS = {
            ID = { TEXT = "#F0F7FA", BG = "#0E0F11" },
            TIME = { TEXT = "#F0F7FA", BG = "#0E0F11" },
            DATE = { TEXT = "#F0F7FA", BG = "#0E0F11" },
            BANK = { TEXT = "#a748ff", BG = "#a748ff" },
            CASH = { TEXT = "#00FFA6", BG = "#00FFA6" },
            BLACKMONEY = { TEXT = "#F0F7FA", BG = "#C91D15" },
            JOB = { TEXT = "#F0F7FA", BG = "#0E0F11" },
            GANG = { TEXT = "#F0F7FA", BG = "#9A33FF" },
            AMMO = { TEXT = "#9748ff", BG = "#AFAFAF" }
        },
        STATUS = {
            HIDE = false,
            TYPE = 1,
            SHOWPERCENTAGE = {
                HEALTH = 100,
                ARMOR = 1,
                FOOD = 100,
                WATER = 100,
                OXYGEN = 99,
                STRESS = 0,
                STAMINA = 99
            },
            COLOR = {
                MICROPHONE = "#F0F7FA",
                HEALTH = "#FF635C",
                ARMOR = "#F0F7FA",
                FOOD = "#FFD373",
                WATER = "#00D0FF",
                OXYGEN = "#00FFA6",
                STRESS = "#B672FF",
                STAMINA = "#9748ff"
            }
        }
    }
}
