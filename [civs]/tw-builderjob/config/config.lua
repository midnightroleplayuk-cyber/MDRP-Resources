Config                       = {}
Locales                      = Locales or {}

-- QUICK SETUP, in order:
--   Framework / inventory ... below, both 'auto'. Leave them.
--   Language ................ Config.Locale below (server default only).
--   Payouts & deposits ...... ECONOMY section below.
--   Disable a region ........ config/data/regions.lua -> enabled = false
--   Prompt look ............. Config.InteractionStyle below.

-- ------------------------------------------------------------------ FRAMEWORK
-- auto | qb | oldqb | qbox | esx | oldesx | vrp | vrp2 | tmc | standalone
-- 'auto' detects it from the running resources; a value set by hand always wins.
-- 'qbox' uses the 'qb' bridge (qbx_core compat layer).
-- 'tmc' has to be set by hand; 'auto' cannot detect it.
Config.Framework             = 'auto'

-- auto | qb_inventory | esx_inventory | ox_inventory | codem-inventory
--      | qs_inventory | tgiann-inventory
Config.Inventory             = "auto"
-- Path for craft/reward item icons. 'auto' = derived from the selected inventory.
Config.InventoryImagePath    = "auto"

Config.SQL                   = "oxmysql"

-- ------------------------------------------------------------------- LANGUAGE
-- Server default only — players pick their own in the menu. Codes = locales/*.lua
Config.Locale                = 'en'

-- -------------------------------------------------------------------- ECONOMY
-- Scales money + XP + bonuses of every region. Per-region values live in
-- config/data/regions.lua; config/economy.lua can derive them from workload.
Config.RewardMultiplier      = 1.0
-- Scales every rental deposit. 0 = no deposits at all.
-- Per-vehicle amounts: config/systems/vehicle_rental.lua
Config.DepositMultiplier     = 1.0

-- CurrencySymbol is what the UI prints next to an amount.
-- MoneyAccount is the framework account the money is added to (bank / cash).
Config.CurrencySymbol        = "£"
Config.MoneyAccount          = "bank"

-- PROMPTS — how the [E] prompt looks. One key:
--   badge (default) | text | oxlib | ox-target | qb-target
--   auto = ox_target / qb-target if installed, else badge
Config.InteractionStyle      = 'badge'

-- FINISHED BUILDS — how long a finished job stays standing after the crew is paid.
--   'off'     remove it right away
--   'timer'   keep it for durationMs, then remove
--   'restart' keep it until the server or the resource restarts. A new crew is
--             sent to a FREE site instead; only when every site is taken does
--             the oldest finished build get recycled. Regions with a single
--             site always recycle, there is nowhere else to send the crew.
-- `regions` overrides the default per region. Delete a line to use the default.
-- Regions not listed keep their build in the world for good (R5 and R9 are
-- saved to the database) or have nothing to show (R8 digs a pit, R12 hauls cargo).
Config.Showcase              = {
    mode       = 'timer',
    durationMs = 180000,

    regions    = {
        plank               = { mode = 'timer', durationMs = 180000 }, -- R1  house
        kulestone           = { mode = 'timer', durationMs = 180000 }, -- R2  tower stone
        ['kulestone:site2'] = { mode = 'timer', durationMs = 180000 }, -- R3  tower stone 2
        pipe                = { mode = 'timer', durationMs = 180000 }, -- R4  pipes
        waterfacility       = { mode = 'timer', durationMs = 180000 }, -- R6  base + wall
        waterfacility2      = { mode = 'timer', durationMs = 180000 }, -- R7  trench pipes
        job7                = { mode = 'timer', durationMs = 180000 }, -- R10 decking
        job8                = { mode = 'timer', durationMs = 180000 }, -- R11 wall + roof
    },
}

-- ---------------------------------------------------------------------- MISC
Config.ServerName            = "Midnight RP"
Config.ExampleProfilePicture = "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png"

-- Discord logging. ⚠ DO NOT PUT THE WEBHOOK URL HERE: config/*.lua is a
-- SHARED script and ships to every client, so a URL here is a published
-- secret. Secrets live in config/secrets/discord.lua (SERVER-ONLY).
Config.Discord               = {
    enabled         = true,

    botName         = "Tworst Store",
    botLogo         = "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png",
    footerText      = "Tworst Builders",

    panelLog        = true,
    panelKeep       = 300,

    events          = {
        jobStart      = true,
        jobFinish     = true,
        jobAbandon    = true,
        lobbyCreate   = false,
        lobbyJoin     = true,
        lobbyLeave    = true,
        lobbyDisband  = true,
        reconnect     = true,
        adminForceEnd = true,
        rewardPaid    = false,
        rewardFailure = true,
        security      = true,
        serverStart   = true,
    },

    showIdentifiers = false,

    mentionRole     = "",

    minGapMs        = 450,
    maxQueue        = 300,
    maxRetries      = 3,
}

-- Menu/interaction keys. Machine keys are separate: config/keybinds.lua.
Config.Keys                  = {
    inviteAccept  = 246,
    inviteDecline = 306,
}

-- Commands a player may type. Rename freely; debug commands never go in here.
Config.Command               = {
    jobReset = "builderjobreset",    -- reset your own job
    jobLeave = "builderjobleave",    -- leave the crew
    settings = "builderjobsettings", -- visual detail / sync quality panel
    keys     = "keys",               -- key binding panel
}

-- Admin identifiers. Field tools like /tw_bp and the /builderadmin panel check
-- this list at the door AND again on every write event.
-- ACE permission, checked first. Leave '' to turn it off.
--   server.cfg:  add_ace group.admin builderjob.admin allow
Config.AdminAce              = 'builderjob.admin'

-- Admins. ANY identifier the player has works — pick whichever your server
-- uses. Run an admin tool once while not an admin and the console prints
-- yours, ready to paste. Uncomment a line below to see the shape.
Config.Admins                = {
    'discord:338928317820567555',
}

-- true: the lobby owner assigns the reward share per member by hand.
Config.LetOwnerSplitRewards  = true

-- Cooldown after finishing a job. Needs jobCoolDownHours as well.
Config.JobCooldownEnabled    = false
Config.jobCoolDownHours      = 0
Config.MaxHistoryEntries     = 50
-- Dress the player in work clothes at job start (outfit = Config.JobClothes).
-- Restoring the old outfit goes through Config.RefreshSkin below; adapt it to your clothing script.
Config.ChangeClothesSystem   = true
Config.TebexSystem           = false
-- ⚠ DIAGNOSTIC LOGS. While on, per-frame measurement loops run (animcontrols
-- + rental) and the console fills with prints. false for a live server.
Config.Debug                 = true
-- Draws zone polygons. ~75us per frame -- turn on only to check a boundary.
Config.DebugZoneDraw         = false
Config.InteractionKeyColor   =
"~g~"
-- ⚠ RELEASE BLOCKER. While on, ~250 debug commands REGISTER and roughly 20
-- server-side validation bypasses plus the per-region test trims stay live.
-- The one correct way to close it: Config.ReleaseBuild = true.
Config.DebugCommands         = true
Config.DebugZones            = false
Config.DebugTowerScenery     = false

Config.RopeProbe             = false

-- Vehicles auto-spawn and RENTAL IS SKIPPED, i.e. the 'rent -> drive -> work
-- -> hand back' flow is never played. Development only.
Config.FastTest              = false
-- Event/network profiler. Measures traffic and writes profiler_logs/*.json.
Config.Profiler              = false
Config.jobLevelCheck         = false

-- Pay less when the crew starts a region that is already part-built (R1 head
-- start). false = the full region reward is paid, which is what 1.0.3 and
-- earlier did. true = the finish screen and the payout both use the reduced
-- amount. Only Region 1 defines a head start today.
Config.HeadStartPenalty      = false

-- /builderadmin read-only panel: live lobbies + earnings breakdown.
Config.AdminPanel            = {
    enabled      = true,
    command      = 'builderadmin',

    cacheSeconds = 60,

    topLimit     = 25,

    stuckMinutes = 90,

    scanLimit    = 500,
}

-- Warns in F8 when the ground under a job site's piles differs from the reference
-- install (config/data/map_baseline.lua): another map/MLO replaced the terrain
-- there, or the builder map pack is not running.
Config.MapConflictCheck      = true

-- Relaxes crew/vehicle caps for solo testing. false for a live server.
Config.SoloTest              = false

-- RELEASE PROFILE -- ONE SWITCH. While true these flags are forced off no
-- matter what they say: Debug, DebugCommands, DebugZoneDraw, DebugZones,
-- DebugTowerScenery, RopeProbe, Profiler, FastTest; the per-region test trims
-- are zeroed too (full size is played). Keep true on a live server.
Config.ReleaseBuild          = true
if Config.ReleaseBuild then
    Config.Debug             = false
    Config.DebugCommands     = false
    Config.DebugZoneDraw     = false
    Config.DebugZones        = false
    Config.DebugTowerScenery = false
    Config.RopeProbe         = false
    Config.Profiler          = false
    Config.FastTest          = false
    Config.SoloTest          = false
end

-- How long to wait after LEAVING a builder zone before local props are
-- removed. Too short and a player walking the boundary keeps tearing the
-- scene down and rebuilding it.
Config.ZoneExitGraceMs = 10000

-- Traffic/pedestrian suppression inside a region.
Config.Ambient         = {
    suppress    = true,
    purge       = true,
    purgeRepeat = true,
    radius      = 400.0,
}

-- UI THEME. One hex colour ('#RRGGBB') for the interface highlight and the ground route arrows.
-- '#E5B93B' keeps the stock builder gold. Green (accept), red (deny), key caps, medals and
-- reward/progress colours stay literal so a reskin cannot break them.
Config.AccentColor = '#E5B93B'

-- Default HUD positions. Players change them via Settings > UI Move.
Config.DefaultUIPositions = {
    teamList = { top = '77.22vh', left = '85.94vw' },
    scoreList = { top = '2.64vh', left = '1.61vw' },
    inviteSide = { top = '2.85vh', left = '73.07vw' },
    notificationDiv = { top = '40.48vh', left = '81.54vw' },
    keyInfoSide = { top = '50%', right = '2.0833vw' },
    dumpsterInfo = { top = '1.3542vw', left = '50%' }
}

-- REGIONS: each Config.Job.regionData entry below is an independent mini-job.
-- regionID and the jobType name do not line up (historical); a missing mapping locks the region.
-- `enabled = false` hides the region AND blocks it on the server; UI-only hiding is not enough.
-- regionName is resolved at load time (server language); regionNameKey is sent to clients
-- and resolved in each player's language. Add both when adding a region.

Config.ChangingRoom              = {
    enabled  = true,

    required = true,

    points   = {
        vector3(1559.97, 1735.78, 110.96),
        vector3(1565.75, 1735.77, 110.85),
        vector3(1565.78, 1726.16, 110.95),
        vector3(1559.84, 1725.78, 110.95),
    },
    zMin     = 109.0,
    zMax     = 114.0,

    anchor   = vector3(1562.84, 1730.87, 110.93),

    blip     = { enabled = true, sprite = 366, color = 5, scale = 0.7 },

    anim     = {
        enabled  = true,
        dict     = 'clothingtie',
        clip     = 'try_tie_negative_a',
        duration = 2200,
        fadeOut  = 400,
        hold     = 250,
        fadeIn   = 400,
    },
}

Config.JobClothes                = {
    male = {
        { jacket = 97,   texture = 0 },
        { shirt = 59,    texture = 0 },
        { arms = 0,      texture = 0 },
        { legs = 9,      texture = 6 },
        { shoes = 12,    texture = 3 },
        { mask = 0,      texture = 0 },
        { chain = 0,     texture = 0 },
        { decals = 0,    texture = 0 },
        { helmet = 145,  texture = 0 },
        { glasses = 0,   texture = 0 },
        { watches = 0,   texture = 0 },
        { bracelets = 0, texture = 0 }
    },
    female = {
        { jacket = 516,  texture = 0 },
        { shirt = 1,    texture = 1},
        { arms = 0,      texture = 0 },
        { legs = 100,     texture = 1 },
        { shoes = 25,    texture = 0 },
        { mask = 0,      texture = 0 },
        { chain = 0,     texture = 0 },
        { decals = 0,    texture = 0 },
        { helmet = 144,  texture = 0},
        { glasses = -1, texture= 0 },
        { watches = -1, texture = 0 },
        { bracelets = -1, texture = 0 }
    },
}

-- Vehicle key integration. Swap GiveVehicleKey for your own key system.
Config.Vehiclekey                = true

Config.GiveVehicleKey            = function(plate, model, vehicle)
    if Config.Vehiclekey then
        if GetResourceState("cd_garage") == "started" then
            TriggerEvent('cd_garage:AddKeys', exports['cd_garage']:GetPlate(vehicle))
        elseif GetResourceState("qs-vehiclekeys") == "started" then
            model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
        elseif GetResourceState("wasabi_carlock") == "started" then
            exports.wasabi_carlock:GiveKey(plate)
        elseif GetResourceState("qb-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        elseif GetResourceState("qbx_vehiclekeys") == "started"
            or GetResourceState("qbx-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        elseif GetResourceState("Renewed-Vehiclekeys") == "started" then
            exports['Renewed-Vehiclekeys']:addKey(plate)
        elseif GetResourceState('MrNewbVehicleKeys') == 'started' then
            exports.MrNewbVehicleKeys:GiveKeysByPlate(plate)
        else
            if Config.Framework == "qb" or Config.Framework == "oldqb" then
                TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
            else
                print("No vehicle key system found")
            end
        end
    end
end

Config.Removekeys                = true

Config.RemoveVehiclekey          = function(plate, model, vehicle)
    if Config.Removekeys then
        if GetResourceState("cd_garage") == "started" then
            TriggerServerEvent('cd_garage:RemovePersistentVehicles', exports['cd_garage']:GetPlate(vehicle))
        elseif GetResourceState("qs-vehiclekeys") == "started" then
            model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            exports['qs-vehiclekeys']:RemoveKeys(plate, model)
        elseif GetResourceState("wasabi_carlock") == "started" then
            exports.wasabi_carlock:RemoveKey(plate)
        elseif GetResourceState("qb-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
        elseif GetResourceState("qbx_vehiclekeys") == "started"
            or GetResourceState("qbx-vehiclekeys") == "started" then
            TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
        elseif GetResourceState("Renewed-Vehiclekeys") == "started" then
            exports['Renewed-Vehiclekeys']:removeKey(plate)
        elseif GetResourceState('MrNewbVehicleKeys') == 'started' then
            exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
        else
            if Config.Framework == "qb" or Config.Framework == "oldqb" then
                TriggerServerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
            else
                print("No vehicle key system found")
            end
        end
    end
end

Config.SetVehicleFuel            = function(vehicle)
    local result = false
    if GetResourceState("LegacyFuel") == "started" then
        result = exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
    elseif GetResourceState("x-fuel") == "started" then
        result = exports["x-fuel"]:SetFuel(vehicle, 100.0)
    elseif GetResourceState("ox_fuel") == "started" then
        result = SetVehicleFuelLevel(vehicle, 100.0)
    elseif GetResourceState("cdn-fuel") == "started" then
        result = exports['cdn-fuel']:SetFuel(vehicle, 100.0)
    elseif GetResourceState("ps-fuel") == "started" then
        result = exports['ps-fuel']:SetFuel(vehicle, 100.0)
    elseif GetResourceState("qb-fuel") == "started" then
        result = exports['qb-fuel']:SetFuel(vehicle, 100.0)
    else
        result = SetVehicleFuelLevel(vehicle, 100.0)
    end

    return result
end

-- Tells the server's clothing script to reload the player's own outfit.
-- Config.ClothingScript is auto-detected (config/gate/auto_detect.lua); set it
-- by hand there if you run something else. Our own snapshot restore
-- (client/components/changing_room.lua) runs either way.
Config.RefreshSkin               = function()
    if not Config.ChangeClothesSystem then return end
    local cs = Config.ClothingScript
    if cs == 'illenium-appearance' then
        TriggerEvent('illenium-appearance:client:reloadSkin')
        -- fivem-appearance: no reload call here on purpose. The old branch used
        -- Core.TriggerServerCallback, which does not exist on the QB client, so it
        -- never ran. Reloading needs appearance data we do not hold; the snapshot
        -- restore in changing_room.lua puts the outfit back on its own.
    elseif cs == 'esx_skin' then
        TriggerEvent('esx_skin:getLastSkin', function(lastSkin)
            TriggerEvent('skinchanger:loadSkin', lastSkin)
        end)
    elseif cs == 'rcore_clothing' then
        TriggerServerEvent('rcore_clothing:reloadSkin')
    elseif cs == 'qb-clothing' then
        TriggerEvent('qb-clothing:reloadSkin')
        ExecuteCommand('refreshskin')
    end
end

-- Notification bridge. Hook your own notification system in here.
-- `type` is only ever info | success | error — nothing else is sent.
-- ox_lib calls info 'inform', so map it: type == 'info' and 'inform' or type.
-- `key` (optional): the same key UPDATES the box in place instead of stacking
-- a new one — progress counters rely on it. Most libraries cannot do this
-- (ox_lib's `id` only shows it once). Ignoring key is safe, you get repeats.
Config.sendNotification          = function(messageData)
    local message, messageType, messageKey
    if type(messageData) == "table" then
        message = messageData.text
        messageType = messageData.type or "info"
        messageKey = messageData.key
    elseif type(messageData) == "string" then
        for key, value in pairs(Config.NotificationText) do
            if value.text == messageData then
                message = value.text
                messageType = value.type or "info"
                break
            end
        end

        if not message then
            message = messageData
            messageType = "info"
        end
    end

    if messageType ~= 'success' and messageType ~= 'error' then messageType = 'info' end

    if not Config.NotifyFilter(message, messageType, messageKey) then return end
    NuiMessage('NOTIFICATION', { message = message, type = messageType, key = messageKey })
end

-- ============================================================================
-- NOTIFICATION BURST FILTER
-- ============================================================================
-- One player action often triggers several notifications together. Two rules:
-- the same text is not repeated within repeatMs, and only infoMax 'info' boxes
-- pass per infoWindowMs. 'error' and 'success' always pass. enabled = false turns it off.
Config.NotifyBurst               = {
    enabled      = true,
    repeatMs     = 6000, -- ms: same text is not shown again within this window
    infoWindowMs = 2500, -- ms: window for the 'info' cap below
    infoMax      = 1,    -- max 'info' notifications per window
}

local notifLastText, notifInfoAt = {}, {}
Config.NotifyFilter              = function(message, messageType, messageKey)
    local b = Config.NotifyBurst
    if not (b and b.enabled) then return true end
    if type(message) ~= 'string' or message == '' then return true end

    -- Keyed notifications (progress counters) update in place, so they skip the filter.
    if messageKey then return true end

    local now = (GetGameTimer and GetGameTimer()) or 0

    local last = notifLastText[message]
    if last and (now - last) < (b.repeatMs or 6000) then return false end
    notifLastText[message] = now

    if messageType ~= 'error' then
        local win, n = (b.infoWindowMs or 2500), 0
        for i = #notifInfoAt, 1, -1 do
            if (now - notifInfoAt[i]) > win then
                table.remove(notifInfoAt, i)
            else
                n = n + 1
            end
        end
        if n >= (b.infoMax or 1) then
            if Config.Debug then
                print(('[notify] info bastirildi (pencerede %d): %s'):format(n, message))
            end
            return false
        end
        notifInfoAt[#notifInfoAt + 1] = now
    end
    return true
end

-- Called before a job starts. Return false to block it (level, gang, whitelist).
-- Optional progress bar override. Leave nil for the built-in NUI bar. A
-- BLOCKING function (ox_lib's lib.progressBar) is fine — it is already called
-- inside its own thread, so it cannot stall the job flow.
--   Config.ProgressBar = function(label, seconds)
--       lib.progressBar({ label = label, duration = seconds * 1000 })
--   end
Config.ProgressBar               = nil
Config.HideProgressBar           = nil

-- Framework job required to start a job. nil or '' = anyone can work.
-- Checked for EVERY crew member; one member without it blocks the start.
-- Works on qb and esx alike -- both job shapes are read.
--   Config.RequiredJob = 'builder'
Config.RequiredJob               = nil

Config.startJobFunction          = function(source, owneridentifier)
    return true
end

-- Called once per crew member when a job is completed. Hook a skill tree or
-- level system here. `data` carries: jobType, regionId, regionName,
-- regionNameKey, score, money, rewardPct, crewSize, seconds, isOwner, paid.
--   exports['your_skilltree']:addXp('construction', data.score * 2, source)
Config.endJobFunction            = function(source, owneridentifier, scoreAmount, data)
end

-- Display names for the language menu. The menu itself is built from the
-- locales/ folder, so dropping a new <code>.lua in there makes it appear;
-- a code with no name here is shown uppercased.
Config.LanguageNames             = {
    en = 'English',
    tr = 'Türkçe',
    de = 'Deutsch',
    es = 'Español',
    fr = 'Français',
    hu = 'Magyar',
    ja = '日本語',
    nl = 'Nederlands',
    pt = 'Português',
    ro = 'Română',
    ru = 'Русский',
    sl = 'Slovenščina',
    sv = 'Svenska',
    zh = '中文',
}

Config.LanguageTitle             = (function()
    local codes = {}
    for code in pairs(Locales or {}) do codes[#codes + 1] = code end
    table.sort(codes, function(a, b)
        if a == 'en' then return true end
        if b == 'en' then return false end
        return a < b
    end)
    local out = {}
    for _, code in ipairs(codes) do
        out[#out + 1] = { value = code, label = Config.LanguageNames[code] or code:upper() }
    end
    return out
end)()

-- Extra reward share by score rank (a table per crew size).
-- Applied to both money and XP, AFTER the job split and damage deductions.
Config.ScoreRankBonus            = {
    enabled = true,
    table = {
        [1] = { 0 },
        [2] = { 8, 0 },
        [3] = { 10, 5, 0 },
        [4] = { 12, 8, 5, 0 },
    },
    applyToXP = true,
}

-- Letting a disconnected player back into the job. Within the window they get
-- their lobby seat, task progress and reward share back.
Config.Reconnection              = {
    enabled = true,

    gracePeriodSeconds = 0,

    maxReconnectAttempts = 3,

    resetAttemptsAfterSeconds = 300,

    ownerTransfer = {
        enabled = true,

        allowRejoinAsMember = true,

        prioritizeByScore = true,

        minimumLobbyTime = 60,
    },

    debugLogs = false,

    notifications = {
        notifyOnDisconnect = true,

        notifyOnReconnect = true,

        notifyAttemptsRemaining = true,
    },
}

function Config.GetJobCfgFor(regionInfo)
    local map  = {
        plank               = Config.PlankJob,
        pipe                = Config.PipeJob,
        waterfacility       = Config.WaterFacilityJob,
        waterfacility2      = Config.WaterFacility2Job,
        excavator_dirt      = Config.ExcavatorJob,
        job12               = Config.Job12,
        job9                = Config.Job9,
        job7                = Config.Job7,
        job8                = Config.Job8,
        panelwall           = Config.PanelWall,
        kulestone           = Config.TowerStoneJob,
        ['kulestone:site2'] = Config.TowerSite2Job,
    }
    local t    = (regionInfo and regionInfo.jobType) or 'plank'
    local inst = regionInfo and regionInfo.jobMetadata and regionInfo.jobMetadata.instanceId
    return (inst and map[t .. ':' .. tostring(inst)]) or map[t]
end

-- Scenery machines that stand on site but are not played.
Config.StaticMachinesByJobType = {
    kulestone = { TL('machine_tower_crane', 'Tower Crane') },
}

function Config.BuildRegionUIInfo(regionInfo)
    local jcfg = Config.GetJobCfgFor(regionInfo)
    if not jcfg then return nil end

    local lobbyCap = tonumber(Config.MaxPlayersInLobby) or 0
    local minP = tonumber(jcfg.minPlayers) or 1
    local maxP = tonumber(jcfg.maxPlayers) or 0
    if maxP <= 0 then maxP = lobbyCap end
    if lobbyCap > 0 and maxP > lobbyCap then maxP = lobbyCap end
    if maxP > 0 and minP > maxP then minP = maxP end

    local machines = {}
    for _, t in ipairs(Config.StaticMachinesByJobType[regionInfo and regionInfo.jobType or ''] or {}) do
        machines[#machines + 1] = t
    end
    for _, rtype in ipairs(jcfg.rentAllowed or {}) do
        local rv = Config.RentalVehicles and Config.RentalVehicles[rtype]
        machines[#machines + 1] = (rv and rv.label) or rtype
    end

    local tutMods = Config.TutorialByJobType
        and Config.TutorialByJobType[regionInfo and regionInfo.jobType or '']

    return { crewMin = minP, crewMax = maxP, machines = machines, tutorialModules = tutMods }
end

-- Resolved at load time (server language) -- kept for server-side use.
-- The NUI region cards use JobTypeLabelKeys below, resolved per player.
