if Config.Framework ~= 'qb' then return end

QBCore = exports['qb-core']:GetCoreObject()

RegisterCallback = QBCore.Functions.CreateCallback
CreateUsableItem = QBCore.Functions.CreateUseableItem

function ShowNotification(src, text, notifyType)
    if notifyType == 'inform' then notifyType = 'primary' end
    TriggerClientEvent('QBCore:Notify', src, text, notifyType)
end

function GetPlayerFromId(playerId)
    return QBCore.Functions.GetPlayer(playerId)
end

function GetPlayerFromIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end

function GetSource(player)
    player = type(player) == 'number' and QBCore.Functions.GetPlayer(player) or player
    return player.PlayerData.source
end

function GetIdentifier(player)
    player = type(player) == 'number' and QBCore.Functions.GetPlayer(player) or player
    return player.PlayerData.citizenid
end

function GetPlayerObjects()
    return QBCore.Functions.GetQBPlayers()
end

function IsAdmin(playerId)
    for k in pairs(Config.AdminGroups) do
        if QBCore.Functions.HasPermission(playerId, k) then
            return true
        end
    end

    return
end

function GetCharName(identifier)
    local targetPlayer = GetPlayerFromIdentifier(identifier)
    if targetPlayer then
        local name = ('%s %s'):format(targetPlayer.PlayerData.charinfo.firstname, targetPlayer.PlayerData.charinfo.lastname)
        return name
    end

	local result = MySQL.Sync.fetchAll('SELECT charinfo FROM players where citizenid = ?', {identifier})
    local charinfo = json.decode(result?[1]?.charinfo)
    local name = ('%s %s'):format(charinfo?.firstname, charinfo?.lastname)

    return name
end

function GetJob(player)
    return player.PlayerData.job
end

function GetJobName(player)
    return player.PlayerData.job.name
end

function GetGradeId(player)
    return player.PlayerData.job.grade.level
end

function SetJob(player, job, grade)
    player.Functions.SetJob(job, grade)
end

function GetAccountMoney(player, account)
    if account == 'money' then account = 'cash' end
    return player.Functions.GetMoney(account)
end

function AddAccountMoney(player, account, amount)
    if account == 'money' then account = 'cash' end
    player.Functions.AddMoney(account, amount)
end

function RemoveAccountMoney(player, account, amount)
    if account == 'money' then account = 'cash' end
    player.Functions.RemoveMoney(account, amount)
end

function GetItemAmount(player, item)
    if item == 'money' then
        return GetAccountMoney(player, item)
    end

    local invItem = player.Functions.GetItemByName(item)
    return invItem?.amount or invItem?.count or 0
end

function AddItem(player, item, amount, metadata)
    if item == 'money' then
        AddAccountMoney(player, item, amount)
        return true
    end

    if Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(GetSource(player), item, amount, metadata)
        return true
    end

    TriggerClientEvent('inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item], 'add')
    return player.Functions.AddItem(item, amount)
end

function RemoveItem(player, item, amount)
    if item == 'money' then
        return RemoveAccountMoney(player, item, amount)
    end

    player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item], 'remove')
end

function GetItemLabel(item)
    return QBCore.Shared.Items?[string.lower(item)]?.label or item
end

CreateThread(function()
    repeat Wait(100) until QBCore

    frameworkLoaded = true
end)