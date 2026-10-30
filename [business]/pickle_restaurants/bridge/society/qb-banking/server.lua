-- bridge/society/qb-banking — the newer QBCore banking resource.
--
-- Same account-per-job model as qb-management, different name for the read
-- (`GetAccountBalance`). A server generally runs one or the other; where both are
-- present qb-management wins, because that is the one a QB boss menu writes to.
RegisterSocietyProvider({
    name     = "qb-banking",
    resource = "qb-banking",
    priority = 65,
    get  = function(job) return SocietyExport("qb-banking", "GetAccountBalance", job) end,
    add  = function(job, amt) return SocietyMoved("qb-banking", "AddMoney", job, amt) end,
    take = function(job, amt) return SocietyMoved("qb-banking", "RemoveMoney", job, amt) end,
})
