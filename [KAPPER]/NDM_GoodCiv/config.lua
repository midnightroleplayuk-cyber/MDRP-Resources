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
    -- Command players use to sign up / sign off as a GoodCiv carrier.
    -- Set to nil to only allow signing up at a sign-up ped (Config.SignupPeds).
    Command = 'goodciv',
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
-- GoodCiv training (quiz at the sign-up NPC before a player can go on duty)
---------------------------------------------------------------------------
-- Players talk to the sign-up NPC (hf1_npcs, target event: goodciv:client:toggleCarrier).
-- Not certified yet -> they take the quiz. Pass -> certified for good and put on duty.
-- Certified -> the NPC (or /goodciv) puts them on / off duty.
Config.Training = {
    Enabled = true,
    -- Correct answers needed to pass (out of #Questions).
    PassMark = 3,
    -- Seconds a player must wait after failing before trying again.
    RetryCooldown = 300,
    -- answer = the number of the correct option (1 = first option).
    -- Answers are checked on the server and never sent to players.
    Questions = {
        {
            question = 'You find someone unresponsive and not breathing normally. What do you do first?',
            options = {
                'Put them in the recovery position and wait',
                'Call for help and start CPR',
                'Give them some water',
                'Leave them and look for a medic',
            },
            answer = 2,
        },
        {
            question = 'How fast should you do chest compressions during CPR?',
            options = {
                '30 to 50 per minute',
                '60 to 80 per minute',
                '100 to 120 per minute',
                '150 to 180 per minute',
            },
            answer = 3,
        },
        {
            question = 'Someone is bleeding heavily from their leg and it will not stop. What should you do?',
            options = {
                'Wash the wound with water',
                'Remove their clothing and leave it uncovered',
                'Apply a tourniquet above the wound',
                'Ask them to walk it off',
            },
            answer = 3,
        },
    },
}

---------------------------------------------------------------------------
-- Sign-up peds (talk to one of these to sign up / sign off as a carrier)
---------------------------------------------------------------------------
Config.SignupPeds = {
    -- Off: the sign-up NPC is placed with hf1_npcs instead (target event: goodciv:client:toggleCarrier).
    Enabled = false,
    -- 'auto' | 'ox_target' | 'qb-target' | 'key'
    -- 'auto' uses ox_target, then qb-target, then a "press E" prompt.
    Interaction = 'ox_target',
    -- How close (metres) the player must be to interact.
    Distance = 2.5,
    -- Peds spawn when a player is within this distance and despawn beyond it.
    SpawnDistance = 60.0,
    Locations = {
        {
            label = 'GoodCiv Volunteer desk',
            model = `s_m_m_doctor_01`,
            -- Where the ped stands (x, y, z, heading). Use the coords from where YOUR
            -- character stands (e.g. /getcoords): the ped is placed 1m lower onto the floor.
            coords = vector4(-305.35, -147.01, 40.24, 120.35),
            scenario = 'WORLD_HUMAN_CLIPBOARD', -- nil = stand idle
            blip = { sprite = 280, colour = 2, scale = 0.7 }, -- nil = no blip
        },
        -- Add more:
        -- { label = 'GoodCiv - Sandy Shores', model = `s_f_y_scrubs_01`, coords = vector4(1839.0, 3673.0, 34.3, 210.0) },
    },
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
    -- Command civilians use to request a medic. Goes through the normal
    -- dispatch first, then falls back to GoodCiv carriers if no medics are on duty.
    -- nil = no command (vinewood-dispatch's /111 is used instead, see Config.Dispatch.Vinewood).
    Command = nil,

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

    -- Where /medic calls are forwarded so real medics see them.
    -- 'builtin'      : GoodCiv shows its own alert + blip to on-duty medics
    -- 'vinewood'     : vinewood-dispatch (injured_person preset)
    -- 'ps-dispatch'  : ps-dispatch (v2) server event
    -- 'cd_dispatch'  : cd_dispatch
    -- 'custom'       : call Config.Dispatch.Custom below
    -- 'none'         : don't forward
    Provider = 'vinewood',

    -- vinewood-dispatch bridge (only active while vinewood-dispatch is running).
    -- When vinewood raises one of these ambulance calls and no ambulance units are on duty,
    -- GoodCiv alerts carriers for any downed player near the call.
    Vinewood = {
        Enabled = true,
        Presets = {
            'person_down',     -- automatic civilian down detection
            'call_111',        -- /111
            'injured_person',
        },
        -- Downed players within this distance (metres) of the call become GoodCiv patients.
        -- Covers bystanders calling /111 for someone else.
        PatientRadius = 30.0,
        -- Count on-duty medics with vinewood's ambulance service (Config.Services in vinewood).
        UseVinewoodDuty = true,
        -- Post GoodCiv progress (volunteers alerted / responding / handed over) as call updates.
        Notes = true,
        NoteAuthor = 'GoodCiv',
    },

    -- Used when Provider = 'custom'. Runs on the server.
    ---@param patient number server id of the caller
    ---@param coords vector3
    ---@param message string
    Custom = function(patient, coords, message)
        -- exports['my-dispatch']:SendAlert({ job = 'ambulance', coords = coords, message = message })
    end,
}

---------------------------------------------------------------------------
-- Patient condition
---------------------------------------------------------------------------
Config.Conditions = {
    -- Only life-threatening calls (unconscious, not breathing, major bleeding) go to carriers.
    LifeThreateningOnly = true,
    -- Cardiac arrest (CPR needed) comes from the real downed state: only stage 2 / no signs
    -- of life. Last stand patients are breathing and only need bleeding control.
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
        Item = nil,   -- nil or '' = no item needed
        ConsumeItem = true,
    },
    CPR = {
        Duration = 20,         -- seconds per CPR cycle
        TargetBpm = { 100, 120 },
        BaseChance = 0.25,     -- chance of ROSC with zero technique
        TechniqueBonus = 0.55, -- added on top, scaled by compression quality (0-1)
        UntreatedBleedPenalty = 0.6, -- chance multiplier if major bleed not controlled
        Cooldown = 3,
        -- Successful CPR brings the patient round on scene (see Config.WakeUp) instead of
        -- leaving them down until hospital handover. They stay injured until they check in.
        WakeOnSuccess = true,
        WakeHealth = 120,      -- health after coming round (max 200, 100 = downed)
    },
    -- When osp_ambulance is running, play its CPR "help up" scene (responder helps the
    -- patient to their feet) after successful CPR or rousing.
    HelpUpScene = true,
    -- Unconscious but breathing: talk to them, tap their shoulders, pain stimulus.
    -- Success brings them round on scene (same as CPR: Config.WakeUp, injured until check-in).
    Rouse = {
        Duration = 8,
        BaseChance = 0.3,       -- chance per attempt
        PerAttemptBonus = 0.1,  -- added for each failed attempt, so persistence pays off
        Cooldown = 3,
    },
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

Config.Hospitals = {
    { label = 'Pillbox Hill Medical', coords = vector3(298.6, -584.5, 43.3), drop = vector4(307.6, -595.3, 43.3, 70.0), radius = 30.0 },
    { label = 'Mount Zonah Medical', coords = vector3(-449.7, -340.8, 34.5), drop = vector4(-448.5, -336.6, 34.5, 80.0), radius = 30.0 },
    { label = 'Sandy Shores Medical', coords = vector3(1839.4, 3672.9, 34.3), drop = vector4(1838.3, 3674.3, 34.3, 210.0), radius = 30.0 },
    { label = 'Paleto Bay Medical', coords = vector3(-247.8, 6331.2, 32.4), drop = vector4(-251.2, 6334.1, 32.4, 225.0), radius = 30.0 },
}

---------------------------------------------------------------------------
-- Revive on handover
---------------------------------------------------------------------------
-- How a patient is revived once handed over at a hospital. Runs on the server.
-- Defaults per framework are below; override if your ambulance script differs.
Config.Revive = {
    qbcore = function(src) TriggerClientEvent('hospital:client:Revive', src) end,
    qbox = function(src)
        if GetResourceState('osp_ambulance') == 'started' then
            -- osp_ambulance full revive (true = revive even if osp flags the injuries as unsurvivable)
            TriggerClientEvent('hospital:client:Revive', src, true)
        else
            -- qbx_medical; swap for your own if you use a different medical script
            TriggerClientEvent('qbx_medical:client:playerRevived', src)
        end
    end,
    esx = function(src) TriggerClientEvent('esx_ambulancejob:revive', src) end,
    standalone = function(src) TriggerClientEvent('goodciv:client:standaloneRevive', src) end,
}

---------------------------------------------------------------------------
-- Wake up after CPR
---------------------------------------------------------------------------
-- How a patient is brought round on scene after successful CPR (Config.Treatment.CPR.WakeOnSuccess).
-- Health is then dropped to Config.Treatment.CPR.WakeHealth. 'osp' is used whenever
-- osp_ambulance is running, whatever the framework.
Config.WakeUp = {
    -- osp partial revive: gets them up but keeps their wounds, and osp won't let health
    -- go back up until they're treated or check in at a hospital.
    osp = function(src) TriggerClientEvent('osp_ambulance:partialRevive', src, true) end,
    qbcore = function(src) TriggerClientEvent('hospital:client:Revive', src) end,
    qbox = function(src) TriggerClientEvent('qbx_medical:client:playerRevived', src) end,
    esx = function(src) TriggerClientEvent('esx_ambulancejob:revive', src) end,
    standalone = function(src) TriggerClientEvent('goodciv:client:standaloneRevive', src) end,
}

---------------------------------------------------------------------------
-- Rewards
---------------------------------------------------------------------------
Config.Rewards = {
    Enabled = true,
    Account = 'cash',   -- qb/qbx: cash | bank, esx: money | bank
    Handover = 350,     -- per responder on successful hospital handover
    Assist = 100,       -- per responder whose patient was revived on scene by others
}
