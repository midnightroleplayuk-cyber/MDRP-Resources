-- Offsets are in metres in the machine's own space (x right, y away from the player, z up)
-- and match the pivots set in blender/prepare_export.py.

Physical = {}

local Rigs   = {}
local Tweens = {}
local Games  = {}
local ticking = false

local SIN10, COS10 = math.sin(math.rad(10.0)), math.cos(math.rad(10.0))
local PRIZE_SPOTS = {
    { 0.05, -0.2 }, { 0.25, -0.1 }, { 0.0, 0.1 }, { 0.24, 0.22 }, { -0.2, 0.2 },
    { -0.22, 0.0 }, { 0.12, 0.3 }, { 0.28, -0.3 }, { -0.02, -0.02 },
}

ArcadeOwned = {}

function ArcadeSweep(model, x, y, z, radius)
    local want, at = model & 0xFFFFFFFF, vec3(x, y, z)
    for _, obj in ipairs(GetGamePool('CObject')) do
        if not ArcadeOwned[obj] and (GetEntityModel(obj) & 0xFFFFFFFF) == want and #(GetEntityCoords(obj) - at) <= radius then
            SetEntityAsMissionEntity(obj, true, true)
            DeleteEntity(obj)
        end
    end
end

local PART_MODELS = {
    claw     = { `rsvx_grabber_bridge`, `rsvx_grabber_carriage`, `rsvx_grabber_claw`, `rsvx_grabber_prize`, `rsvx_grabber_prize2`, `rsvx_grabber_prize3` },
    strength = { `rsvx_bell_puck`, `rsvx_bell_hammer` },
    whack    = { `rsvx_mole_mole`, `rsvx_mole_mallet` },
    hoops    = { `rsvx_hoops_hoop`, `rsvx_hoops_ball` },
}

local function clamp(v, lo, hi) return v < lo and lo or v > hi and hi or v end

local function notify(msg, kind)
    lib.notify({ title = 'Arcade', description = msg, type = kind or 'inform' })
end

local function setPart(rig, part, x, y, z)
    part.x, part.y, part.z = x, y, z
    local p = GetOffsetFromEntityInWorldCoords(rig.base, x, y, z)
    SetEntityCoordsNoOffset(part.obj, p.x, p.y, p.z, false, false, false)
end

local function addPart(rig, key, model, x, y, z, rot)
    if not IsModelValid(model) then return end
    lib.requestModel(model, 5000)
    local p = GetOffsetFromEntityInWorldCoords(rig.base, x, y, z)
    local obj = CreateObjectNoOffset(model, p.x, p.y, p.z, false, false, false)
    rot = rot or vec3(0.0, 0.0, 0.0)
    SetEntityRotation(obj, rot.x, rot.y, rig.heading + rot.z, 2, true)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, false, false)
    SetModelAsNoLongerNeeded(model)
    ArcadeOwned[obj] = true
    rig.parts[key] = { obj = obj, model = model, x = x, y = y, z = z, hx = x, hy = y, hz = z }
end

local function startTicker()
    if ticking then return end
    ticking = true
    CreateThread(function()
        while next(Tweens) do
            local now = GetGameTimer()
            for part, tw in pairs(Tweens) do
                if not DoesEntityExist(part.obj) then
                    Tweens[part] = nil
                else
                    local k = clamp((now - tw.t0) / tw.ms, 0.0, 1.0)
                    setPart(tw.rig, part, tw.fx + (tw.tx - tw.fx) * k, tw.fy + (tw.ty - tw.fy) * k, tw.fz + (tw.tz - tw.fz) * k)
                    if k >= 1.0 then Tweens[part] = nil end
                end
            end
            Wait(0)
        end
        ticking = false
    end)
end

local function move(rig, key, x, y, z, ms, relay)
    local part = rig.parts[key]
    if not part then return end
    if relay then TriggerServerEvent('rsvx_arcade:fx', rig.id, key, x, y, z, ms) end
    if not ms or ms <= 0 then
        Tweens[part] = nil
        return setPart(rig, part, x, y, z)
    end
    Tweens[part] = { rig = rig, fx = part.x, fy = part.y, fz = part.z, tx = x, ty = y, tz = z, t0 = GetGameTimer(), ms = ms }
    startTicker()
end

local function resetRig(rig, relay)
    if relay then TriggerServerEvent('rsvx_arcade:fx', rig.id, '@reset') end
    for _, part in pairs(rig.parts) do
        Tweens[part] = nil
        setPart(rig, part, part.hx, part.hy, part.hz)
    end
end

RegisterNetEvent('rsvx_arcade:fx', function(id, key, x, y, z, ms)
    local rig = Rigs[id]
    if not rig or rig.mine then return end
    if key == '@reset' then return resetRig(rig) end
    if type(x) == 'number' and type(y) == 'number' and type(z) == 'number' then
        move(rig, key, x, y, z, ms)
        if rig.kind == 'strength' and key == 'puck' and z >= 0.2 + Config.Strength.bell / 1000 * 2.25 - 0.001 then
            SetTimeout(math.max(0, (ms or 0) + 50), function()
                local d = #(GetEntityCoords(cache.ped) - vec3(rig.m.x, rig.m.y, rig.m.z))
                if d < Config.Strength.hearing then ArcadeBell(1.0 - d / Config.Strength.hearing) end
            end)
        end
    end
end)

local function hole(i, z)
    local hx = ((i % 3) - 1) * 0.34
    local y = i < 3 and -0.19 or 0.17
    return hx, -0.03 + y * COS10 - z * SIN10, 0.93 + y * SIN10 + z * COS10
end

function ArcadeBell(loudness)
    SendNUIMessage({ action = 'bell', volume = Config.Strength.volume * math.max(0.0, math.min(1.0, loudness)) })
end

local Build = {}

local BOXES = { `rsvx_grabber_prize`, `rsvx_grabber_prize2`, `rsvx_grabber_prize3` }
local CABINET_FLOOR = 0.88

local function prizeLook(rig, i)
    local list = Config.Machines[rig.kind].prizes
    local prize = list and rig.m.prizes and list[rig.m.prizes[i]]
    if prize and prize.model and IsModelValid(prize.model) then
        return prize.model, CABINET_FLOOR + (prize.z or 0.0), 0.45
    end
    return BOXES[i % 3 + 1], 0.935, 0.4
end

local function addPrize(rig, i)
    local s = PRIZE_SPOTS[i]
    local model, z, hang = prizeLook(rig, i)
    addPart(rig, 'prize' .. i, model, s[1], s[2], z, vec3(0.0, 0.0, 17.0 * i))
    if rig.parts['prize' .. i] then rig.parts['prize' .. i].hang = hang end
end

local function restock(rig)
    for i = 1, #PRIZE_SPOTS do
        local key = 'prize' .. i
        local part = rig.parts[key]
        local model = prizeLook(rig, i)
        if not part or part.model ~= model or part.z < 0.6 then
            if part then
                Tweens[part] = nil
                ArcadeOwned[part.obj] = nil
                if DoesEntityExist(part.obj) then DeleteEntity(part.obj) end
                rig.parts[key] = nil
            end
            addPrize(rig, i)
        end
    end
end

function Physical.restock(id)
    local rig = Rigs[id]
    if rig and rig.kind == 'claw' and not rig.mine then restock(rig) end
end

function Build.claw(rig)
    addPart(rig, 'bridge', `rsvx_grabber_bridge`, 0.0, 0.05, 1.71)
    addPart(rig, 'carriage', `rsvx_grabber_carriage`, 0.1, 0.05, 1.67)
    addPart(rig, 'claw', `rsvx_grabber_claw`, 0.1, 0.05, 1.635)
    for _, prize in ipairs(Config.Machines.claw.prizes or {}) do
        if prize.model and IsModelValid(prize.model) then ArcadeSweep(prize.model, rig.m.x, rig.m.y, rig.m.z + 1.0, 0.7) end
    end
    for i = 1, #PRIZE_SPOTS do addPrize(rig, i) end
end

function Build.strength(rig)
    addPart(rig, 'puck', `rsvx_bell_puck`, 0.0, 0.11, 0.2)
    addPart(rig, 'hammer', `rsvx_bell_hammer`, -0.38, -0.2, 0.13, vec3(0.0, -78.0, 20.0))
end

function Build.whack(rig)
    for i = 0, 5 do
        local x, y, z = hole(i, -0.13)
        addPart(rig, 'mole' .. i, `rsvx_mole_mole`, x, y, z, vec3(10.0, 0.0, 0.0))
    end
    addPart(rig, 'mallet', `rsvx_mole_mallet`, 0.42, -0.5, 1.0, vec3(-80.0, 0.0, -25.0))
end

function Build.hoops(rig)
    addPart(rig, 'hoop', `rsvx_hoops_hoop`, 0.0, 0.59, 1.72)
    local ball = Config.Hoops.ball
    addPart(rig, 'ball1', ball, -0.25, -0.33, 1.05)
    addPart(rig, 'ball2', ball, 0.02, -0.32, 1.055)
    addPart(rig, 'ball3', ball, 0.28, -0.31, 1.06)
end

function Physical.attach(m, base)
    if Rigs[m.id] or not Build[m.game] then return end
    local rig = { id = m.id, m = m, base = base, heading = m.h, kind = m.game, parts = {} }
    Rigs[m.id] = rig
    for _, model in ipairs(PART_MODELS[m.game] or {}) do ArcadeSweep(model, m.x, m.y, m.z, 3.0) end
    Build[m.game](rig)
end

function Physical.detach(id)
    local rig = Rigs[id]
    if not rig then return end
    for _, part in pairs(rig.parts) do
        Tweens[part] = nil
        ArcadeOwned[part.obj] = nil
        if DoesEntityExist(part.obj) then DeleteEntity(part.obj) end
    end
    Rigs[id] = nil
end

local function controls()
    DisableAllControlActions(0)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 249, true)
end

local function held(c) return IsDisabledControlPressed(0, c) end
local function tapped(c) return IsDisabledControlJustPressed(0, c) end
local function action() return tapped(22) or tapped(38) end

local function hud(text)
    lib.showTextUI(text, { position = 'right-center' })
end

function Games.claw(rig, submit)
    local P = rig.parts
    local cx, cy = P.carriage.x, P.carriage.y
    local TOP, DOWN = 1.635, 1.385
    local function gantry(z, ms, relay)
        move(rig, 'bridge', 0.0, cy, 1.71, ms, relay)
        move(rig, 'carriage', cx, cy, 1.67, ms, relay)
        move(rig, 'claw', cx, cy, z, ms, relay)
    end

    local ends, lastSend, lastHud, sx, sy = GetGameTimer() + 20000, 0, -1, cx, cy
    while true do
        Wait(0)
        controls()
        local dt, now = GetFrameTime(), GetGameTimer()
        local dx = ((held(175) or held(35)) and 1 or 0) - ((held(174) or held(34)) and 1 or 0)
        local dy = ((held(172) or held(32)) and 1 or 0) - ((held(173) or held(33)) and 1 or 0)
        cx = clamp(cx + dx * 0.25 * dt, -0.3, 0.3)
        cy = clamp(cy + dy * 0.25 * dt, -0.3, 0.3)
        gantry(TOP, 0)
        if now - lastSend > 200 and (sx ~= cx or sy ~= cy) then
            lastSend, sx, sy = now, cx, cy
            TriggerServerEvent('rsvx_arcade:fx', rig.id, 'bridge', 0.0, cy, 1.71, 200)
            TriggerServerEvent('rsvx_arcade:fx', rig.id, 'carriage', cx, cy, 1.67, 200)
            TriggerServerEvent('rsvx_arcade:fx', rig.id, 'claw', cx, cy, TOP, 200)
        end
        local left = math.ceil((ends - now) / 1000)
        if left ~= lastHud then
            lastHud = left
            hud(('Grabber  \nTime: %d  \n[Arrows] Move the claw  \n[Space] Drop'):format(math.max(left, 0)))
        end
        if action() or tapped(177) or now >= ends then break end
    end

    hud('Grabber  \nDropping...')
    gantry(DOWN, 1200, true)
    Wait(1250)

    local bestKey, bestSpot, best = nil, nil, 999.0
    for i = 1, #PRIZE_SPOTS do
        local part = P['prize' .. i]
        if part and part.z > 0.6 then
            local d = #(vec2(part.x, part.y) - vec2(cx, cy))
            if d < best then bestKey, bestSpot, best = 'prize' .. i, i, d end
        end
    end
    local result = submit(math.max(0, math.floor(100 - best / 0.06 * 30 + 0.5)), bestSpot)

    if result.prize and bestKey then
        local hang = P[bestKey].hang or 0.4
        move(rig, bestKey, cx, cy, DOWN - hang, 150, true)
        Wait(200)
        gantry(TOP, 1200, true)
        move(rig, bestKey, cx, cy, TOP - hang, 1200, true)
        Wait(1250)
        cx, cy = -0.27, -0.27
        gantry(TOP, 1500, true)
        move(rig, bestKey, cx, cy, TOP - hang, 1500, true)
        Wait(1600)
        move(rig, bestKey, cx, cy, 0.5, 400, true)
        Wait(600)
    else
        gantry(TOP, 1200, true)
        Wait(1250)
    end
    cx, cy = 0.1, 0.05
    gantry(TOP, 1200, true)
    Wait(1200)
end

function Games.strength(rig, submit)
    local S = Config.Strength
    local bell = S.bell / 1000
    local base = S.speed
    local function pace() return base * (1.0 + (math.random() * 2.0 - 1.0) * S.jitter) end
    local pos, dir, speed = 0.0, 1, pace()
    hud('Bell Ringer  \n[Space] Swing when the bar is full')
    while true do
        Wait(0)
        controls()
        pos += dir * speed * GetFrameTime()
        if pos >= 1.0 then
            base = math.min(S.maxSpeed, base + S.step)
            pos, dir, speed = 1.0, -1, pace()
        elseif pos <= 0.0 then
            pos, dir, speed = 0.0, 1, pace()
        end
        DrawRect(0.9, 0.5, 0.024, 0.43, 0, 0, 0, 180)
        local g = pos >= bell and 200 or 120
        DrawRect(0.9, 0.71 - 0.2 * pos, 0.016, 0.4 * pos, 224, g, 60, 235)
        DrawRect(0.9, 0.71 - 0.4 * bell, 0.024, 0.002, 255, 255, 255, 230)
        if action() then break end
        if tapped(177) then pos = 0.0 break end
    end
    local power = math.floor(pos * 1000 + 0.5)

    local ped = cache.ped
    local swing
    move(rig, 'hammer', -0.38, -0.2, -3.0, 0, true)
    if IsModelValid(`rsvx_bell_hammer`) and lib.requestAnimDict('melee@large_wpn@streamed_core', 3000) then
        lib.requestModel(`rsvx_bell_hammer`, 5000)
        local c = GetEntityCoords(ped)
        swing = CreateObject(`rsvx_bell_hammer`, c.x, c.y, c.z, true, true, false)
        SetEntityCollision(swing, false, false)
        AttachEntityToEntity(swing, ped, GetPedBoneIndex(ped, 57005), 0.09, 0.03, -0.02, -80.0, 0.0, 0.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, -8.0, 1300, 0, 0.0, false, false, false)
        Wait(650)
    end

    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
    move(rig, 'puck', 0.0, 0.11, 0.2 + power / 1000 * 2.25, 500, true)
    Wait(550)
    if power >= S.bell then ArcadeBell(1.0) end
    hud(('Bell Ringer  \nPower: %d'):format(power))
    submit(power)
    Wait(900)
    move(rig, 'puck', 0.0, 0.11, 0.2, 900, true)
    Wait(900)
    if swing then DeleteEntity(swing) end
    move(rig, 'hammer', -0.38, -0.2, 0.13, 0, true)
end

function Games.whack(rig, submit)
    local KEYS = { 157, 158, 160, 164, 165, 159 }
    local up, score = {}, 0
    local start = GetGameTimer()
    local ends, nextSpawn, lastHud = start + 30000, start + 500, -1

    local function mole(i, show)
        local x, y, z = hole(i, show and 0.1 or -0.13)
        move(rig, 'mole' .. i, x, y, z, 120, true)
    end

    while true do
        Wait(0)
        controls()
        local now = GetGameTimer()
        if now >= ends or tapped(177) then break end
        local pace = (now - start) / 30000

        for i = 0, 5 do
            if up[i] and now >= up[i] then
                up[i] = nil
                mole(i, false)
            end
        end
        if now >= nextSpawn then
            nextSpawn = now + 800 - pace * 450
            local free = {}
            for i = 0, 5 do if not up[i] then free[#free + 1] = i end end
            if #free > 0 then
                local i = free[math.random(#free)]
                up[i] = now + 1100 - pace * 500
                mole(i, true)
            end
        end

        for k = 1, 6 do
            if tapped(KEYS[k]) then
                local i = k - 1
                local x, y, z = hole(i, 0.32)
                move(rig, 'mallet', x, y, z, 0, true)
                SetTimeout(180, function()
                    if Rigs[rig.id] == rig then move(rig, 'mallet', 0.42, -0.5, 1.0, 0, true) end
                end)
                if up[i] then
                    up[i] = nil
                    score += 10
                    lastHud = -1
                    mole(i, false)
                    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                else
                    PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                end
            end
        end

        local left = math.ceil((ends - now) / 1000)
        if left ~= lastHud then
            lastHud = left
            hud(('Mole Mash  \nScore: %d   Time: %d  \n[1][2][3] Front row  \n[4][5][6] Back row'):format(score, left))
        end
    end

    for i = 0, 5 do mole(i, false) end
    submit(score)
    Wait(600)
end

function Games.hoops(rig, submit)
    local H = Config.Hoops
    local hoop, ped = rig.parts.hoop, cache.ped
    local score, made, dir, legEnd, flying = 0, 0, 1, 0, false
    local power, pdir, charging = 0.0, 1, false
    local start = GetGameTimer()
    local ends, lastHud = start + H.seconds * 1000, -1

    local function leg()
        local speed = math.min(0.5, 0.12 + made * 0.03)
        local target = dir * 0.25
        local ms = math.max(100, math.floor(math.abs(target - hoop.x) / speed * 1000))
        move(rig, 'hoop', target, 0.59, 1.72, ms, true)
        legEnd = GetGameTimer() + ms
    end
    leg()

    local function throw(p)
        flying = true
        CreateThread(function()
            lib.requestModel(H.ball, 5000)
            move(rig, 'ball1', -0.25, -0.33, -3.0, 0, true)
            local c = GetEntityCoords(ped)
            local ball = CreateObject(H.ball, c.x, c.y, c.z + 1.0, true, true, false)
            SetEntityCollision(ball, false, false)
            AttachEntityToEntity(ball, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.02, -0.04, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

            local played
            for _, a in ipairs(H.throwAnims) do
                if DoesAnimDictExist(a.dict) and lib.requestAnimDict(a.dict, 2000) and GetAnimDuration(a.dict, a.clip) > 0.0 then
                    TaskPlayAnim(ped, a.dict, a.clip, 8.0, -8.0, 900, 48, 0.0, false, false, false)
                    played = a
                    break
                end
            end
            if not rig.animNoted then
                rig.animNoted = true
                print(('[RSVX_Arcade] hoops throw animation: %s'):format(played and (played.dict .. ' / ' .. played.clip) or 'none of Config.Hoops.throwAnims exist on this build'))
            end
            Wait(H.releaseMs)

            DetachEntity(ball, true, false)
            local from = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.35, H.releaseHeight)
            SetEntityCoordsNoOffset(ball, from.x, from.y, from.z, false, false, false)
            SetEntityCollision(ball, true, true)

            local target = GetOffsetFromEntityInWorldCoords(rig.base, 0.0, 0.39, 1.75)
            local flat = vec3(target.x - from.x, target.y - from.y, 0.0)
            local d, dz, a = #flat, target.z - from.z, math.rad(H.angle)
            local denom = 2 * math.cos(a) ^ 2 * (d * math.tan(a) - dz)
            local ideal = denom > 0 and math.sqrt(9.81 * d * d / denom) or 4.0
            local v = ideal * (0.75 + 0.5 * p)
            local along = flat / math.max(d, 0.01)
            SetEntityVelocity(ball, along.x * v * math.cos(a), along.y * v * math.cos(a), v * math.sin(a))

            local t0, last, scored = GetGameTimer(), GetEntityCoords(ball), false
            while GetGameTimer() - t0 < 3500 and DoesEntityExist(ball) do
                Wait(0)
                local pos = GetEntityCoords(ball)
                local rim = GetOffsetFromEntityInWorldCoords(rig.base, hoop.x, 0.39, 1.72)
                if not scored and last.z > rim.z and pos.z <= rim.z then
                    local off = #(vec2(pos.x, pos.y) - vec2(rim.x, rim.y))
                    if off < 0.16 then
                        scored = true
                        local pts = off < 0.06 and 3 or 2
                        score += pts
                        made += 1
                        lastHud = -1
                        PlaySoundFrontend(-1, pts == 3 and 'CHECKPOINT_PERFECT' or 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', true)
                    end
                end
                last = pos
            end
            if DoesEntityExist(ball) then DeleteEntity(ball) end
            if Rigs[rig.id] == rig then move(rig, 'ball1', -0.25, -0.33, 1.05, 0, true) end
            flying = false
        end)
    end

    while true do
        Wait(0)
        controls()
        local now = GetGameTimer()
        if now >= ends or tapped(177) then break end
        if now >= legEnd then
            dir = -dir
            leg()
        end

        if not flying then
            if held(22) then
                charging = true
                power += pdir * 1.1 * GetFrameTime()
                if power >= 1.0 then power, pdir = 1.0, -1 elseif power <= 0.0 then power, pdir = 0.0, 1 end
            elseif charging then
                charging = false
                throw(power)
                power, pdir = 0.0, 1
            end
        end

        DrawRect(0.9, 0.5, 0.024, 0.43, 0, 0, 0, 180)
        DrawRect(0.9, 0.71 - 0.4 * 0.5, 0.020, 0.4 * 0.16, 60, 150, 70, 200)
        DrawRect(0.9, 0.71 - 0.4 * power, 0.022, 0.006, 240, 240, 230, 255)

        local left = math.ceil((ends - now) / 1000)
        if left ~= lastHud then
            lastHud = left
            hud(('Hoops  \nScore: %d   Time: %d  \nHold [Space] for power, release to throw  \nAim for the green band'):format(score, left))
        end
    end

    while flying do Wait(50) end
    submit(score)
    move(rig, 'hoop', 0.0, 0.59, 1.72, 600, true)
    Wait(600)
end

function Physical.has(id)
    return Rigs[id] ~= nil
end

function Physical.play(m, cfg)
    local rig = Rigs[m.id]
    if not rig or rig.mine or not Games[rig.kind] then return end

    local res, err = lib.callback.await('rsvx_arcade:play', false, m.id)
    if not res then return notify(err, 'error') end

    rig.mine = true
    resetRig(rig, true)
    local ped = cache.ped
    TaskTurnPedToFaceEntity(ped, rig.base, 600)
    Wait(600)
    FreezeEntityPosition(ped, true)

    local result, sent = {}, false
    local ok, problem = pcall(Games[rig.kind], rig, function(score, extra)
        if sent then return result end
        sent = true
        result = lib.callback.await('rsvx_arcade:submit', false, score, extra) or { rejected = true }
        return result
    end)

    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    lib.hideTextUI()
    rig.mine = false
    if rig.kind == 'claw' and Rigs[m.id] == rig then restock(rig) end
    TriggerServerEvent('rsvx_arcade:leave')
    if not ok then
        print('[RSVX_Arcade] physical game error: ' .. tostring(problem))
        if Rigs[m.id] == rig then resetRig(rig, true) end
        return
    end

    local lines = {}
    if result.rejected then lines[#lines + 1] = 'Score not saved.' end
    if result.prize then
        lines[#lines + 1] = 'You won ' .. result.prize .. '.'
    elseif result.full then
        lines[#lines + 1] = 'You grabbed it, but you cannot carry any more.'
    elseif result.prize == false then
        lines[#lines + 1] = 'It slipped. No prize this time.'
    end
    if result.best then lines[#lines + 1] = 'New personal best.' end
    if (result.tickets or 0) > 0 then lines[#lines + 1] = ('+%d tickets.'):format(result.tickets) end
    if result.reward then lines[#lines + 1] = 'Bonus: ' .. result.reward .. '.' end
    if #lines > 0 then notify(table.concat(lines, ' '), result.prize == false and 'inform' or 'success') end
end
