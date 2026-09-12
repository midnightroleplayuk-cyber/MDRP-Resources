if Bridge.Keys ~= 'qbx' then return end

Keys.SetProvider('qbx_vehiclekeys', function(plate)
    exports.qbx_vehiclekeys:GiveKeys(plate)
end)
