lib.addCommand(Config.AdminCommand, {
    help = "Open the laptop admin panel",
    params = {},
    restricted = Config.AdminGroups,
}, function(source)
    TriggerClientEvent("av_laptop:admin", source)
end)
