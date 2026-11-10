Systems = {}          -- [id] = public system
States  = {}          -- [id] = public state
IsAdmin = false
EngineerOn = {}       -- [id] = true while this player holds level 3 at that panel

local targetZones = {} -- [id] = { zoneIds }
local props = {}       -- ['id:devId'] = { entity, model }
local panelOpen

local function contains(t, v) if not t then return false end for i = 1, #t do if t[i] == v then return true end end return false end

function IsSounding(id)
    local st = States[id]
    if not st then return false end
    return ((st.fire or st.evacuate) and not st.silenced) or st.testSounding
end
exports('IsSounding', IsSounding)

---------------------------------------------------------------------
-- Interactions
---------------------------------------------------------------------
local function playPress()
    local ped = PlayerPedId()
    lib.requestAnimDict('anim@apt_trans@buzzer')
    TaskPlayAnim(ped, 'anim@apt_trans@buzzer', 'buzz_reg', 8.0, -8.0, 1200, 48, 0, false, false, false)
    Wait(700)
    RemoveAnimDict('anim@apt_trans@buzzer')
end

local function BreakGlass(id, devId)
    playPress()
    local ok, msg = lib.callback.await('vinewood_firealarm:breakGlass', false, id, devId)
    if not ok then lib.notify({ type = 'error', description = msg or 'Nothing happened' }) end
end

local function ResetDevice(id, devId)
    playPress()
    local ok, msg = lib.callback.await('vinewood_firealarm:resetDevice', false, id, devId)
    lib.notify({ type = ok and 'success' or 'error', description = ok and 'Call point reset' or msg })
end

local function TestDevice(id, devId)
    local ok, msg = lib.callback.await('vinewood_firealarm:testDevice', false, id, devId)
    if not ok then lib.notify({ type = 'error', description = msg or 'Test failed' }) end
end

local SERVICE_ANIMS = {
    ceiling = { dict = 'amb@prop_human_movie_bulb@base', clip = 'base' },
    wall = { dict = 'mini@repair', clip = 'fixing_a_ped' },
}
local SERVICE_LABELS = {
    panel = 'Checking panel and batteries', mcp = 'Testing call point with key',
    detector = 'Testing detector with smoke pole', sounder = 'Checking sounder output',
    sprinkler = 'Inspecting sprinkler head',
}

local function isMyService(id)
    local st = States[id]
    return st and st.service and st.service.src == cache.serverId
end

local function ServiceDevice(id, d)
    local secs = (Config.Servicing.times or {})[d.type] or 6
    local anim = (d.type == 'detector' or d.type == 'sprinkler') and SERVICE_ANIMS.ceiling or SERVICE_ANIMS.wall
    if not lib.progressBar({
        duration = secs * 1000, label = SERVICE_LABELS[d.type] or 'Testing device',
        canCancel = true, disable = { move = true, car = true, combat = true },
        anim = anim,
    }) then return end
    local ok, res = lib.callback.await('vinewood_firealarm:serviceDevice', false, id, d.id)
    if ok then
        lib.notify({ type = 'success', description = res and ('%s repaired and tested'):format(d.label) or ('%s tested'):format(d.label) })
    else
        lib.notify({ type = 'error', description = res or 'Test failed' })
    end
end

function OpenPanel(id)
    local data = lib.callback.await('vinewood_firealarm:openPanel', false, id)
    if not data then return lib.notify({ type = 'error', description = 'You can\'t reach the panel from here' }) end
    panelOpen = id
    EngineerOn[id] = data.level >= 3 or nil
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openPanel', system = data.system, state = data.state, level = data.level, maxZones = Config.MaxZones,
        servicer = data.servicer, me = data.me, interval = Config.Servicing.interval, dueSoon = Config.Servicing.dueSoon })
end

---------------------------------------------------------------------
-- Targets
---------------------------------------------------------------------
local function clearTargets(id)
    for _, z in ipairs(targetZones[id] or {}) do exports.ox_target:removeZone(z) end
    targetZones[id] = nil
end

local function buildTargets(id)
    clearTargets(id)
    local sys = Systems[id]
    if not sys then return end
    local list = {}
    for _, d in ipairs(sys.devices) do
        local options
        if d.type == 'panel' then
            options = {
                { name = 'vfa_panel', icon = 'fa-solid fa-bell', label = 'Use fire alarm panel', distance = Config.TargetDistance,
                  onSelect = function() OpenPanel(id) end },
            }
        elseif d.type == 'mcp' then
            options = {
                { name = 'vfa_break', icon = 'fa-solid fa-hand-back-fist', label = 'Break glass', distance = Config.TargetDistance,
                  canInteract = function() return not contains(States[id] and States[id].active, d.id) end,
                  onSelect = function() BreakGlass(id, d.id) end },
                { name = 'vfa_reset', icon = 'fa-solid fa-key', label = 'Reset call point', distance = Config.TargetDistance,
                  canInteract = function() return contains(States[id] and States[id].active, d.id) end,
                  onSelect = function() ResetDevice(id, d.id) end },
            }
        elseif d.type == 'detector' then
            options = {
                { name = 'vfa_test', icon = 'fa-solid fa-spray-can', label = 'Test detector', distance = 4.0,
                  canInteract = function() return IsAdmin or EngineerOn[id] end,
                  onSelect = function() TestDevice(id, d.id) end },
            }
        end
        if Config.Servicing.enabled then
            options = options or {}
            options[#options + 1] = {
                name = 'vfa_service', icon = 'fa-solid fa-screwdriver-wrench', label = 'Service device', distance = 2.5,
                canInteract = function()
                    return isMyService(id) and not contains(States[id].service.tested, d.id)
                end,
                onSelect = function() ServiceDevice(id, d) end,
            }
        end
        if options then
            local radius = d.type == 'panel' and 0.6 or ((d.type == 'detector' or d.type == 'sprinkler') and 0.5 or 0.3)
            list[#list + 1] = exports.ox_target:addSphereZone({
                coords = vec3(d.x, d.y, d.z),
                radius = radius,
                debug = Config.Debug,
                options = options,
            })
        end
    end
    targetZones[id] = list
end

---------------------------------------------------------------------
-- Props
---------------------------------------------------------------------
local function deleteProp(key)
    local p = props[key]
    if p and DoesEntityExist(p.entity) then DeleteEntity(p.entity) end
    props[key] = nil
end

local function wantedModel(id, d)
    if d.type == 'mcp' and Config.Props.mcp_active and contains(States[id] and States[id].active, d.id) then
        local h = joaat(Config.Props.mcp_active)
        if IsModelInCdimage(h) then return h end
    end
    local name = Config.Props[d.type]
    local h = name and joaat(name)
    return (h and IsModelInCdimage(h)) and h or nil
end

CreateThread(function()
    while true do
        local pc = GetEntityCoords(PlayerPedId())
        local seen = {}
        for id, sys in pairs(Systems) do
            for _, d in ipairs(sys.devices) do
                if d.mode == 'prop' then
                    local key = id .. ':' .. d.id
                    seen[key] = true
                    local dist = #(pc - vec3(d.x, d.y, d.z))
                    local p = props[key]
                    if dist < Config.SpawnDistance then
                        local model = wantedModel(id, d)
                        local moved = p and (p.x ~= d.x or p.y ~= d.y or p.z ~= d.z or p.h ~= d.h)
                        if model and (not p or moved or p.model ~= model or not DoesEntityExist(p.entity)) then
                            deleteProp(key)
                            lib.requestModel(model, 5000)
                            local ep = Placement.EntityPos(vec3(d.x, d.y, d.z), d.h, Placement.AnchorFor(d.type))
                            local e = CreateObjectNoOffset(model, ep.x, ep.y, ep.z, false, false, false)
                            SetEntityHeading(e, d.h)
                            FreezeEntityPosition(e, true)
                            SetModelAsNoLongerNeeded(model)
                            props[key] = { entity = e, model = model, x = d.x, y = d.y, z = d.z, h = d.h }
                        end
                    elseif p and dist > Config.SpawnDistance + 10.0 then
                        deleteProp(key)
                    end
                end
            end
        end
        for key in pairs(props) do if not seen[key] then deleteProp(key) end end
        Wait(1000)
    end
end)

---------------------------------------------------------------------
-- Sound + beacons
---------------------------------------------------------------------
local interiorCache = {}
local function interiorOf(key, d)
    if interiorCache[key] == nil then interiorCache[key] = GetInteriorAtCoords(d.x, d.y, d.z) end
    return interiorCache[key]
end

local nearbyBeacons = {}
local lastVol, lastTone = -1, nil

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local myInterior = GetInteriorFromEntity(ped)
        local best, bestTone = 0.0, nil
        local beacons = {}

        for id, sys in pairs(Systems) do
            if IsSounding(id) then
                local sources, anySounder = {}, false
                local faults = States[id] and States[id].faults
                for _, d in ipairs(sys.devices) do if d.type == 'sounder' then anySounder = true break end end
                for _, d in ipairs(sys.devices) do
                    if (not anySounder or d.type == 'sounder') and not contains(faults, d.id) then sources[#sources + 1] = d end
                end
                for _, d in ipairs(sources) do
                    local dc = vec3(d.x, d.y, d.z)
                    local dist = #(pc - dc)
                    if dist < sys.radius then
                        local v = (1.0 - dist / sys.radius) ^ 1.6
                        if interiorOf(id .. ':' .. d.id, d) ~= myInterior then v = v * Config.InteriorDampen end
                        if v > best then best, bestTone = v, sys.tone end
                    end
                    if Config.Beacons and d.type == 'sounder' and dist < 60.0 then beacons[#beacons + 1] = dc end
                end
            end
        end

        if Config.Debug and best > 0 and GetGameTimer() % 1000 < 260 then
            print(('[vinewood_firealarm] sounding: volume %.2f tone %s'):format(best * Config.MasterVolume, tostring(bestTone)))
        end
        nearbyBeacons = beacons
        local vol = math.floor(best * Config.MasterVolume * 100 + 0.5) / 100
        if vol ~= lastVol or bestTone ~= lastTone then
            lastVol, lastTone = vol, bestTone
            SendNUIMessage({ action = 'sound', volume = vol, tone = bestTone or Config.DefaultTone })
        end
        Wait(250)
    end
end)

CreateThread(function()
    while true do
        if #nearbyBeacons > 0 then
            local on = (GetGameTimer() % 1000) < 500
            if on then
                for _, c in ipairs(nearbyBeacons) do
                    DrawLightWithRange(c.x, c.y, c.z, 255, 20, 20, Config.BeaconRange, 6.0)
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

---------------------------------------------------------------------
-- Sync
---------------------------------------------------------------------
local function loadAll()
    local systems, states = lib.callback.await('vinewood_firealarm:getAll', false)
    for id in pairs(Systems) do clearTargets(id) end
    Systems, States = {}, {}
    for _, sys in ipairs(systems or {}) do
        Systems[sys.id] = sys
        States[sys.id] = states[tostring(sys.id)]
        buildTargets(sys.id)
    end
    IsAdmin = lib.callback.await('vinewood_firealarm:isAdmin', false)
end

RegisterNetEvent('vinewood_firealarm:refresh', loadAll)

RegisterNetEvent('vinewood_firealarm:syncSystem', function(id, sys)
    if sys then Systems[id] = sys else Systems[id], States[id] = nil, nil end
    for k in pairs(interiorCache) do if k:find('^' .. id .. ':') then interiorCache[k] = nil end end
    buildTargets(id)
    if not sys then clearTargets(id) end
    if panelOpen == id then
        if sys then SendNUIMessage({ action = 'panelSystem', system = sys })
        else SetNuiFocus(false, false) SendNUIMessage({ action = 'closePanel' }) panelOpen = nil end
    end
end)

RegisterNetEvent('vinewood_firealarm:syncState', function(id, st)
    States[id] = st or nil
    if panelOpen == id and st then SendNUIMessage({ action = 'panelState', state = st }) end
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end
    Wait(2000)
    loadAll()
end)

-- Re-check admin on character load (framework-agnostic)
AddEventHandler('QBCore:Client:OnPlayerLoaded', loadAll)
AddEventHandler('esx:playerLoaded', loadAll)

---------------------------------------------------------------------
-- Panel NUI callbacks
---------------------------------------------------------------------
RegisterNUICallback('panelClose', function(_, cb)
    SetNuiFocus(false, false)
    panelOpen = nil
    cb('ok')
end)

RegisterNUICallback('panelCode', function(data, cb)
    if not panelOpen then return cb({ ok = false }) end
    local level, msg = lib.callback.await('vinewood_firealarm:enterCode', false, panelOpen, data.code)
    if level then EngineerOn[panelOpen] = level >= 3 or nil end
    cb({ ok = level and true or false, level = level, msg = msg })
end)

RegisterNUICallback('panelAction', function(data, cb)
    if not panelOpen then return cb({ ok = false }) end
    local res = lib.callback.await('vinewood_firealarm:panelAction', false, panelOpen, data.action, data.arg)
    if res and res.level then EngineerOn[panelOpen] = res.level >= 3 or nil end
    cb(res or { ok = false })
end)

RegisterNUICallback('panelRefresh', function(_, cb)
    if not panelOpen then return cb(false) end
    cb(lib.callback.await('vinewood_firealarm:openPanel', false, panelOpen) or false)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for key in pairs(props) do deleteProp(key) end
end)

---------------------------------------------------------------------
-- cd_dispatch relay: cd_dispatch takes alerts from a client, so the
-- server hands the alarm's alert to the player nearest the premises.
---------------------------------------------------------------------
RegisterNetEvent('vinewood_firealarm:cdRelay', function(data)
    if GetResourceState('cd_dispatch') ~= 'started' then return end
    local ok, info = pcall(function() return exports['cd_dispatch']:GetPlayerInfo() end)
    data.unique_id = ok and info and info.unique_id or tostring(math.random(100000, 999999))
    data.coords = vec3(data.coords.x, data.coords.y, data.coords.z)
    TriggerServerEvent('cd_dispatch:AddNotification', data)
end)

---------------------------------------------------------------------
-- Automatic detection (GTA fires, explosions, smoke grenades).
-- vinewood_fire fires are checked on the server instead.
---------------------------------------------------------------------
local SMOKE = { `WEAPON_SMOKEGRENADE`, `WEAPON_BZGAS` }

CreateThread(function()
    local hits, cooldown = {}, {}
    while true do
        local D = Config.Detection
        Wait(D and D.interval or 2000)
        if D and D.enabled and (D.nativeFire or D.explosions or D.smokeGrenades) then
            local pc = GetEntityCoords(PlayerPedId())
            local now = GetGameTimer()
            for id, sys in pairs(Systems) do
                local st = States[id]
                for _, d in ipairs(sys.devices) do
                    if d.type == 'detector' and #(pc - vec3(d.x, d.y, d.z)) < 60.0 then
                        local key = id .. ':' .. d.id
                        local active = st and contains(st.active, d.id)
                        local kind
                        if not active and (cooldown[key] or 0) < now then
                            if D.nativeFire and GetNumberOfFiresInRange(d.x, d.y, d.z, D.range) > 0 then
                                kind = 'fire'
                            elseif D.explosions and IsExplosionInSphere(-1, d.x, d.y, d.z, D.range) then
                                kind = 'explosion'
                            elseif D.smokeGrenades then
                                for _, w in ipairs(SMOKE) do
                                    if IsProjectileTypeWithinDistance(d.x, d.y, d.z, w, D.range, false) then kind = 'smoke' break end
                                end
                            end
                        end
                        if kind then
                            hits[key] = (hits[key] or 0) + 1
                            -- explosions are instant; everything else must persist
                            if kind == 'explosion' or hits[key] >= D.confirm then
                                hits[key] = 0
                                cooldown[key] = now + 15000
                                TriggerServerEvent('vinewood_firealarm:detect', id, d.id, kind)
                            end
                        else
                            hits[key] = nil
                        end
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------------------
-- Sprinklers: spray effect, soaking, putting out GTA fires, and
-- applying water to vinewood_fire when the server asks.
---------------------------------------------------------------------
local sprayFx = {} -- ['id:dev'] = handle

local function sprinklerList()
    local list = {}
    for id, st in pairs(States) do
        local sys = Systems[id]
        if sys and st.sprinklers then
            for _, devId in ipairs(st.sprinklers) do
                for _, d in ipairs(sys.devices) do
                    if d.id == devId then list[id .. ':' .. d.id] = d break end
                end
            end
        end
    end
    return list
end

CreateThread(function()
    local S = Config.Sprinklers
    if not S or not S.enabled then return end
    local fx = S.ptfx
    while true do
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local active = sprinklerList()
        local any = false

        for key, d in pairs(active) do
            local c = vec3(d.x, d.y, d.z)
            local dist = #(pc - c)
            if dist < 60.0 then
                any = true
                if not sprayFx[key] then
                    lib.requestNamedPtfxAsset(fx.dict)
                    UseParticleFxAsset(fx.dict)
                    sprayFx[key] = StartParticleFxLoopedAtCoord(fx.name, c.x, c.y, c.z + fx.offset, fx.rot.x, fx.rot.y, fx.rot.z, fx.scale, false, false, false, false)
                end
                if S.suppressNative then StopFireInRange(c.x, c.y, c.z - 1.5, S.coverage) end
                if S.wetPlayers and #(vec2(pc.x, pc.y) - vec2(c.x, c.y)) < S.coverage and pc.z < c.z and c.z - pc.z < 6.0 then
                    SetPedWetnessHeight(ped, 2.0)
                end
            elseif sprayFx[key] then
                StopParticleFxLooped(sprayFx[key], false)
                sprayFx[key] = nil
            end
        end

        for key, h in pairs(sprayFx) do
            if not active[key] then StopParticleFxLooped(h, false) sprayFx[key] = nil end
        end
        Wait(any and 500 or 1500)
    end
end)

RegisterNetEvent('vinewood_firealarm:sprinklerAgent', function(origins)
    local S = Config.Sprinklers
    if GetResourceState('vinewood_fire') ~= 'started' then return end
    local down = vec3(0.0, 0.0, -1.0)
    for _ = 1, 4 do
        for _, o in ipairs(origins) do
            pcall(function()
                exports.vinewood_fire:ApplyAgent(vec3(o.x, o.y, o.z), down, S.agent, S.coverage + 3.0, 60.0, S.rate, 0.25)
            end)
        end
        Wait(250)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, h in pairs(sprayFx) do StopParticleFxLooped(h, false) end
end)

---------------------------------------------------------------------
-- Service schedule (service jobs and admins)
---------------------------------------------------------------------
if Config.Servicing.enabled then
    RegisterCommand(Config.Servicing.command, function()
        local data = lib.callback.await('vinewood_firealarm:schedule', false)
        if not data then return lib.notify({ type = 'error', description = 'Only fire alarm engineers can see the service schedule' }) end
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'openSchedule', systems = data.systems, now = data.now })
    end, false)
end

RegisterNUICallback('scheduleClose', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('scheduleWaypoint', function(data, cb)
    if data.x and data.y then
        SetNewWaypoint(data.x + 0.0, data.y + 0.0)
        lib.notify({ type = 'inform', description = 'Waypoint set' })
    end
    cb('ok')
end)
