-- Incentives scheme: Basic, Standard, Enhanced
Config.IEP = {
    Levels = { 'basic', 'standard', 'enhanced' },
    Labels = { basic = 'Basic', standard = 'Standard', enhanced = 'Enhanced' },
    Default = 'standard',

    Privileges = {
        basic    = { spendLimit = 15, wageMultiplier = 0.5 },
        standard = { spendLimit = 30, wageMultiplier = 1.0 },
        enhanced = { spendLimit = 60, wageMultiplier = 1.25 },
    },

    MaxPoints = 3,   -- an officer can award or deduct 1-3 points per entry

    -- Automatic reviews from the behaviour score over a rolling window
    AutoReview = {
        enabled = true,
        windowHours = 48,
        promoteAt = 6,         -- score at or above moves up one level
        demoteAt = -6,         -- score at or below moves down one level
        minHoursAtLevel = 12,  -- before an automatic promotion
    },
}
