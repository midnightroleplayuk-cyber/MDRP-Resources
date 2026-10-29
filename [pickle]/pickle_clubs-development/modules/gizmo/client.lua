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
    while true do
        local speedMode = 1
        local hit, hitCoords, entity = GetDirectionCoords()
        if hit and hitCoords then 
            if not isFrozen then
                coords = vector3(hitCoords.x, hitCoords.y, hitCoords.z + coordsOffset.z)
                heading = GetGameplayCamRot(2).z
                SetEntityCoords(prop, coords.x + coordsOffset.x, coords.y + coordsOffset.y, coords.z)
                if not data.keepRotation then
                    SetEntityRotation(prop, rotationOffset.x, rotationOffset.y, heading + rotationOffset.z, 2) 
                end
            end
        end
        ShowInteractText(
            '[G]     - ' .. (isFrozen and _L("objects_unfreeze") or _L("objects_freeze")) .. '  \n' ..
            (isFrozen and _L("objects_position") or '') ..
            '[E]     - ' .. _L("objects_save") ..
            (data.enableCancel and '  \n[ESC / BACKSPACE]     - ' .. _L("objects_cancel") or '')
        )
        if IsControlPressed(1, 21) then
            speedMode = 4
        end
        if IsControlJustPressed(1, 47) then
            isFrozen = not isFrozen
        end
        if data.enableCancel and (IsControlJustPressed(1, 202)) then
            if data.deleteEntity then
                CleanupGizmoEntity(prop)
            end
            return nil
        end
        if isFrozen then
            local forwardVector --[[ vector3 ]], rightVector --[[ vector3 ]], upVector --[[ vector3 ]], position --[[ vector3 ]] = GetEntityMatrix(prop)
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
            SetEntityCoords(prop, coords.x + coordsOffset.x, coords.y + coordsOffset.y, coords.z + coordsOffset.z)
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

    local ray = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, -1, -1, 1)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
    return hit, endCoords, entityHit
end

function StartGizmoEditor(data)
    if inGizmo then return false end
    inGizmo = true
    local ped = PlayerPedId()
    local coords = data.coords or (GetEntityCoords(ped) + GetEntityForwardVector(ped) * 3)
    local rotation = data.rotation or vector3(0.0, 0.0, GetEntityHeading(ped))
    if data.entity then
        SetEntityCoords(data.entity, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityRotation(data.entity, rotation.x, rotation.y, rotation.z, 2, true)
        local result = StartMovement(data.entity, data)
        inGizmo = false
        return result
    else
        if data.isPed then
            gizmoEntity = CreateGizmoPed(data.model, coords, rotation)
        else
            gizmoEntity = CreateProp(data.model, coords.x, coords.y, coords.z, false, false, false)
        end
        if not gizmoEntity or not DoesEntityExist(gizmoEntity) then
            inGizmo = false
            return nil
        end
        SetEntityRotation(gizmoEntity, rotation.x, rotation.y, rotation.z, 2, true)
        SetEntityCollision(gizmoEntity, false, false)
        local result = StartMovement(gizmoEntity, data)
        CleanupGizmoEntity(gizmoEntity)
        gizmoEntity = nil
        inGizmo = false
        return result
    end
end