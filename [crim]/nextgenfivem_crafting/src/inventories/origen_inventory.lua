local function init()
    while GetResourceState('origen_inventory') ~= 'started' do
        Wait(100)
    end

    exports['origen_inventory']:CreateUseableItem(PortableBenchOptions.item, function(src, item)
        TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
            item = item.name,
            slot = item.slot,
        })
    end)

    -- This does not work. Couldn't find the correct event name. If you know it, please let us know.
    RegisterNetEvent('origen_inventory:server:useItem', function(src, item)
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

        local origenItems = exports['origen_inventory']:Items()
        if origenItems then
            for k, v in pairs(origenItems) do
                if k and v and type(v) == "table" then
                    table.insert(items, {
                        name = k,
                        label = v.label or k,
                        description = v.description or '',
                        image = (v.image and v.image:match('^%w+://') and v.image)
                            or ('nui://origen_inventory/html/images/' .. (v.image or k .. '.png')),
                        unique = v.stack == false or v.unique
                    })
                else
                    Log.error('Invalid item data in origen_inventory: ' .. tostring(k), v)
                end
            end
        else
            Log.error('Failed to retrieve items from origen_inventory')
        end
    end

    return items
end

local warnedAboutShape = false

--- The shape of `getInventory` differs between origen_inventory builds: some
--- return `{ inventory = { ... } }`, others return the slot list directly, and
--- the per-slot amount is named `amount` on some builds and `count` on others.
--- Normalize every known shape into a plain array of slots.
local function getInventorySlots(src)
    local inventoryData = exports['origen_inventory']:getInventory(src)

    if type(inventoryData) ~= 'table' then
        return false
    end

    local slots = inventoryData.inventory or inventoryData.items or inventoryData

    if type(slots) ~= 'table' then
        return false
    end

    local result = {}

    for _, v in pairs(slots) do
        if type(v) == 'table' then
            local name = v.name or v.item

            if name then
                result[#result + 1] = {
                    name = name,
                    slot = v.slot or 0,
                    amount = tonumber(v.amount or v.count or v.quantity) or 0,
                    metadata = v.metadata or v.info or {},
                }
            end
        end
    end

    if #result == 0 and not warnedAboutShape then
        warnedAboutShape = true
        Log.warning('origen_inventory:getInventory returned no readable slots - the item format may have changed', inventoryData)
    end

    return result
end

local function getPlayerItemsCount(src)
    local slots = getInventorySlots(src)

    if not slots then
        return false
    end

    local items = {}

    for _, v in ipairs(slots) do
        items[v.name] = (items[v.name] or 0) + v.amount
    end

    return items
end

local function getPlayerInventory(src)
    local slots = getInventorySlots(src)

    if not slots then
        return false
    end

    local items = {}

    for _, v in ipairs(slots) do
        table.insert(items, {
            item = v.name,
            slot = v.slot,
            quantity = v.amount,
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
            if not exports['origen_inventory']:addItem(src, item, 1, metadata) then
                return false
            end
        end

        return true
    end

    return exports['origen_inventory']:addItem(src, item, amount, metadata)
end

local function removePlayerItem(src, item, amount)
    return exports['origen_inventory']:removeItem(src, item, amount)
end

local function getSpecificPlayerItem(src, data)
    local slots = getInventorySlots(src)

    if not slots then
        return false
    end

    for _, item in ipairs(slots) do
        if item.name == data.item and item.slot == data.slot then
            return {
                item = item.name,
                metadata = item.metadata,
            }
        end
    end

    return false
end

local function removeSpecificPlayerItem(src, data, amount)
    return exports['origen_inventory']:removeItem(src, data.item, amount, false, data.slot)
end

local function setMetadata(src, data, metadata)
    exports['origen_inventory']:AddItemMetadata(src, data.item, data.slot, metadata)

    return true
end

local function canCarryItem(src, item, amount)
    return exports['origen_inventory']:CanCarryItem(src, item, amount)
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
