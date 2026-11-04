-- Medic requests: forward to the normal dispatch, then fall back to GoodCiv carriers.
Dispatch = {}

local lastRequest = {} -- [src] = os.time()

---Send the call to real medics through the configured dispatch.
local function forward(patient, coords)
    local provider = Config.Dispatch.Provider
    local message = L('medic_alert', Bridge.GetName(patient))
    if provider == 'builtin' then
        for _, medic in ipairs(Bridge.GetOnDutyMedics()) do
            TriggerClientEvent('goodciv:client:medicCall', medic, { coords = coords, message = message, patient = patient })
        end
    elseif provider == 'ps-dispatch' or provider == 'cd_dispatch' then
        -- Both are fed from the caller's client so street/zone info is correct.
        TriggerClientEvent('goodciv:client:forwardDispatch', patient, provider)
    elseif provider == 'custom' and Config.Dispatch.Custom then
        Config.Dispatch.Custom(patient, coords, message)
    end
end

---Handle a medic request from a patient.
---@param origin 'command'|'event'|'auto'|'export'
---@return boolean alerted true if GoodCiv carriers were alerted
function Dispatch.Request(patient, origin)
    local t = os.time()
    if Incidents.IsPatient(patient) then
        if origin == 'command' then
            TriggerClientEvent('goodciv:client:toast', patient, 'warning', L('medic_cooldown'))
        end
        return false
    end
    -- Debounce: death screens can fire their distress event repeatedly.
    if lastRequest[patient] and t - lastRequest[patient] < 5 then return false end
    lastRequest[patient] = t

    local ped = GetPlayerPed(patient)
    if ped == 0 then return false end
    local coords = GetEntityCoords(ped)

    -- Events we listen to have already gone through the server's own dispatch.
    if origin ~= 'event' then forward(patient, coords) end

    local medics = #Bridge.GetOnDutyMedics()
    if medics >= Config.Medics.MinOnDuty then
        TriggerClientEvent('goodciv:client:toast', patient, 'info', L('medic_requested'))
        return false
    end

    local inc, reason = Incidents.Create(patient, origin)
    if not inc then
        if reason == 'not_life_threatening' then
            TriggerClientEvent('goodciv:client:toast', patient, 'info', L('medic_not_needed'))
        end
        return false
    end

    local count = Incidents.Alert(inc)
    if count == 0 then
        TriggerClientEvent('goodciv:client:toast', patient, 'warning', L('medic_none_available'))
    else
        TriggerClientEvent('goodciv:client:toast', patient, 'info', L('medic_requested_goodciv'))
    end
    Incidents.Sync(inc)
    return true
end

RegisterCommand(Config.Dispatch.Command, function(src)
    if src == 0 then return end
    Dispatch.Request(src, 'command')
end, false)

RegisterNetEvent('goodciv:server:autoAlert', function()
    if Config.Dispatch.AutoAlertDelay <= 0 then return end
    Dispatch.Request(source, 'auto')
end)

for _, name in ipairs(Config.Dispatch.ListenEvents) do
    RegisterNetEvent(name)
    AddEventHandler(name, function()
        local src = source
        if type(src) ~= 'number' or src <= 0 then return end
        -- Let the patient's client publish its downed state before we read it.
        SetTimeout(500, function() Dispatch.Request(src, 'event') end)
    end)
end

AddEventHandler('playerDropped', function()
    lastRequest[source] = nil
end)

-- exports.ndm_goodciv:RequestMedic(src) from your own dispatch / death screen.
exports('RequestMedic', function(src) return Dispatch.Request(src, 'export') end)
-- Same as above, but for calls that already went through your dispatch.
exports('MedicFallback', function(src) return Dispatch.Request(src, 'event') end)
exports('GetOnDutyMedicCount', function() return #Bridge.GetOnDutyMedics() end)
