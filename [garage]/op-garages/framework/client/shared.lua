ScriptFunctions = {}

ScriptFunctions.GetVehicleDeformation = function(vehicle)
    if GetResourceState('VehicleDeformation') ~= 'missing' then
        local deformation = exports["VehicleDeformation"]:GetVehicleDeformation(vehicle)
        return deformation
    end

    return {}
end

ScriptFunctions.SetVehicleDeformation = function(vehicle, deformation)
    if GetResourceState('VehicleDeformation') ~= 'missing' then
        exports["VehicleDeformation"]:SetVehicleDeformation(vehicle, deformation)
    end
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

local AIRCRAFT_SAFE_PROPS = {
    'plate', 'plateIndex',
    'color1', 'color2', 'pearlescentColor', 'wheelColor', 'dashboardColor', 'interiorColor',
    'paintType1', 'paintType2',
    'dirtLevel', 'fuelLevel', 'oilLevel',
    'engineHealth', 'bodyHealth', 'tankHealth',
    'livery',
    'windowTint',
    'xenonColor', 'modXenon',
    'neonEnabled', 'neonColor',
    'tyreSmokeColor',
    'lockState',
}

local BLOAT_PROP_KEYS = {
    tireHealth = true,
    tireBurstState = true,
    tireBurstCompletely = true,
    tyreBurst = true,
    doorsBroken = true,
    windowsBroken = true,
    doorStatus = true,
    windowStatus = true,
    customPrimaryColor = true,
    customSecondaryColor = true,
    xenonCustomColor = true,
    xenonCustomColorEnabled = true,
    modCustomFrontWheels = true,
    modCustomBackWheels = true,
    liveryRoof = true,
    tyresCanBurst = true, -- ox_lib uses bulletProofTyres
    modKit17 = true,
    modKit19 = true,
    modKit21 = true,
    modKit47 = true,
    modKit49 = true,
}

ScriptFunctions.IsModelAircraft = function(model)
    if not model then return false end
    return IsThisModelAHeli(model) or IsThisModelAPlane(model)
end

ScriptFunctions.SanitizeVehicleProps = function(vehicle, props)
    if type(props) ~= 'table' then return props end

    local model = props.model or (vehicle and DoesEntityExist(vehicle) and GetEntityModel(vehicle))
    if ScriptFunctions.IsModelAircraft(model) then
        local safe = {}
        for i = 1, #AIRCRAFT_SAFE_PROPS do
            local key = AIRCRAFT_SAFE_PROPS[i]
            if props[key] ~= nil then
                safe[key] = props[key]
            end
        end
        return safe
    end

    -- Strip migration bloat (keeps ox_lib / native setters working, shrinks payloads)
    local cleaned = {}
    for k, v in pairs(props) do
        if not BLOAT_PROP_KEYS[k] then
            cleaned[k] = v
        end
    end
    return cleaned
end

--- Wait until we own the networked vehicle so lib.setVehicleProperties applies
--- locally and does NOT fall into a replicated props statebag path elsewhere.
ScriptFunctions.EnsureVehicleOwnership = function(vehicle, timeoutMs)
    timeoutMs = timeoutMs or 2000
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        return false
    end
    if not NetworkGetEntityIsNetworked(vehicle) then
        return true
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdCanMigrate(netId, true)
    NetworkRequestControlOfEntity(vehicle)

    local deadline = GetGameTimer() + timeoutMs
    while GetGameTimer() < deadline do
        if NetworkHasControlOfEntity(vehicle) or NetworkGetEntityOwner(vehicle) == PlayerId() then
            return true
        end
        NetworkRequestControlOfEntity(vehicle)
        Wait(0)
    end
    return NetworkHasControlOfEntity(vehicle) or NetworkGetEntityOwner(vehicle) == PlayerId()
end

ScriptFunctions.ClearVehiclePropStatebag = function(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    if not NetworkGetEntityIsNetworked(vehicle) then return end
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if netId and netId ~= 0 then
        TriggerServerEvent('op-garages:clearVehiclePropState', netId)
    end
end

function ScriptFunctions.IsVehicleLabelHidden(label)
    if not label or label == "" or label == "CARNOTFOUND" then return true end
    local normalized = string.lower(tostring(label):match("^%s*(.-)%s*$"))
    return normalized == "unknown" or normalized == "unknown vehicle"
end

function ScriptFunctions.ShouldShowVehicleInList(label)
    return not ScriptFunctions.IsVehicleLabelHidden(label)
end

function ScriptFunctions.ResolveVehicleDisplayLabel(model, fallbackSpawn)
    if model == nil or model == "" then return "Unknown" end
    if type(model) == "string" and not tonumber(model) then
        return capitalizeWords(model)
    end
    if fallbackSpawn and not tonumber(fallbackSpawn) then
        return capitalizeWords(tostring(fallbackSpawn))
    end
    return "Unknown Vehicle"
end

function getJobName()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
    end
    return nil
end

function getJobGrade() 
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.grade ~= nil) then
        return type(PlayerData.job.grade) == "table" and PlayerData.job.grade.level or PlayerData.job.grade
    end
    return nil
end