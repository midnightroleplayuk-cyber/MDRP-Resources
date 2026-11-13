Config = {}

-- 'auto' | 'qbox' | 'qbcore' | 'esx'
Config.Framework = 'auto'

-- Shown at the top of the app. Leave nil to use sv_projectName.
Config.ForceName = nil

-- Jobs that count as police. Qbox/QBCore jobs with type = 'leo' also count.
Config.PoliceJobs = { police = true, sheriff = true }

-- In-game commands
Config.Commands = {
    link   = 'mdtlink',   -- shows a 6-digit pairing code
    unlink = 'mdtunlink', -- signs out every phone linked to this character
}

-- Notification style for the pairing code: 'ox_lib' | 'qb' | 'esx' | 'chat'
Config.Notify = 'ox_lib'

Config.Pairing = {
    codeLifetime   = 120, -- seconds a pairing code stays valid
    maxDevices     = 3,   -- phones per character; oldest is signed out when exceeded
    attemptsPerMin = 5,   -- failed pairing attempts allowed per IP per minute
}

Config.Access = {
    -- Officer must be in the city and on duty to use the app (recommended for RP).
    requireInCity = true,
    requireOnDuty = true,

    -- Optional out-of-city read-only access for senior ranks (e.g. command staff).
    -- Only used when requireInCity = true and the officer is not in the city.
    offlineReadOnly = {
        enabled  = false,
        minGrade = 8,
    },

    requestsPerMin = 60, -- per phone
}

-- How long a linked phone stays signed in without being used (days).
Config.TokenIdleDays = 14

-- Hook into Vinewood MDT exports when available (see README for the contract).
Config.MDT = {
    resource = 'vinewood_mdt',
    exports = {
        searchPeople  = 'MobileSearchPeople',
        getProfile    = 'MobileGetProfile',
        searchVehicle = 'MobileSearchVehicle',
        getWarrants   = 'MobileGetWarrants',
        getBolos      = 'MobileGetBolos',
        createBolo    = 'MobileCreateBolo',
    },
}

-- Record every lookup made from the app (who searched what, when).
Config.Audit = true
