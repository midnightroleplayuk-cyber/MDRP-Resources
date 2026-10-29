inGizmo = false

function StartMovement(prop, data)
    local coords = GetEntityCoords(PlayerPedId())
    local heading = 0.0
    local hasSetHeading = false
    FreezeEntityPosition(prop, true)
    SetEntityCollision(prop, false, false)
    local isFrozen = false
    local rerenderTimer = 300
    while true do
        local speedMode = 1
        local hit, hitCoords, entity = GetDirectionCoords()
        if hit and hitCoords then 
            if not isFrozen then
                coords = vector3(hitCoords.x, hitCoords.y, hitCoords.z)
                heading = GetGameplayCamRot(2).z
                SetEntityCoords(prop, coords.x, coords.y, coords.z)
                if not data.keepRotation then
                    SetEntityRotation(prop, 0, 0, heading + (data.rotationOffset or 0.0), 2) 
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
                DeleteScriptObject(prop)
            end
            return nil
        end
        if isFrozen then
            local forwardVector --[[ vector3 ]], rightVector --[[ vector3 ]], upVector --[[ vector3 ]], position --[[ vector3 ]] = GetEntityMatrix(prop)
            if not data.keepRotation then
                if IsControlPressed(1, 15) then
                    heading = heading + (1.0 * speedMode)
                    if heading > 360.0 then heading = (360.0 - heading) end
                    SetEntityRotation(prop, 0.0, 0.0, heading + (data.rotationOffset or 0.0), 2, true)
                    hasSetHeading = true
                elseif IsControlPressed(1, 14) then
                    heading = heading - (1.0 * speedMode)
                    if heading < 0.0 then heading = (360.0 + heading) end
                    SetEntityRotation(prop, 0.0, 0.0, heading + (data.rotationOffset or 0.0), 2, true)
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
            SetEntityCoords(prop, coords.x, coords.y, coords.z)
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
        DeleteScriptObject(prop)
    end
    return {
        position = coords,
        rotation = vector3(0.0, 0.0, heading + (data.rotationOffset or 0.0)),
    }
end

function GetDirectionFromRotation(rotation)
    local dm = (math.pi / 180)
    return vector3(-math.sin(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.cos(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.sin(dm * rotation.x))
end

function GetDirectionCoords(coords, rotation)
    local range = 1000.0
	local coords = coords or GetGameplayCamCoord()
    local rot = rotation or GetGameplayCamRot(2)
    local dir = GetDirectionFromRotation(rot)
	local ecoords = vector3(coords.x + dir.x * range, coords.y + dir.y * range, coords.z + dir.z * range)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(StartShapeTestRay(coords.x, coords.y, coords.z, ecoords.x, ecoords.y, ecoords.z, -1, PlayerPedId(), 1))
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
        gizmoEntity = CreateProp(data.model, coords.x, coords.y, coords.z, false, false, false)
        SetEntityRotation(gizmoEntity, rotation.x, rotation.y, rotation.z, 2, true)
        SetEntityCollision(gizmoEntity, false, false)
        local result = StartMovement(gizmoEntity, data)
        DeleteScriptObject(gizmoEntity)
        gizmoEntity = nil
        inGizmo = false
        return result
    end
end