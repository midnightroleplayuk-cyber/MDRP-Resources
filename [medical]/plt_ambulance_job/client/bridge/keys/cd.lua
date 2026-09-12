if Bridge.Keys ~= 'cd' then return end

Keys.SetProvider('cd_garage', function(plate)
    TriggerEvent('cd_garage:AddKeys', plate)
end)
