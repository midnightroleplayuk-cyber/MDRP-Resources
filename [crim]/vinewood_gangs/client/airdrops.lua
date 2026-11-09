if not Config.Airdrops or not Config.Airdrops.enabled then return end

-- Everything here is local to each player's game: the plane and the falling crate are for show, and the
-- server decides who gets the loot. Everyone sees the crate land in the same spot because it falls straight down.

local cfg = Config.Airdrops
local drops = {}  -- drops[id] = { data, blips, crate, chute, smoke, landed }
local busy, prompt = false, nil

local function notify(key, kind, ...) lib.notify({ description = locale(key, ...), type = kind or 'inform' }) end

local function setPrompt(key)
    if key == prompt then return end
    if prompt then lib.hideTextUI() end
    if key then lib.showTextUI(locale(key)) end
    prompt = key
end

local function groundAt(x, y)
    for _, start in ipairs({ 1000.0, 600.0, 300.0, 150.0 }) do
        local ok, z = GetGroundZFor_3dCoord(x, y, start, false)
        if ok then return z end
    end
    return nil
end

local function addBlips(d)
    local area = AddBlipForRadius(d.cx, d.cy, 0.0, d.radius)
    SetBlipColour(area, 1)
    SetBlipAlpha(area, 90)
    local mark = AddBlipForCoord(d.cx, d.cy, 0.0)
    SetBlipSprite(mark, 94) -- parachute
    SetBlipColour(mark, 1)
    SetBlipScale(mark, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(locale('airdrop_blip'))
    EndTextCommandSetBlipName(mark)
    return { area, mark }
end

local function cleanup(id)
    local e = drops[id]
    if not e then return end
    for _, b in ipairs(e.blips or {}) do if DoesBlipExist(b) then RemoveBlip(b) end end
    for _, ent in ipairs({ e.crate, e.chute, e.plane, e.pilot }) do if ent and DoesEntityExist(ent) then DeleteEntity(ent) end end
    if e.smoke then StopParticleFxLooped(e.smoke, false) end
    drops[id] = nil
end

local function startSmoke(e, x, y, z)
    lib.requestNamedPtfxAsset('core')
    UseParticleFxAssetNextCall('core')
    e.smoke = StartParticleFxLoopedAtCoord('exp_grd_flare', x, y, z + 0.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
end

---Put the crate on the ground (for anyone who wasn't nearby when it fell, or once it's landed).
local function placeLanded(e)
    local d = e.data
    local z = groundAt(d.x, d.y)
    if not z then return end
    if e.chute and DoesEntityExist(e.chute) then DeleteEntity(e.chute) e.chute = nil end
    if not (e.crate and DoesEntityExist(e.crate)) then
        local model = lib.requestModel(d.crate.model)
        e.crate = CreateObjectNoOffset(model, d.x, d.y, z, false, false, false)
        SetModelAsNoLongerNeeded(model)
    end
    SetEntityCoords(e.crate, d.x, d.y, z, false, false, false, false)
    PlaceObjectOnGroundProperly(e.crate)
    FreezeEntityPosition(e.crate, true)
    if not e.smoke then startSmoke(e, d.x, d.y, z) end
    e.landed = true
end

---The plane flies a straight line over the drop and the crate falls from it.
local function flyOver(e)
    local d = e.data
    local me = GetEntityCoords(cache.ped)
    if #(vector2(me.x, me.y) - vector2(d.x, d.y)) > 2500.0 then return end -- too far away to see

    local height = (groundAt(d.x, d.y) or 30.0) + d.plane.height
    local heading = math.random() * math.pi * 2
    local dir = vector3(math.cos(heading), math.sin(heading), 0.0)
    local from = vector3(d.x, d.y, height) - dir * 1500.0
    local to = vector3(d.x, d.y, height) + dir * 1500.0

    -- A wrong model name shouldn't stop the drop: fall back to planes that are in every copy of the game
    local planeModel
    for _, name in ipairs({ d.plane.model, 'cuban800', 'duster', 'titan' }) do
        if name and IsModelInCdimage(GetHashKey(name)) and IsModelAVehicle(GetHashKey(name)) then planeModel = name break end
        if name == d.plane.model then print(('^3[vinewood_gangs] air drop plane model "%s" does not exist, using a fallback^0'):format(tostring(name))) end
    end
    local model = lib.requestModel(planeModel, 15000)
    if not model then return end
    e.plane = CreateVehicle(model, from.x, from.y, from.z, 0.0, false, false)
    SetModelAsNoLongerNeeded(model)
    SetEntityHeading(e.plane, (math.deg(heading) - 90.0) % 360.0)
    SetVehicleEngineOn(e.plane, true, true, false)
    ControlLandingGear(e.plane, 3)
    SetEntityInvincible(e.plane, true)
    SetEntityCollision(e.plane, false, false)

    local total = #(to - from) / d.plane.speed
    local started = GetGameTimer()
    local dropped = false
    while e.plane and DoesEntityExist(e.plane) do
        local t = (GetGameTimer() - started) / 1000 / total
        if t >= 1.0 then break end
        local p = from + (to - from) * t
        SetEntityCoordsNoOffset(e.plane, p.x, p.y, p.z, false, false, false)
        if not dropped and t >= 0.5 then
            dropped = true
            CreateThread(function()
                -- Crate and chute fall straight down at a steady rate
                local cModel = lib.requestModel(d.crate.model)
                local pModel = lib.requestModel(d.crate.parachute)
                local ground = groundAt(d.x, d.y) or 0.0
                local z = p.z - 8.0
                e.crate = CreateObjectNoOffset(cModel, d.x, d.y, z, false, false, false)
                e.chute = CreateObjectNoOffset(pModel, d.x, d.y, z + 2.0, false, false, false)
                SetModelAsNoLongerNeeded(cModel)
                SetModelAsNoLongerNeeded(pModel)
                FreezeEntityPosition(e.crate, true)
                FreezeEntityPosition(e.chute, true)
                local last = GetGameTimer()
                while drops[d.id] == e and z > ground + 0.6 and not e.landed do
                    local now = GetGameTimer()
                    z = z - d.crate.fallSpeed * (now - last) / 1000
                    last = now
                    SetEntityCoordsNoOffset(e.crate, d.x, d.y, z, false, false, false)
                    if e.chute and DoesEntityExist(e.chute) then SetEntityCoordsNoOffset(e.chute, d.x, d.y, z + 2.0, false, false, false) end
                    Wait(0)
                end
                if drops[d.id] == e then placeLanded(e) end
            end)
        end
        Wait(0)
    end
    if e.plane and DoesEntityExist(e.plane) then DeleteEntity(e.plane) end
    e.plane = nil
end

RegisterNetEvent('vinewood_gangs:client:airdropIncoming', function(d)
    cleanup(d.id)
    local e = { data = d }
    drops[d.id] = e
    e.blips = addBlips(d)
    if not d.watching then notify('airdrop_incoming', 'inform') end
    CreateThread(function() flyOver(e) end)
end)

RegisterNetEvent('vinewood_gangs:client:airdropLanded', function(d)
    local e = drops[d.id]
    if not e then
        e = { data = d }
        drops[d.id] = e
        e.blips = addBlips(d)
    end
    e.data = d
    if not (d and d.watching) then notify('airdrop_landed', 'inform') end
    -- If we're near and it hasn't finished falling on our screen yet, it lands now
    local me = GetEntityCoords(cache.ped)
    if #(vector2(me.x, me.y) - vector2(d.x, d.y)) < 400.0 then placeLanded(e) else e.landed = true end
end)

RegisterNetEvent('vinewood_gangs:client:airdropGone', function(id)
    cleanup(id)
end)

-- Joining (or restarting) while a drop is up
CreateThread(function()
    Wait(8000)
    for _, d in ipairs(lib.callback.await('vinewood_gangs:server:airdropActive', false) or {}) do
        local e = { data = d, blips = addBlips(d) }
        drops[d.id] = e
        if d.state == 'landed' then e.landed = true end
    end
end)

local function mmss(ms)
    local sec = math.max(0, math.ceil(ms / 1000))
    return ('%d:%02d'):format(math.floor(sec / 60), sec % 60)
end

-- Someone (maybe us) is breaking into a crate: everyone who can see the drop gets the time left
RegisterNetEvent('vinewood_gangs:client:airdropOpening', function(id, seconds)
    local e = drops[id]
    if not e then return end
    e.openingUntil = seconds and (GetGameTimer() + seconds * 1000) or nil
    for _, b in ipairs(e.blips or {}) do if DoesBlipExist(b) then SetBlipFlashes(b, seconds ~= nil) end end
end)

local function drawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextScale(0.0, 0.38)
    SetTextFont(4)
    SetTextCentre(true)
    SetTextOutline()
    SetTextColour(255, 255, 255, 230)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

---Breaking the crate open takes a while. Getting hurt, knocked down, killed or moving away stops it.
local function open(e)
    busy = true
    setPrompt(nil)
    local ok, seconds = lib.callback.await('vinewood_gangs:server:airdropBeginOpen', false, e.data.id)
    if not ok then notify(seconds or 'failed', 'error') busy = false return end

    local ped = cache.ped
    local startPos = GetEntityCoords(ped)
    local health, armour = GetEntityHealth(ped), GetPedArmour(ped)
    local endsAt = GetGameTimer() + seconds * 1000
    local dict, clip = 'mini@repair', 'fixing_a_ped'
    lib.requestAnimDict(dict)
    TaskPlayAnim(ped, dict, clip, 8.0, -8.0, -1, 1, 0, false, false, false)

    local stopped, shown
    while true do
        local left = endsAt - GetGameTimer()
        if left <= 0 then break end
        if IsEntityDead(ped) or IsPedRagdoll(ped) or IsPedBeingStunned(ped, 0) then stopped = 'airdrop_interrupted' break end
        if GetEntityHealth(ped) < health or GetPedArmour(ped) < armour then stopped = 'airdrop_interrupted' break end
        if #(GetEntityCoords(ped) - startPos) > (cfg.openRange or 2.0) then stopped = 'airdrop_moved' break end
        if IsControlJustPressed(0, 73) then stopped = 'airdrop_gave_up' break end -- X
        if not IsEntityPlayingAnim(ped, dict, clip, 3) then TaskPlayAnim(ped, dict, clip, 8.0, -8.0, -1, 1, 0, false, false, false) end
        DisableControlAction(0, 24, true) -- attack
        DisableControlAction(0, 25, true) -- aim
        local label = mmss(left)
        if label ~= shown then lib.showTextUI(locale('airdrop_timer', label)) shown = label end
        Wait(0)
    end
    lib.hideTextUI()
    ClearPedTasks(ped)

    if stopped then
        lib.callback.await('vinewood_gangs:server:airdropStopOpen', false, e.data.id)
        notify(stopped, stopped == 'airdrop_gave_up' and 'inform' or 'error')
        busy = false
        return
    end

    local ok2, got = lib.callback.await('vinewood_gangs:server:airdropOpen', false, e.data.id)
    if ok2 then
        local parts = {}
        for _, g in ipairs(got or {}) do
            parts[#parts + 1] = g.money and Utils.FormatMoney(g.money) or ('%s x %s'):format(g.count, g.item)
        end
        notify('airdrop_loot', 'success', #parts > 0 and table.concat(parts, ', ') or '-')
    else
        notify(got or 'failed', 'error')
    end
    busy = false
end

-- Landed crates: put them in the world when we get close, and offer to open them
CreateThread(function()
    while true do
        local sleep = 1000
        local me = GetEntityCoords(cache.ped)
        local target
        for _, e in pairs(drops) do
            if e.landed then
                local d2 = #(vector2(me.x, me.y) - vector2(e.data.x, e.data.y))
                if d2 < 400.0 and not (e.crate and DoesEntityExist(e.crate)) then placeLanded(e) end
                if d2 < 30.0 then sleep = 0 end
                if e.openingUntil and d2 < 60.0 and not busy then
                    sleep = 0
                    local left = e.openingUntil - GetGameTimer()
                    if left > 0 then
                        local z = e.crate and DoesEntityExist(e.crate) and GetEntityCoords(e.crate).z or me.z
                        drawText3D(e.data.x, e.data.y, z + 1.3, locale('airdrop_being_opened', mmss(left)))
                    else
                        e.openingUntil = nil
                    end
                end
                if d2 < 2.5 and not busy and not IsPedInAnyVehicle(cache.ped, false) then target = e end
            end
        end
        if target then
            setPrompt('airdrop_open_prompt')
            if IsControlJustPressed(0, 38) then open(target) end
        else
            setPrompt(nil)
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(drops) do cleanup(id) end
    if prompt then lib.hideTextUI() end
end)
