local authorizedPlayers = {}

local function isIdentifierAllowed(src)
    if src == 0 then
        return Config.AllowConsole == true
    end

    if Config.UseAcePermission and IsPlayerAceAllowed(src, Config.AcePermission) then
        return true
    end

    local allowed = {}
    for _, identifier in ipairs(Config.AllowedIdentifiers or {}) do
        allowed[string.lower(identifier)] = true
    end

    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if allowed[string.lower(identifier)] then
            return true
        end
    end

    return false
end

RegisterCommand(Config.Command, function(source)
    if source == 0 then
        print(('[%s] /%s is an in-game developer command.'):format(GetCurrentResourceName(), Config.Command))
        return
    end

    if not isIdentifierAllowed(source) then
        TriggerClientEvent('hf1_propdev:client:denied', source)
        return
    end

    authorizedPlayers[source] = true
    TriggerClientEvent('hf1_propdev:client:toggle', source)
end, false)

-- Client asks again on resource start so the client never decides its own permissions.
RegisterNetEvent('hf1_propdev:server:requestAuthorization', function()
    local src = source
    authorizedPlayers[src] = isIdentifierAllowed(src)
    TriggerClientEvent('hf1_propdev:client:setAuthorization', src, authorizedPlayers[src])
end)

AddEventHandler('playerDropped', function()
    authorizedPlayers[source] = nil
end)
