-- Incidents: one per patient, from the first call until handover, revive or timeout.
Incidents = {}

local incidents = {}   -- [id] = incident
local byPatient = {}   -- [src] = id
local byResponder = {} -- [src] = id
local nextId = 0

local function now() return os.time() end

local function pedCoords(src)
    local ped = GetPlayerPed(src)
    if ped == 0 then return nil end
    return GetEntityCoords(ped)
end

function Incidents.Get(id) return incidents[id] end
function Incidents.IsPatient(src) return byPatient[src] ~= nil end
function Incidents.GetByPatient(src) return byPatient[src] and incidents[byPatient[src]] end
function Incidents.GetResponding(src) return byResponder[src] and incidents[byResponder[src]] end

---Roll the patient's starting condition from what their client reports.
local function rollCondition(src)
    local report = Player(src).state['goodciv:patient'] or {}
    local state = {
        conscious = true,
        breathing = true,
        bleeding = 'none', -- none | major | controlled
    }
    if report.downed then
        state.conscious = false
        -- Cardiac arrest only at stage 2 (no signs of life). Last stand = breathing, can crawl.
        state.breathing = report.stage ~= 2
        local chance = Config.Conditions.MajorBleedChance[report.damage or 'other'] or Config.Conditions.MajorBleedChance.other
        if math.random() < chance then state.bleeding = 'major' end
    end
    return state
end

---Public, client-safe view of an incident.
local function view(inc, forSrc)
    local hospital = GoodCiv.NearestHospital(inc.coords)
    return {
        id = inc.id,
        coords = inc.coords,
        patient = inc.patient,
        tags = GoodCiv.ConditionTags(inc.state),
        state = inc.state,
        assessed = inc.assessed,
        stable = Incidents.IsStable(inc),
        responders = inc.responderCount,
        maxResponders = Config.Alerts.MaxResponders,
        transport = inc.transport and { vehicle = inc.transport.vehicle, hospital = inc.transport.hospital.label } or nil,
        hospital = hospital and hospital.label,
        isResponder = forSrc and inc.responders[forSrc] or false,
    }
end
Incidents.View = view

function Incidents.IsStable(inc)
    return inc.state.breathing and inc.state.bleeding ~= 'major'
end

---Push the latest incident state to the patient and every responder.
function Incidents.Sync(inc)
    for src in pairs(inc.responders) do
        TriggerClientEvent('goodciv:client:incidentUpdate', src, view(inc, src))
    end
    local names = {}
    for src in pairs(inc.responders) do names[#names + 1] = Bridge.GetName(src) end
    TriggerClientEvent('goodciv:client:patientStatus', inc.patient, {
        responders = inc.responderCount,
        names = names,
        transport = inc.transport and inc.transport.hospital.label or nil,
    })
end

local function dismissAlerts(inc, reason)
    for src in pairs(inc.alerted) do
        if not inc.responders[src] then
            TriggerClientEvent('goodciv:client:dismissAlert', src, inc.id, reason and L(reason))
        end
    end
end

---Send the alert to every available carrier who hasn't seen it yet.
function Incidents.Alert(inc)
    local exclude = { [inc.patient] = true }
    for src in pairs(inc.alerted) do exclude[src] = true end
    local carriers = Carriers.GetAvailable(inc.coords, exclude)
    local v = view(inc)
    for i = 1, #carriers do
        local src = carriers[i]
        inc.alerted[src] = true
        TriggerClientEvent('goodciv:client:alert', src, v, Config.Alerts.Timeout)
    end
    inc.lastAlert = now()
    GoodCiv.Debug(('incident %d alerted %d carriers'):format(inc.id, #carriers))
    return #carriers
end

---Create (or return the existing) incident for a patient.
---@return table|nil incident, string|nil reason
function Incidents.Create(patient, origin)
    if byPatient[patient] then return incidents[byPatient[patient]], 'exists' end
    local coords = pedCoords(patient)
    if not coords then return nil, 'no_ped' end

    local state = rollCondition(patient)
    if Config.Conditions.LifeThreateningOnly and not GoodCiv.IsLifeThreatening(state) then
        return nil, 'not_life_threatening'
    end

    nextId = nextId + 1
    local inc = {
        id = nextId,
        patient = patient,
        coords = coords,
        origin = origin,
        createdAt = now(),
        stage = (Player(patient).state['goodciv:patient'] or {}).stage or 0,
        attacker = (Player(patient).state['goodciv:patient'] or {}).attacker,
        treated = {},
        state = state,
        assessed = false,
        responders = {},
        responderCount = 0,
        alerted = {},
        transport = nil,
        action = nil,
    }
    incidents[inc.id] = inc
    byPatient[patient] = inc.id
    GoodCiv.Debug(('incident %d created for %d via %s'):format(inc.id, patient, origin))
    return inc
end

---@param reason string locale key shown to anyone still involved
function Incidents.Close(inc, reason)
    if not incidents[inc.id] then return end
    incidents[inc.id] = nil
    byPatient[inc.patient] = nil
    dismissAlerts(inc, reason)
    for src in pairs(inc.responders) do
        byResponder[src] = nil
        TriggerClientEvent('goodciv:client:incidentClosed', src, inc.id, reason and L(reason))
    end
    TriggerClientEvent('goodciv:client:patientClosed', inc.patient, reason and L(reason))
    if Incidents.OnClosed then Incidents.OnClosed(inc, reason) end
    local names = {}
    for src in pairs(inc.responders) do names[#names + 1] = Logs.Player(src) end
    Logs.Send('incidents', ('Call #%d closed'):format(inc.id), 'blue', {
        { 'Patient', Logs.Player(inc.patient) },
        { 'Outcome', inc.handedOverAt and ('Handed over at ' .. inc.handedOverAt) or reason or 'closed', true },
        { 'Duration', ('%dm %02ds'):format((now() - inc.createdAt) // 60, (now() - inc.createdAt) % 60), true },
        { 'Responders', #names > 0 and table.concat(names, '\n') or 'none' },
    })
    GoodCiv.Debug(('incident %d closed (%s)'):format(inc.id, reason or 'none'))
end

function Incidents.RemoveResponder(inc, src)
    if not inc.responders[src] then return end
    inc.responders[src] = nil
    inc.responderCount = inc.responderCount - 1
    byResponder[src] = nil
    if inc.action and inc.action.src == src then inc.action = nil end
    if inc.transport and inc.transport.driver == src then
        TriggerClientEvent('goodciv:client:leaveVehicle', inc.patient)
        inc.transport = nil
    end
    TriggerClientEvent('goodciv:client:incidentClosed', src, inc.id)
    TriggerClientEvent('goodciv:client:toast', inc.patient, 'warning', L('responder_dropped'))
    Logs.Send('incidents', ('Responder left call #%d'):format(inc.id), 'orange', {
        { 'Responder', Logs.Player(src) },
        { 'Patient', Logs.Player(inc.patient) },
    })
    Incidents.Sync(inc)
end

RegisterNetEvent('goodciv:server:accept', function(id)
    local src = source
    local inc = incidents[id]
    if not inc or not inc.alerted[src] or inc.responders[src] then
        return TriggerClientEvent('goodciv:client:toast', src, 'error', L('not_available'))
    end
    if inc.responderCount >= Config.Alerts.MaxResponders or byResponder[src] or Carriers.Ineligible(src) then
        TriggerClientEvent('goodciv:client:dismissAlert', src, id)
        return TriggerClientEvent('goodciv:client:toast', src, 'error', L('not_available'))
    end

    inc.responders[src] = true
    inc.responderCount = inc.responderCount + 1
    byResponder[src] = inc.id

    TriggerClientEvent('goodciv:client:accepted', src, view(inc, src))
    TriggerClientEvent('goodciv:client:toast', src, 'success', L('accepted'))
    TriggerClientEvent('goodciv:client:toast', inc.patient, 'info', L('responder_en_route', Bridge.GetName(src)))
    if Incidents.OnAccepted then Incidents.OnAccepted(inc, src) end
    local rc = pedCoords(src)
    Logs.Send('incidents', ('Call #%d accepted'):format(inc.id), 'yellow', {
        { 'Responder', Logs.Player(src) },
        { 'Patient', Logs.Player(inc.patient) },
        { 'Distance', rc and ('%dm'):format(math.floor(#(rc - inc.coords))) or '?', true },
        { 'Responders', ('%d / %d'):format(inc.responderCount, Config.Alerts.MaxResponders), true },
    })

    if inc.responderCount >= Config.Alerts.MaxResponders then
        dismissAlerts(inc, 'alert_filled')
    end
    Incidents.Sync(inc)
end)

-- Patient checked in at a hospital themselves: cancel alerts and stand responders down.
RegisterNetEvent('goodciv:server:checkedIn', function()
    local inc = Incidents.GetByPatient(source)
    if not inc or inc.handingOver then return end
    Incidents.Close(inc, 'checked_in')
end)

RegisterNetEvent('goodciv:server:abandon', function()
    local inc = Incidents.GetResponding(source)
    if inc then Incidents.RemoveResponder(inc, source) end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local inc = Incidents.GetByPatient(src)
    if inc then Incidents.Close(inc, 'alert_closed') end
    inc = Incidents.GetResponding(src)
    if inc then Incidents.RemoveResponder(inc, src) end
end)

-- Housekeeping: revived on scene, medics took over, timeouts and re-alerts.
CreateThread(function()
    while true do
        Wait(2000)
        local t = now()
        local medicsOnDuty
        for _, inc in pairs(incidents) do
            local report = Player(inc.patient).state['goodciv:patient']
            local coords = pedCoords(inc.patient)
            if coords then inc.coords = coords end

            -- Last stand -> stage 2 (or back) during the call: follow the real state.
            if report and report.downed and report.stage and report.stage ~= inc.stage then
                inc.stage = report.stage
                local breathing = report.stage ~= 2
                if inc.state.breathing ~= breathing then
                    inc.state.breathing = breathing
                    if not breathing then
                        for r in pairs(inc.responders) do
                            TriggerClientEvent('goodciv:client:toast', r, 'error', L('arrested'))
                        end
                    end
                    Incidents.Sync(inc)
                end
            end

            if report and not report.downed and not inc.transport and not inc.handingOver then
                -- Patient got up (revived by a medic, admin, or another script).
                if inc.responderCount > 0 then Incidents.Reward(inc, Config.Rewards.Assist) end
                Incidents.Close(inc, 'resolved')
            elseif t - inc.createdAt > Config.Alerts.IncidentLifetime then
                Incidents.Close(inc, 'alert_closed')
            elseif inc.responderCount == 0 then
                medicsOnDuty = medicsOnDuty or Bridge.CountOnDutyMedics()
                if medicsOnDuty >= Config.Medics.MinOnDuty then
                    Incidents.Close(inc, 'medic_took_over')
                elseif Config.Alerts.RealertAfter > 0 and t - inc.lastAlert >= Config.Alerts.RealertAfter then
                    inc.alerted = {}
                    Incidents.Alert(inc)
                end
            end
        end
    end
end)

exports('GetIncidentByPatient', function(src)
    local inc = Incidents.GetByPatient(src)
    return inc and view(inc) or nil
end)
