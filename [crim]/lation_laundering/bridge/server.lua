local ox_inv = GetResourceState('ox_inventory') == 'started'

-- Get framework
if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Framework = 'esx'
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = 'qb'
else
    -- Add support for a custom framework here
end

-- Get player from source
--- @param source number
GetPlayer = function(source)
    if Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    else
        -- Add support for a custom framework here
    end
end

-- Function to get a players identifier
--- @param source number
GetIdentifier = function(source)
    local player = GetPlayer(source)
    if not player then return end
    if Framework == 'esx' then
        return player.getIdentifier()
    elseif Framework == 'qb' then
        return player.PlayerData.citizenid
    else
        -- Add support for a custom framework here
    end
end

-- Function to get a players name
--- @param source number
GetName = function(source)
    local player = GetPlayer(source)
    if not player then return end
    if Framework == 'esx' then
        return player.getName()
    elseif Framework == 'qb' then
        return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
    else
        -- Add support for a custom framework here
    end
end

-- Returns the amount of a specific item a player has
--- @param source number
--- @param item string
ItemCount = function(source, item)
    local player = GetPlayer(source)
    if not player then return 0 end
    if ox_inv then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count
    end
    if Framework == 'esx' then
        local item = player.getInventoryItem(item)
        local count = item.count or item.amount
        if not count then return 0 end
        return count
    elseif Framework == 'qb' then
        local count = 0
        for _, itemData in pairs(player.PlayerData.items) do
            if itemData.name == item then
                count = itemData.amount or itemData.count or 1
            end
        end
        return count
    end
end

-- Function to add an item to inventory
--- @param source number
--- @param item string
--- @param count number
--- @param slot any
--- @param metadata any
AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    if not player then return end
    if ox_inv then
        return exports.ox_inventory:AddItem(source, item, count, metadata, slot)
    end
    if Framework == 'esx' then
        return player.addInventoryItem(item, count, metadata, slot)
    elseif Framework == 'qb' then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add')
        return player.Functions.AddItem(item, count, slot, metadata)
    else
        -- Add support for a custom framework here
    end
end

-- Function to remove an item from inventory
--- @param source number
--- @param item string
--- @param count number
--- @param slot any
--- @param metadata any
RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    if not player then return end
    if ox_inv then
        return exports.ox_inventory:RemoveItem(source, item, count, metadata, slot)
    end
    if Framework == 'esx' then
        return player.removeInventoryItem(item, count, metadata, slot)
    elseif Framework == 'qb' then
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
        return player.Functions.RemoveItem(item, count, slot, metadata)
    else
        -- Add support for a custom framework here
    end
end

-- Function used to convert money type
--- @param moneyType string
ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and Framework == 'qb' then
        moneyType = 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        moneyType = 'money'
    end
    return moneyType
end

-- Function to add money to a players account
--- @param source number
--- @param moneyType string
--- @param amount number
AddMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    if Framework == 'esx' then
        player.addAccountMoney(moneyType, amount)
    elseif Framework == 'qb' then
        player.Functions.AddMoney(moneyType, amount)
    else
        -- Add support for a custom framework here
    end
end

--- Function used to remove money from a player
--- @param source number The player source
--- @param moneyType string The type of money to remove
--- @param amount number The amount of money to remove
RemoveMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    if Framework == 'esx' then
        if moneyType == 'money' or moneyType == 'bank' or moneyType == 'black_money' then
            player.removeAccountMoney(moneyType, amount)
        else
            RemoveItem(source, moneyType, amount)
        end
    elseif Framework == 'qb' then
        if moneyType == 'markedbills' or moneyType == 'cashrolls' then
            if Config.QBCore.metadata then
                if Config.QBCore.countTotal then
                    local moneyFound = 0
                    local removeAmount = 0
                    local count = 0
                    for _, item in pairs(player.PlayerData.items) do
                        if item.name == moneyType then
                            if Config.QBCore.hardValues then
                                local total = item.amount or item.count or 1
                                for i = 1, total do
                                    if moneyFound >= amount then break end
                                    moneyFound = moneyFound + Config.QBCore.items[moneyType]
                                    removeAmount = removeAmount + 1
                                end
                                if moneyFound >= amount then break end
                            else
                                local itemData = player.Functions.GetItemByName(moneyType)
                                local currentWorth = itemData.info.worth
                                count = count + 1
                                while amount > 0 and count > 0 do
                                    if currentWorth > amount then
                                        local newWorth = currentWorth - amount
                                        RemoveItem(source, moneyType, 1)
                                        if newWorth > 0 then
                                            local data = {worth = newWorth}
                                            AddItem(source, moneyType, 1, false, data)
                                        end
                                        amount = 0
                                    else
                                        RemoveItem(source, moneyType, 1)
                                        amount = amount - currentWorth
                                        count = count - 1
                                        if count > 0 then
                                            currentWorth = player.Functions.GetItemByName(moneyType).info.worth
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if removeAmount > 0 then
                        RemoveItem(source, moneyType, removeAmount)
                    end
                else
                    local item = player.Functions.GetItemByName(moneyType)
                    local currentWorth = Config.QBCore.hardValues and Config.QBCore.items[moneyType] or item.info.worth
                    local quantity = item.amount or item.count or 1
                    while amount > 0 and quantity > 0 do
                        if currentWorth > amount then
                            local newWorth = currentWorth - amount
                            RemoveItem(source, moneyType, 1)
                            if newWorth > 0 then
                                local data = {worth = newWorth}
                                AddItem(source, moneyType, 1, false, data)
                            end
                            amount = 0
                        else
                            RemoveItem(source, moneyType, 1)
                            amount = amount - currentWorth
                            quantity = quantity - 1
                            if quantity > 0 then
                                currentWorth = player.Functions.GetItemByName(moneyType).info.worth
                            end
                        end
                    end
                end
            else
                if Config.QBCore.countTotal then
                    if Config.QBCore.hardValues then
                        local moneyFound, removeAmount = 0, 0
                        for _, itemData in pairs(player.PlayerData.items) do
                            if itemData.name == moneyType then
                                local total = itemData.amount or itemData.count or 1
                                for i = 1, total do
                                    if moneyFound >= amount then break end
                                    moneyFound = moneyFound + Config.QBCore.items[moneyType]
                                    removeAmount = removeAmount + 1
                                end
                                if moneyFound >= amount then break end
                            end
                        end
                        if removeAmount > 0 then
                            RemoveItem(source, moneyType, removeAmount)
                        end
                    else
                        RemoveItem(source, moneyType, amount)
                    end
                else
                    RemoveItem(source, moneyType, amount)
                end
            end
        elseif moneyType == 'cash' or moneyType == 'bank' then
            player.Functions.RemoveMoney(moneyType, amount)
        else
            RemoveItem(source, moneyType, amount)
        end
    else
        -- Add support for a custom framework here
    end
end

-- Function used to check players balance
--- @param source number
--- @param moneyType string
GetPlayerAccountFunds = function(source, moneyType)
    local player = GetPlayer(source)
    if not player then return end
    moneyType = ConvertMoneyType(moneyType)
    if Framework == 'esx' then
        if moneyType == 'money' or moneyType == 'bank' or moneyType == 'black_money' then
            return player.getAccount(moneyType).money
        else
            local count = ItemCount(source, moneyType)
            if not count then return 0 end
            return count
        end
    elseif Framework == 'qb' then
        if moneyType == 'markedbills' or moneyType == 'cashrolls' then
            if Config.QBCore.metadata then
                if Config.QBCore.countTotal then
                    local worth = 0
                    for _, item in pairs(player.PlayerData.items) do
                        if item.name == moneyType then
                            local count = item.amount or item.count or 1
                            if Config.QBCore.hardValues then
                                worth = worth + Config.QBCore.items[moneyType] * count
                            else
                                worth = worth + item.info.worth * count
                            end
                        end
                    end
                    return worth
                else
                    local item = player.Functions.GetItemByName(moneyType)
                    if not item then return 0 end
                    local count = item.amount or item.count or 1
                    local worth
                    if Config.QBCore.hardValues then
                        worth = Config.QBCore.items[moneyType] * count
                    else
                        worth = item.info and item.info.worth * count or 0 * count
                    end
                    return worth
                end
            else
                if Config.QBCore.countTotal then
                    local worth = 0
                    for _, itemData in pairs(player.PlayerData.items) do
                        if itemData.name == moneyType then
                            local count = itemData.amount or itemData.count or 1
                            if Config.QBCore.hardValues then
                                worth = worth + Config.QBCore.items[moneyType] * count
                            else
                                worth = worth + count
                            end
                        end
                    end
                    return worth
                else
                    local item = player.Functions.GetItemByName(moneyType)
                    if not item then return 0 end
                    local count = item.amount or item.count or 1
                    local worth = 0
                    if Config.QBCore.hardValues then
                        worth = Config.QBCore.items[moneyType] * count
                    else
                        worth = 1 * count
                    end
                    return worth
                end
            end
        elseif moneyType == 'cash' or moneyType == 'bank' then
            return player.PlayerData.money[moneyType]
        else
            local count = ItemCount(source, moneyType)
            if not count then return 0 end
            return count
        end
    else
        -- Add support for a custom framework here
    end
end