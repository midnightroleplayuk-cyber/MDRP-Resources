Config.Accounts = {
    Currency = '£',
    CashItem = 'money',          -- ox_inventory cash item

    Wages = {
        SessionPay = 5,          -- per work session attended, before IEP multiplier
        MinAttendance = 0.5,     -- share of the session a prisoner must be present for
    },

    Deposits = {
        enabled = true,          -- family and friends pay into private cash at a finance desk
        max = 200,
    },

    PayoutOnRelease = true,      -- remaining balance paid out in cash at discharge
    DischargeGrant = 0,          -- extra cash on release
}
