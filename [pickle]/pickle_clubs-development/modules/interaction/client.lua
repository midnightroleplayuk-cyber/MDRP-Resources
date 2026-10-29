INT_ENTITIES = {}
CURRENT_ENTITY = nil
CURRENT_INTERACTION = nil
HOVERED_ENTITY = nil
SCROLL_INPUT = 0 -- -1 = scroll up, 1 = scroll down, 0 = none
local InteractiveEntityTypes = {}

function lerp(a, b, t)
    return a + (b - a) * t
end

-- Draw 3D text at a world position
function DrawText3D(x, y, z, text)
    local success, screenX, screenY = World3dToScreen2d(x, y, z)
    if success then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(screenX - (text:len() * 0.0015), screenY)
    end
end

function InteractiveEntityThread(entity, data)
    local currentEntity = INT_ENTITIES[entity]
    if not currentEntity then return end
    local entType = InteractiveEntityTypes[currentEntity.type]
    if not entType then return end
    if entType.entityThread then
        entType.entityThread(entity, data)
    end
end

function SelectedInteractiveEntityThread(entity, data)
    local currentEntity = INT_ENTITIES[entity]
    if not currentEntity then return end
    local entType = InteractiveEntityTypes[currentEntity.type]
    if not entType then return end
    if entType.selectedThread then
        entType.selectedThread(entity, data)
    end
end

function UnselectedInteractiveEntity(entity, data)
    local currentEntity = INT_ENTITIES[entity]
    if not currentEntity then return end
    local entType = InteractiveEntityTypes[currentEntity.type]
    if not entType then return end
    if entType.unSelected then
        entType.unSelected(entity, data)
    end
end

function InteractiveEntityClicked(entity, data)
    local currentEntity = INT_ENTITIES[entity]
    if not currentEntity then return end
    local entType = InteractiveEntityTypes[currentEntity.type]
    if not entType then return end
    if entType.clicked then
        entType.clicked(entity, data)
    end
end

function RegisterInteractiveEntity(entType, data)
    InteractiveEntityTypes[entType] = data
end

function UpdateInteractiveEntityDisplay(entity, data)
    if not INT_ENTITIES[entity] then return end
    if data then
        for k,v in pairs(data) do
            INT_ENTITIES[entity].display[k] = v
        end
    else
        INT_ENTITIES[entity].display = nil
    end
end

function DeleteInteractiveEntity(entity)
    if not INT_ENTITIES[entity] then return end
    local entType = InteractiveEntityTypes[INT_ENTITIES[entity].type]
    if not entType then return end
    if entType.delete then
        entType.delete(entity)
    end
    if CURRENT_ENTITY == entity then
        CURRENT_ENTITY = nil
    end
    DeleteEntity(entity)
    INT_ENTITIES[entity] = nil
end

function CreateInteractiveEntity(entType, coords, heading, params)
    -- local entity = CreateEntity(entType, coords, heading, data)
    -- INT_ENTITIES[entity] = data
    if not InteractiveEntityTypes[entType] then return print("ERROR: No interactive entity type found for: ", entType) end
    local entityData = {
        type = entType,
        zOffset = 0.01,
        display = params.display,
    }
    local entity = nil
    local newData = {}
    if InteractiveEntityTypes[entType].init then
        entity, newData = InteractiveEntityTypes[entType].init(coords, heading, entityData, params)
    end
    if not entity then return print("ERROR: No entity created for: ", entType) end
    for k,v in pairs(newData or {}) do
        entityData[k] = v
    end
    INT_ENTITIES[entity] = entityData
    return entity
end

function StartInteraction(coords, heading)
    if CURRENT_INTERACTION then return ShowNotification("ERROR: Interaction already started") end
    local temp = CreateTennisBall(coords.x, coords.y, coords.z)
    SetEntityRotation(temp, 0.0, 0.0, heading, 2, true)
    local forwardVector, rightVector, upVector, position = GetEntityMatrix(temp)
    DeleteEntity(temp)
    CreateScriptedCamera()
    local camCoords = coords + (forwardVector * -0.5) + vector3(0.0, 0.0, 0.35)
    local camRotation = vector3(-10.0, 0.0, heading)
    SetCamParams(CurrentCamera, camCoords.x, camCoords.y, camCoords.z,
        camRotation.x, camRotation.y, camRotation.z, 90.0, 
        0, 0, 0, 2
    )
    CURRENT_INTERACTION = {
        coords = coords,
        heading = heading,
        forwardVector = forwardVector,
        rightVector = rightVector,
        upVector = upVector,
    }
    -- Send controls to NUI
    SendNUIMessage({
        type = "updateControls",
        controls = {
            {key = "ESC", label = "controls_exit"}
        }
    })
    CreateThread(function()
        local pitch = 0.0
        local lastX, lastY = -1, -1
        while CURRENT_INTERACTION do
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 51, true)
            -- Handle ESC to exit interaction (control 200 = ESC)
            -- Use IsControlJustPressed instead of IsDisabledControlJustPressed so ESC isn't blocked
            if IsControlJustPressed(0, 200) then
                StopInteraction()
                break
            end
            local screenX, screenY = GetNuiCursorPosition()
            local x, y = GetActualScreenResolution()
            screenX = screenX / x
            screenY = screenY / y
            -- Update hovered entity and scroll input before entity threads
            if not CURRENT_ENTITY then
                local hit, _, entityHit = GetCursorRaycast(camCoords, camRotation)
                HOVERED_ENTITY = (hit and entityHit and DoesEntityExist(entityHit) and INT_ENTITIES[entityHit]) and entityHit or nil
                if IsControlJustPressed(1, 15) then
                    SCROLL_INPUT = 1
                elseif IsControlJustPressed(1, 14) then
                    SCROLL_INPUT = -1
                else
                    SCROLL_INPUT = 0
                end
            else
                HOVERED_ENTITY = nil
                SCROLL_INPUT = 0
            end
            for k,v in pairs(INT_ENTITIES) do
                InteractiveEntityThread(k, {
                    coords = coords,
                    heading = heading,
                    minimum = minimum,
                    maximum = maximum,
                })
            end
            if not CURRENT_ENTITY then
                local hit, dragCoords, entityHit = GetCursorRaycast(camCoords, camRotation)
                -- DrawMarker(1, dragCoords.x, dragCoords.y, dragCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255, 0, 0, 255, false, false, 2)
                if IsDisabledControlJustPressed(0, 24)  then
                    if hit and DoesEntityExist(entityHit) and INT_ENTITIES[entityHit] then
                        if not INT_ENTITIES[entityHit].disableInteraction then
                            CURRENT_ENTITY = entityHit
                            pitch = GetEntityRotation(CURRENT_ENTITY).x
                        end
                        InteractiveEntityClicked(entityHit)
                    end
                end
                SetMouseCursorThisFrame()
            else
                local currentEntity = INT_ENTITIES[CURRENT_ENTITY]
                local minimum, maximum = GetModelDimensions(GetEntityModel(CURRENT_ENTITY))
                local dragCoords = coords + (rightVector * lerp(-0.85, 0.85, screenX)) - (upVector * (screenY - 1))
                SelectedInteractiveEntityThread(CURRENT_ENTITY, {
                    coords = coords,
                    heading = heading,
                    minimum = minimum,
                    maximum = maximum,
                    dragCoords = dragCoords,
                    pitch = pitch,
                })
                if IsDisabledControlPressed(0, 25) then
                    local normal = GetDisabledControlNormal(0, 1) * 60.0
                    pitch = pitch + normal
                    pitch = (pitch % 360 + 360) % 360
                    SetEntityRotation(CURRENT_ENTITY, 0.0, pitch, heading, 2, true)
                    if lastX == -1 then
                        lastX = screenX
                        lastY = screenY
                    end
                else
                    SetMouseCursorThisFrame()
                    if lastX ~= -1 then
                        screenX = lastX
                        screenY = lastY
                        SetCursorLocation(lastX, lastY)
                        lastX = -1
                        lastY = -1
                    else
                        local forwardVector, rightVector, upVector, position = GetEntityMatrix(CURRENT_ENTITY)
                        local propCoords = dragCoords
                        currentEntity.zOffset = GetEntityCoords(CURRENT_ENTITY).z - coords.z
                        SetEntityCoords(CURRENT_ENTITY, propCoords.x, propCoords.y, propCoords.z - (currentEntity.heightOffset or 0))
                        if not IsDisabledControlPressed(0, 24) then
                            UnselectedInteractiveEntity(CURRENT_ENTITY)
                            CURRENT_ENTITY = nil
                        end
                    end
                end
            end
            for k,v in pairs(INT_ENTITIES) do
                local entityCoords = GetEntityCoords(k)
                if CURRENT_ENTITY ~= k and not v.disableGravity and (v.zOffset > 0.0 or v.zOffset < 0.0) then
                    v.zOffset = v.zOffset - 0.050
                    if v.zOffset <= 0.0 then
                        v.zOffset = 0.0
                        SetEntityRotation(k, 0.0, 0.0, heading, 2, true)
                    end
                    entityCoords = vector3(entityCoords.x, entityCoords.y, coords.z + v.zOffset)
                    SetEntityCoordsNoOffset(k, entityCoords.x, entityCoords.y, entityCoords.z)
                end
                if v.display then
                    local onScreen, entityScreenX, entityScreenY = GetScreenCoordFromWorldCoord(entityCoords.x, entityCoords.y, entityCoords.z)
                    local rotation = GetEntityRotation(k, 2)
                    local maxScale = v.display.maxScale or 1.0
                    local minScale = v.display.minScale or 0.0
                    local scale = maxScale
                    if v.display.hiddenHover then
                        -- Use 2D screen distance between cursor and entity for scaling
                        local cursorX, cursorY = GetNuiCursorPosition()
                        local resX, resY = GetActiveScreenResolution()
                        local normalizedCursorX = cursorX / resX
                        local normalizedCursorY = cursorY / resY
                        local screenDist = math.sqrt((normalizedCursorX - entityScreenX)^2 + (normalizedCursorY - entityScreenY)^2)
                        local hoverRadius = v.display.hoverRadius or 0.08
                        if screenDist <= hoverRadius then
                            scale = maxScale
                        else
                            scale = lerp(maxScale, 0.0, (screenDist - hoverRadius) / hoverRadius)
                        end
                        if scale < minScale then scale = minScale end
                    end
                    -- Apply itemSize as a base size multiplier (independent of hover scaling)
                    local itemSize = v.display.itemSize or 1.0
                    SendNUIMessage({
                        type = "updateInteractiveEntityDisplay",
                        data = {
                            entity = k,
                            coords = entityCoords,
                            pitch = rotation.y,
                            display = v.display,
                            onScreen = onScreen,
                            screenX = entityScreenX,
                            screenY = entityScreenY,
                            scale = scale * itemSize,
                        }
                    })
                end
            end
            Wait(0)
        end
    end)
    return CURRENT_INTERACTION
end

function StopInteraction()
    if not CURRENT_INTERACTION then return end
    
    -- Trigger event for other modules to cleanup (like station control)
    TriggerEvent("pickle_clubs:stopInteraction")
    
    -- Hide controls in NUI
    SendNUIMessage({
        type = "updateControls",
        controls = nil
    })
    
    -- Clear all interactive entity displays
    for k,v in pairs(INT_ENTITIES) do
        SendNUIMessage({
            type = "updateInteractiveEntityDisplay",
            data = {
                entity = k,
                onScreen = false,
                display = nil,
            }
        })
        DeleteEntity(k)
    end
    INT_ENTITIES = {}
    CURRENT_INTERACTION = nil
    ExitScriptedCamera(2000)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for k,v in pairs(INT_ENTITIES) do
            DeleteEntity(k)
        end
        INT_ENTITIES = {}
    end
end)