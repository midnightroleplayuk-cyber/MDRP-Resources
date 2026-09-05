if Config.Housing ~= "rcore_housing" then return end

function giveStarterHouse(identifier, playerId)
    exports.rcore_housing:AddStarterApartment(identifier)
end