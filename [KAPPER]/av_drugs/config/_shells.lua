-- IMPORTANT don't change type (ingredients/products) in lab shells, otherwise it will break everything

Config = Config or {}
Config.TestShell = { -- default coords for test shell
    ['zIndex'] = 20, ['door'] = {x = 1.0, y = 1.0, z = 1.0, heading = 90.0, dist = 2}, 
}
Config.Interiors = {
    ['shell_meth'] = {
        ['zIndex'] = 25,
        ['door'] = {x = -6.27, y = 8.07, z = 1.54, heading = -184.46, dist = 2},
    },
    ['shell_coke2'] = {
        ['zIndex'] = 25,
        ['door'] = {x = -6.17, y = 8.31, z = 1.54, heading = -182.33, dist = 2},
    },
    ['k4mb1_acid2_shell'] = {
        ['zIndex'] = 25,
        ['door'] = {x = -2.64, y = 1.2, z = 2.11, heading = -181.9, dist = 2},
    },
}