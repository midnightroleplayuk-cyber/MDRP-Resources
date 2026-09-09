Dispatch = Dispatch or {}

Dispatch['default'] = {
    alert = function(coords, message)
        local serverPlayers = GetPlayers()
        for k, v in pairs(serverPlayers) do
            local sourcePlayer = GetPlayer(v)
            if sourcePlayer then
                if GetActiveFramework() == 'qb' then
                    for _, x in pairs(Config.AmbulanceJobs) do
                        if sourcePlayer.PlayerData.job.name == x then
                            TriggerClientEvent('hospital:client:ambulanceAlert', sourcePlayer.PlayerData.source, coords, message)
                        end
                    end
                else
                    for _, x in pairs(Config.AmbulanceJobs) do
                        if sourcePlayer.job.name == x then
                            TriggerClientEvent('hospital:client:ambulanceAlert', v, coords, message)
                        end
                    end
                end
            end
        end
    end
}
