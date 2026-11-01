---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "one" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }
-- Stash / shop / trunk / plate helpers
-- File-local stash registry.
local stashes = {}

function Sky.FW.GetInventoryStats(source)
    local weight = exports["one_inventory"]:GetWeightHolding(source)
    local free_weight = exports["one_inventory"]:GetWeightLeft(source)
    return helpers.NormalizeInventoryStats(weight, weight + free_weight, nil, nil, 1000)
end

---@description Add an item to the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    return exports.one_inventory:AddItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot) == true
end

---@description Remove an item from the player's inventory; returns the amount removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return 0
    end

    if slot == nil and helpers.NormalizeMetadata(metadata) then
        for _, inventoryItem in ipairs(Sky.FW.GetInventoryItems(source)) do
            if inventoryItem.name == item and helpers.MetadataMatches(inventoryItem.metadata, metadata) then
                slot = inventoryItem.slot
                break
            end
        end
        if slot == nil then
            return 0
        end
    end

    local success = exports.one_inventory:RemoveItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot)
    if success then
        return amount
    end
    return 0
end

---@description Check whether the player can carry the given quantity of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return exports.one_inventory:CanCarryItem(source, item, amount)
end

---@description Check whether the player has at least the given amount of an item.
---@param source number
---@param itemName string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, itemName, amount, metadata)
    return exports.one_inventory:HasItem(source, itemName, tonumber(amount) or 1, helpers.NormalizeMetadata(metadata)) == true
end

---@description Return a normalized list of all items in the player's inventory.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local inventoryItems = exports.one_inventory:GetInventoryItems(source)
    if type(inventoryItems) ~= "table" then
        return {}
    end

    local items = {}
    for index, inventoryItem in pairs(inventoryItems) do
        local normalized = helpers.NormalizeSlotItem(inventoryItem, tonumber(inventoryItem and inventoryItem.slot) or tonumber(index) or index)
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Return a single normalized item entry (with count/metadata) or nil.
---@param source number
---@param itemName string
---@param metadata? table
---@return table|nil
function Sky.FW.GetInventoryItem(source, itemName, metadata)
    local count = tonumber(exports.one_inventory:GetItemCount(source, itemName, helpers.NormalizeMetadata(metadata))) or 0
    if count <= 0 then
        return nil
    end

    local item = exports.one_inventory:GetItem(source, itemName, helpers.NormalizeMetadata(metadata)) or {}
    local result = {
        name = itemName,
        label = helpers.ResolveItemLabel(item.label or Sky.FW.GetItemLabel(itemName), item.metadata),
        amount = count,
        count = count
    }

    local itemMetadata = helpers.NormalizeMetadata(item.metadata)
    if itemMetadata then
        result.metadata = itemMetadata
    end

    return result
end

---@description Return all inventory slots that hold the item matching the metadata.
---@param source number
---@param itemName string
---@param metadata? table
---@return table
function Sky.FW.GetInventorySlotsWithItem(source, itemName, metadata)
    local inventoryItems = exports.one_inventory:SearchInventory(source, itemName, helpers.NormalizeMetadata(metadata))
    if type(inventoryItems) ~= "table" then
        return {}
    end

    local items = {}
    for index, inventoryItem in pairs(inventoryItems) do
        if helpers.MetadataMatches(inventoryItem and inventoryItem.metadata, metadata) then
            local normalized = helpers.NormalizeSlotItem(inventoryItem, tonumber(inventoryItem and inventoryItem.slot) or tonumber(index) or index)
            if normalized then
                items[#items + 1] = normalized
            end
        end
    end
    return items
end

---@description Return the normalized item in the given slot, or nil.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return nil
    end
    return helpers.NormalizeSlotItem(exports.one_inventory:GetSlot(source, numericSlot), numericSlot)
end

---@description Set the metadata of the item in the given slot.
---@param source number
---@param slotId number
---@param metadata table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end
    return exports.one_inventory:SetItemMetadata(source, numericSlot, metadata or {}) == true
end

---@description Return the full item-definitions table from the inventory.
---@return table
function Sky.FW.GetItems()
    return exports.one_inventory:GetAllItemDefinitions()
end

---@description Return the display label for an item name (falls back to the name).
---@param itemName string
---@return string
function Sky.FW.GetItemLabel(itemName)
    local itemDefinition = exports.one_inventory:GetItemDefinition(itemName)
    if type(itemDefinition) == "table" and type(itemDefinition.label) == "string" then
        return itemDefinition.label
    end
    return itemName
end

---@description Return item definition info {name, label, stack, weight, description, image}.
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local itemData = exports.one_inventory:GetItemDefinition(item)
    if not itemData then
        return {}
    end
    return {
        name = itemData.name,
        label = itemData.label,
        stack = itemData.unique,
        weight = itemData.weight,
        description = itemData.description,
        image = (itemData.client and itemData.client.image) or itemData.image
    }
end

---@description Return normalized slot data {name, label, weight, slot, count, metadata}.
---@param source number
---@param slot number
---@return table
function Sky.FW.GetItemBySlot(source, slot)
    local slotData = exports.one_inventory:GetSlot(source, slot)
    if not slotData then
        return {}
    end
    return {
        name = slotData.name,
        label = helpers.ResolveItemLabel(slotData.label or slotData.name, slotData.info or slotData.metadata),
        weight = slotData.weight,
        slot = slotData.slot,
        count = slotData.amount or slotData.count,
        metadata = slotData.info or slotData.metadata
    }
end

---@description Return the name of the inventory resource in use.
---@return string
function Sky.FW.GetResourceName()
    return "one_inventory"
end

---@description Check whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return exports.one_inventory:CanCarryItem(source, weaponName, 1)
end

---@description Add a weapon to the player's inventory.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local weaponMetadata = helpers.NormalizeMetadata(metadata) or { ammo = ammo }
    return exports.one_inventory:AddItem(source, weaponName, 1, weaponMetadata) == true
end

---@description Remove a weapon from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return exports.one_inventory:RemoveItem(source, weaponName, 1, helpers.NormalizeMetadata(metadata)) == true
end

---@description Return the list of weapons in the player's inventory.
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

---@description Register a stash definition in the file-local registry.
---@param id string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? table
---@return boolean
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if type(id) ~= "string" then
        Sky.Debug("error", "[inventory/one] RegisterStash failed: id must be a string, got %s", type(id))
        return false
    end
    if stashes[id] then
        return true, id
    end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Open a stash/trunk/glovebox inventory for the player.
---@param source number
---@param _type string "stash", "trunk", "glovebox"
---@param id string
function Sky.FW.OpenStash(source, _type, id)
    _type = _type or "stash:"
    if _type == "trunk" then
        _type = "vehicle:trunk:"
    elseif _type == "glovebox" then
        _type = "vehicle:glovebox:"
    elseif _type ~= "stash" then
        _type = "stash:"
    end
    return exports.one_inventory:OpenInventory(source, _type, { id = id })
end

---@description Add a list of items to a stash.
---@param id string
---@param items table {item, count, metadata}
---@return boolean
function Sky.FW.AddStashItems(id, items)
    if type(items) ~= "table" then
        Sky.Debug("error", "[inventory/one] AddStashItems failed: items must be a table, got %s", type(items))
        return false
    end
    local success = false
    for _, item in pairs(items) do
        success = exports.one_inventory:AddItem(id, item.item or item.name, item.amount or item.count, item.metadata or item.info or {}, nil)
    end
    return success
end

---@description Clear a stash/trunk/glovebox inventory and drop it from the registry.
---@param id string
---@param _type? string "stash", "trunk", "glovebox"
---@return boolean
function Sky.FW.ClearStash(id, _type)
    if type(id) ~= "string" then
        Sky.Debug("error", "[inventory/one] ClearStash failed: id must be a string, got %s", type(id))
        return false
    end
    if stashes[id] then
        stashes[id] = nil
    end
    if _type == "trunk" then
        id = "vehicle:trunk:" .. id
    elseif _type == "glovebox" then
        id = "vehicle:glovebox:" .. id
    elseif _type ~= "stash" then
        id = "stash:" .. id
    end
    exports.one_inventory:ClearInventory(id, false, false)
    return true
end

---@description Open a target player's inventory for the source player (admin use).
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    if not source or not target then
        Sky.Debug("error", "[inventory/one] OpenPlayerInventory failed: source and target are required (source=%s, target=%s)", tostring(source), tostring(target))
        return false
    end
    exports.one_inventory:OpenInventory(source, "player:", target)
    return true
end

---@description Open a shop inventory for the player.
---@param source number
---@param shopTitle string
function Sky.FW.OpenShop(source, shopTitle)
    return exports.one_inventory:OpenInventory(source, "shop", shopTitle)
end

---@description Add a list of items to a vehicle trunk.
---@param identifier string
---@param items table
---@return boolean
function Sky.FW.AddTrunkItems(identifier, items)
    if type(items) ~= "table" then
        Sky.Debug("error", "[inventory/one] AddTrunkItems failed: items must be a table, got %s", type(items))
        return false
    end
    local fullTrunkId = "vehicle:trunk:" .. identifier
    Wait(1000)
    for i = 1, #items do
        exports.one_inventory:AddItem(fullTrunkId, items[i].name, items[i].amount or items[i].count, items[i].metadata or items[i].info or {}, nil)
    end
    return true
end

---@description Update the vehicle plate stored in the inventory (and jg-mechanic if present).
---@param oldplate string
---@param newplate string
---@return boolean
---@return any (optional) jg-mechanic update result
function Sky.FW.UpdatePlate(oldplate, newplate)
    exports.one_inventory:UpdateVehiclePlate(oldplate, newplate)
    if GetResourceState("jg-mechanic") == "missing" then
        return true
    end
    return true, exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end
