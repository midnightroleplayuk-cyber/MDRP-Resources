if GetResourceState('qbx_core') ~= 'started' then return end

local function getPlayerData(player)
    return player and (player.PlayerData or player)
end

local function getPlayerJob(player)
    local data = getPlayerData(player)
    return data and data.job
end

local function getPlayerMetadata(player)
    local data = getPlayerData(player)
    return data and data.metadata or {}
end

local function getPlayerSource(player)
    local data = getPlayerData(player)
    return data and (data.source or data.PlayerData and data.PlayerData.source)
end

local function setQboxMetadata(source, key, value)
    local success = pcall(function()
        exports.qbx_core:SetMetadata(source, key, value)
    end)

    if success then return end

    local player = GetPlayer(source)
    if player and player.Functions and player.Functions.SetMetaData then
        player.Functions.SetMetaData(key, value)
    end
end

function GetPlayer(source)
    return exports.qbx_core:GetPlayer(tonumber(source))
end

function CreateUseableItem(name, cb)
    return Inventory[GetInventoryTool()].CreateUseableItem(name, cb)
end

function GetIdentifier(source)
    local player = GetPlayer(source)
    local data = getPlayerData(player)
    return data and data.citizenid
end

function QBCreateUseableItem(name, cb)
    exports.qbx_core:CreateUseableItem(name, cb)
end

function ClearInventory(sourcePlayer)
    return Inventory[GetInventoryTool()].ClearInventory(sourcePlayer)
end

function IsFrameworkAdmin(source)
    if not source or source == 0 then return false end
    if IsPlayerAceAllowed(source, 'group.admin') then
        return true
    end
    local ok, allowed = pcall(function()
        return exports.qbx_core:HasPermission(source, 'admin')
    end)
    return ok and allowed == true
end

function getFrameworkBloodType(playerID)
    local player = GetPlayer(tonumber(playerID))
    if not player then return nil end
    local metadata = getPlayerMetadata(player)
    if type(metadata) ~= 'table' then return nil end
    local bloodType = metadata.bloodtype
    if type(bloodType) == 'string' and bloodType ~= '' then
        return bloodType
    end
    return nil
end

function setFrameworkBloodType(playerID, bloodType)
    if type(bloodType) ~= 'string' or bloodType == '' then return end
    setQboxMetadata(tonumber(playerID) or playerID, 'bloodtype', bloodType)
end

local function cacheQboxPlayer(source)
    if CachePlayerWoundIdentity then
        CachePlayerWoundIdentity(source)
    end
end

AddEventHandler('qbx_core:server:playerLoaded', function(player)
    local src = type(player) == 'table' and (player.PlayerData and player.PlayerData.source or player.source) or player
    cacheQboxPlayer(src)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    cacheQboxPlayer(source)
end)

AddEventHandler('qbx_core:server:playerLoggedOut', function(source)
    local data = GetCachedWoundData and GetCachedWoundData(source) or Player(source).state.BodyDamage
    if PersistWoundData then
        PersistWoundData(source, data)
    else
        local identifier = GetIdentifier(source)
        if identifier and type(data) == 'table' then
            MySQL.update('UPDATE players SET woundData = ? WHERE citizenid = ?', { json.encode(data), identifier })
        end
    end
    if FlushRuntimeWoundData then
        FlushRuntimeWoundData(source)
    end
    if ClearCachedWoundData then
        ClearCachedWoundData(source, true)
    end
end)

RegisterServerEvent('osp_ambulance:addItem')
AddEventHandler('osp_ambulance:addItem', function(name, amount, info)
    if amount == nil then amount = 1 end

    local authItem = false

    for _, castGroup in pairs(Config.Casts) do
        for _, cast in pairs(castGroup.casts) do
            if cast.itemName == name then
                authItem = true
            end
        end
    end

    for _, bloodType in pairs(Config.bloodTypes) do
        if ('blood500ml_' .. bloodType.itemName) == name or ('blood250ml_' .. bloodType.itemName) == name then
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

    AddItem(source, name, amount, info)
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

RegisterServerEvent('osp_ambulance:removeItem')
AddEventHandler('osp_ambulance:removeItem', function(name, amount)
    RemoveItem(source, name, amount or 1)
end)

RegisterServerEvent('osp_ambulance:setItemMetadata')
AddEventHandler('osp_ambulance:setItemMetadata', function(slot, info)
    return Inventory[GetInventoryTool()].SetItemMetadata(source, slot, info)
end)

function CheckMoney(source)
    local player = GetPlayer(source)
    local data = getPlayerData(player)
    return data and data.money and data.money.bank or 0
end

function RemoveMoney(source, amount)
    local player = GetPlayer(source)
    if not player then return end

    if player.Functions and player.Functions.RemoveMoney then
        player.Functions.RemoveMoney('bank', tonumber(amount))
        return
    end

    pcall(function()
        exports.qbx_core:RemoveMoney(source, 'bank', tonumber(amount), 'osp_ambulance')
    end)
end

lib.addCommand('911ems', {
    help = GetLang().info.ems_report,
    params = {
        { name = 'message', type = 'string', help = GetLang().info.message_sent, optional = true }
    }
}, function(source, args)
    local message = args.message or GetLang().info.civ_call
    local coords = GetEntityCoords(GetPlayerPed(source))

    for _, playerId in pairs(GetPlayers()) do
        local player = GetPlayer(playerId)
        local job = getPlayerJob(player)

        if job then
            for _, ambulanceJob in pairs(Config.AmbulanceJobs) do
                if job.name == ambulanceJob and job.onduty then
                    TriggerClientEvent('hospital:client:ambulanceAlert', tonumber(playerId), coords, message)
                end
            end
        end
    end
end)

lib.addCommand('revive', {
    help = GetLang().info.revive_player_a,
    params = {
        { name = 'id', type = 'playerId', help = GetLang().info.player_id, optional = true }
    },
    restricted = 'group.admin'
}, function(source, args)
    local target = args.id or source
    TriggerClientEvent('hospital:client:Revive', target, true)
end)

lib.addCommand('kill', {
    help = GetLang().info.kill,
    params = {
        { name = 'id', type = 'playerId', help = GetLang().info.player_id, optional = true }
    },
    restricted = 'group.admin'
}, function(source, args)
    local target = args.id or source
    TriggerClientEvent('hospital:client:KillPlayer', target)
end)

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

lib.callback.register('osp_ambulance:getInventory', function(source)
    local inventoryTool = Inventory[GetInventoryTool()]
    if not inventoryTool or not inventoryTool.GetInventory then
        return {}
    end

    return inventoryTool.GetInventory(source) or {}
end)

RegisterServerEvent('osp_ambulance:saveWoundDataSv')
AddEventHandler('osp_ambulance:saveWoundDataSv', function(data)
    if type(data) ~= 'table' then return end

    if PersistWoundData then
        PersistWoundData(source, data)
        return
    end

    local identifier = GetIdentifier(source)
    if identifier then
        MySQL.update('UPDATE players SET woundData = ? WHERE citizenid = ?', { json.encode(data), identifier })
    end
end)

RegisterNetEvent('hospital:server:SetArmourStatus', function(armor)
    setQboxMetadata(source, 'armor', armor)
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
    setQboxMetadata(source, 'isdead', isDead)
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(bool)
    setQboxMetadata(source, 'inlaststand', bool)
end)

RegisterNetEvent('hospital:server:resetHungerThirst', function()
    setQboxMetadata(source, 'hunger', 100)
    setQboxMetadata(source, 'thirst', 100)
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
