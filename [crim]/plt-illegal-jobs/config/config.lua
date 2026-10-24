Config = {}

Config.Locale = 'auto' -- 'auto' | 'en' | 'es' | 'fr' | 'de' | 'pt-br' | ...

Config.OpenKey = 'F5'
Config.OpenCommand = '-darknet'

Config.ExpandJobInfoBoxKey = 'B'
Config.JobInfoBoxAlign = 'left'


--[[
  Target system used for all ped/vehicle/object/zone interactions.
  System   = 'auto'  -> use ox_target if running, else qb-target if running, else the built-in [E] prompt
             'ox'     -> force ox_target (falls back to [E] prompt if ox_target isn't running)
             'qb'     -> force qb-target (falls back to [E] prompt if qb-target isn't running)
             'disabled' / 'e' -> always use the built-in [E] prompt, even if a target resource is running
  ForceE   = true to always show the [E] prompt alongside (or instead of) the target resource.
  EKey     = control id used for the built-in prompt (38 = E).
  EKeyLabel = label shown in the built-in prompt, e.g. "[E] Open Trunk".
]]
Config.Target = {
    System = 'auto',
    ForceE = false,
    EKey = 38,
    EKeyLabel = '[E] %s',
}

Config.Item = {
    Name = 'darknet_tablet',
    Framework = 'ox',   -- Qbox + ox_inventory
    OnlyViaItem = false, -- F5 / command still work when player has the tablet
    RequireItem = true,  -- must have darknet_tablet to open OS
    UseAnimation = true,
    Prop = `prop_cs_tablet`,
    DebugGive = false,   -- /givetablet for testing
}

-- Physical VPN dongle — without this item the VPN app cannot connect
Config.Vpn = {
    Name = 'darknet_vpn',
    RequireItem = true,
}

Config.Boosting = {
    ContractsPerClass = {
        d     = 3,
        c     = 3,
        b     = 3,
        a     = 3,
        aplus = 2,
        s     = 2,
        splus = 2,
    },
    Timing = {
        PhaseWithTracker    = 1500,
        PhaseWithoutTracker = 1700,
    },
}

-- XP thresholds per level (index = level number)
Config.Levels = { 0, 1000, 2000, 4000, 8000, 10000, 15000 }


Config.Admin = {
    Restricted = 'group.admin',
    --[[
      /illegallevel [id] [1-5]
        1 Street · 2 Courier · 3 Specialist · 4 Operator · 5 Elite
      Raises XP level and unlocks mission apps for that progression rank.
    ]]
}

-- Police job names used for minimum-cop checks
Config.PoliceJobName = {
    ['police']  = true,
}

-- Money types for job payouts
Config.DirtyMoney = {
    isItem      = true,
    itemName    = 'black_money',
    accountName = 'black_money',
    label       = 'Black Money',
}
Config.CleanMoney = {
    isItem      = true,
    itemName    = 'cash',
    accountName = 'cash',
    label       = 'Cash',
}

-- One active run per job key across the whole server (crew or solo).
-- Others join a wait queue until that run finishes/aborts.
-- Always exempt: money_laundering + all corner_* jobs.
Config.JobRunQueue = {
    Enabled = true,
    Exempt = {
        -- 'rob_npc',
    },
}

Config.DefaultRoutingBucket = 0

--[[
  Darknet OS apps — set any entry to false to hide it from the tablet desktop.
  Keys match web/src/data/apps.js ids. Missing keys default to enabled.
]]
Config.Apps = {
    -- System
    trash = true,
    settings = true,
    vpn = true,
    browser = true,
    market = true,
    skills = true,
    crew = true,
    crypto = true,
    robnpc = false,

    -- Job apps
    boosting = true,           -- Vehicle Delivery / car theft
    chopshop = true,
    deliveryweed = true,
    deliverymeth = true,
    deliverycoke = true,
    cornerweed = true,
    cornermeth = true,
    cornercoke = true,
    corneroxy = true,
    counterfeit = true,
    illegaldiving = true,
    fraud = true,
    gunsmuggling = false,
    moneylaundering = false, --  (not a mission)
    moonshine = true,
    npcboxing = true,

    -- New mission apps
    gruppe6heist = true,
    kidnapping = true,
    cryptodistro = true,
    deliverycontainer = true,
    helicargo = false,
    carbreakin = true,

    -- Wave 2 mission apps
    druglabraid = true,
    weaponsairdrop = true,
    docforgery = true,
    marinasmuggle = true,
    safehousedefense = true,
    trainheist = true,
    atmdrilling = true,
    damsabotage = true,
    getawaydriver = true,
}

--[[
    World HUD — minigames, progress bars, notifications
    difficulty: 1 (easy) .. 5 (brutal)
    Progress duration is in milliseconds unless synced to an animation (pass duration at runtime).
]]
Config.UI = {
    Notify = {
        DefaultDuration = 4000,
    },

    Minigame = {
        AllowCancel = true,
        DefaultDifficulty = 2,
        ChainDelay = 250,
        ChainStopOnFail = true,

        -- Global defaults per minigame id (overridden by Config.UI.Jobs).
        -- Game pack lives in web/public/engine (bundled canvas minigames).
        Games = {
            skillcheck   = { difficulty = 2, rounds = 2 },
            lockpick     = { difficulty = 3, pins = 3 },
            hotwire      = { difficulty = 2 },
            quicktime    = { difficulty = 2, length = 6 },
            decrypt      = { difficulty = 3, rounds = 4 },
            dataheist    = { difficulty = 2, packets = 5 },
            chopshop     = { difficulty = 2, parts = 3 },
            reaction     = { difficulty = 2, rounds = 2 },
            vaultdrill   = { difficulty = 1 },
            welding      = { difficulty = 3 },
            cashcount    = { difficulty = 2 },
            breachmatrix = { difficulty = 3 },
            keypad       = { difficulty = 2 },
            locksmith    = { difficulty = 3 },
            thermite     = { difficulty = 3 },
            ghostsignal  = { difficulty = 2 },
            terminalbypass = { difficulty = 1 },
        },
    },

    ProgressBar = {
        DefaultDuration = 15000,
        CanCancel = false,
        UseWhileDead = false,
        Disable = {
            car = true,
            combat = true,
            move = true,
            sprint = true,
        },
    },

    -- Job progress HUD — tablet widget (recommended) or legacy floating panel
    JobProgress = {
        WidgetEnabled = true,        -- Show as widget on tablet desktop (right rail)
        FloatingEnabled = false,     -- Legacy floating HUD on left side of screen
        ShowWhenTabletClosed = false, -- When floating is enabled, show it while tablet is closed
    },

    -- Per-job action overrides (minigame / progress)
    Jobs = {
        chop_shop = {
            unlockVehicle = {
                minigame = { game = 'locksmith', difficulty = 3 },
                progress = { duration = 4000, canCancel = false },
            },
        },

        car_theft = {
            unlockVehicle = {
                minigame = { game = 'hotwire', difficulty = 3 },
                progress = { duration = 4000, canCancel = false },
            },
        },

        gun_smuggling = {
            hotwireForklift = {
                minigame = { game = 'hotwire', difficulty = 2 },
                progress = { duration = 4000, canCancel = true },
            },
            forceOpen = {
                minigame = { game = 'locksmith', difficulty = 3, pins = 4 },
            },
            deliverCrate = {
                progress = { duration = 5000, canCancel = false },
            },
        },

        delivery_weed = {
            unlockVehicle = {
                minigame = { game = 'lockpick', difficulty = 2 },
                progress = { duration = 3500, canCancel = false },
            },
        },
        delivery_meth = {
            unlockVehicle = {
                minigame = { game = 'lockpick', difficulty = 2 },
                progress = { duration = 3500, canCancel = false },
            },
        },
        delivery_coke = {
            unlockVehicle = {
                minigame = { game = 'lockpick', difficulty = 3 },
                progress = { duration = 4000, canCancel = false },
            },
        },

        delivery_container = {
            openContainer = {
                minigame = { game = 'breachmatrix', difficulty = 4 },
                progress = { duration = 5500, canCancel = false },
            },
            lootContainer = {
                progress = { duration = 4000, canCancel = false },
            },
        },

        gruppe6_heist = {
            thermite = {
                minigame = { game = 'thermite', difficulty = 3, rounds = 3 },
                progress = { duration = 5000, canCancel = false },
            },
            loot = {
                progress = { duration = 4500, canCancel = false },
            },
        },

        kidnapping = {
            restrain = {
                progress = { duration = 3500, canCancel = true },
            },
            hotwireVan = {
                minigame = { game = 'hotwire', difficulty = 2 },
                progress = { duration = 4000, canCancel = true },
            },
        },

        crypto_distribution = {
            unlockVehicle = {
                minigame = { game = 'lockpick', difficulty = 2 },
                progress = { duration = 3500, canCancel = false },
            },
            holdSignal = {
                minigame = { game = 'ghostsignal', difficulty = 2, rounds = 2 },
            },
            hackNode = {
                minigame = { game = 'dataheist', difficulty = 3, rounds = 3 },
            },
        },

        heli_cargo = {
            unlockVehicle = {
                minigame = { game = 'locksmith', difficulty = 3 },
                progress = { duration = 4000, canCancel = false },
            },
        },

        rob_npc = {
            rob = {
                progress = {
                    duration = 2200,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a',
                        flag = 49,
                    },
                },
            },
            lootBody = {
                progress = {
                    duration = 2800,
                    canCancel = true,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'amb@medic@standing@kneel@base',
                        clip = 'base',
                        flag = 1,
                    },
                },
            },
        },

        car_breakin = {
            smashWindow = {
                minigame = { game = 'quicktime', difficulty = 2, length = 5 },
                progress = {
                    duration = 2500,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                        clip = 'machinic_loop_mechandplayer',
                        flag = 49,
                    },
                },
            },
        },

        drug_lab_raid = {
            processMix = {
                progress = {
                    duration = 9000,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'anim@amb@business@coc@coc_unpack_cut@',
                        clip = 'fullcut_cycle_v1_cokecutter',
                        flag = 1,
                    },
                },
            },
            processCook = {
                progress = {
                    duration = 14000,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
                        clip = 'chemical_pour_short_cooker',
                        flag = 1,
                    },
                },
            },
            processCool = {
                progress = {
                    duration = 8000,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_ped',
                        flag = 1,
                    },
                },
            },
            processBag = {
                progress = {
                    duration = 8000,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    anim = {
                        dict = 'anim@amb@business@coc@coc_unpack_cut@',
                        clip = 'fullcut_cycle_v1_cokepacker',
                        flag = 1,
                    },
                },
            },
            collectYield = {
                progress = {
                    duration = 4500,
                    canCancel = false,
                    disable = { move = true, car = true, combat = true },
                    -- Bend-down pickup of baggies from the yield table
                    anim = {
                        dict = 'pickup_object',
                        clip = 'pickup_low',
                        flag = 1,
                    },
                },
            },
        },

        weapons_airdrop = {
            openCrate = {
                minigame = { game = 'locksmith', difficulty = 2 },
                progress = { duration = 4000, canCancel = false },
            },
        },

        document_forgery = {
            pickupMaterials = {
                progress = { duration = 3000, canCancel = false },
            },
            -- Paper handoff to forger: minigame gate + give/take emote
            handMaterials = {
                minigame = { game = 'terminalbypass' },
                progress = {
                    duration = 2800,
                    canCancel = false,
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a',
                        flag = 49,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
            collectDocs = {
                progress = { duration = 3000, canCancel = false },
            },
            -- Finished docs handoff to street buyers
            deliverDocs = {
                progress = {
                    duration = 2800,
                    canCancel = false,
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a',
                        flag = 49,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
        },

        marina_smuggling = {
            unlockVehicle = {
                minigame = { game = 'hotwire', difficulty = 2 },
                progress = { duration = 3500, canCancel = false },
            },
            lootCrate = {
                minigame = { game = 'locksmith', difficulty = 3, pins = 4 },
                progress = {
                    duration = 6500,
                    canCancel = false,
                    anim = {
                        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                        clip = 'machinic_loop_mechandplayer',
                        flag = 49,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
            unloadCargo = {
                progress = {
                    duration = 3500,
                    canCancel = false,
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a',
                        flag = 49,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
        },

        getaway_driver = {
            unlockVehicle = {
                minigame = { game = 'hotwire', difficulty = 2 },
                progress = { duration = 3500, canCancel = false },
            },
        },

        train_heist = {
            cutDoor = {
                progress = { duration = 1000, canCancel = false },
            },
            grabGold = {
                progress = { duration = 1000, canCancel = false },
            },
        },

        atm_drilling = {
            -- Mission type: drill
            drill = {
                minigame = { game = 'vaultdrill', difficulty = 1, rounds = 2 },
                progress = {
                    duration = 8000,
                    canCancel = false,
                    anim = {
                        dict = 'anim@heists@fleeca_bank@drilling',
                        clip = 'drill_straight_idle',
                        flag = 1,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
            -- Mission type: rope pull
            attachRope = {
                minigame = { game = 'welding', difficulty = 1, length = 4 },
                progress = {
                    duration = 3500,
                    canCancel = false,
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_ped',
                        flag = 1,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
            loot = {
                minigame = { game = 'cashcount', difficulty = 1, rounds = 1 },
                progress = {
                    duration = 3500,
                    canCancel = false,
                    anim = {
                        dict = 'anim@heists@ornate_bank@grab_cash',
                        clip = 'grab',
                        flag = 1,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
            -- Mission type: fake card bypass
            cardBypass = {
                minigame = { game = 'terminalbypass' },
                progress = {
                    duration = 4000,
                    canCancel = false,
                    anim = {
                        dict = 'mp_common',
                        clip = 'givetake1_a',
                        flag = 49,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
            cardLoot = {
                progress = {
                    duration = 4500,
                    canCancel = false,
                    anim = {
                        dict = 'anim@heists@ornate_bank@grab_cash',
                        clip = 'grab',
                        flag = 1,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
        },

        dam_sabotage = {
            plantCharge = {
                -- Wire-cut style arming before the C4 plant anim
                minigame = { game = 'cuttheright', difficulty = 3 },
                progress = {
                    duration = 5000,
                    canCancel = false,
                    -- Full-body C4 plant (same ornate-bank charge scene as heist C4)
                    anim = {
                        dict = 'anim@heists@ornate_bank@thermal_charge',
                        clip = 'thermal_charge',
                        flag = 1,
                    },
                    disable = { move = true, car = true, combat = true },
                },
            },
        },

        fraud = {
            insertDevice = {
                progress = { duration = 3000, canCancel = false },
            },
            captureData = {
                minigame = { game = 'dataheist', difficulty = 3, packets = 5 },
            },
            duplicateCard = {
                minigame = { game = 'decrypt', difficulty = 4, rounds = 5 },
            },
        },

        moonshine = {
            crushFruit = {
                progress = { duration = 10000, canCancel = false },
            },
            blendFruit = {
                progress = { duration = 5000, canCancel = false },
            },
        },

        money_laundering = {
            washMoney = {
                -- duration synced to animation at runtime; config controls cancel/disable only
                progress = { canCancel = false },
            },
        },

        counterfeit_money = {
            placePaper = {
                progress = { canCancel = false },
            },
            cutPaper = {
                progress = { canCancel = false, disable = { move = true, car = true, combat = true } },
            },
            packMoney = {
                progress = { canCancel = false, disable = { move = true, car = true, combat = true } },
            },
        },
    },
}

Config.debug = false
