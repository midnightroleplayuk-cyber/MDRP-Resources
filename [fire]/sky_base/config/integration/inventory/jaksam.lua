---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "jaksam" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }
local stashes = {}

function Sky.FW.GetResourceName()
    return "jaksam_inventory"
end

function Sky.FW.GetInventoryStats(source)
    local inventory = exports["jaksam_inventory"]:getInventory(source)
    if not inventory then
        Sky.Debug("error", "[inventory] Jaksam statistics unavailable: player %s inventory is not loaded", source)
        return nil, "unavailable"
    end
    return helpers.NormalizeInventoryStats(inventory.totalWeight, inventory.limits.maxWeight,
        helpers.CountOccupiedSlots(inventory.items), inventory.limits.maxSlots, 1)
end

local function list_to_set(items)
    local set = {}
    for _, item_name in ipairs(items or {}) do
        set[item_name] = true
    end
    return set
end

local function get_inventory_items(source)
    local inventory = exports["jaksam_inventory"]:getInventory(source)
    if type(inventory) == "table" and type(inventory.items) == "table" then
        local items = {}
        for slot_key, item in pairs(inventory.items) do
            local slot = tonumber(slot_key) or tonumber(tostring(slot_key):match("^SLOT%-(%d+)$"))
            if slot then
                items[slot] = item
            else
                Sky.Debug("error", ("[inventory] Invalid Jaksam slot '%s' for player %s"):format(tostring(slot_key), source))
            end
        end
        return items
    end
    return {}
end

---@description Add an item to the player's inventory; returns success.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    local success, _ = exports["jaksam_inventory"]:addItem(source, item, amount, metadata, slot)
    return success == true
end

---@description Remove an item from the player's inventory; returns the amount removed (0 on failure).
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    local expectedMetadata = helpers.NormalizeMetadata(metadata)
    if slot == nil and expectedMetadata then
        local _, matched_slot = exports["jaksam_inventory"]:getItemByName(source, item, expectedMetadata)
        slot = matched_slot
        if slot == nil then
            return 0
        end
    end

    local success, result_code, notification_type = exports["jaksam_inventory"]:removeItem(source, item, amount, nil, slot)
    if success then
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
    return exports["jaksam_inventory"]:canCarryItem(source, item, amount)
end

---@description Return whether the player has at least the given amount of the item.
---@param source number
---@param itemName string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, itemName, amount, metadata)
    return exports['jaksam_inventory']:hasItem(source, itemName, amount)
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

---@description Return aggregated data for a single item, or nil if the player has none.
---@param source number
---@param itemName string
---@param metadata? table
---@return table|nil
function Sky.FW.GetInventoryItem(source, itemName, metadata)
    local playerItem = exports["jaksam_inventory"]:getItemByName(source, itemName, metadata)
    if not playerItem then
        return nil
    end
    local itemAmount = exports["jaksam_inventory"]:getTotalItemAmount(source, itemName, metadata) or playerItem.amount or 0
    local result = {
        name = playerItem.name,
        label = playerItem.label or playerItem.name,
        amount = itemAmount,
        count = itemAmount
    }
    local metadataValue = helpers.NormalizeMetadata(playerItem.metadata or playerItem.info)
    if metadataValue then
        result.metadata = metadataValue
    end
    return result
end

---@description Return the normalized slots holding the named item (filtered by metadata).
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

---@description Return the normalized item at the given inventory slot, or nil.
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

---@description Update the metadata of the item in the given slot without moving it.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end

    local success, _ = exports['jaksam_inventory']:setItemMetadataInSlot(source, numericSlot, metadata)
    if success then
        return true
    end
    return false
end

---@description Return the shared item catalog.
---@return table
function Sky.FW.GetItems()
    return exports["jaksam_inventory"]:getStaticItemsList()
end

---@description Return whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    local uppercase_weapon_name = string.upper(weaponName)
    if Sky.Config.framework == "esx" then
        local x_player = ESX.GetPlayerFromId(source)
        if not x_player then
            Sky.Debug("error", "[Sky.FW.CanCarryWeapon] Jaksam ESX player not found (source=%s)", tostring(source))
            return false
        end
        return not x_player.hasWeapon(uppercase_weapon_name)
    end
    return exports["jaksam_inventory"]:canCarryItem(source, uppercase_weapon_name, 1)
end

---@description Add a weapon through Jaksam's ESX compatibility hook or inventory export; returns success.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local uppercase_weapon_name = string.upper(weaponName)
    if Sky.Config.framework == "esx" then
        local x_player = ESX.GetPlayerFromId(source)
        if not x_player then
            Sky.Debug("error", "[Sky.FW.AddWeapon] Jaksam ESX player not found (source=%s)", tostring(source))
            return false
        end
        if x_player.hasWeapon(uppercase_weapon_name) then
            return false
        end
        x_player.addWeapon(uppercase_weapon_name, ammo)
        return x_player.hasWeapon(uppercase_weapon_name)
    end
    return Sky.FW.AddItem(source, uppercase_weapon_name, 1, nil, metadata or { ammo = ammo }) == true
end

---@description Remove a weapon through Jaksam's ESX compatibility hook or inventory export; returns success.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    local uppercase_weapon_name = string.upper(weaponName)
    if Sky.Config.framework == "esx" then
        local x_player = ESX.GetPlayerFromId(source)
        if not x_player then
            Sky.Debug("error", "[Sky.FW.RemoveWeapon] Jaksam ESX player not found (source=%s)", tostring(source))
            return false
        end
        if not x_player.hasWeapon(uppercase_weapon_name) then
            return false
        end
        x_player.removeWeapon(uppercase_weapon_name)
        return not x_player.hasWeapon(uppercase_weapon_name)
    end
    return Sky.FW.RemoveItem(source, uppercase_weapon_name, 1, nil, metadata) > 0
end

---@description Registers an ESX usable item callback.
---@param name string
---@param callback function|nil
---@return boolean
function Sky.FW.RegisterUsableItem(name, callback)
    exports['jaksam_inventory']:registerUsableItem(name, callback)
    return true
end

---@description Registers a programmatic stash through Jaksam's runtime stash API.
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
        id = id,
        label = label or id,
        maxSlots = slots,
        maxWeight = weight,
        runtimeOnly = coords == nil,
    }
    if coords then
        options.coords = coords
    end
    if owner then
        options.isPrivate = true
    end
    if type(groups) == "table" then
        options.allowedJobs = groups
    end
    if type(properties) == "table" then
        if properties.whitelist then
            options.whitelist = list_to_set(properties.whitelist)
        end
        if properties.blacklist then
            options.blacklist = list_to_set(properties.blacklist)
        end
    end

    local registered_id = exports["jaksam_inventory"]:registerStash(options)
    if type(registered_id) ~= "string" then
        Sky.Debug("warn", "[inventory/jaksam] registerStash failed for '%s'", id)
        return false
    end

    stashes[id] = registered_id
    return true, registered_id
end

---@description Opens a registered Jaksam stash for a player.
---@param source number
---@param _type string
---@param id string
---@return boolean
function Sky.FW.OpenStash(source, _type, id)
    local stash_id = stashes[tostring(id)] or tostring(id)
    exports["jaksam_inventory"]:forceOpenInventory(source, stash_id)
    return true
end
