Config = {}

-- 'auto' | 'qbox' | 'qbcore' | 'esx'
Config.Framework = 'auto'

-- Name of the MDT resource folder.
Config.MDTResource = 'vinewood-mdt'

-- Shown on the sign-in screen. Leave nil to use sv_projectName.
Config.ForceName = nil

-- Website: officers open https://<your-server>/vinewood_mdt_mobile/ in any browser.
-- Set false to only allow the Android app.
Config.Website = true

-- In-game commands
Config.Commands = {
    link   = 'mdtlink',   -- /mdtlink 123456 approves the code shown on the app or website
    unlink = 'mdtunlink', -- signs out every phone and browser linked to this character
}

-- Notification style: 'ox_lib' | 'qb' | 'esx' | 'chat'
Config.Notify = 'ox_lib'

Config.Pairing = {
    codeLifetime = 180, -- seconds a sign-in code shown on the app or website stays valid
    maxDevices   = 3,   -- phones/browsers per character; the oldest is signed out when exceeded
    startsPerMin = 6,   -- sign-in codes each IP can request per minute
}

-- Requests per minute per device. The MDT makes several requests per page.
Config.RequestsPerMin = 240

-- How long a linked device stays signed in without being used (days).
Config.TokenIdleDays = 14
