-- Treatment actions. The client asks to begin, plays the animation / minigame,
-- then asks to complete. The server owns the patient state and validates both steps.

local T = Config.Treatment

local function pedCoords(src)
    local ped = GetPlayerPed(src)
    return ped ~= 0 and GetEntityCoords(ped) or nil
end

local function toast(src, kind, msg) TriggerClientEvent('goodciv:client:toast', src, kind, msg) end

---The incident src is responding to, if they are close enough to the patient.
local function responderIncident(src, maxDist)
    local inc = Incidents.GetResponding(src)
    if not inc then return nil end
    local a, b = pedCoords(src), pedCoords(inc.patient)
    if not a or not b or #(a - b) > (maxDist or T.Distance) then
        toast(src, 'error', L('too_far'))
        return nil
    end
    return inc
end

-- name = { duration, check(inc, src) -> errorMsg|nil, apply(inc, src, result) -> toastKind, msg }
local actions = {}

actions.assess = {
    duration = function() return T.Assess.Duration end,
    apply = function(inc)
        inc.assessed = true
        if not inc.state.breathing then return 'warning', L('not_breathing') end
        return 'info', L('assess_done')
    end,
}

actions.tourniquet = {
    duration = function() return T.Tourniquet.Duration end,
    check = function(inc, src)
        if inc.state.bleeding == 'controlled' then return L('already_controlled') end
        if inc.state.bleeding ~= 'major' then return L('no_major_bleed') end
        if T.Tourniquet.Item and not Bridge.HasItem(src, T.Tourniquet.Item) then
            return L('need_item', T.Tourniquet.Item)
        end
    end,
    apply = function(inc, src)
        if T.Tourniquet.Item and T.Tourniquet.ConsumeItem then
            if not Bridge.RemoveItem(src, T.Tourniquet.Item, 1) then
                return 'error', L('need_item', T.Tourniquet.Item)
            end
        end
        inc.state.bleeding = 'controlled'
        return 'success', L('tourniquet_done')
    end,
}

actions.cpr = {
    duration = function() return T.CPR.Duration end,
    check = function(inc, src)
        if inc.state.breathing then return L('is_breathing') end
        local last = inc.lastCpr and inc.lastCpr[src]
        if last and os.time() - last < T.CPR.Cooldown then return L('busy') end
    end,
    apply = function(inc, src, result)
        inc.lastCpr = inc.lastCpr or {}
        inc.lastCpr[src] = os.time()
        local quality = math.max(0.0, math.min(1.0, tonumber(type(result) == 'table' and result.quality) or 0.0))
        local chance = T.CPR.BaseChance + T.CPR.TechniqueBonus * quality
        if inc.state.bleeding == 'major' then chance = chance * T.CPR.UntreatedBleedPenalty end
        GoodCiv.Debug(('cpr quality %.2f chance %.2f'):format(quality, chance))
        if math.random() < chance then
            inc.state.breathing = true
            return 'success', L('cpr_success')
        end
        return 'warning', L('cpr_fail')
    end,
}

actions.recovery = {
    duration = function() return T.RecoveryPosition.Duration end,
    check = function(inc)
        if not inc.state.breathing then return L('not_breathing') end
    end,
    apply = function(inc)
        inc.state.recovery = true
        return 'success', L('recovery_done')
    end,
}

RegisterNetEvent('goodciv:server:beginAction', function(name)
    local src = source
    local def = actions[name]
    if not def then return end
    local inc = responderIncident(src)
    if not inc then return end
    if inc.action and inc.action.src ~= src then return toast(src, 'error', L('busy')) end
    if inc.transport then return toast(src, 'error', L('busy')) end
    local err = def.check and def.check(inc, src)
    if err then return toast(src, 'error', err) end

    local duration = def.duration()
    inc.action = { src = src, name = name, started = os.time(), duration = duration }
    TriggerClientEvent('goodciv:client:runAction', src, name, duration, {
        bpm = T.CPR.TargetBpm,
    })
end)

RegisterNetEvent('goodciv:server:completeAction', function(name, result)
    local src = source
    local def = actions[name]
    local inc = Incidents.GetResponding(src)
    if not def or not inc then return end
    local action = inc.action
    if not action or action.src ~= src or action.name ~= name then return end
    inc.action = nil
    -- 1s tolerance for os.time() granularity.
    if os.time() - action.started < action.duration - 1 then return end
    if not responderIncident(src, T.Distance + 1.0) then return end
    local err = def.check and def.check(inc, src)
    if err then
        toast(src, 'error', err)
    else
        local kind, msg = def.apply(inc, src, result)
        toast(src, kind, msg)
    end
    Incidents.Sync(inc)
end)

RegisterNetEvent('goodciv:server:cancelAction', function()
    local inc = Incidents.GetResponding(source)
    if inc and inc.action and inc.action.src == source then inc.action = nil end
end)

---------------------------------------------------------------------------
-- Transport
---------------------------------------------------------------------------

RegisterNetEvent('goodciv:server:load', function(netId)
    local src = source
    local inc = responderIncident(src)
    if not inc or inc.transport then return end
    if Config.Transport.RequireStable and not Incidents.IsStable(inc) then
        return toast(src, 'error', L('not_stable'))
    end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 or GetEntityType(veh) ~= 2 then return toast(src, 'error', L('no_vehicle')) end
    if #(GetEntityCoords(veh) - pedCoords(src)) > Config.Transport.VehicleDistance + 2.0 then
        return toast(src, 'error', L('no_vehicle'))
    end
    local hospital = GoodCiv.NearestHospital(GetEntityCoords(veh))
    inc.transport = { vehicle = netId, driver = src, hospital = hospital }
    TriggerClientEvent('goodciv:client:enterVehicle', inc.patient, netId)
    toast(src, 'success', L('loaded', hospital.label))
    Incidents.Sync(inc)
end)

-- Patient's client couldn't find a free seat.
RegisterNetEvent('goodciv:server:loadFailed', function()
    local inc = Incidents.GetByPatient(source)
    if not inc or not inc.transport then return end
    toast(inc.transport.driver, 'error', L('vehicle_full'))
    inc.transport = nil
    Incidents.Sync(inc)
end)

RegisterNetEvent('goodciv:server:unload', function()
    local src = source
    local inc = Incidents.GetResponding(src)
    if not inc or not inc.transport then return end
    local a, b = pedCoords(src), pedCoords(inc.patient)
    if not a or not b or #(a - b) > 10.0 then return toast(src, 'error', L('too_far')) end
    inc.transport = nil
    TriggerClientEvent('goodciv:client:leaveVehicle', inc.patient)
    toast(src, 'info', L('unloaded'))
    Incidents.Sync(inc)
end)

RegisterNetEvent('goodciv:server:crash', function()
    local src = source
    local inc = Incidents.GetResponding(src)
    if not inc or not inc.transport or inc.transport.driver ~= src then return end
    -- Rate-limit so one pile-up doesn't roll several times.
    if inc.lastCrash and os.time() - inc.lastCrash < 3 then return end
    inc.lastCrash = os.time()
    if inc.state.breathing and math.random() < Config.Transport.CrashArrestChance then
        inc.state.breathing = false
    end
    for r in pairs(inc.responders) do toast(r, 'error', L('crash')) end
    Incidents.Sync(inc)
end)

RegisterNetEvent('goodciv:server:handover', function()
    local src = source
    local inc = Incidents.GetResponding(src)
    if not inc or inc.handingOver then return end
    local a, b = pedCoords(src), pedCoords(inc.patient)
    if not a or not b or #(a - b) > 12.0 then return toast(src, 'error', L('too_far')) end
    local hospital = GoodCiv.HospitalAt(b)
    if not hospital then return toast(src, 'error', L('not_at_hospital')) end

    inc.handingOver = true
    TriggerClientEvent('goodciv:client:handover', inc.patient, hospital.drop)
    SetTimeout(1500, function()
        Bridge.Revive(inc.patient)
        toast(inc.patient, 'success', L('handover_patient', hospital.label))
        for r in pairs(inc.responders) do toast(r, 'success', L('handover_done', hospital.label)) end
        Incidents.Reward(inc, Config.Rewards.Handover)
        Incidents.Close(inc)
    end)
end)
