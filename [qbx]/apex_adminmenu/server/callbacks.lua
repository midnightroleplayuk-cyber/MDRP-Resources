local ServerSlots = GetConvarInt('sv_maxclients', 48)

lib.callback.register('apex_adminmenu:slotCount', function(source)
    return ServerSlots
end)

-- `menu` names the menu about to open ('QuickMenu'). Config.MenuAccess
-- may keep that one menu closed to a player who is still staff for
-- everything else; the second value tells the client which it was.
lib.callback.register('apex_adminmenu:checkPerms', function(source, menu)
    if not GetPlayer(source) then return false end
    if not AdminPerms(source) then return false end
    if menu and MenuAllowed and not MenuAllowed(source, menu) then return false, 'menu' end
    -- Log admin menu access
    SendDiscordLog(
        "Admin Menu Access",
        "Admin accessed the admin menu",
        {},
        "adminActivity"
    )
    return true
end)

lib.callback.register('apex_adminmenu:players', function(source)
    local players = GetPlayers() or {}
    local SentPlayers = {}
    for i=1, #players do
        -- Every framework's GetPlayers() yields source IDs, but the type
        -- differs (ESX/native = string, QBCore/QBox = number). Coerce so
        -- GetPlayerName / GetIdentifier always receive a real source.
        local src = tonumber(players[i]) or players[i]
        if src then
            SentPlayers[#SentPlayers + 1] = {
                Name = GetPlayerName(src) or ('Player ' .. tostring(src)),
                identifier = GetIdentifier(src),
                Id = src
            }
        end
    end
    local data = { SentPlayers = SentPlayers, PlayerCount = #SentPlayers }
    return data
end)

lib.callback.register('apex_adminmenu:giveMoney', function(source, target, account, amount)
    if not HasActionPermission(source, 'giveMoney') or not GetPlayer(target) then return false end
    AddMoney(target, account, amount)
    return true
end)

lib.callback.register('apex_adminmenu:dropPlayer', function(source, target, reason)
    if not HasActionPermission(source, 'kickPlayers') then return false end
    DropPlayer(target, reason)
    return true
end)

lib.callback.register('apex_adminmenu:banPlayer', function(source, target, time, reason)
    if not HasActionPermission(source, 'banPlayers') or not GetPlayer(target) then return false end
    return BanPlayer(target, time, reason, source)
end)

lib.callback.register('apex_adminmenu:clearinv', function(source, target)
    if not HasActionPermission(source, 'giveItems') then return false end
    target = tonumber(target)
    if not target or not GetPlayer(target) then return false end

    -- Framework-native inventory clear (kept per-framework so we preserve
    -- the original ESX behaviour of also zeroing the money accounts).
    local identifier
    if Framework == 'esx' and ESX then
        local xTarget = ESX.GetPlayerFromId(target)
        if xTarget then
            identifier = xTarget.identifier
            xTarget.setAccountMoney('money', 0)
            xTarget.setAccountMoney('black_money', 0)
            -- Framework-native inventory (no standalone inventory resource).
            for i = 1, #(xTarget.inventory or {}) do
                if xTarget.inventory[i].count > 0 then
                    xTarget.removeInventoryItem(xTarget.inventory[i].name, xTarget.inventory[i].count)
                end
            end
        end
    elseif Framework == 'qb' then
        -- Covers both QBCore and QBox (Framework is 'qb' for both). Guard
        -- the call so a missing ClearInventory on a QBox player object can
        -- never error — the ox/qs branch below does the real work there.
        local player = GetPlayer(target)
        if player then
            if player.Functions and player.Functions.ClearInventory then
                pcall(function() player.Functions.ClearInventory() end)
            end
            if player.PlayerData and player.PlayerData.citizenid then
                MySQL.Async.execute('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode({}), player.PlayerData.citizenid })
            end
        end
    end

    -- Standalone inventory providers — always target the affected PLAYER
    -- (was wrongly clearing `source`, i.e. the admin's own inventory).
    -- Auto-detected in configs/compat.lua: ox, qs, ps, qb, codem, origen,
    -- tgiann, core, mf, chezza.
    Apex.Compat.ClearInventory(target, identifier)

    -- Log inventory clear
    SendDiscordLog(
        "Admin Action: Clear Inventory",
        "Admin cleared a player's inventory",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "moneyActions"
    )
    
    return true
end)

lib.callback.register('apex_adminmenu:freeze', function(source, target, toggle)
    if not AdminPerms(source) then return false end
    -- FreezeEntityPosition is a CLIENT native — calling it here silently
    -- did nothing on every framework. Broadcast the same event
    -- server/events.lua uses (it goes to -1 because the freeze is applied
    -- by whichever client owns the target entity).
    TriggerClientEvent('apex_adminmenu:setPlayerFrozen', -1, target, toggle)
    
    -- Log freeze action
    SendDiscordLog(
        "Admin Action: " .. (toggle and "Freeze" or "Unfreeze"),
        "Admin " .. (toggle and "froze" or "unfroze") .. " a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "playerActions"
    )
end)

lib.callback.register('apex_adminmenu:noclip', function(source, target, toggle)
    if not AdminPerms(source) then return false end
    TriggerClientEvent('apex_adminmenu:noclip', target, toggle)
    
    -- Log noclip action
    SendDiscordLog(
        "Admin Action: NoClip",
        "Admin " .. (toggle and "enabled" or "disabled") .. " noclip for a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "playerActions"
    )
end)

lib.callback.register('apex_adminmenu:giveitem', function(source, target, item, amount)
    if not HasActionPermission(source, 'giveItems') then return false end
    if GetPlayer(target) then
        AddItem(target, item, amount)
        return 'success'
    else
        return 'error'
    end
end)

lib.callback.register('apex_adminmenu:playerdata', function(source, target)
    if not AdminPerms(source) then return false end
    local data = {
        identifier = GetIdentifier(target),
        igname = GetName(target),
        steamname = GetPlayerName(target),
        cash = GetPlayerAccountFunds(target, 'money'),
        bank = GetPlayerAccountFunds(target, 'bank')
    }
    if Framework == 'esx' then data.black_money = GetPlayerAccountFunds(target, 'black_money') end
    return data
end)

lib.callback.register('apex_adminmenu:unban', function(source, targetlicense)
    if not HasActionPermission(source, 'banPlayers') then return false end
    
    -- Get player name before unbanning
    local result = MySQL.query.await('SELECT player FROM apex_bans WHERE license = ?', { targetlicense })
    local playerName = "Unknown"
    if result and #result > 0 then
        playerName = result[1].player
    end
    
    MySQL.query('DELETE FROM apex_bans WHERE license = ?', { targetlicense })
    
    -- Log unban action
    SendDiscordLog(
        "Admin Action: Unban",
        "Admin unbanned a player",
        {
            {name = "Player", value = playerName, inline = true},
            {name = "License", value = targetlicense, inline = false}
        },
        "playerActions",
        3066993  -- Green color
    )
    
    return true
end)
