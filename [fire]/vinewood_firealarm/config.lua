Config = {}

Config.Debug = false

-- 'auto' | 'qbx' | 'qb' | 'esx' | 'standalone'
Config.Framework = 'auto'

-- Admin access (ace). Add to server.cfg:  add_ace group.admin vinewood.firealarm.admin allow
Config.AdminAce = 'vinewood.firealarm.admin'
Config.AdminCommand = 'firealarm'

-- Panels show 8 zones (matches the panel fascia)
Config.MaxZones = 8

---------------------------------------------------------------------
-- Props. Swap these for your own models once they're streamed.
-- Pivot should sit at the BACK-CENTRE of the model so it mounts flush
-- to walls. If a model isn't found, that device falls back to a
-- target point (no prop) automatically.
---------------------------------------------------------------------
Config.Props = {
    mcp        = 'prop_vw_firealert',    -- red break glass call point (streamed in /stream)
    mcp_active = nil,                    -- optional: broken-glass model swapped in while activated
    panel      = 'prop_vw_firepanel',    -- control panel (streamed in /stream)
    sounder    = 'prop_vw_sounder',      -- wall sounder (streamed in /stream)
    detector   = 'prop_vw_smokedetector',-- ceiling smoke detector (streamed in /stream)
    sprinkler  = 'prop_vw_sprinkler',    -- ceiling sprinkler head (streamed in /stream)
}

-- Where each model touches the wall. anchor = the point on the model (in its
-- own local space) that sits on the surface you aim at: normally the centre
-- of its back. heading = extra rotation so the front faces out of the wall
-- (180 for models whose front faces -Y). Read from the model bounds.
Config.PropAnchors = {
    prop_vw_firepanel = { anchor = vec3(0.0, 0.081, 0.212), heading = 180.0 },
    prop_vw_firealert = { anchor = vec3(-0.0425, 0.014, 0.038), heading = 180.0 },
    prop_vw_sounder   = { anchor = vec3(0.0, 0.043, 0.0775), heading = 180.0 },
    prop_vw_sprinkler = { anchor = vec3(0.0, 0.0035, 0.11), heading = 0.0 },     -- top plate, for ceilings
    prop_vw_smokedetector = { anchor = vec3(0.01, 0.0065, 0.042), heading = 0.0 },  -- top of the base, for ceilings
}

-- Extra gap from the surface (metres), on top of the anchor.
Config.WallOffset = 0.0
Config.CeilingOffset = 0.0

Config.SpawnDistance = 80.0          -- props spawn/despawn around players
Config.TargetDistance = 1.5

---------------------------------------------------------------------
-- Live screen on the panel prop (DUI). Everyone near a panel sees its
-- status on the model's screen without opening the UI.
--  txd     : texture dictionary holding the screen texture (firealarm_txd.ytd)
--  texture : the screen texture's name inside it
--  width/height : resolution of the live page. Match the SHAPE of the screen
--            face on the model (not the texture, which is 1024x1024), or
--            the text will look stretched.
---------------------------------------------------------------------
Config.Screen = {
    enabled = true,
    txd = 'firealarm_txd',
    texture = 'firealarmscreen',
    width = 768,
    height = 416,   -- screen face on prop_vw_firepanel is 27.6 x 14.9 cm
    distance = 20.0,
}

---------------------------------------------------------------------
-- Access levels (BS 5839 / EN 54-2 style)
--  Level 1 : anyone — view status, mute panel buzzer, lamp test
--  Level 2 : user code / business staff / fire service — silence, reset, evacuate, disablements
--  Level 3 : engineer code / admin — test mode, view who triggered devices
---------------------------------------------------------------------
Config.AccessTimeout = 300           -- seconds of inactivity before dropping back to level 1
Config.MaxCodeAttempts = 5
Config.CodeLockout = 60              -- seconds locked out after too many wrong codes

-- Jobs that get access to every panel. job = { minGrade, level }
Config.FireServiceJobs = {
    fire = { minGrade = 0, level = 2 },
    lfb  = { minGrade = 0, level = 2 },
}

-- Business owner job (set per system in the admin menu) gets level 2 automatically
Config.OwnerJobGetsLevel2 = true

---------------------------------------------------------------------
-- Behaviour
---------------------------------------------------------------------
Config.BreakGlassCooldown = 60       -- per player, seconds
Config.RequireCallPointReset = true  -- activated MCPs must be reset with the key at the device before the panel can reset
Config.NewZoneResounds = true        -- a new zone going into alarm resounds silenced sounders
Config.TestSoundDuration = 10        -- seconds sounders run per device activation in test mode
Config.SounderTestDuration = 15      -- seconds for the 'Test sounders' panel option
Config.DetectorRange = 12.0          -- TriggerAtCoords export: max distance to a detector
Config.EventLogSize = 50

---------------------------------------------------------------------
-- Servicing (BS 5839-style periodic service). Systems come due every
-- `interval` real days. An engineer from a service job starts a visit at
-- the panel, tests every device in person, then signs it off at the panel
-- and gets paid. Overdue systems slowly develop faults: faulty detectors
-- don't detect, faulty sounders don't sound, faulty call points and
-- sprinklers don't work.
---------------------------------------------------------------------
Config.Servicing = {
    enabled = true,
    jobs = { fire = 0 },          -- job = minimum grade. These jobs get level 2 at every panel.
    interval = 14,                -- real days between services
    dueSoon = 2,                  -- days before due that it shows "service due"
    requiredPercent = 100,        -- % of devices that must be tested to sign off

    payment = 250,                -- paid to the engineer on sign-off (0 to disable)
    account = 'bank',
    -- Optional: charge the business too. Runs on the server.
    -- ChargeBusiness = function(system, amount) end,

    notifyJobs = true,            -- notify on-duty service jobs when a system comes due
    dispatchCall = true,          -- also send a low-priority job to your dispatch
    command = 'fireservice',      -- opens the service schedule (service jobs and admins)

    faults = { enabled = true, chancePerDay = 0.10 },  -- chance per device, per day overdue

    -- Seconds to test each device type
    times = { panel = 10, mcp = 6, detector = 8, sounder = 5, sprinkler = 7 },
}

---------------------------------------------------------------------
-- Automatic detection: smoke detectors go off on their own when they
-- sense fire or smoke. A detection has to be seen on `confirm` checks
-- in a row (so a passing molotov flash doesn't set it off instantly).
---------------------------------------------------------------------
Config.Detection = {
    enabled = true,
    interval = 2000,          -- ms between checks
    confirm = 2,              -- consecutive checks needed before the alarm triggers
    range = 6.0,              -- metres from the detector

    vinewoodFire = true,      -- fires from vinewood_fire (checked on the server via IsFireNear)
    nativeFire = true,        -- GTA fires: molotovs, burning vehicles, script fires
    explosions = true,        -- explosions near the detector
    smokeGrenades = true,     -- smoke grenades and BZ gas
}

---------------------------------------------------------------------
-- Sprinklers. Only operate when a smoke detector detects fire or smoke
-- (never from call points, admin triggers or tests). They run until the
-- panel is reset or someone with level 2 shuts them off.
---------------------------------------------------------------------
Config.Sprinklers = {
    enabled = true,
    mode = 'zone',            -- 'zone': every sprinkler in the detector's zone
                              -- 'radius': only sprinklers within `radius` of the detector (same zone)
    radius = 10.0,
    coverage = 4.0,           -- metres each sprinkler head covers
    maxDuration = 0,          -- seconds before they stop on their own (0 = until reset/shut off)

    -- Putting fires out
    suppressNative = true,    -- puts out GTA fires under the head
    suppressVinewoodFire = true, -- applies water to vinewood_fire cells (via its GrantAgent/ApplyAgent)
    agent = 'water',
    rate = 8.0,               -- agent per second per head (vinewood_fire scale)
    wetPlayers = true,        -- players under a head get soaked

    -- Spray effect. Adjust rot if the spray points the wrong way.
    ptfx = { dict = 'core', name = 'water_cannon_spray', scale = 0.45, rot = vec3(-90.0, 0.0, 0.0), offset = -0.15 },
}

---------------------------------------------------------------------
-- Sound
-- Tones: 'bs_alternating' (recorded BS two-tone 800/970Hz at 2Hz, html/sounds),
--        'alternating' (generated 800/970Hz two-tone), 'continuous' (970Hz),
--        'pulsed' (970Hz 1s on/off — UK 'alert'), 'sweep' (800-970Hz whoop)
---------------------------------------------------------------------
Config.DefaultTone = 'bs_alternating'
Config.DefaultSoundRadius = 40.0
Config.MasterVolume = 0.35
Config.InteriorDampen = 0.35         -- volume multiplier when you're not in the same interior as the sounder
Config.Beacons = true                -- red flashing light at sounders while sounding
Config.BeaconRange = 6.0

---------------------------------------------------------------------
-- Alarm Receiving Centre / dispatch
---------------------------------------------------------------------
Config.Dispatch = {
    enabled = true,
    defaultDelay = 30,               -- seconds between first alarm and the fire service being called (if not reset)

    -- Which dispatch to send to. 'auto' picks the first one running, in this order:
    --   'vinewood-dispatch', 'ps-dispatch', 'cd_dispatch', 'qs-dispatch',
    --   'rcore_dispatch', 'core_dispatch', 'lb-tablet'
    -- or set one of those names to force it, or 'none' to only log to the console.
    system = 'auto',

    code = 'AFA',
    title = 'Automatic fire alarm',
    priority = 2,                    -- 1 = immediate, 2 = urgent, 3 = routine (mapped to each dispatch's own scale)
    jobs = { 'fire' },               -- jobs that get the call
    blip = { sprite = 436, colour = 1, scale = 1.1, flash = true, time = 300 },  -- time in seconds

    -- Per-dispatch extras
    psCodeName = 'firealarm',        -- ps-dispatch: add a Config.Blips entry with this name (see README)
    psJobs = nil,                    -- ps-dispatch: job TYPES if different from jobs, e.g. { 'fire' }
    lbMdt = 'Fire',                  -- lb-tablet: MDT to send to (from lb-tablet/config/mdts.json)
    icon = 'fas fa-fire',            -- ps-dispatch / qs-dispatch icon

    notes = true,                    -- vinewood-dispatch only: post updates to the call (further zones, silenced, reset)
    closeOnReset = false,            -- vinewood-dispatch only: close the call when the panel is reset

    -- Optional: replace all of the above with your own. Runs on the server.
    -- Send = function(data)
    --     -- data = { system, systemId, zone, zoneName, device, reason, coords (vector3), location, title, description, street }
    -- end,
}

-- Discord webhook for activation logs (leave blank to disable)
Config.Webhook = ''

---------------------------------------------------------------------
-- Placement controls
---------------------------------------------------------------------
Config.Placement = {
    maxDistance = 10.0,
    rotateStep = 5.0,
    fineRotateStep = 1.0,
}
