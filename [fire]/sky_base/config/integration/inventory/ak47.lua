---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "ak47" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }
local ak47 = exports["ak47_inventory"]
local stashes = {}

---@description Add an item to the player's inventory (optionally at a slot / with metadata).
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    return ak47:AddItem(source, item, amount, slot, helpers.NormalizeMetadata(metadata))
end

---@description Remove an item from the player's inventory by slot, metadata match, or plain removal.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if slot then
        local ok = ak47:RemoveItem(source, item, amount, slot)
        if ok == false then return 0 end
        return amount
    end

    local info = helpers.NormalizeMetadata(metadata)
    if info then
        local identifier = Sky.FW.GetIdentifier(source)
        local removed = 0
        for _, foundSlot in pairs(ak47:GetSlotsWithItem(identifier, item, info, true) or {}) do
            if removed >= amount then break end
            local slotId = tonumber(foundSlot.slot or foundSlot.id)
            local available = tonumber(foundSlot.amount or foundSlot.count) or 0
            local toRemove = math.min(amount - removed, available)
            if slotId and toRemove > 0 and ak47:RemoveItem(source, item, toRemove, slotId) then
                removed = removed + toRemove
            end
        end
        return removed
    end

    local ok = ak47:RemoveItem(source, item, amount)
    if ok == false then return 0 end
    return amount
end

---@description Check whether the player can carry the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return ak47:CanAddItem(source, item, amount)
end

---@description Check whether the player has at least the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, item, amount, metadata)
    amount = tonumber(amount) or 1
    local identifier = Sky.FW.GetIdentifier(source)
    local info = helpers.NormalizeMetadata(metadata)
    return (tonumber(ak47:GetAmount(identifier, item, info, info ~= nil)) or 0) >= amount
end

---@description Return all normalized items in the player's inventory.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local identifier = Sky.FW.GetIdentifier(source)
    if not identifier then
        print(("[inventory/ak47] GetInventoryItems failed for source %s: player identifier is invalid"):format(tostring(source)))
        return {}
    end

    local items = {}
    for index, item in pairs(ak47:GetInventoryItems(identifier) or {}) do
        local normalized = helpers.NormalizeSlotItem(item, tonumber(item and item.slot) or tonumber(index) or index)
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Return a single normalized inventory item, or nil if absent.
---@param source number
---@param item string
---@param metadata? table
---@return table|nil
function Sky.FW.GetInventoryItem(source, item, metadata)
    local identifier = Sky.FW.GetIdentifier(source)
    local info = helpers.NormalizeMetadata(metadata)
    local data = ak47:GetItem(identifier, item, info, info ~= nil)
    if type(data) ~= "table" then return nil end

    local amount = tonumber(data.amount or data.count) or 0
    if amount <= 0 then return nil end

    local result = {
        name = data.name or item,
        label = helpers.ResolveItemLabel(data.label or item, data.info or data.metadata),
        amount = amount,
        count = amount
    }
    local resolvedMetadata = helpers.NormalizeMetadata(data.info or data.metadata)
    if resolvedMetadata then
        result.metadata = resolvedMetadata
    end
    return result
end

---@description Return all normalized slots holding the given item.
---@param source number
---@param itemName string
---@param metadata? table
---@return table
function Sky.FW.GetInventorySlotsWithItem(source, itemName, metadata)
    local identifier = Sky.FW.GetIdentifier(source)
    local info = helpers.NormalizeMetadata(metadata)
    local items = {}
    for index, slot in pairs(ak47:GetSlotsWithItem(identifier, itemName, info, info ~= nil) or {}) do
        local normalized = helpers.NormalizeSlotItem(slot, tonumber(slot and slot.slot) or tonumber(index) or index)
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Return the normalized item in a specific inventory slot, or nil.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then return nil end
    local identifier = Sky.FW.GetIdentifier(source)
    return helpers.NormalizeSlotItem(ak47:GetSlot(identifier, numericSlot), numericSlot)
end

---@description Set the metadata of a specific inventory slot.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then return false end
    ak47:SetItemInfo(Sky.FW.GetIdentifier(source), numericSlot, metadata or {})
    return true
end

---@description Return the inventory resource's item definitions table.
---@return table
function Sky.FW.GetItems()
    return ak47:Items()
end

---@description Return the display label for an item name.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    return ak47:GetItemLabel(item) or item
end

---@description Return the underlying inventory resource name.
---@return string
function Sky.FW.GetResourceName()
    return "ak47_inventory"
end

---@description Check whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return ak47:CanAddItem(source, weaponName, 1)
end

---@description Add a weapon to the player's inventory.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local info = metadata or { ammo = ammo }
    return ak47:AddItem(source, weaponName, 1, nil, info)
end

---@description Remove a weapon from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return ak47:RemoveItem(source, weaponName, 1) == true
end

---@description Propagate a vehicle plate change to the inventory resource.
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    ak47:OnChangeVehiclePlate(oldplate, newplate)
    return true
end

---@description Creates a programmatic stash through AK47 Inventory's inventory API.
---@param id number|string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? table
---@param properties? table
---@return boolean, string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords, properties)
    id = tostring(id)
    if stashes[id] then
        return true, id
    end

    local options = {
        label = label or id,
        maxWeight = weight,
        slots = slots,
        type = "stash",
    }
    if type(properties) == "table" then
        options.whitelist = properties.whitelist
        options.blacklist = properties.blacklist
    end

    ak47:CreateInventory(id, options)
    if options.whitelist then
        ak47:SetWhitelistedItemsForContainer(id, options.whitelist)
    end
    if options.blacklist then
        ak47:SetBlacklistedItemsForContainer(id, options.blacklist)
    end
    stashes[id] = true
    return true, id
end

---@description Opens a registered AK47 Inventory stash for a player.
---@param source number
---@param _type string
---@param id string
---@return boolean
function Sky.FW.OpenStash(source, _type, id)
    ak47:OpenInventory(source, tostring(id))
    return true
end
