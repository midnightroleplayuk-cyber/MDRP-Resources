-- Rigger role: a second player hooks the load onto the crane.
Config.Rigger = {
    enabled       = true,
    instances     = { main = true, site2 = true },
    hookGrabRange = 2.5,
    bindRange     = 6.0,
    hintRange     = 40.0,
    bindDuration  = 2200,
    bindAnim      = { dict = 'amb@prop_human_movie_bulb@base', clip = 'base',
                      exitDict = 'amb@prop_human_movie_bulb@exit', exitClip = 'exit' },
    trolleyRemote = true,
    trolleySpeed  = 0.55,
    bonusPct      = 0,
    maxSway       = 10.0,
    carryOffset   = { forward = 0.7, up = 0.55 },
    releaseDist   = 14.0,
    bindHookClear = 1.2,
    trolleyDead   = 0.9,

    bindReachTol    = 2.5,
    bindReachWaitMs = 2000,
}
