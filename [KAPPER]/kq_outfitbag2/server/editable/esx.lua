if Config.esxSettings.enabled then
    ESX = nil
    
    if Config.esxSettings.useNewESXExport then
        ESX = exports['es_extended']:getSharedObject()
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

    ESX.RegisterUsableItem(Config.bagItem, function(source)
        TriggerClientEvent('kq_outfitbag2:client:place', source, Config.bagItem, Config.bagItem)
    end)

    for k, item in pairs(Config.additionalItems) do
        ESX.RegisterUsableItem(item, function(source)
            TriggerClientEvent('kq_outfitbag2:client:place', source, item)
        end)
    end

    function RemoveBagItem(player, item)
        if item ~= Config.bagItem and not Contains(Config.additionalItems, item) then
            return
        end

        local xPlayer = ESX.GetPlayerFromId(player)
        xPlayer.removeInventoryItem(item, 1)
    end

    function AddPlayerItem(player, item)
        if item ~= Config.bagItem and not Contains(Config.additionalItems, item) then
            return
        end

        local xPlayer = ESX.GetPlayerFromId(player)
        xPlayer.addInventoryItem(item, 1)
    end

    function _GetPlayerIdentifier(player)
        local xPlayer = ESX.GetPlayerFromId(player)

        return xPlayer.identifier
    end
end
