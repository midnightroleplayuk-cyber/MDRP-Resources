-- Helpers for /bowlinglane. The command itself is registered and permission
-- checked on the server.

local function standing()
    local pos = GetEntityCoords(cache.ped)
    local found, ground = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, false)
    return { x = pos.x, y = pos.y, z = found and ground or pos.z - 1.0, h = GetEntityHeading(cache.ped) }
end

lib.callback.register('rsvx_bowling:placement', standing)

-- Draws where a lane would sit if placed from here: edges, foul line and pin spots.
RegisterNetEvent('rsvx_bowling:preview', function()
    local spot = standing()
    local h = math.rad(spot.h)
    local lane = {
        coords = vec3(spot.x, spot.y, spot.z),
        fx = -math.sin(h), fy = math.cos(h),
        rx = math.cos(h), ry = math.sin(h),
    }

    local half, pit = Physics.LANE_HALF, Physics.PIT_Y
    local function line(x1, y1, x2, y2)
        local a, b = LaneToWorld(lane, x1, y1, 0.03), LaneToWorld(lane, x2, y2, 0.03)
        DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, 122, 0, 252, 255)
    end

    local stop = GetGameTimer() + 30000
    while GetGameTimer() < stop do
        line(-half, 0.0, -half, pit)
        line(half, 0.0, half, pit)
        line(-half, 0.0, half, 0.0)
        line(-half, pit, half, pit)
        for _, s in ipairs(Physics.spots) do
            local p = LaneToWorld(lane, s.x, s.y, 0.02)
            DrawMarker(25, p.x, p.y, p.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.12, 0.12, 0.12, 255, 255, 255, 220,
                false, false, 2, false, nil, nil, false)
        end
        Wait(0)
    end
end)

-- /bowlinglane screen <id> and /bowlinglane panel <id>: move a lane's
-- scoreboard or control panel around live, then save.

local editing = false

local function pairCentre(lane)
    local partner = lane.pairWith and Lanes[lane.pairWith]
    if not partner then return 0.0 end
    local dx, dy = partner.coords.x - lane.coords.x, partner.coords.y - lane.coords.y
    return (dx * lane.rx + dy * lane.ry) / 2.0
end

local function defaultFor(lane, kind)
    local centre = pairCentre(lane)
    local facing = (lane.heading + 180.0) % 360.0
    if kind == 'panel' then
        -- Behind the approach, facing the seating.
        local x = lane.pairWith and centre or 0.95
        return { coords = LaneToWorld(lane, x, -4.5, 1.1), heading = facing, width = 0.6, height = 0.3, tilt = 0.0 }
    end
    local cfg = Config.Screens
    return {
        coords = LaneToWorld(lane, centre, Physics.HEAD + cfg.setback, cfg.height),
        heading = facing, width = lane.pairWith and cfg.pairWidth or cfg.width, height = cfg.tall, tilt = cfg.tilt or 0.0,
    }
end

RegisterNetEvent('rsvx_bowling:editDisplay', function(id, kind)
    if editing then return end
    local lane = Lanes[id]
    if not lane or not Loaded[id] then
        return lib.notify({ title = 'Bowling', description = L('admin_screen_far'), type = 'error' })
    end

    local key = (kind == 'panel' and 'p' or 's') .. id
    local original = lane[kind]
    local s
    if original then
        s = {
            coords = vec3(original.coords.x, original.coords.y, original.coords.z),
            heading = original.heading, width = original.width, height = original.height,
            tilt = original.tilt or 0.0,
        }
    else
        s = defaultFor(lane, kind)
    end

    if not Screen.exists(key) then
        Screen.create(key, s, kind)
        lane[kind] = s
        RefreshDisplays(id)
    end

    local minW, minH = 0.2, 0.1
    editing = true
    lib.showTextUI(L('admin_screen_help'), { position = 'bottom-center' })

    local saved = false
    while editing do
        for _, control in ipairs({ 10, 11, 14, 15, 16, 17, 19, 23, 36, 38, 44, 45, 47, 73, 172, 173, 174, 175, 177, 191 }) do
            DisableControlAction(0, control, true)
        end

        local dt = GetFrameTime()
        -- Shift speeds everything up, X slows it right down for fine adjustment.
        local fast = IsControlPressed(0, 21)
        local fine = IsDisabledControlPressed(0, 73)
        local move = (fine and 0.06 or fast and 2.0 or 0.5) * dt
        local turn = (fine and 5.0 or fast and 120.0 or 35.0) * dt
        local step = fine and 0.002 or fast and 0.05 or 0.01   -- metres per scroll notch

        -- Movement follows the camera, so the keys always mean the same thing
        -- from where you are looking, whichever way the display is turned.
        local cam = math.rad(GetGameplayCamRot(2).z)
        local fx, fy = -math.sin(cam), math.cos(cam)   -- away from you
        local rx, ry = math.cos(cam), math.sin(cam)    -- to your right
        local x, y, z = s.coords.x, s.coords.y, s.coords.z

        if IsDisabledControlPressed(0, 174) then x, y = x - rx * move, y - ry * move end
        if IsDisabledControlPressed(0, 175) then x, y = x + rx * move, y + ry * move end
        if IsDisabledControlPressed(0, 172) then x, y = x + fx * move, y + fy * move end
        if IsDisabledControlPressed(0, 173) then x, y = x - fx * move, y - fy * move end
        if IsDisabledControlPressed(0, 10) then z = z + move end
        if IsDisabledControlPressed(0, 11) then z = z - move end
        s.coords = vec3(x, y, z)

        if IsDisabledControlPressed(0, 44) then s.heading = (s.heading + turn) % 360.0 end
        if IsDisabledControlPressed(0, 38) then s.heading = (s.heading - turn) % 360.0 end

        -- R leans the top towards you, F leans it away.
        if IsDisabledControlPressed(0, 45) then s.tilt = math.min(80.0, s.tilt + turn) end
        if IsDisabledControlPressed(0, 23) then s.tilt = math.max(-80.0, s.tilt - turn) end

        -- Scroll scales it. Hold Alt for width only, Ctrl for height only.
        local grow = 0.0
        if IsDisabledControlJustPressed(0, 15) then grow = step end
        if IsDisabledControlJustPressed(0, 14) then grow = -step end
        if grow ~= 0.0 then
            if IsDisabledControlPressed(0, 19) then
                s.width = s.width + grow
            elseif IsDisabledControlPressed(0, 36) then
                s.height = s.height + grow
            else
                local k = (s.width + grow) / s.width
                s.width, s.height = s.width * k, s.height * k
            end
        end

        -- G: type exact sizes in metres.
        if IsDisabledControlJustPressed(0, 47) then
            local input = lib.inputDialog(L('admin_size_title'), {
                { type = 'number', label = L('admin_size_width'), default = math.floor(s.width * 1000 + 0.5) / 1000, min = minW, max = 8.0, step = 0.001, precision = 3, required = true },
                { type = 'number', label = L('admin_size_height'), default = math.floor(s.height * 1000 + 0.5) / 1000, min = minH, max = 4.0, step = 0.001, precision = 3, required = true },
            })
            if input and input[1] and input[2] then
                s.width, s.height = input[1] + 0.0, input[2] + 0.0
            end
        end

        s.width = math.max(minW, math.min(8.0, s.width))
        s.height = math.max(minH, math.min(4.0, s.height))

        Screen.place(key, s)

        if IsDisabledControlJustPressed(0, 191) then
            saved = true
            editing = false
        elseif IsDisabledControlJustPressed(0, 177) or not Loaded[id] then
            editing = false
        end
        Wait(0)
    end

    lib.hideTextUI()

    if saved then
        TriggerServerEvent('rsvx_bowling:saveDisplay', id, kind, {
            x = s.coords.x, y = s.coords.y, z = s.coords.z,
            heading = s.heading, width = s.width, height = s.height, tilt = s.tilt,
        })
    elseif original then
        lane[kind] = original
        Screen.place(key, original)
    else
        lane[kind] = nil
        Screen.remove(key)
    end
end)

-- /bowlinglane edit <id>: line a lane up with the building. The pins move
-- live so they can be sat exactly on the deck's spots.

RegisterNetEvent('rsvx_bowling:editLane', function(id)
    if editing then return end
    local lane = Lanes[id]
    if not lane or not Loaded[id] then
        return lib.notify({ title = 'Bowling', description = L('admin_screen_far'), type = 'error' })
    end

    local before = {
        coords = lane.coords, heading = lane.heading,
        length = lane.length, pinScale = lane.pinScale, pinZ = lane.pinZ,
    }
    lane.length = lane.length or Physics.HEAD
    lane.pinScale = lane.pinScale or 1.0
    lane.pinZ = lane.pinZ or 0.0

    editing = true
    lib.showTextUI(L('admin_lane_help'), { position = 'bottom-center' })

    local half, pit = Physics.LANE_HALF, Physics.PIT_Y
    local function line(x1, y1, x2, y2)
        local a, b = LaneToWorld(lane, x1, y1, 0.03), LaneToWorld(lane, x2, y2, 0.03)
        DrawLine(a.x, a.y, a.z, b.x, b.y, b.z, 122, 0, 252, 255)
    end

    local saved = false
    while editing do
        for _, control in ipairs({ 10, 11, 14, 15, 16, 17, 19, 36, 38, 44, 73, 172, 173, 174, 175, 177, 191 }) do
            DisableControlAction(0, control, true)
        end

        local dt = GetFrameTime()
        local fast = IsControlPressed(0, 21)
        local fine = IsDisabledControlPressed(0, 73)
        local move = (fine and 0.03 or fast and 1.5 or 0.25) * dt
        -- A degree of heading is about 30 cm at the pins, so turning is slow by default.
        local turn = (fine and 0.25 or fast and 20.0 or 2.5) * dt
        local changed = false

        local cam = math.rad(GetGameplayCamRot(2).z)
        local fx, fy = -math.sin(cam), math.cos(cam)
        local rx, ry = math.cos(cam), math.sin(cam)
        local x, y, z = lane.coords.x, lane.coords.y, lane.coords.z

        if IsDisabledControlPressed(0, 174) then x, y, changed = x - rx * move, y - ry * move, true end
        if IsDisabledControlPressed(0, 175) then x, y, changed = x + rx * move, y + ry * move, true end
        if IsDisabledControlPressed(0, 172) then x, y, changed = x + fx * move, y + fy * move, true end
        if IsDisabledControlPressed(0, 173) then x, y, changed = x - fx * move, y - fy * move, true end
        if IsDisabledControlPressed(0, 10) then z, changed = z + move, true end
        if IsDisabledControlPressed(0, 11) then z, changed = z - move, true end
        lane.coords = vec3(x, y, z)

        if IsDisabledControlPressed(0, 44) then lane.heading, changed = (lane.heading + turn) % 360.0, true end
        if IsDisabledControlPressed(0, 38) then lane.heading, changed = (lane.heading - turn) % 360.0, true end

        -- Scroll: lane length. Alt + scroll: pin spacing. Ctrl + scroll: pin height.
        local notch = 0
        if IsDisabledControlJustPressed(0, 15) then notch = 1 end
        if IsDisabledControlJustPressed(0, 14) then notch = -1 end
        if notch ~= 0 then
            changed = true
            if IsDisabledControlPressed(0, 19) then
                lane.pinScale = math.max(0.6, math.min(1.6, lane.pinScale + notch * (fine and 0.002 or fast and 0.05 or 0.01)))
            elseif IsDisabledControlPressed(0, 36) then
                lane.pinZ = math.max(-0.5, math.min(0.5, lane.pinZ + notch * (fine and 0.002 or fast and 0.05 or 0.01)))
            else
                lane.length = math.max(5.0, math.min(30.0, lane.length + notch * (fine and 0.005 or fast and 0.25 or 0.05)))
            end
        end

        if changed then
            OrientLane(lane)
            SetRack(id, Physics.FULL)
        end

        line(-half, 0.0, -half, pit)
        line(half, 0.0, half, pit)
        line(-half, 0.0, half, 0.0)
        line(0.0, 0.0, 0.0, Physics.HEAD)

        if IsDisabledControlJustPressed(0, 191) then
            saved = true
            editing = false
        elseif IsDisabledControlJustPressed(0, 177) or not Loaded[id] then
            editing = false
        end
        Wait(0)
    end

    lib.hideTextUI()

    if saved then
        -- The server saves it and sends every client the updated lane list.
        TriggerServerEvent('rsvx_bowling:saveLane', id, {
            x = lane.coords.x, y = lane.coords.y, z = lane.coords.z, heading = lane.heading,
            length = lane.length, pinScale = lane.pinScale, pinZ = lane.pinZ,
        })
    else
        lane.coords, lane.heading = before.coords, before.heading
        lane.length, lane.pinScale, lane.pinZ = before.length, before.pinScale, before.pinZ
        OrientLane(lane)
        if Loaded[id] then SetRack(id, State[id] and State[id].mask or Physics.FULL) end
    end
end)
