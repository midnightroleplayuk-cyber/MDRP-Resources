-- Fallback delete for props the client couldn't take ownership of.
-- Only deletes objects that really are attached to the caller's ped.
RegisterNetEvent('rsvx_clearprops:server:delete', function(netIds)
    local src = source
    if type(netIds) ~= 'table' or #netIds > 25 then return end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end

    for _, netId in ipairs(netIds) do
        local obj = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
        if obj ~= 0 and DoesEntityExist(obj)
            and GetEntityType(obj) == 3
            and GetEntityAttachedTo(obj) == ped then
            DeleteEntity(obj)
        end
    end
end)

RegisterCommand(Config.AdminCommand, function(source, args)
    local target = tonumber(args[1])
    if not target or not GetPlayerName(target) then
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { 'Props', 'Usage: /' .. Config.AdminCommand .. ' <server id>' } })
        else
            print('Usage: ' .. Config.AdminCommand .. ' <server id>')
        end
        return
    end
    TriggerClientEvent('rsvx_clearprops:client:force', target)
end, true) -- restricted: needs ace command.clearpropsid
