gg.inventory = gg.inventory or {}

gg.inventory.canCarryitem = function(src, data)
    return exports.origen_inventory:canCarryItem(src, data.item, data.count, data.metadata)
end

gg.inventory.hasItem = function(src, data)
    local inventory = exports.origen_inventory:getInventory(src)
    if not inventory then
        return false, {err = "Failed to get inventory"}
    end
    local count = 0
    for k,v in pairs(inventory) do
        if v.name == data.item then
            count = count + v.count
        end
    end

    if count < data.count then
        return false, {err = "You do not have enough of this item"}
    end

    return true
end

gg.inventory.addItem = function(src, data)
    data.count = data?.count or 1
    local success = gg.inventory.canCarryitem(src, data)
    if not success then
        return success
    end
    local success = exports.origen_inventory:addItem(src, data.item, data.count, data.metadata, data.slot, false)
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

    local success = exports.origen_inventory:removeItem(src, data.item, data.count, data.metadata, data.slot, false)
    if not success then
        return success, {err = "Failed to remove item"}
    end
    return success
end

gg.inventory.getItemTable = function(item)
    if not item then return gg.framework.GetItemData() end
    return gg.framework.GetItemData(item) or nil
end

gg.inventory.getImageUrl = function(item)
    return string.format('https://cfx-nui-origen_inventory/html/images/%s.png', item)
end