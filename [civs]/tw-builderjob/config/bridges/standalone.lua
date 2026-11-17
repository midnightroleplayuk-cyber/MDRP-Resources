
local function loadCore()
    return {
        name = 'standalone',
        version = '1.0.0',
    }
end

local server = {}

local function getPlayer(source)
    if not StandalonePlayers then return nil end
    local player = StandalonePlayers[source]
    if player then return player end

    local identifier = GetPlayerIdentifierByType(source, 'license')
    local playerName = GetPlayerName(source)
    if identifier and playerName then
        StandalonePlayers[source] = {
            source = source,
            identifier = identifier,
            name = playerName,
            money = { cash = 5000, bank = 10000 },
        }
        return StandalonePlayers[source]
    end
    return nil
end

function server.GetPlayer(source)
    return getPlayer(source)
end

function server.GetIdentifier(source)
    local id = GetPlayerIdentifierByType(source, 'license')
    if id then return id end
    local p = getPlayer(source)
    return p and p.identifier or nil
end

function server.GetName(source)
    local n = GetPlayerName(source)
    if n then return n end
    local p = getPlayer(source)
    return p and p.name or 'Unknown'
end

function server.GetMoney(source, accountType)
    local p = getPlayer(source)
    if p and p.money[accountType] then return p.money[accountType] end
    return 0
end

function server.AddMoney(source, accountType, value)
    value = tonumber(value)
    if not value or value <= 0 then
        print(('^1[bridge:standalone] AddMoney FAILED — invalid amount (%s)^7')
            :format(tostring(value)))
        return false
    end
    local p = getPlayer(source)
    if not p then
        print(('^1[bridge:standalone] AddMoney FAILED — player not found (src=%s)^7')
            :format(tostring(source)))
        return false
    end
    if p.money[accountType] == nil then
        print(('^1[bridge:standalone] AddMoney FAILED — unknown account type "%s" '
            .. '(check Config.MoneyAccount). NOT PAID: %s^7')
            :format(tostring(accountType), tostring(value)))
        return false
    end
    p.money[accountType] = p.money[accountType] + value
    return true
end

function server.RemoveMoney(source, accountType, value)
    value = tonumber(value)
    if not value or value <= 0 then return false end
    local p = getPlayer(source)
    if not (p and p.money[accountType]) then return false end
    if p.money[accountType] < value then return false end
    p.money[accountType] = p.money[accountType] - value
    return true
end

function server.GetRawInventory(_source)
    return {}
end

TworstBridge.register({
    name = 'standalone',
    accepts = { 'standalone' },
    loadCore = loadCore,
    server = server,
})
