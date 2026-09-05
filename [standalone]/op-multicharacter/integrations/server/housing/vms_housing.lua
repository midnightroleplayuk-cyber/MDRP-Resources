if Config.Housing ~= "vms_housing" then return end

function giveStarterHouse(identifier, playerId)
    exports['vms_housing']:AddStarterApartment(identifier)
end