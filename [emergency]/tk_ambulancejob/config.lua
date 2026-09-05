Config = {} -- You can place webhook link for logs in server/main_editable.lua

Config.Framework = 'qb' -- 'esx' | 'qb'
Config.NotificationType = 'ox' -- 'esx' | 'qb' | 'ox' | 'mythic'
Config.Locale = 'en' -- 'en' | 'fi'
Config.ImagePath = 'nui://ox_inventory/web/images' -- path for images used in UI (for QB: nui://qb-inventory/html/images) (for ox_inventory: nui://ox_inventory/web/images)
Config.DebugMode = false -- false | true

Config.Inventory = 'ox' -- 'default' | 'ox' | 'qs' | 'qb_old' | 'qb_new'
Config.Target = 'ox' -- 'none' | 'ox' | 'qb'
Config.Dispatch = 'none' -- 'none' | 'tk' | 'cd'
Config.Clothing = 'illenium' -- 'illenium' | 'qb'
Config.Bossmenu = 'tk' -- 'tk' | 'esx' | 'qb'
Config.Billing = 'qb' -- 'esx' | 'qb' | 'okok'
Config.UseOxLib = true -- false | true, remember to add ' shared_script '@ox_lib/init.lua' ' to fxmanifest.lua if set to true
Config.UseTKEvidence = true -- false | true

Config.InteractionType = 'menu' --  'menu' | 'target' | 'both'
Config.UseMouseForMenu = false -- true | false, if true you use mouse to navigate menu, if false you use arrow keys. Only used if Config.InteractionType is set to 'menu' and Config.UseOxLib is set to false

Config.Skeletal = 'menu' -- 'menu' | 'cam' | 'both', the type of skeletal menu to use
Config.ShowHPInSkeletalView = true -- true | false
Config.ForceMaxHealth = true -- true | false, will set max health to 200 for all players
Config.MiniSkeletalPos = {
    x = 99, -- 0-100, percentage from left
    y = 98, -- 0-100, percentage from bottom
}

Config.UISettings = {
    color = 'violet', -- https://v6.mantine.dev/theming/colors/
    shade = 9, -- 1-9
}

Config.Controls = {
    interact = 38, -- E
    remove = 246, -- Y
    dropStretcher = 47, -- G
    distressSignal = 47, -- G
    respawn = 38, -- E
}

Config.Keybinds = { -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    jobMenu = 'F9',
    --drag = 'F7',
    skeletal = 'F7',
}

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
}

Config.Actions = {
    {
        name = 'player',
        actions = {
            'viewSkeletal',
            'putInVehicle',
            'drag',
            'sendBill',
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
        },
    },
}
Config.ShowActionsAlways = true

Config.Bills = { -- you can add more here if you want to use the built in billing system, these are just some examples
    {
        categoryLabel = 'Medical Services',
        bills = {
            {name = 'Basic Treatment Fee', amount = 1000},
            {name = 'Ambulance Transport', amount = 1000},
            {name = 'Medication Administration', amount = 1000},
            {name = 'On-Scene Medical Assessment', amount = 1000},
        },
    },
    {
        categoryLabel = 'Medical Procedures',
        bills = {
            {name = 'Minor Procedure / Treatment', amount = 1000},
        },
    },
}
Config.AllowCustomBills = true -- true | false, if true, players can create custom bills where they can set the amount and reason themselves

Config.Objects = { -- different objects can be placed down, you can also add a storage (persistent storage only works with ox_inventory)
    -- onlyEMS: only EMS jobs (from Config.Hospitals) can place/pick up this object, and if it has a storage, only EMS jobs can open it
    {item = 'med_bag', model = `xm_prop_x17_bag_med_01a`, onlyEMS = true, storage = {
        label = _U('med_bag'),
        slots = 10,
        weight = 10000,
        items = { -- items given to the bag when it's first created (ox_inventory only, only added once)
            {name = 'bandage', count = 5},
            {name = 'ifak', count = 2},
        },
    }},
}

Config.TrackerUpdateInterval = 1000 -- 1 second

Config.DistressSignal = {
    enable = true,
    cooldown = 60, -- in seconds
    blip = {
        color = 1, -- https://docs.fivem.net/docs/game-references/blips/ (Scroll to the bottom)
        scale = 1.0, -- This needs to be a float (eg. 1.0, 1.2, 2.0)
        sprite = 303, -- https://docs.fivem.net/docs/game-references/blips/
        playSound = true -- Should there be a sound for the when the blip shows up (true / false)
    }
}

Config.Blips = { -- blips used for tracker
    default = {
        sprite = 1,
        scale = 0.5,
        color = 1,
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
        color = 1,
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
        color = 1,
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
        color = 1,
        display = 4,
        category = 2,
        shortRange = true,
        cone = false,
        indicator = false
    }
}

Config.Beds = {
    {
        model = `v_med_bed1`, -- bed model
        headingOffset = 0.0, -- offset for player heading when laying in bed, only used with model beds
        maxEMSCount = 1, -- max amount of EMS that can be online for this bed model to work (if there are more than this, the medic will stop working)
        heal = {
            treat = {'bleed', 'shot', 'stab', 'bruise', 'fracture', 'sprain', 'burn', 'crush', 'bite', 'fall', 'vehicle_impact', 'explosion', 'electrical', 'other'}, -- injuries that the bed will treat
            health = 100, -- how much player health will be healed by the bed
            removesBullets = true, -- if true, all bullets will be removed from the player
            revive = true, -- if true, the player will be revived by the bed
            anim = {
                duration = 10000,
                dict = 'mini@cpr@char_b@cpr_def',
                name = 'cpr_pumpchest_idle',
                flag = 1,
            },
        },
        locations = { -- you can also add coords for bed like this
             vec4(361.51, -1407.55, 35.50, 140.82),
            vec4(365.02, -1410.19, 35.50, 132.84),
        }
    },
}

Config.Respawn = {
    items = {
        remove = {
            items = true, -- remove items from player inventory when respawning
            weapons = true, -- remove weapons from player inventory when respawning
        },
        blacklist = { -- items that will not be removed
            phone = true,
            id = true,
        },
        --whitelist = {}, -- if set, only these items will be removed
    },
    locations = { -- player will always be teleported to nearest location
        {coords =vec4(361.06, -1409.58, 30.22, 135.43), useWakeUpAnim = true}, -- useWakeUpAnim: if true, the player will wake up using the wake up animation
    },
    cost = 500, -- cost of respawning
}

Config.Hospitals = {
    {
        blip = {
            label = 'Hospital',
            coords = vector3(299.25, -584.79, 43.26),
            sprite = 61,
            color = 1,
            scale = 0.8,
            display = 4,
            shortRange = true,
        },
        jobs = {
            ambulance = 0,
            ems = 0,
        },
        medics = {
            {
                coords = vec4(355.03, -1397.67, 31.51, 48.79),
                distance = 2.0,
                --ped = `s_m_m_doctor_01`,
                scenario = 'WORLD_HUMAN_CLIPBOARD',
                price = 500,
                maxEMSCount = 1, -- max amount of EMS workers that can be online for this medic to work (if there are more than this, the medic will stop working)
                heal = {
                    treat = {'bleed', 'shot', 'stab', 'bruise', 'fracture', 'sprain', 'burn', 'crush', 'bite', 'fall', 'vehicle_impact', 'explosion', 'electrical', 'other'}, -- injuries that the medic will treat
                    health = 100, -- how much player health will be healed by the medic
                    removesBullets = true, -- if true, all bullets will be removed from the player
                    revive = true, -- if true, the player will be revived by the medic
                    anim = {
                        duration = 10000,
                    },
                },
                teleportToBed = true, -- should player be teleported to closest available bed when using the medic
            },
        },
        shops = {
            {
                coords = vec4(353.51, -1409.02, 32.51, 140.4),
                distance = 2.0,
                ped = `s_m_m_scientist_01`,
                scenario = 'WORLD_HUMAN_HANG_OUT_STREET',
                --[[ marker = { -- you can add marker for any location like this (so also works for storages, wardrobes, etc)
                    type = 1,
                    scale = vec3(1.0, 1.0, 1.0),
                    color = {r = 0, g = 255, b = 0, a = 100},
                    bob = false,
                    faceCamera = true,
                }, ]]
                items = {
                    {name = 'bandage', price = 10, amount = 1},
                    {name = 'ifak', price = 30, amount = 1},
                    {name = 'tourniquet', price = 15, amount = 1},
                    {name = 'gauze', price = 15, amount = 1},
                    {name = 'burn_gel', price = 15, amount = 1},
                    {name = 'surgical_kit', price = 50, amount = 1},
                    {name = 'saline_bag', price = 100, amount = 1},
                    {name = 'leg_brace', price = 20, amount = 1},
                    {name = 'arm_brace', price = 20, amount = 1},
                    {name = 'body_brace', price = 20, amount = 1},
                    {name = 'neck_brace', price = 20, amount = 1},
                    {name = 'ice_pack', price = 10, amount = 1},
                    {name = 'painkillers', price = 50, amount = 1},
                    {name = 'defibrillator', price = 100, amount = 1},
                    {name = 'adrenaline_syringe', price = 50, amount = 1},
                    {name = 'wheelchair', price = 250, amount = 1},
                    {name = 'walking_stick', price = 150, amount = 1},
                    {name = 'med_bag', price = 150, amount = 1},
                    {name = 'body_bag', price = 200, amount = 1},
                },
            },
        },
        storages = { -- public: everyone has same storage, personal: every player has their own storage, locker: player can choose the locker id (and lockers are public)
            {coords = vec3(350.98, -1411.43, 31.51), distance = 2.0, type = 'personal', weight = 1000000, slots = 100},
        },
        wardrobes = {
            {coords = vec3(351.8, -1410.33, 31.51), distance = 2.0},
        },
        bossmenus = {
            {coords = vec3(359.9, -1382.2, 35.53), distance = 2.0},
        },
        toggleDuty = {
            {coords = vec3(353.76, -1399.03, 31.51), distance = 2.0},
        },
        mechanics = {
            {
                coords = vec4(345.40, -556.78, 28.74, 63.60),
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
                },
                ped = `s_m_m_dockwork_01`,
                scenario = 'WORLD_HUMAN_COP_IDLES',
            }
        },
        vehicleMenus = {
            { -- Heli
                locations = {
                    {
                        take = {
                            {coords = vec4(340.63, -581.64, 74.16, 246.73), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(351.64, -588.46, 74.16, 250.11), distance = 2.0},
                        },
                        --[[ blip = {
                            label = 'EMS Garage',
                            coords = vec3(463.36, -985.34, 43.69),
                            sprite = 50,
                            color = 3,
                            scale = 0.8,
                        } ]]
                    },
                },
                returnLocations = {
                    {coords = vec3(351.64, -588.46, 74.16), distance = 2.0},
                },
                vehicleCategories = {
                    {
                        category = 'Helicopter',
                        vehicles = {
                            {label = 'Maverick', model = 'polmav', price = 0, livery = 1},
                        },
                    },
                },
            },
            --[[ { -- Boat
                locations = {
                    {
                        take = {
                            {coords = vec3(-778.6799, -1437.2778, 0.5953), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(-783.6753, -1432.3116, 0.3526, 55.4069), distance = 2.0},
                        },
                    },
                    {
                        take = {
                            {coords = vec3(2826.5039, -670.2258, 0.4134), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(2854.2952, -667.8505, 0.5903, 282.3907), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(85.9970, -2258.3513, 5.0806), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(82.3357, -2267.1614, 0.4062, 182.6948), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(3858.5674, 4459.5347, 0.8349), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(3860.0947, 4453.5415, 0.3257, 246.5833), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(-1611.3589, 5262.6030, 2.9741), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(-1600.9111, 5261.2876, 0.6112, 27.9818), distance = 2.0},
                        }
                    },
                    {
                        take = {
                            {coords = vec3(-1802.9984, -1231.3341, 0.6072), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(-1798.9021, -1235.8271, 0.5562, 215.9090), distance = 2.0},
                        }
                    }
                }, ]]
                --[[ returnLocations = {
                    {coords = vec3(-783.6753, -1432.3116, 0.3526), distance = 2.0},
                    {coords = vec3(2854.2952, -667.8505, 0.5903), distance = 2.0},
                    {coords = vec3(82.3357, -2267.1614, 0.4062), distance = 2.0},
                    {coords = vec3(3860.0947, 4453.5415, 0.3257), distance = 2.0},
                    {coords = vec3(-1600.9111, 5261.2876, 0.6112), distance = 2.0},
                    {coords = vec3(-1798.9021, -1235.8271, 0.5562), distance = 2.0},
                }, ]]
                --[[ vehicleCategories = {
                    {
                        category = 'Boat',
                        vehicles = {
                            {label = 'dinghy', model = 'Dinghy', price = 0},
                        },
                    },
                },
            }, ]]
            { -- Car
                locations = {
                    {
                        take = {
                            {coords = vec4(336.76, -589.55, 28.80, 343.17), distance = 2.0, ped = `s_m_m_dockwork_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
                        },
                        spawn = {
                            {coords = vec4(333.08, -590.51, 28.80, 339.69), distance = 2.0},
                            {coords = vec4(329.67, -589.33, 28.80, 339.74), distance = 2.0},
                            {coords = vec4(326.35, -588.37, 28.80, 339.16), distance = 2.0},
                            {coords = vec4(322.92, -587.48, 28.80, 339.24), distance = 2.0},
                            {coords = vec4(319.40, -586.25, 28.80, 343.60), distance = 2.0},
                        }
                    },
                },
                returnLocations = {
                    {coords = vec3(328.42, -576.84, 28.80), distance = 5.0},
                },
                vehicleCategories = {
                    {
                        category = 'Cars',
                        vehicles = {
                            {label = 'Ambulance', model = 'ambulance', price = 0, minGrade = 0}, -- you can set minGrade for a vehicle and a category to restrict to certain grades
                        },
                        minGrade = 0,
                    },
                    {
                        category = 'Other',
                        vehicles = {
                            {label = 'Firetruck', model = 'firetruk', price = 0},
                        },
                        minGrade = 2,
                    },
                }
            }
        },
        outfits = {
            male = {
                {
                    name = 'EMS',
                    data = {
                        mask_1 = 121,
                        mask_2 = 0,
                        arms = 93,
                        tshirt_1 = 15,
                        tshirt_2 = 0,
                        torso_1 = 249,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 60,
                        decals_2 = 0,
                        chain_1 = 126,
                        chain_2 = 0,
                        pants_1 = 31,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = -1,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    },
                },
            },
            female = {
                {
                    name = 'EMS',
                    data = {
                        mask_1 = 0,
                        mask_2 = 0,
                        arms = 104,
                        tshirt_1 = 2,
                        tshirt_2 = 0,
                        torso_1 = 257,
                        torso_2 = 0,
                        bproof_1 = 0,
                        bproof_2 = 0,
                        decals_1 = 0,
                        decals_2 = 0,
                        chain_1 = 96,
                        chain_2 = 0,
                        pants_1 = 30,
                        pants_2 = 0,
                        shoes_1 = 25,
                        shoes_2 = 0,
                        helmet_1 = 0,
                        helmet_2 = 0,
                        glasses_1 = 0,
                        glasses_2 = 0,
                    },
                },
            },
        },
    },
}
Config.EnableOwnedVehicles = true -- true | false, if true, vehicles taken from job garage will be saved and show up in job garage menu

Config.BPM = {
    show = true, -- true | false, if true, the target BPM will be shown in the UI
    item = 'ecg', -- item that will make it so the BPM is constantly displayed, if you dont have this item then you need to always manually check the target BPM (if item is not set will always show BPM)
    anim = { -- anim for checking BPM manually
        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        name = 'machinic_loop_mechandplayer',
        duration = 4000,
    }
}

Config.SkeletalDamage = {
    minDamage = 2.5, -- minimum damage to apply an injury
    showCause = true, -- true | false, should cause of the damage be shown in the UI
    weaponCalibers = { -- caliber settings, used in UI
        weapons = {
            [`WEAPON_PISTOL`] = '9mm', -- you can also set caliber per weapon like this, weapon caliber will always override class caliber
        },
        class = {
            pistol = '9mm',
            smg = '9mm',
            rifle = '7.62',
            shotgun = '12g',
            mg = '7.62',
            sniper = '.308',
        },
    },
    weaponInjuryTypes = {
        --[`WEAPON_PISTOL`] = 'shot',
        --[`WEAPON_KNIFE`] = 'stab',
        --[`WEAPON_BAT`] = 'bruise',
    },
    disabledWeapons = {
        [`WEAPON_PAINTBALLGUN`] = true,
    },
}

Config.BulletEffects = {
    enable = true,
    headShake = { -- how much player head will shake when hit by a bullet
        amount = 0.5,
        time = 1,
    },
    bodyStumble = { -- settings for ragdoll when hit by a bullet in torso
        chance = 10,
        time = {
            min = 1000,
            max = 2000,
        },
        type = {3},
    },
    legsRagdoll = { -- settings for ragdoll when hit by a bullet in legs
        chance = {
            pistol = 10,
            smg = 10,
            shotgun = 15,
            rifle = 20,
            mg = 20,
            sniper = 25,
        },
        time = {
            pistol = {min = 500, max = 1500},
            smg = {min = 1000, max = 2000},
            shotgun = {min = 1000, max = 2500},
            rifle = {min = 1000, max = 2500},
            mg = {min = 1000, max = 2500},
            sniper = {min = 1000, max = 2500},
        },
        type = {
            pistol = {0, 3},
            smg = {0, 3},
            shotgun = {0, 3},
            rifle = {0, 3},
            mg = {0, 3},
            sniper = {0, 3},
        },
    },

    slowMultiplier = 1.0, -- how much movement speed will be reduced when hit by a bullet in legs
    minMoveRate = 0.5, -- minimum movement speed when hit by a bullet in legs
    injuredWalkBullets = 1, -- how many bullets in legs are needed to apply injured walk
    disableJumpingBullets = 4, -- how many bullets in legs are needed to disable jumping

    armShakeMultiplier = 1.0, -- multiplier for camera shake when shooting with bullets in arms
    disableShootingBullets = 4, -- how many bullets in arms are needed to disable shooting
}

Config.Debuffs = {
    settings = {
        movementReduction = { -- settings for movement reduction
            {health = 20, reduction = 0.75},
            {health = 40, reduction = 0.85},
            {health = 50, reduction = 0.9},
        },
        visionBlur = {
            intensityMultiplier = 1.0, -- how blurry the vision will be
        },
        cameraShake = {
            multiplier = 1.0, -- how much camera will shake camera shakes
            interval = 5000, -- how often camera will shake
        },
        reducedGrip = {
            multiplier = 1.0, -- how much camera will shake when shooting
        },
        staminaDrain = {
            maxStamina = 50.0,
        },
        drunkVision = {
            intensityMultiplier = 0.8,
        },
        aimShake = {
            multiplier = 1.0,
        },
        bleed = {
            injuryTypes = {
                shot = true,
                stab = true,
                crush = true,
                bite = true,
                explosion = true,
                burn = true,
            },
            minDamage = 5, -- min damage done to body part to cause bleed injury
            minPartHealth = 80, -- the minimum health the part can be before bleed injury is applied (so if part health is 80 or lower, bleed injury can be applied)
            chance = 80.0, -- chance to cause bleed injury if the condition above are met
            multiplier = 1, -- how much health will be drained per second
            max = 10, -- maximum health that can be drained
            interval = 10000, -- how often health will be drained
            showNotification = true, -- should a notification to the player be shown when bleeding
        },
        ragdoll = {
            types = { -- settings for ragdoll, will always use the lowest health one
                {health = 10, chance = 0.001, time = 1000, type = 1},
                {health = 20, chance = 0.001, time = 1000, type = 3},
                {health = 30, chance = 0.0005, time = 1000, type = 3},
            },
            showNotification = true, -- should a notification to the player be shown when ragdoll
        },
        injuredWalk = {
            {
                clipset = "move_m@injured",
                style = "Injured",
                healthThreshold = 70,
                gender = "male"
            },
            {
                clipset = "move_f@injured",
                style = "Injured2",
                healthThreshold = 70,
                gender = "female"
            },
        },
    },
    -- debuffs:
    -- movement_reduction: reduces movement speed
    -- no_sprint: disables sprinting
    -- no_jump: disables jumping
    -- vision_blur: vision blur
    -- camera_shake: random camera shake
    -- reduced_grip: camera shake when shooting
    -- aim_shake: shake when aiming with a weapon
    -- stamina_drain: reduces max stamina
    -- drunk_vision: drunk visual effect
    -- bleed: health drain
    -- ragdoll: random ragdolls
    bodyParts = {
        head = { -- possible debuffs for this body part
            vision_blur = {threshold = 65, chance = 0.5}, -- threshold: health threshold for the debuff, chance: chance to apply the debuff when body part health is less than threshold (calculated every time body part is damaged)
            camera_shake = {threshold = 40, chance = 0.4},
            drunk_vision = {threshold = 30, chance = 0.2},
            bleed = {threshold = 100, chance = 100}, -- threshold and chance not used for bleed, settings can be changed above
        },
        torso = {
            movement_reduction = {threshold = 50, chance = 0.3},
            stamina_drain = {threshold = 60, chance = 0.5},
            ragdoll = {threshold = 30, chance = 0.4},
            bleed = {threshold = 100, chance = 100},
        },
        larm = {
            reduced_grip = {threshold = 35, chance = 0.5},
            aim_shake = {threshold = 70, chance = 0.6},
            bleed = {threshold = 100, chance = 100},
        },
        rarm = {
            reduced_grip = {threshold = 35, chance = 0.5},
            aim_shake = {threshold = 40, chance = 0.6},
            bleed = {threshold = 100, chance = 100},
        },
        lleg = {
            no_sprint = {threshold = 35, chance = 0.8},
            no_jump = {threshold = 40, chance = 0.8},
            movement_reduction = {threshold = 75, chance = 0.6},
            ragdoll = {threshold = 30, chance = 0.4},
            stamina_drain = {threshold = 75, chance = 0.5},
            bleed = {threshold = 100, chance = 100},
        },
        rleg = {
            no_sprint = {threshold = 35, chance = 0.8},
            no_jump = {threshold = 40, chance = 0.8},
            movement_reduction = {threshold = 75, chance = 0.6},
            ragdoll = {threshold = 30, chance = 0.4},
            stamina_drain = {threshold = 75, chance = 0.5},
            bleed = {threshold = 100, chance = 100},
        },
    },
}

Config.HealingItems = {
    bandage = {
        minUseHealth = 0, -- if body part health is less than this then item will become unusable
        treat = {'bruise', 'fall', 'vehicle_impact', 'other', 'electrical'}, -- list of injuries that the item can treat
        description = 'Treats minor wounds', -- description for UI
        bodyParts = 'any', -- list of body parts that the item can be used on
        heal = 25, -- how much to heal player health by (0-100)
        removesBullets = false, -- if true then item will remove all bullets from body part
        anim = { -- animation for using on yourself and other player
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    ifak = {
        minUseHealth = 0,
        treat = {'stab', 'sprain', 'fall', 'vehicle_impact', 'bite', 'other', 'electrical', 'bleed'},
        description = 'First aid kit for different injuries',
        bodyParts = 'any',
        heal = 50,
        anim = {
            self = {
                duration = 10000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_ld_health_pack',
                    pos = vec3(0.024, -0.04, -0.111),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 10000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    tourniquet = {
        minUseHealth = 0,
        treat = {'bleed'},
        description = 'Stops bleeding on arms and legs',
        bodyParts = {'larm', 'rarm', 'lleg', 'rleg'},
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    gauze = {
        minUseHealth = 0,
        treat = {'bruise', 'fall', 'vehicle_impact', 'bite', 'other'},
        description = 'Covers and protects wounds',
        bodyParts = 'any',
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    burn_gel = {
        minUseHealth = 0,
        treat = {'burn', 'explosion'},
        description = 'Treats burns and explosion damage',
        bodyParts = 'any',
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_beach_lotion_01',
                    pos = vec3(-0.087, 0.015, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    surgical_kit = {
        minUseHealth = 0,
        treat = {'shot', 'stab', 'bite', 'explosion'},
        description = 'Treats serious wounds and removes bullets',
        bodyParts = 'any',
        removesBullets = true,
        anim = {
            self = {
                duration = 10000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'v_serv_bs_scissors',
                    pos = vec3(-0.023, 0.013, -0.051),
                    rot = vec3(-92.082, -72.672, -4.813),
                },
            },
            other = {
                duration = 10000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    saline_bag = {
        minUseHealth = 0,
        treat = {},
        description = 'Full health recovery',
        heal = 100,
        bodyParts = 'any',
        anim = {
            self = {
                duration = 15000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 15000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    leg_brace = {
        minUseHealth = 0,
        treat = {'fracture', 'crush', 'fall', 'vehicle_impact'},
        description = 'Fixes broken legs',
        bodyParts = {'lleg', 'rleg'},
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    arm_brace = {
        minUseHealth = 0,
        treat = {'fracture', 'crush', 'fall', 'vehicle_impact'},
        description = 'Fixes broken arms',
        bodyParts = {'larm', 'rarm'},
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    body_brace = {
        minUseHealth = 0,
        treat = {'fracture', 'crush', 'fall', 'vehicle_impact'},
        description = 'Fixes broken torso',
        bodyParts = {'torso'},
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    neck_brace = {
        minUseHealth = 0,
        treat = {'fracture', 'sprain', 'crush', 'fall', 'vehicle_impact'},
        description = 'Fixes neck and head injuries',
        bodyParts = {'head', 'torso'},
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    ice_pack = {
        minUseHealth = 0,
        treat = {'electrical', 'bruise', 'other'},
        description = 'Reduces pain and swelling',
        bodyParts = 'any',
        anim = {
            self = {
                duration = 5000,
                dict = 'missheistdockssetup1clipboard@idle_a',
                name = 'idle_a',
                flag = 49,
                allowControls = true,
                prop = {
                    model = 'prop_rolled_sock_02',
                    pos = vec3(-0.072, -0.019, -0.032),
                    rot = vec3(0.0, 0.0, 0.0),
                },
            },
            other = {
                duration = 5000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        },
    },
    painkillers = {
        minUseHealth = 0,
        treat = {},
        description = 'Full health recovery',
        heal = 100,
        bodyParts = 'any',
        anim = {
            self = {
                duration = 2000,
                dict = 'mp_suicide',
                name = 'pill',
                flag = 49,
                allowControls = true,
            },
            other = {
                duration = 2000,
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 49,
            },
        }
    },
}

Config.ReviveOptions = {
    {
        chance = 0.7, -- chance for revive to succeed
        anim = 'cpr', -- animation to play when reviving, cpr is a premade animation
        jobs = { -- jobs that can use this revive option
            ambulance = 0,
        },
    },
    {
        item = {
            name = 'defibrillator', -- item name that is needed for this option
            remove = { -- should item be removed
                fail = true,
                success = true,
            }
        },
        description = 'Revives dead players', -- description for UI
        chance = 1.0,
        jobs = {
            ambulance = 0,
        },
        anim = {
            other = {
                dict = 'mini@cpr@char_a@cpr_str',
                name = 'cpr_pumpchest',
                flag = 1,
            },
        },
    },
    {
        item = {
            name = 'adrenaline_syringe',
            remove = {
                fail = true,
                success = true,
            }
        },
        description = 'Chance to revive dead players',
        chance = 0.5,
        anim = {
            other = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                name = 'machinic_loop_mechandplayer',
                flag = 1,
            },
        },
    },
}
Config.ReviveDetach = {
    peds = true, -- should all peds that are attached to the player be detached when revived
    objects = false, -- should all objects that are attached to the player be detached when revived
}

Config.Stretcher = {
    model = `prop_ld_binbag_01`,
    amountPerVehicle = 1, -- how many stretchers are in a vehicle
    vehicles = { -- if these are set then only vehicles with these models have stretchers and you can only put stretchers in these vehicles
        [`ambulance`] = true,
    },
    allowAlivePlayers = false, -- if true, players can be put on stretcher even if they are alive
    offset = vec3(-0.17, -1.05, -0.52), -- offset for stretcher prop when carried in hand
    rotation = vec3(12.74, 4.51, -8.2), -- rotation for stretcher prop when carried in hand
    patientOffset = vec3(0.0, 1.0, 0.0), -- offset for patient ped on stretcher
}

Config.KnifeWeapons = { -- weapons that will show "stab" as injury type
    `WEAPON_KNIFE`,
    `WEAPON_DAGGER`,
    `WEAPON_MACHETE`,
    `WEAPON_BOTTLE`,
}

Config.Wheelchair = {
    item = 'wheelchair',
    model = `iak_wheelchair`,
}

Config.WalkingStick = {
    item = 'walking_stick',
    model = `prop_cs_walking_stick`,
    clipset = 'move_lester_caneup',
    pos = vec3(0.130, 0.0, -0.029),
    rot = vec3(0.0, -79.3, -32.9),
}

Config.BodyBag = {
    item = 'body_bag',
    model = `xm_prop_body_bag`,
    anim = {
        duration = 5000,
        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        name = 'machinic_loop_mechandplayer',
        flag = 1,
    },
}

Config.LastStand = {
    enable = true,
    time = 60, -- how long last stand will last (seconds)
    audioEffectIntensity = 0.5, -- multiplier for audio effect intensity
}

Config.Death = {
    time = 300, -- how long until player can respawn (seconds)
    anim = {
        dict = 'dead',
        name = 'dead_a',
    },
    disableRespawn = false, -- if true, the "Press E to respawn" text and timer will not be shown and player will not be able to respawn
    respawnHoldTime = 3, -- how long the player needs to hold the respawn key to respawn (seconds)
    audioEffectIntensity = 0.7, -- multiplier for audio effect intensity
}
Config.SkipDeathInitCheck = false -- false | true, if true, the player will skip the death loaded check (if you are having issues with death UI not showing up, try setting this to true)
Config.DisableDeathUI = false -- false | true, disables last stand and death UI (all last stand and death logic will still work)
Config.HideDeathUIInPauseMenu = true -- false | true, hides the death/last-stand UI when the pause menu is open and restores it when the menu closes

Config.Elevators = {
    {
        label = 'Hospital Elevator',
        floors = {
            {
                label = 'Ground Floor',
                coords = {
                    interact = vec3(345.05, -584.83, 28.80), -- interact coords for elevator
                    teleport = vec4(342.22, -585.51, 28.80, 248.00), -- teleport coords for elevator
                },
            },
            {
                label = 'First Floor',
                coords = {
                    interact = vec3(332.43, -595.54, 43.28),
                    teleport = vec4(332.43, -595.54, 43.28, 74.26),
                },
            },
            {
                label = 'Helipad',
                coords = {
                    interact = vec3(338.67, -583.94, 74.16),
                    teleport = vec4(338.67, -583.94, 74.16, 252.02),
                },
            },
        },
    },
}