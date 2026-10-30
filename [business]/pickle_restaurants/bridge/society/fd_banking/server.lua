-- bridge/society/fd_banking — Felis Development's banking.
--
-- Business accounts keyed by the job name, with the same three verbs as okok:
--     GetAccount(business) / AddMoney(business, amount) / RemoveMoney(business, amount)
--
-- `GetAccount` answers with the account rather than a bare number on some builds,
-- which SocietyAmount() unwraps — a table where a number was expected would
-- otherwise read as "unknown account", i.e. as a broke restaurant.
RegisterSocietyProvider({
    name     = "fd_banking",
    resource = "fd_banking",
    priority = 88,
    get  = function(job) return SocietyExport("fd_banking", "GetAccount", job) end,
    add  = function(job, amt) return SocietyMoved("fd_banking", "AddMoney", job, amt) end,
    take = function(job, amt) return SocietyMoved("fd_banking", "RemoveMoney", job, amt) end,
})
