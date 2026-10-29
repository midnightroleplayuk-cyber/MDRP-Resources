
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
            print("^3[tw-builderjob][bridge:vrp]^7 vRP interface still not available after 10s — make sure '@vrp/lib/utils.lua' is in fxmanifest and the vrp resource is started.")
        end
        Citizen.Wait(1000)
    end

    if object then
        local hasV1Api = pcall(function() return type(object.getUserId) end)
        if not hasV1Api or type(object.getUserId) ~= 'function' then
            print('^1[tw-builderjob][bridge:vrp]^7 ============================================================')
            print("^1[tw-builderjob][bridge:vrp]^7 ImagicTheCat-vRP2 (or unsupported vRP fork) detected.")
            print("^1[tw-builderjob][bridge:vrp]^7 Config.Framework = 'vrp' supports vRP1-family forks only.")
            print("^1[tw-builderjob][bridge:vrp]^7 If you use a custom vRP2 fork (Passport/GenerateItem API),")
            print("^1[tw-builderjob][bridge:vrp]^7 set Config.Framework = 'vrp2' instead.")
            print("^1[tw-builderjob][bridge:vrp]^7 Disabling tw-builderjob to avoid runtime errors.")
            print('^1[tw-builderjob][bridge:vrp]^7 ============================================================')
            Config.Framework = 'unsupported'
            return nil
        end
    end
    return object
end

local server = {}

function server.GetPlayer(source)
    return vRP and vRP.getUserId and vRP.getUserId(source) or false
end

function server.GetIdentifier(source)
    local user_id = vRP and vRP.getUserId and vRP.getUserId(source)
    return user_id and tostring(user_id) or nil
end

function server.GetName(source)
    if not (vRP and vRP.getUserId) then return 'Firstname Lastname' end
    local user_id = vRP.getUserId(source)
    if not user_id then return 'Firstname Lastname' end

    local identity = vRP.getUserIdentity(user_id)
    if not identity then return 'Firstname Lastname' end

    local firstName, lastName
    if identity.nome then
        firstName = identity.nome
        lastName  = identity.sobrenome or ''
    elseif identity.firstname then
        firstName = identity.firstname
        lastName  = identity.name or identity.lastname or ''
    elseif identity.first_name then
        firstName = identity.first_name
        lastName  = identity.last_name or identity.surname or ''
    else
        firstName, lastName = 'Firstname', 'Lastname'
    end
    return firstName .. ' ' .. lastName
end

function server.GetMoney(source, accountType)
    if not (vRP and vRP.getUserId) then return 0 end
    local user_id = vRP.getUserId(source)
    if not user_id then return 0 end
    if accountType == 'bank' then return vRP.getBankMoney(user_id) end
    if accountType == 'cash' then return vRP.getMoney(user_id) end
    return 0
end

function server.AddMoney(source, accountType, value)
    if not (vRP and vRP.getUserId) then
        print('^1[bridge:vrp] AddMoney FAILED — vRP proxy not available^7')
        return false
    end
    local user_id = vRP.getUserId(source)
    if not user_id then
        print(('^1[bridge:vrp] AddMoney FAILED — no user_id (src=%s, %s)^7')
            :format(tostring(source), tostring(value)))
        return false
    end
    if accountType == 'bank' then
        vRP.giveBankMoney(user_id, value)
    elseif accountType == 'cash' then
        vRP.giveMoney(user_id, value)
    else
        print(('^1[bridge:vrp] AddMoney FAILED — invalid account type "%s" '
            .. '(bridge accepts bank/cash; check Config.MoneyAccount). NOT PAID: %s^7')
            :format(tostring(accountType), tostring(value)))
        return false
    end
    return true
end

function server.RemoveMoney(source, accountType, value)
    if not (vRP and vRP.getUserId) then return false end
    local user_id = vRP.getUserId(source)
    if not user_id then return false end
    if accountType == 'bank' then return vRP.tryWithdraw(user_id, value) and true or false end
    if accountType == 'cash' then return vRP.tryPayment(user_id, value) and true or false end
    return false
end

function server.GetRawInventory(source)
    if not (vRP and vRP.getUserId) then return {} end
    local user_id = vRP.getUserId(source)
    if not user_id then return {} end
    return vRP.Inventory and vRP.Inventory(user_id) or {}
end

TworstBridge.register({
    name = 'vrp',
    accepts = { 'vrp' },
    loadCore = loadCore,
    server = server,
})
