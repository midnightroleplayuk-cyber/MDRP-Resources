
local Inventory = {}

local function usesOxInventory()
    return GetResourceState('ox_inventory') == 'started'
end

local function usesJaksamInventory()
    return GetResourceState('jaksam_inventory') == 'started'
end

local function usesQsInventory()
    return GetResourceState('qs-inventory') == 'started'
end

---@param source number
---@param itemName string
---@param count number|nil
---@return boolean
function Inventory.canCarryItem(source, itemName, count)
    count = math.floor(tonumber(count) or 1)
    if count < 1 or not itemName then return false end
    if usesOxInventory() then
        local ok, result = pcall(function()
            return exports.ox_inventory:CanCarryItem(source, itemName, count)
        end)
        if not ok then return true end
        -- nil means item doesn't exist in ox items — treat as not carryable
        if result == nil then return false end
        return result == true
    end
    if usesJaksamInventory() then
        local ok, result = pcall(function()
            return exports.jaksam_inventory:canCarryItem(source, itemName, count)
        end)
        if not ok then return true end
        return result == true
    end
    if usesQsInventory() then
        local ok, result = pcall(function()
            return exports['qs-inventory']:CanCarryItem(source, itemName, count)
        end)
        if not ok then return true end
        return result == true
    end
    return true
end

---@param source number
---@param itemName string
---@param count number|nil
---@return boolean success
function Inventory.giveItem(source, itemName, count)
    count = math.floor(tonumber(count) or 1)
    if count < 1 or not itemName or itemName == '' then return false end

    if usesOxInventory() then
        local ok, result = pcall(function()
            return exports.ox_inventory:AddItem(source, itemName, count)
        end)
        if not ok then
            lib.print.error(('[inventory] ox AddItem(%s, %s) error: %s'):format(itemName, count, result))
            return false
        end
        -- ox returns false on failure; otherwise item data / true
        return result ~= false and result ~= nil
    end

    if usesJaksamInventory() then
        local ok, success, resultCode = pcall(function()
            return exports.jaksam_inventory:addItem(source, itemName, count)
        end)
        if not ok then
            lib.print.error(('[inventory] jaksam addItem(%s, %s) error: %s'):format(itemName, count, success))
            return false
        end
        if not success then
            lib.print.error(('[inventory] jaksam addItem(%s, %s) failed: %s'):format(itemName, count, resultCode))
        end
        return success == true
    end

    if usesQsInventory() then
        local ok, err = pcall(function()
            exports['qs-inventory']:AddItem(source, itemName, count)
        end)
        if not ok then
            lib.print.error(('[inventory] qs-inventory AddItem(%s, %s) error: %s'):format(itemName, count, err))
        end
        return ok == true
    end

    local xPlayer = server.getPlayer(source)
    if not xPlayer then return false end

    local framework = shared.getFrameworkName and shared.getFrameworkName() or shared.framework
    if framework == 'esx' then
        -- ESX addInventoryItem usually returns nil even on success
        local ok = pcall(function()
            xPlayer.addInventoryItem(itemName, count)
        end)
        return ok == true
    elseif framework == 'qb' or framework == 'qbx' then
        local added = xPlayer.Functions.AddItem(itemName, count)
        return added ~= false and added ~= nil
    end
    return false
end

---@param source number
---@param itemName string
---@param count number|nil
---@return boolean
function Inventory.removeItem(source, itemName, count)
    count = math.floor(tonumber(count) or 1)
    if count < 1 or not itemName then return false end

    if usesOxInventory() then
        local ok, result = pcall(function()
            return exports.ox_inventory:RemoveItem(source, itemName, count)
        end)
        return ok and result == true
    end

    if usesJaksamInventory() then
        local ok, success = pcall(function()
            return exports.jaksam_inventory:removeItem(source, itemName, count)
        end)
        return ok and success == true
    end

    if usesQsInventory() then
        local ok, err = pcall(function()
            exports['qs-inventory']:RemoveItem(source, itemName, count)
        end)
        if not ok then
            lib.print.error(('[inventory] qs-inventory RemoveItem(%s, %s) error: %s'):format(itemName, count, err))
        end
        return ok == true
    end

    local xPlayer = server.getPlayer(source)
    if not xPlayer then return false end

    local framework = shared.getFrameworkName and shared.getFrameworkName() or shared.framework
    if framework == 'esx' then
        local ok = pcall(function()
            xPlayer.removeInventoryItem(itemName, count)
        end)
        return ok == true
    elseif framework == 'qb' or framework == 'qbx' then
        local removed = xPlayer.Functions.RemoveItem(itemName, count)
        return removed ~= false and removed ~= nil
    end
    return false
end

function Inventory.hasItem(source, itemName, amount)
    amount = amount or 1
    return Inventory.getItemCountByName(source, itemName) >= amount
end

function Inventory.getItemCountByName(source, itemName)
    if not itemName then return 0 end
    if usesOxInventory() then
        local ok, count = pcall(function()
            return exports.ox_inventory:GetItemCount(source, itemName) or 0
        end)
        if not ok then return 0 end
        return tonumber(count) or 0
    end

    if usesJaksamInventory() then
        local ok, count = pcall(function()
            return exports.jaksam_inventory:getTotalItemAmount(source, itemName) or 0
        end)
        if not ok then return 0 end
        return tonumber(count) or 0
    end

    if usesQsInventory() then
        local ok, count = pcall(function()
            return exports['qs-inventory']:GetItemTotalAmount(source, itemName) or 0
        end)
        if not ok then return 0 end
        return tonumber(count) or 0
    end

    local xPlayer = server.getPlayer(source)
    if not xPlayer then return 0 end

    local count = 0
    local item = nil
    local framework = shared.getFrameworkName and shared.getFrameworkName() or shared.framework
    if framework == 'esx' then
        item = xPlayer.hasItem and xPlayer.hasItem(itemName) or (xPlayer.getInventoryItem and xPlayer.getInventoryItem(itemName))
    else
        item = xPlayer.Functions.GetItemByName(itemName)
    end
    if item then count = item.amount or item.count or 0 end
    return tonumber(count) or 0
end

return Inventory
