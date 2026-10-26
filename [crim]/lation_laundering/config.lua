Config, Seconds, Minutes, Hours = {}, 1000, 60000, 3600000 -- Do not touch

-- Use only if needed, directed by support or know what you're doing
-- Notice: enabling debug features can significantly increase resmon
-- And should always be disabled in production unless otherwise needed
Config.Debug = false

-- Do you want to be notified via server console if an update is available?
-- True if yes, false if no
Config.VersionCheck = true

-- Select your context menu below
-- Available options are: 'lation_ui', 'ox_lib', 'esx' or 'qb'
Config.Menu = 'ox_lib'

-- Target system - options are: 'ox_target', 'qb-target', 'qtarget', 'custom' & 'none'
-- 'custom' needs to be added to client/functions.lua
-- If 'none' then TextUI is used instead of targeting
Config.Target = 'ox_target'

-- Set your progress bar system below
-- Available options are: 'lation_ui', 'ox_lib', 'qbcore' & 'custom'
-- 'custom' needs to be added to client/functions.lua
-- Any custom progress bar must also support animations
Config.Progress = 'ox_lib'

-- Notification system - options are: 'lation_ui', 'ox_lib', 'esx', 'qb', 'okok', 'sd-notify', 'wasabi_notify' & 'custom'
-- 'custom' needs to be added to client/functions.lua
Config.Notify = 'ox_lib'

-- The below is only used if Config.Target = 'none'
-- This will be the key used for interactions if no target is set
-- More options here: https://docs.fivem.net/docs/game-references/controls/
Config.InteractKey = 38 -- E

-- How do you want to notify users their money is ready (when using the warehouse)?
-- You can set your phone system below or set to 'none' to use a default alert
-- Options: 'qb-phone', 'npwd', 'qs-smartphone', 'qs-smartphonepro', 'lb-phone', 'gksphone', 'yseries', 'custom' or 'none'
-- If 'custom' you will have to configure your event(s) via client & server functions.lua
-- If 'none' then it will use a default alert dialog from ox_lib
Config.Phone = 'lb-phone'

-- Customize how you want players to begin money laundering
Config.Start = {
    -- If spawnPed = true, the main starting NPC will be spawned as normal
    -- If false, there will be no starting NPC at all
    -- This option exists for those who want to handle where
    -- When and how to open the main menu via exports, etc
    spawnPed = true,
    -- If enabled, the NPC spawned from above will be spawned randomly
    -- At only one of the locations listed. If false, the ped will spawn
    -- Normally at all the locations listed below
    randomizeSpawn = false,
    -- The "require" option below is for requiring a specific item to
    -- Interact with/begin the money laundering process with the starting ped
    -- If you want to require an item, set require to true and set item below
    require = false,
    -- If require = true, then what item do you want to require?
    -- If require = false, this can be ignored
    -- If you want the item removed, set remove = true & if not, remove = false
    item = { name = 'water', quantity = 1, remove = false },
    -- Render is the distance a player must be within to the starting ped
    -- In order for it to spawn, outside this radius and the ped is deleted
    -- Until it is needed again
    render = 75,
    -- If we're spawning a ped (or peds), what model is the ped?
    -- You can find more here: https://docs.fivem.net/docs/game-references/ped-models/
    model = 'g_m_importexport_01',
    -- Below is where the ped (or peds) will spawn
    -- Be sure to use vector4 coordinates
    locations = {
        vec4(138.6853, 270.6841, 109.9740, 73.0269),
        -- Add more spawns here if desired
    }
}

-- Customize your police related settings below
Config.Police = {
    -- List your police jobs below
    jobs = { 'police' },
    -- Do you want to require police be online to start laundering?
    -- If true, this only applies to ped contracts, not the warehouse
    require = false,
    -- If require = true above, how many must be online?
    count = 3,
    -- Do you want to allow players with the police job access to the 
    -- Warehouse, ignoring all requirements such as level, key, etc?
    warehouseAccess = true,
    -- Do you want to enable police dispatch alerts? Police will only be
    -- Notified upon a player being rejected - so Config.Reject.enable must
    -- Be true to use this feature
    enableDispatch = false,
    -- If enableDispatch = true, what dispatch system do you use? Available
    -- Options are: 'linden_outlawalert', 'cd_dispatch', 'ps-dispatch', 'qs-dispatch',
    -- 'core_dispatch', 'rcore_dispatch', 'aty_dispatch' & 'custom'
    -- 'custom' must be manually added in client/functions.lua
    dispatchSystem = 'none'
}

-- Customize item spawn names here if needed
Config.Items = {
    key = 'warehouse_key',
    uncountedMoney = 'uncounted_money'
}

-----------------------------------------------------------------
-- ⛔ QBCore Users: IMPORTANT - PLEASE READ CAREFULLY BELOW ⛔
-----------------------------------------------------------------

-- The options below are vitally important to ensure things work
-- The way you wish them to work. Read carefully and set your options
Config.QBCore = {
    -- If your dirty money item (markedbills or similar) uses metadata
    -- (metadata meaning a "worth" or "value" when you hover over the item)
    -- Then ensure you have metadata set to true! If false, it will count
    -- Your dirty money item as 1:1, so 1 markedbills item will equal $1
    metadata = true,
    -- If you use metadata, do you want to count (add) up the total value
    -- Of all dirty money found in the inventory? If so, set to true
    -- If false, it'll only consider the first dirty money item found
    -- In the inventory and work one bag at a time (not add up total)
    countTotal = true,
    -- If you use metadata, do you want to simply clean the entire items
    -- Value? For example, if a player has a markedbills value of $100
    -- Or $10,000, it don't matter, it'll clean whatever the total value is
    -- If countTotal = true then it'll clean everything found in inventory
    takeAll = false,
    -- If you don't use metadata, but want the laundering script to assign
    -- Values itself to your dirty money item (or items), you can do so here
    -- By setting hardValues = true and listing your items values below
    -- This option will completely ignore any worth or values already existing
    -- For example, if you want markedbills to always be worth $500 each
    hardValues = false,
    -- List your items below you want to hard-assign values too
    -- Be sure to follow the format below
    items = {
        ['black_money'] = 500,
        -- ['cashrolls'] = 250,
        -- Add more items here following the same format above
    }
}

-- Vehicle related options when starting a new contract mission
Config.Vehicle = {
    -- When a player starts a new contract run, do you want
    -- To spawn a vehicle for them to use?
    spawn = true,
    -- If spawning a vehicle, do you want to teleport (warp) 
    -- The player directly into the vehicle's driver seat?
    teleport = true,
    -- If spawning a vehicle, how much fuel should the vehicle
    -- Be spawned with? Be sure to use a float value! That simply
    -- Means to include a .0 on whatever number you set here
    fuel = 85.0,
    -- If spawning a vehicle, what model should be spawned?
    models = { 'baller3', 'fugitive' },
    -- If you add multiple models to the list above you can
    -- Set random = true to randomly select a model from the list
    random = true,
    -- Do you want to require the player pay for the vehicle that
    -- Is being supplied for them to use if spawn = true?
    requireDeposit  = true,
    -- If requireDeposit is true, how much should it cost?
    depositPrice = 500,
    -- When a player ends their contracts runs, should we
    -- Return their deposit? The vehicle must be returned
    -- At the initial starting location in the main menu
    returnDeposit = true,
    -- If returnDeposit is true, how much should we give back?
    depositReturn = 250,
    -- If requireDeposit is true, what account do you want to use
    -- To pay for the rental and return deposit? (cash or bank)
    account = 'cash',
    -- If spawning a vehicle, where should the vehicle spawn?
    -- If you have multiple starting ped locations, ensure you
    -- Have a location for the vehicle to spawn at each location
    -- The script will automatically detect which location to spawn
    -- The vehicle at based on the location of the player
    locations = {
        vec4(125.9180, 278.1013, 109.9004, 249.8953),
        -- Add more locations here if necessary
    }
}

-- Customize your rejection settings here
-- Rejection is the ability for a ped to reject a player during cleaning
-- You can customize the rejection chance per level below (Config.Levels)
Config.Reject = {
    -- Do you want to enable rejections? If true, a player can be rejected
    -- Based on the chance set in their respective level. If false a player
    -- Will never be rejected (unless they don't have enough money, of course)
    enable = true,
    -- If rejections are enabled, do you want to allow missions to continue
    -- As normal after a rejection? Set to true if so. If you want missions
    -- To end after a rejection, set continue to false
    continue = true
}

-- Customize all warehouse related options below
Config.Warehouse = {
    -- Below is the level the player unlocks the use of the warehouse
    unlockAt = 5,
    -- By default, when a player reaches the level to unlock use of the
    -- Warehouse then they are no longer able to run contracts like previous
    -- Levels. However, if you wish to allow them the option of both, you
    -- Can set allowContracts to true
    allowContracts = false,
    -- The option below allows you to customize who can and who cannot enter
    -- and use the warehouse. If requireLvl is true, then it requires the player
    -- Attempting to enter be the correct level (unlockAt). If set to false,
    -- Anyone can enter (and use) as long as they have the key required to enter
    requireLvl = true,
    -- If you want to require the player to purchase the warehouse key
    -- Ensure requirePurchase is set to true. If set to false, the key will
    -- Be given to the player for free
    requirePurchase = true,
    -- If requirePurchase is set to true above, how much does the key cost?
    -- If requirePurchase is false, this can be ignored
    price = 2500,
    -- If requirePurchase is set to true above, what account is used to
    -- Purchase the key? Options are 'bank' and 'cash' - if requirePurchase
    -- Is false, this can also be ignored
    account = 'cash',
    -- When a player unlocks use of the warehouse, do you want to create a
    -- Blip showing the location to enter the warehouse?
    showBlip = true,
    -- Below is the location at which the players are able to enter the warehouse
    -- This is also the same location the blip will be displayed if enabled
    enterAt = vec4(1142.6859, -986.6674, 45.9059, 96.6889),
    -- exitAt is the coords the player will be teleported too upon entering
    -- It will also be the same point at which the player will exit the warehouse
    -- And they will then be teleported back to enterAt
    exitAt = vec4(1138.0872, -3199.1570, -39.6657, 181.2139),
    -- Rotate is the amount of degrees to turn the player upon exit and entry
    -- To ensure the player is facing the correct direction when teleported
    rotate = 180,
    -- If you are using a custom location and it is an MLO, be sure to set
    -- isMLO to true, which will disable the usage of enter/exit points, etc
    isMLO = false,
    -- Duration is how long in hours, minutes + seconds it takes to complete a washing
    -- Cycle for money before it is ready to be picked up and counted. This can be as
    -- Long as you desire - the script will save the time remaining upon server
    -- Restarts and player logout events and pick back up wherever they left off at
    duration = 1 * Hours + 25 * Minutes + 30 * Seconds,
    -- Below is the location of the washing machine at which players can use
    -- To put dirty money in to begin the washing process
    washer = {
        coords = vec3(1122.4, -3193.5, -40.35), -- The location of the washing machine itself
        size = vec3(1.7, 4.35, 2.1), -- The size of the zone around the washer (for TextUI only)
        rotation = 0, -- The rotation of the zone (for TextUI only)
        debug = false, -- Enable or disable zone debugging (visual display, for TextUI only)
    },
    -- Below is the configurations for each money counting machine
    counters = {
        [1] = {
            coords = vec3(1116.0024, -3194.9362, -40.5910), -- The location of the counting machine itself
            size = vec3(3.2, 1.0, 1.8), -- The size of the zone around the machine (for TextUI only)
            rotation = 0, -- The rotation of the zone (for TextUI only)
            radius = 0.35, -- The size of the radius around the machine (for targeting only)
            offset = vec3(0.6327, 0.0385, -0.8101), -- The offset from the machine where chair spawns & player sits
            heading = 88.88, -- The direction the player is facing when counting money
            debug = false -- Enable or disable zone debugging (visual display, for TextUI only)
        },
        [2] = {
            coords = vec3(1116.0164, -3196.2717, -40.5917),
            size = vec3(3.2, 1.0, 1.8),
            rotation = 0,
            radius = 0.35,
            offset = vec3(0.5997, 0.0329, -0.8074),
            heading = 88.88,
            debug = false
        },
        -- Add more here as needed or desired
        -- Note: this does not spawn the money counter, just makes one that exists interactable
        -- Be sure to follow the same format as above
    },
    -- Set your money washing & counting limits below
    limits = {
        washing = {
            -- Minimum amount that can be washed in one cycle
            min = 500,
            -- Maximum amount that can be washed in one cycle
            -- (To change mission/contract limits go to Config.Levels)
            max = 25000
        },
        counting = {
            -- Set the minimum amount of money a player can count in one sitting
            min = 0,
            -- Set the maximum amount of money a player can count in one sitting
            max = 15000,
            -- Interval is how much money equals one full animation to play
            -- For example, if a player is counting $5,000 uncounted_money
            -- And the interval is set to 2500, that means it will play 2 times
            -- If counting $10,000 then it will play 4 times, so on and so forth
            -- Because it will play once for every $2,500 in money being counted
            interval = 2500
        }
    },
    -- While a player is counting money, below are what keys/actions are disabled
    -- During the animation. Find more here: https://docs.fivem.net/docs/game-references/controls/
    -- You can also use empty functions StartedCounting & StoppedCounting
    -- Found in client/functions.lua for further control/integration
    disable = {
        200, -- ESC / pause menu
        36, -- Left CTRL / duck
        -- Add or remove as you wish
    },
    -- ConvertTo below is what we are converting our uncounted_money too
    -- When the user has completed the counting process. By default this is
    -- Cash, but can be set to 'cash' or 'bank'
    convertTo = 'cash'
}

-- Customize the leveling system below
Config.Levels = {
    [1] = { -- Level 1
        -- The dirty money item used at level 1
        dirtyMoney = 'black_money',
        -- Tax rate is how much dirty money is lost during the cleaning process
        -- For example, a 25% tax rate means the player will receive $750 clean
        -- Cash for $1,000 dirty
        taxRate = 25,
        -- The clean options below are the minimum and maximum amounts each ped
        -- Will clean in one contract. The ped will randomly select an amount
        -- Between these two values and offer to clean that amount
        clean = { min = 500, max = 1000 },
        -- AddXP is how much experience is rewarded per cleaning contract
        -- This is where you can adjust how fast or slow leveling is
        addXP = 1000,
        -- If negotiations are enabled, this is the percentage chance a
        -- Players negotiation is accepted
        negotiateChance = 60,
        -- If negotiations are enabled and the ped successfully accepts
        -- This is how much the cleaning amount offered is increased
        -- This is a percentage, so 25 means 25% boost ($1000 offer becomes $1250)
        multiplier = 25,
        -- If Config.Reject.enable is true, RejectChance is the percentage
        -- chance a player gets rejected during cleaning contracts at this level
        rejectChance = 20
    },
    [2] = { -- Level 2
        dirtyMoney = 'markedbills',
        taxRate = 20,
        clean = { min = 750, max = 1500 },
        addXP = 500,
        negotiateChance = 70,
        multiplier = 50,
        rejectChance = 15
    },
    [3] = { -- Level 3
        dirtyMoney = 'markedbills',
        taxRate = 15,
        clean = { min = 1000, max = 2000 },
        addXP = 250,
        negotiateChance = 80,
        multiplier = 75,
        rejectChance = 10
    },
    [4] = { -- Level 4
        dirtyMoney = 'markedbills',
        taxRate = 10,
        clean = { min = 1500, max = 3000 },
        addXP = 125,
        negotiateChance = 90,
        multiplier = 100,
        rejectChance = 5
    },
    [5] = { -- Level 5
        dirtyMoney = 'markedbills',
        taxRate = 5,
        -- (To change warehouse washing limits go to Config.Warehouse.limits.washing)
        clean = { min = 2000, max = 10000 },
        -- When a player achieves the final level, no more XP is gained
        -- No matter what is in addXP below
        addXP = 1,
        -- At the final level, by default level 5, the options below
        -- negotiateChance, multiplier & rejectChance are only used
        -- If allowContracts above is true, otherwise don't matter
        negotiateChance = 95,
        multiplier = 125,
        rejectChance = 0
    },
    -- Add or remove levels with custom options however you wish!
    -- Be sure to follow the correct format and increment numbers correctly
}

-- This is the amount of experience that must be earned between
-- Each level. For example, from level 1 to level 2 you must gain
-- 100,000 XP. Same goes for level 2 to level 3. To customize how
-- Fast or slow the leveling happens between levels, it's best 
-- to simply adjust "addXP" above for each level, not this
Config.LevelUp = 100000

-- If you want to allow players the ability to negotiate with the ped
-- The amount of money they are offering to clean for a chance at a 
-- Higher amount, set to true. If not, set to false. You can customize
-- The chances at which players are successful above in Config.Levels
Config.AllowNegotiations = true

-- Customize how you wants your blips to display
Config.Blips = {
    start = { -- The ped location(s) to start cleaning money
        enabled = true, -- Do you want blip(s) showing where to start money laundering?
        sprite = 47, -- Sprite ID: https://docs.fivem.net/docs/game-references/blips/
        color = 0, -- Color: https://docs.fivem.net/docs/game-references/blips/#blip-colors
        scale = 0.8, -- Size of the blip on the map
        label = 'Money Laundering' -- Blip name/label
    },
    contracts = { -- Blip used when washing money with various peds 
        enabled = true,
        sprite = 500,
        color = 2,
        scale = 0.8,
        label = 'Money Contract'
    },
    warehouse = { -- Blip used for the warehouse location if enabled
        enabled = true,
        sprite = 473,
        color = 17,
        scale = 0.8,
        label = 'Warehouse'
    },
}

-- Manage all animations used here
Config.Animations = {
    accept = {
        label = 'Making deal..',
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'missfam4', clip = 'base' },
        prop = { model = `p_amb_clipboard_01`, bone = 36029, pos = vec3(0.160, 0.080, 0.100), rot = vec3(-130.00, -50.00, 0.00) }
    },
    negotiate = {
        label = 'Negotiating..',
        duration = 6000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'misscarsteal4@actor', clip = 'actor_berating_loop' },
        prop = {  }
    },
    wash = {
        duration = 1500,
        anim = { dict = 'missfbi_s4mop', clip = 'put_down_bucket' }
    },
    count = {
        anim = { dict = 'anim@amb@business@cfm@cfm_counting_notes@', clip = 'note_counting_counter' },
        props = {
            chair = 'v_corp_cd_chair',
            briefcase = 'prop_cash_case_02',
            cash = 'bkr_prop_money_sorted_01',
            cashWrapped = 'bkr_prop_money_wrapped_01'
        }
    }
}

-- Various locations at which NPCs will spawn during contracts
Config.Locations = {
    vec4(130.2, -1274.99, 29.24, 0.0),
    vec4(162.11, -1268.32, 29.24, 160.62),
    vec4(161.79, -1286.42, 29.23, 110.34),
    vec4(339.17, -1263.60, 31.96, 74.82),
    vec4(306.83, -1246.18, 29.57, 08.58),
    vec4(343.40, -1190.28, 29.31, 164.21),
    vec4(109.19, -1804.54, 26.50, 179.38),
    vec4(524.42, -1831.14, 28.28, 249.49),
    vec4(959.98, -2373.81, 30.50, 0.0),
    vec4(1062.27, -2408.46, 29.97, 92.5),
    vec4(1140.85, -2332.80, 31.34, 166),
    vec4(1126.36, -2096.35, 31.08, 278.05),
    vec4(990.39, -1791.78, 31.63, 181.86),
    vec4(1010.55, -1778.92, 31.42, 83.75),
    vec4(977.90, -1708.98, 30.09, 87.52),
    vec4(990.39, -1660.08, 29.44, 0.0),
    vec4(980.86, -1383.56, 31.54, 29.47),
    vec4(935.19, -1520.58, 31.06, 0.0),
    vec4(998.07, -1489.55, 31.41, 278.1),
    vec4(925.84, -1483.28, 30.11, 50.98),
    vec4(886.78, -1516.57, 30.18, 223.01),
    vec4(886.59, -1584.52, 30.95, 261.39),
    vec4(536.46, -1650.18, 29.26, 259.47),
    vec4(491.19, -1705.30, 29.35, 325.47),
    vec4(353.25, -1850.11, 27.71, 217.45),
    vec4(201.78, -2002.96, 18.86, 234),
    vec4(-592.01, -1767.25, 23.18, 235.15),
    vec4(-1110.98, -1046.5, 2.153, 214.28),
    vec4(1064.63, -2407.89, 29.98, 106.59),
    vec4(1078.87, -2443.25, 29.44, 89.69),
    vec4(953.97, -2529.31, 28.30, 171.31),
    vec4(402.26, -2188.63, 5.917, 243.06),
    vec4(-353.99, -1490.89, 30.26, 142.04),
    vec4(-312.45, -1342.49, 31.32, 42.24),
    vec4(-342.67, -899.03, 31.07, 210.86),
    vec4(-317.44, -772.25, 33.96, 28.59),
    vec4(-241.84, -785.30, 30.45, 71.82),
    vec4(-203.62, -758.88, 30.45, 196.89),
    vec4(-222.69, -641.03, 33.39, 142),
    vec4(66.48, -266.27, 48.18, 214.91),
    vec4(117.78, -265.57, 46.33, 114.95),
    vec4(133.96, -258.22, 46.33, 118.89),
    vec4(169.79, -279.18, 50.27, 297.43),
    vec4(475.16, -105.43, 63.15, 190.25),
    vec4(741.29, 140.41, 80.76, 188.99),
    vec4(777.54, 210.96, 83.64, 158.28),
    vec4(955.28, -194.77, 73.20, 229.43),
    vec4(960.85, -210.85, 73.21, 37.49),
    vec4(974.39, -192.00, 73.20, 37.49),
    vec4(966.46, -203.89, 76.25, 249.08),
    vec4(955.76, -195.02, 79.29, 143.23),
    vec4(791.53, -102.66, 82.03, 335.53),
    vec4(820.06, -124.38, 80.22, 296.63),
    vec4(501.94, -612.38, 24.75, 280.33),
    vec4(460.75, -698.17, 27.42, 41.48),
    vec4(367.92, -776.74, 29.26, 95.15),
    vec4(378.51, -900.16, 29.41, 197.58),
    vec4(-3.72, -1086.34, 26.67, 65.54),
    vec4(-17.60, -1037.06, 28.90, 0.0),
    vec4(45.53, -1011.18, 29.52, 109.67),
    vec4(2.23, -1024.41, 28.96, 103.56),
    vec4(-771.69, -1028.13, 14.13, 254.41),
    vec4(-661.76, -710.01, 26.89, 193.05),
    vec4(-617.15, -683.27, 32.23, 222.4),
    vec4(-584.07, -698.28, 31.23, 176.97),
    vec4(-577.70, -676.53, 36.28, 125.32),
    vec4(-592.16, -751.90, 36.28, 4.41),
    vec4(-594.46, -748.81, 29.48, 225.83),
    vec4(-574.89, -800.02, 30.68, 40.03),
    vec4(-590.54, -797.30, 26.04, 223.14),
    vec4(-1000.58, -945.72, 2.15, 160.51),
    vec4(-1055.29, -971.06, 2.00, 198.95),
    vec4(-1072.79, -988.20, 2.15, 249.84),
    vec4(-1044.78, -1168.74, 2.15, 302.46),
    vec4(-1083.22, -1140.00, 2.15, 250.54),
    vec4(-1122.34, -1237.42, 3.17, 295.03),
    vec4(-1112.39, -1258.41, 6.65, 65.14)
}

-- Various NPC models that will be used as the contract NPCs
Config.Models = {
    'a_m_m_afriamer_01',
    'u_m_m_aldinapoli',
    's_m_y_ammucity_01',
    's_m_m_ammucountry',
    'u_m_y_antonb',
    'csb_anton',
    'g_m_m_armboss_01',
    'g_m_m_armgoon_01',
    'g_m_y_armgoon_02',
    'g_m_m_armlieut_01',
    'ig_ashley',
    'cs_ashley',
    's_m_y_autopsy_01',
    's_m_m_autoshop_01',
    's_m_m_autoshop_02',
    'ig_money',
    'csb_money',
    'g_m_y_azteca_01',
    'u_m_y_babyd',
    'g_m_y_ballaeast_01',
    'g_m_y_ballaorig_01',
    'g_f_y_ballas_01',
    'ig_ballasog',
    'csb_ballasog',
    'g_m_y_ballasout_01',
    's_m_y_barman_01',
    's_f_y_bartender_01',
    'u_m_y_baygor',
    's_f_y_baywatch_01',
    's_m_y_baywatch_01',
    'a_f_m_beach_01',
    'a_f_y_beach_01',
    'a_m_m_beach_01',
    'a_m_o_beach_01',
    'a_m_y_beach_01',
    'a_m_m_beach_02',
    'a_m_y_beach_02',
    'a_m_y_beach_03',
    'a_m_y_beachvesp_01',
    'a_m_y_beachvesp_02',
    'ig_benny',
    'ig_beverly',
    'cs_beverly',
    'a_f_m_bevhills_01',
    'a_f_y_bevhills_01',
    'a_m_m_bevhills_01',
    'a_m_y_bevhills_01',
    'a_f_m_bevhills_02',
    'a_f_y_bevhills_02',
    'a_m_m_bevhills_02',
    'a_m_y_bevhills_02',
    'a_f_y_bevhills_03',
    'a_f_y_bevhills_04',
    'u_m_m_bikehire_01',
    'u_f_y_bikerchic',
    'a_m_y_breakdance_01',
    'u_m_y_burgerdrug_01',
    'csb_burgerdrug',
    's_m_y_busboy_01',
    'u_m_m_rivalpap',
    'a_m_y_roadcyc_01',
    's_m_y_robber_01',
    'ig_roccopelosi',
    'csb_roccopelosi',
    'a_f_y_runner_01',
    'a_m_y_runner_01',
    'a_m_y_runner_02',
    'a_f_y_rurmeth_01',
    'a_m_m_rurmeth_01',
    'ig_russiandrunk',
    'cs_russiandrunk',
    'a_f_m_salton_01',
    'a_f_o_salton_01',
    'a_m_m_salton_01',
    'a_m_o_salton_01',
    'a_m_y_salton_01',
    'a_m_m_salton_02',
    'a_m_m_salton_03',
    'a_m_m_salton_04',
    'g_m_y_salvaboss_01',
    'g_m_y_salvagoon_01',
    'g_m_y_salvagoon_02',
    'g_m_y_salvagoon_03',
    'a_m_y_vinewood_04',
}