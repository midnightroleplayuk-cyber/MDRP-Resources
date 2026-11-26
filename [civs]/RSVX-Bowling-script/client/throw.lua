-- Lining up and releasing a ball.
--   1. Set position (A/D), aim (arrow keys) and spin (Q/E) by hand. A line down
--      the lane shows where the ball is heading. SPACE starts the swing.
--   2. The power bar sweeps; SPACE releases.
-- The camera is left alone unless Config.Throw.camera is 'fixed'.

Throw = { active = false, replaying = false }

local ball, cam, released

local function tri(u)
    local f = u % 1.0
    return f < 0.5 and f * 2.0 or 2.0 - f * 2.0
end

local function hud(data)
    data.type = 'aim'
    SendNUIMessage(data)
end

local function cleanup()
    hud({ show = false })
    if ball and DoesEntityExist(ball) then DeleteEntity(ball) end
    ball = nil
    if cam then
        RenderScriptCams(false, true, 500, true, false)
        DestroyCam(cam, false)
        cam = nil
    end
    FreezeEntityPosition(cache.ped, false)
    Throw.active, Throw.replaying, released = false, false, false
end

function Throw.cancel()
    if Throw.active then cleanup() end
end

-- Called by the replay when the local player's ball has finished.
function Throw.finish()
    if Throw.active then cleanup() end
end

-- Chase camera for the bowler's own ball.
function Throw.follow(lane, b)
    if not cam or not Config.Throw.followCam then return end
    local y = math.min(b.y, Physics.HEAD - 2.5)
    local pos = LaneToWorld(lane, b.x * 0.3, y - 3.2, 1.35)
    local look = LaneToWorld(lane, b.x * 0.5, y + 5.0, 0.2)
    SetCamCoord(cam, pos.x, pos.y, pos.z)
    PointCamAtCoord(cam, look.x, look.y, look.z)
end

local function place(lane, offset)
    -- Stand a little left of the ball's line so the right hand is over it.
    local pos = LaneToWorld(lane, offset - 0.28, -0.7, 0.0)
    SetEntityCoords(cache.ped, pos.x, pos.y, pos.z, false, false, false, false)
    SetEntityHeading(cache.ped, lane.heading)
end

local function release(id, input)
    local ped = cache.ped
    local anim = Config.Throw.anim

    hud({ show = false })
    lib.requestAnimDict(anim.dict)
    TaskPlayAnim(ped, anim.dict, anim.name, 8.0, -8.0, 1400, 48, 0.0, false, false, false)
    Wait(anim.releaseMs)

    if ball and DoesEntityExist(ball) then DeleteEntity(ball) end
    ball = nil
    FreezeEntityPosition(ped, false)

    released = true
    TriggerServerEvent('rsvx_bowling:throw', id, input)

    -- If the server turned the throw down nothing will come back, so let go.
    SetTimeout(3000, function()
        if Throw.active and released and not Throw.replaying then cleanup() end
    end)
end

-- Where the ball would go with these settings, as a list of world points.
-- Runs the real simulation with no pins, so the hook is shown too.
local function predict(lane, offset, aim, spin)
    local cfg = Config.Throw
    local angle = math.rad(aim * cfg.maxAngle)
    local speed = cfg.minSpeed + (cfg.maxSpeed - cfg.minSpeed) * 0.6
    local sim = Physics.new({ x = offset, vx = speed * math.sin(angle), vy = speed * math.cos(angle), spin = spin }, 0)

    local points, n = { LaneToWorld(lane, offset, 0.0, 0.04) }, 0
    local b = sim.ball
    local reach = math.min(cfg.guideLength or 8.0, Physics.HEAD + 0.6)
    while not b.gone and b.y < reach and n < 600 do
        Physics.step(sim)
        n = n + 1
        if n % 5 == 0 then
            points[#points + 1] = LaneToWorld(lane, b.x, b.y, 0.04)
            if b.gutter then break end
        end
    end
    return points
end

local function createCam(lane)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local camPos = LaneToWorld(lane, 0.0, -3.6, 1.8)
    local look = LaneToWorld(lane, 0.0, 12.0, 0.2)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(cam, look.x, look.y, look.z)
    SetCamFov(cam, 50.0)
    RenderScriptCams(true, true, 400, true, false)
end

function Throw.begin(id)
    if Throw.active then return end
    local lane = Lanes[id]
    if not lane then return end
    Throw.active = true

    CreateThread(function()
        local cfg = Config.Throw
        local ped = cache.ped
        local offset, spin, power, aim = 0.0, 0.0, 0.0, 0.0
        local phase, t0 = 'setup', 0
        local path, dirty = nil, true

        lib.requestModel(Config.Props.ball)
        local hand = Config.Props.hand
        local pos = GetEntityCoords(ped)
        ball = CreateObject(Config.Props.ball, pos.x, pos.y, pos.z, false, false, false)
        SetEntityCollision(ball, false, false)
        AttachEntityToEntity(ball, ped, GetPedBoneIndex(ped, 57005),
            hand.pos.x, hand.pos.y, hand.pos.z, hand.rot.x, hand.rot.y, hand.rot.z,
            true, true, false, true, 1, true)

        place(lane, offset)
        FreezeEntityPosition(ped, true)

        if cfg.camera == 'fixed' then createCam(lane) end

        while Throw.active and not released do
            DisableAllControlActions(0)
            EnableControlAction(0, 245, true) -- chat
            EnableControlAction(0, 249, true) -- push to talk
            if not cam then
                -- Free camera: look around and zoom as normal.
                EnableControlAction(0, 1, true)
                EnableControlAction(0, 2, true)
                EnableControlAction(0, 0, true)
            end

            if not IsMyTurn(id) or IsDisabledControlJustPressed(0, 177) then
                cleanup()
                return
            end

            local dt = GetFrameTime()
            local now = GetGameTimer()

            if phase == 'setup' then
                local slow = IsDisabledControlPressed(0, 21) and 0.25 or 1.0

                if IsDisabledControlPressed(0, 34) then
                    offset = math.max(-cfg.maxOffset, offset - 0.45 * slow * dt)
                    place(lane, offset)
                    dirty = true
                elseif IsDisabledControlPressed(0, 35) then
                    offset = math.min(cfg.maxOffset, offset + 0.45 * slow * dt)
                    place(lane, offset)
                    dirty = true
                end

                if IsDisabledControlPressed(0, 174) then
                    aim = math.max(-1.0, aim - 0.5 * slow * dt)
                    dirty = true
                elseif IsDisabledControlPressed(0, 175) then
                    aim = math.min(1.0, aim + 0.5 * slow * dt)
                    dirty = true
                end

                if IsDisabledControlPressed(0, 44) then
                    spin = math.max(-1.0, spin - 1.1 * slow * dt)
                    dirty = true
                elseif IsDisabledControlPressed(0, 38) then
                    spin = math.min(1.0, spin + 1.1 * slow * dt)
                    dirty = true
                end

                if IsDisabledControlJustPressed(0, 22) then
                    phase, t0 = 'power', now
                end
            elseif phase == 'power' then
                power = tri((now - t0) / cfg.powerPeriod)
                if IsDisabledControlJustPressed(0, 22) then
                    if cfg.followCam and not cam then createCam(lane) end
                    release(id, { offset = offset, aim = aim, power = power, spin = spin })
                    return
                end
            end

            if cfg.guide then
                if dirty then
                    path = predict(lane, offset, aim, spin)
                    dirty = false
                end
                for i = 1, #path - 1 do
                    local a, b = path[i], path[i + 1]
                    DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, 169, 112, 255, 230)
                end
            end

            hud({ show = true, phase = phase, offset = offset / cfg.maxOffset, spin = spin, power = power, aim = aim })
            Wait(0)
        end
    end)
end
