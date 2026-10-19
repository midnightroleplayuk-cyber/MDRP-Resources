local debugMode

-- Function to convert rotation to direction
local rotationToDirection = function(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

-- Function to cast ray from gameplay camera
local rayCastGamePlayCamera = function(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = rotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
    return b, c, e
end

-- Function to delete entity as admin
local adminDeleteEntity = function(entity)
    if not DoesEntityExist(entity) then return end
    if IsEntityAPed(entity) and IsPedAPlayer(entity) then
        TriggerEvent('apex_adminmenu:notify', Strings.cant_delete, Strings.cant_delete_player_desc, 'error')
        return
    end
    local netId = NetworkGetNetworkIdFromEntity(entity)
    local entCheck = NetworkGetEntityFromNetworkId(netId)
    if entCheck == 0 then
        TriggerEvent("apex_adminmenu:notify", Strings.cant_delete, Strings.cant_delete_entity_desc, 'error')
        return
    end
    TriggerServerEvent('apex_adminmenu:deleteEntity', netId)
    TriggerEvent('apex_adminmenu:notify', Strings.entity_deleted, Strings.entity_deleted_desc, 'success')
end

-- Function to round number to decimal places
local roundInt = function(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Function to start debug mode thread
local startDebugModeThread = function()
    CreateThread(function()
        local outLined
        local lastNotifyTime = 0
        local lastEntityHash = nil
        
        while true do
            if debugMode then
                local position = GetEntityCoords(cache.ped)
                local hit, coords, entity = rayCastGamePlayCamera(1000.0)
                if hit then
                    DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
                    DrawMarker(28, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.135, 0.25, 0.25, 255, 0,0, 50, false, true, 2, true, false, false, false)
                    if entity then
                        if DoesEntityExist(entity) then    
                            local eCoords = GetEntityCoords(entity)
                            if eCoords ~= vector3(0.0,0.0,0.0) then
                                local modelHash = GetEntityModel(entity)
                                local heading = GetEntityHeading(entity)
                                local entOwner = NetworkGetEntityOwner(entity)
                                local playerName = GetPlayerName(entOwner)
                                
                                -- Only show notification if entity changed or enough time has passed
                                local currentTime = GetGameTimer()
                                if modelHash ~= lastEntityHash or (currentTime - lastNotifyTime) > 2000 then
                                    lastEntityHash = modelHash
                                    lastNotifyTime = currentTime
                                    
                                    -- -- Display entity info as notification
                                    -- if entOwner and playerName then
                                    --     local infoText = ("Press [E] to delete entity\nHash: %s\nCoords: vec3(%s, %s, %s)\nHeading: %s\nOwner: [%s] - %s"):format(
                                    --         modelHash, roundInt(eCoords.x, 2), roundInt(eCoords.y, 2), roundInt(eCoords.z, 2), 
                                    --         roundInt(heading, 2), GetPlayerServerId(entOwner), playerName
                                    --     )
                                    --     TriggerEvent('apex_adminmenu:notify', 'Debug Mode', infoText, 'info')
                                    -- else
                                    --     local infoText = ("Press [E] to delete entity\nHash: %s\nCoords: vec3(%s, %s, %s)\nHeading: %s\nOwner: UNKNOWN"):format(
                                    --         modelHash, roundInt(eCoords.x, 2), roundInt(eCoords.y, 2), roundInt(eCoords.z, 2), roundInt(heading, 2)
                                    --     )
                                    --     TriggerEvent('apex_adminmenu:notify', 'Debug Mode', infoText, 'info')
                                    -- end
                                end
                                
                                if not outLined and not IsEntityAPed(entity) then
                                    outLined = entity
                                    SetEntityDrawOutline(outLined, true)
                                    SetEntityDrawOutlineColor(255, 0, 0, 255)
                                end
                                if IsControlJustReleased(0, 38) then
                                    adminDeleteEntity(entity)
                                end
                            else
                                if outLined then
                                    SetEntityDrawOutline(outLined, false)
                                    outLined = nil
                                end
                            end
                        else
                            if outLined then
                                SetEntityDrawOutline(outLined, false)
                                outLined = nil
                            end
                        end
                    end
                else
                    if outLined then
                        SetEntityDrawOutline(outLined, false)
                        outLined = nil
                    end
                end
            else
                if outLined then
                    SetEntityDrawOutline(outLined, false)
                    outLined = nil
                end
                break
            end
            Wait(0)
        end
    end)
end

-- Function to toggle debug mode
toggleDebugMode = function(enabled)
    if enabled and debugMode then return end
    debugMode = enabled
    if enabled then
        TriggerEvent('apex_adminmenu:notify', Strings.debug_activated, Strings.debug_activated, 'success')
        startDebugModeThread()
    else
        TriggerEvent('apex_adminmenu:notify', Strings.debug_deactivated, Strings.debug_deactivated, 'error')
    end
end

-- Function to copy vector3 coordinates
local copyVec3 = function()
    local coords = GetEntityCoords(cache.ped)
    lib.setClipboard('vector3('..roundInt(coords.x, 2)..', '..roundInt(coords.y, 2)..', '..roundInt(coords.z, 2)..')')
    TriggerEvent('apex_adminmenu:notify', Strings.notify_copied, Strings.notify_copied_vec3, 'success', 'copy')
end

-- Function to copy vector4 coordinates
local copyVec4 = function()
    local coords, heading = GetEntityCoords(cache.ped), GetEntityHeading(cache.ped)
    lib.setClipboard('vector4('..roundInt(coords.x, 2)..', '..roundInt(coords.y, 2)..', '..roundInt(coords.z, 2).. ', ' .. roundInt(heading, 2).. ')')
    TriggerEvent('apex_adminmenu:notify', Strings.notify_copied, Strings.notify_copied_vec4, 'success', 'copy')
end

-- Function to copy heading
local copyHeading = function()
    local heading = GetEntityHeading(cache.ped)
    lib.setClipboard(roundInt(heading, 2))
    TriggerEvent('apex_adminmenu:notify', Strings.notify_copied, Strings.notify_copied_headin, 'success', 'copy')
end

-- Developer options menu
DeveloperOptions = function()
    local options = {
        {
            icon = 'fas fa-bug-slash',
            label = Strings.debug_mode,
            description = Strings.debug_mode_desc,
            checked = debugMode or false
        },
        {
            icon = 'fas fa-copy',
            label = Strings.copy_vec3,
            description = Strings.copy_vec3_desc,
            close = false
        },
        {
            icon = 'fas fa-copy',
            label = Strings.copy_vec4,
            description = Strings.copy_vec4_desc,
            close = false
        },
        {
            icon = 'fas fa-compass',
            label = Strings.copy_heading,
            description = Strings.copy_heading_desc,
            close = false
        }
    }
    
    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.developer_options,
        items = options,
        parent = 'main'
    })
    
    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.developer_options then
            if data.index == 1 then
                copyVec3()
            elseif data.index == 2 then
                copyVec4()
            elseif data.index == 3 then
                copyHeading()
            end
        end
        cb('ok')
    end)
end
