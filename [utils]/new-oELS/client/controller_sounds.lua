SoundsController = {}

RegisterNetEvent("oELS:toggleSirens")

AddEventHandler("oELS:toggleSirens", function(player, vehicle, state)
    MainController.DebugPrint("[ToggleSirens] Request from " .. player .. " to change sirens to " .. tostring(state))

    vehicleData = MainController.GetVehicleData(vehicle)

    vehicleData.sirens.State = state

    SoundsController.ChangeSirenTone(vehicleData)
end)

RegisterNetEvent("oELS:toggleSecondSirens")

AddEventHandler("oELS:toggleSecondSirens", function(player, vehicle, state)
    MainController.DebugPrint("[toggleSecondSirens] Request from " .. player .. " to change sirens to " .. tostring(state))

    vehicleData = MainController.GetVehicleData(vehicle)

    vehicleData.dualSiren.State = state

    SoundsController.ChangeSecondSirenTone(vehicleData)
end)

RegisterNetEvent("oELS:toggleBullhorn")

AddEventHandler("oELS:toggleBullhorn", function(player, vehicle, state)
    MainController.DebugPrint("[toggleBullhorn] Request from " .. player .. " to change bullhorn to " .. tostring(state))

    vehicleData = MainController.GetVehicleData(vehicle)

    vehicleData.bullhorn.State = state

    SoundsController.ChangeBullhornState(vehicleData)
end)

function SoundsController.ChangeSirenTone(vehicleData)
    if not vehicleData.entity then return end

    if vehicleData.sirens.Handle then
        MainController.DebugPrint("[ChangeSirenTone] Removing old siren tone that is stored.")
        StopSound(vehicleData.sirens.Handle)
        ReleaseSoundId(vehicleData.sirens.Handle)
        vehicleData.sirens.Handle = nil
    end

    if vehicleData.sirens.State == 0 then return end

    local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]

    if not elsData then
        MainController.DebugPrint("[ChangeSirenTone] Ending Siren Change due to not being able to find ELS data for " .. vehicleData.networkedId)
        vehicleData.sirens.state = 0
        return
    end

    if not elsData.sirens then
        MainController.DebugPrint("[ChangeSirenTone] Ending Siren Change due to malformed ELS data for " .. vehicleData.networkedId)
        vehicleData.sirens.State = 0
        return
    end

    if not elsData.sirens.enabled then
        MainController.DebugPrint("[ChangeSirenTone] Ending Siren Change due to sirens not being enabled for " .. vehicleData.networkedId)
        vehicleData.sirens.State = 0
        return
    end

    soundData = elsData.sirens.sounds[vehicleData.sirens.State]

    if not soundData then
        MainController.DebugPrint("[ChangeSirenTone] Ending Siren Change due to no data being found for requested tone " .. vehicleData.networkedId)
        vehicleData.sirens.State = 0
        return
    end

    vehicleData.sirens.Handle = GetSoundId()
	PlaySoundFromEntity(vehicleData.sirens.Handle, soundData.soundFile, vehicleData.entity, soundData.soundPack, 0, 0)
    MainController.DebugPrint("[ChangeSirenTone] Created Siren sound for " .. vehicleData.networkedId)
end

function SoundsController.ChangeSecondSirenTone(vehicleData)
    if not vehicleData.entity then return end

    if vehicleData.dualSiren.Handle then
        MainController.DebugPrint("[ChangeSecondSirenTone] Removing old siren tone that is stored.")
        StopSound(vehicleData.dualSiren.Handle)
        ReleaseSoundId(vehicleData.dualSiren.Handle)
        vehicleData.dualSiren.Handle = nil
    end

    if vehicleData.dualSiren.State == 0 then return end

    local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]

    if not elsData then
        MainController.DebugPrint("[ChangeSecondSirenTone] Ending Siren Change due to not being able to find ELS data for " .. vehicleData.networkedId)
        vehicleData.dualSiren.state = 0
        return
    end

    if not elsData.dualSirens then
        MainController.DebugPrint("[ChangeSecondSirenTone] Ending Siren Change due to malformed ELS data for " .. vehicleData.networkedId)
        vehicleData.dualSiren.State = 0
        return
    end

    if not elsData.dualSirens.enabled then
        MainController.DebugPrint("[ChangeSecondSirenTone] Ending Siren Change due to sirens not being enabled for " .. vehicleData.networkedId)
        vehicleData.dualSiren.State = 0
        return
    end

    soundData = elsData.dualSirens.sounds[vehicleData.dualSiren.State]

    if not soundData then
        MainController.DebugPrint("[ChangeSecondSirenTone] Ending Siren Change due to no data being found for requested tone " .. vehicleData.networkedId)
        vehicleData.dualSiren.State = 0
        return
    end

    vehicleData.dualSiren.Handle = GetSoundId()
	PlaySoundFromEntity(vehicleData.dualSiren.Handle, soundData.soundFile, vehicleData.entity, soundData.soundPack, 0, 0)
    MainController.DebugPrint("[ChangeSecondSirenTone] Created Siren sound for " .. vehicleData.networkedId)
end

function SoundsController.ChangeBullhornState(vehicleData)
    if not vehicleData.entity then return end

    if vehicleData.bullhorn.Handle then
        MainController.DebugPrint("[ChangeBullhornState] Removing old bullhorn tone that is stored.")
        StopSound(vehicleData.bullhorn.Handle)
        ReleaseSoundId(vehicleData.bullhorn.Handle)
        vehicleData.bullhorn.Handle = nil
    end

    if vehicleData.bullhorn.State == 0 then return end

    local elsData = StoredConfigs[GetEntityModel(vehicleData.entity)]

    if not elsData then
        MainController.DebugPrint("[ChangeBullhornState] Ending Bullhorn due to not being able to find ELS data for " .. vehicleData.networkedId)
        vehicleData.bullhorn.state = 0
        return
    end

    if not elsData.sirens then
        MainController.DebugPrint("[ChangeBullhornState] Ending Bullhorn due to malformed ELS data for " .. vehicleData.networkedId)
        vehicleData.bullhorn.State = 0
        return
    end

    soundData = elsData.sirens.bullHorn

    if not soundData then
        MainController.DebugPrint("[ChangeBullhornState] Ending Bullhorn due to no data being found for " .. vehicleData.networkedId)
        vehicleData.bullhorn.State = 0
        return
    end

    if not soundData.enabled then
        MainController.DebugPrint("[ChangeBullhornState] Ending Bullhorn due to bullhorn not being enabled for " .. vehicleData.networkedId)
        vehicleData.bullhorn.State = 0
        return
    end

    vehicleData.bullhorn.Handle = GetSoundId()
	PlaySoundFromEntity(vehicleData.bullhorn.Handle, soundData.soundFile, vehicleData.entity, soundData.soundPack, 0, 0)
    MainController.DebugPrint("[ChangeBullhornState] Created Bullhorn sound for " .. vehicleData.networkedId)
end
