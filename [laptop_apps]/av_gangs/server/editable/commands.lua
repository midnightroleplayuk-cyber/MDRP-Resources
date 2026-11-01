lib.addCommand(Config.AdminCommand, {
    help = 'AV Gangs Admin Panel',
    params = {},
    restricted = Config.AdminLevel
}, function(source)
    TriggerClientEvent('av_gangs:openAdmin',source)
end)

if Config.GraffitiXP then
   lib.addCommand(Config.GraffitiXP, {
        help = 'AV Gangs Graffitis XP',
        params = {},
        restricted = Config.AdminLevel
    }, function(source)
        syncGraffitis(source)
    end)
end
