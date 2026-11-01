Config = Config or {}
Config.DistanceUnit =
"miles"                       -- "KM" or "miles" (To modify the text in UI go to av_laptop/build/lang.json and search distance_unit)
Config.Blips = {              -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
    Route = { Color = 6 },
    Generic = { Size = 1.0, Color = 38 },
    Next = { Size = 1.3, Color = 47 },
    Passed = { Size = 0.6, Color = 62 }
}
Config.CheckpointSound = true                            -- Trigger a sound when u reach a waypoint
Config.FlareTime = 10                                    -- In seconds
Config.StartAndFinishModel = `prop_offroad_tyres02`      -- Used for start/finish checkpoint, needs to be a valid model
Config.CheckpointPileModel =
`xm_prop_base_tripod_lampa`                              -- Used as default checkpoint and for preview. Object hash | false
Config.MinimumCheckpoints = 5                            -- Minimum Checkpoints required for a race
Config.JoinDistance = 100                                -- Distance between player and race for check in
Config.MaxTimeDNF = 5                                    -- Max time (in minutes) players have to complete the race after the 1st place has finish it, all the racers who haven't completed it will be marked as DNF.
Config.EventExpirationTime = 5                           -- Max time (in minutes) before removing an event that has reached it starting time and has not being started
Config.RouteDistance = 150                               -- It won't render the route in GPS if the distance between your current checkpoint and the next one is less than X meters.
Config.AllowPassengers = true                            -- Allow passengers to join races and see checkpoints/UI, they don't have to pay any money and they won't receive anything if they are in the winning vehicle
Config.WinnersPrizes = {                                 -- Divide the prize pot with the 1st, 2nd and 3rd place from a total of 100%
    [1] = 70,                                            --% Percentage for 1st place
    [2] = 20,                                            --% Percentage for 2nd place
    [3] = 10,                                            --% Percentage for 3rd place
    -- The total from all places can't be more than 100%, otherwise the script will ignore your values and give the 100% to 1st place and 0 to all other places
}
Config.WaypointsToRender = 3 -- Amount of checkpoint waypoints to render during a race
Config.MinRacersRecord = 5   -- In order to update a player record, the race needs at least X racers competing, otherwise no records (races / wins) will be updated for anyone in race
Config.MaxBlipsRender = 15   -- blips to render at the same time, to prevent the 100 limit from GTA
Config.GhostLoopWait = 20    -- Time in ms between each loop of the ghost system, you can increase it if you are having performance issues, but it may cause the ghost to be less accurate
Config.CrewWinRecord = 5     -- Min participants required for crew wins to count, preventing stat manipulation

--[[
    Available models for checkpoint when creating/editing a circuit
]]
Config.CheckpointModels = {
    'xm_prop_base_tripod_lampa',
    'prop_offroad_tyres02', -- Start/Finish default model
    'prop_rub_pile_04',
    'prop_dock_bouy_3',     -- For water checkpoints
    'prop_dock_bouy_2',     -- For water checkpoints
    --    'bzzz_checkpoint_a', -- if using bzzz checkpoints https://bzzz.tebex.io/package/6459195
    --    'bzzz_prop_light_tube_a', -- if using bzzz lights https://bzzz.tebex.io/package/5834472
}

--[[
    Ghost Replay
    follows a previously recorded run (your personal best and/or the track record)
]]
Config.GhostReplay = {
    enabled = true,               -- master switch; per-player on/off lives in App > Settings
    sampleMs = 150,               -- How often does the ghost system sample the player position? lower number is more accurate but more expensive for CPU/network
    alpha = 200,                  -- 0-255 transparency of the ghost car
    bestColor = { 41, 121, 255 }, -- RGB tint for the personal-best ghost (blue)
    recordColor = { 212, 175, 55 }, -- RGB tint for the track-record ghost (gold)
}

--[[
    Race Path
    OFF for every racer by default: each player turns it on for themselves in
    App > Settings, where they also pick its color. `enabled` below is the server-wide
    master switch -- set it to false and the option disappears from Settings entirely.
]]
Config.RacePath = {
    enabled = true,                           -- master switch; false hides the option from App > Settings
    color = { r = 0, g = 200, b = 255 },      -- default arrow color before the player picks one
    brakeColor = { r = 255, g = 45, b = 45 }, -- arrows where the record driver was braking
    brakeDrop = 5.0,                          -- km/h lost between samples to count as braking (lower = more red)
    opacity = 100,                            -- default arrow opacity (0-100) before the player picks one
    spacing = 4.0,                            -- meters between arrows
    arrowLength = 4.0,                        -- arrow size along the road
    arrowWidth = 3.0,                         -- arrow size across the road
    viewDistance = 80.0,                      -- how far ahead arrows are drawn
    behindDistance = 10.0,                    -- how far behind the car they linger before fading
    alpha = 200,                              -- brightest point of the flowing wave (0-255)
    minAlpha = 60,                            -- dimmest point of the wave (0-255)
    flowFreq = 0.35,                          -- how tight the wave pattern is along the road
    flowSpeed = 0.004,                        -- how fast the wave travels toward the checkpoint
    zOffset = 0.01,                           -- lift above the asphalt to avoid z-fighting
    rebuildInterval = 3000,                   -- ms between refreshes of the sampled road route
}

Config.Rewind = {
    enabled = true,    -- master switch; when false the option disappears from event creation
    distance = 100.0,  -- how far back (meters) the racer is placed; the closest buffered point at or beyond this
    history = 20,      -- seconds of driving kept in memory to search through
    cooldown = 10,     -- seconds the racer must wait between rewinds
    animationMs = 700, -- how long the car takes to fly back along its own line (0 = instant)
    sampleMs = 250,    -- how often the car position is buffered (lower = finer rewind points but more CPU usage)
}
