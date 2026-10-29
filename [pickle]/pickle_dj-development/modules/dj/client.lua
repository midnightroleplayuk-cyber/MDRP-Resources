local DJStations = {}
local LocalDJStations = {}
local stationControls = {}
local DJ_CAMERA = nil

function CreateDJCamera()
    local initialCamSettings = {
        coords = GetGameplayCamCoord(),
        rotation = GetGameplayCamRot(),
        fov = GetGameplayCamFov(),
    }
    DJ_CAMERA = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 
        initialCamSettings.coords.x, initialCamSettings.coords.y, initialCamSettings.coords.z, 
        initialCamSettings.rotation.x, initialCamSettings.rotation.y, initialCamSettings.rotation.z, initialCamSettings.fov
    )
    SetCamActive(DJ_CAMERA, true)
    RenderScriptCams(true, false, 0, true, true)
end

function ExitDJCamera(durationValue)
    local duration = durationValue
    if duration == nil then duration = 2000 end
    ClearFocus()
	DestroyAllCams()
    RenderScriptCams(false, true, duration, true, false) 
end

function UnregisterDJStation(id)
    if LocalDJStations[id] then
        DeleteInteraction(LocalDJStations[id].interact)
        DeleteScriptObject(LocalDJStations[id].entity)
        if LocalDJStations[id].speakerEntities then
            for _, ent in ipairs(LocalDJStations[id].speakerEntities) do
                DeleteScriptObject(ent)
            end
        end
        -- Clean up entity data entities
        if LocalDJStations[id].entityData then
            for _, speakerData in ipairs(LocalDJStations[id].entityData.speakers or {}) do
                if speakerData.entity and DoesEntityExist(speakerData.entity) then
                    DeleteScriptObject(speakerData.entity)
                end
            end
            for _, lightData in ipairs(LocalDJStations[id].entityData.lights or {}) do
                if lightData.entity and DoesEntityExist(lightData.entity) then
                    DeleteScriptObject(lightData.entity)
                    DeleteScriptObject(lightData.attEnt)
                end
            end
            for _, smokeMachineData in ipairs(LocalDJStations[id].entityData.smokemachines or {}) do
                if smokeMachineData.entity and DoesEntityExist(smokeMachineData.entity) then
                    DeleteScriptObject(smokeMachineData.entity)
                end
            end
        end
    end
    LocalDJStations[id] = nil
    -- Don't clear DJStations[id] here - it's needed for re-registration
end

-- Handle station removal from server
RegisterNetEvent('pickle_dj:removeStation', function(stationId)
    UnregisterDJStation(stationId)
    -- Clear station data after unregistering
    DJStations[stationId] = nil
    
    -- If viewing entities for this station, stop viewing
    if viewingStationId == stationId then
        viewingEntities = false
        viewingStationId = nil
    end
    
    ShowNotification(_L("dj_station_removed_info"), "info")
end)

-- Render all props for a DJ station (main prop, speakers, lights)
local function RenderDJStationProps(id)
    local station = DJStations[id]
    if not station or not LocalDJStations[id] then return end
    
    -- If already rendered, skip
    if LocalDJStations[id].entity and DoesEntityExist(LocalDJStations[id].entity) then
        return
    end
    
    -- Create main prop
    LocalDJStations[id].entity = CreateProp(station.prop, station.coords.x, station.coords.y, station.coords.z, false, true, false)
    SetEntityRotation(LocalDJStations[id].entity, 0.0, 0.0, station.heading, 2, true)
    FreezeEntityPosition(LocalDJStations[id].entity, true)
    
    -- If prop is tennis ball (invisible placeholder), make it invisible and non-colliding
    local tennisBallHash = GetHashKey("prop_tennis_ball")
    if station.prop == tennisBallHash then
        SetEntityAlpha(LocalDJStations[id].entity, 0, false) -- Make invisible
        SetEntityCollision(LocalDJStations[id].entity, false, false) -- Disable collision
    end
    
    -- Initialize entity storage if not already done
    if not LocalDJStations[id].entityData then
        LocalDJStations[id].entityData = {
            speakers = {},
            lights = {},
            smokemachines = {},
            other = {}
        }
    end
    
    -- Clear existing speaker entities list
    LocalDJStations[id].speakerEntities = {}
    
    -- Spawn configured speakers for this station (visuals only)
    if station.speakers and type(station.speakers) == "table" then
        for i, sp in ipairs(station.speakers) do
            -- Find or create speaker data entry
            local speakerData = nil
            if LocalDJStations[id].entityData.speakers[i] then
                speakerData = LocalDJStations[id].entityData.speakers[i]
            else
                speakerData = { entity = nil, dbId = sp.id, data = sp }
                table.insert(LocalDJStations[id].entityData.speakers, speakerData)
            end
            
            -- Only create entity if it doesn't exist
            if not speakerData.entity or not DoesEntityExist(speakerData.entity) then
                local spec = (Config.SpeakerProps and sp.speakerType and Config.SpeakerProps[sp.speakerType]) or nil
                local model = (spec and spec.model) or (sp.model or `prop_speaker_06`)
                local offset = (spec and spec.soundOffset) or vector3(0.0, 0.0, 0.0)
                local sc = sp.coords or station.coords
                local pos = vector3(sc.x + offset.x, sc.y + offset.y, sc.z + offset.z)
                local ent = CreateProp(model, pos.x, pos.y, pos.z, false, true, false)
                local h = sp.heading or (spec and spec.heading) or station.heading or 0.0
                local rot = spec and spec.rotation or vector3(0.0, 0.0, 0.0)
                SetEntityRotation(ent, rot.x, rot.y, h + rot.z, 2, true)
                FreezeEntityPosition(ent, true)
                speakerData.entity = ent
                table.insert(LocalDJStations[id].speakerEntities, ent)
            end
        end
    end
    
    -- Spawn configured lights for this station
    if station.lights and type(station.lights) == "table" then
        for i, light in ipairs(station.lights) do
            -- Find or create light data entry
            local lightData = nil
                lightData = LocalDJStations[id].entityData.lights[i]
            -- Only create entity if it doesn't exist
            if not lightData.entity or not DoesEntityExist(lightData.entity) then
                local spec = (Config.LightTypes and light.data.lightType and Config.LightTypes[light.data.lightType]) or nil
                local model = (spec and spec.model) or (light.model or `stg_blinder`)
                local ent = CreateProp(model, light.coords.x, light.coords.y, light.coords.z, false, true, false)
                local attEnt = CreateProp(model, light.coords.x, light.coords.y, light.coords.z, false, true, false)
                SetEntityCoordsNoOffset(ent, light.coords.x, light.coords.y, light.coords.z, 0.0, 0.0, 0.0)
                local rot = spec and spec.rotation or vector3(0.0, 0.0, 0.0)
                SetEntityCollision(ent, false, false)
                SetEntityRotation(ent, rot.x, rot.y, light.heading + rot.z, 2, true)
                FreezeEntityPosition(ent, true)
                AttachEntityToEntity(attEnt, ent, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                lightData.entity = ent
                lightData.attEnt = attEnt
                lightData.heading = light.heading + rot.z
                SetObjectLightColor(ent, 1, lightData.color[1], lightData.color[2], lightData.color[3])
                SetObjectLightColor(attEnt, 1, 0, 0, 0)
            end
        end
    end
    
    -- Spawn configured smoke machines for this station
    if station.smokemachines and type(station.smokemachines) == "table" then
        for i, smokeMachine in ipairs(station.smokemachines) do
            -- Find or create smoke machine data entry
            local smokeMachineData = nil
            if LocalDJStations[id].entityData.smokemachines[i] then
                smokeMachineData = LocalDJStations[id].entityData.smokemachines[i]
            else
                smokeMachineData = {
                    entity = nil,
                    dbId = smokeMachine.id,
                    data = smokeMachine
                }
                table.insert(LocalDJStations[id].entityData.smokemachines, smokeMachineData)
            end
            
            -- Only create entity if it doesn't exist
            if not smokeMachineData.entity or not DoesEntityExist(smokeMachineData.entity) then
                local model = smokeMachine.model or `ba_prop_club_smoke_machine`
                local ent = CreateProp(model, smokeMachine.coords.x, smokeMachine.coords.y, smokeMachine.coords.z, false, true, false)
                SetEntityCoordsNoOffset(ent, smokeMachine.coords.x, smokeMachine.coords.y, smokeMachine.coords.z, 0.0, 0.0, 0.0)
                SetEntityCollision(ent, false, false)
                SetEntityRotation(ent, 0.0, 0.0, smokeMachine.heading, 2, true)
                FreezeEntityPosition(ent, true)
                smokeMachineData.entity = ent
            end
        end
    end
end

-- Unrender all props for a DJ station (but keep station data)
local function UnrenderDJStationProps(id)
    if not LocalDJStations[id] then return end
    
    -- Delete main prop
    if LocalDJStations[id].entity and DoesEntityExist(LocalDJStations[id].entity) then
        DeleteScriptObject(LocalDJStations[id].entity)
        LocalDJStations[id].entity = nil
    end
    
    -- Delete speaker entities
    if LocalDJStations[id].speakerEntities then
        for _, ent in ipairs(LocalDJStations[id].speakerEntities) do
            if DoesEntityExist(ent) then
                DeleteScriptObject(ent)
            end
        end
        LocalDJStations[id].speakerEntities = {}
    end
    
    -- Delete entity data entities (speakers and lights)
    if LocalDJStations[id].entityData then
        for _, speakerData in ipairs(LocalDJStations[id].entityData.speakers or {}) do
            if speakerData.entity and DoesEntityExist(speakerData.entity) then
                DeleteScriptObject(speakerData.entity)
                speakerData.entity = nil
            end
        end
        for _, lightData in ipairs(LocalDJStations[id].entityData.lights or {}) do
            if lightData.entity and DoesEntityExist(lightData.entity) then
                DeleteScriptObject(lightData.entity)
                DeleteScriptObject(lightData.attEnt)
                lightData.entity = nil
                lightData.attEnt = nil
            end
        end
        for _, smokeMachineData in ipairs(LocalDJStations[id].entityData.smokemachines or {}) do
            if smokeMachineData.entity and DoesEntityExist(smokeMachineData.entity) then
                DeleteScriptObject(smokeMachineData.entity)
                smokeMachineData.entity = nil
            end
        end
    end
end

function RegisterDJStation(id)
    if LocalDJStations[id] then UnregisterDJStation(id) end
	local station = DJStations[id]
	if not station then return end
	LocalDJStations[id] = {
		interact = CreateInteraction({
            icon = Config.TargetIcons.dj,
			label = station.name,
			coords = station.coords,
			heading = station.heading,
            zOffset = station.prop == GetHashKey("prop_tennis_ball") and 0.0 or -1.0
		}, function(selection, targetData)
            -- Check if player can access this station before showing menu
            lib.callback('pickle_dj:canAccessStationInteraction', false, function(canAccess, canManage, errorMessage)
                if not canAccess then
                    if errorMessage then
                        ShowNotification(errorMessage, "error")
                    else
                        ShowNotification(_L("dj_no_access_station"), "error")
                    end
                    return
                end
                local options =  {
                    { 
                        title = _L("dj_open_controller_title"), 
                        description = _L("dj_open_controller_description"),
                        icon = 'music',
                        onSelect = function()
                            -- Check if player can access the controller before opening UI
                            lib.callback('pickle_dj:canAccessController', false, function(canAccess, errorMessage)
                                -- Store id in a local variable for use in the callback
                                local stationId = id
                                local station = DJStations[id]
                                if not canAccess then
                                    if errorMessage then
                                        ShowNotification(errorMessage, "error")
                                    else
                                        ShowNotification(_L("dj_cannot_access_controller"), "error")
                                    end
                                    return
                                end
                                
                                -- Access granted, proceed with opening UI
                            SetMusicController(station.streamId)
                            CreateThread(function()
                                -- Ensure props are rendered before opening controller
                                if not LocalDJStations[id].entity or not DoesEntityExist(LocalDJStations[id].entity) then
                                    RenderDJStationProps(id)
                                    Wait(100) -- Give props time to spawn
                                end
                                local coords = GetEntityCoords(LocalDJStations[id].entity) + vector3(0.0, 0.0, 2.0)
                                coords = coords + GetEntityForwardVector(LocalDJStations[id].entity) * 1.0
                                SetNuiFocus(true, true)
                                CreateDJCamera()
                                SetCamParams(DJ_CAMERA, coords.x, coords.y, coords.z + (station.prop == GetHashKey("prop_tennis_ball") and -1.0 or 0.0),
                                    -30.0, 0.0, station.heading + 180.0, 90.0, 
                                    2000, 0, 0, 2
                                )
                                PlayAnim(PlayerPedId(), "anim@amb@nightclub@djs@dixon@", "dixn_idle_cntr_b_dix", 1.0, -1.0, -1, 1, 1.0, false, false, false)
                                end)
                                
                                -- Light controls are now part of station data, so they're already available
                                -- Send current light controls state to NUI
                                debugPrint("^2[DJ Controller]^0 ===== OPENING CONTROLLER =====")
                                debugPrint("^2[DJ Controller]^0 Station ID: " .. tostring(id))
                                debugPrint("^2[DJ Controller]^0 stationControls[" .. tostring(id) .. "] exists: " .. tostring(stationControls[id] ~= nil))
                                
                                -- Debug: Check all station IDs in stationControls
                                local stationIds = {}
                                for sid, _ in pairs(stationControls) do
                                    table.insert(stationIds, tostring(sid))
                                end
                                debugPrint("^2[DJ Controller]^0 Available station IDs in stationControls: " .. table.concat(stationIds, ", "))
                                
                                if stationControls[id] then
                                    debugPrint("^2[DJ Controller]^0 stationControls[" .. tostring(id) .. "].lights exists: " .. tostring(stationControls[id].lights ~= nil))
                                    local uiControls = {}
                                    uiControls.speed = GetSpeedString(stationControls[id].speed or 2.0)
                                    if stationControls[id].lights then
                                        uiControls.lights = {}
                                        for lightType, lightControl in pairs(stationControls[id].lights) do
                                            -- Ensure colors are properly formatted as arrays
                                            local primaryColor = lightControl.primaryColor
                                            local secondaryColor = lightControl.secondaryColor
                                            
                                            -- Debug: Check what we're getting
                                            debugPrint("^2[DJ Controller]^0 Light type: " .. tostring(lightType))
                                            if primaryColor then
                                                debugPrint("^2[DJ Controller]^0 primaryColor type: " .. type(primaryColor) .. ", value: [" .. tostring(primaryColor[1] or "nil") .. ", " .. tostring(primaryColor[2] or "nil") .. ", " .. tostring(primaryColor[3] or "nil") .. "]")
                                            else
                                                debugPrint("^2[DJ Controller]^0 primaryColor is nil")
                                            end
                                            if secondaryColor then
                                                debugPrint("^2[DJ Controller]^0 secondaryColor type: " .. type(secondaryColor) .. ", value: [" .. tostring(secondaryColor[1] or "nil") .. ", " .. tostring(secondaryColor[2] or "nil") .. ", " .. tostring(secondaryColor[3] or "nil") .. "]")
                                            else
                                                debugPrint("^2[DJ Controller]^0 secondaryColor is nil")
                                            end
                                            
                                            -- Validate and normalize primary color
                                            if primaryColor and type(primaryColor) == "table" then
                                                -- Check if it's a proper array with 3 elements (use rawget to handle 0 values)
                                                local r, g, b = primaryColor[1], primaryColor[2], primaryColor[3]
                                                if r ~= nil and g ~= nil and b ~= nil then
                                                    primaryColor = {r, g, b}
                                                else
                                                    primaryColor = nil -- Invalid, will use default
                                                end
                                            else
                                                primaryColor = nil -- Invalid, will use default
                                            end
                                            
                                            -- Use defaults if validation failed
                                            if not primaryColor then
                                                if lightType == "ambient" then
                                                    primaryColor = {255, 0, 0} -- red
                                                elseif lightType == "spotlight" then
                                                    primaryColor = {0, 255, 0} -- green
                                                elseif lightType == "barlight" then
                                                    primaryColor = {0, 0, 255} -- blue
                                                else
                                                    primaryColor = {255, 0, 0} -- default red
                                                end
                                            end
                                            
                                            -- Validate and normalize secondary color
                                            if secondaryColor and type(secondaryColor) == "table" then
                                                -- Check if it's a proper array with 3 elements (use rawget to handle 0 values)
                                                local r, g, b = secondaryColor[1], secondaryColor[2], secondaryColor[3]
                                                if r ~= nil and g ~= nil and b ~= nil then
                                                    secondaryColor = {r, g, b}
                                                else
                                                    secondaryColor = nil -- Invalid, will use default
                                                end
                                            else
                                                secondaryColor = nil -- Invalid, will use default
                                            end
                                            
                                            -- Use defaults if validation failed
                                            if not secondaryColor then
                                                if lightType == "ambient" then
                                                    secondaryColor = {255, 100, 0} -- orange
                                                elseif lightType == "spotlight" then
                                                    secondaryColor = {0, 200, 255} -- cyan
                                                elseif lightType == "barlight" then
                                                    secondaryColor = {255, 0, 255} -- magenta
                                                else
                                                    secondaryColor = {255, 100, 0} -- default orange
                                                end
                                            end
                                            
                                            debugPrint("^2[DJ Controller]^0 Final colors for " .. lightType .. " - primary: [" .. primaryColor[1] .. ", " .. primaryColor[2] .. ", " .. primaryColor[3] .. "], secondary: [" .. secondaryColor[1] .. ", " .. secondaryColor[2] .. ", " .. secondaryColor[3] .. "]")
                                            
                                            -- Ensure colors are always arrays (defensive check)
                                            local finalPrimaryColor = primaryColor
                                            local finalSecondaryColor = secondaryColor
                                            if not finalPrimaryColor or type(finalPrimaryColor) ~= "table" or #finalPrimaryColor ~= 3 then
                                                debugPrint("^1[DJ Controller]^0 ERROR: primaryColor invalid for " .. lightType .. ", using default")
                                                if lightType == "ambient" then
                                                    finalPrimaryColor = {255, 0, 0}
                                                elseif lightType == "spotlight" then
                                                    finalPrimaryColor = {0, 255, 0}
                                                elseif lightType == "barlight" then
                                                    finalPrimaryColor = {0, 0, 255}
                                                else
                                                    finalPrimaryColor = {255, 0, 0}
                                                end
                                            end
                                            if not finalSecondaryColor or type(finalSecondaryColor) ~= "table" or #finalSecondaryColor ~= 3 then
                                                debugPrint("^1[DJ Controller]^0 ERROR: secondaryColor invalid for " .. lightType .. ", using default")
                                                if lightType == "ambient" then
                                                    finalSecondaryColor = {255, 100, 0}
                                                elseif lightType == "spotlight" then
                                                    finalSecondaryColor = {0, 200, 255}
                                                elseif lightType == "barlight" then
                                                    finalSecondaryColor = {255, 0, 255}
                                                else
                                                    finalSecondaryColor = {255, 100, 0}
                                                end
                                            end
                                            
                                            debugPrint("^2[DJ Controller]^0 Sending to NUI for " .. lightType .. " - primaryColor: [" .. finalPrimaryColor[1] .. ", " .. finalPrimaryColor[2] .. ", " .. finalPrimaryColor[3] .. "], secondaryColor: [" .. finalSecondaryColor[1] .. ", " .. finalSecondaryColor[2] .. ", " .. finalSecondaryColor[3] .. "]")
                                            
                                            uiControls.lights[lightType] = {
                                                enabled = (lightControl.enabled ~= false),
                                                rotateHorizontal = (lightControl.rotateHorizontal == true),
                                                rotateVertical = (lightControl.rotateVertical == true),
                                                flash = GetFlashString(lightControl.flash) or "off",
                                                speed = GetSpeedString(lightControl.speed or 2.0),
                                                primaryColor = finalPrimaryColor,
                                                secondaryColor = finalSecondaryColor
                                            }
                                        end
                                    else
                                        debugPrint("^1[DJ Controller]^0 WARNING: stationControls[" .. tostring(id) .. "].lights is nil!")
                                    end
                                    debugPrint("^2[DJ Controller]^0 Sending light controls to NUI...")
                                    -- Send setControllerVisible FIRST to set currentStationId, then send light controls
                                SendNUIMessage({
                                    type = 'music:setControllerVisible',
                                    visible = true,
                                    stationId = id,
                                    streamId = station.streamId
                                })
                                    -- Use a small delay to ensure React has processed setControllerVisible and updated currentStationId
                                    -- We use CreateThread with Wait instead of Wait(0) since we're in a callback
                                    CreateThread(function()
                                        Wait(50) -- Small delay to let React process the state update
                                        SendNUIMessage({
                                            type = 'music:lightControlsState',
                                            data = {
                                                stationId = id,
                                                controls = uiControls
                                            }
                                        })
                                        debugPrint("^2[DJ Controller]^0 Light controls sent to NUI (delayed)")
                                    end)
                                    debugPrint("^2[DJ Controller]^0 Light controls queued to send")
                                else
                                    debugPrint("^1[DJ Controller]^0 WARNING: stationControls[" .. tostring(id) .. "] is nil! Light controls not available.")
                                end
                                
                                -- Request particle effects state
                                TriggerServerEvent('pickle_dj:requestParticleEffects', id)
                                -- Notify server that player is opening controller (will auto-assign as broadcaster)
                                TriggerServerEvent('pickle_dj:openController', id)
                            end, id)
                        end
                    },
                }
                if canManage then
                    table.insert(options, { 
                        title = _L("dj_manage_objects_title"), 
                        description = _L("dj_manage_objects_description"),
                        icon = 'cog',
                        onSelect = function()
                            OpenEntityManagementMenu(id)
                        end
                    })
                    table.insert(options, {
                        title = _L("dj_manage_whitelist_title"),
                        description = _L("dj_manage_whitelist_description"),
                        icon = 'user-check',
                        onSelect = function()
                            OpenWhitelistMenu(id)
                        end
                    })
                    table.insert(options, {
                        title = _L("dj_remove_station_title"),
                        description = _L("dj_remove_station_description"),
                        icon = 'trash',
                        onSelect = function()
                            -- Show confirmation dialog
                            local input = lib.inputDialog(_L("dj_remove_station_dialog_title"), {
                                {type = 'input', label = _L("dj_remove_station_confirm_label"), description = _L("dj_remove_station_confirm_description"), required = true, min = 1}
                            })
                            if input and input[1] and string.upper(input[1]) == "DELETE" then
                                TriggerServerEvent('pickle_dj:removeStation', id)
                            else
                                ShowNotification(_L("dj_station_removal_cancelled"), "info")
                            end
                        end
                    })
                end
                if #options == 1 then
                    options[1].onSelect()
                    return
                end
                lib.registerContext({
                    id = 'dj_station_' .. id,
                    title = station.name,
                    options = options
                })
                lib.showContext('dj_station_' .. id)
            end, id)

		end),
        entity = nil,
        speakerEntities = {},
	}
    -- Initialize entity storage (but don't create props yet - render distance thread will handle that)
    -- Preserve existing entities if they exist (for resource restarts)
    local existingLights = {}
    if LocalDJStations[id] and LocalDJStations[id].entityData and LocalDJStations[id].entityData.lights then
        -- Create a map of existing lights by dbId to preserve their entities
        for _, existingLight in ipairs(LocalDJStations[id].entityData.lights) do
            if existingLight.dbId and existingLight.entity and DoesEntityExist(existingLight.entity) then
                existingLights[existingLight.dbId] = existingLight
            end
        end
    end
    
    LocalDJStations[id].entityData = {
        speakers = {},
        lights = {},
        smokemachines = {},
        other = {}
    }
    
    -- Store speaker and light data for later rendering
    if station.speakers and type(station.speakers) == "table" then
        for _, sp in ipairs(station.speakers) do
            table.insert(LocalDJStations[id].entityData.speakers, {
                entity = nil, -- Will be created when rendered
                dbId = sp.id,
                data = sp
            })
        end
    end
    
    if station.lights and type(station.lights) == "table" then
        for _, light in ipairs(station.lights) do
            -- Get color from server controls if available, otherwise use defaults
            local defaultColors = {
                ambient = {255, 0, 0},
                spotlight = {0, 255, 0},
                barlight = {0, 0, 255}
            }
            local lightColor = defaultColors[light.data.lightType] or {255, 255, 255}
            
            -- Try to get color from server controls based on colorSpec (now available from station data)
            local controls = stationControls[id]
            if controls and controls.lights and controls.lights[light.data.lightType] then
                -- Check top-level colorSpec first (new format), then nested (old format)
                local colorSpec = light.colorSpec or (light.data and light.data.colorSpec) or "primary"
                if colorSpec == "secondary" and controls.lights[light.data.lightType].secondaryColor then
                    lightColor = controls.lights[light.data.lightType].secondaryColor
                elseif controls.lights[light.data.lightType].primaryColor then
                    lightColor = controls.lights[light.data.lightType].primaryColor
                end
            end
            
            -- Preserve existing entity if it exists
            local existingLight = existingLights[light.id]
            local lightData = {
                entity = existingLight and existingLight.entity or nil, -- Preserve existing entity
                lightType = light.data.lightType,
                coords = light.coords,
                heading = light.heading,
                dbId = light.id,
                color = lightColor,
                data = light
            }
            
            -- If entity exists, update its color immediately
            if lightData.entity and DoesEntityExist(lightData.entity) then
                SetObjectLightColor(lightData.entity, 1, lightColor[1], lightColor[2], lightColor[3])
                -- Set flag to ensure render loop processes it
                if not updateLightColor[id] then updateLightColor[id] = {} end
                updateLightColor[id][light.data.lightType] = true
            end
            
            table.insert(LocalDJStations[id].entityData.lights, lightData)
        end
    end
    
    -- Store smoke machine data for later rendering
    if station.smokemachines and type(station.smokemachines) == "table" then
        for _, smokeMachine in ipairs(station.smokemachines) do
            table.insert(LocalDJStations[id].entityData.smokemachines, {
                entity = nil, -- Will be created when rendered
                dbId = smokeMachine.id,
                data = smokeMachine
            })
        end
    end
    
    -- Check if we're in range and render if so
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - station.coords)
    if distance <= Config.RenderDistance then
        RenderDJStationProps(id)
    end
    
    return station
end

-- Per-station light controls (stationId -> controls)
-- flash: 0 = off, 1 = high (every tick), 2 = low (every 2 ticks)
-- Controls are ONLY set from server, never initialized locally
-- Note: stationControls is declared at the top of the file (line 3)

-- Per-station particle effects (stationId -> effects)
-- Effects are ONLY set from server, never initialized locally
local stationParticleEffects = {}

-- Track which light types need color updates (per station, per light type)
local updateLightColor = {}

-- Render distance thread - manages prop rendering based on distance
CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local renderDistance = Config.RenderDistance or 100.0
        
        for id, station in pairs(DJStations) do
            if not station or not station.coords then goto continue_station end
            
            local distance = #(playerCoords - station.coords)
            local isRendered = LocalDJStations[id] and LocalDJStations[id].entity and DoesEntityExist(LocalDJStations[id].entity)
            
            if distance <= renderDistance then
                -- In range - render if not already rendered
                if not isRendered then
                    RenderDJStationProps(id)
                end
            else
                -- Out of range - unrender if currently rendered
                if isRendered then
                    UnrenderDJStationProps(id)
                end
            end
            
            ::continue_station::
        end
    end
end)

CreateThread(function()
    local maxRot = 90.0
    local maxHz = 45.0
    local stationRot = {} -- per speed value, per station rotation state (lights with same speed share rotation)
    local stationDir = {} -- per speed value, per station direction
    local stationHDir = {} -- per speed value, per station horizontal direction
    local visibleLights = {} -- per station, per light type
    local flashGroupStates = {} -- per station, per flash value -> boolean state
    local ticks = 0
    while true do
        ticks = ticks + 1
        -- updateLightColor flags are set by event handlers and cleared after processing
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local renderDistance = Config.RenderDistance or 100.0
        local hasNearbyStations = false
        
        -- Process each station's controls separately
        for stationId, station in pairs(LocalDJStations) do
            -- Only process if we have controls from server
            local controls = stationControls[stationId]
            if not controls then goto continue_station end
            
            -- Check distance to station - skip if too far away
            local stationData = DJStations[stationId]
            if not stationData or not stationData.coords then goto continue_station end
            local distance = #(playerCoords - stationData.coords)
            if distance > renderDistance then goto continue_station end
            
            hasNearbyStations = true
            
            if not controls.lights then goto continue_station end
            
            -- Group lights by speed value to ensure synchronized rotation
            local speedGroups = {} -- speedValue -> {lightTypes}
            for lightType, lightControls in pairs(controls.lights) do
                if lightControls.enabled ~= false then
                    local lightSpeed = (lightControls.speed and lightControls.speed > 0) and lightControls.speed or 2.0
                    if not speedGroups[lightSpeed] then
                        speedGroups[lightSpeed] = {}
                    end
                    table.insert(speedGroups[lightSpeed], lightType)
                end
            end
            
            -- Update rotation for each speed group (lights with same speed share rotation state)
            for speedValue, lightTypes in pairs(speedGroups) do
                -- Initialize rotation state for this speed value at this station if not exists
                if not stationRot[speedValue] then
                    stationRot[speedValue] = {}
                end
                if not stationRot[speedValue][stationId] then
                    stationRot[speedValue][stationId] = 0.0
                    if not stationDir[speedValue] then stationDir[speedValue] = {} end
                    stationDir[speedValue][stationId] = 1
                    if not stationHDir[speedValue] then stationHDir[speedValue] = {} end
                    stationHDir[speedValue][stationId] = 1
                end
                
                -- Update rotation state for this speed group (all lights with this speed share the same rotation)
                if stationDir[speedValue][stationId] == 1 and stationRot[speedValue][stationId] >= maxRot then
                    stationDir[speedValue][stationId] = -1
                    stationHDir[speedValue][stationId] = -stationHDir[speedValue][stationId]
                elseif stationDir[speedValue][stationId] == -1 and stationRot[speedValue][stationId] < 0.0 then
                    stationDir[speedValue][stationId] = 1
                end
                stationRot[speedValue][stationId] = stationRot[speedValue][stationId] + speedValue * stationDir[speedValue][stationId]
            end
            
            if not visibleLights[stationId] then
                visibleLights[stationId] = {}
                for lightType, lightControls in pairs(controls.lights) do
                    visibleLights[stationId][lightType] = true
                end
            end
            
            if not flashGroupStates[stationId] then
                flashGroupStates[stationId] = {}
            end
            
            -- Group lights by flash value to ensure synchronized flashing
            local flashGroups = {} -- flashValue -> {lightTypes}
            for lightType, lightControls in pairs(controls.lights) do
                if lightControls.enabled ~= false and lightControls.flash > 0 then
                    local flashValue = lightControls.flash
                    if not flashGroups[flashValue] then
                        flashGroups[flashValue] = {}
                    end
                    table.insert(flashGroups[flashValue], lightType)
                    -- Initialize flash group state if not set
                    if flashGroupStates[stationId][flashValue] == nil then
                        flashGroupStates[stationId][flashValue] = true
                    end
                end
            end
            
            -- Check flash updates for this station - group by flash value for synchronization
            for flashValue, lightTypes in pairs(flashGroups) do
                if ticks % flashValue == 0 then
                    -- Toggle the state for this flash group (all lights with same flash value)
                    flashGroupStates[stationId][flashValue] = not flashGroupStates[stationId][flashValue]
                    -- Apply the same state to all lights in this group
                    if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                    for _, lightType in ipairs(lightTypes) do
                        local lightControls = controls.lights[lightType]
                        if lightControls and lightControls.enabled ~= false then
                            visibleLights[stationId][lightType] = flashGroupStates[stationId][flashValue]
                            updateLightColor[stationId][lightType] = true
                        end
                    end
                else
                    -- Ensure all lights in this group have the same state (sync check)
                    local groupState = flashGroupStates[stationId][flashValue]
                    if groupState ~= nil then
                        for _, lightType in ipairs(lightTypes) do
                            local lightControls = controls.lights[lightType]
                            if lightControls and lightControls.enabled ~= false then
                                if visibleLights[stationId][lightType] ~= groupState then
                                    if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                                    visibleLights[stationId][lightType] = groupState
                                    updateLightColor[stationId][lightType] = true
                                end
                            end
                        end
                    end
                end
            end
            
            -- Handle non-flashing lights (flash == 0) and disabled lights
            for lightType, lightControls in pairs(controls.lights) do
                if lightControls.enabled ~= false then
                    if lightControls.flash == 0 and not visibleLights[stationId][lightType] then
                        if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                        visibleLights[stationId][lightType] = true
                        updateLightColor[stationId][lightType] = true
                    end
                elseif visibleLights[stationId][lightType] then
                    if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                    visibleLights[stationId][lightType] = false
                    updateLightColor[stationId][lightType] = true
                end
            end
            
            -- Apply controls to lights for this station
            if not station.entityData or not station.entityData.lights then goto continue_station end
            for i=1, #station.entityData.lights do
                local light = station.entityData.lights[i]
                -- Skip if entity doesn't exist (not rendered)
                if not light.entity or not DoesEntityExist(light.entity) then goto continue end
                local lightControls = controls.lights[light.lightType]
                if not lightControls then goto continue end
                
                local tilt = 0.0
                local locHz = 0.0
                local locRot = 0.0
                
                if light.lightType == "spotlight" then
                    tilt = -20.0
                end
                
                -- Get speed for this light type to find its rotation group
                local lightSpeed = (lightControls.speed and lightControls.speed > 0) and lightControls.speed or 2.0
                
                -- Get rotation state for this speed group (lights with same speed share rotation)
                local rotState = stationRot[lightSpeed] and stationRot[lightSpeed][stationId] or 0.0
                local hDirState = stationHDir[lightSpeed] and stationHDir[lightSpeed][stationId] or 1
                
                if lightControls.rotateHorizontal then
                    local hz = (rotState / maxRot) * maxHz
                    if hDirState == 1 then
                        locHz = hz - maxHz
                    else
                        locHz = maxHz - hz
                    end
                end
                if lightControls.rotateVertical then
                    locRot = rotState
                end
                -- Update light color from server controls if available (based on colorSpec)
                -- Check top-level colorSpec first (new format), then nested (old format)
                local colorSpec = (light.data and light.data.colorSpec) or (light.data and light.data.data and light.data.data.colorSpec) or "primary"
                local colorToUse = nil
                if colorSpec == "secondary" and lightControls.secondaryColor then
                    colorToUse = lightControls.secondaryColor
                elseif lightControls.primaryColor then
                    colorToUse = lightControls.primaryColor
                end
                
                if colorToUse then
                    local newColor = {colorToUse[1], colorToUse[2], colorToUse[3]}
                    -- Only update if color changed
                    if light.color[1] ~= newColor[1] or light.color[2] ~= newColor[2] or light.color[3] ~= newColor[3] then
                        light.color = newColor
                        if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                        updateLightColor[stationId][light.lightType] = true
                    end
                end
                
                if updateLightColor[stationId] and updateLightColor[stationId][light.lightType] then
                    SetEntityAlpha(light.entity, visibleLights[stationId][light.lightType] and 255 or 0, false)
                end
                SetEntityRotation(light.entity, locRot + tilt, 0.0, (light.heading) + (locHz), 2, true)
                ::continue::
            end
            -- Handle particle effects for smoke machines
            local particleEffects = stationParticleEffects[stationId]
            if particleEffects and station.entityData and station.entityData.smokemachines then
                for i=1, #station.entityData.smokemachines do
                    local smokeMachine = station.entityData.smokemachines[i]
                    if not smokeMachine.entity or not DoesEntityExist(smokeMachine.entity) then goto continue_smoke end
                    
                    -- Handle smoke effect
                    if particleEffects.smoke then
                        if not smokeMachine.smokeParticle then
                            RequestNamedPtfxAsset("scr_ar_planes")
                            while not HasNamedPtfxAssetLoaded("scr_ar_planes") do
                                Citizen.Wait(0)
                            end
                            UseParticleFxAssetNextCall("scr_ar_planes")
                            smokeMachine.smokeParticle = StartParticleFxLoopedOnEntity("scr_ar_trail_smoke", smokeMachine.entity, 0.0, -1.5, 0.0, 0.0, 90.0, -90.0, 0.5, false, false, false)
                        end
                    else
                        if smokeMachine.smokeParticle then
                            StopParticleFxLooped(smokeMachine.smokeParticle, false)
                            RemoveParticleFx(smokeMachine.smokeParticle, true)
                            smokeMachine.smokeParticle = nil
                        end
                    end
                    
                    -- Handle fire effect
                    if particleEffects.fire then
                        if not smokeMachine.flameParticle then
                            RequestNamedPtfxAsset("core")
                            while not HasNamedPtfxAssetLoaded("core") do
                                Citizen.Wait(0)
                            end
                            UseParticleFxAssetNextCall("core")
                            smokeMachine.flameParticle = StartParticleFxLoopedOnEntity("ent_sht_flame", smokeMachine.entity, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0, 1.0, false, false, false)
                            SetTimeout(7000, function()
                                if smokeMachine.flameParticle then
                                    StopParticleFxLooped(smokeMachine.flameParticle, false)
                                    RemoveParticleFx(smokeMachine.flameParticle, false)
                                    smokeMachine.flameParticle = nil
                                end
                            end)
                        end
                    else
                        if smokeMachine.flameParticle then
                            debugPrint("Removing flame particle")
                            StopParticleFxLooped(smokeMachine.flameParticle, false)
                            RemoveParticleFx(smokeMachine.flameParticle, true)
                            smokeMachine.flameParticle = nil
                        end
                    end
                    ::continue_smoke::
                end
            end
            ::continue_station::
        end
        -- Use longer wait time when no nearby stations to reduce CPU usage
        if hasNearbyStations then
            Wait(0)
        else
            Wait(1500) -- Check less frequently when no stations nearby
        end
    end
end)

-- Refresh light entity props every 5 seconds when within render distance
CreateThread(function()
    while true do        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local renderDistance = Config.RenderDistance or 100.0
        
        -- Check each station
        for stationId, localStation in pairs(LocalDJStations) do
            local stationData = DJStations[stationId]
            if not stationData or not stationData.coords then goto continue_station end
            
            -- Check if within render distance
            local distance = #(playerCoords - stationData.coords)
            if distance > renderDistance then goto continue_station end
            
            -- Refresh light entity props if they exist
            if localStation.entityData and localStation.entityData.lights then
                for _, lightData in ipairs(localStation.entityData.lights) do
                    if lightData.entity and DoesEntityExist(lightData.entity) then
                        local model = GetEntityModel(lightData.entity)
                        local rotation = GetEntityRotation(lightData.entity)
                        local coords = lightData.coords
                        DeleteScriptObject(lightData.entity)
                        lightData.entity = CreateProp(model, coords.x, coords.y, coords.z, false, true, false)
                        SetEntityCoordsNoOffset(lightData.entity, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
                        SetEntityRotation(lightData.entity, rotation.x, rotation.y, rotation.z, 2, true)
                        -- Refresh light color
                        if lightData.color then
                            SetObjectLightColor(lightData.entity, 1, lightData.color[1], lightData.color[2], lightData.color[3])
                        end
                        if lightData.attEnt and DoesEntityExist(lightData.attEnt) then
                            AttachEntityToEntity(lightData.attEnt, lightData.entity, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                        end
                        -- Refresh entity properties (collision and freeze state)
                        SetEntityCollision(lightData.entity, false, false)
                        FreezeEntityPosition(lightData.entity, true)
                    end
                end
            end
            
            ::continue_station::
        end
        Wait(5000) -- Wait 5 seconds between refreshes
    end
end)

RegisterNetEvent('pickle_dj:registerDJStation', function(id, station)
    debugPrint("^3[DJ Register]^0 Event received - id type: " .. type(id))
    if type(id) == 'table' then
        debugPrint("^3[DJ Register]^0 Processing bulk station sync - " .. tostring(table.count or "unknown") .. " stations")
        for id, station in pairs(id) do
            DJStations[id] = station
            -- Store light controls from station data
            if station.lightControls then
                debugPrint("^3[DJ Register]^0 Setting stationControls[" .. tostring(id) .. "] from station data")
                -- Deep copy the entire light controls structure to avoid reference issues
                stationControls[id] = {
                    speed = station.lightControls.speed,
                    lights = {}
                }
                if station.lightControls.lights then
                    debugPrint(string.format("[DJ Register] Found %d light types in station.lightControls.lights", 0)) -- Will count below
                    local count = 0
                    for lightType, lightControl in pairs(station.lightControls.lights) do
                        count = count + 1
                        -- Extract colors properly, handling nil and ensuring proper array format
                        local primaryColor = nil
                        if lightControl.primaryColor and type(lightControl.primaryColor) == "table" then
                            local r, g, b = lightControl.primaryColor[1], lightControl.primaryColor[2], lightControl.primaryColor[3]
                            if r ~= nil and g ~= nil and b ~= nil then
                                primaryColor = {r, g, b}
                                debugPrint(string.format("[DJ Register] %s primaryColor: [%d, %d, %d]", lightType, r, g, b))
                            else
                                debugPrint(string.format("[DJ Register] %s primaryColor invalid: r=%s, g=%s, b=%s", lightType, tostring(r), tostring(g), tostring(b)))
                            end
                        else
                            debugPrint(string.format("[DJ Register] %s primaryColor missing or wrong type: %s", lightType, type(lightControl.primaryColor)))
                        end
                        
                        local secondaryColor = nil
                        if lightControl.secondaryColor and type(lightControl.secondaryColor) == "table" then
                            local r, g, b = lightControl.secondaryColor[1], lightControl.secondaryColor[2], lightControl.secondaryColor[3]
                            if r ~= nil and g ~= nil and b ~= nil then
                                secondaryColor = {r, g, b}
                                debugPrint(string.format("[DJ Register] %s secondaryColor: [%d, %d, %d]", lightType, r, g, b))
                            else
                                debugPrint(string.format("[DJ Register] %s secondaryColor invalid: r=%s, g=%s, b=%s", lightType, tostring(r), tostring(g), tostring(b)))
                            end
                        else
                            debugPrint(string.format("[DJ Register] %s secondaryColor missing or wrong type: %s", lightType, type(lightControl.secondaryColor)))
                        end
                        
                        stationControls[id].lights[lightType] = {
                            enabled = lightControl.enabled,
                            rotateHorizontal = lightControl.rotateHorizontal,
                            rotateVertical = lightControl.rotateVertical,
                            flash = lightControl.flash,
                            speed = lightControl.speed,
                            primaryColor = primaryColor,
                            secondaryColor = secondaryColor
                        }
                    end
                    debugPrint(string.format("[DJ Register] Processed %d light types for stationControls[%s]", count, id))
                else
                    debugPrint(string.format("[DJ Register] WARNING: station.lightControls.lights is nil for station %s", id))
                end
            else
                debugPrint(string.format("[DJ Register] WARNING: station.lightControls is nil for station %s", id))
            end
            RegisterDJStation(id)
            
            -- Update existing lights' colors if they're already rendered (after RegisterDJStation has set them up)
            if station.lightControls and station.lightControls.lights then
                local localStation = LocalDJStations[id]
                if localStation and localStation.entityData and localStation.entityData.lights then
                    for _, lightData in ipairs(localStation.entityData.lights) do
                        if lightData.entity and DoesEntityExist(lightData.entity) then
                            local lightType = lightData.lightType
                            local lightControls = station.lightControls.lights[lightType]
                            if lightControls then
                                -- Check top-level colorSpec first (new format), then nested (old format)
                                local colorSpec = (lightData.data and lightData.data.colorSpec) or (lightData.data and lightData.data.data and lightData.data.data.colorSpec) or "primary"
                                local colorToUse = nil
                                
                                if colorSpec == "secondary" and lightControls.secondaryColor then
                                    colorToUse = lightControls.secondaryColor
                                elseif lightControls.primaryColor then
                                    colorToUse = lightControls.primaryColor
                                end
                                
                                if colorToUse then
                                    local newColor = {colorToUse[1], colorToUse[2], colorToUse[3]}
                                    -- Update light color
                                    lightData.color = newColor
                                    SetObjectLightColor(lightData.entity, 1, newColor[1], newColor[2], newColor[3])
                                    if not updateLightColor[id] then updateLightColor[id] = {} end
                                    updateLightColor[id][lightType] = true
                                end
                            end
                        end
                    end
                end
            end
        end
        return
    end
    DJStations[id] = station
    -- Store light controls from station data
    if station.lightControls then
        -- Deep copy the entire light controls structure to avoid reference issues
        stationControls[id] = {
            speed = station.lightControls.speed,
            lights = {}
        }
        if station.lightControls.lights then
            for lightType, lightControl in pairs(station.lightControls.lights) do
                -- Extract colors properly, handling nil and ensuring proper array format
                local primaryColor = nil
                if lightControl.primaryColor and type(lightControl.primaryColor) == "table" then
                    local r, g, b = lightControl.primaryColor[1], lightControl.primaryColor[2], lightControl.primaryColor[3]
                    if r ~= nil and g ~= nil and b ~= nil then
                        primaryColor = {r, g, b}
                    end
                end
                
                local secondaryColor = nil
                if lightControl.secondaryColor and type(lightControl.secondaryColor) == "table" then
                    local r, g, b = lightControl.secondaryColor[1], lightControl.secondaryColor[2], lightControl.secondaryColor[3]
                    if r ~= nil and g ~= nil and b ~= nil then
                        secondaryColor = {r, g, b}
                    end
                end
                
                stationControls[id].lights[lightType] = {
                    enabled = lightControl.enabled,
                    rotateHorizontal = lightControl.rotateHorizontal,
                    rotateVertical = lightControl.rotateVertical,
                    flash = lightControl.flash,
                    speed = lightControl.speed,
                    primaryColor = primaryColor,
                    secondaryColor = secondaryColor
                }
            end
        end
    end
    RegisterDJStation(id)
    
    -- Update existing lights' colors if they're already rendered (after RegisterDJStation has set them up)
    if station.lightControls and station.lightControls.lights then
        local localStation = LocalDJStations[id]
        if localStation and localStation.entityData and localStation.entityData.lights then
            for _, lightData in ipairs(localStation.entityData.lights) do
                if lightData.entity and DoesEntityExist(lightData.entity) then
                    local lightType = lightData.lightType
                    local lightControls = station.lightControls.lights[lightType]
                    if lightControls then
                        -- Check top-level colorSpec first (new format), then nested (old format)
                        local colorSpec = (lightData.data and lightData.data.colorSpec) or (lightData.data and lightData.data.data and lightData.data.data.colorSpec) or "primary"
                        local colorToUse = nil
                        
                        if colorSpec == "secondary" and lightControls.secondaryColor then
                            colorToUse = lightControls.secondaryColor
                        elseif lightControls.primaryColor then
                            colorToUse = lightControls.primaryColor
                        end
                        
                        if colorToUse then
                            local newColor = {colorToUse[1], colorToUse[2], colorToUse[3]}
                            -- Update light color
                            lightData.color = newColor
                            SetObjectLightColor(lightData.entity, 1, newColor[1], newColor[2], newColor[3])
                            if not updateLightColor[id] then updateLightColor[id] = {} end
                            updateLightColor[id][lightType] = true
                        end
                    end
                end
            end
        end
    end
    
    -- If viewing entities for this station, refresh view
    if viewingEntities and viewingStationId == id then
        -- Viewing will automatically update as entities are re-registered
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerServerEvent('pickle_dj:requestDJStations')
    end
end)

-- Receive broadcast start command from server
-- Note: The music module also handles this event to set CurrentControlInstanceId
-- We just forward it to NUI here
RegisterNetEvent('pickle_dj:startBroadcasting', function(musicInstanceId, streamId)
    debugPrint("[pickle_dj] Received startBroadcasting", musicInstanceId, streamId, type(musicInstanceId))
    
    -- Validate that we have both instanceId and streamId before sending to NUI
    if not musicInstanceId or musicInstanceId == nil then
        debugPrint("[pickle_dj] ERROR: Cannot start broadcast - musicInstanceId is nil")
        return
    end
    
    if not streamId or streamId == nil then
        debugPrint("[pickle_dj] ERROR: Cannot start broadcast - streamId is nil")
        return
    end
    
    -- Trigger the NUI to start broadcasting
    SendNUIMessage({
        type = 'music:startAutoBroadcast',
        data = {
            instanceId = musicInstanceId,
            streamId = streamId
        }
    })
end)

-- Receive broadcast stop command from server
RegisterNetEvent('pickle_dj:stopBroadcasting', function()
    -- Trigger the NUI to stop broadcasting
    SendNUIMessage({
        type = 'music:stopAutoBroadcast',
        data = {}
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for id, station in pairs(DJStations) do
            UnregisterDJStation(id)
        end
    end
end)

RegisterNUICallback('setVisible', function(data, cb)
    -- Acknowledge the NUI callback immediately to prevent timeout
    cb(true)
    
    -- Defer SetNuiFocus and camera cleanup to give any in-flight NUI fetch
    -- callbacks (e.g. queued light-toggle POSTs) time to complete before
    -- asserting SetNuiFocus(false, false). Wait(0) is a single-frame defer
    -- which is not enough when multiple fetches are queued; Wait(50) (~3 frames
    -- at 60 fps) gives CEF's fetch queue time to drain and prevents the
    -- stuck-cursor race that occurs when the player closes the UI while light
    -- toggles are still in flight.
    if not data.visible then
        CreateThread(function()
            Wait(50)
            ExitDJCamera()
            ClearPedTasks(PlayerPedId())
            SetNuiFocus(data.visible, data.visible)
            -- Note: We don't stop broadcasting when controller closes
            -- Broadcasting continues until player leaves range of all speakers
        end)
    else
        CreateThread(function()
            Wait(0)
            SetNuiFocus(data.visible, data.visible)
        end)
    end
end)

RegisterNUICallback('updateLightControls', function(data, cb)
    local stationId = data.stationId
    local lightType = data.lightType
    local property = data.property
    local value = data.value
    
    if not stationId or not lightType or not property then
        cb(false)
        return
    end
    
    -- Send update to server to network it
    TriggerServerEvent('pickle_dj:updateLightControls', stationId, lightType, property, value)
    
    cb(true)
end)

RegisterNUICallback('updateAllLightControls', function(data, cb)
    local stationId = data.stationId
    local property = data.property
    local value = data.value
    
    if not stationId or not property then
        cb(false)
        return
    end
    
    -- Send batch update to server to network it
    TriggerServerEvent('pickle_dj:updateAllLightControls', stationId, property, value)
    
    cb(true)
end)

RegisterNUICallback('updateLightSpeed', function(data, cb)
    local stationId = data.stationId
    local speedString = data.speed
    
    if not stationId or not speedString then
        cb(false)
        return
    end
    
    -- Send speed update to server to network it (server will convert string to numeric)
    TriggerServerEvent('pickle_dj:updateLightSpeed', stationId, speedString)
    
    cb(true)
end)

RegisterNUICallback('updateParticleEffect', function(data, cb)
    local stationId = data.stationId
    local effect = data.effect
    local value = data.value
    
    if not stationId or not effect or value == nil then
        cb(false)
        return
    end
    
    -- Send update to server to network it
    TriggerServerEvent('pickle_dj:updateParticleEffect', stationId, effect, value)
    
    cb(true)
end)

RegisterNUICallback('getConfig', function(data, cb)
    cb({
        locale = Language[Config.Language]
    })
end)

-- Receive networked control updates from server
-- Client only stores what server sends, no mapping or conversion
RegisterNetEvent('pickle_dj:lightControlsUpdated', function(stationId, lightType, property, value)
    -- Only update if we have controls from server (initial state must be received first)
    if not stationControls[stationId] or not stationControls[stationId].lights or not stationControls[stationId].lights[lightType] then
        return
    end
    
    -- Store exactly what server sends - no mapping or conversion
    stationControls[stationId].lights[lightType][property] = value
    
    -- Update light colors if color property changed
    if property == "primaryColor" or property == "secondaryColor" then
        -- Ensure value is a table with 3 elements
        if type(value) == "table" and #value == 3 then
            -- Update all lights of this type with the new color
            local station = LocalDJStations[stationId]
            if station and station.entityData and station.entityData.lights then
                for _, lightData in ipairs(station.entityData.lights) do
                    if lightData.lightType == lightType and lightData.entity and DoesEntityExist(lightData.entity) then
                        -- Determine which color to use based on entity's colorSpec
                        -- Check top-level colorSpec first (new format), then nested (old format)
                        local colorSpec = (lightData.data and lightData.data.colorSpec) or (lightData.data and lightData.data.data and lightData.data.data.colorSpec) or "primary"
                        local colorToUse = {value[1], value[2], value[3]}
                    if property == "primaryColor" then
                        if colorSpec == "primary" then
                            lightData.color = {value[1], value[2], value[3]}
                            colorToUse = {value[1], value[2], value[3]}
                        else
                            -- This light uses secondary, so use secondary color instead
                            local secondaryColor = stationControls[stationId].lights[lightType].secondaryColor
                            if secondaryColor and type(secondaryColor) == "table" and #secondaryColor == 3 then
                                colorToUse = {secondaryColor[1], secondaryColor[2], secondaryColor[3]}
                            else
                                colorToUse = {255, 100, 0}
                            end
                        end
                    elseif property == "secondaryColor" then
                        if colorSpec == "secondary" then
                            lightData.color = {value[1], value[2], value[3]}
                            colorToUse = {value[1], value[2], value[3]}
                        else
                            -- This light uses primary, so use primary color instead
                            local primaryColor = stationControls[stationId].lights[lightType].primaryColor
                            if primaryColor and type(primaryColor) == "table" and #primaryColor == 3 then
                                colorToUse = {primaryColor[1], primaryColor[2], primaryColor[3]}
                            else
                                colorToUse = {255, 0, 0}
                            end
                        end
                    end
                        -- Set flag to update color in render loop
                        if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                        updateLightColor[stationId][lightType] = true
                        SetObjectLightColor(lightData.entity, 1, colorToUse[1], colorToUse[2], colorToUse[3])
                    end
                end
            end
        end
    end
    
    -- Convert flash/speed number to string for UI using shared function
    local uiValue = value
    if property == "flash" then
        uiValue = GetFlashString(value)
    elseif property == "speed" then
        uiValue = GetSpeedString(value)
    elseif property == "primaryColor" or property == "secondaryColor" then
        -- Colors are arrays, send as-is (ensure it's a table)
        if type(value) == "table" and #value == 3 then
            uiValue = {value[1], value[2], value[3]}
        else
            uiValue = value
        end
    end
    
    -- Send to NUI for UI updates
    SendNUIMessage({
        type = 'music:lightControlsUpdated',
        data = {
            stationId = stationId,
            lightType = lightType,
            property = property,
            value = uiValue
        }
    })
end)

-- Receive particle effects state from server
RegisterNetEvent('pickle_dj:particleEffectsState', function(stationId, effectsData)
    if effectsData then
        stationParticleEffects[stationId] = {
            smoke = effectsData.smoke == true,
            fire = effectsData.fire == true,
        }
        -- Send to NUI
        SendNUIMessage({
            type = 'music:particleEffectsState',
            data = {
                stationId = stationId,
                state = stationParticleEffects[stationId]
            }
        })
    end
end)

-- Receive particle effects updates from server
RegisterNetEvent('pickle_dj:particleEffectsUpdated', function(stationId, effect, value)
    if not stationParticleEffects[stationId] then
        stationParticleEffects[stationId] = {
            smoke = false,
            fire = false,
        }
    end
    
    if effect == "smoke" then
        stationParticleEffects[stationId].smoke = value == true
    elseif effect == "fire" then
        stationParticleEffects[stationId].fire = value == true
    end
    
    -- Send to NUI for UI updates
    SendNUIMessage({
        type = 'music:particleEffectsUpdated',
        data = {
            stationId = stationId,
            effect = effect,
            value = value == true
        }
    })
end)

-- Receive initial control state when opening controller (kept for backwards compatibility)
RegisterNetEvent('pickle_dj:lightControlsState', function(stationId, controlsData)
    if controlsData then
        stationControls[stationId] = controlsData
        
        -- Update existing lights' colors based on their colorSpec
        local station = LocalDJStations[stationId]
        if station and station.entityData and station.entityData.lights and controlsData.lights then
            for _, lightData in ipairs(station.entityData.lights) do
                if lightData.entity and DoesEntityExist(lightData.entity) then
                    local lightType = lightData.lightType
                    local lightControls = controlsData.lights[lightType]
                    if lightControls then
                        -- Check top-level colorSpec first (new format), then nested (old format)
                        local colorSpec = (lightData.data and lightData.data.colorSpec) or (lightData.data and lightData.data.data and lightData.data.data.colorSpec) or "primary"
                        local colorToUse = nil
                        
                        if colorSpec == "secondary" and lightControls.secondaryColor then
                            colorToUse = lightControls.secondaryColor
                        elseif lightControls.primaryColor then
                            colorToUse = lightControls.primaryColor
                        end
                        
                        if colorToUse then
                            local newColor = {colorToUse[1], colorToUse[2], colorToUse[3]}
                            -- Update light color
                            lightData.color = newColor
                            if not updateLightColor[stationId] then updateLightColor[stationId] = {} end
                            updateLightColor[stationId][lightType] = true
                        end
                    end
                end
            end
        end
        
        -- Convert flash numeric values to strings for UI (deep copy with conversion)
        local uiControls = {}
        uiControls.speed = GetSpeedString(controlsData.speed or 2.0)
        if controlsData.lights then
            uiControls.lights = {}
            for lightType, lightControl in pairs(controlsData.lights) do
                -- Ensure colors are properly formatted as arrays
                local primaryColor = lightControl.primaryColor
                local secondaryColor = lightControl.secondaryColor
                
                -- Validate and normalize primary color
                if primaryColor and type(primaryColor) == "table" then
                    -- Check if it's a proper array with 3 elements
                    if primaryColor[1] and primaryColor[2] and primaryColor[3] then
                        primaryColor = {primaryColor[1], primaryColor[2], primaryColor[3]}
                    else
                        primaryColor = nil -- Invalid, will use default
                    end
                else
                    primaryColor = nil -- Invalid, will use default
                end
                
                -- Use defaults if validation failed
                if not primaryColor then
                    if lightType == "ambient" then
                        primaryColor = {255, 0, 0} -- red
                    elseif lightType == "spotlight" then
                        primaryColor = {0, 255, 0} -- green
                    elseif lightType == "barlight" then
                        primaryColor = {0, 0, 255} -- blue
                    else
                        primaryColor = {255, 0, 0} -- default red
                    end
                end
                
                -- Validate and normalize secondary color
                if secondaryColor and type(secondaryColor) == "table" then
                    -- Check if it's a proper array with 3 elements
                    if secondaryColor[1] and secondaryColor[2] and secondaryColor[3] then
                        secondaryColor = {secondaryColor[1], secondaryColor[2], secondaryColor[3]}
                    else
                        secondaryColor = nil -- Invalid, will use default
                    end
                else
                    secondaryColor = nil -- Invalid, will use default
                end
                
                -- Use defaults if validation failed
                if not secondaryColor then
                    if lightType == "ambient" then
                        secondaryColor = {255, 100, 0} -- orange
                    elseif lightType == "spotlight" then
                        secondaryColor = {0, 200, 255} -- cyan
                    elseif lightType == "barlight" then
                        secondaryColor = {255, 0, 255} -- magenta
                    else
                        secondaryColor = {255, 100, 0} -- default orange
                    end
                end
                
                -- Ensure all boolean values are explicitly set (nil defaults: enabled=true, others=false)
                uiControls.lights[lightType] = {
                    enabled = (lightControl.enabled ~= false), -- nil or true = true, false = false
                    rotateHorizontal = (lightControl.rotateHorizontal == true), -- explicit true check
                    rotateVertical = (lightControl.rotateVertical == true), -- explicit true check
                    flash = GetFlashString(lightControl.flash) or "off",
                    speed = GetSpeedString(lightControl.speed or 2.0),
                    primaryColor = primaryColor,
                    secondaryColor = secondaryColor
                }
            end
        end
        -- Send to NUI with converted values
        SendNUIMessage({
            type = 'music:lightControlsState',
            data = {
                stationId = stationId,
                controls = uiControls
            }
        })
    end
end)


-- DJ Station Creation System
local isPlacingDJ = false
local previewEntity = nil
local defaultProp = `sf_prop_sf_dj_desk_01a`

-- Raycast function
local function RaycastFromCamera()
    local camRot = GetGameplayCamRot(2)
    local camCoord = GetGameplayCamCoord()
    local distance = 50.0
    
    local raycast = StartExpensiveSynchronousShapeTestLosProbe(
        camCoord.x, camCoord.y, camCoord.z,
        camCoord.x + (-math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)) * distance),
        camCoord.y + (math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)) * distance),
        camCoord.z + (math.sin(math.rad(camRot.x)) * distance),
        -1, -- flags (all entities)
        PlayerPedId(),
        7 -- flags
    )
    
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(raycast)
    return hit == 1, endCoords, surfaceNormal, entityHit
end

-- Register notification event (defined before ShowNotification function)
RegisterNetEvent('pickle_dj:notify', function(message, type)
    if lib then
        lib.notify({
            title = 'DJ Station',
            description = message,
            type = type or 'info'
        })
    end
end)

-- Draw 3D text helper
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoord()
    local distance = #(vector3(x, y, z) - camCoords)
    
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Command handler
RegisterCommand('createdj', function()
    if isPlacingDJ then
        ShowNotification(_L("dj_already_placing"), "error")
        return
    end
    
    -- Check if player has admin permission (server will also check)
    lib.callback('pickle_dj:checkAdmin', false, function(isAdmin)
        if not isAdmin then
            ShowNotification(_L("dj_no_permission_command"), "error")
            return
        end
        local options = {}
        for k,v in pairs(Config.DJStations) do
            table.insert(options, {label = k, value = v.prop})
        end
        local input = lib.inputDialog(_L("dj_create_station_title"), {
            {type = 'input', label = _L("dj_station_name_label"), description = _L("dj_station_name_description"), required = true, min = 1, max = 50},
            {type = 'select', label = _L("dj_prop_label"), description = _L("dj_prop_description"), options = options, required = true, default = options[1].value},
            {type = 'checkbox', label = _L("dj_place_without_prop_question"), description = _L("dj_place_without_prop_description")}
        })
        if not input or not input[1] or not input[2] then
            ShowNotification(_L("dj_no_station_selected"), "error")
            return
        end
        
        local stationName = input[1]
        local prop = input[2]
        local placeWithoutProp = input[3] or false
        local placementModel = prop
        local finalProp = prop
        
        -- If placing without prop, use tennis ball for placement indicator and as invisible prop
        if placeWithoutProp then
            placementModel = GetHashKey("prop_tennis_ball")
            finalProp = GetHashKey("prop_tennis_ball") -- Use tennis ball as invisible prop for compatibility
        end
        
        isPlacingDJ = true
        local result = StartGizmoEditor({
            model = placementModel,
            coords = GetEntityCoords(PlayerPedId()),
            rotation = GetEntityRotation(PlayerPedId()),
            rotationOffset = 180.0,
            enableCancel = true
        })
        ShowNotification(_L("dj_place_station_instructions"), "info")
        
        if result and result.position then
            isPlacingDJ = false
            
            -- Send to server
            TriggerServerEvent('pickle_dj:saveStation', {
                name = stationName,
                coords = result.position,
                heading = result.rotation.z,
                prop = finalProp,
                speakers = {}, -- Empty initially, can be added later
                lights = {} -- Empty initially, lights are auto-generated
            })
        else
            isPlacingDJ = false
            ShowNotification(_L("dj_station_creation_cancelled"), "error")
        end
    end)
end, false)

-- Handle station item usage
RegisterNetEvent('pickle_dj:useStationItem', function(prop, stationName)
    if isPlacingDJ then
        ShowNotification(_L("dj_already_placing"), "error")
        return
    end
    
    isPlacingDJ = true
    local result = StartGizmoEditor({
        model = prop,
        coords = GetEntityCoords(PlayerPedId()),
        rotation = GetEntityRotation(PlayerPedId()),
        rotationOffset = 180.0,
        enableCancel = true
    })
    ShowNotification("Look where you want to place the DJ station. Press E to place, Q to cancel, A/D to rotate", "info")
    
    if result and result.position then
        -- Prompt for station name
        local input = lib.inputDialog(_L("dj_create_station_title"), {
            {type = 'input', label = _L("dj_station_name_label"), description = _L("dj_station_name_description"), required = true, min = 1, max = 50, default = stationName}
        })
        
        if input and input[1] then
            local stationName = input[1]
            isPlacingDJ = false
            
            -- Send to server (mark as fromItem to skip admin check)
            -- Item will be removed server-side after successful creation
            TriggerServerEvent('pickle_dj:saveStation', {
                name = stationName,
                coords = result.position,
                heading = result.rotation.z,
                prop = prop,
                speakers = {},
                lights = {},
                fromItem = true -- Flag to indicate this is from item usage
            })
        else
            isPlacingDJ = false
            ShowNotification(_L("dj_station_creation_cancelled"), "error")
        end
    else
        isPlacingDJ = false
        ShowNotification("DJ station creation cancelled", "error")
    end
end)

-- Handle entity item usage
RegisterNetEvent('pickle_dj:useEntityItem', function(entityType, variantKey)
    -- Check if player is near a manageable station
    lib.callback('pickle_dj:canUseEntityItem', false, function(canUse, stationId)
        if not canUse or not stationId then
            ShowNotification(_L("dj_must_be_near_station"), "error")
            return
        end
        
        -- Find item name from variant
        local itemName = nil
        if entityType == "speaker" then
            if variantKey == "speaker_1" then
                itemName = "dj_speaker_large"
            elseif variantKey == "speaker_2" then
                itemName = "dj_speaker_medium"
            elseif variantKey == "speaker_3" then
                itemName = "dj_speaker_small"
            end
        elseif entityType == "light" then
            if variantKey == "ambient" then
                itemName = "dj_light_ambient"
            elseif variantKey == "spotlight" then
                itemName = "dj_light_spotlight"
            elseif variantKey == "barlight" then
                itemName = "dj_light_barlight"
            end
        end
        
        if not itemName then
            ShowNotification(_L("dj_invalid_item_config"), "error")
            return
        end
        
        -- Start entity placement with item name
        StartEntityPlacement(stationId, entityType, variantKey, itemName)
    end)
end)

RegisterCommand('managedj', function()
    local closest = { dist = 999999, id = nil }
    for id, station in pairs(DJStations) do
        local dist = #(GetEntityCoords(PlayerPedId()) - station.coords)
        if dist < closest.dist and dist < Config.RenderDistance then
            closest.dist = dist
            closest.id = id
        end
    end
    if closest.id then
        OpenEntityManagementMenu(closest.id)
    else
        ShowNotification(_L("dj_no_station_found"), "error")
    end
end, false)

-- Entity Management System
local isPlacingEntity = false
local viewingEntities = false
local viewingStationId = nil

-- Entity type definitions
local EntityTypes = {
    speaker = {
        label = _L("dj_speaker_label"),
        icon = "volume-high",
        defaultModel = `h4_prop_battle_club_speaker_med`,
        configKey = "speaker_1"
    },
    light = {
        label = _L("dj_light_label"),
        icon = "lightbulb",
        defaultModel = `stg_blinder`,
    },
    smokemachine = {
        label = _L("dj_smoke_machine_label"),
        icon = "cloud",
        defaultModel = `ba_prop_club_smoke_machine`,
    }
}

-- Show notification helper
function ShowNotification(message, type)
    if lib then
        lib.notify({
            title = 'DJ Station',
            description = message,
            type = type or 'info'
        })
    end
end

-- Open entity management menu
function OpenEntityManagementMenu(stationId)
    local station = DJStations[stationId]
    if not station then return end
    
    local localStation = LocalDJStations[stationId]
    if not localStation then return end
    
    -- Check if player can manage this station (owner or admin)
    lib.callback('pickle_dj:canManageStation', false, function(canManage)
        if not canManage then
            ShowNotification(_L("dj_no_permission_manage_station"), "error")
            return
        end
        
        local options = {
            {
                title = _L("dj_move_table_title"),
                description = _L("dj_move_table_description"),
                icon = "arrows-up-down-left-right",
                onSelect = function()
                    StartStationMove(stationId)
                end
            },
            {
                title = _L("dj_place_entity_title"),
                description = _L("dj_place_entity_description"),
                icon = "plus",
                onSelect = function()
                    OpenEntityTypeMenu(stationId)
                end
            },
            {
                title = _L("dj_view_entities_title"),
                description = _L("dj_view_entities_description"),
                icon = "eye",
                onSelect = function()
                    ToggleEntityViewing(stationId)
                    SetTimeout(100, function()
                        OpenEntityManagementMenu(stationId)
                    end)
                end
            },
            {
                title = _L("dj_remove_entity_title"),
                description = _L("dj_remove_entity_description"),
                icon = "trash",
                onSelect = function()
                    OpenEntityRemoveMenu(stationId)
                end
            },
            {
                title = _L("dj_manage_light_colors_title"),
                description = _L("dj_manage_light_colors_description"),
                icon = "palette",
                onSelect = function()
                    OpenLightColorMenu(stationId)
                end
            }
        }
        
        lib.registerContext({
            id = 'dj_entity_manage_' .. stationId,
            title = _L("dj_entity_management", station.name),
            options = options
        })
        lib.showContext('dj_entity_manage_' .. stationId)
    end, stationId)
end

-- Open entity type selection menu
function OpenEntityTypeMenu(stationId)
    local options = {}
    
    for entityType, entityInfo in pairs(EntityTypes) do
        table.insert(options, {
            title = entityInfo.label,
            description = _L("dj_place_entity_type_description", entityInfo.label:lower()),
            icon = entityInfo.icon,
            onSelect = function()
                -- Show variant selection for speakers and lights
                if entityType == "speaker" or entityType == "light" then
                    OpenEntityVariantMenu(stationId, entityType)
                else
                    StartEntityPlacement(stationId, entityType, nil)
                end
            end
        })
    end
    
        lib.registerContext({
            id = 'dj_entity_type_' .. stationId,
            title = _L("dj_select_entity_type"),
            menu = 'dj_entity_manage_' .. stationId,
            options = options
        })
    lib.showContext('dj_entity_type_' .. stationId)
end

-- Open variant selection menu for speakers or lights
function OpenEntityVariantMenu(stationId, entityType)
    local options = {}
    local configTable = nil
    local title = ""
    
    if entityType == "speaker" then
        configTable = Config.SpeakerProps
        title = _L("dj_select_speaker_type")
    elseif entityType == "light" then
        configTable = Config.LightTypes
        title = _L("dj_select_light_type")
    end
    
    if not configTable then
        ShowNotification(_L("dj_no_variants_available"), "error")
        return
    end
    
    -- Build options from config
    for variantKey, variantData in pairs(configTable) do
        local label = variantData.label or variantKey
        local description = _L("dj_place_entity_type_description", label:lower())
        
        table.insert(options, {
            title = label,
            description = description,
            icon = entityType == "speaker" and "volume-high" or "lightbulb",
            onSelect = function()
                StartEntityPlacement(stationId, entityType, variantKey)
            end
        })
    end
    
    if #options == 0 then
        ShowNotification(_L("dj_no_variants_configured"), "error")
        return
    end
    
    lib.registerContext({
        id = 'dj_entity_variant_' .. stationId .. '_' .. entityType,
        title = title,
        menu = 'dj_entity_type_' .. stationId,
        options = options
    })
    lib.showContext('dj_entity_variant_' .. stationId .. '_' .. entityType)
end

-- Start entity placement
function StartEntityPlacement(stationId, entityType, variantKey, itemName)
    if isPlacingEntity then
        ShowNotification(_L("dj_already_placing_entity"), "error")
        return
    end
    
    -- Store item name if placing from item
    if itemName then
        isPlacingEntityFromItem = itemName
    end
    
    local entityInfo = EntityTypes[entityType]
    if not entityInfo then return end
    
    local station = DJStations[stationId]
    if not station then return end
    
    -- Get model and variant data based on entity type
    local model = entityInfo.defaultModel
    local variantData = nil
    local variantLabel = entityInfo.label
    
    if entityType == "speaker" then
        if variantKey and Config.SpeakerProps and Config.SpeakerProps[variantKey] then
            variantData = Config.SpeakerProps[variantKey]
            model = variantData.model
            variantLabel = variantData.label or variantKey
        elseif Config.SpeakerProps then
            -- If no variant selected but config exists, use first one
            for key, data in pairs(Config.SpeakerProps) do
                variantData = data
                model = data.model
                variantKey = key
                variantLabel = data.label or key
                break
            end
        end
    elseif entityType == "light" then
        if variantKey and Config.LightTypes and Config.LightTypes[variantKey] then
            variantData = Config.LightTypes[variantKey]
            model = variantData.model
            variantLabel = variantData.label or variantKey
        elseif Config.LightTypes then
            -- If no variant selected but config exists, use first one
            for key, data in pairs(Config.LightTypes) do
                variantData = data
                model = data.model
                variantKey = key
                variantLabel = data.label or key
                break
            end
        end
    end
    
    isPlacingEntity = true
    
    -- Start gizmo editor
    local result = StartGizmoEditor({
        model = model,
        coords = GetEntityCoords(PlayerPedId()),
        rotation = vector3(0.0, 0.0, GetEntityHeading(PlayerPedId())),
        lightColor = {255, 255, 255},
        rotationOffset = entityType == "smokemachine" and 180.0 or 0.0,
        enableCancel = true,
        deleteEntity = true
    })
    
    if result and result.position then
        -- Prepare entity data
        local entityData = {
            coords = result.position,
            heading = result.rotation.z,
            model = model
        }
        
        -- Add entity-specific data
        if entityType == "speaker" and variantData then
            entityData.data = {
                speakerType = variantKey,
                rotation = variantData.rotation or vector3(0.0, 0.0, 0.0),
                soundOffset = variantData.soundOffset or vector3(0.0, 0.0, 0.0),
                soundRadius = variantData.soundRadius
            }
        elseif entityType == "light" and variantData then
            entityData.data = {
                lightType = variantKey,
                strobeModel = variantData.strobeModel
            }
        elseif entityType == "smokemachine" then
            -- Smoke machines don't need variant data
            entityData.data = {}
        end
        
        -- Send to server
        TriggerServerEvent('pickle_dj:addEntity', stationId, entityType, entityData)
        ShowNotification(_L("dj_entity_placed", variantLabel), "success")
        
        -- If placed via item, remove item from inventory
        local wasFromItem = isPlacingEntityFromItem ~= nil
        if wasFromItem then
            TriggerServerEvent('pickle_dj:confirmEntityPlacement', isPlacingEntityFromItem)
            isPlacingEntityFromItem = nil
        end
        isPlacingEntity = false
        if not wasFromItem then
            OpenEntityTypeMenu(stationId)
        end
    else
        ShowNotification(_L("dj_entity_placement_cancelled"), "error")
        isPlacingEntityFromItem = nil
        isPlacingEntity = false
    end
end

-- Toggle entity viewing
function ToggleEntityViewing(stationId)
    if viewingEntities and viewingStationId == stationId then
        viewingEntities = false
        viewingStationId = nil
        ShowNotification(_L("dj_entity_viewing_disabled"), "info")
    else
        viewingEntities = true
        viewingStationId = stationId
        ShowNotification(_L("dj_entity_viewing_enabled"), "info")
    end
end

-- Start moving a DJ station
function StartStationMove(stationId)
    local station = DJStations[stationId]
    if not station then
        ShowNotification(_L("dj_station_not_found"), "error")
        return
    end
    
    local localStation = LocalDJStations[stationId]
    if not localStation or not localStation.entity or not DoesEntityExist(localStation.entity) then
        ShowNotification(_L("dj_station_entity_not_found"), "error")
        return
    end
    
    -- Get current position and rotation
    local currentCoords = GetEntityCoords(localStation.entity)
    local currentRotation = GetEntityRotation(localStation.entity)
    
    -- Start gizmo editor at current position
    local result = StartGizmoEditor({
        model = station.prop,
        coords = currentCoords,
        rotation = currentRotation,
        rotationOffset = station.rotationOffset or 180.0,
        enableCancel = true
    })
    
    ShowNotification(_L("dj_move_table_instructions"), "info")
    
    if result and result.position then
        -- Send new position to server
        TriggerServerEvent('pickle_dj:moveStation', stationId, result.position, result.rotation.z)
    else
        ShowNotification(_L("dj_station_move_cancelled"), "error")
    end
end

-- Open entity removal menu
function OpenEntityRemoveMenu(stationId)
    local localStation = LocalDJStations[stationId]
    if not localStation or not localStation.entityData then
        ShowNotification(_L("dj_no_entities_found"), "error")
        return
    end
    
    local options = {}
    
    -- Add speakers
    for i, speakerData in ipairs(localStation.entityData.speakers or {}) do
        local variantLabel = "Speaker"
        if speakerData.data and speakerData.data.speakerType and Config.SpeakerProps and Config.SpeakerProps[speakerData.data.speakerType] then
            variantLabel = Config.SpeakerProps[speakerData.data.speakerType].label or speakerData.data.speakerType
        end
        table.insert(options, {
            title = variantLabel .. " #" .. (speakerData.dbId or i),
            description = _L("dj_remove_speaker"),
            icon = "volume-high",
            onSelect = function()
                if speakerData.dbId then
                    TriggerServerEvent('pickle_dj:removeEntity', speakerData.dbId)
                else
                    ShowNotification(_L("dj_entity_id_not_found"), "error")
                end
                SetTimeout(500, function()
                    OpenEntityRemoveMenu(stationId)
                end)
            end
        })
    end
    
    -- Add lights
    for i, lightData in ipairs(localStation.entityData.lights or {}) do
        local variantLabel = "Light"
        if Config.LightTypes and Config.LightTypes[lightData.lightType] then
            variantLabel = Config.LightTypes[lightData.lightType].label or lightData.lightType
        end
        table.insert(options, {
            title = variantLabel .. " #" .. (lightData.dbId or i),
            description = _L("dj_remove_light"),
            icon = "lightbulb",
            onSelect = function()
                if lightData.dbId then
                    TriggerServerEvent('pickle_dj:removeEntity', lightData.dbId)
                else
                    ShowNotification(_L("dj_entity_id_not_found"), "error")
                end
                SetTimeout(500, function()
                    OpenEntityRemoveMenu(stationId)
                end)
            end
        })
    end
    
    -- Add smoke machines
    for i, smokeMachineData in ipairs(localStation.entityData.smokemachines or {}) do
        table.insert(options, {
            title = _L("dj_smoke_machine_number", smokeMachineData.dbId or i),
            description = _L("dj_remove_smoke_machine"),
            icon = "cloud",
            onSelect = function()
                if smokeMachineData.dbId then
                    TriggerServerEvent('pickle_dj:removeEntity', smokeMachineData.dbId)
                else
                    ShowNotification(_L("dj_entity_id_not_found"), "error")
                end
                SetTimeout(500, function()
                    OpenEntityRemoveMenu(stationId)
                end)
            end
        })
    end
    
    if #options == 0 then
        ShowNotification(_L("dj_no_entities_to_remove"), "info")
        return
    end
    
    lib.registerContext({
        id = 'dj_entity_remove_' .. stationId,
        title = _L("dj_remove_entity_title_menu"),
        menu = 'dj_entity_manage_' .. stationId,
        options = options
    })
    lib.showContext('dj_entity_remove_' .. stationId)
end

-- Open light color management menu
function OpenLightColorMenu(stationId)
    local localStation = LocalDJStations[stationId]
    if not localStation or not localStation.entityData then
        ShowNotification(_L("dj_no_entities_found"), "error")
        return
    end
    
    local options = {}
    
    -- Add lights
    for i, lightData in ipairs(localStation.entityData.lights or {}) do
        local variantLabel = "Light"
        if Config.LightTypes and Config.LightTypes[lightData.lightType] then
            variantLabel = Config.LightTypes[lightData.lightType].label or lightData.lightType
        end
        
        -- Get current color spec (default to "primary" if not set)
        -- Check both top-level colorSpec (new format) and nested data.colorSpec (old format)
        local currentColorSpec = "primary"
        if lightData.data then
            -- Check top-level colorSpec first (extracted by server)
            if lightData.data.colorSpec then
                currentColorSpec = lightData.data.colorSpec
            -- Fallback to nested data.colorSpec
            elseif lightData.data.data and lightData.data.data.colorSpec then
                currentColorSpec = lightData.data.data.colorSpec
            end
        end
        
        local colorSpecLabel = currentColorSpec == "primary" and _L("dj_color_primary") or _L("dj_color_secondary")
        local oppositeColorSpec = currentColorSpec == "primary" and "secondary" or "primary"
        local oppositeColorSpecLabel = oppositeColorSpec == "primary" and _L("dj_color_primary") or _L("dj_color_secondary")
        
        table.insert(options, {
            title = variantLabel .. " #" .. (lightData.dbId or i),
            description = _L("dj_color_description", colorSpecLabel, oppositeColorSpecLabel),
            icon = currentColorSpec == "primary" and "circle" or "circle-dot",
            onSelect = function()
                if lightData.dbId then
                    -- Toggle color spec
                    local newColorSpec = oppositeColorSpec
                    TriggerServerEvent('pickle_dj:updateEntityColorSpec', lightData.dbId, newColorSpec)
                    -- Update local data immediately for responsive UI
                    if lightData.data then
                        -- Update top-level colorSpec (preferred)
                        lightData.data.colorSpec = newColorSpec
                        -- Also update nested data.colorSpec for consistency
                        if lightData.data.data then
                            lightData.data.data.colorSpec = newColorSpec
                        end
                    else
                        lightData.data = { colorSpec = newColorSpec, data = { colorSpec = newColorSpec } }
                    end
                else
                    ShowNotification(_L("dj_entity_id_not_found"), "error")
                end
                -- Refresh menu to show updated state
                SetTimeout(500, function()
                    OpenLightColorMenu(stationId)
                end)
            end
        })
    end
    
    if #options == 0 then
        ShowNotification(_L("dj_no_lights_found"), "info")
        return
    end
    
    lib.registerContext({
        id = 'dj_light_color_' .. stationId,
        title = _L("dj_manage_light_colors_title_menu"),
        menu = 'dj_entity_manage_' .. stationId,
        options = options
    })
    lib.showContext('dj_light_color_' .. stationId)
end

-- Update entity data when station is updated
RegisterNetEvent('pickle_dj:entityUpdated', function(stationId)
    -- Reload the station
    if DJStations[stationId] then
        RegisterDJStation(stationId)
    end
end)

-- Open whitelist management menu
function OpenWhitelistMenu(stationId)
    local station = DJStations[stationId]
    if not station then return end
    
    -- Check if player can manage whitelist
    lib.callback('pickle_dj:canManageStation', false, function(canManage)
        if not canManage then
            ShowNotification(_L("dj_no_permission_manage_station"), "error")
            return
        end
        
        -- Check if owner (non-admin) - they can only manage players
        lib.callback('pickle_dj:checkAdmin', false, function(isAdmin)
            -- Get whitelist
            lib.callback('pickle_dj:getWhitelist', false, function(whitelist)
                local options = {}
                
                -- Add existing entries
                for _, entry in ipairs(whitelist or {}) do
                    local displayName = entry.name or entry.value
                    if entry.type == 'job' then
                        displayName = displayName .. " (Rank: " .. (entry.rank or 0) .. ")"
                    elseif entry.type == 'ace' then
                        displayName = entry.value
                    end
                    
                    table.insert(options, {
                        title = displayName,
                        description = _L("dj_whitelist_type", entry.type:gsub("^%l", string.upper)),
                        icon = entry.type == 'player' and "user" or (entry.type == 'job' and "briefcase" or "shield"),
                        onSelect = function()
                            lib.callback('pickle_dj:checkAdmin', false, function(isAdmin2)
                                local canRemove = isAdmin2
                                if not isAdmin2 then
                                    -- Non-admin owners can only remove players
                                    canRemove = entry.type == 'player'
                                end
                                
                                if canRemove then
                                    lib.registerContext({
                                        id = 'dj_whitelist_remove_' .. entry.id,
                                        title = _L("dj_remove_from_whitelist"),
                                        menu = 'dj_whitelist_' .. stationId,
                                        options = {
                                            {
                                                title = _L("dj_confirm_remove_title"),
                                                description = _L("dj_confirm_remove_description", displayName),
                                                icon = "trash",
                                                onSelect = function()
                                                    TriggerServerEvent('pickle_dj:removeWhitelist', stationId, entry.id)
                                                    SetTimeout(500, function()
                                                        OpenWhitelistMenu(stationId)
                                                    end)
                                                end
                                            }
                                        }
                                    })
                                    lib.showContext('dj_whitelist_remove_' .. entry.id)
                                else
                                    ShowNotification(_L("dj_whitelist_only_remove_players"), "error")
                                end
                            end)
                        end
                    })
                end
                
                -- Add option to add new entry
                table.insert(options, {
                    title = _L("dj_add_to_whitelist_title"),
                    description = _L("dj_add_to_whitelist_description"),
                    icon = "plus",
                    onSelect = function()
                        OpenAddWhitelistMenu(stationId, isAdmin)
                    end
                })
                
                lib.registerContext({
                    id = 'dj_whitelist_' .. stationId,
                    title = _L("dj_whitelist_management", station.name),
                    menu = 'dj_station_' .. stationId,
                    options = options
                })
                lib.showContext('dj_whitelist_' .. stationId)
            end, stationId)
        end)
    end, stationId)
end

-- Open add whitelist menu
function OpenAddWhitelistMenu(stationId, isAdmin)
    local options = {
        {
            title = _L("dj_add_player_title"),
            description = _L("dj_add_player_description"),
            icon = "user",
            onSelect = function()
                local station = DJStations[stationId]
                if not station or not station.coords then
                    ShowNotification(_L("dj_station_not_found"), "error")
                    return
                end
                
                -- Get nearby players
                lib.callback('pickle_dj:getNearbyPlayers', false, function(nearbyPlayers)
                    if not nearbyPlayers or #nearbyPlayers == 0 then
                        ShowNotification(_L("dj_no_nearby_players"), "info")
                        return
                    end
                    
                    local options = {}
                    for _, player in ipairs(nearbyPlayers) do
                        table.insert(options, {
                            title = player.name,
                            description = _L("dj_player_info", player.serverId, player.distance),
                            icon = "user",
                            onSelect = function()
                                TriggerServerEvent('pickle_dj:addWhitelist', stationId, 'player', player.identifier, player.name, 0)
                                ShowNotification(_L("dj_added_to_whitelist", player.name), "success")
                                SetTimeout(500, function()
                                    OpenWhitelistMenu(stationId)
                                end)
                            end
                        })
                    end
                    
                    lib.registerContext({
                        id = 'dj_select_player_' .. stationId,
                        title = _L("dj_select_player_to_add"),
                        menu = 'dj_add_whitelist_' .. stationId,
                        options = options
                    })
                    lib.showContext('dj_select_player_' .. stationId)
                end, station.coords, 10.0)
            end
        }
    }
    
    if isAdmin then
        table.insert(options, {
            title = _L("dj_add_job_title"),
            description = _L("dj_add_job_description"),
            icon = "briefcase",
            onSelect = function()
                local input = lib.inputDialog(_L("dj_add_job_title"), {
                    {type = 'input', label = _L("dj_job_name_label"), description = _L("dj_job_name_description"), required = true},
                    {type = 'number', label = _L("dj_minimum_rank_label"), description = _L("dj_minimum_rank_description"), required = true, default = 0, min = 0}
                })
                if input and input[1] and input[2] ~= nil then
                    TriggerServerEvent('pickle_dj:addWhitelist', stationId, 'job', input[1], input[1], input[2])
                    SetTimeout(500, function()
                        OpenWhitelistMenu(stationId)
                    end)
                end
            end
        })
        
        table.insert(options, {
            title = _L("dj_add_ace_title"),
            description = _L("dj_add_ace_description"),
            icon = "shield",
            onSelect = function()
                local input = lib.inputDialog(_L("dj_add_ace_title"), {
                    {type = 'input', label = _L("dj_ace_permission_label"), description = _L("dj_ace_permission_description"), required = true}
                })
                if input and input[1] then
                    TriggerServerEvent('pickle_dj:addWhitelist', stationId, 'ace', input[1], input[1], 0)
                    SetTimeout(500, function()
                        OpenWhitelistMenu(stationId)
                    end)
                end
            end
        })
    end
    
    lib.registerContext({
        id = 'dj_add_whitelist_' .. stationId,
        title = _L("dj_add_to_whitelist_title"),
        menu = 'dj_whitelist_' .. stationId,
        options = options
    })
    lib.showContext('dj_add_whitelist_' .. stationId)
end

-- Thread to draw entity labels when viewing entities
CreateThread(function()
    while true do
        local waitTime = 1500        
        if viewingEntities and viewingStationId then
            waitTime = 0
            local localStation = LocalDJStations[viewingStationId]
            local station = DJStations[viewingStationId]
            if not station or not station.coords then
                viewingEntities = false
                viewingStationId = nil
            else
                local pcoords = GetEntityCoords(PlayerPedId())
                local distance = #(pcoords - station.coords)
                if distance > Config.RenderDistance then
                    viewingEntities = false
                    viewingStationId = nil
                elseif localStation and localStation.entityData then
                    -- Draw speaker labels
                    for k,v in pairs(localStation.entityData) do 
                        for i, data in ipairs(v) do
                            if data.entity and DoesEntityExist(data.entity) then
                                local coords = GetEntityCoords(data.entity)
                                local label = "#" .. (data.dbId or i)
                                DrawText3D(coords.x, coords.y, coords.z + 0.5, label)
                            end
                        end
                    end
                end
            end
        end
        Wait(waitTime)
    end
end)