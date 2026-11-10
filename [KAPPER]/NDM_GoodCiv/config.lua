Config = {}

-- Framework: 'auto' | 'qbcore' | 'qbox' | 'esx' | 'standalone'
-- 'auto' picks qbx_core, then qb-core, then es_extended, then falls back to standalone.
Config.Framework = 'auto'

-- Inventory used for tourniquets / kits: 'auto' | 'ox_inventory' | 'framework' | 'none'
-- 'none' means items are never required or consumed.
Config.Inventory = 'auto'

Config.Locale = 'en'
Config.Debug = false

---------------------------------------------------------------------------
-- Medics
---------------------------------------------------------------------------
Config.Medics = {
    -- Jobs that count as medics. A medic must be on duty to count.
    Jobs = { 'ambulance', 'ems', 'doctor', 'fire' },
    -- Standalone servers: players with this ace count as on-duty medics.
    StandaloneAce = 'goodciv.medic',
    -- GoodCiv carriers are only alerted when FEWER than this many medics are on duty.
    -- 1 = "only when there are no medics at all".
    MinOnDuty = 1,
}

---------------------------------------------------------------------------
-- GoodCiv carriers (the civilian volunteers)
---------------------------------------------------------------------------
Config.Carriers = {
    -- Command players use to sign up / sign off as a GoodCiv volunteer.
    Command = 'goodcivsignup',
    -- Players with these jobs can never be carriers (they have their own dispatch).
    BlockedJobs = { 'police', 'sheriff', 'ambulance', 'ems', 'doctor', 'fire' },
    -- Optional item a carrier must hold to sign up and to receive alerts (nil = none).
    -- e.g. 'firstaid_kit'
    RequiredItem = nil,
    -- Optional ace permission required to sign up (nil = anyone).
    -- e.g. 'goodciv.carrier'  ->  add_ace group.carrier goodciv.carrier allow
    AcePermission = nil,
    -- Remember opt-in between sessions (stored in server KVP by identifier).
    Persist = true,
}

---------------------------------------------------------------------------
-- Alerts
---------------------------------------------------------------------------
Config.Alerts = {
    -- Only carriers within this distance (metres) of the patient are alerted. 0 = everyone.
    Radius = 2500.0,
    -- Seconds an alert stays on screen before it is auto-declined.
    Timeout = 30,
    -- How many carriers may accept the same incident.
    MaxResponders = 2,
    -- If nobody accepts, re-alert carriers this many seconds later (0 = never).
    RealertAfter = 60,
    -- Incident closes automatically after this many seconds with no handover.
    IncidentLifetime = 900,
    -- Default keys (players can rebind in Settings > Key Bindings > FiveM).
    AcceptKey = 'PAGEUP',
    DeclineKey = 'PAGEDOWN',
    -- Sound on alert (frontend sound name / set).
    Sound = { name = 'Event_Message_Purple', set = 'GTAO_FM_Events_Soundset' },
}

---------------------------------------------------------------------------
-- Dispatch integration
---------------------------------------------------------------------------
Config.Dispatch = {
    -- Command a downed player uses to request a GoodCiv volunteer (/goodciv).
    -- The call is also forwarded to your normal dispatch (Provider below). Volunteers
    -- are alerted when fewer than Config.Medics.MinOnDuty medics are on duty.
    -- Set Config.Medics.MinOnDuty = 999 to always alert volunteers.
    Command = 'goodciv',

    -- Existing "call EMS" server events to piggyback on. When any of these fire,
    -- the call has already gone to your normal dispatch, so GoodCiv only performs
    -- the "no medics available" fallback check for the sender.
    -- Remove the ones you don't use or add your own.
    ListenEvents = {
        'hospital:server:ambulanceAlert',      -- qb-ambulancejob (last stand / dead "call EMS")
        'esx_ambulancejob:onPlayerDistress',   -- esx_ambulancejob distress signal
    },

    -- Automatically raise an incident when a player goes down (seconds after going down, 0 = off).
    -- Leave at 0 if your death screen already has a "call EMS" button wired into ListenEvents.
    AutoAlertDelay = 0,

    -- Where /goodciv calls are forwarded so real medics see them.
    -- 'builtin'      : GoodCiv shows its own alert + blip to on-duty medics
    -- 'ps-dispatch'  : ps-dispatch (v2) server event
    -- 'cd_dispatch'  : cd_dispatch
    -- 'custom'       : call Config.Dispatch.Custom below
    -- 'none'         : don't forward
    Provider = 'builtin',

    -- Used when Provider = 'custom'. Runs on the server.
    ---@param patient number server id of the caller
    ---@param coords vector3
    ---@param message string
    Custom = function(patient, coords, message)
        -- exports['my-dispatch']:SendAlert({ job = 'ambulance', coords = coords, message = message })
    end,
}

---------------------------------------------------------------------------
-- Down state (standalone)
---------------------------------------------------------------------------
-- GoodCiv can run its own "downed" state so it works without any ambulance script.
Config.Down = {
    -- 'auto'      : use GoodCiv's down state unless one of MedicalScripts is running
    -- 'goodciv'   : always use GoodCiv's down state
    -- 'framework' : never; your ambulance script handles death / last stand / revive
    Mode = 'auto',
    MedicalScripts = {
        'qb-ambulancejob', 'qbx_medical', 'esx_ambulancejob', 'wasabi_ambulance',
        'ars_ambulancejob', 'osp_ambulance', 'ak47_ambulancejob', 'ak47_qb_ambulancejob',
        'p_ambulancejob', 'visn_are', 'brutal_ambulancejob',
    },
    -- Seconds before a downed player may respawn at the nearest hospital (0 = never).
    RespawnAfter = 600,
    -- Seconds to hold E to respawn.
    RespawnHold = 3,
    -- Charged on respawn if the player can afford it (framework servers only).
    RespawnFee = 500,
    -- Animations while down.
    Anim = { dict = 'dead', clip = 'dead_a' },
    VehicleAnim = { dict = 'random@crash_rescue@car_death@std_car', clip = 'loop' },
}

---------------------------------------------------------------------------
-- Injured after being brought round
---------------------------------------------------------------------------
-- When a GoodCiv volunteer brings a patient round on scene, the patient's health is
-- held low until they check in at a hospital.
Config.Injury = {
    Enabled = true,
    -- Health is capped at this percentage until check-in.
    HealthPercent = 25,
    -- Injured walk and no sprinting / jumping until check-in. Clipset = nil to skip.
    Clipset = 'move_m@injured',
    DisableSprint = true,
    -- Set a GPS waypoint to the nearest check-in point when brought round.
    Waypoint = true,
    -- Remember the injury across reconnects (stored in server KVP by identifier).
    Persist = true,
}

---------------------------------------------------------------------------
-- Hospital check-in
---------------------------------------------------------------------------
Config.CheckIn = {
    -- 'goodciv'  : GoodCiv check-in points (Config.Hospitals + points made with /goodcivconfig)
    -- 'external' : your hospital script. Its revive / heal events (ExternalEvents) or the
    --              CheckIn export clear the injury. GoodCiv points are hidden.
    -- 'both'     : either one clears the injury
    Mode = 'both',
    -- Use the hospitals in Config.Hospitals as check-in points as well as in-game ones.
    UseConfigHospitals = true,
    -- Metres from the point to check in.
    Distance = 1.8,
    -- Seconds the treatment takes.
    Duration = 10,
    -- Default fee (each point can override it). Framework servers only.
    Fee = 250,
    Account = 'bank',   -- qb/qbx: cash | bank, esx: money | bank
    -- Map blips for check-in points: 'all' | 'custom' (only /goodcivconfig points) | 'none'
    Blips = 'custom',
    -- Handing a patient over at a hospital counts as checking them in.
    HandoverCountsAsCheckIn = true,
    -- Client events from your hospital script that mean "this player was treated".
    -- Used when Mode is 'external' or 'both'. Ignored for ExternalGrace seconds after
    -- a GoodCiv revive, since the revive itself may fire one of them.
    ExternalEvents = {
        'hospital:client:Revive',            -- qb-ambulancejob (check-in bed / EMS revive)
        'qbx_medical:client:playerRevived',  -- qbx_medical
        'esx_ambulancejob:revive',           -- esx_ambulancejob
    },
    ExternalGrace = 8,
}

---------------------------------------------------------------------------
-- Admin
---------------------------------------------------------------------------
Config.Admin = {
    -- In-city check-in point creator.
    Command = 'goodcivconfig',
    -- Admin revive: /goodcivrevive [id]  (also clears the injury)
    ReviveCommand = 'goodcivrevive',
    -- Ace needed for both:  add_ace group.admin goodciv.admin allow
    Ace = 'goodciv.admin',
}

---------------------------------------------------------------------------
-- Patient condition
---------------------------------------------------------------------------
Config.Conditions = {
    -- Only life-threatening calls (unconscious, not breathing, major bleeding) go to carriers.
    LifeThreateningOnly = true,
    -- Chance (0-1) a downed patient is in cardiac arrest (not breathing).
    NotBreathingChance = 0.6,
    -- Chance (0-1) of major bleeding by the damage type that put the patient down.
    -- Damage types: bullet, explosive, melee, vehicle, fall, other
    MajorBleedChance = {
        bullet = 0.85,
        explosive = 0.7,
        melee = 0.4,
        vehicle = 0.5,
        fall = 0.2,
        other = 0.1,
    },
}

---------------------------------------------------------------------------
-- Treatment
---------------------------------------------------------------------------
Config.Treatment = {
    -- Responder must be this close (metres) to treat.
    Distance = 3.0,
    Assess = { Duration = 3 },
    Tourniquet = {
        Duration = 6,
        Item = 'tourniquet',   -- nil = no item needed
        ConsumeItem = true,
    },
    CPR = {
        Duration = 20,         -- seconds per CPR cycle
        TargetBpm = { 100, 120 },
        BaseChance = 0.25,     -- chance of ROSC with zero technique
        TechniqueBonus = 0.55, -- added on top, scaled by compression quality (0-1)
        UntreatedBleedPenalty = 0.6, -- chance multiplier if major bleed not controlled
        Cooldown = 3,
    },
    RecoveryPosition = { Duration = 4 },
    -- Bring a stable patient round on scene. They get up injured (Config.Injury).
    BringRound = { Duration = 8 },
}

---------------------------------------------------------------------------
-- Transport
---------------------------------------------------------------------------
Config.Transport = {
    -- Patient must be breathing with bleeding controlled before you can load them.
    RequireStable = true,
    -- Max distance (metres) from the responder to the vehicle used.
    VehicleDistance = 6.0,
    -- Speed limit (mph) for the driver while the patient is onboard. 0 = no limit.
    SpeedLimitMph = 70,
    -- A hit that removes this much vehicle body health counts as a crash.
    CrashThreshold = 80.0,
    -- Chance a crash makes a stable patient arrest again.
    CrashArrestChance = 0.35,
    -- Vehicle classes that can't be used (8 = motorcycles, 13 = cycles, 14 = boats, 15 = helis, 16 = planes...).
    BlockedClasses = { 8, 13, 14, 15, 16, 21 },
}

-- Built-in hospitals. Patients are handed over inside `radius` of `coords`; `drop` is
-- the check-in desk. Add more in-game with /goodcivconfig. Optional `fee` per hospital.
Config.Hospitals = {
    { label = 'Pillbox Hill Medical', coords = vector3(298.6, -584.5, 43.3), drop = vector4(307.6, -595.3, 43.3, 70.0), radius = 30.0 },
    { label = 'Mount Zonah Medical', coords = vector3(-449.7, -340.8, 34.5), drop = vector4(-448.5, -336.6, 34.5, 80.0), radius = 30.0 },
    { label = 'Sandy Shores Medical', coords = vector3(1839.4, 3672.9, 34.3), drop = vector4(1838.3, 3674.3, 34.3, 210.0), radius = 30.0 },
    { label = 'Paleto Bay Medical', coords = vector3(-247.8, 6331.2, 32.4), drop = vector4(-251.2, 6334.1, 32.4, 225.0), radius = 30.0 },
}

---------------------------------------------------------------------------
-- Revive on handover
---------------------------------------------------------------------------
-- How a patient is revived when brought round or handed over. Runs on the server.
-- Only used when Config.Down resolves to 'framework' (your ambulance script owns the
-- down state); otherwise GoodCiv's own revive is used.
-- Defaults per framework are below; override if your ambulance script differs.
Config.Revive = {
    qbcore = function(src) TriggerClientEvent('hospital:client:Revive', src) end,
    qbox = function(src)
        -- qbx_medical; swap for your own if you use a different medical script
        TriggerClientEvent('qbx_medical:client:playerRevived', src)
    end,
    esx = function(src) TriggerClientEvent('esx_ambulancejob:revive', src) end,
    standalone = function(src) TriggerClientEvent('goodciv:client:revive', src) end,
}

---------------------------------------------------------------------------
-- Rewards
---------------------------------------------------------------------------
Config.Rewards = {
    Enabled = true,
    Account = 'cash',   -- qb/qbx: cash | bank, esx: money | bank
    Handover = 350,     -- per responder on successful hospital handover
    BringRound = 250,   -- per responder when the patient is brought round on scene
    Assist = 100,       -- per responder whose patient was revived on scene by others
}
