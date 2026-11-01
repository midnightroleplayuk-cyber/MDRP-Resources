---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "jpr" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }
local jpr = exports["jpr-inventory"]
local stashes = {}

---@description Adds an item to the player inventory; returns success.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    local ok = jpr:AddItem(source, item, amount, slot, helpers.NormalizeMetadata(metadata), "sky_base:AddItem")
    return ok and true or false
end

---@description Removes an item from the player inventory; returns the amount removed (0 on failure).
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
    local ok = jpr:RemoveItem(source, item, amount, slot, "sky_base:RemoveItem")
    return ok and amount or 0
end

-- jpr-inventory exposes no carry-weight check; AddItem is the effective gate.
---@description jpr-inventory exposes no carry-weight check; always true (AddItem is the effective gate).
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
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, item, amount, metadata)
    return jpr:HasItem(source, item, tonumber(amount) or 1) == true
end

---@description Returns the player's full inventory as a normalized slot-item list.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then
        print(("[inventory/jpr] GetInventoryItems failed for source %s: QB player not found"):format(tostring(source)))
        return {}
    end

    local items = {}
    for index, item in pairs(xPlayer.PlayerData.items or {}) do
        local normalized = helpers.NormalizeSlotItem({
            name = item.name,
            amount = item.amount or item.count,
            label = item.label,
            metadata = item.info or item.metadata,
            slot = item.slot
        }, tonumber(item.slot) or index)
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Returns the normalized item at the given inventory slot, or nil.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then return nil end
    local slotData = jpr:GetItemBySlot(source, numericSlot)
    if not slotData then return nil end
    return helpers.NormalizeSlotItem({
        name = slotData.name,
        label = slotData.label,
        amount = slotData.amount or slotData.count,
        metadata = slotData.info or slotData.metadata,
        slot = numericSlot
    }, numericSlot)
end

---@description Set the metadata of the item in the given slot (jpr-inventory has no direct setter; re-adds the slot's stack with the new metadata).
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
    if not jpr:RemoveItem(source, slotItem.name, amount, numericSlot, "sky_base:SetInventorySlotMetadata") then
        return false
    end
    local ok = jpr:AddItem(source, slotItem.name, amount, numericSlot, helpers.NormalizeMetadata(metadata), "sky_base:SetInventorySlotMetadata")
    return ok and true or false
end

-- jpr-inventory is QBCore-based: the catalog comes from QBCore.Shared.Items and the per-player
-- inventory is read from the QB player items (jpr exposes no whole-inventory export).
---@description Returns the shared item catalog (QBCore.Shared.Items).
---@return table
function Sky.FW.GetItems()
    return QBCore.Shared.Items
end

---@description Returns the display label for an item, falling back to its name.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    local shared = QBCore.Shared.Items[item]
    return shared and shared.label or item
end

-- Stash / shop / trunk / plate helpers
---@description Returns the item data at the given slot as a normalized table (empty table if none).
---@param source number
---@param slot number
---@return table
function Sky.FW.GetItemBySlot(source, slot)
    local slotData = jpr:GetItemBySlot(source, slot)
    if not slotData then return {} end
    return {
        name = slotData.name,
        label = helpers.ResolveItemLabel(slotData.label or slotData.name, slotData.info or slotData.metadata),
        weight = slotData.weight,
        slot = slot,
        count = slotData.amount or slotData.count,
        metadata = slotData.info or slotData.metadata
    }
end

---@description Returns the inventory resource name in use.
---@return string
function Sky.FW.GetResourceName()
    return "jpr-inventory"
end

---@description Returns whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return Sky.FW.CanCarryItem(source, weaponName, 1, metadata)
end

---@description Adds a weapon (as a single item) to the player inventory; returns success.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    return Sky.FW.AddItem(source, weaponName, 1, nil, metadata or { quality = 100, ammo = ammo })
end

---@description Removes a weapon (as a single item) from the player inventory; returns success.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return Sky.FW.RemoveItem(source, weaponName, 1, nil, metadata) > 0
end

---@description Registers a stash definition (tracked locally); returns success and the stash id.
---@param id string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? table
---@return boolean, string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then return true, id end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Opens the target player's inventory for the given source; returns success.
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    local identifier = Sky.FW.GetIdentifier(target)
    if not identifier then return false end
    jpr:OpenInventory(source, identifier)
    return true
end

---@description Opens the named shop for the given source; returns success.
---@param source number
---@param shopTitle string
---@return boolean
function Sky.FW.OpenShop(source, shopTitle)
    jpr:OpenShop(source, shopTitle)
    return true
end

---@description Registers a shop with the given inventory and coords; returns success.
---@param shopTitle string
---@param shopInventory table
---@param shopCoords table
---@param shopGroups? table
---@return boolean
function Sky.FW.RegisterShop(shopTitle, shopInventory, shopCoords, shopGroups)
    if not shopTitle or not shopInventory or not shopCoords then return false end
    local items = {}
    for slot, entry in pairs(shopInventory) do
        items[#items + 1] = {
            name = entry.name,
            price = entry.price or 1000,
            amount = entry.count or entry.amount or 1,
            slot = slot
        }
    end
    jpr:CreateShop({ name = shopTitle, label = shopTitle, coords = shopCoords, items = items, slots = #shopInventory })
    return true
end

---@description Updates the vehicle plate stored in glovebox/trunk inventories (and jg-mechanic if present); returns success.
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    MySQL.transaction.await({
        "UPDATE gloveboxitems SET plate = @newplate WHERE plate = @oldplate",
        "UPDATE trunkitems SET plate = @newplate WHERE plate = @oldplate"
    }, { newplate = newplate, oldplate = oldplate })
    if GetResourceState("jg-mechanic") ~= "missing" then
        exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    end
    return true
end
