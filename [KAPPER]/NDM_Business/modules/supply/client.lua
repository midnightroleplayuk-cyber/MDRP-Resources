local CARRY = {
    dict = 'anim@heists@box_carry@',
    clip = 'idle',
    model = `hei_prop_heist_box`,
    bone = 60309,
    offset = vec3(0.03, 0.08, 0.22),
}

local BLOCKED_WHILE_CARRYING = { 21, 22, 23, 24, 25, 37, 44, 140, 141, 142, 257, 263 }

local Orders = {}
local Depots = {}
local DepotZones = {}
local Blips = {}
local carryingOrder = nil
local carryProp = nil
local busy = false

local function clearBlip(orderId)
    if Blips[orderId] then
        RemoveBlip(Blips[orderId])
        Blips[orderId] = nil
    end
end

local function refreshBlip(order)
    clearBlip(order.id)
    local useDepot = order.atDepot > 0 and order.loaded == 0 and order.carried == 0
    local target = useDepot and order.depot or (order.stock or order.depot)
    local blip = AddBlipForCoord(target.x, target.y, target.z)
    SetBlipSprite(blip, 478)
    SetBlipColour(blip, 47)
    SetBlipScale(blip, 0.85)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(useDepot and ('Collect stock: %s'):format(order.depot.label)
        or ('Deliver stock: %s'):format(order.venueLabel))
    EndTextCommandSetBlipName(blip)
    Blips[order.id] = blip
end

local function stopCarrying()
    carryingOrder = nil
    if carryProp and DoesEntityExist(carryProp) then DeleteEntity(carryProp) end
    carryProp = nil
    StopAnimTask(cache.ped, CARRY.dict, CARRY.clip, 1.0)
end

local function startCarrying(orderId)
    carryingOrder = orderId
    lib.requestAnimDict(CARRY.dict)
    lib.requestModel(CARRY.model)

    local coords = GetEntityCoords(cache.ped)
    carryProp = CreateObject(CARRY.model, coords.x, coords.y, coords.z, true, true, false)
    SetEntityCollision(carryProp, false, false)
    AttachEntityToEntity(carryProp, cache.ped, GetPedBoneIndex(cache.ped, CARRY.bone),
        CARRY.offset.x, CARRY.offset.y, CARRY.offset.z, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(CARRY.model)

    CreateThread(function()
        local prop = carryProp
        local deadline = GetGameTimer() + 3000
        while prop == carryProp and DoesEntityExist(prop) and not NetworkGetEntityIsNetworked(prop)
            and GetGameTimer() < deadline do
            Wait(50)
        end
        if prop == carryProp and DoesEntityExist(prop) and NetworkGetEntityIsNetworked(prop) then
            TriggerServerEvent('ndm_business:supply:carryProp', NetworkGetNetworkIdFromEntity(prop))
        end
    end)

    CreateThread(function()
        while carryingOrder == orderId do
            for _, control in ipairs(BLOCKED_WHILE_CARRYING) do
                DisableControlAction(0, control, true)
            end
            if not IsEntityPlayingAnim(cache.ped, CARRY.dict, CARRY.clip, 3) then
                TaskPlayAnim(cache.ped, CARRY.dict, CARRY.clip, 5.0, -1.0, -1, 49, 0.0, false, false, false)
            end
            Wait(0)
        end
    end)
end

local function applyCarry(orderId)
    if orderId == carryingOrder then return end
    if carryingOrder then stopCarrying() end
    if orderId then startCarrying(orderId) end
end

local function haul(action, payload)
    if busy then return end
    busy = true
    local ok, result = pcall(lib.callback.await, 'ndm_business:supply:' .. action, false, payload or {})
    busy = false
    if not ok or not result then
        lib.notify({ type = 'error', description = 'The server did not respond.' })
        return
    end
    if not result.ok then
        lib.notify({ type = 'error', description = result.error })
        return
    end
    applyCarry(result.carrying)
end

local function orderAtDepot(depotId)
    for _, order in pairs(Orders) do
        if order.depot.id == depotId and order.atDepot > 0 then return order end
    end
    return nil
end

local function orderInVehicle(plate)
    for _, order in pairs(Orders) do
        if order.plate == plate and order.loaded > 0 then return order end
    end
    return nil
end

local function plateOf(vehicle)
    return (GetVehicleNumberPlateText(vehicle) or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function removeDepotZone(id)
    if DepotZones[id] then
        exports.ox_target:removeZone(DepotZones[id])
        DepotZones[id] = nil
    end
end

local function addDepotZone(depot)
    removeDepotZone(depot.id)
    DepotZones[depot.id] = exports.ox_target:addSphereZone({
        coords = vec3(depot.x, depot.y, depot.z),
        radius = 1.0,
        options = {
            {
                name = ('ndm_business_depot_%d'):format(depot.id),
                icon = 'fa-solid fa-box',
                label = 'Collect stock box',
                distance = 3.0,
                canInteract = function()
                    return not carryingOrder and orderAtDepot(depot.id) ~= nil
                end,
                onSelect = function()
                    local order = orderAtDepot(depot.id)
                    if order then haul('take', { orderId = order.id }) end
                end,
            },
        },
    })
end

local function refreshState()
    for _ = 1, 30 do
        local ok, state = pcall(lib.callback.await, 'ndm_business:supply:state', false)
        if ok and type(state) == 'table' then
            for id in pairs(Blips) do clearBlip(id) end
            Orders = {}
            for _, order in ipairs(state.orders or {}) do
                Orders[order.id] = order
                refreshBlip(order)
            end
            for id in pairs(DepotZones) do removeDepotZone(id) end
            Depots = {}
            for _, depot in ipairs(state.depots or {}) do
                Depots[depot.id] = depot
                addDepotZone(depot)
            end
            applyCarry(state.carrying)
            return
        end
        Wait(2000)
    end
end

function NDM.IsCarryingFor(venueId)
    local order = carryingOrder and Orders[carryingOrder]
    return order ~= nil and order.venueId == venueId
end

function NDM.DeliverBox()
    haul('deliver')
end

RegisterNetEvent('ndm_business:supply:order', function(id, order)
    local isNew = order and not Orders[id]
    Orders[id] = order
    if order then
        refreshBlip(order)
        if isNew then
            lib.notify({ type = 'inform', description = ('Stock is ready to collect at %s.'):format(order.depot.label) })
        end
    else
        clearBlip(id)
        if carryingOrder == id then stopCarrying() end
    end
end)

RegisterNetEvent('ndm_business:supply:waypoint', function(x, y)
    SetNewWaypoint(x + 0.0, y + 0.0)
end)

RegisterNetEvent('ndm_business:supply:depot', function(id, depot)
    Depots[id] = depot
    if depot then addDepotZone(depot) else removeDepotZone(id) end
end)

-- Opened from the Admin view of /business. `done` runs afterwards, even when placement is cancelled.
function NDM.PlaceDepot(label, done)
    CreateThread(function()
        local coords, heading = NDM.RunPlacer()
        if not coords then
            if done then done() end
            return
        end
        local ok, result = pcall(lib.callback.await, 'ndm_business:supply:saveDepot', false, {
            label = label,
            x = coords.x,
            y = coords.y,
            z = coords.z,
            heading = heading,
        })
        if ok and result and result.ok then
            lib.notify({ type = 'success', description = ('Depot #%d placed.'):format(result.id) })
        else
            lib.notify({ type = 'error', description = result and result.error or 'The server did not respond.' })
        end
        if done then done() end
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(refreshState)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    CreateThread(refreshState)
end)

RegisterCommand('dropbox', function()
    if carryingOrder then CreateThread(function() haul('putBack') end) end
end, false)

TriggerEvent('chat:addSuggestion', '/dropbox', 'Put your carried stock box back')

CreateThread(function()
    refreshState()
    exports.ox_target:addGlobalVehicle({
        {
            name = 'ndm_business_load_box',
            icon = 'fa-solid fa-box',
            label = 'Load stock box',
            distance = 3.0,
            canInteract = function() return carryingOrder ~= nil end,
            onSelect = function(data)
                haul('load', { netId = NetworkGetNetworkIdFromEntity(data.entity) })
            end,
        },
        {
            name = 'ndm_business_unload_box',
            icon = 'fa-solid fa-box-open',
            label = 'Take stock box',
            distance = 3.0,
            canInteract = function(entity)
                return not carryingOrder and orderInVehicle(plateOf(entity)) ~= nil
            end,
            onSelect = function(data)
                local order = orderInVehicle(plateOf(data.entity))
                if order then
                    haul('unload', { orderId = order.id, netId = NetworkGetNetworkIdFromEntity(data.entity) })
                end
            end,
        },
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if carryingOrder then stopCarrying() end
    for id in pairs(Blips) do clearBlip(id) end
    for id in pairs(DepotZones) do removeDepotZone(id) end
    exports.ox_target:removeGlobalVehicle({ 'ndm_business_load_box', 'ndm_business_unload_box' })
end)
