RegisterServerEvent('op-garages:wxCarlock')
AddEventHandler('op-garages:wxCarlock', function(vehicle, model, plate)
    exports["wx_carlock"]:shareKey(source, plate)
end)