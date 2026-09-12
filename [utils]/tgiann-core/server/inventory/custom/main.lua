-- All the code in the file is included as an example. You should edit these exports according to your own script.

if not configCore.custom.customInventory then return end
local myInventory = exports["my-inventory-script"]

---@class CustomInventoryItem
---@field label string
---@field name string
---@field weight number

---@class CustomInventoryPlayerItem : CustomInventoryItem
---@field amount number
---@field slot number
---@field info table ## Metadata/info about the item

---@return table<string, CustomInventoryItem>
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.Items = function()
    return myInventory:Items()
end

---@param xPlayer any
---@return table<string | number, CustomInventoryItem>
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.getPlayerItems = function(xPlayer)
    local src = tgiCore.getSource(xPlayer)
    return myInventory:GetPlayerItems(src)
end

---@param xPlayer any
---@param item string
---@param amount number
---@param slot number
---@return boolean
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.removeItem = function(xPlayer, item, amount, slot)
    local src = tgiCore.getSource(xPlayer)
    return myInventory:RemoveItem(src, item, amount, slot)
end

---@param xPlayer any
---@param item string
---@param amount number
---@param slot number
---@param metadata table
---@return boolean
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.addItem = function(xPlayer, item, amount, slot, metadata)
    local src = tgiCore.getSource(xPlayer)
    return myInventory:AddItem(src, item, amount, slot, metadata)
end

---@param stashName string
---@param item string
---@param amount number
---@param slot number
---@param metadata table
---@return boolean
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.addItemToStash = function(stashName, item, amount, slot, metadata)
    return myInventory:AddItemToSecondaryInventory("stash", stashName, item, amount, slot, metadata)
end

---@param stashName string
---@param item string
---@param amount number
---@param slot number
---@param metadata table
---@return boolean
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.removeItemFromStash = function(stashName, item, amount, slot, metadata)
    return myInventory:RemoveItemFromSecondaryInventory("stash", stashName, item, amount, slot, metadata)
end

---@param stashName string
---@param item string
---@return CustomInventoryPlayerItem|nil
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.getStashItemByName = function(stashName, item)
    return myInventory:GetItemByNameFromSecondaryInventory("stash", stashName, item)
end

---@param item string
---@return string
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.itemName = function(item)
    local itemData = myInventory:Items(item)
    if itemData then
        return itemData.label
    else
        return string.format("Item Not Found! %s", item)
    end
end

---@param xPlayer any
---@param item string
---@return CustomInventoryPlayerItem|nil
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.getItemByName = function(xPlayer, item)
    local src = tgiCore.getSource(xPlayer)
    return myInventory:GetItemByName(src, item)
end

---@param xPlayer any
---@param slot number
---@return CustomInventoryPlayerItem|nil
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.getItemBySlot = function(xPlayer, slot)
    local src = tgiCore.getSource(xPlayer)
    return myInventory:GetItemBySlot(src, slot)
end

---@param xPlayer any
---@param search "slots" | "count"
---@param item any
---@param metadata table | string | number | boolean
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.search = function(xPlayer, search, item, metadata)
    local items = tgiCore.getPlayerItems(xPlayer)
    return inventory.search(items, search, item, metadata)
end

---@param xPlayer any
---@param item string
---@param slot number
---@param metadata table
---@diagnostic disable-next-line:duplicate-set-field
tgiCore.SetMetadata = function(xPlayer, item, slot, metadata)
    local removed = tgiCore.removeItem(xPlayer, item, 1, slot)
    if removed then
        return tgiCore.addItem(xPlayer, item, 1, slot, metadata)
    end
    return false
end
