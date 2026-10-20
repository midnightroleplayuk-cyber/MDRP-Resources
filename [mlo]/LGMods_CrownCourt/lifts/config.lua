LiftConfig = {}

-- Westbridge Crown Court lifts (crown_court resource). Five shafts; every stop has two interaction points: the landing call
-- station beside the doors and the car operating panel inside the car. Coordinates come straight out of the Blender build
-- (cc_int_fin.lift_fin) - re-run the export notes in README.txt if the lifts move.
--   tpCoords = where the player arrives: middle of the car, facing out through the doors (x, y, z, heading)
--   doors    = the two sliding leaves of that landing (model + position); buttons[1] is the landing call station (doors open
--              there first, then you ride), buttons[2] the car operating panel

-- Interaction: 'ox_target' (default) or 'qb-target', or 'custom' with LiftConfig.CustomInteraction (see the bottom of this file).
LiftConfig.Interaction = 'ox_target'

LiftConfig.TargetRadius = 0.2        -- sphere round each call plate / COP (plates are 10 x 30 cm, the COP 22 x 75 cm)
LiftConfig.TravelTime   = 1500       -- ms with the screen faded out (the "ride")
LiftConfig.ManageDoors  = false      -- the script never touches the lift leaves: ox_doorlock (or nothing) owns them, as before.
                                     -- true = the script opens / closes the landing doors itself on departure and arrival
LiftConfig.DoorOpenTime = 2500       -- ms the doors stay open after arriving
LiftConfig.Icon         = 'fas fa-elevator'

LiftConfig.Elevators = {
    {   -- public lift: car park corner shaft (scripted hop) -> Public Hall -> first-floor court waiting
        name = 'public',
        floors = {
            { label = 'Level -1 - Car Park',
              buttons  = { vector3(-412.277, -428.516, 28.644), vector3(-412.063, -430.494, 28.744) },
              tpCoords = vector4(-411.266, -429.481, 27.544, 82.7),
              doors    = { { model = 'wcc_lift_leaf_546_2288', coords = vector3(-412.365, -429.896, 27.556) },
                           { model = 'wcc_lift_leaf_546_2288', coords = vector3(-412.226, -428.805, 27.556) } } },
            { label = 'Ground Floor - Public Hall',
              buttons  = { vector3(-403.249, -429.464, 32.950), vector3(-403.010, -431.244, 33.050) },
              tpCoords = vector4(-402.276, -430.425, 31.850, 82.7),
              doors    = { { model = 'wcc_lift_leaf_546_2288', coords = vector3(-403.337, -430.844, 31.862) },
                           { model = 'wcc_lift_leaf_546_2288', coords = vector3(-403.198, -429.753, 31.862) } } },
            { label = 'First Floor - Court Waiting',
              buttons  = { vector3(-403.249, -429.464, 37.150), vector3(-403.010, -431.244, 37.250) },
              tpCoords = vector4(-402.276, -430.425, 36.050, 82.7),
              doors    = { { model = 'wcc_lift_leaf_546_2288', coords = vector3(-403.337, -430.844, 36.062) },
                           { model = 'wcc_lift_leaf_546_2288', coords = vector3(-403.198, -429.753, 36.062) } } },
        },
    },
    {   -- judges' lift: judges' & staff entrance -> first-floor judicial corridor
        name = 'judges',
        floors = {
            { label = "Ground Floor - Judges' Entrance",
              buttons  = { vector3(-405.906, -457.496, 32.950), vector3(-404.293, -458.168, 33.050) },
              tpCoords = vector4(-405.276, -458.723, 31.850, 352.7),
              doors    = { { model = 'wcc_lift_leaf_496_2288', coords = vector3(-404.647, -457.744, 31.862) },
                           { model = 'wcc_lift_leaf_496_2288', coords = vector3(-405.639, -457.618, 31.862) } } },
            { label = "First Floor - Judges' Corridor",
              buttons  = { vector3(-405.906, -457.496, 37.150), vector3(-404.293, -458.168, 37.250) },
              tpCoords = vector4(-405.276, -458.723, 36.050, 352.7),
              doors    = { { model = 'wcc_lift_leaf_496_2288', coords = vector3(-404.647, -457.744, 36.062) },
                           { model = 'wcc_lift_leaf_496_2288', coords = vector3(-405.639, -457.618, 36.062) } } },
        },
    },
    {   -- staff / car park lift: car park core -> car park stair & lift lobby (ground floor)
        name = 'carpark',
        floors = {
            { label = 'Level -1 - Car Park',
              buttons  = { vector3(-418.035, -452.599, 28.644), vector3(-416.173, -453.302, 28.744) },
              tpCoords = vector4(-417.360, -453.869, 27.544, 352.7),
              doors    = { { model = 'wcc_lift_leaf_546_2288', coords = vector3(-416.677, -452.860, 27.556) },
                           { model = 'wcc_lift_leaf_546_2288', coords = vector3(-417.768, -452.721, 27.556) } } },
            { label = 'Ground Floor - Staff Lobby',
              buttons  = { vector3(-418.114, -453.219, 32.950), vector3(-416.252, -453.922, 33.050) },
              tpCoords = vector4(-417.434, -454.452, 31.850, 352.7),
              doors    = { { model = 'wcc_lift_leaf_546_2288', coords = vector3(-416.756, -453.480, 31.862) },
                           { model = 'wcc_lift_leaf_546_2288', coords = vector3(-417.847, -453.341, 31.862) } } },
        },
    },
    {   -- secure dock lift, courts 1 & 2: custody -> dock lobby
        name = 'dock12',
        floors = {
            { label = 'Ground Floor - Custody (Courts 1 & 2)',
              buttons  = { vector3(-412.115, -444.061, 32.950), vector3(-411.777, -445.853, 33.050) },
              tpCoords = vector4(-411.036, -444.985, 31.850, 82.7),
              doors    = { { model = 'wcc_lift_leaf_496_2288', coords = vector3(-412.141, -445.348, 31.862) },
                           { model = 'wcc_lift_leaf_496_2288', coords = vector3(-412.015, -444.356, 31.862) } } },
            { label = 'First Floor - Dock Lobby (Courts 1 & 2)',
              buttons  = { vector3(-412.115, -444.061, 37.150), vector3(-411.777, -445.853, 37.250) },
              tpCoords = vector4(-411.036, -444.985, 36.050, 82.7),
              doors    = { { model = 'wcc_lift_leaf_496_2288', coords = vector3(-412.141, -445.348, 36.062) },
                           { model = 'wcc_lift_leaf_496_2288', coords = vector3(-412.015, -444.356, 36.062) } } },
        },
    },
    {   -- secure dock lift, courts 3 & 4: custody -> dock lobby (R block first floor)
        name = 'dock34',
        floors = {
            { label = 'Ground Floor - Custody (Courts 3 & 4)',
              buttons  = { vector3(-437.425, -433.830, 32.950), vector3(-437.081, -435.573, 33.050) },
              tpCoords = vector4(-436.346, -434.754, 31.850, 82.7),
              doors    = { { model = 'wcc_lift_leaf_496_2288', coords = vector3(-437.451, -435.117, 31.862) },
                           { model = 'wcc_lift_leaf_496_2288', coords = vector3(-437.325, -434.126, 31.862) } } },
            { label = 'First Floor - Dock Lobby (Courts 3 & 4)',
              buttons  = { vector3(-437.425, -433.830, 38.400), vector3(-437.081, -435.573, 38.500) },
              tpCoords = vector4(-436.346, -434.754, 37.300, 82.7),
              doors    = { { model = 'wcc_lift_leaf_496_2288', coords = vector3(-437.451, -435.117, 37.312) },
                           { model = 'wcc_lift_leaf_496_2288', coords = vector3(-437.325, -434.126, 37.312) } } },
        },
    },
}

-- Any other interaction script: set LiftConfig.Interaction = 'custom' and fill these two in. `options` is a list of
-- { label = string, icon = string, onSelect = function() } ; return whatever handle `remove` needs.
LiftConfig.CustomInteraction = {
    add = function(coords, radius, options)
        -- e.g. exports['my-target']:AddSphere(coords, radius, options)
    end,
    remove = function(handle)
        -- e.g. exports['my-target']:RemoveZone(handle)
    end,
}
