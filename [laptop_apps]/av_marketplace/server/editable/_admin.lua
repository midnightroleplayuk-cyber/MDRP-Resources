lib.addCommand(Config.AdminCommand, {
    help = 'AV Marketplace Admin Panel',
    params = {},
    restricted = Config.AdminLevel
}, function(source)
    TriggerClientEvent("av_marketplace:openAdmin", source)
end)

function isAdmin(playerId) -- Used for admin panel actions
    local result = IsPlayerAceAllowed(playerId, ('command.%s'):format(Config.AdminCommand)) -- run the default admin check
    dbug("isAdmin(result)", result)
    return result
end