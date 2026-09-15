local function init()
    while GetResourceState('qs-inventory') ~= 'started' do
        Wait(100)
    end

    exports['qs-inventory']:CreateUsableItem(PortableBenchOptions.item, function(src, item)
        TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
            item = item.name,
            slot = item.slot,
        })
    end)

    -- Probably not working. Couldn't find any info about the parameters of the event. If you know it, please let us know.
    RegisterNetEvent('inventory:usedItem', function(itemName, slot)
        local src = source

        -- Check if item matches portable bench format pattern
        local format = PortableBenchOptions.format or '%s_crafting_bench'
        local pattern = format:gsub('%%s', '.*')
        if itemName:match(pattern) or string.endsWith(itemName, '_' .. PortableBenchOptions.item) then
            TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
                item = itemName,
                slot = slot,
            })
        end
    end)
end

local items = nil

local function getItems()
    if not items then
        items = {}

        local qsItems = exports['qs-inventory']:GetItemList()
        if qsItems then
            for k, v in pairs(qsItems) do
                if k and v and type(v) == 'table' then
                    table.insert(items, {
                        name = k,
                        label = v.label or k,
                        description = v.description or '',
                        image = (v.image and v.image:match('^%w+://') and v.image)
                            or ('nui://qs-inventory/html/images/' .. (v.image or k .. '.png')),
                        unique = v.stack == false or v.unique
                    })
                else
                    Log.error('Invalid item data in qs-inventory: ' .. tostring(k), v)
                end
            end
        else
            Log.error('Failed to retrieve items from qs-inventory')
        end
    end

    return items
end

local function getPlayerItemsCount(src)
    local inventory = exports['qs-inventory']:GetInventory(src)

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
    local inventory = exports['qs-inventory']:GetInventory(src)

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
            if not exports['qs-inventory']:AddItem(src, item, 1, nil, metadata) then
                return false
            end
        end

        return true
    end

    return exports['qs-inventory']:AddItem(src, item, amount, nil, metadata)
end

local function removePlayerItem(src, item, amount)
    return exports['qs-inventory']:RemoveItem(src, item, amount)
end

local function getSpecificPlayerItem(src, data)
    local inventory = exports['qs-inventory']:GetInventory(src)

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
    return exports['qs-inventory']:RemoveItem(src, data.item, amount, data.slot)
end

local function setMetadata(src, data, metadata)
    exports['qs-inventory']:SetItemMetadata(src, data.slot, metadata)

    return true
end

local function canCarryItem(src, item, amount)
    return exports['qs-inventory']:CanCarryItem(src, item, amount)
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
    canCarryItem = canCarryItem,
}
