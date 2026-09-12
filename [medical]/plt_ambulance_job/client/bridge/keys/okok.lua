if Bridge.Keys ~= 'okok' then return end

Keys.SetProvider('okokGarage', function(plate)
    TriggerEvent('okokGarage:GiveKeys', plate)
end)
