-- vinewood-dispatch bridge: when vinewood raises an ambulance call and no ambulance units
-- are on duty, alert GoodCiv carriers for downed players at the call, and post GoodCiv
-- progress back onto the vinewood call as updates.
local cfg = Config.Dispatch.Vinewood
if not cfg or not cfg.Enabled then return end

local RES = 'vinewood-dispatch'
local alertFor = {} -- [incident id] = vinewood alert id

local function running() return GetResourceState(RES) == 'started' end

local function note(incId, text)
    if not cfg.Notes or not running() then return end
    local alertId = alertFor[incId]
    if not alertId then return end
    pcall(function() exports[RES]:AddNote(alertId, text, cfg.NoteAuthor or 'GoodCiv') end)
end

---Downed players within PatientRadius of coords.
local function downedNear(coords)
    local list = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        local report = Player(src).state['goodciv:patient']
        if report and report.downed then
            local ped = GetPlayerPed(src)
            if ped ~= 0 and #(GetEntityCoords(ped) - coords) <= cfg.PatientRadius then
                list[#list + 1] = src
            end
        end
    end
    return list
end

AddEventHandler('vinewood-dispatch:server:alertCreated', function(alert)
    if type(alert) ~= 'table' or not alert.coords then return end
    if not GoodCiv.InList(cfg.Presets, alert.preset) then return end
    if not GoodCiv.InList(alert.services or {}, 'ambulance') then return end

    local coords = vector3(alert.coords.x + 0.0, alert.coords.y + 0.0, alert.coords.z + 0.0)
    for _, src in ipairs(downedNear(coords)) do
        local existing = Incidents.GetByPatient(src)
        if existing then
            -- Already a GoodCiv patient (e.g. called earlier); just link the new call.
            alertFor[existing.id] = alertFor[existing.id] or alert.id
        else
            local alerted, inc = Dispatch.Request(src, 'dispatch')
            if alerted and inc then
                alertFor[inc.id] = alert.id
                if (inc.alertedCount or 0) > 0 then
                    note(inc.id, L('vw_note_alerted', inc.alertedCount))
                else
                    note(inc.id, L('vw_note_none'))
                end
            end
        end
    end
end)

Incidents.OnAccepted = function(inc, src)
    note(inc.id, L('vw_note_responding', Bridge.GetName(src)))
end

Incidents.OnClosed = function(inc, reason)
    if inc.handedOverAt then
        note(inc.id, L('vw_note_handover', inc.handedOverAt))
    elseif reason == 'resolved' then
        note(inc.id, L('vw_note_resolved'))
    elseif reason == 'alert_closed' and inc.responderCount > 0 then
        note(inc.id, L('vw_note_ended'))
    end
    alertFor[inc.id] = nil
end

-- If the vinewood call is closed, stop posting to it.
AddEventHandler('vinewood-dispatch:server:alertClosed', function(id)
    for incId, alertId in pairs(alertFor) do
        if alertId == id then alertFor[incId] = nil end
    end
end)

print(('^2[goodciv]^7 vinewood-dispatch bridge loaded (%s)'):format(running() and 'running' or 'not started yet'))
