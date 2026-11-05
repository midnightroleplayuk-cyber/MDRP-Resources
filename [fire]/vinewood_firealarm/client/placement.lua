Placement = {}

local function modelFor(kind)
    local name = Config.Props[kind]
    if not name then return nil end
    local hash = joaat(name)
    if not IsModelInCdimage(hash) then return nil end
    lib.requestModel(hash, 5000)
    return hash
end
Placement.ModelFor = modelFor

---Anchor settings for a device type's model (or nil)
function Placement.AnchorFor(kind)
    local name = Config.Props[kind]
    return name and Config.PropAnchors and Config.PropAnchors[name] or nil
end

---Entity position so the model's anchor point lands on `point`
function Placement.EntityPos(point, heading, anchor)
    if not anchor or not anchor.anchor then return point end
    local a = anchor.anchor
    local r = math.rad(heading)
    local c, s = math.cos(r), math.sin(r)
    return vec3(point.x - (a.x * c - a.y * s), point.y - (a.x * s + a.y * c), point.z - a.z)
end

local function surfaceOf(n)
    if n.z > 0.7 then return 'floor' end
    if n.z < -0.7 then return 'ceiling' end
    return 'wall'
end

---Interactive placement. Returns { x, y, z, h, surface, mode } or nil if cancelled.
---@param kind string panel|mcp|sounder|detector
---@param mode string prop|target
function Placement.Start(kind, mode)
    local model = mode == 'prop' and modelFor(kind) or nil
    if mode == 'prop' and not model then
        lib.notify({ type = 'warning', description = ('Model "%s" not found, placing as a target point'):format(tostring(Config.Props[kind])) })
        mode = 'target'
    end

    local preview
    if model then
        preview = CreateObject(model, 0.0, 0.0, 0.0, false, false, false)
        SetEntityAlpha(preview, 170, false)
        SetEntityCollision(preview, false, false)
        FreezeEntityPosition(preview, true)
    end

    local anchor = model and Placement.AnchorFor(kind) or nil
    local rot, snap = 0.0, true
    local result
    -- Let the game take input back from the NUI before reading keys,
    -- otherwise the first key press is swallowed.
    SetNuiFocus(false, false)
    Wait(250)
    local ready = GetGameTimer() + 150
    lib.showTextUI('[E / Enter] Place  \n[Scroll] Rotate · [Shift] fine  \n[G] Surface snap on/off  \n[Backspace] Cancel', { position = 'right-center' })

    while true do
        Wait(0)
        for _, c in ipairs({ 14, 15, 16, 17, 24, 25, 37, 38, 44, 47, 140, 141, 142, 177, 191, 200, 201 }) do DisableControlAction(0, c, true) end

        local hit, _, coords, normal = lib.raycast.cam(17, 4, Config.Placement.maxDistance)
        local surface = hit and surfaceOf(normal) or 'wall'
        local step = IsControlPressed(0, 21) and Config.Placement.fineRotateStep or Config.Placement.rotateStep

        if IsDisabledControlJustPressed(0, 15) then rot = (rot + step) % 360 end
        if IsDisabledControlJustPressed(0, 14) then rot = (rot - step) % 360 end
        if IsDisabledControlJustPressed(0, 47) then
            snap = not snap
            lib.notify({ description = snap and 'Surface snap on' or 'Surface snap off' })
        end

        local pos, heading = coords, rot
        if hit then
            if snap and surface == 'wall' then
                heading = (GetHeadingFromVector_2d(normal.x, normal.y) + (anchor and anchor.heading or 0.0) + rot) % 360
                pos = coords + normal * Config.WallOffset
            elseif surface == 'ceiling' then
                pos = coords + normal * Config.CeilingOffset
            end

            if preview then
                local ep = Placement.EntityPos(pos, heading, anchor)
                SetEntityCoordsNoOffset(preview, ep.x, ep.y, ep.z, false, false, false)
                SetEntityHeading(preview, heading)
            else
                DrawMarker(28, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 0.12, 0.12, 0.12, 220, 30, 30, 190, false, false, 2, false, nil, nil, false)
                local tip = pos + normal * 0.35
                DrawLine(pos.x, pos.y, pos.z, tip.x, tip.y, tip.z, 255, 255, 255, 200)
            end
        end

        local canAct = GetGameTimer() > ready
        if canAct and (IsDisabledControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 191) or IsDisabledControlJustPressed(0, 201)) then
            if hit then
                local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                local cross = s2 ~= 0 and GetStreetNameFromHashKey(s2) or nil
                result = {
                    x = pos.x, y = pos.y, z = pos.z, h = heading, surface = surface, mode = mode,
                    location = {
                        street = GetStreetNameFromHashKey(s1),
                        cross = cross ~= '' and cross or nil,
                        zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)),
                    },
                }
                break
            else
                lib.notify({ type = 'error', description = 'Aim at a wall, ceiling or floor' })
            end
        end
        if canAct and (IsDisabledControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 200)) then break end
    end

    lib.hideTextUI()
    if preview then DeleteEntity(preview) end
    if model then SetModelAsNoLongerNeeded(model) end
    return result
end
