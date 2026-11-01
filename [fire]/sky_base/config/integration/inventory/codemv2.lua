---@diagnostic disable: duplicate-set-field
-- CodeM Supreme Inventory V2. Keep this separate from the V1 and ox adapters:
-- https://codem.gitbook.io/codem-documentation/supreme-series/essentials/inventory-aio/developers/server-exports
if Sky.Config.inventory ~= "codemv2" then return end

if not IsDuplicityVersion() then
    AddEventHandler("codem-inventoryv2:client:loaded", function()
        TriggerEvent("sky_base:inventoryUpdated")
    end)
    AddEventHandler("ox_inventory:itemCount", function()
        TriggerEvent("sky_base:inventoryUpdated")
    end)
    return
end

local helpers = SkyInventoryHelpers
local registered_stashes = {}
Sky.FW.InventoryCapabilities = { itemMetadata = true }

function Sky.FW.GetInventoryStats(source)
    local inventory = exports["codem-inventoryv2"]:GetInventory(source)
    if not inventory then
        Sky.Debug("error", "[inventory] CodeM V2 statistics unavailable: player %s inventory is not loaded", source)
        return nil, "unavailable"
    end
    return helpers.NormalizeInventoryStats(inventory.weight, inventory.maxWeight,
        helpers.CountOccupiedSlots(inventory.items), inventory.slots, 1000)
end

function Sky.FW.AddItem(source, item, amount, slot, metadata)
    local success = exports["codem-inventoryv2"]:AddItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot)
    return success
end

function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    local success = exports["codem-inventoryv2"]:RemoveItem(source, item, amount, helpers.NormalizeMetadata(metadata), slot)
    return success and amount or 0
end

function Sky.FW.CanCarryItem(source, item, amount, metadata)
    local can_carry = exports["codem-inventoryv2"]:CanCarryItem(source, item, amount, helpers.NormalizeMetadata(metadata))
    return can_carry
end

function Sky.FW.HasItem(source, item, amount, metadata)
    local count = exports["codem-inventoryv2"]:GetItemCount(source, item, helpers.NormalizeMetadata(metadata), false)
    return count >= (tonumber(amount) or 1)
end

function Sky.FW.GetInventoryItems(source)
    local inventory_items = exports["codem-inventoryv2"]:GetInventoryItems(source)
    if not inventory_items then
        Sky.Debug("error", "[inventory/codemv2] Player inventory is unavailable for source %s", tostring(source))
        return {}
    end

    local items = {}
    for slot, item in pairs(inventory_items) do
        local normalized = helpers.NormalizeSlotItem(item, slot, { amountOrder = "count_first" })
        if normalized then items[#items + 1] = normalized end
    end
    return items
end

function Sky.FW.GetInventorySlotsWithItem(source, item, metadata)
    local slots = exports["codem-inventoryv2"]:GetSlotsWithItem(source, item, helpers.NormalizeMetadata(metadata), false)
    -- CodeM returns nil for an unknown item; Sky's slot lookup always returns an array.
    if slots == nil then
        Sky.Debug("warn", "[inventory/codemv2] GetSlotsWithItem returned nil for item '%s' (source %s); check its definition in codem-inventoryv2/data/items.lua", tostring(item), tostring(source))
        return {}
    end
    local items = {}
    for _, slot in ipairs(slots) do
        local normalized = helpers.NormalizeSlotItem(slot, slot.slot, { amountOrder = "count_first" })
        if normalized then items[#items + 1] = normalized end
    end
    return items
end

function Sky.FW.GetInventoryItem(source, item, metadata)
    local slots = Sky.FW.GetInventorySlotsWithItem(source, item, metadata)
    if #slots == 0 then return nil end

    local amount = 0
    for _, slot in ipairs(slots) do
        amount = amount + slot.amount
    end
    return {
        name = slots[1].name,
        label = slots[1].label,
        amount = amount,
        count = amount,
        metadata = slots[1].metadata
    }
end

function Sky.FW.GetInventorySlot(source, slot)
    local item = exports["codem-inventoryv2"]:GetSlot(source, slot)
    local normalized = helpers.NormalizeSlotItem(item, slot, { amountOrder = "count_first" })
    if normalized then normalized.weight = item.weight end
    return normalized
end

Sky.FW.GetItemBySlot = Sky.FW.GetInventorySlot
Sky.FW.GetPlayerInventory = Sky.FW.GetInventoryItems

function Sky.FW.SetInventorySlotMetadata(source, slot, metadata)
    -- Unlike ox_inventory, V2 documents a boolean result. Do not manufacture success.
    local success = exports["codem-inventoryv2"]:SetMetadata(source, slot, metadata or {})
    return success
end

function Sky.FW.GetItems()
    return exports["codem-inventoryv2"]:Items()
end

function Sky.FW.GetItemLabel(item)
    local definition = exports["codem-inventoryv2"]:Items(item)
    return definition and definition.label or item
end

function Sky.FW.GetItemInfo(item)
    local definition = exports["codem-inventoryv2"]:Items(item)
    if not definition then
        Sky.Debug("error", "[inventory/codemv2] Item definition is missing: %s", tostring(item))
        return {}
    end

    local image = definition.client and definition.client.image or (item .. ".png")
    return {
        name = item,
        label = definition.label,
        stack = definition.stack ~= false,
        weight = definition.weight or 0,
        description = definition.description,
        image = "nui://codem-inventory-images/images/" .. image
    }
end

function Sky.FW.GetResourceName()
    return "codem-inventoryv2"
end

function Sky.FW.RegisterUsableItem(name, callback)
    local use_callback = callback
    if callback then
        use_callback = function(source, item)
            local normalized = helpers.NormalizeSlotItem(item, item.slot, { amountOrder = "count_first" })
            return callback(source, normalized)
        end
    end
    exports["codem-inventoryv2"]:CreateUsableItem(name, use_callback)
    return true
end

function Sky.FW.RegisterItem(definition, _options)
    if type(definition) ~= "table" or type(definition.name) ~= "string" or definition.name == "" then
        Sky.Debug("error", "[inventory/codemv2] RegisterItem requires an item definition with a non-empty name")
        return false
    end
    if exports["codem-inventoryv2"]:Items(definition.name) then return true end

    Sky.Debug("warn", "[inventory/codemv2] Runtime item registration is not documented; add '%s' to codem-inventoryv2/data/items.lua and restart the inventory", definition.name)
    return false
end

function Sky.FW.RefreshItems()
    Sky.Debug("warn", "[inventory/codemv2] Runtime item catalog reload is not documented; restart codem-inventoryv2 after editing data/items.lua")
    return false
end

function Sky.FW.CanCarryWeapon(source, weapon, metadata)
    local can_carry = exports["codem-inventoryv2"]:CanCarryItem(source, weapon, 1, helpers.NormalizeMetadata(metadata))
    return can_carry
end

function Sky.FW.AddWeapon(source, weapon, ammo, metadata)
    local weapon_metadata = {}
    for key, value in pairs(metadata or {}) do weapon_metadata[key] = value end
    if weapon_metadata.ammo == nil then weapon_metadata.ammo = ammo end
    local success = exports["codem-inventoryv2"]:AddItem(source, weapon, 1, weapon_metadata)
    return success
end

function Sky.FW.RemoveWeapon(source, weapon, metadata)
    local success = exports["codem-inventoryv2"]:RemoveItem(source, weapon, 1, helpers.NormalizeMetadata(metadata))
    return success
end

function Sky.FW.GetWeapons(source)
    local weapons = {}
    local definitions = Sky.FW.GetItems()
    for _, item in ipairs(Sky.FW.GetInventoryItems(source)) do
        local definition = definitions[item.name]
        if definition and (definition.weapon or definition.type == "weapon" or definition.weaponName) then
            weapons[#weapons + 1] = {
                name = item.name,
                label = item.label,
                amount = item.amount,
                ammo = item.metadata and item.metadata.ammo,
                metadata = item.metadata
            }
        end
    end
    return weapons
end

function Sky.FW.RegisterStash(id, label, slots, weight, owner, groups, coords)
    id = tostring(id)
    if registered_stashes[id] then return true, id end
    exports["codem-inventoryv2"]:RegisterStash(id, label, slots, weight, owner, groups, coords)
    registered_stashes[id] = true
    return true, id
end

function Sky.FW.OpenStash(source, inventory_type, id)
    exports["codem-inventoryv2"]:forceOpenInventory(source, inventory_type or "stash", id)
end

function Sky.FW.AddStashItems(id, items)
    for _, item in pairs(items) do
        local success, reason = exports["codem-inventoryv2"]:AddItem(id, item.item, item.count or item.amount, helpers.NormalizeMetadata(item.metadata or item.info))
        if not success then
            Sky.Debug("error", "[inventory/codemv2] Could not add '%s' to '%s': %s", tostring(item.item), tostring(id), tostring(reason))
            return false
        end
    end
    return true
end

function Sky.FW.ClearStash(id, _type)
    id = tostring(id)
    -- ClearInventory has no documented return and preserves money accounts.
    exports["codem-inventoryv2"]:ClearInventory(id)
    local remaining = exports["codem-inventoryv2"]:GetInventoryItems(id)
    if remaining and next(remaining) == nil then return true end
    Sky.Debug("error", "[inventory/codemv2] Stash '%s' is not confirmed empty after ClearInventory; storage is unavailable or retained items remain (V2 keeps money accounts)", id)
    return false
end

function Sky.FW.OpenPlayerInventory(source, target)
    exports["codem-inventoryv2"]:forceOpenInventory(source, "player", target)
    return true
end

function Sky.FW.RegisterShop(title, items, coords, groups)
    exports["codem-inventoryv2"]:RegisterShop(title, {
        name = title,
        inventory = items,
        locations = coords and { coords } or nil,
        groups = groups
    })
    return true
end

function Sky.FW.OpenShop(source, title)
    -- V2 documents the server export for shops, not ox_inventory:openInventory.
    exports["codem-inventoryv2"]:forceOpenInventory(source, "shop", { type = title, id = 1 })
end

function Sky.FW.AddTrunkItems(plate, items)
    local id = "trunk" .. plate
    return Sky.FW.AddStashItems(id, items)
end

function Sky.FW.GetVehicleInventoryItems(plate, compartment, _net_id)
    if (compartment ~= "trunk" and compartment ~= "glovebox") or type(plate) ~= "string" or not plate:find("%S") then
        Sky.Debug("error", "[inventory/codemv2] Vehicle read requires a valid plate and trunk/glovebox compartment")
        return nil, "invalid_target"
    end
    -- V2 documents string ids and 'glovebox', not ox's table target / 'glove' prefix.
    local items = exports["codem-inventoryv2"]:GetInventoryItems(compartment .. plate)
    return helpers.NormalizeStorageItems(items)
end

function Sky.FW.TakeVehicleInventoryItem(source, plate, compartment, net_id, slot, name, amount)
    local items, reason = Sky.FW.GetVehicleInventoryItems(plate, compartment, net_id)
    if not items then return false, reason end

    local id = compartment .. plate
    return helpers.TakeVehicleSlot(source, items, slot, name, amount, function(item, count)
        return exports["codem-inventoryv2"]:RemoveItem(id, item.name, count, item.metadata, item.slot, false)
    end, function(item, count)
        return exports["codem-inventoryv2"]:AddItem(id, item.name, count, item.metadata, item.slot)
    end)
end

function Sky.FW.UpdatePlate(old_plate, new_plate)
    local moved = exports["codem-inventoryv2"]:UpdateVehicle(old_plate, new_plate)
    return moved
end
