local spawned = {}
local uiOpen = false

local function deleteSpawned()
    for id, entity in pairs(spawned) do
        if DoesEntityExist(entity) then
            exports.ox_target:removeLocalEntity(entity, ('hf1_scratchcard_stand_%s'):format(id))
            DeleteEntity(entity)
        end
    end
    spawned = {}
end

local function openShop(standId)
    lib.registerContext({
        id = 'hf1_scratchcard_shop',
        title = 'Midnight Scratchcards',
        options = {
            {
                title = ('Buy Scratchcard — £%s'):format(Config.CardPrice),
                description = 'Receive a physical scratchcard. Match three symbols and/or reveal the crossed fingers for an extra £2,000.',
                icon = 'ticket',
                onSelect = function()
                    TriggerServerEvent('hf1_scratchcard:server:buyCard', standId)
                end
            },
            {
                title = 'Claim Winnings',
                description = 'Check the scratchcards in your inventory and redeem a winning card.',
                icon = 'sterling-sign',
                onSelect = function()
                    TriggerServerEvent('hf1_scratchcard:server:claimWinnings', standId)
                end
            }
        }
    })
    lib.showContext('hf1_scratchcard_shop')
end

local function spawnStand(stand)
    local model = Config.PropModel
    lib.requestModel(model, 10000)
    local obj = CreateObjectNoOffset(model, stand.x, stand.y, stand.z, false, false, false)
    SetEntityHeading(obj, stand.h + 0.0)
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
    SetModelAsNoLongerNeeded(model)

    spawned[stand.id] = obj
    exports.ox_target:addLocalEntity(obj, {{
        name = ('hf1_scratchcard_stand_%s'):format(stand.id),
        icon = 'fa-solid fa-ticket',
        label = 'Midnight Scratchcards',
        distance = Config.TargetDistance,
        onSelect = function() openShop(stand.id) end
    }})
end

RegisterNetEvent('hf1_scratchcard:client:setStands', function(stands)
    deleteSpawned()
    for _, stand in ipairs(stands or {}) do spawnStand(stand) end
end)

local placementActive = false

local function rotationToDirection(rotation)
    local rz = math.rad(rotation.z)
    local rx = math.rad(rotation.x)
    local cosX = math.abs(math.cos(rx))
    return vector3(-math.sin(rz) * cosX, math.cos(rz) * cosX, math.sin(rx))
end

local function cameraRaycast(distance, ignoreEntity)
    local camPos = GetGameplayCamCoord()
    local direction = rotationToDirection(GetGameplayCamRot(2))
    local destination = camPos + (direction * distance)
    local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, destination.x, destination.y, destination.z, -1, ignoreEntity or PlayerPedId(), 0)
    local _, hit, endCoords = GetShapeTestResult(ray)
    if hit == 1 then return endCoords end
    return destination
end

local function startStandPlacement()
    if placementActive then return end
    placementActive = true

    CreateThread(function()
        local ped = PlayerPedId()
        local model = Config.PropModel
        lib.requestModel(model, 10000)

        local startCoords = GetEntityCoords(ped) + (GetEntityForwardVector(ped) * (Config.PlaceDistance or 2.0))
        local preview = CreateObjectNoOffset(model, startCoords.x, startCoords.y, startCoords.z, false, false, false)
        if not DoesEntityExist(preview) then
            placementActive = false
            lib.notify({ description = 'Could not create the scratchcard stand preview.', type = 'error' })
            return
        end

        SetEntityAlpha(preview, 180, false)
        SetEntityCollision(preview, false, false)
        FreezeEntityPosition(preview, true)
        SetEntityInvincible(preview, true)

        local heading = GetEntityHeading(ped)
        local zOffset = 0.0
        local maxDistance = Config.PlacementMaxDistance or 12.0

        lib.showTextUI('[E] Place  |  [←/→] Rotate  |  [PgUp/PgDn] Height  |  [Backspace] Cancel', { position = 'top-center' })

        while placementActive and DoesEntityExist(preview) do
            Wait(0)
            ped = PlayerPedId()
            local pcoords = GetEntityCoords(ped)
            local hit = cameraRaycast(maxDistance, preview)

            -- Do not allow the preview to be moved an arbitrary distance away from the manager.
            local delta = hit - pcoords
            if #delta > maxDistance then
                hit = pcoords + ((delta / #delta) * maxDistance)
            end

            SetEntityCoordsNoOffset(preview, hit.x, hit.y, hit.z + zOffset, false, false, false)
            SetEntityHeading(preview, heading)

            if IsControlPressed(0, 174) then heading = (heading + 1.0) % 360.0 end
            if IsControlPressed(0, 175) then heading = (heading - 1.0) % 360.0 end
            if IsControlPressed(0, 10) then zOffset = math.min(zOffset + 0.01, 3.0) end -- Page Up
            if IsControlPressed(0, 11) then zOffset = math.max(zOffset - 0.01, -3.0) end -- Page Down

            if IsControlJustPressed(0, 38) then -- E
                local final = GetEntityCoords(preview)
                placementActive = false
                lib.hideTextUI()
                DeleteEntity(preview)
                SetModelAsNoLongerNeeded(model)
                TriggerServerEvent('hf1_scratchcard:server:placeStand', {
                    x = final.x, y = final.y, z = final.z, h = heading
                })
                break
            elseif IsControlJustPressed(0, 177) then -- Backspace
                placementActive = false
                lib.hideTextUI()
                DeleteEntity(preview)
                SetModelAsNoLongerNeeded(model)
                lib.notify({ description = 'Scratchcard stand placement cancelled.', type = 'inform' })
                break
            end
        end

        if DoesEntityExist(preview) then DeleteEntity(preview) end
        lib.hideTextUI()
        placementActive = false
    end)
end

local function openPlacedStandsMenu(stands)
    local options = {}
    for _, stand in ipairs(stands or {}) do
        local id = tonumber(stand.id)
        local label = stand.label or ('Scratchcard Stand #%s'):format(id or '?')
        options[#options + 1] = {
            title = label,
            description = ('ID %s | %.2f, %.2f, %.2f'):format(id or '?', stand.x or 0, stand.y or 0, stand.z or 0),
            icon = 'location-dot',
            onSelect = function()
                lib.registerContext({
                    id = ('hf1_scratchcard_manage_%s'):format(id),
                    title = label,
                    menu = 'hf1_scratchcard_placed_stands',
                    options = {
                        {
                            title = 'Set GPS waypoint',
                            icon = 'map-location-dot',
                            onSelect = function()
                                SetNewWaypoint(stand.x + 0.0, stand.y + 0.0)
                                lib.notify({ description = 'Waypoint set to this scratchcard stand.', type = 'success' })
                            end
                        },
                        {
                            title = 'Teleport to stand',
                            icon = 'person-walking-arrow-right',
                            onSelect = function()
                                SetEntityCoords(PlayerPedId(), stand.x + 0.0, stand.y + 0.0, stand.z + 1.0, false, false, false, false)
                                SetEntityHeading(PlayerPedId(), stand.h + 0.0)
                            end
                        },
                        {
                            title = 'Delete stand',
                            description = 'Permanently removes this stand from the database.',
                            icon = 'trash',
                            onSelect = function()
                                local alert = lib.alertDialog({
                                    header = 'Delete scratchcard stand?',
                                    content = ('Delete **%s** (ID %s)?'):format(label, id),
                                    centered = true,
                                    cancel = true
                                })
                                if alert == 'confirm' then
                                    TriggerServerEvent('hf1_scratchcard:server:deleteStand', id)
                                end
                            end
                        }
                    }
                })
                lib.showContext(('hf1_scratchcard_manage_%s'):format(id))
            end
        }
    end

    if #options == 0 then
        options[1] = { title = 'No stands placed', description = 'Use Place new stand from /scard.', disabled = true, icon = 'circle-info' }
    end

    lib.registerContext({ id = 'hf1_scratchcard_placed_stands', title = 'Placed Scratchcard Stands', menu = 'hf1_scratchcard_manager', options = options })
    lib.showContext('hf1_scratchcard_placed_stands')
end

RegisterNetEvent('hf1_scratchcard:client:showPlacedStands', openPlacedStandsMenu)

RegisterNetEvent('hf1_scratchcard:client:managerMenu', function()
    lib.registerContext({
        id = 'hf1_scratchcard_manager',
        title = 'Scratchcard Stand Manager',
        options = {
            {
                title = 'Place new stand',
                description = 'Places v_ret_247_lotterysign in front of you and saves it to the database.',
                icon = 'plus',
                onSelect = function()
                    startStandPlacement()
                end
            },
            {
                title = 'Manage placed stands',
                description = 'View every database-backed stand, set a waypoint, teleport to it, or delete it.',
                icon = 'list',
                onSelect = function() TriggerServerEvent('hf1_scratchcard:server:requestManageStands') end
            },
            {
                title = 'Remove nearest stand',
                description = 'Quickly removes the closest managed stand.',
                icon = 'trash',
                onSelect = function()
                    local pcoords = GetEntityCoords(PlayerPedId())
                    local nearestId, nearestDist
                    for id, entity in pairs(spawned) do
                        if DoesEntityExist(entity) then
                            local d = #(pcoords - GetEntityCoords(entity))
                            if not nearestDist or d < nearestDist then nearestId, nearestDist = id, d end
                        end
                    end
                    local maxDist = Config.ManageStandDistance or 4.0
                    if nearestId and nearestDist <= maxDist then TriggerServerEvent('hf1_scratchcard:server:deleteStand', nearestId)
                    else lib.notify({ description = ('No managed scratchcard stand within %.1f metres.'):format(maxDist), type = 'error' }) end
                end
            }
        }
    })
    lib.showContext('hf1_scratchcard_manager')
end)

-- Called by ox_inventory item client.export.
exports('useScratchcard', function(data, slot)
    local metadata = slot and slot.metadata or (data and data.metadata)
    if type(metadata) ~= 'table' or type(metadata.grid) ~= 'table' then
        lib.notify({ description = 'This scratchcard is invalid.', type = 'error' })
        return
    end

    uiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        card = {
            grid = metadata.grid,
            bonus = metadata.bonus,
            price = Config.CardPrice,
            bonusSymbol = Config.BonusSymbol,
            cardId = metadata.cardId,
            slot = (slot and slot.slot) or (data and data.slot)
        }
    })
end)

RegisterNUICallback('markScratched', function(data, cb)
    if data and data.slot and data.cardId then
        TriggerServerEvent('hf1_scratchcard:server:markScratched', data.slot, data.cardId)
    end
    cb({ ok = true })
end)

RegisterNUICallback('close', function(_, cb)
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    cb({ ok = true })
end)

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('hf1_scratchcard:server:requestStands')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if uiOpen then SetNuiFocus(false, false) end
    deleteSpawned()
end)
