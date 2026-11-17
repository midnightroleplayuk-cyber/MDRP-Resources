-- ====================================================================
-- REGION 1 -- PILE LAYOUT (per stage). Keep it a top-level key, not under Config.PlankJob.
-- ====================================================================
-- dx/dy/dz = pile group centre (offset from the site reference); points = number of piles;
-- spread = distance between outermost piles (m); perStack = pieces per pile (nil = rest).
-- ====================================================================

Config = Config or {}

Config.PlankStages = {
    plank = {
        perStack  = 5,
        stackStep = vector3(0.0, 0.0, 0.10),
        rot       = vector3(-90.0, 0.0, 0.0),
    },
    wire = {
        perStack  = 5,
        stackStep = vector3(0.0, 0.0, 0.06),
        rot       = vector3(0.0, 0.0, 0.0),
    },

    pole = {
        dx = -11.740, dy = 0.0, dz = -0.025,
        points = nil,
        spread = 2.673, axis = 'y',
        perStack = 2,
        stackStep = vector3(0.0, 0.0, 0.3),
        rot = vector3(90.0, 0.0, 90.0),
    },
    rebar = {
        dx = -12.046, dy = 0.0, dz = -0.025,
        points = nil,
        spread = 4.682, axis = 'y',
        perStack = 2,
        stackStep = vector3(0.0, 0.0, 0.3),
        rot = vector3(0.0, 0.0, 90.0),
    },
    ground = {
        dx = -14.786, dy = 0.0, dz = 0.4,
        points = 1, perStack = nil,
        stackStep = vector3(0.0, 0.0, 0.15),
        rot = vector3(0.0, 90.0, 0.0),
    },
    upperWall = {
        dx = -14.786, dy = 0.0, dz = 0.4,
        points = 1, perStack = nil,
        stackStep = vector3(0.0, 0.0, 0.15),
        rot = vector3(0.0, 90.0, 0.0),
    },
    ceiling = {
        dx = -14.786, dy = 0.0, dz = 0.4,
        points = 1, perStack = nil,
        stackStep = vector3(0.0, 0.0, 0.15),
        rot = vector3(0.0, 0.0, 0.0),
    },
    upperCeiling = {
        dx = -14.786, dy = 0.0, dz = 0.4,
        points = 1, perStack = nil,
        stackStep = vector3(0.0, 0.0, 0.15),
        rot = vector3(0.0, 0.0, 0.0),
    },
}
