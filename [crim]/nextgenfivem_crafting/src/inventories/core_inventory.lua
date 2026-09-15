local function init()
    while GetResourceState('core_inventory') ~= 'started' do
        Wait(100)
    end

    QBCore = QBCore or exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem(PortableBenchOptions.item, function(src, item)
        TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
            item = item.name,
            slot = item.slot,
        })
    end)

    -- This does not work. Couldn't find the correct event name. If you know it, please let us know.
    RegisterNetEvent('core_inventory:server:useItem', function(src, item)
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

        local coreItems = exports['core_inventory']:getItemsList()
        if coreItems then
            for _, v in pairs(coreItems) do
                if v and type(v) == "table" and v.name then
                    table.insert(items, {
                        name = v.name,
                        label = v.label or v.name,
                        description = v.description or '',
                        image = (v.image and v.image:match('^%w+://') and v.image)
                            or ('nui://core_inventory/html/images/' .. (v.image or (v.name and v.name .. '.png' or 'default.png'))),
                        unique = v.stack == false or v.unique
                    })
                else
                    Log.error('Invalid item data in core_inventory: ' .. tostring(v), v)
                end
            end
        else
            Log.error('Failed to retrieve items from core_inventory')
        end
    end

    return items
end

local function getPlayerItemsCount(src)
    local inventory = exports['core_inventory']:getInventory(src)

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
    local inventory = exports['core_inventory']:getInventory(src)

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
            if not exports['core_inventory']:addItem(src, item, 1, metadata) then
                return false
            end
        end

        return true
    end

    if exports['core_inventory']:addItem(src, item, amount, metadata) then
        return true
    end

    return false
end

local function removePlayerItem(src, item, amount)
    if exports['core_inventory']:removeItem(src, item, amount) then
        return true
    end

    return false
end

local function getSpecificPlayerItem(src, data)
    local inventory = exports['core_inventory']:getInventory(src)

    if not inventory then
        return false
    end

    for _, item in pairs(inventory) do
        if item and item.name == data.item and item.slot == data.slot then
            return {
                item = item.name,
                metadata = item.metadata or {},
            }
        end
    end

    return false
end

local function removeSpecificPlayerItem(src, data, amount)
    local inventory = exports['core_inventory']:getInventory(src)

    if not inventory then
        return false
    end

    local item

    for _, v in pairs(inventory) do
        if v and v.name == data.item and v.slot == data.slot then
            item = v
            break
        end
    end

    if not item then
        return false
    end

    if exports['core_inventory']:removeItemExact(src, item.id, amount) then
        return true
    end

    return false
end

local function setMetadata(src, data, metadata)
    exports['core_inventory']:setMetadata(src, data.slot, metadata)

    return true
end

local function canCarryItem(src, item, amount)
    return exports['core_inventory']:canCarry(src, item, amount)
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
    canCarryItems = canCarryItem,
}
