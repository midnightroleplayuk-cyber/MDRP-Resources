-- Qbox provides qb-core via its bridge; prefer qbox.lua so events are not double-registered.
if GetResourceState('qbx_core') == 'started' then return end
if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function()
    if CachePlayerWoundIdentity then
        CachePlayerWoundIdentity(source)
    end
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(source)
    local src = source
    local data = GetCachedWoundData and GetCachedWoundData(src) or Player(src).state.BodyDamage
    if PersistWoundData then
        PersistWoundData(src, data)
    else
        local sourcePlayer = QBCore.Functions.GetPlayer(src)
        if sourcePlayer and type(data) == 'table' then
            MySQL.Async.execute('UPDATE players SET woundData = @woundData WHERE citizenid = @citizenid', {
                ['@woundData'] = json.encode(data),
                ['@citizenid'] = sourcePlayer.PlayerData.citizenid,
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

function GetPlayer(source)
    return QBCore.Functions.GetPlayer(tonumber(source))
end

function CreateUseableItem(name, cb)
    return Inventory[GetInventoryTool()].CreateUseableItem(name, cb)
end

function GetIdentifier(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then
        return xPlayer.PlayerData.citizenid
    end
end

function QBCreateUseableItem(name, cb)
    QBCore.Functions.CreateUseableItem(name, cb)
end

function ClearInventory(sourcePlayer)
    return Inventory[GetInventoryTool()].ClearInventory(sourcePlayer)
end

function IsFrameworkAdmin(source)
    if not source or source == 0 then return false end
    return QBCore.Functions.HasPermission(source, 'admin') or QBCore.Functions.HasPermission(source, 'god')
end

function getFrameworkBloodType(playerID)
    local ply = QBCore.Functions.GetPlayer(tonumber(playerID))
    if not ply or not ply.PlayerData or not ply.PlayerData.metadata then return nil end
    local bloodType = ply.PlayerData.metadata.bloodtype
    if type(bloodType) == 'string' and bloodType ~= '' then
        return bloodType
    end
    return nil
end

function setFrameworkBloodType(playerID, bloodType)
    if type(bloodType) ~= 'string' or bloodType == '' then return end
    local ply = QBCore.Functions.GetPlayer(tonumber(playerID))
    if ply and ply.Functions and ply.Functions.SetMetaData then
        ply.Functions.SetMetaData('bloodtype', bloodType)
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
        if ('blood500ml_' .. v.itemName) == name or ('blood250ml_' .. v.itemName) == name then
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
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    local currentCash = sourcePlayer.Functions.GetMoney('bank')
    return currentCash
end

function RemoveMoney(source, amount)
    local src = source
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    if sourcePlayer then
        sourcePlayer.Functions.RemoveMoney('bank', amount)
    end
end


-- Commands

QBCore.Commands.Add('911ems', GetLang().info.ems_report, {{name = 'message', help = GetLang().info.message_sent}}, false, function(source, args)
    local src = source
    local message
    if args[1] then message = table.concat(args, " ") else message = GetLang().info.civ_call end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        for _,x in pairs(Config.AmbulanceJobs) do
            if v.PlayerData.job.name == x and v.PlayerData.job.onduty then
                TriggerClientEvent('hospital:client:ambulanceAlert', v.PlayerData.source, coords, message)
            end
        end
    end
end)

QBCore.Commands.Add("revive", GetLang().info.revive_player_a, {{name = "id", help = GetLang().info.player_id}}, false, function(source, args)
    local src = source
    if args[1] then
        local sourcePlayer = GetPlayer(tonumber(args[1]))
        if sourcePlayer then
            TriggerClientEvent('hospital:client:Revive', sourcePlayer.PlayerData.source, true)
        else
            TriggerClientEvent('osp_ambulance:SendTextMessage', src, 'Chat', 'Player was not online', 3000, 'error')
        end
    else
        TriggerClientEvent('hospital:client:Revive', src, true)
    end
end, "admin")


QBCore.Commands.Add("kill", GetLang().info.kill, {{name = "id", help = GetLang().info.player_id}}, false, function(source, args)
    local src = source
    if args[1] then
        local sourcePlayer = GetPlayer(tonumber(args[1]))
        if sourcePlayer then
            TriggerClientEvent('hospital:client:KillPlayer', sourcePlayer.PlayerData.source)
        else
            TriggerClientEvent('osp_ambulance:SendTextMessage', src, 'Chat', 'Player was not online', 3000, 'error')
        end
    else
        TriggerClientEvent('hospital:client:KillPlayer', src)
    end
end, "admin")

lib.callback.register('osp_ambulance:getWoundData', function(source)
    if LoadPersistedWoundData then
        return LoadPersistedWoundData(source)
    end

    local sourcePlayer = GetPlayer(source)
    if not sourcePlayer then
        return
    end

    local res = MySQL.single.await('SELECT `woundData` FROM players WHERE `citizenid` = ? LIMIT 1', {
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

    local sourcePlayer = QBCore.Functions.GetPlayer(source)
    if sourcePlayer then
        MySQL.Async.execute('UPDATE players SET woundData = @woundData WHERE citizenid = @citizenid', {
            ['@woundData'] = json.encode(data),
            ['@citizenid'] = sourcePlayer.PlayerData.citizenid,
        })
    end
end)

RegisterNetEvent('hospital:server:SetArmourStatus', function(armor) -- Used to set the death status of a player, used by other qbcore scripts for easy intregration
    local src = source
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    if sourcePlayer then
        sourcePlayer.Functions.SetMetaData("armor", armor)
    end
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead) -- Used to set the death status of a player, used by other qbcore scripts for easy intregration
    local src = source
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    if sourcePlayer then
        sourcePlayer.Functions.SetMetaData("isdead", isDead)
    end
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool) -- Used to set the laststand status of a player, used by other qbcore scripts for easy intregration
    local src = source
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    if sourcePlayer then
        sourcePlayer.Functions.SetMetaData("inlaststand", bool)
    end
end)

RegisterNetEvent('hospital:server:resetHungerThirst', function()
    local sourcePlayer = QBCore.Functions.GetPlayer(source)

    if not sourcePlayer then return end

    sourcePlayer.Functions.SetMetaData('hunger', 100)
    sourcePlayer.Functions.SetMetaData('thirst', 100)

    TriggerClientEvent('hud:client:UpdateNeeds', source, 100, 100)
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