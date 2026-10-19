local torqueLoop, breakLoop

-- Function to set vehicle torque
SetTorque = function(value)
    if not IsPedInAnyVehicle(cache.ped, true) then 
        TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
        return 
    end
    
    if torqueLoop then
        breakLoop = true
        Wait(100) -- Wait for the loop to break
    end
    
    CreateThread(function()
        torqueLoop = true
        breakLoop = false
        local notifyTime = 0
        local vehicle = GetVehiclePedIsIn(cache.ped, false)
        
        -- Initial notification
        TriggerEvent('apex_adminmenu:notify', Strings.vehicle_torque_set, Strings.vehicle_torque_set_desc:format(value), 'success')
        
        while true do
            if breakLoop or not IsPedInAnyVehicle(cache.ped, true) then
                torqueLoop = false
                breakLoop = false
                TriggerEvent('apex_adminmenu:notify', Strings.vehicle_torque_disabled, Strings.vehicle_torque_disabled, 'error')
                break
            end
            
            if value == 1.0 then
                torqueLoop = false
                breakLoop = false
                TriggerEvent('apex_adminmenu:notify', Strings.vehicle_torque_disabled, Strings.vehicle_torque_disabled, 'error')
                break
            end
            
            SetVehicleEngineTorqueMultiplier(vehicle, value)
            
            -- Only show notification every 10 seconds to avoid spam
            local currentTime = GetGameTimer()
            if (currentTime - notifyTime) > 10000 then
                notifyTime = currentTime
                TriggerEvent('apex_adminmenu:notify', Strings.vehicle_torque_set, Strings.vehicle_torque_set_desc:format(value), 'info')
            end
            
            Wait(0)
        end
    end)
end

-- Function to lock/unlock vehicle doors
DoorStatus = function(status)
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    if status == 2 then
        SetVehicleDoorsLocked(vehicle, 2)
        TriggerEvent('apex_adminmenu:notify', Strings.notify_locked_doors, Strings.notify_locked_doors_desc, 'success', 'fa-car')
    elseif status == 1 then
        SetVehicleDoorsLocked(vehicle, 1)
        TriggerEvent('apex_adminmenu:notify', Strings.notify_unlocked_doors, Strings.notify_unlocked_doors_desc, 'success', 'fa-car')
    end
end

-- Function to change license plate
ChangePlate = function()
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    ShowInputDialog(Strings.dialog_license_plate, {
        { type = 'input', label = Strings.dialog_license_plate_label, placeholder = Strings.dialog_license_plate_placeholder }
    }, 'changePlate')
end

-- Function to change license plate text
ChangePlateText = function(plate)
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    if not plate or plate == "" then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_invalid_entry, 'error', 'fa-xmark')
    end
    
    SetVehicleNumberPlateText(vehicle, plate)
    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_plate_changed, Strings.vehicle_plate_changed_desc:format(plate), 'success', 'fa-check')
end

-- Function to delete vehicle
DeleteCar = function()
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_deleted, Strings.vehicle_deleted_desc, 'success', 'fa-check')
end

-- Function to repair vehicle
RepairCar = function()
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_repaired, Strings.vehicle_repaired_desc, 'success', 'fa-check')
end

-- Function to set vehicle mods
local setVehicleMods = function(vehicle, mods)
    if not DoesEntityExist(vehicle) or not mods then return end
    
    local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    SetVehicleModKit(vehicle, 0)
    
    if mods.plate then 
        SetVehicleNumberPlateText(vehicle, tostring(mods.plate)) 
    end
    
    if mods.color1 then 
        SetVehicleColours(vehicle, tonumber(mods.color1), secondaryColor) 
    end
    
    if mods.color2 then 
        SetVehicleColours(vehicle, tonumber(mods.color1) or primaryColor, tonumber(mods.color2)) 
    end
    
    if mods.modTurbo then 
        ToggleVehicleMod(vehicle, 18, true) -- Turbo
        
        -- Max out all vehicle mods
        for i = 0, 49 do
            local numMods = GetNumVehicleMods(vehicle, i)
            if numMods > 0 then
                SetVehicleMod(vehicle, i, numMods - 1, false)
            end
        end
        
        -- Apply other performance upgrades
        SetVehicleMod(vehicle, 11, 3, false) -- Engine
        SetVehicleMod(vehicle, 12, 2, false) -- Brakes
        SetVehicleMod(vehicle, 13, 2, false) -- Transmission
        SetVehicleMod(vehicle, 15, 3, false) -- Suspension
        SetVehicleMod(vehicle, 16, 4, false) -- Armor
        
        -- Extra upgrades
        ToggleVehicleMod(vehicle, 22, true) -- Xenon headlights
    end
end

-- Function to refuel vehicle
Refuel = function()
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    -- Set fuel level to maximum
    if Config.FuelSystem == 'ox' then
        local fuel = Entity(vehicle).state.fuel
        if fuel then
            Entity(vehicle).state.fuel = 100
        else
            SetVehicleFuelLevel(vehicle, 100.0)
        end
        TriggerServerEvent('apex_adminmenu:setFuel', NetworkGetNetworkIdFromEntity(vehicle))
    elseif Config.FuelSystem == 'legacyfuel' then
        exports['LegacyFuel']:SetFuel(vehicle, 100)
    else
        SetVehicleFuelLevel(vehicle, 100.0)
    end
    
    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_refueled, Strings.vehicle_refueled_desc, 'success', 'fa-gas-pump')
end

-- Direct spawn vehicle function (no dialog)
DirectSpawnVehicle = function(model, plate, color1, color2, maxed)


    if not model or model == "" then 
        TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
        return 
    end

    -- Normalize model name and remove any special characters
    model = model:lower():gsub('[^%w_-]', '')

    -- Get hash
    local hash = GetHashKey(model)
    
    -- Validate model
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_invalid_entry, 'error', 'fa-xmark')
        return
    end

    -- Load model
    RequestModel(hash)
    
    -- Wait for model to load with timeout
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 50 do
        timeout = timeout + 1
        Wait(10)
    end

    if not HasModelLoaded(hash) then
        TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_invalid_entry, 'error', 'fa-xmark')
        return
    end

    -- Get spawn position
    local playerPed = cache.ped
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    
    -- Offset the spawn position to avoid collision with player
    local spawnPos = vector3(
        coords.x + (forward.x * 4.0),
        coords.y + (forward.y * 4.0),
        coords.z
    )

    -- Create vehicle
    local vehicle = CreateVehicle(hash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, false)
    
    if not DoesEntityExist(vehicle) then
        TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_invalid_entry, 'error', 'fa-xmark')
        SetModelAsNoLongerNeeded(hash)
        return
    end

    -- Set vehicle properties
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    
    -- Set plate if provided
    if plate and plate ~= "" then
        SetVehicleNumberPlateText(vehicle, plate)
    end
    
    -- Convert color to number if it's a string
    if type(color1) == "string" then
        color1 = tonumber(color1)
    end
    
    if type(color2) == "string" then
        color2 = tonumber(color2)
    end
    
    -- Set colors if provided
    if color1 or color2 then
        SetVehicleColours(vehicle, color1 or 0, color2 or 0)
    end
    
    -- Apply performance upgrades if maxed
    if maxed == true or maxed == "true" then
        SetVehicleModKit(vehicle, 0)
        
        -- Engine
        SetVehicleMod(vehicle, 11, 3, false)
        -- Brakes
        SetVehicleMod(vehicle, 12, 2, false)
        -- Transmission
        SetVehicleMod(vehicle, 13, 2, false)
        -- Suspension
        SetVehicleMod(vehicle, 15, 3, false)
        -- Armor
        SetVehicleMod(vehicle, 16, 4, false)
        -- Turbo
        ToggleVehicleMod(vehicle, 18, true)
        -- Xenon Headlights
        ToggleVehicleMod(vehicle, 22, true)
    end

    -- Final vehicle setup
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleDoorsLocked(vehicle, 0)
    SetVehicleOnGroundProperly(vehicle)

    -- Give keys if configured
    if Config.UsingVehicleKeys and Config.UsingVehicleKeys ~= '' then
        Wait(100) -- Small delay to ensure vehicle is properly registered
        GiveVehKeys(GetVehicleNumberPlateText(vehicle), model, vehicle)
    end

    -- Put player in vehicle
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

    -- Cleanup
    SetModelAsNoLongerNeeded(hash)
    
    -- Success notification
    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_spawned, Strings.vehicle_spawned_desc:format(model), 'success', 'fa-car')
end

-- Function to show custom vehicle dialog directly
ShowCustomVehicleDialog = function()
    -- IMPORTANTE: NÃO fechar o menu nem remover o foco do NUI aqui
    -- Isso mantém o cursor visível para interagir com o diálogo
    
    local colorOptions = {}
    for i = 1, #Config.VehicleColors do
        colorOptions[#colorOptions + 1] = {
            label = Config.VehicleColors[i].label,
            value = tostring(Config.VehicleColors[i].value)
        }
    end
    
    ShowInputDialog(Strings.dialog_spawn_a_car, {
        { type = 'input', label = Strings.dialog_car_model, placeholder = Strings.dialog_car_model_holder },
        { type = 'input', label = Strings.dialog_car_plate, placeholder = Strings.dialog_car_plate_holder },
        { type = 'select', label = Strings.dialog_car_color_primary, options = colorOptions },
        { type = 'checkbox', label = Strings.dialog_car_maxed, checked = false }
    }, 'customVehicle')
end

-- Function to spawn a vehicle - Now goes directly to custom vehicle dialog
SpawnCar = function()
    -- Go directly to custom vehicle dialog
    ShowCustomVehicleDialog()
end

-- Helper function to check if spawn point is clear
IsSpawnPointClear = function(coords, radius)
    return not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, radius)
end

-- Function to change vehicle color
ChangeVehColor = function(value)
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    local data = { color1 = value, color2 = value }
    setVehicleMods(vehicle, data)
    
    local colorName = "Unknown"
    for i = 1, #Config.VehicleColors do
        if Config.VehicleColors[i].value == value then
            colorName = Config.VehicleColors[i].label
            break
        end
    end
    
    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_color_changed, Strings.vehicle_color_changed_desc:format(colorName), 'success', 'fa-palette')
end

-- Function to give vehicle keys
GiveKeys = function()
    if not Config.UsingVehicleKeys then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_disabled_keys, 'error', 'fa-xmark')
    end
    
    local coords = GetEntityCoords(cache.ped)
    local vehicle
    
    if IsPedInAnyVehicle(cache.ped, false) then
        vehicle = GetVehiclePedIsIn(cache.ped, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)

    if not GiveVehKeys(plate, GetEntityModel(vehicle), vehicle) then
        -- No key resource matched. Say so instead of claiming success.
        return TriggerEvent('apex_adminmenu:notify', Strings.notify_error, Strings.notify_disabled_keys, 'error', 'fa-xmark')
    end

    TriggerEvent('apex_adminmenu:notify', Strings.vehicle_keys_given, Strings.vehicle_keys_given_desc:format(plate), 'success', 'fa-key')
end

-- Function to give vehicle keys based on the configured system.
-- The per-provider details live in configs/compat.lua so qbx_vehiclekeys,
-- qb-vehiclekeys, wasabi, Renewed, quasar, jaksam, … all work without
-- touching this file. `vehicle` is what matters — plate/model are only
-- kept for callers (and custom implementations) that still pass them.
GiveVehKeys = function(plate, model, vehicle)
    if not vehicle or vehicle == 0 then
        -- Older call sites only had the plate. Resolve the entity from it.
        if IsPedInAnyVehicle(cache.ped, false) then
            vehicle = GetVehiclePedIsIn(cache.ped, false)
        else
            local c = GetEntityCoords(cache.ped)
            vehicle = GetClosestVehicle(c.x, c.y, c.z, 5.0, 0, 71)
        end
    end

    return Apex.Compat.GiveVehicleKeys(vehicle)
end

-- Main vehicle options menu
VehicleOptions = function()
    local options = {
        {
            icon = 'fas fa-car-on',
            label = Strings.spawn_car,
            description = Strings.spawn_car_desc
        },
        {
            icon = 'fas fa-screwdriver-wrench',
            close = false,
            label = Strings.repair_car,
            description = Strings.repair_car_desc
        },
        {
            icon = 'fas fa-trash',
            close = false,
            label = Strings.delete_car,
            description = Strings.delete_car_desc
        },
        {
            icon = 'fas fa-pen',
            label = Strings.number_plate,
            description = Strings.number_plate_desc
        },
        {
            icon = 'fas fa-gas-pump',
            close = false,
            label = Strings.refuel,
            description = Strings.refuel_desc
        },
        {
            icon = 'fas fa-key',
            close = false,
            label = Strings.give_keys,
            description = Strings.give_keys_desc
        },
        {
            icon = 'fas fa-unlock-keyhole',
            label = Strings.doors,
            description = Strings.doors_desc,
            values = { 'Unlock', 'Lock' },
            defaultIndex = 0,
            close = false
        },
        {
            icon = 'fas fa-bolt',
            label = Strings.boost_car,
            description = Strings.boost_car_desc,
            values = Config.TorqueMultiplier,
            defaultIndex = 0,
            close = false
        },
        {
            icon = 'fas fa-palette',
            label = Strings.color_change,
            description = Strings.color_change_desc,
            values= Config.VehicleColors,
            defaultIndex = 0,
            close = false
        },
        { -- index 9
            icon = 'fas fa-car-burst',
            close = false,
            label = Strings.recover_car,
            description = Strings.recover_car_desc
        }
    }

    SendNUIMessage({
        action = 'openSubMenu',
        title = Strings.vehicle_menu,
        items = options,
        parent = 'main'
    })

    -- Register NUI callback for this menu
    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == Strings.vehicle_menu then
            if data.index == 0 then
                SpawnCar()
            elseif data.index == 1 then
                RepairCar()
            elseif data.index == 2 then
                DeleteCar()
            elseif data.index == 3 then
                ChangePlate()
            elseif data.index == 4 then
                Refuel()
            elseif data.index == 5 then
                GiveKeys()
            elseif data.index == 9 then
                RecoverVehicle()
            end
        end
        cb('ok')
    end)
end

-- Register command for direct vehicle spawning.
-- Gated on the SAME server-side permission callback the menu uses —
-- without this any player could type /spawnveh and get a car.
RegisterCommand('spawnveh', function(source, args)
    local hasPerms = lib.callback.await('apex_adminmenu:checkPerms', 100)
    if not hasPerms then return end

    local model = args[1] or "adder"
    local plate = args[2] or "ADMIN"
    local color = tonumber(args[3]) or 0
    local maxed = args[4] == "true"

    DirectSpawnVehicle(model, plate, color, color, maxed)
end, false)

TriggerEvent('chat:removeSuggestion', '/spawnveh')
