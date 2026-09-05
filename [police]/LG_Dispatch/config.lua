Config = {}

-- Framework detection: 'auto', 'qbcore', 'esx', 'tmc', 'qbox'
Config.Framework = 'auto'

Config.UseLGModsCAD = false -- leave false, for now...

-- Keybind to open dispatch UI
Config.OpenKey = 'F3'

-- Jobs considered emergency services
Config.EligibleJobs = {
    ['police']    = { label = 'Police',    type = 'police', icon = 'shield-halved', color = '#3b82f6' },
    ['ambulance'] = { label = 'Ambulance',       type = 'Ambulance',    icon = 'heart-pulse',  color = '#22c55e' }
}

-- Unit statuses
Config.Statuses = {
    { id = 'available',  label = 'Available',  color = '#22c55e' },
    { id = 'busy',       label = 'Busy',       color = '#f59e0b' },
    { id = 'enroute',    label = 'En Route',   color = '#3b82f6' },
    { id = 'onscene',    label = 'On Scene',   color = '#8b5cf6' },
    { id = 'atstation',  label = 'At Station', color = '#64748b' },
    { id = 'offduty',    label = 'Off Duty',   color = '#6b7280' },
}

-- Call priorities
Config.Priorities = {
    { id = 1, label = 'Grade 1 - Immediate',     color = '#ef4444' },
    { id = 2, label = 'Grade 2 - Prompt',        color = '#f59e0b' },
    { id = 3, label = 'Grade 3 - Standard',      color = '#3b82f6' },
    { id = 4, label = 'Grade 4 - Scheduled',     color = '#64748b' },
}

-- Call types with defaults
Config.CallTypes = {
    ['999']       = { label = '999 Emergency Call',    defaultPriority = 2, blip = true,  blipSprite = 480, blipColor = 1,  blipDuration = 30, autoExpire = 1800 },
    ['panic']     = { label = 'Officer Assistance',    defaultPriority = 1, blip = true,  blipSprite = 526, blipColor = 1,  blipDuration = 60, autoExpire = 900  },
    ['robbery']   = { label = 'Robbery in Progress',   defaultPriority = 1, blip = true,  blipSprite = 156, blipColor = 1,  blipDuration = 45, autoExpire = 1200 },
    ['shooting']  = { label = 'Firearms Discharge',    defaultPriority = 1, blip = true,  blipSprite = 110, blipColor = 1,  blipDuration = 45, autoExpire = 1200 },
    ['traffic']   = { label = 'Vehicle Stop',          defaultPriority = 3, blip = true,  blipSprite = 326, blipColor = 38, blipDuration = 20, autoExpire = 1800 },
    ['medical']   = { label = 'Medical Assistance',    defaultPriority = 2, blip = true,  blipSprite = 153, blipColor = 2,  blipDuration = 30, autoExpire = 1200 },
    ['fire_call'] = { label = 'Fire Incident',         defaultPriority = 2, blip = true,  blipSprite = 436, blipColor = 1,  blipDuration = 30, autoExpire = 1200 },
    ['general']   = { label = 'Incident Log',          defaultPriority = 3, blip = false, blipSprite = 1,   blipColor = 0,  blipDuration = 0,  autoExpire = 3600 },
}

-- GPS update interval (ms) for live unit tracking
Config.GPSUpdateInterval = 2000

-- Ignore similar calls within this radius (game units) and time (seconds)
Config.DedupeRadius = 50.0
Config.DedupeTime = 10

-- Sounds
Config.Sounds = {
    newCall = true,
    panic   = true,
}

-- Permissions (minimum job grade required per job)
-- Keys must match the job names in Config.EligibleJobs.
-- Use ['*'] as a fallback for any job not explicitly listed.
Config.Permissions = {
    closeCalls = {
        police    = 0,   -- Police: Grade 0+
        ambulance = 0,   -- Ambulance: Grade 0+, I've set these as examples ofc you can put whatever jobs you want here
    },
    editPriority = {
        police    = 2,   
        ambulance = 2,   
    },
    addNotes = {
        police    = 3,  
        ambulance = 2,   
    },
    createCalls = {
        police    = 0,   
        ambulance = 0,  
    },
    manageUnits = {
        police    = 2,  
    },
    mergeCalls = {
        police    = 2, 
    },
    placeMarkers = {
        police    = 2,   
    },
}

-- Callsign validation Lua pattern (empty string = no validation)
-- Example: '^%u%u%d%d$' requires two uppercase letters + two digits
Config.CallsignRegex = ''

-- Show off-duty units on map
Config.ShowOffDutyOnMap = false

-- Default call expiry in seconds (0 = never)
Config.DefaultCallExpiry = 3600

-- Notification style: 'toast' | 'chat'
Config.NotificationStyle = 'toast'

-- Unit trail breadcrumb settings (stored in memory, reset on restart)
Config.UnitTrailLength = 50
Config.UnitTrailInterval = 3

-- Discord webhook for call notifications (leave empty to disable)
Config.DiscordWebhook = ''
Config.DiscordBotName = 'LG Dispatch'
Config.DiscordBotAvatar = 'https://media.discordapp.net/attachments/1238207587887874118/1384714689350729808/lg_logo_solo.png?ex=69a98ccc&is=69a83b4c&hm=204f314cf5cf31a0cd2ab07c8f055a6af2a763b06b7fbb1a556a0199aa34a500&=&format=webp&quality=lossless&width=1895&height=1895'
