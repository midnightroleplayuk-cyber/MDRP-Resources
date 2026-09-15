local function init()
    while GetResourceState('qb-inventory') ~= 'started' do
        Wait(100)
    end

    QBCore = QBCore or exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem(PortableBenchOptions.item, function(src, item)
        TriggerEvent('nextgenfivem_crafting:usePortableBench', src, {
            item = item.name,
            slot = item.slot,
        })
    end)

    RegisterNetEvent('qb-inventory:server:useItem', function(item)
        local src = source

        -- Check if item has benchType metadata
        local metadata = item.info
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

        if QBCore and QBCore.Shared and QBCore.Shared.Items then
            for k,v in pairs(QBCore.Shared.Items) do
                if k and v and type(v) == "table" then
                    table.insert(items, {
                        name = k,
                        label = v.label or k,
                        description = v.description or '',
                        image = (v.image and v.image:match('^%w+://') and v.image)
                            or (v.image and ('nui://qb-inventory/html/images/' .. v.image))
                            or '',
                        unique = v.unique or false
                    })
                else
                    Log.error('Invalid item data in QBCore.Shared.Items: ' .. tostring(k), v)
                end
            end
        else
            Log.error('Failed to retrieve items from QBCore.Shared.Items')
        end
    end

    return items
end

local function getPlayerItemsCount(src)
    local player = QBCore.Functions.GetPlayer(src)

    if not player then
        return false
    end

    local inventory = player.PlayerData.items

    if not inventory then
        return false
    end

    local items = {}

    for _,v in pairs(inventory) do
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
    local player = QBCore.Functions.GetPlayer(src)

    if not player then
        return false
    end

    local inventory = player.PlayerData.items

    if not inventory then
        return false
    end

    local items = {}

    for _,v in pairs(inventory) do
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
    local player = QBCore.Functions.GetPlayer(src)

    if not player then
        return false
    end

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
            if not exports['qb-inventory']:AddItem(src, item, 1, false, metadata or false, 'nextgenfivem_crafting:addPlayerItem') then
                return false
            end
        end
    else
        local res = exports['qb-inventory']:AddItem(src, item, amount, false, metadata or false, 'nextgenfivem_crafting:addPlayerItem')

        if not res then
            return false
        end
    end

    if QBCore.Shared.Items[item] then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
    end

    if Player(src).state.inv_busy then
        TriggerClientEvent('qb-inventory:client:updateInventory', src)
    end

    return true
end

local function removePlayerItem(src, item, amount)
    local player = QBCore.Functions.GetPlayer(src)

    if not player then
        return false
    end

    local res = exports['qb-inventory']:RemoveItem(src, item, amount, false, 'nextgenfivem_crafting:removePlayerItem')

    if res then
        if QBCore.Shared.Items[item] then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', amount)
        end

        if Player(src).state.inv_busy then
            TriggerClientEvent('qb-inventory:client:updateInventory', src)
        end
    end

    return res
end

local function getSpecificPlayerItem(src, data)
    local player = QBCore.Functions.GetPlayer(src)

    if not player then
        return false
    end

    local item = exports['qb-inventory']:GetItemBySlot(src, data.slot)

    if not item then
        return false
    end

    return {
        item = item.name,
        metadata = item.info,
    }
end

local function removeSpecificPlayerItem(src, data, amount)
    local player = QBCore?.Functions.GetPlayer(src)

    if not player then
        return false
    end

    local res = exports['qb-inventory']:RemoveItem(src, data.item, amount, data.slot, 'nextgenfivem_crafting:removePlayerItem')

    if res then
        if QBCore.Shared.Items[data.item] then
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], 'remove', amount)
        end

        if Player(src).state.inv_busy then
            TriggerClientEvent('qb-inventory:client:updateInventory', src)
        end
    end

    return res
end

local function setMetadata(src, data, metadata)
    local player = QBCore.Functions.GetPlayer(src)

    if not player then
        return false
    end

    local item = player.PlayerData.items[data.slot]

    if not item or item.name ~= data.item then
        return false
    end

    item.info = metadata

    player.Functions.SetPlayerData("items", player.PlayerData.items)

    if Player(src).state.inv_busy then
        TriggerClientEvent('inventory:client:UpdatePlayerInventory', src, false)
    end

    return true
end

local missingCanAddExport

local function canCarryItem(src, item, amount)
    if missingCanAddExport == nil then
        local status = pcall(function()
            return exports['qb-inventory'].CanAddItem
        end)

        if not status then
            missingCanAddExport = true
        else
            missingCanAddExport = false
        end
    end

    if missingCanAddExport then
        return true
    end

    local canAdd, reason = exports['qb-inventory']:CanAddItem(src, item, amount)

    return canAdd
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
