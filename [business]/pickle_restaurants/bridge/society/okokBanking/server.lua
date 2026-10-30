-- bridge/society/okokBanking — okokBanking (v1 and v2).
--
-- Runs on ESX and QB alike, which is exactly why the resolver probes for the
-- PROVIDER rather than assuming one bank per framework. Its society exports take
-- the account name — for us always the restaurant's JOB — and a value:
--
--     GetAccount(society) / AddMoney(society, value) / RemoveMoney(society, value)
--
-- Ranked below Renewed-Banking (which shims other providers and so must win when
-- both are present) but above the qb-* pair, since a server running okok is
-- running it INSTEAD of qb-management, not alongside it.
--
-- Accounts are created by okok itself for every job it knows, so there is no
-- `make` here — the first write lands in an account that already exists.
RegisterSocietyProvider({
    name     = "okokBanking",
    resource = "okokBanking",
    priority = 90,
    get  = function(job) return SocietyExport("okokBanking", "GetAccount", job) end,
    add  = function(job, amt) return SocietyMoved("okokBanking", "AddMoney", job, amt) end,
    take = function(job, amt) return SocietyMoved("okokBanking", "RemoveMoney", job, amt) end,
})
