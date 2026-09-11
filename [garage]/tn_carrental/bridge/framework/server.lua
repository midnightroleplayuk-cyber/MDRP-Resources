Bridge = Bridge or {}
Bridge.Framework = Bridge.Framework or {}

local ESX, QBCore = nil, nil
local currentFramework = 'standalone'

local function init()
    if (Config.Framework == 'qbox' and GetResourceState('qbx_core') == 'started') or (Config.Framework == 'qbx' and GetResourceState('qbx_core') == 'started') or (Config.Framework == 'auto' and GetResourceState('qbx_core') == 'started') then
        currentFramework = 'qbox'
        return
    end

    if (Config.Framework == 'esx' and GetResourceState('es_extended') == 'started') or (Config.Framework == 'auto' and GetResourceState('es_extended') == 'started') then
        ESX = exports.es_extended:getSharedObject()
        currentFramework = 'esx'
        return
    end

    if (Config.Framework == 'qb' and GetResourceState('qb-core') == 'started') or (Config.Framework == 'auto' and GetResourceState('qb-core') == 'started') then
        QBCore = exports['qb-core']:GetCoreObject()
        currentFramework = 'qb'
        return
    end

    currentFramework = 'standalone'
end

init()

function Bridge.Framework.GetName()
    return currentFramework
end

function Bridge.Framework.GetCore()
    if currentFramework == 'esx' then return ESX end
    if currentFramework == 'qb' then return QBCore end
    if currentFramework == 'qbox' then return exports.qbx_core end
end

function Bridge.Framework.GetIdentifier(source)
    if currentFramework == 'qbox' then
        local player = exports.qbx_core:GetPlayer(source)
        return player and player.PlayerData and player.PlayerData.citizenid
    end

    if currentFramework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier
    end

    if currentFramework == 'qb' then
        local player = QBCore.Functions.GetPlayer(source)
        return player and player.PlayerData.citizenid
    end

    return ('license:%s'):format(source)
end

function Bridge.Framework.GetPlayerName(source)
    if currentFramework == 'qbox' then
        local player = exports.qbx_core:GetPlayer(source)
        if player and player.PlayerData then
            local char = player.PlayerData.charinfo or {}
            local fullName = ('%s %s'):format(char.firstname or '', char.lastname or ''):gsub('^%s*(.-)%s*$', '%1')
            if fullName ~= '' then return fullName end
            return player.PlayerData.name
        end
    elseif currentFramework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.getName then return xPlayer.getName() end
    elseif currentFramework == 'qb' then
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            local char = player.PlayerData.charinfo or {}
            return ('%s %s'):format(char.firstname or '', char.lastname or ''):gsub('^%s*(.-)%s*$', '%1')
        end
    end

    return GetPlayerName(source) or 'Unbekannt'
end

local function accountForPayment(method)
    if method == 'cash' then return Config.PaymentAccounts.cash or 'money' end
    if method == 'card' then return Config.PaymentAccounts.card or 'bank' end
    return nil
end

local function qbMoneyAccount(account)
    return account == 'money' and 'cash' or account
end

function Bridge.Framework.RemoveMoney(source, amount, method)
    if amount <= 0 then return true end
    local requestedAccount = accountForPayment(method)

    if currentFramework == 'qbox' then
        local account = qbMoneyAccount(requestedAccount or Config.PaymentAccounts.card or 'bank')
        local balance = exports.qbx_core:GetMoney(source, account)
        if not balance or balance < amount then return false end
        return exports.qbx_core:RemoveMoney(source, account, amount, 'vehicle-rental') == true
    end

    if currentFramework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end

        if requestedAccount == 'money' then
            if xPlayer.getMoney() >= amount then
                xPlayer.removeMoney(amount)
                return true
            end
            return false
        end

        if requestedAccount then
            local requestedData = xPlayer.getAccount(requestedAccount)
            if requestedData and requestedData.money >= amount then
                xPlayer.removeAccountMoney(requestedAccount, amount)
                return true
            end
            return false
        end

        local account = Config.PaymentAccounts.card or 'bank'
        local accountData = xPlayer.getAccount(account)

        if accountData and accountData.money >= amount then
            xPlayer.removeAccountMoney(account, amount)
            return true
        end

        return false
    end

    if currentFramework == 'qb' then
        local player = QBCore.Functions.GetPlayer(source)
        if not player then return false end

        if requestedAccount then
            local qbAccount = qbMoneyAccount(requestedAccount)
            local balance = player.PlayerData.money[qbAccount] or 0
            if balance >= amount then
                player.Functions.RemoveMoney(qbAccount, amount, 'vehicle-rental')
                return true
            end
            return false
        end

        local primary = Config.PaymentAccounts.card or 'bank'
        local primaryMoney = player.PlayerData.money[primary] or 0

        if primaryMoney >= amount then
            player.Functions.RemoveMoney(primary, amount, 'vehicle-rental')
            return true
        end

        return false
    end

    return true
end

function Bridge.Framework.AddMoney(source, amount)
    if amount <= 0 then return end

    if currentFramework == 'qbox' then
        exports.qbx_core:AddMoney(source, qbMoneyAccount(Config.PaymentAccounts.refund or Config.PaymentAccounts.card or 'bank'), amount, 'vehicle-rental-refund')
    elseif currentFramework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then xPlayer.addAccountMoney(Config.PaymentAccounts.refund or Config.PaymentAccounts.card or 'bank', amount) end
    elseif currentFramework == 'qb' then
        local player = QBCore.Functions.GetPlayer(source)
        if player then player.Functions.AddMoney(Config.PaymentAccounts.refund or Config.PaymentAccounts.card or 'bank', amount, 'vehicle-rental-refund') end
    end
end

function Bridge.Framework.Notify(source, message, type)
    local system = Config.Notify or 'auto'

    if system == 'auto' then
        if GetResourceState('ox_lib') == 'started' then
            system = 'ox_lib'
        elseif currentFramework == 'qbox' then
            system = 'ox_lib'
        elseif currentFramework == 'qb' then
            system = 'qb'
        elseif currentFramework == 'esx' then
            system = 'esx'
        else
            system = 'native'
        end
    end

    if system == 'ox_lib' and GetResourceState('ox_lib') == 'started' then
        TriggerClientEvent('ox_lib:notify', source, {
            title       = 'Car Rental',
            description = message,
            type        = type or 'inform'
        })
    elseif system == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, message, type or 'primary')
    elseif system == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message)
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'Car Rental', message } })
    end
end
