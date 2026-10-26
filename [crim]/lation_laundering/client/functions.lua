local ox_inv = GetResourceState('ox_inventory') == 'started'

-- You can change the textUI script here
-- Options: 'lation_ui', 'ox_lib', 'jg-textui', 'okokTextUI', 'qbcore' & 'custom'
local textui = 'lation_ui'

-- Function to show a notification
--- @param message string
--- @param type string
ShowNotification = function(message, type)
    if Config.Notify == 'lation_ui' then
        exports.lation_ui:notify({ title = 'Money Laundering', message = message, type = type, icon = 'fas fa-money-bill-wave' })
    elseif Config.Notify == 'ox_lib' then
        lib.notify({ title = 'Money Laundering', description = message, type = type, position = 'top', icon = 'fas fa-money-bill-wave' })
    elseif Config.Notify == 'esx' then
        ESX.ShowNotification(message)
    elseif Config.Notify == 'qb' then
        QBCore.Functions.Notify(message, type)
    elseif Config.Notify == 'okok' then
        exports['okokNotify']:Alert('Money Laundering', message, 5000, type, false)
    elseif Config.Notify == 'sd-notify' then
        exports['sd-notify']:Notify('Money Laundering', message, type)
    elseif Config.Notify == 'wasabi_notify' then
        exports.wasabi_notify:notify('Money Laundering', message, 5000, type, false, 'fas fa-money-bill-wave')
    elseif Config.Notify == 'custom' then
        -- Add custom notification export/event here
    end
end

-- Event used to display notifications from server
--- @param message string
--- @param type string
RegisterNetEvent('lation_laundering:Notify', function(message, type)
    ShowNotification(message, type)
end)

-- Function used to set vehicle fuel
--- @param vehicle number
SetFuel = function(vehicle)
    -- Check if LegacyFuel is running
    if GetResourceState('LegacyFuel') == 'started' then
        exports['LegacyFuel']:SetFuel(vehicle, Config.Vehicle.fuel)
    end
    -- Check if cdn-fuel is running
    if GetResourceState('cdn-fuel') == 'started' then
        exports['cdn-fuel']:SetFuel(vehicle, Config.Vehicle.fuel)
    end
    -- Check if ps-fuel is running
    if GetResourceState('ps-fuel') == 'started' then
        exports['ps-fuel']:SetFuel(vehicle, Config.Vehicle.fuel)
    end
    -- Check if lj-fuel is running
    if GetResourceState('lj-fuel') == 'started' then
        exports['lj-fuel']:SetFuel(vehicle, Config.Vehicle.fuel)
    end
    -- Check if okokGasStation is running
    if GetResourceState('okokGasStation') == 'started' then
        exports['okokGasStation']:SetFuel(vehicle, Config.Vehicle.fuel)
    end
    -- Check if nd_fuel is running
    if GetResourceState('nd_fuel') == 'started' then
        exports['nd_fuel']:SetFuel(vehicle, Config.Vehicle.fuel)
    end
    Entity(vehicle).state.fuel = Config.Vehicle.fuel
end

-- Function used to give keys to vehicle
--- @param vehicle number
GiveKeys = function(vehicle)
    -- Get vehicle plate & model
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    -- Check if wasabi_carlock is running
    if GetResourceState('wasabi_carlock') == 'started' then
        exports.wasabi_carlock:GiveKey(plate)
    end
    -- Check if okokGarage is running
    if GetResourceState('okokGarage') == 'started' then
        TriggerServerEvent("okokGarage:GiveKeys", plate)
    end
    -- Check if qb-vehiclekeys is running
    if GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerEvent('qb-vehiclekeys:client:AddKeys', plate)
    end
    -- Check if qs-vehiclekeys is running
    if GetResourceState('qs-vehiclekeys') == 'started' then
        exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
    end
    -- Check if cd_garage is running
    if GetResourceState('cd_garage') == 'started' then
        TriggerEvent('cd_garage:AddKeys', plate)
    end
    -- Check if jaksam's vehicles_keys is running
    if GetResourceState('vehicles_keys') == 'started' then
        TriggerServerEvent('vehicles_keys:selfGiveVehicleKeys', plate)
    end
    -- Check if t1ger_keys is running
    if GetResourceState('t1ger_keys') == 'started' then
        TriggerServerEvent('t1ger_keys:updateOwnedKeys', plate, true)
    end
    -- Check if Renewed-Vehiclekeys is running
    if GetResourceState('Renewed-Vehiclekeys') == 'started' then
        exports['Renewed-Vehiclekeys']:addKey(plate)
    end
end

-- Function that allows or rejects a player from opening main menu
CanOpenMenu = function()
    -- Example implementation to show how this works
    -- First, we're checking if the player is dead
    local dead = IsPedDeadOrDying(cache.ped, false)
    -- If the variable "dead" is true, it'll return false below
    -- Which will not allow the menu to open
    if dead then
        -- Here is where you would display a notification providing
        -- Some information to the player about why the menu won't open
        return false
    end
    -- If "dead" is false, then the code proceeds to here
    -- Which now returns "true", allowing the menu to open
    return true
end

-- Function that allows or rejects a player from purchasing warehouse key
CanBuyKey = function()
    -- This function works the same as the above CanOpenMenu
    -- Except obviously for the purchasing of the warehouse key
    -- We'll provide another example implementation below:
    -- Let's say we wanted to restrict buying keys to gangs only
    -- You would obviously replace "true" with your gang system export
    -- That would check if a player was in a gang or not
    local inGang = true
    -- Next we add an if-then statement below, so if not inGang then..
    if not inGang then
        -- We return false! Thus not allowing the player to purchase
        -- A warehouse key if they are not a gang member. We would also
        -- Likely inform the player here with a notification like:
        -- ShowNotification('You must be a gang member to purchase this', 'error')
        return false
    end
    -- If the player IS a gang member, then we'll make it to this part of
    -- The code and then simply return true, allowing them to purchase a key
    return true
end

-- Function that runs to verify conditions before allowing warehouse entry
CanEnterWarehouse = function()
    -- Initialize variables
    local result, isPolice = true, false
    -- Check if police exception exists
    if Config.Police.warehouseAccess then
        local player = GetPlayerData()
        for _, job in pairs(Config.Police.jobs) do
            if player.job.name == job then
                isPolice = true
            end
        end
    end
    -- Check if player has the key
    local hasKey = HasItem(Config.Items.key, 1)
    if not hasKey and not isPolice then
        ShowNotification(Strings.Notify.notAuthorized, 'error')
        result = false
    end
    -- Check if we're enforcing level requirement
    if Config.Warehouse.requireLvl then
        local level = exports.lation_laundering:GetData('level')
        if level < Config.Warehouse.unlockAt and not isPolice then
            ShowNotification(Strings.Notify.notAuthorized, 'error')
            result = false
        end
    end
    -- If you want to add custom requirements to entering the warehouse
    -- This is where you would make that happen
    return result
end

-- Function that's triggered when started counting money
-- This function can be used for anything, but by default
-- It disables the ability to open your inventory during
-- The money counting process
StartedCounting = function()
    -- Check if ox_inventory is running
    if GetResourceState('ox_inventory') == 'started' then
        LocalPlayer.state.invBusy = true
    end
    -- Check if qb-inventory is running
    if GetResourceState('qb-inventory') == 'started' then
        LocalPlayer.state.inv_busy = true
    end
    -- Check if qs-inventory is running
    if GetResourceState('qs-inventory') == 'started' then
        exports['qs-inventory']:setInventoryDisabled(true)
    end
end

-- Function that's triggered when stopped counting money
-- As mentioned above, this function can be used for anything
-- After a player has completed counting money, it will 
-- Re-enable access to their inventory
StoppedCounting = function()
    -- Check if ox_inventory is running
    if GetResourceState('ox_inventory') == 'started' then
        LocalPlayer.state.invBusy = false
    end
    -- Check if qb-inventory is running
    if GetResourceState('qb-inventory') == 'started' then
        LocalPlayer.state.inv_busy = false
    end
    -- Check if qs-inventory is running
    if GetResourceState('qs-inventory') == 'started' then
        exports['qs-inventory']:setInventoryDisabled(false)
    end
end

-- Function that's triggered when a player has entered the warehouse
EnteredWarehouse = function()

end

-- Function that's triggered when a player has exited the warehouse
ExitedWarehouse = function()

end

-- Function that's triggered when starting contracts
StartedLaundering = function()

end

-- Function that's triggered when stopping contracts
StoppedLaundering = function()

end

-- Function to handle dispatch notifications
--- @param dispatch table .coords, .street
PoliceDispatch = function(dispatch)
    if Config.Police.dispatchSystem == 'linden_outlawalert' then
        local d = {displayCode = '10-911', description = 'Suspicious Activity', isImportant = 0, recipientList = Config.Police.jobs, length = '10000', infoM = 'fa-info-circle', info = 'A citizen has reported suspicious activity on ' ..dispatch.street}
        local dispatchData = { dispatchData = d, caller = 'Citizen', coords = dispatch.coords }
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    elseif Config.Police.dispatchSystem == 'cd_dispatch' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Police.jobs,
            coords = data.coords,
            title = '10-911 - Suspicious Activity',
            message = 'A citizen has reported suspicious activity on ' ..data.street,
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 51,
                scale = 1.0,
                colour = 1,
                flashes = false,
                text = '10-911 | Suspicious Activity',
                time = 5,
                radius = 0,
            }
        })
    elseif Config.Police.dispatchSystem == 'ps-dispatch' then
        exports["ps-dispatch"]:CustomAlert({
            coords = dispatch.coords,
            message = "A citizen has reported suspicious activity on " ..dispatch.street,
            dispatchCode = "10-911 | Suspicious Activity",
            description = "Suspicious Activity",
            radius = 0,
            sprite = 64,
            color = 2,
            scale = 1.0,
            length = 3,
        })
    elseif Config.Police.dispatchSystem == 'qs-dispatch' then
        local playerData = exports['qs-dispatch']:GetPlayerInfo()
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.Police.jobs,
            callLocation = playerData.coords,
            callCode = { code = '10-911', snippet = 'Suspicious Activity' },
            message = 'A citizen has reported suspicious activity on ' ..playerData.street_1,
            flashes = false,
            image = nil,
            blip = {
                sprite = 488,
                scale = 1.5,
                colour = 1,
                flashes = true,
                text = 'Suspicious Activity',
                time = (6 * 60 * 1000),
            }
        })
    elseif Config.Police.dispatchSystem == 'core_dispatch' then
        local gender = IsPedMale(cache.ped) and 'male' or 'female'
        TriggerServerEvent("core_dispatch:addCall", "10-911", "Suspicious Activity",
            {{icon = "fa-venus-mars", info = gender}},
            {dispatch.coords.x, dispatch.coords.y, dispatch.coords.z},
            'police', 30000, 156, 1, false)
    elseif Config.Police.dispatchSystem == 'rcore_dispatch' then
        local player_data = exports['rcore_dispatch']:GetPlayerData()
        local data = {
            code = '10-911 - Suspicious Activity',
            default_priority = 'low',
            coords = player_data.coords,
            job = Config.Police.jobs,
            text = 'A citizen has reported suspicious activity on ' ..player_data.street_1,
            type = 'alerts',
            blip = {
                sprite = 54,
                colour = 3,
                scale = 0.7,
                text = '10-911 - Suspicious Activity',
                flashes = false,
                radius = 0,
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    elseif Config.Police.dispatchSystem == 'aty_dispatch' then
        TriggerEvent('aty_dispatch:SendDispatch', 'Suspicious Activity', '10-911', 54, Config.Police.jobs)
    elseif Config.Police.dispatchSystem == 'custom' then
        -- Add your custom dispatch system here
    else
        -- No dispatch system was found
        if Config.Police.enableDispatch then
            print('No dispatch system was identified - please update your Config.Police.dispatchSystem')
        end
    end
end

-- Function to handle sending a message to specific phone
SendPhoneMessage = function()
    if Config.Phone == 'qb-phone' then
        TriggerServerEvent('lation_laundering:phoneMessage', cache.serverId)
    elseif Config.Phone == 'npwd' then
        local number = exports.npwd:getPhoneNumber()
        TriggerServerEvent('lation_laundering:phoneMessage', cache.serverId, number)
    elseif Config.Phone == 'qs-smartphone' then
        TriggerServerEvent('lation_laundering:phoneMessage', cache.serverId)
    elseif Config.Phone == 'qs-smartphonepro' then
        local data = { sender = Strings.Phone.sender, subject = Strings.Phone.subject, message = Strings.Phone.message }
        TriggerServerEvent('phone:sendNewMail', data)
    elseif Config.Phone == 'lb-phone' then
        TriggerServerEvent('lation_laundering:phoneMessage', cache.serverId)
    elseif Config.Phone == 'gksphone' then
        local number = exports["gksphone"]:PhoneNumber()
        TriggerServerEvent('gksphone:gksc:sendMessage', number, Strings.Phone.message)
    elseif Config.Phone == 'yseries' then
        TriggerServerEvent('lation_laundering:phoneMessage', cache.serverId)
    elseif Config.Phone == 'custom' then
        -- Configure 'custom' phone system here
    end
end

-- Display a progress bar
--- @param data table
function ProgressBar(data)
    if Config.Progress == 'lation_ui' then
        if exports.lation_ui:progressBar({
            label = data.label,
            description = data.description or nil,
            icon = data.icon or nil,
            duration = data.duration,
            useWhileDead = data.useWhileDead,
            canCancel = data.canCancel,
            steps = data.steps or nil,
            disable = data.disable,
            anim = {
                dict = data.anim.dict or nil,
                clip = data.anim.clip or nil,
                flag = data.anim.flag or nil
            },
            prop = {
                model = data.prop.model or nil,
                bone = data.prop.bone or nil,
                pos = data.prop.pos or nil,
                rot = data.prop.rot or nil
            }
        }) then
            return true
        end
        return false
    elseif Config.Progress == 'ox_lib' then
        -- Want to use ox_lib's progress circle instead of bar?
        -- Change "progressBar" to "progressCircle" below & done!
        if lib.progressBar({
            label = data.label,
            duration = data.duration,
            position = data.position or 'bottom',
            useWhileDead = data.useWhileDead,
            canCancel = data.canCancel,
            disable = data.disable,
            anim = {
                dict = data.anim.dict or nil,
                clip = data.anim.clip or nil,
                flag = data.anim.flag or nil
            },
            prop = {
                model = data.prop.model or nil,
                bone = data.prop.bone or nil,
                pos = data.prop.pos or nil,
                rot = data.prop.rot or nil
            }
        }) then
            return true
        end
        return false
    elseif Config.Progress == 'qbcore' then
        local p = promise.new()
        QBCore.Functions.Progressbar(data.label, data.label, data.duration, data.useWhileDead, data.canCancel, {
            disableMovement = data.disable.move,
            disableCarMovement = data.disable.car,
            disableMouse = false,
            disableCombat = data.disable.combat
        }, {
            animDict = data.anim.dict or nil,
            anim = data.anim.clip or nil,
            flags = data.anim.flag or nil
        }, {
            model = data.prop.model or nil,
            bone = data.prop.bone or nil,
            coords = data.prop.pos or nil,
            rotation = data.prop.rot or nil
        }, {},
        function()
            ClearPedTasks(cache.ped)
            p:resolve(true)
        end,
        function()
            ClearPedTasks(cache.ped)
            p:resolve(false)
        end)
        return Citizen.Await(p)
    else
        -- Add 'custom' progress bar here
    end
end

-- Function used to display TextUI
--- @param text string 
--- @param icon string
ShowTextUI = function(text, icon)
    if textui == 'lation_ui' then
        local isOpen, _ = exports.lation_ui:isOpen()
        if isOpen then return end
        exports.lation_ui:showText({
            description = text,
            icon = icon
        })
    elseif textui == 'ox_lib' then
        local isOpen, _ = lib.isTextUIOpen()
        if isOpen then return end
        lib.showTextUI(text, {
            position = 'left-center',
            icon = icon
        })
    elseif textui == 'jg-textui' then
        exports['jg-textui']:DrawText(text)
    elseif textui == 'okokTextUI' then
        exports['okokTextUI']:Open(text, 'lightblue ', 'left', false)
    elseif textui == 'qbcore' then
        exports['qb-core']:DrawText(text, 'left')
    else
        -- Add custom textUI here
    end
end

-- Function used to hide/remove TextUI
--- @param label string
HideTextUI = function(label)
    if textui == 'lation_ui' then
        local isOpen, text = exports.lation_ui:isOpen()
        if isOpen and text == label then
            exports.lation_ui:hideText()
        end
    elseif textui == 'ox_lib' then
        local isOpen, text = lib.isTextUIOpen()
        if isOpen and text == label then
            lib.hideTextUI()
        end
    elseif textui == 'jg-textui' then
        exports['jg-textui']:HideText()
    elseif textui == 'okokTextUI' then
        exports['okokTextUI']:Close()
    elseif textui == 'qbcore' then
        exports['qb-core']:HideText()
    else
        -- Add custom textUI here
    end
end

-- Function to add circle target zones
--- @param data table
AddCircleZone = function(data)
    if Config.Target == 'ox_target' then
        exports.ox_target:addSphereZone(data)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddCircleZone(data.name, data.coords, data.radius, {
            name = data.name,
            debugPoly = Config.Debug}, {
            options = data.options,
            distance = 2,
        })
    elseif Config.Target == 'qtarget' then
        exports.qtarget:AddCircleZone(data.name, data.coords, data.radius, {
            name = data.name,
            debugPoly = Config.Debug}, {
            options = {data.options},
            distance = 2,
        })
    elseif Config.Target == 'custom' then
        -- Add support for a custom target system here
    elseif Config.Target == 'none' then
        -- TextUI is being used
    else
        print('No target system defined in the config file.')
    end
end

-- Add target to entity
--- @param entity number Entity number
--- @param data table Options table
AddTargetEntity = function(entity, data)
    if Config.Target == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, data)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {options = data, distance = 2.0})
    elseif Config.Target == 'qtarget' then
        exports.qtarget:AddTargetEntity(entity, {options = data, distance = 2.0})
    elseif Config.Target == 'custom' then
        -- Add support for a custom target system here
    else
        print('No target system defined in the config file.')
    end
end

-- Function to remove circle target zones
--- @param id number | string
RemoveCircleZone = function(id)
    if Config.Target == 'ox_target' then
        exports.ox_target:removeZone(id)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:RemoveZone(id)
    elseif Config.Target == 'qtarget' then
        exports.qtarget:RemoveZone(id)
    elseif Config.Target == 'custom' then
        -- Add support for a custom target system here
    elseif Config.Target == 'none' then
        -- TextUI is being used
    else
        print('No target system defined in the config file.')
    end
end

-- Remove target from entity
--- @param entity number
--- @param data table|string|nil
RemoveTargetEntity = function(entity, data)
    if Config.Target == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, data)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity, nil)
    elseif Config.Target == 'qtarget' then
        exports.qtarget:RemoveTargetEntity(entity, data)
    elseif Config.Target == 'custom' then
        -- Add support for a custom target system here
    else
        print('No target system defined in the config file.')
    end
end

-- Function that returns true or false if player has item
--- @param item string
--- @param amount number
HasItem = function(item, amount)
    if not item then return end
    if ox_inv then
        local count = exports.ox_inventory:Search('count', item)
        if count >= amount then
            return true
        end
        return false
    end
    if Framework == 'esx' then
        if not ESX.GetPlayerData() or not ESX.GetPlayerData().inventory then
            return false
        end
        local inventory = ESX.GetPlayerData().inventory
        for _, itemData in pairs(inventory) do
            if itemData.name == item then
                local count = itemData.count or itemData.amount
                if count >= amount then
                    return true
                end
            end
        end
        return false
    elseif Framework == 'qb' then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if not PlayerData or not PlayerData.items then
            return false
        end
        for _, itemData in pairs(PlayerData.items) do
            if itemData and itemData.name == item then
                local count = itemData.amount or itemData.count
                if count >= amount then
                    return true
                end
            end
        end
        return false
    else
        -- Add support for a custom framework here
    end
end

-- Function that returns count of item in inventory
--- @param item string
ItemCount = function(item)
    if not item then return end
    if ox_inv then
        local count = exports.ox_inventory:Search('count', item)
        return count or 0
    end
    if Framework == 'esx' then
        if not ESX.GetPlayerData() or not ESX.GetPlayerData().inventory then
            return 0
        end
        local inventory = ESX.GetPlayerData().inventory
        for _, itemData in pairs(inventory) do
            if itemData.name == item then
                local count = itemData.count or itemData.amount
                return count or 0
            end
        end
        return 0
    elseif Framework == 'qb' then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if not PlayerData or not PlayerData.items then
            return 0
        end
        for _, itemData in pairs(PlayerData.items) do
            if itemData and itemData.name == item then
                local count = itemData.amount or itemData.count
                return count or 0
            end
        end
        return 0
    else
        -- Add support for a custom framework here
    end
end

-- Function to spawn peds
--- @param model string
--- @param position vector4 | vector3
SpawnPed = function(model, position)
    lib.requestModel(model, 1500)
    while not HasModelLoaded(model) do Wait(0) end
    local ped = CreatePed(0, model, position.x, position.y, position.z - 1.0, position.w, false, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    return ped
end

-- Function used to spawn vehicles
--- @param model string
--- @param position vector4 | vector3
SpawnVehicle = function(model, position)
    lib.requestModel(model, 1500)
    while not HasModelLoaded(model) do Wait(0) end
    local vehicle = CreateVehicle(model, position.x, position.y, position.z, position.w, true, true)
    return vehicle
end