---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "qs" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }

---@description Register a usable item through Quasar with normalized slot data.
---@param name string
---@param callback function|nil
---@return boolean
function Sky.FW.RegisterUsableItem(name, callback)
    if not callback then
        -- The Base-owned dispatcher handles deactivation; QS only accepts callbacks.
        return true
    end

    exports["qs-inventory"]:CreateUsableItem(name, function(source, item)
        local normalized = helpers.NormalizeSlotItem(item, item.slot)
        return callback(source, normalized)
    end)
    return true
end

local function get_inventory_items(source)
    local inventory = exports["qs-inventory"]:GetInventory(source)
    if type(inventory) == "table" and type(inventory.items) == "table" then
        return inventory.items
    end
    if type(inventory) == "table" then
        return inventory
    end
    return {}
end

-- Stash / shop / trunk / plate helpers
local stashes = {}

---@description Add an item to the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    metadata = helpers.NormalizeMetadata(metadata)
    if metadata then
        return exports["qs-inventory"]:AddItem(source, item, amount, slot, metadata)
    end
    return exports["qs-inventory"]:AddItem(source, item, amount, slot)
end

---@description Remove an item from the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if slot ~= nil then
        local removed = exports["qs-inventory"]:RemoveItem(source, item, amount, slot)
        if removed == false then
            return 0
        end
        return amount
    end

    local expectedMetadata = helpers.NormalizeMetadata(metadata)
    local normalizedItemName = type(item) == "string" and item:lower() or nil
    if expectedMetadata and normalizedItemName then
        local remaining = tonumber(amount) or 0
        local removedAmount = 0

        for index, inventoryItem in pairs(get_inventory_items(source)) do
            if remaining <= 0 then
                break
            end

            if type(inventoryItem) == "table"
                and type(inventoryItem.name) == "string"
                and inventoryItem.name:lower() == normalizedItemName
                and helpers.MetadataMatches(inventoryItem.metadata or inventoryItem.info, expectedMetadata) then
                local itemAmount = tonumber(inventoryItem.amount or inventoryItem.count) or 0
                local itemSlot = tonumber(inventoryItem.slot) or tonumber(index)
                local removeAmount = math.min(remaining, itemAmount)

                if itemSlot and removeAmount > 0 then
                    local removed = exports["qs-inventory"]:RemoveItem(source, item, removeAmount, itemSlot, expectedMetadata)
                    if removed ~= false then
                        remaining = remaining - removeAmount
                        removedAmount = removedAmount + removeAmount
                    end
                end
            end
        end

        return removedAmount
    end

    local removed = exports["qs-inventory"]:RemoveItem(source, item, amount)
    if removed == false then
        return 0
    end
    return amount
end

---@description Check whether the player can carry the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return exports["qs-inventory"]:CanCarryItem(source, item, amount)
end

---@description Return the player's inventory as a normalized list of slot items.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local items = {}
    for index, inventoryItem in pairs(get_inventory_items(source)) do
        local normalized = helpers.NormalizeSlotItem(inventoryItem, tonumber(inventoryItem and inventoryItem.slot) or tonumber(index) or index)
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Return all inventory slots holding the named item (optionally matching metadata).
---@param source number
---@param itemName string
---@param metadata? table
---@return table
function Sky.FW.GetInventorySlotsWithItem(source, itemName, metadata)
    local normalizedName = type(itemName) == "string" and itemName:lower() or nil
    if not normalizedName then
        return {}
    end

    local items = {}
    for index, inventoryItem in pairs(get_inventory_items(source)) do
        if type(inventoryItem) == "table"
            and type(inventoryItem.name) == "string"
            and inventoryItem.name:lower() == normalizedName
            and helpers.MetadataMatches(inventoryItem.metadata or inventoryItem.info, metadata) then
            local normalized = helpers.NormalizeSlotItem(inventoryItem, index)
            if normalized then
                items[#items + 1] = normalized
            end
        end
    end
    return items
end

---@description Return the normalized item occupying the given slot, or nil.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return nil
    end

    for index, inventoryItem in pairs(get_inventory_items(source)) do
        local itemSlot = tonumber(inventoryItem and inventoryItem.slot) or tonumber(index)
        if itemSlot == numericSlot then
            return helpers.NormalizeSlotItem(inventoryItem, itemSlot)
        end
    end
    return nil
end

---@description Set the metadata of the item in the given slot.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end
    exports["qs-inventory"]:SetItemMetadata(source, numericSlot, metadata or {})
    return true
end

---@description Return item definition info {name, label, stack, weight, description, image}.
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local itemsData = exports["qs-inventory"]:GetItemList()
    if not itemsData then return {} end
    local itemData = itemsData[item]
    if not itemData then return {} end
    return {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = (itemData.client and itemData.client.image) or itemData.image
    }
end

---@description Return the item occupying the given slot {name, label, weight, slot, count, metadata}, or nil.
---@param source number
---@param slot number
---@return table|nil
function Sky.FW.GetItemBySlot(source, slot)
    for _, item in pairs(get_inventory_items(source)) do
        if item.slot == slot then
            return {
                name = item.name,
                label = helpers.ResolveItemLabel(item.label or item.name, item.info or item.metadata),
                weight = item.weight,
                slot = slot,
                count = item.amount or item.count,
                metadata = item.info or item.metadata or {}
            }
        end
    end
    return nil
end

---@description Return the name of the inventory resource in use.
---@return string
function Sky.FW.GetResourceName()
    return "qs-inventory"
end

---@description Check whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return exports["qs-inventory"]:CanCarryItem(source, weaponName, 1)
end

---@description Add a weapon to the player's inventory.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local weaponMetadata = helpers.NormalizeMetadata(metadata)
    if not weaponMetadata then
        weaponMetadata = { quality = 100, ammo = ammo }
    end
    return exports["qs-inventory"]:AddItem(source, weaponName, 1, nil, weaponMetadata)
end

---@description Remove a weapon from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    if helpers.NormalizeMetadata(metadata) then
        return Sky.FW.RemoveItem(source, weaponName, 1, nil, metadata) > 0
    end
    return exports["qs-inventory"]:RemoveItem(source, weaponName, 1) == true
end

---@description Register a stash definition for later opening.
---@param id string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? vector3
---@return boolean, string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then return true, id end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Open a previously registered stash for the player.
---@param source number
---@param _type? string
---@param id string
---@return boolean
function Sky.FW.OpenStash(source, _type, id)
    _type = _type or "stash"
    local tbl = stashes[id]
    if not tbl then
        Sky.Debug("debug", "[inventory] OpenStash called for unregistered stash '%s'", tostring(id))
        return false
    end
    TriggerEvent("inventory:server:OpenInventory", _type, id, { maxweight = tbl.weight or 5000, slots = tbl.slots or 20 })
    TriggerClientEvent("inventory:client:SetCurrentStash", source, id)
    return true
end

---@description Clear the contents of the specified stash inventory.
---@param id string
---@param _type? string
---@return boolean
function Sky.FW.ClearStash(id, _type)
    if type(id) ~= "string" then
        Sky.Debug("error", "[inventory] ClearStash requires a string id, got '%s'", type(id))
        return false
    end
    exports["qs-inventory"]:ClearOtherInventory(_type, id)
    return true
end

---@description Update the vehicle plate stored in trunk/glovebox inventories (and jg-mechanic if present).
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    local queries = {
        "UPDATE inventory_trunk SET plate = @newplate WHERE plate = @oldplate",
        "UPDATE inventory_glovebox SET plate = @newplate WHERE plate = @oldplate"
    }
    local values = { newplate = newplate, oldplate = oldplate }
    MySQL.transaction.await(queries, values)
    if GetResourceState("jg-mechanic") == "missing" then return true end
    return true, exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end
