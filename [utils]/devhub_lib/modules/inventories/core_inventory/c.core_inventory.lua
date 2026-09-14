if Shared.InventorySystem ~= "core_inventory" then return end  
local allItems = nil
Core.GetItemData = function(itemName) 
    if not allItems then
        allItems = exports['core_inventory']:getItemsList()
    end
    local data = allItems[itemName]
    return { 
        name = itemName,
        label = data?.label or itemName,
        img = ('nui://core_inventory/html/img/%s.png'):format(itemName),
    }
end

RegisterNetEvent('onEquipWeapon', function(currentWeapon)
    --TODO if you have this inventory and need help, open a ticket  

    -- local metadata = data?.metadata
    -- TriggerEvent("devhub_lib:client:currentWeapon", {
    --     weapon = data.name,
    --     metadata = metadata,
    -- })
end)

RegisterNetEvent('onUnEquipWeapon', function(currentWeapon)
    TriggerEvent("devhub_lib:client:currentWeapon")
end)

LoadedSystems['inventory'] = true