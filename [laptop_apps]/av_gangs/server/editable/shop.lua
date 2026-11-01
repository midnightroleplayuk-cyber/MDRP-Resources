local cooldowns = {}
local closeToRestart = false

CreateThread(function()
    local temp_cooldowns = LoadResourceFile('av_gangs', 'json/cooldown.json')
    cooldowns = temp_cooldowns and json.decode(temp_cooldowns) or {}
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    closeToRestart = true
end)

lib.callback.register('av_gangs:getPrices', function(source, name)
    local sprayPrice = Config.Prices['spray']
    local removerPrice = Config.Prices['remover']
    local count = getGraffitis(name)
    if count >= 1 then
        sprayPrice = (sprayPrice * Config.SprayMultiplier * count)
    end
    return {spray = Round(sprayPrice), remover = removerPrice}
end)

RegisterServerEvent('av_gangs:buyItem', function(data)
    dbug('av_gangs:buyItem')
    if closeToRestart then
        TriggerClientEvent('av_laptop:notification',source,'Shop', 'We are close for today, come back tomorrow', 'error')
        return
    end
    local src = source
    local gang = data.gang
    local item = data.item
    local price = data.price
    cooldowns[gang] = cooldowns[gang] or {}
    cooldowns[gang][item] = cooldowns[gang][item] or false
    local hoursDiff = getDiff(cooldowns[gang][item])
    dbug('hoursDiff', hoursDiff)
    if not cooldowns[gang][item] or (hoursDiff and hoursDiff >= Config.ItemCooldown[item]) then
        local myMoney = exports['av_laptop']:getMoney(src, Config.ShopAccount)
        if myMoney >= price then
            local info = {}
            info.gang = gang
            info.expiration = exports['av_laptop']:addMinutes(Config.SprayTime * 60)
            exports['av_laptop']:removeMoney(src, Config.ShopAccount, price)
            exports['av_laptop']:addItem(src,item,1,info)
            cooldowns[gang][item] = os.time()
            SaveResourceFile(GetCurrentResourceName(), 'json/cooldown.json', json.encode(cooldowns), -1)
        else
            TriggerClientEvent('av_laptop:notification',src,Lang['gang_shop'],Lang['no_money'],"error")
        end
    else
        TriggerClientEvent('av_laptop:notification',src,Lang['gang_shop'],Lang['spray_limit'],"error")
    end
end)

function getDiff(time)
    if not time then return false end
    local seconds = os.time() - time
    local diff = seconds / 3600
    return math.floor(diff)
end