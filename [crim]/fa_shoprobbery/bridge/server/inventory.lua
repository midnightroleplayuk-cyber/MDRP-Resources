Bridge = Bridge or {}

local detectedInventory

local function ResourceStarted(name)
    return GetResourceState(name) == 'started'
end

local function detectInventory()
    if detectedInventory then return detectedInventory end

    if Config.Inventory ~= 'auto' then
        detectedInventory = Config.Inventory
        return detectedInventory
    end

    if ResourceStarted('ox_inventory') then
        detectedInventory = 'ox_inventory'
    elseif ResourceStarted('qb-inventory') then
        detectedInventory = 'qb-inventory'
    elseif ResourceStarted('qs-inventory') then
        detectedInventory = 'qs-inventory'
    elseif ResourceStarted('jaksam_inventory') then
        detectedInventory = 'jaksam_inventory'
    elseif ResourceStarted('tgiann-inventory') then
        detectedInventory = 'tgiann-inventory'
    elseif Bridge.GetFramework() == 'esx' then
        detectedInventory = 'esx'
    else
        detectedInventory = 'custom'
    end

    return detectedInventory
end

function Bridge.GetDetectedInventory()
    return detectInventory()
end

function Bridge.HasItem(src, item, amount)
    if not item then return true end
    amount = amount or 1

    local inventory = detectInventory()

    if inventory == 'ox_inventory' then
        return exports.ox_inventory:GetItemCount(src, item) >= amount
    end

    if inventory == 'qb-inventory' then
        local count = exports['qb-inventory']:GetItemCount(src, item)
        return count and count >= amount
    end

    if inventory == 'qs-inventory' then
        local count = exports['qs-inventory']:GetItemTotalAmount(src, item)
        return tonumber(count) ~= nil and count >= amount
    end

    if inventory == 'jaksam_inventory' then
        return exports.jaksam_inventory:hasItem(src, item, amount) == true
    end

    if inventory == 'tgiann-inventory' then
        local count = exports['tgiann-inventory']:GetItemCount(src, item)
        return tonumber(count) ~= nil and count >= amount
    end

    if inventory == 'esx' then
        local player = Bridge.GetPlayer(src)
        local invItem = player and player.getInventoryItem and player.getInventoryItem(item)
        return invItem and invItem.count >= amount
    end

    if inventory == 'custom' and exports.fa_inventory then
        return exports.fa_inventory:HasItem(src, item, amount)
    end

    return true
end

function Bridge.CanCarryItem(src, item, amount, metadata)
    if not item then return true end
    amount = amount or 1

    local inventory = detectInventory()

    if inventory == 'ox_inventory' then
        return exports.ox_inventory:CanCarryItem(src, item, amount, metadata) == true
    end

    if inventory == 'qb-inventory' then
        local canAdd = exports['qb-inventory']:CanAddItem(src, item, amount)
        return canAdd == true
    end

    if inventory == 'qs-inventory' then
        return exports['qs-inventory']:CanCarryItem(src, item, amount) == true
    end

    if inventory == 'jaksam_inventory' then
        return exports.jaksam_inventory:canCarryItem(src, item, amount) == true
    end

    if inventory == 'tgiann-inventory' then
        local ok, canCarry = pcall(function()
            return exports['tgiann-inventory']:CanCarryItem(src, item, amount)
        end)
        if ok then return canCarry == true end

        ok, canCarry = pcall(function()
            return exports['tgiann-inventory']:CanAddItem(src, item, amount)
        end)
        return ok and canCarry == true
    end

    if inventory == 'esx' then
        local player = Bridge.GetPlayer(src)
        if player and player.canCarryItem then
            return player.canCarryItem(item, amount) == true
        end

        return true
    end

    if inventory == 'custom' and exports.fa_inventory then
        local ok, canCarry = pcall(function()
            return exports.fa_inventory:CanCarryItem(src, item, amount, metadata)
        end)

        if ok then return canCarry == true end
    end

    return true
end

function Bridge.CanCarryMoney(src, account, amount)
    local framework = Bridge.GetFramework()
    if framework == 'qbox' or framework == 'qb' or framework == 'esx' then return true end

    local items = ServerConfig.StandaloneMoneyItems or {}
    local item = account == 'dirty' and items.Dirty or items.Cash
    if not item or item == '' then return false end

    return Bridge.CanCarryItem(src, item, amount)
end

function Bridge.AddItem(src, item, amount, metadata)
    amount = amount or 1
    local inventory = detectInventory()

    if inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(src, item, amount, metadata)
    end

    if inventory == 'qb-inventory' then
        return exports['qb-inventory']:AddItem(src, item, amount, false, metadata)
    end

    if inventory == 'qs-inventory' then
        return exports['qs-inventory']:AddItem(src, item, amount, false, metadata)
    end

    if inventory == 'jaksam_inventory' then
        return exports.jaksam_inventory:addItem(src, item, amount, metadata)
    end

    if inventory == 'tgiann-inventory' then
        return exports['tgiann-inventory']:AddItem(src, item, amount, false, metadata, false)
    end

    if inventory == 'esx' then
        local player = Bridge.GetPlayer(src)
        if player and player.addInventoryItem then
            player.addInventoryItem(item, amount)
            return true
        end
    end

    if inventory == 'custom' and exports.fa_inventory then
        return exports.fa_inventory:AddItem(src, item, amount, metadata)
    end

    return false
end

function Bridge.RemoveItem(src, item, amount)
    if not item then return true end
    amount = amount or 1
    local inventory = detectInventory()

    if inventory == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(src, item, amount)
    end

    if inventory == 'qb-inventory' then
        return exports['qb-inventory']:RemoveItem(src, item, amount)
    end

    if inventory == 'qs-inventory' then
        return exports['qs-inventory']:RemoveItem(src, item, amount)
    end

    if inventory == 'jaksam_inventory' then
        return exports.jaksam_inventory:removeItem(src, item, amount)
    end

    if inventory == 'tgiann-inventory' then
        return exports['tgiann-inventory']:RemoveItem(src, item, amount)
    end

    if inventory == 'esx' then
        local player = Bridge.GetPlayer(src)
        if player and player.removeInventoryItem then
            player.removeInventoryItem(item, amount)
            return true
        end
    end

    if inventory == 'custom' and exports.fa_inventory then
        return exports.fa_inventory:RemoveItem(src, item, amount)
    end

    return false
end

function Bridge.AddMoney(src, account, amount)
    local framework = Bridge.GetFramework()
    local player = Bridge.GetPlayer(src)
    account = account or 'cash'

    if framework == 'qbox' and exports.qbx_core then
        return exports.qbx_core:AddMoney(src, account == 'dirty' and 'cash' or account, amount, 'store-robbery')
    end

    if framework == 'qb' and player and player.Functions then
        player.Functions.AddMoney(account == 'dirty' and 'cash' or account, amount, 'store-robbery')
        return true
    end

    if framework == 'esx' and player then
        if account == 'dirty' and player.addAccountMoney then
            player.addAccountMoney('black_money', amount)
            return true
        end

        if player.addMoney then
            player.addMoney(amount)
            return true
        end
    end

    local items = ServerConfig.StandaloneMoneyItems or {}
    local item = account == 'dirty' and items.Dirty or items.Cash
    if not item or item == '' then return false end

    return Bridge.AddItem(src, item, amount)
end
