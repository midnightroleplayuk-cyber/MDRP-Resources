local function init()
    while GetResourceState('codem-inventory') ~= 'started' do
        Wait(100)
    end

    if FW.name == 'esx' or FW.name == 'esx-legacy' then
        ESX = ESX or exports['es_extended']:getSharedObject()

        ESX.RegisterUsableItem(PortableBenchOptions.item, function(src, name, item)
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })
        end)
    elseif FW.name == 'qbcore' then
        QBCore = QBCore or exports['qb-core']:GetCoreObject()

        QBCore.Functions.CreateUseableItem(PortableBenchOptions.item, function(src, item)
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = item.name,
                slot = item.slot,
            })
        end)
    else
        Log.error('Unsupported framework for codem-inventory')
    end

    -- This does not work. Couldn't find the correct event name. If you know it, please let us know.
    RegisterNetEvent('codem_inventory:server:useItem', function(src, item)
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

        local codemItems = exports['codem-inventory']:GetItemList()
        if codemItems then
            for _, v in pairs(codemItems) do
                if v and type(v) == "table" and v.name then
                    table.insert(items, {
                        name = v.name,
                        label = v.label or v.name,
                        description = v.description or '',
                        image = (v.image and v.image:match('^%w+://') and v.image)
                            or ('nui://codem-inventory/html/itemimages/' .. (v.image or (v.name and v.name .. '.png' or 'default.png'))),
                        unique = v.stack == false or v.unique
                    })
                else
                    Log.error('Invalid item data in codem-inventory: ' .. tostring(v), v)
                end
            end
        else
            Log.error('Failed to retrieve items from codem-inventory')
        end
    end

    return items
end

local function getPlayerItemsCount(src)
    local inventory = exports['codem-inventory']:GetInventory(nil, src)

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

local function getPlayerInventory(src)
    local inventory = exports['codem-inventory']:GetInventory(nil, src)

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
                metadata = v.info or {},
            })
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
            if not exports['codem-inventory']:AddItem(src, item, 1, nil, metadata) then
                return false
            end
        end

        return true
    end

    return exports['codem-inventory']:AddItem(src, item, amount, nil, metadata)
end

local function removePlayerItem(src, item, amount)
    return exports['codem-inventory']:RemoveItem(src, item, amount)
end

local function getSpecificPlayerItem(src, data)
    local inventory = exports['codem-inventory']:GetInventory(nil, src)

    if not inventory then
        return false
    end

    for _, item in pairs(inventory) do
        if item and item.name == data.item and item.slot == data.slot then
            return {
                item = item.name,
                metadata = item.info or {},
            }
        end
    end

    return false
end

local function removeSpecificPlayerItem(src, data, amount)
    return exports['codem-inventory']:RemoveItem(src, data.item, amount, data.slot)
end

local function setMetadata(src, data, metadata)
    exports['codem-inventory']:SetItemMetadata(src, data.slot, metadata)

    return true
end

local function canCarryItems(src, items)
    return true
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
