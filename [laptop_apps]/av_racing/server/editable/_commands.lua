lib.addCommand(Config.AdminCommand, {
    help = 'AV Racing Admin Panel',
    params = {},
    restricted = Config.AdminLevel
}, function(source)
    openAdmin(source)
end)

RegisterCommand("racing:wipe", function(source)
    if source and tonumber(source) > 0 then
        warn("/racing:wipe > This command can only be used in TxAdmin live console")
        return
    end
    MySQL.update.await("UPDATE `av_racing_profiles` SET `races` = 0, `wins` = 0, `elo` = 0", {})
    print("All your racers victories, elo and wins got wiped correctly.")
end,true)