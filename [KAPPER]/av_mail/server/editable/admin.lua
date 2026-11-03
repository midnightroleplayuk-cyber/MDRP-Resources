lib.addCommand(Config.AdminCommand, {
    help = 'AV Mail Admin Panel',
    params = {},
    restricted = Config.AdminGroups
}, function(source)
    TriggerClientEvent("av_mail:openAdmin", source)
end)

function isAdmin(playerId) -- Used for admin panel actions
    local result = IsPlayerAceAllowed(playerId, ('command.%s'):format(Config.AdminCommand)) -- run the default admin check
    dbug("isAdmin(result)", result)
    return result
end