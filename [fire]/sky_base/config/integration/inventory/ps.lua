---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "ps" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }

-- Stash / shop / trunk / plate helpers
local stashes = {}

function Sky.FW.GetInventoryStats(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then
        Sky.Debug("error", "[inventory] PS statistics unavailable: player %s is not loaded", source)
        return nil, "unavailable"
    end
    local weight = exports["ps-inventory"]:GetTotalWeight(player.PlayerData.items)
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
    return exports["ps-inventory"]:AddItem(source, item, amount, slot, helpers.NormalizeMetadata(metadata))
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
        for _, inventoryItem in pairs(Sky.FW.GetInventoryItems(source) or {}) do
            if inventoryItem and inventoryItem.name == item and helpers.MetadataMatches(inventoryItem.metadata, metadata) then
                slot = inventoryItem.slot
                break
            end
        end
    end
    local removed = slot and exports["ps-inventory"]:RemoveItem(source, item, amount, slot)
        or exports["ps-inventory"]:RemoveItem(source, item, amount)
    if removed then
        return amount
    end
    return 0
end

---@description Returns inventory slots that hold the named item matching the given metadata.
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
    for index, inventoryItem in pairs(Sky.FW.GetInventoryItems(source) or {}) do
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

---@description Returns the normalized inventory item occupying the given slot.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return nil
    end

    for index, inventoryItem in pairs(Sky.FW.GetInventoryItems(source) or {}) do
        local itemSlot = tonumber(inventoryItem and inventoryItem.slot) or tonumber(index)
        if itemSlot == numericSlot then
            return helpers.NormalizeSlotItem(inventoryItem, itemSlot)
        end
    end
    return nil
end

---@description Set the metadata of the item in the given slot (ps-inventory has no direct setter; re-adds the slot's stack with the new metadata).
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end
    local slotItem = Sky.FW.GetInventorySlot(source, numericSlot)
    if not slotItem then
        Sky.Debug("debug", "[inventory] SetInventorySlotMetadata failed: no item in slot %s for source %s", numericSlot, tostring(source))
        return false
    end
    local amount = tonumber(slotItem.amount or slotItem.count) or 1
    if not exports["ps-inventory"]:RemoveItem(source, slotItem.name, amount, numericSlot) then
        return false
    end
    return exports["ps-inventory"]:AddItem(source, slotItem.name, amount, numericSlot, helpers.NormalizeMetadata(metadata)) and true or false
end

---@description Returns shared item info {name, label, stack, weight, description, image}.
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local itemData = QBCore.Shared.Items[item]
    if not itemData then return {} end
    return {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.stack or "true",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = (itemData.client and itemData.client.image) or itemData.image
    }
end

---@description Returns the item occupying the given slot for the player.
---@param source number
---@param slot number
---@return table
function Sky.FW.GetItemBySlot(source, slot)
    local item = exports["ps-inventory"]:GetItemBySlot(source, slot)
    if not item then return {} end
    return {
        name = item.name,
        label = helpers.ResolveItemLabel(item.label or item.name, item.info),
        weight = item.weight,
        slot = slot,
        count = item.amount,
        metadata = item.info
    }
end

---@description Returns the name of the inventory resource in use.
---@return string
function Sky.FW.GetResourceName()
    return "ps-inventory"
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
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local info = helpers.NormalizeMetadata(metadata) or { ammo = ammo }
    return exports["ps-inventory"]:AddItem(source, weaponName, 1, nil, info)
end

---@description Removes a weapon from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    local slot = nil
    if helpers.NormalizeMetadata(metadata) then
        for _, inventoryItem in pairs(Sky.FW.GetInventorySlotsWithItem(source, weaponName, metadata) or {}) do
            slot = inventoryItem.slot
            break
        end
    end
    if slot then
        return exports["ps-inventory"]:RemoveItem(source, weaponName, 1, slot) == true
    end
    return exports["ps-inventory"]:RemoveItem(source, weaponName, 1) == true
end

---@description Registers a stash definition under the given id.
---@param id string
---@param label string
---@param slots number
---@param weight number
---@param owner string|nil
---@param groups table|nil
---@param coords table|nil
---@return boolean, string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then return true, id end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Opens the specified stash for the player.
---@param source number
---@param _type string
---@param id string
---@return nil
function Sky.FW.OpenStash(source, _type, id)
    _type = _type or "stash"
    exports["ps-inventory"]:OpenInventory(_type, id, nil, source)
end

---@description Opens a target player's inventory for the given source (admin use).
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    if not source then
        Sky.Debug("error", "[inventory] OpenPlayerInventory: source is required")
        return false
    end
    if not target then
        Sky.Debug("error", "[inventory] OpenPlayerInventory: target is required")
        return false
    end
    exports["ps-inventory"]:OpenInventoryById(source, target)
    return true
end

---@description Opens the named shop for the player.
---@param source number
---@param shopTitle string
---@return boolean
function Sky.FW.OpenShop(source, shopTitle)
    return exports["ps-inventory"]:OpenShop(source, shopTitle)
end

---@description Registers a shop from the given inventory definition.
---@param shopTitle string
---@param shopInventory table
---@param shopCoords table
---@param shopGroups table
---@return boolean
function Sky.FW.RegisterShop(shopTitle, shopInventory, shopCoords, shopGroups)
    if not shopTitle then
        Sky.Debug("error", "[inventory] RegisterShop: shopTitle is required")
        return false
    end
    if not shopInventory then
        Sky.Debug("error", "[inventory] RegisterShop: shopInventory is required")
        return false
    end
    if not shopCoords then
        Sky.Debug("error", "[inventory] RegisterShop: shopCoords is required")
        return false
    end
    if not shopGroups then
        Sky.Debug("error", "[inventory] RegisterShop: shopGroups is required")
        return false
    end

    local repackItems = {}
    for slot, entry in pairs(shopInventory) do
        repackItems[#repackItems + 1] = {
            name = entry.name,
            price = entry.price or 1000,
            amount = entry.amount or entry.count or 1,
            slot = slot
        }
    end
    local repackedShopItems = {
        name = shopTitle,
        label = shopTitle,
        coords = shopCoords,
        items = repackItems,
        slots = #shopInventory
    }

    exports["ps-inventory"]:CreateShop(repackedShopItems)
    return true
end

---@description Updates a vehicle plate across glovebox/trunk storage (and jg-mechanic if present).
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    local queries = {
        "UPDATE gloveboxitems SET plate = @newplate WHERE plate = @oldplate",
        "UPDATE trunkitems SET plate = @newplate WHERE plate = @oldplate"
    }
    local values = { newplate = newplate, oldplate = oldplate }
    MySQL.transaction.await(queries, values)
    if GetResourceState("jg-mechanic") == "missing" then return true end
    return true, exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end
