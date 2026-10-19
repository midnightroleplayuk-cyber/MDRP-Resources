--[[
    Apex MDT - Shared Config
    ════════════════════════════════════════════════════════════
    ONE in-game tablet, TWO modes:
        • POLICE mode - Mobile Data Terminal (CAD, records, warrants…)
        • EMS mode - Medical Data Terminal (patients, triage, beds…)
    The mode is chosen AUTOMATICALLY from the character's active job
    (Config.jobs[...].mode). Brand blue #1F5EFF (matches apex_banking).

    The live map uses the exact apex_bossmenu method (Leaflet + the
    gtamap.xyz styleAtlas tiles), see Config.map.

    Framework (ESX Legacy / QBCore / QBox) is AUTO-DETECTED at runtime - you never have to change anything to switch frameworks.

    EVERYTHING is a toggle: see Config.features below. Turn any app,
    device behaviour, integration or permission on/off freely - each
    flag is honoured by the server logic AND the NUI render.
]]

Config = {}

-- ─── General ──────────────────────────────────────────────
Config.debug        = false
Config.locale       = 'en'   -- 'en' | 'pt' | 'es' | 'fr' | 'de'
Config.resourceName = GetCurrentResourceName()

-- ─── Framework (auto-detected: ESX, QB, QBox) ─────────────
Config.framework = 'qbx'    -- 'auto' | 'esx' | 'qb' | 'qbx'

-- ═══════════════════════════════════════════════════════════
-- FEATURE TOGGLES  (turn anything on/off)
-- ═══════════════════════════════════════════════════════════
Config.features = {
    -- ── Device experience ───────────────────────────────────
    enableBootScreen      = false,  -- cold-boot splash (off = wake straight to the iOS-style lock screen)
    enableLockScreen      = true,   -- badge/PIN unlock step after boot
    enableStatusBar       = true,   -- iOS-style status bar (clock, battery, signal)
    enableSounds          = true,   -- UI clicks, dispatch chime, boot sound · RESERVED: not wired yet
    enableBattery         = false,   -- simulated battery drain while open
    enableInactivityLogout= false,   -- auto-close after Config.inactivityTimeout
    enableThemePerDept    = true,   -- tint the UI with the department colour · always on (per-job theme is built-in)
    enableLightDarkToggle = true,   -- light/dark theme switch in Settings · RESERVED: not wired yet
    enableConfigurableWidgets = true, -- dashboard widgets can be reordered/hidden · RESERVED: not wired yet

    -- ── Shared apps (both modes) ────────────────────────────
    enableDashboard       = true,
    enableDispatch        = true,   -- live CAD (911/112 calls + assign units)
    enableLiveMap         = true,   -- Leaflet live unit + call map
    enableRoster          = true,   -- department roster / on-duty board
    enableComms           = true,   -- internal chat, DMs, broadcasts, panic
    enableStats           = true,   -- department statistics + charts
    enableAuditLog        = true,   -- audit trail of every MDT action
    enableSettings        = true,
    enableCctv            = true,   -- self-contained CCTV viewer (police + EMS)
    enableBodycamApp      = true,   -- bodycam record overlay (police)

    -- ── POLICE apps ─────────────────────────────────────────
    enablePoliceProfiles  = true,   -- citizen lookup + criminal records
    enablePoliceVehicles  = true,   -- vehicle registry lookup
    enablePoliceReports   = true,   -- incident / arrest reports
    enablePoliceWarrants  = true,   -- warrant management + approvals
    enablePoliceBolos     = true,   -- be-on-the-look-out alerts
    enablePoliceCharges   = true,   -- penal code + sentence calculator
    enablePoliceCitations = true,   -- traffic fines / tickets
    enablePoliceEvidence  = true,   -- digital evidence locker + chain of custody
    enablePoliceBooking   = true,   -- step-by-step booking (mugshot/prints/charges)
    enablePoliceCourt      = true,  -- court docket / hearings (scaffold)
    enablePoliceAlpr       = true,  -- ALPR plate reader hooks + flagged-plate alerts

    -- ── EMS apps ────────────────────────────────────────────
    enableEmsPatients     = true,   -- patient clinical records
    enableEmsTriage       = true,   -- triage colours + vitals + diagnosis
    enableEmsDispatch     = true,   -- EMS-specific CAD (shares the live map)
    enableEmsBeds         = true,   -- ward / bed / admission management
    enableEmsSurgery      = true,   -- surgery scheduling + post-op notes
    enableEmsBilling      = true,   -- invoices, price table, insurance
    enableEmsPharmacy      = true,  -- medication stock + prescriptions
    enableEmsReports      = true,   -- medical reports, certificates
    enableEmsDeaths       = true,   -- deaths / forensics / autopsies
    enableEmsBloodBank     = true,  -- blood/organ bank (scaffold)
    enableEmsTelemedicine  = true,  -- remote consults between departments (scaffold)

    -- ── World / duty ────────────────────────────────────────
    enableDutyToggle      = true,   -- /duty + station-marker on/off-duty
    enableStationBlips    = true,   -- map blips on stations/hospitals
    enableCallBlips       = true,   -- world-map blips for active dispatch calls
    enableDutyMarkers     = true,   -- 3D on/off-duty marker at each station
    enablePanicButton     = true,   -- panic broadcasts location + sound
    enableUnitTracking    = true,   -- on-duty units stream GPS to the map
    enableAutoWeaponsCall = true,   -- any player's gunfire auto-creates a 10-71 for police (tuned in Config.weaponsCall)
    enableWaypointOnCall  = true,   -- "respond" sets a GPS waypoint
    enableEmsDownCall     = true,   -- a player going down auto-creates a Code Blue EMS call

    -- ── Integrations / advanced extras ─────────────────────
    enableDiscordWebhooks = true,   -- push warrants/BOLO/panic/deaths to Discord
    enableDataSharing     = true,   -- share permitted flags between PD ↔ EMS tablets
    enableFacialRecognition = false,-- mugshot match (export hook; off by default)
    enableBodycam          = false, -- body/dashcam integration (export hook)
    enableOfflineSync      = false, -- queue actions offline, sync on reconnect (hook)
    enableShiftScheduling  = true,  -- shifts / rota board in the roster · RESERVED: not wired yet

    -- ── Permissions / behaviour ─────────────────────────────
    requireDutyToOpen     = true,  -- must be on duty to open the tablet
    restrictByJob         = true,   -- only Config.jobs may open the tablet
    warrantsNeedApproval  = true,   -- a warrant needs a supervisor to go active
    reportsNeedApproval   = true,   -- reports flow draft→submitted→approved
    lockRecordEditToAuthor= false,  -- only author/supervisor can edit a record
    logEverything         = true,   -- write an audit row for each action

    -- ── Notifications ───────────────────────────────────────
    notifyOnNewCall       = true,
    notifyOnBolo          = true,   -- alert on-duty units when a BOLO is posted
    notifyOnBulletin      = true,   -- alert on-duty units when a bulletin is posted
    notifyOnWarrant       = true,   -- alert on-duty police when a warrant goes active
    notifyOnPanic         = true,   -- broadcast on-screen panic alert to nearby units
    notifyOnCriticalCall  = true,   -- RESERVED: not wired yet
    notifyOnDeath         = true,
}

-- ─── Access / how the tablet opens ────────────────────────
Config.command   = 'mdt'              -- /mdt
Config.dutyCmd   = 'duty'             -- /duty toggle
Config.panicCmd  = 'panic'            -- /panic broadcast
Config.openItem  = 'mdt_tablet'           -- usable inventory item that opens the tablet
Config.requireItem = false            -- TRUE = the player MUST carry Config.openItem to open the
                                      -- MDT at all (the /mdt command AND the keybind are gated too).
Config.keybind   = {
    enable  = true,
    key     = 'F11',                   -- predefined key to open the tablet (rebindable in-game
                                      -- via FiveM → Settings → Key Bindings → "Open MDT Tablet")
    label   = 'Open MDT Tablet',
}
Config.inactivityTimeout = 180        -- seconds of no input before auto-logout

-- --- Auto weapons call (needs Config.features.enableAutoWeaponsCall) -------
-- A player firing a gun raises a "10-71 Shots Fired" call on the police CAD,
-- with blip + map marker, for every on-duty police unit. The shooter is never
-- told. Up to 1.2.2 only an on-duty officer's OWN shots counted, so civilian
-- gunfire never reached the MDT.
Config.weaponsCall = {
    shooters        = 'civilians',     -- 'anyone'    = every player
                                    -- 'civilians' = everyone except on-duty police units
                                    -- 'units'     = only on-duty MDT units (the old behaviour)
    ignoreSilenced  = true,         -- a suppressed weapon does not raise a call
    ignoreInVehicle = false,        -- true = drive-by shots are ignored
    cooldownMs      = 30000,        -- one call per shooter per 30 s (enforced client AND server side)
    mergeRadius     = 75.0,         -- metres: gunfire near a Shots Fired call opened less than
    mergeSeconds    = 120,          --   mergeSeconds ago joins that call instead of opening a new one
                                    --   (a 5-player shootout = 1 call). 0 = always open a new call.
    anonymousCaller = true,         -- the CAD shows "Anonymous" as caller instead of the shooter's name
    discord         = false,        -- true = also push each automatic 10-71 to the 'panic' Discord webhook
    -- Weapons that never raise a call (tools / non-lethal / toys).
    ignoreWeapons = {
        'WEAPON_UNARMED', 'WEAPON_STUNGUN', 'WEAPON_STUNGUN_MP', 'WEAPON_FIREEXTINGUISHER',
        'WEAPON_PETROLCAN', 'WEAPON_HAZARDCAN', 'WEAPON_FERTILIZERCAN', 'WEAPON_FLARE',
        'WEAPON_FLAREGUN', 'WEAPON_SNOWBALL', 'WEAPON_BALL', 'WEAPON_METALDETECTOR',
    },
}

-- ═══════════════════════════════════════════════════════════
-- JOBS  (which job → which mode + department identity)
-- ═══════════════════════════════════════════════════════════
-- mode      : 'police' | 'ems'  → decides which tablet UI loads.
-- dispatch  : true  → this job receives that mode's 911/112 calls.
-- label/short: shown in the device header + roster.
-- color     : department accent (used if enableThemePerDept).
Config.jobs = {
    -- ── Police-side ──
    police  = { mode = 'police', label = 'Los Santos Police Dept.', short = 'LSPD', dispatch = true, color = '#1F5EFF' },
    sheriff = { mode = 'police', label = 'Blaine County Sheriff',    short = 'BCSO', dispatch = true, color = '#E5A93C' },
    fib     = { mode = 'police', label = 'F.I.B.',                   short = 'FIB',  dispatch = true, color = '#34C77B' },
    sast    = { mode = 'police', label = 'State Police',             short = 'SAST', dispatch = true, color = '#A78BFA' },

    -- ── EMS-side ──
    ambulance = { mode = 'ems', label = 'Pillbox Medical Center',   short = 'EMS',  dispatch = true, color = '#E5564B' },
    doctor    = { mode = 'ems', label = 'Central Hospital',         short = 'MD',   dispatch = true, color = '#06B6D4' },
    ems       = { mode = 'ems', label = 'Emergency Services',       short = 'EMS',  dispatch = true, color = '#E5564B' },
}

-- ═══════════════════════════════════════════════════════════
-- RANKS  (job grade → rank label + supervisor privileges)
-- ═══════════════════════════════════════════════════════════
-- supervisor = can approve warrants/reports, post bulletins, manage
-- the roster (hire/fire/promote), delete others' records.
Config.ranks = {
    -- ── Police ──
    police = {
        [0] = { label = 'Cadet',          supervisor = false },
        [1] = { label = 'Officer',        supervisor = false },
        [2] = { label = 'Senior Officer', supervisor = false },
        [3] = { label = 'Sergeant',       supervisor = true  },
        [4] = { label = 'Lieutenant',     supervisor = true  },
        [5] = { label = 'Captain',        supervisor = true  },
        [6] = { label = 'Chief of Police', supervisor = true },
    },
    sheriff = {
        [0] = { label = 'Deputy',         supervisor = false },
        [1] = { label = 'Senior Deputy',  supervisor = false },
        [2] = { label = 'Corporal',       supervisor = false },
        [3] = { label = 'Sergeant',       supervisor = true  },
        [4] = { label = 'Undersheriff',   supervisor = true  },
        [5] = { label = 'Sheriff',        supervisor = true  },
    },
    fib = {
        [0] = { label = 'Agent',          supervisor = false },
        [1] = { label = 'Senior Agent',   supervisor = false },
        [2] = { label = 'Supervisory Agent', supervisor = true },
        [3] = { label = 'Director',       supervisor = true  },
    },
    sast = {
        [0] = { label = 'Trooper',        supervisor = false },
        [1] = { label = 'Senior Trooper', supervisor = false },
        [2] = { label = 'Sergeant',       supervisor = true  },
        [3] = { label = 'Commander',      supervisor = true  },
    },
    -- ── EMS ──
    ambulance = {
        [0] = { label = 'Trainee',        supervisor = false },
        [1] = { label = 'Paramedic',      supervisor = false },
        [2] = { label = 'Nurse',          supervisor = false },
        [3] = { label = 'Doctor',         supervisor = true  },
        [4] = { label = 'Surgeon',        supervisor = true  },
        [5] = { label = 'Chief of Medicine', supervisor = true },
    },
    doctor = {
        [0] = { label = 'Intern',         supervisor = false },
        [1] = { label = 'Resident',       supervisor = false },
        [2] = { label = 'Attending',      supervisor = true  },
        [3] = { label = 'Department Head', supervisor = true },
        [4] = { label = 'Medical Director', supervisor = true },
    },
    ems = {
        [0] = { label = 'Trainee',        supervisor = false },
        [1] = { label = 'Paramedic',      supervisor = false },
        [2] = { label = 'Senior Paramedic', supervisor = false },
        [3] = { label = 'Supervisor',     supervisor = true  },
        [4] = { label = 'Director',       supervisor = true  },
    },
}

-- ─── Sub-departments / divisions (UI filter + per-dept perms) ──
-- Optional tags an officer/medic can belong to (set in-panel by a
-- supervisor). Purely organisational + filterable in the roster.
Config.divisions = {
    police = { 'Patrol', 'Traffic', 'SWAT', 'Detectives', 'K-9', 'Air Support', 'Internal Affairs' },
    ems    = { 'Emergency', 'Paramedics', 'Surgery', 'Psychiatry', 'Pharmacy', 'Forensics', 'Rehab', 'Administration' },
}

-- ─── Callsign ─────────────────────────────────────────────
Config.callsign = {
    autoGenerate = true,
    prefixByJob  = {
        police = '1-ADAM', sheriff = '2-LINCOLN', fib = '3-FOX', sast = '4-TANGO',
        ambulance = 'M', doctor = 'D', ems = 'M',
    },
}

-- ═══════════════════════════════════════════════════════════
-- STATUS BOARD  (10-codes per mode)
-- ═══════════════════════════════════════════════════════════
-- available = true → free to be assigned to calls.
Config.statuses = {
    police = {
        { code = '10-8',  label = 'Available',     color = '#34C77B', available = true  },
        { code = '10-6',  label = 'Busy',          color = '#E5A93C', available = false },
        { code = '10-7',  label = 'Out of Service', color = '#7C7C82', available = false },
        { code = '10-23', label = 'On Scene',      color = '#1F5EFF', available = false },
        { code = '10-15', label = 'Transporting',  color = '#A78BFA', available = false },
        { code = '10-11', label = 'Traffic Stop',  color = '#06B6D4', available = false },
        { code = 'Code 5', label = 'Stakeout',     color = '#565659', available = false },
        { code = 'PANIC', label = 'Officer Down!', color = '#E5564B', available = false },
    },
    ems = {
        { code = '10-8',  label = 'Available',     color = '#34C77B', available = true  },
        { code = 'En Route', label = 'En Route',   color = '#06B6D4', available = false },
        { code = 'On Scene', label = 'On Scene',   color = '#1F5EFF', available = false },
        { code = 'Transport', label = 'Transporting', color = '#A78BFA', available = false },
        { code = 'At Hosp.', label = 'At Hospital', color = '#E5A93C', available = false },
        { code = '10-7',  label = 'Out of Service', color = '#7C7C82', available = false },
        { code = 'PANIC', label = 'EMS in Danger!', color = '#E5564B', available = false },
    },
}
Config.defaultStatus = '10-8'

-- ═══════════════════════════════════════════════════════════
-- DISPATCH CALL TYPES  (per mode - used for CAD + map blips)
-- ═══════════════════════════════════════════════════════════
Config.callTypes = {
    police = {
        { id = 'shots',      label = 'Shots Fired',          code = '10-71', priority = 'critical', icon = 'fa-gun',           color = '#E5564B' },
        { id = 'robbery',    label = 'Robbery in Progress',  code = '10-90', priority = 'high',     icon = 'fa-mask',          color = '#F97316' },
        { id = 'assault',    label = 'Assault',              code = '10-16', priority = 'high',     icon = 'fa-hand-fist',     color = '#F97316' },
        { id = 'pursuit',    label = 'Vehicle Pursuit',      code = '10-80', priority = 'critical', icon = 'fa-car-burst',     color = '#E5564B' },
        { id = 'traffic',    label = 'Traffic Incident',     code = '10-50', priority = 'medium',   icon = 'fa-car-side',      color = '#E5A93C' },
        { id = 'theft',      label = 'Theft',                code = '10-68', priority = 'medium',   icon = 'fa-box-open',      color = '#E5A93C' },
        { id = 'disturbance', label = 'Disturbance',         code = '10-66', priority = 'low',      icon = 'fa-volume-high',   color = '#34C77B' },
        { id = 'suspicious', label = 'Suspicious Activity',  code = '10-66', priority = 'low',      icon = 'fa-user-secret',   color = '#34C77B' },
        { id = 'backup',     label = 'Officer Needs Backup', code = '10-78', priority = 'critical', icon = 'fa-tower-broadcast', color = '#E5564B' },
        { id = 'panic',      label = 'OFFICER DOWN',         code = '10-99', priority = 'critical', icon = 'fa-tower-cell',    color = '#E5564B' },
    },
    ems = {
        { id = 'cardiac',    label = 'Cardiac Arrest',       code = 'Code Blue', priority = 'critical', icon = 'fa-heart-pulse',  color = '#E5564B' },
        { id = 'trauma',     label = 'Major Trauma',         code = 'Code Red',  priority = 'critical', icon = 'fa-truck-medical', color = '#E5564B' },
        { id = 'gsw',        label = 'Gunshot Wound',        code = 'Code Red',  priority = 'critical', icon = 'fa-droplet',      color = '#E5564B' },
        { id = 'mva',        label = 'Vehicle Accident',     code = '10-50',     priority = 'high',     icon = 'fa-car-burst',    color = '#F97316' },
        { id = 'overdose',   label = 'Overdose',             code = 'Code Red',  priority = 'high',     icon = 'fa-pills',        color = '#F97316' },
        { id = 'unconscious', label = 'Unconscious Person',  code = 'Code Yellow', priority = 'high',   icon = 'fa-bed-pulse',    color = '#F97316' },
        { id = 'fall',       label = 'Fall / Injury',        code = 'Code Yellow', priority = 'medium', icon = 'fa-person-falling', color = '#E5A93C' },
        { id = 'medical',    label = 'Medical Emergency',    code = 'Code Yellow', priority = 'medium', icon = 'fa-kit-medical',  color = '#E5A93C' },
        { id = 'psych',      label = 'Mental Health',        code = 'Code Green',  priority = 'medium', icon = 'fa-brain',        color = '#A78BFA' },
        { id = 'transfer',   label = 'Patient Transfer',     code = '10-15',     priority = 'low',      icon = 'fa-truck-arrow-right', color = '#34C77B' },
        { id = 'panic',      label = 'EMS IN DANGER',        code = 'Mayday',    priority = 'critical', icon = 'fa-tower-cell',   color = '#E5564B' },
    },
}

-- ─── Priority colour scale (shared by calls + BOLOs) ──────
Config.priorities = {
    { id = 'low',      label = 'Low',      color = '#34C77B' },
    { id = 'medium',   label = 'Medium',   color = '#E5A93C' },
    { id = 'high',     label = 'High',     color = '#F97316' },
    { id = 'critical', label = 'Critical', color = '#E5564B' },
}

-- ═══════════════════════════════════════════════════════════
-- POLICE - PENAL CODE
-- ═══════════════════════════════════════════════════════════
-- type: 'felony' | 'misdemeanor' | 'infraction'
--   fine  = recommended fine ($) · jail = months (0 = none) · points = licence points
Config.penalCode = {
    -- ── Title 1 · Crimes Against Persons ───────────────────
    { id = 'P101', title = 'Crimes Against Persons', label = 'Murder (1st Degree)',          type = 'felony',      fine = 50000, jail = 999, points = 0, desc = 'Premeditated unlawful killing of another person.' },
    { id = 'P102', title = 'Crimes Against Persons', label = 'Manslaughter',                 type = 'felony',      fine = 30000, jail = 120, points = 0, desc = 'Unlawful killing without premeditation.' },
    { id = 'P103', title = 'Crimes Against Persons', label = 'Attempted Murder',             type = 'felony',      fine = 35000, jail = 150, points = 0, desc = 'Attempt to unlawfully kill another person.' },
    { id = 'P104', title = 'Crimes Against Persons', label = 'Assault with a Deadly Weapon', type = 'felony',      fine = 12000, jail = 45,  points = 0, desc = 'Assault using a weapon capable of lethal harm.' },
    { id = 'P105', title = 'Crimes Against Persons', label = 'Assault & Battery',            type = 'misdemeanor', fine = 3500,  jail = 10,  points = 0, desc = 'Intentional physical harm or threat thereof.' },
    { id = 'P106', title = 'Crimes Against Persons', label = 'Kidnapping',                   type = 'felony',      fine = 25000, jail = 90,  points = 0, desc = 'Unlawful seizure and detention of a person.' },
    { id = 'P107', title = 'Crimes Against Persons', label = 'Assault on a Peace Officer',   type = 'felony',      fine = 15000, jail = 60,  points = 0, desc = 'Assault committed against an on-duty officer.' },
    { id = 'P108', title = 'Crimes Against Persons', label = 'Hostage Taking',               type = 'felony',      fine = 40000, jail = 200, points = 0, desc = 'Holding a person hostage to compel action.' },

    -- ── Title 2 · Property Crimes ──────────────────────────
    { id = 'P201', title = 'Property Crimes', label = 'Grand Theft Auto',           type = 'felony',      fine = 10000, jail = 35, points = 0, desc = 'Theft of a motor vehicle.' },
    { id = 'P202', title = 'Property Crimes', label = 'Armed Robbery',              type = 'felony',      fine = 20000, jail = 70, points = 0, desc = 'Robbery committed with a deadly weapon.' },
    { id = 'P203', title = 'Property Crimes', label = 'Burglary',                   type = 'felony',      fine = 8000,  jail = 30, points = 0, desc = 'Unlawful entry with intent to commit a crime.' },
    { id = 'P204', title = 'Property Crimes', label = 'Petty Theft',                type = 'misdemeanor', fine = 1500,  jail = 5,  points = 0, desc = 'Theft of property under a minor value threshold.' },
    { id = 'P205', title = 'Property Crimes', label = 'Vandalism',                  type = 'misdemeanor', fine = 2000,  jail = 4,  points = 0, desc = 'Willful destruction of property.' },
    { id = 'P206', title = 'Property Crimes', label = 'Arson',                      type = 'felony',      fine = 22000, jail = 80, points = 0, desc = 'Deliberately setting fire to property.' },
    { id = 'P207', title = 'Property Crimes', label = 'Trespassing',                type = 'infraction',  fine = 750,   jail = 0,  points = 0, desc = 'Unlawful presence on private property.' },
    { id = 'P208', title = 'Property Crimes', label = 'Possession of Stolen Goods', type = 'misdemeanor', fine = 4000,  jail = 12, points = 0, desc = 'Knowingly possessing stolen property.' },

    -- ── Title 3 · Traffic Offenses ─────────────────────────
    { id = 'P301', title = 'Traffic Offenses', label = 'Reckless Driving',        type = 'misdemeanor', fine = 1200, jail = 2, points = 4, desc = 'Operating a vehicle with willful disregard for safety.' },
    { id = 'P302', title = 'Traffic Offenses', label = 'Speeding (1-15 over)',    type = 'infraction',  fine = 350,  jail = 0, points = 1, desc = 'Exceeding the posted limit by up to 15 mph.' },
    { id = 'P303', title = 'Traffic Offenses', label = 'Speeding (16-30 over)',   type = 'infraction',  fine = 650,  jail = 0, points = 2, desc = 'Exceeding the posted limit by 16-30 mph.' },
    { id = 'P304', title = 'Traffic Offenses', label = 'Speeding (31+ over)',     type = 'misdemeanor', fine = 1100, jail = 1, points = 3, desc = 'Exceeding the posted limit by 31+ mph.' },
    { id = 'P305', title = 'Traffic Offenses', label = 'Driving Under Influence', type = 'misdemeanor', fine = 5000, jail = 15, points = 6, desc = 'Operating a vehicle while intoxicated.' },
    { id = 'P306', title = 'Traffic Offenses', label = 'Driving w/o a License',   type = 'infraction',  fine = 900,  jail = 0, points = 2, desc = 'Operating a vehicle without a valid license.' },
    { id = 'P307', title = 'Traffic Offenses', label = 'Evading a Peace Officer', type = 'felony',      fine = 9000, jail = 25, points = 6, desc = 'Fleeing from law enforcement in a vehicle.' },
    { id = 'P308', title = 'Traffic Offenses', label = 'Illegal Parking',         type = 'infraction',  fine = 250,  jail = 0, points = 0, desc = 'Parking in violation of posted restrictions.' },

    -- ── Title 4 · Drug Offenses ────────────────────────────
    { id = 'P401', title = 'Drug Offenses', label = 'Possession (Personal)',        type = 'misdemeanor', fine = 2500,  jail = 8,   points = 0, desc = 'Possession of a controlled substance.' },
    { id = 'P402', title = 'Drug Offenses', label = 'Possession w/ Intent to Sell', type = 'felony',      fine = 15000, jail = 50,  points = 0, desc = 'Possession of drugs intended for distribution.' },
    { id = 'P403', title = 'Drug Offenses', label = 'Drug Trafficking',             type = 'felony',      fine = 35000, jail = 120, points = 0, desc = 'Large-scale transport or sale of narcotics.' },
    { id = 'P404', title = 'Drug Offenses', label = 'Operating a Drug Lab',         type = 'felony',      fine = 28000, jail = 100, points = 0, desc = 'Manufacturing controlled substances.' },

    -- ── Title 5 · Weapons Offenses ─────────────────────────
    { id = 'P501', title = 'Weapons Offenses', label = 'Possession of Illegal Firearm', type = 'felony',      fine = 12000, jail = 40,  points = 0, desc = 'Possessing an unregistered or prohibited weapon.' },
    { id = 'P502', title = 'Weapons Offenses', label = 'Brandishing a Weapon',          type = 'misdemeanor', fine = 4000,  jail = 12,  points = 0, desc = 'Displaying a weapon in a threatening manner.' },
    { id = 'P503', title = 'Weapons Offenses', label = 'Discharge of a Firearm',        type = 'felony',      fine = 9000,  jail = 30,  points = 0, desc = 'Unlawfully firing a weapon in public.' },
    { id = 'P504', title = 'Weapons Offenses', label = 'Weapons Trafficking',           type = 'felony',      fine = 40000, jail = 150, points = 0, desc = 'Sale or transport of illegal firearms.' },

    -- ── Title 6 · Public Order ─────────────────────────────
    { id = 'P601', title = 'Public Order', label = 'Disorderly Conduct',       type = 'infraction',  fine = 500,   jail = 0,  points = 0, desc = 'Disruptive or offensive public behaviour.' },
    { id = 'P602', title = 'Public Order', label = 'Resisting Arrest',         type = 'misdemeanor', fine = 3000,  jail = 10, points = 0, desc = 'Obstructing a lawful arrest.' },
    { id = 'P603', title = 'Public Order', label = 'Obstruction of Justice',   type = 'misdemeanor', fine = 5000,  jail = 18, points = 0, desc = 'Interfering with an investigation or officer.' },
    { id = 'P604', title = 'Public Order', label = 'Bribery of an Official',   type = 'felony',      fine = 18000, jail = 45, points = 0, desc = 'Offering value to corrupt a public official.' },
    { id = 'P605', title = 'Public Order', label = 'Impersonating an Officer', type = 'felony',      fine = 10000, jail = 30, points = 0, desc = 'Falsely representing oneself as law enforcement.' },
    { id = 'P606', title = 'Public Order', label = 'Public Intoxication',      type = 'infraction',  fine = 400,   jail = 0,  points = 0, desc = 'Being intoxicated in a public place.' },
    { id = 'P607', title = 'Public Order', label = 'Failure to Comply',        type = 'misdemeanor', fine = 2500,  jail = 6,  points = 0, desc = 'Refusing lawful orders from an officer.' },
}

-- ─── Booking / sentence calculator ────────────────────────
-- Conversion used by the charge builder to turn months into an
-- in-game jail time. monthsToSeconds = real prison time per "month".
Config.booking = {
    monthsToSeconds = 30,   -- 1 "month" of sentence = 30s of in-game jail (tune to your jail script)
    maxJailSeconds  = 3600, -- hard cap regardless of charges
    sendInvoice     = true, -- generate a fine invoice to the citizen on booking
}

-- ═══════════════════════════════════════════════════════════
-- POLICE - citizen flags, BOLO, report types
-- ═══════════════════════════════════════════════════════════
Config.flags = {
    { id = 'armed',     label = 'Armed & Dangerous',      icon = 'fa-gun',                     color = '#E5564B', mode = 'police' },
    { id = 'violent',   label = 'Violent Offender',       icon = 'fa-hand-fist',               color = '#E5564B', mode = 'police' },
    { id = 'flight',    label = 'Flight Risk',            icon = 'fa-person-running',          color = '#E5A93C', mode = 'police' },
    { id = 'gang',      label = 'Gang Affiliation',       icon = 'fa-users',                   color = '#EC4899', mode = 'police' },
    { id = 'warrant',   label = 'Active Warrant',         icon = 'fa-file-circle-exclamation', color = '#E5564B', mode = 'police' },
    { id = 'informant', label = 'Confidential Informant', icon = 'fa-user-secret',             color = '#34C77B', mode = 'police' },
    -- Medical flags (EMS mode) - shareable to PD when enableDataSharing.
    { id = 'mental',    label = 'Mental Health',          icon = 'fa-brain',                   color = '#A78BFA', mode = 'both',  shareToPolice = true },
    { id = 'allergy',   label = 'Severe Allergy',         icon = 'fa-hand-dots',               color = '#F97316', mode = 'ems' },
    { id = 'diabetic',  label = 'Diabetic',               icon = 'fa-syringe',                 color = '#06B6D4', mode = 'ems' },
    { id = 'cardiac',   label = 'Cardiac Risk',           icon = 'fa-heart-pulse',             color = '#E5564B', mode = 'ems' },
    { id = 'contagious', label = 'Contagious',            icon = 'fa-virus-covid',             color = '#EC4899', mode = 'ems',   shareToPolice = true },
}

Config.boloTypes   = { 'person', 'vehicle' }
Config.reportTypes = {
    -- mode 'police'
    { id = 'incident',      label = 'Incident Report',  icon = 'fa-file-lines',        mode = 'police' },
    { id = 'arrest',        label = 'Arrest Report',    icon = 'fa-handcuffs',         mode = 'police' },
    { id = 'investigation', label = 'Investigation',    icon = 'fa-magnifying-glass',  mode = 'police' },
    { id = 'use_of_force',  label = 'Use of Force',     icon = 'fa-shield-halved',     mode = 'police' },
    { id = 'field',         label = 'Field Interview',  icon = 'fa-clipboard-user',    mode = 'police' },
    -- mode 'ems'
    { id = 'medical',       label = 'Medical Report',   icon = 'fa-notes-medical',     mode = 'ems' },
    { id = 'discharge',     label = 'Discharge Summary', icon = 'fa-file-medical',     mode = 'ems' },
    { id = 'certificate',   label = 'Medical Certificate', icon = 'fa-file-signature', mode = 'ems' },
    { id = 'death_cert',    label = 'Death Certificate', icon = 'fa-file-circle-xmark', mode = 'ems' },
}

-- ─── Evidence types (police evidence locker) ──────────────
Config.evidenceTypes = {
    { id = 'physical', label = 'Physical', icon = 'fa-box' },
    { id = 'weapon',   label = 'Weapon',   icon = 'fa-gun' },
    { id = 'drug',     label = 'Narcotics', icon = 'fa-pills' },
    { id = 'document', label = 'Document', icon = 'fa-file' },
    { id = 'digital',  label = 'Digital',  icon = 'fa-microchip' },
    { id = 'dna',      label = 'DNA',      icon = 'fa-dna' },
    { id = 'ballistic', label = 'Ballistic', icon = 'fa-crosshairs' },
    { id = 'print',    label = 'Fingerprint', icon = 'fa-fingerprint' },
}

-- ═══════════════════════════════════════════════════════════
-- EMS - clinical data
-- ═══════════════════════════════════════════════════════════
-- Triage colour scale (most → least urgent).
Config.triage = {
    { id = 'red',    label = 'Immediate',  color = '#E5564B', desc = 'Life-threatening - treat now.' },
    { id = 'orange', label = 'Very Urgent', color = '#F97316', desc = 'Serious - within 10 minutes.' },
    { id = 'yellow', label = 'Urgent',     color = '#E5A93C', desc = 'Stable but needs care soon.' },
    { id = 'green',  label = 'Standard',   color = '#34C77B', desc = 'Minor - can wait.' },
    { id = 'black',  label = 'Deceased',   color = '#565659', desc = 'No signs of life.' },
}

-- Vital signs the triage form records, with healthy ranges (for the
-- NUI to colour out-of-range readings red).
Config.vitals = {
    { id = 'pulse', label = 'Pulse',        unit = 'bpm',  min = 60,  max = 100 },
    { id = 'bp',    label = 'Blood Pressure', unit = 'mmHg', text = true },        -- free text e.g. 120/80
    { id = 'spo2',  label = 'SpO₂',         unit = '%',    min = 95,  max = 100 },
    { id = 'temp',  label = 'Temperature',  unit = '°C',   min = 36.1, max = 37.5 },
    { id = 'resp',  label = 'Respiration',  unit = '/min', min = 12,  max = 20 },
    { id = 'gluc',  label = 'Glucose',      unit = 'mg/dL', min = 70,  max = 140 },
}

-- Searchable diagnosis / injury list (grouped by category).
Config.diagnoses = {
    { id = 'D101', cat = 'Trauma',      label = 'Gunshot Wound',           severity = 'critical' },
    { id = 'D102', cat = 'Trauma',      label = 'Stab Wound',              severity = 'high' },
    { id = 'D103', cat = 'Trauma',      label = 'Blunt Force Trauma',      severity = 'high' },
    { id = 'D104', cat = 'Trauma',      label = 'Fracture (Limb)',         severity = 'medium' },
    { id = 'D105', cat = 'Trauma',      label = 'Concussion',              severity = 'medium' },
    { id = 'D106', cat = 'Trauma',      label = 'Laceration',              severity = 'low' },
    { id = 'D107', cat = 'Trauma',      label = 'Burn (2nd/3rd Degree)',   severity = 'high' },
    { id = 'D201', cat = 'Cardiac',     label = 'Cardiac Arrest',          severity = 'critical' },
    { id = 'D202', cat = 'Cardiac',     label = 'Myocardial Infarction',   severity = 'critical' },
    { id = 'D203', cat = 'Cardiac',     label = 'Arrhythmia',              severity = 'medium' },
    { id = 'D301', cat = 'Respiratory', label = 'Respiratory Failure',     severity = 'critical' },
    { id = 'D302', cat = 'Respiratory', label = 'Asthma Attack',           severity = 'medium' },
    { id = 'D401', cat = 'Toxicology',  label = 'Drug Overdose',           severity = 'critical' },
    { id = 'D402', cat = 'Toxicology',  label = 'Alcohol Poisoning',       severity = 'high' },
    { id = 'D403', cat = 'Toxicology',  label = 'Severe Allergic Reaction', severity = 'high' },
    { id = 'D501', cat = 'Neurological', label = 'Stroke',                 severity = 'critical' },
    { id = 'D502', cat = 'Neurological', label = 'Seizure',                severity = 'high' },
    { id = 'D601', cat = 'Mental Health', label = 'Acute Psychosis',       severity = 'high' },
    { id = 'D602', cat = 'Mental Health', label = 'Suicidal Ideation',     severity = 'high' },
    { id = 'D701', cat = 'General',     label = 'Dehydration',             severity = 'low' },
    { id = 'D702', cat = 'General',     label = 'Hypothermia',             severity = 'medium' },
    { id = 'D703', cat = 'General',     label = 'Unconsciousness (Unknown)', severity = 'high' },
}

-- Hospital wards & beds (admissions / bed manager).
Config.wards = {
    { id = 'er',      label = 'Emergency',  beds = 8,  color = '#E5564B' },
    { id = 'icu',     label = 'Intensive Care', beds = 4, color = '#F97316' },
    { id = 'surgery', label = 'Surgery',    beds = 3,  color = '#A78BFA' },
    { id = 'general', label = 'General',    beds = 12, color = '#34C77B' },
    { id = 'psych',   label = 'Psychiatry', beds = 6,  color = '#06B6D4' },
    { id = 'recovery', label = 'Recovery',  beds = 8,  color = '#5C7AFF' },
}

-- Pharmacy stock (dispense ties to a prescription).
Config.medications = {
    { id = 'morphine',     label = 'Morphine',        stock = 40,  controlled = true  },
    { id = 'epinephrine',  label = 'Epinephrine',     stock = 60,  controlled = true  },
    { id = 'ibuprofen',    label = 'Ibuprofen',       stock = 200, controlled = false },
    { id = 'paracetamol',  label = 'Paracetamol',     stock = 200, controlled = false },
    { id = 'antibiotics',  label = 'Antibiotics',     stock = 120, controlled = false },
    { id = 'insulin',      label = 'Insulin',         stock = 80,  controlled = true  },
    { id = 'naloxone',     label = 'Naloxone',        stock = 50,  controlled = true  },
    { id = 'sedative',     label = 'Sedative',        stock = 45,  controlled = true  },
    { id = 'antihistamine', label = 'Antihistamine',  stock = 150, controlled = false },
}

-- Surgery catalogue (scheduling).
Config.surgeries = {
    { id = 'appendectomy', label = 'Appendectomy',         minutes = 45 },
    { id = 'bullet',       label = 'Bullet Extraction',    minutes = 60 },
    { id = 'cardiac',      label = 'Cardiac Surgery',      minutes = 180 },
    { id = 'orthopedic',   label = 'Orthopedic Repair',    minutes = 120 },
    { id = 'neuro',        label = 'Neurosurgery',         minutes = 240 },
    { id = 'cosmetic',     label = 'Reconstructive',       minutes = 90 },
}

-- ─── Blood types (blood bank scaffold) ────────────────────
Config.bloodTypes = { 'O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+' }

-- ═══════════════════════════════════════════════════════════
-- BILLING  (EMS invoices + police fines share this table)
-- ═══════════════════════════════════════════════════════════
Config.billing = {
    ems = {
        { id = 'consult',   label = 'Consultation',       amount = 250 },
        { id = 'er',        label = 'ER Admission',       amount = 1500 },
        { id = 'treatment', label = 'Field Treatment',    amount = 750 },
        { id = 'transport', label = 'Ambulance Transport', amount = 1200 },
        { id = 'surgery',   label = 'Surgery',            amount = 5000 },
        { id = 'medication', label = 'Medication',        amount = 300 },
        { id = 'bed_day',   label = 'Hospital Stay (day)', amount = 800 },
    },
    insuranceCoverPct = 0.6,  -- when a patient has insurance, this fraction is covered
}

-- ═══════════════════════════════════════════════════════════
-- LIVE MAP  (apex_bossmenu method - Leaflet + gtamap.xyz tiles)
-- ═══════════════════════════════════════════════════════════
-- These exact values are passed to the NUI and used to build the
-- Leaflet map the same way apex_bossmenu does (CRS.Simple +
-- L.Transformation). Markers are plotted at [coords.y, coords.x].
Config.map = {
    tileUrl   = 'https://www.gtamap.xyz/mapStyles/styleAtlas/{z}/{x}/{y}.jpg',
    minZoom   = 2,
    maxZoom   = 5,
    zoom      = 3,
    -- CRS.Simple transformation (scaleX, centerX, -scaleY, centerY)
    transform = { scaleX = 0.02072, centerX = 117.3, scaleY = 0.0205, centerY = 172.8 },
    maxBounds = { { 8000.0, -5500.0 }, { -8000.0, 5500.0 } },
    streamIntervalMs = 3000,   -- how often on-duty units push their position
    -- Where the map centres when opened (downtown / Mission Row by default)
    defaultCenter = { x = 425.0, y = -980.0 },
    defaultZoom   = 4,
}

-- ─── Stations / hospitals (blips + duty markers) ──────────
-- mode tags which department the location belongs to.
Config.stations = {
    { mode = 'police', label = 'Mission Row PD',         coords = vec3(428.23, -984.31, 30.71), duty = vec3(441.4, -982.4, 30.68), blip = { sprite = 60,  color = 29, scale = 0.9  } },
    { mode = 'police', label = 'Sandy Shores Sheriff',   coords = vec3(1853.1, 3686.5, 34.27),  duty = vec3(1853.1, 3689.5, 34.27), blip = { sprite = 60,  color = 29, scale = 0.85 } },
    { mode = 'police', label = 'Paleto Bay Sheriff',     coords = vec3(-448.6, 6012.6, 31.72),  duty = vec3(-448.6, 6008.6, 31.72), blip = { sprite = 60,  color = 29, scale = 0.85 } },
    { mode = 'ems',    label = 'Pillbox Medical Center', coords = vec3(307.7, -595.0, 43.28),   duty = vec3(311.2, -595.0, 43.28),  blip = { sprite = 61,  color = 1,  scale = 0.9  } },
    { mode = 'ems',    label = 'Sandy Shores Medical',   coords = vec3(1839.6, 3672.9, 34.28),  duty = vec3(1833.0, 3673.0, 34.28), blip = { sprite = 61,  color = 1,  scale = 0.85 } },
}

-- ═══════════════════════════════════════════════════════════
-- DISCORD WEBHOOKS  (push high-signal events; honoured only if
-- features.enableDiscordWebhooks)
-- ═══════════════════════════════════════════════════════════
Config.discord = {
    username  = 'Apex MDT',
    avatar    = '',
    webhooks  = {
        warrants = '',   -- new active warrant
        bolos    = '',   -- high/critical BOLO posted
        panic    = '',   -- panic button
        deaths   = '',   -- death certificate / morgue
        audit    = '',   -- full audit feed (optional, noisy)
    },
}

-- ═══════════════════════════════════════════════════════════
-- CCTV  (self-contained - viewed inside the tablet)
-- ═══════════════════════════════════════════════════════════
-- A scripted camera is created at each location; you rotate/zoom it and
-- watch through the tablet "screen" overlay (security timecycle, REC HUD).
-- `mode`: 'police' | 'ems' | 'both' - which department can view it.
Config.cctv = {
    enabled    = true,
    timecycle  = 'CAMERA_secuirity',   -- security-cam colour grade ('' to disable)
    rotateSpeed = 1.4,
    cameras = {
        -- ── Police ──
        { id = 'msr_lobby',   mode = 'police', label = 'Mission Row · Lobby',   coords = vec3(441.0, -981.0, 30.7),  heading = 180.0, pitch = -12.0 },
        { id = 'msr_cells',   mode = 'police', label = 'Mission Row · Cells',   coords = vec3(461.5, -998.2, 30.7),  heading = 90.0,  pitch = -14.0 },
        { id = 'msr_garage',  mode = 'police', label = 'Mission Row · Garage',  coords = vec3(454.0, -1017.0, 28.4), heading = 0.0,   pitch = -10.0 },
        { id = 'msr_front',   mode = 'police', label = 'Mission Row · Entrance', coords = vec3(434.0, -979.0, 30.7),  heading = 250.0, pitch = -8.0 },
        -- ── EMS ──
        { id = 'pb_er',       mode = 'ems',    label = 'Pillbox · ER',          coords = vec3(307.0, -595.0, 43.3),  heading = 70.0,  pitch = -12.0 },
        { id = 'pb_entrance', mode = 'ems',    label = 'Pillbox · Entrance',    coords = vec3(298.0, -583.0, 43.3),  heading = 200.0, pitch = -10.0 },
        { id = 'pb_parking',  mode = 'ems',    label = 'Pillbox · Ambulance Bay', coords = vec3(330.0, -580.0, 43.3), heading = 300.0, pitch = -10.0 },
    },
}

-- ═══════════════════════════════════════════════════════════
-- BODYCAM  (self-contained overlay, police)
-- ═══════════════════════════════════════════════════════════
Config.bodycam = {
    enabled  = true,
    autoOnDuty = false,   -- start recording automatically when going on duty
}

-- ─── UI Theme ─────────────────────────────────────────────
-- `brand` and `bg` are the two master colours; every surface/border is
-- DERIVED from `bg` at runtime, so changing `bg` retints the WHOLE tablet.
--
-- The tablet themes itself to match the wearer's job: the POLICE MDT and the
-- EMS / HOSPITAL MDT each get their own palette + identity (name, eyebrow,
-- icon). Edit `police` and `ems` independently below. Shared status colours
-- (success/warning/error) live at the top level. Players can still override
-- brand/bg per device in Settings.
-- Both MDTs share the EXACT apex_adminmenu palette (neutral near-black base
-- #0A0A0B with grey surfaces + the shared status colours below). Only the
-- ACCENT colour changes per mode: POLICE = tactical blue (graphite bg), HOSPITAL/EMS = medical red.
-- The mode `brand` drives the whole UI chrome (buttons, headers, active states,
-- lock badge) - Settings.applyServerTheme() shades it into the full --brand-* ramp.
-- Per-job `color` (Config.jobs) is only a department accent (--dept); shared
-- status/priority/triage/ward colours are GLOBAL and must never equal a mode brand.
Config.theme = {
    -- shared status colours + text (identical to apex_adminmenu)
    text      = '#F4F4F5',
    textSub   = 'rgba(244,244,245,.55)',
    info      = '#4E9CE5',
    success   = '#34C77B',
    warning   = '#E5A93C',
    error     = '#E5564B',

    -- POLICE - apex_adminmenu base, BLUE accent
    police = {
        brand     = '#1F5EFF',   -- blue accent (same as apex_adminmenu)
        brandDark = '#0048F0',
        bg        = '#0A0A0B',   -- apex_adminmenu neutral near-black
        name      = 'APEX MDT',  -- brand shown in the sidebar
        dept      = 'TACTICAL',  -- eyebrow / sub-label
        markIcon  = 'fa-shield-halved',
    },

    -- EMS / HOSPITAL - apex_adminmenu base, MEDICAL RED accent
    -- (emergency/medical red - the hospital identity; police stays blue)
    ems = {
        brand     = '#E5453E',   -- medical / emergency red
        brandDark = '#B5302B',
        bg        = '#0A0A0B',   -- same apex_adminmenu neutral near-black
        name      = 'APEX EMS',
        dept      = 'MEDICAL',
        markIcon  = 'fa-truck-medical',
    },
}

-- ─── Wallpaper (per-mode MDT background image) ────────────
-- Drop your generated images in html/img/ and point these at them
-- (relative to the NUI), or use a full https URL. Leave '' to use the
-- built-in tinted gradient. Shown faintly behind the UI so text stays
-- readable; tune the strength with `opacity`.
Config.wallpaper = {
    enable  = true,
    police  = 'img/police.png',      -- relative to html/ (or a full https URL)
    ems     = 'img/ambulance.png',
    opacity = 0.55,                  -- 0 = invisible, 1 = full image (UI cards stay opaque on top)
}

-- ─── User avatar (device chrome + records) ────────────────
Config.avatar = {
    enable     = true,
    useMugshot = true,                 -- live officer/medic headshot in the chrome
    mugshotUrl = nil,                  -- e.g. 'https://cdn.myserver.com/mugshots/%s.png'
    -- Default profile photo used in EVERY avatar slot when no photo was
    -- captured (relative to html/, or a full https URL).
    defaultUrl = 'img/perfil.png',
}

-- ─── Real in-game photo (account setup "Take Photo") ──────
-- Captures an actual screenshot of the player's face with a front
-- camera (requires the `screenshot-basic` resource), stores it as a
-- base64 data-URI in the DB and uses it as the profile photo. If
-- screenshot-basic is missing or this is disabled, it falls back to the
-- live ped headshot.
Config.photo = {
    enable    = true,
    -- 'camera'   → photo booth: orbit/zoom/height the camera yourself, then
    --              capture. Uses screenshot-basic for the framed base64 photo
    --              when present; otherwise falls back to the native headshot.
    -- 'headshot' → native ped headshot only (no positioning, no extra resource).
    method    = 'camera',
    resource  = 'screenshot-basic',  -- capture resource (method = 'camera')
    encoding  = 'jpg',     -- 'jpg' | 'png' | 'webp'   (screenshot method)
    quality   = 0.85,      -- 0..1 (jpg/webp)
    camDist   = 0.62,      -- metres in front of the face (screenshot method)
    camFov    = 28.0,      -- lower = tighter portrait
    settleMs  = 250,       -- wait after hiding the viewfinder, before the shutter
    hideHud   = true,      -- hide radar/HUD during the shot
    -- SAFETY NET. screenshot-basic answers in ~100 ms when it works, but on some
    -- builds/GPUs its NUI never answers at all - and the player would sit in the
    -- photo camera forever. After this many ms the booth closes itself and falls
    -- back to the native ped headshot. Never set this to 0.
    timeoutMs = 10000,
}

-- ─── Currency / formatting ────────────────────────────────
Config.currency   = { symbol = '£', position = 'before' }
Config.dateFormat = 'DD/MM/YYYY'       -- 'MM/DD/YYYY' | 'DD/MM/YYYY'
Config.use24h     = true              -- status-bar clock format

-- ─── Item image source (NUI) ──────────────────────────────
Config.itemImageBase = 'nui://ox_inventory/web/images/'

-- ─── Notifications ────────────────────────────────────────
Config.notify = { title = 'MDT', duration = 4500 }

-- ─── Fallback strings (mirror the locale keys) ────────────
Config.strings = {
    noAccess     = 'You are not authorised to use this tablet.',
    notOnDuty    = 'You must be on duty to open the tablet.',
    onDuty       = 'You are now ON DUTY.',
    offDuty      = 'You are now OFF DUTY.',
    saved        = 'Saved.',
    deleted      = 'Deleted.',
    noPermission = 'You do not have permission to do that.',
    callCreated  = 'Dispatch call created.',
    statusSet    = 'Status updated: %s',
    panic        = '%s - PANIC activated!',
    needsApproval = 'Submitted for supervisor approval.',
    approved      = 'Approved.',
}
