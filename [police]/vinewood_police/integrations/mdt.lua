-- vinewood-mdt. Verified against vinewood-mdt 2.18.0.
--   Request(src, action, data)   runs an MDT action as the officer (2.18+)
--   GetFormOptions()             the MDT's offences, powers, outcomes... (2.18+)
--   GetMarkers(kind, id)         'person', citizenid | 'vehicle', plate
--   GetActiveBail(cid)
--   SearchPeople(q, limit)
--   GetCasesForPerson(cid)
-- Older versions get the read-only exports; records then stay in vinewood_police.

VPO.Integrations.Define('mdt', {
    resources = { 'vinewood-mdt' },
    minVersion = '2.18.0',
    setup = function(res, _, limited)
        local mdt = exports[res]
        local reasons = (Config.Integrations.mdt or {}).Reasons or {}
        local a = { resource = res, canWrite = not limited }

        function a.GetMarkers(kind, id) return mdt:GetMarkers(kind, id) end
        function a.GetActiveBail(cid) return mdt:GetActiveBail(cid) end
        function a.SearchPeople(q, limit) return mdt:SearchPeople(q, limit) end
        function a.GetCasesForPerson(cid) return mdt:GetCasesForPerson(cid) end

        if limited then
            VPO.Log.warn('%s is older than 2.18.0: arrests, searches and evidence will be kept in vinewood_police only. Update the MDT to link them.', res)
            return a
        end

        --- Runs an MDT action as the officer. Adds the audit purpose from Config.Integrations.mdt.Reasons.
        function a.Request(src, action, data)
            data = data or {}
            if data._reason == nil then data._reason = reasons[action] or reasons.default end
            return mdt:Request(src, action, data)
        end

        function a.GetFormOptions()
            if not a._form then a._form = mdt:GetFormOptions() end
            return a._form
        end

        return a
    end,
})
