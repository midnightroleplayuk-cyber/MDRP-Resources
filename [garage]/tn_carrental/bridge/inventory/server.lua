Bridge = Bridge or {}
Bridge.Inventory = Bridge.Inventory or {}

local function getInventory()
    if Config.Inventory ~= 'auto' then return Config.Inventory end

    if GetResourceState('ox_inventory') == 'started' then
        return 'ox_inventory'
    end

    if Bridge.Framework and Bridge.Framework.GetName and Bridge.Framework.GetName() == 'qb' then
        return 'qb'
    end

    return 'none'
end

function Bridge.Inventory.AddRentalPaper(source, metadata)
    local inventory = getInventory()
    if inventory == 'none' then return false end

    if inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(source, Config.RentalPaperItem, 1, metadata)
    end

    if inventory == 'qb' then
        local QBCore = Bridge.Framework and Bridge.Framework.GetCore and Bridge.Framework.GetCore()
        local player = QBCore and QBCore.Functions.GetPlayer(source)
        if player then
            player.Functions.AddItem(Config.RentalPaperItem, 1, false, metadata)
            if QBCore.Shared.Items[Config.RentalPaperItem] then
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.RentalPaperItem], 'add')
            end
            return true
        end
    end

    return false
end

function Bridge.Inventory.RegisterRentalPaperUse()
    local inventory = getInventory()
    if inventory == 'none' then return end

    -- ox_inventory: item use is handled client-side via exports (see bridge/inventory/client.lua)
    -- QB: register useable item server-side
    if inventory == 'qb' then
        local QBCore = Bridge.Framework and Bridge.Framework.GetCore and Bridge.Framework.GetCore()
        if QBCore then
            QBCore.Functions.CreateUseableItem(Config.RentalPaperItem, function(source, item)
                local meta = (item and item.info) or {}
                TriggerEvent('tn_carrental:server:playerUsedPaperInternal', source, meta)
            end)
        end
    end
end
