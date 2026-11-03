---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "core" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }
local core = exports.core_inventory
local stashes = {}

---@description Add an item to the player's inventory; returns true on success.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    local ok = core:addItem(source, item, amount, helpers.NormalizeMetadata(metadata))
    return ok and true or false
end

---@description Remove an item from the player's inventory; returns the amount removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if slot then
        return core:removeItemExact(source, slot, amount) and amount or 0
    end
    if helpers.NormalizeMetadata(metadata) then
        for _, inventoryItem in ipairs(Sky.FW.GetInventoryItems(source)) do
            if inventoryItem.name == item and inventoryItem.slot and helpers.MetadataMatches(inventoryItem.metadata, metadata) then
                return core:removeItemExact(source, inventoryItem.slot, amount) and amount or 0
            end
        end
        return 0
    end
    core:removeItem(source, item, amount)
    return amount
end

-- core_inventory exposes no carry-weight check; AddItem is the effective gate.
---@description Check whether the player can carry the item; core_inventory has no weight gate.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return true
end

---@description Return the player's inventory items as a normalized slot list.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local items = {}
    for index, item in pairs(core:getInventory(source) or {}) do
        local stacked = (item.metadata or item.info) and (tonumber(item.count or item.amount) or 0) > 1
        if stacked then
            for _, expanded in pairs(core:getItems(source, item.name) or {}) do
                local normalized = helpers.NormalizeSlotItem({
                    name = item.name,
                    count = expanded.count or expanded.amount,
                    label = expanded.label,
                    metadata = expanded.metadata or expanded.info,
                    slot = expanded.id or expanded.slot
                }, tonumber(expanded.id or expanded.slot) or index, { amountOrder = "count_first" })
                if normalized then items[#items + 1] = normalized end
            end
        else
            local normalized = helpers.NormalizeSlotItem({
                name = item.name,
                count = item.count or item.amount,
                label = item.label,
                metadata = item.metadata or item.info,
                slot = item.id or item.slot
            }, tonumber(item.id or item.slot) or index, { amountOrder = "count_first" })
            if normalized then items[#items + 1] = normalized end
        end
    end
    return items
end

---@description Set the metadata of a specific inventory slot.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then return false end
    core:setMetadata(source, numericSlot, metadata or {})
    return true
end

---@description Return the inventory's full items list.
---@return table
function Sky.FW.GetItems()
    return core:getItemsList()
end

---@description Return the localized label for an item, falling back to the item name.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    local items = Sky.FW.GetItems()
    if type(items) == "table" then
        local data = items[item] or items[type(item) == "string" and item:lower() or item]
        if type(data) == "table" and type(data.label) == "string" then
            return data.label
        end
    end
    return item
end

---@description Return the inventory resource name.
---@return string
function Sky.FW.GetResourceName()
    return "core_inventory"
end

---@description Check whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return Sky.FW.CanCarryItem(source, weaponName, 1, metadata)
end

---@description Add a weapon to the player's inventory; returns true on success.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    return Sky.FW.AddItem(source, weaponName, 1, nil, metadata or { quality = 100, ammo = ammo })
end

---@description Remove a weapon from the player's inventory; returns true if removed.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return Sky.FW.RemoveItem(source, weaponName, 1, nil, metadata) > 0
end

-- Stash / shop / trunk / plate helpers
---@description Register a stash definition for later opening.
---@param id number|string
---@param label string
---@param slots number
---@param weight number
---@param owner string
---@param groups table
---@param coords table
---@return boolean
---@return number|string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then return true, id end
    stashes[id] = { id = id, label = label, slots = slots or 30, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Open a previously registered stash for the player.
---@param source number
---@param _type string
---@param id number|string
---@return boolean
function Sky.FW.OpenStash(source, _type, id)
    local stash = stashes[id]
    if not stash then
        Sky.Debug("debug", "[inventory/core] OpenStash: stash '%s' is not registered", tostring(id))
        return false
    end
    core:openInventory(source, id, _type or "stash", stash.slots or 30, stash.weight or 50000, true, nil, false)
    return true
end

---@description Open a target player's inventory as a stash for the source player.
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    local identifier = Sky.FW.GetIdentifier(target)
    if not identifier then return false end
    core:openInventory(source, "stash-" .. identifier:gsub(":", ""), "stash", nil, nil, true, nil, false)
    return true
end

---@description Update vehicle plate references across the inventory tables.
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    MySQL.transaction.await({
        "UPDATE coreinventories SET name = @newplate WHERE name = @oldplate",
        "UPDATE coreinventories SET name = @newplate WHERE name = @glovebox",
        "UPDATE coreinventories SET name = @newplate WHERE name = @trunk"
    }, {
        newplate = newplate,
        oldplate = oldplate,
        glovebox = "glovebox-" .. oldplate,
        trunk = "trunk-" .. oldplate
    })
    if GetResourceState("jg-mechanic") ~= "missing" then
        exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    end
    return true
end
