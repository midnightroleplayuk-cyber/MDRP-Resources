---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "tgiann" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }

local stashes = {}

function Sky.FW.GetInventoryStats(source)
    local items = exports["tgiann-inventory"]:GetPlayerItems(source)
    local limits = exports["tgiann-inventory"]:GetPlayerInventoryData(source)
    if not items or not limits then
        Sky.Debug("error", "[inventory] TGIANN statistics unavailable: player %s inventory is not loaded", source)
        return nil, "unavailable"
    end
    local weight = exports["tgiann-inventory"]:GetTotalWeight(items)
    -- Slots are grid cells; counting item records would undercount larger items.
    return helpers.NormalizeInventoryStats(weight, limits.maxweight, nil, nil, 1000)
end

-- tgiann resolves item labels per source via its own export.
local function normalize_slot(item, fallbackSlot, source)
    return helpers.NormalizeSlotItem(item, fallbackSlot, {
        labelResolver = function(name) return exports["tgiann-inventory"]:GetItemLabel(name, source) end
    })
end

---@description Add an item to the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    return exports["tgiann-inventory"]:AddItem(source, item, amount, slot, helpers.NormalizeMetadata(metadata))
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

    if slot ~= nil then
        local removed = exports["tgiann-inventory"]:RemoveItem(source, item, amount, slot, metadata)
        if removed then
            return amount
        end
        return 0
    end

    if helpers.NormalizeMetadata(metadata) then
        local removedAmount = 0
        for _, inventoryItem in ipairs(Sky.FW.GetInventorySlotsWithItem(source, item, metadata)) do
            if removedAmount >= amount then
                break
            end

            local availableAmount = tonumber(inventoryItem.amount or inventoryItem.count) or 1
            local amountToRemove = math.min(amount - removedAmount, availableAmount)
            if amountToRemove > 0 then
                local removed = exports["tgiann-inventory"]:RemoveItem(source, item, amountToRemove, inventoryItem.slot, metadata)
                if removed then
                    removedAmount = removedAmount + amountToRemove
                end
            end
        end

        return removedAmount
    end

    local removed = exports["tgiann-inventory"]:RemoveItem(source, item, amount)
    if removed then
        return amount
    end
    return 0
end

---@description Check whether the player can carry the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return exports["tgiann-inventory"]:CanCarryItem(source, item, amount)
end

---@description Return whether the player has at least the given amount of an item.
---@param source number
---@param itemName string
---@param amount? number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, itemName, amount, metadata)
    amount = tonumber(amount) or 1
    if not helpers.NormalizeMetadata(metadata) then
        local provider_result = exports["tgiann-inventory"]:HasItem(source, itemName, amount)
        Sky.Debug("debug",
            "[inventory:tgiann] HasItem source=%s item=%s amount=%s providerResult=%s providerResultType=%s",
            tostring(source), tostring(itemName), tostring(amount), tostring(provider_result), type(provider_result))

        if not provider_result and Sky.IsDebugActive("debug") then
            local matching_slots = {}
            local normalized_name = type(itemName) == "string" and itemName:lower() or nil
            for index, inventory_item in pairs(exports["tgiann-inventory"]:GetPlayerItems(source) or {}) do
                if type(inventory_item) == "table"
                    and type(inventory_item.name) == "string"
                    and inventory_item.name:lower() == normalized_name then
                    matching_slots[#matching_slots + 1] = ("index=%s slot=%s name=%s amount=%s count=%s"):format(
                        tostring(index), tostring(inventory_item.slot), tostring(inventory_item.name),
                        tostring(inventory_item.amount), tostring(inventory_item.count))
                end
            end
            Sky.Debug("debug", "[inventory:tgiann] HasItem rejected item=%s; matchingSlots=%s",
                tostring(itemName), #matching_slots > 0 and table.concat(matching_slots, " | ") or "none")
        end

        return provider_result and true or false
    end
    local inventory_item = Sky.FW.GetInventoryItem(source, itemName, metadata)
    local found_amount = inventory_item and (tonumber(inventory_item.amount or inventory_item.count) or 0) or 0
    local has_item = inventory_item ~= nil and found_amount >= amount
    Sky.Debug("debug", "[inventory:tgiann] HasItem metadata source=%s item=%s amount=%s foundAmount=%s result=%s",
        tostring(source), tostring(itemName), tostring(amount), tostring(found_amount), tostring(has_item))
    return has_item
end

---@description Return the player's full inventory as a list of normalized items.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local items = {}
    for index, inventoryItem in pairs(exports["tgiann-inventory"]:GetPlayerItems(source) or {}) do
        local normalized = normalize_slot(inventoryItem, tonumber(inventoryItem and inventoryItem.slot) or tonumber(index) or index, source)
        if normalized then
            items[#items + 1] = normalized
        end
    end
    return items
end

---@description Return an aggregated item entry (total amount across slots) or nil.
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

---@description Return all inventory slots holding the item that match the metadata.
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
    for index, inventoryItem in pairs(exports["tgiann-inventory"]:GetPlayerItems(source) or {}) do
        if type(inventoryItem) == "table"
            and type(inventoryItem.name) == "string"
            and inventoryItem.name:lower() == normalizedName
            and helpers.MetadataMatches(inventoryItem.metadata or inventoryItem.info, metadata) then
            local normalized = normalize_slot(inventoryItem, index, source)
            if normalized then
                items[#items + 1] = normalized
            end
        end
    end
    return items
end

---@description Return the normalized item in the given slot or nil.
---@param source number
---@param slotId number
---@return table|nil
function Sky.FW.GetInventorySlot(source, slotId)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return nil
    end

    local itemData = exports["tgiann-inventory"]:GetItemBySlot(source, numericSlot)
    if itemData then
        return normalize_slot(itemData, numericSlot, source)
    end
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
    local slotItem = Sky.FW.GetInventorySlot(source, numericSlot)
    if not slotItem then
        Sky.Debug("debug", "[inventory] SetInventorySlotMetadata failed: no item in slot %s for source %s", numericSlot, tostring(source))
        return false
    end
    exports["tgiann-inventory"]:UpdateItemMetadata(source, slotItem.name, numericSlot, metadata or {})
    return true
end

---@description Return the inventory's full item definition list.
---@return table
function Sky.FW.GetItems()
    return exports["tgiann-inventory"]:GetItemList()
end

---@description Return the display label for an item name.
---@param itemName string
---@return string
function Sky.FW.GetItemLabel(itemName)
    return exports["tgiann-inventory"]:GetItemLabel(itemName) or itemName
end

---@description Return item definition info (name, label, stack, weight, description, image).
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local itemList = exports["tgiann-inventory"]:GetItemList()
    local itemData = itemList and itemList[item]
    if not itemData then
        return {}
    end
    return {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = (itemData.client and itemData.client.image) or itemData.image
    }
end

---@description Return the item in the given slot as a normalized table or nil.
---@param source number
---@param slot number
---@return table|nil
function Sky.FW.GetItemBySlot(source, slot)
    local item = exports["tgiann-inventory"]:GetItemBySlot(source, slot)
    if not item then
        return nil
    end
    return {
        name = item.name,
        label = helpers.ResolveItemLabel(item.label or item.name, item.info or item.metadata),
        weight = item.weight,
        slot = slot,
        count = item.amount or item.count,
        metadata = item.info or item.metadata or {}
    }
end

---@description Return the inventory resource name in use.
---@return string
function Sky.FW.GetResourceName()
    return "tgiann-inventory"
end

---@description Return whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return Sky.FW.CanCarryItem(source, weaponName, 1, metadata)
end

---@description Add a weapon item to the player's inventory.
---@param source number
---@param weaponName string
---@param ammo? number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local info = metadata or { quality = 100, ammo = ammo }
    return exports["tgiann-inventory"]:AddItem(source, weaponName, 1, nil, info)
end

---@description Remove a weapon item from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    if helpers.NormalizeMetadata(metadata) then
        return Sky.FW.RemoveItem(source, weaponName, 1, nil, metadata) == 1
    end
    return exports["tgiann-inventory"]:RemoveItem(source, weaponName, 1) == true
end

---@description Return the player's weapons as a list of normalized entries.
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

---@description Register a stash definition; returns success and the stash id.
---@param id string
---@param label string
---@param slots number
---@param weight number
---@param owner? string
---@param groups? table
---@param coords? vector3
---@return boolean, string
function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    if stashes[id] then
        return true, id
    end
    stashes[id] = { id = id, label = label, slots = slots, weight = weight, owner = owner, groups = groups, coords = coords }
    return true, id
end

---@description Open the given stash for the player.
---@param source number
---@param _type string
---@param id string
---@return boolean
function Sky.FW.OpenStash(source, _type, id)
    _type = _type or "stash"
    local tbl = stashes[id] or { weight = 1000000, slot = 50, label = "Stash" }
    return exports["tgiann-inventory"]:ForceOpenInventory(source, _type, id, { maxWeight = tbl.weight, slots = tbl.slot, label = tbl.label })
end

---@description Clear the given stash inventory.
---@param id string
---@param _type? string
---@return boolean
function Sky.FW.ClearStash(id, _type)
    if type(id) ~= "string" then
        Sky.Debug("error", "[Sky.FW.ClearStash] id must be a string, got: " .. type(id))
        return false
    end
    exports["tgiann-inventory"]:DeleteInventory(_type, id)
    if stashes[id] then
        stashes[id] = nil
    end
    return true
end

---@description Open a target player's inventory for the source player.
---@param source number
---@param target number
---@return boolean
function Sky.FW.OpenPlayerInventory(source, target)
    if not source or not target then
        Sky.Debug("error", "[Sky.FW.OpenPlayerInventory] source and target are required")
        return false
    end
    exports["tgiann-inventory"]:OpenInventoryById(source, target)
    return true
end

---@description Add a list of items to a vehicle trunk inventory.
---@param identifier string
---@param items table
---@return boolean
function Sky.FW.AddTrunkItems(identifier, items)
    if type(items) ~= "table" then
        Sky.Debug("error", "[Sky.FW.AddTrunkItems] items must be a table, got: " .. type(items))
        return false
    end
    for _, v in pairs(items) do
        exports["tgiann-inventory"]:AddItemToSecondaryInventory("trunk", identifier, v.item, v.count, nil, v.metadata)
    end
    return true
end

---@description Update the vehicle plate stored in trunk/glovebox inventories.
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    local queries = {
        "UPDATE tgiann_inventory_trunkitems SET plate = @newplate WHERE plate = @oldplate",
        "UPDATE tgiann_inventory_gloveboxitems SET plate = @newplate WHERE plate = @oldplate"
    }
    MySQL.transaction.await(queries, { newplate = newplate, oldplate = oldplate })
    exports["tgiann-inventory"]:UpdateVehicle(oldplate, newplate)
    if GetResourceState("jg-mechanic") == "missing" then
        return true
    end
    return true, exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end
