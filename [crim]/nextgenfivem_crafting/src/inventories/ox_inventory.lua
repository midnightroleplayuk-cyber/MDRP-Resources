local function init()
    while GetResourceState('ox_inventory') ~= 'started' do
        Wait(100)
    end

    if FW.name == 'esx' or FW.name == 'esx-legacy' then
        ESX = ESX or exports['es_extended']:getSharedObject()

        ESX.RegisterUsableItem(PortableBenchOptions.item, function(src, name, item)
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })

            return true
        end)
    elseif FW.name == 'qbcore' then
        QBCore = QBCore or exports['qb-core']:GetCoreObject()

        QBCore.Functions.CreateUseableItem(PortableBenchOptions.item, function(src, item)
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })

            return true
        end)
    elseif FW.name == 'qbox' then
        exports.qbx_core:CreateUseableItem(PortableBenchOptions.item, function(src, item)
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })

            return true
        end)
    elseif FW.name == 'oxcore' then
        exports(PortableBenchOptions.item, function(event, item, inventory, slot, data)
            if event == 'usedItem' then
                TriggerEvent('nextgenfivem_crafting:usePortableBench', inventory.id, {
                    item = item,
                    slot = slot,
                })
            end
        end)
    else
        Log.error('Unsupported framework for ox_inventory')
    end

    RegisterNetEvent('ox_inventory:usedItem', function(src, name, slot, metadata)
        -- The default portable bench item is already handled by the framework-specific
        -- usable-item callback registered above (ESX/QB/qbox/oxcore). After ox_inventory's
        -- useItem callback returns truthy, the client re-broadcasts ox_inventory:usedItem,
        -- which would otherwise fire usePortableBench a second time. The bench placement
        -- only happens once, but both server handlers reach the RemoveSpecificPlayerItem
        -- call — the second one fails with not_enough_items and surfaces as
        -- "An error occurred. (remove_item)" to the player.
        if name == PortableBenchOptions.item then return end

        -- Check if item has benchType metadata (custom-named portable bench)
        if metadata and metadata.benchType then
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = name,
                slot = slot,
            })
            return
        end

        -- Check if item matches portable bench format pattern (custom-named bench)
        local format = PortableBenchOptions.format or '%s_crafting_bench'
        local pattern = format:gsub('%%s', '.*')
        if name:match(pattern) or string.endsWith(name, '_' .. PortableBenchOptions.item) then
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = name,
                slot = slot,
            })
        end
    end)
end

local items = nil

local function getItems()
    if not items then
        items = {}

        local oxItems = exports.ox_inventory:Items()
        if oxItems then
            for k, v in pairs(oxItems) do
                if k and v and type(v) == "table" then
                    local label = v.label or k
                    local description = v.description or ""
                    local weight = v.weight or 0
                    local image = (v.client and v.client.image) and v.client.image or (k .. ".png")
                    local unique = (v.stack == false) or v.unique or false

                    table.insert(items, {
                        name = k,
                        label = label,
                        description = description,
                        weight = weight,
                        image = (image:match('^%w+://') and image) or ('nui://ox_inventory/web/images/' .. image),
                        unique = unique
                    })
                else
                    Log.error('Invalid item data in ox_inventory: ' .. k, v)
                end
            end
        else
            Log.error('Failed to retrieve items from ox_inventory')
        end
    end

    return items
end

local function getPlayerItemsCount(src)
    local inventory = exports.ox_inventory:GetInventory(src)

    if not inventory then
        return false
    end

    local items = {}

    for _, v in pairs(inventory.items) do
        if not items[v.name] then
            items[v.name] = v.count
        else
            items[v.name] = items[v.name] + v.count
        end
    end

    return items
end

local function getPlayerInventory(src)
    local inventory = exports.ox_inventory:GetInventory(src)

    if not inventory then
        return false
    end

    local items = {}

    for _, v in pairs(inventory.items) do
        table.insert(items, {
            item = v.name,
            slot = v.slot,
            quantity = v.count,
            metadata = v.metadata,
        })
    end

    return items
end

local function addPlayerItem(src, item, amount, metadata, options)
    if options then
        metadata = metadata or {}

        if options.description then
            metadata.description = options.description
        end

        if options.label then
            metadata.label = options.label
        end
    end

    if amount > 1 and items and items[item]?.unique then
        -- Give multiple unique items one by one to prevent duplicated metadata

        for i = 1, amount do
            if not exports.ox_inventory:AddItem(src, item, 1, metadata) then
                return false
            end
        end

        return true
    end

    return exports.ox_inventory:AddItem(src, item, amount, metadata)
end

local function removePlayerItem(src, item, amount)
    return exports.ox_inventory:RemoveItem(src, item, amount)
end

local function getSpecificPlayerItem(src, data)
    local slot = exports.ox_inventory:GetSlot(src, data.slot)

    if slot then
        return {
            item = slot.name,
            metadata = slot.metadata,
        }
    end

    return false
end

local function removeSpecificPlayerItem(src, data, amount)
    return exports.ox_inventory:RemoveItem(src, data.item, amount, nil, data.slot)
end

local function setMetadata(src, data, metadata)
    exports.ox_inventory:SetMetadata(src, data.slot, metadata)

    return true
end

local function canCarryItems(src, items)
    local totalWeight = 0

    for _, v in pairs(items) do
        local name, amount = v.name, v.amount or 1

        for _, item in pairs(getItems()) do
            if item.name == name then
                totalWeight = totalWeight + item.weight * amount
                break
            end
        end
    end

    local canCarryWeight = exports.ox_inventory:CanCarryWeight(src, totalWeight)

    return canCarryWeight
end

return {
    init = init,
    getItems = getItems,
    getPlayerItemsCount = getPlayerItemsCount,
    getPlayerInventory = getPlayerInventory,
    addPlayerItem = addPlayerItem,
    removePlayerItem = removePlayerItem,
    getSpecificPlayerItem = getSpecificPlayerItem,
    removeSpecificPlayerItem = removeSpecificPlayerItem,
    setMetadata = setMetadata,
    canCarryItems = canCarryItems,
}
