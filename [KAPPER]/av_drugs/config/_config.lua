Config = {}
Config.Debug = false
Config.Target = exports['av_laptop']:getTarget()
Config.PurityField = "purity" -- Metadata field name for drugs

-- If the sv restart is in the next X minutes, cooking function will stop working to prevent players from losing their ingredients
-- Requires txAdmin for this, check server/editable/restart.lua
Config.PreventCooking = 30 -- minutes (number) or false... Max number can be 30, TxAdmin only sends this alert 30, 15, 10, 5, 4, 3, 2, 1 minutes before restart

-- police jobs names/types for labs and tables seizure, also used to not allow this jobs for corner sell
-- if using job types (qb and qbx) don't add duplicated jobname and type (ex. don't use "police" and "leo" or it will count cops twice server side)
Config.PoliceJobs = {
    "police",
    "bcso",
    "fbi",
}
Config.App = { -- Read this to know how to restrict an APP: https://docs.av-scripts.com/laptop-pack-v3/laptop-v3/apps-config
    name = "chef",
    label = "Chef", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end