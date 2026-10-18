
local Target = require 'client.modules.target'
local Utils = require 'client.modules.utils'

local Launder = {
    inside = false,
    spawned = {},
    cache = {},
    entryPed = nil,
    placing = false,
    ghost = nil,
}

local function cfg()
    local job = lib.load('jobs.money_laundering.config')
    return job and job.lab or {}
end

local function toVec3(c)
    if not c then return nil end
    if type(c) == 'vector3' then return c end
    local x = tonumber(c.x)
    local y = tonumber(c.y)
    local z = tonumber(c.z)
    if not x or not y or not z then return nil end
    return vector3(x, y, z)
end

local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if hash == 0 then return nil end
    if not IsModelValid(hash) and not IsModelInCdimage(hash) then
        return nil
    end
    if HasModelLoaded(hash) then return hash end
    RequestModel(hash)
    local deadline = GetGameTimer() + 5000
    while not HasModelLoaded(hash) do
        if GetGameTimer() > deadline then return nil end
        Wait(0)
    end
    return hash
end

local function resolvePropModel(prop)
    local lab = cfg()
    local eq = prop and prop.item_key and (lab.equipment or {})[prop.item_key]
    return (eq and eq.model) or (prop and prop.model)
end

local function spawnPed(model, coords)
    local hash = loadModel(model)
    if not hash then return nil end
    local ped = CreatePed(0, hash, coords.x, coords.y, coords.z - 1.0, coords.w or 0.0, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetModelAsNoLongerNeeded(hash)
    return ped
end

local function fadeTeleport(coords)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, coords.w or 0.0)
    Wait(300)
    DoScreenFadeIn(500)
end

local function openFocusUi()
    SetNuiFocus(true, true)
end

local function enterLab()
    if Launder.inside then return end
    local lab = cfg()
    Launder.outside = GetEntityCoords(cache.ped)
    if lab.ipl and lab.ipl ~= '' then RequestIpl(lab.ipl) end
    fadeTeleport(lab.interior)
    Launder.inside = true
    TriggerServerEvent(_e('server:launder:requestSync'))
end

local function exitLab()
    if not Launder.inside then return end
    local lab = cfg()
    local dest = lab.entry.coords
    if Launder.outside then
        dest = vec4(Launder.outside.x, Launder.outside.y, Launder.outside.z, dest.w)
    end
    fadeTeleport(dest)
    Launder.inside = false
end

local function openUnitPanel(propId)
    propId = tonumber(propId)
    local prop = (Launder.spawned[propId] and Launder.spawned[propId].data)
        or Launder.cache[propId]
    if not prop then return end
    local lab = cfg()
    SendNUIMessage({
        action = 'launderOpenUnit',
        data = {
            prop = prop,
            chemicals = lab.chemicals,
            maintenance = lab.maintenance,
            equipment = (lab.equipment or {})[prop.item_key],
        },
    })
    openFocusUi()
end

local function despawnProp(id)
    local entry = Launder.spawned[id]
    if not entry then return end
    if entry.entity and DoesEntityExist(entry.entity) then
        Target.removeLocalEntity(entry.entity)
        DeleteEntity(entry.entity)
    end
    Launder.spawned[id] = nil
end

local function attachTargets(entity, prop)
    Target.addLocalEntity(entity, {
        {
            name = 'ij_launder_panel_' .. prop.id,
            icon = 'fas fa-sliders',
            label = 'Open Control Panel',
            distance = 2.5,
            onSelect = function()
                openUnitPanel(prop.id)
            end,
        },
        {
            name = 'ij_launder_pickup_' .. prop.id,
            icon = 'fas fa-box',
            label = 'Pack Equipment',
            distance = 2.5,
            onSelect = function()
                TriggerServerEvent(_e('server:launder:unitAction'), {
                    propId = prop.id,
                    action = 'pickup',
                })
            end,
        },
    })
end

local function spawnProp(prop)
    if not prop or not prop.id then return end
    despawnProp(prop.id)
    local modelName = resolvePropModel(prop)
    local hash = loadModel(modelName)
    if not hash then
        Utils.notify('Launder Lab', 'error', nil, ('Failed to load model: %s'):format(tostring(modelName)))
        return
    end
    local c = toVec3(prop.coords)
    if not c then return end
    local obj = CreateObjectNoOffset(hash, c.x, c.y, c.z, false, false, false)
    SetEntityHeading(obj, prop.heading or 0.0)
    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetEntityCollision(obj, true, true)
    SetModelAsNoLongerNeeded(hash)
    Launder.spawned[prop.id] = { entity = obj, data = prop }
    attachTargets(obj, prop)
end

local function stopPlacement()
    Launder.placing = false
    Launder.placeItem = nil
    if Launder.ghost and DoesEntityExist(Launder.ghost) then
        DeleteEntity(Launder.ghost)
    end
    Launder.ghost = nil
end

local function rotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function raycastFromCamera(maxDist)
    local camCoord = GetGameplayCamCoord()
    local dir = rotationToDirection(GetGameplayCamRot(2))
    local dest = camCoord + (dir * maxDist)
    -- Synchronous LOS probe avoids one-frame lag from async shape tests
    local handle = StartExpensiveSynchronousShapeTestLosProbe(
        camCoord.x, camCoord.y, camCoord.z,
        dest.x, dest.y, dest.z,
        511, cache.ped, 7
    )
    local _, hit, endCoords = GetShapeTestResult(handle)
    if hit == 1 then
        return true, endCoords
    end
    -- fallback: keep aim projection Z (no ground snap)
    return true, dest
end

function Launder.startPlacement(itemKey)
    local lab = cfg()
    local eq = (lab.equipment or {})[itemKey]
    if not eq then
        Utils.notify('Launder Lab', 'error', nil, 'Unknown equipment.')
        return
    end
    if Launder.placing then stopPlacement() end

    CreateThread(function()
        local hash = loadModel(eq.model)
        if not hash then
            Utils.notify('Launder Lab', 'error', nil, ('Model failed to load: %s'):format(eq.model))
            return
        end

        Launder.placing = true
        Launder.placeItem = itemKey
        local heading = GetEntityHeading(cache.ped)
        local pedCoords = GetEntityCoords(cache.ped)
        Launder.ghost = CreateObjectNoOffset(hash, pedCoords.x, pedCoords.y, pedCoords.z, false, false, false)
        SetEntityAlpha(Launder.ghost, 150, false)
        SetEntityCollision(Launder.ghost, false, false)
        FreezeEntityPosition(Launder.ghost, true)

        local placeCfg = lab.placement or {}
        local lastPos = pedCoords

        while Launder.placing do
            Wait(0)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)

            local hit, endCoords = raycastFromCamera(placeCfg.maxDistance or 10.0)
            if endCoords and Launder.ghost and DoesEntityExist(Launder.ghost) then
                local z = endCoords.z + (placeCfg.groundOffset or 0.0)
                SetEntityCoordsNoOffset(Launder.ghost, endCoords.x, endCoords.y, z, false, false, false)
                SetEntityHeading(Launder.ghost, heading)
                lastPos = vector3(endCoords.x, endCoords.y, z)
                Utils.drawText3D(lastPos + vector3(0.0, 0.0, 0.95), '[E] Place   [G] Cancel   [SCROLL] Rotate')
            end

            if IsDisabledControlJustPressed(0, 14) or IsControlJustPressed(0, 14) then
                heading = (heading + (placeCfg.rotateStep or 5.0)) % 360.0
            elseif IsDisabledControlJustPressed(0, 15) or IsControlJustPressed(0, 15) then
                heading = (heading - (placeCfg.rotateStep or 5.0)) % 360.0
            end

            if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                if lastPos then
                    TriggerServerEvent(_e('server:launder:placeProp'), {
                        itemKey = Launder.placeItem,
                        coords = { x = lastPos.x, y = lastPos.y, z = lastPos.z },
                        heading = heading,
                    })
                end
                stopPlacement()
            elseif IsControlJustPressed(0, 47) or IsDisabledControlJustPressed(0, 47) then
                stopPlacement()
                Utils.notify('Launder Lab', 'inform', nil, 'Placement cancelled.')
            end
        end

        SetModelAsNoLongerNeeded(hash)
    end)
end

function Launder.init()
    local lab = cfg()

    if lab.entry.enablePed ~= false then
        Launder.entryPed = spawnPed(lab.entry.ped, lab.entry.coords)
        if Launder.entryPed then
            Target.addLocalEntity(Launder.entryPed, {
                {
                    name = 'ij_launder_enter',
                    icon = 'fas fa-door-open',
                    label = lab.entry.label or 'Enter Laundering Lab',
                    distance = 2.5,
                    onSelect = function()
                        local Dialogue = require 'client.modules.dialogue'
                        if not Dialogue.confirm(
                            Launder.entryPed,
                            'Looking to wash some paper?',
                            lab.entry.label or 'Enter lab',
                            'No thanks'
                        ) then
                            return
                        end
                        enterLab()
                    end,
                },
            })
        end
    end

    if lab.entry.enableBlip ~= false then
        -- Blip for lab entry
        local blip = AddBlipForCoord(lab.entry.coords.x, lab.entry.coords.y, lab.entry.coords.z)
        SetBlipSprite(blip, 500)
        SetBlipColour(blip, 2)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Money Laundering Lab')
        EndTextCommandSetBlipName(blip)
        Launder.entryBlip = blip
    end

    CreateThread(function()
        local exitCfg = lab.exit or {}
        local exitPos = exitCfg.coords or lab.interior
        local exitCoords = vector3(exitPos.x + 0.0, exitPos.y + 0.0, exitPos.z + 0.0)
        local exitLabel = exitCfg.label or 'Exit Lab'
        while true do
            local sleep = 1000
            if Launder.inside then
                local coords = GetEntityCoords(cache.ped)
                local d = #(coords - exitCoords)
                if d < 15.0 then
                    sleep = 0
                    Utils.drawText3D(exitCoords + vector3(0.0, 0.0, 1.0), '[E] ' .. exitLabel)
                    if d < 2.0 and IsControlJustReleased(0, 38) then
                        exitLab()
                    end
                end
            end
            Wait(sleep)
        end
    end)

    CreateThread(function()
        while true do
            Wait(2000)
            local pcoords = GetEntityCoords(cache.ped)
            for id, prop in pairs(Launder.cache) do
                local c = toVec3(prop.coords)
                if c then
                    local d = #(pcoords - c)
                    if d <= (lab.propSpawnRadius or 50.0) then
                        if not Launder.spawned[id] then spawnProp(prop) end
                    elseif d >= (lab.propDespawnRadius or 60.0) then
                        despawnProp(id)
                    end
                end
            end
        end
    end)
end

RegisterNetEvent(_e('client:launder:startPlacement'), function(itemKey)
    Launder.startPlacement(itemKey)
end)

RegisterNetEvent(_e('client:launder:syncProps'), function(props, fullReplace)
    props = props or {}
    local lab = cfg()
    if fullReplace then
        for id in pairs(Launder.spawned) do despawnProp(id) end
        Launder.cache = {}
    end
    local pcoords = GetEntityCoords(cache.ped)
    for i = 1, #props do
        local prop = props[i]
        Launder.cache[prop.id] = prop
        SendNUIMessage({ action = 'launderSyncProp', data = { prop = prop } })
        local c = toVec3(prop.coords)
        local d = c and #(pcoords - c) or 9999.0
        if d <= (lab.propSpawnRadius or 50.0) then
            local existing = Launder.spawned[prop.id]
            if existing and existing.entity and DoesEntityExist(existing.entity) then
                existing.data = prop
                Target.removeLocalEntity(existing.entity)
                attachTargets(existing.entity, prop)
            else
                spawnProp(prop)
            end
        else
            despawnProp(prop.id)
        end
    end
end)

RegisterNetEvent(_e('client:launder:removeProp'), function(id)
    id = tonumber(id)
    Launder.cache[id] = nil
    despawnProp(id)
    SendNUIMessage({ action = 'launderPropsRemoved', data = { id = id } })
end)

RegisterNetEvent(_e('client:launder:syncPropNui'), function(prop)
    if prop and prop.id then
        Launder.cache[prop.id] = prop
        if Launder.spawned[prop.id] then Launder.spawned[prop.id].data = prop end
    end
    SendNUIMessage({ action = 'launderSyncProp', data = { prop = prop } })
end)

RegisterNetEvent(_e('client:launder:openMonitor'), function(props)
    SendNUIMessage({ action = 'launderOpenMonitor', data = { props = props } })
    openFocusUi()
end)

RegisterNetEvent(_e('client:launder:dashboard'), function(data)
    SendNUIMessage({ action = 'launderDashboard', data = data })
end)

-- NUI callbacks for lab overlays / app
RegisterNUICallback('launderCloseUi', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'launderCloseUi' })
    cb({ ok = true })
end)

RegisterNUICallback('launderUnitAction', function(data, cb)
    TriggerServerEvent(_e('server:launder:unitAction'), {
        propId = data.propId,
        action = data.action,
        payload = data.payload or data,
    })
    cb({ ok = true })
end)

RegisterNUICallback('launderSaveConnections', function(data, cb)
    TriggerServerEvent(_e('server:launder:saveConnections'), data.connections or {})
    cb({ ok = true })
end)

RegisterNUICallback('launderRequestMonitor', function(_, cb)
    TriggerServerEvent(_e('server:launder:requestMonitor'))
    cb({ ok = true })
end)

RegisterNUICallback('launderRequestDashboard', function(_, cb)
    TriggerServerEvent(_e('server:launder:requestDashboard'))
    cb({ ok = true })
end)

RegisterNUICallback('launderSetWaypoint', function(_, cb)
    local lab = cfg()
    local c = lab.entry.coords
    SetNewWaypoint(c.x, c.y)
    cb({ ok = true })
end)

exports('startLaunderPlacement', function(itemKey)
    Launder.startPlacement(itemKey)
end)

exports('usePlaceable', function(data, slot)
    local name = (data and data.name) or (slot and slot.name)
    if name then Launder.startPlacement(name) end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= shared.resource then return end
    stopPlacement()
    for id in pairs(Launder.spawned) do despawnProp(id) end
    if Launder.entryPed and DoesEntityExist(Launder.entryPed) then
        Target.removeLocalEntity(Launder.entryPed)
        DeleteEntity(Launder.entryPed)
    end
    if Launder.entryBlip then RemoveBlip(Launder.entryBlip) end
end)

return Launder
