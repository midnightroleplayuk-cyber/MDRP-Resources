ScriptFunctions = {}
Framework = nil
Fr = {}

Fr.EnterSpawnSelection = function(isNew)
    if type(isPlayerPrisoner) == "function" and isPlayerPrisoner() then
        if type(finishPrisonerMultichar) == "function" then
            finishPrisonerMultichar()
        end
        return
    end

    if GetResourceState('okokSpawnSelector') == 'started' then
        TriggerEvent('okokSpawnSelector:spawnMenu', isNew)
        Wait(1000)
        SendNUIMessage({
            action = "setBlackScreen", 
            data = false
        })
    else 
        startSpawnSelection()
    end
end

-- Function triggered when character is spawned, after cutscenes etc
Fr.CharacterSpawned = function()
    Config.SwitchHud(true)
end

Fr.CharacterCreated = function()
    local coords = Config.SwitchPlayer.startCoords

    if Config.EnableStartCutScene then 
        startCutScene(function(res)
            if res then 
                if Config.SpawnSelector.enable then 
                    Fr.EnterSpawnSelection(true)
                else 
                    switchToCoords(coords, true)
                end
            end
        end)
    else 
        if Config.SpawnSelector.enable then 
            if (Config.SpawnSelector.mode or "tablet") ~= "classic" then
                SendNUIMessage({
                    action = "setBlackScreen", 
                    data = true
                })
                Wait(1200)
            end
            Fr.EnterSpawnSelection(true)
        else 
            switchToCoords(coords, true)
        end
    end
end

ScriptFunctions.RequestModel = function(modelHash, cb)
    local original = modelHash
    if type(modelHash) == 'number' then
    elseif type(modelHash) == 'string' then
        modelHash = joaat(modelHash)
    else
        debugPrint(("^1[RequestModel]^0 Invalid model type: %s (%s)"):format(type(original), tostring(original)))
        if cb then cb(false) end
        return false
    end

    if not IsModelInCdimage(modelHash) then
        debugPrint(("^1[RequestModel]^0 Model not in CD image: %s (%s)"):format(tostring(modelHash), tostring(original)))
        if cb then cb(false) end
        return false
    end

    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)

        local start = GetGameTimer()
        local timeout = 15000 

        while not HasModelLoaded(modelHash) do
            Wait(0)

            if (GetGameTimer() - start) > timeout then
                debugPrint(("^1[RequestModel]^0 Timeout loading model: %s (%s)"):format(tostring(modelHash), tostring(original)))
                if cb then cb(false) end
                return false
            end
        end
    end

    if cb then cb(true) end
    return modelHash
end

Fr.SpawnVehicle = function(vehicleModel, coords, heading, networked, cb)
    CreateThread(function()
        debugPrint('[SpawnVehicle] Called with model = ' .. tostring(vehicleModel))

        local modelHash
        if type(vehicleModel) == 'number' then
            modelHash = vehicleModel
        elseif type(vehicleModel) == 'string' then
            modelHash = joaat(vehicleModel)
        else
            debugPrint('^1[SpawnVehicle]^0 Invalid vehicleModel type: ' .. type(vehicleModel))
            if cb then cb(nil) end
            return
        end

        local playerPed = PlayerPedId()
        if not DoesEntityExist(playerPed) then
            debugPrint('^1[SpawnVehicle]^0 Player ped does not exist')
            if cb then cb(nil) end
            return
        end

        local vec3Coords
        if type(coords) == "vector3" or type(coords) == "vector4" then
            local x, y, z = tonumber(coords.x), tonumber(coords.y), tonumber(coords.z)
            if x and y and z then
                vec3Coords = vector3(x, y, z)
            end
        elseif type(coords) == "table" then
            local x = tonumber(coords.x)
            local y = tonumber(coords.y)
            local z = tonumber(coords.z)
            if x and y and z then
                vec3Coords = vector3(x, y, z)
            end
        end

        -- NEVER fall back to player position — that leaked scene vehicles (planes etc.)
        -- into whatever MLO/street the joining ped was standing in.
        if not vec3Coords then
            debugPrint('^1[SpawnVehicle]^0 Invalid coords — aborting (no player-pos fallback)')
            if cb then cb(nil) end
            return
        end

        heading = tonumber(heading)
        if not heading then
            heading = GetEntityHeading(playerPed)
        end
        -- Only explicit true creates a networked vehicle. Anything else (nil/false/fn)
        -- stays local so scene props can never pile up in bucket 0 for other players.
        networked = networked == true

        debugPrint(('[SpawnVehicle] Final spawn position: x=%.2f, y=%.2f, z=%.2f, h=%.2f, net=%s')
            :format(vec3Coords.x, vec3Coords.y, vec3Coords.z, heading, tostring(networked)))

        local loadedModel = ScriptFunctions.RequestModel(modelHash)
        if not loadedModel then
            debugPrint('^1[SpawnVehicle]^0 Failed to load vehicle model: ' .. tostring(vehicleModel))
            if cb then cb(nil) end
            return
        end

        local vehicle = CreateVehicle(loadedModel, vec3Coords.x, vec3Coords.y, vec3Coords.z, heading, networked, false)

        if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
            debugPrint('^1[SpawnVehicle]^0 CreateVehicle returned invalid entity for model: ' .. tostring(vehicleModel))
            SetModelAsNoLongerNeeded(loadedModel)
            if cb then cb(nil) end
            return
        end

        debugPrint('[SpawnVehicle] Vehicle created, entity id = ' .. tostring(vehicle))

        SetEntityAsMissionEntity(vehicle, true, true)
        if networked then
            local id = NetworkGetNetworkIdFromEntity(vehicle)
            if id and id ~= 0 then
                SetNetworkIdCanMigrate(id, false)
                SetNetworkIdExistsOnAllMachines(id, false)
            end
        end

        SetVehicleHasBeenOwnedByPlayer(vehicle, false)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(loadedModel)
        SetVehRadioStation(vehicle, 'OFF')

        RequestCollisionAtCoord(vec3Coords.x, vec3Coords.y, vec3Coords.z)
        local colStart = GetGameTimer()
        local colTimeout = 15000

        while DoesEntityExist(vehicle) and not HasCollisionLoadedAroundEntity(vehicle)
            and (GetGameTimer() - colStart) < colTimeout do
            Wait(0)
        end

        if not HasCollisionLoadedAroundEntity(vehicle) then
            debugPrint('^3[SpawnVehicle]^0 Collision did not fully load around vehicle within timeout')
        end

        debugPrint('[SpawnVehicle] Finished, calling callback')

        if cb then
            cb(vehicle)
        end
    end)
end