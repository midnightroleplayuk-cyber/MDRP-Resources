Config.Sentence = {
    -- 'online'   : time only counts while the prisoner is connected
    -- 'realtime' : wall-clock time, online or not
    -- 'hybrid'   : online at full rate, offline at OfflineRate
    Mode = 'online',
    OfflineRate = 0.25,

    -- Fraction of the term served before automatic release (0.5 = half).
    -- Vinewood MoJ can override this per sentence by sending releasePoint.
    ReleasePoint = 0.5,

    TickInterval = 60,    -- seconds between time-served ticks
    SweepInterval = 300,  -- seconds between offline/pending sweeps

    AutoRelease = true,   -- discharge online prisoners as soon as their release point passes

    MinTermSeconds = 300,
    MaxTermSeconds = 60 * 60 * 24 * 60,
}
