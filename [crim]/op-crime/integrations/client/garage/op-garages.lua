if Config.GarageScript == "op-garages" then
    function openGangGarage()
        local coords = GetEntityCoords(PlayerPedId())
        exports['op-garages']:OpenGangGarageHere(coords, true)
    end
end