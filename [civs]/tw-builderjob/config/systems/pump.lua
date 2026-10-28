-- ====================================================================
-- CONCRETE PUMP
-- ====================================================================
-- A 19-part chain plus hydraulics and pour effects. The mixer is parked
-- behind the pump and fills the hopper as long as it stays within 8 m.
-- ====================================================================

Config      = Config or {}
Config.Pump = {

    stowSpeedMul = 2.0,

    -- Stops the boom tip before it sinks into the ground. tipClear + hyst is
    -- the trigger height: too large and it blocks the normal pouring pose.
    groundGuard  = { enabled = true, tipClear = 0.15, pipeClear = 0.05, hyst = 0.10,
                     guardPipe = false, blockMs = 600 },

    pumpDeploy   = {
        pose      = {
            slew    = 0.00,
            boom01  = 90.00,
            boom02  = 112.92,
            boom03  = 94.15,
            boom04  = 54.92,
            boom05  = 33.98,
        },
        timeoutMs = 25000,
    },

    fillMixerModel = "twmixer",
}

Config.Pump.camViews = {
    { key = 'camSmart',    labelKey = 'cam_smart_follow', label = TL('cam_smart_follow', 'Smart follow'),  kind = 'delegate' },
    { key = 'camWide',     labelKey = 'cam_wide', label = TL('cam_wide', 'Wide view'),   kind = 'orbit',
      dist = 26.0, distMin = 6.0, distMax = 60.0, zoomStep = 2.0,
      height = 9.0, lookZ = 5.0, fov = 45.0 },
    { key = 'camFp',       labelKey = 'cam_first_person', label = TL('cam_first_person', 'First person'), kind = 'fp',
      fov = 55.0, fovMin = 20.0, fovMax = 70.0, zoomStep = 4.0 },
}
