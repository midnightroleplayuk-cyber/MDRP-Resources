Clubs = {}
LocalClubs = {}
RegisteredEntityTypes = {}
CurrentCamera = nil
ClubManagementNuiVisible = false
ClubManagementFocus = true

local function ApplyClubManagementFocus(toggle)
    ClubManagementFocus = toggle == true
    if ClubManagementFocus then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    else
        SetNuiFocus(true, false)
        SetNuiFocusKeepInput(true)
    end
    SendNUIMessage({
        type = "setClubManagementFocus",
        toggle = ClubManagementFocus,
    })
end

local function NormalizeForNui(value)
    local valueType = type(value)
    if valueType == "vector3" then
        return { x = value.x, y = value.y, z = value.z }
    end
    if valueType ~= "table" then
        return value
    end
    local output = {}
    for k, v in pairs(value) do
        output[k] = NormalizeForNui(v)
    end
    return output
end

-- Serialize clubs for NUI
local function SerializeClubsForNui()
    local list = {}
    for id, club in pairs(Clubs) do
        local entitiesMap = {}
        for entityId, entity in pairs(club.entities or {}) do
            entitiesMap[tostring(entityId)] = NormalizeForNui(entity)
        end
        list[#list + 1] = {
            id = id,
            label = club.label or ("Club #" .. id),
            description = club.description or "",
            coords = NormalizeForNui(club.coords),
            jobs = club.jobs or {},
            entities = entitiesMap,
            drink_menu = NormalizeForNui(club.drink_menu or {}),
            blip = club.blip,
        }
    end
    return list
end

RegisterNUICallback("closeClubManagement", function(_, cb)
    ClubManagementNuiVisible = false
    ClubManagementFocus = false
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback("teleportToEntity", function(data, cb)
    if data and data.clubId and data.entityId then
        local clubId = tonumber(data.clubId)
        local club = clubId and Clubs[clubId]
        if club and club.entities and club.entities[data.entityId] then
            local entity = club.entities[data.entityId]
            local coords = (entity.bartender and entity.bartender.coords)
                or (entity.bouncer and entity.bouncer.coords)
                or (entity.society and entity.society.coords)
                or entity.coords
            if coords then
                SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
            end
        end
    end
    cb({ ok = true })
end)

RegisterNUICallback("toggleClubManagementFocus", function(_, cb)
    if ClubManagementNuiVisible then
        ApplyClubManagementFocus(not ClubManagementFocus)
    end
    cb({ ok = true, focus = ClubManagementFocus })
end)

local function RunWithReleasedManagementFocus(cb)
    local previousFocus = ClubManagementFocus
    if ClubManagementNuiVisible then
        SendNUIMessage({ type = "setClubManagementPanelHidden", hidden = true })
        ApplyClubManagementFocus(false)
    end
    local results = { cb() }
    if ClubManagementNuiVisible then
        SendNUIMessage({ type = "setClubManagementPanelHidden", hidden = false })
        ApplyClubManagementFocus(previousFocus)
    end
    return table.unpack(results)
end

RegisterNUICallback("getPlayerCoords", function(_, cb)
    local coords = RunWithReleasedManagementFocus(function()
        local gizmo = StartGizmoEditor({
            model = `prop_tennis_ball`,
            coords = GetEntityCoords(PlayerPedId()),
            rotation = vector3(0.0, 0.0, 0.0),
            enableCancel = true,
        })
        if not gizmo or not gizmo.position then return nil end
        return gizmo.position
    end)
    if coords then
        cb({ x = coords.x, y = coords.y, z = coords.z })
    else
        cb(nil)
    end
end)

local function BuildEntityPayloadFromUiWithGizmo(clubId, entityType, sourcePayload)
    local club = Clubs[clubId]
    if not club then return nil end

    local payload = DeepCopy(sourcePayload or {})
    payload.type = entityType

    if entityType == "bartender" then
        payload.bartender = payload.bartender or {}
        return RunWithReleasedManagementFocus(function()
            return UpdateBartenderPosition(payload, club)
        end)
    end

    if entityType == "bouncer" then
        payload.bouncer = payload.bouncer or {}
        payload.bouncer.ped = payload.bouncer.ped or "bouncer_1"
        return RunWithReleasedManagementFocus(function()
            return UpdateBouncerPosition(payload, club)
        end)
    end

    if entityType == "club_entry" then
        payload.bouncer = payload.bouncer or {}
        payload.bouncer.ped = payload.bouncer.ped or "bouncer_1"
        payload.eject = payload.eject or {}
        return RunWithReleasedManagementFocus(function()
            local movedBouncer = UpdateClubEntryBouncerPosition(payload, club)
            if not movedBouncer then return nil end
            return UpdateClubEntryEjectPosition(movedBouncer, club)
        end)
    end

    if entityType == "society" then
        payload.society = payload.society or {}
        return RunWithReleasedManagementFocus(function()
            return UpdateSocietyPosition(payload, club)
        end)
    end

    return payload
end

RegisterNUICallback("clubManagementAction", function(payload, cb)
    local action = payload and payload.action or nil
    local data = payload and payload.data or {}

    if action == "createClub" then
        local defaultCoords = GetEntityCoords(PlayerPedId())
        local createCoords = data.coords or defaultCoords
        TriggerServerEvent("pickle_clubs:createClub", {
            label = data.label,
            description = data.description or "",
            coords = { x = createCoords.x, y = createCoords.y, z = createCoords.z },
            jobs = data.jobs,
            drink_menu = type(data.drink_menu) == "table" and next(data.drink_menu) and data.drink_menu or Config.DefaultDrinks or {},
            blip = data.blip,
        })
    elseif action == "updateClub" then
        local updateCoords = data.coords
        if updateCoords then
            updateCoords = { x = updateCoords.x, y = updateCoords.y, z = updateCoords.z }
        end
        TriggerServerEvent("pickle_clubs:updateClub", tonumber(data.clubId), {
            label = data.label,
            description = data.description or "",
            coords = updateCoords,
            jobs = data.jobs,
            drink_menu = data.drink_menu,
            blip = data.blip,
        })
    elseif action == "deleteClub" then
        TriggerServerEvent("pickle_clubs:deleteClub", tonumber(data.clubId))
    elseif action == "createClubEntity" then
        local clubId = tonumber(data.clubId)
        local entityType = data.entityType
        local entityPayload = data.entityData
        if data.useGizmo == true then
            entityPayload = BuildEntityPayloadFromUiWithGizmo(clubId, entityType, entityPayload)
        end
        if entityPayload then
            TriggerServerEvent("pickle_clubs:createClubEntity", clubId, entityType, entityPayload)
        end
    elseif action == "updateClubEntity" then
        TriggerServerEvent("pickle_clubs:updateClubEntity", tonumber(data.clubId), tostring(data.entityId), data.entityData)
    elseif action == "deleteClubEntity" then
        TriggerServerEvent("pickle_clubs:deleteClubEntity", tonumber(data.clubId), tostring(data.entityId))
    elseif action == "editClubCoords" then
        local clubId = tonumber(data.clubId)
        local club = Clubs[clubId]
        if club then
            local coords = RunWithReleasedManagementFocus(function()
                local gizmo = StartGizmoEditor({
                    model = `prop_tennis_ball`,
                    coords = club.coords,
                    rotation = vector3(0.0, 0.0, 0.0),
                    enableCancel = true,
                })
                if not gizmo or not gizmo.position then return nil end
                return gizmo.position
            end)
            if coords then
                Clubs[clubId].coords = coords
                TriggerServerEvent("pickle_clubs:updateClub", clubId, { coords = { x = coords.x, y = coords.y, z = coords.z } })
                if ClubManagementNuiVisible then
                    SendNUIMessage({
                        type = "updateClubManagement",
                        clubs = SerializeClubsForNui(),
                    })
                end
            end
        end
    elseif action == "editEntityTransform" then
        local clubId = tonumber(data.clubId)
        local entityId = tostring(data.entityId)
        local target = data.target or "main"
        local club = Clubs[clubId]
        local entity = club and club.entities and club.entities[entityId]
        if club and entity then
            local updatedPayload = nil
            if entity.type == "bartender" then
                updatedPayload = RunWithReleasedManagementFocus(function()
                    return WithTemporarilyHiddenEntity(clubId, entityId, function()
                        return UpdateBartenderPosition(entity, club)
                    end)
                end)
            elseif entity.type == "bouncer" then
                updatedPayload = RunWithReleasedManagementFocus(function()
                    return WithTemporarilyHiddenEntity(clubId, entityId, function()
                        return UpdateBouncerPosition(entity, club)
                    end)
                end)
            elseif entity.type == "club_entry" then
                updatedPayload = RunWithReleasedManagementFocus(function()
                    return WithTemporarilyHiddenEntity(clubId, entityId, function()
                        if target == "eject" then
                            return UpdateClubEntryEjectPosition(entity, club)
                        end
                        return UpdateClubEntryBouncerPosition(entity, club)
                    end)
                end)
            elseif entity.type == "society" then
                updatedPayload = RunWithReleasedManagementFocus(function()
                    return WithTemporarilyHiddenEntity(clubId, entityId, function()
                        return UpdateSocietyPosition(entity, club)
                    end)
                end)
            end
            if updatedPayload then
                Clubs[clubId].entities[entityId] = updatedPayload
                TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, updatedPayload)
                if ClubManagementNuiVisible then
                    SendNUIMessage({
                        type = "updateClubManagement",
                        clubs = SerializeClubsForNui(),
                    })
                end
            end
        end
    end

    cb({ ok = true })
end)

function CreateScriptedCamera()
    if CurrentCamera then ExitScriptedCamera() end
    local initialCamSettings = {
        coords = GetGameplayCamCoord(),
        rotation = GetGameplayCamRot(),
        fov = GetGameplayCamFov(),
    }
    CurrentCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 
        initialCamSettings.coords.x, initialCamSettings.coords.y, initialCamSettings.coords.z, 
        initialCamSettings.rotation.x, initialCamSettings.rotation.y, initialCamSettings.rotation.z, initialCamSettings.fov
    )
    SetCamActive(CurrentCamera, true)
    RenderScriptCams(true, false, 0, true, true)
end

function ExitScriptedCamera(durationValue)
    local duration = durationValue
    if duration == nil then duration = 2000 end
    ClearFocus()
	DestroyAllCams()
    RenderScriptCams(false, true, duration, true, false) 
end


local ClubBlips = {} -- clubId -> blipHandle

local function UpdateClubBlip(id)
    -- Remove old blip
    if ClubBlips[id] then
        RemoveBlip(ClubBlips[id])
        ClubBlips[id] = nil
    end
    local club = Clubs[id]
    if not club or not club.coords then return end
    local b = club.blip or {}
    if b.visible == false then return end
    local coords = club.coords
    if not coords then return end
    ClubBlips[id] = CreateBlip({
        coords = {coords.x, coords.y, coords.z},
        sprite = b.sprite or 614,
        color = b.color or 5,
        scale = b.scale or 0.8,
        label = b.name or club.label or ("Club #" .. id),
    })
end

-- Coerce {x, y, z} tables (the DB/JSON shape used since the vector-blip fix)
-- back to a vector3 so the rest of the client can do `pcoords - coords` math.
local function EnsureVector3(c)
    if not c then return vector3(0.0, 0.0, 0.0) end
    if type(c) == "vector3" then return c end
    if type(c) == "table" then
        return vector3(tonumber(c.x) or tonumber(c[1]) or 0.0,
                       tonumber(c.y) or tonumber(c[2]) or 0.0,
                       tonumber(c.z) or tonumber(c[3]) or 0.0)
    end
    return vector3(0.0, 0.0, 0.0)
end

function RegisterClub(id, data)
    if data and data.coords then data.coords = EnsureVector3(data.coords) end
    Clubs[id] = data
    UpdateClubBlip(id)
    local pcoords = GetEntityCoords(PlayerPedId())
    if #(pcoords - data.coords) < Config.RenderDistance then
        RenderClub(id)
    end
end

function UnregisterClub(id)
    UnrenderClub(id)
    if ClubBlips[id] then
        RemoveBlip(ClubBlips[id])
        ClubBlips[id] = nil
    end
    Clubs[id] = nil
end

function RenderClub(id)
    UnrenderClub(id)
    local club = Clubs[id]
    if not club then return end
    LocalClubs[id] = {
        entities = {},
    }
    for k,v in pairs(club.entities) do
        LocalClubs[id].entities[k] = RenderClubEntity(id, k)
    end
end

function UnrenderClub(id)
    if not LocalClubs[id] then return end
    for k,v in pairs(LocalClubs[id].entities) do
        UnrenderClubEntity(id, k)
    end
    LocalClubs[id].entities = nil
    LocalClubs[id] = nil
end

function RenderClubEntity(id, entityId)
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    if not RegisteredEntityTypes[entity.type] then return end
    RegisteredEntityTypes[entity.type].onRender(id, entityId)
    return true
end

function UnrenderClubEntity(id, entityId)
    local club = Clubs[id]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end
    if not RegisteredEntityTypes[entity.type] then return end
    RegisteredEntityTypes[entity.type].onUnrender(id, entityId)
end

function RegisterEntityType(entityType, data)
    local localOnRender = data.onRender or function() end
    local localOnUnrender = data.onUnrender or function() end
    RegisteredEntityTypes[entityType] = {
        label = data.label or entityType,
        description = data.description or "This is the " .. entityType .. " entity type.",
        data =  data.data or {},
        localOnRender = localOnRender,
        localOnUnrender = localOnUnrender,
        onRender = function(id, entityId)
            TriggerServerEvent("pickle_clubs:renderEntity", id, entityId)
            localOnRender(id, entityId)
        end,
        onUnrender = function(id, entityId)
            TriggerServerEvent("pickle_clubs:unrenderEntity", id, entityId)
            localOnUnrender(id, entityId)
        end,
    }
end

function UnregisterEntityType(entityType)
    RegisteredEntityTypes[entityType] = nil
end

function CreateClubNPC(pedId, coords, heading)
    local pedCfg = Config.Peds[pedId]
    local modelHash = `mp_m_freemode_01`
    if not pedCfg then 
        print("^1ERROR: No ped configuration found for: " .. pedId) 
    else 
        modelHash = pedCfg.model
    end
    local npc = CreateNPC(modelHash, coords.x, coords.y, coords.z, heading, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    return npc
end

local DialogContextCounter = 0

function StartClubPrompt(coords, heading, data)
    if not data or not data.dialog then return end
    -- Reset context counter for new prompt
    DialogContextCounter = 0
    CreateScriptedCamera()
    SetCamParams(CurrentCamera, coords.x, coords.y, coords.z + 0.5,
        0.0, 0.0, heading + 180.0, 90.0, 
        2000, 0, 0, 2
    )
    ShowDialogMenu(data.dialog)
end

function StopClubPrompt()
    ExitScriptedCamera()
    lib.hideContext()
end

function ShowDialogMenu(dialog, menuId)
    if not dialog then return end
    
    -- Call onStart callback if it exists
    if dialog.onStart then
        dialog.onStart()
    end
    
    DialogContextCounter = DialogContextCounter + 1
    local contextId = ('pickle_clubs_dialog_%s'):format(DialogContextCounter)
    local menuOptions = {}
    
    dialog.options = dialog.options or {}
    for i=1, #dialog.options do
        local option = dialog.options[i]
        local menuOption = {
            title = option.label,
            description = option.description or "",
            icon = option.icon,
        }
        
        -- If option has a nested dialog, create a submenu
        if option.dialog then
            menuOption.onSelect = function()
                -- Call option's onSelect callback if it exists before showing nested dialog
                if option.onSelect then
                    option.onSelect()
                end
                ShowDialogMenu(option.dialog, contextId)
            end
        else
            -- Leaf option - handle selection
            menuOption.onSelect = function()
                if option.onSelect then
                    option.onSelect()
                end
                -- If dialog should finish, close camera
                if dialog.finish then

                end
            end
        end
        
        table.insert(menuOptions, menuOption)
    end
    
    -- If dialog has finish=true and no options, add a default close option
    if dialog.finish then
        SetTimeout(2000, function()
            ExitScriptedCamera()
            lib.hideContext(contextId)
        end)
    end
    if dialog.speechSelect then
        dialog.speech = dialog.speechSelect()
    end
    -- Register and show context menu
    lib.registerContext({
        id = contextId,
        menu = menuId,
        title = dialog.speech or dialog.title or "Dialog",
        options = menuOptions
    })
    
    lib.showContext(contextId)
end

local function ToVector3(value, fallback)
    if type(value) == "vector3" then return value end
    if type(value) == "table" then
        local x = value.x or value[1]
        local y = value.y or value[2]
        local z = value.z or value[3]
        if x and y and z then
            return vector3(x, y, z)
        end
    end
    return fallback
end

local function CoordsDescription(coords)
    local v = ToVector3(coords, vector3(0.0, 0.0, 0.0))
    return ("%d, %d, %d"):format(math.floor(v.x), math.floor(v.y), math.floor(v.z))
end

local function GetEntityAnchor(entity, fallback)
    if not entity then return fallback end
    if entity.type == "bartender" and entity.bartender then
        return ToVector3(entity.bartender.coords, fallback)
    end
    if entity.type == "society" and entity.society then
        return ToVector3(entity.society.coords, fallback)
    end
    if entity.bouncer then
        return ToVector3(entity.bouncer.coords, fallback)
    end
    if entity.eject then
        return ToVector3(entity.eject.coords, fallback)
    end
    return fallback
end

local function ResolvePedModelForGizmo(pedId)
    local pedCfg = Config.Peds and Config.Peds[pedId]
    if pedCfg and pedCfg.model then
        return pedCfg.model
    end
    return `s_m_m_bouncer_01`
end

local function PlaceWithGizmo(initialCoords, initialHeading, data, isPed)
    local modelOverride = type(data) == "table" and data.model or data
    local gizmoData = {
        model = modelOverride or Config.Bartender.registerModel or `vw_prop_casino_till`,
        coords = initialCoords,
        rotation = vector3(0.0, 0.0, initialHeading or 0.0),
        enableCancel = true,
        isPed = isPed == true,
    }
    if type(data) == "table" then
        if data.coordsOffset then gizmoData.coordsOffset = data.coordsOffset end
        if data.rotationOffset then gizmoData.rotationOffset = data.rotationOffset end
    end
    local gizmo = StartGizmoEditor(gizmoData)
    if not gizmo or not gizmo.position then return nil, nil end
    return gizmo.position, (gizmo.rotation and gizmo.rotation.z) or (initialHeading or 0.0)
end

local function BuildBartenderEntityFromInput(baseEntity, defaultCoords, defaultHeading)
    local current = (baseEntity and baseEntity.bartender) or {}
    local startCoords = ToVector3(current.coords, defaultCoords)
    local startHeading = current.heading or defaultHeading or 0.0
    local coords, heading = PlaceWithGizmo(startCoords, startHeading)
    if not coords then return nil end

    local input = lib.inputDialog("Bartender Settings", {
        { type = "input", label = "Blip Name", default = (current.blip and current.blip.name) or "Bartending Station", required = true },
        { type = "input", label = "Blip Color", default = tostring((current.blip and current.blip.color) or 5), required = true },
        { type = "input", label = "Blip Sprite", default = tostring((current.blip and current.blip.sprite) or 52), required = true },
        { type = "input", label = "Blip Scale", default = tostring((current.blip and current.blip.scale) or 0.8), required = true },
        { type = "checkbox", label = "Blip Visible", checked = (current.blip and current.blip.visible) ~= false },
    })
    if not input then return nil end

    return {
        type = "bartender",
        bartender = {
            coords = coords,
            heading = heading,
            blip = {
                name = input[1],
                color = tonumber(input[2]) or 5,
                sprite = tonumber(input[3]) or 52,
                scale = tonumber(input[4]) or 0.8,
                visible = input[5] ~= false,
            },
        },
    }
end

local function BuildBouncerEntityFromInput(baseEntity, defaultCoords, defaultHeading)
    local current = (baseEntity and baseEntity.bouncer) or {}
    local startCoords = ToVector3(current.coords, defaultCoords)
    local startHeading = current.heading or defaultHeading or 0.0

    local input = lib.inputDialog("Bouncer Settings", {
        { type = "input", label = "Ped Config Id", description = "Config.Peds key (example: bouncer_1)", default = current.ped or "bouncer_1", required = true },
        { type = "checkbox", label = "VIP Mode", description = "Only VIP pass holders are allowed past this bouncer", checked = current.vipMode == true },
    })
    if not input then return nil end
    local pedId = input[1]

    local coords, heading = PlaceWithGizmo(startCoords, startHeading, ResolvePedModelForGizmo(pedId), true)
    if not coords then return nil end

    return {
        type = "bouncer",
        bouncer = {
            ped = pedId,
            coords = coords,
            heading = heading,
            vipMode = input[2] == true,
        },
    }
end

local function BuildSocietyEntityFromInput(baseEntity, defaultCoords, defaultHeading)
    local current = (baseEntity and baseEntity.society) or {}
    local startCoords = ToVector3(current.coords, defaultCoords)
    local startHeading = current.heading or defaultHeading or 0.0
    local coords, heading = PlaceWithGizmo(startCoords, startHeading, `prop_tennis_ball`, false)
    if not coords then return nil end

    return {
        type = "society",
        society = {
            coords = coords,
            heading = heading,
        },
    }
end

local function BuildClubEntryEntityFromInput(baseEntity, defaultCoords, defaultHeading)
    local currentBouncer = (baseEntity and baseEntity.bouncer) or {}
    local currentEject = (baseEntity and baseEntity.eject) or {}

    local input = lib.inputDialog("Club Entry Settings", {
        { type = "input", label = "Bouncer Ped Config Id", description = "Config.Peds key (example: bouncer_1)", default = currentBouncer.ped or "bouncer_1", required = true },
    })
    if not input then return nil end
    local pedId = input[1]

    local initialBouncerCoords = ToVector3(currentBouncer.coords, defaultCoords)
    local initialBouncerHeading = currentBouncer.heading or defaultHeading or 0.0
    local bouncerCoords, bouncerHeading = PlaceWithGizmo(initialBouncerCoords, initialBouncerHeading, ResolvePedModelForGizmo(pedId), true)
    if not bouncerCoords then return nil end

    local initialEjectCoords = ToVector3(currentEject.coords, bouncerCoords + vector3(0.0, -2.0, 0.0))
    local initialEjectHeading = currentEject.heading or bouncerHeading
    local ejectCoords, ejectHeading = PlaceWithGizmo(initialEjectCoords, initialEjectHeading, {
        model = `prop_ar_arrow_3`,
        coordsOffset = vector3(0.0, 0.0, 0.1),
        rotationOffset = vector3(90.0, 0.0, 90.0),
    }, false)
    if not ejectCoords then return nil end

    return {
        type = "club_entry",
        bouncer = {
            ped = pedId,
            coords = bouncerCoords,
            heading = bouncerHeading,
        },
        eject = {
            coords = ejectCoords,
            heading = ejectHeading,
        },
    }
end

function DeepCopy(value)
    if type(value) ~= "table" then return value end
    local output = {}
    for k, v in pairs(value) do
        output[k] = DeepCopy(v)
    end
    return output
end

local function BuildEntityPayload(entityType, baseEntity, club)
    local clubCoords = ToVector3(club and club.coords, GetEntityCoords(PlayerPedId()))
    local anchor = GetEntityAnchor(baseEntity, clubCoords)
    local defaultHeading = 0.0
    if baseEntity and baseEntity.bartender then defaultHeading = baseEntity.bartender.heading or defaultHeading end
    if baseEntity and baseEntity.bouncer then defaultHeading = baseEntity.bouncer.heading or defaultHeading end
    if baseEntity and baseEntity.eject then defaultHeading = baseEntity.eject.heading or defaultHeading end

    if baseEntity and baseEntity.society then defaultHeading = baseEntity.society.heading or defaultHeading end

    if entityType == "bartender" then
        return BuildBartenderEntityFromInput(baseEntity, anchor, defaultHeading)
    elseif entityType == "bouncer" then
        return BuildBouncerEntityFromInput(baseEntity, anchor, defaultHeading)
    elseif entityType == "club_entry" then
        return BuildClubEntryEntityFromInput(baseEntity, anchor, defaultHeading)
    elseif entityType == "society" then
        return BuildSocietyEntityFromInput(baseEntity, anchor, defaultHeading)
    end
    return nil
end

function UpdateBartenderPosition(entity, club)
    local current = entity.bartender or {}
    local startCoords = ToVector3(current.coords, club.coords)
    local startHeading = current.heading or 0.0
    local coords, heading = PlaceWithGizmo(startCoords, startHeading)
    if not coords then return nil end
    
    local updated = DeepCopy(entity)
    updated.bartender = updated.bartender or {}
    updated.bartender.coords = coords
    updated.bartender.heading = heading
    return updated
end

local function UpdateBartenderSettings(entity)
    local current = entity.bartender or {}
    local input = lib.inputDialog("Bartender Settings", {
        { type = "input", label = "Blip Name", default = (current.blip and current.blip.name) or "Bartending Station", required = true },
        { type = "input", label = "Blip Color", default = tostring((current.blip and current.blip.color) or 5), required = true },
        { type = "input", label = "Blip Sprite", default = tostring((current.blip and current.blip.sprite) or 52), required = true },
        { type = "input", label = "Blip Scale", default = tostring((current.blip and current.blip.scale) or 0.8), required = true },
        { type = "checkbox", label = "Blip Visible", checked = (current.blip and current.blip.visible) ~= false },
    })
    if not input then return nil end

    local updated = DeepCopy(entity)
    updated.bartender = updated.bartender or {}
    updated.bartender.blip = {
        name = input[1],
        color = tonumber(input[2]) or 5,
        sprite = tonumber(input[3]) or 52,
        scale = tonumber(input[4]) or 0.8,
        visible = input[5] ~= false,
    }
    return updated
end

function UpdateBouncerPosition(entity, club)
    local current = entity.bouncer or {}
    local startCoords = ToVector3(current.coords, club.coords)
    local startHeading = current.heading or 0.0
    local pedId = current.ped or "bouncer_1"
    local coords, heading = PlaceWithGizmo(startCoords, startHeading, ResolvePedModelForGizmo(pedId), true)
    if not coords then return nil end
    
    local updated = DeepCopy(entity)
    updated.bouncer = updated.bouncer or {}
    updated.bouncer.coords = coords
    updated.bouncer.heading = heading
    return updated
end

local function UpdateBouncerSettings(entity)
    local current = entity.bouncer or {}
    local input = lib.inputDialog("Bouncer Settings", {
        { type = "input", label = "Ped Config Id", description = "Config.Peds key (example: bouncer_1)", default = current.ped or "bouncer_1", required = true },
        { type = "checkbox", label = "VIP Mode", description = "Only VIP pass holders are allowed past this bouncer", checked = current.vipMode == true },
    })
    if not input then return nil end
    
    local updated = DeepCopy(entity)
    updated.bouncer = updated.bouncer or {}
    updated.bouncer.ped = input[1]
    updated.bouncer.vipMode = input[2] == true
    return updated
end

function UpdateClubEntryBouncerPosition(entity, club)
    local currentBouncer = entity.bouncer or {}
    local startCoords = ToVector3(currentBouncer.coords, club.coords)
    local startHeading = currentBouncer.heading or 0.0
    local pedId = currentBouncer.ped or "bouncer_1"
    local coords, heading = PlaceWithGizmo(startCoords, startHeading, ResolvePedModelForGizmo(pedId), true)
    if not coords then return nil end
    
    local updated = DeepCopy(entity)
    updated.bouncer = updated.bouncer or {}
    updated.bouncer.coords = coords
    updated.bouncer.heading = heading
    return updated
end

function UpdateSocietyPosition(entity, club)
    local current = entity.society or {}
    local startCoords = ToVector3(current.coords, club.coords)
    local startHeading = current.heading or 0.0
    local coords, heading = PlaceWithGizmo(startCoords, startHeading, `prop_tennis_ball`, false)
    if not coords then return nil end

    local updated = DeepCopy(entity)
    updated.society = updated.society or {}
    updated.society.coords = coords
    updated.society.heading = heading
    return updated
end

function UpdateClubEntryEjectPosition(entity, club)
    local currentEject = entity.eject or {}
    local currentBouncer = entity.bouncer or {}
    local startCoords = ToVector3(currentEject.coords, currentBouncer.coords and (currentBouncer.coords + vector3(0.0, -2.0, 0.0)) or club.coords)
    local startHeading = currentEject.heading or (currentBouncer.heading or 0.0)
    local coords, heading = PlaceWithGizmo(startCoords, startHeading, {
        model = `prop_ar_arrow_3`,
        coordsOffset = vector3(0.0, 0.0, 0.1),
        rotationOffset = vector3(90.0, 0.0, 90.0),
    }, false)
    if not coords then return nil end
    
    local updated = DeepCopy(entity)
    updated.eject = updated.eject or {}
    updated.eject.coords = coords
    updated.eject.heading = heading
    return updated
end

local function UpdateClubEntrySettings(entity)
    local currentBouncer = entity.bouncer or {}
    local input = lib.inputDialog("Club Entry Settings", {
        { type = "input", label = "Bouncer Ped Config Id", description = "Config.Peds key (example: bouncer_1)", default = currentBouncer.ped or "bouncer_1", required = true },
    })
    if not input then return nil end
    
    local updated = DeepCopy(entity)
    updated.bouncer = updated.bouncer or {}
    updated.bouncer.ped = input[1]
    return updated
end

local function EntityTitle(entityType)
    if entityType == "bartender" then return "Bartender" end
    if entityType == "bouncer" then return "Bouncer" end
    if entityType == "club_entry" then return "Club Entry" end
    if entityType == "society" then return "Management" end
    return entityType
end

function WithTemporarilyHiddenEntity(clubId, entityId, cb)
    local club = Clubs[clubId]
    if not club or not club.entities or not club.entities[entityId] then
        return cb()
    end
    local entity = club.entities[entityId]
    local reg = RegisteredEntityTypes[entity.type]
    if not reg then
        return cb()
    end
    local isRendered = LocalClubs[clubId] and LocalClubs[clubId].entities and LocalClubs[clubId].entities[entityId]
    if isRendered and reg.localOnUnrender then
        reg.localOnUnrender(clubId, entityId)
        LocalClubs[clubId].entities[entityId] = nil
    end

    local results = {cb()}

    if isRendered and reg.localOnRender then
        reg.localOnRender(clubId, entityId)
        LocalClubs[clubId].entities[entityId] = true
    end
    return table.unpack(results)
end

function OpenClubEntityMenu(clubId, entityId)
    local club = Clubs[clubId]
    if not club then return end
    local entity = club.entities[entityId]
    if not entity then return end

    local options = {}
    
    if entity.type == "bartender" then
        table.insert(options, {
            title = "Move Position",
            description = "Reposition the bartender station",
            onSelect = function()
                local payload = WithTemporarilyHiddenEntity(clubId, entityId, function()
                    return UpdateBartenderPosition(entity, club)
                end)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
        table.insert(options, {
            title = "Edit Settings",
            description = "Configure blip settings",
            onSelect = function()
                local payload = UpdateBartenderSettings(entity)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
    elseif entity.type == "bouncer" then
        table.insert(options, {
            title = "Move Position",
            description = "Reposition the bouncer",
            onSelect = function()
                local payload = WithTemporarilyHiddenEntity(clubId, entityId, function()
                    return UpdateBouncerPosition(entity, club)
                end)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
        table.insert(options, {
            title = "Edit Settings",
            description = "Change bouncer ped model",
            onSelect = function()
                local payload = UpdateBouncerSettings(entity)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
    elseif entity.type == "society" then
        table.insert(options, {
            title = "Move Position",
            description = "Reposition the management interaction point",
            onSelect = function()
                local payload = WithTemporarilyHiddenEntity(clubId, entityId, function()
                    return UpdateSocietyPosition(entity, club)
                end)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
    elseif entity.type == "club_entry" then
        table.insert(options, {
            title = "Move Bouncer Position",
            description = "Reposition the bouncer",
            onSelect = function()
                local payload = WithTemporarilyHiddenEntity(clubId, entityId, function()
                    return UpdateClubEntryBouncerPosition(entity, club)
                end)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
        table.insert(options, {
            title = "Move Eject Position",
            description = "Reposition where players are thrown out",
            onSelect = function()
                local payload = WithTemporarilyHiddenEntity(clubId, entityId, function()
                    return UpdateClubEntryEjectPosition(entity, club)
                end)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
        table.insert(options, {
            title = "Edit Settings",
            description = "Change bouncer ped model",
            onSelect = function()
                local payload = UpdateClubEntrySettings(entity)
                if payload then
                    TriggerServerEvent("pickle_clubs:updateClubEntity", clubId, entityId, payload)
                end
            end,
        })
    end

    table.insert(options, {
        title = "Delete Entity",
        description = "Remove this entity from the club",
        onSelect = function()
            lib.registerContext({
                id = ("club_entity_delete_%s_%s"):format(clubId, entityId),
                title = "Confirm Entity Delete",
                options = {
                    {
                        title = "Yes, Delete",
                        description = "This cannot be undone",
                        onSelect = function()
                            TriggerServerEvent("pickle_clubs:deleteClubEntity", clubId, entityId)
                        end
                    },
                    {
                        title = "Cancel",
                        onSelect = function() end
                    }
                },
            })
            lib.showContext(("club_entity_delete_%s_%s"):format(clubId, entityId))
        end,
    })

    lib.registerContext({
        id = ("club_entity_manage_%s_%s"):format(clubId, entityId),
        title = ("Entity %s (%s)"):format(entityId, entity.type),
        options = options,
    })
    lib.showContext(("club_entity_manage_%s_%s"):format(clubId, entityId))
end

local function OpenClubManageMenu(clubId)
    local club = Clubs[clubId]
    if not club then return end

    local options = {
        {
            title = "Edit Club Details",
            description = "Update club label/description",
            onSelect = function()
                local input = lib.inputDialog("Edit Club", {
                    { type = "input", label = "Label", default = club.label, required = true },
                    { type = "textarea", label = "Description", default = club.description or "", required = false },
                })
                if not input then return end
                TriggerServerEvent("pickle_clubs:updateClub", clubId, {
                    label = input[1],
                    description = input[2] or "",
                })
            end,
        },
        {
            title = "Move Club Center",
            description = "Set the club center used for render distance",
            onSelect = function()
                local gizmo = StartGizmoEditor({
                    model = Config.Bartender.registerModel or `vw_prop_casino_till`,
                    coords = club.coords,
                    rotation = vector3(0.0, 0.0, GetEntityHeading(PlayerPedId())),
                    enableCancel = true,
                })
                if gizmo and gizmo.position then
                    local p = gizmo.position
                    TriggerServerEvent("pickle_clubs:updateClub", clubId, { coords = { x = p.x, y = p.y, z = p.z } })
                end
            end,
        },
        {
            title = "Add Entity",
            description = "Create bartender, bouncer, or club entry entities",
            onSelect = function()
                local createOptions = {
                    {
                        title = "Add Bartender",
                        description = "Create a bartender station entity",
                        onSelect = function()
                            local payload = BuildEntityPayload("bartender", nil, club)
                            if payload then
                                TriggerServerEvent("pickle_clubs:createClubEntity", clubId, "bartender", payload)
                            end
                        end,
                    },
                    {
                        title = "Add Bouncer",
                        description = "Create a bouncer patrol entity",
                        onSelect = function()
                            local payload = BuildEntityPayload("bouncer", nil, club)
                            if payload then
                                TriggerServerEvent("pickle_clubs:createClubEntity", clubId, "bouncer", payload)
                            end
                        end,
                    },
                    {
                        title = "Add Club Entry",
                        description = "Create a queue+entry bouncer entity",
                        onSelect = function()
                            local payload = BuildEntityPayload("club_entry", nil, club)
                            if payload then
                                TriggerServerEvent("pickle_clubs:createClubEntity", clubId, "club_entry", payload)
                            end
                        end,
                    },
                    {
                        title = "Add Management",
                        description = "Create a management interaction point",
                        onSelect = function()
                            local payload = BuildEntityPayload("society", nil, club)
                            if payload then
                                TriggerServerEvent("pickle_clubs:createClubEntity", clubId, "society", payload)
                            end
                        end,
                    },
                }
                lib.registerContext({
                    id = ("club_add_entity_%s"):format(clubId),
                    title = ("Add Entity To Club #%s"):format(clubId),
                    options = createOptions,
                })
                lib.showContext(("club_add_entity_%s"):format(clubId))
            end,
        },
    }

    local entityOptions = {}
    local grouped = {
        bartender = {},
        bouncer = {},
        club_entry = {},
        society = {},
        other = {},
    }
    for listedEntityId, listedEntity in pairs(club.entities or {}) do
        local key = grouped[listedEntity.type] and listedEntity.type or "other"
        table.insert(grouped[key], {
            id = listedEntityId,
            data = listedEntity,
        })
    end
    local orderedTypes = {"bartender", "bouncer", "club_entry", "society", "other"}
    for i = 1, #orderedTypes do
        local entityType = orderedTypes[i]
        if #grouped[entityType] > 0 then
            table.sort(grouped[entityType], function(a, b) return tostring(a.id) < tostring(b.id) end)
            table.insert(entityOptions, {
                title = EntityTitle(entityType),
                description = "--------------------",
                disabled = true,
            })
            for j = 1, #grouped[entityType] do
                local item = grouped[entityType][j]
                table.insert(entityOptions, {
                    title = tostring(item.id),
                    description = ("Type: %s | Coords: %s"):format(EntityTitle(item.data.type), CoordsDescription(GetEntityAnchor(item.data, club.coords))),
                    onSelect = function()
                        OpenClubManagementNuiForEntity(clubId, item.id)
                    end,
                })
            end
        end
    end
    if #entityOptions > 0 then
        table.insert(options, {
            title = "Manage Entities",
            description = "Edit or remove existing entities",
            onSelect = function()
                lib.registerContext({
                    id = ("club_entities_%s"):format(clubId),
                    title = ("Club %s Entities"):format(clubId),
                    options = entityOptions,
                })
                lib.showContext(("club_entities_%s"):format(clubId))
            end,
        })
    end

    table.insert(options, {
        title = "Delete Club",
        description = "Delete club and all entities",
        onSelect = function()
            lib.registerContext({
                id = ("club_delete_confirm_%s"):format(clubId),
                title = "Confirm Club Delete",
                options = {
                    {
                        title = "Yes, Delete Club",
                        description = "Deletes all entities inside this club",
                        onSelect = function()
                            TriggerServerEvent("pickle_clubs:deleteClub", clubId)
                        end,
                    },
                    {
                        title = "Cancel",
                        onSelect = function() end,
                    }
                },
            })
            lib.showContext(("club_delete_confirm_%s"):format(clubId))
        end,
    })

    lib.registerContext({
        id = ("club_manage_%s"):format(clubId),
        title = ("Manage Club #%s"):format(clubId),
        options = options,
    })
    lib.showContext(("club_manage_%s"):format(clubId))
end

-- Opens the Club Management NUI (used by /clubs and pickle_clubs:openClubManagement).
function OpenClubManagementNui()
    lib.callback("pickle_clubs:checkIsAdmin", false, function(isAdmin)
        if not isAdmin then
            ShowNotification("You do not have permission to manage clubs.")
            return
        end
        ClubManagementNuiVisible = true
        ApplyClubManagementFocus(true)
        SendNUIMessage({
            type = "openClubManagement",
            clubs = SerializeClubsForNui(),
            flavors = Config.Bartender and Config.Bartender.flavors or {},
            peds = Config.Peds or {},
            defaultDrinks = Config.DefaultDrinks or {},
        })
    end)
end

-- Opens the Club Management NUI directly to a specific entity (used when "Manage" is clicked on bartender/bouncer/club_entry).
function OpenClubManagementNuiForEntity(clubId, entityId)
    lib.callback("pickle_clubs:checkIsAdmin", false, function(isAdmin)
        if not isAdmin then
            ShowNotification("You do not have permission to manage clubs.")
            return
        end
        ClubManagementNuiVisible = true
        ApplyClubManagementFocus(true)
        SendNUIMessage({
            type = "openClubManagement",
            clubs = SerializeClubsForNui(),
            flavors = Config.Bartender and Config.Bartender.flavors or {},
            clubId = clubId,
            entityId = entityId,
        })
    end)
end

-- Opens the ox_lib Club Management menu (Create New Club, Manage Existing Clubs).
function OpenClubManagement()
    lib.callback("pickle_clubs:checkIsAdmin", false, function(isAdmin)
        if not isAdmin then
            ShowNotification("You do not have permission to manage clubs.")
            return
        end

        local options = {
            {
                title = "Create New Club",
                description = "Create a club and set its center with gizmo",
                onSelect = function()
                    local input = lib.inputDialog("Create Club", {
                        { type = "input", label = "Label", required = true },
                        { type = "textarea", label = "Description", required = false },
                    })
                    if not input then return end
                    local gizmo = StartGizmoEditor({
                        model = Config.Bartender.registerModel or `vw_prop_casino_till`,
                        coords = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0,
                        rotation = vector3(0.0, 0.0, GetEntityHeading(PlayerPedId())),
                        enableCancel = true,
                    })
                    if not gizmo or not gizmo.position then return end
                    local p = gizmo.position
                    TriggerServerEvent("pickle_clubs:createClub", {
                        label = input[1],
                        description = input[2] or "",
                        coords = { x = p.x, y = p.y, z = p.z },
                    })
                end,
            }
        }

        local clubOptions = {}
        for clubId, club in pairs(Clubs) do
            table.insert(clubOptions, {
                title = ("#%s %s"):format(clubId, club.label),
                description = club.description or "",
                onSelect = function()
                    OpenClubManageMenu(clubId)
                end,
            })
        end

        if #clubOptions > 0 then
            table.insert(options, {
                title = "Manage Existing Clubs",
                description = "Open a club to edit entities and settings",
                onSelect = function()
                    lib.registerContext({
                        id = "club_manage_list",
                        title = "Clubs",
                        options = clubOptions,
                    })
                    lib.showContext("club_manage_list")
                end,
            })
        end

        lib.registerContext({
            id = "club_management_root",
            title = "Club Management",
            options = options,
        })
        lib.showContext("club_management_root")
    end)
end

CreateThread(function()
    while true do
        for k,v in pairs(Clubs) do
            local pcoords = GetEntityCoords(PlayerPedId())
            local dist = #(pcoords - v.coords)
            if dist <= Config.RenderDistance and not LocalClubs[k] then
                RenderClub(k)
            elseif LocalClubs[k] and dist > Config.RenderDistance then
                UnrenderClub(k)
            end
        end
        Wait(1500)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    Wait(1000)
    if resource == GetCurrentResourceName() then
        TriggerServerEvent("pickle_clubs:initializePlayer")
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k,v in pairs(Clubs) do
            UnregisterClub(k)
        end
    end
end)

RegisterNetEvent("pickle_clubs:syncClubs", function(id, data)
    if type(id) == "number" then
        if not data then return UnregisterClub(id) end
        RegisterClub(id, data)
    else 
        local data = id
        for k,v in pairs(Clubs) do
            UnregisterClub(k)
        end
        for k,v in pairs(data) do
            RegisterClub(k, v)
        end
    end

    if ClubManagementNuiVisible then
        SendNUIMessage({
            type = "updateClubManagement",
            clubs = SerializeClubsForNui(),
        })
    end
end)

RegisterNetEvent("pickle_clubs:openClubManagement", function()
    OpenClubManagementNui()
end)

AddEventHandler("pickle_clubs:openClubManagement", function()
    OpenClubManagementNui()
end)