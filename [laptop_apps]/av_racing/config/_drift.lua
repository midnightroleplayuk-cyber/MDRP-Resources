Config = Config or {}

Config.Drift = {
    MinSpeed = 8.0, -- Min speed required to start registering a drift
    MinAngle = 12.0, -- Min angle required to start registering a drift
    MaxAngle = 85.0, -- Max angle before a drift is considered a spin-out
    ChainTimeout = 1500, -- Milliseconds allowed to transition between drifts without losing the combo
    SpeedDivisor = 5.0, -- Divides the vehicle speed to calculate base points
    AngleDivisor = 10.0, -- Divides the drift angle to calculate the angle multiplier
    TickRate = 50, -- How often (in milliseconds) points are calculated and added
    ComboIncrement = 0.05, -- How much the combo multiplier increases per tick while drifting
    MaxCombo = 5.0 -- The max combo multiplier allowed
}