lib.addCommand(Config.AdminCommand, {
    help = "Open the admin panel to manage music",
    params = {},
    restricted = Config.AdminGroups
}, function(source, args, raw)
    -- Open the admin panel to manage music
    TriggerClientEvent("av_music:openAdminPanel", source)
end)

function isAdmin(playerId) -- Used for admin panel actions
    local result = IsPlayerAceAllowed(playerId, ('command.%s'):format(Config.AdminCommand)) -- run the default admin check
    dbug("isAdmin(result)", result)
    return result
end