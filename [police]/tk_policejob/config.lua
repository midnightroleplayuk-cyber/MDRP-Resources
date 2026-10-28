Config = {} -- You can place webhook link for logs in server/main_editable.lua

Config.Framework = 'qb' -- 'esx' | 'qb'
Config.NotificationType = 'ox' -- 'esx' | 'qb' | 'ox' | 'mythic'
Config.Locale = 'en' -- 'en' | 'fi'
Config.ImagePath = 'nui://ox_inventory/web/images' -- path for images used in UI (for QB: nui://qb-inventory/html/images) (for ox_inventory: nui://ox_inventory/web/images)
Config.DebugMode = false -- false | true

Config.Inventory = 'ox' -- 'default' | 'ox' | 'qs' | 'qb_old' | 'qb_new'
Config.Target = 'ox' -- 'none' | 'ox' | 'qb'
Config.Clothing = 'op' -- 'illenium' | 'qb' | 'op'
Config.Bossmenu = 'qb' -- 'tk' | 'esx' | 'qb'
Config.Jail = 'tk' -- 'tk'
Config.Billing = 'qb' -- 'esx' | 'qb' | 'okok'
Config.UseOxLib = true -- false | true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true

Config.InteractionType = 'target' --  'menu' | 'target' | 'both'
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
        toggle = 'F7',
        moveMode = 'F9',
        lockFront = 'NUMPAD8',
        lockBack = 'NUMPAD2',
        focus = '0',
        frontLane = 'NUMPAD4',
        backLane = 'NUMPAD6',
    },
    policeMenu = 'F6',
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
            dict = 'mdxfc@animatiou',
            name = 'mdxfc_clip',
            flag = 49,
        },
        back = {
            dict = 'mdx@rearstack_anim',
            name = 'mdxrc_clip',
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
   -- breathalyzer = 'breathalyzer',
    bodycam = 'bodycam',
    dashCam = 'dash_cam',
    lockpick = 'lockpick',
}
Config.HandcuffsOnlyForPolice = true
Config.GiveKeyOnCuff = false -- false | true, should you get they handcuffs key item when cuffing someone
Config.RequireFaceTargetWhenCuffing = true -- false | true, should you need to face target when cuffing/uncuffing
Config.CuffControlsToDisable = {
    soft = {140, 69, 92, 114, 56, 21, 24, 25, 263, 45, 22, 44, 37, 23, 288, 289, 170, 167, 0, 26, 73, 199, 59, 71, 72, 36, 47, 264, 257, 141, 142, 143, 75, 80, 250, 310},
    hard = {30, 31, 32, 33, 34, 35},
}

Config.Actions = {
    {
        name = 'player',
        actions = {
            'search',
            --'softCuff',
            --'hardCuff',
            --'unCuff',
            'putInVehicle',
            'drag',
            --'fine',
            --'jail',
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
            --'impound',
            --'checkInfo',
            --'takeVest',
        },
    },
}
Config.ShowActionsAlways = true
Config.CivActions = { -- These only work if interaction type is set to 'target' or 'both'
    {
        name = 'player',
        actions = {
            --'search',
            --'softCuff',
            --'hardCuff',
            --'unCuff',
            'putInVehicle',
            'drag',
        },
    },
    {
        name = 'vehicle',
        actions = {
            'takeOutFromVehicle',
        },
    }, 
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
Config.SpeedCameraFlash = false -- Enable/disable the flash effect when caught speeding

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
		component = 119,
    },
    {
        item = 'thermal_vision_goggles',
        type = 'thermal',
		component = 148,
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
    --[[{
        take = {coords = vec4(407.79, -1625.66, 29.29, 226.0), 
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
        spawn = {
            {coords = vec4(416.87, -1627.98, 29.29, 138.5), distance = 2.0},
            {coords = vec4(419.44, -1629.58, 29.29, 138.5), distance = 2.0},
        },
        blip = {
            label = 'PD Impound',
            coords = vector3(407.79, -1625.66, 29.29),
            sprite = 56,
            color = 17,
            scale = 0.8,
            display = 4,
        }
    },--]]
}

Config.PoliceStations = {
    {
        blip = {
            label = 'Vinewood Station',
            coords = vector3(417.21, -335.11, 45.94),
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
                coords = vec4(396.92, -311.0, 47.00, 157.02),
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
                        arms = {item = 1, texture = 0},
                        pants = {item = 242, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 225, texture = 0},
                        t_shirt = {item = 238, texture = 0},
                        vest = {item = 80, texture = 14},
                        decals = {item = 0, texture = 0},
                        torso = {item = 625, texture = 0},
                        hat = {item = 244, texture = 0},
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
   -- {name = 'ammo-shotgun', price = 0, amount = 8, grade = 5},
    {name = 'blood_sample_kit', price = 0, amount = 1},
    {name = 'bodycam', price = 0, amount = 1},
    {name = 'breathalyzer', price = 0, amount = 1},
    {name = 'breathalyzer_mouthpiece', price = 0, amount = 10},
    {name = 'dash_cam', price = 0, amount = 1},
    {name = 'dnatest', price = 0, amount = 1},
    {name = 'fibre_swab', price = 0, amount = 1},
    {name = 'fingerprint_lift', price = 0, amount = 1},
    {name = 'fingerprint_scanner', price = 0, amount = 1},
    {name = 'gsr_swab', price = 0, amount = 1},
    {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
    {name = 'police_tape', price = 0, amount = 1, grade = 0},
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
            -- SECOND VINEWOOD SHOP: change these coords to your preferred location.
            {
                coords = vec4(372.21, -341.11, 51.14, 64.59), -- ARMED ARMORY
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
                        mask = {item = 263, texture = 0},
                        arms = {item = 0, texture = 0},
                        pants = {item = 232, texture = 0},
                        bag = {item = 122, texture = 0},
                        shoes = {item = 61, texture = 0},
                        accessory = {item = -1, texture = 0},
                        t_shirt = {item = 228, texture = 0},
                        vest = {item = 78, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 605, texture = 1},
                        hat = {item = 249, texture = 0},
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
    --{name = 'ammo-9', price = 0, amount = 12, grade = 4},
    --{name = 'ammo-rifle', price = 0, amount = 30, grade = 4},
   -- {name = 'ammo-shotgun', price = 0, amount = 8, grade = 5},
    {name = 'blood_sample_kit', price = 0, amount = 1},
    {name = 'bodycam', price = 0, amount = 1},
    {name = 'breathalyzer', price = 0, amount = 1},
    {name = 'breathalyzer_mouthpiece', price = 0, amount = 10},
    {name = 'dash_cam', price = 0, amount = 1},
    {name = 'dnatest', price = 0, amount = 1},
    {name = 'fibre_swab', price = 0, amount = 1},
    {name = 'fingerprint_lift', price = 0, amount = 1},
    {name = 'fingerprint_scanner', price = 0, amount = 1},
    {name = 'gsr_swab', price = 0, amount = 1},
    {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
    {name = 'police_tape', price = 0, amount = 1, grade = 0},
    {name = 'radio', price = 0, amount = 1},
    {name = 'clothes_bag', price = 0, amount = 1},
    {name = 'gps', price = 0, amount = 1},
    {name = 'digital_camera', price = 0, amount = 1},
    {name = 'sd_card', price = 0, amount = 1},
    {name = 'stinger', price = 0, amount = 1, grade = 3},
    --{name = 'taser_cartridge', price = 0, amount = 1, grade = 2},
    --{name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 13},
    --{name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
    {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
    --{name = 'WEAPON_P226', price = 0, amount = 1, grade = 13},
    -- {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 13},
    --{name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 13},
    --{name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 13},
   -- {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 8},
    --{name = 'police_drone', price = 0, amount = 1, grade = 8},
    -- {name = 'metal_riot_shield', price = 0, amount = 1, grade = 2},
    -- {name = 'glass_riot_shield', price = 0, amount = 1, grade = 2},
    -- {name = 'night_vision_goggles', price = 0, amount = 1, grade = 2},
    -- {name = 'thermal_vision_goggles', price = 0, amount = 1, grade = 2},
    -- {name = 'cone', price = 0, amount = 1},
    -- {name = 'barrier', price = 0, amount = 1},
    -- {name = 'worklight', price = 0, amount = 1},
    {name = 'at_flashlight', price = 0, amount = 1},
    {name = 'at_muzzle_slanted', price = 0, amount = 1},
    {name = 'at_scope_medium', price = 0, amount = 1},
    {name = 'at_grip', price = 0, amount = 1},
},
            },
        },

        storages = {
            {coords = vector3(423.2, -326.34, 51.08), distance = 2.0, type = 'personal', weight = 1000000, slots = 100}, --FEMALE VINEWOOD
            {coords = vector3(414.85, -318.22, 51.04), distance = 2.0, type = 'personal', weight = 1000000, slots = 100}, --MALE VINEWOOD
        },
       -- wardrobes = {
          --  {coords = vector3(411.29, -323.38, 51.14), distance = 2.0}, --FEMALE VINEWOOD
          --  {coords = vector3(419.11, -326.33, 51.3), distance = 2.0}, -- MALE VINEWOOD

       -- },
        --[[bossmenus = {
            {coords = vector3(2788.34, 4739.92, 48.63), distance = 2.0},
        },]]
        toggleDuty = {
            {coords = vector3(411.89, -327.67, 47.33), distance = 2.0},
        },
      --  bodycamStation = {
      --       {coords = vector3(2783.149, 4742.051, 48.627), distance = 2.0},
      --  },
       --[[  mechanics = {
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
        }, ]]
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
--     {
--         blip = {
--             label = 'Custody Suite',
--             coords = vector3(517.094, 7.519, 70.629),
--             sprite = 137,
--             color = 3,
--             scale = 0.8,
--             display = 4,
--             shortRange = true,
--         },
--         jobs = {
--             police = 0,
--             sheriff = 0,
--         },
--         shops = {
--             {
--                 coords = vector4(543.0, 9.42, 70.629, 184.559), -- Custody
--                 distance = 2.0,
--                 ped = `mp_m_freemode_01`,
--                 scenario = 'WORLD_HUMAN_COP_IDLES',
--                 pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
--                     appearance = {
--                         mom = {item = 0},
--                         dad = {item = 0},
--                         face = {item = 50},
--                         skin_tone = {item = 50},

--                         hair = {item = 0, texture = 0},
--                         hair_color_1 = {item = 0},
--                         hair_color_2 = {item = 0},

--                         eyes = {item = 0},

--                         blemishes = {item = -1},
--                         blemishes_opacity = {item = 100},

--                         beard = {item = -1},
--                         beard_opacity = {item = 100},
--                         beard_color = {item = 0},

--                         eyebrows = {item = -1},
--                         eyebrows_opacity = {item = 100},
--                         eyebrows_color = {item = 0},

--                         ageing = {item = -1},
--                         ageing_opacity = {item = 100},

--                         makeup = {item = -1},
--                         makeup_opacity = {item = 100},
--                         makeup_color_1 = {item = 0},
--                         makeup_color_2 = {item = 0},

--                         blush = {item = -1},
--                         blush_opacity = {item = 100},
--                         blush_color = {item = 0},

--                         complexion = {item = -1},
--                         complexion_opacity = {item = 100},

--                         sun_damage = {item = -1},
--                         sun_damage_opacity = {item = 100},

--                         lipstick = {item = -1},
--                         lipstick_opacity = {item = 100},
--                         lipstick_color = {item = 0},

--                         moles_freckles = {item = -1},
--                         moles_freckles_opacity = {item = 100},

--                         chest_hair = {item = -1},
--                         chest_hair_opacity = {item = 100},
--                         chest_hair_color = {item = 0},

--                         body_blemishes = {item = -1},
--                         body_blemishes_opacity = {item = 100},
--                     },
--                     clothing = {
--                         mask = {item = 121, texture = 0},
--                         arms = {item = 11, texture = 0},
--                         pants = {item = 226, texture = 0},
--                         bag = {item = 0, texture = 0},
--                         shoes = {item = 25, texture = 0},
--                         accessory = {item = 0, texture = 0},
--                         t_shirt = {item = 233, texture = 0},
--                         vest = {item = 0, texture = 0},
--                         decals = {item = 0, texture = 0},
--                         torso = {item = 605, texture = 0},
--                         hat = {item = 251, texture = 0},
--                         glass = {item = -1, texture = 0},
--                         ear = {item = -1, texture = 0},
--                         watch = {item = -1, texture = 0},
--                         bracelet = {item = -1, texture = 0},
--                     }
--                 },
--                 --[[ marker = { -- you can add marker for any location like this (so also works for storages, wardrobes, etc)
--                     type = 1,
--                     scale = vec3(1.0, 1.0, 1.0),
--                     color = {r = 0, g = 255, b = 0, a = 100},
--                     bob = false,
--                     faceCamera = true,
--                 }, ]]
-- items = {
--  --  {name = 'ammo-9', price = 0, amount = 12, grade = 8},
--  --   {name = 'ammo-rifle', price = 0, amount = 30, grade = 8},
--   --  {name = 'ammo-shotgun', price = 0, amount = 8, grade = 8},
--     {name = 'blood_sample_kit', price = 0, amount = 1},
--    -- {name = 'bodycam', price = 0, amount = 1},
--  --   {name = 'breathalyzer', price = 0, amount = 1},
--  --   {name = 'dash_cam', price = 0, amount = 1},
--    -- {name = 'dnatest', price = 0, amount = 1},
--     {name = 'fibre_swab', price = 0, amount = 1},
--     {name = 'fingerprint_lift', price = 0, amount = 1},
-- -- {name = 'fingerprint_scanner', price = 0, amount = 1},
--     {name = 'gsr_swab', price = 0, amount = 1},
--     {name = 'police_tape', price = 0, amount = 1, grade = 0},
--     {name = 'digital_camera', price = 0, amount = 1},
--     {name = 'sd_card', price = 0, amount = 1},
--  --   {name = 'handcuffs', price = 0, amount = 1},
--   --  {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
--   --  {name = 'radio', price = 0, amount = 1},
--  --   {name = 'stinger', price = 0, amount = 1, grade = 1},
--  --   {name = 'taser_cartridge', price = 0, amount = 1, grade = 1},
--  --   {name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 8},
--  --   {name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 8},
--     {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
--  --   {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
--  --   {name = 'WEAPON_P226', price = 0, amount = 1, grade = 8},
--  --   {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 8},
--  --   {name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 8},
--   --  {name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 8},
--  --   {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 1},
--     -- {name = 'metal_riot_shield', price = 0, amount = 1, grade = 2},
--     -- {name = 'glass_riot_shield', price = 0, amount = 1, grade = 2},
--     -- {name = 'night_vision_goggles', price = 0, amount = 1, grade = 2},
--     -- {name = 'thermal_vision_goggles', price = 0, amount = 1, grade = 2},
--     -- {name = 'cone', price = 0, amount = 1},
--     -- {name = 'barrier', price = 0, amount = 1},
--     -- {name = 'worklight', price = 0, amount = 1},
--- },
--             },
--         },
--         storages = {
--             {coords = vector3(509.544, 18.155, 70.882), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
--             {coords = vector3(508.016, 17.211, 70.882), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
--             {coords = vector3(516.0822, 23.1046, 71.9002), distance = 2.0, type = 'locker', weight = 1000000, slots = 100} -- Storage for Vinewood NON EVIDENCE
--             --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
--         },
--         wardrobes = {
--             {coords = vector3(513.187, 20.238, 70.882), distance = 2.0},
--             {coords = vector3(511.836, 19.378, 70.882), distance = 2.0},
--         },
--         bossmenus = {
--             {coords = vector3(516.663, 20.31, 70.882), distance = 2.0},
--         },
--         toggleDuty = {
--             {coords = vector3(523.665, 21.285, 70.882), distance = 2.0},
--         },
--         bodycamStation = {
--             {coords = vector3(509.599, 15.172, 70.882), distance = 2.0},
--         },
--         --[[mechanics = {
--             {
--                 coords = vector3(2812.77, 4846.35, 46.68),
--                 distance = 4.0,
--                 features = {
--                     repair = true,
--                     wash = true,
--                     colors = {
--                         primary = true,
--                         secondary = true
--                     },
--                     extras = true,
--                     liveries = true,
--                     performance = {
--                         engine = true,
--                         brakes = true,
--                         turbo = true,
--                         transmission = true,
--                         armor = true,
--                         suspension = true
--                     }
--                 }
--             }
--         },--]]
--         vehicleMenus = {
--             --[[{ -- Cars
--                 locations = {
--                     {
--                         take = {
--                             {coords = vec4(544.517, 1.688, 70.629, 116.76), 
--                             distance = 2.0, 
--                             ped = `mp_m_freemode_01`,
--                             scenario = 'WORLD_HUMAN_COP_IDLES',
--                             pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
--                                 appearance = {
--                                     mom = {item = 0},
--                                     dad = {item = 0},
--                                     face = {item = 50},
--                                     skin_tone = {item = 50},

--                                     hair = {item = 0, texture = 0},
--                                     hair_color_1 = {item = 0},
--                                     hair_color_2 = {item = 0},

--                                     eyes = {item = 0},

--                                     blemishes = {item = -1},
--                                     blemishes_opacity = {item = 100},

--                                     beard = {item = -1},
--                                     beard_opacity = {item = 100},
--                                     beard_color = {item = 0},

--                                     eyebrows = {item = -1},
--                                     eyebrows_opacity = {item = 100},
--                                     eyebrows_color = {item = 0},

--                                     ageing = {item = -1},
--                                     ageing_opacity = {item = 100},

--                                     makeup = {item = -1},
--                                     makeup_opacity = {item = 100},
--                                     makeup_color_1 = {item = 0},
--                                     makeup_color_2 = {item = 0},

--                                     blush = {item = -1},
--                                     blush_opacity = {item = 100},
--                                     blush_color = {item = 0},

--                                     complexion = {item = -1},
--                                     complexion_opacity = {item = 100},

--                                     sun_damage = {item = -1},
--                                     sun_damage_opacity = {item = 100},

--                                     lipstick = {item = -1},
--                                     lipstick_opacity = {item = 100},
--                                     lipstick_color = {item = 0},

--                                     moles_freckles = {item = -1},
--                                     moles_freckles_opacity = {item = 100},

--                                     chest_hair = {item = -1},
--                                     chest_hair_opacity = {item = 100},
--                                     chest_hair_color = {item = 0},

--                                     body_blemishes = {item = -1},
--                                     body_blemishes_opacity = {item = 100},
--                                 },
--                                 clothing = {
--                                     mask = {item = 0, texture = 0},
--                                     arms = {item = 11, texture = 0},
--                                     pants = {item = 226, texture = 0},
--                                     bag = {item = 0, texture = 0},
--                                     shoes = {item = 25, texture = 0},
--                                     accessory = {item = 0, texture = 0},
--                                     t_shirt = {item = 233, texture = 0},
--                                     vest = {item = 0, texture = 0},
--                                     decals = {item = 0, texture = 0},
--                                     torso = {item = 603, texture = 0},

--                                     hat = {item = 251, texture = 0},
--                                     glass = {item = -1, texture = 0},
--                                     ear = {item = -1, texture = 0},
--                                     watch = {item = -1, texture = 0},
--                                     bracelet = {item = -1, texture = 0},
--                                 }
--                             },
--                         },
--                     },
--                         spawn = {
--                             {coords = vector4(543.466, -3.655, 70.629, 121.011), distance = 2.0}, 
--                             {coords = vector4(545.228, -6.659, 70.629, 120.618), distance = 2.0}, 
--                             {coords = vector4(546.858, -10.005, 70.629, 117.961), distance = 2.0},
--                             {coords = vector4(536.065, -4.624, 70.629, 211.192), distance = 2.0},
--                             {coords = vector4(532.516, -6.954, 70.629, 209.848), distance = 2.0},
--                             {coords = vector4(528.945, -8.872, 70.629, 211.208), distance = 2.0},
--                         }
--                     },
--                 },
--                 returnLocations = {
--                     {coords = vector3(525.79, -12.422, 70.629), distance = 5.0},
--                     {coords = vector3(521.871, -14.933, 70.629), distance = 5.0},
--                 },
--                 vehicleCategories = {
--                     {
--                         category = 'Cars',
--                         vehicles = {
--                             {label = 'Response Karin', model = 'karintourm', price = 0, minGrade = 0},
--                             {label = 'Response Van', model = 'impermark', price = 0, minGrade = 0},
--                             {label = 'Response Off Road', model = 'sandmark', price = 0, minGrade = 0},
--                             {label = 'Dog Unit', model = 'dog90cx', price = 0, minGrade = 1},
--                             {label = 'Traffic Marked A4', model = 'wagmark8ft', price = 0, minGrade = 1},
--                             {label = 'Traffic Marked XC90', model = 'marked90cxt', price = 0, minGrade = 1},
--                             {label = 'Traffic Marked Interceptor', model = 'straferint', price = 0, minGrade = 1},
--                             {label = 'ARU Marked XC90', model = 'marked90cxa', price = 0, minGrade = 1},
--                            -- {label = 'ARU Marked Rebla', model = 'Reblaxxpd', price = 0, minGrade = 0},
--                             {label = 'ARU Marked A4', model = 'wagmark8fa', price = 0, minGrade = 1}
--                         },
--                         minGrade = 0,
--                     },
--                     {
--                         category = 'Motorcycles',
--                         vehicles = {
--                             {label = 'Police Bike', model = 'guardmark', price = 0, minGrade = 1},
--                         },
--                         minGrade = 1,
--                     },
--                     {
--                         category = 'Unmarked',
--                         vehicles = {
--                             {label = 'Unmarked Cruiser', model = 'police4', price = 0, minGrade = 0},
--                         },
--                         minGrade = 0,
--                     },
--                     {
--                         category = 'Other',
--                         vehicles = {
--                             {label = 'Prison Bus', model = 'pbus', price = 0},
--                             {label = 'Riot', model = 'riot', price = 0},
--                         },
--                         minGrade = 2,
--                     },
--                 }
--             }--]]
--         },
--         outfits = {
--             male = {
--                 {
--                     name = 'Student Officer',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 232,
--                         tshirt_2 = 0,
--                         torso_1 = 603,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 0,
--                         bag_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 25,
--                         shoes_2 = 0,
--                         helmet_1 = 251,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Response - Taser',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 233,
--                         tshirt_2 = 0,
--                         torso_1 = 603,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 0,
--                         bag_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 25,
--                         shoes_2 = 0,
--                         helmet_1 = 251,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Response - Belt/ No Taser',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 233,
--                         tshirt_2 = 0,
--                         torso_1 = 603,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 0,
--                         bag_2 = 0,
--                         chain_1 = 208,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 25,
--                         shoes_2 = 0,
--                         helmet_1 = 251,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Dog Handler',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 229,
--                         tshirt_2 = 0,
--                         torso_1 = 603,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 0,
--                         bag_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 25,
--                         shoes_2 = 0,
--                         helmet_1 = 251,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'NPAS',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 15,
--                         tshirt_2 = 0,
--                         torso_1 = 610,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 0,
--                         bag_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 234,
--                         pants_2 = 0,
--                         shoes_1 = 54,
--                         shoes_2 = 0,
--                         helmet_1 = 248,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Traffic - Taser/ No Belt',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 15,
--                         tshirt_2 = 0,
--                         torso_1 = 603,
--                         torso_2 = 0,
--                         bproof_1 = 67,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 113,
--                         bag_2 = 0,
--                         chain_1 = 215,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 61,
--                         shoes_2 = 0,
--                         helmet_1 = 261,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Traffic - Belt & Taser',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 15,
--                         tshirt_2 = 0,
--                         torso_1 = 603,
--                         torso_2 = 0,
--                         bproof_1 = 67,
--                         bproof_2 = 0,
--                         backpack1 = 113,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         bag_1 = 113,
--                         bag_2 = 0,
--                         chain_1 = 208,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 61,
--                         shoes_2 = 0,
--                         helmet_1 = 261,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Armed Response',
--                     data = {
--                         mask_1 = 169,
--                         mask_2 = 0,
--                         arms = 11,
--                         tshirt_1 = 221,
--                         tshirt_2 = 0,
--                         torso_1 = 601,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 209,
--                         chain_2 = 0,
--                         pants_1 = 226,
--                         pants_2 = 0,
--                         shoes_1 = 61,
--                         shoes_2 = 0,
--                         helmet_1 = 247,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Public Order',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 17,
--                         tshirt_1 = 15,
--                         tshirt_2 = 0,
--                         torso_1 = 619,
--                         torso_2 = 0,
--                         bproof_1 = 67,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 208,
--                         chain_2 = 0,
--                         pants_1 = 234,
--                         pants_2 = 0,
--                         shoes_1 = 54,
--                         shoes_2 = 0,
--                         helmet_1 = 260,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Bike Gear',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 1,
--                         tshirt_1 = 15,
--                         tshirt_2 = 0,
--                         torso_1 = 617,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 235,
--                         pants_2 = 0,
--                         shoes_1 = 54,
--                         shoes_2 = 0,
--                         helmet_1 = 256,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Formal Suit',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 1,
--                         tshirt_1 = 15,
--                         tshirt_2 = 0,
--                         torso_1 = 620,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 235,
--                         pants_2 = 0,
--                         shoes_1 = 10,
--                         shoes_2 = 0,
--                         helmet_1 = -1,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--             },
--             female = {
--                 {
--                     name = 'PC - No Taser',
--                     data = {
--                         mask_1 = 121,
--                         mask_2 = 0,
--                         arms = 14,
--                         tshirt_1 = 14,
--                         tshirt_2 = 0,
--                         torso_1 = 639,
--                         torso_2 = 0,
--                         bproof_1 = 62,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 237,
--                         pants_2 = 0,
--                         shoes_1 = 64,
--                         shoes_2 = 0,
--                         helmet_1 = -1,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'PC - Taser',
--                     data = {
--                         mask_1 = 121,
--                         mask_2 = 0,
--                         arms = 14,
--                         tshirt_1 = 14,
--                         tshirt_2 = 0,
--                         torso_1 = 639,
--                         torso_2 = 0,
--                         bproof_1 = 63,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 237,
--                         pants_2 = 0,
--                         shoes_1 = 64,
--                         shoes_2 = 0,
--                         helmet_1 = -1,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'Forensics',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 109,
--                         tshirt_1 = 14,
--                         tshirt_2 = 0,
--                         torso_1 = 641,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 1,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 238,
--                         pants_2 = 0,
--                         shoes_1 = 168,
--                         shoes_2 = 0,
--                         helmet_1 = 0,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--                 {
--                     name = 'NPAS',
--                     data = {
--                         mask_1 = 0,
--                         mask_2 = 0,
--                         arms = 36,
--                         tshirt_1 = 14,
--                         tshirt_2 = 0,
--                         torso_1 = 642,
--                         torso_2 = 0,
--                         bproof_1 = 0,
--                         bproof_2 = 0,
--                         decals_1 = 0,
--                         decals_2 = 0,
--                         chain_1 = 0,
--                         chain_2 = 0,
--                         pants_1 = 239,
--                         pants_2 = 0,
--                         shoes_1 = 25,
--                         shoes_2 = 0,
--                         helmet_1 = 247,
--                         helmet_2 = 0,
--                         glasses_1 = 0,
--                         glasses_2 = 0,
--                     }
--                 },
--             }
--         },
--     },
    {
        blip = {
            label = 'Paleto PD',
            coords = vector3(-451.442, 6017.252, 31.568),
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
                coords = vector4(-440.759, 5996.368, 31.568, 311.595), -- Paleto
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
    {name = 'ammo-9', price = 0, amount = 12, grade = 5},
    {name = 'ammo-rifle', price = 0, amount = 30, grade = 5},
    {name = 'ammo-shotgun', price = 0, amount = 8, grade = 5},
    {name = 'blood_sample_kit', price = 0, amount = 1},
    {name = 'bodycam', price = 0, amount = 1},
    {name = 'breathalyzer', price = 0, amount = 1},
    {name = 'breathalyzer_mouthpiece', price = 0, amount = 10},
    {name = 'dash_cam', price = 0, amount = 1},
   -- {name = 'dnatest', price = 0, amount = 1},
    {name = 'fibre_swab', price = 0, amount = 1},
    {name = 'fingerprint_lift', price = 0, amount = 1},
-- {name = 'fingerprint_scanner', price = 0, amount = 1},
    {name = 'gsr_swab', price = 0, amount = 1},
    {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
    {name = 'police_tape', price = 0, amount = 1, grade = 0},
    {name = 'radio', price = 0, amount = 1},
    {name = 'gps', price = 0, amount = 1},
    {name = 'digital_camera', price = 0, amount = 1},
    {name = 'sd_card', price = 0, amount = 1},
    {name = 'stinger', price = 0, amount = 1, grade = 3},
    {name = 'taser_cartridge', price = 0, amount = 1, grade = 8},
    {name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
    {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
    {name = 'WEAPON_P226', price = 0, amount = 1, grade = 13},
    -- {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 8},
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
            {coords = vector3(-444.988, 6005.018, 31.568), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(-432.626, 5991.863, 31.569), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(-428.735, 5991.91, 31.569), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(-430.717, 5989.751, 31.569), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(-446.56, 6003.388, 31.568), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(-442.268, 6002.108, 31.568), distance = 2.0},
            {coords = vector3(-443.311, 6003.271, 31.568), distance = 2.0},
            {coords = vector3(-443.394, 6000.959, 31.568), distance = 2.0},
            {coords = vector3(-444.541, 6002.171, 31.568), distance = 2.0},
            {coords = vector3(-443.049, 6006.442, 31.568), distance = 2.0},
            {coords = vector3(-441.731, 6004.971, 31.568), distance = 2.0},
            {coords = vector3(-440.33, 6003.702, 31.568), distance = 2.0},
        },
        bossmenus = {
            {coords = vector3(-437.138, 6011.943, 31.568), distance = 2.0},
        },
        toggleDuty = {
            {coords = vector3(-449.19, 6020.007, 31.568), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(-437.437, 6007.929, 31.568), distance = 2.0},
        },
        vehicleMenus = {
                --[[{ -- Cars
                locations = {
                    {
                        take = {
                            {coords = vector4(-445.49, 5999.864, 31.49, 131.416), 
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
                            {coords = vector4(-448.509, 5994.626, 31.341, 90.419), distance = 2.0}, 
                            {coords = vector4(-452.188, 5998.399, 31.341, 95.338), distance = 2.0}, 
                            {coords = vector4(-455.302, 6001.911, 31.341, 89.161), distance = 2.0},
                            {coords = vector4(-458.892, 6005.738, 31.341, 84.893), distance = 2.0},
                            {coords = vector4(-462.491, 6009.756, 31.341, 87.318), distance = 2.0},
                        }
                    },
                },
                returnLocations = {
                    {coords = vector3(-481.489, 6024.782, 31.341), distance = 5.0},
                    {coords = vector3(-478.319, 6027.629, 31.341), distance = 5.0},
                    {coords = vector3(-475.471, 6030.903, 31.341), distance = 5.0},
                    {coords = vector3(-472.181, 6034.601, 31.341), distance = 5.0},
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
                           -- {label = 'ARU Marked Rebla', model = 'Reblaxxpd', price = 0, minGrade = 0},
                            {label = 'ARU Marked A4', model = 'wagmark8fa', price = 0, minGrade = 1}
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
            label = 'N.E.S.T',
            coords = vector3(2534.533, -312.516, 93.112),
            sprite = 137,
            color = 3,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            police = 0,
            sheriff = 0,
            flightops = 0,
        },
        shops = {
            {
                coords = vector4(2544.6750, -282.8622, 93.1122, 182.9790), -- HQ
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
    {name = 'ammo-9', price = 0, amount = 12, grade = 5},
    {name = 'ammo-rifle', price = 0, amount = 30, grade = 5},
    {name = 'ammo-shotgun', price = 0, amount = 8, grade = 5},
    {name = 'blood_sample_kit', price = 0, amount = 1},
    {name = 'bodycam', price = 0, amount = 1},
    {name = 'breathalyzer', price = 0, amount = 1},
    {name = 'breathalyzer_mouthpiece', price = 0, amount = 10},
    {name = 'dash_cam', price = 0, amount = 1},
   -- {name = 'dnatest', price = 0, amount = 1},
    {name = 'fibre_swab', price = 0, amount = 1},
    {name = 'fingerprint_lift', price = 0, amount = 1},
-- {name = 'fingerprint_scanner', price = 0, amount = 1},
    {name = 'gsr_swab', price = 0, amount = 1},
    {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
    {name = 'police_tape', price = 0, amount = 1, grade = 0},
    {name = 'radio', price = 0, amount = 1},
    {name = 'gps', price = 0, amount = 1},
    {name = 'digital_camera', price = 0, amount = 1},
    {name = 'sd_card', price = 0, amount = 1},
    {name = 'stinger', price = 0, amount = 1, grade = 3},
    {name = 'taser_cartridge', price = 0, amount = 1, grade = 8},
    {name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
    {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
    {name = 'WEAPON_P226', price = 0, amount = 1, grade = 13},
    -- {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 8},
    {name = 'clothes_bag', price = 0, amount = 1, grade = 0},
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
           -- {coords = vector3(2527.784, -292.045, 93.615), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
          --  {coords = vector3(2527.814, -293.641, 93.615), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(2532.594, -295.352, 93.112), distance = 2.0},
            {coords = vector3(2528.554, -295.343, 93.112), distance = 2.0},
            {coords = vector3(2528.114, -290.491, 93.112), distance = 2.0},
            {coords = vector3(2529.914, -290.529, 93.112), distance = 2.0},
            {coords = vector3(2532.057, -290.671, 93.112), distance = 2.0},
        },
        bossmenus = {
            {coords = vector3(2517.429, -319.163, 93.112), distance = 1.5},
        },
        toggleDuty = {
            {coords = vector3(2534.533, -312.516, 93.112), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(2517.9001, -318.4384, 93.8062), distance = 2.0},
        },
        --[[mechanics = {
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
        },--]]
        vehicleMenus = {
            --[[{ -- Cars
                locations = {
                    {
                        take = {
                            {coords = vector4(2511.613, -357.374, 93.112, 91.474), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_CLIPBOARD',
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
                                    pants = {item = 206, texture = 0},
                                    bag = {item = 0, texture = 0},
                                    shoes = {item = 25, texture = 0},
                                    accessory = {item = 0, texture = 0},
                                    t_shirt = {item = 234, texture = 0},
                                    vest = {item = 0, texture = 0},
                                    decals = {item = 0, texture = 0},
                                    torso = {item = 569, texture = 0},

                                    hat = {item = 232, texture = 0},
                                    glass = {item = -1, texture = 0},
                                    ear = {item = -1, texture = 0},
                                    watch = {item = -1, texture = 0},
                                    bracelet = {item = -1, texture = 0},
                                }
                            },
                        },
                    },
                        spawn = {
                            {coords = vector4(2515.571, -355.068, 92.992, 269.088), distance = 2.0}, 
                            {coords = vector4(2516.144, -350.513, 92.992, 268.045), distance = 2.0}, 
                        }
                    },
                },
                returnLocations = {
                    {coords = vector3(2516.144, -350.513, 92.992), distance = 5.0},
                    {coords = vector3(2516.621, -355.187, 92.992), distance = 5.0},
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
                           -- {label = 'ARU Marked Rebla', model = 'Reblaxxpd', price = 0, minGrade = 0},
                            {label = 'ARU Marked A4', model = 'wagmark8fa', price = 0, minGrade = 1}
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
    { -- Training Centre - Firing Range
        jobs = {
            police = 0,
            sheriff = 0,
        },
        shops = {
            {
                coords = vector3(2477.52, -373.22, 89.313),
                distance = 2.0,
items = {
    {name = 'ammo-9', price = 0, amount = 12, grade = 5},
    {name = 'ammo-rifle', price = 0, amount = 30, grade = 5},
    {name = 'ammo-shotgun', price = 0, amount = 8, grade = 5},
   -- {name = 'blood_sample_kit', price = 0, amount = 1},
   -- {name = 'bodycam', price = 0, amount = 1},
   -- {name = 'breathalyzer', price = 0, amount = 1},
   -- {name = 'dash_cam', price = 0, amount = 1},
 --   {name = 'dnatest', price = 0, amount = 1},
  --  {name = 'fibre_swab', price = 0, amount = 1},
 --   {name = 'fingerprint_scanner', price = 0, amount = 1},
  --  {name = 'gsr_swab', price = 0, amount = 1},
  --  {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
   -- {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
  --  {name = 'radio', price = 0, amount = 1},
  --  {name = 'stinger', price = 0, amount = 1, grade = 1},
    {name = 'police_tape', price = 0, amount = 1, grade = 0},
    {name = 'taser_cartridge', price = 0, amount = 1, grade = 8},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
    {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
    {name = 'WEAPON_P226', price = 0, amount = 1, grade = 13},
    -- {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 13},
    {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 8},
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
            {coords = vector3(2527.9866, -293.6417, 94.5546), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(2471.382, -374.029, 89.313), distance = 2.0},
        },
    },
    {
        blip = {
            label = 'Training Centre', -- FIRE
            coords = vector3(2534.533, -312.516, 93.112),
            sprite = 137,
            color = 3,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            fire = 0,
            ambulance = 0,
            sheriff = 0,
        },
        shops = {
            {
                coords = vector4(2546.12, -303.54, 93.112, 59.919),
                distance = 2.0,
                ped = `mp_m_freemode_01`,
                scenario = 'WORLD_HUMAN_COP_IDLES',
                pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                    appearance = {
                        mom = {item = 0},
                        dad = {item = 0},
                        face = {item = 50},
                        skin_tone = {item = 50},

                        hair = {item = 21, texture = 0},
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
                   -- {name = 'decontent', price = 0, amount = 1},
                    {name = 'lpp', price = 0, amount = 1},
                    {name = 'rescuecushion', price = 0, amount = 1, grade = 2},
                    {name = 'tripod', price = 0, amount = 1, grade = 2},
                    {name = 'basket', price = 0, amount = 1, grade = 2},
                    {name = 'scba', price = 0, amount = 1},
                    {name = 'scbarope', price = 0, amount = 1},
                    {name = 'radio', price = 0, amount = 1},
                    {name = 'gps', price = 0, amount = 1},
                    {name = 'police_tape', price = 0, amount = 1, grade = 0},
                    {name = 'worklight', price = 0, amount = 1},
                    {name = 'bodycam', price = 0, amount = 1},
                    {name = 'dash_cam', price = 0, amount = 1},
                    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
                    {name = 'cone', price = 0, amount = 1},
                    {name = 'WEAPON_FIREEXTINGUISHER', price = 0, amount = 1},
                    {name = 'WEAPON_GLASSMASTER', price = 0, amount = 1},
                    {name = 'WEAPON_CUTTER', price = 0, amount = 1},
                    {name = 'WEAPON_SPREADER', price = 0, amount = 1},
                    {name = 'weapon_throwline', price = 0, amount = 1},
                    {name = 'clothes_bag', price = 0, amount = 1, grade = 0},
                    {name = 'upgraded_drone', price = 0, amount = 1, grade = 3},
                },
            },
        },
        storages = {
            {coords = vector3(2527.784, -292.045, 93.615), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(2527.814, -293.641, 93.615), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            {coords = vector3(328.1575, -587.2042, 29.7472), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            {coords = vector3(-344.7463, -588.9879, 34.1301), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            {coords = vector3(-345.7993, -586.8507, 34.2002), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            {coords = vector3(-348.2024, -590.0586, 34.2543), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            {coords = vector3(-1416.4860, -263.1396, 47.6270), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(-332.8424, -579.1095, 34.2022), distance = 2.0},
            {coords = vector3(2532.594, -295.352, 93.112), distance = 2.0},
            {coords = vector3(2528.554, -295.343, 93.112), distance = 2.0},
            {coords = vector3(2528.114, -290.491, 93.112), distance = 2.0},
            {coords = vector3(2529.914, -290.529, 93.112), distance = 2.0},
            {coords = vector3(2532.057, -290.671, 93.112), distance = 2.0},
        },
        bossmenus = {
            {coords = vector3(2517.429, -319.163, 93.112), distance = 2.0},
        },
        toggleDuty = {
            {coords = vector3(2534.533, -312.516, 93.112), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(2513.935, -317.895, 93.112), distance = 2.0},
        },
        --[[mechanics = {
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
        },--]]
        vehicleMenus = {
            --[[{ -- Cars
                locations = {
                    {
                        take = {
                            {coords = vector4(2511.613, -357.374, 93.112, 91.474), 
                            distance = 2.0, 
                            ped = `mp_m_freemode_01`,
                            scenario = 'WORLD_HUMAN_CLIPBOARD',
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
                                    pants = {item = 206, texture = 0},
                                    bag = {item = 0, texture = 0},
                                    shoes = {item = 25, texture = 0},
                                    accessory = {item = 0, texture = 0},
                                    t_shirt = {item = 234, texture = 0},
                                    vest = {item = 0, texture = 0},
                                    decals = {item = 0, texture = 0},
                                    torso = {item = 569, texture = 0},

                                    hat = {item = 232, texture = 0},
                                    glass = {item = -1, texture = 0},
                                    ear = {item = -1, texture = 0},
                                    watch = {item = -1, texture = 0},
                                    bracelet = {item = -1, texture = 0},
                                }
                            },
                        },
                    },
                        spawn = {
                            {coords = vector4(2515.571, -355.068, 92.992, 269.088), distance = 2.0}, 
                            {coords = vector4(2516.144, -350.513, 92.992, 268.045), distance = 2.0}, 
                        }
                    },
                },
                returnLocations = {
                    {coords = vector3(2516.144, -350.513, 92.992), distance = 5.0},
                    {coords = vector3(2516.621, -355.187, 92.992), distance = 5.0},
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
                           -- {label = 'ARU Marked Rebla', model = 'Reblaxxpd', price = 0, minGrade = 0},
                            {label = 'ARU Marked A4', model = 'wagmark8fa', price = 0, minGrade = 1}
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
                    name = 'Station Wear',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 153,
                        tshirt_2 = 0,
                        torso_1 = 598,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 259,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 224,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Station Outfit',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 599,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 259,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 224,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Turnout Gear',
                    data = {
                        mask_1 = 245,
                        mask_2 = 0,
                        arms = 216,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 600,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 225,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 254,
                        helmet_2 = 0,
                        glasses_1 = -1,
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
                    name = 'Turnout Gear',
                    data = {
                        mask_1 = 254,
                        mask_2 = 0,
                        arms = 250,
                        tshirt_1 = 348,
                        tshirt_2 = 0,
                        torso_1 = 767,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 272,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 256,
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
            label = 'LA Mesa PD',
            coords = vector3(834.706, -1287.12, 28.242),
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
                coords = vector4(846.859, -1291.451, 28.238, 86.715),
                distance = 2.0,
                ped = `mp_m_freemode_01`,
                scenario = 'WORLD_HUMAN_CLIPBOARD',
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
   -- {name = 'ammo-9', price = 0, amount = 12, grade = 8},
    --{name = 'ammo-rifle', price = 0, amount = 30, grade = 8},
   -- {name = 'ammo-shotgun', price = 0, amount = 8, grade = 8},
    {name = 'blood_sample_kit', price = 0, amount = 1},
    {name = 'bodycam', price = 0, amount = 1},
    {name = 'breathalyzer', price = 0, amount = 1},
    {name = 'breathalyzer_mouthpiece', price = 0, amount = 10},
    {name = 'dash_cam', price = 0, amount = 1},
  --  {name = 'dnatest', price = 0, amount = 1},
    {name = 'fibre_swab', price = 0, amount = 1},
    {name = 'fingerprint_lift', price = 0, amount = 1},
-- {name = 'fingerprint_scanner', price = 0, amount = 1},
    {name = 'gsr_swab', price = 0, amount = 1},
    {name = 'handcuffs', price = 0, amount = 1},
    {name = 'gh_pdnotebook', price = 0, amount = 1},
    {name = 'WEAPON_PEPPERSPRAY', price = 0, amount = 1},
    {name = 'WEAPON_ANTIDOTE', price = 0, amount = 1},
    {name = 'empty_ticket', price = 0, amount = 10, grade = 0},
    {name = 'police_tape', price = 0, amount = 1, grade = 0},
    {name = 'radio', price = 0, amount = 1},
    {name = 'gps', price = 0, amount = 1},
    {name = 'stinger', price = 0, amount = 1, grade = 3},
    {name = 'taser_cartridge', price = 0, amount = 1, grade = 8},
   -- {name = 'WEAPON_CARBINERIFLE', price = 0, amount = 1, grade = 8},
   -- {name = 'WEAPON_COMBATPISTOL', price = 0, amount = 1, grade = 8},
    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
    {name = 'WEAPON_NIGHTSTICK', price = 0, amount = 1},
  --  {name = 'WEAPON_P226', price = 0, amount = 1, grade = 8},
   -- {name = 'WEAPON_PUMPSHOTGUN', price = 0, amount = 1, grade = 8},
  --  {name = 'WEAPON_SIG716', price = 0, amount = 1, grade = 8},
  --  {name = 'WEAPON_SIGMCX', price = 0, amount = 1, grade = 8},
    {name = 'WEAPON_STUNGUN', price = 0, amount = 1, grade = 8},
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
            {coords = vector3(846.098, -1290.31, 28.238), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(845.678, -1287.988, 28.238), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(852.805, -1304.441, 28.235), distance = 2.0},
            {coords = vector3(850.134, -1308.757, 28.237), distance = 2.0},
            {coords = vector3(850.804, -1309.786, 28.236), distance = 2.0},
            {coords = vector3(854.307, -1309.767, 28.235), distance = 2.0},
            {coords = vector3(855.241, -1309.016, 28.235), distance = 2.0},
        },
        bossmenus = {
            {coords = vector3(846.14, -1279.148, 28.242), distance = 4.0},
        },
        toggleDuty = {
            {coords = vector3(832.379, -1289.273, 28.243), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(835.652, -1290.738, 28.242), distance = 2.0},
        },
        vehicleMenus = {
                --[[{ -- Cars
                locations = {
                    {
                        take = {
                            {coords = vector4(-3153.959, 1142.859, 21.048, 59.284), 
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
                            {coords = vector4(-3157.641, 1153.814, 21.071, 239.075), distance = 2.0}, 
                            {coords = vector4(-3155.979, 1157.135, 21.062, 250.286), distance = 2.0}, 
                            {coords = vector4(-3154.138, 1160.214, 21.061, 247.523), distance = 2.0},
                            {coords = vector4(-3152.699, 1163.788, 21.055, 242.12), distance = 2.0},
                            {coords = vector4(-3151.34, 1167.115, 21.049, 246.309), distance = 2.0},
                        }
                    },
                },
                returnLocations = {
                    {coords = vector3(-3167.515, 1129.608, 21.01), distance = 5.0},
                    {coords = vector3(-3163.339, 1138.701, 21.157), distance = 5.0},
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
                           -- {label = 'ARU Marked Rebla', model = 'Reblaxxpd', price = 0, minGrade = 0},
                            {label = 'ARU Marked A4', model = 'wagmark8fa', price = 0, minGrade = 1}
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
            label = 'Vespucci Fire Station',
            coords = vector3(-1047.096, -1398.115, 16.191),
            sprite = 210,
            color = 1,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            fire = 0,
            ambulance = 0,
        },
        shops = {
            {
                coords = vector4(-1029.452, -1388.725, 4.973, 43.321),
                distance = 2.0,
                ped = `mp_m_freemode_01`,
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                    appearance = {
                        mom = {item = 0},
                        dad = {item = 0},
                        face = {item = 50},
                        skin_tone = {item = 50},

                        hair = {item = 21, texture = 0},
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
                        pants = {item = 224, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 24, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 153, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 259, texture = 0},
                        torso = {item = 598, texture = 0},

                        hat = {item = -1, texture = 0},
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
                   -- {name = 'decontent', price = 0, amount = 1},
                    {name = 'lpp', price = 0, amount = 1},
                    {name = 'rescuecushion', price = 0, amount = 1, grade = 1},
                    {name = 'tripod', price = 0, amount = 1, grade = 1},
                    {name = 'basket', price = 0, amount = 1, grade = 1},
                    {name = 'scba', price = 0, amount = 1},
                    {name = 'scbarope', price = 0, amount = 1},
                    {name = 'radio', price = 0, amount = 1},
                    {name = 'gps', price = 0, amount = 1},
                    {name = 'police_tape', price = 0, amount = 1, grade = 0},
                    {name = 'worklight', price = 0, amount = 1},
                    {name = 'bodycam', price = 0, amount = 1},
                    {name = 'dash_cam', price = 0, amount = 1},
                    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
                    {name = 'cone', price = 0, amount = 1},
                    {name = 'WEAPON_FIREEXTINGUISHER', price = 0, amount = 1},
                    {name = 'WEAPON_GLASSMASTER', price = 0, amount = 1},
                    {name = 'WEAPON_CUTTER', price = 0, amount = 1},
                    {name = 'WEAPON_SPREADER', price = 0, amount = 1},
                    {name = 'weapon_throwline', price = 0, amount = 1},
                    {name = 'clothes_bag', price = 0, amount = 1, grade = 0},
                    {name = 'upgraded_drone', price = 0, amount = 1, grade = 3},
                    {name = 'ecg', price = 0, amount = 1, grade = 4},
                    {name = 'bandage', price = 0, amount = 1, grade = 4},
                },
            },
        },
        storages = {
            {coords = vector3(-1036.05, -1401.65, 5.07), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(-1051.40, -1435.53, 4.97), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(-1036.008, -1389.38, 4.973), distance = 2.0},
            {coords = vector3(-1036.70, -1391.39, 4.97), distance = 2.0},
            {coords = vector3(-1033.20, -1389.93, 4.97), distance = 2.0},
            {coords = vector3(-1030.67, -1392.66, 4.97), distance = 2.0},
        },
        bossmenus = {
            {coords = vector3(-1055.04, -1432.04, 4.97), distance = 2.0},
        },
        toggleDuty = {
            {coords = vector3(-1039.11, -1400.70, 5.08), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(-1053.37, -1432.03, 5.01), distance = 2.0},
        },
        --[[mechanics = {
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
        },--]]
        vehicleMenus = {
            --[[{ -- heli
                locations = {
                    {
                        take = {
                            {coords = vec4(2464.24, -407.29, 95.00, 50.10), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
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
                    {coords = vec3(2454.77, -399.62, 95.00), distance = 2.0},
                },
                vehicleCategories = {
                    {
                        category = 'Helicopter',
                        vehicles = {
                            {label = 'NPAS', model = 'polec130', price = 0, livery = 0},
                        },
                    },
                },
            },]]--
            { -- Boat marker1
                locations = {
                    {
                        take = {
                            {coords = vec4(-1006.71, -1396.988, 1.596, 198.776), distance = 2.0, ped = `mp_m_boatstaff_01`, scenario = 'WORLD_HUMAN_CLIPBOARD'},
                        },
                        spawn = {
                            {coords = vec4(-1000.191, -1399.504, 0.12, 19.274), distance = 2.0},
                        }
                    }
                },
                returnLocations = {
                    {coords = vec3(-1000.191, -1399.504, 0.12), distance = 5.0},
                },
                vehicleCategories = {
                    {
                        category = 'Boat',
                        vehicles = {
                            {label = 'TRT Rescue Boat', model = 'dinghy', price = 0, minGrade = 1},
                        },
                    },
                },
            },
            { -- Cars
                locations = {
                    {
                        take = {
                            {coords = vec4(2528.134, -468.168, 92.992, 174.956), distance = 2.0, ped = `mp_m_waremech_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(2535.114, -457.273, 92.992, 358.922), distance = 2.0},
                        }
                    }
                },
                returnLocations = {
                    {coords = vec3(2535.114, -457.273, 92.992), distance = 5.0},
                },
                vehicleCategories = {
                    {
                        category = 'Car',
                        vehicles = {
                            {label = 'RTC Car', model = 'asterope', price = 0, minGrade = 1},
                        },
                    },
                },
            }
        },
        outfits = {
            male = {
                {
                    name = 'Station Wear',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 153,
                        tshirt_2 = 0,
                        torso_1 = 598,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 259,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 224,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Station Outfit',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 599,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 259,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 224,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Turnout Gear',
                    data = {
                        mask_1 = 245,
                        mask_2 = 0,
                        arms = 216,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 600,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 225,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 254,
                        helmet_2 = 0,
                        glasses_1 = -1,
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
                    name = 'Turnout Gear',
                    data = {
                        mask_1 = 254,
                        mask_2 = 0,
                        arms = 250,
                        tshirt_1 = 348,
                        tshirt_2 = 0,
                        torso_1 = 767,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 272,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 256,
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
            label = 'Sandy Fire Station',
            coords = vector3(1674.722, 3574.015, 35.701),
            sprite = 210,
            color = 1,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            fire = 0,
            ambulance = 0,
        },
        shops = {
            {
                coords = vector4(1685.689, 3578.289, 35.701, 294.123),
                distance = 2.0,
                ped = `mp_m_freemode_01`,
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                    appearance = {
                        mom = {item = 0},
                        dad = {item = 0},
                        face = {item = 50},
                        skin_tone = {item = 50},

                        hair = {item = 21, texture = 0},
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
                        pants = {item = 224, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 24, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 153, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 259, texture = 0},
                        torso = {item = 598, texture = 0},

                        hat = {item = -1, texture = 0},
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
                   -- {name = 'decontent', price = 0, amount = 1},
                    {name = 'lpp', price = 0, amount = 1},
                    {name = 'rescuecushion', price = 0, amount = 1, grade = 2},
                    {name = 'tripod', price = 0, amount = 1, grade = 2},
                    {name = 'basket', price = 0, amount = 1, grade = 2},
                    {name = 'chock', price = 0, amount = 1, grade = 2},
                    {name = 'scba', price = 0, amount = 1},
                    {name = 'scbarope', price = 0, amount = 1},
                    {name = 'radio', price = 0, amount = 1},
                    {name = 'gps', price = 0, amount = 1},
                    {name = 'fan', price = 0, amount = 1},
                    {name = 'upgraded_drone', price = 0, amount = 1, grade = 3},
                    {name = 'stabiliser', price = 0, amount = 1},
                    {name = 'worklight', price = 0, amount = 1},
                    {name = 'bodycam', price = 0, amount = 1},
                    {name = 'dash_cam', price = 0, amount = 1},
                    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
                    {name = 'cone', price = 0, amount = 1},
                    {name = 'WEAPON_FIREEXTINGUISHER', price = 0, amount = 1},
                    {name = 'WEAPON_HALLIGAN', price = 0, amount = 1},
                    {name = 'WEAPON_SPREADER', price = 0, amount = 1},
                    {name = 'WEAPON_SAW', price = 0, amount = 1},
                    {name = 'weapon_throwline', price = 0, amount = 1},
                },
            },
        },
        storages = {
            {coords = vector3(1678.932, 3581.178, 35.701), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(1680.497, 3582.182, 35.701), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(1674.532, 3583.436, 35.701), distance = 2.0},
            {coords = vector3(1676.473, 3586.004, 35.701), distance = 2.0},
            {coords = vector3(1684.642, 3579.888, 35.701), distance = 2.0},
            {coords = vector3(1686.209, 3583.329, 35.701), distance = 2.0},
            {coords = vector3(1683.995, 3580.958, 35.701), distance = 2.0},
        },
        bossmenus = {
         --   {coords = vector3(187.638, -1636.814, 29.803), distance = 2.0},
        },
        toggleDuty = {
            {coords = vector3(1675.391, 3573.054, 35.701), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(1674.157, 3588.532, 38.494), distance = 2.0},
        },
        --[[mechanics = {
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
        },--]]
        vehicleMenus = {
            --[[{ -- heli
                locations = {
                    {
                        take = {
                            {coords = vec4(2464.24, -407.29, 95.00, 50.10), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
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
                    {coords = vec3(2454.77, -399.62, 95.00), distance = 2.0},
                },
                vehicleCategories = {
                    {
                        category = 'Helicopter',
                        vehicles = {
                            {label = 'NPAS', model = 'polec130', price = 0, livery = 0},
                        },
                    },
                },
            },]]--
            --[[{ -- Boat
                locations = {
                    {
                        take = {
                            {coords = vec3(-778.6799, -1437.2778, 0.5953), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(-783.6753, -1432.3116, 0.3526, 55.4069), distance = 2.0},
                        },
                    },
                    {
                        take = {
                            {coords = vec3(2826.5039, -670.2258, 0.4134), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(2854.2952, -667.8505, 0.5903, 282.3907), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(85.9970, -2258.3513, 5.0806), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(82.3357, -2267.1614, 0.4062, 182.6948), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(3858.5674, 4459.5347, 0.8349), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(3860.0947, 4453.5415, 0.3257, 246.5833), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(-1611.3589, 5262.6030, 2.9741), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(-1600.9111, 5261.2876, 0.6112, 27.9818), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(-1802.9984, -1231.3341, 0.6072), distance = 2.0, ped = `s_m_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
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
                },
                vehicleCategories = {
                    {
                        category = 'Boat',
                        vehicles = {
                            {label = 'lspppredator', model = 'Predator', price = 0},
                        },
                    },
                },
            },
            { -- Cars
                locations = {
                    {
                        take = {
                            {coords = vector4(198.777, -1648.188, 29.803, 138.77), 
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
                                    mask = {item = 245, texture = 0},
                                    arms = {item = 215, texture = 0},
                                    pants = {item = 205, texture = 0},
                                    bag = {item = 0, texture = 0},
                                    shoes = {item = 51, texture = 0},
                                    accessory = {item = 0, texture = 0},
                                    t_shirt = {item = 216, texture = 0},
                                    vest = {item = 0, texture = 0},
                                    decals = {item = 0, texture = 0},
                                    torso = {item = 555, texture = 0},

                                    hat = {item = 236, texture = 0},
                                    glass = {item = -1, texture = 0},
                                    ear = {item = -1, texture = 0},
                                    watch = {item = -1, texture = 0},
                                    bracelet = {item = -1, texture = 0},
                                }
                            },
                        },
                    },
                        spawn = {
                            {coords = vector4(187.036, -1641.378, 29.803, 46.587), distance = 2.0}, 
                            {coords = vector4(183.929, -1644.23, 29.803, 44.191), distance = 2.0}, 
                            {coords = vector4(180.809, -1646.946, 29.803, 46.264), distance = 2.0},
                            {coords = vector4(178.289, -1650.046, 29.803, 46.38), distance = 2.0},
                            {coords = vector4(193.505, -1657.608, 29.803, 224.205), distance = 2.0},
                            {coords = vector4(196.627, -1654.853, 29.803, 235.538), distance = 2.0},
                            {coords = vector4(199.304, -1651.751, 29.803, 225.793), distance = 2.0},
                        }
                    },
                },
                returnLocations = {
                    {coords = vector3(206.656, -1661.848, 29.803), distance = 10.0},
                    {coords = vector3(204.048, -1666.118, 29.803), distance = 10.0},
                },
                vehicleCategories = {
                    {
                        category = 'Trucks',
                        vehicles = {
                            {label = 'Fire Truck', model = 'fmlccfire', price = 0, minGrade = 0},
                            {label = 'Water Truck', model = 'fmlwater', price = 0, minGrade = 0},
                        },
                        minGrade = 0,
                    },
                    --[[{
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
            }]]--
        },
        outfits = {
            male = {
                {
                    name = 'Station Wear',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 153,
                        tshirt_2 = 0,
                        torso_1 = 598,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 259,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 224,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Station Outfit',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 599,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 259,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 224,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Turnout Gear',
                    data = {
                        mask_1 = 245,
                        mask_2 = 0,
                        arms = 216,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 600,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 225,
                        pants_2 = 0,
                        shoes_1 = 24,
                        shoes_2 = 0,
                        helmet_1 = 254,
                        helmet_2 = 0,
                        glasses_1 = -1,
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
                    name = 'Turnout Gear',
                    data = {
                        mask_1 = 254,
                        mask_2 = 0,
                        arms = 250,
                        tshirt_1 = 348,
                        tshirt_2 = 0,
                        torso_1 = 767,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 272,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 256,
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
            label = 'Fleet Services',
            coords = vector3(950.82, -1476.561, 35.526),
            sprite = 210,
            color = 1,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            fleetmech = 0,
        },
        shops = {
            {
                coords = vector4(932.191, -1473.788, 30.832, 265.737),
                distance = 2.0,
                ped = `mp_m_freemode_01`,
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                pedSkin = { -- Only works with mp_m_freemode_01 or mp_f_freemode_01
                    appearance = {
                        mom = {item = 0},
                        dad = {item = 0},
                        face = {item = 50},
                        skin_tone = {item = 50},

                        hair = {item = 23, texture = 0},
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
                        pants = {item = 226, texture = 0},
                        bag = {item = 0, texture = 0},
                        shoes = {item = 25, texture = 0},
                        accessory = {item = 0, texture = 0},
                        t_shirt = {item = 15, texture = 0},
                        vest = {item = 0, texture = 0},
                        decals = {item = 0, texture = 0},
                        torso = {item = 596, texture = 12},

                        hat = {item = -1, texture = 0},
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
                    {name = 'cone', price = 0, amount = 1},
                    {name = 'worklight', price = 0, amount = 1},
                    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
                    {name = 'bodycam', price = 0, amount = 1},
                    {name = 'dash_cam', price = 0, amount = 1},
                    {name = 'gh_pdnotebook', price = 0, amount = 1},
                    {name = 'radio', price = 0, amount = 1},
                    {name = 'gps', price = 0, amount = 1},
                },
            },
        },
        storages = {
            {coords = vector3(948.014, -1489.823, 35.526), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(950.158, -1489.776, 35.526), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vector3(946.727, -1485.524, 35.526), distance = 2.0},
        },
        bossmenus = {
         --   {coords = vector3(187.638, -1636.814, 29.803), distance = 2.0},
        },
        toggleDuty = {
            {coords = vector3(950.922, -1476.563, 35.526), distance = 2.0},
        },
        bodycamStation = {
            {coords = vector3(951.283, -1481.412, 35.356), distance = 2.0},
        },
        vehicleMenus = {
           
        },
        outfits = {
            male = {
                {
                    name = 'Station Formal',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 596,
                        torso_2 = 10,
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
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Station Mechanic',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 598,
                        torso_2 = 2,
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
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Incident Commander',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 251,
                        tshirt_2 = 1,
                        torso_1 = 596,
                        torso_2 = 13,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 260,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 205,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Recovery',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 611,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 260,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 230,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Recovery Trainee',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 611,
                        torso_2 = 1,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 260,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
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
            }
        },
    },
    {
        jobs = {
            backstreetgarage = 0,
            unit17tuning = 0,
        },
        storages = {
            {
                coords = vector3(759.13, -1275.88, 29.52), -- Bar Stash BSG
                distance = 2.0,
                type = 'public',
                weight = 1000000,
                slots = 100,
                groups = {
                    backstreetgarage = 0,
                }
            },
            {
                coords = vector3(759.83, -1294.60, 29.52), -- Boss room stash filling cabs BSG
                distance = 2.0,
                type = 'public',
                weight = 1000000,
                slots = 100,
                groups = {
                    backstreetgarage = 4,
                }
            },
            {
                coords = vector3(-196.139, -1359.568, 31.258), -- Unit17 personal stash
                distance = 2.0,
                type = 'personal',
                weight = 1000000,
                slots = 100,
                groups = {
                    unit17tuning = 0,
                }
            },
            {
                coords = vector3(-216.603, -1372.268, 31.258), -- Unit17 public stash (all workers)
                distance = 2.0,
                type = 'public',
                weight = 1000000,
                slots = 100,
                groups = {
                    unit17tuning = 0,
                }
            },
            {
                coords = vector3(-199.529, -1372.855, 27.264), -- Unit17 public stash (owners)
                distance = 2.0,
                type = 'public',
                weight = 1000000,
                slots = 100,
                groups = {
                    unit17tuning = 4,
                }
            },
        },
        wardrobes = {
            {coords = vector3(-231.652, -1373.433, 31.436), distance = 2.0},
        },
    },
    {--flight ops hangar
        jobs = {
            flightops = 0,
            police = 0,
            ambulance = 0,
            fire = 0,
        },
        shops = {
            {
                coords = vector4(2493.638, -449.054, 92.995, 214.4),
                distance = 2.0,
                ped = `mp_f_helistaff_01`,
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                --[[ marker = { -- you can add marker for any location like this (so also works for storages, wardrobes, etc)
                    type = 1,
                    scale = vec3(1.0, 1.0, 1.0),
                    color = {r = 0, g = 255, b = 0, a = 100},
                    bob = false,
                    faceCamera = true,
                }, ]]
                items = {
                    {name = 'WEAPON_FLASHLIGHT', price = 0, amount = 1},
                    {name = 'radio', price = 0, amount = 1},
                    {name = 'gps', price = 0, amount = 1},
                    {name = 'upgraded_drone', price = 0, amount = 1, grade = 1},
                    {name = 'police_drone', price = 0, amount = 1, grade = 1},
                    {name = 'WEAPON_FIREEXTINGUISHER', price = 0, amount = 1},
                    {name = 'clothes_bag', price = 0, amount = 1},
                    {name = 'ecg', price = 0, amount = 1, grade = 4},
                    {name = 'bandage', price = 0, amount = 1, grade = 4},                                                                                                     
                },
            },
        },
        storages = {
            {coords = vector3(2493.91, -451.72, 93.01), distance = 2.0, type = 'public', weight = 1000000, slots = 100},
            {coords = vector3(2495.86, -454.85, 93.01), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
            --{coords = vector3(2814.48828125, 4724.9599609375, 48.627304077148), distance = 2.0, type = 'locker', weight = 1000000, slots = 100},
        },
     --[[]   wardrobes = {
            {coords = vector3(946.727, -1485.524, 35.526), distance = 2.0},
        },]]--
        bossmenus = {
            {coords = vector3(2475.59, -444.72, 93.01), distance = 2.0},
        },
        toggleDuty = {
            {coords = vector3(2494.17, -442.65, 93.00), distance = 2.0},
        },
        bodycamStation = {
        --    {coords = vector3(951.283, -1481.412, 35.356), distance = 2.0},
        },
        vehicleMenus = 
        {
            { -- heli
                locations = {
                    {
                        take = {
                            {coords = vec4(2464.24, -407.29, 95.00, 50.10), 
                            distance = 2.0, 
                            ped = `mp_f_helistaff_01`,
                            scenario = 'WORLD_HUMAN_COP_IDLES',
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
                        } ]]
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
        },
       --[[ outfits = {
            male = {
                {
                    name = 'Station Formal',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 596,
                        torso_2 = 10,
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
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Station Mechanic',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 598,
                        torso_2 = 2,
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
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Incident Commander',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 251,
                        tshirt_2 = 1,
                        torso_1 = 596,
                        torso_2 = 13,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 260,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 205,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Recovery',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 611,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 260,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 230,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    }
                },
                {
                    name = 'Recovery Trainee',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 0,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 611,
                        torso_2 = 1,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 260,
                        decals_2 = 0,
                        bag_1 = 0,
                        bag_2 = 0,
                        chain_1 = 0,
                        chain_2 = 0,
                        pants_1 = 226,
                        pants_2 = 1,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 215,
                        helmet_2 = -1,
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
            }
        },]]--
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