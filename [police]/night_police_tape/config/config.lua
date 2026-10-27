Config = {}

Config.ConfigVersion = '1.0.0'
Config.Debug = false
Config.EventPrefix = 'night_police_tape'

-- Language of everything players read: messages, the on-screen panel, key binding
-- descriptions and chat suggestions. Included: 'en', 'nl', 'de', 'fr', 'es'.
-- To add one, copy locales/en.lua, rename it and translate it. Lines left out stay English.
Config.Locale = 'en'

--====================== PERMISSIONS ======================--

Config.EveryoneHasPermission = false

Config.Enable_Night_DiscordApi_Permissions = false    -- server/s_functions.lua
Config.Enable_Ace_Permissions = false                 -- server/s_functions.lua
Config.Enable_ESX_Permissions = false                 -- client/c_functions.lua & server/s_functions.lua
Config.Enable_QBCore_Permissions = {
    Check_By_Job = true,                              -- client/c_functions.lua & server/s_functions.lua
    Check_By_Permissions = true,                      -- server/s_functions.lua
}

Config.PermissionRoles = {
    'police',
    'ambulance',
    'fire',
}

--====================== REQUIRED ITEM ======================--
-- Players must be carrying this item to hang tape. Leave Enabled false to skip the check.
-- System: 'auto', 'esx', 'ox', 'qb', or 'qbox'.
--   auto uses whichever inventory is running: ox_inventory, then Qbox, then QBCore, then ESX.
--   Qbox servers that use ox_inventory can pick 'ox' or leave this on auto.
-- Add the item yourself, under Config.Item.Name:
--   esx   items table:          police_tape, label Police tape
--   ox    data/items.lua:       ['police_tape'] = { label = 'Police tape', weight = 200, stack = true, close = true }
--   qb    qb-core/shared/items.lua
--   qbox  ox_inventory data/items.lua, unless you are not running ox_inventory

Config.Item = {
    Enabled = true,
    System = 'ox',
    Name = 'police_tape',
    RemoveOnPlace = false,   -- take one item when a tape is hung
    ReturnOnRemove = false,  -- give it back when that player takes the tape down. Only applies if RemoveOnPlace is true.
}

--====================== COMMANDS AND CONTROLS ======================--

-- Place, Remove, Restyle and Clear are chat commands. The others only exist so their keys
-- can be remapped in Settings > Key Bindings > FiveM, and are hidden from chat suggestions.
Config.Commands = {
    Place = 'policetape',
    Remove = 'removetape',
    Restyle = 'restyletape',
    Clear = 'cleartapes',   -- admins only, see Config.Clear.AdminRoles. '' turns the command off.
    Confirm = 'policetape_confirm',
    Cancel = 'policetape_cancel',
    CycleLeft = 'policetape_prev',
    CycleRight = 'policetape_next',
    AimRemove = 'policetape_remove',
    AimRestyle = 'policetape_restyle',
}

-- Default keyboard keys. Players rebind them in Settings > Key Bindings > FiveM and the
-- on-screen hints follow. Key names: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
-- Set a key to '' to leave it unbound.
Config.HotKeys = {
    Place = '',             -- /policetape. Unbound by default.
    Confirm = 'E',
    Cancel = 'BACK',        -- Backspace
    CycleLeft = 'LEFT',     -- Left arrow
    CycleRight = 'RIGHT',   -- Right arrow
    AimRemove = 'LMENU',    -- Left Alt, while looking at a tape
    AimRestyle = 'G',       -- while looking at a tape
}

-- Milliseconds the remove key has to be held while looking at a tape. 0 removes on a tap.
Config.RemoveHoldTime = 1200

-- On mouse and keyboard, left click also confirms and the mouse wheel also changes the style
-- while placing. The weapon wheel, weapon keys and firing are locked while placing either way.
Config.MouseControls = true

-- Default controller buttons. Names: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/pad-digitalbutton/
Config.PadHotKeys = {
    Confirm = 'RDOWN_INDEX',    -- A
    Cancel = 'RRIGHT_INDEX',    -- B
    CycleLeft = 'LLEFT_INDEX',  -- D-Left
    CycleRight = 'LRIGHT_INDEX',-- D-Right
    AimRemove = '',
    AimRestyle = '',
}

-- Game controls switched off while the default keys above are in use, so E does not open a
-- door and G does not throw a grenade. https://docs.fivem.net/docs/game-references/controls/
Config.BlockedControls = {
    Placing = { 38, 51, 177, 194, 174, 175, 189, 190 },  -- E, Backspace, arrows
    Aiming = { 19, 47, 58 },                             -- Alt, G
}

Config.UI = {
    Accent = { 59, 130, 246 },  -- same default blue as night_ers
    Tint = 0.7,                 -- how much of the accent colours the panel's dark glass, 0 (neutral) to 1, as in night_ers
    ValidMarker = { 60, 200, 90 },    -- aim marker where confirming would work
    InvalidMarker = { 220, 40, 40 },  -- aim marker and preview line where it would not
}

--====================== TAPE ======================--

-- Must match the streamed segment. The mesh is 1 metre along its forward axis.
Config.SegmentLength = 1.0

Config.Sag = {
    droopAtReference = 0.12,   -- metres of droop at the middle of a reference span
    referenceSpan = 8.0,       -- metres. Droop scales with the span.
}

-- Tape near the player bows downwind and ripples, scaled by the game's wind speed.
-- Purely visual and local to each player. Both anchors stay fixed.
Config.Wind = {
    Enabled = true,
    Strength = 1.0,     -- 0.5 calmer, 2.0 wilder
    IdleSpeed = 1.5,    -- m/s of breeze assumed when the weather is calm, so tape never hangs dead still
    Distance = 25.0,    -- only tapes this close to the player move. Farther ones hang still.
}

-- Tape gives way when people or vehicles walk or drive into it, then springs back.
-- Purely visual and local to each player, like the wind.
Config.Stretch = {
    Enabled = true,
    Distance = 30.0,    -- only tapes this close to the player react
    MaxStretch = 1.15,  -- pushed tape can get 15% longer, then whoever pushes slips through
    NPCs = true,        -- people who are not players push the tape too
    Vehicles = true,
    -- A player driving into tape faster than Speed tears it down for everybody. Slower,
    -- the tape stretches and lets them through. Needs Enabled and Vehicles above.
    Tear = {
        Enabled = false,
        Speed = 50.0,   -- km/h
    },
}

Config.Preview = {
    Alpha = 210,        -- see-through-ness of the tape shown while placing, 0 to 255
    Swatch = true,      -- show one metre of the selected style in the on-screen panel
}

Config.MinLength = 0.75
Config.MaxLength = 40.0
-- Each 1 m of tape is one local object. 100 objects per 100 m² is a 10 m square.
Config.MaxObjectsPerArea = 100
Config.AreaSquareMeters = 100.0
Config.PlaceDistance = 25.0     -- how far the aim ray reaches
Config.MaxAnchorDistance = 30.0 -- both anchors must be this close to the player
Config.StreamDistance = 150.0
Config.AimDistance = 12.0       -- how far away a tape can be selected by looking at it
Config.AimRadius = 0.45         -- metres from the look ray to count as aiming at the tape
Config.ActionDistance = 20.0    -- server rejects remove/restyle farther away than this

-- Tapes come down by themselves this many minutes after they were hung, restarts
-- included. 0 keeps every tape until someone removes it.
Config.Lifetime = {
    Minutes = 0,
    Scripted = false,   -- whether tapes placed by other resources through the PlaceTape export expire too
}

-- /cleartapes [radius|all] takes down every tape within the radius, or all of them.
-- Admins only. A player is an admin if they hold one of AdminRoles in a permission system
-- turned on under PERMISSIONS (Discord roles, ACE, ESX jobs or groups, QBCore jobs or
-- permissions), or if ACE allows them the command, for example in server.cfg:
--   add_ace group.admin command.cleartapes allow
-- Config.EveryoneHasPermission does not make everyone an admin.
-- From the server console, use: cleartapes all
Config.Clear = {
    DefaultRadius = 25.0,   -- metres, when no radius is given
    MaxRadius = 200.0,
    AdminRoles = {
        'Administrator',    -- Discord role
        'admin',            -- ESX group, QBCore permission
        'superadmin',       -- ESX group
        'god',              -- QBCore permission
    },
}

--====================== SERVER PROTECTION ======================--
-- The most requests one player can send, as Count per Seconds. Anything past that is
-- dropped, so a modified client cannot flood the server with tapes, saves and updates.
-- Normal play stays far below these. Set Count to 0 to turn a limit off.
Config.RateLimit = {
    Place = { Count = 4, Seconds = 10 },
    Remove = { Count = 8, Seconds = 10 },
    Restyle = { Count = 10, Seconds = 10 },
    Tear = { Count = 6, Seconds = 10 },
    Other = { Count = 10, Seconds = 10 },   -- starting placement, sync and permission checks
}

-- A tape end aimed at the ground gets this post, with the tape tied near its top.
-- Ends aimed at a wall, fence, pole or tree take the tape directly, without a post.
-- Empty string turns posts off; every end is then tied where it was aimed.
Config.AnchorProp = 'prop_roadpole_01a'
Config.AnchorPlaceOnGround = true   -- tilt the post to match sloped ground
Config.AnchorTopOffset = 0.05       -- metres below the top of the post where the tape is tied
Config.AnchorTapeHeight = nil       -- fixed tie height above the ground in metres; nil measures the model

-- One model per legend so different tapes can show different styles at once.
-- Set enabled = false to hide a style from placing and restyling. Saved tapes in a hidden style switch to the first enabled one.
-- The designs live in tools/tape_styles.py. Rebuild with tools/build_tape.py, then add a line here.
Config.Textures = {
    -- General
    { id = 'police', label = 'Police line', model = 'ns_tape_police', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'police_yellow', label = 'Police line (yellow)', model = 'ns_tape_police_yellow', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'police_check', label = 'Police check', model = 'ns_tape_police_check', enabled = false, color = { r = 30, g = 76, b = 158 } },
    { id = 'police_diag', label = 'Police diagonal', model = 'ns_tape_police_diag', enabled = false, color = { r = 30, g = 76, b = 158 } },
    { id = 'caution', label = 'Caution', model = 'ns_tape_caution', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'crime', label = 'Crime scene', model = 'ns_tape_crime', enabled = true, color = { r = 245, g = 206, b = 20 } },
    { id = 'crime_yellow', label = 'Crime scene (yellow)', model = 'ns_tape_crime_yellow', enabled = true, color = { r = 245, g = 206, b = 20 } },
    { id = 'fire', label = 'Fire line', model = 'ns_tape_fire', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'fire_alert', label = 'Fire line alert', model = 'ns_tape_fire_alert', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'danger', label = 'Danger', model = 'ns_tape_danger', enabled = true, color = { r = 210, g = 31, b = 40 } },
    { id = 'detour', label = 'Detour', model = 'ns_tape_detour', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'construction', label = 'Construction', model = 'ns_tape_construction', enabled = true, color = { r = 245, g = 206, b = 20 } },

    -- North America
    { id = 'us_sheriff', label = "Sheriff's line (US)", model = 'ns_tape_us_sheriff', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'ca_police', label = 'Police line EN/FR (CA)', model = 'ns_tape_ca_police', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'us_biohazard', label = 'Biohazard', model = 'ns_tape_us_biohazard', enabled = false, color = { r = 242, g = 85, b = 28 } },

    -- United Kingdom and Ireland
    { id = 'uk_police', label = 'Police line (UK)', model = 'ns_tape_uk_police', enabled = true, color = { r = 30, g = 76, b = 158 } },
    { id = 'ie_garda', label = 'Garda (IE)', model = 'ns_tape_ie_garda', enabled = true, color = { r = 30, g = 76, b = 158 } },
    { id = 'uk_fire', label = 'Fire, do not cross (UK)', model = 'ns_tape_uk_fire', enabled = true, color = { r = 210, g = 31, b = 40 } },

    -- Benelux
    { id = 'nl_roodwit', label = 'Rood-wit lint', model = 'ns_tape_nl_roodwit', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'nl_politie', label = 'Politie, niet betreden (NL)', model = 'ns_tape_nl_politie', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'nl_brandweer', label = 'Brandweer (NL)', model = 'ns_tape_nl_brandweer', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'be_police', label = 'Politie / Police (BE)', model = 'ns_tape_be_police', enabled = false, color = { r = 30, g = 76, b = 158 } },

    -- Germany, Austria, Switzerland
    { id = 'de_polizei', label = 'Polizeiabsperrung (DE)', model = 'ns_tape_de_polizei', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'de_feuerwehr', label = 'Feuerwehr-Sperrzone (DE)', model = 'ns_tape_de_feuerwehr', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'at_polizei', label = 'Polizei (AT)', model = 'ns_tape_at_polizei', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'ch_polizei', label = 'Polizei / Police / Polizia (CH)', model = 'ns_tape_ch_polizei', enabled = false, color = { r = 210, g = 31, b = 40 } },

    -- France, Italy, Spain, Portugal
    { id = 'fr_police', label = 'Police, franchissement interdit (FR)', model = 'ns_tape_fr_police', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'fr_pompiers', label = 'Sapeurs-pompiers (FR)', model = 'ns_tape_fr_pompiers', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'it_polizia', label = 'Polizia (IT)', model = 'ns_tape_it_polizia', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'es_policia', label = 'Línea de policía (ES)', model = 'ns_tape_es_policia', enabled = false, color = { r = 30, g = 76, b = 158 } },
    { id = 'es_bomberos', label = 'Bomberos (ES)', model = 'ns_tape_es_bomberos', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'pt_policia', label = 'Polícia (PT)', model = 'ns_tape_pt_policia', enabled = false, color = { r = 30, g = 76, b = 158 } },

    -- Nordics and eastern Europe
    { id = 'se_polis', label = 'Polis avspärrat (SE)', model = 'ns_tape_se_polis', enabled = false, color = { r = 30, g = 76, b = 158 } },
    { id = 'no_politi', label = 'Politi (NO)', model = 'ns_tape_no_politi', enabled = false, color = { r = 30, g = 76, b = 158 } },
    { id = 'dk_politi', label = 'Politi (DK)', model = 'ns_tape_dk_politi', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'pl_policja', label = 'Policja (PL)', model = 'ns_tape_pl_policja', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'ru_policiya', label = 'Police, no entry (RU)', model = 'ns_tape_ru_policiya', enabled = false, color = { r = 210, g = 31, b = 40 } },

    -- Latin America
    { id = 'mx_precaucion', label = 'Precaución (MX)', model = 'ns_tape_mx_precaucion', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'mx_policia', label = 'Línea de policía (MX)', model = 'ns_tape_mx_policia', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'br_policia', label = 'Local de crime (BR)', model = 'ns_tape_br_policia', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'br_perigo', label = 'Perigo, fita zebrada (BR)', model = 'ns_tape_br_perigo', enabled = false, color = { r = 210, g = 31, b = 40 } },

    -- Asia
    { id = 'jp_keepout', label = 'Keep out (JP)', model = 'ns_tape_jp_keepout', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'kr_policeline', label = 'Police line, no entry (KR)', model = 'ns_tape_kr_policeline', enabled = false, color = { r = 245, g = 206, b = 20 } },
    { id = 'cn_police', label = 'Police line (CN)', model = 'ns_tape_cn_police', enabled = false, color = { r = 30, g = 76, b = 158 } },
    { id = 'hk_police', label = 'Police cordon (HK)', model = 'ns_tape_hk_police', enabled = false, color = { r = 210, g = 31, b = 40 } },
    { id = 'id_policeline', label = 'Police line (ID)', model = 'ns_tape_id_policeline', enabled = false, color = { r = 245, g = 206, b = 20 } },

    -- Plain, no wording
    { id = 'hazard_stripes', label = 'Hazard stripes, yellow/black', model = 'ns_tape_hazard_stripes', enabled = true, color = { r = 245, g = 206, b = 20 } },
    { id = 'plain_bluewhite', label = 'Plain blue/white', model = 'ns_tape_plain_bluewhite', enabled = true, color = { r = 30, g = 76, b = 158 } },
    { id = 'plain_redwhite_blocks', label = 'Plain red/white blocks', model = 'ns_tape_plain_redwhite_blocks', enabled = true, color = { r = 210, g = 31, b = 40 } },
    { id = 'plain_yellow', label = 'Plain yellow', model = 'ns_tape_plain_yellow', enabled = true, color = { r = 245, g = 206, b = 20 } },
}