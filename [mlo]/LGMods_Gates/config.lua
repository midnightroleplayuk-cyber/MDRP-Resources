Config = {}

Config.Debug = false

-- ─── FRAMEWORK ───────────────────────────────────────────────────────────────

Config.Framework = {
    name        = "standalone",              -- standalone | qbcore | qbox | esx | tmc
    jobLock     = true,                     -- true = only allowedJobs can open gates
    allowedJobs = { "police", "ambulance" },
}

-- ─── ACCESS ──────────────────────────────────────────────────────────────────

Config.Access = {
    usePinCodes  = true,   -- true = keypad gates ask for a PIN before opening
    requiredItem = nil,     -- "warrant_card" = player must carry this item to interact
    stationCodes = {        -- PIN code per station (shared by all gates in that station)
        ["Alta"]            = "1234",
        ["Sinners"]         = "1326",
        ["Sinners_CarPark"] = "1326",
	["ChadwellHeath"] = "1234",
    },
}

-- ─── INTERACTION ─────────────────────────────────────────────────────────────

Config.Interaction = {
    useOxTarget = true,   -- true = ox_target zones | false = E-key prompt
    distance    = 1.0,     -- metres before the prompt/zone activates
    custom      = nil,     -- set below to use your own interaction script
}

-- Uncomment to use C3DText:
-- Config.Interaction.custom = {
--     onCreate = function(coords, label, title, distance, onSelect)
--         return exports["C3DText"]:CreateUI(
--             coords,
--             { { label = label, icon = "fas fa-door-open", onSelect = onSelect } },
--             title,
--             distance
--         )
--     end,
--     onDestroy = function(id)
--         exports["C3DText"]:DestroyUI(id)
--     end,
-- }

-- ─── BEHAVIOUR ───────────────────────────────────────────────────────────────

Config.Behaviour = {
    autoClose = 15,   -- false = disabled | number = seconds before gate auto-closes

    autoOpen = {
        enabled  = false,             -- true = gates auto-open when a player enters their inside zone
        radius   = 4.0,              -- detection radius in metres
        interval = 1500,             -- how often proximity is checked (milliseconds)
        jobCheck = false,            -- true = restrict to jobs listed below | false = any player
        jobs     = { "police", "ambulance" },
    },
}

-- ─── SOUNDS ──────────────────────────────────────────────────────────────────

Config.Sounds = {
    gateVolume  = 0.5,   -- 0.0 – 1.0
    alarmVolume = 0.6,   -- 0.0 – 1.0
    minDistance = 5.0,   -- full volume within this range (metres)
    maxDistance = 30.0,  -- silent beyond this range (metres)
}
