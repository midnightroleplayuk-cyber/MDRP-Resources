Config = Config or {}
Config.MaxOwnedLabs = 1 -- Max labs a player can own at the same time
Config.LabCookingXP = {min = 3, max = 5} -- XP received for every lab cook
Config.LabCooldown = 120 -- Lab cooldown after cooking (in minutes)
Config.PayMaintenance = true -- or false if u don't want players to pay lab maintenance every X days
Config.MaintenanceDays = 7 -- if PayMaintenance = true, lab will charge a cleaning fee every X days
Config.DeleteUnusedLabs = 14 -- Delete unused labs after X days from their last cook
Config.LabKeys = { 
    -- [item name] and a key index that matches a labtype
    ['meth_key'] = "methlab",
    ['coke_key'] = "cokelab",
    ['lsd_key'] = "lsdlab",
}

Config.LabTypes = {
    ['methlab'] = { -- unique key index
        drug = "meth", -- drug name linked to this lab
        shellModel = 'shell_meth', -- shell model
        interactions = {
            {
                event = "av_drugs:labStash", -- stash zone
                label = Lang['stash_zone'],
                coords = {x = 1.89, y = 2.99, z = 1.54, heading = -359.35},
            },
            {
                event = "av_drugs:labPC", -- laptop zone
                label = Lang['pc'],
                coords = {x = -7.94, y = 1.45, z = 1.54, heading = -90.5},
            },
            {
                event = "av_drugs:cook",
                label = Lang['cook_station'],
                coords = {x = -2.32, y = -1.64, z = 2.02, heading = -184.45},
                ingredients = { -- required items for this station
                    {name = "water", amount = 4},
                    {name = "burger", amount = 4},
                },
                output = {
                    {name = "meth_tray", amount = 2}
                },
                animation = {
                    dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
                    anim = "chemical_pour_long_cooker",
                    -- why this doesn't have duration field? if there's no duration the script will detect the animation total duration automatically..
                }
            },
            {
                event = "av_drugs:interaction",
                label = Lang['cut_station'],
                coords = {x = 4.62, y = -2.83, z = 1.54, heading = -182.84},
                ingredients = {
                    {name = "meth_tray", amount = 1}
                },
                output = {
                    {name = "meth_batch", amount = 2}
                },
                animation = {
                    dict = "anim@amb@business@coc@coc_unpack_cut@",
                    anim = "fullcut_cycle_v7_cokecutter",
                    duration = 30000,
                }
            },
            {
                event = "av_drugs:interaction",
                label = Lang['packaging_station'],
                coords = {x = 4.43, y = 2.97, z = 1.54, heading = -2.08},
                ingredients = {
                    {name = "meth_batch", amount = 1}
                },
                output = {
                    {name = "meth_baggy", amount = 50}
                },
                animation = {
                    dict = "anim@amb@business@coc@coc_unpack_cut@",
                    anim = "fullcut_cycle_v7_cokecutter",
                    duration = 30000,
                }
            },
        }
    },
    ['cokelab'] = { -- unique key index
        drug = "coke", -- drug name linked to this lab
        shellModel = 'shell_coke2', -- shell model
        interactions = {
            {
                event = "av_drugs:labStash", -- stash zone
                label = Lang['stash_zone'],
                coords = {x = 8.26, y = 3.09, z = 1.78, heading = -344.5},
            },
            {
                event = "av_drugs:labPC", -- laptop zone
                label = Lang['pc'],
                coords = {x = -8.02, y = -0.96, z = 1.54, heading = -87.29},
            },
            {
                event = "av_drugs:cook",
                label = Lang['cook_station'],
                coords = {x = 4.36, y = 3.08, z = 1.54, heading = -0.69},
                ingredients = { -- required items for this station
                    {name = "water", amount = 4},
                    {name = "burger", amount = 4},
                },
                output = {
                    {name = "coke_tray", amount = 2}
                },
                animation = {
                    dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
                    anim = "chemical_pour_long_cooker",
                    -- why this doesn't have duration field? if there's no duration the script will detect the animation total duration automatically..
                }
            },
            {
                event = "av_drugs:interaction",
                label = Lang['cut_station'],
                coords = {x = 5.95, y = -2.71, z = 1.54, heading = -179.26},
                ingredients = {
                    {name = "coke_tray", amount = 1}
                },
                output = {
                    {name = "coke_batch", amount = 2}
                },
                animation = {
                    dict = "anim@amb@business@coc@coc_unpack_cut@",
                    anim = "fullcut_cycle_v7_cokecutter",
                    duration = 30000,
                }
            },
            {
                event = "av_drugs:interaction",
                label = Lang['packaging_station'],
                coords = {x = 0.68, y = -0.47, z = 1.54, heading = -0.41},
                ingredients = {
                    {name = "coke_batch", amount = 1}
                },
                output = {
                    {name = "coke_baggy", amount = 50}
                },
                animation = {
                    dict = "anim@amb@business@coc@coc_unpack_cut@",
                    anim = "fullcut_cycle_v7_cokecutter",
                    duration = 30000,
                }
            },
            {
                event = "av_drugs:interaction",
                label = Lang['packaging_station'],
                coords = {x = -4.56, y = -0.48, z = 1.54, heading = -0.53},
                ingredients = {
                    {name = "coke_batch", amount = 1}
                },
                output = {
                    {name = "coke_baggy", amount = 50}
                },
                animation = {
                    dict = "anim@amb@business@coc@coc_unpack_cut@",
                    anim = "fullcut_cycle_v7_cokecutter",
                    duration = 30000,
                }
            },
        }
    },
    ['lsdlab'] = { -- unique key index
        drug = "lsd", -- drug name linked to this lab
        shellModel = 'k4mb1_acid2_shell', -- shell model
        interactions = {
            {
                event = "av_drugs:labStash", -- stash zone
                label = Lang['stash_zone'],
                coords = {x = -4.27, y = -1.13, z = 2.51, heading = -92.59},
            },
            {
                event = "av_drugs:labPC", -- laptop zone
                label = Lang['pc'],
                coords = {x = 3.63, y = 1.23, z = 2.51, heading = -279.43},
            },
            {
                event = "av_drugs:cook",
                label = Lang['cook_station'],
                coords = {x = -0.59, y = -1.11, z = 2.11, heading = -185.82},
                ingredients = { -- required items for this station
                    {name = "water", amount = 4},
                    {name = "burger", amount = 4},
                },
                output = {
                    {name = "lsd_sheet", amount = 2}
                },
                animation = {
                    dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
                    anim = "chemical_pour_long_cooker",
                    -- why this doesn't have duration field? if there's no duration the script will detect the animation total duration automatically..
                }
            },
            {
                event = "av_drugs:interaction",
                label = Lang['packaging_station'],
                coords = {x = 1.96, y = 1.08, z = 2.51, heading = -88.05},
                ingredients = {
                    {name = "lsd_sheet", amount = 1}
                },
                output = {
                    {name = "lsd_stamp", amount = 24}
                },
                animation = {
                    dict = "anim@amb@business@coc@coc_unpack_cut@",
                    anim = "fullcut_cycle_v7_cokecutter",
                    duration = 30000,
                }
            },
        }
    },
}