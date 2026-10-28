
local function loadCore()
    local object = nil
    local fw = Config.Framework

    if fw == 'qb' then
        local counter = 0
        local status = pcall(function() exports['qb-core']:GetCoreObject() end)
        if status then
            while not object do
                object = exports['qb-core']:GetCoreObject()
                counter = counter + 1
                if counter == 3 then break end
                Citizen.Wait(1000)
            end
        end
    elseif fw == 'oldqb' then
        local counter = 0
        while not object do
            counter = counter + 1
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            if counter == 3 then break end
            Citizen.Wait(1000)
        end
    end

    if not object then
        print(('^1[tw-builderjob][bridge:%s]^7 framework object not retrievable — check that qb-core is started and Config.Framework is correct'):format(fw))
    end
    return object
end

local server = {}

function server.GetPlayer(source)
    return Core and Core.Functions and Core.Functions.GetPlayer(source) or false
end

function server.GetIdentifier(source)
    local Player = server.GetPlayer(source)
    return Player and Player.PlayerData and Player.PlayerData.citizenid or nil
end

function server.GetName(source)
    local Player = server.GetPlayer(tonumber(source))
    if Player and Player.PlayerData and Player.PlayerData.charinfo then
        return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    end
    return '0'
end

function server.GetMoney(source, accountType)
    local Player = server.GetPlayer(source)
    if not (Player and Player.PlayerData and Player.PlayerData.money) then return 0 end
    return Player.PlayerData.money[accountType] or 0
end

function server.AddMoney(source, accountType, value, reason)
    local Player = server.GetPlayer(source)
    if not (Player and Player.Functions) then
        print(('^1[bridge:qb] AddMoney FAILED — player not found (src=%s, %s, %s)^7')
            :format(tostring(source), tostring(accountType), tostring(value)))
        return false
    end
    if accountType ~= 'bank' and accountType ~= 'cash' then
        print(('^1[bridge:qb] AddMoney FAILED — invalid account type "%s" (QBCore only accepts bank/cash; '
            .. 'check the Config.MoneyAccount/CurrencySymbol value). Payment NOT MADE: %s^7')
            :format(tostring(accountType), tostring(value)))
        return false
    end
    local ok = Player.Functions.AddMoney(accountType, value, reason)
    return ok ~= false
end

function server.RemoveMoney(source, accountType, value)
    local Player = server.GetPlayer(source)
    if Player and Player.Functions and (accountType == 'bank' or accountType == 'cash') then
        return Player.Functions.RemoveMoney(accountType, value)
    end
    return false -- no player/account = no money was deducted
end

function server.GetRawInventory(source)
    local Player = server.GetPlayer(source)
    if Player and Player.PlayerData and Player.PlayerData.items then
        return Player.PlayerData.items
    end
    return {}
end

TworstBridge.register({
    name = 'qb',
    accepts = { 'qb', 'oldqb', 'qbox', 'qbx' },
    loadCore = loadCore,
    server = server,
})
