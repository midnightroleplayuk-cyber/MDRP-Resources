Config = {}

Config.Debug = false

-- 'auto' | 'qbx' | 'qb' | 'esx' | 'standalone'
-- Standalone uses ace permissions: add_ace group.police vinewood.dispatch.police allow
Config.Framework = 'qbx'

-- 'mi' or 'km'
Config.Units = 'mi'

---------------------------------------------------------------------
-- Callsigns
-- /callsign 1A-12   set your callsign (saved per character, remembered across restarts)
-- /callsign         open a box to change it
-- /callsign clear   remove it
---------------------------------------------------------------------
Config.Callsigns = {
    enabled = true,
    command = 'callsign',
    maxLength = 8,
    pattern = '^[%w%-]+$',      -- letters, numbers and dashes
    uppercase = true,
    unique = true,              -- two players online can't share a callsign
    restrictToServices = true,  -- only police / ambulance / fire jobs can set one
    syncMetadata = true,        -- also write to QB/Qbox metadata.callsign for other scripts
}

-- Fallbacks when a player hasn't set a callsign here: these exports (first non-empty wins),
-- then QB/Qbox metadata.callsign. Each export receives the player's source.
Config.CallsignExports = {
    { resource = 'vinewood-emsmdt', export = 'GetCallsign' },
}

---------------------------------------------------------------------
-- Services: which jobs receive which alerts
---------------------------------------------------------------------
Config.Services = {
    police = {
        label = 'Midnight Police Constabulary',
        colour = '#1b3f9a',           -- Battenburg colour on alert cards
        jobs = { 'police', 'sheriff', 'bcso', 'sasp' },
        requireDuty = true,
    },
    ambulance = {
        label = 'Midnight Health Service',
        colour = '#0b7a3e',
        jobs = { 'ambulance', 'ems', 'nbhs' },
        requireDuty = true,
    },
    fire = {
        label = 'Midnight Fire & Rescue',
        colour = '#b8141b',
        jobs = { 'fire', 'firefighter' },
        requireDuty = true,
    },
}

---------------------------------------------------------------------
-- Priorities (UK grading)
---------------------------------------------------------------------
Config.Priorities = {
    [1] = { label = 'Immediate', sound = { name = 'Lose_1st', set = 'GTAO_FM_Events_Soundset' } },
    [2] = { label = 'Priority',  sound = { name = 'Event_Message_Purple', set = 'GTAO_FM_Events_Soundset' } },
    [3] = { label = 'Routine',   sound = { name = 'Menu_Accept', set = 'Phone_SoundSet_Default' } },
}

---------------------------------------------------------------------
-- UI / timings
---------------------------------------------------------------------
Config.UI = {
    position = 'top-left',  -- top-right | top-left | bottom-right | bottom-left
    duration = 30,           -- seconds an alert stays on screen
    maxOnScreen = 4,
    -- grades that stay on screen until you attach, dismiss them or open the log (1 Immediate, 2 Priority, 3 Routine)
    stickyPriorities = { 1 },
    -- alerts that time out before you attach are counted as missed, with a reminder on screen until you open the log
    showMissed = true,
}

Config.BlipDuration = 300    -- seconds blips stay on the map
Config.AlertExpiry = 30      -- minutes alerts stay in the server log / history
Config.HistoryLimit = 50     -- alerts kept in the dispatch log

Config.Keys = {
    respond = 'G',           -- attach / detach from the latest alert (sets waypoint)
    history = 'F5',          -- open the dispatch log
    dismiss = 'DELETE',      -- clear the newest alert from the screen (it stays in the log)
    panic = '',              -- panic button, unbound by default
}

---------------------------------------------------------------------
-- Location
---------------------------------------------------------------------
Config.Location = {
    usePostals = true,
    postalResource = 'nearest-postal',  -- needs a client export getPostal()
}

---------------------------------------------------------------------
-- Security for alerts sent from client scripts
---------------------------------------------------------------------
Config.Security = {
    allowCustomFromClient = true,  -- allow client exports with no preset (title/services set by caller)
    maxClientDistance = 250.0,     -- alert coords must be this close to the sender
    clientCooldown = 5,            -- seconds between identical alerts from one player
    maxTitle = 64,
    maxDescription = 300,
}

---------------------------------------------------------------------
-- Player calls
---------------------------------------------------------------------
Config.Calls = {
    enabled = true,
    emergencyCommand = '999',   -- /999 [police|ambulance|fire] message
    nonEmergencyCommand = '101',-- /101 message (police)
    cooldown = 30,              -- seconds
    showCallerName = false,
    showCallerNumber = true,    -- QB/Qbox charinfo.phone where available
    requireItem = false,        -- e.g. 'phone' (checked through ox_inventory)
}

---------------------------------------------------------------------
-- Backup requests (on-duty only)
-- /backup            routine backup to your own service
-- /backup urgent     urgent assistance to your service and police
-- /backup firearms   armed response (police only)
---------------------------------------------------------------------
Config.Backup = {
    enabled = true,
    command = 'backup',
    trackUnit = true,  -- attaching routes you to the requesting unit's live blip
    types = {
        routine = { preset = 'backup_routine', label = 'Request routine backup', key = '' },
        urgent = { preset = 'backup_urgent', label = 'Request urgent assistance', key = '' },
        firearms = { preset = 'backup_firearms', label = 'Request firearms support', key = '' },
    },
}

---------------------------------------------------------------------
-- Live unit blips (needs OneSync)
---------------------------------------------------------------------
Config.LiveBlips = {
    enabled = true,
    interval = 2000,         -- ms between position updates
    showNames = true,        -- callsign (or name) on the blip
    shortRange = false,
    scale = 0.85,
    panicDuration = 60,      -- seconds a unit's blip flashes after their panic button
    flashWithLights = true,  -- blip flashes while blue lights are on
    panicColour = 1,

    -- which services each service can see
    visibility = {
        police = { 'police', 'ambulance', 'fire' },
        ambulance = { 'police', 'ambulance', 'fire' },
        fire = { 'police', 'ambulance', 'fire' },
    },

    colours = { police = 3, ambulance = 2, fire = 49 },

    -- by GetVehicleType()
    sprites = {
        foot = 1,
        automobile = 56,
        bike = 226,
        heli = 64,
        boat = 427,
        plane = 423,
        submarine = 308,
        trailer = 56,
        train = 56,
    },
}

---------------------------------------------------------------------
-- Call updates (notes on open calls)
-- /callupdate text      adds to the call you're attached to
-- /callupdate 12 text   adds to call #12
---------------------------------------------------------------------
Config.CallUpdates = {
    enabled = true,
    commands = { 'callupdate', 'cu' },
    maxNotes = 20,
    maxLength = 200,
    cooldown = 3,             -- seconds between updates per unit
    notifyAttached = false,    -- attached units get a notification for each update
}

---------------------------------------------------------------------
-- Built-in detections
---------------------------------------------------------------------
Config.Detections = {
    -- on-duty emergency services do not trigger crime detections
    ignoreOnDuty = true,

    shooting = {
        enabled = true,
        cooldown = 30,
        requireWitness = true,
        witnessRadius = 60.0,
        ignoreSilenced = true,
        ignoredWeapons = {
            'WEAPON_STUNGUN', 'WEAPON_STUNGUN_MP', 'WEAPON_FLAREGUN', 'WEAPON_FIREEXTINGUISHER',
            'WEAPON_PETROLCAN', 'WEAPON_SNOWBALL', 'WEAPON_BALL', 'WEAPON_FLARE',
        },
        ignoreZones = {
            { coords = vec3(13.8, -1097.3, 29.8), radius = 25.0 },   -- Ammu-Nation range, Pillbox
            { coords = vec3(821.4, -2163.5, 29.6), radius = 25.0 },  -- Ammu-Nation range, Cypress Flats
        },
    },

    fight = {
        enabled = true,
        cooldown = 60,
        requireWitness = true,
        witnessRadius = 40.0,
    },

    carjack = {
        enabled = true,
        cooldown = 30,
    },

    rtc = {
        enabled = true,
        cooldown = 60,
        minSpeed = 45,       -- speed before impact (Config.Units per hour)
        speedDrop = 35,      -- sudden loss of speed that counts as a crash
        ignoreClasses = { 13, 14, 15, 16, 21 }, -- cycles, boats, helis, planes, trains
    },

    vehicleFire = {
        enabled = true,
        radius = 40.0,       -- any burning vehicle this close to a player is reported
        cooldown = 120,
    },

    -- Players dying or going into last stand. Detected automatically: the game, QB/Qbox metadata,
    -- ESX death, osp_ambulance and wasabi_ambulance (v1/v2)
    down = {
        enabled = true,
        stateBagKeys = { 'isDead', 'dead', 'isDown' }, -- extra keys if your death script uses state bags
        presets = {
            police = 'officer_down',
            ambulance = 'medic_down',
            fire = 'firefighter_down',
        },
    },
}

-- Civilians (and off-duty emergency staff) going down alert the ambulance service
Config.Detections.civilianDown = {
    enabled = true,
    delay = 5,               -- seconds before the alert, so instant revives don't trigger one
    cooldown = 120,          -- seconds between alerts for the same player
    requireWitness = false,  -- true: only if an NPC is nearby to call it in
    witnessRadius = 60.0,
    ignoreZones = {},        -- e.g. { coords = vec3(...), radius = 50.0 } for PvP or event areas

    -- these causes also go to police
    alsoPolice = { shot = true, stabbing = true, assault = true, vehicle = true, explosion = true },

    -- title, description and grade (1 Immediate, 2 Priority, 3 Routine) per cause
    causes = {
        shot = { title = 'Person shot', description = 'A person has been shot and is unresponsive.', priority = 1 },
        stabbing = { title = 'Person stabbed', description = 'A person has been stabbed and is unresponsive.', priority = 1 },
        assault = { title = 'Person assaulted', description = 'A person has been beaten and is unresponsive.', priority = 1 },
        vehicle = { title = 'Pedestrian struck', description = 'A person has been hit by a vehicle.', priority = 1 },
        explosion = { title = 'Explosion casualty', description = 'A person has been injured in an explosion.', priority = 1 },
        fire = { title = 'Burns casualty', description = 'A person has been badly burned.', priority = 1 },
        fall = { title = 'Fall from height', description = 'A person has fallen and is unresponsive.', priority = 1 },
        drowning = { title = 'Drowning', description = 'A person has been pulled from the water unresponsive.', priority = 1 },
        electric = { title = 'Electrocution', description = 'A person has been electrocuted.', priority = 1 },
        unknown = { title = 'Person unresponsive', description = 'A member of the public reports a person collapsed and unresponsive.', priority = 2 },
    },
}

---------------------------------------------------------------------
-- Alert presets
-- Each preset gets a client + server convenience export in PascalCase:
-- store_robbery -> exports['vinewood-dispatch']:StoreRobbery(overrides)
--
-- blip.approximate places the blip randomly inside the radius
-- vehicle = true attaches the sender's current/last vehicle
-- weapon = true attaches the weapon type being held
-- requireService = only on-duty members of these services may send it
-- unit = true attaches the sender's callsign and lets responders follow their live blip
-- ownService = true sends it to the sender's service (plus addServices)
-- cooldown = seconds between sends from one player
---------------------------------------------------------------------
Config.Alerts = {
    shooting = {
        title = 'Shots fired',
        description = 'Members of the public report gunfire.',
        priority = 1,
        services = { 'police' },
        weapon = true,
        blip = { sprite = 110, colour = 1, scale = 1.1, radius = 80.0, approximate = true, flash = true },
    },
    shooting_vehicle = {
        title = 'Shots fired from vehicle',
        description = 'Gunfire reported from a moving vehicle.',
        priority = 1,
        services = { 'police' },
        weapon = true,
        vehicle = true,
        blip = { sprite = 110, colour = 1, scale = 1.1, radius = 80.0, approximate = true, flash = true },
    },
    fight = {
        title = 'Fight in progress',
        description = 'Reports of people fighting in the street.',
        priority = 2,
        services = { 'police' },
        blip = { sprite = 311, colour = 47, scale = 1.0, radius = 50.0, approximate = true },
    },
    vehicle_theft = {
        title = 'Vehicle taken by force',
        description = 'Driver removed from their vehicle.',
        priority = 2,
        services = { 'police' },
        vehicle = true,
        blip = { sprite = 225, colour = 47, scale = 1.0 },
    },
    rtc = {
        title = 'Road traffic collision',
        description = 'Reports of a serious collision.',
        priority = 2,
        services = { 'police', 'ambulance' },
        vehicle = true,
        blip = { sprite = 380, colour = 47, scale = 1.0 },
    },
    officer_down = {
        unit = true,
        title = 'Officer down',
        description = 'An officer is injured and needs urgent assistance.',
        priority = 1,
        services = { 'police', 'ambulance' },
        requireService = { 'police' },
        blip = { sprite = 161, colour = 3, scale = 1.3, flash = true },
    },
    medic_down = {
        unit = true,
        title = 'Paramedic down',
        description = 'A paramedic is injured and needs urgent assistance.',
        priority = 1,
        services = { 'police', 'ambulance' },
        requireService = { 'ambulance' },
        blip = { sprite = 161, colour = 2, scale = 1.3, flash = true },
    },
    firefighter_down = {
        unit = true,
        title = 'Firefighter down',
        description = 'A firefighter is injured and needs urgent assistance.',
        priority = 1,
        services = { 'police', 'ambulance', 'fire' },
        requireService = { 'fire' },
        blip = { sprite = 161, colour = 1, scale = 1.3, flash = true },
    },
    panic_police = {
        unit = true,
        title = 'Officer panic button',
        description = 'Panic button activated. Urgent assistance required.',
        priority = 1,
        services = { 'police' },
        requireService = { 'police' },
        blip = { sprite = 161, colour = 3, scale = 1.4, flash = true },
    },
    panic_ambulance = {
        unit = true,
        title = 'Paramedic panic button',
        description = 'Panic button activated. Urgent assistance required.',
        priority = 1,
        services = { 'police', 'ambulance' },
        requireService = { 'ambulance' },
        blip = { sprite = 161, colour = 2, scale = 1.4, flash = true },
    },
    panic_fire = {
        unit = true,
        title = 'Firefighter panic button',
        description = 'Panic button activated. Urgent assistance required.',
        priority = 1,
        services = { 'police', 'fire' },
        requireService = { 'fire' },
        blip = { sprite = 161, colour = 1, scale = 1.4, flash = true },
    },
    backup_routine = {
        title = 'Backup requested',
        description = 'Unit requests additional units.',
        priority = 2,
        services = { 'police', 'ambulance', 'fire' },
        requireService = { 'police', 'ambulance', 'fire' },
        ownService = true,           -- goes to the requester's own service
        unit = true,
        cooldown = 20,
        blip = { sprite = 161, colour = 5, scale = 1.1 },
    },
    backup_urgent = {
        title = 'Urgent assistance',
        description = 'Unit requires urgent assistance.',
        priority = 1,
        services = { 'police', 'ambulance', 'fire' },
        requireService = { 'police', 'ambulance', 'fire' },
        ownService = true,
        addServices = { 'police' },  -- always also sent to police
        unit = true,
        cooldown = 20,
        blip = { sprite = 161, colour = 1, scale = 1.3, flash = true },
    },
    backup_firearms = {
        title = 'Firearms support requested',
        description = 'Armed response requested.',
        priority = 1,
        services = { 'police' },
        requireService = { 'police' },
        unit = true,
        cooldown = 20,
        blip = { sprite = 110, colour = 1, scale = 1.3, flash = true },
    },
    call_999 = {
        title = '999 call',
        priority = 1,
        services = { 'police', 'ambulance', 'fire' },
        caller = true,
        blip = { sprite = 480, colour = 1, scale = 1.0 },
    },
    call_101 = {
        title = '101 call',
        priority = 3,
        services = { 'police' },
        caller = true,
        blip = { sprite = 480, colour = 3, scale = 0.9 },
    },
    person_down = {
        title = 'Person unresponsive',
        description = 'A member of the public reports a person collapsed and unresponsive.',
        priority = 2,
        services = { 'ambulance', 'police' },  -- detection sends ambulance, plus police when violent
        cooldown = 30,
        blip = { sprite = 153, colour = 1, scale = 1.1, flash = true },
    },
    injured_person = {
        title = 'Injured person',
        description = 'A member of the public needs medical attention.',
        priority = 2,
        services = { 'ambulance' },
        blip = { sprite = 61, colour = 2, scale = 1.0 },
    },
    structure_fire = {
        title = 'Building fire',
        description = 'Fire reported in a building. Persons may be trapped.',
        priority = 1,
        services = { 'fire', 'ambulance', 'police' },
        blip = { sprite = 436, colour = 1, scale = 1.2, radius = 40.0, flash = true },
    },
    vehicle_fire = {
        title = 'Vehicle fire',
        description = 'A vehicle is on fire.',
        priority = 2,
        services = { 'fire', 'police' },  -- police in case it's a stolen car being burnt out
        vehicle = true,
        dedupePlate = 300,                 -- one alert per plate every 5 minutes, however many people see it
        matchStolen = { 'vehicle_theft' }, -- links to a recent stolen-vehicle call with the same plate
        blip = { sprite = 436, colour = 47, scale = 1.0 },
    },
    store_robbery = {
        title = 'Shop robbery',
        description = 'Silent alarm triggered at a shop.',
        priority = 1,
        services = { 'police' },
        blip = { sprite = 52, colour = 1, scale = 1.1, flash = true },
    },
    bank_robbery = {
        title = 'Bank robbery',
        description = 'Bank alarm activated.',
        priority = 1,
        services = { 'police' },
        blip = { sprite = 500, colour = 1, scale = 1.2, radius = 60.0, flash = true },
    },
    house_burglary = {
        title = 'Burglary',
        description = 'Intruder alarm activated at a residential property.',
        priority = 2,
        services = { 'police' },
        blip = { sprite = 40, colour = 47, scale = 1.0 },
    },
    drug_dealing = {
        title = 'Drug dealing',
        description = 'A member of the public reports drug dealing.',
        priority = 2,
        services = { 'police' },
        cooldown = 15,
        blip = { sprite = 51, colour = 1, scale = 1.0, radius = 60.0, approximate = true },
    },
    drug_sting = {
        title = 'Undercover officer needs assistance',
        description = 'Undercover drug operation compromised. Officer requires urgent backup.',
        priority = 1,
        services = { 'police' },
        cooldown = 15,
        blip = { sprite = 51, colour = 1, scale = 1.2, flash = true },
    },
    suspicious = {
        title = 'Suspicious activity',
        description = 'A member of the public reports suspicious behaviour.',
        priority = 3,
        services = { 'police' },
        blip = { sprite = 66, colour = 5, scale = 0.9, radius = 60.0, approximate = true },
    },
}
