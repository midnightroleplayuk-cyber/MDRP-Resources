Config                = Config or {}

Config.Framework      = "qb"      -- "qb" | "oldqb" | "esx" | "oldesx"  | "vrp" | "vrp2" | "tmc" | "standalone"
Config.Inventory      =
"ox_inventory"                    -- "qb_inventory" | "esx_inventory" | "ox_inventory" | "qs_inventory" | "ps-inventory" | "codem-inventory" | "tgiann-inventory" | "core_inventory" | "origen_inventory"
Config.MoneyAccount   = "cash"    -- "cash" = pay to cash | "bank" = pay to bank account

Config.SQL            = "oxmysql" -- SQL resource name: "oxmysql" | "mysql-async" | "ghmattimysql"
Config.Locale         = "en"      -- default language code (must match a value in Config.AvailableLocales below)
Config.CurrencySymbol =
"£"                               -- currency symbol for client-side UI display (notifications, HUD, job end screen)


Config.Clothes                   = {
    enabled   = true,  -- false = fully disable clothing system (no cabin props spawn, no clothes change, no interaction) | true = use autoEquip/required below
    autoEquip = true, -- true = auto equip work clothes on job start (no cabin) | false = player changes at cabin manually
    required  = true, -- true = player must wear work clothes before doing tasks | false = clothes are optional (only applies when autoEquip = false)
}

Config.BlipCategory              = {
    enabled          = true, -- true = group all job NPC blips under a single category in the pause map legend
    index            = 12,   -- custom category index (valid range: 12-254)
    -- Category label is always taken from locales/<lang>.json → ui.blipCategoryName

    -- Initial visibility: true = blips visible at spawn | false = hidden until player toggles
    -- Trigger these events from your radial menu / key bind to control visibility at runtime:
    --     TriggerEvent("tw-litejobpack:showJobBlips")
    --     TriggerEvent("tw-litejobpack:hideJobBlips")
    --     TriggerEvent("tw-litejobpack:toggleJobBlips")
    visibleByDefault = true,

    -- Unified style: when true, ALL job NPC blips use the shared sprite/color/scale below,
    -- overriding each job's per-blip settings. Lets server owners enforce a consistent look.
    -- Leave any field as nil to keep the per-job value for that property.
    unifyStyle       = false,
    sprite           = 408, -- shared blip sprite (see https://docs.fivem.net/docs/game-references/blips/) | nil = keep per-job sprite
    color            = 2,   -- shared blip color (see https://docs.fivem.net/docs/game-references/blip-colors/)
    scale            = 0.8, -- shared blip scale
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  UI SYSTEMS                                                               │
-- │                                                                           │
-- │  "default"        → use the pack's own built-in UI                        │
-- │  "qb-progressbar" → use qb-progressbar (only for ProgressBar)            │
-- │  "ox_lib"         → use ox_lib                                            │
-- │  "custom"         → you provide your own function below in this file │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.ProgressBar               = "default" -- "default" | "qb-progressbar" | "ox_lib" | "custom"
Config.Notification              = "default" -- "default" | "qb" | "esx" | "ox_lib" | "custom"
Config.DrawTextUI                = "default" -- "default" | "qb" | "esx" | "ox_lib" | "custom"
Config.ListMenu                  = "default" -- "default" | "ox_lib" | "custom"

-- Default UI panel positions (vw/vh units)
-- locked = true  → panel always stays at this position, player cannot override
-- locked = false → player can drag & save custom position; config value is the initial default
--
-- top/left → the default position for each panel. Set these to match your desired layout.
--            Use UI Move debug log to find CSS default values: open UI Move in-game,
--            check F8 console for [UIDefaults] lines, copy those values here.
--
-- version → increment this when you change any position or lock state.
--           Players with an older version will have their saved positions cleared.
Config.DefaultUIPositionsVersion = 4
Config.DefaultUIPositions        = {
    jobProgressPanel        = { bottom = '12.00vh', right = '1.00vw', locked = false },
    coopLeaderboardPanel    = { top = '12.00vh', right = '1.00vw', locked = false },
    drawTextContainer       = { top = '47.65vh', right = '1.80vw', locked = false },
    actionProgressContainer = { bottom = '18.00vh', left = '48.54vw', locked = false },
    finishJobModal          = { top = '35.00vh', right = '8.00vw', locked = false },
    oxygenIndicator         = { bottom = '2.00vw', right = '2.00vw', locked = false },
    -- Trailer damage readout (trucker). Kept on the LEFT but lifted above the
    -- minimap, which owns the bottom-left corner (top edge ~24vh).
    trailerHealthIndicator  = { bottom = '26.00vh', left = '2.00vw', locked = false },

    -- notifContainer: notification toast stack (width ≈ 17vw, locked by design — configure here, not via UI Move).
    -- Common presets:
    --   top-right   (default)  { top = '1.50vw',  right = '1.00vw' }
    --   top-left               { top = '1.50vw',  left  = '1.00vw' }
    --   top-center             { top = '1.50vw',  left  = '41.50vw' }  -- (100 - 17) / 2
    --   center-right           { top = '45.00vh', right = '1.00vw' }
    --   bottom-right           { bottom = '1.50vw', right = '1.00vw' }
    notifContainer          = { top = '1.50vw', right = '1.00vw' },
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  UI THEME — Customize accent colors without editing CSS                    │
-- │                                                                           │
-- │  Set any value to nil or remove the line to keep the default color.       │
-- │  Colors must be 6-digit hex format: "#RRGGBB"                            │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.UITheme                   = {
    AccentColor  = "#47a3ff", -- primary brand color (buttons, active tabs, progress rings, highlights)
    SuccessColor = "#2ecc71", -- success / completed states (green indicators, checkmarks, positive badges)
    ErrorColor   = "#ef4444", -- error / danger states (red buttons, warning icons, negative badges)
    WarningColor = "#ffde59", -- warning / caution badges (yellow alerts, shift/weather penalties)
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  FINISH JOB MODAL                                                          │
-- │                                                                            │
-- │  enabled = true  → show the cinematic finish job modal (camera + NUI)      │
-- │  enabled = false → skip the modal entirely; show a simple notification     │
-- │                    instead and auto-end the job (no continue/end choice).  │
-- │                    Useful for servers that prefer minimal HUD takeover.    │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.FinishModal               = {
    enabled = true, -- true = show cinematic finish modal | false = skip modal, auto-end job with notifications
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │                            TARGET SYSTEM                                   │
-- │                                                                            │
-- │  enabled = false → every interaction is a key press (drawtext)             │
-- │  enabled = true  → each interaction uses whatever `points` says below,      │
-- │                    and anything not listed there uses `default`.           │
-- │                                                                            │
-- │  Per point you can set "target" or "drawtext". This is useful when a        │
-- │  graphics pack or a custom prop makes one specific interaction hard to      │
-- │  hit with the target crosshair: switch only that point to "drawtext" and    │
-- │  leave the rest on targets.                                                 │
-- │                                                                            │
-- │  In game, /jobpackpoints prints every point the current job reached and     │
-- │  the mode it is running in.                                                │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.TargetSystem              = {
    enabled = true,        -- true = use target system (ox_target/qb-target) | false = use proximity key press
    resource = "ox_target", -- "auto", "ox_target", "qb-target"
    icon = "fas fa-briefcase",
    jobCenterIcon = "fas fa-building",

    default = "target",     -- mode for every point not listed below

    points = {
        -- ── shared by every job ──────────────────────────────────────────────
        jobCenterNpc     = "target",   -- the main Job Center NPC
        jobNpc           = "target",   -- the NPC that starts / ends a job
        clothes          = "target",   -- work clothes cabin

        -- ── vehicle trunk ────────────────────────────────────────────────────
        takeTool         = "target",   -- take the job tool out of the trunk
        returnTool       = "target",   -- put the tool back
        takeFromTrunk    = "target",   -- take a collected item back out of the trunk
        loadToTruck      = "target",   -- load what you are carrying into the trunk
        takeBox          = "target",   -- farmer / fruitpicker: take an empty crate
        takeLoadedBox    = "target",   -- farmer / fruitpicker: take a part-filled crate
        returnBox        = "target",   -- farmer / fruitpicker: put an empty crate back
        trunkBox         = "target",   -- delivery: open/close the trunk, load or take a parcel

        -- ── scale / processing ───────────────────────────────────────────────
        placeOnScale     = "target",   -- put what you are carrying on the scale
        finishProcessing = "target",   -- tell the scale NPC to process what is on it
        finishJob        = "target",   -- cleaner / powerwash / windowscleaner / fishing finish point

        -- ── the work itself ──────────────────────────────────────────────────
        pickup           = "target",   -- pick an item up off the ground (ore, log, scrap, carcass, loot, trash bag)
        breakAction      = "target",   -- miner rocks, lumberjack trees, scrapyard wrecks
        harvest          = "target",   -- farmer / fruitpicker harvest points
        repairTask       = "target",   -- powerlines / tiretechnician repair points
        polish           = "target",   -- cardetailer: polish a car
        trimBush         = "target",   -- landscaping: trim a bush
        mowLawn          = "target",   -- landscaping: mow a lawn patch
        conveyorButton   = "target",   -- forklift: the conveyor start button
        exitNpc          = "target",   -- forklift: the NPC that ends the job

        -- ── per job ──────────────────────────────────────────────────────────
        selectArea       = "target",   -- hunting: pick a hunting area
        depotNpc         = "target",   -- delivery: the depot NPC handing out parcels
        deliverBox       = "target",   -- delivery: hand a parcel to a customer
        depositTruck     = "target",   -- cleanup: throw the bag into the truck
        catchDog         = "target",   -- dogwalking: pick the dog up
        deliverDog       = "target",   -- dogwalking: hand the dog back to its owner
        cleanPoop        = "target",   -- dogwalking: clean up after the dog
        pickUpPassenger  = "target",   -- taxi: pick the passenger up
        dropOffPassenger = "target",   -- taxi: drop the passenger off
        attachTrailer    = "target",   -- trucker: attach / reattach the trailer
        fishingShop      = "target",   -- fishing: the shop NPC
        sellNpc          = "target",   -- fishing / diving: the buyer NPC
        digTreasure      = "target",   -- treasurehunter: dig the treasure up
        openChest        = "target",   -- treasurehunter: open the chest
        loadCargo        = "target",   -- treasurehunter: load the loot onto the boat
        stealCargo       = "target",   -- treasurehunter: steal loot off another boat
    },
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │                         HOURS REQUIREMENT                                 │
-- │                                                                           │
-- │  Require a minimum number of played hours before a player can start       │
-- │  a job. Hours are read from any database table you configure below.       │
-- │  Each job can set its own 'requiredHours' value (0 = no requirement).     │
-- │                                                                           │
-- │  Works like codem-mdtv2 SearchDatabaseTable: define the table, column,    │
-- │  and identifier — the system builds the query automatically.              │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.HoursRequirement          = {
    enabled        = false, -- true = enforce per-job hour requirements | false = skip check

    -- true  = also block INVITING a player who can't meet the job's required/max
    --         hours (checked the moment you invite them), so the owner never
    --         fills the party with members who'd block the start.
    -- false = invites are open; the requirement is only enforced when the job
    --         actually starts (previous behaviour).
    checkOnInvite  = true,

    -- Database table & column configuration
    -- The system will run: SELECT {column} FROM {table} WHERE {identifier} = ?
    table          = "vrp_users",   -- database table that stores playtime
    column         = "hoursPlayed", -- column name holding the hours value (numeric)
    identifier     = "id",          -- column that matches the player identifier (vRP user_id, citizenid, etc.)

    -- How to resolve the player identifier for the query above.
    -- "auto"       = uses the same identifier as Config.Framework (citizenid, identifier, user_id, etc.)
    -- "license"    = FiveM license identifier
    -- "steam"      = Steam hex identifier
    -- "discord"    = Discord identifier
    identifierType = "auto",
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │                              JOB CENTER                                   │
-- │                                                                           │
-- │  Job Center is the main hub where players browse and select jobs.         │
-- │  All settings related to the job center NPC, selection behavior,          │
-- │  and persistence are grouped here.                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘

Config.JobCenter                 = {
    enabled = true, -- true = enable job center NPC(s) | false = disable job center

    -- One or more job center locations. Each entry spawns its own NPC + blip.
    -- Add as many as you want — players can use any of them to open the same menu.
    -- The interaction key/distance below is shared by all locations.
    locations = {
        {
            coords = vector4(-265.0, -963.0, 31.2, 205.0),
            ped = {
                model = "s_m_m_linecook",
                scenario = "WORLD_HUMAN_CLIPBOARD",
            },
            blip = {
                enabled = true,
                sprite = 408,
                color = 2,
                scale = 0.8,
            },
        },
        -- Example second location — uncomment and adjust to add another job center NPC:
        -- {
        --     coords = vector4(-1037.5, -2738.3, 20.2, 330.0),
        --     ped = {
        --         model = "s_m_m_linecook",
        --         scenario = "WORLD_HUMAN_CLIPBOARD",
        --     },
        --     blip = {
        --         enabled = true,
        --         sprite = 408,
        --         color = 2,
        --         scale = 0.8,
        --     },
        -- },
    },

    interaction = {
        distance = 2.0,
        key = 38,
        keyLabel = "[E]",
        -- text is loaded from locale: drawtext.jobCenter
    },
}

-- RequireSelectedJob
-- When true, players MUST go to the Job Center and select a job before they can
-- interact with any job NPC. Only the selected job's blip will be visible on the map.
-- When false, players can walk up to any job NPC and start working directly.
Config.RequireSelectedJob        = false

-- HideUnselectedJobEntities
-- Only applies when RequireSelectedJob = true.
-- When true, NPCs, blips, scale props, and cabins for non-selected jobs are completely
-- hidden from the world. Only the selected job's entities will spawn.
-- When false, all job entities remain visible but the player still needs to select a job to interact.
Config.HideUnselectedJobEntities = false

-- RealJob - Controls how the selected job is saved/persisted
--
--   'none'      → Job selection is only stored in memory (RAM).
--                  Resets when the player disconnects. Player must re-select every session.
--                  Framework job (QBCore/ESX) is NOT changed.
--
--   'sql'       → Job selection is saved to the 'tw_jobpack' SQL table.
--                  Remembered across reconnects. Framework job is NOT changed.
--
--   'framework' → Job selection is synced with QBCore/ESX via SetJob().
--                  On join, reads the player's current framework job and maps it back.
--                  Does NOT save to SQL.
--
--   'both'      → Saves to SQL AND sets the framework job via SetJob().
--                  Full persistence + framework sync.
--
Config.RealJob                   = 'none'

-- Live framework-job sync (only used when RealJob = 'framework').
-- true  → when ANOTHER resource (external job center, admin menu, /setjob)
--         changes the player's QBCore/ESX job mid-session, the pack picks it
--         up immediately instead of only on join. If the player is in the
--         middle of an active job, the change is held and applied when that
--         job ends (they get a notification both times).
-- false → framework job is only read on join (pre-1.4.6 behavior).
Config.LiveFrameworkJobSync      = true

-- EXTERNAL JOBS
-- Add existing server jobs (police, ambulance, mechanic etc.) to the Job Center UI.
-- These jobs are NOT managed by this resource — they just appear in the job list.
--
--   id         → Unique identifier (used internally)
--   job        → Framework job name (e.g. "police", "ambulance") — must exist in QBCore/ESX
--   grade      → Grade/rank to assign when hired (0 = entry level)
--   directHire → true:  Player gets SetJob() immediately when they click "Apply"
--                false: Player only gets a GPS waypoint to the duty location
--   coords     → Location shown on GPS when selected
--
Config.ExternalJobs              = {
    -- {
    --     id = "police",
    --     name = "Police",
    --     subtitle = "Protect and Serve",
    --     icon = "./img/jobs/external_default.svg",
    --     image = "./img/jobs/external_default.png",
    --     description = { "Join the police force and protect the city." },
    --     job = "police",
    --     grade = 0,
    --     directHire = true,
    --     coords = vector3(440.0, -982.0, 30.7),
    -- },
    -- {
    --     id = "ambulance",
    --     name = "EMS",
    --     subtitle = "Save Lives",
    --     icon = "./img/jobs/external_default.svg",
    --     image = "./img/jobs/external_default.png",
    --     description = { "Work as a paramedic and save lives." },
    --     job = "ambulance",
    --     grade = 0,
    --     directHire = true,
    --     coords = vector3(340.0, -1397.0, 32.5),
    -- },
}

Config.Commands                  = {
    progress = "progress", -- command to open progress panel (e.g. /progress)
}

Config.AdminPanel                = {
    enabled = true,                         -- true = admin panel available | false = disabled
    command = "jobadmin",                   -- chat command to open admin panel
    acePermission = "tw-litejobpack.admin", -- FiveM ACE permission required to access
    identifierWhitelist = {                 -- supports citizenid (no prefix) AND FiveM identifiers (with prefix)
        "GC81T50W",                         -- citizenid
        "CXM25352",                         -- citizenid
        "fivem:10863588"
        -- "fivem:xxxx",                    -- FiveM ID
        -- "discord:xxxx",                  -- Discord ID
        -- "license:xxxx",                  -- License
        -- "steam:xxxx",                    -- Steam hex
    },
    cacheRefreshInterval = 60, -- seconds between admin data cache refresh
}

Config.InventoryAccess           = {
    enabled = false, -- true = restrict inventory during jobs | false = full inventory access
    allowedItems = {},
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  AVAILABLE LOCALES (UI language selector)                                  │
-- │                                                                            │
-- │  Languages shown in the in-game settings → language dropdown.              │
-- │  To add a new language:                                                    │
-- │    1. Drop your translation file into  locales/<code>.json                 │
-- │       and include a top-level "_meta" block with the language's            │
-- │       native name and flag emoji, e.g.:                                    │
-- │           {                                                                │
-- │               "_meta": { "name": "Italiano", "flag": "🇮🇹" },              │
-- │               "ui": { ... }                                                │
-- │           }                                                                │
-- │    2. Add the language code to the list below                              │
-- │    3. Restart the resource                                                 │
-- │                                                                            │
-- │  The display name & flag come from the locale file's _meta block, so you  │
-- │  only need to maintain them in one place.                                  │
-- └─────────────────────────────────────────────────────────────────────────────┘

Config.AvailableLocales          = {
    "en", "tr", "de", "fr", "es", "pt", "nl", "ru", "ja", "hu", "sv", "ro",
    -- "it",
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  VEHICLE RECOVERY                                                          │
-- │                                                                            │
-- │  Server-authoritative re-spawn fallback for job vehicles that get culled  │
-- │  (out of OneSync scope, deleted by external scripts, vehicle pool, etc.). │
-- │                                                                            │
-- │  How it works:                                                             │
-- │  1. Client validation thread tracks vehicle entity every 5s.              │
-- │  2. If entity missing for `missingThreshold` ms, client requests respawn. │
-- │  3. Server verifies entity is truly gone, then re-spawns at last known   │
-- │     coords using the original plate. Trunk content is NOT preserved.     │
-- │  4. Cooldown prevents spam if a third-party script keeps deleting.       │
-- │                                                                            │
-- │  Trade-offs: new vehicle resets fuel/damage. Trunk items lost. Better    │
-- │  than silent despawn but not invisible to the player.                    │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.VehicleRecovery           = {
    enabled          = false, -- master switch. Leave false unless customers report despawn issues.
    missingThreshold = 30000, -- ms entity must be missing locally before client asks server to respawn
    serverCooldown   = 60000, -- ms between respawn attempts per lobby (anti-spam)
}

Config.Vehiclekey                = true -- true = give vehicle keys for job vehicles | false = no keys

Config.GiveVehicleKey            = function(plate, model, vehicle)
    if not Config.Vehiclekey then return end

    -- Entity-based key systems read keys off the vehicle entity, not a plate.
    local hasVeh = vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)

    -- Entity-based systems first (they don't care about the plate). Handle them
    -- before the blank-plate guard so they still work when only a netId is known.
    if GetResourceState("qbx_vehiclekeys") == "started" then
        -- DO NOT use the qb-vehiclekeys plate bridge. qbx's GetVehiclesFromPlate()
        -- has a filter bug (`... or GetVehicleNumberPlateText(vehicle)` is always
        -- truthy) so it returns EVERY vehicle in the world — AcquireVehicleKeys(plate)
        -- then hands the player keys to every car, and removeKeys(plate) wipes them
        -- all. Key off the exact entity via the native per-session export instead,
        -- resolved server-side from the netId.
        if hasVeh then
            TriggerServerEvent('tw-litejobpack:server:qbxVehicleKey', VehToNet(vehicle), true)
        end
        return
    elseif GetResourceState("cd_garage") == "started" then
        if hasVeh then TriggerEvent('cd_garage:AddKeys', exports['cd_garage']:GetPlate(vehicle)) end
        return
    elseif GetResourceState("tgiann-hotwire") == "started" then
        if hasVeh then exports["tgiann-hotwire"]:SetNonRemoveableIgnition(vehicle, true) end
        return
    elseif GetResourceState("p_vehiclekeys") == "started" then
        -- createKey wants plate + networked entity; read the plate off the
        -- entity so it matches p_vehiclekeys' own plate view (padding included).
        if hasVeh then
            local ok, err = pcall(function()
                exports['p_vehiclekeys']:createKey(GetVehicleNumberPlateText(vehicle), vehicle)
            end)
            if not ok then print('[GiveVehicleKey] p_vehiclekeys ERROR:', err) end
        end
        return
    end

    -- Remaining systems are plate-based: a blank/whitespace/nil plate pollutes the
    -- key store and makes clean removal impossible. Bail rather than feed garbage.
    if type(plate) ~= "string" or (plate:gsub("%s+", "")) == "" then return end

    if GetResourceState("qs-vehiclekeys") == "started" then
        if hasVeh then model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) end
        exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
    elseif GetResourceState("wasabi_carlock") == "started" then
        exports.wasabi_carlock:GiveKey(plate)
    elseif GetResourceState("qb-vehiclekeys") == "started" then
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
    elseif GetResourceState("Renewed-Vehiclekeys") == "started" then
        exports['Renewed-Vehiclekeys']:addKey(plate)
    elseif GetResourceState("ak47_vehiclekeys") == "started" then
        -- Job vehicles are temporary loaners: a VIRTUAL key grants access
        -- without DB ownership (docs.menanak47.com integration page). Swap to
        -- exports['ak47_vehiclekeys']:GiveKey(plate, false) if you prefer a
        -- persistent key instead.
        if hasVeh then plate = GetVehicleNumberPlateText(vehicle) end
        local ok, err = pcall(function()
            exports['ak47_vehiclekeys']:GiveVirtualKey(plate)
        end)
        if not ok then print('[GiveVehicleKey] ak47_vehiclekeys ERROR:', err) end
    else
        if Config.Framework == "qb" or Config.Framework == "oldqb" or Config.Framework == "tmc" then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        end
    end
end

Config.Removekeys                = true -- true = remove vehicle keys when job ends | false = keep keys

Config.RemoveVehiclekey          = function(plate, model, vehicle)
    if not Config.Removekeys then return end

    local hasVeh = vehicle and vehicle ~= 0 and DoesEntityExist(vehicle)

    -- Entity-based systems first — they key off the vehicle, not a plate, and the
    -- blank-plate guard below must not block them.
    if GetResourceState("qbx_vehiclekeys") == "started" then
        -- NEVER use the qb-vehiclekeys plate bridge here: qbx's GetVehiclesFromPlate()
        -- matches EVERY vehicle in the world (filter bug), so removeKeys(plate) wipes
        -- ALL of the player's keys — their personal car included. This was the exact
        -- customer report. Remove only the job vehicle via the native per-session
        -- export. If the entity is already gone, its leftover sessionId key is an
        -- orphan that can never unlock anything, so skipping is safe.
        if hasVeh then
            TriggerServerEvent('tw-litejobpack:server:qbxVehicleKey', VehToNet(vehicle), false)
        end
        return
    elseif GetResourceState("cd_garage") == "started" then
        -- cd_garage:RemovePersistentVehicles with a nil/blank plate can purge the
        -- player's entire persistent vehicle list. Only fire with a real entity.
        if hasVeh then
            TriggerServerEvent('cd_garage:RemovePersistentVehicles', exports['cd_garage']:GetPlate(vehicle))
        end
        return
    elseif GetResourceState("p_vehiclekeys") == "started" then
        -- removeKey needs the entity; if the truck is already deleted the
        -- leftover key is an orphan that can't unlock anything — skipping is
        -- safe (same rationale as the qbx branch above). removeAll=true so a
        -- reconnect re-grant can't leave a duplicate key behind.
        if hasVeh then
            local ok, err = pcall(function()
                exports['p_vehiclekeys']:removeKey(GetVehicleNumberPlateText(vehicle), vehicle, true)
            end)
            if not ok then print('[RemoveVehiclekey] p_vehiclekeys ERROR:', err) end
        end
        return
    end

    -- CRITICAL guard for plate-based systems: an empty/whitespace/nil plate is a
    -- wildcard for several of them and wipes EVERY key the player owns. Bail unless
    -- we have a real plate.
    if type(plate) ~= "string" or (plate:gsub("%s+", "")) == "" then return end

    if GetResourceState("qs-vehiclekeys") == "started" then
        local vehicleModel = model
        if hasVeh then
            vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        end

        local success, err = pcall(function()
            exports['qs-vehiclekeys']:RemoveKeys(plate, vehicleModel)
        end)
        if not success then
            print('[RemoveVehiclekey] ERROR:', err)
        end

        TriggerServerEvent('tw-litejobpack:server:removeVehicleKeyItem', plate)
    elseif GetResourceState("wasabi_carlock") == "started" then
        exports.wasabi_carlock:RemoveKey(plate)
    elseif GetResourceState("qb-vehiclekeys") == "started" then
        -- 'qb-vehiclekeys:client:RemoveKeys' is registered CLIENT-side only in
        -- stock qb-vehiclekeys — firing it as a server event was a silent no-op
        -- (keys were never removed). server:RemoveVehicleKeys is the real
        -- server handler, the exact mirror of server:AcquireVehicleKeys above.
        TriggerServerEvent('qb-vehiclekeys:server:RemoveVehicleKeys', plate)
    elseif GetResourceState("Renewed-Vehiclekeys") == "started" then
        exports['Renewed-Vehiclekeys']:removeKey(plate)
    elseif GetResourceState("ak47_vehiclekeys") == "started" then
        -- Mirror of the virtual key granted in GiveVehicleKey. If you switched
        -- that branch to GiveKey, switch this one to RemoveKey(plate, false).
        if hasVeh then plate = GetVehicleNumberPlateText(vehicle) end
        local ok, err = pcall(function()
            exports['ak47_vehiclekeys']:RemoveVirtualKey(plate)
        end)
        if not ok then print('[RemoveVehiclekey] ak47_vehiclekeys ERROR:', err) end
    else
        if Config.Framework == "qb" or Config.Framework == "oldqb" or Config.Framework == "tmc" then
            TriggerServerEvent('qb-vehiclekeys:server:RemoveVehicleKeys', plate)
        end
    end
end

Config.SetVehicleFuel            = function(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return false end

    -- Try the active fuel resource's API (pcall'lı — export farklı sürümlerde değişiyor)
    if GetResourceState("LegacyFuel") == "started" then
        pcall(function() exports["LegacyFuel"]:SetFuel(vehicle, 100.0) end)
    elseif GetResourceState("x-fuel") == "started" then
        pcall(function() exports["x-fuel"]:SetFuel(vehicle, 100.0) end)
    elseif GetResourceState("ox_fuel") == "started" then
        pcall(function() Entity(vehicle).state.fuel = 100.0 end)
    elseif GetResourceState("cdn-fuel") == "started" then
        pcall(function() exports['cdn-fuel']:SetFuel(vehicle, 100.0) end)
    elseif GetResourceState("ps-fuel") == "started" then
        pcall(function() exports['ps-fuel']:SetFuel(vehicle, 100.0) end)
    elseif GetResourceState("lc_fuel") == "started" then
        pcall(function() exports["lc_fuel"]:SetFuel(vehicle, 100.0) end)
    end

    -- Statebag fallback (x-fuel/ox_fuel + bazı custom fuel script'leri burayı okuyor)
    pcall(function() Entity(vehicle).state.fuel = 100.0 end)

    -- Native fuel level — bütün fuel script'leri en azından bunu okur
    SetVehicleFuelLevel(vehicle, 100.0)

    return true
end

Config.RefreshSkin               = function()

end

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  CUSTOM FUNCTIONS                                                         │
-- │                                                                           │
-- │  When you set a UI system to "custom" above, write your function here.    │
-- │  The pack will call these automatically.                                  │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- ── Custom Progress Bar ─────────────────────────────────────────────────────
-- Must return true (completed) or false (cancelled)
Config.CustomActionProgress      = function(duration, label, options)
    -- Example:
    -- return exports['mythic_progbar']:Progress({
    --     name = "jobpack_action",
    --     duration = duration,
    --     label = label,
    --     canCancel = true,
    -- })
    return true
end

-- ── Custom Notification ─────────────────────────────────────────────────────
Config.CustomNotification        = function(text, type, duration)
    -- Example:
    -- exports['okokNotify']:Alert("Job Pack", text, duration, type)
end

-- ── Custom Draw Text ────────────────────────────────────────────────────────
Config.CustomDrawText            = function(text, position)
    -- Example:
    -- exports['cd_drawtextui']:ShowUI('default', text)
end

Config.CustomHideText            = function()
    -- Example:
    -- exports['cd_drawtextui']:HideUI()
end

-- ── Custom List Menu ────────────────────────────────────────────────────────
-- Must return selected index (1, 2, 3...) or nil (cancelled)
-- options = { { title = "...", description = "...", disabled = false }, ... }
Config.CustomOpenListMenu        = function(title, options)
    -- your menu system here
    return nil
end

Config.CustomCloseListMenu       = function()
end
