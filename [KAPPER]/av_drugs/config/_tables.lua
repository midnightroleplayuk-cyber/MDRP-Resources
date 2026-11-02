-- Table items and more config is in server/editable/_items.lua
Config = Config or {}
Config.TableRender = 50.0 -- Distance for table object render
Config.ProgressType = "progressCircle" -- progress type used for ox progressbar (progressBar or progressCircle)
Config.PlacingTime = 10000 -- time to place a table in ms (10000 = 10 seconds)
Config.RemovingTime = 10000 -- time to remove a table in ms (10000 = 10 seconds)
Config.WipeStashOnRemove = true -- wipe a table stash if the table gets removed (not destroyed), prevents using tables as mobile stashes
Config.MaxTablesPerPlayer = 1 -- Max tables the same player can place at the same time, keep it low otherwise too many entities spawned close will take too much CPU
Config.RemoveTablesAfter = 7 -- Remove placed tables that have X days without cooking, perfect for tables placed by players who doesn't play the sv anymore
Config.Animation = { -- Animation used after input menu
    dict = "anim@amb@business@coc@coc_unpack_cut@",
    animation = "fullcut_cycle_v6_cokepacker",
    duration = 10000 -- in ms (10 seconds)
}
Config.PlayerCooldown = 30 -- Player won't be able to cook in any table for X time or false if u don't want players cooldown