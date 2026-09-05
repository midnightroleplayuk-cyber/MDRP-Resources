-- ⚠️ Each mission must be configured using the structure below! ⚠️

--- @param type: car / weapon / money / black_money / item
--- Description:
---   - "car" → Must be a vehicle available in the Vehicle Store. Otherwise, it will not appear.
---   - To assign a vehicle as a mission reward, enable "vehicle visibility" from the Admin Panel
---     and provide the model name using:
---       @param ModelName

-- 💡 Mission-related functions are located in:
--    config/Missions/MissionsFunctions.lua

-- 💡 Optional: restrict a mission to selected gangs only
--    AllowedGangs = { 1, 5, 12 },  -- gang/org IDs; empty/nil = available to every gang
--    Works together with CanRecieveMission (both must pass).

Config.DisableMissions = false -- Disable / Enable missions tab from crime tablet

Config.Missions = {
    -- Note: Metadata currently work only for ox_inventory. If you want to make metadata compatible with your inventory script:
    -- Files that need to be edited: `integrations/server/inventory/` and one of `framework/server` function Fr.AddItem
    
    ["find_vehicle"] = {
        UI = {
            levelRequired = 15,
            maxLevel = 100,
            missionLabel = "Find a Vehicle on the Street",
            missionDescription = "Find the vehicle model we send you and bring it back without damaging it.",
            missionExp = 100,
            missionReward = {
                {
                    label = "AMMO 9mm x50",
                    nameSpawn = "pistol_ammo",
                    amount = 50,
                    img = "https://cdn3d.iconscout.com/3d/premium/thumb/ammo-3d-icon-download-in-png-blend-fbx-gltf-file-formats--ammunition-case-metal-box-bullet-military-pack-weapon-icons-9555390.png",
                    rare = "red",
                    type = "item",
                },
            }
        },
        -- AllowedGangs = { 1, 2 }, -- uncomment to limit this mission to gang IDs 1 and 2
        OnMissionStart = function()
            startFindVehicleMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["laundry_100k"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Money Laundering",
            missionDescription = "Launder $100,000 of dirty money at a laundering point. Your gang must unlock the laundering upgrade.",
            missionExp = 250,
            missionReward = {
                {
                    label = "1x Pistol SNS",
                    nameSpawn = "weapon_snspistol",
                    amount = 1,
                    img = "https://data.otherplanet.dev/fivemicons/%5bweapons%5d/weapon_vintagepistol.png",
                    rare = "purple",
                    type = "item"
                }
            }
        },
        OnMissionStart = function()
            startLaundryMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["capture_1Zone"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Capture at Least 1 Zone",
            missionDescription = "Capture at least one zone to claim extra rewards and EXP for your gang.",
            missionExp = 150,
            missionReward = {
                {
                    label = "5 000$",
                    nameSpawn = "",
                    amount = 5000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startZoneCaptureMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["spray_graffiti"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Graffiti Mission",
            missionDescription = "Spray at least 3 graffiti in assigned turf zones.",
            missionExp = 180,
            missionReward = {
                {
                    label = "5 000$",
                    nameSpawn = "",
                    amount = 5000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startSprayGraffitiMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["remove_graffiti"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Graffiti Removal Mission",
            missionDescription = "Remove at least 5 enemy gang graffiti in assigned turf zones.",
            missionExp = 180,
            missionReward = {
                {
                    label = "5 000$",
                    nameSpawn = "",
                    amount = 5000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startRemoveGraffitiMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["sell_drugs"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Sell Drugs",
            missionDescription = "Sell drugs to 50 people using any selected drug inside a turf zone.",
            missionExp = 180,
            missionReward = {
                {
                    label = "5 000$",
                    nameSpawn = "",
                    amount = 5000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startSellingDrugsMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["steal_van"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Steal Drug Van",
            missionDescription = "Steal a drug van from an armed gang and deliver it safely.",
            missionExp = 180,
            missionReward = {
                {
                    label = "1x SNS Pistol",
                    nameSpawn = "weapon_snspistol",
                    amount = 1,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "purple",
                    type = "item"
                }
            }
        },
        OnMissionStart = function()
            deliverVanMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["armored_truck_heist"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Armored Truck Heist",
            missionDescription = "Phase 1: steal the stockade. Phase 2: open the rear door in a safe zone. Phase 3: deliver the cargo.",
            missionExp = 320,
            missionReward = {
                {
                    label = "15 000$",
                    nameSpawn = "",
                    amount = 15000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "purple",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startArmoredTruckHeistMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["intercept_convoy"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Intercept NPC Convoy",
            missionDescription = "Intercept an armed convoy, steal the target rumpo3, and deliver it to the marked point.",
            missionExp = 280,
            missionReward = {
                {
                    label = "1x Pistol",
                    nameSpawn = "weapon_pistol",
                    amount = 1,
                    img = "https://data.otherplanet.dev/fivemicons/%5bweapons%5d/weapon_pistol.png",
                    rare = "purple",
                    type = "item"
                },
                {
                    label = "5 000$",
                    nameSpawn = "",
                    amount = 5000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "purple",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startConvoyInterceptMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["coast_air_contraband"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Coast/Air Contraband",
            missionDescription = "Pick up the package on the coast and deliver it inland with no active wanted level.",
            missionExp = 240,
            missionReward = {
                {
                    label = "10 000$",
                    nameSpawn = "",
                    amount = 10000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startCoastAirContrabandMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["drug_sell_npc"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Drug Delivery",
            missionDescription = "Deliver 50g of marijuana to the marked location.",
            missionExp = 120,
            missionReward = {
                {
                    label = "5 000$",
                    nameSpawn = "",
                    amount = 5000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "purple",
                    type = "money"
                }
            }
        },
        ItemName = "weed", -- Item name to sell to ped.
        OnMissionStart = function()
            startWeedDelivey()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["mobile_lab_assault"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Mobile Lab Assault",
            missionDescription = "Intercept a mobile lab, survive armed pursuit, and deliver it to a safe zone.",
            missionExp = 360,
            missionReward = {
                {
                    label = "18 000$",
                    nameSpawn = "",
                    amount = 18000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "purple",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startMobileLabAssaultMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["recover_stash_raid"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Recover Stash After Raid",
            missionDescription = "Recover a stash seized in a raid and deliver it before you lose it.",
            missionExp = 290,
            missionReward = {
                {
                    label = "12 000$",
                    nameSpawn = "",
                    amount = 12000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startRecoverStashAfterRaidMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },
    ["multi_checkpoint_delivery"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Multi Delivery x3",
            missionDescription = "Complete 3 checkpoints with the cargo before time runs out.",
            missionExp = 300,
            missionReward = {
                {
                    label = "15 000$",
                    nameSpawn = "",
                    amount = 15000,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "purple",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startMultiCheckpointDeliveryMission()
        end,
        CanRecieveMission = function(jobId)
            return true
        end,
    },

    --[[ 

    -------------------------------------------------
    -- ONLY FOR VEHICLE THEFT SCRIPT ----------------
    -- https://www.otherplanet.dev/product/6503031 --
    -------------------------------------------------

    ["vehicleTheft"] = {
        UI = {
            levelRequired = 1,
            maxLevel = 100,
            missionLabel = "Complete Vehicle Theft Hacking",
            missionDescription = "Start and complete vehicle theft hacking proccess.",
            missionExp = 350,
            missionReward = {
                {
                    label = "50 000$",
                    nameSpawn = "",
                    amount = 15,
                    img = "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
                    rare = "blue",
                    type = "money"
                }
            }
        },
        OnMissionStart = function()
            startVehicleTheftMission()
        end,
    },]]--
}