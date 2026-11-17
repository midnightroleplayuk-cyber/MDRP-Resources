-- ====================================================================
-- MACHINE PART CONTROLS (arm, bucket, tipper)
-- ====================================================================
-- Moving parts of a machine are vehicle DOORS on the model. Add your own
-- vehicle here and its parts move with the machine keys.
--   door         : door index on the model (0-5)
--   controlGroup : which key pair moves it
--                  1 = G / H      2 = arrow up / down
--                  3 = arrow right / left     4 = E / Q
--   min / max    : how far the part may travel (0.0 = shut, 1.0 = full)
--   speed        : travel per tick, bigger is faster
--   invert       : flip the direction
-- The vehicle also has to be the model named in config/jobs/excavator.lua
-- (vehicles.jcbModel) for the digging job to use it.
-- ====================================================================

Config.VehicleAnimControls = {

    twmixer = {
        parts = {
            { door = 2, controlGroup = 3, min = 0.0, max = 1.0, speed = 0.008, invert = true },
        }
    },

    twtiptruck = {
        parts = {
            { door = 2, controlGroup = 3, min = 0.0, max = 1.0, speed = 0.008 },
            { door = 5, controlGroup = 2, min = 0.0, max = 1.0, speed = 0.01 },
        }
    },

    twdigmas = {
        parts = {
            { door = 1, controlGroup = 1, min = 0.0, max = 1.0, speed = 0.01 },
            { door = 2, controlGroup = 2, min = 0.0, max = 1.0, speed = 0.01 },
            { door = 3, controlGroup = 4, min = 0.0, max = 1.0, speed = 0.01 },
            { door = 5, controlGroup = 3, min = 0.0, max = 1.0, speed = 0.008 },
        }
    },

    twrough = {
        parts = {
            { door = 2, controlGroup = 3, min = 0.0, max = 1.0, speed = 0.01 },
            { door = 3, controlGroup = 2, min = 0.0, max = 1.0, speed = 0.01 },
        }
    },
}
