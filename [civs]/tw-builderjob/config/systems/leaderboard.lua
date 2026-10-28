-- ====================================================================
-- LEADERBOARD
-- ====================================================================
-- Top-players tab in the job menu (money earned / jobs finished).
-- `Config = Config or {}` is required: this file may load before config.lua.
-- ====================================================================
Config = Config or {}

Config.Leaderboard = {
    -- When disabled the tab is hidden from the menu as well.
    enabled = true,

    -- Rows per metric. The server queries top money and top jobs separately and
    -- merges them, so at most 2 x limit rows are sent.
    limit = 10,

    -- Query cache (seconds). 0 = off. Finishing a job invalidates the cache anyway.
    cacheSeconds = 60,

    -- Minimum lifetime earnings to be listed. 0 = everyone, 1 = at least one finished job.
    minMoney = 1,
}
