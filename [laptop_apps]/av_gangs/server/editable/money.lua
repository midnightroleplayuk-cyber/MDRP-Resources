function getMoney(playerId,gang)
    local money = 0
    money = exports['av_laptop']:getMoney(playerId, Config.MoneyAccount)
    dbug('getMoney(playerId, gang, money)', playerId, gang, money)
    return money
end

function removeMoney(playerId,gang,amount)
    dbug('removeMoney(playerId, gang, amount)', playerId, gang, amount)
    -- You can replace this export with your own removemoney export from your banking script
    exports['av_laptop']:removeMoney(playerId, Config.MoneyAccount, amount)

    -- Don't remove this, we will use it to update money in UI:
    local updatedMoney = getMoney(playerId,gang)
    TriggerClientEvent('av_gangs:listeners', playerId, "updateMoney", updatedMoney)
end

function addMoney(playerId,gang,amount)
    dbug('addMoney(playerId, gang, amount)', playerId, gang, amount)
    exports['av_laptop']:addMoney(playerId, Config.MoneyAccount, amount)

    -- Don't remove this, we will use it to update money in UI:
    local updatedMoney = getMoney(playerId,gang)
    TriggerClientEvent('av_gangs:listeners', playerId, "updateMoney", updatedMoney)
end