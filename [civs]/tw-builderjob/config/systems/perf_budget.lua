-- Frame budget: how long heavy work may spend per frame.
Config = Config or {}
Config.PerfBudget = {
    enabled      = true,
    governor     = true,
    targetMs     = 0.30,
    windowMs     = 2000,
    recoverRatio = 0.6,
    maxClockRes  = 0.0021,
}
