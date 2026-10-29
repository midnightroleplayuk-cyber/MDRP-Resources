local ScriptEntities = {
    vehicles = {},
    peds = {},
    props = {}
}

function CreateVeh(modelHash, ...)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local veh = CreateVehicle(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    ScriptEntities["vehicles"][veh] = true
    return veh
end

function CreateNPC(modelHash, ...)
    if not IsModelInCdimage(modelHash) then return CreateNPC(`a_m_m_skater_01`, ...) end
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end
    local ped = CreatePed(26, modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    ScriptEntities["peds"][ped] = true
    return ped
end

function CreateProp(modelHash, ...)
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 1000 do
        Wait(0)
        timeout = timeout + 1
    end
    -- If the intended model never streamed in, fall back to a visible placeholder
    -- rather than an invisible/mismeasured entity. (Measurement elsewhere uses the
    -- intended model hash directly, so this substitution can't distort stacking.)
    if not HasModelLoaded(modelHash) then
        return CreateProp(`ch_prop_fingerprint_scanner_error_01b`, ...)
    end
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    ScriptEntities["props"][obj] = true
    return obj
end

function CreateTennisBall(...)
    local ball = CreateObject(`prop_tennis_ball`, ...)
    SetEntityAlpha(ball, 0, false)
    FreezeEntityPosition(ball, true)
    SetEntityCollision(ball, false, false)
    SetEntityVisible(ball, false, false)
    return ball
end

function PlayAnim(ped, dict, ...)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    TaskPlayAnim(ped, dict, ...)
end

function PlayEffect(dict, particleName, entity, off, rot, time, cb)
    CreateThread(function()
        RequestNamedPtfxAsset(dict)
        while not HasNamedPtfxAssetLoaded(dict) do
            Wait(0)
        end
        UseParticleFxAssetNextCall(dict)
        Wait(10)
        local particleHandle = StartParticleFxLoopedOnEntity(particleName, entity, off.x, off.y, off.z, rot.x, rot.y, rot.z, 1.0)
        SetParticleFxLoopedColour(particleHandle, 0, 255, 0 , 0)
        Wait(time)
        StopParticleFxLooped(particleHandle, false)
        cb()
    end)
end

function CreateBlip(data)
    local x,y,z = table.unpack(data.coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, data.display or 4)
    if (data.category) then 
        SetBlipCategory(blip, data.category)
    end
    SetBlipScale(blip, data.scale or 0.85)
    SetBlipColour(blip, data.color or 1)
    if (data.rotation) then 
        SetBlipRotation(blip, math.ceil(data.rotation))
    end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.label or _L("blip_unknown"))
    EndTextCommandSetBlipName(blip)
    if (data.radius) then
        local radiusBlip = AddBlipForRadius(x, y, z, data.radius.size)
        SetBlipColour(radiusBlip, data.radius.color or data.color)
        SetBlipAlpha(radiusBlip, data.radius.alpha or 127)
        SetBlipHighDetail(radiusBlip, true)
        return blip, radiusBlip
    end
    return blip
end

local interactTick = 0
local interactCheck = false
local interactText = nil

function ShowInteractText(text)
    interactTick = GetGameTimer()
    if interactText ~= text then
        interactText = text
        SendNUIMessage({ type = "setInteractText", text = text })
    end
    if interactCheck then return end
    interactCheck = true
    CreateThread(function()
        -- Stay open while ShowInteractText keeps being called each frame; only
        -- hide once it has stopped ticking for >150ms. Comparing the *last call*
        -- time (interactTick) against now — rather than re-reading the clock and
        -- comparing it to itself — is what stops the open/close flicker during
        -- continuous calls such as object placement.
        while true do
            Wait(150)
            if GetGameTimer() - interactTick >= 150 then
                interactCheck = false
                interactText  = nil
                interactTick  = 0
                SendNUIMessage({ type = "setInteractText", text = nil })
                return
            end
        end
    end)
end


local Interactions = {}
EnableInteraction = true

function FormatOptions(index, data)
    local options = data.options
    local list = {}
    if not options or #options < 2 then
        list[1] = ((options and options[1]) and options[1] or { label = data.label })
        list[1].name = GetCurrentResourceName() .. "_option_" .. math.random(1,999999999)
        list[1].onSelect = function(data)
            SelectInteraction(index, 1, data)
        end
        return list
    end
    for i=1, #options do
        list[i] = options[i] 
        list[i].name = GetCurrentResourceName() .. "_option_" .. math.random(1,999999999)
        list[i].onSelect = function(data)
            SelectInteraction(index, i, data)
        end
    end
    return list
end

function EnsureInteractionModel(index)
    local data = Interactions[index] 
    if not data or data.entity then return end
    local entity
    if not data.model and not data.hiddenKeypress and Config.UseTarget and Config.NoModelTargeting then 
        entity = CreateProp(`ng_proc_brick_01a`, data.coords.x, data.coords.y, data.coords.z, false, true, false)
        SetEntityAlpha(entity, 0, false)
    elseif data.model and (not data.model.modelType or data.model.modelType == "ped") then
        local offset = data.model.offset or vector3(0.0, 0.0, 0.0)
        entity = CreateNPC(data.model.hash, data.coords.x + offset.x, data.coords.y + offset.y, (data.coords.z - 1.0) + offset.z, data.rotation.z, false, true)
        SetEntityInvincible(entity, true)
        SetBlockingOfNonTemporaryEvents(entity, true)
        if data.model.animation then
            PlayAnim(entity, data.model.animation.dict, data.model.animation.name, 8.0, -8.0, -1, 1, 0, 0, 0, 0)
        end
    elseif data.model and data.model.modelType == "prop" then
        local offset = data.model.offset or vector3(0.0, 0.0, 0.0)
        entity = CreateProp(data.model.hash, data.coords.x + offset.x, data.coords.y + offset.y, (data.coords.z - 1.0) + offset.z, false, true, false)
    else
        return
    end
    FreezeEntityPosition(entity, true)
    SetEntityRotation(entity, data.rotation.x, data.rotation.y, data.rotation.z, 2, true)
    Interactions[index].entity = entity
    return entity
end

function IsEntityScriptObject(entity)
    for k,v in pairs(ScriptEntities) do 
        if ScriptEntities[k][entity] then 
            return true
        end
    end
    return false
end

function DeleteScriptObject(entity)
    DeleteEntity(entity)
    for k,v in pairs(ScriptEntities) do 
        if ScriptEntities[k][entity] then 
            ScriptEntities[k][entity] = nil
        end
    end
end

function DeleteInteractionEntity(index)
    local data = Interactions[index] 
    if not data or not data.entity then return end
    DeleteScriptObject(data.entity)
    Interactions[index].entity = nil
end

function SelectInteraction(index, selection, targetData)
    if not EnableInteraction then return end
    local pcoords = GetEntityCoords(PlayerPedId())
    local data = Interactions[index]
    if not data then return end
    if not data.target and not data.targetPed and #(data.coords - pcoords) > (data.interactRadius and data.interactRadius or Config.InteractDistance) then
        return ShowNotification(_L("interact_far"))
    end
    Interactions[index].selected(selection, targetData)
end

function CreateInteraction(data, selected)
    local index
    repeat
        index = math.random(1, 999999999)
    until not Interactions[index]
    local options = FormatOptions(index, data)
    Interactions[index] = {
        selected = selected,
        options = options,
        icon = data.icon,
        label = data.label,
        model = data.model,
        coords = data.coords,
        zOffset = data.zOffset or 0,
        target = data.target,
        offset = data.offset,
        radius = data.radius or 1.0,
        interactRadius = data.interactRadius or Config.InteractDistance,
        distance = data.distance or Config.InteractDistance,
        rotation = data.rotation or vector3(0.0, 0.0, data.heading or 0.0),
        vehicleInteract = data.vehicleInteract,
        hiddenKeypress = data.hiddenKeypress
    }
    local pcoords = GetEntityCoords(PlayerPedId())
    if data.coords then
        local dist = #(pcoords-data.coords)
        if (dist < Config.RenderDistance) then 
            EnsureInteractionModel(index)
        end
    end
    if Config.UseTarget and not data.vehicleInteract then
        if data.targetPed then
            Interactions[index].targetPed = data.targetPed
            AddTargetPed(data.targetPed, Interactions[index].options, Interactions[index].icon)
        elseif data.target then
            AddTargetModel(data.target, Interactions[index].radius, Interactions[index].options, Interactions[index].icon)
        else
            Interactions[index].zone = AddTargetZone(Interactions[index].coords - vector3(0.0, 0.0, Interactions[index].zOffset), Interactions[index].radius, Interactions[index].options, Interactions[index].icon, Interactions[index].distance)
        end
    end
    return index
end

function DeleteInteraction(index)
    local data = Interactions[index] 
    if not data then return end
    if (data.entity) then 
        DeleteInteractionEntity(index)
    end
    if Config.UseTarget then
        if data.targetPed then
            RemoveTargetPed(data.targetPed, data.options)
        elseif data.target then
            RemoveTargetModel(data.target, data.options)
        else
            RemoveTargetZone(data.zone)
        end
    end
    Interactions[index] = nil
end

function GetPositiveRotation(rot)
    if rot < 0 then 
        return GetPositiveRotation(rot + 360.0)
    elseif rot > 360 then 
        return GetPositiveRotation(rot - 360.0)
    else
        return rot
    end
end

function GetClampedHeading(heading, heading2)
    local heading, rotZ = GetPositiveRotation(heading), GetPositiveRotation(heading2)
    local diff = GetPositiveRotation(heading - rotZ) 
    if diff > 90 and diff < 270 then 
        local a = math.abs(diff - 90)
        local b = math.abs(diff - 270)
        if a < b then 
            rotZ = nil
        elseif b < a then
            rotZ = nil
        end
    else
        rotZ = heading2
    end
    return rotZ
end

function IsPlayerAlive()
    local health = GetEntityHealth(PlayerPedId())
    return health > 0
end

CreateThread(function()
    while true do 
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        local wait = 1500
        local closestInteraction = {id = nil, dist = nil}
        local inVehicle = GetVehiclePedIsIn(ped, false) ~= 0
        for k,v in pairs(Interactions) do 
            local coords = v.coords
            if coords then
                local dist = #(pcoords-coords)
                if (dist < Config.RenderDistance) then 
                    EnsureInteractionModel(k)
                    if not Config.UseTarget or v.hiddenKeypress or v.vehicleInteract then
                        if not Config.UseTarget and not v.hiddenKeypress and not v.vehicleInteract and not v.model and Config.Marker and Config.Marker.enabled then
                            wait = 0
                            DrawMarker(Config.Marker.id, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                            Config.Marker.scale, Config.Marker.scale, Config.Marker.scale, Config.Marker.color[1], 
                            Config.Marker.color[2], Config.Marker.color[3], Confirestaurantslor[4], false, true)
                        end
                        if dist < (v.interactRadius and v.interactRadius or Config.InteractDistance) and (not closestInteraction.id or closestInteraction.dist > dist) then
                            local allow = true
                            if inVehicle and not v.vehicleInteract then
                                allow = false
                            elseif not inVehicle and v.vehicleInteract then
                                allow = false
                            end
                            if allow then
                                closestInteraction.id = k
                                closestInteraction.dist = dist
                            end
                        end
                    end
                elseif v.entity then
                    DeleteInteractionEntity(k)
                end
            elseif not Config.UseTarget and v.target then
                local entity = GetNearestEntityModel(v.target)
                if entity then
                    local offset = v.offset or vector3(0.0, 0.0, 0.0)
                    local coords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
                    local dist = #(pcoords-coords)
                    if dist < v.distance and (not closestInteraction.id or closestInteraction.dist > dist) then
                        local allow = true
                        if inVehicle and not v.vehicleInteract then
                            allow = false
                        end
                        if allow then
                            closestInteraction.id = k
                            closestInteraction.dist = dist
                        end
                    end
                end
            end
        end
        if closestInteraction.id then
            local k = closestInteraction.id
            local v = Interactions[closestInteraction.id]
            wait = 0 
            if v.target then
                if not ShowInteractText("[E] - " .. v.label) and IsControlJustPressed(1, 51) then
                    if not v.options or #v.options < 2 then 
                        SelectInteraction(k, 1, {entity = entity, coords = coords, dist = dist})
                    else 
                        lib.registerContext({
                            id = 'restaurants_'..k,
                            title = v.title or _L("interact_options"),
                            options = v.options
                        })
                        lib.showContext('restaurants_'..k)
                    end
                end
            else
                if not ShowInteractText("[E] - " .. v.label) and IsControlJustPressed(1, 51) then
                    if not v.options or #v.options < 2 then 
                        SelectInteraction(k, 1)
                    else 
                        lib.registerContext({
                            id = 'restaurants_'..k,
                            title = v.title or _L("interact_options"),
                            options = v.options
                        })
                        lib.showContext('restaurants_'..k)
                    end
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for k,v in pairs(Interactions) do
        DeleteInteraction(k)
    end
    -- Delete every prop/veh/ped this resource spawned. Local (non-mission)
    -- objects won't honour DeleteEntity during shutdown unless we claim them as
    -- a mission entity first, so flag then delete.
    for _, category in pairs(ScriptEntities) do
        for entity in pairs(category) do
            if DoesEntityExist(entity) then
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
            end
        end
    end
end)
-- ─── the pause menu, shoved closed ───────────────────────────────────────────
-- Every view here that owns the screen (a panel, an in-world DUI, the placement
-- gizmo, a seat) keeps the pause menu out while it is up. They all used to do it the
-- same way, and that way was WRONG in a way that could cost a player their game:
--
--     SetFrontendActive(false)
--     ActivateFrontendMenu(`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`, true, -1)
--
-- The second line does not "keep it shut" — it OPENS a pause menu, an empty one, with
-- the game paused and the frontend cursor drawn. That trick exists for scripts that
-- want the pause cursor on purpose; here it meant every shove replaced a real pause
-- menu with a contentless one, and the moment the loop doing the shoving stopped
-- (the view had just closed — which is exactly when the last shove happens) the
-- player was left staring at a frontend cursor over a paused game with no menu to
-- back out of. Nothing in-game can dismiss it: that is the "I had to reboot" bug.
--
-- Deactivating is the whole job, so this does only that. NEVER re-introduce an
-- ActivateFrontendMenu here or at a call site.
--
-- PRE-EMPT, DON'T UNDO. Closing a pause menu that has already opened plays its
-- transition — the screen dims and comes back — which is the "slight fade on exit"
-- that closing-after-the-fact can never avoid, however fast the loop reacts.
-- `SetPauseMenuActive(false)` every frame is the cheap prevention: the menu never
-- starts, so there is no transition to sit through. `IsPauseMenuActive()` only
-- answers once the menu is fully up, by which point the fade has already played, so
-- the recovery below tests `GetPauseMenuState()` as well and catches one mid-open.
function ForcePauseMenuClosed()
    SetPauseMenuActive(false)
    if IsPauseMenuActive() or GetPauseMenuState() ~= 0 then
        SetFrontendActive(false)
    end
end
