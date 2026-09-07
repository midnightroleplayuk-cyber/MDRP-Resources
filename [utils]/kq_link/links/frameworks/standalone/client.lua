if Link.framework ~= 'none' and Link.framework ~= 'standalone' then
    return
end

function GetPlayerJob()
    return nil
end

function GetItemCount(item)
    return 1000
end

function GetPlayerInventory()
    return {}
end

function GetInventoryItems()
    return {}
end

function GetInventoryImagePath()
    return '', 'png'
end
