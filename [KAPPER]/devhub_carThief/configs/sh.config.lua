Config = {} -- Do not touch

Config.Debug = false -- Enable debug prints, this will help you find issues

Config.SfxVolume = {
    close = 0.1, -- 0 - 1.0
    error = 0.5, -- 0 - 1.0
    open = 0.1, -- 0 - 1.0
    success = 0.5, -- 0 - 1.0
    terminal = 0.5, -- 0 - 1.0
}

Config.BlipSettings = { -- Blip settings for the car meet locations
    sprite = 225,
    color = 5,
    scale = 0.8,
}

Config.Peds = { -- List of peds that can be spawned at the car meet.
    { model = GetHashKey("a_m_m_socenlat_01"), gender = "male" },
    { model = GetHashKey("a_m_o_ktown_01"), gender = "male" },
    { model = GetHashKey("a_m_y_downtown_01"), gender = "male" },
    { model = GetHashKey("a_m_y_cyclist_01"), gender = "male" },
    { model = GetHashKey("a_m_y_genstreet_02"), gender = "male" },
    { model = GetHashKey("a_m_y_indian_01"), gender = "male" },
    { model = GetHashKey("a_m_y_mexthug_01"), gender = "male" },
    { model = GetHashKey("a_m_y_soucent_02"), gender = "male" },
    { model = GetHashKey("a_m_y_gencaspat_01"), gender = "male" },
    { model = GetHashKey("a_m_y_vindouche_01"), gender = "male" },
    { model = GetHashKey("a_f_y_business_02"), gender = "female" },
    { model = GetHashKey("a_f_y_business_01"), gender = "female" },
    { model = GetHashKey("a_f_y_hipster_02"), gender = "female" },
    { model = GetHashKey("a_f_y_bevhills_04"), gender = "female" },
    { model = GetHashKey("a_f_y_bevhills_01"), gender = "female" },
}

Config.PedAnimations = { -- List of animations that the peds can perform at the car meet.
    { dict = "amb@world_human_bum_wash@male@low@idle_a", anim = "idle_a" },
    { dict = "anim@mp_player_intcelebrationfemale@slow_clap", anim = "slow_clap" },
    { dict = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_a_player_a" },
    { dict = "amb@world_human_strip_watch_stand@male_a@idle_a", anim = "idle_a" },
}

Config.VehiclesSettings = { -- All of vehicle settings
    models = { -- List of cars that can be spawned at the car meet.
        {
            model = GetHashKey("adder"),
            label = "Adder",
            class = "Sports",
            yearOfProduction = { 2010, 2016 }, -- min, max
            image = "https://docs.fivem.net/vehicles/adder.webp",
        },
        {
            model = GetHashKey("banshee"),
            label = "Banshee",
            class = "Sports",
            yearOfProduction = { 2002, 2012 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/banshee.webp",
        },
        {
            model = GetHashKey("bullet"),
            label = "Bullet",
            class = "Sports",
            yearOfProduction = { 2000, 2008 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/bullet.webp",
        },
        {
            model = GetHashKey("cheetah"),
            label = "Cheetah",
            class = "Sports",
            yearOfProduction = { 2012, 2020 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/cheetah.webp",
        },
        {
            model = GetHashKey("entityxf"),
            label = "Entity XF",
            class = "Sports",
            yearOfProduction = { 2013, 2019 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/entityxf.webp",
        },
        {
            model = GetHashKey("fmj"),
            label = "FMJ",
            class = "Sports",
            yearOfProduction = { 2015, 2022 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/fmj.webp",
        },
        {
            model = GetHashKey("infernus"),
            label = "Infernus",
            class = "Sports",
            yearOfProduction = { 2006, 2014 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/infernus.webp",
        },
        {
            model = GetHashKey("nero"),
            label = "Nero",
            class = "Sports",
            yearOfProduction = { 2014, 2021 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/nero.webp",
        },
        {
            model = GetHashKey("osiris"),
            label = "Osiris",
            class = "Sports",
            yearOfProduction = { 2015, 2023 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/osiris.webp",
        },
        {
            model = GetHashKey("penetrator"),
            label = "Penetrator",
            class = "Sports",
            yearOfProduction = { 2012, 2018 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/penetrator.webp",
        },
        {
            model = GetHashKey("pfister811"),
            label = "Pfister 811",
            class = "Sports",
            yearOfProduction = { 2016, 2022 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/pfister811.webp",
        },
        {
            model = GetHashKey("reaper"),
            label = "Reaper",
            class = "Sports",
            yearOfProduction = { 2014, 2020 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/reaper.webp",
        },
        {
            model = GetHashKey("tempesta"),
            label = "Tempesta",
            class = "Sports",
            yearOfProduction = { 2016, 2023 }, -- { min, max }
            image = "https://docs.fivem.net/vehicles/tempesta.webp",
        },
    },
    registries = { -- List of registries countries that can be used in the UI
        "PL",
        "UK",
        "DE",
        "ES",
        "IT",
        "FR",
    },
    colors = {
        { id = 0, label = "Metallic Black" },
        { id = 1, label = "Metallic Graphite Black" },
        { id = 2, label = "Metallic Black Steal" },
        { id = 3, label = "Metallic Dark Silver" },
        { id = 4, label = "Metallic Silver" },
        { id = 5, label = "Metallic Blue Silver" },
        { id = 6, label = "Metallic Steel Gray" },
        { id = 7, label = "Metallic Shadow Silver" },
        { id = 8, label = "Metallic Stone Silver" },
        { id = 9, label = "Metallic Midnight Silver" },
        { id = 10, label = "Metallic Gun Metal" },
        { id = 11, label = "Metallic Anthracite Grey" },
        { id = 12, label = "Matte Black" },
        { id = 13, label = "Matte Gray" },
        { id = 14, label = "Matte Light Grey" },
        { id = 15, label = "Util Black" },
        { id = 16, label = "Util Black Poly" },
        { id = 17, label = "Util Dark silver" },
        { id = 18, label = "Util Silver" },
        { id = 19, label = "Util Gun Metal" },
        { id = 20, label = "Util Shadow Silver" },
        { id = 21, label = "Worn Black" },
        { id = 22, label = "Worn Graphite" },
        { id = 23, label = "Worn Silver Grey" },
        { id = 24, label = "Worn Silver" },
        { id = 25, label = "Worn Blue Silver" },
        { id = 26, label = "Worn Shadow Silver" },
        { id = 27, label = "Metallic Red" },
        { id = 28, label = "Metallic Torino Red" },
        { id = 29, label = "Metallic Formula Red" },
        { id = 30, label = "Metallic Blaze Red" },
        { id = 31, label = "Metallic Graceful Red" },
        { id = 32, label = "Metallic Garnet Red" },
        { id = 33, label = "Metallic Desert Red" },
        { id = 34, label = "Metallic Cabernet Red" },
        { id = 35, label = "Metallic Candy Red" },
        { id = 36, label = "Metallic Sunrise Orange" },
        { id = 37, label = "Metallic Classic Gold" },
        { id = 38, label = "Metallic Orange" },
        { id = 39, label = "Matte Red" },
        { id = 40, label = "Matte Dark Red" },
        { id = 41, label = "Matte Orange" },
        { id = 42, label = "Matte Yellow" },
        { id = 43, label = "Util Red" },
        { id = 44, label = "Util Bright Red" },
        { id = 45, label = "Util Garnet Red" },
        { id = 46, label = "Worn Red" },
        { id = 47, label = "Worn Golden Red" },
        { id = 48, label = "Worn Dark Red" },
        { id = 49, label = "Metallic Dark Green" },
        { id = 50, label = "Metallic Racing Green" },
        { id = 51, label = "Metallic Sea Green" },
        { id = 52, label = "Metallic Olive Green" },
        { id = 53, label = "Metallic Green" },
        { id = 54, label = "Metallic Gasoline Blue Green" },
        { id = 55, label = "Matte Lime Green" },
        { id = 56, label = "Util Dark Green" },
        { id = 57, label = "Util Green" },
        { id = 58, label = "Worn Dark Green" },
        { id = 59, label = "Worn Green" },
        { id = 60, label = "Worn Sea Wash" },
        { id = 61, label = "Metallic Midnight Blue" },
        { id = 62, label = "Metallic Dark Blue" },
        { id = 63, label = "Metallic Saxony Blue" },
        { id = 64, label = "Metallic Blue" },
        { id = 65, label = "Metallic Mariner Blue" },
        { id = 66, label = "Metallic Harbor Blue" },
        { id = 67, label = "Metallic Diamond Blue" },
        { id = 68, label = "Metallic Surf Blue" },
        { id = 69, label = "Metallic Nautical Blue" },
        { id = 70, label = "Metallic Bright Blue" },
        { id = 71, label = "Metallic Purple Blue" },
        { id = 72, label = "Metallic Spinnaker Blue" },
        { id = 73, label = "Metallic Ultra Blue" },
        { id = 74, label = "Metallic Bright Blue" },
        { id = 75, label = "Util Dark Blue" },
        { id = 76, label = "Util Midnight Blue" },
        { id = 77, label = "Util Blue" },
        { id = 78, label = "Util Sea Foam Blue" },
        { id = 79, label = "Util Lightning blue" },
        { id = 80, label = "Util Maui Blue Poly" },
        { id = 81, label = "Util Bright Blue" },
        { id = 82, label = "Matte Dark Blue" },
        { id = 83, label = "Matte Blue" },
        { id = 84, label = "Matte Midnight Blue" },
        { id = 85, label = "Worn Dark blue" },
        { id = 86, label = "Worn Blue" },
        { id = 87, label = "Worn Light blue" },
        { id = 88, label = "Metallic Taxi Yellow" },
        { id = 89, label = "Metallic Race Yellow" },
        { id = 90, label = "Metallic Bronze" },
        { id = 91, label = "Metallic Yellow Bird" },
        { id = 92, label = "Metallic Lime" },
        { id = 93, label = "Metallic Champagne" },
        { id = 94, label = "Metallic Pueblo Beige" },
        { id = 95, label = "Metallic Dark Ivory" },
        { id = 96, label = "Metallic Choco Brown" },
        { id = 97, label = "Metallic Golden Brown" },
        { id = 98, label = "Metallic Light Brown" },
        { id = 99, label = "Metallic Straw Beige" },
        { id = 100, label = "Metallic Moss Brown" },
        { id = 101, label = "Metallic Biston Brown" },
        { id = 102, label = "Metallic Beechwood" },
        { id = 103, label = "Metallic Dark Beechwood" },
        { id = 104, label = "Metallic Choco Orange" },
        { id = 105, label = "Metallic Beach Sand" },
        { id = 106, label = "Metallic Sun Bleeched Sand" },
        { id = 107, label = "Metallic Cream" },
        { id = 108, label = "Util Brown" },
        { id = 109, label = "Util Medium Brown" },
        { id = 110, label = "Util Light Brown" },
        { id = 111, label = "Metallic White" },
        { id = 112, label = "Metallic Frost White" },
        { id = 113, label = "Worn Honey Beige" },
        { id = 114, label = "Worn Brown" },
        { id = 115, label = "Worn Dark Brown" },
        { id = 116, label = "Worn straw beige" },
        { id = 117, label = "Brushed Steel" },
        { id = 118, label = "Brushed Black steel" },
        { id = 119, label = "Brushed Aluminium" },
        { id = 120, label = "Chrome" },
        { id = 121, label = "Worn Off White" },
        { id = 122, label = "Util Off White" },
        { id = 123, label = "Worn Orange" },
        { id = 124, label = "Worn Light Orange" },
        { id = 125, label = "Metallic Securicor Green" },
        { id = 126, label = "Worn Taxi Yellow" },
        { id = 127, label = "police car blue" },
        { id = 128, label = "Matte Green" },
        { id = 129, label = "Matte Brown" },
        { id = 130, label = "Worn Orange" },
        { id = 131, label = "Matte White" },
        { id = 132, label = "Worn White" },
        { id = 133, label = "Worn Olive Army Green" },
        { id = 134, label = "Pure White" },
        { id = 135, label = "Hot Pink" },
        { id = 136, label = "Salmon pink" },
        { id = 137, label = "Metallic Vermillion Pink" },
        { id = 138, label = "Orange" },
        { id = 139, label = "Green" },
        { id = 140, label = "Blue", },
        { id = 141, label = "Mettalic Black Blue" },
        { id = 142, label = "Metallic Black Purple" },
        { id = 143, label = "Metallic Black Red" },
        { id = 144, label = "hunter green" },
        { id = 145, label = "Metallic Purple" },
        { id = 146, label = "Metaillic V Dark Blue" },
        { id = 148, label = "Matte Purple" },
        { id = 149, label = "Matte Dark Purple" },
        { id = 150, label = "Metallic Lava Red" },
        { id = 151, label = "Matte Forest Green" },
        { id = 152, label = "Matte Olive Drab" },
        { id = 153, label = "Matte Desert Brown" },
        { id = 154, label = "Matte Desert Tan" },
        { id = 155, label = "Matte Foilage Green" },
        { id = 157, label = "Epsilon Blue" },
    },
    insuranceChance = 0.5, -- 50% | chance that the spawned vehicle will have insurance
    registrationChance = 0.5, -- 50% | chance that the spawned vehicle will have valid registration
}

Config.Nodes = { -- List of nodes that can be used in the UI
    "WARSAW",
    "LONDON",
    "BERLIN",
    "MADRID",
    "ROME",
    "PARIS",
}

Config.Names = {
    male = {
        "Liam Anderson",
        "Noah Thompson",
        "James Wilson",
        "Benjamin Harris",
        "Elijah Clark",
        "Lucas Lewis",
        "Mason Robinson",
        "Ethan Walker",
        "Alexander Hall",
        "Daniel Allen",
        "Matthew Young",
        "Joseph King",
        "Samuel Wright",
        "David Scott",
        "Andrew Green",
        "Christopher Baker",
        "Joshua Adams",
        "Nathan Nelson",
        "Ryan Carter",
        "Caleb Mitchell",
        "John Smith"
    },
    female = {
        "Emma Johnson",
        "Olivia Davis",
        "Ava Martinez",
        "Isabella Garcia",
        "Sophia Rodriguez",
        "Mia Hernandez",
        "Charlotte Lopez",
        "Amelia Gonzalez",
        "Harper Wilson",
        "Evelyn Anderson",
        "Abigail Thomas",
        "Emily Taylor",
        "Elizabeth Moore",
        "Sofia Jackson",
        "Avery Martin",
        "Ella Lee",
        "Scarlett Perez",
        "Grace Thompson",
        "Chloe White",
        "Lily Harris",
    }
}

Config.Music = {
    volume = 0.1, -- 0 - 1.0 | Volume of the music that will be played at the car meet
    distance = 35.0, -- Range (in meters) at which the music can be heard. A wider range also makes the fade smoother as the player approaches
    musics = { -- List of musics that can be played at the car meet, script will pick one of these musics randomly and play it on the car meet location
        "https://youtu.be/kS87s-Gsgrs?si=RUAE8Uy6uwwxFRCs",
        "https://www.youtube.com/watch?v=PxkKPEKNBYM",
        "https://www.youtube.com/watch?v=pROMhMqBwNE",
        "https://www.youtube.com/watch?v=OneGjvSqJr0",
    } 
}

Config.CarThiefLocations = { -- List of locations where the car meet can be held.
    {
        blipCoords = vec3(-1666.841, -925.729, 8.042), -- The location of the blip that will be shown to the player when they start the task

        amountOfPeds = 7, -- Amount of peds that will be spawned at the car meet. This need to be lower than or equal to the amount of names in Config.Names
        vehicleLocations = {
            vec4(-1672.297, -930.277, 7.401, 319.127),
            vec4(-1663.279, -919.840, 7.806, 138.121),
            vec4(-1661.050537, -921.810974, 7.796387, 136.062988),
            vec4(-1670.109, -932.434, 7.399, 319.933),
            vec4(-1665.9225, -917.9390, 8.2215, 136.6790),
            vec4(-1675.1017, -928.5654, 7.8068, 319.5054),
        },
        pedLocations = { -- The location where the peds will be spawned, this need to be lower than or equal to the amount of peds
            vec4(-1666.777, -926.222, 8.032, 68.326),
            vec4(-1675.680, -923.901, 7.904, 270.71),
            vec4(-1668.112, -919.760, 8.144, 244.32),
            vec4(-1661.253, -916.268, 8.325, 170.989),
            vec4(-1657.826, -922.156, 8.278, 74.209),
            vec4(-1667.389, -931.902, 7.891, 84.831),
            vec4(-1671.715, -936.038, 7.721, 331.944),
            vec4(-1674.342, -933.985, 7.717, 337.806)
        }
    },
    {
        blipCoords = vec3(-185.8651, -1947.9749, 27.620), -- The location of the blip that will be shown to the player when they start the task

        amountOfPeds = 7, -- Amount of peds that will be spawned at the car meet. This need to be lower than or equal to the amount of names in Config.Names
        vehicleLocations = {
            vec4(-180.7981, -1942.2771, 27.6204, 114.8625),
            vec4(-180.0936, -1945.6910, 27.6204, 111.7656),
            vec4(-179.1033, -1949.1097, 27.6204, 110.3326),
            vec4(-191.0612, -1954.4496, 27.6204, 289.6256),
            vec4(-191.6682, -1950.2756, 27.6204, 294.2201),
            vec4(-193.2270, -1946.7848, 27.6204, 293.4139),
        },
        pedLocations = { -- The location where the peds will be spawned, this need to be lower than or equal to the amount of peds
            vec4(-194.1742, -1942.6903, 27.6204, 9.3266),
            vec4(-190.9685, -1938.6372, 27.6263, 260.7179),
            vec4(-186.8338, -1943.5566, 27.6270, 210.8616),
            vec4(-185.9826, -1952.0710, 27.6217, 172.0765),
            vec4(-179.3346, -1954.8231, 27.6206, 256.1837),
            vec4(-182.8503, -1937.1128, 27.6204, 70.8802),
            vec4(-194.4026, -1944.0615, 27.6204, 198.9256),
            vec4(-184.3557, -1947.1671, 27.6204, 310.3213),
        }
    },
    {
        blipCoords = vec3(884.7067, -42.0096, 78.7641), -- The location of the blip that will be shown to the player when they start the task

        amountOfPeds = 7, -- Amount of peds that will be spawned at the car meet. This need to be lower than or equal to the amount of names in Config.Names
        vehicleLocations = {
            vec4(880.9044, -34.8354, 78.3518, 238.1413),
            vec4(879.3483, -38.0927, 78.3541, 237.4079),
            vec4(876.9467, -40.6993, 78.3524, 239.1902),
            vec4(887.9203, -47.5353, 78.3522, 58.5148),
            vec4(889.8762, -44.6647, 78.3538, 59.9900),
            vec4(891.6218, -41.6542, 78.3544, 57.9501),
        },
        pedLocations = { -- The location where the peds will be spawned, this need to be lower than or equal to the amount of peds
            vec4(894.5435, -37.7907, 78.7640, 144.5135),
            vec4(890.0764, -33.0559, 78.7641, 114.6270),
            vec4(886.3415, -29.4545, 78.7641, 136.9048),
            vec4(885.8583, -37.5582, 78.7643, 215.8790),
            vec4(881.3779, -45.0197, 78.7642, 69.3606),
            vec4(880.8229, -52.9838, 78.7642, 265.0425),
            vec4(879.6840, -50.5322, 78.7642, 44.8904),
            vec4(884.1389, -42.1308, 78.7642, 306.5646),
        }
    },
}

Config.CarChecker = { -- Options for the car checker.
    itemName = "devhub_car_checker", -- Item name that will trigger the car checker when used

    duiConfig = { -- Prefer to keep the default values, changing them may cause issues with the script if you don't know what you are doing
        url       = "nui://devhub_carThief/html/index.html",
        resX      = 1280, -- Landscape, so the existing car-checker UI layout still fits
        resY      = 720,
        model     = GetHashKey("prop_laptop_lester"), -- Smaller landscape prop, proven to work with the DUI texture swap (see devhub_licenses)

        pollMax   = 100,
        postDelay = 300,
        loadTicks = 500,
        dictTicks = 10,

        -- Screen-space corners of the prop's screen, used to map the mouse onto the DUI.
        -- These MUST be re-calibrated in-game for this prop (see the calibration steps below).
        screenTL = { x = 0.3211, y = 0.3569 },
        screenTR = { x = 0.6754, y = 0.3569 },
        screenBL = { x = 0.2898, y = 0.7785 },
        screenBR = { x = 0.7047, y = 0.7785 },

        swapMap = { -- { textureDict, textureName } of the prop screen that gets replaced with the DUI.
            -- The exact screen texture name varies, so several candidates are listed -
            -- a non-matching entry is harmless, only the correct one takes effect.
            -- This same candidate list is used by devhub_licenses and is confirmed working.
            { "prop_laptop_lester", "prop_lester_screen" },
            { "prop_laptop_lester", "prop_laptop_lester" },
            { "prop_laptop_lester", "prop_screen"        },
            { "prop_laptop_lester", "screen"             },
            { "prop_laptop_lester", "laptop_screen"      },
        },
    },

    cameraConfig = { -- Camera config for the car checker
        offset = vec3(0.0, -0.28, 0.165), -- Closer than the orbital screen so the smaller prop still fills the view - tune in-game
        fadeTime  = 500,
    },

    plateFocus = { -- While the car checker DUI is open, this key swings the camera onto the nearest vehicle's plate so the player can read it
        key          = "Tab",  -- Keyboard key that toggles plate focus (JS KeyboardEvent.key value, e.g. "Tab", "f", "Control")
        searchRadius = 60.0,   -- How far (meters) to search for the closest vehicle
        camDistance  = 1.6,    -- How far behind the plate the camera sits
        camHeight    = 0.2,    -- Vertical camera offset above the plate
    },

    foundSequence = { -- What happens once the car checker identifies the wanted vehicle
        closeDelay = 4000, -- ms the result stays on screen before the DUI auto-closes
    },


    animation = {
        dict = "anim@heists@box_carry@",
        anim = "idle",
    },

    attach = { -- How the prop sits in the player's right hand - tune offset/rot in-game if it clips
        bone = 28422,
        offset = vec3(0.0, -0.1, -0.18),
        -- rot = { pitch, yaw, roll }. pitch tilts the laptop up/down (more negative = more upright),
        -- yaw faces it toward the player, roll levels it side-to-side.
        rot = vec3(-2.0, 0.0, 180.0)
    }
}

Config.KeyCloner = { -- Options for the key cloner
    itemName = "devhub_key_cloner", -- Item name that will trigger the key cloner when used

    duiConfig = { -- Prefer to keep the default values, changing them may cause issues with the script if you don't know what you are doing
        url       = "nui://devhub_carThief/html/index.html",
        resX      = 720,
        resY      = 1280,
        model     = GetHashKey("prop_phone_cs_frank"),

        pollMax   = 100,
        postDelay = 300,
        loadTicks = 500,
        dictTicks = 10,

        screenTL = { x = 0.4302, y = 0.3148 },
        screenTR = { x = 0.5615, y = 0.3130 },
        screenBL = { x = 0.4302, y = 0.6676 },
        screenBR = { x = 0.5615, y = 0.6658 },

        swapMap = {
            { "prop_phone_cs_frank", "black_screen" },
        },
    },

    initialization = {
        updateInterval = 50, -- Interval at which the progress will be updated
        distanceThreshold = 9.0, -- Distance at which the progress will start to decrease, this is in case the player moves away from the car while cloning the key
        maxRatePerSecond = 20.0, -- How much progress will be added per second when the player is within the distance threshold
        minDistance = 2.0, -- If the player is closer to the ped than the specified value, the detection bar will begin to increase.
        detectionBarIncreaseRate = 2.5, -- How much the detection bar will increase per `updateInterval` when the player is within the `minDistance`
        detectionBarDecreaseRate = 2.5, -- How much the detection bar will decrease per `updateInterval` when the player is outside of the `minDistance`

        pedMarker = {
            type = 20,
            offset = vec3(0.0, 0.0, 1.0),
            rotation = vec3(0.0, 180.0, 0.0),
            scale = vec3(0.2, 0.2, 0.2),
            color = { r = 255, g = 255, b = 0, a = 100 },
        },
    },

    animation = { -- animation that will be played while the player is reading the key
        dict = "cellphone@",
        anim = "cellphone_text_read_base",
    },
    
    attach = { -- offset for attaching the phone to the player's hand
        bone = 28422,
        offset = vec3(0.0, 0.0, 0.0),
        rot = vec3(0.0, 0.0, 0.0)
    },

    cameraConfig = { -- Camera config for the key cloner
        offset = vec3(0.0, -0.2, 0.0),
        fadeTime  = 500,
    },

    distractingPed = {
        target = {
            icon = 'fa-solid fa-comment', -- target icon (https://fontawesome.com/icons)
        },

        npcDialogData = {
            npc = {
                role = "Citizen",
                icon = 'fas fa-user',
                camera = { -- @table (optional) camera settings for npc dialog
                    distance = 0.85, -- @number (optional) camera distance from npc, default 0.85
                    height = 0.65, -- @number (optional) camera height offset, default 0.65
                },
                animation = { -- @table (optional) animation to play on npc when dialog opens
                    dict = "gestures@m@standing@casual", -- @string (required) animation dictionary
                    name = "gesture_shrug_hard", -- @string (required) animation name
                    blendIn = 8.0, -- @number (optional) blend in speed, default 8.0
                    blendOut = -8.0, -- @number (optional) blend out speed, default -8.0
                    duration = -1, -- @number (optional) animation duration in ms, -1 for full length, default -1
                    flag = 2, -- @number (optional) animation flags (0 = normal, 1 = repeat, 2 = stop on last frame, etc.), default 1
                    playbackRate = 0, -- @number (optional) playback rate, default 0
                },
            },
            soundFile = '', -- @string (optional) sound file URL to play when dialog opens
            -- Pool of distraction lines. Each time the player opens this dialog, 3 are
            -- picked at random, and at least one of the 3 will always be a failing option.
            options = {
                {
                    label = "Did you see Tom Holland around the corner?", -- @string (required) option label shown to the player
                    icon = 'fas fa-comment', -- @string (required) fontawesome icon class
                },
                {
                    label = "Someone was asking about you; they're standing over there by the car.",
                    icon = 'fas fa-comment',
                },
                {
                    label = "Is that your friend over there waving at you?",
                    icon = 'fas fa-comment',
                },
                {
                    label = "There's a guy by the entrance saying he knows you.",
                    icon = 'fas fa-comment',
                },
                {
                    label = "The host is looking for you - he's over by the speakers.",
                    icon = 'fas fa-comment',
                },
                {
                    label = "I think someone just scratched a car down the street.",
                    icon = 'fas fa-comment',
                },
                {
                    label = "Can you step aside? I want to steal your car.",
                    icon = 'fas fa-comment',
                    fail = true -- @boolean if true, selecting this option cancels the car meet and calls the police
                },
                {
                    label = "Mind handing me your car keys for a second?",
                    icon = 'fas fa-comment',
                    fail = true
                },
                {
                    label = "Don't move - I'm taking your car.",
                    icon = 'fas fa-comment',
                    fail = true
                },
            }
        },

        distractedPedCoords = vec4(0.245, 0.275, 0.110, 31.899), -- The location where the distracted ped will go

        distractTime = 60000, -- The time, in milliseconds, during which ped attention will be diverted
        staticMessagePosition = "bottom-right", -- top-left, top-right, bottom-left, bottom-right
    },

    unlockingCar = {
        vehicleMarker = {
            type = 20,
            offset = vec3(0.0, 0.0, 1.5),
            rotation = vec3(0.0, 180.0, 0.0),
            scale = vec3(0.4, 0.4, 0.4),
            color = { r = 255, g = 255, b = 0, a = 100 },
        },

        maxDistance = 5.0, -- Max distance from the car at which the player can unlock it using the key cloner
        duration = 7500, -- Duration of the unlocking progress in milliseconds
    }
}

Config.ReturningVehicle = { -- Options for returning the vehicle after the car meet
    blip = {
        sprite = 225,
        color = 5,
        scale = 0.8,
    },

    locations = {
        {
            ped = {
                model = GetHashKey("a_m_m_soucent_01"), -- Ped model that will be spawned to return the vehicle
                anim = { dict = "missmic_3_ext@leadin@mic_3_ext", anim = "_leadin_trevor" }, -- Animation that the return vehicle ped will play
                coords = vec4(-693.550, -1396.158, 4.150, 230.969), -- Location where the ped will be spawned to return the vehicle
                name = "Bob Grass" -- Name of the ped that will be shown in the UI when the player is returning the vehicle
            },

            targetVehicleCoords = vec3(-680.220, -1403.692, 4.576) -- Location where the player need to bring the vehicle to complete the task
        },
        {
            ped = {
                model = GetHashKey("a_m_m_soucent_01"), -- Ped model that will be spawned to return the vehicle
                anim = { dict = "missmic_3_ext@leadin@mic_3_ext", anim = "_leadin_trevor" }, -- Animation that the return vehicle ped will play
                coords = vec4(-422.8473, 1217.9650, 324.7582, 257.0289), -- Location where the ped will be spawned to return the vehicle
                name = "Bob Grass" -- Name of the ped that will be shown in the UI when the player is returning the vehicle
            },

            targetVehicleCoords = vec3(-417.0455, 1215.7380, 325.6418) -- Location where the player need to bring the vehicle to complete the task
        },
        {
            ped = {
                model = GetHashKey("a_m_m_soucent_01"), -- Ped model that will be spawned to return the vehicle
                anim = { dict = "missmic_3_ext@leadin@mic_3_ext", anim = "_leadin_trevor" }, -- Animation that the return vehicle ped will play
                coords = vec4(1455.6479, -2623.2271, 47.6284, 2.6918), -- Location where the ped will be spawned to return the vehicle
                name = "Bob Grass" -- Name of the ped that will be shown in the UI when the player is returning the vehicle
            },

            targetVehicleCoords = vec3(1453.3458, -2616.2141, 48.5382) -- Location where the player need to bring the vehicle to complete the task
        },
        {
            ped = {
                model = GetHashKey("a_m_m_soucent_01"), -- Ped model that will be spawned to return the vehicle
                anim = { dict = "missmic_3_ext@leadin@mic_3_ext", anim = "_leadin_trevor" }, -- Animation that the return vehicle ped will play
                coords = vec4(-327.2182, -2757.2878, 5.1002, 321.0342), -- Location where the ped will be spawned to return the vehicle
                name = "Bob Grass" -- Name of the ped that will be shown in the UI when the player is returning the vehicle
            },

            targetVehicleCoords = vec3(-324.9109, -2750.3896, 6.0112) -- Location where the player need to bring the vehicle to complete the task
        },
    },

    target = {
        icon = 'fa-solid fa-comment', -- target icon (https://fontawesome.com/icons)
        radius = 2.0,
    },

    parkRadius = 10.0, -- How close (meters) the vehicle must be parked to the drop-off spot for it to count

    npcDialogData = {
        npc = {
            role = "Citizen",
            icon = 'fas fa-user',
            camera = { -- @table (optional) camera settings for npc dialog
                distance = 0.85, -- @number (optional) camera distance from npc, default 0.85
                height = 0.65, -- @number (optional) camera height offset, default 0.65
            },
            animation = { -- @table (optional) animation to play on npc when dialog opens
                dict = "gestures@m@standing@casual", -- @string (required) animation dictionary
                name = "gesture_shrug_hard", -- @string (required) animation name
                blendIn = 8.0, -- @number (optional) blend in speed, default 8.0
                blendOut = -8.0, -- @number (optional) blend out speed, default -8.0
                duration = -1, -- @number (optional) animation duration in ms, -1 for full length, default -1
                flag = 2, -- @number (optional) animation flags (0 = normal, 1 = repeat, 2 = stop on last frame, etc.), default 1
                playbackRate = 0, -- @number (optional) playback rate, default 0
            },
        },
        soundFile = '', -- @string (optional) sound file URL to play when dialog opens
        optionIcon = 'fas fa-car' -- @string (required) fontawesome icon class
    }
}

Config.Informant = { -- The contact the player must meet before the car meet location is revealed
    despawnDelay = 60000, -- ms the contact lingers after the conversation ends before despawning
    ped = {
        model = "a_m_y_business_03", -- Informant ped model
        anim = { dict = "amb@world_human_smoking@male@male_a@idle_a", anim = "idle_a" }, -- Idle animation (set to false to disable)
    },
    locations = { -- The informant spawns at one of these, picked at random for each task
        vec4(269.1508, 3.2266, 78.2459, 246.6737),
        vec4(-1564.5082, -300.3329, 47.2321, 320.0967),
    },
    blip = { -- Blip that points the player to the informant
        sprite = 480,
        color = 5,
        scale = 0.8,
    },
    target = {
        icon = "fas fa-user-secret", -- target icon (https://fontawesome.com/icons)
    },
    giveItems = { -- Tools the informant hands over if the player doesn't already have them
        { name = "devhub_car_checker", amount = 1 },
        { name = "devhub_key_cloner", amount = 1 },
    },
    npcDialogData = { -- Dialog styling (devhub_lib NpcDialog)
        npc = {
            role = "Contact",
            icon = "fas fa-user-secret",
            camera = {
                distance = 0.85,
                height = 0.65,
            },
        },
        soundFile = "",
    },
}

Config.LocationResetTime = 600000 -- Time in milliseconds after which a location will be reset (10 minutes)

Config.MinPolice = 0 -- Minimum amount of police online required to join the queue

Config.MaxTaskTime = 20 -- Maximum time (in minutes) before the next queued player is processed
Config.PersonalCooldownTime = 10 -- Personal cooldown (in minutes) before a player can join the queue again

Config.StartRequirements = {
    -- Item example (player must have the item, set consume = true to remove it on start):
    -- { name = "devhub_car_checker", amount = 1, consume = false },

    -- Custom handler example:
    -- {
    --     label = "Crew Membership",
    --     icon = "fas fa-users",
    --     check = function(source)
    --         return true
    --     end,
    --     action = function(source)
    --         -- runs once the task actually starts
    --     end,
    -- },
}

Config.PedSettings = {
    enabled = true, -- Spawn an NPC players can talk to in order to join the queue / check their position
    peds = {
        {
            model = "ig_lestercrest",
            coords = vec4(-452.5981, 171.7005, 75.2038, 350.6036),
            blip = {
                enabled = true,
                sprite = 225,
                color = 5,
                scale = 0.8,
                label = "Car Meet Contact",
            },
        },
    },
}

Config.SkillTree = { -- devhub_skillTree integration (https://store.devhub.gg/product/6438994)
    enabled = false, -- Enable skill tree XP rewards + the skill perks below
    category = "laptop", -- Skill tree category UID the skills + XP belong to

    xpPerJob = 30, -- XP awarded to the player on completing a car meet job

    -- Each value is the `uid` of a skill in your skill tree. When a player has the skill
    -- unlocked, its `effect` value is applied as a percentage. Paste the matching skill
    -- definitions (provided separately) into your skill tree's Config.SkillsList.
    skills = {
        steadyHands  = "carthief_steady_hands",  -- key cloner detection meter fills slower
        quickHands   = "carthief_quick_hands",   -- key cloner reads the key faster
        silverTongue = "carthief_silver_tongue", -- distracted vehicle owners stay away longer
        masterThief  = "carthief_master_thief",  -- the stolen vehicle unlocks faster
    },
}

Config.Rewards = { -- Optional reward paid out directly when the stolen car is returned (does NOT need devhub_laptop)
    enabled = false, -- Set true to hand out these rewards on job completion

    money = { -- Cash payout - set max to 0 to skip the money reward
        account = "bank", -- "cash" or "bank"
        min = 1500,
        max = 3000,
    },

    items = { -- Item rewards - each entry independently rolls its `chance` (1-100) on completion
        -- { item = "goldbar", min = 1, max = 2, chance = 40 },
        -- { item = "rolex",   min = 1, max = 1, chance = 25 },
    },
}

Config.LaptopConfig = {
    enabled = true, -- Integrate with the devhub_laptop Crime Traders app
    traderId = 'trader_1',
    name = 'Car Thief',
    smallDescription = 'Steal a high-end car from an underground car meet.',
    description = 'Join the queue and wait for your turn. Travel to the car meet, identify the target vehicle with a car checker, clone its key, distract the owner, steal the car and deliver it to the buyer.',
    bannerImage = 'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/carThief/taskImage.webp', 
    images = {
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/carThief/img1.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/carThief/img2.webp',
        'https://upload.devhub.gg/dh_upload/laptop/appStore/appGallery/crimeTraders/carThief/img3.webp',
    },
    link = "https://store.devhub.gg",
    rewards = {
        items = {
            -- { name = 'money', quantity = 2000 },
        },
        money = 2000,
        crimePoints = 600,
        xp = 300,
    },
    tasks = {
        ['uid_1'] = {
            name = 'Join the queue',
            description = 'Join the queue and wait for your turn.',
            icon = 'fas fa-sign-in-alt',
            order = 1,
        },
        ['uid_8'] = {
            name = 'Meet your contact',
            description = 'Find the informant and talk to them to get the details of the job.',
            icon = 'fas fa-user-secret',
            order = 2,
        },
        ['uid_2'] = {
            name = 'Travel to the car meet',
            description = 'A GPS marker will show the location of the car meet. Head there.',
            icon = 'fas fa-map-marker-alt',
            order = 3,
        },
        ['uid_3'] = {
            name = 'Identify the target vehicle',
            description = 'Use the car checker to search license plates and find the wanted vehicle.',
            icon = 'fas fa-id-card',
            order = 4,
        },
        ['uid_4'] = {
            name = 'Clone the vehicle key',
            description = 'Use the key cloner near the vehicle owner to copy the key without being noticed.',
            icon = 'fas fa-key',
            order = 5,
        },
        ['uid_5'] = {
            name = 'Distract the owner',
            description = 'Talk to the vehicle owner and lure them away from the car.',
            icon = 'fas fa-comments',
            order = 6,
        },
        ['uid_6'] = {
            name = 'Steal the vehicle',
            description = 'Use the cloned key to unlock the vehicle and drive off with it.',
            icon = 'fas fa-car-burst',
            order = 7,
        },
        ['uid_7'] = {
            name = 'Deliver the vehicle',
            description = 'Drive the stolen vehicle to the buyer and hand it over to finish the job.',
            icon = 'fas fa-flag-checkered',
            order = 8,
        },
    }
}