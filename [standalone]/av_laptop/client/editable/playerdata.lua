PlayerData = nil

function getPlayer()
    while not Core do Wait(10) end
    if Config.Framework == "qb" then
        PlayerData = Core.Functions.GetPlayerData()
    end
end