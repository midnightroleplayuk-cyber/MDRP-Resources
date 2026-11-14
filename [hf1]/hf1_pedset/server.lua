local function notify(src, message, kind)
    TriggerClientEvent('HF1-Pedset:notify', src, message, kind or 'inform')
end

RegisterCommand('pedchange', function(source, args)
    if source == 0 then
        print('[HF1-Pedset] Run /pedchange in-game.')
        return
    end

    -- group.admin is a principal; check a permission granted to that principal.
    if not IsPlayerAceAllowed(source, 'HF1-Pedset.use') then
        print(('[HF1-Pedset] Permission denied for player %d'):format(source))
        notify(source, 'You do not have permission to use /pedchange.', 'error')
        return
    end

    local target = tonumber(args[1])
    if not target or target < 1 or target % 1 ~= 0 then
        notify(source, 'Usage: /pedchange [server ID]', 'error')
        return
    end
    if not GetPlayerName(target) then
        notify(source, 'That player is not online.', 'error')
        return
    end
    if GetResourceState('op-clothing') ~= 'started' then
        print('[HF1-Pedset] ERROR: op-clothing is not started')
        notify(source, 'op-clothing is not running. Check server console.', 'error')
        return
    end

    local granted, grantErr = pcall(function()
        exports['op-clothing']:GrantCustomPedPermission(target)
    end)
    if not granted then
        print(('[HF1-Pedset] GrantCustomPedPermission failed: %s'):format(tostring(grantErr)))
        notify(source, 'Custom ped permission failed. Check server console.', 'error')
        return
    end

    local opened, openErr = pcall(function()
        exports['op-clothing']:OpenCharacterCreator(target, {
            allowCancel = true,
            allowModelChange = true
        })
    end)
    if not opened then
        print(('[HF1-Pedset] OpenCharacterCreator failed: %s'):format(tostring(openErr)))
        notify(source, 'Character creator failed. Check server console.', 'error')
        return
    end

    print(('[HF1-Pedset] Admin %d requested creator for player %d (custom peds enabled)'):format(source, target))
    notify(source, ('Requested character creator for player %d.'):format(target), 'success')
end, false)
