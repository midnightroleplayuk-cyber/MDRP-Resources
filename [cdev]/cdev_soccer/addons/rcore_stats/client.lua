repeat Wait(0) until statsInited

--- @param gameKey string
RegisterNetEvent("cdev_soccer:client:api:onMatchStart", function(gameKey)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_games_played", 1)
end)

--- @param gameKey string
--- @param scoringTeamId number
RegisterNetEvent("cdev_soccer:client:api:onGoal", function(gameKey, scoringTeamId)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_goals_made", 1)
end)

--- @param gameKey string
RegisterNetEvent("cdev_soccer:client:api:onShot", function(gameKey)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_shots_made", 1)
end)

--- @param gameKey string
--- @param targetPlayerServerId number
RegisterNetEvent("cdev_soccer:client:api:onTackle", function(gameKey, targetPlayerServerId)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_tackles_made", 1)
end)

--- @param gameKey string
RegisterNetEvent("cdev_soccer:client:api:onGameWin", function(gameKey)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_game_wins", 1)
end)

--- @param gameKey string
RegisterNetEvent("cdev_soccer:client:api:onGameLoss", function(gameKey)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_game_losses", 1)
end)

--- @param gameKey string
RegisterNetEvent("cdev_soccer:client:api:onSave", function(gameKey)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_save_made", 1)
end)

--- @param gameKey string
RegisterNetEvent("cdev_soccer:client:api:onPass", function(gameKey)
    TriggerEvent('rcore_stats:api:increaseStatValue', "soccer_passes_made", 1)
end)
