-- Treatment panel: assess, tourniquet, CPR, load / unload.
Treatment = {}

local open = false
local busy = false

local ANIMS = {
    assess = { dict = 'amb@medic@standing@kneel@base', clip = 'base' },
    tourniquet = { dict = 'amb@medic@standing@tendtodead@idle_a', clip = 'idle_a' },
    cpr = { dict = 'mini@cpr@char_a@cpr_str', clip = 'cpr_pumpchest' },
    rouse = { dict = 'amb@medic@standing@kneel@base', clip = 'base' },
}

local LABELS = {
    assess = 'Checking airway, breathing and circulation',
    tourniquet = 'Applying tourniquet',
    rouse = 'Talking to the patient and tapping their shoulders',
}

function Treatment.IsOpen() return open end
function Treatment.IsBusy() return busy end

function Treatment.Open(incident)
    open = true
    Nui.Focus(true)
    Nui.Send('treatment', incident)
end

function Treatment.Refresh(incident)
    if open then Nui.Send('treatment', incident) end
end

function Treatment.Close()
    if busy then Nui.CancelCpr() end
    open = false
    Nui.Focus(false)
    Nui.Send('treatment', false)
end

local function playAnim(name)
    local anim = ANIMS[name]
    if not anim then return end
    RequestAnimDict(anim.dict)
    local timeout = GetGameTimer() + 3000
    while not HasAnimDictLoaded(anim.dict) and GetGameTimer() < timeout do Wait(10) end
    TaskPlayAnim(PlayerPedId(), anim.dict, anim.clip, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

local function stopAnim()
    ClearPedTasks(PlayerPedId())
end

local function closeEnough()
    local patient = Responder.PatientPed()
    if patient == 0 then return false end
    return #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(patient)) <= Config.Treatment.Distance + 0.5
end

local function facePatient()
    local patient = Responder.PatientPed()
    if patient ~= 0 then TaskTurnPedToFaceEntity(PlayerPedId(), patient, 800) Wait(800) end
end

---Timed action with a progress bar; returns false if the responder walked off.
local function progress(label, duration)
    Nui.Send('progress', { label = label, duration = duration })
    local ends = GetGameTimer() + duration * 1000
    while GetGameTimer() < ends do
        if not closeEnough() then
            Nui.Send('progress', false)
            return false
        end
        Wait(100)
    end
    Nui.Send('progress', false)
    return true
end

RegisterNetEvent('goodciv:client:runAction', function(name, duration, opts)
    if busy then return end
    busy = true
    facePatient()
    playAnim(name)
    local ok, result
    if name == 'cpr' then
        result = Nui.RunCpr(duration, opts.bpm)
        ok = result ~= nil and closeEnough()
    else
        ok = progress(LABELS[name] or name, duration)
    end
    stopAnim()
    busy = false
    if ok then
        TriggerServerEvent('goodciv:server:completeAction', name, result)
    else
        TriggerServerEvent('goodciv:server:cancelAction')
        Nui.Toast('error', L('too_far'))
    end
    if open then Nui.Focus(true) end
end)

---Closest usable vehicle to the responder.
local function nearbyVehicle()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local best, bestDist
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        local d = #(coords - GetEntityCoords(veh))
        if d <= Config.Transport.VehicleDistance and (not bestDist or d < bestDist)
            and not GoodCiv.InList(Config.Transport.BlockedClasses, GetVehicleClass(veh))
            and NetworkGetEntityIsNetworked(veh) then
            best, bestDist = veh, d
        end
    end
    return best
end

RegisterNUICallback('action', function(data, cb)
    cb('ok')
    if busy then return Nui.Toast('error', L('busy')) end
    local name = data.name
    if name == 'load' then
        local veh = nearbyVehicle()
        if not veh then return Nui.Toast('error', L('no_vehicle')) end
        TriggerServerEvent('goodciv:server:load', VehToNet(veh))
        Treatment.Close()
    elseif name == 'unload' then
        TriggerServerEvent('goodciv:server:unload')
    elseif ANIMS[name] then
        TriggerServerEvent('goodciv:server:beginAction', name)
    end
end)

RegisterNUICallback('close', function(data, cb)
    cb('ok')
    Treatment.Close()
end)
