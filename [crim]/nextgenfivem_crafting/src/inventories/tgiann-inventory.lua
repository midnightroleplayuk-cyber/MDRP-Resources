local function init()
    while GetResourceState('tgiann-inventory') ~= 'started' do
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
    else
        Log.error('Unsupported framework for tgiann-inventory')
    end

    -- This does not work. Couldn't find the correct event name. If you know it, please let us know.
    RegisterNetEvent('tgiann-inventory:server:useItem', function(src, item)
        -- Check if item has benchType metadata
        local metadata = item.info or item.metadata
        if metadata and metadata.benchType then
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })
            return
        end

        -- Check if item matches portable bench format pattern
        local format = PortableBenchOptions.format or '%s_crafting_bench'
        local pattern = format:gsub('%%s', '.*')
        if item.name:match(pattern) or string.endsWith(item.name, '_' .. PortableBenchOptions.item) then
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })
        end
    end)
end

local items = nil

local function getItems()
    if not items then
        items = {}

        local tgiannItems = exports['tgiann-inventory']:Items()
        if tgiannItems then
            for k, v in pairs(tgiannItems) do
                if k and v and type(v) == "table" then
                    table.insert(items, {
                        name = k,
                        label = v.label or k,
                        description = v.description or '',
                        image = (v.image and v.image:match('^%w+://') and v.image)
                            or ('nui://inventory_images/images/' .. (v.image or (v.name and v.name .. '.png' or 'default.png'))),
                        unique = v.stack == false or v.unique
                    })
                else
                    Log.error('Invalid item data in tgiann-inventory: ' .. tostring(k), v)
                end
            end
        else
            Log.error('Failed to retrieve items from tgiann-inventory')
        end
    end

    return items
end

local function getPlayerInventory(src)
    local inventory = exports['tgiann-inventory']:GetPlayerItems(src)

    if not inventory then
        return false
    end

    local items = {}

    for _, v in pairs(inventory) do
        if v and v.name then
            table.insert(items, {
                item = v.name,
                slot = v.slot or 0,
                quantity = v.amount or 0,
                metadata = v.metadata or {},
            })
        end
    end
    return items
end

local function getPlayerItemsCount(src)
    local inventory = exports['tgiann-inventory']:GetPlayerItems(src)

    if not inventory then
        return false
    end

    local items = {}

    for _, v in pairs(inventory) do
        if v and v.name and v.amount then
            if not items[v.name] then
                items[v.name] = v.amount
            else
                items[v.name] = items[v.name] + v.amount
            end
        end
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
            if exports['tgiann-inventory']:AddItem(src, item, 1, nil, metadata) == false then
                return false
            end
        end

        return true
    end

    return exports['tgiann-inventory']:AddItem(src, item, amount, nil, metadata) ~= false
end

local function removePlayerItem(src, item, amount)
    return exports['tgiann-inventory']:RemoveItem(src, item, amount) ~= false
end

local function getSpecificPlayerItem(src, data)
    local item = exports['tgiann-inventory']:GetItemBySlot(src, data.slot)

    if not item then
        return false
    end

    return {
        item = item.name,
        metadata = item.metadata or {},
    }
end

local function removeSpecificPlayerItem(src, data, amount)
    return exports['tgiann-inventory']:RemoveItem(src, data.item, amount, data.slot)
end

local function setMetadata(src, data, metadata)
    local item = exports['tgiann-inventory']:GetItemBySlot(src, data.slot, metadata)

    if not item or item.name ~= data.item then
        return false
    end

    item.info = metadata

    return exports['tgiann-inventory']:SetItemData(src, item.name, data.slot, metadata)
end

local function canCarryItems(src, items)
    return exports["tgiann-inventory"]:CanCarryItems(src, items)
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
