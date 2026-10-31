-- vinewood-dispatch. Verified against vinewood-dispatch 1.6.0.
--   GetStoredCallsign(src)        the callsign saved in the dispatch (no fallbacks)
--   SetCallsign(src, callsign)    -> ok, errOrCallsign. Validates, uppercases, keeps it unique, writes metadata.
--   GetOnDutyCount(service)
--   AddUnitNote(alertId, src, text)
--   CreateAlert(data) -> id, CloseAlert(id), AddNote(id, text, author), ToggleResponder(id, src)   (callouts)
-- Events listened to: vinewood-dispatch:server:callsignChanged (src, callsign)
-- 1.6.0 also asks vinewood_police whether ESX officers are on duty.

VPO.Integrations.Define('dispatch', {
    resources = { 'vinewood-dispatch' },
    minVersion = '1.6.0',
    setup = function(res, _, limited)
        local d = exports[res]
        local a = { resource = res }
        if limited then
            VPO.Log.warn('%s is older than 1.6.0: on ESX it will count every police player as on duty.', res)
        end
        function a.GetStoredCallsign(src) return d:GetStoredCallsign(src) end
        function a.SetCallsign(src, callsign) return d:SetCallsign(src, callsign) end
        function a.GetOnDutyCount(service) return d:GetOnDutyCount(service) end
        function a.AddUnitNote(id, src, text) return d:AddUnitNote(id, src, text) end
        function a.CreateAlert(data) return d:CreateAlert(data) end
        function a.CloseAlert(id) return d:CloseAlert(id) end
        function a.AddNote(id, text, author) return d:AddNote(id, text, author) end
        function a.ToggleResponder(id, src) return d:ToggleResponder(id, src) end
        --- Tells the dispatch on the officer's client to re-read their service and duty.
        function a.RefreshClient(src) TriggerClientEvent(res .. ':client:refreshService', src) end
        return a
    end,
})
