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

    local model = lib.requestModel(d.plane.model)
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
    notify('airdrop_incoming', 'inform')
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
    notify('airdrop_landed', 'inform')
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

local function open(e)
    busy = true
    setPrompt(nil)
    local ok, seconds = lib.callback.await('vinewood_gangs:server:airdropBeginOpen', false, e.data.id)
    if not ok then notify(seconds or 'failed', 'error') busy = false return end
    local done = lib.progressBar({
        duration = seconds * 1000, label = locale('airdrop_opening'), canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
    })
    if done then
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
