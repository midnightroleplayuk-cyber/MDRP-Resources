Config = {}

-- Enabling this will add additional prints and display of the resource within the pot
Config.debug = false

--
Config.locale = 'en'

--
Config.items = {
    cocaLeaf = 'coca_leaf',
    cocaBlend = 'coca_blend',
    cocaPaste = 'coca_paste',
    gasoline = 'gasoline',
    hydrochloricAcid = 'hydrochloric_acid',
    cement = 'cement',
    cocaine = 'coke',
}

-- Controls the game map and mini-map display
-- When changing the map style, you will have to rejoin the server to see the effects
Config.map = {
    displayIslandOnGameMap = true,

    -- 0 = default base game (Grayscale) style
    -- 1 = Color map style (Created by @MarDarVin)
    style = 0,
}

Config.basic = {
    coca = {
        -- Duration of the coca plant collection (in ms)
        collectDuration = 4000,
    },
    pit = {
        -- The amount that the pits should be filled on script start-up
        defaultPitFillPercentage = 25,

        -- How much percentage the pit should get filled with leaves per one coca leaf item
        fillPerLeaf = 0.5,

        -- How much percentage the pit should get filled with cement per one cement item
        fillPerCementBag = 30,

        -- The amount of leaves percentage that will be deducted from the pit when a player gets coca blend
        leavesCost = 2,

        -- The amount cement percentage that will be deducted from the pit when a player gets coca blend
        cementCost = 2,

        -- The distance that the players need to walk inside the pit to receive a coca blend item
        distanceBetweenReward = 8,

        -- How many cocaine items should the player get from one pit process
        rewardAmount = 1,

        -- Whether the custom walking animation should be enabled when walking inside the pit
        enableCustomMovementClipset = true,

        -- Whether to enable target options to the pit. Alongside the usable items (will only work if kq_link has target enabled)
        enableTargetOptions = true,
    },
    barrel = {
        -- Duration of the processing process in seconds
        duration = 45,

        -- Duration of time for which the owner (player adding the last item) will have the exclusive permissions of picking up the final item
        -- (During this period other players will not be able to take the final item) (Time in seconds)
        gracePeriod = 4,

        -- How many coca blend items will players put into the barrel at once/will be required to have to process it
        cocaBlendCost = 10,

        -- How many gasoline items will players put into the barrel at once/will be required to have to process it
        gasolineCost = 1,

        -- How many coca paste items should the player get from one barrel process
        rewardAmount = 1,
    },
    firepit = {
        -- Duration of the processing process in seconds
        duration = 60,

        -- Duration of time for which the owner (player adding the last item) will have the exclusive permissions of picking up the final item
        -- (During this period other players will not be able to take the final item) (Time in seconds)
        gracePeriod = 4,

        -- How many coca paste items will players put into the firepit at once/will be required to have to process it
        cocaPasteCost = 2,

        -- How many hydrochloric acid items will players put into the firepit at once/will be required to have to process it
        acidCost = 1,

        -- How many cocaine items should the player get from one firepit process
        rewardAmount = 1,
    },
}

-- The stomping pits
Config.pits = {
    ['main_1'] = {
        enabled = true,
        coords = vec3(5507.08, 2112.97, 10.31),
        rotation = vec3(-2.4, 0.7, 171.10)
    },
    ['addon_a_1'] = {
        enabled = false,
        coords = vec3(4294.01, 7713.74, 7.11),
        rotation = vec3(-2.3, -3.28, 171.7)
    },
    ['addon_b_1'] = {
        enabled = false,
        coords = vec3(-6394.12, 2772.58, 5.6),
        rotation = vec3(0, 0, 42)
    },
    ['addon_c_1'] = {
        enabled = false,
        coords = vec3(5161.87, -1212.85, 11.76),
        rotation = vec3(0.8, -.34, -52.52)
    },
}

-- The fire pits
Config.firepits = {
    ['main_1'] = {
        enabled = true,
        coords = vec3(5528.17, 2110.47, 9.89),
        rotation = vec3(-2.4, 0.7, 171)
    },
    ['main_2'] = {
        enabled = true,
        coords = vec3(5529.44, 2112.34, 10.67),
        rotation = vec3(-2.4, 0.7, 111)
    },
    ['addon_a_1'] = {
        enabled = false,
        coords = vec3(4275.0, 7724.18, 6.51),
        rotation = vec3(-2.4, 0.7, 75)
    },
    ['addon_b_1'] = {
        enabled = false,
        coords = vec3(-6371.59, 2770.76, 5.85),
        rotation = vec3(0, 0, 80)
    },
    ['addon_b_2'] = {
        enabled = false,
        coords = vec3(-6369.68, 2772.02, 5.6),
        rotation = vec3(0, 0, 100)
    },
    ['addon_b_3'] = {
        enabled = false,
        coords = vec3(-6384.28, 2817.21, 5.65),
        rotation = vec3(0, 0, 0)
    },
    ['addon_c_1'] = {
        enabled = false,
        coords = vec3(5144.55, -1221.04, 11.56),
        rotation = vec3(0, 0, 0)
    },
    ['addon_c_2'] = {
        enabled = false,
        coords = vec3(5173.03, -1214.89, 12.12),
        rotation = vec3(0, 0, 43)
    },
}

-- The processing barrels
Config.barrels = {
    ['main_1'] = {
        enabled = true,
        coords = vec3(5506.38, 2120.38, 10.61),
        rotation = vec3(0.15, 3.7, -104.28)
    },
    ['main_2'] = {
        enabled = true,
        coords = vec3(5507.6, 2119.94, 10.61),
        rotation = vec3(0.15, 3.7, -104.28)
    },
    ['main_3'] = {
        enabled = true,
        coords = vec3(5512.89, 2102.70, 9.98),
        rotation = vec3(0.58, 2.54, 53.0)
    },
    ['addon_a_1'] = {
        enabled = false,
        coords = vec3(4283.65, 7725.79, 6.75),
        rotation = vec3(0.58, 2.54, 260.0)
    },
    ['addon_a_2'] = {
        enabled = false,
        coords = vec3(4282.42, 7725.94, 6.75),
        rotation = vec3(0.58, 2.54, 255.0)
    },
    ['addon_a_3'] = {
        enabled = false,
        coords = vec3(4280.91, 7726.0, 7.75),
        rotation = vec3(0.58, 2.54, 280.0)
    },
    ['addon_b_1'] = {
        enabled = false,
        coords = vec3(-6387.74, 2791.32, 5.69),
        rotation = vec3(0, 0, 320)
    },
    ['addon_b_2'] = {
        enabled = false,
        coords = vec3(-6386.45, 2792.44, 5.69),
        rotation = vec3(0, 0, 310)
    },
    ['addon_b_3'] = {
        enabled = false,
        coords = vec3(-6381.39, 2794.15, 5.7),
        rotation = vec3(0, 0, 225)
    },
    ['addon_b_4'] = {
        enabled = false,
        coords = vec3(-6391.21, 2760.84, 5.64),
        rotation = vec3(0, 0, 45)
    },
    ['addon_b_5'] = {
        enabled = false,
        coords = vec3(-6396.08, 2801.34, 5.82),
        rotation = vec3(0, 0, 282)
    },
    ['addon_c_1'] = {
        enabled = false,
        coords = vec3(5141.49, -1215.24, 11.47),
        rotation = vec3(0, 0, 27)
    },
    ['addon_c_2'] = {
        enabled = false,
        coords = vec3(5142.23, -1216.33, 11.47),
        rotation = vec3(0, 0, 25)
    },
    ['addon_c_3'] = {
        enabled = false,
        coords = vec3(5143.71, -1213.74, 11.56),
        rotation = vec3(0, 0, 273)
    },
}


-- All the plantations which will spawn coca plants
Config.plantations = {
    ['main_1'] = {
        -- Whether the plantation should be enabled
        enabled = true,

        regrowTime = 30, -- time in minutes

        -- Center point of the plantation
        coords = vec3(5503.25, 2134.7, 11.1),

        -- Amount of coca leaves per plant
        amounts = {
            min = 3,
            max = 5,
        },

        plants = {
            vec3(5500.0, 2128.41, 10.93),
            vec3(5498.82, 2128.87, 10.9),
            vec3(5497.21, 2129.4, 10.9),
            vec3(5495.45, 2130.08, 10.94),
            vec3(5493.54, 2130.8, 10.91),
            vec3(5491.75, 2131.47, 10.89),
            vec3(5490.14, 2132.04, 10.94),
            vec3(5488.42, 2132.53, 10.91),
            vec3(5486.67, 2133.18, 10.9),
            vec3(5484.76, 2133.8, 10.87),
            vec3(5483.11, 2134.51, 10.92),
            vec3(5481.89, 2135.04, 10.87),
            vec3(5479.73, 2135.75, 10.87),
            vec3(5481.77, 2139.21, 11.06),
            vec3(5483.2, 2138.64, 11.06),
            vec3(5484.79, 2138.03, 11.07),
            vec3(5486.49, 2137.44, 11.08),
            vec3(5488.23, 2136.79, 11.08),
            vec3(5489.7, 2136.22, 11.08),
            vec3(5491.55, 2135.54, 11.12),
            vec3(5493.04, 2134.99, 11.09),
            vec3(5494.72, 2134.37, 11.12),
            vec3(5496.15, 2133.87, 11.12),
            vec3(5497.65, 2133.34, 11.1),
            vec3(5499.92, 2132.6, 11.15),
            vec3(5501.51, 2132.1, 11.05),
            vec3(5512.52, 2131.7, 11.31),
            vec3(5510.91, 2132.51, 11.31),
            vec3(5509.34, 2133.32, 11.3),
            vec3(5507.9, 2133.74, 11.31),
            vec3(5506.32, 2134.48, 11.32),
            vec3(5504.45, 2135.12, 11.3),
            vec3(5502.77, 2135.7, 11.3),
            vec3(5501.06, 2136.29, 11.28),
            vec3(5498.97, 2136.98, 11.28),
            vec3(5496.96, 2137.7, 11.27),
            vec3(5495.06, 2138.35, 11.24),
            vec3(5493.4, 2139.01, 11.26),
            vec3(5491.69, 2139.6, 11.21),
            vec3(5490.01, 2140.29, 11.25),
            vec3(5488.09, 2141.1, 11.21),
            vec3(5486.38, 2141.54, 11.24),
            vec3(5484.46, 2142.11, 11.2),
            vec3(5482.49, 2142.96, 11.16),
            vec3(5483.23, 2146.15, 11.35),
            vec3(5485.44, 2145.45, 11.38),
            vec3(5487.28, 2144.61, 11.37),
            vec3(5488.97, 2144.04, 11.4),
            vec3(5490.59, 2143.39, 11.38),
            vec3(5492.16, 2142.81, 11.39),
            vec3(5494.0, 2142.23, 11.42),
            vec3(5496.22, 2141.46, 11.4),
            vec3(5498.09, 2140.78, 11.38),
            vec3(5500.56, 2139.87, 11.42),
            vec3(5502.56, 2139.14, 11.42),
            vec3(5504.67, 2138.38, 11.43),
            vec3(5506.96, 2137.46, 11.44),
            vec3(5508.92, 2136.84, 11.45),
            vec3(5511.01, 2136.04, 11.45),
            vec3(5513.1, 2135.21, 11.45),
            vec3(5515.26, 2134.38, 11.46),
            vec3(5517.29, 2137.38, 11.59),
            vec3(5515.87, 2138.3, 11.61),
            vec3(5514.15, 2138.96, 11.62),
            vec3(5512.33, 2139.68, 11.62),
            vec3(5511.02, 2140.16, 11.63),
            vec3(5509.08, 2140.84, 11.61),
            vec3(5506.53, 2141.67, 11.63),
            vec3(5500.81, 2143.81, 11.53),
            vec3(5498.94, 2144.48, 11.56),
            vec3(5496.92, 2145.22, 11.56),
            vec3(5494.78, 2146.0, 11.57),
            vec3(5492.42, 2146.82, 11.52),
            vec3(5490.0, 2147.77, 11.55),
            vec3(5487.68, 2148.58, 11.53),
            vec3(5484.42, 2149.64, 11.5),
            vec3(5478.08, 2156.86, 11.55),
            vec3(5474.79, 2161.74, 11.68),
            vec3(5477.88, 2168.39, 11.9),
            vec3(5484.8, 2157.3, 11.69),
            vec3(5498.39, 2156.2, 11.88),
            vec3(5511.71, 2151.16, 11.92),
            vec3(5516.42, 2147.83, 11.87),
            vec3(5517.04, 2093.07, 9.65),
            vec3(5480.0, 2091.74, 11.69),
            vec3(5473.17, 2110.97, 9.78),
            vec3(5467.57, 2118.38, 9.94),
            vec3(5475.64, 2128.81, 10.4),
        }
    },
    ['addon_a_1'] = {
        -- Whether the plantation should be enabled
        enabled = false,

        regrowTime = 30, -- time in minutes

        -- Center point of the plantation
        coords = vec3(4286.52, 7705.35, 7.04),

        -- Amount of coca leaves per plant
        amounts = {
            min = 3,
            max = 5,
        },

        plants = {
            vec3(4286.52, 7705.35, 7.04),
            vec3(4287.38, 7703.79, 6.97),
            vec3(4286.73, 7701.68, 6.93),
            vec3(4284.16, 7700.55, 6.94),
            vec3(4282.59, 7701.94, 6.97),
            vec3(4280.3, 7703.74, 7.05),
            vec3(4278.11, 7702.48, 7.0),
            vec3(4280.89, 7699.18, 6.94),
            vec3(4281.33, 7696.56, 6.93),
            vec3(4283.05, 7696.04, 6.93),
            vec3(4284.7, 7697.36, 6.93),
            vec3(4286.54, 7699.08, 6.93),
            vec3(4290.31, 7702.02, 6.93),
            vec3(4294.45, 7703.49, 6.9),
            vec3(4284.52, 7694.55, 6.93),
            vec3(4283.37, 7691.91, 6.93),
            vec3(4282.2, 7690.24, 6.92),
            vec3(4280.54, 7690.91, 6.92),
            vec3(4279.64, 7692.56, 6.93),
            vec3(4280.83, 7693.62, 6.93),
            vec3(4282.08, 7692.83, 6.93),
            vec3(4279.11, 7695.28, 6.93),
            vec3(4277.38, 7696.23, 6.93),
            vec3(4275.93, 7698.2, 6.93),
            vec3(4275.7, 7699.84, 6.94),
            vec3(4274.13, 7700.82, 6.94),
            vec3(4272.06, 7699.88, 6.93),
            vec3(4272.48, 7698.21, 6.93),
            vec3(4274.17, 7699.05, 6.93),
            vec3(4275.5, 7702.31, 6.98),
            vec3(4277.04, 7704.16, 7.08),
            vec3(4277.48, 7694.38, 6.92),
            vec3(4277.51, 7691.73, 6.93),
            vec3(4278.55, 7690.02, 6.91),
            vec3(4279.96, 7688.3, 6.9),
            vec3(4281.86, 7687.71, 6.89),
            vec3(4278.14, 7689.04, 6.9),
            vec3(4275.76, 7688.54, 6.85),
            vec3(4273.88, 7690.35, 6.86),
            vec3(4275.14, 7691.96, 6.91),
            vec3(4269.53, 7709.25, 7.31),
            vec3(4268.21, 7711.96, 7.37),
            vec3(4273.34, 7729.21, 7.74),
            vec3(4273.14, 7735.13, 7.88),
            vec3(4277.91, 7738.61, 7.72),
            vec3(4284.4, 7748.22, 7.04),
            vec3(4285.32, 7753.09, 6.8),
            vec3(4285.24, 7756.35, 6.75),
            vec3(4287.53, 7757.9, 6.75),
            vec3(4289.64, 7759.98, 6.75),
            vec3(4281.6, 7754.95, 6.76),
            vec3(4277.29, 7752.31, 6.78),
            vec3(4272.31, 7745.97, 6.89),
            vec3(4266.28, 7745.98, 6.97),
            vec3(4263.07, 7740.73, 7.32),
            vec3(4265.32, 7732.92, 7.54),
            vec3(4261.42, 7728.87, 7.56),
            vec3(4258.32, 7731.59, 7.5),
            vec3(4258.2, 7735.52, 7.45),
            vec3(4254.77, 7731.07, 7.41),
            vec3(4252.44, 7732.66, 7.34),
            vec3(4257.27, 7739.23, 7.42),
            vec3(4259.67, 7740.36, 7.42),
            vec3(4263.68, 7750.51, 7.3),
            vec3(4271.1, 7755.37, 6.75),
            vec3(4293.66, 7748.63, 6.93),
            vec3(4296.52, 7756.6, 6.8),
            vec3(4305.98, 7760.75, 6.8),
            vec3(4309.92, 7758.13, 6.75),
            vec3(4304.19, 7752.93, 6.79),
            vec3(4309.57, 7746.48, 6.75),
            vec3(4318.09, 7739.05, 6.75),
            vec3(4318.59, 7732.12, 6.75),
            vec3(4317.36, 7721.71, 5.33),
            vec3(4315.65, 7719.71, 5.4),
            vec3(4313.62, 7716.46, 5.87),
            vec3(4312.77, 7718.65, 5.92),
            vec3(4311.83, 7721.47, 6.15),
            vec3(4311.06, 7718.33, 6.33),
            vec3(4298.88, 7654.58, 8.0),
            vec3(4300.01, 7656.91, 7.95),
            vec3(4304.83, 7655.86, 8.23),
            vec3(4308.99, 7654.1, 8.12),
            vec3(4311.76, 7647.65, 7.81),
            vec3(4303.83, 7647.23, 7.73),
            vec3(4291.02, 7662.75, 6.75),
            vec3(4291.51, 7669.06, 6.83),
            vec3(4295.19, 7671.84, 6.79),
            vec3(4298.68, 7673.43, 6.9),
            vec3(4296.77, 7676.52, 6.83),
            vec3(4289.18, 7678.83, 6.75),
            vec3(4282.46, 7677.15, 6.74),
            vec3(4280.11, 7673.8, 6.74),
            vec3(4278.5, 7674.61, 6.74),
            vec3(4270.83, 7682.31, 6.74),
            vec3(4269.33, 7684.84, 6.74),
            vec3(4261.71, 7682.02, 6.64),
        }
    },
    ['addon_b_1'] = {
        -- Whether the plantation should be enabled
        enabled = false,

        regrowTime = 30, -- time in minutes

        -- Center point of the plantation
        coords = vec3(-6355.29, 2804.03, 5.6),

        -- Amount of coca leaves per plant
        amounts = {
            min = 3,
            max = 5,
        },

        plants = {
            vec3(-6349.99, 2784.52, 5.77),
            vec3(-6350.49, 2776.78, 5.77),
            vec3(-6350.47, 2772.06, 5.61),
            vec3(-6351.02, 2764.78, 5.61),
            vec3(-6352.89, 2756.63, 5.69),
            vec3(-6365.97, 2753.65, 5.62),
            vec3(-6370.18, 2754.86, 5.57),
            vec3(-6373.57, 2757.75, 5.76),
            vec3(-6377.78, 2757.4, 5.79),
            vec3(-6382.09, 2758.49, 5.7),
            vec3(-6381.27, 2754.08, 6.22),
            vec3(-6384.7, 2750.89, 6.31),
            vec3(-6391.23, 2756.89, 5.89),
            vec3(-6394.09, 2758.86, 5.84),
            vec3(-6404.55, 2763.57, 6.08),
            vec3(-6404.64, 2768.93, 5.7),
            vec3(-6407.57, 2777.27, 5.68),
            vec3(-6402.12, 2782.25, 5.68),
            vec3(-6398.32, 2793.6, 6.13),
            vec3(-6402.23, 2798.2, 5.69),
            vec3(-6408.17, 2798.57, 5.61),
            vec3(-6408.54, 2802.07, 5.62),
            vec3(-6410.11, 2807.86, 5.65),
            vec3(-6411.2, 2810.15, 5.75),
            vec3(-6414.2, 2810.6, 5.74),
            vec3(-6413.37, 2813.31, 5.83),
            vec3(-6411.0, 2813.71, 5.83),
            vec3(-6409.35, 2816.32, 5.71),
            vec3(-6411.27, 2817.32, 5.94),
            vec3(-6413.28, 2815.51, 5.86),
            vec3(-6415.66, 2815.21, 5.49),
            vec3(-6412.71, 2827.05, 5.82),
            vec3(-6410.18, 2830.75, 5.75),
            vec3(-6410.16, 2835.19, 5.62),
            vec3(-6376.82, 2815.18, 5.97),
            vec3(-6380.0, 2824.63, 5.78),
            vec3(-6379.39, 2829.75, 5.76),
            vec3(-6377.02, 2832.94, 5.76),
            vec3(-6379.51, 2840.54, 5.7),
            vec3(-6384.44, 2850.52, 5.67),
            vec3(-6377.25, 2853.79, 5.66),
            vec3(-6357.08, 2848.58, 5.7),
            vec3(-6353.75, 2847.49, 6.1),
            vec3(-6350.57, 2846.94, 6.13),
            vec3(-6347.87, 2844.99, 5.66),
            vec3(-6345.63, 2842.8, 5.63),
            vec3(-6350.48, 2836.67, 5.66),
            vec3(-6353.84, 2836.45, 5.67),
            vec3(-6354.82, 2843.81, 6.05),
            vec3(-6350.94, 2845.02, 6.29),
            vec3(-6346.92, 2847.41, 5.8),
            vec3(-6342.74, 2850.45, 6.12),
            vec3(-6339.96, 2848.09, 5.59),
            vec3(-6333.41, 2849.33, 5.61),
            vec3(-6331.26, 2851.81, 5.61),
            vec3(-6328.0, 2850.48, 5.61),
            vec3(-6326.05, 2856.76, 5.54),
            vec3(-6323.77, 2857.78, 5.65),
            vec3(-6321.15, 2856.92, 5.72),
            vec3(-6318.65, 2856.17, 5.59),
            vec3(-6318.03, 2857.51, 5.64),
            vec3(-6320.75, 2858.44, 6.0),
            vec3(-6323.42, 2855.82, 5.57),
            vec3(-6325.19, 2855.16, 5.59),
            vec3(-6325.63, 2858.82, 5.54),
            vec3(-6325.39, 2861.83, 5.35),
            vec3(-6329.22, 2862.93, 5.29),
            vec3(-6332.57, 2862.92, 5.25),
            vec3(-6337.33, 2858.33, 5.59),
            vec3(-6338.71, 2854.88, 6.02),
            vec3(-6341.87, 2845.94, 5.61),
            vec3(-6318.31, 2817.55, 5.61),
            vec3(-6313.51, 2817.63, 5.24),
            vec3(-6308.53, 2818.15, 5.43),
            vec3(-6307.71, 2821.23, 5.55),
            vec3(-6306.22, 2823.14, 5.62),
            vec3(-6308.67, 2823.18, 5.61),
            vec3(-6311.37, 2820.33, 5.4),
            vec3(-6310.19, 2811.62, 5.51),
            vec3(-6312.36, 2807.02, 5.32),
            vec3(-6317.1, 2802.35, 5.56),
            vec3(-6320.64, 2796.43, 7.02),
            vec3(-6318.96, 2790.48, 6.31),
            vec3(-6320.95, 2772.8, 5.61),
            vec3(-6322.96, 2768.45, 5.55),
            vec3(-6328.08, 2760.87, 5.53),
            vec3(-6318.41, 2760.91, 4.75),
            vec3(-6338.31, 2766.48, 7.07),
            vec3(-6342.79, 2763.09, 6.53),
            vec3(-6347.36, 2763.73, 6.03),
            vec3(-6350.42, 2763.11, 5.58),
            vec3(-6346.97, 2759.98, 6.06),
            vec3(-6343.33, 2759.22, 6.05),
            vec3(-6338.19, 2760.12, 6.32),
            vec3(-6335.46, 2769.28, 7.27),
            vec3(-6351.53, 2775.29, 5.61),
        }
    },
    ['addon_c_1'] = {
        -- Whether the plantation should be enabled
        enabled = false,

        regrowTime = 30, -- time in minutes

        -- Center point of the plantation
        coords = vec3(5073.64, -1046.02, 12.85),

        -- Amount of coca leaves per plant
        amounts = {
            min = 3,
            max = 5,
        },

        plants = {
            vec3(5088.8, -1049.87, 12.67),
            vec3(5087.45, -1050.67, 12.66),
            vec3(5085.79, -1051.69, 12.68),
            vec3(5084.31, -1052.39, 12.72),
            vec3(5082.31, -1053.33, 12.8),
            vec3(5080.72, -1054.4, 12.87),
            vec3(5078.88, -1055.63, 12.95),
            vec3(5076.81, -1056.96, 13.02),
            vec3(5075.31, -1057.81, 13.05),
            vec3(5073.89, -1058.63, 13.07),
            vec3(5072.3, -1059.48, 13.07),
            vec3(5070.65, -1060.38, 13.08),
            vec3(5068.98, -1061.41, 13.09),
            vec3(5067.12, -1062.64, 13.1),
            vec3(5065.33, -1063.75, 13.12),
            vec3(5063.52, -1064.85, 13.18),
            vec3(5063.63, -1063.46, 13.15),
            vec3(5065.88, -1061.78, 13.09),
            vec3(5067.91, -1060.85, 13.08),
            vec3(5069.58, -1059.85, 13.07),
            vec3(5071.7, -1058.5, 13.06),
            vec3(5073.48, -1057.41, 13.05),
            vec3(5075.61, -1056.13, 13.01),
            vec3(5077.32, -1055.08, 12.96),
            vec3(5079.12, -1054.18, 12.89),
            vec3(5081.11, -1052.96, 12.82),
            vec3(5083.06, -1051.85, 12.76),
            vec3(5085.12, -1050.63, 12.71),
            vec3(5086.57, -1049.74, 12.69),
            vec3(5088.17, -1048.86, 12.69),
            vec3(5084.3, -1041.73, 12.94),
            vec3(5081.97, -1042.78, 12.91),
            vec3(5079.86, -1043.66, 12.88),
            vec3(5078.18, -1044.71, 12.86),
            vec3(5076.63, -1045.7, 12.85),
            vec3(5074.73, -1046.72, 12.86),
            vec3(5072.73, -1047.91, 12.9),
            vec3(5070.95, -1049.04, 12.96),
            vec3(5069.62, -1049.81, 13.0),
            vec3(5067.77, -1050.89, 13.04),
            vec3(5065.95, -1052.05, 13.06),
            vec3(5064.19, -1053.03, 13.07),
            vec3(5062.4, -1053.99, 13.08),
            vec3(5060.43, -1055.21, 13.09),
            vec3(5060.07, -1053.83, 13.1),
            vec3(5062.26, -1052.66, 13.09),
            vec3(5063.89, -1051.76, 13.1),
            vec3(5065.81, -1050.66, 13.08),
            vec3(5067.88, -1049.41, 13.04),
            vec3(5069.67, -1048.32, 12.98),
            vec3(5071.72, -1047.13, 12.9),
            vec3(5073.64, -1046.02, 12.85),
            vec3(5075.64, -1044.84, 12.85),
            vec3(5077.51, -1043.76, 12.86),
            vec3(5079.64, -1042.52, 12.9),
            vec3(5081.3, -1041.58, 12.94),
            vec3(5082.83, -1040.83, 12.98),
            vec3(5084.29, -1040.08, 13.03),
            vec3(5079.19, -1032.16, 13.39),
            vec3(5077.37, -1033.07, 13.31),
            vec3(5075.12, -1034.24, 13.25),
            vec3(5072.51, -1035.5, 13.24),
            vec3(5070.28, -1036.66, 13.26),
            vec3(5067.89, -1037.98, 13.27),
            vec3(5065.93, -1039.07, 13.29),
            vec3(5063.51, -1040.36, 13.33),
            vec3(5061.34, -1041.67, 13.37),
            vec3(5059.35, -1043.13, 13.4),
            vec3(5057.13, -1044.78, 13.43),
            vec3(5054.43, -1046.79, 13.4),
            vec3(5054.47, -1045.55, 13.45),
            vec3(5058.4, -1045.17, 13.36),
            vec3(5060.84, -1043.26, 13.33),
            vec3(5062.97, -1041.73, 13.29),
            vec3(5064.98, -1040.85, 13.22),
            vec3(5066.74, -1039.85, 13.19),
            vec3(5069.5, -1038.27, 13.16),
            vec3(5071.87, -1036.74, 13.18),
            vec3(5074.29, -1035.24, 13.22),
            vec3(5077.04, -1031.86, 13.36),
            vec3(5084.62, -1017.13, 13.8),
            vec3(5072.81, -1024.13, 13.86),
            vec3(5052.32, -1038.18, 13.94),
            vec3(5043.04, -1053.18, 13.11),
            vec3(5041.23, -1062.99, 13.12),
            vec3(5047.18, -1068.58, 13.12),
            vec3(5051.74, -1073.36, 13.07),
            vec3(5049.67, -1074.42, 13.12),
        }
    },
}

-- Simple item collection system. You'll probably want to replace it with your own more advanced system for gathering supplies.
-- We recommend adding these items to your stores, robberies etc.
-- Obviously this system works perfectly fine, it's just a simple solution for easy looting
Config.itemCollection = {
    {
        enabled = true,
        label = 'hydrochloric acid',

        model = 'tr_prop_meth_hcacid',
        offset = vec3(0, 0, 0),
        interactionDistance = 2,

        item = 'hydrochloric_acid',
        amount = 1,

        animation = {
            dict = 'anim@heists@load_box',
            name = 'lift_box',

            attachment = {
                holdModel = 'tr_prop_meth_hcacid',

                delay = 1200,
                bone = 57005,
                offset = vec3(0.05, 0.0, -0.25),
                rotation = vec3(0, 90, 120),
            }
        },

        -- Find out more: https://docs.fivem.net/docs/game-references/blips/
        blip = {
            sprite = 653,
            color = 39,
            alpha = 255, -- 0 to 255
            scale = 0.5,
            label = 'Hydrochloric acid'
        },

        -- All locations of where the loot should spawn at
        locations = {
            {
                coords = vec3(816.27, -3186.96, 4.9),
                rotation = vec3(0, 0, 40),
                blip = false,
            },
            {
                coords = vec3(1738.19, -1610.4, 111.46),
                rotation = vec3(0, 0, 40),
                blip = false,
            },
            {
                coords = vec3(-226.42, -2667.34, 5.0),
                rotation = vec3(0, 0, 40),
                blip = false,
            },
            {
                coords = vec3(106.02, 6627.5, 30.79),
                rotation = vec3(0, 0, 40),
                blip = false,
            },
        },
    },
    {
        enabled = true,
        label = 'gasoline',

        model = 'prop_jerrycan_01a',
        offset = vec3(0, 0, 0),
        interactionDistance = 2,

        item = 'gasoline',
        amount = 1,

        animation = {
            dict = 'anim@heists@load_box',
            name = 'lift_box',

            attachment = {
                holdModel = 'prop_jerrycan_01a',

                delay = 1200,
                bone = 57005,
                offset = vec3(0.05, 0.0, -0.25),
                rotation = vec3(0, 90, 120),
            }
        },

        -- Find out more: https://docs.fivem.net/docs/game-references/blips/
        blip = {
            sprite = 653,
            color = 39,
            alpha = 255, -- 0 to 255
            scale = 0.5,
            label = 'Gasoline'
        },

        -- All locations of where the loot should spawn at
        locations = {
            {
                coords = vec3(-2551.39, 2315.58, 32.22),
                rotation = vec3(0, 0, 329),
                blip = false,
            },
            {
                coords = vec3(-2073.11, -325.95, 12.32),
                rotation = vec3(0, 0, 270),
                blip = false,
            },
            {
                coords = vec3(1166.96, -322.19, 68.27),
                rotation = vec3(0, 0, 154),
                blip = false,
            },
            {
                coords = vec3(170.34, -1722.41, 28.39),
                rotation = vec3(0, 0, 355),
                blip = false,
            },
        },
    },
    {
        enabled = true,
        label = 'cement',

        model = 'prop_cons_cements01',
        offset = vec3(0, 0, 0),
        interactionDistance = 3,

        item = 'cement',
        amount = 1,

        animation = {
            dict = 'anim@heists@load_box',
            name = 'lift_box',

            attachment = {
                holdModel = 'kq_cement_bag',

                delay = 1200,
                bone = 57005,
                offset = vec3(0.05, 0.0, -0.25),
                rotation = vec3(90, 90, 120),
            }
        },

        -- Find out more: https://docs.fivem.net/docs/game-references/blips/
        blip = {
            sprite = 653,
            color = 39,
            alpha = 255, -- 0 to 255
            scale = 0.5,
            label = 'Cement pile'
        },

        -- All locations of where the loot should spawn at
        locations = {
            {
                coords = vec3(-440.55, -952.07, 28.39),
                rotation = vec3(0, 0, 75),
                blip = true,
            },
                {
                coords = vec3(-440.99, -953.4, 28.39),
                rotation = vec3(0, 0, 75),
                blip = true,
            },
                {
                coords = vec3(-470.53, -957.02, 29.41),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(-470.37, -955.57, 29.41),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(261.19, 2874.64, 42.61),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(261.19, 2874.64, 42.61),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(261.19, 2874.64, 42.61),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(261.19, 2874.64, 42.61),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(261.19, 2874.64, 42.61),
                rotation = vec3(0, 0, 125),
                blip = true,
            },
                {
                coords = vec3(261.19, 2874.64, 42.61),
                rotation = vec3(0, 0, 125),
                blip = true,
            },

        },
    },
}

-- https://docs.fivem.net/docs/game-references/controls/
-- Use the input index for the "input" value
Config.keybinds = {
    interact = {
        label = 'E',
        name = 'INPUT_PICKUP',
        input = 38,
    },
}

