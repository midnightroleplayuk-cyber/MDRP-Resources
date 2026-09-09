ESX = GetResourceState('es_extended') == 'started' and true or false
QBCore = GetResourceState('qb-core') == 'started' and true or false
QBox = GetResourceState('qbx_core') == 'started' and true or false

Framework = nil
Fr = {}

Citizen.CreateThread(function()
    if ESX then
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
        Fr.addItem = function(xPlayer, itemname, quantity)
            return xPlayer.addInventoryItem(itemname, quantity)
        end
        Fr.ReturnMoneyToOfflineUser = function(identifier, amount)
            local result = MySQL.Sync.fetchAll(
                "SELECT accounts FROM users WHERE identifier = @identifier ",
                {['@identifier '] = trim(identifier)}
            )
            if result and result[1] then
                local moneyObject = json.encode(result[1].accounts)
                moneyObject.money = amount + moneyObject.money
                MySQL.Async.execute("UPDATE `users` SET `accounts` = @newMoney WHERE `identifier` = @identifier", {
                    ['@newMoney'] = json.decode(moneyObject),
                    ['@identifier'] = trim(identifier)
                })
            end
        end
    elseif QBCore or QBox then
        Framework = exports['qb-core']:GetCoreObject()

        Fr.usersTable = "players"
        Fr.identificatorTable = "citizenid"

        Fr.Table = 'player_vehicles'
        Fr.VehProps = 'mods'
        Fr.OwnerTable = "citizenid"
        Fr.StoredTable = 'state'

        Fr.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
        Fr.IsPlayerDead = function(source)
            local Player = Fr.getPlayerFromId(source)
            local isLastStand = Player.PlayerData.metadata["inlaststand"]
            local isDead = Player.PlayerData.metadata["isdead"]
            if isDead and isLastStand then
                return true
            else
                return false
            end
        end
        Fr.RegisterServerCallback = function(...)
            return Framework.Functions.CreateCallback(...)
        end
        Fr.GetPlayerFromIdentifier = function(identifier)
            return Framework.Functions.GetPlayerByCitizenId(identifier)
        end
        Fr.getPlayerFromId = function(...)
            return Framework.Functions.GetPlayer(...)
        end
        Fr.GetMoney = function(Player, account)
            if account == "money" then account = "cash" end
            return Player.PlayerData.money[account]
        end
        Fr.ManageMoney = function(Player, account, action, amount)
            if account == "money" then account = "cash" end
            if action == "add" then
                return Player.Functions.AddMoney(account, amount)
            else
                return Player.Functions.RemoveMoney(account, amount)
            end
        end
        Fr.GetIndentifier = function(source)
            local xPlayer = Fr.getPlayerFromId(source)
            return xPlayer.PlayerData.citizenid
        end
        Fr.GetPlayerName = function(sourceOrIdentifier)
            local xPlayer = Fr.getPlayerFromId(sourceOrIdentifier)
            local name

            if xPlayer then
                name = xPlayer.PlayerData.charinfo.firstname .." ".. xPlayer.PlayerData.charinfo.lastname
            else
                local result = MySQL.Sync.fetchAll(
                    "SELECT charinfo FROM players WHERE citizenid = @citizenid",
                    {['@citizenid'] = trim(sourceOrIdentifier)}
                )
                if result and result[1] then
                    result[1].charinfo = json.decode(result[1].charinfo)
                    name = result[1].charinfo.firstname .. " " .. result[1].charinfo.lastname
                else
                    name = "Unknown"
                end
            end
        
            return name
        end
        Fr.GetGroup = function(source)
            return "Admin"
        end
        Fr.GetSourceFromPlayerObject = function(xPlayer)
            if xPlayer then
                return xPlayer.PlayerData.source
            else
                return nil
            end
        end
        Fr.GetPlayerJob = function(xPlayer)
            local job = {
                name = xPlayer.PlayerData.job.name,
                grade = xPlayer.PlayerData.job.grade.level
            }
            return job
        end
        Fr.addItem = function(xPlayer, itemname, quantity)
            return xPlayer.Functions.AddItem(itemname, quantity)
        end
        Fr.ReturnMoneyToOfflineUser = function(identifier, amount)
            local result = MySQL.Sync.fetchAll(
                "SELECT money FROM players WHERE citizenid = @citizenid",
                {['@citizenid'] = trim(identifier)}
            )
            if result and result[1] then
                local moneyObject = json.encode(result[1].money)
                moneyObject.cash = amount + moneyObject.cash
                MySQL.Async.execute("UPDATE `players` SET `money` = @newMoney WHERE `citizenid` = @citizenid", {
                    ['@newMoney'] = json.decode(moneyObject),
                    ['@citizenid'] = trim(identifier)
                })
            end
        end
    end
end)
