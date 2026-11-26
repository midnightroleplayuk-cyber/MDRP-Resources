-- Plays a throw back on every client near the lane. The server has already
-- decided the result; this runs the same simulation purely to draw it, then
-- snaps the rack to the server's answer.

local function distanceTo(lane)
    local pos = GetEntityCoords(cache.ped)
    local a = #(pos - lane.coords)
    local b = #(pos - LaneToWorld(lane, 0.0, Physics.HEAD, 0.0))
    return a < b and a or b
end

local function sfx(kind, volume)
    if Config.Sounds then SendNUIMessage({ type = 'sfx', kind = kind, volume = volume }) end
end

RegisterNetEvent('rsvx_bowling:throw', function(id, data)
    local lane, loaded = Lanes[id], Loaded[id]
    if not lane or not loaded then return end

    local mine = data.src == cache.serverId
    loaded.replaying = true
    loaded.seq = data.seq
    if mine then Throw.replaying = true end

    Machine.park(loaded)
    SetRack(id, data.before)

    lib.requestModel(Config.Props.ball)
    local start = LaneToWorld(lane, data.throw.x, 0.0, Config.Props.ballZ)
    local ball = CreateObjectNoOffset(Config.Props.ball, start.x, start.y, start.z, false, false, false)
    FreezeEntityPosition(ball, true)
    SetEntityCollision(ball, false, false)
    if loaded.ball and DoesEntityExist(loaded.ball) then DeleteEntity(loaded.ball) end
    loaded.ball = ball

    local sim = Physics.new(data.throw, data.before)
    local acc, tilt, lastHit = 0.0, {}, 0
    local dist = distanceTo(lane)
    local audible = dist < 35.0
    local volume = audible and math.max(0.08, 1.0 - dist / 35.0) or 0.0
    local rolling = false

    if audible then
        sfx('roll', volume)
        rolling = true
    end

    while not sim.done and Loaded[id] == loaded and loaded.seq == data.seq do
        local frame = GetFrameTime()
        acc = acc + frame
        if acc > 0.25 then acc = 0.25 end

        local hit = 0
        while acc >= Physics.DT and not sim.done do
            Physics.step(sim)
            acc = acc - Physics.DT
            if sim.impact > hit then hit = sim.impact end
        end

        local b = sim.ball
        if b.gone then
            if IsEntityVisible(ball) then SetEntityVisible(ball, false, false) end
            if rolling then
                sfx('rollstop')
                rolling = false
            end
        else
            local pos = LaneToWorld(lane, b.x, b.y, Config.Props.ballZ - (b.gutter and 0.05 or 0.0))
            SetEntityCoordsNoOffset(ball, pos.x, pos.y, pos.z, false, false, false)
            SetEntityRotation(ball, -((b.y / Physics.BALL_R) * 57.29578) % 360.0, 0.0, lane.heading, 2, true)
            if mine then Throw.follow(lane, b) end
        end

        if audible and hit > 1.0 and GetGameTimer() - lastHit > 70 then
            lastHit = GetGameTimer()
            sfx('hit', volume * math.min(1.0, hit / 12.0))
        end

        for i = 1, 10 do
            local p, obj = sim.pins[i], loaded.pins[i]
            if p and obj and DoesEntityExist(obj) then
                if p.gone then
                    if IsEntityVisible(obj) then SetEntityVisible(obj, false, false) end
                else
                    local t = tilt[i] or 0.0
                    if p.down and t < 90.0 then
                        t = math.min(90.0, t + 420.0 * frame)
                        tilt[i] = t
                    end

                    local pos = LaneToWorld(lane, p.x, p.y, PinBase(lane) + (t / 90.0) * Physics.PIN_R)
                    SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z, false, false, false)

                    if t > 0.0 then
                        -- Lay the pin over in the direction it was knocked.
                        local wx = lane.rx * p.fx + lane.fx * p.fy
                        local wy = lane.ry * p.fx + lane.fy * p.fy
                        SetEntityRotation(obj, -t, 0.0, math.deg(math.atan(-wx, wy)), 2, true)
                    end
                end
            end
        end

        Wait(0)
    end

    if rolling then sfx('rollstop') end
    if DoesEntityExist(ball) then DeleteEntity(ball) end
    if loaded.ball == ball then loaded.ball = nil end
    if mine then Throw.finish() end

    -- Lane unloaded or a newer throw took over while this one was playing.
    if Loaded[id] ~= loaded or loaded.seq ~= data.seq then return end

    if MyLane == id or Watching == id or dist < 20.0 then
        SendNUIMessage({ type = 'banner', text = data.label, name = data.name })
    end

    Wait(Config.Timing.sweepDelay)
    if Loaded[id] ~= loaded or loaded.seq ~= data.seq then return end

    local nextMask = data.next or data.after
    if loaded.machine then
        local finished = Machine.cycle(id, lane, loaded, sim, data.after, nextMask, function()
            return Loaded[id] == loaded and loaded.seq == data.seq
        end)
        if not finished then return end
    end

    -- Whatever happened above, end on exactly the rack the next ball needs.
    SetRack(id, nextMask)
    loaded.replaying = false

    -- If the server has already moved on (new frame, next player), use its rack.
    local st = State[id]
    if st and not (st.busy and st.seq == data.seq) then SetRack(id, st.mask) end
end)
