-- ------------------------------------------------------------------------------
-- Framework / Server / QBCore
-- ------------------------------------------------------------------------------

local function qbAccount(account)
    if account == 'money' then return 'cash' end
    return account or 'cash'
end

local function bind()
    if not Fr.ShouldBind('qb') then return false end
    if GetResourceState('qb-core') ~= 'started' then return false end
    -- Prefer qbox when both are present.
    if GetResourceState('qbx_core') == 'started' and (not Config.Framework or Config.Framework == 'auto') then
        return false
    end

    Config.Framework = 'qb'
    QBCore = true
    Framework = exports['qb-core']:GetCoreObject()

    Fr.GetPlayerObject = function(src)
        return Framework.Functions.GetPlayer(src)
    end

    Fr.GetIdentifier = function(src)
        local Player = Framework.Functions.GetPlayer(src)
        return Player and Player.PlayerData.citizenid or nil
    end

    Fr.GetPlayerName = function(src)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player then return GetPlayerName(src) or 'Unknown' end
        local ci = Player.PlayerData.charinfo or {}
        return ('%s %s'):format(ci.firstname or '', ci.lastname or '')
    end

    Fr.GetGender = function(src)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player then return 'male' end
        local ci = Player.PlayerData.charinfo or {}
        return (ci.gender == 1 or ci.gender == 'f') and 'female' or 'male'
    end

    Fr.HasMoney = function(src, account, amount)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        local money = Player.PlayerData and Player.PlayerData.money or {}
        return (tonumber(money[qbAccount(account)]) or 0) >= amount
    end

    Fr.RemoveMoney = function(src, account, amount)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        local ok = Player.Functions.RemoveMoney(qbAccount(account), amount, 'op-clothing')
        return ok and true or false
    end

    Fr.AddMoney = function(src, account, amount)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        return Player.Functions.AddMoney(qbAccount(account), amount, 'op-clothing')
    end

    Fr.GetJob = function(src)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player or not Player.PlayerData.job then return nil, 0 end
        return Player.PlayerData.job.name, tonumber(Player.PlayerData.job.grade and Player.PlayerData.job.grade.level) or 0
    end

    Fr.GetGang = function(src)
        local Player = Framework.Functions.GetPlayer(src)
        if not Player or not Player.PlayerData.gang then return nil, 0 end
        return Player.PlayerData.gang.name, tonumber(Player.PlayerData.gang.grade and Player.PlayerData.gang.grade.level) or 0
    end

    Fr.GetGroup = function(src)
        return Framework.Functions.GetPermission(src)
    end

    Fr.BindRegisterServerCallback(function(name, fn)
        Framework.Functions.CreateCallback(name, function(source, cb, ...)
            local ok, result = pcall(fn, source, ...)
            if not ok then
                print(('^1 callback %s failed: %s^0'):format(tostring(name), tostring(result)))
                cb(nil)
                return
            end
            cb(result)
        end)
    end)

    Fr.MarkReady('qb')
    return true
end

CreateThread(function()
    if not Fr.ShouldBind('qb') then return end
    if bind() then return end
    if not Fr.WaitForResource('qb-core', 60000) then
        if Fr.ShouldBind('qb') then
            print('^1 qb-core did not start — purchases will fail.^0')
        end
        return
    end
    bind()
end)
