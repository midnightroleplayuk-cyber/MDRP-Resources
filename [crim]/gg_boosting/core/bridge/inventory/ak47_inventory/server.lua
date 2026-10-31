gg.inventory = gg.inventory or {}

gg.inventory.canCarryitem = function(src, data)
    return exports['ak47_inventory']:CanAddItem(src, data.item, data.count)
end

gg.inventory.hasItem = function(src, data)
    local item = exports['ak47_inventory']:GetItem(src, data.item, nil, false)
    return item and item.count >= data.count
end

gg.inventory.addItem = function(src, data)
    data.count = data?.count or 1

    local success = gg.inventory.canCarryitem(src, data)
    if not success then
        return success
    end

    local success = exports['ak47_inventory']:AddItem(src, data.item, data.count, data.slot, data.metadata)
    if not success then 
        return success
    end
    return success
end

gg.inventory.removeItem = function(src, data)
    data.count = data?.count or 1

    local success, response = gg.inventory.hasItem(src, data)
    if not success then
        return success, {err = response.err}
    end

    local success = exports['ak47_inventory']:RemoveItem(src, data.item, data.count, data.slot)
    if not success then
        return success
    end
    return success
end

gg.inventory.getItemTable = function(item)
    if not item then return exports['ak47_inventory']:Items() end
    return exports['ak47_inventory']:Items(item) or nil
end

gg.inventory.getImageUrl = function(item)
    return string.format('https://cfx-nui-ak47_inventory/web/images/%s.png', item)
end