---@type Job
return {
    -- Minimum required level to start the job
    level = 1,

    -- Job title displayed in the UI
    label = locale('counterfeit_money.label'),

    -- Short mission description
    description = locale('counterfeit_money.description'),

    -- UI image for the mission
    image = 'counterfeit_money.png',

    -- Rewards for completing the mission. Granted once, when the player leaves
    -- the facility (client getOutsideLab triggers finishJob). Black money itself
    -- is handed out per-batch in onPacking, not here.
    reward = {
        exp = 50,
        money = 'Random'
    },

    -- Restart cooldown applied per player when the job finishes or is manually stopped.
    -- One attempt per day.
    cooldown = { enabled = true, minutes = 1440 },

    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,

    -- Additional info or lore for the mission
    information = locale('counterfeit_money.information'),

    -- Step-by-step instructions for the mission
    steps = {
        { label = locale('counterfeit_money.steps.1'), },
        { label = locale('counterfeit_money.steps.2'), timeLimit = 60 * 30, },
    },

    -- Blips (optional)
    blips = {
        lab_location = { sprite = 500, color = 3, text = locale('counterfeit_money.blips.lab_location') },
    },

    -- Checked at job start so players can't enter the lab and get stuck at
    -- the placePaperScene stage without a sheet in hand. Not consumed here —
    -- game.placePaperScene.requiredItems still removes it mid-job.
    requiredItems = {
        ['money_sheet'] = { itemName = 'money_sheet', label = 'Money Sheet' },
    },

    -- Game mechanics and settings
    game = {
        police_alert_chance = 0.2, -- 20% chance to alert police when packing counterfeit money

     
        useShellInterior = true, -- true = use shell interior, false = use mlo interior

        shell_interior = {
            coords = vector3(1121.897, -3195.338, -40.4025),
            entrance = vector4(1137.7310, -3196.8601, -39.6657, 80.7380),
            exitPoint = vector3(1138.0, -3198.96, -39.68),
            -- Biker DLC counterfeit cash factory (same as bob74_ipl)
            ipl = 'bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo',
        },

        shell_interior_lab_locations = {
            vector3(84.04, -1551.96, 29.6),
            vector3(-1083.1752, -1262.0634, 5.5935),
        },

        mlo_interior_lab_locations = {
            vector3(198.9336, 2459.0754, 55.6908), -- MLO interior location 1 - [bamboozled barnlab]
        },

        placePaperScene = {
            requiredItems = {
                { label = 'Money Sheet', itemName = 'money_sheet', count = 1 },
            },
            rewardItems = {
                { label = 'Uncutted Money', itemName = 'uncutted_money', count = 8 },
            },
            coords = {
                mlo_interior = {},
                shell_interior = {
                    {
                        coords = vector3(1134.33, -3197.23, -39.67),
                        offset = vector3(-1.0, 1.0, -1.0),
                        rotation = vector3(0.0, 0.0, 180.0)
                    },
                    {
                        coords = vector3(1132.94, -3197.27, -39.67),
                        offset = vector3(-1.0, 1.0, -1.0),
                        rotation = vector3(0.0, 0.0, 180.0)
                    },
                    {
                        coords = vector3(1131.37, -3197.28, -39.67),
                        offset = vector3(-1.0, 1.0, -1.0),
                        rotation = vector3(0.0, 0.0, 180.0)
                    },
                    {
                        coords = vector3(1129.88, -3197.29, -39.67),
                        offset = vector3(-1.0, 1.0, -1.0),
                        rotation = vector3(0.0, 0.0, 180.0)
                    },
                    {
                        coords = vector3(1128.52, -3197.31, -39.67),
                        offset = vector3(-1.0, 1.0, -1.0),
                        rotation = vector3(0.0, 0.0, 180.0)
                    },
                },
            }
        },

        cuttingScene = {
            requiredItems = {
                { label = 'Uncutted Money', itemName = 'uncutted_money', count = 8 },
            },
            rewardItems = {
                { label = 'Cutted Money', itemName = 'cutted_money', count = 16 },
            },
            coords = {
                mlo_interior = {},
                shell_interior = {
                    {
                        coords = vector3(1122.41, -3197.88, -40.39),
                        offset = vector3(2.29, 0.66, -0.6),
                        rotation = vector3(0.0, 0.0, 180.0),
                    },
                },
            }
        },

        packingScene = {
            requiredItems = {
                { label = 'Cutted Money', itemName = 'cutted_money', count = 16 },
            },
            rewardItems = {
                { label = 'Black Money', itemName = Config.DirtyMoney.itemName, count = 16 },
            },
            coords = {
                mlo_interior = {},
                shell_interior = {
                    {
                        coords = vector3(1116.66, -3195.75, -40.4),
                        offset = vector3(-0.8, 0.9, -0.59),
                        rotation = vector3(0.0, 0.0, 90.0)
                    },
                    {
                        coords = vector3(1116.71, -3194.42, -40.4),
                        offset = vector3(-0.8, 0.95, -0.59),
                        rotation = vector3(0.0, 0.0, 90.0)
                    },
                },
            }
        },
    },

    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `a_m_m_business_01`,
        coords   = vec4(-1095.21, -254.47, 37.68, 116.43),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'counterfeit_money.mp3',
        line     = 'Perfect or nothing — one bad bill sinks the batch.',
    },
}

