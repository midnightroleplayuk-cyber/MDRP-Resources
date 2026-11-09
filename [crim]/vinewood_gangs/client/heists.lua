if not Config.Heists or not Config.Heists.enabled then return end

local cfg = Config.Heists
local run           -- the gang's heist in progress (from the server), or nil
local busy, prompt = false, nil
local blips = {}
local gameResult    -- promise resolved by the minigame

local VERB = { hack = 'heist_do_hack', thermite = 'heist_do_thermite', drill = 'heist_do_drill', loot = 'heist_do_loot',
    wait = 'heist_do_wait', truck_doors = 'heist_do_thermite', talk = 'heist_do_talk' }
-- Steps whose spot is an NPC (no ground marker), or which aren't worked by pressing E
local NPC_STEP = { talk = true, hostage = true, guards = true }
local NO_PROMPT = { truck = true, hostage = true, guards = true }

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

    if s.type == 'talk' then
        local npc = NpcFor and NpcFor(s.i)
        if npc then
            TaskTurnPedToFaceEntity(cache.ped, npc, 1000)
            TaskTurnPedToFaceEntity(npc, cache.ped, 1000)
            Wait(800)
            PlayPedAmbientSpeechNative(npc, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE')
        end
    elseif s.w then
        SetEntityHeading(cache.ped, s.w)
    end
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
        if res.say and res.say ~= '' then
            lib.notify({ title = s.label, description = res.say, type = 'inform', duration = 10000 })
        elseif res.result == 'failed' then
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
-- NPC steps
-------------------------------------------------------------------------------

local npcs = {}        -- npcs[i] = the contact or hostage for step i (this game only: they don't fight)

---Loads a ped model, falling back to a default if the name doesn't exist in the game (or isn't streamed).
local function loadPed(name, fallback)
    for _, m in ipairs({ name, fallback }) do
        if m and IsModelInCdimage(GetHashKey(m)) and IsModelAPed(GetHashKey(m)) then
            return lib.requestModel(m, 10000)
        end
        if m == name and name then print(('^3[vinewood_gangs] heist NPC model "%s" does not exist, using %s^0'):format(tostring(name), tostring(fallback))) end
    end
end
local guardsOwned = {} -- guard ped netIds we've been told about, so we can keep their AI going
local asked = {}       -- asked[key] = true once we've asked the server something, so we don't ask every second

function NpcFor(i) local p = npcs[i] return p and DoesEntityExist(p) and p or nil end

local function removeNpc(i)
    if npcs[i] and DoesEntityExist(npcs[i]) then DeleteEntity(npcs[i]) end
    npcs[i] = nil
end

local function spawnNpc(s)
    local model = loadPed(s.ped or cfg.npc.ped, cfg.npc.ped)
    if not model then return end
    local ped = CreatePed(4, model, s.x, s.y, s.z - 1.0, s.w or 0.0, false, true)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    if s.type == 'talk' then
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
    else
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    end
    npcs[s.i] = ped
end

-- The guards' hostility is set on whichever game controls each guard (control moves between players)
local GUARD_GROUP = GetHashKey('VG_HEIST_GUARDS')
AddRelationshipGroup('VG_HEIST_GUARDS')
SetRelationshipBetweenGroups(5, GUARD_GROUP, GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GUARD_GROUP)

local function armGuard(ped, g)
    SetPedRelationshipGroupHash(ped, GUARD_GROUP)
    SetPedArmour(ped, g.armour or 50)
    SetPedAccuracy(ped, g.accuracy or 40)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 5, true)
    SetPedCombatAbility(ped, 2)
    SetPedCombatRange(ped, 1)
    SetPedFleeAttributes(ped, 0, false)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetPedKeepTask(ped, true)
    TaskCombatHatedTargetsAroundPed(ped, 60.0, 0)
end

local function spawnGuards(runId, i)
    local ok, g = lib.callback.await('vinewood_gangs:server:heistGuardsClaim', false, runId, i)
    if not ok or not g then return end
    local model = loadPed(g.ped, cfg.npc.guardPed)
    if not model then return end
    local nets = {}
    for n = 1, g.count do
        local x, y, z, w
        local spot = g.spots and g.spots[n]
        if spot then
            -- Placed one by one in the builder: exactly there, facing that way
            x, y, z, w = spot.x, spot.y, spot.z - 1.0, spot.w or 0.0
        else
            local a = (n / g.count) * math.pi * 2
            local r = g.radius * (0.4 + math.random() * 0.6)
            x, y = g.x + math.cos(a) * r, g.y + math.sin(a) * r
            local found, gz = GetGroundZFor_3dCoord(x, y, g.z + 3.0, false)
            z, w = found and gz or g.z, math.random(0, 359) + 0.0
        end
        local ped = CreatePed(4, model, x, y, z, w, true, true)
        if ped and ped ~= 0 then
            SetEntityAsMissionEntity(ped, true, true)
            GiveWeaponToPed(ped, GetHashKey(g.weapon), 250, false, true)
            armGuard(ped, g)
            TaskGuardCurrentPosition(ped, 15.0, 10.0, true)
            nets[#nets + 1] = NetworkGetNetworkIdFromEntity(ped)
        end
    end
    SetModelAsNoLongerNeeded(model)
    lib.callback.await('vinewood_gangs:server:heistGuardsSpawned', false, runId, i, nets)
end

-- Intimidating: aim at them until they comply. Returns true while the "aim at" hint is showing.
local aiming = false
function HostagePrompt(pos)
    if busy or aiming then return false end
    for _, s in ipairs(run.steps) do
        local ped = s.type == 'hostage' and s.available and not s.done and NpcFor(s.i)
        if ped and #(pos - GetEntityCoords(ped)) < cfg.npc.aimDistance then
            if IsPlayerFreeAimingAtEntity(PlayerId(), ped) and not s.busy then
                setPrompt(nil)
                aiming = true
                CreateThread(function()
                    local ok, game = lib.callback.await('vinewood_gangs:server:heistBegin', false, run.id, s.i)
                    if not ok then notify(game or 'failed', 'error') aiming = false return end
                    ClearPedTasksImmediately(ped)
                    TaskHandsUp(ped, -1, cache.ped, -1, true)
                    local endsAt, shown = GetGameTimer() + (game.duration or 8) * 1000, nil
                    local held = true
                    while GetGameTimer() < endsAt do
                        if IsEntityDead(ped) or not IsPlayerFreeAimingAtEntity(PlayerId(), ped) then held = false break end
                        local left = math.ceil((endsAt - GetGameTimer()) / 1000)
                        if left ~= shown then lib.showTextUI(locale('heist_intimidating', ('0:%02d'):format(left))) shown = left end
                        Wait(0)
                    end
                    lib.hideTextUI()
                    if held then
                        local ok2 = lib.callback.await('vinewood_gangs:server:heistFinish', false, run and run.id, s.i, true)
                        if ok2 then notify('heist_hostage_complied', 'success', s.label) end
                    else
                        lib.callback.await('vinewood_gangs:server:heistFinish', false, run and run.id, s.i, false)
                        if not IsEntityDead(ped) then notify('heist_hostage_lost', 'error') TaskHandsUp(ped, 4000, cache.ped, -1, true) end
                    end
                    aiming = false
                end)
                return true
            end
            setPrompt('heist_aim_hint', s.label)
            return true
        end
    end
    return false
end

-- Keep NPCs in step with the heist: show them when the crew is near, take them away when done; spot a
-- killed hostage; spawn guards; keep the guards we control fighting.
CreateThread(function()
    while true do
        local sleep = 1500
        if run then
            local pos = GetEntityCoords(cache.ped)
            local wanted = {}
            for _, s in ipairs(run.steps) do
                if (s.type == 'talk' or s.type == 'hostage') and s.x and not s.done then
                    local near = #(pos - vector3(s.x, s.y, s.z)) < cfg.npc.spawnDistance
                    if near then
                        wanted[s.i] = true
                        if not NpcFor(s.i) then spawnNpc(s) end
                        local ped = NpcFor(s.i)
                        if s.type == 'hostage' and s.available and ped and IsEntityDead(ped) and not asked['dead' .. run.id .. ':' .. s.i] then
                            asked['dead' .. run.id .. ':' .. s.i] = true
                            lib.callback.await('vinewood_gangs:server:heistHostageKilled', false, run.id, s.i)
                        end
                    end
                elseif s.type == 'guards' and s.available and not s.done and s.x and not s.guardsUp
                    and #(pos - vector3(s.x, s.y, s.z)) < cfg.npc.spawnDistance and not asked['guards' .. run.id .. ':' .. s.i] then
                    asked['guards' .. run.id .. ':' .. s.i] = true
                    spawnGuards(run.id, s.i)
                    -- If the server said no (someone else is spawning them), we can ask again later
                    SetTimeout(25000, function() asked['guards' .. (run and run.id or 0) .. ':' .. s.i] = nil end)
                end
                if s.guards then
                    for _, n in ipairs(s.guards) do guardsOwned[n] = s end
                end
            end
            -- A talk step that's done keeps its NPC a moment (they just spoke); a dead hostage stays where they fell
            for i in pairs(npcs) do
                local s = run.steps[i]
                if not wanted[i] and not (s and s.type == 'hostage' and s.done) then removeNpc(i) end
            end
            -- Guards we control: keep them hostile and fighting
            for n in pairs(guardsOwned) do
                if NetworkDoesEntityExistWithNetworkId(n) then
                    local ped = NetToPed(n)
                    if NetworkGetEntityOwner(ped) == PlayerId() and not IsEntityDead(ped) then
                        if GetPedRelationshipGroupHash(ped) ~= GUARD_GROUP or not IsPedInCombat(ped, 0) then
                            armGuard(ped, guardsOwned[n])
                        end
                    end
                end
            end
            sleep = 1000
        else
            for i in pairs(npcs) do removeNpc(i) end
            guardsOwned, asked = {}, {}
        end
        Wait(sleep)
    end
end)

-------------------------------------------------------------------------------
-- Contacts who start a heist (stand at its start point; the crew talks to them to begin)
-------------------------------------------------------------------------------

local contacts = {} -- contacts[heistId] = ped (this game only)

CreateThread(function()
    while true do
        local sleep = 1500
        local list = GlobalState.vg_heist_starts or {}
        local pos = GetEntityCoords(cache.ped)
        local wanted = {}
        for _, st in ipairs(list) do
            if st.npc then
                local d = #(pos - vector3(st.x, st.y, st.z))
                if d < cfg.npc.spawnDistance then
                    wanted[st.id] = true
                    if not (contacts[st.id] and DoesEntityExist(contacts[st.id])) then
                        local model = loadPed(st.npc.ped, cfg.npc.ped)
                        if model then
                            local ped = CreatePed(4, model, st.x, st.y, st.z - 1.0, st.w or 0.0, false, true)
                            SetModelAsNoLongerNeeded(model)
                            SetEntityInvincible(ped, true)
                            FreezeEntityPosition(ped, true)
                            SetBlockingOfNonTemporaryEvents(ped, true)
                            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
                            contacts[st.id] = ped
                        end
                    end
                    -- Walk up and press E (no prompt while a heist is already running for us)
                    if d < 2.2 and not run and not busy and (st.anyone or GetPlayerGang()) then
                        sleep = 0
                        setPrompt('heist_start_npc', st.npc.name or '?', st.label)
                        if IsControlJustPressed(0, 38) then
                            setPrompt(nil)
                            local ped = contacts[st.id]
                            if ped then TaskTurnPedToFaceEntity(cache.ped, ped, 800) end
                            local ok, res, extra = lib.callback.await('vinewood_gangs:server:heistStartNpc', false, st.id)
                            if ok then
                                if res and res ~= '' then lib.notify({ title = st.npc.name, description = res, type = 'inform', duration = 10000 }) end
                                if ped then PlayPedAmbientSpeechNative(ped, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE') end
                            else
                                notify(res or 'failed', 'error', extra)
                            end
                            Wait(1000)
                        end
                    elseif d < 3.0 and prompt == 'heist_start_npc' then
                        setPrompt(nil)
                    end
                end
            end
        end
        for id, ped in pairs(contacts) do
            if not wanted[id] then
                if DoesEntityExist(ped) then DeleteEntity(ped) end
                contacts[id] = nil
            end
        end
        Wait(sleep)
    end
end)

-------------------------------------------------------------------------------
-- Prompts
-------------------------------------------------------------------------------

local function nearestStart(pos, anyoneOnly)
    local starts = GlobalState.vg_heist_starts or {}
    for _, h in ipairs(starts) do
        -- Jobs started by talking to a contact don't have a marker (the contact is there instead).
        -- Players with no gang only get jobs open to anyone.
        if not h.npc and (not anyoneOnly or h.anyone) and #(pos - vector3(h.x, h.y, h.z)) < 2.5 then return h end
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        local gang = GetPlayerGang()
        -- Gang members, or anyone on a job / near one that's open to everyone
        if not busy and not IsPedInAnyVehicle(cache.ped, false) then
            local pos = GetEntityCoords(cache.ped)
            local target, startHere

            if run then
                for _, s in ipairs(run.steps) do
                    if s.available and not s.done and s.x and not NO_PROMPT[s.type] then
                        local d = #(pos - vector3(s.x, s.y, s.z))
                        if d < 25.0 then
                            sleep = 0
                            if not NPC_STEP[s.type] then
                                DrawMarker(1, s.x, s.y, s.z - 0.98, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.12, 240, 173, 78, s.busy and 60 or 140, false, false, 2, false, nil, nil, false)
                            end
                            if d < cfg.stepRadius + (NPC_STEP[s.type] and 0.8 or 0) and not s.busy then target = s end
                        end
                    end
                end
            elseif gang and HasGangPermission('heists') then
                startHere = nearestStart(pos)
            elseif not gang then
                startHere = nearestStart(pos, true)
                if startHere then sleep = 0 end
            end

            if target then
                setPrompt(VERB[target.type] or 'heist_do_loot', target.label)
                if IsControlJustPressed(0, 38) then work(target) end
            elseif run and HostagePrompt and HostagePrompt(pos) then
                sleep = 0
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
    for i in pairs(npcs) do removeNpc(i) end
    for _, ped in pairs(contacts) do if DoesEntityExist(ped) then DeleteEntity(ped) end end
    if prompt then lib.hideTextUI() end
    if gameResult then SetNuiFocus(false, false) end
end)
