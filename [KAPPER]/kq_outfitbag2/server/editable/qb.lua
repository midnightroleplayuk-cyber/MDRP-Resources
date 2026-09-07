if Config.qbSettings.enabled then
    
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem(Config.bagItem, function(source)
        TriggerClientEvent('kq_outfitbag2:client:place', source, Config.bagItem, Config.bagItem)
    end)

    for k, item in pairs(Config.additionalItems) do
        QBCore.Functions.CreateUseableItem(item, function(source)
            TriggerClientEvent('kq_outfitbag2:client:place', source, item, item)
        end)
    end

    function RemoveBagItem(player, item)
        if item ~= Config.bagItem and not Contains(Config.additionalItems, item) then
            return
        end
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        xPlayer.Functions.RemoveItem(item, 1)
    end

    function AddPlayerItem(player, item)
        if item ~= Config.bagItem and not Contains(Config.additionalItems, item) then
            return
        end

        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        xPlayer.Functions.AddItem(item, 1)
    end

    function _GetPlayerIdentifier(player)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))

        return xPlayer.PlayerData.citizenid
    end
end
