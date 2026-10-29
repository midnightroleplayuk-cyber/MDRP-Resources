
local function loadCore()
    local object = nil
    local ok = pcall(function() exports['core']:getCoreObject() end)
    if ok then
        local tries = 0
        while not object do
            object = exports['core']:getCoreObject()
            tries = tries + 1
            if tries == 3 then break end
            Citizen.Wait(1000)
        end
    end
    if not object then
        print('^1[tw-builderjob][bridge:tmc]^7 framework object not retrievable - check that the TMC "core" resource starts before tw-builderjob')
    end
    return object
end

local server = {}

function server.GetPlayer(source)
    return Core and Core.Functions and Core.Functions.GetPlayer(source) or false
end

local warnedIdentifier = false

function server.GetIdentifier(source)
    local Player = server.GetPlayer(source)
    local cid = Player and Player.PlayerData and Player.PlayerData.citizenid
    if cid then return cid end
    if not Player then return nil end
    if not warnedIdentifier then
        warnedIdentifier = true
        print('^3[bridge:tmc] PlayerData.citizenid is missing - falling back to the license identifier^7')
    end
    return GetPlayerIdentifierByType(source, 'license')
end

function server.GetName(source)
    local Player = server.GetPlayer(tonumber(source))
    if not Player then return '0' end
    if Player.Functions and Player.Functions.GetFullName then
        local ok, name = pcall(Player.Functions.GetFullName)
        if ok and type(name) == 'string' and name ~= '' then return name end
    end
    local info = Player.PlayerData and Player.PlayerData.charinfo
    if info then
        return (info.firstname or 'Unknown') .. ' ' .. (info.lastname or '')
    end
    return GetPlayerName(source) or '0'
end

function server.GetMoney(source, accountType)
    local Player = server.GetPlayer(source)
    if not Player then return 0 end
    local money = Player.PlayerData and Player.PlayerData.money
    if type(money) == 'table' and type(money[accountType]) == 'number' then
        return money[accountType]
    end
    return math.huge
end

function server.AddMoney(source, accountType, value, reason)
    local Player = server.GetPlayer(source)
    if not (Player and Player.Functions) then
        print(('^1[bridge:tmc] AddMoney FAILED - player not found (src=%s, %s, %s)^7')
            :format(tostring(source), tostring(accountType), tostring(value)))
        return false
    end
    if accountType ~= 'bank' and accountType ~= 'cash' then
        print(('^1[bridge:tmc] AddMoney FAILED - invalid account type "%s" (use bank or cash '
            .. 'in Config.MoneyAccount). Payment NOT MADE: %s^7')
            :format(tostring(accountType), tostring(value)))
        return false
    end
    local ok = Player.Functions.AddMoney(accountType, value, reason)
    return ok ~= false
end

function server.RemoveMoney(source, accountType, value)
    local Player = server.GetPlayer(source)
    if not (Player and Player.Functions and Player.Functions.RemoveMoney) then return false end
    if accountType ~= 'bank' and accountType ~= 'cash' then return false end
    value = tonumber(value)
    if not value or value <= 0 then return false end
    return Player.Functions.RemoveMoney(accountType, value, 'tw-builderjob') == true
end

function server.GetRawInventory(source)
    local Player = server.GetPlayer(source)
    if Player and Player.PlayerData and Player.PlayerData.items then
        return Player.PlayerData.items
    end
    return {}
end

TworstBridge.register({
    name = 'tmc',
    accepts = { 'tmc' },
    loadCore = loadCore,
    server = server,
})
