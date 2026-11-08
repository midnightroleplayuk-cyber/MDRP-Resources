if not Config.Drugs or not Config.Drugs.enabled then return end
local turfHintAt -- when we last said which drug builds turf control

local cfg = Config.Drugs
local status = { canSell = false } -- from the server: can I deal here, and with what
local used = {}                    -- pedestrians already approached: used[ped] = GetGameTimer() until free again
local busy, prompt, target = false, nil, nil

local GIVE = { dict = 'mp_common', clip = 'givetake1_a' }

local function notify(key, kind, ...) lib.notify({ description = locale(key, ...), type = kind or 'inform' }) end

local function setPrompt(key, ...)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key, ...)) end
    prompt = key
end

local function refresh()
    status = lib.callback.await('vinewood_gangs:server:drugStatus', false) or { canSell = false }
end

-- Check what we can sell on entering an area, joining a gang, and every so often while in an area
AddEventHandler('vinewood_gangs:client:zoneChanged', function() SetTimeout(300, refresh) end)
AddEventHandler('vinewood_gangs:client:gangUpdated', function() SetTimeout(300, refresh) end)
CreateThread(function()
    Wait(6000)
    while true do
        if GetPlayerGang() or not cfg.gangOnly then refresh() end
        Wait(20000)
    end
end)

---A pedestrian we could approach: on foot, alive, not a player or a police officer, close and in front of us.
local function findBuyer()
    local me = cache.ped
    local pos, fwd = GetEntityCoords(me), GetEntityForwardVector(me)
    local best, bestDist
    local t = GetGameTimer()
    for _, ped in ipairs(GetGamePool('CPed')) do
        if ped ~= me and not IsPedAPlayer(ped) and IsPedHuman(ped) and not IsEntityDead(ped)
            and not IsPedInAnyVehicle(ped, false) and not (used[ped] and used[ped] > t) then
            local ptype = GetPedType(ped)
            if ptype ~= 6 and ptype ~= 27 and ptype ~= 29 then -- cops, SWAT, army
                local d = #(pos - GetEntityCoords(ped))
                if d < 2.2 then
                    local dir = (GetEntityCoords(ped) - pos) / math.max(d, 0.01)
                    if fwd.x * dir.x + fwd.y * dir.y > 0.3 and (not best or d < bestDist) then best, bestDist = ped, d end
                end
            end
        end
    end
    return best
end

local function deal(ped)
    busy = true
    setPrompt(nil)
    used[ped] = GetGameTimer() + 15 * 60000 -- each pedestrian can only be approached once in a while

    -- The buyer stops and listens
    ClearPedTasks(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskTurnPedToFaceEntity(ped, cache.ped, cfg.dealTime)
    TaskTurnPedToFaceEntity(cache.ped, ped, 800)

    local done = lib.progressBar({
        duration = cfg.dealTime, label = locale('drugs_dealing'), canCancel = true,
        disable = { move = true, car = true, combat = true },
    })

    local ok, res = false, 'failed'
    if done then ok, res = lib.callback.await('vinewood_gangs:server:drugSell', false) end

    SetBlockingOfNonTemporaryEvents(ped, false)
    if not done then
        ClearPedTasks(ped)
    elseif not ok then
        ClearPedTasks(ped)
        notify(res or 'failed', 'error')
    elseif res.result == 'sold' then
        lib.requestAnimDict(GIVE.dict)
        TaskPlayAnim(cache.ped, GIVE.dict, GIVE.clip, 8.0, -8.0, 1500, 49, 0, false, false, false)
        TaskPlayAnim(ped, GIVE.dict, 'givetake1_b', 8.0, -8.0, 1500, 49, 0, false, false, false)
        notify(res.dirty and 'drugs_sold_dirty' or 'drugs_sold', 'success', res.qty, res.label, Utils.FormatMoney(res.paid))
        local t = res.turf
        if t and t.own and t.counted then
            notify('drugs_turf_gain', 'success', t.label, t.gained, t.control)
        elseif t and t.own and not t.counted and GetGameTimer() > (turfHintAt or 0) then
            turfHintAt = GetGameTimer() + 300000 -- every 5 minutes at most
            notify('drugs_turf_not_counted', 'inform', t.needs ~= '' and t.needs or '?')
        end
        SetTimeout(1600, function() if DoesEntityExist(ped) then TaskWanderStandard(ped, 10.0, 10) end end)
    elseif res.result == 'declined' then
        notify('drugs_declined', 'inform')
        TaskWanderStandard(ped, 10.0, 10)
    elseif res.result == 'snitched' then
        notify('drugs_snitched', 'error')
        TaskSmartFleePed(ped, cache.ped, 80.0, -1, false, false)
    elseif res.result == 'undercover' then
        notify('drugs_undercover', 'error', res.qty, res.label)
        TaskSmartFleePed(ped, cache.ped, 30.0, 4000, false, false)
    end
    refresh()
    busy = false
end

CreateThread(function()
    while true do
        local sleep = 1000
        target = nil
        if status.canSell and not busy and not IsPedInAnyVehicle(cache.ped, false) and not IsEntityDead(cache.ped) then
            sleep = 250
            target = findBuyer()
            if target then sleep = 0 end
        end

        if target then setPrompt('drugs_prompt', status.label) else setPrompt(nil) end
        if target and IsControlJustPressed(0, 38) then deal(target) end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and prompt then lib.hideTextUI() end
end)
