cfg = cfg or {} cfg.settings = cfg.settings or {}


cfg.settings.ui = {
    primary_color = 'rgb(134, 11, 250)',
    vehicle_image_directory = "vehicle_images/",
    image_format = ".png",  -- Item Images ( Vehicles are Stored as webp )
}

cfg.settings.currency = {
    boosting = "XNT",
}

-- For Specifc Blips (Most are in config/shared/tasks.lua)
cfg.settings.blip_theme = { --https://docs.fivem.net/docs/game-references/blips/#blip-colors
    blip_color = 83, 
    route_color = 83,
    radius_color = 3,
}

cfg.settings.gameplay = {
    car_spawn_healthy = true,       -- Max Fuel, Vehicle Health, Engine Health ( If False you can save vehicles with lower engine health, body health and fuel amount)
    stop_vehicle_givekey = false,   -- If your framework/keys do not give keys from dead npcs set true
    contract_timer = 60,            -- 60 Minutes until contract force ends vehicle will automatically delete
    police_onduty = false,          -- Require police to be on duty aswell.
    police_jobs = {["police"] = true, ["sheriff"] = true},    -- Police Jobs
    delete_item = {
        ["gg_rattle_can"] = true,
        ["gg_signal_jammer"] = true,
        ["gg_boost_plate"] = true,
        ["gg_tracker_scrambler"] = false,   -- Item should delete on use
        ["gg_wire_cutters"] = false,
    }
}

cfg.settings.progression = {
    show_locked_rewards = true,     -- Can view locked rewards on progression page
}

cfg.settings.contracts = {
    allow_transfers = true,         -- True to allow users to transfer contracts to eachother
    transfer_fee = 5,               -- 5 XNT to transfer contract (SET 0 to Remove FEE)
    transfer_restrict_level = true, -- Ensure reciever is high enough level for the contract.
    split_payout = true,            -- Group splits boost payout equally.
    vin_scratch = true,             -- Can start a vin scratch mission
    vin_scratch_level_req = 25,     -- Player must be level 25 to initiate a boost.
    vin_scratch_cost = 300,         -- 300% Value of vehicle contract payout (EX: Payout = 100, Vin Cost would be 300) payout * 3
}

cfg.settings.vinscratch = {
    total_vinscratch_daily = 25,    -- Global vinscratch limit per 24h (reset daily)
    player_vinscratch_limit = 1,    -- How many vinscratches a player can do
    player_reset_time = 7,          -- Reset period in days for the above limit


    -- EXPORT TO CHECK IF VEHICLES ARE VINSCRATCHES
    -- https://gg-studio.gitbook.io/gg-studio-docs/gg-studio-scripts/advanced-boosting-system/api/exports/client
}


cfg.settings.unlocks = {
    refresh_time = 60,               -- Time (in minutes) until player can claim a new free contract
}

cfg.settings.store = {
    restock_time = 120,
}

cfg.settings.market = {
    total_sell_limit = 250,            -- Max contracts allowed on the market at once
    contracts_page = 40,               -- Contracts per page on market place ui
    user_sell_limit = 4,               -- Max contracts a single user can list
    sell_time = 120,                   -- Duration (in minutes) a contract stays listed
    min_contract_time_required = 180,  -- Minimum remaining time (in minutes) for a contract to be eligible for listing

    min_vehicle_sell_value = 35,       -- Minimum sell value as % of payout
    max_vehicle_sell_value = 100,      -- Maximum sell value as % of payout

    require_level_class = true,        -- Player must be high enough level to buy a certain class of vehicle.
}

cfg.settings.market_automation = {
    enabled = true,                     -- Automatically add contracts to market
    start_loop_instantly = false,       -- Should the cars be added instantly on server restart or wait out one iteration.
    interval = 5,                       -- Time interval (in minutes) for auto-adding server contracts
    max_server_listings = 50,           -- Maximum number of server-generated listings allowed
    market_endtime      = 60,           -- How long the contract will be on market in minutes
    vehicle_cost_range = {              -- Vehicle cost range as a % of payout
        min = 30,
        max = 70
    },
    seller_names = {                    -- Server seller aliases (PLAYERS CAN NOT USE THESE NAMES IF THEY ARE IN THIS LIST)
        "puppetmaster",
        "blacklotus",
        "ghostbroker",
        "nightvendor",
        "wireman",
        "phantomdeal",
        "fixerx",
        "darkagent",
        "gridlock",
        "ironshade"
    },
}

cfg.settings.popup = {
    enabled = true,         -- Show the popup task (true = on, false = off)
    keybind = "J",          -- Key to toggle the popup (e.g. "J")
    height = 79,            -- Position of popup on screen (1 = top, 100 = bottom)
    vehicle_height = 65,    -- Position of popup on screen (WHILE IN VEHICLE) (1 = top, 100 = bottom)
    location = 'left',      -- Side of screen the popup appears on ("left" or "right")
}

cfg.settings.webhooks = {
    bot_name = "GG Studio", -- Change to server name
    bot_avatar = "https://i.ibb.co/37yPN9F/logo-purple-white.png", -- Image of the bot profile picture
    job_finish = "",      -- Add webhook here Ex: https://discord.com/api/webhooks/xxx/xxx
}





-- IGNORE
-- IGNORE
-- IGNORE
-- AUTO ADDS POLICE FOR DISPATCH (IGNORE)
cfg.settings.gameplay.police_dispatch = {}
for k,v in pairs(cfg.settings.gameplay.police_jobs) do if v then table.insert(cfg.settings.gameplay.police_dispatch, k) end end
cfg.settings.mounted = true -- Ignore used to check for syntax errors