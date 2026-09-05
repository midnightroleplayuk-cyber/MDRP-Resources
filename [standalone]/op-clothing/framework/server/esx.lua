-- ------------------------------------------------------------------------------
-- Framework / Server / ESX
-- ------------------------------------------------------------------------------

local function bind()
    if not Fr.ShouldBind('esx') then return false end
    if GetResourceState('es_extended') ~= 'started' then return false end

    Config.Framework = 'esx'
    ESX = true
    Framework = exports['es_extended']:getSharedObject()

    Fr.GetPlayerObject = function(src)
        return Framework.GetPlayerFromId(src)
    end

    Fr.GetIdentifier = function(src)
        local xPlayer = Framework.GetPlayerFromId(src)
        return xPlayer and xPlayer.identifier or nil
    end

    Fr.GetPlayerName = function(src)
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return GetPlayerName(src) or 'Unknown' end
        local n = xPlayer.getName and xPlayer.getName() or nil
        return n or (GetPlayerName(src) or 'Unknown')
    end

    Fr.GetGender = function(src)
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return 'male' end
        local sex = xPlayer.get and xPlayer.get('sex') or nil
        return (sex == 'f' or sex == 1) and 'female' or 'male'
    end

    Fr.HasMoney = function(src, account, amount)
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        if account == 'bank' then
            local acc = xPlayer.getAccount and xPlayer.getAccount('bank') or nil
            return acc and (tonumber(acc.money) or 0) >= amount or false
        end
        if xPlayer.getMoney then
            return (tonumber(xPlayer.getMoney()) or 0) >= amount
        end
        local cash = xPlayer.getAccount and xPlayer.getAccount('money') or nil
        return cash and (tonumber(cash.money) or 0) >= amount or false
    end

    Fr.RemoveMoney = function(src, account, amount)
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        if not Fr.HasMoney(src, account, amount) then return false end
        if account == 'bank' then
            xPlayer.removeAccountMoney('bank', amount)
        elseif xPlayer.removeMoney then
            xPlayer.removeMoney(amount)
        else
            xPlayer.removeAccountMoney('money', amount)
        end
        return true
    end

    Fr.AddMoney = function(src, account, amount)
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        if account == 'bank' then
            xPlayer.addAccountMoney('bank', amount)
        elseif xPlayer.addMoney then
            xPlayer.addMoney(amount)
        else
            xPlayer.addAccountMoney('money', amount)
        end
        return true
    end

    Fr.GetJob = function(src)
        local xPlayer = Framework.GetPlayerFromId(src)
        if not xPlayer or not xPlayer.job then return nil, 0 end
        return xPlayer.job.name, tonumber(xPlayer.job.grade) or 0
    end

    Fr.GetGroup = function(src)
        local xPlayer = Framework.GetPlayerFromId(src)
        return xPlayer and xPlayer.getGroup and xPlayer.getGroup() or nil
    end

    Fr.BindRegisterServerCallback(function(name, fn)
        Framework.RegisterServerCallback(name, function(source, cb, ...)
            local ok, result = pcall(fn, source, ...)
            if not ok then
                print(('^1 callback %s failed: %s^0'):format(tostring(name), tostring(result)))
                cb(nil)
                return
            end
            cb(result)
        end)
    end)

    Fr.MarkReady('esx')
    return true
end

CreateThread(function()
    if not Fr.ShouldBind('esx') then return end
    if bind() then return end
    if not Fr.WaitForResource('es_extended', 60000) then
        if Fr.ShouldBind('esx') then
            print('^1 es_extended did not start — purchases will fail.^0')
        end
        return
    end
    bind()
end)
