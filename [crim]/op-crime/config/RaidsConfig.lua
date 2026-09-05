-- ──────────────────────────────────────────────────────────────────────────────
-- Police Raids Configuration
-- (Information) ► Configure Jobs that are allowed to raid gangs
-- ──────────────────────────────────────────────────────────────────────────────

Config.Raids = {

    -- Enable or disable the entire raid system
    enable = true,
    commandName = "startraid",

    -- Jobs that are allowed to start raids
    allowedJobs = {
        ['police'] = {
            minimumGradeToStart = 2, -- Minimum job grade required to start a raid
        },
    },

    -- Cooldown settings
    raidCooldownPerJob  = 2,   -- Cooldown (in hours) per job after starting a raid
    raidCooldownPerGang = 24,  -- Cooldown (in hours) before the same gang can be raided again

    -- Time window when raids are allowed
    raidTime = {

        -- WARNING: Make sure you configured correct Config.TimeZone in MainConfig.lua
        -- INFORMATION: Use 24 hours time format

        startTime = "00:00", -- Raids can start from this hour
        endTime   = "11:00", -- Raids can start until this hour
    },

    -- Display blips for raiding officers
    -- Set to false for more serious RP (no automatic gang location)
    displayBlips = true,

    -- Elements that can be seized during a raid
    raidableElements = {
        stash       = true, -- Gang stash
        money       = true, -- Clean money
        dirty_money = true, -- Dirty money
    },

    -- Admin approval mode
    -- When enabled, an admin must approve each raid manually
    adminMode = {
        enable = false,              -- Enable admin approval requirement
        commandToApprove = "approveraid", -- Command used by admins to approve a raid
    },

    -- Minimum Gang members online
    minimumGangPlayersOnline = 0,
    -- Minimum Job members online
    minimumJobPlayersOnline = 1,

    -- Raid duration
    raidDuration = 30, -- Duration of the raid in minutes

    -- Inform Online Gang Members about Raid.
    informGang = true
}