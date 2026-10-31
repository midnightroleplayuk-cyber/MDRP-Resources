local FarmerJob = {

    id = "farmer",

    icon = "./img/jobs/farmer_icon.svg",
    image = "./img/jobs/farmer_bg.png",
    video = "https://tworst.info/uploads/videos/8fc17aaae64ae35bc148ccb44017c737_1775405596.mp4",
    enabled = true, -- true = job active | false = job disabled
    requiredHours = 0, -- minimum hours played to start this job (0 = no requirement, requires Config.HoursRequirement.enabled)
    maxHours = 0, -- maximum hours allowed to start this job (0 = no limit, e.g. 100 = players with 100+ hours cannot do this job)

    npc = {
        enabled = true, -- true = spawn NPC | false = no NPC
        coords = vector4(2932.43, 4624.21, 48.72, 48.98),
        model = "a_m_m_farmer_01",
        scenario = "WORLD_HUMAN_CLIPBOARD",
        interaction = {
            distance = 2.0,
            key = 38,
            keyLabel = "[E]",
        },
        blip = {
            enabled = true, -- true = show blip on map | false = no blip
            sprite = 631,
            color = 2,
            scale = 0.8,
        },
    },

    xprewards = {
        plantHarvested = 20,
        jobCompleted = 500,
    },

    payment = {
        mode = "onJobEnd", -- "onJobEnd" = pay all at job end | "perItem" = pay instantly per task
        completionBonus = 0, -- bonus paid once when job is fully completed
        coopMode = "full", -- "full" = everyone gets full pay | "split" = pay divided by player count
    },

    stepRewards = {
        -- Available phases: onLoad (box loaded into truck), onScale (box placed on scale), onProcess (scale boxes processed)
        onLoad    = { enabled = false, dropMode = "perItem", itemList = { { item = "sandwich", count = 1, chance = 10 } } },
        onProcess = { enabled = false, dropMode = "perItem", itemList = { { item = "water_bottle", count = 1, chance = 8 } } },
    },

    missioncompletedItems = {
        giveItemPlayer = false, -- true = give items on job complete | false = no items given
        dropMode = "weightedPool", -- "weightedPool" = pick one item by chance weight | "perItem" = each item rolls independently
        itemList = {
            { item = "sandwich",     count = 1, chance = 50 },
            { item = "water_bottle", count = 1, chance = 30 },
        },
    },

}

local runtime = {

    produceTypes = {
        lettuce = {
            name = "Lettuce",
            model = "prop_veg_crop_03_cab",
            price = 50,
            kgPerItem = 0.80,
            slotsPerItem = 1,
            zOffset = 0.05,
            breakScale = 0.3,
            harvestDist = 1.0,
        },
        pumpkin = {
            name = "Pumpkin",
            model = "prop_veg_crop_03_pumpkin",
            price = 65,
            kgPerItem = 3.50,
            slotsPerItem = 1,
            zOffset = 0.05,
            breakScale = 1.2,
            harvestDist = 1.4,
        },
        melon = {
            name = "Melon",
            model = "prop_veg_crop_03_kavun",
            price = 70,
            kgPerItem = 2.50,
            slotsPerItem = 1,
            zOffset = 0.05,
            breakScale = 0.3,
            harvestDist = 1.0,
        },
        watermelon = {
            name = "Watermelon",
            model = "prop_veg_crop_03_karpuz",
            price = 75,
            kgPerItem = 5.00,
            slotsPerItem = 1,
            zOffset = 0.05,
            breakScale = 1.5,
            harvestDist = 1.3,
        },
    },

    plantSpawns = {

        { coord = vector4(2948.04, 4673.83, 49.17, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2947.33, 4676.63, 49.55, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2946.57, 4680.18, 50.07, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2945.74, 4683.89, 50.59, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2944.93, 4687.60, 50.95, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2944.26, 4690.26, 51.23, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2943.69, 4693.38, 51.32, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2943.21, 4696.39, 51.31, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2941.14, 4695.75, 51.28, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2941.81, 4692.06, 51.27, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2942.59, 4688.37, 51.06, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2943.38, 4684.65, 50.70, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2944.16, 4681.06, 50.24, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2944.96, 4677.36, 49.65, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2945.85, 4673.36, 49.12, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },

        { coord = vector4(2943.75, 4672.75, 49.18, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2943.06, 4676.47, 49.54, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2942.32, 4680.19, 50.14, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2941.47, 4683.88, 50.64, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2940.61, 4687.54, 50.95, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2939.80, 4691.10, 51.18, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2939.04, 4694.86, 51.26, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2936.93, 4694.69, 51.08, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2937.69, 4691.06, 51.05, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2938.47, 4687.30, 50.90, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2939.23, 4683.69, 50.58, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2940.05, 4680.16, 50.14, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2940.83, 4676.47, 49.51, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2941.48, 4673.57, 49.26, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2941.97, 4671.20, 49.09, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },

        { coord = vector4(2940.05, 4671.12, 49.14, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2939.40, 4674.82, 49.36, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2938.58, 4678.35, 49.83, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2937.83, 4682.01, 50.35, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2937.05, 4685.58, 50.68, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2936.27, 4689.31, 50.91, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2935.45, 4693.05, 50.93, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2933.15, 4693.54, 50.82, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2933.89, 4690.10, 50.76, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2934.50, 4686.31, 50.70, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2935.28, 4682.76, 50.43, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2936.21, 4678.96, 49.97, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2937.04, 4675.22, 49.41, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2937.93, 4671.52, 49.16, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },

        { coord = vector4(2935.97, 4671.11, 49.14, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2935.26, 4674.62, 49.36, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2934.59, 4678.41, 49.91, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2933.66, 4682.00, 50.42, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2932.91, 4685.50, 50.66, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2932.17, 4689.07, 50.63, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2931.47, 4692.88, 50.68, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2929.24, 4692.56, 50.45, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2929.93, 4689.28, 50.53, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2930.68, 4685.40, 50.57, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2931.50, 4681.89, 50.37, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2932.29, 4678.46, 49.95, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2932.91, 4675.37, 49.41, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2933.42, 4672.64, 49.19, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2933.97, 4669.99, 49.03, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },

        { coord = vector4(2932.11, 4670.37, 49.13, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2931.45, 4673.95, 49.22, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2930.66, 4677.18, 49.69, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2929.78, 4680.98, 50.24, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2928.99, 4684.17, 50.51, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2928.36, 4687.70, 50.43, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2927.47, 4691.78, 50.32, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2925.23, 4692.19, 50.23, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2925.68, 4689.56, 50.23, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2926.49, 4686.03, 50.36, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2927.34, 4682.35, 50.38, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2928.12, 4678.75, 49.90, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2928.84, 4675.71, 49.47, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2929.40, 4673.06, 49.17, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2930.21, 4669.63, 49.09, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },

        { coord = vector4(2928.39, 4669.04, 49.12, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2927.61, 4672.62, 49.16, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2926.83, 4676.17, 49.54, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2926.01, 4679.87, 50.01, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2925.21, 4683.55, 50.30, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2924.62, 4686.42, 50.30, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2923.78, 4690.12, 50.15, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2921.16, 4691.33, 50.02, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2921.98, 4687.65, 50.11, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2922.76, 4684.43, 50.20, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2923.25, 4681.56, 50.12, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2924.00, 4678.42, 49.71, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2924.78, 4675.55, 49.43, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2925.39, 4672.80, 49.18, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2926.21, 4669.02, 49.14, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },

        { coord = vector4(2924.74, 4666.25, 49.25, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2923.98, 4669.94, 49.21, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2923.25, 4673.66, 49.29, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2922.30, 4678.05, 49.68, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2921.49, 4681.69, 50.02, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2920.71, 4685.37, 50.08, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2919.67, 4689.90, 49.99, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2917.41, 4689.75, 49.86, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2918.30, 4686.16, 49.91, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2918.95, 4682.55, 49.87, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2919.79, 4679.02, 49.65, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2920.63, 4675.50, 49.39, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2921.22, 4672.87, 49.20, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2921.94, 4669.36, 49.12, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2922.81, 4665.73, 49.18, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },

        { coord = vector4(2921.59, 4662.84, 49.12, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2920.84, 4666.28, 49.09, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2920.16, 4669.80, 49.12, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2919.28, 4673.45, 49.25, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2918.40, 4677.16, 49.47, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2917.55, 4680.78, 49.75, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2916.78, 4684.32, 49.84, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2915.86, 4688.26, 49.76, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2913.52, 4689.20, 49.64, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2914.25, 4685.75, 49.64, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2914.98, 4682.26, 49.67, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2915.81, 4678.47, 49.50, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2916.71, 4674.97, 49.27, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2917.64, 4670.55, 49.13, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2918.39, 4666.79, 49.04, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2919.40, 4662.35, 49.13, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },

        { coord = vector4(2918.01, 4660.10, 49.21, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2917.34, 4663.55, 49.18, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2916.56, 4667.26, 49.14, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2915.70, 4670.91, 49.14, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2914.73, 4675.23, 49.25, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2913.79, 4679.40, 49.47, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2912.81, 4683.63, 49.59, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2912.00, 4687.41, 49.54, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2909.77, 4687.07, 49.36, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2910.70, 4683.48, 49.41, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2911.65, 4679.16, 49.35, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2912.40, 4675.80, 49.20, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2913.29, 4671.76, 49.14, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2914.11, 4667.84, 49.13, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2914.88, 4664.00, 49.17, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },
        { coord = vector4(2915.56, 4660.27, 49.24, 0.0), produceType = "lettuce",    prop = "prop_veg_crop_03_cab" },

        { coord = vector4(2914.02, 4658.47, 49.19, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2913.03, 4663.02, 49.14, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2912.21, 4666.76, 49.17, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2911.43, 4670.48, 49.18, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2910.66, 4674.26, 49.22, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2909.89, 4677.91, 49.29, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2909.13, 4681.42, 49.33, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2908.34, 4684.96, 49.33, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2907.77, 4687.68, 49.27, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2905.90, 4687.03, 49.23, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2906.68, 4682.71, 49.22, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2907.50, 4678.55, 49.24, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2908.60, 4673.92, 49.18, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2909.55, 4669.37, 49.16, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2910.26, 4665.65, 49.17, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2910.84, 4662.83, 49.17, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },
        { coord = vector4(2911.61, 4659.20, 49.18, 0.0), produceType = "pumpkin",    prop = "prop_veg_crop_03_pumpkin" },

        { coord = vector4(2910.54, 4654.47, 49.22, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2909.87, 4657.92, 49.25, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2909.18, 4661.83, 49.17, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2908.34, 4666.14, 49.18, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2907.34, 4670.79, 49.20, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2906.35, 4675.36, 49.21, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2905.38, 4679.73, 49.19, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2904.57, 4683.51, 49.19, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2903.94, 4686.44, 49.15, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2901.90, 4686.26, 49.14, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2902.84, 4681.68, 49.13, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2903.70, 4677.26, 49.18, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2904.80, 4672.60, 49.18, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2905.84, 4668.15, 49.17, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2906.75, 4663.39, 49.18, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2907.81, 4658.09, 49.22, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },
        { coord = vector4(2909.04, 4652.76, 49.22, 0.0), produceType = "melon",      prop = "prop_veg_crop_03_kavun" },

        { coord = vector4(2907.18, 4651.37, 49.18, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2906.24, 4655.94, 49.25, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2905.28, 4660.59, 49.19, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2904.44, 4665.28, 49.17, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2903.54, 4669.93, 49.17, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2902.57, 4674.31, 49.17, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2901.53, 4678.75, 49.15, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2900.34, 4684.28, 49.11, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2898.08, 4685.04, 49.08, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2899.01, 4680.62, 49.07, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2899.95, 4676.15, 49.12, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2901.20, 4670.90, 49.14, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2902.26, 4666.07, 49.13, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2903.91, 4657.00, 49.16, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
        { coord = vector4(2904.84, 4651.98, 49.13, 0.0), produceType = "watermelon", prop = "prop_veg_crop_03_karpuz" },
    },

    box = {

        models = {
            v1 = "prop_crate_03a",
            v2 = "prop_crate_03a",
            v3 = "prop_box_wood05a",
        },

        capacity = {
            v1 = 6,
            v2 = 8,
            v3 = 10,
        },

        playerAttach = {
            bone = 28422,
            offset = vector3(0.01, -0.30, -0.15),
            rotation = vector3(0.0, 0.0, 90.0),
        },

        carryAnim = {
            dict = "anim@heists@box_carry@",
            name = "idle",
        },

        groundOffset = vector3(0.0, 0.5, -0.5),
    },

    produceAttach = {
        bone = 0,
        positions = {
            { offset = vector3(0.110, -0.250, 0.040),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.140, -0.250, 0.040), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.110, 0.030, 0.040),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.140, 0.030, 0.040),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.100, 0.260, 0.040),   rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.130, 0.250, 0.040),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.000, -0.130, 0.200),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.000, 0.130, 0.200),   rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    breakSession = {
        type = "plant",
        ballCount = { min = 4, max = 5 },
        ballSize = 0.12,
        repeatPerBall = 2,
    },

    animations = {
        harvest = {
            dict = "amb@world_human_gardener_plant@female@base",
            name = "base_female",
            duration = 3000,
        },
        pickupBox = {
            dict = "pickup_object",
            name = "pickup_low",
        },
        putdownBox = {
            dict = "pickup_object",
            name = "putdown_low",
        },
        reachPick = {
            dict = "amb@prop_human_movie_bulb@idle_a",
            name = "idle_a",
        },
    },

    vehicle = {
        -- These spawn slots sit closer together than the default 7.0 clear
        -- radius (VehicleManager), which made one parked vehicle block every
        -- neighbouring slot and capped the job at one lobby at a time.
        -- Must stay BELOW the smallest slot-to-slot gap.
        spawnClearRadius = 4.5,
        spawnLocations = {
            vector4(2943.59, 4646.7, 48.08, 47.52),
            vector4(2939.88, 4643.51, 48.08, 47.52),
            vector4(2936.21, 4639.71, 48.08, 43.33),
            vector4(2931.88, 4633.95, 48.08, 52.33),
        },
        model = "bison",
        color = { primary = 28, secondary = 111 },
        plate = "FARMER",
        useCustomPlate = false,
        fuelOnSpawn = 100.0,
        trunkDoors = {},

        boxPositions = {
            { offset = vector3(-0.35, -2.1, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.35, -2.1, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.35, -1.6, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.35, -1.6, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },

            { offset = vector3(-0.35, -2.1, 0.75), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.35, -2.1, 0.75),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(-0.35, -1.6, 0.75), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.35, -1.6, 0.75),  rotation = vector3(0.0, 0.0, 0.0) },
        },

        emptyBoxPositions = {
            { offset = vector3(-0.35, -2.1, 0.45), rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.35, -2.1, 0.45),  rotation = vector3(0.0, 0.0, 0.0) },
            { offset = vector3(0.0, -2.1, 0.75),   rotation = vector3(0.0, 0.0, 0.0) },
        },
    },

    processing = {
        coord = vector4(2878.17, 4487.6, 48.29, -60.65),
        prop = "tw_baskul",
        propOffset = vector3(0.0, 0.0, 0.0),
        propRotation = vector3(0.0, 0.0, 35.368),
        spawnDistance = 50.0,
        interactDistance = 2.5,
        maxDistanceFromScale = 15.0,
        maxScaleItems = 20,
        progressTarget = 5, -- boxes that fill the progress bar to 100% (display only; tune to a typical round). NOT the scale cap (maxScaleItems).
        scaleStackHeight = 0.5,

        economyItem = "wheat",

        levelPayBonus = 0.02,

        levelChanceBonus = 0.5,

        qualityTiers = {
            { name = "Common",  chance = 60, multiplier = 1.0 },
            { name = "Fresh",   chance = 25, multiplier = 1.3 },
            { name = "Premium", chance = 10, multiplier = 1.6 },
            { name = "Organic", chance = 5,  multiplier = 2.0 },
        },
        npc = {
            model = "s_m_y_construct_01",
            coord = vector4(2875.91, 4488.15, 48.29, 168.82),
            scenario = "WORLD_HUMAN_CLIPBOARD",
            interactDistance = 2.0,
        },

        carrier = {
            npcModel        = "s_m_y_construct_02",
            carryProp       = "prop_crate_03a",
            maxItemsToCarry = 2,
            walkSpeed       = 1.0,

            spawnCoord      = vector4(2889.07, 4491.36, 47.95, 137.42),
            dropCoord       = vector4(2890.31, 4493.83, 47.97, 170.4),

            carryBone       = 28422,
            carryOffset     = vector3(0.01, -0.30, -0.15),
            carryRotation   = vector3(0.0, 0.0, 90.0),
            pickupTime      = 2000,
            dropTime        = 1500,
        },
    },

    workClothes = {
        coord = vector4(2919.10, 4623.55, 47.36, 131.52),
    },
}

FarmerJob.runtime = runtime

local vehSpawn = runtime.vehicle.spawnLocations[1]
local headingRad = math.rad(vehSpawn.w)
local trunkX = vehSpawn.x + math.sin(headingRad) * 3.0
local trunkY = vehSpawn.y - math.cos(headingRad) * 3.0
local trunkHeading = (vehSpawn.w + 180.0) % 360.0

FarmerJob.preview = {
    playerPosition = vector3(2932.43, 4624.21, 48.72),
    vehicleStep = 3,
    steps = {

        {
            camCoord = vector3(2930.4, 4626.1, 49.9),
            camTarget = vector3(2934.0, 4622.8, 48.7),
        },

        {
            autoClothes = true,
            camCoord = vector3(2921.9, 4626.1, 50.6),
            camTarget = vector3(2918.9, 4623.4, 47.7),
        },

        {
            autoVehicle = true,
            autoCargo = { count = 2, model = runtime.box.models.v1 },
            camCoord = vector3(2946.8, 4643.9, 50.7),
            camTarget = vector3(2943.4, 4646.8, 48.5),
        },

        {
            camCoord = vector3(2948.6, 4671.1, 50.3),
            camTarget = vector3(2947.7, 4675.9, 49.2),
            entities = {
                { type = "prop", model = runtime.plantSpawns[1].prop, coords = runtime.plantSpawns[1].coord },
                { type = "prop", model = runtime.plantSpawns[2].prop, coords = runtime.plantSpawns[2].coord },
                { type = "prop", model = runtime.plantSpawns[3].prop, coords = runtime.plantSpawns[3].coord },
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(2949.04, 4673.83, 49.17, 180.0),
                    faceCoord = vector3(2948.04, 4673.83, 49.17),
                    anim = { dict = runtime.animations.harvest.dict, name = runtime.animations.harvest.name, flag = 1 },
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(2946.7, 4670.7, 50.8),
            camTarget = vector3(2946.4, 4675.2, 48.6),
            entities = {
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(2946.5, 4674.0, 49.17, 220.0),
                    faceCoord = vector3(2943.59, 4646.7, 48.08),
                    anim = { dict = runtime.box.carryAnim.dict, name = runtime.box.carryAnim.name, flag = 49 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.box.models.v1,
                    attachTo = 1,
                    attachBone = runtime.box.playerAttach.bone,
                    attachOffset = runtime.box.playerAttach.offset,
                    attachRotation = runtime.box.playerAttach.rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.lettuce.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[1].offset,
                    attachRotation = runtime.produceAttach.positions[1].rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.pumpkin.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[2].offset,
                    attachRotation = runtime.produceAttach.positions[2].rotation,
                    persist = false
                },
            },
        },

        {
            camCoord = vector3(2946.9, 4643.8, 50.8),
            camTarget = vector3(2943.5, 4646.7, 48.6),
            entities = {
                {
                    type = "ped",
                    model = "a_m_m_farmer_01",
                    coords = vector4(trunkX, trunkY, vehSpawn.z, vehSpawn.w),
                    anim = { dict = runtime.box.carryAnim.dict, name = runtime.box.carryAnim.name, flag = 49 },
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.box.models.v1,
                    attachTo = 1,
                    attachBone = runtime.box.playerAttach.bone,
                    attachOffset = runtime.box.playerAttach.offset,
                    attachRotation = runtime.box.playerAttach.rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.lettuce.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[1].offset,
                    attachRotation = runtime.produceAttach.positions[1].rotation,
                    persist = false
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.melon.model,
                    attachTo = 2,
                    attachBone = 0,
                    attachOffset = runtime.produceAttach.positions[3].offset,
                    attachRotation = runtime.produceAttach.positions[3].rotation,
                    persist = false
                },
            },
        },

        {
            autoScale = true,
            autoCarrier = true,
            scaleDUI = { rockCount = 2, payPerRock = runtime.produceTypes.lettuce.price },
            camCoord = vector3(2876.2, 4483.8, 49.4),
            camTarget = vector3(2878.5, 4488.3, 49.0),
            entities = {
                {
                    type = "prop",
                    model = runtime.box.models.v1,
                    coords = vector4(runtime.processing.coord.x, runtime.processing.coord.y,
                        runtime.processing.coord.z + 2.0, 0.0),
                    spawnDelay = 2000
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.lettuce.model,
                    coords = vector4(runtime.processing.coord.x + 0.11, runtime.processing.coord.y - 0.25,
                        runtime.processing.coord.z + 2.0, 0.0),
                    spawnDelay = 2500
                },
                {
                    type = "prop",
                    model = runtime.produceTypes.pumpkin.model,
                    coords = vector4(runtime.processing.coord.x - 0.14, runtime.processing.coord.y - 0.25,
                        runtime.processing.coord.z + 2.0, 0.0),
                    spawnDelay = 2500
                },
            },
        },
    },
}

FarmerJob.clothes = {
    male = {
        tshirt_1 = 15,
        tshirt_2 = 1,
        torso_1 = 234,
        torso_2 = 19,
        arms = 0,
        pants_1 = 0,
        pants_2 = 1,
        shoes_1 = 12,
        shoes_2 = 0,
        chain_1 = 0,
        chain_2 = 0,
        helmet_1 = -1,
        helmet_2 = 1,
    },
    female = {
        tshirt_1 = 36,
        tshirt_2 = 1,
        torso_1 = 9,
        torso_2 = 6,
        decals_1 = 0,
        decals_2 = 0,
        arms = 0,
        pants_1 = 92,
        pants_2 = 2,
        shoes_1 = 12,
        shoes_2 = 0,
        chain_1 = -1,
        chain_2 = 0,
        helmet_1 = 141,
        helmet_2 = 6,
    },
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.startJobFunction)
-- Return true to allow the player to start, false to prevent
FarmerJob.startJobFunction = {
    enabled = false, -- true = enable start check for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId)
        return true
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.endJobFunction)
-- lobbyAmount / playerAmount meaning: number of crop boxes processed
FarmerJob.endJobFunction = {
    enabled = false, -- true = enable end function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

-- Per-job override (if enabled = true, this runs INSTEAD of the global Config.resetJobFunction)
-- Called when the job is cancelled (owner/member leaves mid-job, lobby disbanded, etc.)
FarmerJob.resetJobFunction = {
    enabled = false, -- true = enable reset function for THIS job only | false = use global
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
    end,
}

return FarmerJob
