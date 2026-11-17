
local function loadCore()
    local object = nil
    local Proxy = nil
    local attempts = 0

    while not object do
        if not Proxy then
            pcall(function() Proxy = module('vrp', 'lib/Proxy') end)
        end
        if Proxy then
            local ok, iface = pcall(function() return Proxy.getInterface('vRP') end)
            if ok and iface then
                object = iface
                break
            end
        end
        if type(vRP) == 'table' then
            object = vRP
            break
        end

        attempts = attempts + 1
        if attempts == 10 then
            print("^3[tw-builderjob][bridge:vrp2]^7 vRP interface still not available after 10s — make sure the vrp resource is started and your fork exposes Passport/GenerateItem.")
        end
        Citizen.Wait(1000)
    end
    return object
end

local function waitForVrp()
    while vRP == nil do Wait(100) end
end

local server = {}

function server.GetPlayer(source)
    waitForVrp()
    if not vRP.Passport then return false end
    local Player = nil
    local retries = 0
    while not Player and retries < 50 do
        Player = vRP.Passport(source)
        if not Player then
            Wait(100)
            retries = retries + 1
        end
    end
    return Player
end

function server.GetIdentifier(source)
    local Player = server.GetPlayer(source)
    return Player and tostring(Player) or nil
end

function server.GetName(source)
    waitForVrp()
    local Player = server.GetPlayer(source)
    if Player and vRP.FullName then
        local name = vRP.FullName(Player)
        if name then return name end
    end
    return 'Firstname Lastname'
end

function server.GetMoney(source, _accountType)
    waitForVrp()
    local Player = server.GetPlayer(source)
    if not (Player and vRP.InventoryItemAmount) then return 0 end
    local amount = vRP.InventoryItemAmount(Player, 'dollar')
    return amount and amount[1] or 0
end

function server.AddMoney(source, _accountType, value)
    waitForVrp()
    local Player = server.GetPlayer(source)
    if not (Player and vRP.GenerateItem) then
        print(('^1[bridge:vrp2] AddMoney FAILED — player or vRP.GenerateItem missing '
            .. '(src=%s, %s)^7'):format(tostring(source), tostring(value)))
        return false
    end
    vRP.GenerateItem(Player, 'dollar', value, true)
    return true
end

function server.RemoveMoney(source, _accountType, value)
    waitForVrp()
    local Player = server.GetPlayer(source)
    if Player and vRP.TakeItem then
        local ok = vRP.TakeItem(Player, 'dollar', value)
        return ok and true or false
    end
    return false
end

function server.GetRawInventory(source)
    return {}
end

TworstBridge.register({
    name = 'vrp2',
    accepts = { 'vrp2' },
    loadCore = loadCore,
    server = server,
})
