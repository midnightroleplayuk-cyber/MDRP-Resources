-- ====================================================================
-- PERFORMANCE / LOD LAYERS
-- ====================================================================
-- Every layer has its own kill switch: turn a flag off and restart to get the
-- old behaviour back unchanged. Use it to tell a visual bug from a logic bug.
-- ====================================================================
Config.PerfLOD = {
    enabled          = true,

    frameCache       = true,
    mirrorLod        = true,
    interactionIndex = true,
    interactionScanMs= 100,
    idleGate         = true,
    ropeGate         = true,
    wireV2           = true,
    inputSync        = true,
    opHydSettle      = true,
    hydAttach        = true,
    hydCadenceMs     = 0,
    scheduler        = false,

    cv2Scopes        = true,
    intScopes        = true,

    -- Sync quality a player starts on before they touch the settings panel.
    -- performans | dengeli | yuksek (default) | ultra | sinematik
    -- On a player's FIRST join the script measures their FPS once and drops the
    -- VISUAL detail level if the machine is weak; the sync quality below is not
    -- touched by that. Once the player picks anything, their choice sticks.
    defaultQuality = 'yuksek',

    levels = {
        dusuk  = { marker = false, sling = false, hyd = false, mirrorHyd = false, pumpHyd = false, fx = false, maxAnim = 2, opStride = 3, badge3d = false,
                   truckGuard = false, probeMs = 600 },
        orta   = { maxAnim = 4 },
        yuksek = { maxAnim = 0 },
    },
    autoSampleMs = 3000,
    autoLowFps   = 40,
    autoMidFps   = 60,

    mirrorWake       = true,

    mirrorWakeMs     = 3000,

    timedLerp        = true,

    ultraTier = true,
    interp = {
        bufferMs = 100,
        extrapMs = 120,
        capacity = 12,

        tower         = true,
        towerBufferMs = 140,
    },

    tiers = {
        ultraDist  = 0.0,
        highDist   = 30.0,
        medDist    = 80.0,
        lowDist    = 150.0,
        hysteresis = 5.0,
        recheckMs  = 250,
    },
    view = {
        enabled       = true,
        viewDot       = 0.60,
        offGraceTicks = 2,
        medMaxDist    = 100.0,
        highMaxDist   = 60.0,
    },
    apply = {
        medMs   = 66,
        medLerp = 0.60,
        lowMs   = 250,
        lowLerp = 1.0,
    },

    serverFanout = true,
    fanout = {
        nearDist  = 70.0,
        farNth    = 3,
        hotGapMs  = 200,

        perRecipientMax = 120,
        telemetry = false,

        perRecipientMaxByQuality = {
            performans = 90,
            dengeli    = 180,
            yuksek     = 180,
            ozel       = 180,
            ultra      = 400,
            sinematik  = 600,
        },
    },
}
