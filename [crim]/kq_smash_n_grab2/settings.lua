Settings = {}

Settings.positions = {
    normal = {
        {
            bone = 'seat_dside_f',
            offset = vec3(0, 0, 0),
            windowIndex = 0,
        },
        {
            bone = 'seat_pside_f',
            offset = vec3(0, 0, 0),
            windowIndex = 1,
        },
        {
            bone = 'seat_dside_r',
            offset = vec3(0, 0, 0),
            windowIndex = 2,
        },
        {
            bone = 'seat_pside_r',
            offset = vec3(0, 0, 0),
            windowIndex = 3,
        },
    },
    special = {
        ['bison'] = {
            allowNormalPositions = false,
            offsets = {
                vec3(0.014, -1.68, 0.26),
            },
        },
        ['sandking'] = {
            allowNormalPositions = false,
            offsets = {
                vec3(0.015, -2.36, 0.37),
            },
        },
        ['sandking2'] = {
            allowNormalPositions = false,
            offsets = {
                vec3(-0.05, -1.98, 0.64),
            },
        },
        ['rebel'] = {
            allowNormalPositions = false,
            offsets = {
                vec3(0.03, -1.66, 0.30),
            },
        },
        ['rebel2'] = {
            allowNormalPositions = false,
            offsets = {
                vec3(0.03, -1.66, 0.30),
            },
        },
    },
}
