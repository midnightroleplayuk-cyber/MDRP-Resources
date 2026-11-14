Config = {}

-- 'auto' | 'qbox' | 'qbcore' | 'esx'
Config.Framework = 'auto'

-- Name of the MDT resource folder.
Config.MDTResource = 'vinewood-mdt'

-- Shown on the app's sign-in screen. Leave nil to use sv_projectName.
Config.ForceName = nil

-- In-game commands
Config.Commands = {
    link   = 'mdtlink',   -- shows a 6-digit pairing code
    unlink = 'mdtunlink', -- signs out every phone linked to this character
}

-- Notification style for the pairing code: 'ox_lib' | 'qb' | 'esx' | 'chat'
Config.Notify = 'ox_lib'

Config.Pairing = {
    codeLifetime   = 120, -- seconds a pairing code stays valid
    maxDevices     = 3,   -- phones per character; the oldest is signed out when exceeded
    attemptsPerMin = 5,   -- failed pairing attempts allowed per IP per minute
}

-- Requests per minute per phone. The MDT makes several requests per page.
Config.RequestsPerMin = 240

-- How long a linked phone stays signed in without being used (days).
Config.TokenIdleDays = 14
