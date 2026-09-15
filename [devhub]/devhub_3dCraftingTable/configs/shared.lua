Shared = {} 

-- Debug configuration
Shared.Debug = {
    Enabled = false, -- Set to false to disable all debug prints
    Levels = {
        Info = true,    -- General information
        Success = true, -- Success operations
        Warning = true  -- Warning and potential issues
    }
}

Shared.Lang = {
    ["missing_items"] = "You don't have all needed items",
    ["menu_closed"] = "You closed the menu",
    ["left"] = "LEFT",
    ["right"] = "RIGHT",
    ["enter"] = "ENTER",
    ["select"] = "SELECT",
}
 

-- Integration with DevHub Skill Tree
-- Set to true only if you're using our skill tree system
-- Purchase at: https://store.devhub.gg/product/6440792-1
Shared.DEVHUB_SKILLTREE_ENABLED = false
--  "devhub_3dCraftingTable:useTable:client"

Shared.MultipleRecipes = {
    ["craft1"] = { -- example recipe
        itemsNeeded = {
            {
                name = "water",
                amount = 1,
            },
        },
        rewards = {
            {
                name = "burger",
                amount = 1,
            }, 
        },
        tableUid = "spices",
        handler = function()
            -- Return true to show this recipe in 3D UI, false to hide it
            
            -- Example conditions:
            -- Check player level, job, items, permissions, etc.
            
            return true
        end,
    },
}
 
Shared.Recepie = { 
    ["spices"] = {
        ["rewards"] = {
        },
        ["neededItems"] = {
        },
        ["prop"] = "devhub_alchemy_table",
        ["props"] = {
            [1] = {
                ["staticModel"] = true,
                ["defaultPosition"] = {
                    ["rotation"] = {
                        [1] = 0,
                        [2] = 0,
                        [3] = 0,
                    },
                    ["offset"] = {
                        [1] = 0.1175537109375,
                        [2] = -0.149658203125,
                        [3] = 0.36103439331055,
                    },
                    ["depth"] = 2.17,
                    ["preview"] = false,
                },
                ["changeModel"] = {
                    ["preview"] = false,
                    ["rotation"] = {
                        [1] = 0,
                        [2] = 0,
                        [3] = 0,
                    },
                    ["step"] = "5",
                    ["offset"] = {
                        [1] = 0.11756896972656,
                        [2] = -0.1478271484375,
                        [3] = 0.36341094970703,
                    },
                    ["depth"] = 2.17,
                    ["prop"] = "v_res_foodjara",
                },
                ["prop"] = "v_res_foodjarb",
            },
            [2] = {
                ["effects"] = {
                    ["sound"] = "",
                    ["delete"] = "1",
                    ["wait"] = "1500",
                    ["particleLib"] = "",
                    ["scale"] = "1.0",
                    ["particleName"] = "",
                },
                ["defaultPosition"] = {
                    ["rotation"] = {
                        [1] = 1,
                        [2] = 13,
                        [3] = 0,
                    },
                    ["offset"] = {
                        [1] = 0.49971008300781,
                        [2] = -0.74053955078125,
                        [3] = 0.40755462646484,
                    },
                    ["depth"] = 1.7,
                    ["preview"] = false,
                },
                ["endPosition"] = {
                    ["rotation"] = {
                        [1] = 0,
                        [2] = 0,
                        [3] = 0,
                    },
                    ["offset"] = {
                        [1] = 0.39549255371094,
                        [2] = -0.46575927734375,
                        [3] = 0.48587417602539,
                    },
                    ["depth"] = 1.84,
                    ["preview"] = false,
                },
                ["prop"] = "devhub_plant_medicinal_plantain",
            },
            [3] = {
                ["effects"] = {
                    ["sound"] = "",
                    ["delete"] = "1",
                    ["wait"] = "1500",
                    ["particleLib"] = "",
                    ["scale"] = "1.0",
                    ["particleName"] = "",
                },
                ["defaultPosition"] = {
                    ["rotation"] = {
                        [1] = -84,
                        [2] = 0,
                        [3] = 44,
                    },
                    ["offset"] = {
                        [1] = 0.75520324707031,
                        [2] = -0.6016845703125,
                        [3] = 0.38826751708984,
                    },
                    ["depth"] = 1.85,
                    ["preview"] = false,
                },
                ["endPosition"] = {
                    ["rotation"] = {
                        [1] = 0,
                        [2] = 0,
                        [3] = 0,
                    },
                    ["offset"] = {
                        [1] = 0.40164184570312,
                        [2] = -0.52935791015625,
                        [3] = 0.38321685791016,
                    },
                    ["depth"] = 1.86,
                    ["preview"] = false,
                },
                ["prop"] = "prop_single_rose",
            },
            [4] = {
                ["effects"] = {
                    ["position"] = {
                        ["offset"] = {
                            [1] = 0.38629150390625,
                            [2] = -0.43865966796875,
                            [3] = 0.39352798461914,
                        },
                        ["rotation"] = {
                            [1] = 0,
                            [2] = 0,
                            [3] = 0,
                        },
                    },
                    ["sound"] = "",
                    ["delete"] = "1",
                    ["wait"] = "3500",
                    ["particleLib"] = "core",
                    ["scale"] = "0.1",
                    ["particleName"] = "exp_grd_bzgas_smoke",
                },
                ["defaultPosition"] = {
                    ["rotation"] = {
                        [1] = 8,
                        [2] = 8,
                        [3] = 110,
                    },
                    ["offset"] = {
                        [1] = 0.02423095703125,
                        [2] = -0.661376953125,
                        [3] = 0.37027359008789,
                    },
                    ["depth"] = 1.79,
                    ["preview"] = false,
                },
                ["endPosition"] = {
                    ["rotation"] = {
                        [1] = 52,
                        [2] = 4,
                        [3] = 24,
                    },
                    ["offset"] = {
                        [1] = 0.32524108886719,
                        [2] = -0.48223876953125,
                        [3] = 0.54174423217773,
                    },
                    ["depth"] = 1.79,
                    ["preview"] = false,
                },
                ["prop"] = "bkr_prop_coke_spoon_01",
            },
            [5] = {
                ["effects"] = {
                    ["sound"] = "",
                    ["delete"] = "1",
                    ["wait"] = "2500",
                    ["particleLib"] = "",
                    ["scale"] = "1.0",
                    ["particleName"] = "",
                },
                ["defaultPosition"] = {
                    ["rotation"] = {
                        [1] = 0,
                        [2] = 0,
                        [3] = 0,
                    },
                    ["offset"] = {
                        [1] = 0.38687133789062,
                        [2] = -0.53228759765625,
                        [3] = 0.34997177124023,
                    },
                    ["depth"] = 1.88,
                    ["preview"] = false,
                },
                ["endPosition"] = {
                    ["rotation"] = {
                        [1] = 0,
                        [2] = -91,
                        [3] = 0,
                    },
                    ["offset"] = {
                        [1] = 0.31306457519531,
                        [2] = -0.17999267578125,
                        [3] = 0.79732894897461,
                    },
                    ["depth"] = 1.9,
                    ["preview"] = false,
                },
                ["prop"] = "bkr_prop_coke_mortalpestle",
            },
        },
    },
}