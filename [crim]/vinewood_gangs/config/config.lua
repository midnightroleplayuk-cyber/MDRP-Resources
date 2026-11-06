Config = {}

Config.Debug = false
Config.Framework = 'auto' -- 'auto' | 'qbox' | 'qb' | 'esx'
Config.Currency = '£'

-- Every module can be switched off independently. Phase 2/3 modules are off until built.
Config.Modules = {
    graffiti     = true,
    contracts    = true,
    heat         = true,
    diplomacy    = true,
    enterprises  = true,
    rackets      = true,
    supplyChains = true,
    safehouses   = true,
    auctions     = true,
    informants   = true, -- members can secretly inform to the police (see config/informants.lua)
    prison       = false,
    director     = true,
}

Config.Gangs = {
    maxMembers   = 25,
    creationCost = 50000, -- taken from the creator's bank
    nameMin      = 3,
    nameMax      = 24,
    allowPlayerCreation = true, -- false = staff create gangs with /gangcreate only
    inviteDistance      = 5.0,  -- metres; 0 disables the proximity check
    inviteExpirySeconds = 60,
    disbandRefund       = true, -- pay the clean treasury to the boss's bank on disband (if online)
}

Config.Territory = {
    showAllInfluence = true, -- tablet shows every gang's influence in each area (false = only your own)

    -- A notification when a player walks into (or out of) an area
    enterNotice = {
        enabled  = true,
        showTo   = 'gangs', -- 'gangs' = anyone in a gang, 'everyone' = all players
        cooldown = 60,      -- seconds before the same area is announced again
        onLeave  = true,    -- also say when you leave gang territory altogether
    },

    -- Map picture behind the Territory tab. Replace the file (web/images) or set image = false for a plain grid.
    -- pixel = world coordinate x scale + offset; the defaults fit the standard 2048 x 2048 GTA V atlas.
    tabletMap = {
        image   = 'images/map.jpg',
        size    = 2048,
        scaleX  = 0.16576, offsetX = 938.4,
        scaleY  = -0.164,  offsetY = 1382.4,
        nudgeX  = 0.0,     nudgeY = 0.0, -- metres; shift everything if your areas sit slightly off
    },

    -- Areas drawn on the in-game map in their owner's colour
    map = {
        enabled       = true,
        showTo        = 'gangs', -- 'gangs' = anyone in a gang, 'everyone' = all players
        minimap       = false,   -- also draw on the minimap (busier)
        showUnclaimed = true,    -- grey areas nobody holds yet
        alpha         = 90,      -- 0-255
        cellSize      = 40.0,    -- metres; areas are filled with squares this size (bigger = fewer blips)
        maxCells      = 150,     -- per area: cells grow automatically for large areas
        maxTotal      = 900,     -- across every area, so lots of areas never hit GTA's limit on map markers
    },
}

Config.Tablet = {
    keybind         = 'F7',         -- false to disable
    command         = 'gangtablet', -- false to disable
    item            = false,        -- e.g. 'gang_tablet' (ox_inventory: see README in the reply / use export openTablet)
    showNearbyNames = false,        -- invite list shows character names instead of 'Person (ID)'
}

-- Staff commands are restricted to this ACE principal, e.g. add_principal identifier.fivem:123 group.admin
Config.Admin = {
    group = 'group.admin',
}

Config.Influence = {
    tickMinutes         = 5,
    captureThreshold    = 100,  -- influence needed to take a zone
    holdThreshold       = 60,   -- owner keeps the zone while above this
    ownershipMargin     = 25,   -- lead over 2nd place needed to take a zone
    maxPerZone          = 1000,
    decayPercentPerHour = 4.0,
    pruneBelow          = 0.5,
    -- Decay slows down when the server is quiet so gangs don't lose turf overnight
    population = { minPlayers = 10, fullAt = 64, minScale = 0.15 },
}

Config.Heat = {
    tickMinutes         = 10,
    decayPercentPerHour = 3.0,
    -- Crossing a threshold upwards generates a police intelligence lead
    thresholds = {
        { level = 25,  precision = 'vague' },
        { level = 60,  precision = 'area'  },
        { level = 100, precision = 'exact' },
    },
    leadExpiryHours = 48,
    maxLeadsPerHour = 4, -- server-wide cap so small police shifts aren't flooded
}

Config.Ledger = {
    flagThreshold  = 25000,   -- single transactions at or above this are flagged
    maxTransaction = 1000000, -- per deposit/withdrawal
}

Config.ActivityLog = {
    retentionDays = 30,
}

Config.Logos = {
    enabled         = true,
    requireApproval = true, -- staff approve logos in /gangadmin before they show
    -- Links must be https and on one of these hosts (subdomains included).
    -- Discord attachment links expire after a while, so they aren't allowed by default.
    -- If you host on Fivemanage, add the domain from one of your image links here.
    allowedHosts = { 'i.imgur.com', 'i.ibb.co', 'r2.fivemanage.com' },

    -- true: accept an image link from ANY website (it must still start with https://, and staff still approve it).
    -- Bear in mind picture tags load for everyone who walks past them, so the website hosting the image can see
    -- those players' IP addresses. Discord attachment links expire, so images from them go blank after a while.
    allowAnyHost = true,
    extensions   = { 'png', 'jpg', 'jpeg', 'webp', 'gif' },
}

-- Your other Vinewood resources. Set either to false to turn the link off.
Config.Integrations = {
    dispatch = 'vinewood-dispatch',
    mdt      = 'vinewood-mdt',

    -- Who intelligence reports appear to come from on the MDT
    intelAuthor = 'Organised Crime Unit (automated)',
    -- 3x5x2 grading per lead precision: source, assessment, handling
    intelGrading = { vague = '2DP', area = '2CP', exact = '2BP' },
}

-- Chances that a member of the public calls the police
Config.Witnesses = {
    graffiti = 0.15, -- someone spraying a tag
    assault  = 0.5,  -- a debt collection that turns into a fight
}
