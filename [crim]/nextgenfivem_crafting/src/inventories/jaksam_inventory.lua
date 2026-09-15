local function init()
    while GetResourceState('jaksam_inventory') ~= 'started' do
        Wait(100)
    end

    exports.jaksam_inventory:registerUsableItem(PortableBenchOptions.item, function(src, name, item)
        TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
            item = item.name,
            slot = item.slot,
        })

        return true
    end)
end

local items = nil

local function getItems()
    if items then return items end

    items = {}

    local itemList = exports.jaksam_inventory:getStaticItemsList()

    if not itemList then
        Log.error('Failed to retrieve items from jaksam_inventory')
        return items
    end

    for name, itemData in pairs(itemList) do
        if type(itemData) == 'table' then
            items[#items + 1] = {
                name = name,
                label = itemData.label or name,
                description = itemData.description or '',
                weight = itemData.weight or 0,
                image = (itemData.image and itemData.image:match('^%w+://') and itemData.image)
                    or (itemData.image and ('nui://jaksam_inventory/_images/' .. itemData.image))
                    or '',
                unique = itemData.unique or false,
            }
        end
    end

    if #items == 0 then
        Log.error('Failed to build item list for jaksam_inventory')
    end

    return items
end

local function getPlayerItemsCount(src)
    local inventory = exports.jaksam_inventory:getInventory(src)
    if not inventory or not inventory.items then return false end

    local result = {}

    for _, itemData in pairs(inventory.items) do
        if itemData and itemData.name and itemData.amount then
            result[itemData.name] = (result[itemData.name] or 0) + itemData.amount
        end
    end

    return result
end

local function getPlayerInventory(src)
    local inventory = exports.jaksam_inventory:getInventory(src)
    if not inventory or not inventory.items then return false end

    local result = {}

    for slot, itemData in pairs(inventory.items) do
        if itemData and itemData.name then
            local slotNumber = itemData.slot or slot
            if type(slotNumber) == 'string' then
                slotNumber = tonumber(slotNumber:match('%d+')) or slotNumber
            end

            table.insert(result, {
                item = itemData.name,
                slot = slotNumber,
                quantity = itemData.amount or 0,
                metadata = itemData.metadata or {},
            })
        end
    end

    return result
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

    return exports.jaksam_inventory:addItem(src, item, amount, metadata)
end

local function removePlayerItem(src, item, amount)
    return exports.jaksam_inventory:removeItem(src, item, amount)
end

local function getSpecificPlayerItem(src, data)
    local itemData = exports.jaksam_inventory:getItemFromSlot(src, data.slot)

    if not itemData then
        return false
    end

    return {
        item = itemData.name or data.item,
        metadata = itemData.metadata or {},
    }
end

local function removeSpecificPlayerItem(src, data, amount)
    return exports.jaksam_inventory:removeItem(src, data.item, amount, nil, data.slot)
end

local function setMetadata(src, data, metadata)
    local success = exports.jaksam_inventory:setItemMetadataInSlot(src, data.slot, metadata)
    return success and true or false
end

local function canCarryItem(src, item, amount)
    local success, canCarry = pcall(function()
        return exports.jaksam_inventory:canCarryItem(src, item, amount)
    end)

    if not success then
        return true
    end

    return canCarry
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
