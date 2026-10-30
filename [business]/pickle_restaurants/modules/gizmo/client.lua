inGizmo = false

local function CleanupGizmoEntity(entity)
    if entity and DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end

local function ResolveGizmoModel(model)
    if type(model) == "number" then
        return model
    end
    if type(model) == "string" then
        return GetHashKey(model)
    end
    return nil
end

local function CreateGizmoPed(model, coords, rotation)
    local modelHash = ResolveGizmoModel(model)
    if not modelHash then return nil end
    if not IsModelInCdimage(modelHash) then return nil end
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end
    local ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z, rotation.z or 0.0, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetModelAsNoLongerNeeded(modelHash)
    return ped
end

-- Play a looping animation on a preview ped (seated seat placement). Streams the
-- dict in first; flag 1 = looping so it holds while the ped follows the cursor.
function PlayGizmoAnim(ped, anim)
    if not (ped and DoesEntityExist(ped) and anim and anim.dict and anim.name) then return end
    if not HasAnimDictLoaded(anim.dict) then
        RequestAnimDict(anim.dict)
        local t = GetGameTimer()
        while not HasAnimDictLoaded(anim.dict) and GetGameTimer() - t < 2000 do Wait(0) end
    end
    TaskPlayAnim(ped, anim.dict, anim.name, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

function StartMovement(prop, data)
    local coords = GetEntityCoords(PlayerPedId())
    local heading = 0.0
    local hasSetHeading = false
    FreezeEntityPosition(prop, true)
    SetEntityCollision(prop, false, false)
    local isFrozen = false
    local rerenderTimer = 300
    local coordsOffset = data.coordsOffset or vector3(0.0, 0.0, 0.0)
    local rotationOffset = data.rotationOffset or vector3(0.0, 0.0, 0.0)
    -- facePlacer: the preview looks BACK at you instead of away. While unfrozen the
    -- heading is re-derived from the camera every frame, so seeding a rotation on
    -- spawn is overwritten on the first frame the ray hits something — the flip has
    -- to live in the loop. Manual rotation (frozen) still works from there.
    local faceFlip = data.facePlacer and 180.0 or 0.0
    -- Persistent HEIGHT TRIM. Unfrozen, the prop rides the camera raycast, which
    -- pins it to whatever surface is under the cursor — so an anchor that has to sit
    -- a few centimetres above (or below) the mesh it lands on could only be trimmed
    -- by freezing first, which most admins never discover. This offset survives
    -- every raycast frame, so a seat, a serving-tray point or a virtual anchor can
    -- be lifted clear of the geometry it would otherwise clip into.
    local zAdjust = 0.0
    local Z_TRIM_STEP = 0.005 -- metres per frame, arrow keys (x4 with SHIFT). TUNE IN-GAME.
    -- UNFROZEN the trim is the SCROLL WHEEL: the prop is riding the cursor there, so
    -- the hand that lifts it should be the one already on the mouse. Per NOTCH, not
    -- per frame, hence the much larger step. Frozen, scroll is rotation and the arrows
    -- keep the height (the mouse is nudging position there).
    local Z_SCROLL_STEP = 0.05 -- metres per scroll notch (x4 with SHIFT). TUNE IN-GAME.
    while true do
        local speedMode = 1
        -- keep a seated-preview ped in its pose if moving it dropped the animation.
        -- Re-assert without re-streaming (dict already loaded), so a missing clip
        -- can never stall the placement loop.
        if data.anim and DoesEntityExist(prop) and HasAnimDictLoaded(data.anim.dict)
            and not IsEntityPlayingAnim(prop, data.anim.dict, data.anim.name, 3) then
            TaskPlayAnim(prop, data.anim.dict, data.anim.name, 8.0, -8.0, -1, 1, 0.0, false, false, false)
        elseif data.scenario and DoesEntityExist(prop) and not IsPedUsingScenario(prop, data.scenario) then
            TaskStartScenarioInPlace(prop, data.scenario, 0, false)
        end
        local hit, hitCoords, entity = GetDirectionCoords()
        if hit and hitCoords then 
            if not isFrozen then
                coords = vector3(hitCoords.x, hitCoords.y, hitCoords.z + coordsOffset.z + zAdjust)
                heading = (GetGameplayCamRot(2).z + faceFlip) % 360.0
                -- Wall-mounted props: nudge the prop back off the surface it's aimed
                -- at (toward the camera/placer) by data.wallOffset so it doesn't bury
                -- into the wall. Horizontal only, so a slightly-angled aim can't
                -- lift/sink it. Baked into `coords`, so the SAVED position matches.
                if data.wallOffset and data.wallOffset > 0.0 then
                    local cam = GetGameplayCamCoord()
                    local back = vector3(cam.x - hitCoords.x, cam.y - hitCoords.y, 0.0)
                    local len = #back
                    if len > 0.01 then
                        local inv = data.wallOffset / len
                        coords = vector3(coords.x + back.x * inv,
                                         coords.y + back.y * inv, coords.z)
                    end
                end
                SetEntityCoords(prop, coords.x + coordsOffset.x, coords.y + coordsOffset.y, coords.z)
                if not data.keepRotation then
                    SetEntityRotation(prop, rotationOffset.x, rotationOffset.y, heading + rotationOffset.z, 2) 
                end
            end
        end
        ShowInteractText(
            '[G]     - ' .. (isFrozen and _L("objects_unfreeze") or _L("objects_freeze")) .. '  \n' ..
            (isFrozen and _L("objects_position") or '') ..
            _L(isFrozen and "objects_height" or "objects_height_scroll") ..
            '[E]     - ' .. _L("objects_save") ..
            (data.enableCancel and '  \n[ESC / BACKSPACE]     - ' .. _L("objects_cancel") or '')
        )
        if IsControlPressed(1, 21) then
            speedMode = 4
        end
        if IsControlJustPressed(1, 47) then
            isFrozen = not isFrozen
        end
        -- Pause-menu suppression. Mirrors the working pattern in
        -- pickle_drugs/housing_admin's pickZoneArea: kill every pause
        -- control each frame and force the frontend back closed before
        -- our `IsDisabledControlJustReleased` check runs, otherwise a
        -- single ESC tap paints a frame of pause before we handle it.
        DisableControlAction(0, 199, true) -- INPUT_FRONTEND_PAUSE
        DisableControlAction(0, 200, true) -- INPUT_FRONTEND_PAUSE_ALTERNATE
        DisableControlAction(0, 322, true) -- INPUT_FRONTEND_PAUSE_ALTERNATE (alt)
        ForcePauseMenuClosed()
        if data.enableCancel and (
            IsControlJustPressed(1, 202)
            or IsDisabledControlJustReleased(0, 199)
            or IsDisabledControlJustReleased(0, 200)
            or IsDisabledControlJustReleased(0, 322)
        ) then
            if data.deleteEntity then
                CleanupGizmoEntity(prop)
            end
            -- This loop is what was keeping the key off the frontend, and it ends
            -- HERE — so the rest of the same press would open the pause menu behind
            -- the cancelled placement (modules/interactive).
            if GuardPauseKeys then GuardPauseKeys() end
            return nil
        end
        -- Height trim, live in BOTH modes: unfrozen it re-offsets every raycast
        -- frame (so the prop keeps its lift as you sweep the cursor around), frozen
        -- it nudges the parked point directly.
        local step
        if not isFrozen then
            -- scroll wheel while the prop follows the cursor
            if IsControlJustPressed(1, 15) then
                step = Z_SCROLL_STEP * speedMode
            elseif IsControlJustPressed(1, 14) then
                step = -Z_SCROLL_STEP * speedMode
            end
        elseif IsControlPressed(1, 172) or IsControlPressed(1, 173) then
            step = Z_TRIM_STEP * speedMode * (IsControlPressed(1, 172) and 1.0 or -1.0)
        end
        if step then
            zAdjust = zAdjust + step
            if isFrozen then
                coords = vector3(coords.x, coords.y, coords.z + step)
                SetEntityCoords(prop, coords.x + coordsOffset.x, coords.y + coordsOffset.y, coords.z)
            end
        end
        if isFrozen then
            -- Nudging is CAMERA-relative: "up" on the mouse pushes the prop away from
            -- the viewer and "right" pushes it to the right OF THE SCREEN, whichever
            -- way the prop itself happens to be turned. Taking the prop's own matrix
            -- (what this used to do) meant the axes rotated with the prop, so after
            -- turning it the nudge keys sent it sideways relative to what you saw.
            -- Yaw only, flattened to the ground plane — pitch must not shrink the
            -- step or leak height into a horizontal nudge (Z has its own key).
            local camYaw = math.rad(GetGameplayCamRot(2).z)
            local forwardVector = vector3(-math.sin(camYaw), math.cos(camYaw), 0.0)
            local rightVector   = vector3(math.cos(camYaw), math.sin(camYaw), 0.0)
            if not data.keepRotation then
                if IsControlPressed(1, 15) then
                    heading = heading + (1.0 * speedMode)
                    if heading > 360.0 then heading = (360.0 - heading) end
                    SetEntityRotation(prop, rotationOffset.x, rotationOffset.y, heading + rotationOffset.z, 2, true)
                    hasSetHeading = true
                elseif IsControlPressed(1, 14) then
                    heading = heading - (1.0 * speedMode)
                    if heading < 0.0 then heading = (360.0 + heading) end
                    SetEntityRotation(prop, rotationOffset.x, rotationOffset.y, heading + rotationOffset.z, 2, true)
                    hasSetHeading = true
                end
            end
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            if IsDisabledControlPressed(1, 24) then
                coords = vector3(coords.x, coords.y, coords.z + ((0.04 * speedMode) * GetDisabledControlNormal(0, 2)))
            else
                coords = coords - forwardVector * ((GetDisabledControlNormal(0, 2) * 0.02) * speedMode)
                coords = coords + rightVector * ((GetDisabledControlNormal(0, 1) * 0.02) * speedMode)
            end
            -- z already carries coordsOffset.z (baked into `coords` in the non-frozen
            -- branch); don't add it twice or a seated preview drops an extra offset.
            SetEntityCoords(prop, coords.x + coordsOffset.x, coords.y + coordsOffset.y, coords.z)
            -- if IsControlPressed(1, 172) then
            --     coords = coords + forwardVector * (0.005 * speedMode)
            --     SetEntityCoords(prop, coords.x, coords.y, coords.z)
            -- elseif IsControlPressed(1, 173) then
            --     coords = coords - forwardVector * (0.005 * speedMode)
            --     SetEntityCoords(prop, coords.x, coords.y, coords.z)
            -- end
            -- if IsControlPressed(1, 174) then
            --     coords = coords - rightVector * (0.005 * speedMode)
            --     SetEntityCoords(prop, coords.x, coords.y, coords.z)
            -- elseif IsControlPressed(1, 175) then
            --     coords = coords + rightVector * (0.005 * speedMode)
            --     SetEntityCoords(prop, coords.x, coords.y, coords.z)
            -- end
        end
        if data.lightColor then
            SetObjectLightColor(prop, 1, data.lightColor[1], data.lightColor[2], data.lightColor[3])
        end
        if IsControlJustPressed(1, 51) then
            break
        end
        Wait(0) 
    end
    if data.deleteEntity then
        CleanupGizmoEntity(prop)
    end
    return {
        position = coords - coordsOffset,
        rotation = vector3(0.0, 0.0, heading),
    }
end

function GetDirectionFromRotation(rotation)
    local dm = (math.pi / 180)
    return vector3(-math.sin(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.cos(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.sin(dm * rotation.x))
end

function GetDirectionCoords(coords, rotation, intersectType)
    local range = 1000.0
	local coords = coords or GetGameplayCamCoord()
    local rot = rotation or GetGameplayCamRot(2)
    local dir = GetDirectionFromRotation(rot)
	local ecoords = vector3(coords.x + dir.x * range, coords.y + dir.y * range, coords.z + dir.z * range)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(StartShapeTestRay(coords.x, coords.y, coords.z, ecoords.x, ecoords.y, ecoords.z, intersectType or -1, PlayerPedId(), 1))
	return hit, endCoords, entityHit 
end


function ConvertScreenCoordinates(position)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(position.x, position.y, position.z)
    if not onScreen then
        return nil
    end

    local newPos = {}
    newPos.x = (_x - 0.5) * 2
    newPos.y = (_y - 0.5) * 2
    newPos.z = 0
    return vector3(newPos.x, newPos.y, newPos.z)
end

function ScreenToWorld(camPos, camRot, relX, relY)
    local cameraRange = 1.0
    local camForward = GetDirectionFromRotation(camRot)
    local rotUp = camRot + vector3(cameraRange, 0, 0)
    local rotDown = camRot + vector3(-cameraRange, 0, 0)
    local rotLeft = camRot + vector3(0, 0, -cameraRange)
    local rotRight = camRot + vector3(0, 0, cameraRange)

    local camRight = GetDirectionFromRotation(rotRight) - GetDirectionFromRotation(rotLeft)
    local camUp = GetDirectionFromRotation(rotUp) - GetDirectionFromRotation(rotDown)

    local rollRad = -((camRot.y * math.pi) / 180.0)
    local camRightRoll = (camRight * math.cos(rollRad)) - (camUp * math.sin(rollRad))
    local camUpRoll = (camRight * math.sin(rollRad)) + (camUp * math.cos(rollRad))
    local screenCoords = ConvertScreenCoordinates(((camPos + (camForward * cameraRange)) + camRightRoll) + camUpRoll)

    if screenCoords == undefined then
        return (camPos + (camForward * cameraRange))
    end

    local zero3d = (camPos + (camForward * cameraRange))
    local zero2d = ConvertScreenCoordinates(zero3d)

    if zero2d == nil then
        return (camPos + (camForward * cameraRange))
    end

    if math.abs(screenCoords.x - zero2d.x) < 0.001 or math.abs(screenCoords.y - zero2d.y) < 0.001 then
        return (camPos + (camForward * cameraRange))
    end

    local scaleX = (relX - zero2d.x) / (screenCoords.x - zero2d.x)
    local scaleY = (relY - zero2d.y) / (screenCoords.y - zero2d.y)
    return ((camPos + (camForward * cameraRange)) + (camRightRoll * scaleX)) + (camUpRoll * scaleY)
end

function GetCursorRaycast(camPos, camRot, flags, ignore)
    local x, y = GetNuiCursorPosition()

    local absoluteX = x
    local absoluteY = y

    local screenX, screenY = GetActiveScreenResolution()

    local relativeX = 1 - (x / screenX) * 1.0 * 2
    local relativeY = 1 - (y / screenY) * 1.0 * 2

    if relativeX > 0.0 then
        relativeX = -relativeX;
    else
        relativeX = math.abs(relativeX)
    end

    if relativeY > 0.0 then
        relativeY = -relativeY
    else
        relativeY = math.abs(relativeY)
    end
    
    local target = ScreenToWorld(camPos, camRot, relativeX, relativeY)

    local dir = target - camPos
    local from = camPos + (dir * 0.05)
    local to = camPos + (dir * 300)

    -- Ignore the player's own ped by default, otherwise the cursor ray hits the
    -- body standing between the camera and what we're aiming at (e.g. the oven
    -- doors). Callers can still override the ignore entity / intersect flags.
    local ray = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, flags or -1, ignore or PlayerPedId(), 1)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
    return hit, endCoords, entityHit
end

function StartGizmoEditor(data)
    if inGizmo then return false end
    inGizmo = true
    -- The launching panel just closed for placement, resetting the NUI to the
    -- default theme; re-skin the [E]/[G] hint overlay to that panel's theme.
    if ReassertNUITheme then ReassertNUITheme() end
    local ped = PlayerPedId()
    local coords = data.coords or (GetEntityCoords(ped) + GetEntityForwardVector(ped) * 3)
    local rotation = data.rotation or vector3(0.0, 0.0, GetEntityHeading(ped))
    if data.entity then
        SetEntityCoords(data.entity, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityRotation(data.entity, rotation.x, rotation.y, rotation.z, 2, true)
        -- onSpawn/onDespawn let a caller hang extra preview props off the gizmo
        -- entity (the stovetop's oven doors) without the gizmo knowing about them.
        if data.onSpawn then data.onSpawn(data.entity) end
        local result = StartMovement(data.entity, data)
        if data.onDespawn then data.onDespawn() end
        inGizmo = false
        return result
    else
        if data.isPed then
            gizmoEntity = CreateGizmoPed(data.model, coords, rotation)
            -- A seated preview: play the looping sit animation (matching the real
            -- sit) so the ghost shows the exact pose the player will get.
            if gizmoEntity and data.anim then
                PlayGizmoAnim(gizmoEntity, data.anim)
            elseif gizmoEntity and data.scenario then
                TaskStartScenarioInPlace(gizmoEntity, data.scenario, 0, false)
            end
        else
            gizmoEntity = CreateProp(data.model, coords.x, coords.y, coords.z, false, false, false)
        end
        if not gizmoEntity or not DoesEntityExist(gizmoEntity) then
            inGizmo = false
            return nil
        end
        SetEntityRotation(gizmoEntity, rotation.x, rotation.y, rotation.z, 2, true)
        SetEntityCollision(gizmoEntity, false, false)
        if data.onSpawn then data.onSpawn(gizmoEntity) end
        local result = StartMovement(gizmoEntity, data)
        if data.onDespawn then data.onDespawn() end
        CleanupGizmoEntity(gizmoEntity)
        gizmoEntity = nil
        inGizmo = false
        return result
    end
end