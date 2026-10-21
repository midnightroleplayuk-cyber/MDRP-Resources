MainController = {}
SavedVehicles = {}
EnabledVehicles = {}
StoredConfigs = {}
StoredPatterns = {
    PRIMARY = {},
    SECONDARY = {},
    WARNING = {},
    ONSCENE = {}
}

IsLoaded = false

Citizen.CreateThread(function()
    MainController.DebugPrint("[Initialisation] Thank you for using oELS, now loading.")

    MainController.LoadVCFFiles()
    MainController.loadPatterns()

    MainController.DebugPrint("[Initialisation] Loading a total of " .. tostring(#Config.Soundpacks) .. " soundpacks.")

    for _, soundpack in pairs(Config.Soundpacks) do
        RequestScriptAudioBank(soundpack, false)
    end

    DistantCopCarSirens(false)

    collectgarbage("collect")

    KeyPressController.MainThread()
end)

function MainController.GetVehicleData(netId)
    if SavedVehicles[netId] then
        --MainController.DebugPrint("[RegisterNewVehicle] Saved data for " .. netId .. " already found and returned.")
        return SavedVehicles[netId]
    end

    MainController.DebugPrint("[RegisterNewVehicle] No Saved data for " .. netId .. " found, creating.")

    SavedVehicles[netId] = {}

    SavedVehicles[netId].networkedId = netId

    SavedVehicles[netId].lightStates = {
        Primary = {
            Enabled = false,
            CurrentStage = 1,
            LastUpdated = 0
        },
        OnScene = {
            Enabled = false,
            CurrentStage = 1,
            LastUpdated = 0
        },
        Warning = {
            Enabled = false,
            CurrentStage = 1,
            LastUpdated = 0
        },
        Secondary = {
            Enabled = false,
            CurrentStage = 1,
            LastUpdated = 0
        },
        WigWags = {
            Enabled = false,
            CurrentStage = 1,
            CurrentBrightness = 0.0,
            LastUpdated = 0
        },
        AlleyLights = 0,
        Indicators = 0
    }

    SavedVehicles[netId].sirens = {
        State = 0,
        Handle = nil
    }

    SavedVehicles[netId].dualSiren = {
        State = 0,
        Handle = nil
    }

    SavedVehicles[netId].bullhorn = {
        State = 0,
        Handle = nil
    }

    if NetworkDoesEntityExistWithNetworkId(netId) then
		SavedVehicles[netId].entity = NetworkGetEntityFromNetworkId(netId)
        LightsController.CleanupVehicle(SavedVehicles[netId])
    else
        SavedVehicles[netId].entity = nil
	end

    MainController.DebugPrint("[RegisterNewVehicle] Saved Data generated for " .. netId)
    return SavedVehicles[netId]
end

function MainController.GetVehicleDataUsingEntity(entity)
	local netId = NetworkGetNetworkIdFromEntity(entity)

	if netId == 0 then return nil end

	return MainController.GetVehicleData(netId)
end

function MainController.isVehicleELS(vehicle)
    if StoredConfigs[GetEntityModel(vehicle)] then
        return true
    end

    return false
end

function MainController.isVehicleNonELS(vehicle)
    if Config.NonELS[GetEntityModel(vehicle)] then
        return true
    end

    return false
end

function MainController.shouldUse999Mode(vehicle)
    for _, spawnCode in pairs(Config.Optilink.Use999Sound) do
        if spawnCode == GetEntityModel(vehicle) then
            return true
        end
    end

    return false
end

function MainController.canPedControlELS(ownPed, ownVehicle)
    local elsData = StoredConfigs[GetEntityModel(ownVehicle)]

    local seatsToCheck = {-1,0}

    if elsData and elsData.misc and elsData.misc.seatsCanControl then
        seatsToCheck = elsData.misc.seatsCanControl
    end

    for _, seat in pairs(seatsToCheck) do
        seat = tonumber(seat)
        if GetPedInVehicleSeat(ownVehicle, seat) == ownPed then
            return true
        end
    end

    return false
end

function MainController.LoadVCFFiles()
    MainController.DebugPrint("Requested to load oELS Files.")

    local elsTable = {}
    local scriptName = GetCurrentResourceName()
    local totalLoaded = 0
    local totalUsingDefault = 0

    defaultJSONFile = LoadResourceFile(scriptName, "/ELS/_DEFAULT.json")

    if defaultJSONFile == nil then MainController.ConsolePrint("ERROR", "Your _DEFAULT.json file is missing.") end

    defaultJSONFile = json.decode(defaultJSONFile)

    if defaultJSONFile == nil then MainController.ConsolePrint("ERROR", "Your _DEFAULT.json file is invalid, please validate the code.") end

    elsFileNames = json.decode(LoadResourceFile(scriptName, "/ELS/_VEHICLES.json"))

    if elsFileNames == nil then return MainController.ConsolePrint("ERROR", "Your _VEHICLES.json file is invalid, please validate the code.") end

    MainController.DebugPrint("Requested to load a total of " .. tostring(#elsFileNames))

    for _, fileName in pairs(elsFileNames) do
        MainController.DebugPrint("Attempting to load ELS file for " .. fileName)

        elsFile = json.decode(LoadResourceFile(scriptName, "/ELS/" .. fileName .. ".json"))

        if elsFile == nil then
            if defaultJSONFile == nil then
                MainController.ConsolePrint("WARNING", "Your " .. fileName .. ".json file is missing or invalid, loading skipped.")
            else
                MainController.ConsolePrint("WARNING", "Your " .. fileName .. ".json file is missing or invalid, now using DEFAULT file.")
                elsTable[GetHashKey(fileName)] = defaultJSONFile
                totalLoaded = totalLoaded + 1
                totalUsingDefault = totalUsingDefault + 1
            end
        else
            elsTable[GetHashKey(fileName)] = elsFile
            totalLoaded = totalLoaded + 1
        end
    end

    MainController.DebugPrint("Loaded a total of " .. tostring(totalLoaded) .. "/" .. tostring(#elsFileNames) .. " (" .. tostring(totalUsingDefault) .. " using DEFAULT) for use.")

    StoredConfigs = elsTable
end

function MainController.loadPatterns()
    Citizen.CreateThread(function()
        for name, pattern in pairs(Config.PrimaryPatterns) do
            local temporaryTable = {}

            for num, segment in pairs(pattern) do
                for _, extra in pairs(segment[1]) do
                    if not temporaryTable[extra] then
                        temporaryTable[extra] = true
                    end
                end
            end

            local finalTable = {}

            for extra, _ in pairs(temporaryTable) do
                table.insert(finalTable, extra)
            end

            StoredPatterns.PRIMARY[name] = finalTable
            MainController.DebugPrint("Set Primary Pattern Extras for " .. name .. " total controlled extras are " .. tostring(#finalTable))
        end
    end)

    Citizen.CreateThread(function()
        for name, pattern in pairs(Config.SecondaryPatterns) do
            local temporaryTable = {}

            for num, segment in pairs(pattern) do
                for _, extra in pairs(segment[1]) do
                    if not temporaryTable[extra] then
                        temporaryTable[extra] = true
                    end
                end
            end

            local finalTable = {}

            for extra, _ in pairs(temporaryTable) do
                table.insert(finalTable, extra)
            end

            StoredPatterns.SECONDARY[name] = finalTable
            MainController.DebugPrint("Set Secondary Pattern Extras for " .. name .. " total controlled extras are " .. tostring(#finalTable))
        end
    end)

    Citizen.CreateThread(function()
        for name, pattern in pairs(Config.WarningPatterns) do
            local temporaryTable = {}

            for num, segment in pairs(pattern) do
                for _, extra in pairs(segment[1]) do
                    if not temporaryTable[extra] then
                        temporaryTable[extra] = true
                    end
                end
            end

            local finalTable = {}

            for extra, _ in pairs(temporaryTable) do
                table.insert(finalTable, extra)
            end

            StoredPatterns.WARNING[name] = finalTable
            MainController.DebugPrint("Set Warning Pattern Extras for " .. name .. " total controlled extras are " .. tostring(#finalTable))
        end
    end)

    Citizen.CreateThread(function()
        for name, pattern in pairs(Config.OnScenePatterns) do
            local temporaryTable = {}

            for num, segment in pairs(pattern) do
                for _, extra in pairs(segment[1]) do
                    if not temporaryTable[extra] then
                        temporaryTable[extra] = true
                    end
                end
            end

            local finalTable = {}

            for extra, _ in pairs(temporaryTable) do
                table.insert(finalTable, extra)
            end

            StoredPatterns.ONSCENE[name] = finalTable
            MainController.DebugPrint("Set OnScene Pattern Extras for " .. name .. " total controlled extras are " .. tostring(#finalTable))
        end
    end)
end

function MainController.DebugPrint(message)
    if not Config.Debug then return end

    print("[oELS] [Debugging] " .. message)
end

function MainController.ConsolePrint(type, message)
    print("[oELS] [" .. type .. "] " .. message)
end

RegisterNetEvent("oELS:VehicleRemoved")

AddEventHandler("oELS:VehicleRemoved", function(netId)
    MainController.DebugPrint("Removed vehicle due to entity being removed on the server.")

    if SavedVehicles[netId] then
        if SavedVehicles[netId].sirens.Handle then
            StopSound(SavedVehicles[netId].sirens.Handle)
            ReleaseSoundId(SavedVehicles[netId].sirens.Handle)
            SavedVehicles[netId].sirens.Handle = nil
        end

        if SavedVehicles[netId].sirens.Handle then
            StopSound(SavedVehicles[netId].bullhorn.Handle)
            ReleaseSoundId(SavedVehicles[netId].bullhorn.Handle)
            SavedVehicles[netId].bullhorn.Handle = nil
        end
    end

    SavedVehicles[netId] = nil
	EnabledVehicles[netId] = nil
end)

function MainController.CheckVehicleStates()
	for k, v in pairs(EnabledVehicles) do
		if not DoesEntityExist(v) then
			MainController.VehicleLeftScope(k)
		end
	end

	for k, v in pairs(SavedVehicles) do
		if not EnabledVehicles[k] then
			if NetworkDoesEntityExistWithNetworkId(k) then
				MainController.VehicleEnteredScope(k)
			end
		end
	end
end

function MainController.VehicleLeftScope(netId)
	MainController.DebugPrint("Removed vehicle due leaving range.")

	EnabledVehicles[netId] = nil

    if SavedVehicles[netId] then
        if SavedVehicles[netId].sirens.Handle then
            StopSound(SavedVehicles[netId].sirens.Handle)
            ReleaseSoundId(SavedVehicles[netId].sirens.Handle)
            SavedVehicles[netId].sirens.Handle = nil
        end

        if SavedVehicles[netId].sirens.Handle then
            StopSound(SavedVehicles[netId].bullhorn.Handle)
            ReleaseSoundId(SavedVehicles[netId].bullhorn.Handle)
            SavedVehicles[netId].bullhorn.Handle = nil
        end

        SavedVehicles[netId].entity = nil
    end
end

function MainController.VehicleEnteredScope(netId)
	MainController.DebugPrint("Generated vehicle due entering range.")

	local entity = NetworkGetEntityFromNetworkId(netId)

	if entity == 0 or not IsEntityAVehicle(entity) then return end

    EnabledVehicles[netId] = entity
	SavedVehicles[netId].entity = entity

	SetVehicleAutoRepairDisabled(entity, true)
	SetVehicleHasMutedSirens(entity, true)
    SetVehicleSiren(entity, SavedVehicles[netId].lightStates.Primary.Enabled)

    local needsEnv = false

    if SavedVehicles[netId].lightStates.AlleyLights > 0 then
        LightsController.AlleyLights(SavedVehicles[netId])
    end

	if SavedVehicles[netId].sirens.State ~= 0 and not SavedVehicles[netId].sirens.Handle then
		SoundsController.ChangeSirenTone(SavedVehicles[netId])
	end

	if SavedVehicles[netId].dualSiren.State ~= 0 and not SavedVehicles[netId].dualSiren.Handle then
		SoundsController.ChangeSecondSirenTone(SavedVehicles[netId])
	end

	if SavedVehicles[netId].bullhorn.State == 1 and not SavedVehicles[netId].bullhorn.Handle then
		SoundsController.ChangeBullhornState(SavedVehicles[netId])
	end

    LightsController.Indicators(SavedVehicles[netId])
end
