Config = {}

-- AI traffic inside the estate. true = no npc cars spawn or drive through the estate, strays get removed.
-- The custom paths are stream/nodes*.ynd, don't delete them - the vanilla ones run through the buildings.
Config.DisableAIVehicles = true

-- street names shown on the HUD for the estate roads
Config.StreetNames = {
    JTE_ST_ASHDOWN = 'Ashdown Road',
    JTE_ST_JAMESTOWN = 'Jamestown Way',
    JTE_ST_TANNERY = 'Tannery Street',
    JTE_ST_COBDEN = 'Cobden Street',
}

Config.LiftConfig = {
    Interaction = 'ox_target', -- ox_target / qb-target / custom
    TargetRadius = 0.25,
    TravelTime = 1500,
    Icon = 'fas fa-elevator',

    Elevators = {
        { -- Ashdown House west
            name = 'ashdown_w',
            floors = {
                { label = 'Ground Floor',
                  buttons  = { vector3(371.444, -1989.259, 22.777), vector3(371.787, -1988.874, 22.797) },
                  tpCoords = vector4(371.731, -1988.004, 21.697, 135.0) },
                { label = '1st Floor',
                  buttons  = { vector3(371.444, -1989.259, 25.577), vector3(371.787, -1988.874, 25.597) },
                  tpCoords = vector4(371.731, -1988.004, 24.497, 135.0) },
                { label = '2nd Floor',
                  buttons  = { vector3(371.444, -1989.259, 28.377), vector3(371.787, -1988.874, 28.397) },
                  tpCoords = vector4(371.731, -1988.004, 27.297, 135.0) },
                { label = '3rd Floor',
                  buttons  = { vector3(371.444, -1989.259, 31.177), vector3(371.787, -1988.874, 31.197) },
                  tpCoords = vector4(371.731, -1988.004, 30.097, 135.0) },
                { label = '4th Floor',
                  buttons  = { vector3(371.444, -1989.259, 33.977), vector3(371.787, -1988.874, 33.997) },
                  tpCoords = vector4(371.731, -1988.004, 32.897, 135.0) },
            },
        },
        { -- Ashdown House east
            name = 'ashdown_e',
            floors = {
                { label = 'Ground Floor',
                  buttons  = { vector3(397.275, -2015.089, 22.777), vector3(398.587, -2015.673, 22.797) },
                  tpCoords = vector4(398.530, -2014.803, 21.697, 135.0) },
                { label = '1st Floor',
                  buttons  = { vector3(397.275, -2015.089, 25.577), vector3(398.587, -2015.673, 25.597) },
                  tpCoords = vector4(398.530, -2014.803, 24.497, 135.0) },
                { label = '2nd Floor',
                  buttons  = { vector3(397.275, -2015.089, 28.377), vector3(398.587, -2015.673, 28.397) },
                  tpCoords = vector4(398.530, -2014.803, 27.297, 135.0) },
                { label = '3rd Floor',
                  buttons  = { vector3(397.275, -2015.089, 31.177), vector3(398.587, -2015.673, 31.197) },
                  tpCoords = vector4(398.530, -2014.803, 30.097, 135.0) },
                { label = '4th Floor',
                  buttons  = { vector3(397.275, -2015.089, 33.977), vector3(398.587, -2015.673, 33.997) },
                  tpCoords = vector4(398.530, -2014.803, 32.897, 135.0) },
            },
        },
        { -- Brunel House west
            name = 'brunel_w',
            floors = {
                { label = 'Ground Floor',
                  buttons  = { vector3(321.593, -2012.240, 20.235), vector3(321.936, -2011.855, 20.255) },
                  tpCoords = vector4(321.880, -2010.985, 19.155, 135.0) },
                { label = '1st Floor',
                  buttons  = { vector3(321.593, -2012.240, 23.035), vector3(321.936, -2011.855, 23.055) },
                  tpCoords = vector4(321.880, -2010.985, 21.955, 135.0) },
                { label = '2nd Floor',
                  buttons  = { vector3(321.593, -2012.240, 25.835), vector3(321.936, -2011.855, 25.855) },
                  tpCoords = vector4(321.880, -2010.985, 24.755, 135.0) },
                { label = '3rd Floor',
                  buttons  = { vector3(321.593, -2012.240, 28.635), vector3(321.936, -2011.855, 28.655) },
                  tpCoords = vector4(321.880, -2010.985, 27.555, 135.0) },
                { label = '4th Floor',
                  buttons  = { vector3(321.593, -2012.240, 31.435), vector3(321.936, -2011.855, 31.455) },
                  tpCoords = vector4(321.880, -2010.985, 30.355, 135.0) },
            },
        },
        { -- Brunel House east
            name = 'brunel_e',
            floors = {
                { label = 'Ground Floor',
                  buttons  = { vector3(353.434, -2044.081, 20.235), vector3(354.746, -2044.664, 20.255) },
                  tpCoords = vector4(354.689, -2043.794, 19.155, 135.0) },
                { label = '1st Floor',
                  buttons  = { vector3(353.434, -2044.081, 23.035), vector3(354.746, -2044.664, 23.055) },
                  tpCoords = vector4(354.689, -2043.794, 21.955, 135.0) },
                { label = '2nd Floor',
                  buttons  = { vector3(353.434, -2044.081, 25.835), vector3(354.746, -2044.664, 25.855) },
                  tpCoords = vector4(354.689, -2043.794, 24.755, 135.0) },
                { label = '3rd Floor',
                  buttons  = { vector3(353.434, -2044.081, 28.635), vector3(354.746, -2044.664, 28.655) },
                  tpCoords = vector4(354.689, -2043.794, 27.555, 135.0) },
                { label = '4th Floor',
                  buttons  = { vector3(353.434, -2044.081, 31.435), vector3(354.746, -2044.664, 31.455) },
                  tpCoords = vector4(354.689, -2043.794, 30.355, 135.0) },
            },
        },
        { -- Cromwell House west
            name = 'cromwell_w',
            floors = {
                { label = 'Ground Floor',
                  buttons  = { vector3(310.881, -2076.693, 16.992), vector3(311.223, -2076.307, 17.012) },
                  tpCoords = vector4(311.167, -2075.438, 15.912, 135.0) },
                { label = '1st Floor',
                  buttons  = { vector3(310.881, -2076.693, 19.792), vector3(311.223, -2076.307, 19.812) },
                  tpCoords = vector4(311.167, -2075.438, 18.712, 135.0) },
                { label = '2nd Floor',
                  buttons  = { vector3(310.881, -2076.693, 22.592), vector3(311.223, -2076.307, 22.612) },
                  tpCoords = vector4(311.167, -2075.438, 21.512, 135.0) },
                { label = '3rd Floor',
                  buttons  = { vector3(310.881, -2076.693, 25.392), vector3(311.223, -2076.307, 25.412) },
                  tpCoords = vector4(311.167, -2075.438, 24.312, 135.0) },
            },
        },
        { -- Cromwell House east
            name = 'cromwell_e',
            floors = {
                { label = 'Ground Floor',
                  buttons  = { vector3(338.479, -2104.291, 16.992), vector3(339.791, -2104.874, 17.012) },
                  tpCoords = vector4(339.734, -2104.005, 15.912, 135.0) },
                { label = '1st Floor',
                  buttons  = { vector3(338.479, -2104.291, 19.792), vector3(339.791, -2104.874, 19.812) },
                  tpCoords = vector4(339.734, -2104.005, 18.712, 135.0) },
                { label = '2nd Floor',
                  buttons  = { vector3(338.479, -2104.291, 22.592), vector3(339.791, -2104.874, 22.612) },
                  tpCoords = vector4(339.734, -2104.005, 21.512, 135.0) },
                { label = '3rd Floor',
                  buttons  = { vector3(338.479, -2104.291, 25.392), vector3(339.791, -2104.874, 25.412) },
                  tpCoords = vector4(339.734, -2104.005, 24.312, 135.0) },
            },
        },
    },

    -- only used when Interaction = 'custom'
    CustomInteraction = {
        add = function(coords, radius, options)
            -- return exports['my-target']:AddSphere(coords, radius, options)
        end,
        remove = function(handle)
            -- exports['my-target']:RemoveZone(handle)
        end,
    },
}
