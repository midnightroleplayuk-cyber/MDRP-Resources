-- RSVX bowling alley (v0.6). The building, its props and the doors are placed by stream/rsvx_bowling.ymap;
-- the old club, its junk, the poles/bushes on the car park and the grass there are removed by the edited
-- vanilla cs4_04 / cs4_roads ymaps in stream/. Nothing needs spawning from script any more.

-- /bowling teleports you to the car park aisle, facing the building
RegisterCommand('bowling', function()
    local ped = PlayerPedId()
    SetEntityCoords(ped, 1471.89, 3740.41, 34.0, false, false, false, false)
    SetEntityHeading(ped, 305.1)
end, false)

-- BowlingPinSpots (pin_spots.lua) holds the 80 pin positions for your pin script
exports('GetPinSpots', function()
    return BowlingPinSpots
end)
