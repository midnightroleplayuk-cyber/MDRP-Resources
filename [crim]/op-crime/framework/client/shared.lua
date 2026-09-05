ScriptFunctions = {}
Framework = nil
Fr = {}

Fr.SpawnVehicle = function(vehicleModel, coords, heading, networked, cb)
    local model = type(vehicleModel) == 'number' and vehicleModel or joaat(vehicleModel)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
    networked = networked == nil and true or networked

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    if not vector or not playerCoords then
        print('Unable to spawn')
        return
    end

    CreateThread(function()
        ScriptFunctions.RequestModel(model)

        local vehicle = CreateVehicle(model, vector.xyz, heading, networked, true)

        if networked then
            local id = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(vehicle, true, true)
        end
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(model)
        SetVehRadioStation(vehicle, 'OFF')

        RequestCollisionAtCoord(vector.xyz)
        while not HasCollisionLoadedAroundEntity(vehicle) do
            Wait(0)
        end

        if cb then
            cb(vehicle)
        end
    end)
end

ScriptFunctions.GetClosestPlayers = function(maxDistance)
    maxDistance = maxDistance or 10.0
    local playersInRange = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local otherPed = GetPlayerPed(playerId)
        local playerServerId = GetPlayerServerId(playerId)
        if otherPed ~= playerPed then
            local otherCoords = GetEntityCoords(otherPed)
            local distance = #(playerCoords.xyz - otherCoords.xyz)
            if distance <= maxDistance then
                table.insert(playersInRange, { id = playerServerId, distance = distance })
            end
        end
    end

    return playersInRange
end

ScriptFunctions.RequestModel = function(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or joaat(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

local itemsCache = { data = nil, expiresAt = 0 }
local cacheTime = 10000

ScriptFunctions.GetInventoryItems = function()
    local playerData = Fr.GetPlayerData()
    local itemsList = {}

    local now = GetGameTimer() or 0
    if itemsCache.data and now < itemsCache.expiresAt then
        return itemsCache.data
    end
    
    if ESX then
        local items = playerData.inventory
        if not items then 
            return {} 
        end
        
        for k, v in pairs(items) do
            table.insert(itemsList, {
                name = v.name,
                amount = v.count,
            })
        end
    elseif QBCore or QBox then
        local items = playerData.items
        if not items then 
            return {} 
        end
        
        for k, v in pairs(items) do
            table.insert(itemsList, {
                name = v.name,
                amount = v.amount or v.count,
            })
        end
    end

    itemsCache.data = itemsList
    itemsCache.expiresAt = now + cacheTime
    
    debugPrint("itemsList", json.encode(itemsList))
    return itemsList
end