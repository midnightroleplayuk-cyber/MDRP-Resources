Shared = {}

-- Debug configuration
Shared.Debug = {
    Enabled = false,    -- Set to false to disable all debug prints
    Levels = {
        Info = true,    -- General information
        Success = true, -- Success operations
        Warning = true  -- Warning and potential issues
    }
}

-- Lockpick configuration
Shared.Lockpick = {
    enabled = true,                    -- Enable/disable lockpick item removal
    itemName = "lockpick",             -- Item name to remove
    removeOnFail = true,               -- Remove item on failed lockpick
    removeOnSuccess = false,            -- Remove item on successful lockpick
}

Shared.PawnShop = {
    enabled = true,
    coords = vec4(199.3678, -1769.0023, 29.2547, 142.2725),
    pedModel = "a_m_y_bevhills_01",
    blip = {
        sprite = 500,
        color = 2,
        scale = 0.7,
        name = "Pawn Shop",
        enabled = true
    }, 
    prices = {
        { name = "dh_hr_hard_disc", price = 5 },
        { name = "dh_hr_statue_4", price = 5 },
        { name = "dh_hr_toaster", price = 5 },
        { name = "dh_hr_headphones", price = 5 },
        { name = "dh_hr_dress", price = 5 },
        { name = "dh_hr_hairdryer", price = 5 },
        { name = "dh_hr_tv", price = 5 },
        { name = "dh_hr_painting", price = 5 },
        { name = "dh_hr_statue_3", price = 5 },
        { name = "dh_hr_skull", price = 5 },
        { name = "dh_hr_soap_2", price = 5 },
        { name = "dh_hr_statue_2", price = 5 },
        { name = "dh_hr_pestle", price = 5 },
        { name = "dh_hr_scales_2", price = 5 },
        { name = "dh_hr_brush_pot", price = 5 },
        { name = "dh_hr_tiger_2", price = 5 },
        { name = "dh_hr_soap", price = 5 },
        { name = "dh_hr_remote", price = 5 },
        { name = "dh_hr_luggage_2", price = 5 },
        { name = "dh_hr_bottle", price = 5 },
        { name = "dh_hr_table", price = 5 },
        { name = "dh_hr_wheel", price = 5 },
        { name = "dh_hr_knife", price = 5 },
        { name = "dh_hr_iron", price = 5 },
        { name = "dh_hr_bike", price = 5 },
        { name = "dh_hr_pot", price = 5 },
        { name = "dh_hr_casino_car", price = 5 },
        { name = "dh_hr_clock", price = 5 },
        { name = "dh_hr_golf", price = 5 },
        { name = "dh_hr_plant", price = 5 },
        { name = "dh_hr_passport", price = 5 },
        { name = "dh_hr_mug", price = 5 },
        { name = "dh_hr_champagne", price = 5 },
        { name = "dh_hr_mixer", price = 5 },
        { name = "dh_hr_sarcophagus", price = 5 },
        { name = "dh_hr_scales", price = 5 },
        { name = "dh_hr_toilet_bag", price = 5 },
        { name = "dh_hr_sculpture", price = 5 },
        { name = "dh_hr_rope", price = 5 },
        { name = "dh_hr_radio", price = 5 },
        { name = "dh_hr_mouse", price = 5 },
        { name = "dh_hr_trophy", price = 5 },
        { name = "dh_hr_shovel", price = 5 },
        { name = "dh_hr_luggage", price = 5 },
        { name = "dh_hr_plunger", price = 5 },
        { name = "dh_hr_statue", price = 5 },
        { name = "dh_hr_shoe_box", price = 5 },
        { name = "dh_hr_plant_2", price = 5 },
        { name = "dh_hr_tool_box", price = 5 },
        { name = "dh_hr_bong", price = 5 },
        { name = "dh_hr_tablet", price = 5 },
        { name = "dh_hr_necklace", price = 5 },
        { name = "dh_hr_pc", price = 5 },
        { name = "dh_hr_teapot", price = 5 },
        { name = "dh_hr_basket", price = 5 },
        { name = "dh_hr_bike_2", price = 5 },
        { name = "dh_hr_teddy_bear", price = 5 },
        { name = "dh_hr_statue_5", price = 5 },
        { name = "dh_hr_shirt", price = 5 },
        { name = "dh_hr_umbrella", price = 5 },
        { name = "dh_hr_perfume", price = 5 },
        { name = "dh_hr_speaker", price = 5 },
        { name = "dh_hr_doll_2", price = 5 },
        { name = "dh_hr_tiger", price = 5 },
        { name = "dh_hr_laptop", price = 5 },
        { name = "dh_hr_gold_cd", price = 5 },
        { name = "dh_hr_doll", price = 5 },
        { name = "dh_hr_fan", price = 5 },
        { name = "dh_hr_chopboard", price = 5 },
        { name = "dh_hr_coffee", price = 5 },
        { name = "dh_hr_monitor", price = 5 },
        { name = "dh_hr_bedside_clock", price = 5 },
        { name = "dh_hr_iron_2", price = 5 },
        { name = "dh_hr_keyboard", price = 5 },
        { name = "dh_hr_drone", price = 5 },
        { name = "dh_hr_shave_box", price = 5 },
        { name = "dh_hr_guitar", price = 5 },
        { name = "dh_hr_bed_dog", price = 5 },
        { name = "dh_hr_desk_lamp", price = 5 },
    }
}



CreateThread(function()
    Shared.HouseTiers = {
        ["tier1"] = {
            -- {
            --     props = House1,
            --     entry = vec3(918.5439, -933.0507, -90.4959),
            --     propsPercent = { min = 50, max = 70 },
            -- },
            {
                props = House6,
                entry = vec3(1037.3604, -925.3293, -88.7232),
                propsPercent = { min = 40, max = 60 }, -- % of available props to spawn (random between min and max)
            }
        },
        ["tier2"] = {
            {
                props = House4,
                entry = vec3(995.2757, -932.9591, -88.1844),
                propsPercent = { min = 40, max = 60 }, -- % of available props to spawn (random between min and max)
            },
            {
                props = House5,
                entry = vec3(1022.0903, -932.3845, -88.9941),
                propsPercent = { min = 40, max = 60 }, -- % of available props to spawn (random between min and max)
            }
        },
        ["tier3"] = {
            {
                props = House2,
                entry = vec3(946.1440, -932.5292, -90.4961),
                propsPercent = { min = 40, max = 60 }, -- % of available props to spawn (random between min and max)
            },
            {
                props = House3,
                entry = vec3(956.5540, -927.3091, -90.9467),
                propsPercent = { min = 40, max = 60 }, -- % of available props to spawn (random between min and max)
            }
        }
    }
end)


Shared.PedSettings = {
    enabled = true,
    peds = {
        {
            model = "ig_lestercrest",
            coords = vec4(359.7007, 356.5764, 104.3271, 351.7176),
            blip = {
                enabled = false,
                sprite = 1,
                color = 2,
                scale = 0.8,
                label = "House Robbery NPC",
            },
        },
        -- Add more peds here:
        -- {
        --     model = "ig_lestercrest",
        --     coords = vec4(0.0, 0.0, 0.0, 0.0),
        --     blip = {
        --         enabled = false,
        --         sprite = 1,
        --         color = 2,
        --         scale = 0.8,
        --         label = "House Robbery NPC",
        --     },
        -- },
    },
}

Shared.StartRequirements = {
    -- Item example:
    { name = "water", amount = 1, consume = true },
    -- Custom handler example:
    -- {
    --     label = "Crew Membership",
    --     icon = "fas fa-users",
    --     check = function(source)
    --         return true
    --     end,
    --     action = function(source)
    --         -- runs once the mission actually starts
    --     end,
    -- },
}

Shared.LaptopConfig = {
    enabled = true,
    traderId = 'trader_1',
    name = 'House Robbery',
    smallDescription = 'A quick and stealthy theft.',
    description = 'Steal valuable items from a location. The more you steal, the higher the chance the police will arrive.',
    bannerImage = 'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/houseRobbery/taskImage.webp',
    images = {
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/houseRobbery/img1.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/houseRobbery/img2.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/houseRobbery/img4.webp',
    },
    link = "https://store.devhub.gg",
    rewards = {
        items = {
            { name = 'weapon_pistol', quantity = 1 },
        },
        money = 1000,
        crimePoints = 500,
        xp = 250,
    },
    tasks = {
        ['uid_1'] = {
            name = 'Join the queue',
            description = 'Join the queue and wait for your turn.',
            icon = 'fas fa-sign-in-alt',
            order = 1,
        },
        ['uid_2'] = {
            name = 'Receive location',
            description = 'You will receive a notification and the apartment location on the map.',
            icon = 'fas fa-map-marker-alt',
            order = 2,
        },
        ['uid_3'] = {
            name = 'Pick the lock',
            description = 'Use a lockpick on the door and enter the apartment.',
            icon = 'fas fa-key',
            order = 3,
        },
        ['uid_4'] = {
            name = 'Loot the apartment',
            description = 'Take everything you can. Be careful: the more you steal, the higher the chance the police will arrive.',
            icon = 'fas fa-box-open',
            order = 4,
        },
        ['uid_5'] = {
            name = 'Steal 5 items',
            description = 'Steal 5 items to receive rewards.',
            icon = 'fas fa-gifts',
            order = 5,
        },
        ['uid_6'] = {
            name = 'Sell at pawn shop',
            description = 'Sell all stolen items at the pawn shop.',
            icon = 'fas fa-dollar-sign',
            order = 6,
        },
    }
}



House1 = {
    {itemName = "dh_hr_tv", coords = vec3(926.965942, -933.610474, -90.365089), rotation = vec3(0.010000, 0.010000, -179.990005), prop = "ex_prop_ex_tv_flat_01" },
    {itemName = "dh_hr_table", coords = vec3(927.361450, -927.958862, -91.288406), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "prop_t_coffe_table_02" },
    {itemName = "dh_hr_sculpture", coords = vec3(917.152893, -930.922974, -90.039627), rotation = vec3(0.010000, 0.010000, -99.989929), prop = "apa_mp_h_acc_dec_sculpt_02" },
    {itemName = "dh_hr_plant", coords = vec3(910.4053, -933.073669, -90.18869), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "dh_plant" },
    {itemName = "dh_hr_soap", coords = vec3(913.518066, -931.270752, -90.544380), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap", coords = vec3(913.518066, -930.285400, -90.544380), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap_2", coords = vec3(913.416321, -931.075989, -90.644707), rotation = vec3(0.010000, 0.010000, -34.990028), prop = "dh_bathroom_accesories_white_2" },
    {itemName = "dh_hr_painting", coords = vec3(918.008545, -931.455017, -89.746956), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "dh_painting_samoyed" },
    {itemName = "dh_hr_painting", coords = vec3(928.826233, -928.046692, -89.623940), rotation = vec3(0.010000, 0.010000, -89.990036), prop = "dh_painting_bengal" },
    {itemName = "dh_hr_painting", coords = vec3(928.822083, -929.366882, -89.625191), rotation = vec3(0.010000, 0.010000, -89.990036), prop = "dh_painting_modern" },
    {itemName = "dh_hr_plant_2", coords = vec3(918.120667, -931.068848, -90.734970), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "dh_flower" },
    {itemName = "dh_hr_passport", coords = vec3(921.521606, -931.855469, -90.587074), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "bkr_prop_fakeid_bundlepassports" },
    {itemName = "dh_hr_champagne", coords = vec3(925.668335, -931.650757, -90.391693), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "h4_prop_battle_champ_closed" },
    {itemName = "dh_hr_skull", coords = vec3(921.876648, -927.362366, -90.915695), rotation = vec3(0.010000, 0.010000, -34.990028), prop = "vw_prop_casino_art_skull_03b" },
    {itemName = "dh_hr_casino_car", coords = vec3(917.255066, -929.477722, -90.049858), rotation = vec3(0.010000, 0.010000, -89.990036), prop = "vw_prop_casino_art_car_09a" },
    {itemName = "dh_hr_dress", coords = vec3(917.967651, -926.778931, -90.335579), rotation = vec3(0.010000, 0.010000, 45.009956), prop = "prop_dress_disp_02" },
    {itemName = "dh_hr_teddy_bear", coords = vec3(921.199341, -929.576965, -90.790100), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "v_club_vu_bear" },
    {itemName = "dh_hr_bedside_clock", coords = vec3(917.194885, -930.565247, -89.987541), rotation = vec3(0.010000, 0.010000, -89.990036), prop = "v_res_fh_bedsideclock" },
    {itemName = "dh_hr_headphones", coords = vec3(917.229736, -927.614685, -90.675713), rotation = vec3(-89.989998, 0.010000, 0.010000), prop = "h4_prop_battle_headphones_dj" },
    {itemName = "dh_hr_iron", coords = vec3(913.387634, -930.540405, -90.629654), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "prop_iron_01" },
    {itemName = "dh_hr_iron_2", coords = vec3(914.231995, -929.103882, -90.539703), rotation = vec3(0.010000, 0.010000, -179.990005), prop = "v_ret_fh_ironbrd" },
    {itemName = "dh_hr_doll", coords = vec3(927.366821, -926.938416, -91.019363), rotation = vec3(0.010000, 0.010000, -44.989956), prop = "prop_defilied_ragdoll_01" },
    {itemName = "dh_hr_tiger", coords = vec3(928.109741, -933.211182, -91.507553), rotation = vec3(0.010000, 0.010000, -114.989922), prop = "sf_prop_sf_art_statue_tgr_01a" },
    {itemName = "dh_hr_gold_cd", coords = vec3(917.016174, -933.699646, -89.519554), rotation = vec3(0.010000, 0.010000, -179.990005), prop = "sf_prop_sf_lp_plaque_01a" },
    {itemName = "dh_hr_hairdryer", coords = vec3(913.400208, -930.884033, -90.717926), rotation = vec3(0.010000, 0.010000, -84.989960), prop = "v_serv_bs_hairdryer" },
    {itemName = "dh_hr_coffee", coords = vec3(923.079102, -927.983765, -90.378731), rotation = vec3(0.010000, 0.010000, 90.010040), prop = "prop_coffee_mac_02" },
    {itemName = "dh_hr_mixer", coords = vec3(923.173340, -928.860962, -90.419533), rotation = vec3(0.010000, 0.010000, 90.010040), prop = "v_res_tre_mixer" },
    {itemName = "dh_hr_fan", coords = vec3(918.008606, -929.164368, -90.844406), rotation = vec3(0.010000, 0.010000, 100.009926), prop = "v_res_fh_towerfan" },
    {itemName = "dh_hr_pestle", coords = vec3(924.990051, -929.068909, -90.605713), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "v_res_pestle" },
    {itemName = "dh_hr_chopboard", coords = vec3(925.153015, -931.211121, -90.603897), rotation = vec3(0.010000, 0.010000, -89.990036), prop = "v_res_mchopboard" },
    {itemName = "dh_hr_scales", coords = vec3(923.203369, -928.384705, -90.625999), rotation = vec3(0.010000, 0.010000, 90.010040), prop = "v_res_m_kscales" },
    {itemName = "dh_hr_knife", coords = vec3(925.213074, -930.771179, -90.606026), rotation = vec3(0.010000, 0.010000, -94.989944), prop = "prop_knife_stand" },
    {itemName = "dh_hr_tiger_2", coords = vec3(928.207886, -930.358154, -91.491463), rotation = vec3(0.010000, 0.010000, -89.990036), prop = "sum_prop_ac_tigerrug_01a" },
    {itemName = "dh_hr_shoe_box", coords = vec3(922.343933, -931.678101, -90.502106), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "v_res_fa_shoebox3" },
    {itemName = "dh_hr_laptop", coords = vec3(915.148499, -927.836365, -90.711647), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "xm_prop_x17_laptop_mrsr" },
    {itemName = "dh_hr_hard_disc", coords = vec3(925.017151, -927.888977, -90.604301), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "xm_prop_x17_harddisk_01a" },
    {itemName = "dh_hr_luggage", coords = vec3(918.319641, -931.606812, -91.239281), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "prop_luggage_06a" },
    {itemName = "dh_hr_doll_2", coords = vec3(928.404297, -926.882446, -90.872276), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "ch_prop_princess_robo_plush_07a" },
    {itemName = "dh_hr_drone", coords = vec3(916.919189, -928.447815, -91.373924), rotation = vec3(0.010000, 0.010000, 0.010000), prop = "reh_prop_reh_drone_brk_02a" },
    {itemName = "dh_hr_shovel", coords = vec3(918.927307, -926.774963, -91.504280), rotation = vec3(-9.990033, 0.010000, 0.010000), prop = "prop_tool_shovel3" },
}

House2 = {
    {itemName = "dh_hr_tv", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), coords = vec3(939.760315, -932.213989, -90.215530), prop = "ex_prop_ex_tv_flat_01" },
    {itemName = "dh_hr_sculpture", rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), coords = vec3(935.282104, -937.226196, -90.623466), prop = "apa_mp_h_acc_dec_sculpt_02" },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(935.456299, -935.829224, -90.216469), prop = "dh_plant" },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(941.874756, -937.726501, -90.510307), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(941.398560, -933.455627, -89.725349), prop = "dh_painting_samoyed" },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, -1.000000, 0.000000), coords = vec3(936.651550, -940.123352, -89.845589), prop = "dh_painting_bengal" },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(937.363586, -930.967102, -89.625626), prop = "dh_painting_modern" },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(943.721008, -930.489380, -90.733406), prop = "dh_flower" },
    {itemName = "dh_hr_passport", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(935.358521, -939.355896, -90.837181), prop = "bkr_prop_fakeid_bundlepassports" },
    {itemName = "dh_hr_champagne", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(942.267700, -930.146179, -90.627312), prop = "h4_prop_battle_champ_closed" },
    {itemName = "dh_hr_skull", rotation = vec4(0.000000, 0.000000, -0.500000, 0.866025), coords = vec3(935.268616, -937.508972, -90.631142), prop = "vw_prop_casino_art_skull_03b" },
    {itemName = "dh_hr_casino_car", rotation = vec4(0.000000, 0.000000, 0.887011, 0.461749), coords = vec3(935.330505, -938.198914, -90.837387), prop = "vw_prop_casino_art_car_09a" },
    {itemName = "dh_hr_bedside_clock", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(940.902283, -926.891663, -90.490685), prop = "v_res_fh_bedsideclock" },
    {itemName = "dh_hr_headphones", rotation = vec4(0.737277, 0.000000, 0.000000, 0.675590), coords = vec3(946.071960, -927.582947, -90.678734), prop = "h4_prop_battle_headphones_dj" },
    {itemName = "dh_hr_iron", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(943.108704, -931.317993, -90.418747), prop = "prop_iron_01" },
    {itemName = "dh_hr_iron_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(946.464294, -930.982849, -90.539040), prop = "v_ret_fh_ironbrd" },
    {itemName = "dh_hr_doll", rotation = vec4(0.000000, 0.000000, -0.984808, 0.173648), coords = vec3(940.448364, -930.137451, -90.853470), prop = "prop_defilied_ragdoll_01" },
    {itemName = "dh_hr_gold_cd", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(942.860718, -932.254150, -89.678299), prop = "sf_prop_sf_lp_plaque_01a" },
    {itemName = "dh_hr_hairdryer", rotation = vec4(-0.448826, 0.411273, 0.535982, 0.584921), coords = vec3(946.330872, -936.182068, -91.149178), prop = "v_serv_bs_hairdryer" },
    {itemName = "dh_hr_coffee", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), coords = vec3(941.248108, -939.164063, -90.308655), prop = "prop_coffee_mac_02" },
    {itemName = "dh_hr_mixer", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), coords = vec3(941.270142, -939.580444, -90.349197), prop = "v_res_tre_mixer" },
    {itemName = "dh_hr_fan", rotation = vec4(0.000000, 0.000000, -0.843391, -0.537300), coords = vec3(939.417786, -933.515686, -90.844231), prop = "v_res_fh_towerfan" },
    {itemName = "dh_hr_pestle", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(939.146362, -939.801636, -90.633720), prop = "v_res_pestle" },
    {itemName = "dh_hr_chopboard", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(939.037720, -938.370850, -90.626480), prop = "v_res_mchopboard" },
    {itemName = "dh_hr_scales", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(938.921387, -936.385376, -90.634491), prop = "v_res_m_kscales" },
    {itemName = "dh_hr_knife", rotation = vec4(0.000000, 0.000000, 0.707107, -0.707107), coords = vec3(941.292603, -939.940247, -90.558655), prop = "prop_knife_stand" },
    {itemName = "dh_hr_shoe_box", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(943.101807, -932.841003, -90.461990), prop = "v_res_fa_shoebox3" },
    {itemName = "dh_hr_laptop", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(945.220825, -927.413879, -90.701286), prop = "xm_prop_x17_laptop_mrsr" },
    {itemName = "dh_hr_hard_disc", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(941.699646, -927.016602, -90.543961), prop = "xm_prop_x17_harddisk_01a" },
    {itemName = "dh_hr_luggage", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(943.866211, -931.089111, -91.249474), prop = "prop_luggage_06a" },
    {itemName = "dh_hr_desk_lamp", rotation = vec4(0.000000, 0.000000, 0.422618, 0.906308), coords = vec3(944.280334, -927.064636, -90.701004), prop = "xm3_prop_xm3_desklamp_01a" },
    {itemName = "dh_hr_tablet", rotation = vec4(0.703427, 0.019601, -0.005124, 0.710478), coords = vec3(944.146851, -927.591370, -90.689919), prop = "sf_prop_sf_tablet_01a" },
    {itemName = "dh_hr_statue", rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), coords = vec3(935.329285, -939.556885, -90.623100), prop = "v_club_vu_statue" },
    {itemName = "dh_hr_shirt", rotation = vec4(0.000000, 0.000000, -0.887011, 0.461749), coords = vec3(943.446777, -935.397888, -89.845993), prop = "prop_cs_shirt_01" },
    {itemName = "dh_hr_umbrella", rotation = vec4(0.708973, -0.009472, -0.011985, 0.705070), coords = vec3(943.269043, -932.187317, -90.531937), prop = "v_res_fa_umbrella" },
    {itemName = "dh_hr_bong", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(937.171387, -933.227722, -91.066597), prop = "xm3_prop_xm3_bong_01a" }
}
 
House3 = {
    {itemName = "dh_hr_laptop", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(961.115479, -928.773438, -88.164558), prop = "xm_prop_x17_laptop_mrsr" },
    {itemName = "dh_hr_hard_disc", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(961.306396, -928.282410, -87.027397), prop = "xm_prop_x17_harddisk_01a" },
    {itemName = "dh_hr_luggage", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(962.849182, -928.879089, -88.686165), prop = "prop_luggage_06a" },
    {itemName = "dh_hr_coffee", rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), coords = vec3(960.126038, -932.856689, -87.750908), prop = "prop_coffee_mac_02" },
    {itemName = "dh_hr_headphones", rotation = vec4(0.737277, 0.000000, 0.000000, 0.675590), coords = vec3(960.370605, -928.753967, -88.141838), prop = "h4_prop_battle_headphones_dj" },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(964.749084, -928.572327, -87.644501), prop = "dh_plant" },
    {itemName = "dh_hr_teddy_bear", rotation = vec4(0.176704, -0.339444, 0.819491, 0.426600), coords = vec3(964.125427, -932.305603, -88.592216), prop = "v_club_vu_bear" },
    {itemName = "dh_hr_clock", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(959.858521, -932.387207, -86.839828), prop = "sf_prop_sf_game_clock_01a" },
    {itemName = "dh_hr_statue_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(961.514893, -932.897156, -87.996948), prop = "sf_prop_sf_art_trophy_cp_01a" },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), coords = vec3(959.638672, -932.966492, -87.270683), prop = "dh_painting_bengal" },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), coords = vec3(956.465393, -937.178650, -87.172485), prop = "dh_painting_modern" },
    {itemName = "dh_hr_passport", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(964.017700, -933.732727, -88.150711), prop = "bkr_prop_fakeid_bundlepassports" },
    {itemName = "dh_hr_bedside_clock", rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), coords = vec3(960.542725, -940.078186, -88.203995), prop = "v_res_fh_bedsideclock" },
    {itemName = "dh_hr_bedside_clock", rotation = vec4(0.000000, 0.000000, 0.953717, 0.300706), coords = vec3(964.664734, -939.996765, -88.195442), prop = "v_res_fh_bedsideclock" },
    {itemName = "dh_hr_fan", rotation = vec4(0.000000, 0.000000, -0.422618, 0.906308), coords = vec3(960.734192, -936.534058, -88.268227), prop = "v_res_fh_towerfan" },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(964.859314, -933.529114, -88.183578), prop = "dh_flower" },
    {itemName = "dh_hr_perfume", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(963.081360, -933.421204, -88.010231), prop = "v_res_r_perfume" },
    {itemName = "dh_hr_laptop", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(963.536926, -933.660034, -88.134163), prop = "m25_1_prop_m51_laptop_01a" },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(955.263306, -938.358582, -87.911880), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(955.250916, -939.294800, -87.911522), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_shave_box", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), coords = vec3(955.547607, -938.856445, -87.922012), prop = "v_res_fh_aftershavebox" },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(959.335449, -926.770996, -91.187416), prop = "dh_flower" },
    {itemName = "dh_hr_iron", rotation = vec4(-0.819152, 0.000000, 0.000000, 0.573577), coords = vec3(955.787537, -936.132690, -89.613098), prop = "prop_iron_01" },
    {itemName = "dh_hr_iron_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(956.387024, -935.722656, -90.994987), prop = "v_ret_fh_ironbrd" },
    {itemName = "dh_hr_hairdryer", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(955.476990, -939.241150, -91.065781), prop = "v_serv_bs_hairdryer" },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(955.239136, -938.145996, -90.884995), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(955.252563, -939.575928, -90.881683), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(966.484070, -926.901978, -90.640625), prop = "dh_plant" },
    {itemName = "dh_hr_bed_dog", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(965.178101, -927.144531, -91.966568), prop = "sf_prop_sf_bed_dog_01a" },
    {itemName = "dh_hr_statue_3", rotation = vec4(0.000000, 0.000000, -0.258819, 0.965926), coords = vec3(960.529724, -927.181396, -91.521507), prop = "sf_prop_sf_art_dog_01c" },
    {itemName = "dh_hr_tv", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), coords = vec3(965.196472, -929.361877, -91.489403), prop = "prop_trev_tv_01" },
    {itemName = "dh_hr_mixer", rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), coords = vec3(961.204224, -939.272461, -90.815193), prop = "v_res_tre_mixer" },
    {itemName = "dh_hr_pestle", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(961.578247, -939.210632, -91.017654), prop = "v_res_pestle" },
    {itemName = "dh_hr_chopboard", rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), coords = vec3(962.263977, -939.199036, -91.019615), prop = "v_res_mchopboard" },
    {itemName = "dh_hr_scales", rotation = vec4(0.000000, 0.000000, -0.906308, -0.422618), coords = vec3(962.940308, -939.286621, -91.020233), prop = "v_res_m_kscales" },
    {itemName = "dh_hr_knife", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(963.427185, -939.220520, -91.021927), prop = "prop_knife_stand" },
    {itemName = "dh_hr_skull", rotation = vec4(0.000000, 0.000000, -0.965926, 0.258819), coords = vec3(963.076965, -934.786377, -90.923286), prop = "vw_prop_casino_art_skull_03b" },
    {itemName = "dh_hr_casino_car", rotation = vec4(0.000000, 0.000000, 0.342020, 0.939693), coords = vec3(965.304932, -934.785828, -90.923157), prop = "vw_prop_casino_art_car_09a" },
    {itemName = "dh_hr_hard_disc", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(964.549011, -934.768677, -90.920876), prop = "xm_prop_x17_harddisk_01a" },
    {itemName = "dh_hr_statue_4", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(966.176392, -932.583374, -91.950485), prop = "m24_1_prop_m41_statue_01a" },
    {itemName = "dh_hr_radio", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), coords = vec3(962.574646, -934.867615, -91.772324), prop = "v_res_j_radio" }
}
House4 = {
    {itemName = "dh_hr_tv", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "ex_prop_ex_tv_flat_01", coords = vec3(977.835693, -930.003479, -87.754807) },
    {itemName = "dh_hr_sculpture", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "apa_mp_h_acc_dec_sculpt_02", coords = vec3(982.279846, -924.751587, -88.660957) },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant", coords = vec3(978.153564, -927.935364, -88.328331) },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant", coords = vec3(994.131470, -936.778931, -87.881424) },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant", coords = vec3(987.602661, -935.766418, -84.717957) },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3", coords = vec3(994.386536, -930.335266, -84.881683) },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3", coords = vec3(993.425232, -930.328125, -84.878212) },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3", coords = vec3(989.792725, -936.174622, -88.343773) },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3", coords = vec3(989.753113, -935.243408, -88.343971) },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "dh_painting_samoyed", coords = vec3(992.311401, -928.446289, -84.134903) },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_painting_bengal", coords = vec3(987.492126, -924.503113, -84.208679) },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), prop = "dh_painting_modern", coords = vec3(987.018555, -935.287903, -87.619446) },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower", coords = vec3(977.999146, -931.840271, -88.872261) },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower", coords = vec3(992.805420, -924.902954, -85.263634) },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower", coords = vec3(991.796814, -920.819336, -85.258461) },
    {itemName = "dh_hr_champagne", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "h4_prop_battle_champ_closed", coords = vec3(980.223267, -924.791260, -86.748978) },
    {itemName = "dh_hr_skull", rotation = vec4(0.000000, 0.000000, -0.342020, 0.939693), prop = "vw_prop_casino_art_skull_03b", coords = vec3(978.313171, -924.700928, -87.807396) },
    {itemName = "dh_hr_casino_car", rotation = vec4(0.000000, 0.000000, -0.887011, 0.461749), prop = "vw_prop_casino_art_car_09a", coords = vec3(977.958008, -930.031677, -88.750740) },
    {itemName = "dh_hr_bedside_clock", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "v_res_fh_bedsideclock", coords = vec3(990.175720, -930.443420, -85.359055) },
    {itemName = "dh_hr_headphones", rotation = vec4(0.737277, 0.000000, 0.000000, 0.675590), prop = "h4_prop_battle_headphones_dj", coords = vec3(987.060486, -925.174683, -85.202560) },
    {itemName = "dh_hr_pc", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_dyn_pc_02", coords = vec3(988.775024, -925.009705, -85.715149) },
    {itemName = "dh_hr_monitor", rotation = vec4(0.000000, 0.000000, 0.043619, 0.999048), prop = "ch_prop_ch_monitor_01a", coords = vec3(987.598877, -924.755737, -85.225334) },
    {itemName = "dh_hr_keyboard", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_cs_keyboard_01", coords = vec3(987.519958, -925.152771, -85.208099) },
    {itemName = "dh_hr_mouse", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_cs_mouse_01", coords = vec3(988.071777, -925.173401, -85.205574) },
    {itemName = "dh_hr_iron", rotation = vec4(0.000000, 0.000000, -0.537300, 0.843391), prop = "prop_iron_01", coords = vec3(989.735901, -921.048340, -85.075378) },
    {itemName = "dh_hr_iron_2", rotation = vec4(0.000000, 0.000000, -1.000000, 0.000000), prop = "v_ret_fh_ironbrd", coords = vec3(988.501160, -922.194275, -85.031113) },
    {itemName = "dh_hr_gold_cd", rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), prop = "sf_prop_sf_lp_plaque_01a", coords = vec3(988.023438, -934.967285, -84.202240) },
    {itemName = "dh_hr_hairdryer", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_serv_bs_hairdryer", coords = vec3(993.815491, -930.095459, -85.056480) },
    {itemName = "dh_hr_coffee", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_coffee_mac_02", coords = vec3(988.951477, -924.811707, -88.133301) },
    {itemName = "dh_hr_mixer", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "v_res_tre_mixer", coords = vec3(991.948547, -929.602356, -88.170929) },
    {itemName = "dh_hr_fan", rotation = vec4(0.000000, 0.000000, -0.923880, 0.382683), prop = "v_res_fh_towerfan", coords = vec3(986.857788, -931.165649, -85.375641) },
    {itemName = "dh_hr_pestle", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_pestle", coords = vec3(992.064819, -927.475464, -88.379059) },
    {itemName = "dh_hr_chopboard", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_mchopboard", coords = vec3(989.565125, -924.826050, -88.375526) },
    {itemName = "dh_hr_scales", rotation = vec4(0.000000, 0.000000, 0.382683, 0.923880), prop = "v_res_m_kscales", coords = vec3(991.941162, -924.859253, -88.377617) },
    {itemName = "dh_hr_plant", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "vw_prop_vw_plant_int_03a", coords = vec3(983.262817, -924.815063, -89.639854) },
    {itemName = "dh_hr_desk_lamp", rotation = vec4(0.000000, 0.000000, -0.422618, 0.906308), prop = "ch_prop_ch_desk_lamp", coords = vec3(986.491333, -924.635193, -85.224960) },
    {itemName = "dh_hr_luggage", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "prop_luggage_07a", coords = vec3(992.041077, -929.989868, -85.841309) },
    {itemName = "dh_hr_trophy", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "m24_1_prop_m41_shield_trophy_01a", coords = vec3(980.196167, -924.775696, -88.657173) },
    {itemName = "dh_hr_bike", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "ch_chint02_bike", coords = vec3(984.890076, -935.589111, -88.143898) },
    {itemName = "dh_hr_guitar", rotation = vec4(0.510052, 0.491880, -0.500845, 0.497046), prop = "prop_el_guitar_01", coords = vec3(981.932068, -924.724304, -89.411270) }
}
House5 = {
    {itemName = "dh_hr_tv", coords = vec3(1007.026672, -934.007019, -88.768761), rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), prop = "ex_prop_ex_tv_flat_01" },
    {itemName = "dh_hr_tv", coords = vec3(1010.372253, -934.452209, -85.762627), rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), prop = "ex_prop_ex_tv_flat_01" },
    {itemName = "dh_hr_tv", coords = vec3(1013.800720, -927.656921, -88.553200), rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "ex_prop_ex_tv_flat_01" },
    {itemName = "dh_hr_sculpture", coords = vec3(1014.099609, -930.743591, -88.536598), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "apa_mp_h_acc_dec_sculpt_02" },
    {itemName = "dh_hr_plant", coords = vec3(1008.670776, -934.197021, -88.693481), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant" },
    {itemName = "dh_hr_plant", coords = vec3(1006.629456, -925.041504, -85.707947), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant" },
    {itemName = "dh_hr_plant", coords = vec3(1013.774780, -926.739441, -85.893448), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant" },
    {itemName = "dh_hr_plant", coords = vec3(1021.802795, -939.931458, -85.692581), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_plant" },
    {itemName = "dh_hr_soap", coords = vec3(1013.412231, -930.294250, -85.969948), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap", coords = vec3(1013.425415, -929.356995, -85.967018), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap", coords = vec3(1014.521118, -935.719299, -88.937927), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_soap", coords = vec3(1014.530457, -934.793274, -88.938347), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3" },
    {itemName = "dh_hr_painting", coords = vec3(1013.149292, -935.201050, -88.028465), rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), prop = "dh_painting_samoyed" },
    {itemName = "dh_hr_painting", coords = vec3(1007.424866, -924.310730, -88.287704), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_painting_bengal" },
    {itemName = "dh_hr_painting", coords = vec3(1015.336609, -940.259460, -85.277763), rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), prop = "dh_painting_modern" },
    {itemName = "dh_hr_painting", coords = vec3(1023.163696, -932.524536, -85.083733), rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "dh_painting_modern" },
    {itemName = "dh_hr_plant_2", coords = vec3(1022.964355, -931.502808, -85.322350), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower" },
    {itemName = "dh_hr_plant_2", coords = vec3(1013.765076, -936.727600, -86.229866), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower" },
    {itemName = "dh_hr_plant_2", coords = vec3(1006.125610, -924.433716, -89.236580), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower" },
    {itemName = "dh_hr_skull", coords = vec3(1010.681885, -934.380127, -86.611565), rotation = vec4(0.000000, 0.000000, 0.965926, 0.258819), prop = "vw_prop_casino_art_skull_03b" },
    {itemName = "dh_hr_casino_car", coords = vec3(1013.761658, -939.888000, -86.193916), rotation = vec4(0.000000, 0.000000, 0.906308, 0.422618), prop = "vw_prop_casino_art_car_09a" },
    {itemName = "dh_hr_bedside_clock", coords = vec3(1021.996155, -935.740417, -86.448914), rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), prop = "v_res_fh_bedsideclock" },
    {itemName = "dh_hr_bedside_clock", coords = vec3(1021.214966, -929.345337, -89.272888), rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "v_res_fh_bedsideclock" },
    {itemName = "dh_hr_headphones", coords = vec3(1014.627441, -939.127380, -86.151421), rotation = vec4(-0.737277, 0.000000, 0.000000, 0.675590), prop = "h4_prop_battle_headphones_dj" },
    {itemName = "dh_hr_laptop", coords = vec3(1015.807556, -939.351379, -86.198112), rotation = vec4(0.000000, 0.000000, 0.923880, 0.382683), prop = "xm_prop_x17_laptop_mrsr" },
    {itemName = "dh_hr_hairdryer", coords = vec3(1015.303772, -934.811035, -86.138947), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_serv_bs_hairdryer" },
    {itemName = "dh_hr_gold_cd", coords = vec3(1017.719116, -931.197571, -85.188286), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "sf_prop_sf_lp_plaque_01a" },
    {itemName = "dh_hr_coffee", coords = vec3(1012.803650, -928.024048, -89.025238), rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "prop_coffee_mac_02" },
    {itemName = "dh_hr_mixer", coords = vec3(1012.808960, -927.634460, -89.077415), rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "v_res_tre_mixer" },
    {itemName = "dh_hr_fan", coords = vec3(1012.906616, -930.605347, -89.341370), rotation = vec4(0.000000, 0.000000, -0.843391, -0.537300), prop = "v_res_fh_towerfan" },
    {itemName = "dh_hr_bed_dog", coords = vec3(1012.443665, -934.021790, -87.011620), rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), prop = "sf_prop_sf_bed_dog_01b" },
    {itemName = "dh_hr_golf", coords = vec3(1016.094604, -924.850403, -89.482613), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "sf_prop_sf_golf_bag_01b" },
    {itemName = "dh_hr_scales", coords = vec3(1010.360291, -928.002014, -89.049408), rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "v_res_m_kscales" },
    {itemName = "dh_hr_bottle", coords = vec3(1007.558105, -926.995544, -88.985840), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "ba_prop_battle_decanter_03_s" },
    {itemName = "dh_hr_statue_5", coords = vec3(1007.194885, -932.197083, -89.496773), rotation = vec4(0.000000, 0.000000, -0.996195, 0.087156), prop = "ba_prop_battle_trophy_dancer" },
    {itemName = "dh_hr_rope", coords = vec3(1018.133118, -929.661072, -86.986694), rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_skip_rope_01" },
    {itemName = "dh_hr_radio", coords = vec3(1020.853638, -930.955139, -86.996552), rotation = vec4(0.000000, 0.000000, 1.000000, 0.000000), prop = "m24_1_prop_m41_radio_01a" },
    {itemName = "dh_hr_speaker", coords = vec3(1017.735107, -930.318665, -84.894821), rotation = vec4(0.000000, 0.000000, 0.737277, -0.675590), prop = "h4_prop_h4_isl_speaker_01a" }
}

House6 = {
    {itemName = "dh_hr_bed_dog", rotation = vec4(0.000000, 0.000000, 0.707107, 0.707107), prop = "sf_prop_sf_bed_dog_01b", coords = vec3(1046.473633, -932.228333, -89.727028) },
    {itemName = "dh_hr_tv", rotation = vec4(0.000000, 0.000000, -0.675590, -0.737277), prop = "prop_tv_flat_03", coords = vec3(1046.587524, -928.830994, -88.638336) },
    {itemName = "dh_hr_tv", rotation = vec4(0.000000, 0.000000, -0.707107, -0.707107), prop = "prop_trev_tv_01", coords = vec3(1036.806641, -930.799500, -88.888817) },
    {itemName = "dh_hr_soap", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_bathroom_accesories_soap_3", coords = vec3(1031.397827, -924.742676, -88.802902) },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_painting_samoyed", coords = vec3(1032.513550, -928.203064, -88.109879) },
    {itemName = "dh_hr_painting", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_painting_bengal", coords = vec3(1035.386597, -924.552979, -87.992615) },
    {itemName = "dh_hr_plant_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "dh_flower", coords = vec3(1043.829346, -924.790955, -88.961731) },
    {itemName = "dh_hr_skull", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "vw_prop_casino_art_skull_03b", coords = vec3(1044.638916, -924.880676, -89.518723) },
    {itemName = "dh_hr_bedside_clock", rotation = vec4(0.000000, 0.000000, -0.461749, 0.887011), prop = "v_res_fh_bedsideclock", coords = vec3(1030.652954, -929.609863, -88.944717) },
    {itemName = "dh_hr_iron", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_iron_01", coords = vec3(1037.038940, -929.163391, -88.814552) },
    {itemName = "dh_hr_iron_2", rotation = vec4(0.000000, 0.000000, -1.000000, 0.000000), prop = "v_ret_fh_ironbrd", coords = vec3(1036.970947, -932.079712, -88.760773) },
    {itemName = "dh_hr_coffee", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "prop_coffee_mac_02", coords = vec3(1038.163696, -930.281860, -88.697311) },
    {itemName = "dh_hr_pestle", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "v_res_pestle", coords = vec3(1037.625122, -930.327087, -88.385498) },
    {itemName = "dh_hr_chopboard", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "v_res_mchopboard", coords = vec3(1038.286133, -931.608521, -88.938980) },
    {itemName = "dh_hr_knife", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "prop_knife_stand", coords = vec3(1037.859985, -931.795410, -88.950317) },
    {itemName = "dh_hr_hard_disc", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "xm_prop_x17_harddisk_01a", coords = vec3(1046.438477, -929.333618, -88.721123) },
    {itemName = "dh_hr_laptop", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "xm_prop_x17_laptop_mrsr", coords = vec3(1045.222168, -924.753113, -88.968170) },
    {itemName = "dh_hr_luggage", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_luggage_06a", coords = vec3(1034.750244, -924.691833, -89.529747) },
    {itemName = "dh_hr_shoe_box", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_fa_shoebox3", coords = vec3(1035.671265, -924.724182, -89.635551) },
    {itemName = "dh_hr_remote", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_tvremote", coords = vec3(1046.414429, -928.808960, -88.705627) },
    {itemName = "dh_hr_speaker", rotation = vec4(0.000000, 0.000000, 0.537300, 0.843391), prop = "v_res_pcspeaker", coords = vec3(1046.669312, -928.017334, -88.719894) },
    {itemName = "dh_hr_tiger_2", rotation = vec4(0.000000, 0.000000, 0.999048, 0.043619), prop = "sum_prop_ac_tigerrug_01a", coords = vec3(1043.858276, -932.739136, -89.762505) },
    {itemName = "dh_hr_sarcophagus", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "sum_prop_ac_sarcophagus_01a", coords = vec3(1040.142090, -925.031982, -89.770065) },
    {itemName = "dh_hr_mug", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_mug01", coords = vec3(1037.666748, -931.393250, -88.320091) },
    {itemName = "dh_hr_mug", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_mug01", coords = vec3(1037.666748, -931.514587, -88.320091) },
    {itemName = "dh_hr_mug", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_mug01", coords = vec3(1037.666748, -931.638184, -88.320091) },
    {itemName = "dh_hr_mug", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_mug01", coords = vec3(1037.666748, -931.768066, -88.320091) },
    {itemName = "dh_hr_pot", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_pot02", coords = vec3(1038.276367, -932.846313, -88.761642) },
    {itemName = "dh_hr_toaster", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_toaster_01", coords = vec3(1037.684448, -930.675415, -88.271057) },
    {itemName = "dh_hr_bike_2", rotation = vec4(0.000000, 0.000000, 0.887011, 0.461749), prop = "prop_exer_bike_01", coords = vec3(1033.844849, -929.346680, -89.657570) },
    {itemName = "dh_hr_bottle", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "h4_prop_battle_whiskey_bottle_s", coords = vec3(1030.889038, -932.192749, -88.804794) },
    {itemName = "dh_hr_basket", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tre_washbasket", coords = vec3(1031.946411, -924.937012, -89.732956) },
    {itemName = "dh_hr_plunger", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_tt_plunger", coords = vec3(1033.742920, -925.406128, -89.378029) },
    {itemName = "dh_hr_scales_2", rotation = vec4(0.000000, 0.000000, -0.707107, 0.707107), prop = "v_ret_ml_scale", coords = vec3(1037.791626, -931.178833, -88.885948) },
    {itemName = "dh_hr_teapot", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_res_r_teapot", coords = vec3(1040.675293, -930.921997, -88.874313) },
    {itemName = "dh_hr_toilet_bag", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_ret_ps_toiletbag", coords = vec3(1044.996460, -924.907227, -89.522591) },
    {itemName = "dh_hr_necklace", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_j_neck_disp_02", coords = vec3(1044.379028, -924.872620, -88.851364) },
    {itemName = "dh_hr_luggage_2", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_ld_case_01", coords = vec3(1036.946411, -928.371216, -88.599731) },
    {itemName = "dh_hr_wheel", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "prop_wheel_01", coords = vec3(1030.926758, -933.028198, -89.395622) },
    {itemName = "dh_hr_brush_pot", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "v_club_vubrushpot", coords = vec3(1031.160767, -924.747742, -88.821167) },
    {itemName = "dh_hr_tool_box", rotation = vec4(0.000000, 0.000000, 0.000000, 1.000000), prop = "xs_prop_x18_tool_box_02a", coords = vec3(1037.001465, -928.535767, -88.947166) }
}