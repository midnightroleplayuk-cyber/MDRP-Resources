Config = {} -- You can place webhook link for logs in server/main_editable.lua

Config.Framework = 'qb' -- 'esx' | 'qb'
Config.NotificationType = 'ox' -- 'esx' | 'qb' | 'ox' | 'mythic'
Config.Locale = 'en' -- 'en' | 'fi'
Config.ImagePath = 'nui://ox_inventory/web/images' -- path for images used in UI (for QB: nui://qb-inventory/html/images) (for ox_inventory: nui://ox_inventory/web/images)
Config.DebugMode = false -- false | true

Config.Inventory = 'ox' -- 'default' | 'ox' | 'qs' | 'qb_old' | 'qb_new'
Config.Target = 'ox' -- 'none' | 'ox' | 'qb'
Config.Clothing = 'illenium' -- 'illenium' | 'qb' -- DO NOT CHANGE FROM ILLENIUM IN HERE! ITS CLIENT MAIN_EDITABLE!
Config.Bossmenu = 'qb' -- 'tk' | 'esx' | 'qb'
Config.Jail = 'tk' -- 'tk'
Config.Billing = 'qb' -- 'esx' | 'qb' | 'okok'
Config.UseOxLib = true -- false | true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true

Config.InteractionType = 'menu' --  'menu' | 'target' | 'both'
Config.UseMouseForMenu = false -- true | false, if true you use mouse to navigate menu, if false you use arrow keys. Only used if Config.InteractionType is set to 'menu' and Config.UseOxLib is set to false

Config.UISettings = {
    color = 'blue', -- https://v6.mantine.dev/theming/colors/
    shade = 6, -- 1-9
}

Config.Controls = {
    interact = 38, -- E
    remove = 246, -- Y
    stopDrag = 177, -- BACKSPACE
}

Config.Keybinds = { -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    radar = {
       -- toggle = 'F7',
        moveMode = 'F9',
        lockFront = 'NUMPAD8',
        lockBack = 'NUMPAD2',
        focus = '0',
        frontLane = 'NUMPAD4',
        backLane = 'NUMPAD6',
    },
   -- policeMenu = 'F6',
    tackle = 'Q',
    softCuff = 'UP',
    --hardCuff = '',
    uncuff = 'DOWN',
    drag = 'LEFT',
}
Config.TackleForEveryone = false -- false | true, should everyone be able to tackle players

Config.Anims = {
    place = {
        dict = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@',
        name = 'plant_floor',
        duration = 1000,
    },
    remove = {
        dict = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@',
        name = 'plant_floor',
        duration = 1000,
    },
    softCuff = {
        dict = 'mp_arrest_paired',
        name = 'cop_p2_fwd_left',
        flag = 24,
    },
    hardCuff = {
        dict = 'mp_arrest_paired',
        name = 'cop_p2_back_right',
        flag = 8,
    },
    unCuff = {
        dict = 'mp_arresting',
        name = 'a_uncuff',
        flag = 24,
    },
    tackle = {
        player = {
            dict = 'missmic2ig_11',
            name = 'mic_2_ig_11_intro_goon',
            flag = 0,
        },
        target = {
            dict = 'missmic2ig_11',
            name = 'mic_2_ig_11_intro_p_one',
            flag = 0,
        },
    },
    cuffed = {
        front = {
            dict = 'anim@move_m@prisoner_cuffed',
            name = 'idle',
            flag = 49,
        },
        back = {
            dict = 'mp_arresting',
            name = 'idle',
            flag = 49,
        }
    }
}

Config.Dist = {
    analyze = 2.0,
    evidence = {
        see = 10.0,
        interact = 2.0,
    },
    reconstruction = 20.0,
}

Config.Items = {
    handcuffs = 'handcuffs',
    --handcuffsKey = 'handcuffs_key',
    fingerprintScanner = 'fingerprint_scanner',
    breathalyzer = 'breathalyzer',
    bodycam = 'bodycam',
    dashCam = 'dash_cam',
    lockpick = 'lockpick',
}
Config.HandcuffsOnlyForPolice = true
Config.GiveKeyOnCuff = false -- false | true, should you get they handcuffs key item when cuffing someone
Config.RequireFaceTargetWhenCuffing = true -- false | true, should you need to face target when cuffing/uncuffing
Config.AllowCuffingCuffedTarget = false -- false | true, if set to true you can cuff target even if they are already cuffed
Config.CuffControlsToDisable = {
    soft = {140, 69, 92, 114, 56, 21, 24, 25, 263, 45, 22, 44, 37, 23, 288, 289, 170, 167, 0, 26, 73, 199, 59, 71, 72, 36, 47, 264, 257, 141, 142, 143, 75, 80, 250, 310},
    hard = {30, 31, 32, 33, 34, 35},
}
Config.ShowFakeNameForNPCVehicle = true -- false | true, should the script show a random name for NPC vehicles
Config.FakeName = {
    firstNames = {'John', 'Matthew', 'Michael', 'David', 'James', 'Robert', 'William', 'John', 'Matthew', 'Michael', 'David', 'James', 'Robert', 'William', 'Emma', 'Olivia', 'Ava', 'Sophia', 'Isabella', 'Mia'},
    lastNames = {'Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White'},
}

Config.Actions = {
    {
        name = 'player',
        actions = {
            'search',
            'softCuff',
            'hardCuff',
            'unCuff',
            'putInVehicle',
            'drag',
            'fine',
            'jail',
            -- add custom actions like this:
            --[[ {
                title = 'Lockup',
                icon = 'fas fa-lock',
                canInteract = function()
                    if Config.ShowActionsAlways then
                        return true
                    end

                    local closestPlayer = Utils.GetClosestPlayer()
                    return closestPlayer and closestPlayer ~= -1
                end,
                onSelect = function()
                    local closestPlayer = Utils.GetClosestPlayer()
                    local targetId = GetPlayerServerId(closestPlayer)

                    local input = OpenDialog('Lock Up', {'Time'})
                    if not input or not input[1] then return end

                    local time = tonumber(input[1])
                    if not time or time <= 0 then
                        return
                    end

                    exports.tk_jail:jail(targetId, time, 'lockup')
                end
            }, ]]
        },
    },
    {
        name = 'vehicle',
        actions = {
            'takeOutFromVehicle',
            'impound',
            'checkInfo',
            'takeVest',
        },
    },
}
Config.ShowActionsAlways = true
Config.CivActions = { -- These only work if interaction type is set to 'target' or 'both'
    --[[ {
        name = 'player',
        actions = {
            'search',
            'softCuff',
            'hardCuff',
            'unCuff',
            'putInVehicle',
            'drag',
        },
    },
    {
        name = 'vehicle',
        actions = {
            'takeOutFromVehicle',
        },
    }, ]]
}

Config.Fines = {
    --[[ {
        categoryLabel = 'Traffic Offences',
        fineList = {
            {name = 'Speeding', amount = 1000},
            {name = 'Misuse of Sirens', amount = 1000},
            {name = 'Failure to Stop', amount = 1000},
            {name = 'Failure to Signal', amount = 1000},
        },
    },
    {
        categoryLabel = 'Criminal Offences',
        fineList = {
            {name = 'Possession of Drugs', amount = 1000},
        },
    }, ]]
}
Config.AllowCustomFine = true

Config.Sounds = {
    cuff = true,
    uncuff = true,
    flash = true,
}

Config.RadarSettings = {
    unit = 'mph', -- 'mph' | 'kmh'
    lockSpeed = 70,
    position = {
        x = 0.8,
        y = 0.8,
    },
    distance = 50.0,
}

Config.Tackling = {
    enable = true,
    cooldown = 5000,
    distance = 1.0,
    duration = 2000,
}

Config.Objects = {
    cone = `prop_mp_cone_02`,
    barrier = `prop_barrier_work05`,
    worklight = `prop_worklight_03b`,
    spike_strips = `p_ld_stinger_s`,
}

Config.SpeedCameras = {
    speed_camera = {
        item = 'speed_camera',
        objects = {
            {
                model = `prop_cctv_pole_04`,
                offset = vec3(0.0, 0.0, 0.0),
            }
        },
        speedLimit = 50,
        whitelistedJobs = {
            police = true,
            sheriff = true,
        },
        timecycleModifier = 'Bloom',
        distance = 20.0,
    }
}
Config.SpeedCameraFlash = true -- Enable/disable the flash effect when caught speeding

Config.TrackerUpdateInterval = 1000 -- 1 second

Config.RiotShields = {
    {
        name = 'glass_riot_shield',
        object = {
            model = `prop_riot_shield`,
            boneIndex = 45509,
            offset = vec3(0.35, 0.05, -0.1),
            rotation = vec3(300.0, 180.0, 60.0),
        }
    },
    {
        name = 'metal_riot_shield',
        object = {
            model = `prop_ballistic_shield`,
            boneIndex = 45509,
            offset = vec3(0.35, 0.05, -0.1),
            rotation = vec3(300.0, 180.0, 60.0),
        }
    }
}

Config.NVGs = {
    {
        item = 'night_vision_goggles',
        type = 'nvg',
		component = {
            male = 119,
            female = 119,
        },
        toggleInstantly = true,
    },
    {
        item = 'thermal_vision_goggles',
        type = 'thermal',
		component = {
            male = 148,
            female = 148,
        },
        toggleInstantly = true,
    },
}

Config.Blips = {
    default = {
        sprite = 1,
        scale = 0.5,
        color = 3,
        display = 4,
        category = 2,
        shortRange = true,
        cone = true,
        indicator = false
    },
    dead = {
        enable = true,
        sprite = 303,
        scale = 0.7,
        color = 1,
        display = 4,
        category = 2,
        shortRange = true,
        cone = false,
        indicator = false
    },
    car = {
        enable = true,
        sprite = 227,
        scale = 1.0,
        color = 3,
        display = 4,
        category = 2,
        shortRange = true,
        cone = false,
        indicator = false,
        sirenFlashing = true,
        flashInterval = 250
    },
    heli = {
        enable = true,
        sprite = 43,
        scale = 1.0,
        color = 3,
        display = 4,
        category = 2,
        shortRange = true,
        cone = false,
        indicator = false
    },
    boat = {
        enable = true,
        sprite = 427,
        scale = 1.0,
        color = 3,
        display = 4,
        category = 2,
        shortRange = true,
        cone = false,
        indicator = false
    }
}

Config.ImpoundLots = {
    {
        take = {
            coords = vec4(407.79, -1625.66, 29.29, 226.0),
            distance = 2.0,
            ped = `s_f_y_cop_01`,
            scenario = 'WORLD_HUMAN_COP_IDLES',
            --[[ pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                headBlend = {
                    shape_first_id = 0,
                    shape_second_id = 0,
                    shape_third_id = 0,
                    skin_first_id = 0,
                    skin_second_id = 0,
                    skin_third_id = 0,
                    shape_mix = 0.0,
                    skin_mix = 0.0,
                    third_mix = 0.0,
                    is_parent = 0,
                },
                faceFeatures = {
                    nose_width = 0.0,
                    nose_peak = 0.0,
                    nose_length = 0.0,
                    nose_bone_curveness = 0.0,
                    nose_tip = 0.0,
                    nose_bone_twist = 0.0,
                    eyebrow_up_down = 0.0,
                    eyebrow_in_out = 0.0,
                    cheek_bones_up_down = 0.0,
                    cheek_sideways_bone_size = 0.0,
                    cheek_bones_width = 0.0,
                    eye_opening = 0.0,
                    lip_thickness = 0.0,
                    jaw_bone_width = 0.0,
                    jaw_bone_shape = 0.0,
                    chin_bone_up_down = 0.0,
                    chin_bone_length = 0.0,
                    chin_bone_shape = 0.0,
                    chin_hole = 0.0,
                    neck_thickness = 0.0,
                },
                appearance = {
                    hair = {item = 0, texture = 0},
                    hair_color_1 = {item = 0},
                    hair_color_2 = {item = 0},

                    eyes = {item = 0},

                    blemishes = {item = -1},
                    blemishes_opacity = {item = 100},

                    beard = {item = -1},
                    beard_opacity = {item = 100},
                    beard_color = {item = 0},

                    eyebrows = {item = -1},
                    eyebrows_opacity = {item = 100},
                    eyebrows_color = {item = 0},

                    ageing = {item = -1},
                    ageing_opacity = {item = 100},

                    makeup = {item = -1},
                    makeup_opacity = {item = 100},
                    makeup_color_1 = {item = 0},
                    makeup_color_2 = {item = 0},

                    blush = {item = -1},
                    blush_opacity = {item = 100},
                    blush_color = {item = 0},

                    complexion = {item = -1},
                    complexion_opacity = {item = 100},

                    sun_damage = {item = -1},
                    sun_damage_opacity = {item = 100},

                    lipstick = {item = -1},
                    lipstick_opacity = {item = 100},
                    lipstick_color = {item = 0},

                    moles_freckles = {item = -1},
                    moles_freckles_opacity = {item = 100},

                    chest_hair = {item = -1},
                    chest_hair_opacity = {item = 100},
                    chest_hair_color = {item = 0},

                    body_blemishes = {item = -1},
                    body_blemishes_opacity = {item = 100},
                },
                clothing = {
                    mask = {item = 0, texture = 0},
                    arms = {item = 0, texture = 0},
                    pants = {item = 0, texture = 0},
                    bag = {item = 0, texture = 0},
                    shoes = {item = 0, texture = 0},
                    accessory = {item = 0, texture = 0},
                    t_shirt = {item = 0, texture = 0},
                    vest = {item = 0, texture = 0},
                    decals = {item = 0, texture = 0},
                    torso = {item = 0, texture = 0},

                    hat = {item = -1, texture = 0},
                    glass = {item = -1, texture = 0},
                    ear = {item = -1, texture = 0},
                    watch = {item = -1, texture = 0},
                    bracelet = {item = -1, texture = 0},
                }
            }, ]]
        },
        spawn = {
            {coords = vec4(416.87, -1627.98, 29.29, 138.5), distance = 2.0},
            {coords = vec4(419.44, -1629.58, 29.29, 138.5), distance = 2.0},
        },
        blip = {
            label = 'LSPD Impound',
            coords = vector3(407.79, -1625.66, 29.29),
            sprite = 137,
            color = 3,
            scale = 0.8,
            display = 4,
        }
    },
}

Config.PoliceStations = {
        {
        blip = {
            label = 'Police HQ',
            coords = vector3(437.93, -981.71, 30.69),
            sprite = 137,
            color = 3,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            police = 0,
            sheriff = 0,
            --flightops = 0,
        },
        shops = {
            {
                coords = vec4(457.10, -979.03, 30.69, 167.01),
                distance = 2.0,
                ped = `mp_m_freemode_01`,
                scenario = 'WORLD_HUMAN_COP_IDLES',
                pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                    appearance = {
                        mom = {item = 0},
                        dad = {item = 0},
                        face = {item = 50},
                        skin_tone = {item = 50},

                        hair = {item = 0, texture = 0},
                        hair_color_1 = {item = 0},
                        hair_color_2 = {item = 0},

                        eyes = {item = 0},

                        blemishes = {item = -1},
                        blemishes_opacity = {item = 100},

                        beard = {item = -1},
                        beard_opacity = {item = 100},
                        beard_color = {item = 0},

                        eyebrows = {item = -1},
                        eyebrows_opacity = {item = 100},
                        eyebrows_color = {item = 0},

                        ageing = {item = -1},
                        ageing_opacity = {item = 100},

                        makeup = {item = -1},
                        makeup_opacity = {item = 100},
                        makeup_color_1 = {item = 0},
                        makeup_color_2 = {item = 0},

                        blush = {item = -1},
                        blush_opacity = {item = 100},
                        blush_color = {item = 0},

                        complexion = {item = -1},
                        complexion_opacity = {item = 100},

                        sun_damage = {item = -1},
                        sun_damage_opacity = {item = 100},

                        lipstick = {item = -1},
                        lipstick_opacity = {item = 100},
                        lipstick_color = {item = 0},

                        moles_freckles = {item = -1},
                        moles_freckles_opacity = {item = 100},

                        chest_hair = {item = -1},
                        chest_hair_opacity = {item = 100},
                        chest_hair_color = {item = 0},

                        body_blemishes = {item = -1},
                        body_blemishes_opacity = {item = 100},
                    },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                },
                --[[ marker = { -- you can add marker for any location like this (so also works for storages, wardrobes, etc)
                    type = 1,
                    scale = vec3(1.0, 1.0, 1.0),
                    color = {r = 0, g = 255, b = 0, a = 100},
                    bob = false,
                    faceCamera = true,
                }, ]]
items = {
    {name = 'ammo-9', price = 0, amount = 12, grade = 4},
    {name = 'ammo-rifle', price = 0, amount = 30, grade = 4},
    {name = 'ammo-shotgun', price = 0, amount = 8, grade = 5},
    {name = 'blood_sample_kit', price = 0, amount = 1},
   -- {name = 'bodycam', price = 0, amount = 1},
    {name = 'breath_alcohol_tester', price = 0, amount = 1},
    {name = 'dash_cam', price = 0, amount = 1},
   -- {name = 'dnatest', price = 0, amount = 1},
    {name = 'fibre_swab', price = 0, amount = 1},
    {name = 'fingerprint_lift', price = 0, amount = 1},
    {name = 'fingerprint_scanner', price = 0, amount = 1},
    {name = 'gsr_swab', price = 0, amount = 1},
    {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
    {name = 'emergency_tape', price = 0, amount = 1, grade = 0},
    {name = 'radio', price = 0, amount = 1},
    {name = 'clothes_bag', price = 0, amount = 1},
    {name = 'gps', price = 0, amount = 1},
    {name = 'digital_camera', price = 0, amount = 1},
    {name = 'sd_card', price = 0, amount = 1},
    {name = 'stinger', price = 0, amount = 1, grade = 3},
    {name = 'taser_cartridge', price = 0, amount = 1, grade = 2},
    {name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
    {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
    {name = 'WEAPON_P226', price = 0, amount = 1, grade = 13},
    -- {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 13},
   -- {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 8},
    {name = 'police_drone', price = 0, amount = 1, grade = 8},
    -- {name = 'metal_riot_shield', price = 0, amount = 1, grade = 2},
    -- {name = 'glass_riot_shield', price = 0, amount = 1, grade = 2},
    -- {name = 'night_vision_goggles', price = 0, amount = 1, grade = 2},
    -- {name = 'thermal_vision_goggles', price = 0, amount = 1, grade = 2},
    -- {name = 'cone', price = 0, amount = 1},
    -- {name = 'barrier', price = 0, amount = 1},
    -- {name = 'worklight', price = 0, amount = 1},
},
            },
        },
        storages = {
            {coords = vector3(456.25, -993.33, 30.69), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
          --  {coords = vector3(2806.0933, 4710.9009, 50.0986), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            {coords = vector3(478.73, -981.91, 24.92), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
          --  {coords = vector3(2811.6104, 4753.4893, 50.2594), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
            {coords = vector3(429.56, -1007.09, 28.84), distance = 2.0, type = 'public', weight = 1000000, slots = 100}, -- Senora Maintenance Room 1
           -- {coords = vector3(2811.7148, 4752.7520, 49.9266), distance = 2.0, type = 'public', weight = 1000000, slots = 100}, -- Senora Maintenance Room 2
        },
        wardrobes = {
            {coords = vector3(449.75, -991.61, 30.69), distance = 2.0},
        },
        --[[bossmenus = {
            {coords = vector3(2788.34, 4739.92, 48.63), distance = 2.0},
        },]]
        toggleDuty = {
            {coords = vector3(454.15, -979.48, 30.69), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(2783.149, 4742.051, 48.627), distance = 2.0},
        },
        mechanics = {
            {
                coords = vector3(2812.77, 4846.35, 46.68),
                distance = 4.0,
                features = {
                    repair = true,
                    wash = true,
                    colors = {
                        primary = true,
                        secondary = true
                    },
                    extras = true,
                    liveries = true,
                    performance = {
                        engine = true,
                        brakes = true,
                        turbo = true,
                        transmission = true,
                        armor = true,
                        suspension = true
                    }
                }
            }                        
        },
        vehicleMenus = {
            --[[{ -- heli
                locations = {
                    {
                        take = {
                            {coords = vec4(2464.24, -407.29, 95.00, 50.10), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                                },
                            },
                        },
                        spawn = {
                            {coords = vec4(2454.77, -399.62, 95.00, 270.92), distance = 2.0},
                        },
                        --[[ blip = {
                            label = 'LSPD Garage',
                            coords = vec3(463.36, -985.34, 43.69),
                            sprite = 50,
                            color = 3,
                            scale = 0.8,
                        } 
                    },
                },
                returnLocations = {
                    {coords = vec3(2454.77, -399.62, 95.00), distance = 4.0},
                },
                vehicleCategories = {
                    {
                        category = 'Helicopter',
                        vehicles = {
                            {label = 'HMED', model = 'aeron', price = 0, livery = 3},
                            {label = 'NPAS', model = 'aeron', price = 0, livery = 2},
                            {label = 'SAR', model = 'aeron', price = 0, livery = 5},
                            {label = 'SPEC', model = 'aeron', price = 0, livery = 6},                            
                        },
                    },
                },
            },
--[[            { -- Boat
                locations = {
                    {
                        take = {
                            {coords = vec3(-778.6799, -1437.2778, 1.5953), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(-783.6753, -1432.3116, 0.3526, 55.4069), distance = 2.0},
                        },
                    },
                    {
                        take = {
                            {coords = vector4(-1611.393, -1126.667, 2.295, 105.36), -- BEACH BY JET SKI
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(-1642.647, -1160.948, -0.318, 143.191), distance = 2.0},
                        },
                    },
                    {
                        take = {
                            {coords = vec3(2826.5039, -670.2258, 0.4134), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(2854.2952, -667.8505, 0.5903, 282.3907), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(85.9970, -2258.3513, 5.0806), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(82.3357, -2267.1614, 0.4062, 182.6948), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(3858.5674, 4459.5347, 0.8349), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(3860.0947, 4453.5415, 0.3257, 246.5833), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(-1611.3589, 5262.6030, 2.9741), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(-1600.9111, 5261.2876, 0.6112, 27.9818), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(-1802.9984, -1231.3341, 0.6072), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                    clothing = {
                        mask = {item = 121, texture = 0},
                        arms = {item = 11, texture = 0},
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 233, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 0},
                        hat = {item = 251, texture = 0},
                        glass = {item = -1, texture = 0},
                        ear = {item = -1, texture = 0},
                        watch = {item = -1, texture = 0},
                        bracelet = {item = -1, texture = 0},
                    }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(-1798.9021, -1235.8271, 0.5562, 215.9090), distance = 2.0},
                        }
                    }
                },
                returnLocations = {
                    {coords = vec3(-783.6753, -1432.3116, 0.3526), distance = 2.0},
                    {coords = vec3(2854.2952, -667.8505, 0.5903), distance = 2.0},
                    {coords = vec3(82.3357, -2267.1614, 0.4062), distance = 2.0},
                    {coords = vec3(3860.0947, 4453.5415, 0.3257), distance = 2.0},
                    {coords = vec3(-1600.9111, 5261.2876, 0.6112), distance = 2.0},
                    {coords = vec3(-1798.9021, -1235.8271, 0.5562), distance = 2.0},
                    {coords = vector3(-1634.884, -1157.527, 0.842), distance = 10.0},
                },
                vehicleCategories = {
                    {
                        category = 'Boat',
                        vehicles = {
                            {label = 'lspppredator', model = 'Predator', price = 0},
                        },
                    },
                },
            }, ]]
           --[[{ -- Cars
                locations = {
                    {
                        take = {
                            {coords = vec4(2770.35, 4696.99, 47.37, 330.99), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
                            pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                                appearance = {
                                    mom = {item = 0},
                                    dad = {item = 0},
                                    face = {item = 50},
                                    skin_tone = {item = 50},

                                    hair = {item = 0, texture = 0},
                                    hair_color_1 = {item = 0},
                                    hair_color_2 = {item = 0},

                                    eyes = {item = 0},

                                    blemishes = {item = -1},
                                    blemishes_opacity = {item = 100},

                                    beard = {item = -1},
                                    beard_opacity = {item = 100},
                                    beard_color = {item = 0},

                                    eyebrows = {item = -1},
                                    eyebrows_opacity = {item = 100},
                                    eyebrows_color = {item = 0},

                                    ageing = {item = -1},
                                    ageing_opacity = {item = 100},

                                    makeup = {item = -1},
                                    makeup_opacity = {item = 100},
                                    makeup_color_1 = {item = 0},
                                    makeup_color_2 = {item = 0},

                                    blush = {item = -1},
                                    blush_opacity = {item = 100},
                                    blush_color = {item = 0},

                                    complexion = {item = -1},
                                    complexion_opacity = {item = 100},

                                    sun_damage = {item = -1},
                                    sun_damage_opacity = {item = 100},

                                    lipstick = {item = -1},
                                    lipstick_opacity = {item = 100},
                                    lipstick_color = {item = 0},

                                    moles_freckles = {item = -1},
                                    moles_freckles_opacity = {item = 100},

                                    chest_hair = {item = -1},
                                    chest_hair_opacity = {item = 100},
                                    chest_hair_color = {item = 0},

                                    body_blemishes = {item = -1},
                                    body_blemishes_opacity = {item = 100},
                                },
                                clothing = {
                                    mask = {item = 0, texture = 0},
                                    arms = {item = 11, texture = 0},
                                    pants = {item = 226, texture = 0},
                                    bag = {item = 0, texture = 0},
                                    shoes = {item = 25, texture = 0},
                                    accessory = {item = 0, texture = 0},
                                    t_shirt = {item = 233, texture = 0},
                                    vest = {item = 0, texture = 0},
                                    decals = {item = 0, texture = 0},
                                    torso = {item = 603, texture = 0},

                                    hat = {item = 251, texture = 0},
                                    glass = {item = -1, texture = 0},
                                    ear = {item = -1, texture = 0},
                                    watch = {item = -1, texture = 0},
                                    bracelet = {item = -1, texture = 0},
                                }
                            },
                        },
                    },
                        spawn = {
                            {coords = vec4(2773.88, 4700.47, 47.17, 281.46), distance = 2.0},
                            {coords = vec4(2773.16, 4704.29, 47.17, 285.23), distance = 2.0},
                            {coords = vec4(2772.38, 4707.88, 47.17, 284.36), distance = 2.0},
                        }
                    },
                },
                returnLocations = {
                    {coords = vec3(2762.81, 4752.34, 47.17), distance = 5.0},
                    {coords = vec3(2763.47, 4748.95, 47.17), distance = 5.0},
                    {coords = vec3(2764.33, 4745.22, 47.17), distance = 5.0},
                },
                vehicleCategories = {
                    {
                        category = 'Cars',
                        vehicles = {
                            {label = 'Response Karin', model = 'karintourm', price = 0, minGrade = 0},
                            {label = 'Response Van', model = 'impermark', price = 0, minGrade = 0},
                            {label = 'Response Off Road', model = 'sandmark', price = 0, minGrade = 0},
                            {label = 'Dog Unit', model = 'dog90cx', price = 0, minGrade = 1},
                            {label = 'Traffic Marked A4', model = 'wagmark8ft', price = 0, minGrade = 1},
                            {label = 'Traffic Marked XC90', model = 'marked90cxt', price = 0, minGrade = 1},
                            {label = 'Traffic Marked Interceptor', model = 'straferint', price = 0, minGrade = 1},
                            {label = 'ARU Marked XC90', model = 'marked90cxa', price = 0, minGrade = 1},
                            --{label = 'ARU Marked Rebla', model = 'Reblaxxpd', price = 0, minGrade = 0},
                            {label = 'ARU Marked A4', model = 'wagmark8faa', price = 0, minGrade = 1}
                        },
                        minGrade = 0,
                    },
                    {
                        category = 'Motorcycles',
                        vehicles = {
                            {label = 'Police Bike', model = 'guardmark', price = 0, minGrade = 1},
                        },
                        minGrade = 1,
                    },
                    {
                        category = 'Unmarked',
                        vehicles = {
                            {label = 'Unmarked Cruiser', model = 'police4', price = 0, minGrade = 0},
                        },
                        minGrade = 0,
                    },
                    {
                        category = 'Other',
                        vehicles = {
                            {label = 'Prison Bus', model = 'pbus', price = 0},
                            {label = 'Riot', model = 'riot', price = 0},
                        },
                        minGrade = 2,
                    },
                }
            }--]]
        },
        outfits = {
            male = {
                {
                    name = 'Student Officer',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 232,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 251,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Response - Taser',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 233,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 251,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Response - Belt/ No Taser',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 233,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 208,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 251,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Dog Handler',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 229,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 251,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'NPAS',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 610,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 234,
                        pants_2 = 0,
                        shoes_1 = 54,
                        shoes_2 = 0,
                        helmet_1 = 248,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Traffic Hivis - Taser/ No Belt',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 253,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 78,
                        bproof_2 = 0,
                        decals_1 = 282,
                        decals_2 = 282,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 61,
                        shoes_2 = 0,
                        helmet_1 = 261,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Traffic Hivis - No Taser/ No Belt',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 255,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 78,
                        bproof_2 = 0,
                        decals_1 = 282,
                        decals_2 = 282,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 61,
                        shoes_2 = 0,
                        helmet_1 = 261,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Traffic - Taser/ No Belt',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 67,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 113,
                        bag_2 = 0,
                        chain_1 = 215,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 61,
                        shoes_2 = 0,
                        helmet_1 = 261,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Traffic - Belt & Taser',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 603,
                        torso_2 = 0,
                        bproof_1 = 67,
                        bproof_2 = 0,
                        backpack1 = 113,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 113,
                        bag_2 = 0,
                        chain_1 = 208,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 61,
                        shoes_2 = 0,
                        helmet_1 = 261,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Armed Response',
                    data = {
                        mask_1 = 169,
                        mask_2 = 0,
                        arms = 11,
                        tshirt_1 = 221,
                        tshirt_2 = 0,
                        torso_1 = 601,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 209,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 61,
                        shoes_2 = 0,
                        helmet_1 = 247,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Public Order',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 17,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 619,
                        torso_2 = 0,
                        bproof_1 = 67,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 208,
                        chain_2 = 0,
                        pants_1 = 234,
                        pants_2 = 0,
                        shoes_1 = 54,
                        shoes_2 = 0,
                        helmet_1 = 260,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Bike Gear',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 1,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 617,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 235,
                        pants_2 = 0,
                        shoes_1 = 54,
                        shoes_2 = 0,
                        helmet_1 = 256,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Formal Suit',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 1,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 620,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 235,
                        pants_2 = 0,
                        shoes_1 = 10,
                        shoes_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
            },
            female = {
                {
                    name = 'PC - No Taser',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 14,
                        tshirt_1 = 14,
                        tshirt_2 = 0,
                        torso_1 = 639,
                        torso_2 = 0,
                        bproof_1 = 62,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 237,
                        pants_2 = 0,
                        shoes_1 = 64,
                        shoes_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'PC - Taser',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 14,
                        tshirt_1 = 14,
                        tshirt_2 = 0,
                        torso_1 = 639,
                        torso_2 = 0,
                        bproof_1 = 63,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 237,
                        pants_2 = 0,
                        shoes_1 = 64,
                        shoes_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Forensics',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 109,
                        tshirt_1 = 14,
                        tshirt_2 = 0,
                        torso_1 = 641,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 1,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 238,
                        pants_2 = 0,
                        shoes_1 = 168,
                        shoes_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'NPAS',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 36,
                        tshirt_1 = 14,
                        tshirt_2 = 0,
                        torso_1 = 642,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 239,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 247,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
            }
        },
    },
    {
        blip = {
            label = 'BSCO',
            coords = vector3(-437.94, 6014.0, 32.27),
            sprite = 137,
            color = 3,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            police = 0,
            sheriff = 0,
        },
        shops = {
            {
                coords = vec4(-445.91, 6014.89, 37.0, 222.0),
                distance = 2.0,
                ped = `csb_cop`,
                scenario = 'WORLD_HUMAN_COP_IDLES',
                items = {
                    {name = 'handcuffs', price = 10, amount = 1},
                    {name = 'fingerprint_scanner', price = 10, amount = 1},
                    {name = 'breathalyzer', price = 10, amount = 1},
                    {name = 'metal_riot_shield', price = 100, amount = 1, grade = 2},
                    {name = 'glass_riot_shield', price = 100, amount = 1, grade = 2},
                    {name = 'night_vision_goggles', price = 100, amount = 1, grade = 2},
                    {name = 'thermal_vision_goggles', price = 100, amount = 1, grade = 2},
                    {name = 'spike_strips', price = 100, amount = 1},
                    {name = 'cone', price = 10, amount = 1},
                    {name = 'barrier', price = 10, amount = 1},
                    {name = 'worklight', price = 10, amount = 1},
                    {name = 'bodycam', price = 100, amount = 1},
                    {name = 'dash_cam', price = 100, amount = 1},
                    {name = 'ammo-9', price = 1, amount = 12},
                    {name = 'ammo-rifle', price = 1, amount = 30, grade = 2},
                    {name = 'ammo-shotgun', price = 1, amount = 8, grade = 2},
                    {name = 'WEAPON_FLASHLIGHT', price = 100, amount = 1},
                    {name = 'WEAPON_NIGHTSTICK', price = 250, amount = 1},
                    {name = 'WEAPON_STUNGUN', price = 250, amount = 1},
                    {name = 'WEAPON_COMBATPISTOL', price = 500, amount = 1},
                    {name = 'WEAPON_PUMPSHOTGUN', price = 1000, amount = 1, grade = 2},
                    {name = 'WEAPON_CARBINERIFLE', price = 1000, amount = 1, grade = 2},
                },
            },
        },
        storages = {
            {coords = vec3(-445.86, 6018.68, 37.0), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vec3(-449.44, 6015.1, 37.0), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vec3(-439.7, 6011.07, 37.0), distance = 2.0},
        },
        bossmenus = {
            --{coords = vec3(-432.81, 6005.86, 37.0), distance = 2.0},
        },
        toggleDuty = {
            --{coords = vec3(-446.91, 6013.6, 33.44), distance = 2.0},
        },
        bodycamStation = {
            {coords = vec3(-441.08, 5999.66, 36.92), distance = 2.0},
        },
        mechanics = {
            {
                coords = vec3(-465.38, 6031.75, 31.34),
                distance = 4.0,
                features = {
                    repair = true,
                    wash = true,
                    colors = {
                        primary = true,
                        secondary = true
                    },
                    extras = true,
                    liveries = true,
                    performance = {
                        engine = true,
                        brakes = true,
                        turbo = true,
                        transmission = true,
                        armor = true,
                        suspension = true
                    }
                }
            }
        },
        vehicleMenus = {
            {
                locations = {
                    {
                        take = {
                            {coords = vec4(-462.86, 6025.95, 31.45, 133.0), distance = 2.0, ped = `csb_cop`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(-468.88, 6038.4, 31.34, 225.0), distance = 2.0},
                            {coords = vec4(-472.25, 6035.17, 31.34, 270.0), distance = 2.0},
                            {coords = vec4(-475.81, 6031.4, 31.34, 270.0), distance = 2.0},
                            {coords = vec4(-479.37, 6027.67, 31.34, 270.0), distance = 2.0},
                            {coords = vec4(-482.93, 6023.94, 31.34, 270.0), distance = 2.0},
                        }
                    },
                },
                returnLocations = {
                    {coords = vec3(-474.99, 6022.45, 31.34), distance = 5.0},
                },
                vehicleCategories = {
                    {
                        category = 'Cars',
                        vehicles = {
                            {label = 'Cruiser', model = 'sheriff', price = 0},
                            {label = 'Granger', model = 'sheriff2', price = 0}
                        },
                        minGrade = 0,
                    },
                    {
                        category = 'Unmarked',
                        vehicles = {
                            {label = 'Unmarked Cruiser', model = 'police4', price = 0},
                            {label = 'Unmarked Buffalo', model = 'fbi', price = 0},
                            {label = 'Unmarked Granger', model = 'fbi2', price = 0},
                        },
                        minGrade = 2,
                    },
                    {
                        category = 'Other',
                        vehicles = {
                            {label = 'Prison Bus', model = 'pbus', price = 0},
                            {label = 'Riot', model = 'riot', price = 0},
                        },
                        minGrade = 2,
                    },
                }
            }
        },
        outfits = {
            male = {
                {
                    name = 'Patrol',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 26,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        torso_1 = 318,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 130,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 46,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Patrol (Vest & Helmet)',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 26,
                        tshirt_1 = 58,
                        tshirt_2 = 0,
                        torso_1 = 318,
                        torso_2 = 0,
                        bproof_1 = 7,
                        bproof_2 = 1,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 130,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 150,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
            },
            female = {
                {
                    name = 'Patrol',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 28,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        torso_1 = 329,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 136,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 45,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Patrol (Vest & Helmet)',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 28,
                        tshirt_1 = 35,
                        tshirt_2 = 0,
                        torso_1 = 329,
                        torso_2 = 0,
                        bproof_1 = 7,
                        bproof_2 = 1,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 136,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 149,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
            }
        },
    },
}
Config.EnableOwnedVehicles = true

Config.VehicleCamOffset = {
    default = vec3(0.0, 0.0, 0.0), -- Default
    -- you can add specific offset for models like this:
    -- [`police`] = vec3(0.0, 0.0, 0.1),
}

Config.VehicleCamRotation = {
    default = vec3(0.0, 0.0, 0.0), -- Default
    -- you can add specific rotation for models like this:
    -- [`police`] = vec3(0.0, 0.0, 0.0),
}