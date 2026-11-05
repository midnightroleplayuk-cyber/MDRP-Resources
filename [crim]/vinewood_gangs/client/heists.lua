if not Config.Heists or not Config.Heists.enabled then return end

local cfg = Config.Heists
local run           -- the gang's heist in progress (from the server), or nil
local busy, prompt = false, nil
local blips = {}
local gameResult    -- promise resolved by the minigame

local VERB = { hack = 'heist_do_hack', thermite = 'heist_do_thermite', drill = 'heist_do_drill', loot = 'heist_do_loot',
    wait = 'heist_do_wait', truck_doors = 'heist_do_thermite' }

local function notify(key, kind, ...) lib.notify({ description = locale(key, ...), type = kind or 'inform' }) end

local function setPrompt(key, ...)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key, ...)) end
    prompt = key
end

-------------------------------------------------------------------------------
-- Minigames (web/minigames.js)
-------------------------------------------------------------------------------

RegisterNUICallback('minigameResult', function(data, cb)
    cb('ok')
    if gameResult then gameResult:resolve(data and data.success == true) end
end)

local function playGame(game, difficulty, time)
    gameResult = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'minigame', game = game, difficulty = difficulty, time = time })
    local ok = Citizen.Await(gameResult)
    SetNuiFocus(false, false)
    gameResult = nil
    return ok
end

-------------------------------------------------------------------------------
-- Blips and markers
-------------------------------------------------------------------------------

local function clearBlips()
    for _, b in ipairs(blips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    blips = {}
end

local function refreshBlips()
    clearBlips()
    if not run then return end
    for _, s in ipairs(run.steps) do
        if s.available and not s.done and s.x and s.type ~= 'truck' then
            local b = AddBlipForCoord(s.x, s.y, s.z)
            SetBlipSprite(b, 1)
            SetBlipScale(b, 0.7)
            SetBlipColour(b, 5)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(s.label)
            EndTextCommandSetBlipName(b)
            blips[#blips + 1] = b
        end
    end
    if run.truckNet and NetworkDoesEntityExistWithNetworkId(run.truckNet) then
        local b = AddBlipForEntity(NetToVeh(run.truckNet))
        SetBlipSprite(b, 67)
        SetBlipColour(b, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(run.label)
        EndTextCommandSetBlipName(b)
        blips[#blips + 1] = b
    end
    if run.escape then
        local b = AddBlipForRadius(run.escape.x, run.escape.y, run.escape.z, run.escape.r)
        SetBlipColour(b, 1)
        SetBlipAlpha(b, 70)
        blips[#blips + 1] = b
    end
end

RegisterNetEvent('vinewood_gangs:client:heistUpdate', function(view)
    local wasEscaping = run and run.escape
    run = view
    if run and run.escape and not wasEscaping then notify('heist_escape', 'success', run.label) end
    refreshBlips()
end)

-------------------------------------------------------------------------------
-- Working a step
-------------------------------------------------------------------------------

local function playAnim(anim)
    if not anim then return end
    lib.requestAnimDict(anim.dict)
    TaskPlayAnim(cache.ped, anim.dict, anim.clip, 4.0, -4.0, -1, 1, 0, false, false, false)
end

local function work(s)
    busy = true
    setPrompt(nil)
    local ok, game, extra = lib.callback.await('vinewood_gangs:server:heistBegin', false, run.id, s.i)
    if not ok then
        if game == 'heist_need_item' then notify('heist_need_item', 'error', extra) else notify(game or 'failed', 'error') end
        busy = false
        return
    end

    if s.w then SetEntityHeading(cache.ped, s.w) end
    playAnim((cfg.stepTypes[s.type] or {}).anim)
    local success
    if game.game then
        success = playGame(game.game, game.difficulty, game.time)
    else
        success = lib.progressBar({
            duration = (game.duration or 10) * 1000, label = s.label, canCancel = true,
            disable = { move = true, car = true, combat = true },
        })
    end
    ClearPedTasks(cache.ped)

    local ok2, res = lib.callback.await('vinewood_gangs:server:heistFinish', false, run and run.id, s.i, success == true)
    if ok2 and res then
        if res.result == 'failed' then
            notify('heist_step_failed', 'error', cfg.retryDelay)
        elseif res.reward and res.reward.money then
            notify('heist_loot_money', 'success', Utils.FormatMoney(res.reward.money))
        elseif res.reward and res.reward.item then
            notify('heist_loot_item', 'success', res.reward.count, res.reward.item)
        else
            notify('heist_step_done', 'success', s.label)
        end
    end
    busy = false
end

-------------------------------------------------------------------------------
-- Armoured truck guards (created by whoever started the job)
-------------------------------------------------------------------------------

RegisterNetEvent('vinewood_gangs:client:heistTruck', function(netId, truck)
    local timeout = GetGameTimer() + 10000
    while not NetworkDoesEntityExistWithNetworkId(netId) and GetGameTimer() < timeout do Wait(100) end
    if not NetworkDoesEntityExistWithNetworkId(netId) then return end
    local veh = NetToVeh(netId)
    local model = lib.requestModel(truck.guardModel)
    local group = GetHashKey('SECURITY_GUARD')
    for seat = -1, truck.guards - 2 do
        local ped = CreatePedInsideVehicle(veh, 4, model, seat, true, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetPedRelationshipGroupHash(ped, group)
        GiveWeaponToPed(ped, GetHashKey(truck.guardWeapon), 250, false, true)
        SetPedArmour(ped, 100)
        SetPedAccuracy(ped, 35)
        SetPedCombatAttributes(ped, 46, true) -- stand and fight
        SetPedFleeAttributes(ped, 0, false)
        SetPedKeepTask(ped, true)
        if seat == -1 then TaskVehicleDriveWander(ped, veh, truck.driveSpeed, 786603) end
    end
    SetModelAsNoLongerNeeded(model)
end)

-------------------------------------------------------------------------------
-- Prompts
-------------------------------------------------------------------------------

local function nearestStart(pos)
    local starts = GlobalState.vg_heist_starts or {}
    for _, h in ipairs(starts) do
        if #(pos - vector3(h.x, h.y, h.z)) < 2.5 then return h end
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        local gang = GetPlayerGang()
        if gang and not busy and not IsPedInAnyVehicle(cache.ped, false) then
            local pos = GetEntityCoords(cache.ped)
            local target, startHere

            if run then
                for _, s in ipairs(run.steps) do
                    if s.available and not s.done and s.x and s.type ~= 'truck' then
                        local d = #(pos - vector3(s.x, s.y, s.z))
                        if d < 25.0 then
                            sleep = 0
                            DrawMarker(1, s.x, s.y, s.z - 0.98, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.12, 240, 173, 78, s.busy and 60 or 140, false, false, 2, false, nil, nil, false)
                            if d < cfg.stepRadius and not s.busy then target = s end
                        end
                    end
                end
            elseif HasGangPermission('heists') then
                startHere = nearestStart(pos)
                if startHere then sleep = 0 end
            end

            if target then
                setPrompt(VERB[target.type] or 'heist_do_loot', target.label)
                if IsControlJustPressed(0, 38) then work(target) end
            elseif startHere then
                setPrompt('heist_start_prompt', startHere.label)
                if IsControlJustPressed(0, 38) then
                    setPrompt(nil)
                    local ok, err = lib.callback.await('vinewood_gangs:server:heistStart', false, startHere.id)
                    if not ok then notify(err or 'failed', 'error') end
                    Wait(1000)
                end
            else
                setPrompt(nil)
            end
        else
            setPrompt(nil)
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearBlips()
    if prompt then lib.hideTextUI() end
    if gameResult then SetNuiFocus(false, false) end
end)
