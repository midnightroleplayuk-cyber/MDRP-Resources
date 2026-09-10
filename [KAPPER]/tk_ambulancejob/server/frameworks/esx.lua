if Config.Framework ~= 'esx' then return end

ESX = exports["es_extended"]:getSharedObject()

RegisterCallback = ESX.RegisterServerCallback
CreateUsableItem = ESX.RegisterUsableItem

function ShowNotification(src, text, notifyType)
    TriggerClientEvent('esx:showNotification', src, text)
end

function GetPlayerFromId(playerId)
    return ESX.GetPlayerFromId(playerId)
end

function GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function GetSource(xPlayer)
    xPlayer = type(xPlayer) == 'number' and ESX.GetPlayerFromId(xPlayer) or xPlayer
    return xPlayer.source
end

function GetIdentifier(xPlayer)
    xPlayer = type(xPlayer) == 'number' and ESX.GetPlayerFromId(xPlayer) or xPlayer
    return xPlayer.identifier
end

function GetPlayerObjects()
    return ESX.GetPlayers()
end

function IsAdmin(playerId)
    local xPlayer = GetPlayerFromId(playerId)
    return Config.AdminGroups[xPlayer.getGroup()]
end

function GetCharName(identifier)
    local xTarget = GetPlayerFromIdentifier(identifier)
    if xTarget then return xTarget.getName() end

	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users where identifier = ?', {identifier})
    local name = ('%s %s'):format(result?[1]?.firstname, result?[1]?.lastname)

    return name
end

function GetJob(xPlayer)
    return xPlayer.job
end

function GetJobName(xPlayer)
    xPlayer = type(xPlayer) == 'number' and ESX.GetPlayerFromId(xPlayer) or xPlayer
    return xPlayer.job.name
end

function GetGradeId(xPlayer)
    xPlayer = type(xPlayer) == 'number' and ESX.GetPlayerFromId(xPlayer) or xPlayer
    return xPlayer.job.grade
end

function GetGradeLabel(xPlayer)
    xPlayer = type(xPlayer) == 'number' and ESX.GetPlayerFromId(xPlayer) or xPlayer
    return xPlayer.job.grade_label
end

function IsOnDuty(playerId)
    return true
end

function SetJob(xPlayer, job, grade)
    xPlayer.setJob(job, grade)
end

function GetAccountMoney(xPlayer, account)
    return xPlayer.getAccount(account).money
end

function AddAccountMoney(xPlayer, account, amount)
    xPlayer.addAccountMoney(account, amount)
end

function RemoveAccountMoney(xPlayer, account, amount)
    xPlayer.removeAccountMoney(account, amount)
end

function IsWeapon(item)
    return item and string.upper(string.sub(item, 0, 7)) == 'WEAPON_'
end

function GetItemAmount(xPlayer, item)
    if Config.Inventory == 'default' and IsWeapon(item) then
        local has = xPlayer.getWeapon(item)
        return has and 1 or 0
    end

    local xItem = xPlayer.getInventoryItem(item)
    return xItem?.count or xItem?.amount or 0
end

function GetPlayerInventory(playerId)
    local xPlayer = GetPlayerFromId(playerId)
    local inventory = {}

    local playerItems = Config.Inventory == 'qs' and exports['qs-inventory']:GetInventory(playerId) or xPlayer.inventory

    for _,v in pairs(playerItems) do
        local amount = v.count or v.amount or 0
        if amount > 0 then
            inventory[#inventory+1] = {name = v.name, label = GetItemLabel(v.name), amount = amount, metadata = v.metadata or v.info}
        end
    end

    if Config.Inventory == 'default' then
        for _,v in pairs(xPlayer.loadout) do
            inventory[#inventory+1] = {name = v.name, amount = v.ammo}
        end
    end

    return inventory
end

function CanCarryItem(xPlayer, item, amount)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:CanCarryItem(GetSource(xPlayer), item, amount)
    end

    if Config.Inventory == 'default' and IsWeapon(item) then
        local weapon = xPlayer.getWeapon(item)
        return not weapon
    end

    return xPlayer.canCarryItem(item, amount)
end

function AddItem(xPlayer, item, amount, metadata)
    if not CanCarryItem(xPlayer, item, amount) then
        local playerId = GetSource(xPlayer)
        Notify(playerId, _U('not_enough_space'), 'error')
        return
    end

    if Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(GetSource(xPlayer), item, amount, metadata)
        return true
    end

    if Config.Inventory == 'qs' then
        exports['qs-inventory']:AddItem(GetSource(xPlayer), item, amount, nil, metadata)
        return true
    end

    if Config.Inventory == 'default' and IsWeapon(item) then
        xPlayer.addWeapon(item, amount)
        return true
    end

    xPlayer.addInventoryItem(item, amount)
    return true
end

function RemoveItem(xPlayer, item, amount)
    if Config.Inventory == 'default' and IsWeapon(item) then
        xPlayer.removeWeapon(item, amount)
        return
    end

    xPlayer.removeInventoryItem(item, amount)
end

function GetItemLabel(item)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:Items(item)?.label or item
    end

    if Config.Inventory == 'default' and IsWeapon(item) then
        return ESX.GetWeaponLabel(item) or item
    end

    return ESX.GetItemLabel(item) or item
end

local weaponLabels = {}

if Config.Inventory == 'ox' then
    for _,v in pairs(exports.ox_inventory:Items()) do
        if v.hash and v.label then
            weaponLabels[v.hash] = v.label
        end
    end
end

function GetWeaponLabel(weapon)
    if Config.Inventory == 'ox' then
        return weaponLabels[weapon] or weapon
    end

    return ESX.GetWeaponFromHash(weapon)?.label or weapon
end

RegisterCallback('tk_ambulancejob:getItemLabel', function(src, cb, item)
	cb(GetItemLabel(item))
end)

CreateThread(function()
    repeat Wait(100) until ESX

    frameworkLoaded = true
end)