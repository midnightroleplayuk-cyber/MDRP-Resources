--[[
    Apex Gangs — Shared Config
    ────────────────────────────────────────────────────────────
    Everything user-facing lives here. The script is designed to be
    edited ALMOST entirely in-game (gangs, ranks, HQs, turf, garages,
    safes are all created with the /gangcreator in-world editor), so
    this file only holds global behaviour + defaults. Edit + restart
    (or run `apex_gangs_reload`) to broadcast new settings to clients.

    Palette note: brand is Apex blue #b81fff on a hue-free dark
    surface stack, exactly like apex_banking. The NUI derives its
    whole colour ramp from Config.theme at runtime.
]]

Config = Config or {}

-- ─── General ──────────────────────────────────────────────
Config.debug         = false
Config.locale        = 'en'           -- 'en' | 'pt' | 'es' | 'fr' | 'de'
Config.resourceName  = GetCurrentResourceName()

-- ─── Framework override (auto-detected by default) ───────
-- 'auto' picks the running framework automatically. Force one only
-- if you run several cores at once. Supported: 'auto'|'esx'|'qb'|'qbx'
Config.framework     = 'auto'

-- How gangs are stored in your framework:
--   'native' → use the framework's own gang system where it exists
--              (QBCore/QBox `gang` field). On ESX (no native gangs)
--              this transparently falls back to 'job'.
--   'job'    → model each gang as a job/grade (works everywhere,
--              including old ESX). Recommended for ESX servers.
--   'standalone' → apex_gangs is the ONLY source of truth; player
--              gang lives purely in apex_gangs_members (no core write).
Config.gangStore     = 'native'

-- ═══════════════════════════════════════════════════════════
-- PROVIDERS — plug into resources you already run. 'auto' detects
-- at runtime; a specific name forces it; 'none' disables it.
-- ═══════════════════════════════════════════════════════════
Config.providers = {
    notify    = 'auto',  -- 'auto'|'apex_notify'|'ox_lib'|'okok'|'mythic'|'esx'|'qb'|'custom'|'none'
    target    = 'auto',  -- 'auto'|'ox_target'|'qb-target'|'qtarget'|'none'
    textui    = 'auto',  -- 'auto'|'ox_lib'|'esx'|'qb'|'apex'|'none'
    inventory = 'auto',  -- vault stash provider (see Config.vault)
    garage    = 'auto',  -- external garage bridge (see Config.garage.providers)
    logger    = 'webhook', -- 'webhook'|'fivem_logs'|'custom'
}

-- ═══════════════════════════════════════════════════════════
-- FEATURE TOGGLES — flip whole subsystems on/off per server.
-- Disabled subsystems keep their DB tables (no data loss) but hide
-- their UI pane and short-circuit their server callbacks.
-- ═══════════════════════════════════════════════════════════
Config.features = {
    creation       = true,   -- in-game gang creation (admin)
    members        = true,    -- invite / kick / promote / demote
    ranks          = true,    -- per-rank labels + permissions editor
    permissions    = true,    -- granular permission system
    hq             = true,    -- gang HQ + interaction points
    occupation     = true,    -- HQ occupation/dispute mechanic
    turf           = true,    -- capturable territory (redzone-style)
    graffiti       = true,    -- spray / tagging system
    levels         = true,    -- gang XP + level progression
    upgrades       = true,    -- buyable / unlockable gang upgrades
    vault          = true,    -- shared safe (money + item stash)
    garage         = true,    -- shared gang garage
    scout          = true,    -- scout rival gangs for intel
    raid           = true,    -- raid rival gangs for loot
    airdrop        = true,    -- server-wide loot airdrops (plane + crate)
    tasks          = true,    -- gang tasks / contracts
    medic          = true,    -- gang medic (heal / revive)
    salaries       = true,    -- optional per-rank salaries
    players        = true,    -- live members tab + map
    map            = true,    -- live leaflet map (GTA tiles)
    blips          = true,    -- map blips for HQ + turf
    worldMarkers   = true,    -- 3D markers on HQ points
    sounds         = true,    -- NUI / client click sounds
    logs           = true,    -- audit log of every action
    settings       = true,    -- Settings pane (per-player theme)
}

-- ═══════════════════════════════════════════════════════════
-- ACCESS — who can open the ADMIN god-menu and the in-world
-- creator/editor. Two independent gates (ace + job) per command,
-- plus the deep admin detection (ESX group / QB permission / ids).
-- ═══════════════════════════════════════════════════════════
Config.adminAce       = 'apex_gangs.admin'
Config.adminCommand   = 'gangadmin'      -- /gangadmin  → god-mode menu
Config.creatorCommand = 'gangmanager'    -- /gangmanager → in-world zone editor + manager
Config.creatorHotkey  = false            -- creator opens by COMMAND ONLY (bind disabled)
Config.menuCommand    = 'gangmenu'       -- /gangmenu   → a member's own gang menu
Config.menuHotkey     = false            -- e.g. 'F8' (false to disable)

-- ═══════════════════════════════════════════════════════════
-- GANG INTERACTIONS RADIAL (F10) — member-only quick actions
-- (cuff, bag, trunk, carry, flat tire, hostage, search…). Ported
-- standalone from atomic_ganginteractions. Only members of a
-- registered gang can open it. Binds are rebindable in-menu (KVP).
-- ═══════════════════════════════════════════════════════════
Config.interactions = {
    enabled   = true,
    gangOnly  = true,                  -- only gang members can open the radial
    openKey   = 'F10',                  -- default open bind (rebindable in radial Settings)
    command   = 'ganginteract',        -- /ganginteract also opens it
    distance        = 3.0,             -- player target range (metres)
    vehicleDistance = 5.0,             -- nearest-vehicle range (trunk / tire)
    playerVisibleInTrunk = false,
    requireItems    = false,           -- false → no item/weapon needed for any action
    targetNpcs      = true,            -- F10 actions also work on NPCs (peds), not just players
    inventory = 'auto',                -- rob/search inventory: 'auto'|'ox'|'qb'|'qs'|'mf'|'codem'

    -- per-action master toggles (hidden from the radial when false)
    features = {
        search = true, cuff = true, bag = true, trunk = true,
        carry = true, flattire = true, hostage = true, escort = true,
    },

    -- optional item requirements per action
    items = {
        cuff     = { item = 'handcuffs',   required = false },
        bag      = { item = 'paper_bag',   required = false },
        flattire = { item = 'weapon_knife', required = false },
    },
    hostageWeapons = { 'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_SNSPISTOL', 'WEAPON_VINTAGEPISTOL' },

    -- Supported rebind keys (name → FiveM control id) shown in the
    -- radial Settings. Pick any for the open key or a per-action quick key.
    keyControls = {
        F1=288, F2=289, F3=170, F5=166, F6=167, F7=168, F8=169, F9=56, F10=57, F11=344, F12=58,
        E=38, G=58, H=74, X=73, Z=20, B=29, V=0, CAPSLOCK=137, LEFTALT=19, LEFTCTRL=36, LEFTSHIFT=21,
        NUM0=108, NUM1=117, NUM2=118, NUM3=60, NUM4=107, NUM5=110, NUM6=109, NUM7=117, NUM8=111, NUM9=112,
    },
}

Config.adminAceFallbacks = {
    'command', 'command.kick', 'command.ban',
    'group.admin', 'group.superadmin', 'group.god', 'group.mod',
    'qbcore.god', 'qbcore.admin', 'qbcore.mod',
}
Config.adminIdentifiers = {
    -- 'license:abcdef0123456789abcdef0123456789abcdef01',
}

Config.access = {
    creator = {
        ace = { enabled = true, perms = {
            'apex_gangs.creator', 'apex_gangs.admin',
            'group.owner', 'group.developer', 'group.admin', 'group.superadmin',
        } },
        job = { enabled = false, jobs = {} },
        includeAdmins = true,
    },
    admin = {
        ace = { enabled = true, perms = {
            'apex_gangs.admin',
            'group.owner', 'group.developer', 'group.admin', 'group.superadmin',
            'group.god', 'group.mod', 'qbcore.god', 'qbcore.admin', 'qbcore.mod',
        } },
        job = { enabled = false, jobs = {} },
        includeAdmins = true,
    },
}

-- ─── Interaction style for HQ / world points ──────────────
-- '3dmarker' = floating in-world icon + [E] (default)
-- 'target'   = ox_target / qb-target look-at
-- 'textui'   = proximity key prompt
Config.interaction       = '3dmarker'
Config.textUIKey         = 38      -- E
Config.textUIDistance    = 2.0
Config.targetMaxDistance = 3.0
Config.markerLift        = 1.0
-- Gang zones (HQ / safe / garage / medic / task) are PRIVATE to their gang:
-- only that gang's members see the blip/marker and can interact. By default this
-- is STRICT — even admins are gang-locked in-world (they manage zones through the
-- /gangmanager creator, not by walking into other gangs' HQs). Set true to let
-- admins see/use every gang's zones in-world.
Config.zonesAdminSeeAll  = false

-- ─── UI Theme (matches apex_banking palette) ─────────────
-- Brand is Apex blue #1F5EFF. The neutral surface stack is
-- intentionally hue-free so the brand colour reads cleanly. The
-- NUI derives its whole ramp (brand-300..600 + alphas, surfaces)
-- from `brand` + `bg` at runtime, so changing two hexes re-themes
-- everything — including the in-world 3D markers.
-- `bg` is the BASE tone the NUI ramp derives the whole surface stack from
-- (sidebar tone). With #131314 the ramp reproduces apex_bossmenu's exact
-- background stack: shell #0A0A0B · sidebar #131314 · card #1A1A1B ·
-- raised #232325 · border #1F1F21 · borderHi #2A2A2D.
Config.theme = {
    brand        = '#1F5EFF',
    brandDark    = '#0048F0',
    bg           = '#131314',
    bgCard       = '#1A1A1B',
    bgRaised     = '#232325',
    bgSidebar    = '#131314',
    border       = '#1F1F21',
    borderHi     = '#2A2A2D',
    text         = '#F4F4F5',
    textSub      = 'rgba(244,244,245,.55)',
    info         = '#4E9CE5',
    success      = '#34C77B',
    warning      = '#E5A93C',
    error        = '#E5564B',
}

-- ─── Currency ─────────────────────────────────────────────
Config.currency = { symbol = '£', position = 'before' }

-- ─── Notifications ────────────────────────────────────────
Config.notify = {
    position = 'top-right',
    duration = 5000,
    title    = 'Gangs',
    fallbackToBuiltin = true,
    custom = {
        resource = '', export = '', args = { '@message', '@type', '@duration' },
        event = '', eventArgs = nil,
    },
}

-- ─── Item images for the NUI (vault preview) ──────────────
Config.itemImageBase = 'nui://ox_inventory/web/images/'

-- ═══════════════════════════════════════════════════════════
-- GANG CREATION defaults — used by the admin "create gang" flow
-- and as the baseline for every new gang.
-- ═══════════════════════════════════════════════════════════
Config.gangs = {
    -- Any grade ≥ this is treated as a leader when a gang has no
    -- explicit is_leader rank flag in the DB.
    defaultLeaderGradeMin = 4,

    nameMinLen   = 3,
    nameMaxLen   = 22,
    labelMaxLen  = 32,

    -- Hard ceiling for a gang's member cap (clamps admin/creator input so a
    -- typo can't set 0 — which would lock invites — or an absurd value).
    absMaxMembers = 200,

    -- Default colour applied to a brand-new gang (hex). Editable in
    -- the creator. Drives the turf wall colour + blips.
    defaultColor = '#1F5EFF',

    -- Starting state for a new gang.
    startLevel      = 1,
    startMaxMembers = 12,

    -- Default rank ladder cloned into every new gang. grade 0 = lowest.
    -- Permissions are keys from Config.permissions.all (see below).
    defaultRanks = {
        { grade = 0, label = 'Recruit',    isLeader = false, salary = 0,
          permissions = { 'use_garage', 'create_graffiti', 'view_members' } },
        { grade = 1, label = 'Member',     isLeader = false, salary = 0,
          permissions = { 'use_garage', 'store_vehicle', 'create_graffiti', 'view_members',
                          'access_vault', 'start_scout', 'capture_turf', 'occupy_hq' } },
        { grade = 2, label = 'Enforcer',   isLeader = false, salary = 0,
          permissions = { 'use_garage', 'store_vehicle', 'create_graffiti', 'remove_graffiti',
                          'view_members', 'access_vault', 'deposit_items', 'withdraw_items',
                          'start_scout', 'start_raid', 'capture_turf', 'occupy_hq', 'manage_tasks' } },
        { grade = 3, label = 'Lieutenant', isLeader = false, salary = 0,
          permissions = { 'invite_members', 'promote_members', 'use_garage', 'store_vehicle',
                          'take_vehicle', 'delete_vehicle', 'create_graffiti', 'remove_graffiti',
                          'view_members', 'access_vault', 'deposit_items', 'withdraw_items',
                          'deposit_money', 'start_scout', 'start_raid', 'capture_turf', 'occupy_hq',
                          'manage_tasks', 'view_logs' } },
        { grade = 4, label = 'Boss',       isLeader = true,  salary = 0,
          permissions = { '*' } },   -- '*' = every permission
    },
}

-- ═══════════════════════════════════════════════════════════
-- PERMISSIONS — the full catalogue. Each rank holds a subset
-- (or '*' for all). Checked server-side on every privileged action.
-- ═══════════════════════════════════════════════════════════
Config.permissions = {
    -- key = label shown in the rank editor
    all = {
        invite_members   = 'Invite members',
        kick_members     = 'Remove members',
        promote_members  = 'Promote members',
        demote_members   = 'Demote members',
        manage_ranks     = 'Manage ranks',
        transfer_lead    = 'Transfer leadership',
        view_members     = 'View members',
        view_logs        = 'View gang logs',
        access_vault     = 'Access the safe',
        deposit_items    = 'Deposit items',
        withdraw_items   = 'Withdraw items',
        deposit_money    = 'Deposit money',
        withdraw_money   = 'Withdraw money',
        use_garage       = 'Use the garage',
        store_vehicle    = 'Store vehicles',
        take_vehicle     = 'Take vehicles',
        delete_vehicle   = 'Delete garage vehicles',
        start_scout      = 'Start a scout',
        start_raid       = 'Start a raid',
        capture_turf     = 'Capture territory',
        create_graffiti  = 'Create graffiti',
        remove_graffiti  = 'Remove graffiti',
        manage_tasks     = 'Manage tasks',
        occupy_hq        = 'Occupy HQs',
        buy_upgrades     = 'Buy upgrades',
        use_medic        = 'Use the gang medic',
    },
    -- Leaders (is_leader rank) implicitly hold every permission.
    leaderHasAll = true,
}

-- ═══════════════════════════════════════════════════════════
-- LEVELS / XP — gang progression. xpForLevel(n) defines the curve.
-- ═══════════════════════════════════════════════════════════
Config.levels = {
    enabled  = true,
    maxLevel = 20,
    -- XP required to go FROM level n TO n+1.
    curve = function(level) return math.floor(1000 * (level ^ 1.5)) end,

    -- XP awards per action.
    xp = {
        task_complete   = 250,
        turf_capture    = 500,
        turf_defend     = 300,
        raid_success    = 750,
        raid_defended   = 400,
        graffiti_place  = 50,
        scout_success   = 120,
        hq_explore      = 200,
        member_recruit  = 100,
    },

    -- What each level unlocks. Empty levels just add prestige.
    unlocks = {
        [2]  = { maxMembers = 16 },
        [4]  = { maxMembers = 20, graffitiLimit = 15 },
        [6]  = { maxMembers = 24, vaultSlots = 120 },
        [8]  = { maxMembers = 28, garageLimit = 8 },
        [10] = { maxMembers = 34, vaultSlots = 160, garageLimit = 10 },
        [14] = { maxMembers = 40 },
        [18] = { maxMembers = 50 },
    },
}

-- ═══════════════════════════════════════════════════════════
-- UPGRADES — buyable with treasury money (and/or a level gate).
-- ═══════════════════════════════════════════════════════════
Config.upgrades = {
    enabled = true,
    -- key = { label, desc, cost, minLevel, max (stacking levels), effect }
    catalogue = {
        member_cap   = { label = 'Recruitment Drive', desc = '+4 max members per level',  cost = 25000, minLevel = 2, max = 5, effect = { maxMembers = 4 } },
        vault_space  = { label = 'Reinforced Safe',   desc = '+40 vault slots per level',  cost = 18000, minLevel = 2, max = 4, effect = { vaultSlots = 40 } },
        garage_space = { label = 'Bigger Garage',     desc = '+2 garage slots per level',  cost = 22000, minLevel = 3, max = 4, effect = { garageLimit = 2 } },
        graffiti_cap = { label = 'Tag Crew',          desc = '+5 graffiti per level',      cost = 12000, minLevel = 2, max = 4, effect = { graffitiLimit = 5 } },
        task_cd      = { label = 'Hustle',            desc = '-15% task cooldown',         cost = 15000, minLevel = 3, max = 3, effect = { taskCdMult = -0.15 } },
        raid_reward  = { label = 'Connections',       desc = '+10% raid rewards',          cost = 30000, minLevel = 5, max = 3, effect = { raidRewardMult = 0.10 } },
        zone_reward  = { label = 'Territory Tax',     desc = '+10% turf income',           cost = 28000, minLevel = 4, max = 3, effect = { turfRewardMult = 0.10 } },
        hq_security  = { label = 'HQ Security',       desc = '+15s HQ occupation time',    cost = 20000, minLevel = 4, max = 3, effect = { occupyBonus = 15 } },
        medic_unlock = { label = 'Gang Medic',        desc = 'Unlock the gang medic',      cost = 40000, minLevel = 6, max = 1, effect = { medic = true } },
    },
}

-- ═══════════════════════════════════════════════════════════
-- TURF — capturable territory (redzone-style barrier walls).
-- Zones themselves are created in-game with /gangcreator. These
-- are the global rules.
-- ═══════════════════════════════════════════════════════════
Config.turf = {
    enabled            = true,
    captureSeconds     = 60,       -- time inside an enemy zone to flip it
    contestFreezes     = true,     -- 2+ gangs inside → progress freezes
    cooldownSeconds    = 600,      -- per-zone recapture cooldown after a flip
    minMembersToCapture = 1,       -- members of the capturing gang needed inside

    -- "Tag your turf": a new zone starts NEUTRAL (grey). A gang claims it by
    -- spraying graffiti inside — once it has `tagsRequired` tags in the zone it
    -- becomes theirs (the walls + map blip take the gang's colour).
    claimByGraffiti = {
        enabled      = true,
        tagsRequired = 3,          -- gang tags inside the zone needed to claim it
        claimEnemy   = false,      -- false → only NEUTRAL zones (enemy zones need a capture)
    },

    -- Passive income paid to the owning gang per interval.
    income = { enabled = true, amount = 500, intervalMinutes = 30, toVault = true },

    -- Wall visuals (redzone look). color defaults to the OWNING gang's
    -- colour at runtime; this is the neutral / fallback colour.
    -- enabled=false → NO coloured barrier wall up to the sky (the zone still
    -- works for capture/income/graffiti; only the visual wall is hidden).
    -- Default OFF: no in-world zone colour. Set true to bring the redzone wall back.
    wall = {
        enabled        = false,
        neutral        = { r = 120, g = 120, b = 130, a = 70 },
        circleSegments = 48,
        height         = 1000.0,
        floorDrop      = 60.0,
        renderBand     = 300,      -- only draw the wall within this many m of the edge
        contestPulse   = true,     -- blink the wall alpha while contested
    },
    -- Territories on the MAIN GAME MAP (pause map + minimap) for EVERYONE —
    -- fusti_gangmap-style: a coloured AREA blip (the shaded zone) + an
    -- icon/label blip at the centre, coloured by the owning gang. Works
    -- standalone; the rich hover popup (blip_info) is optional.
    blip = {
        enabled    = true,    -- master: show the gang turf blips on the GTA map at all
        area       = false,   -- OFF: no translucent radius CIRCLE. Just ONE plain
                              -- icon blip per zone — nothing extra to clutter or
                              -- interfere with the ESC/pause map. (true re-adds the circle.)
        sprite     = 310,     -- gang icon sprite at the zone centre
        scale      = 0.9,
        alpha      = 70,      -- circle translucency on the map (only if area = true)
        display    = 3,       -- 3 = minimap + big map (visible to everyone)
        shortRange = false,   -- false = always shown on the big map
        -- Optional rich popup via glitchdetector's blip_info (auto-detected).
        -- DISABLED by default: it hooks the pause map (clickable info cards /
        -- instructional buttons) which interferes with panning/clicking the
        -- normal GTA map. Leave false for plain, static blips only.
        blipInfo   = false,
        ytd        = 'jobs',
    },
}

-- ═══════════════════════════════════════════════════════════
-- HQ OCCUPATION — capture an enemy HQ point.
-- ═══════════════════════════════════════════════════════════
Config.occupation = {
    enabled         = true,
    captureSeconds  = 120,
    cooldownSeconds = 1800,
    reward          = { xp = 200, money = 5000 },
    failOnLeave     = true,        -- attackers leaving the zone aborts it
}

-- ═══════════════════════════════════════════════════════════
-- GRAFFITI — standalone tagging (ported from sa_spray scaleform).
-- ═══════════════════════════════════════════════════════════
Config.graffiti = {
    enabled         = false,
    item            = 'spraycan',   -- required item to spray (false = none)
    removerItem     = 'spray_remover',
    consumeItem     = false,        -- consume one item per spray
    perGangLimit    = 10,           -- base cap (raised by levels/upgrades)
    cooldownSeconds = 120,
    persistDays     = 7,            -- auto-expire old tags
    maxChars        = 9,
    drawDistance    = 100.0,        -- text-graffiti draw distance (scaleform fonts)
    canRemoveRival  = true,         -- rivals can remove your tags (rank-gated)
    maxPlaceDist    = 8.0,          -- server rejects sprays further than this from the player (anti remote-tag/claim)

    -- Players may paint an arbitrary image URL (not just the catalogue).
    allowCustomUrl  = true,

    -- Custom freehand DRAWINGS (the "Draw" tab — a canvas exported as a
    -- transparent PNG and stored server-side). maxDrawingBytes caps the data
    -- URL length to keep DB rows + sync payloads sane.
    allowDrawings   = true,
    -- Max data-URL length for a flattened editor graffiti. The editor auto-shrinks
    -- the export to fit this, so it can never error "too large"; raising it just
    -- allows higher-resolution tags (at a bigger DB row + sync payload).
    maxDrawingBytes = 700000,

    -- ── IMAGE graffiti render (DrawSpritePoly textured quad) ──
    -- A DUI runtime texture (built from the image URL) is drawn flat on the
    -- wall as a 3D quad. NO scaleform .gfx (those crash on recent builds).
    --   size     = quad WIDTH in metres (height follows the image aspect)
    --   distance = draw distance in metres
    --   max      = max image sprays drawn at once (perf cap)
    render = { max = 12, distance = 50.0, size = 1.2 },

    -- ── Resize limits (anti-abuse) ──
    -- During placement the player resizes with the mouse wheel; `scale`
    -- multiplies the base size. min/max CLAMP it (also enforced server-side).
    --   image: multiplies render.size (metres)
    --   text : multiplies the font size
    scale = {
        text  = { min = 0.5, max = 4.0, step = 0.1, default = 1.0 },
        image = { min = 0.4, max = 2.5, step = 0.1, default = 1.0 },
    },

    -- Spray progress (seconds). Tag artworks use `tag`, everything else `piece`.
    timers = { piece = 30, tag = 10 },

    -- Spray animation / prop / particle — a 1:1 port of qb-graffiti's Lamar
    -- wall-tagging scene (STANDING, no crouch, NO shake). The can attaches to the
    -- right hand; the ped plays the tagging loop, then after `loopMs` settles into
    -- the exit loop while the paint particle streams from the can nozzle.
    spray = {
        animDict   = 'switch@franklin@lamar_tagging_wall',
        animClip   = 'lamar_tagging_wall_loop_lamar',   -- tagging loop (intro)
        exitClip   = 'lamar_tagging_exit_loop_lamar',   -- sustained spray loop
        loopMs     = 5500,                              -- intro length before the exit loop (qb timing)
        prop       = 'prop_cs_spray_can',
        propBone   = 28422,                          -- SKEL_R_Hand
        propOffset = { x = 0.0, y = -0.01, z = -0.012 },
        propRot    = { x = 0.0, y = 0.0,  z = 0.0 },
        ptfxDict   = 'scr_playerlamgraff',
        ptfx       = 'scr_lamgraff_paint_spray',
        ptfxAlpha  = 0.25,                              -- qb-graffiti alpha
    },

    -- Streamed graffiti faces (the .gfx files in stream/) for the TEXT mode.
    -- Built-in GTA fonts (Pricedown etc.) also work but need no file.
    fonts = {
        { font = 'graffiti1', label = 'Wildstyle',  sizeMult = 0.7 },
        { font = 'graffiti2', label = 'Bubble',     sizeMult = 0.55 },
        { font = 'graffiti3', label = 'Tag',        sizeMult = 0.55 },
        { font = 'graffiti4', label = 'Throwie',    sizeMult = 0.5 },
        { font = 'graffiti5', label = 'Blockbuster',sizeMult = 0.6 },
    },

    -- Colour swatches offered in the selector (text colour + spray tint).
    colors = { '#1F5EFF', '#E5564B', '#34C77B', '#E5A93C', '#A66DF0', '#FFFFFF', '#111111' },

    -- Forbidden words filter (text mode).
    blacklist = { 'badword1', 'badword2' },

    -- ── IMAGE graffiti catalogue (MF DUI → runtime texture) ──
    -- Each entry is a real image URL the client binds straight into a DUI of
    -- width×height pixels. `tag = true` marks short tags (uses the shorter
    -- spray timer). Players can also paint a custom URL if allowCustomUrl.
    images = {
        enabled = true,
        -- ── DROP-IN GALLERY ──
        -- Put .png files in  html/images/  and list their file names here. Each
        -- one shows in the graffiti editor's IMG panel and loads LOCALLY (no
        -- external URL). Players drag them onto the canvas to compose a tag;
        -- the finished piece is flattened to a single image and sprayed.
        gallery = {
            'grove.png',
            'ballas.png',
            'bloods.png',
            'vagos.png',
        },
        catalogue = {},   -- legacy external-URL catalogue (the folder gallery above is preferred)
    },
}

-- ═══════════════════════════════════════════════════════════
-- VAULT / SAFE — shared per-gang stash + money.
-- ═══════════════════════════════════════════════════════════
Config.vault = {
    enabled = true,
    slots   = 80,
    weight  = 200000,             -- 200 kg base (raised by upgrades)
    idTemplate = 'apex_gang_vault_%s',   -- %s = gang name
    -- Money side mirrors the framework society/gang account when true.
    syncSocietyMoney = true,
    minDeposit = 1, maxDeposit = 9999999,
    minWithdraw = 1, maxWithdraw = 1000000,
    -- inventory provider order (auto). See apex_bossmenu style providers.
    providers = { 'ox_inventory', 'qb-inventory', 'qs-inventory', 'ps-inventory',
                  'codem-inventory', 'origen_inventory', 'tgiann-inventory',
                  'mf-inventory', 'chezza-inventory' },
}

-- ═══════════════════════════════════════════════════════════
-- GARAGE — shared gang vehicles. Self-contained by default; can
-- bridge to an external garage for the actual spawn if you prefer.
-- ═══════════════════════════════════════════════════════════
Config.garage = {
    enabled    = true,
    baseLimit  = 6,              -- vehicles per gang (raised by levels/upgrades)
    keysOnTake = true,          -- hand vehicle keys on take
    -- Only let a member deposit a NEW vehicle into the gang garage if it is
    -- their OWN car (framework owned_vehicles / player_vehicles). Re-storing a
    -- car already in the gang garage is always allowed; admins bypass this.
    requireOwnership = true,
    -- When 'external', delegate spawn/store to one of these resources;
    -- when 'self', apex_gangs spawns at the HQ garage point itself.
    mode       = 'self',         -- 'self' | 'external'
    providers  = {
        'ak47_garage', 'ak47_qb_garage', 'cd_garage', 'codem_garage',
        'jg_advancedgarages', 'loaf_garage', 'okokGarage', 'rcore_garage',
        'vms_garagesv2',
    },
    -- Vehicle keys resources (auto-detected) for keysOnTake.
    keyProviders = {
        'qbx_vehiclekeys', 'qb-vehiclekeys', 'wasabi_carlock', 'Renewed-Vehiclekeys',
        'tgiann-hotwire', 'MrNewbVehicleKeys', 'cd_garage', 'okokGarage',
    },
}

-- ═══════════════════════════════════════════════════════════
-- SCOUT — gather intel on a rival gang.
-- ═══════════════════════════════════════════════════════════
Config.scout = {
    enabled         = true,
    durationSeconds = 45,
    cooldownSeconds = 600,
    successChance   = 0.75,        -- 0..1
    alertChance     = 0.35,        -- chance the rival is warned
    reveals = { 'hqArea', 'onlineMembers', 'level', 'turfCount', 'vaultEstimate', 'defenseState' },
}

-- ═══════════════════════════════════════════════════════════
-- RAID — attack a rival gang for loot.
-- ═══════════════════════════════════════════════════════════
Config.raid = {
    enabled         = true,
    requireScout    = true,        -- a recent scout is required to raid
    scoutValidMins  = 30,
    durationSeconds = 300,
    cooldownSeconds = 3600,
    minAttackers    = 2,
    minDefenders    = 0,           -- 0 = can raid offline gangs (reduced loot)
    -- ── RP rules ──
    requireTerritory = true,       -- you can only raid a gang that HOLDS turf
    repCost          = 50,         -- launching a raid spends this much REP (mobilising)
    cashCost         = 15000,      -- society money spent from your vault to mobilise a raid
    -- The "Capture their base" toggle in the raid dialog. When enabled and the
    -- raid SUCCEEDS, one of the target's territories is seized for your gang —
    -- for an extra mobilisation cost.
    captureBase      = { enabled = true, extraCash = 10000, extraRep = 100 },
    daytimeOnly      = false,      -- true → only between hourStart..hourEnd (in-game time)
    hourStart        = 20,         -- raids allowed from 20:00…
    hourEnd          = 6,          -- …to 06:00 (wraps midnight) when daytimeOnly
    -- Loot pulled from the target on success (configurable + balanced).
    loot = {
        moneyPctOfVault = 0.20,    -- steal up to 20% of target vault money
        moneyMax        = 50000,
        items           = {        -- chance-based item drops
            { item = 'gang_supplies', min = 1, max = 3, chance = 0.6 },
            { item = 'weapon_parts',  min = 1, max = 2, chance = 0.35 },
        },
        xp        = 750,
        influence = 1,             -- territory influence gained
    },
    offlineLootMult = 0.4,         -- multiplier when target has no defenders
    -- ── STASH RAID ──
    -- When a raid SUCCEEDS, the winners get a TIMED window to reach the LOSER's
    -- safe and steal directly from their item stash. A waypoint + blip + on-foot
    -- distance (in metres) guides them there; [E] at the safe opens the real
    -- gang stash. When the timer runs out, access is revoked.
    stashRaid = {
        enabled       = true,
        windowSeconds = 180,        -- how long the winners can loot after winning
        openRadius    = 3.0,        -- must be within this many metres of the enemy safe
        point         = 'safe',     -- which of the loser's gang zones is the stash (falls back to 'hq')
        blip          = { sprite = 478, color = 1, scale = 1.0 },   -- 478 = loot bag
    },
}

-- ═══════════════════════════════════════════════════════════
-- AIRDROP — a server-wide loot crate flown in by a cargo plane and
-- dropped by parachute at a RANDOM enabled zone. Everyone fights over
-- it. The HQ navbar shows the countdown to the next drop, and the HQ
-- live map shows every candidate zone (admins toggle each on/off live).
-- ═══════════════════════════════════════════════════════════
Config.airdrop = {
    enabled         = true,
    autoSchedule    = true,    -- run the periodic scheduler (false = /airdrop command / livemap only)
    intervalMinutes = 45,      -- a drop is delivered every N minutes…
    requiredPlayers = 0,       -- …only if at least this many players are online (0 = always)
    warnSeconds     = 30,      -- "incoming" broadcast this long before the plane arrives
    unlockMinutes   = 1.5,     -- the crate is sealed (parachuting + arming) before it can be opened
    openSeconds     = 6,       -- channel time (progress) to crack the crate open on site
    openRadius      = 3.0,     -- how close you must be to open it (server-validated)
    requireWeapon   = false,   -- must hold a firearm to open (like a raid)
    gangOnly        = false,   -- true → only gang members get the blip / may open
    notifyEveryone  = true,    -- broadcast the "airdrop inbound" notification to all players
    blipScanRadius  = false,   -- false = blip always visible · number = only within N metres

    streak = { chance = 15, count = 2 },   -- chance% that a scheduled drop spawns `count` crates at once

    -- ── Cargo plane delivery (flies in, drops, flies out) ──
    plane = {
        model      = 'titan',          -- bbv-airdrops cargo plane
        pilotModel = 's_m_m_pilot_02',  -- bbv-airdrops pilot
        spawnDist  = 700.0,    -- spawns this far from the drop and flies in
        height     = 240.0,    -- cruise height above the drop
        speed      = 90.0,
    },
    crateModel     = 'prop_drop_armscrate_01',  -- bbv-airdrops supply crate
    parachuteModel = 'p_cargo_chute_s',
    -- crouch + search loop while cracking the crate open (bbv-style pickup)
    openAnim       = { dict = 'anim@gangops@facility@servers@bodysearch@', clip = 'player_search' },

    blip = { sprite = 550, color = 1, scale = 0.95, label = 'Airdrop' },   -- bbv-airdrops blip
    planeBlip = { sprite = 422, color = 5, scale = 0.9, label = 'Cargo Plane' },
    -- Coloured ground flare/smoke beacon at the landed crate (the signal).
    flare = { enabled = true, color = { r = 220, g = 40, b = 40 }, scale = 1.6, alpha = 0.9 },

    -- ── Loot (rolled SERVER-SIDE on open — never trusted to the client) ──
    reward = {
        money     = { min = 5000, max = 20000 },   -- cash granted on open
        toVault   = false,                         -- true → money to the gang safe instead of the pocket
        itemRolls = { min = 1, max = 3 },          -- how many item stacks the crate yields
        -- Weighted loot table. `weight` is relative (higher = more common).
        -- ONLY items that exist in this server's ox_inventory (gang-themed).
        -- Weapon keys are UPPERCASE (ox weapons). Edit freely.
        items = {
            { item = 'armour',              min = 1, max = 3,    weight = 16 },
            { item = 'medikit',             min = 1, max = 3,    weight = 16 },
            { item = 'bandage',             min = 2, max = 5,    weight = 16 },
            { item = 'lockpick',            min = 1, max = 3,    weight = 16 },
            { item = 'fixkit',              min = 1, max = 2,    weight = 8  },
            { item = 'spraycan',            min = 1, max = 3,    weight = 18 },  -- tag the turf you take
            { item = 'spray_remover',       min = 1, max = 2,    weight = 8  },  -- scrub rival tags
            { item = 'black_money',         min = 1000, max = 5000, weight = 14 },
            { item = 'WEAPON_BAT',          min = 1, max = 1,    weight = 9  },
            { item = 'WEAPON_PISTOL',       min = 1, max = 1,    weight = 9  },
            { item = 'WEAPON_MICROSMG',     min = 1, max = 1,    weight = 5  },
            { item = 'WEAPON_PUMPSHOTGUN',  min = 1, max = 1,    weight = 4  },
            { item = 'WEAPON_ASSAULTRIFLE', min = 1, max = 1,    weight = 2  },
        },
    },

    -- ── Candidate drop zones. A RANDOM enabled zone is picked per drop, then a
    -- random point inside its radius. Each `id` must be stable (used to persist
    -- the live on/off toggle). Edit / add freely. ──
    zones = {
        { id = 'dz_sandy',     label = 'Sandy Shores',  coords = vector3(1844.0, 3680.0, 33.5),    radius = 90.0,  enabled = true },
        { id = 'dz_paleto',    label = 'Paleto Bay',    coords = vector3(-275.0, 6230.0, 31.5),    radius = 90.0,  enabled = true },
        { id = 'dz_docks',     label = 'Elysian Docks', coords = vector3(338.0, -2715.0, 7.0),     radius = 80.0,  enabled = true },
        { id = 'dz_airport',   label = 'LSIA',          coords = vector3(-1336.0, -3044.0, 13.9),  radius = 90.0,  enabled = true },
        { id = 'dz_quarry',    label = 'Davis Quarry',  coords = vector3(2954.0, 2785.0, 41.0),    radius = 90.0,  enabled = true },
        { id = 'dz_chiliad',   label = 'Mt. Chiliad',   coords = vector3(450.0, 5566.0, 781.0),    radius = 70.0,  enabled = true },
        { id = 'dz_powerstn',  label = 'Power Station', coords = vector3(2737.0, 1530.0, 24.5),    radius = 80.0,  enabled = true },
        { id = 'dz_vinewood',  label = 'Vinewood Hills', coords = vector3(-174.0, 497.0, 130.0),   radius = 70.0,  enabled = false },
    },
}

-- ═══════════════════════════════════════════════════════════
-- REPUTATION — a second gang currency (REP). Earned from tasks and
-- operations; shown in the HQ navbar next to the society money; gates
-- the raid (your gang needs enough rep to launch one).
-- ═══════════════════════════════════════════════════════════
Config.reputation = {
    enabled = true,
    label   = 'REP',
    raidMin = 250,        -- reputation the gang needs to launch a raid
    -- rep gained per NON-task action (mirrors the XP reasons). Tasks pay
    -- their own reward.rep (see Config.tasks.pool below). These double as the
    -- "street points" scoring: kills 5 · holding turf 1/5s · spray 2 · clean 3.
    rewards = {
        turf_capture   = 40,
        turf_defend    = 25,
        raid_success   = 80,
        scout_success  = 15,
        member_recruit = 10,
        turf_kill      = 5,    -- per kill while inside contested/enemy turf
        turf_hold      = 1,    -- per 5s held inside an enemy zone you're flipping
        graffiti_place = 2,    -- per tag sprayed
        graffiti_remove = 3,   -- per rival tag scrubbed
    },
    holdInterval = 5,          -- seconds per turf_hold point
}

-- ═══════════════════════════════════════════════════════════
-- TASKS — gang contracts. The 'mission' ones are STARTED from the Tasks
-- tab and played out in the world (eliminate / grab+deliver); completing
-- them pays the society money + reputation shown on the card.
-- ═══════════════════════════════════════════════════════════
Config.tasks = {
    enabled       = true,
    maxActive     = 5,             -- concurrent tasks offered per gang
    refreshHours  = 6,             -- auto-offer new tasks every N hours
    cooldownSeconds = 300,
    -- Per-player cooldown after an explore-HQ / a finished mission.
    exploreCooldown = 5,
    missionCooldown = 60,
    pool = {
        -- ── ASSASSINATION — kill a roaming high-value target, then meet the
        --    fixer to collect. (rewards roll between min/max) ──
        { id = 'assassination', type = 'mission', name = 'Assassination Contract',
          desc = 'Eliminate a high-value target quickly and discreetly, leaving no witnesses behind.',
          objective = 1, minLevel = 1,
          reward = { money = { min = 7500, max = 30000 }, rep = { min = 250, max = 1150 }, xp = 600 },
          mission = {
              verb = 'assassinate', timeLimit = 1200, model = 'a_m_y_business_01', armed = true,
              targets = {
                  { start = vector3(-332.37, -672.74, 32.38), finish = vector3(304.86, -740.39, 29.31) },
                  { start = vector3(553.87, 152.79, 99.28),    finish = vector3(-239.15, 244.26, 92.04) },
                  { start = vector3(-1274.02, 315.47, 65.51),  finish = vector3(-1392.72, -299.23, 43.61) },
              },
              endings = {
                  { coords = vector3(265.97, 3178.47, 41.64), customers = { { model = 'g_m_y_mexgoon_03', coords = vector4(260.65, 3178.22, 41.74, 283.42) } } },
                  { coords = vector3(1534.01, 6328.88, 23.44), customers = { { model = 'g_m_y_mexgoon_03', coords = vector4(1538.73, 6324.40, 23.06, 37.55) } } },
              },
          } },

        -- ── BODY DISPOSAL — carry a body to a remote drop and get rid of it ──
        { id = 'body_disposal', type = 'mission', name = 'Body Disposal',
          desc = 'Discreetly get rid of evidence by disposing of a body without leaving any trace for law enforcement.',
          objective = 1, minLevel = 1,
          reward = { money = { min = 10000, max = 15000 }, rep = { min = 500, max = 800 }, xp = 300 },
          mission = {
              verb = 'disposal', timeLimit = 1200, bodyModel = 'a_m_y_business_01',
              bodies  = { { coords = vector3(-1077.07, 712.99, 163.41), heading = 127.0 } },
              endings = { { coords = vector3(67.04, -2755.78, 6.00) } },
          } },

        -- ── HOMELESS KIDNAPPING — carry a homeless target to the buyers ──
        { id = 'kidnapping', type = 'mission', name = 'Homeless Kidnapping',
          desc = 'Abduct a target from the streets without drawing attention from bystanders or authorities.',
          objective = 1, minLevel = 1,
          reward = { money = { min = 6000, max = 12000 }, rep = { min = 450, max = 1350 }, xp = 250 },
          mission = {
              verb = 'abduct', timeLimit = 1200, model = 'a_m_o_tramp_01',
              -- Where the homeless target spawns (one is picked at random). Right
              -- now it's pinned to the single requested spot. Add more vector3s
              -- here to randomise across locations again.
              spawns = {
                  vector3(147.824188, -1193.789062, 29.414673),   -- requested kidnap spot (exact Z, under the bridge)
              },
              endings = {
                  { coords = vector3(1377.61, -747.55, 66.47), customers = {
                      { model = 'g_m_y_mexgang_01', coords = vector4(1387.38, -745.98, 66.19, 90.76) },
                      { model = 'g_m_y_mexgoon_03', coords = vector4(1383.47, -744.27, 66.18, 151.03) } } },
                  { coords = vector3(-1157.21, -1454.50, 3.48), customers = {
                      { model = 'g_m_y_mexgoon_03', coords = vector4(-1151.70, -1462.20, 3.41, 20.51) },
                      { model = 'g_m_y_mexgang_01', coords = vector4(-1156.83, -1460.39, 3.38, 311.51) } } },
              },
          } },

        -- ── NARCOTICS HEIST — clear the cartel guards, grab the shipment,
        --    then sell it to the buyers ──
        { id = 'narcotics_heist', type = 'mission', name = 'Narcotics Heist',
          desc = 'Steal a drug shipment from a cartel and sell it before they catch you.',
          objective = 1, minLevel = 1,
          reward = { money = { min = 5000, max = 20000 }, rep = { min = 250, max = 1000 }, xp = 450 },
          mission = {
              verb = 'heist', timeLimit = 1200, vanModel = 'speedo',
              vans = {
                  { coords = vector4(-463.34, -63.01, 44.25, 218.46), guards = {
                      { model = 'g_m_y_korean_02', coords = vector4(-459.76, -62.78, 44.51, 42.04), weapon = 'WEAPON_ASSAULTRIFLE' },
                      { model = 'g_m_y_korean_01', coords = vector4(-468.83, -62.54, 44.51, 345.10), weapon = 'WEAPON_ASSAULTRIFLE' },
                      { model = 'g_m_y_mexgoon_03', coords = vector4(-459.66, -56.92, 44.51, 75.76), weapon = 'WEAPON_ASSAULTRIFLE' } } },
                  { coords = vector4(155.03, -1233.07, 28.96, 254.99), guards = {
                      { model = 'g_m_y_korean_02', coords = vector4(149.04, -1230.98, 29.19, 223.39), weapon = 'WEAPON_ASSAULTRIFLE' },
                      { model = 'g_m_y_korean_01', coords = vector4(147.30, -1232.93, 29.19, 250.91), weapon = 'WEAPON_ASSAULTRIFLE' },
                      { model = 'g_m_y_mexgoon_03', coords = vector4(146.16, -1235.12, 29.19, 255.94), weapon = 'WEAPON_ASSAULTRIFLE' } } },
              },
              endings = {
                  { coords = vector3(1162.49, -1496.47, 34.43), customers = {
                      { model = 'g_m_y_mexgoon_03', coords = vector4(1156.43, -1493.81, 33.69, 239.64) },
                      { model = 'g_m_y_mexgang_01', coords = vector4(1159.74, -1493.92, 33.69, 142.16) } } },
                  { coords = vector3(676.35, -2648.51, 5.81), customers = {
                      { model = 'g_m_y_mexgoon_03', coords = vector4(671.90, -2653.23, 5.08, 15.02) },
                      { model = 'g_m_y_mexgang_01', coords = vector4(668.88, -2651.42, 5.08, 286.64) } } },
              },
          } },

        -- Passive contract completed at the HQ task point (no START button).
        { id = 'explore_hq', type = 'explore', name = 'Case the HQ',
          desc = 'Explore your HQ for hidden stashes (use the task point at your HQ).',
          objective = 1, minLevel = 1, reward = { xp = 200, money = 3000, rep = 50 } },
    },
}

-- ═══════════════════════════════════════════════════════════
-- MEDIC — unlockable gang medic (heal / revive members).
-- ═══════════════════════════════════════════════════════════
Config.medic = {
    enabled         = true,
    requiresUpgrade = true,        -- needs the 'medic_unlock' upgrade
    healCost        = 500,         -- from treasury, per use
    reviveCost      = 2500,
    cooldownSeconds = 60,
    healAmount      = 100,         -- HP
    reviveResource  = 'auto',      -- 'auto' (native) | 'esx_ambulancejob' | 'qb-ambulancejob' | 'wasabi_ambulance'
}

-- ═══════════════════════════════════════════════════════════
-- SALARIES — optional per-rank pay from the treasury.
-- ═══════════════════════════════════════════════════════════
Config.salaries = {
    enabled        = false,
    tickMinutes    = 60,
    payFromVault   = true,
    onlineOnly     = true,
}

-- ═══════════════════════════════════════════════════════════
-- TEST MODE — solo testing aid. Lets ONE player exercise the
-- full invasion loop (turf capture / scout / raid) without other
-- real players, and spawns NPC defenders to fight while you do.
-- ⚠ TURN THIS OFF on a live/production server.
-- Toggle live in-game with /gangtest (admin) — no restart needed.
-- ═══════════════════════════════════════════════════════════
Config.testMode = {
    enabled      = false,  -- master switch — OFF for production. Admins flip it on
                           -- in-game with /gangtest to test the loop solo.

    -- Relax the multiplayer gates so a SOLO player can trigger everything:
    soloOps      = true,   -- raids ignore minAttackers / minDefenders / requireScout
    noCooldowns  = true,   -- scout / raid / turf-recapture cooldowns are skipped

    -- Auto-create a throwaway RIVAL gang on boot so you ALWAYS have a target to
    -- scout / raid (and an owner you can assign to a turf zone, then invade).
    -- Done purely from config — no command needed. (/gangtest rival uses these
    -- same values.) It's created once and skipped if it already exists.
    autoRival    = {
        enabled = false,             -- OFF: no auto-created rival gang on boot
        name    = 'rivals',          -- internal gang id (a-z0-9_)
        label   = 'Test Rivals',     -- display name
        color   = '#E5564B',         -- gang colour (turf wall / blips)
    },

    -- Auto-create a whole set of TEST GANGS on boot (ONLY while test mode is on)
    -- so you have several rivals to scout / raid / invade. They are created once
    -- and skipped if they already exist; they persist in the DB until you delete
    -- them in /gangmanager (or /gangtest cleangangs).
    testGangs = {
        enabled = false,             -- OFF: no auto-created test gangs on boot
        list = {
            { name = 'families', label = 'Families', color = '#34C77B' },
            { name = 'ballas',   label = 'Ballas',   color = '#7E57C2' },
            { name = 'bloods',   label = 'Bloods',   color = '#E5564B' },
            { name = 'vagos',    label = 'Vagos',    color = '#E5A93C' },
        },
    },

    -- Auto-DRAW a small curated set of territories on the map (test mode only):
    -- Grove, Ballas, Bloods, Vagos + one dedicated TEST zone.
    -- DISABLED by default: the script no longer auto-creates ANY zones on boot
    -- (this was the source of the "duplicate / extra zones on the map"). Draw
    -- your own zones in the creator. When this is false, any previously
    -- auto-created test territories (ids `test_*`) are cleaned up on boot.
    -- You can still spawn one on demand with /gangtest zone.
    testZones = {
        enabled = false,
        list = {
            { owner = 'families', label = 'Grove Street', coords = vector3(112.5, -1940.0, 20.8), radius = 80.0 },
            { owner = 'ballas',   label = 'Forum Drive',  coords = vector3(95.0, -2010.0, 20.5),  radius = 80.0 },
            { owner = 'bloods',   label = 'Strawberry',   coords = vector3(300.0, -1880.0, 24.0), radius = 80.0 },
            { owner = 'vagos',    label = 'Rancho',        coords = vector3(360.0, -2055.0, 21.0), radius = 80.0 },
            -- the dedicated TEST / recording zone (owned by the Test Rivals)
            { owner = 'rivals',   label = 'TEST ZONE',    coords = vector3(215.0, -810.0, 30.7),  radius = 60.0 },
        },
    },

    -- NPC defenders so an "invasion" is an actual fight. They appear when you
    -- step into an enemy/neutral turf zone (and during a raid), turn hostile,
    -- and despawn when you leave the zone / capture it / the raid ends.
    npcDefenders = {
        enabled      = true,
        count        = 4,            -- how many spawn per wave
        models       = {             -- a random one is picked per ped
            'g_m_y_ballasout_01', 'g_m_y_ballaeast_01', 'g_m_y_ballaorig_01',
            'g_m_y_famca_01', 'g_m_y_famdnf_01',
        },
        weapon       = 'WEAPON_PISTOL',
        accuracy     = 35,           -- 0-100
        health       = 200,
        armour       = 25,
        spawnRadius  = 18.0,         -- spread around the zone centre / you (metres)
        despawnAfter = 300,          -- hard despawn after N seconds (safety net)
        announce     = true,         -- notify "defenders incoming" / "area cleared"
    },
}

-- ─── Players tab + live map ───────────────────────────────
Config.players = {
    enabled            = true,
    refreshMs          = 2000,
    bossSeesOwnGangOnly = true,
    showVehicles       = true,
}
Config.map = { enabled = true, style = 'atlas' }

-- ─── Blip defaults ────────────────────────────────────────
Config.blips = {
    hq   = { sprite = 84, color = 0, scale = 0.9, label = 'Gang HQ' },
    turf = { sprite = 84, color = 1, scale = 0.85 },
}

-- ─── Discord webhooks (optional, leave empty to disable) ──
Config.logs = {
    gang       = '',
    members    = '',
    ranks      = '',
    vault      = '',
    garage     = '',
    turf       = '',
    graffiti   = '',
    scout      = '',
    raid       = '',
    tasks      = '',
    upgrades   = '',
    medic      = '',
    admin      = '',
}

-- ─── Hot reload pulse ─────────────────────────────────────
-- After editing Config, run the console command `apex_gangs_reload`
-- to push the new settings to every client. No restart required.
Config.hotReload = true
