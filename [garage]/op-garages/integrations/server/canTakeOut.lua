function canTakeOutCar(identifier, source, plate, cb)
    -- This function works in callback to make sure you can trigger mysql etc.
    -- You can add here some notification why this vehicle can't be taken out
    -- EXAMPLE:
    --
    -- TriggerClientEvent('op-uniqueNotif:sendNotify', source, "This vehicle can be taken out only if you have VIP rank!", "error", 5)
    return cb(true)
end