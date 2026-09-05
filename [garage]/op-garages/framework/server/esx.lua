ESX = GetResourceState('es_extended') == 'started' and true or false

if not ESX then return end

Fr = {}

Framework = exports["es_extended"]:getSharedObject()
Fr.usersTable = "users"
Fr.identificatorTable = "identifier"

Fr.Table = 'owned_vehicles'
Fr.VehProps = 'vehicle'
Fr.OwnerTable = "owner"
Fr.StoredTable = "stored"

Fr.PlayerLoaded = 'esx:playerLoaded'
Fr.IsPlayerDead = function(source)
    return Player(source).state.isDead
end
Fr.RegisterServerCallback = function(...)
    return Framework.RegisterServerCallback(...)
end
Fr.GetPlayerFromIdentifier = function(identifier)
    return Framework.GetPlayerFromIdentifier(identifier)
end
Fr.getPlayerFromId = function(...)
    return Framework.GetPlayerFromId(...)
end
Fr.GetMoney = function(xPlayer, account)
    return xPlayer.getAccount(account).money
end
Fr.ManageMoney = function(xPlayer, account, action, amount)
    if action == "add" then
        return xPlayer.addAccountMoney(account, amount)
    else
        return xPlayer.removeAccountMoney(account, amount)
    end
end
Fr.GetIndentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.identifier
end
Fr.GetPlayerName = function(sourceOrIdentifier)
    local xPlayer = Fr.getPlayerFromId(sourceOrIdentifier)
    local name

    if xPlayer then
        name = xPlayer.name
        if name == GetPlayerName(Fr.GetSourceFromPlayerObject(xPlayer)) then
            name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
        end
    else
        local result = MySQL.Sync.fetchAll(
            "SELECT firstname, lastname, identifier FROM users WHERE identifier = @identifier",
            {['@identifier'] = trim(sourceOrIdentifier)}
        )
        if result and result[1] then
            name = result[1].firstname .. " " .. result[1].lastname
        else
            name = "Unknown"
        end
    end

    return name
end
Fr.GetGroup = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return "Admin" end
    return xPlayer.getGroup()
end
Fr.GetSourceFromPlayerObject = function(xPlayer)
    if xPlayer then
        return xPlayer.source
    else
        return nil
    end
end
Fr.GetPlayerJob = function(xPlayer)
    local job = {
        name = xPlayer.job.name,
        grade = xPlayer.job.grade
    }
    return job
end
Fr.GetPlayerGang = function(xPlayer)
    if GetResourceState('op-crime') == 'started' then
        local xSource = Fr.GetSourceFromPlayerObject(xPlayer)
        local ident = Fr.GetIndentifier(xSource)
        local havePerms = exports['op-crime']:checkPermissions(ident, "garage_access")
        local grade = 0

        if Config.ReverseGradeCheck then 
            if havePerms then 
                grade = 50
            else
                grade = 0
            end
        else
            if havePerms then 
                grade = 0
            else
                grade = 50
            end
        end

        local gang = {
            name = tostring(Player(xSource).state.gangId),
            grade = grade,
        }
        return gang
    elseif GetResourceState('rcore_gangs') == 'started' then
        local xSource = Fr.GetSourceFromPlayerObject(xPlayer)
        local gang = exports.rcore_gangs:GetPlayerGang(xSource)
        if not gang then return {} end

        return {
            name = gang.name,
            grade = 0
        }
    else
        local gang = {
            name = xPlayer.job.name,
            grade = xPlayer.job.grade
        }
        return gang
    end
end
Fr.RegisterItem = function(itemName, itemEvent)
    Framework.RegisterUsableItem(itemName, function(playerId)
        local xPlayer = Fr.getPlayerFromId(playerId)
        TriggerClientEvent('op-garages:'.. itemEvent, Fr.GetSourceFromPlayerObject(xPlayer))
    end)
end
Fr.getInventory = function(xPlayer)
    return xPlayer.getInventory()
end
Fr.addItem = function(xPlayer, itemname, quantity)
    quantity = tonumber(quantity) or 0
    itemname = tostring(itemname)

    if quantity <= 0 then
        quantity = 1
    end

    return xPlayer.addInventoryItem(itemname, quantity)
end
Fr.removeItem = function(xPlayer, itemname, quantity)
    quantity = tonumber(quantity) or 0
    itemname = tostring(itemname)

    if quantity <= 0 then
        quantity = 1
    end

    return xPlayer.removeInventoryItem(itemname, quantity)
end