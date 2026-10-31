return {
    debugMode = false,      -- Display Debug Information
    notifications = "ox",   -- [ox, qb, esx] [defaults ox]
    ProgressBar = "ox",     -- [ox, qb, esx] [defaults ox]

    -- OVERIDES (This Will Override The Auto Detection and Can Lead to Issues if Resource Does Not Exist)
    framework = "", -- [Leave Blank For Auto Detection] - OPTIONS https://gg-studio.gitbook.io/gg-studio-docs/gg-studio-scripts/advanced-boosting-system/dependencies
    inventory = "", -- [Leave Blank For Auto Detection] - OPTIONS https://gg-studio.gitbook.io/gg-studio-docs/gg-studio-scripts/advanced-boosting-system/dependencies
    target = "",    -- [Leave Blank For Auto Detection] - OPTIONS https://gg-studio.gitbook.io/gg-studio-docs/gg-studio-scripts/advanced-boosting-system/dependencies
    dispatch = "",  -- [Leave Blank For Auto Detection] - OPTIONS ???

    -- FUEL & KEYS HANDLED INSIDE (gg_boosting/core/lib/miniBridge/client.lua)

    
    -- Add your license here if the admin tab is missing
    -- Find a player's license in txAdmin (Player List)
    -- Use format: license:xxx or license2:xxx
    admins = {
        ["license:example"] = true,
        ["license2:6e713bc45df69b1338e94c292948ef0053ffb638"] = true,
    }
}