---@diagnostic disable: duplicate-set-field
if Sky.Config.inventory ~= "qb-inv" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
Sky.FW.InventoryCapabilities = { itemMetadata = true }

function Sky.FW.TakeVehicleInventoryItem(source, plate, compartment, netId, slot, name, amount)
    local items, code = Sky.FW.GetVehicleInventoryItems(plate, compartment, netId)
    if not items then return false, code end
    local id = compartment .. "-" .. plate:match("^%s*(.-)%s*$")
    return helpers.TakeVehicleSlot(source, items, slot, name, amount, function(item, count)
        return exports["qb-inventory"]:RemoveItem(id, item.name, count, item.slot, "sky_base:vehicleRaid")
    end, function(item, count)
        return exports["qb-inventory"]:AddItem(id, item.name, count, item.slot, item.metadata, "sky_base:vehicleRaidRestore")
    end)
end

function Sky.FW.GetVehicleInventoryItems(plate, compartment, _netId)
    if (compartment ~= "trunk" and compartment ~= "glovebox") or type(plate) ~= "string" or not plate:find("%S") then
        print("[sky_base] qb-inventory vehicle read rejected: invalid plate or compartment")
        return nil, "invalid_target"
    end
    -- Current qb-inventory hydrates saved inventories at startup. Never CreateInventory here:
    -- a missing cache entry during startup must not become a fabricated empty compartment.
    local inventory = exports["qb-inventory"]:GetInventory(compartment .. "-" .. plate:match("^%s*(.-)%s*$"))
    return helpers.NormalizeStorageItems(inventory and inventory.items)
end

-- Stash / shop / trunk / plate helpers
-- File-local stash registry.
local stashes = {}

---@description Add an item to the player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    return exports["qb-inventory"]:AddItem(source, item, amount, slot, helpers.NormalizeMetadata(metadata), "sky_base:AddItem")
end

---@description Remove an item from the player's inventory; returns the amount removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    if slot == nil and helpers.NormalizeMetadata(metadata) then
        for index, inventoryItem in pairs(Sky.FW.GetInventoryItems(source)) do
            if type(inventoryItem) == "table"
                and inventoryItem.name == item
                and helpers.MetadataMatches(inventoryItem.metadata or inventoryItem.info, metadata) then
                slot = tonumber(inventoryItem.slot) or tonumber(index)
                break
            end
        end
        if not slot then return 0 end
    end

    local removed = exports["qb-inventory"]:RemoveItem(source, item, amount, slot, "sky_base:RemoveItem")
    if removed then
        return amount
    end
    return 0
end

---@description Check whether the player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return exports["qb-inventory"]:CanAddItem(source, weaponName, 1)
end

---@description Return normalized item metadata for the given item name.
---@param item string
---@return table
function Sky.FW.GetItemInfo(item)
    local itemData = Sky.FW.GetItems()[item]
    if not itemData then return {} end
    return {
        name = itemData.name,
        label = itemData.label,
        stack = itemData.unique,
        weight = itemData.weight,
        description = itemData.description,
        image = (itemData.client and itemData.client.image) or itemData.image
    }
end

---@description Return the normalized item occupying the given inventory slot.
---@param source number
---@param slot number
---@return table
function Sky.FW.GetItemBySlot(source, slot)
    local slotData = exports["qb-inventory"]:GetItemBySlot(source, slot)
    if not slotData then return {} end
    return {
        name = slotData.name,
        label = helpers.ResolveItemLabel(slotData.label or slotData.name, slotData.info),
        weight = slotData.weight,
        slot = slotData.slot,
        count = slotData.amount,
        metadata = slotData.info
    }
end

---@description Update the slot's info without removing or recreating its item.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then
        return false
    end
    local slotData = exports["qb-inventory"]:GetItemBySlot(source, numericSlot)
    if not slotData then
        Sky.Debug("debug", "[inventory] SetInventorySlotMetadata failed: no item in slot %s for source %s", numericSlot, tostring(source))
        return false
    end
    return exports["qb-inventory"]:SetItemData(source, slotData.name, "info", helpers.NormalizeMetadata(metadata) or {}, numericSlot) == true
end

---@description Return the inventory resource name.
---@return string
function Sky.FW.GetResourceName()
    return "qb-inventory"
end

---@description Add a weapon to the player's inventory with generated serial/quality/ammo metadata.
---@param source number
---@param weaponName string
---@param ammo number
---@param metadata? table
---@return boolean
function Sky.FW.AddWeapon(source, weaponName, ammo, metadata)
    local info = metadata or {}
    if info.serie == nil then
        info.serie = tostring(QBCore.Shared.RandomInt(2) ..
            QBCore.Shared.RandomStr(3) ..
            QBCore.Shared.RandomInt(1) ..
            QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
    end
    if info.quality == nil then info.quality = 100 end
    if info.ammo == nil then info.ammo = ammo end
    return exports["qb-inventory"]:AddItem(source, weaponName, 1, nil, info, "sky_base:AddWeapon")
end

---@description Remove a weapon from the player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    return exports["qb-inventory"]:RemoveItem(source, weaponName, 1, nil, "sky_base:RemoveWeapon") == true
end

---@description Register a stash definition in the file-local registry.
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

---@description Open a stash inventory for the player.
---@param source number
---@param _type? string
---@param id string
---@return any
function Sky.FW.OpenStash(source, _type, id)
    _type = _type or "stash"
    return exports["qb-inventory"]:OpenInventory(source, id)
end

---@description Add a list of items to a stash inventory.
---@param id string
---@param items table
---@return boolean
function Sky.FW.AddStashItems(id, items)
    if type(items) ~= "table" then return false end
    local success = false
    for _, item in pairs(items) do
        success = exports["qb-inventory"]:AddItem(id, item.item, item.count or item.amount, nil, item.metadata or item.info, "sky_base:AddStashItems")
    end
    return success
end

---@description Clear a stash/trunk/glovebox inventory and drop it from the registry.
---@param id string
---@param _type? string
---@return boolean
function Sky.FW.ClearStash(id, _type)
    if type(id) ~= "string" then return false end
    if stashes[id] then stashes[id] = nil end
    if _type == "trunk" then
        id = "trunk-" .. id
    elseif _type == "glovebox" then
        id = "glovebox-" .. id
    end
    local inv = exports["qb-inventory"]:GetInventory(id)
    if not inv then return true end
    exports["qb-inventory"]:ClearStash(id)
    return true
end

---@description Open another player's inventory for the source player.
---@param source number
---@param target number
---@return any
function Sky.FW.OpenPlayerInventory(source, target)
    if not source then
        Sky.Debug("error", "[inventory] OpenPlayerInventory: source is required")
        return false
    end
    if not target then
        Sky.Debug("error", "[inventory] OpenPlayerInventory: target is required")
        return false
    end
    return exports["qb-inventory"]:OpenInventory(source, target)
end

---@description Open a registered shop for the player.
---@param source number
---@param shopTitle string
---@return any
function Sky.FW.OpenShop(source, shopTitle)
    return exports["qb-inventory"]:OpenShop(source, shopTitle)
end

---@description Register a shop and its inventory.
---@param shopTitle string
---@param shopInventory table
---@param shopCoords? table
---@param _shopGroups? table
---@return any
function Sky.FW.RegisterShop(shopTitle, shopInventory, shopCoords, _shopGroups)
    if not shopTitle or not shopInventory then return end
    local repackedShopItems = {}
    for _, v in pairs(shopInventory) do
        table.insert(repackedShopItems, { name = v.name, price = v.price, amount = v.count or v.amount or 1000 })
    end
    return exports["qb-inventory"]:CreateShop({ name = shopTitle, label = shopTitle, coords = shopCoords, items = repackedShopItems })
end

---@description Add a list of items to a vehicle trunk inventory.
---@param identifier string
---@param items table
---@return boolean
function Sky.FW.AddTrunkItems(identifier, items)
    if type(items) ~= "table" then return false end
    local fullTrunkId = "trunk-" .. identifier
    if not exports["qb-inventory"]:GetInventory(fullTrunkId) then
        exports["qb-inventory"]:CreateInventory(fullTrunkId, { label = fullTrunkId, slots = 15, maxweight = 10000 })
    end
    Wait(1000)
    for i = 1, #items do
        exports["qb-inventory"]:AddItem(fullTrunkId, items[i].name, items[i].amount or items[i].count, items[i].slot or nil, items[i].info or items[i].metadata or {}, "sky_base:AddTrunkItems")
    end
    return true
end

---@description Migrate trunk/glovebox inventories from an old plate to a new plate.
---@param oldplate string
---@param newplate string
---@return boolean
function Sky.FW.UpdatePlate(oldplate, newplate)
    local queries = {
        "UPDATE inventory_glovebox SET plate = @newplate WHERE plate = @oldplate",
        "UPDATE inventory_trunk SET plate = @newplate WHERE plate = @oldplate"
    }
    local values = { newplate = newplate, oldplate = oldplate }
    MySQL.transaction.await(queries, values)
    if GetResourceState("jg-mechanic") == "missing" then return true end
    return true, exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end
