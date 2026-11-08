if not Config.Modules.supplyChains then return end

local run     -- our own collection run: { id, netId, plate, pickup, home, endsAt, keys }
local runBlip
local tips = {} -- tips[netId] = { blip, untilAt }
local busy, prompt = false, nil

local function notify(key, kind, ...)
    lib.notify({ description = locale(key, ...), type = kind or 'inform' })
end

local function setPrompt(key)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key)) end
    prompt = key
end

local function removeBlip(b) if b and DoesBlipExist(b) then RemoveBlip(b) end end

local function makeBlip(entity, point, labelKey, colour, route)
    local b = entity and AddBlipForEntity(entity) or AddBlipForCoord(point.x, point.y, point.z)
    SetBlipSprite(b, entity and 67 or 501)
    SetBlipColour(b, colour)
    if route then SetBlipRoute(b, true) SetBlipRouteColour(b, colour) end
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(locale(labelKey))
    EndTextCommandSetBlipName(b)
    return b
end

local function netVehicle(netId)
    if netId and NetworkDoesNetworkIdExist(netId) then
        local veh = NetToVeh(netId)
        if DoesEntityExist(veh) then return veh end
    end
end

-- Our gang's safehouse entrances (the only places a van can be unloaded)
local function ourEntrances()
    local gang = GetPlayerGang()
    local out = {}
    if not gang then return out end
    for _, h in ipairs(GlobalState.vg_safehouses or {}) do
        if h.gangId == gang.id then out[#out + 1] = h.entrance end
    end
    return out
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------

RegisterNetEvent('vinewood_gangs:client:supplyStart', function(data)
    removeBlip(runBlip)
    run = data
    run.endsAt = GetGameTimer() + data.secondsLeft * 1000
    runBlip = makeBlip(nil, data.pickup, 'blip_supply_pickup', 5, true)
    notify('supply_run_started', 'success', data.pickup.label)
end)

RegisterNetEvent('vinewood_gangs:client:supplyEnd', function(id)
    if run and run.id == id then
        removeBlip(runBlip)
        runBlip, run = nil, nil
    end
end)

RegisterNetEvent('vinewood_gangs:client:supplyTip', function(netId, where, seconds)
    tips[netId] = { untilAt = GetGameTimer() + seconds * 1000 }
    notify('supply_tip', 'inform', where)
end)

-------------------------------------------------------------------------------
-- Loop: blips, keys, and the unload prompt
-------------------------------------------------------------------------------

CreateThread(function()
    while true do
        local sleep = 1000
        local now = GetGameTimer()

        -- Our run: point at the van until we're in it, then at home
        if run then
            sleep = 500
            local veh = netVehicle(run.netId)
            if veh and not run.keys then
                run.keys = true
                Config.Contracts.giveKeys(veh, run.plate)
            end
            local inVan = veh and GetVehiclePedIsIn(cache.ped, false) == veh
            local stage = inVan and 'home' or (veh and 'van' or 'pickup')
            if stage ~= run.stage then
                removeBlip(runBlip)
                if stage == 'home' then
                    runBlip = makeBlip(nil, run.home, 'blip_supply_home', 2, true)
                elseif stage == 'van' then
                    runBlip = makeBlip(veh, nil, 'blip_supply_van', 5, true)
                else
                    runBlip = makeBlip(nil, run.pickup, 'blip_supply_pickup', 5, true)
                end
                run.stage = stage
            end
        end

        -- Tip-offs: show the van to rivals for a few minutes
        for netId, tip in pairs(tips) do
            if now > tip.untilAt then
                removeBlip(tip.blip)
                tips[netId] = nil
            elseif not tip.blip then
                local veh = netVehicle(netId)
                if veh then tip.blip = makeBlip(veh, nil, 'blip_supply_rival', 1, false) end
            end
        end

        -- Unload prompt: in a supply van, parked at one of our safehouses
        local want, shipmentId
        if not busy then
            local veh = GetVehiclePedIsIn(cache.ped, false)
            if veh ~= 0 then
                local id = tonumber((GetVehicleNumberPlateText(veh) or ''):match('SUP(%d+)'))
                if id then
                    sleep = 250
                    local pos = GetEntityCoords(veh)
                    for _, e in ipairs(ourEntrances()) do
                        if #(pos - vector3(e.x, e.y, e.z)) < 15.0 then
                            local mine = run and (run.id % 100000) == id
                            want, shipmentId, sleep = mine and 'supply_prompt_unload' or 'supply_prompt_fence', mine and run.id or id, 0
                            break
                        end
                    end
                end
            end
        end
        setPrompt(want)

        if want and IsControlJustPressed(0, 38) then
            busy = true
            setPrompt(nil)
            local done = lib.progressBar({
                duration = 6000, label = locale('supply_unloading'), canCancel = true,
                disable = { car = true, combat = true },
            })
            if done then
                local ok, res = lib.callback.await('vinewood_gangs:server:supplyUnload', false, shipmentId)
                if not ok then notify(res or 'failed', 'error') end
                if ok then TaskLeaveVehicle(cache.ped, GetVehiclePedIsIn(cache.ped, false), 0) end
            end
            busy = false
        end

        if run and now > run.endsAt + 5000 then
            removeBlip(runBlip)
            runBlip, run = nil, nil
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    removeBlip(runBlip)
    for _, t in pairs(tips) do removeBlip(t.blip) end
    if prompt then lib.hideTextUI() end
end)
