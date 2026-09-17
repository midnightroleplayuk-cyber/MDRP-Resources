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

ScriptFunctions.getJobName = function()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
    end
    return nil
end

ScriptFunctions.getJobGrade = function()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.grade ~= nil) then
        return type(PlayerData.job.grade) == "table" and PlayerData.job.grade.level or PlayerData.job.grade
    end
    return nil
end