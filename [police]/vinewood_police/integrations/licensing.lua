-- vinewood_licensing. Verified against 2.0.4 (EXPORTS.md). Identifiers may be a server id or citizenid.
--   GetLicenceData(id)   { hasLicence, provisionalOnly, hasProvisional, categories, number, points, banned, ban, ... }
--   IsBanned(id)         banned, ban
--   GetPoints(id)        total, endorsements, queued
--   AddPoints(id, points, code, reason, officer) -> ok, total, autoBanned, status ('queued' when offline)
VPO.Integrations.Define('licensing', {
    resources = { 'vinewood_licensing' },
    minVersion = '2.0.0',
    setup = function(res)
        local l = exports[res]
        local a = { resource = res }
        function a.GetLicenceData(id) return l:GetLicenceData(id) end
        function a.IsBanned(id) return l:IsBanned(id) end
        function a.AddPoints(id, points, code, reason, officer) return l:AddPoints(id, points, code, reason, officer) end

        --- One short summary for the roadside panel.
        function a.Summary(id)
            local d = l:GetLicenceData(id)
            if type(d) ~= 'table' then return nil end
            local status = 'none'
            if d.banned then status = 'disqualified'
            elseif d.hasLicence then status = 'valid'
            elseif d.provisionalOnly or d.hasProvisional then status = 'provisional' end
            return {
                status = status, categories = d.categories, number = d.number, points = d.points or 0,
                expiry = d.expiry, ban = d.banned and d.ban or nil,
            }
        end
        return a
    end,
})
