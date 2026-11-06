Config = {}

-- ─────────────────────────────────────────────────────────────
-- Branding (shown in the MDT header)
-- ─────────────────────────────────────────────────────────────
Config.Branding = {
    serviceName = 'Fire & Rescue Service',
    shortName   = 'FRS',
    controlName = 'Fire Control',   -- what the control room is called in messages
    logo        = '',               -- optional URL or nui://vinewood_firemdt/html/logo.png
}

-- 'auto' detects qbx_core → qb-core → es_extended
Config.Framework = 'auto'

-- Jobs allowed to use the MDT
Config.Jobs = { fire = true }

-- Only works while on duty (QB/Qbox). ESX is always treated as on duty.
Config.RequireDuty = true

-- Minimum job grade for each permission
Config.Grades = {
    control      = 3,   -- create incidents, mobilise appliances, close incidents
    editHydrants = 0,   -- add hydrants / report defects
    editRisks    = 2,   -- create & edit operational risk (SSRI) records
    editSops     = 4,   -- edit policies & procedures
}

-- Players with these jobs get the control tab regardless of grade (a dedicated control room job)
Config.ControlJobs = { firecontrol = true }

-- ─────────────────────────────────────────────────────────────
-- Opening the MDT
-- ─────────────────────────────────────────────────────────────
Config.Command   = 'firemdt'
Config.Keybind   = 'F6'          -- players can rebind in Settings > Key Bindings > FiveM

-- Only open while sat in an appliance (set false to allow anywhere, e.g. at station)
Config.RequireVehicle = false
-- Vehicle models that count as appliances when RequireVehicle = true. Class 18 (emergency) also counts if AllowEmergencyClass.
Config.ApplianceModels = { 'firetruk' }
Config.AllowEmergencyClass = true

-- ─────────────────────────────────────────────────────────────
-- Status codes (bottom strip). Edit to match your brigade.
-- ─────────────────────────────────────────────────────────────
Config.Statuses = {
    { code = 0, label = 'Priority',             colour = '#C8102E', emergency = true },
    { code = 1, label = 'Mobile & available',   colour = '#2E9E5B' },
    { code = 2, label = 'Available at station', colour = '#2E9E5B' },
    { code = 3, label = 'Mobile to incident',   colour = '#F2C200' },
    { code = 4, label = 'In attendance',        colour = '#E07B00' },
    { code = 5, label = 'Available at scene',   colour = '#3B82C4' },
    { code = 6, label = 'Returning',            colour = '#3B82C4' },
    { code = 7, label = 'Unavailable',          colour = '#6B747D' },
}
Config.DefaultStatus  = 2
Config.MobileStatus   = 3   -- set automatically when a unit accepts a mobilisation
Config.AttendStatus   = 4   -- set automatically when a unit arrives (see AutoAttendDistance)
Config.AutoAttendDistance = 40.0  -- metres; 0 disables auto status 4

-- ─────────────────────────────────────────────────────────────
-- Incident types & messages
-- ─────────────────────────────────────────────────────────────
Config.IncidentTypes = {
    'Fire - Dwelling',
    'Fire - Commercial',
    'Fire - Vehicle',
    'Fire - Secondary (grass/refuse)',
    'Road Traffic Collision',
    'RTC - Persons trapped',
    'Automatic Fire Alarm',
    'Hazardous Materials',
    'Rescue - Water',
    'Rescue - Height / Confined space',
    'Special Service',
    'Assist Ambulance',
    'Assist Police',
}
Config.Priorities = { 'Category 1', 'Category 2', 'Category 3' }

-- Quick assistance messages (sent as "Make ..." messages)
Config.AssistanceMessages = {
    'Make pumps 2', 'Make pumps 4', 'Make pumps 6', 'Make pumps 8',
    'Make aerial 1', 'Make rescue tender 1', 'Make HazMat officer',
    'Make ambulance', 'Make police', 'Make water carrier',
}

-- Stop message behaviour
Config.StopMessageClosesIncident = false -- if true, any stop message closes the incident

-- Incident reference: prefix .. yymmdd .. '-' .. id
Config.IncidentPrefix = 'FR'

-- ─────────────────────────────────────────────────────────────
-- Map / navigation
-- ─────────────────────────────────────────────────────────────
Config.HoseLength = 25          -- metres per length (UK standard 45/70mm length)
Config.MapMinRange = 60         -- metres shown at closest zoom
Config.MapMaxRange = 1500       -- metres shown at widest auto zoom
Config.UnitBroadcastInterval = 3000   -- ms between appliance position updates
Config.RiskAlertExtra = 50.0    -- metres added to a risk site's radius when flagging incidents
Config.HydrantSearchRadius = 250.0

-- Map background image (any top-down GTA map). Bounds are the world coordinates at the image edges.
-- If markers sit slightly off, use the Calibrate button on the MDT map (Fire Control only),
-- then paste the values it prints in F8 here.
Config.MapImage = {
    enabled = true,
    file = 'map.jpg',          -- inside html/
    minX = -5758.0, maxX = 6815.0,   -- left / right edge
    minY = -4118.0, maxY = 8453.0,   -- bottom / top edge
    dim = 0.35,                -- darken the image so markers stand out (0 = off)
    sea = '#0f8fb5',           -- fill outside the image edges
    -- The image fades to the plain grid when zoomed in further than it has detail for.
    -- Upscale factor = screen pixels per image pixel. A higher-res image (e.g. 8192 px) keeps it visible closer in.
    fadeStart = 3.0,
    fadeEnd   = 6.0,
}

-- Hydrant types and statuses
Config.HydrantTypes    = { 'Underground', 'Pillar', 'Dry riser inlet', 'Wet riser', 'Open water' }
Config.HydrantStatuses = { 'Serviceable', 'Defective', 'Out of service' }

-- GTA world hydrant props that can be scanned near you
Config.WorldHydrantProps = { 'prop_fire_hydrant_1', 'prop_fire_hydrant_2', 'prop_fire_hydrant_4', 'prop_fire_driser_1a' }

-- Risk levels for SSRI
Config.RiskLevels = {
    { level = 1, label = 'Level 1 - Low',    colour = '#2E9E5B' },
    { level = 2, label = 'Level 2 - Medium', colour = '#F2C200' },
    { level = 3, label = 'Level 3 - High',   colour = '#C8102E' },
}

-- ─────────────────────────────────────────────────────────────
-- Sounds (generated in the NUI, no files needed)
-- ─────────────────────────────────────────────────────────────
Config.MobiliseTone = true
Config.MobiliseVolume = 0.35

-- ─────────────────────────────────────────────────────────────
-- Notifications (edit to your notify of choice)
-- ─────────────────────────────────────────────────────────────
Config.Notify = function(msg, kind)
    lib.notify({ title = Config.Branding.shortName .. ' MDT', description = msg, type = kind or 'inform' })
end
