-- Event handlers

AddEventHandler('ox_inventory:updateInventory', function(changes) -- triggered when player inventory gets updated
    if not LocalPlayer.state.inLaptop then return end
    local count = exports.ox_inventory:Search('count', Config.LaptopItem)
    if not count or count == 0 and LocalPlayer.state.inLaptop then
        TriggerEvent('av_laptop:close')
        TriggerEvent('av_racing:notifications', false)
    end
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(player)
    if not LocalPlayer.state.inLaptop then return end
    if Config.Inventory == "ox_inventory" then return end
    local items = player['items']
    if not items then return end
end)