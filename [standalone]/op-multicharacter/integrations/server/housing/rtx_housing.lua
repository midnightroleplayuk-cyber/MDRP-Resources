if Config.Housing ~= "rtx_housing" then return end

function giveStarterHouse(identifier, playerId)
    exports["rtx_housing"]:GiveStarterApartment(tonumber(playerId))
end