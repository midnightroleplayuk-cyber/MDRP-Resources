if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

if GetResourceState("esx_society") ~= 'missing' then
    TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})
end

function CreateUseableItem(name, cb)
    return Inventory[GetInventoryTool()].CreateUseableItem(name, cb)
end

function GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        return xPlayer.identifier
    end
end

AddEventHandler("esx:playerLoaded", function(playerId)
    if CachePlayerWoundIdentity then
        CachePlayerWoundIdentity(playerId)
    end
    TriggerClientEvent("osp_ambulance:loadScreens", playerId)
end)

AddEventHandler('esx:playerLogout', function(source, cb)
    local src = source
    local data = GetCachedWoundData and GetCachedWoundData(src) or Player(src).state.BodyDamage
    if PersistWoundData then
        PersistWoundData(src, data)
    else
        local sourcePlayer = GetPlayer(src)
        if sourcePlayer and type(data) == 'table' then
            MySQL.Async.execute('UPDATE users SET woundData = @woundData WHERE identifier = @identifier', {
                ['@woundData'] = json.encode(data),
                ['@identifier'] = sourcePlayer.identifier,
            })
        end
    end
    if FlushRuntimeWoundData then
        FlushRuntimeWoundData(src)
    end
    if ClearCachedWoundData then
        ClearCachedWoundData(src, true)
    end
end)

function ClearInventory(sourcePlayer)
    return Inventory[GetInventoryTool()].ClearInventory(sourcePlayer)
end

function IsFrameworkAdmin(source)
    if not source or source == 0 then return false end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    local group = xPlayer.getGroup and xPlayer.getGroup() or xPlayer.group
    return group == 'admin' or group == 'superadmin'
end

function getFrameworkBloodType(playerID)
    local xPlayer = GetPlayer(tonumber(playerID) or playerID)
    if not xPlayer then return nil end

    local bloodType = nil
    if xPlayer.getMeta then
        local ok, value = pcall(function()
            return xPlayer.getMeta('bloodtype')
        end)
        if ok then bloodType = value end
    end
    if (type(bloodType) ~= 'string' or bloodType == '') and xPlayer.get then
        local ok, value = pcall(function()
            return xPlayer.get('bloodtype')
        end)
        if ok then bloodType = value end
    end
    if type(bloodType) == 'string' and bloodType ~= '' then
        return bloodType
    end
    return nil
end

function setFrameworkBloodType(playerID, bloodType)
    if type(bloodType) ~= 'string' or bloodType == '' then return end
    local xPlayer = GetPlayer(tonumber(playerID) or playerID)
    if not xPlayer then return end

    if xPlayer.setMeta then
        pcall(function()
            xPlayer.setMeta('bloodtype', bloodType)
        end)
        return
    end
    if xPlayer.set then
        pcall(function()
            xPlayer.set('bloodtype', bloodType)
        end)
    end
end

RegisterServerEvent("osp_ambulance:addItem")
AddEventHandler("osp_ambulance:addItem", function(name, amount, info)
    if amount == nil then amount = 1 end
    local authItem = false
    for k,v in pairs(Config.Casts) do
        for _,x in pairs(v.casts) do
            if x.itemName == name then
                authItem = true
            end
        end
    end

    for _, v in pairs(Config.bloodTypes) do
        if ('blood500ml_' .. v.itemName) == name then
            authItem = true
        end
    end

    if name == 'bloodsample' or name == 'expiredblood' then
        authItem = true
    end

    if name == 'stretcher' or name == 'tourniquet' or name == 'ecg' or name == 'medical_bag' then 
        authItem = true
    end

    if IsPrescriptionItem and IsPrescriptionItem(name) then
        authItem = true
    end

    if not authItem then 
        print('NON AUTHORIZED ITEM SPAWNING BY ID: ', source)
        return
    end
    local src = source
    AddItem(src, name, amount, info)
end)

function AddItem(src, name, amount, info)
    return Inventory[GetInventoryTool()].AddItem(src, name, amount, info)
end

function RemoveItem(src, name, amount)
    return Inventory[GetInventoryTool()].RemoveItem(src, name, amount)
end

function RemoveItemBySlot(src, slot, amount)
    local adapter = Inventory[GetInventoryTool()]
    if adapter and adapter.RemoveItemBySlot then
        return adapter.RemoveItemBySlot(src, slot, amount or 1)
    end
    return false
end

RegisterServerEvent("osp_ambulance:removeItem")
AddEventHandler("osp_ambulance:removeItem", function(name, amount)
    if amount == nil then amount = 1 end
    local src = source
    RemoveItem(src, name, amount)
end)

RegisterServerEvent('osp_ambulance:setItemMetadata')
AddEventHandler('osp_ambulance:setItemMetadata', function(slot, info)
    return Inventory[GetInventoryTool()].SetItemMetadata(source, slot, info)
end)

function CheckMoney(source)
    local src = source
    local sourcePlayer = GetPlayer(source)
    local currentCash = sourcePlayer.getAccount('bank').money
    return currentCash
end

function RemoveMoney(source, amount)
    local src = source
    local sourcePlayer = GetPlayer(src)
    if sourcePlayer.getMoney() >= amount then
        sourcePlayer.removeMoney(amount)
    elseif sourcePlayer.getAccount('bank').money >= amount then
        sourcePlayer.removeAccountMoney('bank', amount)
    end
end


lib.callback.register('osp_ambulance:getName', function(source, data)
    local sourcePlayer = GetPlayer(source)
    if not sourcePlayer then return end
    if not sourcePlayer.identifier then return end
    local result = MySQL.query.await('SELECT firstname, lastname FROM `users` WHERE identifier = ?', {
        sourcePlayer.identifier
    })
    if result[1] and result[1].firstname and result[1].lastname then
        return {firstname = result[1].firstname, lastname = result[1].lastname}
    else
        return nil
    end
end)

-- Commands

ESX.RegisterCommand('911ems', 'user', function(xPlayer, args, showError)
    local src = xPlayer.source
    local message
    if args[1] then message = table.concat(args, " ") else message = GetLang().info.civ_call end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local serverPlayers = GetPlayers()
    for k,v in pairs(serverPlayers) do
        local sourcePlayer = GetPlayer(v)
        if sourcePlayer then
            for _,x in pairs(Config.AmbulanceJobs) do
                if sourcePlayer.job.name == x then
                    TriggerClientEvent('hospital:client:ambulanceAlert', v, coords, message)
                end
            end
        end
    end
end, false, {help = GetLang().info.message_sent})

ESX.RegisterCommand('revive', 'admin', function(xPlayer, args, showError)
    if args.id then
        TriggerClientEvent('hospital:client:Revive', args.id, true)
    else
        TriggerClientEvent('hospital:client:Revive', xPlayer.source, true)
    end
end, true, {help = 'revive', validate = true, arguments = {
    {name = 'id', help = GetLang().info.player_id, type = 'playerId'}
}})

ESX.RegisterCommand('kill', 'admin', function(xPlayer, args, showError)
    local src = xPlayer.source
    if args.id  then
        local sourcePlayer = GetPlayer(args.id)
        if sourcePlayer then
            TriggerClientEvent('hospital:client:KillPlayer', args.id)
        else
            TriggerClientEvent('osp_ambulance:SendTextMessage', src, 'Chat', 'Player was not online', 3000, 'error')
        end
    else
        TriggerClientEvent('hospital:client:KillPlayer', src)
    end
end, false, {help = 'kill', validate = false, arguments = {
    {name = 'id',validate = false, help = GetLang().info.player_id, type = 'playerId'}
}}) 

lib.callback.register('osp_ambulance:getWoundData', function(source)
    if LoadPersistedWoundData then
        return LoadPersistedWoundData(source)
    end

    local sourcePlayer = GetPlayer(source)
    if not sourcePlayer then
        return
    end

    local res = MySQL.single.await('SELECT `woundData` FROM users WHERE `identifier` = ? LIMIT 1', {
        GetIdentifier(source)
    })
    if not res or not res.woundData or res.woundData == '' then
        return false
    end

    local ok, data = pcall(json.decode, res.woundData)
    return (ok and type(data) == 'table') and data or false
end)

lib.callback.register('osp_ambulance:getInventory', function(source, data)
    local inventoryTool = Inventory[GetInventoryTool()]
    if not inventoryTool or not inventoryTool.GetInventory then
        return {}
    end

    return inventoryTool.GetInventory(source) or {}
end)

RegisterServerEvent("osp_ambulance:saveWoundDataSv")
AddEventHandler("osp_ambulance:saveWoundDataSv", function(data)
    if type(data) ~= 'table' then return end

    if PersistWoundData then
        PersistWoundData(source, data)
        return
    end

    local sourcePlayer = GetPlayer(source)
    if not sourcePlayer then
        return
    end
    MySQL.Async.execute('UPDATE users SET woundData = @woundData WHERE identifier = @identifier', {
        ['@woundData'] = json.encode(data),
        ['@identifier'] = sourcePlayer.identifier,
    })
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead) -- Used to set the death status of a player, used by other qbcore scripts for easy intregration
    local src = source
    if isDead then
        TriggerClientEvent('osp_ambulance:OnPlayerDead', src)
    else
        TriggerClientEvent('osp_ambulance:OnPlayerSpawn', src)
    end 
    -- Player(src).state:set('isDead', isDead, true)
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool) -- Used to set the laststand status of a player, used by other qbcore scripts for easy intregration
    local src = source
    if bool then
        TriggerClientEvent('osp_ambulance:OnPlayerDead', src)
    else
        TriggerClientEvent('osp_ambulance:OnPlayerSpawn', src)
    end 
    -- Player(src).state:set('isLastStand', bool, true)
end)

RegisterNetEvent('hospital:server:resetHungerThirst', function()
    local sourcePlayer = GetPlayer(source)
    if not sourcePlayer then return end

    TriggerClientEvent('esx_status:set', source, 'hunger', 1000000)
    TriggerClientEvent('esx_status:set', source, 'thirst', 1000000)
end)

RegisterNetEvent('osp_ambulance:registerStash', function(stashid)
    return Inventory[GetInventoryTool()].RegisterStash(source, stashid)
end)

RegisterNetEvent('osp_ambulance:registerBloodstorage', function(stashid)
    return Inventory[GetInventoryTool()].RegisterBloodStorage(source, stashid)
end)

RegisterNetEvent('osp_ambulance:registerMedicalBagStash', function(stashid)
    local adapter = Inventory[GetInventoryTool()]
    if adapter and adapter.RegisterMedicalBagStash then
        return adapter.RegisterMedicalBagStash(source, stashid)
    end
end)

RegisterNetEvent('osp_amblance:setDeathStatus')
AddEventHandler('osp_amblance:setDeathStatus', function(isDead)
    local xPlayer = GetPlayer(source)
    if not xPlayer then return end
    if type(isDead) == 'boolean' then
        MySQL.update('UPDATE users SET is_dead = ? WHERE identifier = ?', {isDead, xPlayer.identifier})
        Player(source).state:set('isDead', isDead, true)
    end
end)