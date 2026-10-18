-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}
Config.Departments = {}
-- Department configs live in config/shared/departments/*.lua

-- ============================================================================
-- Core / UI
-- ============================================================================

-- default accent; depts can override with their own color
Config.UIColor = '#2b29b1'

-- locales/*.json — 'en' ships by default
Config.Locale = 'en'

-- weapon images: nui://{ImgDirectory}{weapon_type}.png
Config.ImgDirectory = 'wasabi_inventory/ui/images/'

Config.OpenMDT = {
    item = {
        enabled = true,
        name = 'mdt_tablet',
    },
    command = {
        enabled = true,
        cmd = 'mdt',
        keybind = 'F11', -- 'F4' or false
    },
}

Config.Announcements = {
    maxAnnouncements = 10,
    defaultExpireDays = 7,
}

-- ============================================================================
-- AutoSync (framework + housing read-through)
-- ============================================================================

-- Jobs hidden from synchronized records. These defaults are retained so upgrading
-- servers do not suddenly expose civilian/gang affiliations in the MDT job picker.
local hiddenJobDefaults = {
    taxi = true,
    bloods = true,
    ballas = true,
    vagos = true,
}

Config.IgnoredJobs = {}
for jobName, hidden in pairs(hiddenJobDefaults) do
    if hidden then Config.IgnoredJobs[#Config.IgnoredJobs + 1] = jobName end
end
table.sort(Config.IgnoredJobs)

-- shown instead of an ignored job on synchronized records
Config.IgnoredJobDisplay = 'unemployed'

-- pull citizens/vehicles/properties from framework + housing instead of manual register
-- mdt tables stay for flags/notes/photos. set enabled=false for fully standalone records.
Config.SyncData = {
    enabled  = true,   -- master switch
    citizens = true,
    vehicles = true,
    -- false, or housing resource name (RxHousing, bcs_housing, rtx_housing, vms_housing)
    -- other scripts: copy bridge/housing/template.lua -> bridge/housing/<resource>.lua
    housing  = false,
}

-- ============================================================================
-- Dispatch
-- ============================================================================

local dispatchTypeRows = {
    { 'traffic_stop', 'Traffic Stop', 'car' },
    { 'disturbance',  'Public Disturbance', 'volume-up' },
    { 'theft',        'Theft Report', 'shopping-bag' },
    { 'assault',      'Assault Call', 'user-minus' },
    { 'robbery',      'Robbery Alert', 'dollar' },
    { 'shooting',     'Weapons Discharge', 'exclamation-triangle' },
    { 'officer_down', 'Officer Emergency', 'shield' },
    { 'panic',        'Emergency Assistance', 'exclamation-circle' },
}

Config.DispatchTypes = {}
for i = 1, #dispatchTypeRows do
    local row = dispatchTypeRows[i]
    Config.DispatchTypes[row[1]] = { label = row[2], icon = row[3] }
end

-- Keys and type identifiers remain stable for integrations and saved calls; display copy is v2-specific.
Config.PremadeDispatches = {
    store_robbery = {
        type = 'robbery', title = 'Commercial Robbery', priority = 4,
        description = 'Robbery reported at a retail location; approach with caution.', location = 'Reported Business',
    },
    bank_robbery = {
        type = 'robbery', title = 'Financial Institution Alarm', priority = 5,
        description = 'Priority alarm from a bank or financial institution.', location = 'Reported Bank',
    },
    vehicle_theft = {
        type = 'theft', title = 'Vehicle Theft', priority = 3,
        description = 'A vehicle theft is currently being reported.', location = 'Last Known Position',
    },
    house_alarm = {
        type = 'disturbance', title = 'Residential Alarm', priority = 2,
        description = 'A residential security alarm has activated.', location = 'Reported Residence',
    },
    shots_fired = {
        type = 'shooting', title = 'Possible Gunfire', priority = 5,
        description = 'Reports indicate possible weapons fire nearby.', location = 'Dispatch Coordinates',
    },
    drug_deal = {
        type = 'disturbance', title = 'Suspected Narcotics Activity', priority = 2,
        description = 'Suspicious activity consistent with a narcotics transaction.', location = 'Reported Area',
    },
    street_race = {
        type = 'traffic_stop', title = 'Reckless Vehicle Activity', priority = 3,
        description = 'Multiple vehicles may be participating in an illegal race.', location = 'Reported Roadway',
    },
    assault_report = {
        type = 'assault', title = 'Active Altercation', priority = 3,
        description = 'A physical confrontation has been reported.', location = 'Reported Scene',
    },
    vandalism = {
        type = 'disturbance', title = 'Property Damage', priority = 1,
        description = 'Intentional damage to property has been reported.', location = 'Affected Property',
    },
    hostage_situation = {
        type = 'officer_down', title = 'Critical Hostage Incident', priority = 5,
        description = 'Possible hostage incident requiring an immediate coordinated response.', location = 'Incident Location',
    },
}

-- gunshot alerts (cops ignored). uses shots_fired premade.
Config.Alerts = {
    shots_fired = {
        enabled = true,
        timeout = 15 * 60 * 1000,
    },
}

-- Radio / Patrol
Config.Radio = {
    enabled = false,
    provider = 'pma-voice', -- pma-voice | saltychat | custom adapter name
    channels = {
        -- `channel` remains the MDT/PMA numeric value. `saltyChat` is the
        -- external string channel used when provider = 'saltychat'.
        { id = 'TAC-1', label = 'TAC-1', channel = 1, saltyChat = 'TAC-1' },
        { id = 'TAC-2', label = 'TAC-2', channel = 2, saltyChat = 'TAC-2' },
        { id = 'TAC-3', label = 'TAC-3', channel = 3, saltyChat = 'TAC-3' },
        { id = 'TAC-4', label = 'TAC-4', channel = 4, saltyChat = 'TAC-4' },
    },
    callChannelStart = 50,
    callChannelEnd   = 99,
    pmaVoice = {
        resource = 'pma-voice',
    },
    saltyChat = {
        resource = 'saltychat',
        primary = true,
        -- Used only when a channel has no explicit `saltyChat` mapping.
        channelPrefix = 'MDT-',
    },
}

-- bodycam via Medal.tv — players need Medal installed
-- set Instant Replay buffer >= maxClipDuration
Config.BodyCam = {
    enabled = false,
    stopKey = 'F10',
    maxClipDuration = 300,   -- seconds per SaveClip (~15–600)
    -- auto-save while recording longer than maxClipDuration (ms). 0 = only on stop
    segmentIntervalMs = 240000,
    alertType = 'OverlayOnly', -- Default|Disabled|SoundOnly|OverlayOnly
}

Config.Dispatch = Config.Dispatch or {}
-- metres from call coords before auto 10-2
Config.Dispatch.arrivalDistance = 35.0
-- maximum responding officers per call; patrol responses count each member
Config.Dispatch.maxResponders = 10

-- ============================================================================
-- Record type catalogs
-- ============================================================================

local function buildTypeCatalog(rows)
    local catalog = {}
    for i = 1, #rows do
        local row = rows[i]
        catalog[i] = { type = row[1], label = row[2], icon = row[3] }
    end
    return catalog
end

-- Type identifiers are stable because existing records store them; labels and presentation belong to v2.
Config.PropertyTypes = buildTypeCatalog({
    { 'house', 'Residential House', 'home' },
    { 'apartment', 'Apartment / Unit', 'building' },
    { 'business', 'Commercial Property', 'briefcase' },
    { 'office', 'Office', 'sitemap' },
    { 'store', 'Retail Property', 'shopping-cart' },
    { 'warehouse', 'Warehouse', 'box' },
    { 'garage', 'Garage', 'car' },
    { 'industrial', 'Industrial Property', 'cog' },
    { 'land', 'Land Parcel', 'map' },
    { 'other', 'Other Property', 'question-circle' },
})

Config.EvidenceTypes = buildTypeCatalog({
    { 'physical_item', 'Physical Item', 'box' },
    { 'biological', 'Biological Material', 'heart' },
    { 'weapon', 'Weapon', 'shield' },
    { 'drugs', 'Controlled Substance', 'filter' },
    { 'document', 'Document', 'file' },
    { 'digital', 'Digital Evidence', 'desktop' },
    { 'photo_video', 'Photo or Video', 'camera' },
    { 'other', 'Other Evidence', 'question-circle' },
})

-- stable type IDs are stored on charge / penal code types
-- labels and badge tones are for show; add/remove/rename rows as needed.
-- tone: green | red | amber | blue | grey
Config.ChargeTypes = {
    { type = 'felony',      label = 'Felony',      tone = 'red' },
    { type = 'misdemeanor', label = 'Misdemeanor', tone = 'amber' },
    { type = 'infraction',  label = 'Infraction',  tone = 'blue' },
}

-- ============================================================================
-- Permissions
-- ============================================================================

--[[
    Staff groups (ACE) used for the staff override. You can also use:
        add_ace group.admin mdt.staff allow
--]]
Config.StaffGroups = {
    'superadmin',
    'admin',
    'god',
    'mod',
}

-- Permission names are part of the public v2 integration surface. Access bands keep
-- department defaults in one independently maintained policy instead of cloning a v1 table.
local ACCESS_BANDS = {
    everyone = '*',
    officer = { 1, 2, 3, 4, 5 },
    supervisor = { 2, 3, 4, 5 },
    command = { 3, 4, 5 },
    leadership = { 4, 5 },
}

local PERMISSIONS_BY_BAND = {
    everyone = {
        'mdt.open', 'mdt.dispatch.view', 'mdt.dispatch.respond', 'mdt.dispatch.pin',
        'mdt.dispatch.incident', 'mdt.panic.trigger', 'mdt.patrol.manage',
        'mdt.penalcodes.view', 'mdt.cameras.view',
    },
    officer = {
        'mdt.citizens.create', 'mdt.citizens.edit',
        'mdt.vehicles.create', 'mdt.vehicles.edit', 'mdt.vehicles.flag',
        'mdt.weapons.create', 'mdt.weapons.edit', 'mdt.weapons.flag',
        'mdt.properties.create', 'mdt.properties.edit', 'mdt.properties.flag',
        'mdt.evidence.create', 'mdt.evidence.edit', 'mdt.evidence.checkout', 'mdt.evidence.checkin',
        'mdt.warrants.serve', 'mdt.bolos.create', 'mdt.bolos.resolve',
        'mdt.incidents.create', 'mdt.incidents.edit', 'mdt.dispatch.create',
    },
    supervisor = {
        'mdt.charges.create', 'mdt.warrants.create', 'mdt.bolos.edit',
        'mdt.incidents.close', 'mdt.penalcodes.create',
        'mdt.cameras.place', 'mdt.cameras.repair',
    },
    command = {
        'mdt.announcements.create', 'mdt.announcements.edit', 'mdt.evidence.delete',
        'mdt.charges.edit', 'mdt.warrants.edit', 'mdt.warrants.cancel',
        'mdt.incidents.delete', 'mdt.incidents.manual', 'mdt.dispatch.delete',
        'mdt.dispatch.radio', 'mdt.penalcodes.edit', 'mdt.cameras.manage',
    },
    leadership = {
        'mdt.announcements.delete', 'mdt.citizens.delete', 'mdt.vehicles.delete',
        'mdt.weapons.delete', 'mdt.properties.delete', 'mdt.charges.delete',
        'mdt.warrants.delete', 'mdt.bolos.delete', 'mdt.penalcodes.delete',
    },
}

local function copyAccessRule(rule)
    if rule == '*' then return rule end
    local copy = {}
    for i = 1, #rule do copy[i] = rule[i] end
    return copy
end

function Config.BuildDepartmentPermissions(overrides)
    local permissions = {}
    for band, names in pairs(PERMISSIONS_BY_BAND) do
        for i = 1, #names do
            permissions[names[i]] = copyAccessRule(ACCESS_BANDS[band])
        end
    end
    for name, rule in pairs(overrides or {}) do
        if rule == false then
            permissions[name] = nil
        else
            permissions[name] = copyAccessRule(rule)
        end
    end
    return permissions
end

-- ============================================================================
-- Weapon / vehicle catalogs
-- ============================================================================

-- GTA weapon identifiers are public game data. Grouping them here gives v2 a single,
-- maintainable catalog without inheriting v1's flat ordering and presentation table.
local WEAPON_GROUPS = {
    sidearms = {
        { 'weapon_pistol', 'Pistol' }, { 'weapon_pistol_mk2', 'Pistol Mk II' },
        { 'weapon_combatpistol', 'Combat Pistol' }, { 'weapon_appistol', 'AP Pistol' },
        { 'weapon_pistol50', 'Pistol .50' }, { 'weapon_snspistol', 'SNS Pistol' },
        { 'weapon_snspistol_mk2', 'SNS Pistol Mk II' }, { 'weapon_heavypistol', 'Heavy Pistol' },
        { 'weapon_vintagepistol', 'Vintage Pistol' }, { 'weapon_marksmanpistol', 'Marksman Pistol' },
        { 'weapon_revolver', 'Heavy Revolver' }, { 'weapon_revolver_mk2', 'Heavy Revolver Mk II' },
        { 'weapon_doubleaction', 'Double Action Revolver' }, { 'weapon_ceramicpistol', 'Ceramic Pistol' },
        { 'weapon_navyrevolver', 'Navy Revolver' }, { 'weapon_gadgetpistol', 'Perico Pistol' },
    },
    compact = {
        { 'weapon_microsmg', 'Micro SMG' }, { 'weapon_smg', 'SMG' },
        { 'weapon_smg_mk2', 'SMG Mk II' }, { 'weapon_assaultsmg', 'Assault SMG' },
        { 'weapon_combatpdw', 'Combat PDW' }, { 'weapon_machinepistol', 'Machine Pistol' },
        { 'weapon_minismg', 'Mini SMG' },
    },
    shotguns = {
        { 'weapon_pumpshotgun', 'Pump Shotgun' }, { 'weapon_pumpshotgun_mk2', 'Pump Shotgun Mk II' },
        { 'weapon_sawnoffshotgun', 'Sawed-Off Shotgun' }, { 'weapon_assaultshotgun', 'Assault Shotgun' },
        { 'weapon_bullpupshotgun', 'Bullpup Shotgun' }, { 'weapon_musket', 'Musket' },
        { 'weapon_heavyshotgun', 'Heavy Shotgun' }, { 'weapon_dbshotgun', 'Double Barrel Shotgun' },
        { 'weapon_autoshotgun', 'Sweeper Shotgun' }, { 'weapon_combatshotgun', 'Combat Shotgun' },
    },
    rifles = {
        { 'weapon_assaultrifle', 'Assault Rifle' }, { 'weapon_assaultrifle_mk2', 'Assault Rifle Mk II' },
        { 'weapon_carbinerifle', 'Carbine Rifle' }, { 'weapon_carbinerifle_mk2', 'Carbine Rifle Mk II' },
        { 'weapon_advancedrifle', 'Advanced Rifle' }, { 'weapon_specialcarbine', 'Special Carbine' },
        { 'weapon_specialcarbine_mk2', 'Special Carbine Mk II' }, { 'weapon_bullpuprifle', 'Bullpup Rifle' },
        { 'weapon_bullpuprifle_mk2', 'Bullpup Rifle Mk II' }, { 'weapon_compactrifle', 'Compact Rifle' },
        { 'weapon_militaryrifle', 'Military Rifle' }, { 'weapon_heavyrifle', 'Heavy Rifle' },
    },
    precision = {
        { 'weapon_sniperrifle', 'Sniper Rifle' }, { 'weapon_heavysniper', 'Heavy Sniper' },
        { 'weapon_heavysniper_mk2', 'Heavy Sniper Mk II' }, { 'weapon_marksmanrifle', 'Marksman Rifle' },
        { 'weapon_marksmanrifle_mk2', 'Marksman Rifle Mk II' },
    },
    melee = {
        { 'weapon_knife', 'Knife' }, { 'weapon_nightstick', 'Nightstick' },
        { 'weapon_hammer', 'Hammer' }, { 'weapon_bat', 'Baseball Bat' },
        { 'weapon_crowbar', 'Crowbar' }, { 'weapon_golfclub', 'Golf Club' },
        { 'weapon_bottle', 'Bottle' }, { 'weapon_dagger', 'Dagger' },
        { 'weapon_hatchet', 'Hatchet' }, { 'weapon_knuckle', 'Knuckle Dusters' },
        { 'weapon_machete', 'Machete' }, { 'weapon_flashlight', 'Flashlight' },
        { 'weapon_switchblade', 'Switchblade' }, { 'weapon_poolcue', 'Pool Cue' },
        { 'weapon_wrench', 'Wrench' }, { 'weapon_battleaxe', 'Battle Axe' },
    },
}

Config.Weapons = {}
for _, groupName in ipairs({ 'sidearms', 'compact', 'shotguns', 'rifles', 'precision', 'melee' }) do
    local group = WEAPON_GROUPS[groupName]
    for i = 1, #group do
        Config.Weapons[#Config.Weapons + 1] = { name = group[i][1], label = group[i][2] }
    end
end

Config.VehicleTypes = buildTypeCatalog({
    { 'car', 'Passenger Car', 'car' }, { 'sedan', 'Sedan', 'car' },
    { 'coupe', 'Coupe', 'car' }, { 'compact', 'Compact', 'car' },
    { 'muscle', 'Muscle Car', 'car' }, { 'sports', 'Sports Car', 'car' },
    { 'sports_classic', 'Classic Sports Car', 'car' }, { 'super', 'Supercar', 'car' },
    { 'suv', 'SUV', 'truck' }, { 'truck', 'Truck', 'truck' },
    { 'van', 'Van', 'truck' }, { 'motorcycle', 'Motorcycle', 'car' },
    { 'bicycle', 'Bicycle', 'car' }, { 'off_road', 'Off-Road Vehicle', 'truck' },
    { 'utility', 'Utility Vehicle', 'truck' }, { 'industrial', 'Industrial Vehicle', 'truck' },
    { 'service', 'Service Vehicle', 'truck' }, { 'commercial', 'Commercial Vehicle', 'truck' },
    { 'emergency', 'Emergency Vehicle', 'truck' }, { 'military', 'Military Vehicle', 'truck' },
    { 'helicopter', 'Helicopter', 'car' }, { 'plane', 'Aircraft', 'car' },
    { 'boat', 'Watercraft', 'car' },
})

-- ============================================================================
-- Resources / debug
-- ============================================================================

--[[
    ONLY CHANGE THIS PART IF YOU HAVE RENAMED SCRIPTS SUCH AS OBJECT GIZMO, SCREENSHOT-BASIC
--]]
Resources = {
    SCREENBASIC = { name = 'screenshot-basic', export = 'all' },
    OBJECTGIZMO = { name = 'object_gizmo', export = 'all' },
}

-- leave false in prod — debug logs are noisy and can dump record data
Config.ShowDebugPrints = false
ShowDebugPrints = Config.ShowDebugPrints -- keep in sync for any external readers
