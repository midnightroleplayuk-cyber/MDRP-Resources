-- vinewood-interviews 1.8.1+, vinewood_prison 2.4+, vinewood-moj 1.2+.
-- These are mostly listened to (events), not called: the MDT drives remand and court.
--   interviews: events vinewood-interviews:server:started / :ended (1.8.1+)
--   prison:     events vinewood_prison:received (identifier, prisonNo), exports IsInCustody(target)
--   moj:        exports GetPersonSummary(cid), GetActiveWarrants(cid)

VPO.Integrations.Define('interviews', {
    resources = { 'vinewood-interviews' },
    minVersion = '1.8.1',
    setup = function(res, _, limited)
        if limited then VPO.Log.warn('%s is older than 1.8.1: interviews won\'t be logged on custody records.', res) end
        return { resource = res, events = not limited }
    end,
})

VPO.Integrations.Define('prison', {
    resources = { 'vinewood_prison' },
    minVersion = '2.4.0',
    setup = function(res)
        local p = exports[res]
        local a = { resource = res }
        function a.IsInCustody(target) return p:IsInCustody(target) end
        return a
    end,
})

VPO.Integrations.Define('moj', {
    resources = { 'vinewood-moj' },
    minVersion = '1.2.0',
    setup = function(res)
        local m = exports[res]
        local a = { resource = res }
        function a.Summary(cid) return m:GetPersonSummary(cid) end
        function a.Warrants(cid) return m:GetActiveWarrants(cid) end
        return a
    end,
})
