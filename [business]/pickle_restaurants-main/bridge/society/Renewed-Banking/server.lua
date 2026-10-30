-- bridge/society/Renewed-Banking — Renewed-Banking.
--
-- HIGHEST PRIORITY, and that is not a preference — it is a correctness rule.
-- Renewed-Banking SHIMS both qb-management and esx_society, so on a server running
-- it those two providers also answer. Talking to it through one of those narrower
-- doors would work right up until it didn't (its own account model is richer, and
-- job accounts it created are not always visible through the shim).
RegisterSocietyProvider({
    name     = "Renewed-Banking",
    resource = "Renewed-Banking",
    priority = 100,
    get  = function(job) return SocietyExport("Renewed-Banking", "getAccountMoney", job) end,
    add  = function(job, amt) return SocietyMoved("Renewed-Banking", "addAccountMoney", job, amt) end,
    take = function(job, amt) return SocietyMoved("Renewed-Banking", "removeAccountMoney", job, amt) end,
    -- The one provider that both CAN create a job account and needs telling to:
    -- it keeps organisation accounts in a cache of its own, so an account nobody
    -- created is not merely empty, it is absent.
    --
    -- ITS RETURN VALUE IS NOT AN ANSWER, so we ask again instead. Renewed 2.1.4's
    -- CreateJobAccount ends with a non-awaited `MySQL.insert` and treats the nil that
    -- comes back as a database error: it raises, and on the way out it deletes the
    -- cache entry it had just made. So a perfectly good creation looks like a throw,
    -- and the account really is gone afterwards. Asking GetJobAccount is the only
    -- honest test, and it also covers the builds where that bug is fixed.
    make = function(job, label)
        if SocietyExport("Renewed-Banking", "GetJobAccount", job) then return true end
        SocietyExport("Renewed-Banking", "CreateJobAccount", { name = job, label = label or job }, 0)
        return SocietyExport("Renewed-Banking", "GetJobAccount", job) ~= nil
    end,
})
