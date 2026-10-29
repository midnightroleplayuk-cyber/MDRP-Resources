-- ====================================================================
-- REGION 8 -- Sidewalk Repair (JCB + tiptruck)
-- ====================================================================
-- Dig sand with the bucket -> dump into the truck -> tip it into the pit -> lay stones by hand.
-- A site is lockable: one lobby claims a pit and no other lobby can work it until the job ends.
-- ====================================================================

Config.ExcavatorJob = {
    watchZones = { 'buildermainzone', 'excavator', 'excavator2', 'excavator3', 'excavator4' },

    sceneZones = { sand = 'buildermainzone', hole = 'excavator' },

    -- false = crews get the first free pit in the list below, so the same one
    -- comes up until another crew is on it. true = a random free pit each time.
    randomSite = false,

    vehicles = { jcbModel = 'twdigmas', tiptruckModel = 'twtiptruck' },

    crewProfiles = {
        [1] = { vehicles = { jcb = 1 } },
        [2] = { vehicles = { jcb = 1, tiptruck = 1 } },
        [3] = { vehicles = { jcb = 1, tiptruck = 2 } },
        [4] = { vehicles = { jcb = 2, tiptruck = 2 } },
    },

    fleetCapByQuota = true,
    rentAllowed = { 'jcb', 'tiptruck' },

    minPlayers = 1,
    maxPlayers = 4,

    sitesForCrew = function(_) return 1 end,

    digsPerTruck = 5,
    truckLoadsPerHole = 1,

    sandPiles = {
        vec4(1067.204, 2359.826, 42.892, 0.0),
        vec4(1067.204, 2366.826, 43.015, 0.0),
        vec4(1067.204, 2372.847, 43.415, 0.0),
        vec4(1067.204, 2351.526, 43.788, 0.0),
    },

    sandModels = {
        'tworst_job10dirt1e',
        'tworst_job10dirt1d',
        'tworst_job10dirt1c',
        'tworst_job10dirt1b',
        'tworst_job10dirt1a',
    },

    sandCollision   = false,

    truckExtras     = { 3, 4, 5, 6, 7 },
    jcbDirtExtra    = 8,
    jcbDefaultExtra = 1,

    cooldownHours = 0,

    sites = {
        {
            id     = 'sidewalk1',
            cover = { model = 'tw_job10parquet1', coords = vec3(-1906.348, 674.680, 125.510), rot = vec3(0.0, 0.0, 0.0) },
            label  = 'Sidewalk Repair #1',
            center = vec3(-1906.39, 674.86, 126.52),

            minCrew = 1, maxCrew = 2,
            crewPerSite = 1,
            truckLoads  = 1,
            zones = { sand = 'buildermainzone', hole = 'excavator' },

            sandPile = vec4(1067.204, 2359.826, 42.892, 0.0),

            jcbSpawn   = vec4(1016.74, 2364.58, 50.46, 280.0),
            truckSpawn = vec4(1017.55, 2356.14, 51.27, 280.0),

            holeFill = {
                { model = 'tworst_job10dirt1', coords = vec3(-1906.350, 674.667, 124.615), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirt4', coords = vec3(-1906.353, 674.664, 124.697), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirt2', coords = vec3(-1906.360, 674.656, 124.866), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirt3', coords = vec3(-1906.367, 674.649, 125.036), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirt5', coords = vec3(-1906.373, 674.643, 125.176), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirt6', coords = vec3(-1906.379, 674.637, 125.314), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirt7', coords = vec3(-1906.308, 674.711, 125.436), rot = vec3(0.0, 0.0, 0.0) },
            },

            stonePiles = {
                { coords = vec3(-1909.297, 671.704, 125.409), rot = vec3(-2.864, 1.490, 359.712),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
                { coords = vec3(-1903.601, 677.600, 125.900), rot = vec3(-2.862, 1.493, 359.653),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
            },

            stoneSlots = {
                { model = 'tworst_job10con5', coords = vec3(-1907.091, 672.914, 125.358), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10con4', coords = vec3(-1908.025, 673.744, 125.358), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10con2', coords = vec3(-1906.670, 675.024, 125.469), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10con1', coords = vec3(-1905.515, 676.467, 125.625), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10con',  coords = vec3(-1905.934, 674.349, 125.469), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10con3', coords = vec3(-1904.459, 675.472, 125.580), rot = vec3(0.0, 0.0, 0.0) },
            },
        },

        {
            id     = 'sidewalk2',
            cover = { model = 'tw_job10parquet2', coords = vec3(-1953.763, 576.191, 115.930), rot = vec3(0.0, 0.0, 0.0) },
            zones  = { sand = 'buildermainzone', hole = 'excavator2' },
            label  = 'Sidewalk Repair #2 (small)',
            center = vec3(-1953.881, 576.181, 115.938),

            minCrew = 1, maxCrew = 2,
            crewPerSite = 1,
            truckLoads  = 1,

            sandPile   = vec4(1067.204, 2359.826, 42.892, 0.0),
            jcbSpawn   = vec4(1016.74, 2364.58, 50.46, 280.0),
            truckSpawn = vec4(1017.55, 2356.14, 51.27, 280.0),
            stonePiles = {
                { coords = vec3(-1953.029, 581.234, 116.743), rot = vec3(-2.855, 1.508, 359.349),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
            },

            holeModels = {
                'tworst_job10dirtc1', 'tworst_job10dirtc2', 'tworst_job10dirtc3',
                'tworst_job10dirtc4', 'tworst_job10dirtc5', 'tworst_job10dirtc6',
            },
            holeFill = {
                { model = 'tworst_job10dirtc1', coords = vec3(-1953.881, 576.181, 115.188), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirtc2', coords = vec3(-1953.881, 576.181, 115.328), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirtc3', coords = vec3(-1953.881, 576.181, 115.468), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirtc4', coords = vec3(-1953.881, 576.181, 115.608), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirtc5', coords = vec3(-1953.881, 576.181, 115.748), rot = vec3(0.0, 0.0, 0.0) },
                { model = 'tworst_job10dirtc6', coords = vec3(-1953.881, 576.181, 115.888), rot = vec3(0.0, 0.0, 0.0) },
            },

            stoneSlots = {
                { model = 'tworst_job10conc', coords = vec3(-1952.671, 578.926, 116.337), rot = vec3(0.46, 2.16, -0.22) },
                { model = 'tworst_job10conc', coords = vec3(-1953.918, 579.153, 116.326), rot = vec3(0.46, 2.16, -0.22) },
                { model = 'tworst_job10conc', coords = vec3(-1953.040, 577.021, 116.080), rot = vec3(0.91, 2.05, 0.53) },
                { model = 'tworst_job10conc', coords = vec3(-1954.288, 577.249, 116.081), rot = vec3(0.87, 2.01, -0.15) },
                { model = 'tworst_job10conc', coords = vec3(-1953.407, 575.135, 115.830), rot = vec3(0.46, 2.16, -0.22) },
                { model = 'tworst_job10conc', coords = vec3(-1954.655, 575.362, 115.819), rot = vec3(0.46, 2.16, -0.22) },
                { model = 'tworst_job10conc', coords = vec3(-1953.777, 573.230, 115.572), rot = vec3(0.91, 2.05, 0.53) },
                { model = 'tworst_job10conc', coords = vec3(-1955.024, 573.459, 115.573), rot = vec3(0.87, 2.01, -0.15) },
            },
        },

        {
            id     = 'sidewalk3',
            cover = { model = 'tw_job10parquet3', coords = vec3(502.539, 276.439, 102.047), rot = vec3(0.0, 0.0, 0.0) },
            zones  = { sand = 'buildermainzone', hole = 'excavator3' },
            label  = 'Sidewalk Repair #3 (large)',
            center = vec3(502.629, 276.257, 102.024),

            minCrew = 3, maxCrew = 4,
            crewPerSite = 2,
            truckLoads  = 2,

            sandPile   = vec4(1067.204, 2359.826, 42.892, 0.0),
            jcbSpawn   = vec4(1016.74, 2364.58, 50.46, 280.0),
            truckSpawn = vec4(1017.55, 2356.14, 51.27, 280.0),
            stonePiles = {
                { coords = vec3(502.582, 285.942, 102.001), rot = vec3(-2.864, 1.490, 359.712),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
                { coords = vec3(502.582, 266.569, 102.001), rot = vec3(-2.864, 1.490, 359.712),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
            },

            holeFill = {
                { model = 'tworst_job10h3dirt1', coords = vec3(502.629, 276.257, 100.934), rot = vec3(0.000, -0.030, 1.131) },
                { model = 'tworst_job10h3dirt2', coords = vec3(502.629, 276.257, 101.068), rot = vec3(0.000, -0.030, 1.131) },
                { model = 'tworst_job10h3dirt3', coords = vec3(502.629, 276.258, 101.408), rot = vec3(0.000, -0.030, 1.131) },
                { model = 'tworst_job10h3dirt4', coords = vec3(502.629, 276.258, 101.633), rot = vec3(0.000, -0.030, 1.131) },
                { model = 'tworst_job10h3dirt5', coords = vec3(502.629, 276.259, 101.893), rot = vec3(0.000, -0.030, 1.131) },
                { model = 'tworst_job10h3dirt',  coords = vec3(502.629, 276.259, 102.024), rot = vec3(0.000, -0.030, 1.131) },
            },

            stoneSlots = {
                { model = 'tworst_job10h3con', coords = vec3(491.774, 278.190, 101.992), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(492.464, 280.028, 101.989), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(493.129, 281.871, 101.986), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(494.579, 281.349, 101.987), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(493.915, 279.505, 101.990), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(493.225, 277.667, 101.993), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(494.680, 277.143, 101.993), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(495.370, 278.981, 101.990), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(496.034, 280.824, 101.987), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(497.482, 280.302, 101.988), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(496.818, 278.459, 101.991), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(496.128, 276.621, 101.994), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(501.931, 274.530, 101.997), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(502.621, 276.367, 101.994), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(503.286, 278.211, 101.991), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(501.837, 278.733, 101.990), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(501.173, 276.889, 101.993), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(500.483, 275.052, 101.996), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(499.028, 275.576, 101.996), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(499.718, 277.414, 101.993), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(500.383, 279.257, 101.990), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(498.932, 279.780, 101.989), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(498.268, 277.936, 101.992), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(497.578, 276.098, 101.995), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(503.392, 274.003, 101.998), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(504.082, 275.841, 101.995), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(504.746, 277.685, 101.992), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(506.196, 277.162, 101.992), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(505.532, 275.319, 101.995), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(504.842, 273.481, 101.998), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(506.297, 272.956, 101.999), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(506.987, 274.794, 101.996), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(507.651, 276.638, 101.993), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(509.099, 276.116, 101.994), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(508.435, 274.272, 101.997), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(507.745, 272.434, 102.000), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(513.466, 274.542, 101.996), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(512.802, 272.698, 101.999), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(512.112, 270.861, 102.002), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(510.657, 271.385, 102.001), rot = vec3(-0.09, 0.31, 89.35) },
                { model = 'tworst_job10h3con', coords = vec3(511.347, 273.223, 101.998), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(512.012, 275.066, 101.995), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(510.561, 275.589, 101.994), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(509.897, 273.745, 101.997), rot = vec3(-0.09, 0.31, 90.15) },
                { model = 'tworst_job10h3con', coords = vec3(509.207, 271.908, 102.000), rot = vec3(-0.09, 0.31, 89.35) },
            },
        },

        {
            id     = 'sidewalk4',
            cover = { model = 'tw_job10parquet4', coords = vec3(790.275, -2164.920, 28.583), rot = vec3(0.0, 0.0, 0.0) },
            zones  = { sand = 'buildermainzone', hole = 'excavator4' },
            label  = 'Sidewalk Repair #4 (large)',
            center = vec3(734.596, -2226.928, 28.253),

            minCrew = 3, maxCrew = 4,
            crewPerSite = 2,
            truckLoads  = 2,

            sandPile   = vec4(1067.204, 2359.826, 42.892, 0.0),
            jcbSpawn   = vec4(1016.74, 2364.58, 50.46, 280.0),
            truckSpawn = vec4(1017.55, 2356.14, 51.27, 280.0),
            stonePiles = {
                { coords = vec3(741.339, -2226.898, 28.259), rot = vec3(-2.864, 1.490, 359.712),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
                { coords = vec3(727.558, -2226.898, 28.259), rot = vec3(-2.864, 1.490, 359.712),
                  stackStep = vec3(0.0020, 0.0050, 0.092) },
            },

            holeFill = {
                { model = 'tworst_job10h4dirt1', coords = vec3(734.596, -2226.928, 27.225), rot = vec3(-0.01, 0.00, -5.19) },
                { model = 'tworst_job10h4dirt2', coords = vec3(734.596, -2226.928, 27.378), rot = vec3(-0.01, 0.00, -5.19) },
                { model = 'tworst_job10h4dirt3', coords = vec3(734.597, -2226.928, 27.626), rot = vec3(-0.01, 0.00, -5.19) },
                { model = 'tworst_job10h4dirt4', coords = vec3(734.597, -2226.928, 27.943), rot = vec3(-0.01, 0.00, -5.19) },
                { model = 'tworst_job10h4dirt5', coords = vec3(734.598, -2226.928, 28.189), rot = vec3(-0.01, 0.00, -5.19) },
                { model = 'tworst_job10h4dirt', coords = vec3(734.598, -2226.928, 28.253), rot = vec3(-0.01, 0.00, -5.19) },
            },

            stoneSlots = {
                { model = 'tworst_job10h4con', coords = vec3(735.455, -2238.363, 28.262), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(731.558, -2237.913, 28.255), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(733.508, -2238.149, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(733.642, -2236.606, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(731.693, -2236.369, 28.255), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(735.590, -2236.819, 28.262), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(735.724, -2235.286, 28.262), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(731.827, -2234.836, 28.255), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(733.776, -2235.072, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(733.911, -2233.531, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(731.961, -2233.295, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(735.859, -2233.745, 28.262), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(735.992, -2232.219, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(732.095, -2231.770, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(734.044, -2232.006, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(734.179, -2230.462, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(732.229, -2230.226, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(736.127, -2230.676, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(736.262, -2229.135, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(732.364, -2228.685, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(734.314, -2228.922, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(734.448, -2227.385, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(732.498, -2227.149, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(736.396, -2227.599, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(736.530, -2226.067, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(732.632, -2225.617, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(734.582, -2225.854, 28.260), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(734.716, -2224.319, 28.261), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(732.766, -2224.083, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(736.664, -2224.533, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(736.798, -2222.992, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(732.901, -2222.542, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(734.850, -2222.778, 28.261), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(734.985, -2221.233, 28.261), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(733.036, -2220.996, 28.256), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(736.933, -2221.446, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(737.339, -2216.802, 28.264), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(733.441, -2216.352, 28.257), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(735.391, -2216.588, 28.261), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(735.256, -2218.134, 28.261), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con', coords = vec3(733.306, -2217.897, 28.257), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(737.204, -2218.347, 28.264), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(737.069, -2219.888, 28.263), rot = vec3(0.02, -0.01, 14.40) },
                { model = 'tworst_job10h4con', coords = vec3(733.172, -2219.438, 28.257), rot = vec3(0.02, -0.01, 12.88) },
                { model = 'tworst_job10h4con', coords = vec3(735.121, -2219.675, 28.261), rot = vec3(0.02, -0.01, 13.77) },
                { model = 'tworst_job10h4con2', coords = vec3(735.988, -2215.433, 28.234), rot = vec3(0.02, -0.01, 14.40) },
            },
        },
    },
}

do
    local nSites = #(Config.ExcavatorJob.sites or {})
    if nSites < 2 then
        Config.ExcavatorJob.crewProfiles[4] = { vehicles = { jcb = 1, tiptruck = 1 } }
        Config.ExcavatorJob.maxPlayers = 2
        if IsDuplicityVersion and IsDuplicityVersion() then
            print('^3[excavator]^7 single site defined -> quota set to 1 crew, maxPlayers set '
                .. 'to 2. It becomes 4 automatically once a second site is added.')
        end
    end
end
