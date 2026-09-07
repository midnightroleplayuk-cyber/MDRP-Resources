DRAWABLE = {
    ['mask'] = 1,
    ['torso'] = 3,
    ['legs'] = 4,
    ['bag'] = 5,
    ['feet'] = 6,
    ['accessory'] = 7,
    ['undershirt'] = 8,
    ['chest'] = 9,
    ['decals'] = 10,
    ['tops'] = 11,
}

PROPS = {
    ['helmet'] = 0,
    ['glasses'] = 1,
    ['ear'] = 2,
}

NAKED = {
    -- Male
    [1885233650] = {
        head = {
            ['mask'] = 0,
            ['helmet'] = -1,
            ['glasses'] = 0,
            ['ear'] = -1,
        },
        top = {
            ['torso'] = 15,
            ['undershirt'] = 15,
            ['tops'] = 15,
            ['accessory'] = 0,
            ['chest'] = 0,
            ['decals'] = 0,
            ['bag'] = 0,
        },
        bottom = {
            ['legs'] = 61,
            ['feet'] = 34,
        }
    },
    -- Female
    [-1667301416] = {
        head = {
            ['mask'] = 0,
            ['helmet'] = -1,
            ['glasses'] = -1,
            ['ear'] = -1,
        },
        top = {
            ['torso'] = 15,
            ['undershirt'] = 14,
            ['tops'] = 18,
            ['accessory'] = 0,
            ['chest'] = 0,
            ['decals'] = 0,
            ['bag'] = 0,
        },
        bottom = {
            ['legs'] = 62,
            ['feet'] = 35,
        }
    }
}
