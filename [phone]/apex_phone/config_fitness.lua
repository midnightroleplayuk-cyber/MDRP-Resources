-- ------------------------------------------------------------
-- FITNESS (app "Fitness" on PearOS, "Saúde" on Nova UI)
-- The client (client/fitness.lua) samples the player once per second while alive and
-- outside the pause menu: metres walked, metres run, metres in a vehicle and active
-- seconds. Every `flushSeconds` the deltas go to the server (server/fitness.lua), which
-- validates them against the real time elapsed (a player cannot walk faster than 12 m/s,
-- a vehicle faster than 120 m/s), stores one row per character and day
-- (apex_phone_fitness), computes steps and calories from the metres, keeps the goals,
-- the streak and the awards, and notifies the player when a ring closes or an award
-- unlocks. The day is the SERVER's local date (the client has no real clock).
-- Steps: 0.75 m per step walking, 1.1 m running. Calories: 0.052 kcal per metre
-- walking, 0.075 kcal per metre running (a 70 kg person); driving burns nothing.
-- ------------------------------------------------------------
Config.Fitness = {
    enabled = true,           -- false hides the tracker and the app answers "disabled"
    sampleSeconds = 1,        -- how often the client measures (seconds, minimum 0.5)
    flushSeconds = 60,        -- how often the client sends its deltas to the server
    liveSeconds = 5,          -- how often the client refreshes the rings of an open app (NUI push)
    -- default daily goals (each character can change them in the app, inside these limits)
    goals = { kcal = 400, minutes = 30, steps = 8000 },
    limits = {
        kcal = { min = 100, max = 3000 },
        minutes = { min = 5, max = 300 },
        steps = { min = 1000, max = 50000 },
    },
    awards = true,            -- false: no medals and no "award unlocked" notifications
    notifyRings = true,       -- notification when a ring closes (once per ring per day)
    keepDays = 365,           -- days of history kept per character (older rows are deleted at start)
}
