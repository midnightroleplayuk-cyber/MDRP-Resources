Config = {}
Config.Language = {}

Config.Debug = false -- Enable this to show a marker at your pole locations in game


Config.DistanceToPole = 1.4 -- Distance to the pole that the use prompt will show
Config.UsePoleControl = 51 -- The control to use the pole, default E
Config.PoleSpeed = 0.038 -- This is speed the player goes down the pole
Config.PoleLocations = {
    -- Start of entry
    ["Moddex Fire Station 1"] = {
        ["Start Locations"] = { -- Inside this table is the coordinates for
            vector3(-1206.87, -1304.0, 12.31),   -- where you can get onto the pole.
        },
        ["End Z Coordinate"] = 5.2, -- This is the Z coordinate for where the pole ends.
        ["Heading"] = 26.03, -- This is the heading to set the player to when they get on the pole.
    },
    ["Moddex Fire Station 2"] = {
        ["Start Locations"] = { -- Inside this table is the coordinates for
            vector3(-1209.14, -1305.03, 12.31),   -- where you can get onto the pole.
        },
        ["End Z Coordinate"] = 4.7, -- This is the Z coordinate for where the pole ends.
        ["Heading"] = 26.03, -- This is the heading to set the player to when they get on the pole.
    },
    --End of entry. Copy between the "Start of entry" and this line to make another entry if you wish.
}

Config.Language.UsePole = "Press ~INPUT_CONTEXT~ to slide down the pole."