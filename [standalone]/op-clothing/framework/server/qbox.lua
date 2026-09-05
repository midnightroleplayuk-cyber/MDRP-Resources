-- ------------------------------------------------------------------------------
-- Framework / Server / QBox
-- ------------------------------------------------------------------------------

local function qbAccount(account)
    if account == 'money' then return 'cash' end
    return account or 'cash'
end

local function getPlayer(src)
    return Framework:GetPlayer(src)
end

local function bind()
    if not Fr.ShouldBind('qbox') then return false end
    if GetResourceState('qbx_core') ~= 'started' then return false end

    Config.Framework = 'qbox'
    QBX = true
    Framework = exports.qbx_core

    Fr.GetPlayerObject = getPlayer

    Fr.GetIdentifier = function(src)
        local Player = getPlayer(src)
        return Player and Player.PlayerData.citizenid or nil
    end

    Fr.GetPlayerName = function(src)
        local Player = getPlayer(src)
        if not Player then return GetPlayerName(src) or 'Unknown' end
        local ci = Player.PlayerData.charinfo or {}
        return ('%s %s'):format(ci.firstname or '', ci.lastname or '')
    end

    Fr.GetGender = function(src)
        local Player = getPlayer(src)
        if not Player then return 'male' end
        local ci = Player.PlayerData.charinfo or {}
        return (ci.gender == 1 or ci.gender == 'f') and 'female' or 'male'
    end

    Fr.HasMoney = function(src, account, amount)
        local Player = getPlayer(src)
        if not Player then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        local money = Player.PlayerData and Player.PlayerData.money or {}
        return (tonumber(money[qbAccount(account)]) or 0) >= amount
    end

    Fr.RemoveMoney = function(src, account, amount)
        local Player = getPlayer(src)
        if not Player then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        return Player.Functions.RemoveMoney(qbAccount(account), amount, 'op-clothing')
    end

    Fr.AddMoney = function(src, account, amount)
        local Player = getPlayer(src)
        if not Player then return false end
        amount = tonumber(amount) or 0
        if amount <= 0 then return true end
        return Player.Functions.AddMoney(qbAccount(account), amount, 'op-clothing')
    end

    Fr.GetJob = function(src)
        local Player = getPlayer(src)
        if not Player or not Player.PlayerData.job then return nil, 0 end
        return Player.PlayerData.job.name, tonumber(Player.PlayerData.job.grade and Player.PlayerData.job.grade.level) or 0
    end

    Fr.GetGang = function(src)
        local Player = getPlayer(src)
        if not Player or not Player.PlayerData.gang then return nil, 0 end
        return Player.PlayerData.gang.name, tonumber(Player.PlayerData.gang.grade and Player.PlayerData.gang.grade.level) or 0
    end

    Fr.GetGroup = function(src)
        local Player = getPlayer(src)
        return Player and Player.PlayerData.group or nil
    end

    Fr.BindRegisterServerCallback(function(name, fn)
        if lib and lib.callback then
            lib.callback.register(name, function(source, ...)
                local ok, result = pcall(fn, source, ...)
                if not ok then
                    print(('^1 callback %s failed: %s^0'):format(tostring(name), tostring(result)))
                    return nil
                end
                return result
            end)
            return
        end
        print(('^1 ox_lib missing — cannot register callback %s^0'):format(tostring(name)))
    end)

    Fr.MarkReady('qbox')
    return true
end

CreateThread(function()
    if not Fr.ShouldBind('qbox') then return end
    if bind() then return end
    if not Fr.WaitForResource('qbx_core', 60000) then
        if Fr.ShouldBind('qbox') then
            print('^1 qbx_core did not start — purchases will fail.^0')
        end
        return
    end
    bind()
end)
