local enabled = false
local authorized = false
local lastEntity = 0
local lastValidInfo = nil
local lastValidAt = 0

local function notify(message, notifyType)
    lib.notify({
        title = 'HF1 Prop Dev',
        description = message,
        type = notifyType or 'inform'
    })
end

local function copyValue(label, value)
    local text = tostring(value)
    lib.setClipboard(text)
    notify(('%s copied to clipboard.'):format(label), 'success')
end

local function rotationToDirection(rotation)
    local adjustedZ = math.rad(rotation.z)
    local adjustedX = math.rad(rotation.x)
    local cosX = math.abs(math.cos(adjustedX))

    return vector3(
        -math.sin(adjustedZ) * cosX,
        math.cos(adjustedZ) * cosX,
        math.sin(adjustedX)
    )
end

local function getCameraRay(distance)
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local direction = rotationToDirection(camRot)
    local destination = camCoords + (direction * distance)
    return camCoords, destination
end

-- Persistent HUD centre dot. This is deliberately 2D and completely independent
-- from entity/raycast results, so it remains visible even when the camera is still.
local function drawPropDevCrosshair()
    if Config.DrawCrosshair == false then return end

    local c = Config.CrosshairColor or { r = 0, g = 255, b = 0, a = 255 }
    local dot = Config.CrosshairDotSize or 0.0040

    -- Bright-green circular centre dot only. Build the circle from tiny HUD
    -- scanlines so it stays dependency-free and remains visible every frame.
    -- Detection still uses the exact camera-centre ray.
    local radius = dot * 0.5
    local rows = Config.CrosshairCircleRows or 11
    local rowHeight = dot / rows

    -- HUD X/Y values are normalized independently, so the same normalized
    -- width and height are not the same number of screen pixels. Scale X by
    -- height / width so this remains a true circle at 16:9, 21:9, etc.
    local screenWidth, screenHeight = GetActiveScreenResolution()
    local xAspectCorrection = 1.0
    if screenWidth and screenHeight and screenWidth > 0 and screenHeight > 0 then
        xAspectCorrection = screenHeight / screenWidth
    end

    for i = 0, rows - 1 do
        local yOffset = ((i + 0.5) / rows * 2.0 - 1.0) * radius
        local normalizedY = yOffset / radius
        local halfWidth = radius * math.sqrt(math.max(0.0, 1.0 - (normalizedY * normalizedY)))

        DrawRect(
            0.5,
            0.5 + yOffset,
            (halfWidth * 2.0) * xAspectCorrection,
            rowHeight * 1.15,
            c.r, c.g, c.b, c.a
        )
    end
end

local function runShapeTest(handle)
    -- Shape tests can take more than one frame to complete. Poll briefly rather
    -- than treating a pending result as a miss (important for MLO/map objects).
    for _ = 1, 10 do
        local state, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
        if state ~= 1 then
            return hit == 1, endCoords, surfaceNormal, entityHit
        end
        Wait(0)
    end

    return false, nil, nil, 0
end

local function raycastFromCamera(distance)
    local camCoords, destination = getCameraRay(distance)
    local flags = Config.RaycastFlags or 511
    local ignore = PlayerPedId()

    -- First use an exact LOS ray so the laser terminates exactly where the
    -- centre of the gameplay camera is pointing.
    local losHandle = StartShapeTestLosProbe(
        camCoords.x, camCoords.y, camCoords.z,
        destination.x, destination.y, destination.z,
        flags,
        ignore,
        7
    )

    local worldHit, hitCoords, surfaceNormal, entityHit = runShapeTest(losHandle)

    -- Some MLO/static props have collision that the LOS probe hits as world
    -- geometry without returning an entity handle. Sweep a very small capsule
    -- down the SAME camera ray to acquire nearby object/entity handles.
    if entityHit == 0 and Config.UseCapsuleFallback ~= false then
        local radius = Config.RaycastRadius or 0.12
        local capsuleHandle = StartShapeTestCapsule(
            camCoords.x, camCoords.y, camCoords.z,
            destination.x, destination.y, destination.z,
            radius,
            flags,
            ignore,
            7
        )

        local capsuleHit, capsuleCoords, capsuleNormal, capsuleEntity = runShapeTest(capsuleHandle)
        if capsuleHit and capsuleEntity ~= 0 then
            entityHit = capsuleEntity
            -- Keep the exact LOS impact for the laser when available. This
            -- prevents the visible line from appearing to bend/snap sideways.
            if not worldHit then
                hitCoords = capsuleCoords
                surfaceNormal = capsuleNormal
                worldHit = true
            end
        end
    end

    return worldHit, hitCoords or destination, surfaceNormal, entityHit, camCoords, destination
end

local function entityTypeName(entity)
    local entityType = GetEntityType(entity)
    if entityType == 1 then return 'Ped' end
    if entityType == 2 then return 'Vehicle' end
    if entityType == 3 then return 'Object / Prop' end
    return 'Unknown'
end

local function getModelDisplayName(entity, model)
    if IsEntityAVehicle(entity) then
        local display = GetDisplayNameFromVehicleModel(model)
        if display and display ~= '' and display ~= 'CARNOTFOUND' then
            local label = GetLabelText(display)
            if label and label ~= 'NULL' then
                return ('%s (%s)'):format(display, label)
            end
            return display
        end
    end

    -- FiveM/GTA does not expose a universal reverse hash -> archetype-name native
    -- for every map/object entity. GetEntityArchetypeName is available on modern
    -- FiveM builds and gives the useful prop/model name where supported.
    if GetEntityArchetypeName then
        local ok, name = pcall(GetEntityArchetypeName, entity)
        if ok and name and name ~= '' then
            return name
        end
    end

    return 'Unknown / hash only'
end

local function safeNative(default, fn, ...)
    local ok, value = pcall(fn, ...)
    if ok and value ~= nil then return value end
    return default
end

local function buildEntityInfo(entity)
    -- Map/MLO object handles can disappear as streaming updates. Every native that
    -- dereferences the entity is therefore protected; a bad handle must never kill
    -- the propdev render thread.
    if entity == 0 or not DoesEntityExist(entity) then return nil end

    local model = safeNative(0, GetEntityModel, entity)
    if model == 0 then return nil end

    local coords = safeNative(nil, GetEntityCoords, entity)
    local rotation = safeNative(nil, GetEntityRotation, entity, 2)
    if not coords or not rotation then return nil end

    local networked = safeNative(false, NetworkGetEntityIsNetworked, entity) == true
    local netId = networked and safeNative(0, NetworkGetNetworkIdFromEntity, entity) or 0
    local owner = networked and safeNative(-1, NetworkGetEntityOwner, entity) or -1

    return {
        entity = entity,
        typeName = entityTypeName(entity),
        modelName = getModelDisplayName(entity, model),
        modelHash = model,
        modelHashHex = ('0x%08X'):format(model & 0xFFFFFFFF),
        coords = coords,
        rotation = rotation,
        networked = networked,
        netId = netId,
        owner = owner,
        missionEntity = safeNative(false, IsEntityAMissionEntity, entity),
        visible = safeNative(true, IsEntityVisible, entity),
        heading = safeNative(0.0, GetEntityHeading, entity)
    }
end

local function drawText2D(x, y, text, scale)
    SetTextFont(0)
    SetTextScale(scale or 0.32, scale or 0.32)
    SetTextColour(255, 255, 255, 235)
    SetTextOutline()
    SetTextDropShadow()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function drawPanel(info)
    local x = 0.015
    local y = 0.32
    local line = 0.024

    DrawRect(0.155, 0.445, 0.29, 0.285, 0, 0, 0, 165)
    drawText2D(x, y, '~b~HF1 PROP DEV~s~', 0.38)
    y = y + line * 1.35
    drawText2D(x, y, ('Type: ~y~%s~s~'):format(info.typeName)); y = y + line
    drawText2D(x, y, ('Model: ~g~%s~s~'):format(info.modelName)); y = y + line
    drawText2D(x, y, ('Hash: %s  |  %s'):format(info.modelHash, info.modelHashHex)); y = y + line
    drawText2D(x, y, ('Entity handle: %s'):format(info.entity)); y = y + line

    if Config.ShowNetworkId then
        drawText2D(x, y, ('Networked: %s  |  Net ID: %s  |  Owner: %s'):format(
            tostring(info.networked), info.netId, info.owner
        )); y = y + line
    end

    if Config.ShowEntityCoords then
        drawText2D(x, y, ('Coords: %.3f, %.3f, %.3f'):format(info.coords.x, info.coords.y, info.coords.z)); y = y + line
    end

    if Config.ShowRotation then
        drawText2D(x, y, ('Rotation: %.2f, %.2f, %.2f'):format(info.rotation.x, info.rotation.y, info.rotation.z)); y = y + line
    end

    drawText2D(x, y, ('Mission entity: %s  |  Visible: %s'):format(
        tostring(info.missionEntity), tostring(info.visible)
    )); y = y + line

    drawText2D(x, y, ('~c~[%s] Copy menu  |  /%s Close~s~'):format(Config.MenuControlLabel or 'E', Config.Command), 0.29)
end

local function openEntityMenu(info)
    if not info or not DoesEntityExist(info.entity) then
        notify('No valid entity is currently targeted.', 'error')
        return
    end

    local coords = ('vector3(%.4f, %.4f, %.4f)'):format(info.coords.x, info.coords.y, info.coords.z)
    local rotation = ('vector3(%.4f, %.4f, %.4f)'):format(info.rotation.x, info.rotation.y, info.rotation.z)
    local heading = ('%.4f'):format(info.heading or 0.0)

    lib.registerContext({
        id = 'hf1_propdev_entity_menu',
        title = ('HF1 Prop Dev — %s'):format(info.modelName),
        options = {
            {
                title = 'Copy Prop / Model Name',
                description = info.modelName,
                icon = 'copy',
                onSelect = function() copyValue('Prop name', info.modelName) end
            },
            {
                title = 'Copy Model Hash (Decimal)',
                description = tostring(info.modelHash),
                icon = 'hashtag',
                onSelect = function() copyValue('Model hash', info.modelHash) end
            },
            {
                title = 'Copy Model Hash (Hex)',
                description = info.modelHashHex,
                icon = 'code',
                onSelect = function() copyValue('Hex model hash', info.modelHashHex) end
            },
            {
                title = 'Copy Entity Handle',
                description = tostring(info.entity),
                icon = 'fingerprint',
                onSelect = function() copyValue('Entity handle', info.entity) end
            },
            {
                title = 'Copy Coordinates',
                description = coords,
                icon = 'location-dot',
                onSelect = function() copyValue('Coordinates', coords) end
            },
            {
                title = 'Copy Rotation',
                description = rotation,
                icon = 'rotate',
                onSelect = function() copyValue('Rotation', rotation) end
            },
            {
                title = 'Copy Heading',
                description = heading,
                icon = 'compass',
                onSelect = function() copyValue('Heading', heading) end
            },
            {
                title = 'Copy Network ID',
                description = info.networked and tostring(info.netId) or 'Entity is not networked',
                icon = 'network-wired',
                disabled = not info.networked,
                onSelect = function() copyValue('Network ID', info.netId) end
            },
            {
                title = 'Copy Lua Object Snippet',
                description = 'Model + coords + heading',
                icon = 'file-code',
                onSelect = function()
                    local snippet = ("{ model = '%s', hash = %s, coords = %s, heading = %s }"):format(
                        info.modelName, info.modelHash, coords, heading
                    )
                    copyValue('Lua object snippet', snippet)
                end
            }
        }
    })

    lib.showContext('hf1_propdev_entity_menu')
end

local function printEntityInfo(info)
    print('^3========== HF1 PROP DEV ==========^7')
    print(('Type: %s'):format(info.typeName))
    print(('Model name: %s'):format(info.modelName))
    print(('Model hash: %s (%s)'):format(info.modelHash, info.modelHashHex))
    print(('Entity handle: %s'):format(info.entity))
    print(('Coords: vector3(%.4f, %.4f, %.4f)'):format(info.coords.x, info.coords.y, info.coords.z))
    print(('Rotation: vector3(%.4f, %.4f, %.4f)'):format(info.rotation.x, info.rotation.y, info.rotation.z))
    print(('Networked: %s | Net ID: %s | Owner: %s'):format(tostring(info.networked), info.netId, info.owner))
    print('^3==============================^7')
end

RegisterNetEvent('hf1_propdev:client:setAuthorization', function(value)
    authorized = value == true
    if not authorized then
        enabled = false
        lastValidInfo = nil
        lastValidAt = 0
        lastEntity = 0
    end
end)

RegisterNetEvent('hf1_propdev:client:denied', function()
    enabled = false
    notify('You are not authorized to use /' .. Config.Command .. '.')
end)

RegisterNetEvent('hf1_propdev:client:toggle', function()
    authorized = true
    enabled = not enabled
    lastEntity = 0
    lastValidInfo = nil
    lastValidAt = 0
    notify(enabled and 'Prop developer enabled.' or 'Prop developer disabled.')
end)

-- Entity acquisition runs independently from drawing. Shape tests are asynchronous and
-- may need to yield for several frames; doing that inside the render loop is what made
-- the laser and panel flicker/spin on streamed MLO props.
CreateThread(function()
    Wait(500)
    TriggerServerEvent('hf1_propdev:server:requestAuthorization')

    while true do
        if not enabled or not authorized then
            Wait(250)
        else
            local hit, _, _, entity = raycastFromCamera(Config.MaxDistance or 50.0)

            if hit and entity ~= 0 and DoesEntityExist(entity) then
                local info = buildEntityInfo(entity)
                if info then
                    -- Latch the selection. A miss does NOT clear it. The panel changes
                    -- only after another valid entity has positively been identified.
                    if not lastValidInfo or info.entity ~= lastValidInfo.entity or info.modelHash ~= lastValidInfo.modelHash then
                        lastValidInfo = info
                        lastEntity = info.entity
                        printEntityInfo(info)
                    end
                end
            end

            Wait(Config.ScanIntervalMs or 35)
        end
    end
end)

-- Pure render/input loop. Never waits for a shape test. The crosshair is HUD-space
-- and the invisible centre-camera ray used for detection remains unchanged.
CreateThread(function()
    while true do
        if not enabled or not authorized then
            Wait(250)
        else
            Wait(0)

            -- HUD-space aim marker. It is drawn every rendered frame and cannot be
            -- occluded by world geometry or disappear when the camera stops moving.
            drawPropDevCrosshair()

            if lastValidInfo then
                drawPanel(lastValidInfo)

                if IsControlJustReleased(0, Config.MenuControl or 38) and not lib.getOpenContextMenu() then
                    openEntityMenu(lastValidInfo)
                end
            else
                drawText2D(0.015, 0.32, '~b~HF1 PROP DEV~s~  Aim at a prop/entity...', 0.34)
            end

            if Config.ShowHelpText then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName(('Aim at entity  |  [%s] Copy menu  |  /%s Toggle  |  New targets print to F8'):format(Config.MenuControlLabel or 'E', Config.Command))
                EndTextCommandDisplayHelp(0, false, false, -1)
            end
        end
    end
end)
