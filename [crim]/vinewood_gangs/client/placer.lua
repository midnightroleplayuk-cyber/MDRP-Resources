-- Placing NPCs from the staff panel: a see-through preview of the real NPC follows where you look, you turn it
-- with the mouse wheel and press E to place it. Used for heist contacts, hostages and guards.

local function camDirection()
    local r = GetGameplayCamRot(2)
    local x, z = math.rad(r.x), math.rad(r.z)
    local n = math.abs(math.cos(x))
    return vector3(-math.sin(z) * n, math.cos(z) * n, math.sin(x))
end

---Where the player is looking: the first bit of world or object the camera ray hits (not people).
local function aimPoint(maxDist)
    local from = GetGameplayCamCoord()
    local to = from + camDirection() * maxDist
    local ray = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, 1 | 16, cache.ped, 7)
    local _, hit, coords = GetShapeTestResult(ray)
    if hit == 1 then
        -- Don't let it be placed miles away
        if #(coords - GetEntityCoords(cache.ped)) <= maxDist then return coords end
    end
    local p = GetEntityCoords(cache.ped) + GetEntityForwardVector(cache.ped) * 2.0
    local found, gz = GetGroundZFor_3dCoord(p.x, p.y, p.z + 2.0, false)
    return vector3(p.x, p.y, found and gz or p.z - 1.0)
end

local function ghostPed(model, alpha)
    local ped = CreatePed(4, model, 0.0, 0.0, 0.0, 0.0, false, false)
    SetEntityAlpha(ped, alpha, false)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)
    return ped
end

---Places one NPC (or several, for guards). Returns a list of { x, y, z, w } (z is where a person's middle sits,
---like a standing player's position), or nil if cancelled.
function PlaceNpcs(opts)
    opts = opts or {}
    local name = opts.model
    if not (name and IsModelInCdimage(GetHashKey(name)) and IsModelAPed(GetHashKey(name))) then name = 'a_m_m_business_01' end
    local model = lib.requestModel(name, 10000)
    if not model then return nil end
    local multi = opts.multi == true
    local max = math.max(1, math.min(12, tonumber(opts.max) or 1))

    local ghost = ghostPed(model, 160)
    local placed, points = {}, {}
    local heading = (GetEntityHeading(cache.ped) + 180.0) % 360.0 -- facing you to start with
    local shown, result = nil, nil

    while true do
        -- Keep the wheel, E and X for us while placing
        for _, c in ipairs({ 14, 15, 16, 17, 24, 25, 37, 38, 44, 73, 140, 141, 142, 177, 191, 194, 200, 261, 262 }) do DisableControlAction(0, c, true) end
        local fine = IsDisabledControlPressed(0, 21) -- shift
        if IsDisabledControlJustPressed(0, 15) or IsDisabledControlJustPressed(0, 261) then heading = (heading + (fine and 2.0 or 15.0)) % 360.0 end
        if IsDisabledControlJustPressed(0, 14) or IsDisabledControlJustPressed(0, 262) then heading = (heading - (fine and 2.0 or 15.0)) % 360.0 end

        local p = aimPoint(30.0)
        SetEntityCoordsNoOffset(ghost, p.x, p.y, p.z + 1.0, false, false, false)
        SetEntityHeading(ghost, heading)
        DrawMarker(25, p.x, p.y, p.z + 0.03, 0, 0, 0, 0, 0, 0, 0.9, 0.9, 0.9, 91, 141, 239, 160, false, false, 2, false, nil, nil, false)
        -- Which way they'll face
        local f = vector3(math.sin(math.rad(-heading)), math.cos(math.rad(-heading)), 0.0)
        DrawLine(p.x, p.y, p.z + 0.05, p.x + f.x * 1.2, p.y + f.y * 1.2, p.z + 0.05, 91, 141, 239, 255)

        local help = multi and locale('place_help_multi', #points + 1, max) or locale('place_help_single')
        if help ~= shown then lib.showTextUI(help) shown = help end

        if IsDisabledControlJustPressed(0, 38) then -- E
            local point = { x = p.x, y = p.y, z = p.z + 1.0, w = heading }
            if not multi then result = { point } break end
            points[#points + 1] = point
            local copy = ghostPed(model, 230)
            SetEntityCoordsNoOffset(copy, point.x, point.y, point.z, false, false, false)
            SetEntityHeading(copy, heading)
            placed[#placed + 1] = copy
            if #points >= max then result = points break end
        elseif multi and IsDisabledControlJustPressed(0, 177) and #points > 0 then -- backspace: undo the last one
            points[#points] = nil
            local last = table.remove(placed)
            if last and DoesEntityExist(last) then DeleteEntity(last) end
        elseif multi and IsDisabledControlJustPressed(0, 191) and #points > 0 then -- enter: done
            result = points
            break
        elseif IsDisabledControlJustPressed(0, 73) then -- X: cancel
            result = nil
            break
        end
        Wait(0)
    end

    lib.hideTextUI()
    if DoesEntityExist(ghost) then DeleteEntity(ghost) end
    for _, e in ipairs(placed) do if DoesEntityExist(e) then DeleteEntity(e) end end
    SetModelAsNoLongerNeeded(model)
    return result
end
