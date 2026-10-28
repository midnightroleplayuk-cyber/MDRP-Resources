-- ====================================================================
-- SLING PROFILES -- per-model crane carry pose, keyed by prop model name.
-- Vehicle crane: mode 'none'|'4corner'|'midline'|'single'|'face:<side>', drop (m below
--   hook), ropez (rope start on hook, m). Tower crane: ox/oy/oz (m), slingCount 2|4.
-- Shared: rx/ry/yaw (deg), ox/oy (m). Tune in-game with /slingtool (DebugCommands).
-- ====================================================================

Config.SlingProfiles = Config.SlingProfiles or {}

-- Do not copy a `points` list from a similar-looking model: points are model-local
-- and rotate with the mesh. Tune each model on its own.

-- Region 11 roof beams: hand-written defaults, overridden by measured_sling.lua.
Config.SlingProfiles['tworst_job8wall2'] = {
    mode = '4corner', drop = 1.25, ropez = 0.00,
    yaw = 0.0, rx = 35.0, ry = 90.0,
    ox = 0.00, oy = -0.22,
}
Config.SlingProfiles['tworst_job8wall3'] = {
    mode = '4corner', drop = 1.25, ropez = 0.00,
    yaw = 0.0, rx = 35.0, ry = 90.0,
    ox = 0.00, oy = -0.22,
}

-- Measured poses live in config/data/measured_sling.lua and override the
-- hand-written defaults above.
do
    local data = TwMeasuredSling
    if type(data) == 'table' then
        local n = 0
        for model, prof in pairs(data) do
            if type(model) == 'string' and type(prof) == 'table' then
                Config.SlingProfiles[model] = prof
                n = n + 1
            end
        end
        if n > 0 and Config.Debug then
            print(('[sling] %d measured profile(s) applied'):format(n))
        end
    else
        print('^1[sling] config/data/measured_sling.lua missing — only the built-in defaults are active^7')
    end
end
