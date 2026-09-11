Bridge = Bridge or {}
Bridge.Keys = Bridge.Keys or {}

local eventBuckets = {}
local RATE_LIMIT = { limit = 6, window = 10 }

local function cleanPlate(plate)
    return string.gsub(plate or '', '^%s*(.-)%s*$', '%1')
end

local function resourceStarted(resource)
    return GetResourceState(resource) == 'started'
end

local function rateLimited(source, action)
    local now = os.time()
    eventBuckets[source] = eventBuckets[source] or {}
    local bucket = eventBuckets[source][action]

    if not bucket or now >= bucket.resetAt then
        eventBuckets[source][action] = { count = 1, resetAt = now + RATE_LIMIT.window }
        return false
    end

    bucket.count = bucket.count + 1
    if bucket.count > RATE_LIMIT.limit then
        print(('[tn_carrental][keys] rate limit source=%s action=%s count=%s'):format(source, action, bucket.count))
        return true
    end

    return false
end

local function run(system, action, handler)
    local ok, result = pcall(handler)
    if not ok then
        print(('[tn_carrental][keys] %s %s failed: %s'):format(system, action, result))
    end
    return ok and result ~= false
end

local function resolveVehicle(netId)
    if not netId or netId == 0 then return 0 end

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local attempts = 0

    while (not vehicle or vehicle == 0 or not DoesEntityExist(vehicle)) and attempts < 25 do
        Wait(100)
        vehicle = NetworkGetEntityFromNetworkId(netId)
        attempts = attempts + 1
    end

    return vehicle or 0
end

local function validateGiveRequest(source, vehicle, plate)
    if not Bridge.Rentals or not Bridge.Rentals.ValidateKeyGive then
        print(('[tn_carrental][keys] give denied: rental validator missing source=%s plate=%s'):format(source, plate))
        return false
    end

    local ok, reason = Bridge.Rentals.ValidateKeyGive(source, vehicle, plate)
    if not ok then
        print(('[tn_carrental][keys] give denied: source=%s plate=%s reason=%s'):format(source, plate, tostring(reason)))
        return false
    end

    return true
end

RegisterNetEvent('tn_carrental:keys:give', function(system, netId, plate)
    local source = source
    if rateLimited(source, 'give') then return end
    plate = cleanPlate(plate)

    if system == 'qbx_vehiclekeys' and resourceStarted('qbx_vehiclekeys') then
        local vehicle = resolveVehicle(netId)

        if vehicle == 0 then
            print(('[tn_carrental][keys] qbx_vehiclekeys give skipped: no server vehicle for source=%s netId=%s plate=%s'):format(source, tostring(netId), plate))
            return
        end

        if not validateGiveRequest(source, vehicle, plate) then return end

        run(system, 'give', function()
            exports.qbx_vehiclekeys:GiveKeys(source, vehicle, true)
        end)
    elseif system == 'wasabi_carlock' and resourceStarted('wasabi_carlock') then
        if not validateGiveRequest(source, 0, plate) then return end
        run(system, 'give', function()
            exports.wasabi_carlock:GiveKey(source, plate)
        end)
    elseif system == 'VehicleKeyChain' and resourceStarted('VehicleKeyChain') then
        if not validateGiveRequest(source, 0, plate) then return end
        run(system, 'give', function()
            exports.VehicleKeyChain:AddTempKey(source, plate)
        end)
    end
end)

RegisterNetEvent('tn_carrental:keys:remove', function(system, netId, plate)
    local source = source
    if rateLimited(source, 'remove') then return end
    plate = cleanPlate(plate)

    if system == 'qbx_vehiclekeys' and resourceStarted('qbx_vehiclekeys') then
        local vehicle = resolveVehicle(netId)

        if vehicle == 0 then
            print(('[tn_carrental][keys] qbx_vehiclekeys remove skipped: no server vehicle for source=%s netId=%s plate=%s'):format(source, tostring(netId), plate))
            return
        end

        run(system, 'remove', function()
            exports.qbx_vehiclekeys:RemoveKeys(source, vehicle, true)
        end)
    elseif system == 'wasabi_carlock' and resourceStarted('wasabi_carlock') then
        run(system, 'remove', function()
            exports.wasabi_carlock:RemoveKey(source, plate)
        end)
    elseif system == 'VehicleKeyChain' and resourceStarted('VehicleKeyChain') then
        run(system, 'remove', function()
            exports.VehicleKeyChain:RemoveKey(source, plate, 1)
        end)
    end
end)

AddEventHandler('playerDropped', function()
    eventBuckets[source] = nil
end)
