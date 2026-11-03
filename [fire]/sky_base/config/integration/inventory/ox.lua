---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "ox" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }

function Sky.FW.GetInventoryStats(source)
    local inventory = exports.ox_inventory:GetInventory(source)
    if not inventory then
        Sky.Debug("error", "[inventory] ox statistics unavailable: player %s inventory is not loaded", source)
        return nil, "unavailable"
    end
    return helpers.NormalizeInventoryStats(inventory.weight, inventory.maxWeight,
        helpers.CountOccupiedSlots(inventory.items), inventory.slots, 1000)
end

local stashes = {}

function Sky.FW.TakeVehicleInventoryItem(source, plate, compartment, netId, slot, name, amount)
    local items, code = Sky.FW.GetVehicleInventoryItems(plate, compartment, netId)
    if not items then return false, code end
    local prefix = ({ trunk = "trunk", glovebox = "glove" })[compartment]
    local inventory = exports.ox_inventory:GetInventory({ id = prefix .. plate, netid = netId })
    if not inventory then return false, "unavailable" end
    return helpers.TakeVehicleSlot(source, items, slot, name, amount, function(item, count)
        return exports.ox_inventory:RemoveItem(inventory.id, item.name, count, item.metadata, item.slot, false, true)
    end, function(item, count)
        return exports.ox_inventory:AddItem(inventory.id, item.name, count, item.metadata, item.slot)
    end)
end

function Sky.FW.GetVehicleInventoryItems(plate, compartment, netId)
    local prefix = ({ trunk = "trunk", glovebox = "glove" })[compartment]
    if not prefix or type(plate) ~= "string" or not plate:find("%S") or type(netId) ~= "number" then
        print("[sky_base] ox_inventory vehicle read rejected: invalid plate, compartment or network ID")
        return nil, "invalid_target"
    end
    -- The provider resolves plate trimming and loads unopened persisted storage itself.
    local inventory = exports.ox_inventory:GetInventory({ id = prefix .. plate, netid = netId })
    return helpers.NormalizeStorageItems(inventory and inventory.items)
end

---@description Adds an item to the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    return exports.ox_inventory:AddItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot)
end

---@description Removes an item from the player's inventory and returns the amount removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if slot then
        local success = exports.ox_inventory:RemoveItem(source, item, amount, nil, slot)
        return success and amount or 0
    end

    if helpers.NormalizeMetadata(metadata) then
        for _, inventoryItem in ipairs(Sky.FW.GetInventoryItems(source)) do
            if inventoryItem.name == item and helpers.MetadataMatches(inventoryItem.metadata, metadata) then
                slot = inventoryItem.slot
                break
            end
        end
        if not slot then return 0 end
    end

    local success = exports.ox_inventory:RemoveItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot)
    return success and amount or 0
end

---@description Checks whether the player can carry the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return exports.ox_inventory:CanCarryItem(source, item, amount, metadata)
end

---@description Returns true when the player has at least the requested amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, item, amount, metadata)
    amount = tonumber(amount) or 1
    local count = exports.ox_inventory:GetItemCount(source, item, metadata)
    return count ~= nil and count >= amount
end

---@description Returns the player's inventory as a normalized list of item slots.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local items = {}
    for index, item in pairs(exports.ox_inventory:GetInventoryItems(source) or {}) do
        local normalized = helpers.NormalizeSlotItem(item, tonumber(item and item.slot) or tonumber(index) or index, { amountOrder = "count_first" })
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Returns a single normalized item entry, or nil when the player has none.
---@param source number
---@param item string
---@param metadata? table
---@return table?
function Sky.FW.GetInventoryItem(source, item, metadata)
    local count = tonumber(exports.ox_inventory:GetItemCount(source, item, metadata) or 0) or 0
    if count <= 0 then
        return nil
    end

    local resolvedMetadata = helpers.NormalizeMetadata(metadata)
    if not resolvedMetadata then
        local slots = exports.ox_inventory:GetSlotsWithItem(source, item, nil, false) or {}
        resolvedMetadata = helpers.NormalizeMetadata(slots[1] and slots[1].metadata)
    end

    return {
        name = item,
        label = Sky.FW.GetItemLabel(item, resolvedMetadata),
        amount = count,
        count = count,
        metadata = resolvedMetadata
    }
end

---@description Returns the normalized slots that contain the given item.
---@param source number
---@param itemName string
---@param metadata? table
---@return table
function Sky.FW.GetInventorySlotsWithItem(source, itemName, metadata)
    local slots = exports.ox_inventory:GetSlotsWithItem(source, itemName, metadata, false) or {}
    local items = {}
    for index, slot in ipairs(slots) do
        local fullSlot = slot and slot.slot and exports.ox_inventory:GetSlot(source, slot.slot) or slot
        local item = helpers.NormalizeSlotItem(fullSlot, index, { amountOrder = "count_first" })
        if item then
            items[#items + 1] = item
        end
    end
    return items
end

---@description Returns the normalized item in a specific slot, or nil when empty/invalid.
---@param source number
---@param slotId number
---@return table?
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return nil
    end
    return helpers.NormalizeSlotItem(exports.ox_inventory:GetSlot(source, numericSlot), numericSlot, { amountOrder = "count_first" })
end

---@description Sets the metadata of an item in a specific inventory slot.
---@param source number
---@param slotId number
---@param metadata table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end
    exports.ox_inventory:SetMetadata(source, numericSlot, metadata or {})
    return true
end

---@description Returns the full registered items table.
---@return table
function Sky.FW.GetItems()
    return exports.ox_inventory:Items()
end

---@description Confirms existing ox_inventory items; new definitions must be loaded from data/items.lua.
---@param definition table
---@param options? table
---@return boolean
function Sky.FW.RegisterItem(definition, options)
    if type(definition) ~= "table" or type(definition.name) ~= "string" or definition.name == "" then
        return false
    end

    if exports.ox_inventory:Items(definition.name) then
        return true
    end

    Sky.Debug(
        "debug",
        "[inventory] RegisterItem cannot add missing ox_inventory item '%s'; add it to ox_inventory/data/items.lua and restart the inventory.",
        definition.name
    )
    return false
end

---@description Returns the display label for an item, falling back to its name.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    local oxItem = exports.ox_inventory:Items(item)
    return oxItem and oxItem.label or item
end

---@description Returns item info {name, label, stack, weight, description, image}.
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local itemData = exports.ox_inventory:Items(item)
    if not itemData then
        Sky.Debug("debug", "[Sky.FW.GetItemInfo] No ox_inventory item data for: " .. tostring(item))
        return {}
    end
    return {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.stack or "true",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = string.format("nui://ox_inventory/web/images/%s", itemData.client and itemData.client.image or string.format("%s.png", item))
    }
end

---@description Returns the item in a slot as {name, label, weight, slot, count, metadata?}, or nil.
---@param source number
---@param slot number
---@return table?
function Sky.FW.GetItemBySlot(source, slot)
    local numericSlot = tonumber(slot)
    if not numericSlot then
        return nil
    end

    local oxSlot = exports.ox_inventory:GetSlot(source, numericSlot)
    if type(oxSlot) ~= "table" then
        return nil
    end

    local result = {
        name = oxSlot.name,
        label = helpers.ResolveItemLabel(oxSlot.label or Sky.FW.GetItemLabel(oxSlot.name), oxSlot.metadata),
        weight = oxSlot.weight,
        slot = tonumber(oxSlot.slot) or numericSlot,
        count = tonumber(oxSlot.count or oxSlot.amount) or 0
    }
    local metadata = helpers.NormalizeMetadata(oxSlot.metadata)
    if metadata then
        result.metadata = metadata
    end

    return result
end

---@description Returns the name of the active inventory resource.
---@return string
function Sky.FW.GetResourceName()
    return "ox_inventory"
end

---@description Returns true when the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return exports.ox_inventory:CanCarryItem(source, weaponName, 1, metadata)
end

---@description Adds a weapon item to the player's inventory.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    return exports.ox_inventory:AddItem(source, weaponName, 1, metadata or { ammo = ammo })
end

---@description Removes a weapon item from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return exports.ox_inventory:RemoveItem(source, weaponName, 1, metadata) == true
end

---@description Registers a stash inventory.
---@param id number|string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? table
---@return boolean
---@return string|number
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    id = tostring(id)
    if stashes[id] then
        return true, id
    end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    exports.ox_inventory:RegisterStash(id, label, slots, weight, owner, groups, coords)
    return true, id
end

---@description Opens the specified stash for the player.
---@param source number
---@param _type string "stash", "trunk", "glovebox"
---@param id string
---@return nil
function Sky.FW.OpenStash(source, _type, id)
    _type = _type or "stash"
    exports.ox_inventory:forceOpenInventory(source, _type, id)
end

---@description Adds a list of items to a stash.
---@param id string
---@param items table {item, count, metadata}
---@return boolean
function Sky.FW.AddStashItems(id, items)
    if type(items) ~= "table" then
        Sky.Debug("error", "[Sky.FW.AddStashItems] items is not a table for stash: " .. tostring(id))
        return false
    end
    local success = false
    for _, v in pairs(items) do
        success = exports.ox_inventory:AddItem(id, v.item, v.count or v.amount, v.metadata or v.info or {})
    end
    return success
end

---@description Clears the specified stash inventory.
---@param id string
---@param _type string unused with ox_inventory
---@return boolean
function Sky.FW.ClearStash(id, _type)
    id = tostring(id)
    exports.ox_inventory:ClearInventory(id)
    if stashes[id] then
        stashes[id] = nil
    end
    return true
end

---@description Opens a target player's inventory for the source player (admin use).
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    if not source or not target then
        Sky.Debug("error", "[Sky.FW.OpenPlayerInventory] source and target are required (source=" .. tostring(source) .. ", target=" .. tostring(target) .. ")")
        return false
    end
    exports.ox_inventory:forceOpenInventory(source, "player", target)
    return true
end

---@description Opens the specified shop for the player.
---@param source number
---@param shopTitle string
---@return nil
function Sky.FW.OpenShop(source, shopTitle)
    TriggerClientEvent("ox_inventory:openInventory", source, "shop", { type = shopTitle })
end

---@description Registers a shop inventory.
---@param shopTitle string
---@param shopInventory table
---@param shopCoords table
---@param shopGroups table
---@return boolean
function Sky.FW.RegisterShop(shopTitle, shopInventory, shopCoords, shopGroups)
    exports.ox_inventory:RegisterShop(shopTitle, { name = shopTitle, inventory = shopInventory, groups = shopGroups })
    return true
end

---@description Adds a list of items to a vehicle trunk stash.
---@param identifier string
---@param items table
---@return boolean
function Sky.FW.AddTrunkItems(identifier, items)
    if type(items) ~= "table" then
        Sky.Debug("error", "[Sky.FW.AddTrunkItems] items is not a table for identifier: " .. tostring(identifier))
        return false
    end
    local id = "trunk" .. identifier
    Sky.FW.RegisterStash(id, identifier, 20, 10000, nil, nil, nil)
    Wait(100)
    local success = false
    for _, v in pairs(items) do
        success = exports.ox_inventory:AddItem(id, v.item, v.count or v.amount, v.metadata or v.info or {})
    end
    return success
end

---@description Updates the stored vehicle plate inside the inventory.
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    exports.ox_inventory:UpdateVehicle(oldplate, newplate)
    if GetResourceState("jg-mechanic") == "missing" then
        return true
    end
    return true, exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end
