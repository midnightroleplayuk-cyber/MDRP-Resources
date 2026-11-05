if not Config.Modules.contracts then return end

local cfg = Config.Contracts
local current        -- { id, template, stage, data, endsAt }
local blip, blipEntity, debtor, box
local busy, warned, keysGiven, enteredSent, subduedSent = false, false, false, false, false
local prompt -- locale key of the text UI currently shown

local function hidePrompt()
    if prompt then lib.hideTextUI() end
    prompt = nil
end

local PICKUP_ANIM = { dict = 'pickup_object', clip = 'pickup_low' }
local THREAT_ANIM = { dict = 'misscommon@response', clip = 'bring_it_on' }
local BOX_MODEL = GetHashKey('prop_cs_cardbox_01')

local function notify(key, kind, ...)
    lib.notify({ description = locale(key, ...), type = kind or 'inform' })
end

local function v3(t) return vector3(t.x, t.y, t.z) end

-------------------------------------------------------------------------------
-- World helpers
-------------------------------------------------------------------------------

local function removeBlip()
    if blip and DoesBlipExist(blip) then RemoveBlip(blip) end
    blip, blipEntity = nil, nil
end

local function setBlip(point, labelKey, entity)
    removeBlip()
    blip = entity and AddBlipForEntity(entity) or AddBlipForCoord(point.x, point.y, point.z)
    blipEntity = entity
    SetBlipColour(blip, 5)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(locale(labelKey))
    EndTextCommandSetBlipName(blip)
end

local function attachBox()
    lib.requestModel(BOX_MODEL)
    box = CreateObject(BOX_MODEL, GetEntityCoords(cache.ped), true, true, false)
    AttachEntityToEntity(box, cache.ped, GetPedBoneIndex(cache.ped, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(BOX_MODEL)
end

local function removeBox()
    if box and DoesEntityExist(box) then DeleteEntity(box) end
    box = nil
end

local function releaseDebtor()
    if debtor and DoesEntityExist(debtor) then
        if IsEntityDead(debtor) then
            SetEntityAsNoLongerNeeded(debtor)
        else
            SetBlockingOfNonTemporaryEvents(debtor, false)
            TaskWanderStandard(debtor, 10.0, 10)
            SetPedAsNoLongerNeeded(debtor)
        end
    end
    debtor = nil
end

local function spawnDebtor()
    local d = current.data
    local model = GetHashKey(d.model)
    lib.requestModel(model)
    debtor = CreatePed(4, model, d.spot.x, d.spot.y, d.spot.z - 1.0, d.spot.w or 0.0, true, true)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(debtor, true, true)
    SetBlockingOfNonTemporaryEvents(debtor, true)
    TaskStartScenarioInPlace(debtor, 'WORLD_HUMAN_SMOKING', 0, true)
    setBlip(nil, 'blip_debtor', debtor)
end

local function clearWorld()
    removeBlip()
    removeBox()
    releaseDebtor()
    hidePrompt()
end

local function jobVehicle()
    local id = current and current.data.netId
    if id and NetworkDoesNetworkIdExist(id) then return NetToVeh(id) end
end

local function marker(point, size)
    DrawMarker(1, point.x, point.y, point.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size, size, 0.6, 242, 169, 59, 110, false, false, 2, false, nil, nil, false)
end

local function progress(duration, labelKey, anim)
    return lib.progressBar({
        duration = duration,
        label = locale(labelKey),
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = anim,
    })
end

local function act(name)
    local ok, res = lib.callback.await('vinewood_gangs:server:contractAction', false, current.id, name)
    if not ok then notify(res or 'failed', 'error') end
    return ok, res
end

-------------------------------------------------------------------------------
-- Stages
-------------------------------------------------------------------------------

local function applyStage()
    local c, d = current, current.data
    if c.template == 'courier' then
        setBlip(c.stage == 'pickup' and d.pickup or d.drop, c.stage == 'pickup' and 'blip_pickup' or 'blip_dropoff')
    elseif c.template == 'transport' then
        if c.stage == 'steal' then
            local veh = jobVehicle()
            if veh then setBlip(nil, 'blip_vehicle', veh) else setBlip(d.pickup, 'blip_vehicle') end
        else
            setBlip(d.drop, 'blip_dropoff')
        end
    elseif c.template == 'collect' then
        if debtor and DoesEntityExist(debtor) then setBlip(nil, 'blip_debtor', debtor) else setBlip(d.spot, 'blip_debtor') end
    end
end

local function begin(view)
    clearWorld()
    current = view
    current.endsAt = GetGameTimer() + view.secondsLeft * 1000
    busy, warned, keysGiven, enteredSent, subduedSent = false, false, false, false, false
    applyStage()
end

RegisterNetEvent('vinewood_gangs:client:contractStart', function(view)
    begin(view)
    notify('contract_started', 'success')
end)

RegisterNetEvent('vinewood_gangs:client:contractStage', function(stage, outcome)
    if not current then return end
    current.stage = stage

    if current.template == 'collect' and debtor and DoesEntityExist(debtor) then
        ClearPedTasksImmediately(debtor)
        SetBlockingOfNonTemporaryEvents(debtor, false)
        if outcome == 'flee' then
            TaskSmartFleePed(debtor, cache.ped, 400.0, -1, false, false)
            notify('debtor_ran', 'error')
        elseif outcome == 'fight' then
            GiveWeaponToPed(debtor, GetHashKey('WEAPON_BAT'), 1, false, true)
            TaskCombatPed(debtor, cache.ped, 0, 16)
            notify('debtor_fights', 'error')
        end
    end
    applyStage()
end)

RegisterNetEvent('vinewood_gangs:client:contractEnd', function(result, info)
    clearWorld()
    current = nil
    if result == 'completed' then
        notify('contract_done', 'success', Utils.FormatMoney(info))
    else
        notify('contract_failed', 'error', locale('fail_' .. tostring(info)))
    end
end)

-- Every minute, check the server still has our job; if not, clear the blip and markers
CreateThread(function()
    while true do
        Wait(60000)
        if current then
            local view = lib.callback.await('vinewood_gangs:server:contractResume', false)
            if not view then
                clearWorld()
                current = nil
            end
        end
    end
end)

-- Pick the job back up after a relog or client restart
CreateThread(function()
    Wait(5000)
    local view = lib.callback.await('vinewood_gangs:server:contractResume', false)
    if view and not current then begin(view) end
end)

-------------------------------------------------------------------------------
-- Objective loop
-------------------------------------------------------------------------------

local function courier(c, pos)
    local stage = c.stage
    local target = stage == 'pickup' and c.data.pickup or c.data.drop
    local dist = #(pos - v3(target))
    if dist > 60.0 then return nil, 750 end
    marker(target, 1.5)
    if dist > 2.5 or IsPedInAnyVehicle(cache.ped, false) then return nil, 0 end

    if IsControlJustPressed(0, 38) then
        busy = true
        hidePrompt()
        if progress(3000, stage == 'pickup' and 'contract_progress_pickup' or 'contract_progress_deliver', PICKUP_ANIM) then
            local ok = act(stage == 'pickup' and 'pickup' or 'deliver')
            if ok and stage == 'pickup' then attachBox() end
        end
        busy = false
    end
    return stage == 'pickup' and 'contract_prompt_pickup' or 'contract_prompt_deliver', 0
end

local function transport(c, pos)
    local veh = jobVehicle()
    if veh and not keysGiven then
        keysGiven = true
        cfg.giveKeys(veh, c.data.plate)
    end

    if c.stage == 'steal' then
        if veh and blipEntity ~= veh then setBlip(nil, 'blip_vehicle', veh) end
        if veh and not enteredSent and GetVehiclePedIsIn(cache.ped, false) == veh then
            enteredSent = true
            if not act('entered') then enteredSent = false end
        end
        return nil, 500
    end

    local dist = #(pos - v3(c.data.drop))
    if dist > 80.0 then return nil, 750 end
    marker(c.data.drop, 4.0)
    if dist > 8.0 or not veh or GetVehiclePedIsIn(cache.ped, false) ~= veh then return nil, 0 end

    if IsControlJustPressed(0, 38) then
        busy = true
        hidePrompt()
        TaskLeaveVehicle(cache.ped, veh, 0)
        Wait(1500)
        act('handover')
        busy = false
    end
    return 'contract_prompt_handover', 0
end

local function collect(c, pos)
    local dist = #(pos - v3(c.data.spot))
    if not debtor and c.stage == 'find' and dist < 90.0 then spawnDebtor() end
    if not debtor or not DoesEntityExist(debtor) then return nil, 750 end

    local pd = #(pos - GetEntityCoords(debtor))
    local dead = IsEntityDead(debtor) or GetEntityHealth(debtor) <= 120

    if (c.stage == 'fight' or c.stage == 'chase') and dead and not subduedSent then
        subduedSent = true
        act(c.stage == 'fight' and 'subdued' or 'caught')
        return nil, 500
    end

    if c.stage == 'find' and pd < 3.0 and not dead then
        if IsControlJustPressed(0, 38) then
            busy = true
            hidePrompt()
            TaskTurnPedToFaceEntity(debtor, cache.ped, 1500)
            if progress(4000, 'contract_progress_intimidate', THREAT_ANIM) then
                local ok, outcome = act('intimidate')
                if ok and outcome == 'paid' then TaskHandsUp(debtor, 4000, cache.ped, -1, false) end
            end
            busy = false
        end
        return 'contract_prompt_intimidate', 0
    end

    if c.stage == 'chase' and pd < 2.5 and not dead then
        if IsControlJustPressed(0, 38) then
            busy = true
            hidePrompt()
            ClearPedTasksImmediately(debtor)
            TaskHandsUp(debtor, 5000, cache.ped, -1, false)
            act('caught')
            busy = false
        end
        return 'contract_prompt_grab', 0
    end

    return nil, pd < 40.0 and 0 or 500
end

local RUNNERS = { courier = courier, transport = transport, collect = collect }

CreateThread(function()
    while true do
        local want, sleep = nil, 750
        local c = current
        if c and not busy then
            if not warned and c.endsAt - GetGameTimer() < 60000 then
                warned = true
                notify('contract_one_minute', 'error')
            end
            local runner = RUNNERS[c.template]
            if runner then want, sleep = runner(c, GetEntityCoords(cache.ped)) end
        end
        if want ~= prompt and not busy then
            hidePrompt()
            if want then lib.showTextUI(locale(want)) end
            prompt = want
        end
        Wait(sleep or 750)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then clearWorld() end
end)
