if Bridge.Keys ~= 'qb' then return end

Keys.SetProvider('qb-vehiclekeys', function(plate)
    TriggerEvent('vehiclekeys:client:SetOwner', plate)
    TriggerEvent('qb-vehiclekeys:client:AddKeys', plate)
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end)
