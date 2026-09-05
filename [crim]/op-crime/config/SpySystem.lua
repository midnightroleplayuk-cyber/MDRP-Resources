-- ──────────────────────────────────────────────────────────────────────────────
-- 🕵️ SPY SYSTEM CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────
-- Description:
-- This configuration controls all spy-related items and mechanics.
-- It includes GPS trackers, motion sensors, spy cameras, binoculars,
-- and detection tools used for surveillance and tracking players.
-- ──────────────────────────────────────────────────────────────────────────────

Config.maxFreecamDistance = 15.0 

Config.SpySystem = {
    -- 🚗 CAR GPS TRACKER
    -- Allows players to place a GPS tracker on vehicles
    CarGps = {
        enable = true, -- Enable / Disable this feature
        itemName = "spy_gps", -- Item required to place GPS
        refreshRate = 0.5, -- How often GPS position updates (in seconds)
        gpsMode = "exact", 
        -- "exact"  → shows exact vehicle position
        -- "radius" → shows approximate area (circle)
        blip = {
            radius = 20.0, -- Used only in "radius" mode
            blipId = 724, -- Blip sprite ID
            blipColor = 1, -- Blip color
            blipSize = 0.7 -- Blip scale
        }
    },
    -- 📡 MOTION SENSOR
    -- Detects movement in a specific area
    MotionSensor = {
        enable = true, -- Enable / Disable
        itemName = "spy_motionsensor", -- Required item
        radius = 15.0, -- Detection radius
        prop = {
            enable = true, -- Spawn prop in world
            propName = "prop_spycam" -- Prop model
        },
        blip = {
            blipId = 875,
            blipColor = 3,
            blipSize = 0.7  
        }
    },
    -- 📷 SPY CAMERA
    -- Placeable cameras with remote viewing
    SpyCam = {
        enable = true, -- Enable / Disable
        itemName = "spy_cam", -- Item to place camera
        maxDistance = 250.0, 
        -- Maximum viewing distance (OneSync limitation)
        prop = {
            enable = true, 
            propName = "prop_spycam"
        },
        blip = {
            blipId = 873,
            blipColor = 2,
            blipSize = 0.7  
        },
        terminalItemName = "spy_cam_terminal"
        -- Item used to access camera list and live feed
    },
    -- 🔭 SPY BINOCULARS
    -- Allows long-distance observation of players
    SpyBinoculars = {
        enable = true, -- Enable / Disable
        itemName = "spy_binoculars", -- Required item
        maxDistance = 50.0, -- Maximum usable distance
        enableVoice = true, 
        -- If enabled, you can hear players you are aiming at
    },
    -- 📡 SPY DETECTOR
    -- Detects nearby spy devices (GPS, cameras, sensors)
    SpyDetector = {
        enable = true, -- Enable / Disable
        itemName = "spy_detector", -- Required item
    }
}