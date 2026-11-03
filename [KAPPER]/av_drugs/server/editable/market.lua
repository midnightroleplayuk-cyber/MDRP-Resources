local limit = {}

RegisterServerEvent('av_drugs:buy', function(data)
    if not data or not (data['name'] or not data['amount']) then return end
    local src = source
    local identifier = exports['av_laptop']:getIdentifier(src)
    local item = data['name']
    local amount = data['amount']
    local canBuy = true
    local price = Config.Market[item] and Config.Market[item]['price'] or false
    local account = Config.Market[item] and Config.Market[item]['account'] or false
    local max = Config.Market[item] and Config.Market[item]['max'] or false
    limit[identifier] = limit[identifier] or {}
    if max then
        local today = limit[identifier] and limit[identifier][item] or 0
        if today >= max then
            TriggerClientEvent('av_laptop:notificationUI',src,Lang['app_title'], Lang['daily_limit'], 'error')
            return
        end
    end
    if not price or not tonumber(price) then
        print("Item "..item.." doesn't have a valid price, check your Config.Market!")
        print("Item "..item.." doesn't have a valid price, check your Config.Market!")
        print("Item "..item.." doesn't have a valid price, check your Config.Market!")
        return
    end
    if not account then
        print("Item "..item.." doesn't have a valid account, check your Config.Market!")
        print("Item "..item.." doesn't have a valid account, check your Config.Market!")
        print("Item "..item.." doesn't have a valid account, check your Config.Market!")
        return
    end
    local hasMoney = exports['av_laptop']:getMoney(src, account)
    if hasMoney then
        local total = price * amount
        if tonumber(hasMoney) >= total then
            exports['av_laptop']:removeMoney(src, account, total)
            allOrders[identifier] = allOrders[identifier] or {}
            local index = #allOrders[identifier] + 1
            allOrders[identifier][index] = {
                name = item,
                amount = amount
            }
            TriggerClientEvent('av_drugs:marketBlip', src)
            save('market')
            limit[identifier][item] = limit[identifier][item] or 0
            limit[identifier][item] += amount
        else
            TriggerClientEvent('av_laptop:notificationUI', src, Lang['app_title'], Lang['no_money'], 'error')
        end
    else
        print("Account "..account.." doesn't exist in your Framework, this is NOT a script problem, verify your Config and Framework Accounts.")
        print("Account "..account.." doesn't exist in your Framework, this is NOT a script problem, verify your Config and Framework Accounts.")
        print("Account "..account.." doesn't exist in your Framework, this is NOT a script problem, verify your Config and Framework Accounts.")
    end
end)

RegisterServerEvent('av_drugs:getDelivery', function()
    local src = source
    local identifier = exports['av_laptop']:getIdentifier(src)
    local delivered = false
    dbug("getDelivery for "..identifier)
    if allOrders[identifier] then
        for k, v in pairs(allOrders[identifier]) do
            local metadata = Config.Market[v['name']] and Config.Market[v['name']]['setMetadata'] or false
            if metadata and type(metadata) == "function" then
                metadata = metadata(src,identifier)
            end
            dbug("addItem:", v['name'], v['amount'], json.encode(metadata))
            exports['av_laptop']:addItem(src, v['name'], v['amount'], metadata)
            delivered = true
        end
        allOrders[identifier] = nil
        save('market')
    end
    if not delivered then
        TriggerClientEvent('av_laptop:notification',src, Lang['door_title'], Lang['nothing'], 'inform')
    end
end)