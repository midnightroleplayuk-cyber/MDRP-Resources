local function notify(playerId, message)
    TriggerClientEvent('chat:addMessage', playerId, {
        color = { 255, 200, 80 },
        args = { 'Ped Change', message }
    })
end

RegisterCommand('pedchange', function(source, args)
    if source == 0 then
        print('[admin-pedchange] This command must be used in-game.')
        return
    end

    if not IsPlayerAceAllowed(source, 'group.admin') then
        notify(source, 'You do not have permission to use this command.')
        return
    end

    local targetId = tonumber(args[1])
    if not targetId or targetId < 1 or targetId % 1 ~= 0 then
        notify(source, 'Usage: /pedchange [player ID]')
        return
    end

    if not GetPlayerName(targetId) then
        notify(source, 'That player is not online.')
        return
    end

    local success, err = pcall(function()
        -- op-clothing manages this permission; it may persist depending on its implementation.
        exports['op-clothing']:GrantCustomPedPermission(targetId)
        exports['op-clothing']:OpenCharacterCreator(targetId, {
            allowCancel = true,
            allowModelChange = true
        })
    end)

    if not success then
        print(('[hf1_pedset] Failed for %s: %s'):format(targetId, tostring(err)))
        notify(source, 'Could not open the creator. Check the server console.')
        return
    end

    notify(source, ('Opened character creator with custom ped access for ID %d.'):format(targetId))
end, false)
