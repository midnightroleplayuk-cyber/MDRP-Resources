---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "origen" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }
local origin = exports.origen_inventory
local stashes = {}

function Sky.FW.GetInventoryStats(source)
    local weight = origin:GetTotalWeight(source)
    return helpers.NormalizeInventoryStats(weight, nil, nil, nil, 1000)
end

function Sky.FW.TakeVehicleInventoryItem(source, plate, compartment, netId, slot, name, amount)
    local items, code = Sky.FW.GetVehicleInventoryItems(plate, compartment, netId)
    if not items then return false, code end
    local id = compartment .. "_" .. plate:match("^%s*(.-)%s*$")
    return helpers.TakeVehicleSlot(source, items, slot, name, amount, function(item, count)
        return origin:removeItem(id, item.name, count, item.metadata, item.slot, false)
    end, function(item, count)
        return origin:addItem(id, item.name, count, item.metadata, item.slot, false)
    end)
end

function Sky.FW.GetVehicleInventoryItems(plate, compartment, _netId)
    if (compartment ~= "trunk" and compartment ~= "glovebox") or type(plate) ~= "string" or not plate:find("%S") then
        print("[sky_base] origen_inventory vehicle read rejected: invalid plate or compartment")
        return nil, "invalid_target"
    end
    -- Match this adapter's existing trunk_/glovebox_ identifiers. The getter must resolve
    -- the inventory before getItems; unavailable storage is not a negative search result.
    local id = compartment .. "_" .. plate:match("^%s*(.-)%s*$")
    if not origin:getInventory(id) then return nil, "unavailable" end
    return helpers.NormalizeStorageItems(origin:getItems(id))
end

---@description Add an item to a player's inventory; returns true on success.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    if not origin:canCarryItem(source, item, amount) then
        return false
    end
    local ok = origin:addItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot, false)
    return ok and true or false
end

---@description Remove an item from a player's inventory; returns the amount removed (0 on failure).
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if slot then
        local ok = origin:removeItem(source, item, amount, nil, slot, false)
        return ok and amount or 0
    end
    if helpers.NormalizeMetadata(metadata) then
        for _, inventoryItem in ipairs(Sky.FW.GetInventoryItems(source)) do
            if inventoryItem.name == item and inventoryItem.slot and helpers.MetadataMatches(inventoryItem.metadata, metadata) then
                slot = inventoryItem.slot
                break
            end
        end
        if not slot then return 0 end
        local ok = origin:removeItem(source, item, amount, nil, slot, false)
        return ok and amount or 0
    end
    local ok = origin:removeItem(source, item, amount, nil, nil, false)
    return ok and amount or 0
end

---@description Check whether a player can carry the given item amount.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return origin:canCarryItem(source, item, amount)
end

---@description Check whether a player has at least the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, item, amount, metadata)
    amount = tonumber(amount) or 1
    return (tonumber(origin:getItemCount(source, item, helpers.NormalizeMetadata(metadata), false)) or 0) >= amount
end

---@description Return the player's inventory as a normalized item list.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local inventory = origin:GetInventory(source)
    local list = (type(inventory) == "table" and inventory.inventory) or {}
    local items = {}
    for index, item in pairs(list) do
        if item and item.slot then
            local normalized = helpers.NormalizeSlotItem({
                name = item.name,
                amount = item.amount or item.count,
                label = item.label,
                metadata = item.metadata or item.info,
                slot = item.slot
            }, tonumber(item.slot) or index)
            if normalized then
                items[#items + 1] = normalized
            end
        end
    end
    return items
end

---@description Return a single normalized inventory item entry, or nil if absent.
---@param source number
---@param item string
---@param metadata? table
---@return table|nil
function Sky.FW.GetInventoryItem(source, item, metadata)
    local count = tonumber(origin:getItemCount(source, item, helpers.NormalizeMetadata(metadata), false)) or 0
    if count <= 0 then
        return nil
    end
    local result = { name = item, label = Sky.FW.GetItemLabel(item, metadata), amount = count, count = count }
    local normalizedMetadata = helpers.NormalizeMetadata(metadata)
    if normalizedMetadata then
        result.metadata = normalizedMetadata
    end
    return result
end

---@description Set metadata on a specific inventory slot; returns true on success.
---@param source number
---@param slotId number
---@param metadata table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then return false end
    origin:setMetadata(source, numericSlot, metadata or {})
    return true
end

---@description Return the full items table from the inventory resource.
---@return table
function Sky.FW.GetItems()
    return origin:Items()
end

---@description Return the display label for an item, falling back to its name.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    local data = origin:Items(item)
    if type(data) == "table" and type(data.label) == "string" then
        return data.label
    end
    return item
end

---@description Return the inventory resource name in use.
---@return string
function Sky.FW.GetResourceName()
    return "origen_inventory"
end

---@description Check whether a player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return origin:canCarryItem(source, weaponName, 1)
end

---@description Give a weapon to a player; returns true on success.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    return Sky.FW.AddItem(source, weaponName, 1, nil, metadata or { quality = 100, ammo = ammo })
end

---@description Remove a weapon from a player; returns true on success.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return Sky.FW.RemoveItem(source, weaponName, 1, nil, metadata) > 0
end

-- Stash / shop / trunk / plate helpers
---@description Register a stash with the inventory resource.
---@param id string|number
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? table
---@return boolean
---@return string|number
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then return true, id end
    stashes[id] = { id = id, label = label or id, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    origin:registerStash(id, label, slots, weight, owner, groups, coords)
    return true, id
end

---@description Open a stash/trunk/glovebox for the player.
---@param source number
---@param _type string "stash", "trunk", "glovebox"
---@param id string|number
---@return boolean
function Sky.FW.OpenStash(source, _type, id)
    origin:OpenInventory(source, _type or "stash", id)
    return true
end

---@description Clear all items from the specified stash/trunk/glovebox.
---@param id string
---@param _type string "stash", "trunk", "glovebox"
---@return boolean
function Sky.FW.ClearStash(id, _type)
    if type(id) ~= "string" then return false end
    if stashes[id] then stashes[id] = nil end
    if _type == "trunk" then
        id = "trunk_" .. id
    elseif _type == "glovebox" then
        id = "glovebox_" .. id
    elseif _type == "stash" then
        id = "stash_" .. id
    end
    local inventory = origin:getInventory(id, _type)
    if type(inventory) ~= "table" or not inventory.inventory then return false end
    for _, v in pairs(inventory.inventory) do
        if v.slot then
            origin:removeItem(id, v.name, v.amount, nil, v.slot)
        end
    end
    return true
end

---@description Open another player's inventory for the source player.
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    origin:OpenInventory(source, "otherplayer", target)
    return true
end

---@description Add a batch of items to a vehicle trunk stash.
---@param identifier string
---@param items table
---@return boolean
function Sky.FW.AddTrunkItems(identifier, items)
    if type(items) ~= "table" then return false end
    local id = "trunk_" .. identifier
    Sky.FW.RegisterStash(id, identifier, 20, 10000, nil, nil, nil)
    local repacked = {}
    for _, v in pairs(items) do
        repacked[#repacked + 1] = { name = v.item or v.name, amount = v.count or v.amount, metadata = v.metadata or v.info or {} }
    end
    if #repacked == 0 then return false end
    origin:addItems(id, repacked)
    return true
end

---@description Update the stored vehicle plate across trunk/glovebox inventories.
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
