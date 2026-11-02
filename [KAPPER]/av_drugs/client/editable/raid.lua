function canRaid() -- return true or false, player will be able to raid this property or false
    -- add your own check, I made mine simple, it checks if player is Cop and has item decrypter
    local isCop = exports['av_laptop']:hasJob(Config.PoliceJobs)
    local hasDecrypted = exports['av_laptop']:hasItem(Config.RaidItem)
    return (isCop and hasDecrypted)
end

function minigame(level)
    TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    Wait(3000)
    local options = Config.Upgrades['security'] and Config.Upgrades['security'][level] or Config.DefaultSecurity
    local finished = false
    local res = false
    dbug("minigame(level, options)", level, json.encode(options, {indent = true}))
    local res = exports['av_alphabet']:start(options['hand'], options['seconds'], options['blocks'])
    dbug("minigame result", res)
    ClearPedTasks(cache.ped)
    return res
end