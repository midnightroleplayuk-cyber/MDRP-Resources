-- Region polygons and map blips. If a job's zoneId does not match an area name
-- in here, that job's sync dies silently.
Config.RegionBlipZone      = {
    plank               = false,
    ['kulestone:main']  = { zone = 'buildermainzone', coords = vector3(948.82, 2409.43, 76.28) },
    ['kulestone:site2'] = { zone = 'site2',       coords = vector3(47.22, -460.51, 94.75) },
    pipe                = { zone = 'buildermainzone', coords = vector3(1063.0, 2337.0, 53.5) },
    panelwall           = { zone = 'buildermainzone', coords = vector3(1023.0, 2442.0, 49.0) },
    waterfacility       = { zone = 'buildermainzone', coords = vector3(1061.0, 2299.0, 43.5) },
    waterfacility2      = { zone = 'buildermainzone', coords = vector3(1029.0, 2247.0, 43.3) },
    excavator_dirt      = 'excavator',
    job9                = 'job9',
    job7                = 'job7',
    job8                = 'job8',
    job12               = { 'job12_a', 'job12_b' },
}

Config.builderCoords       = {
    {
        id = 1,
        name = 'buildermainzone',
        coords = vector3(1009.02, 2296.74, 50.59),
        points = {
            vector2(863.9765625, 2496.4575195312),
            vector2(778.59930419922, 2106.732421875),
            vector2(1187.9714355469, 2050.4465332031),
            vector2(1205.5408935547, 2533.2924804688),
        },
    },
    {
        id = 2,
        name = 'site2',
        coords = vector3(47.22, -460.50, 94.74),
        points = {
            vector2(-53.0, -560.0),
            vector2( 147.0, -560.0),
            vector2( 147.0, -360.0),
            vector2(-53.0, -360.0),
        },
    },
    {
        id = 3,
        name = 'job9',
        coords = vector3(-2008.0, 545.0, 113.0),
        points = {
            vector2(-1980.0, 575.0),
            vector2(-2040.0, 575.0),
            vector2(-2040.0, 515.0),
            vector2(-1980.0, 515.0),
        },
    },
    {
        id = 4,
        name = 'excavator',
        coords = vector3(-1906.39, 674.86, 125.0),
        blipLabel = TL('blip_sidewalk', 'Sidewalk Repair'),
        points = {
            vector2(-1885.0, 660.0),
            vector2(-1918.0, 660.0),
            vector2(-1918.0, 685.0),
            vector2(-1885.0, 685.0),
        },
    },
    {
        id = 13,
        name = 'excavator2',
        coords = vector3(-1953.88, 576.18, 116.0),
        blipLabel = TL('blip_sidewalk', 'Sidewalk Repair'),
        points = {
            vector2(-1930.0, 553.0),
            vector2(-1978.0, 553.0),
            vector2(-1978.0, 600.0),
            vector2(-1930.0, 600.0),
        },
    },
    {
        id = 14,
        name = 'excavator3',
        coords = vector3(502.63, 276.26, 102.0),
        blipLabel = TL('blip_sidewalk', 'Sidewalk Repair'),
        points = {
            vector2(467.0, 246.0),
            vector2(538.0, 246.0),
            vector2(538.0, 307.0),
            vector2(467.0, 307.0),
        },
    },
    {
        id = 15,
        name = 'excavator4',
        coords = vector3(734.60, -2226.93, 28.25),
        blipLabel = TL('blip_sidewalk', 'Sidewalk Repair'),
        points = {
            vector2(707.0, -2263.0),
            vector2(762.0, -2263.0),
            vector2(762.0, -2190.0),
            vector2(707.0, -2190.0),
        },
    },
    {
        id = 5,
        name = 'job7',
        coords = vector3(-1125.0, -964.0, 5.6),
        points = {
            vector2(-1099.0, -935.0),
            vector2(-1151.0, -935.0),
            vector2(-1151.0, -993.0),
            vector2(-1099.0, -993.0),
        },
    },
    {
        id = 8,
        name = 'job8',
        coords = vector3(-825.19, -800.24, 19.69),
        points = {
            vector2(-787.0, -762.0),
            vector2(-863.0, -762.0),
            vector2(-863.0, -838.0),
            vector2(-787.0, -838.0),
        },
    },
    {
        id = 7,
        name = 'job12_a',
        coords = vector3(1565.03, 1705.19, 110.13),
        blipLabel = TL('blip_depot', 'Depot'),
        points = {
            vector2(1494.95, 1754.08),
            vector2(1578.80, 1774.20),
            vector2(1576.93, 1627.78),
            vector2(1495.38, 1639.66),
        },
    },
    {
        id = 8,
        name = 'job12_b',
        coords = vector3(1219.96, 1816.03, 78.03),
        blipLabel = TL('blip_delivery', 'Delivery'),
        points = {
            vector2(1189.96, 1786.03),
            vector2(1249.96, 1786.03),
            vector2(1249.96, 1846.03),
            vector2(1189.96, 1846.03),
        },
    },
    {
        id = 9,
        name = 'job12_b2',
        coords = vector3(812.57, 2187.09, 51.37),
        blipLabel = TL('blip_delivery', 'Delivery'),
        points = {
            vector2(782.57, 2157.09),
            vector2(842.57, 2157.09),
            vector2(842.57, 2217.09),
            vector2(782.57, 2217.09),
        },
    },
    {
        id = 10,
        name = 'job12_b3',
        coords = vector3(985.85, 2676.63, 38.78),
        blipLabel = TL('blip_delivery', 'Delivery'),
        points = {
            vector2(955.85, 2646.63),
            vector2(1015.85, 2646.63),
            vector2(1015.85, 2706.63),
            vector2(955.85, 2706.63),
        },
    },
}

if Tworst and Tworst.LoadBuilderZonesJson then Tworst.LoadBuilderZonesJson() end

Config.BuilderBlipSettings = {
    sprite = 317,
    color = 17,
    scale = 0.8,
    display = 4,
    shortRange = true
}

Config.TaskBlipSettings = {
    enabled     = true,
    color       = 17,
    routeColor  = 17,
    scale       = 0.85,
    display     = 4,
    shortRange  = false,
    category    = 1,
    sprite      = 1,

    dedupeRadius = 60.0,

    radius      = false,
    radiusSize  = 14.0,
    radiusAlpha = 80,
    radiusRGB   = { 255, 119, 0 },

    spriteByJob = {
        goSite        = 317,
        rental        = 477,
        rentalReturn  = 477,
        pwReturn      = 477,
        excReturn     = 477,
        towerReturnPoint = 477,
        job12GoA      = 478,
        job12GoB      = 478,
        excDig        = 318,
        excFillTruck  = 318,
        excHaul       = 318,
        excHole       = 318,
        excPave       = 318,
    },
}

Config.InventoryAccess = {
    allowedItems = {
    }
}
