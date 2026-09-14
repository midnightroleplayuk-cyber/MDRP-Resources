if not Config then Config = {} end

-- All configuration is stored in database and can be changed in-game via the
-- editor command below (Config.Command) or /admindevhub

Config.Debug = false

Config.Command = 'pettyCrimes'

Config.Activities = Config.Activities or {}

-- ─────────────────────────────────────────────────────────────────────────────
-- DISPATCH
-- ─────────────────────────────────────────────────────────────────────────────
-- Called on the SERVER every time an activity should send a police dispatch.
-- Each activity carries its own dispatch settings, edited in-game on the
-- activity's "Dispatch" tab (a code, title, message, priority, the jobs to
-- notify, a map blip, an alert chance, when the alert fires, and an on/off
-- toggle).
--
-- WHEN THE ALERT FIRES is the "Alert when" setting on that same tab:
--   On success  the crime is completed and paid out (default — the alert lands
--               after the fact, so police usually arrive too late)
--   On start    the moment the player begins the crime (minigame opens, porch
--               package is lifted, car window is smashed) — gives police a real
--               chance to catch the suspect in the act
--   Both        one alert on start and another on success
-- Each stage rolls the alert chance separately, and `data.stage` below tells you
-- which one you're handling.
--
-- This function is intentionally LEFT EMPTY — wire it into whatever dispatch
-- system you run here (ps-dispatch, cd_dispatch, qs-dispatch, lb-tablet, a
-- custom one). We only call it once the activity's alert is enabled, the stage
-- is one the activity alerts on AND its chance roll passes, so you don't need to
-- re-check those.
--
-- @param data table — everything our system passes to the dispatch:
--   data.activity   string   activity key, e.g. 'postalBoxTheft'
--   data.stage      string   'start' (crime begun) or 'success' (crime done)
--   data.code       string   dispatch / call code, e.g. '10-31'
--   data.name       string   alert title, e.g. 'Postal Box Theft'
--   data.message    string   alert body / description text
--   data.priority   number   1 = high, 2 = medium, 3 = low
--   data.chance     number   configured alert chance 0–100 (already rolled)
--   data.jobs       table    array of job names to notify, e.g. { 'police' }
--   data.blip       table    { sprite = n, color = n, scale = n, flashDurationMs = n }
--   data.coords     vector3  where the crime happened
--   data.source     number   server id of the offending player
--   data.playerName string   offending player's name (GetPlayerName)
Config.SendDispatch = function(data)
    -- Set up your own dispatch system here.
end