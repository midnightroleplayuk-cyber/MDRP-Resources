
function server.getPlayer(source)
    return server.framework.GetPlayerFromId(source)
end

function server.getPlayerIdentifier(source)
    local xPlayer = server.getPlayer(source)
    if xPlayer then return xPlayer.getIdentifier() end
    return nil
end

function server.getPlayerCharacterName(source)
    local xPlayer = server.getPlayer(source)
    if xPlayer then return xPlayer.getName() end
    return nil
end

function server.playerAddMoney(source, account, amount)
    local xPlayer = server.getPlayer(source)
    if xPlayer then
        account = (account == 'cash') and 'money' or account
        return xPlayer.addAccountMoney(account, tonumber(amount))
    end
    return false
end

function server.playerRemoveMoney(source, account, amount)
    local xPlayer = server.getPlayer(source)
    if xPlayer then return xPlayer.removeAccountMoney(account, tonumber(amount)) end
    return false
end

function server.getPlayerBalance(source, account)
    account = (account == 'cash') and 'money' or account
    local xPlayer = server.getPlayer(source)
    return tonumber(xPlayer.getAccount(account).money)
end

function server.getPlayerJob(source)
    local xPlayer = server.getPlayer(source)
    if not xPlayer or not xPlayer.getJob then return nil end
    return xPlayer.getJob()
end

function server.getPlayerGang(source)
    return {}
end

function server.createUseableItem(item, callback)
    server.framework.RegisterUsableItem(item, callback)
end

function server.setPlayerMeta(source, key, value)
    local xPlayer = server.getPlayer(source)
    if not xPlayer.setMeta then return false end
    if value == nil then return xPlayer.clearMeta(key) end
    return xPlayer.setMeta(key, value)
end

function server.getPlayerMeta(source, key)
    local xPlayer = server.getPlayer(source)
    if not xPlayer.getMeta then return false end
    return xPlayer.getMeta(key)
end
