
local function loadCore()
    local object = nil
    local fw = Config.Framework

    if fw == 'esx' then
        local counter = 0
        local status = pcall(function() exports['es_extended']:getSharedObject() end)
        if status then
            while not object do
                object = exports['es_extended']:getSharedObject()
                counter = counter + 1
                if counter == 3 then break end
                Citizen.Wait(1000)
            end
        end
    elseif fw == 'oldesx' then
        local counter = 0
        while not object do
            TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            counter = counter + 1
            if counter == 3 then break end
            Citizen.Wait(1000)
        end
    end

    if not object then
        print(('^1[tw-builderjob][bridge:%s]^7 framework object not retrievable — check that es_extended is started and Config.Framework is correct'):format(fw))
    end
    return object
end

local server = {}

function server.GetPlayer(source)
    return Core and Core.GetPlayerFromId and Core.GetPlayerFromId(source) or false
end

function server.GetIdentifier(source)
    local Player = server.GetPlayer(source)
    return Player and Player.getIdentifier and Player.getIdentifier() or nil
end

function server.GetName(source)
    local Player = Core and Core.GetPlayerFromId and Core.GetPlayerFromId(tonumber(source))
    if Player and Player.getName then return Player.getName() end
    return '0'
end

function server.GetMoney(source, accountType)
    local Player = server.GetPlayer(source)
    if not Player then return 0 end
    if accountType == 'bank' then
        return Player.getAccount('bank').money
    elseif accountType == 'cash' then
        return Player.getMoney()
    end
    return 0
end

function server.AddMoney(source, accountType, value)
    local Player = server.GetPlayer(source)
    if not Player then
        print(('^1[bridge:esx] AddMoney FAILED — player not found (src=%s, %s, %s)^7')
            :format(tostring(source), tostring(accountType), tostring(value)))
        return false
    end
    if accountType == 'bank' then
        Player.addAccountMoney('bank', tonumber(value))
    elseif accountType == 'cash' then
        Player.addMoney(value)
    else
        print(('^1[bridge:esx] AddMoney FAILED — invalid account type "%s" '
            .. '(bridge accepts bank/cash; check Config.MoneyAccount). NOT PAID: %s^7')
            :format(tostring(accountType), tostring(value)))
        return false
    end
    return true
end

function server.RemoveMoney(source, accountType, value)
    local Player = server.GetPlayer(source)
    if not Player then return false end
    local bal = (accountType == 'bank') and Player.getAccount('bank').money or Player.getMoney()
    if (tonumber(bal) or 0) < (tonumber(value) or 0) then return false end
    if accountType == 'bank' then
        Player.removeAccountMoney('bank', value)
    elseif accountType == 'cash' then
        Player.removeMoney(value)
    else
        return false
    end
    return true
end

function server.GetRawInventory(source)
    local Player = server.GetPlayer(source)
    if not (Player and Player.getInventory) then return {} end
    return Player.getInventory()
end

TworstBridge.register({
    name = 'esx',
    accepts = { 'esx', 'oldesx' },
    loadCore = loadCore,
    server = server,
})
