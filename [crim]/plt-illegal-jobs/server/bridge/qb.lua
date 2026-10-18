
function server.getPlayer(source)
    return server.framework.Functions.GetPlayer(source)
end

function server.getPlayerIdentifier(source)
    local xPlayer = server.getPlayer(source)
    if xPlayer then return xPlayer.PlayerData.citizenid end
    return nil
end

function server.getPlayerCharacterName(source)
    local xPlayer = server.getPlayer(source)
    if xPlayer then
        return (xPlayer.PlayerData.charinfo.firstname or '') .. ' ' .. (xPlayer.PlayerData.charinfo.lastname or '')
    end
    return nil
end

function server.playerAddMoney(source, account, amount)
    local xPlayer = server.getPlayer(source)
    if xPlayer then return xPlayer.Functions.AddMoney(account, tonumber(amount)) end
    return false
end

function server.playerRemoveMoney(source, account, amount)
    local xPlayer = server.getPlayer(source)
    if xPlayer then return xPlayer.Functions.RemoveMoney(account, tonumber(amount)) end
    return false
end

function server.getPlayerBalance(source, account)
    local xPlayer = server.getPlayer(source)
    if not xPlayer or not xPlayer.PlayerData then return 0 end
    return xPlayer.PlayerData.money[account] or 0
end

function server.getPlayerJob(source)
    local xPlayer = server.getPlayer(source)
    if not xPlayer or not xPlayer.PlayerData then return nil end
    return xPlayer.PlayerData.job
end

function server.getPlayerGang(source)
    local xPlayer = server.getPlayer(source)
    if not xPlayer or not xPlayer.PlayerData then return nil end
    return xPlayer.PlayerData.gang
end

function server.createUseableItem(item, callback)
    server.framework.Functions.CreateUseableItem(item, callback)
end

function server.setPlayerMeta(source, key, value)
    local xPlayer = server.getPlayer(source)
    return xPlayer.Functions.SetMetaData(key, value)
end

function server.getPlayerMeta(source, key)
    local xPlayer = server.getPlayer(source)
    return xPlayer.PlayerData.metadata[key]
end
