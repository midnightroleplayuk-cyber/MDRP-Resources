---@diagnostic disable: duplicate-set-field
-- Framework-native QBCore inventory. Active when no standalone inventory is selected; provides
-- fallbacks otherwise. Guarded on the framework.
if Sky.Config.framework ~= "qb" then return end
if not IsDuplicityVersion() then return end

local helpers = SkyInventoryHelpers
if Sky.Config.inventory == "qb" or Sky.Config.inventory == "qb-inv" then
    function Sky.FW.GetResourceName()
        return "qb-inventory"
    end

    function Sky.FW.GetInventoryStats(source)
        local player = QBCore.Functions.GetPlayer(source)
        if not player then
            Sky.Debug("error", "[inventory] QB statistics unavailable: player %s is not loaded", source)
            return nil, "unavailable"
        end
        local weight = exports["qb-inventory"]:GetTotalWeight(player.PlayerData.items)
        local free_weight = exports["qb-inventory"]:GetFreeWeight(source)
        local used_slots, free_slots = exports["qb-inventory"]:GetSlots(source)
        return helpers.NormalizeInventoryStats(weight, weight + free_weight, used_slots, used_slots + free_slots, 1000)
    end
end
if Sky.Config.inventory == "qb" then
    Sky.FW.InventoryCapabilities = { itemMetadata = true }
end

---@description Register a usable item with the framework so its callback fires on use.
---@param name string
---@param callback function|nil
function Sky.FW.RegisterUsableItem(name, callback)
    QBCore.Functions.CreateUseableItem(name, callback)
end

---@description Adds or updates an item through QBCore's synchronized shared-item API.
---@param definition table
---@param options? table
---@return boolean
function Sky.FW.RegisterItem(definition, options)
    if type(definition) ~= "table" or type(definition.name) ~= "string" or definition.name == "" then
        return false
    end

    local item_name = definition.name
    local existing = exports["qb-core"]:GetCoreObject({ "Shared" }).Shared.Items[item_name]
    if type(existing) == "table" and type(options) == "table" and options.preserveExisting == true then
        return true
    end

    local item = {}
    for key, value in pairs(definition) do
        item[key] = value
    end
    item.name = item_name
    item.type = item.type or "item"
    item.image = item.image or (item_name .. ".png")
    item.unique = item.unique == true or item.stack == false
    item.useable = item.useable == true or item.consume ~= nil
    item.shouldClose = item.shouldClose ~= false and item.close ~= false

    if existing then
        local success = QBCore.Functions.UpdateItem(item_name, item)
        return success == true
    end

    local success = QBCore.Functions.AddItem(item_name, item)
    return success == true
end

---@description Add an item to a player's inventory.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return boolean
function Sky.FW.AddItem(source, item, amount, slot, metadata)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return false end
    return xPlayer.Functions.AddItem(item, amount, slot, helpers.NormalizeMetadata(metadata))
end

---@description Remove an item from a player's inventory; returns the amount actually removed.
---@param source number
---@param item string
---@param amount number
---@param slot? number
---@param metadata? table
---@return number
function Sky.FW.RemoveItem(source, item, amount, slot, metadata)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return 0 end

    if slot then
        return xPlayer.Functions.RemoveItem(item, amount, slot) and amount or 0
    end

    local expectedMetadata = helpers.NormalizeMetadata(metadata)
    if expectedMetadata then
        local playerItem
        for _, inventoryItem in pairs(xPlayer.PlayerData.items or {}) do
            if inventoryItem and inventoryItem.name == item then
                if helpers.MetadataMatches(inventoryItem.metadata or inventoryItem.info, expectedMetadata) then
                    playerItem = inventoryItem
                    break
                end
            end
        end
        if not playerItem then return 0 end

        local removed_amount = math.min(amount, playerItem.amount)
        return xPlayer.Functions.RemoveItem(item, removed_amount, playerItem.slot) and removed_amount or 0
    end

    return xPlayer.Functions.RemoveItem(item, amount) and amount or 0
end

---@description Check whether a player can carry the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryItem(source, item, amount, metadata)
    return exports["qb-inventory"]:CanAddItem(source, item, amount)
end

---@description Check whether a player has at least the given amount of an item.
---@param source number
---@param item string
---@param amount number
---@param metadata? table
---@return boolean
function Sky.FW.HasItem(source, item, amount, metadata)
    amount = amount or 1
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local foundItem = xPlayer.Functions.GetItemByName(item)
    if foundItem == nil then return false end
    return foundItem.amount >= amount
end

---@description Get all items in a player's inventory as normalized entries.
---@param source number
---@return table
function Sky.FW.GetInventoryItems(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return {} end

    local items = {}
    for _, item in pairs(xPlayer.PlayerData.items or {}) do
        local count = item.amount or item.count
        if count and count > 0 then
            local normalizedItem = {
                slot = tonumber(item.slot),
                name = item.name,
                label = helpers.ResolveItemLabel(item.label or item.name, item.metadata or item.info),
                amount = count
            }
            local metadata = helpers.NormalizeMetadata(item.metadata or item.info)
            if metadata then
                normalizedItem.metadata = metadata
            end
            items[#items + 1] = normalizedItem
        end
    end
    return items
end

---@description Get a single item from a player's inventory by name.
---@param source number
---@param item string
---@param metadata? table
---@return table|nil
function Sky.FW.GetInventoryItem(source, item, metadata)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local playerItem = xPlayer.Functions.GetItemByName(item)
    if not playerItem then return nil end
    return {
        name = playerItem.name,
        label = helpers.ResolveItemLabel(playerItem.label or playerItem.name, playerItem.metadata or playerItem.info),
        amount = playerItem.amount,
        metadata = helpers.NormalizeMetadata(playerItem.metadata or playerItem.info)
    }
end

---@description Update metadata in place through the framework's player-data synchronization.
---@param source number
---@param slotId number
---@param metadata? table
---@return boolean
function Sky.FW.SetInventorySlotMetadata(source, slotId, metadata)
    local numericSlot = tonumber(slotId)
    if not numericSlot then return false end
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return false end

    local item = xPlayer.Functions.GetItemBySlot(numericSlot)
    if not item then
        Sky.Debug("debug", "[inventory] SetInventorySlotMetadata failed: no item in slot %s for source %s", numericSlot, tostring(source))
        return false
    end

    item.info = helpers.NormalizeMetadata(metadata) or {}
    xPlayer.PlayerData.items[numericSlot] = item
    xPlayer.Functions.SetPlayerData("items", xPlayer.PlayerData.items)
    return true
end

---@description Get the framework's shared item definitions table.
---@return table
function Sky.FW.GetItems()
    return exports["qb-core"]:GetCoreObject({ "Shared" }).Shared.Items
end

---@description Get the display label for an item, falling back to its name.
---@param item string
---@return string
function Sky.FW.GetItemLabel(item)
    local shared = Sky.FW.GetItems({ item })[item]
    return shared and shared.label or item
end

---@description Check whether a player can carry the given weapon.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.CanCarryWeapon(source, weaponName, metadata)
    return exports["qb-inventory"]:CanAddItem(source, weaponName, 1)
end

---@description Add a weapon to a player's inventory, generating serial/quality/ammo metadata.
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
    return exports["qb-inventory"]:AddItem(source, weaponName, 1, false, info)
end

---@description Remove a weapon from a player's inventory.
---@param source number
---@param weaponName string
---@param metadata? table
---@return boolean
function Sky.FW.RemoveWeapon(source, weaponName, metadata)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local weapon = xPlayer.Functions.GetItemByName(weaponName)
    if weapon then
        xPlayer.Functions.RemoveItem(weaponName, 1, weapon.slot)
        return true
    end
    return false
end

---@description Get all weapons currently in a player's inventory.
---@param source number
---@return table
function Sky.FW.GetWeapons(source)
    local weapons = {}
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer or not xPlayer.PlayerData then
        return weapons
    end

    for _, item in pairs(xPlayer.PlayerData.items or {}) do
        local name = item.name
        if name and item.amount and item.amount > 0 then
            local isWeapon = item.type == "weapon" or string.sub(string.lower(name), 1, 7) == "weapon_"
            if isWeapon then
                local label = item.label
                if not label and QBCore.Shared and QBCore.Shared.Items and QBCore.Shared.Items[name] then
                    label = QBCore.Shared.Items[name].label
                end
                weapons[#weapons + 1] = {
                    name = name,
                    label = label,
                    amount = item.amount,
                    ammo = item.info and item.info.ammo or nil
                }
            end
        end
    end
    return weapons
end
