-- Event handlers to get when a player is fully loaded into server
AddEventHandler("QBCore:Server:PlayerLoaded", function(Player)
    playerJoined(Player.PlayerData.source)
end)

RegisterServerEvent("esx:onPlayerJoined")
AddEventHandler("esx:onPlayerJoined", function(Player)
    local src = Player
    if not src then src = source end
    playerJoined(src)
end)

-- Get Player Object
function getPlayer(src)
    if Config.Framework == "qb" then
        return Core.Functions.GetPlayer(src)
    elseif Config.Framework == "qbox" then
        return exports.qbx_core:GetPlayer(src)
    elseif Config.Framework == "esx" then
        return Core.GetPlayerFromId(src)
    end
end

-- Get Player Identifier
function getIdentifier(src)
    if Config.Framework == "qb" then
        local Player = getPlayer(src)
        if Player then
            return Player.PlayerData.citizenid
        end
    elseif Config.Framework == "qbox" then
        local Player = getPlayer(src)
        if Player then
            return Player.PlayerData.citizenid
        end
    elseif Config.Framework == "esx" then
        local xPlayer = getPlayer(src)
        if xPlayer then
            return xPlayer.identifier
        end
    end
    return false
end

-- Has item?
function hasItem(src, name, amount)
    dbug("hasItem(src,item,amount)", src, name, amount or 1)
    if not src then return false end
    local qty = amount and tonumber(amount) or 1
    if Config.Inventory and Config.Inventory == "ox_inventory" then
        local item = exports['ox_inventory']:GetItem(src, name, nil, true)
        if item and tonumber(item) >= qty then
            return true
        else
            return false
        end
    end
    if Config.Framework == "qb" then
        if Config.Inventory then
            return exports[Config.Inventory]:HasItem(src, name, qty)
        else
            local Player = getPlayer(src)
            if Player then
                return Player.Functions.HasItem(name, qty)
            end
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        local item = xPlayer.getInventoryItem(name)
        if item and item['count'] >= qty then
            return true
        end
    end
    return false
end

-- Remove Item from Player
function removeItem(src, item, amount, slot, metadata)
    if not src then return false end
    local qty = amount or 1
    dbug('removeItem(src, item, amount, slot)', src, item, qty, slot)
    if Config.Inventory and Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:RemoveItem(src, item, qty, metadata, slot)
    elseif Config.Inventory and Config.Inventory == "qb-inventory" or Config.Inventory == "qs-inventory" then
        return exports[Config.Inventory]:RemoveItem(src, item, qty, slot)
    else
        local Player = getPlayer(src)
        if Player then
            if Config.Framework == "esx" then
                Player.removeInventoryItem(item, qty)
            else
                if Player.Functions.RemoveItem then
                    Player.Functions.RemoveItem(item, qty)
                else
                    warn("Function RemoveItem() does NOT exist in your QB-Core, edit server/editable/_framework.lua line 200 and add your own removeItem function, this is NOT a script problem.")
                    warn("Function RemoveItem() does NOT exist in your QB-Core, edit server/editable/_framework.lua line 200 and add your own removeItem function, this is NOT a script problem.")
                    warn("Function RemoveItem() does NOT exist in your QB-Core, edit server/editable/_framework.lua line 200 and add your own removeItem function, this is NOT a script problem.")
                end
            end
        end
    end
end

-- Add Item to player
function addItem(src, item, amount, info, slot)
    dbug('addItem(src,item,amount)', src, item, amount)
    if not src then return false end
    if Config.Inventory then
        if Config.Inventory == "tgiann-inventory" then
            return exports["tgiann-inventory"]:AddItem(src, item, amount, slot, info)
        end
        if Config.Inventory == "ox_inventory" then
            return exports.ox_inventory:AddItem(src, item, amount, info, slot)
        end
        if Config.Inventory == "qs-inventory" then
            return exports['qs-inventory']:AddItem(src, item, amount, slot, info)
        end
    end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        return Player.Functions.AddItem(item, amount, false, info)
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer.canCarryItem(item, amount) then
            xPlayer.addInventoryItem(item, amount, info)
            return true
        end
    end
    return false
end

-- Add Money
function addMoney(src, account, amount, reason)
    if not src then return false end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        local Crypto = Player.PlayerData.metadata and Player.PlayerData.metadata.crypto or false
        if Crypto and Crypto[account] then
            Crypto[account] += tonumber(amount)
            Player.Functions.SetMetaData("crypto", Crypto)
        else
            Player.Functions.AddMoney(account, amount)
        end
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(src)
        if identifier then
            exports.qbx_core:AddMoney(identifier, account, amount, reason or '')
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        xPlayer.addAccountMoney(account, amount)
    end
end

-- Remove money from player
function removeMoney(src, account, amount, reason)
    dbug("removeMoney(src, account, amount)", src, account, amount)
    if not src then return false end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        if Player then
            local Crypto = Player.PlayerData.metadata and Player.PlayerData.metadata.crypto or false
            if Crypto and Crypto[account] then
                Crypto[account] -= amount
                Player.Functions.SetMetaData("crypto", Crypto)
            else
                Player.Functions.RemoveMoney(account, amount)
            end
        end
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(src)
        if identifier then
            exports.qbx_core:RemoveMoney(identifier, account, amount, reason or '')
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        xPlayer.removeAccountMoney(account, amount)
    end
end

-- Get Player money
function getMoney(src, account)
    dbug("getMoney(src,account)", src, account)
    if not src then return false end
    if Config.Framework == "qb" then
        local Player = getPlayer(src)
        if Player then
            if (Player.PlayerData and Player.PlayerData.metadata) and Player.PlayerData.metadata.crypto then
                if Player.PlayerData.metadata.crypto[account] then
                    return Player.PlayerData.metadata.crypto[account] or 0
                end
            end
            if Player.PlayerData.money[account] then
                return Player.PlayerData.money[account] or 0
            end
        end
        return false
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(src)
        if identifier then
            return exports.qbx_core:GetMoney(identifier, account) or 0
        end
    elseif Config.Framework == "esx" then
        local xPlayer = getPlayer(src)
        if xPlayer and xPlayer.getAccount(account) then
            return xPlayer.getAccount(account).money
        else
            return false
        end
    end
end

function getCops()
    local amount = 0
    if Config.Framework == "qbox" then
        for _, v in pairs(Config.PoliceJobs) do
            local count, _ = exports['qbx_core']:GetDutyCountJob(v)
            amount += count
        end
        return amount
    end
    if Config.Framework == "qb" then
        local players = Core.Functions.GetQBPlayers()
        local counted = {}
        for _, v in pairs(Config.PoliceJobs) do
            for _, j in pairs(players) do
                local src = j and j['PlayerData']['source'] or false
                if src and not counted[tostring(src)] then
                    if (j.PlayerData.job.type == v or j.PlayerData.job.name == v) and j.PlayerData.job.onduty then
                        counted[tostring(src)] = true
                        amount += 1
                    end
                end
            end
        end
        return amount
    elseif Config.Framework == "esx" then
        for _, v in pairs(Config.PoliceJobs) do
            local xPlayers = Core.GetExtendedPlayers('job', v)
            amount += #xPlayers
        end
        return amount
    end
    return amount
end