Electric = {}

Electric.GetBatteryPercentage = function(vehicle) -- if you have custom export for getting battery percentage
    return 100                                    -- here you can implement your system

    -- /*
    --     For example you can do this if you have other script for this
    --     return export["YourFuelScript"]:GetBattery(vehicle)

    --     return value needs to be in format 0-100%
    -- */
end
