Config = {}

-- Courtroom sound-proofing (pma-voice 6.4.0+). With the doors shut, players inside can't be heard outside and vice versa.
-- Radio and phone calls still work. Turn off if another script already uses pma-voice's overrideProximityCheck.
Config.Soundproofing = {
    Enabled = true,
    VoiceResource = 'pma-voice',
    Rooms = {
        court   = true, -- Courtrooms 1 - 4
        jury    = true, -- Jury Retiring Rooms
        judges  = true, -- Judges' Chambers
        consult = true, -- Consultation Rooms
    },
}

Config.LiftConfig = {
    Interaction = 'ox_target', -- ox_target / qb-target / custom (see CustomInteraction below)
    TargetRadius = 0.2,
    TravelTime = 1500,
    ManageDoors = false, -- true = the script opens and closes the lift doors itself
    DoorOpenTime = 2500,
    Icon = 'fas fa-elevator',

    Elevators = {
        { -- Public lift
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
        { -- Judges' lift
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
        { -- Car park lift
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
        { -- Dock lift, courts 1 & 2
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
        { -- Dock lift, courts 3 & 4
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
    },

    -- only used when Interaction = 'custom'
    CustomInteraction = {
        add = function(coords, radius, options)
        end,
        remove = function(handle)
        end,
    },
}
