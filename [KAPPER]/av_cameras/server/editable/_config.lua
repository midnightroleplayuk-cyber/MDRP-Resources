Config = Config or {}
-- Every x hours the script will check all cameras and reduce battery by the amount set in "BatteryToReduce" for each camera that is not plugged in
-- It will also check for random damage based on the "damageChance" value set for each item in _items.lua, for RP purposes
Config.MasterLoopTime = 60 -- in minutes, how often the master loop should run, which checks for battery and random damage, set to false to disable
Config.BatteryToReduce = 2 -- how much battery to reduce every loop, in percentage (from 100% to 0 in 48 loops with this setting and default MasterLoopTime)
Config.MaxDamagedCamerasPerLoop = 5 -- Max cameras that can get damaged each loop
Config.MaxGroupsPerPlayer = 20 -- max groups per player, to prevent spam on database
Config.OnRestartReset = {
    battery = false, -- if true, all camera batteries will be reset to 100% on server restart
    damage = false -- if true, all cameras will be online and undamaged on server restart
}