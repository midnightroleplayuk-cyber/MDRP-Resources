if Config.Housing ~= "nolag_properties" then return end

function giveStarterHouse(identifier, playerId)
    exports.nolag_properties:AddStarterApartment(identifier)
end