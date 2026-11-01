---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "codem" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }

-- File-local stash registry.
local stashes = {}

function Sky.FW.GetInventoryStats(source)
    local identifier = Sky.FW.GetIdentifier(source)
    if not identifier then
        Sky.Debug("error", "[inventory] CodeM statistics unavailable: player %s is not loaded", source)
        return nil, "unavailable"
    end
    local items = exports["codem-inventory"]:GetInventory(identifier, source)
    if not items then
        Sky.Debug("error", "[inventory] CodeM statistics unavailable: player %s inventory is not loaded", source)
        return nil, "unavailable"
    end
    local weight = exports["codem-inventory"]:GetTotalWeight(items)
    return helpers.NormalizeInventoryStats(weight, nil, nil, nil, 1000)
end

---@description Adds an item to the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    return exports["codem-inventory"]:AddItem(source, item, amount, slot, helpers.NormalizeMetadata(metadata))
end

---@description Removes an item from the player's inventory and returns the amount removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if not slot and helpers.NormalizeMetadata(metadata) then
        for _, inventoryItem in ipairs(Sky.FW.GetInventoryItems(source)) do
            if inventoryItem.name == item and helpers.MetadataMatches(inventoryItem.metadata, metadata) then
                slot = inventoryItem.slot
                break
            end
        end
        if not slot then return 0 end
    end

    local removed = exports["codem-inventory"]:RemoveItem(source, item, amount, slot)
    return removed and amount or 0
end

-- codem-inventory exposes no carry-weight check; AddItem is the effective gate.
---@description Returns whether the player can carry the given item amount.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return true
end

---@description Returns whether the player has at least the given amount of the item.
---@param source number
---@param itemName string
---@param amount? number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, itemName, amount, metadata)
    amount = tonumber(amount) or 1
    local inventoryItem = Sky.FW.GetInventoryItem(source, itemName, metadata)
    return inventoryItem ~= nil and (tonumber(inventoryItem.amount or inventoryItem.count) or 0) >= amount
end

---@description Returns the player's full inventory as a list of normalized slot items.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local identifier = Sky.FW.GetIdentifier(source)
    if not identifier then
        print(("[inventory/codem] GetInventoryItems failed for source %s: player identifier is invalid"):format(tostring(source)))
        return {}
    end

    local inventory = exports["codem-inventory"]:GetInventory(identifier, source)
    local items = {}
    if type(inventory) ~= "table" then
        print(("[inventory/codem] GetInventoryItems failed for source %s: codem inventory returned %s"):format(tostring(source), type(inventory)))
        return items
    end

    for index, item in pairs(inventory) do
        local normalized = helpers.NormalizeSlotItem(item, tonumber(item and item.slot) or tonumber(index) or index)
        if normalized then
            items[#items + 1] = normalized
        end
    end

    return items
end

---@description Returns an aggregated item entry (summed amount) matching name and metadata, or nil.
---@param source number
---@param itemName string
---@param metadata? table
---@return table|nil
function Sky.FW.GetInventoryItem(source, itemName, metadata)
    local slots = Sky.FW.GetInventorySlotsWithItem(source, itemName, metadata)
    if #slots <= 0 then
        return nil
    end

    local amount = 0
    for _, slot in ipairs(slots) do
        amount = amount + (tonumber(slot.amount or slot.count) or 0)
    end

    local firstSlot = slots[1]
    local result = {
        name = firstSlot.name,
        label = firstSlot.label or firstSlot.name,
        amount = amount,
        count = amount
    }
    local slotMetadata = helpers.NormalizeMetadata(firstSlot.metadata)
    if slotMetadata then
        result.metadata = slotMetadata
    end

    return result
end

---@description Returns all inventory slots holding the item that match the given metadata.
---@param source number
---@param itemName string
---@param metadata? table
---@return table
function Sky.FW.GetInventorySlotsWithItem(source, itemName, metadata)
    local inventoryItems = exports["codem-inventory"]:GetItemsByName(source, itemName)
    if type(inventoryItems) ~= "table" then
        return {}
    end
    if inventoryItems.name then
        inventoryItems = { inventoryItems }
    end

    local items = {}
    for index, inventoryItem in pairs(inventoryItems) do
        if type(inventoryItem) == "table" then
            local itemMetadata = inventoryItem.metadata or inventoryItem.info
            if helpers.MetadataMatches(itemMetadata, metadata) then
                local normalized = helpers.NormalizeSlotItem(inventoryItem, index)
                if normalized then
                    items[#items + 1] = normalized
                end
            end
        end
    end

    return items
end

---@description Returns the normalized item occupying the given slot id, or nil.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return nil
    end

    for index, item in ipairs(Sky.FW.GetInventoryItems(source) or {}) do
        local itemSlot = tonumber(item and item.slot) or index
        if itemSlot == numericSlot then
            return helpers.NormalizeSlotItem(item, itemSlot)
        end
    end

    return nil
end

---@description Sets the metadata of the item in the given slot.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end
    exports["codem-inventory"]:SetItemMetadata(source, numericSlot, metadata or {})
    return true
end

---@description Returns the full item definition list from the inventory resource.
---@return table
function Sky.FW.GetItems()
    return exports["codem-inventory"]:GetItemList()
end

---@description Returns the display label for an item, falling back to the item name.
---@param itemName string
---@return string
function Sky.FW.GetItemLabel(itemName)
    local items = Sky.FW.GetItems()
    if type(items) == "table" then
        local itemData = items[itemName] or items[type(itemName) == "string" and itemName:lower() or itemName]
        if type(itemData) == "table" and type(itemData.label) == "string" then
            return itemData.label
        end

        for _, itemDataEntry in pairs(items) do
            if type(itemDataEntry) == "table" and itemDataEntry.name == itemName and type(itemDataEntry.label) == "string" then
                return itemDataEntry.label
            end
        end
    end

    return itemName
end

---@description Returns a normalized item info table {name, label, stack, weight, description, image}.
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local items = Sky.FW.GetItems()
    if type(items) ~= "table" or type(items[item]) ~= "table" then
        return {}
    end
    local itemData = items[item]
    return {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = (itemData.client and itemData.client.image) or itemData.image
    }
end

---@description Returns the normalized item data for a specific slot, or nil.
---@param source number
---@param slot number
---@return table|nil
function Sky.FW.GetItemBySlot(source, slot)
    local slotData = exports["codem-inventory"]:GetItemBySlot(source, slot)
    if type(slotData) ~= "table" then
        return nil
    end
    return {
        name = slotData.name,
        label = helpers.ResolveItemLabel(slotData.label or slotData.name, slotData.info or slotData.metadata),
        weight = slotData.weight,
        slot = slotData.slot,
        count = slotData.amount or slotData.count,
        metadata = slotData.info or slotData.metadata or {}
    }
end

---@description Returns the name of the inventory resource in use.
---@return string
function Sky.FW.GetResourceName()
    return "codem-inventory"
end

---@description Returns whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return Sky.FW.CanCarryItem(source, weaponName, 1, metadata)
end

---@description Adds a weapon to the player's inventory.
---@param source number
---@param weaponName string
---@param ammo? number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local info = metadata or { quality = 100, ammo = ammo }
    return exports["codem-inventory"]:AddItem(source, weaponName, 1, nil, info)
end

---@description Removes a weapon from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    if helpers.NormalizeMetadata(metadata) then
        return Sky.FW.RemoveItem(source, weaponName, 1, nil, metadata) > 0
    end
    return exports["codem-inventory"]:RemoveItem(source, weaponName, 1) == true
end

---@description Returns the list of weapons in the player's inventory.
---@param source number
---@return table
function Sky.FW.GetWeapons(source)
    local weapons = {}
    for _, item in ipairs(Sky.FW.GetInventoryItems(source) or {}) do
        local name = item.name
        if type(name) == "string" and name:lower():find("^weapon_") then
            weapons[#weapons + 1] = {
                name = name,
                label = item.label or name,
                amount = tonumber(item.amount or item.count) or 1,
                ammo = item.metadata and item.metadata.ammo or nil,
                metadata = item.metadata
            }
        end
    end
    return weapons
end

---@description Registers a stash in the file-local registry.
---@param id string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? table
---@return boolean, string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then
        return true, id
    end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Adds items to a stash.
---@param id string
---@param items table
---@return boolean
function Sky.FW.AddStashItems(id, items)
    if type(items) ~= "table" then
        return false
    end
    local repack = {}
    for _, v in pairs(items) do
        repack[#repack + 1] = {
            item = v.item,
            amount = v.count or v.amount,
            info = v.metadata or v.info or {},
            unique = v.unique or v.stack or false,
            description = v.description or "none",
            weight = Sky.FW.GetItemInfo(v.item).weight or 0,
            type = "item",
            slot = #repack + 1
        }
    end
    exports["codem-inventory"]:UpdateStash(id, repack)
    return true
end

---@description Clears a stash's contents and removes it from the registry.
---@param id string
---@param _type? string
---@return boolean
function Sky.FW.ClearStash(id, _type)
    if type(id) ~= "string" then
        return false
    end
    if stashes[id] then
        stashes[id] = nil
    end
    exports["codem-inventory"]:UpdateStash(id, {})
    return true
end
