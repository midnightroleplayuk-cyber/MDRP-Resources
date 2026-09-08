Config = {}

-- Enabling this will add additional prints and debug visuals
Config.debug = false

-- Available locales: de, en, es, fr, nl, no, pl, pt-br
-- Edit and add more in `/locales`
Config.locale = 'en'

-- The money accounts used for payouts. Use the names your framework uses
-- (kq_link will try to automatically translate them, only change these if you encounter issues)
Config.accounts = {
    cash = 'money',
    addCashAsItem = false, -- Use this option when using dirty_money, markedbills etc. (This is commonly the case on qbox and qbcore servers) (Item name defined above)

    bank = 'bank',
}

-- How money is displayed in the UI. The currency symbol is defined in the locale files
Config.moneyFormat = {
    -- 'before' = $1,250 | 'after' = 1.250$
    symbolPosition = 'before',

    -- Space between the symbol and the amount ('1 250 $' vs '1 250$')
    spaceBetween = false,

    thousandSeparator = ',',

    -- All prices in this resource are whole amounts; this only applies if a
    -- future value ever shows cents
    decimalSeparator = '.',
}

Config.editor = {
    -- Command that opens the admin panel
    -- Access is controlled through the ACE permission 'command.drugdeals:admin'
    command = 'drugdeals:admin',
}

-- Props held during the hand-over animation
Config.dealProps = {
    enabled = true,

    -- Whether the props should be visible to other players
    networked = true,

    -- Spawn the props on the server instead of the client. (Useful when using lockdown mode relaxed/strict)
    serverSpawned = true,

    -- The prop the buyer hands back
    cash = {
        model = 'prop_cash_pile_02',
        bone = 28422,
        offset = vec3(0.1, 0.04, 0.0),
        rotation = vec3(25.0, 0.0, 10.0),
    },

    -- Selectable per drug in the admin panel. The first entry is the default for drugs with no prop selected
    drugs = {
        {
            model = 'prop_drug_package_02',
            label = 'Drug package',
            bone = 28422,
            offset = vec3(0.04, 0.06, -0.01),
            rotation = vec3(135.0, -135.0, 40.0),
        },
        {
            model = 'hei_prop_hei_drug_pack_02',
            label = 'Drug package 2',
            bone = 28422,
            offset = vec3(0.04, 0.06, -0.01),
            rotation = vec3(135.0, -135.0, 40.0),
        },
        {
            model = 'prop_meth_bag_01',
            label = 'Meth bag',
            bone = 28422,
            offset = vec3(0.1, 0.0, -0.01),
            rotation = vec3(135.0, -100.0, 40.0),
        },
        {
            model = 'prop_paper_bag_small',
            label = 'Paper bag',
            bone = 28422,
            offset = vec3(0.0991, -0.0464, -0.0843),
            rotation = vec3(-48.9, -7.65, 16.91),
        },
        {
            model = 'xm3_prop_xm3_bag_weed_01a',
            label = 'Large weed bag',
            bone = 28422,
            offset = vec3(0.1184, 0.0537, -0.0732),
            rotation = vec3(28.57, 46.51, 43.07)
        },
        {
            model = 'p_cs_joint_02',
            label = 'Joint',
            bone = 28422,
            offset = vec3(0.06, 0.02, 0.0),
            rotation = vec3(0.0, 0.0, 0.0),
        },
        {
            model = 'p_cs_script_bottle_s',
            label = 'Pills Bottle',
            bone = 28422,
            offset = vec3(0.0530, -0.0489, -0.0653),
            rotation = vec3(-66.01, 11.50, -8.29)
        },
        {
            model = 'hei_prop_pill_bag_01',
            label = 'Larger pills bag',
            bone = 28422,
            offset = vec3(0.0916, 0.0592, -0.1003),
            rotation = vec3(-72.96, 80.06, 28.76)
        },
        {
            model = 'prop_coke_block_01',
            label = 'Coke brick',
            bone = 28422,
            offset = vec3(0.0122, -0.0025, -0.0847),
            rotation = vec3(-132.65, 101.65, 11.77)
        },
        {
            model = 'prop_weed_block_01',
            label = 'Weed brick',
            bone = 28422,
            offset = vec3(0.0515, 0.0185, -0.0753),
            rotation = vec3(-116.39, -168.34, -43.35)
        },
        {
            model = 'h4_prop_h4_cash_bag_01a',
            label = 'Money bag',
            bone = 28422,
            offset = vec3(0.0928, -0.0087, -0.0955),
            rotation = vec3(-51.70, -178.76, -25.52)
        },
        {
            model = 'prop_box_guncase_02a',
            label = 'Weapon case',
            bone = 28422,
            offset = vec3(0.0953, -0.0158, -0.1318),
            rotation = vec3(141.67, 174.68, -33.37)
        },
    },
}

-- Global market price drift. Selling pushes a drug's price down, prices recover back toward base over time. Server-wide, saved in the database
Config.market = {
    -- How far a price can stray from its base in either direction (0-100)
    -- 20 = prices stay between 80% and 120% of the base price
    maxFluctuation = 20,

    -- Minutes between market recalculations. Sales are tallied in-between and repriced all at once
    recalcInterval = 20,

    -- The maximum price change in % per single recalculation (0-100)
    maxStep = 3,
}

-- Street deals
Config.street = {
    enabled = true,

    -- Whether to hide the "~$120" market hint in the offer popup
    hideMarketPrice = false,

    npc = {
        -- Ped models that can not be dealt with
        blacklistedModels = {
            's_m_m_fibsec_01',
            's_m_y_fireman_01',
            's_m_y_mime',
            's_m_y_hwaycop_01',
            's_m_y_marine_01',
            's_m_y_marine_02',
            's_m_y_marine_03',
            's_m_m_marine_01',
            's_m_y_ranger_01',
            's_m_y_sheriff_01',
            's_m_m_strperf_01',
            's_m_m_security_01',
            's_m_m_armoured_01',
            's_m_m_armoured_02',
            'csb_trafficwarden',
            's_f_y_cop_01',
            's_f_y_ranger_01',
            's_m_y_cop_01',
        },
    },

    -- NPCs refuse to deal when too many other people stand around them
    crowd = {
        enabled = true,
        radius = 15.0,

        -- The buyer refuses once more than this many peds are nearby
        maxPeds = 4,
    },

    -- A street deal consists of two separate rolls:
    -- - Approach, whether the NPC is willing to talk at all
    -- - Offer, whether they accept the offered price for the drug
    accept = {
        approach = {
            -- Base chance an NPC is willing to talk (0-100) (chance = base * timeOfDay)
            base = 75,

            -- Time of day windows (24h format)
            timeOfDay = {
                -- More willing at night
                { from = 21, to = 5, multiplier = 1.2 },

                -- Less willing in the morning/afternoon
                { from = 7, to = 14, multiplier = 0.7 },
            },
        },

        offer = {
            -- Accept chance based on the asking price vs the market value, per unit
            greedCurve = {
                { ratio = 0.1, multiplier = 3.0 }, -- npcs are 3x more likely to buy the drug is player sells it for 10% of its value
                { ratio = 0.5, multiplier = 1.5 },
                { ratio = 1.0, multiplier = 1.0 },
                { ratio = 1.2, multiplier = 0.6 },
                { ratio = 1.5, multiplier = 0.25 },
                { ratio = 2.0, multiplier = 0.1 }, -- npcs have 0.1x chance to buy drug that's priced at double of the market price
            },
        },
    },

    cooldowns = {
        -- Seconds between street deals for each player
        global = 2,
    },
}

-- Corner selling
-- Admin-placed corner zones where the player posts up and buyers come to them
Config.corner = {
    enabled = true,

    -- Whether buyers may be SPAWNED when no ambient NPC qualifies nearby
    -- Disabled = corners only ever use naturally existing ambient NPCs
    spawnBuyers = true,

    -- Blip on a corner, only shown while carrying one of its drugs and within
    -- viewDistance (meters) of the corner
    blip = {
        enabled = true,
        sprite = 465,
        color = 66,
        scale = 0.7,
        viewDistance = 100.0,
        areaAlpha = 80,
    },

    -- Idle animations played while posted up, one rolled per post-up
    -- Walking breaks the pose; an animation the ped rejects falls to the next roll
    idleAnims = {
        { dict = 'anim@heists@heist_corona@single_team', anim = 'single_team_loop_boss' },
        { dict = 'missbigscore2aig_3', anim = 'wait_for_van_c' },
        { dict = 'rcmnigel1a', anim = 'base' },
    },
}

-- Jobs that count as police
-- Used by the witness dispatch and the minimum police requirements
Config.policeJobs = {
    'police',
}

-- NPCs witnessing a completed street sale may call the police
Config.dispatch = {
    enabled = true,
    witnesses = {
        -- Chance per nearby NPC (0-100), the first successful roll becomes the witness
        chancePerPed = 5,
        -- Radius at which npcs will have a chance to call the dispatch
        radius = 25.0,

        -- Seconds between two dispatch calls (per player)
        cooldown = 180,
    },

    -- Only used for non-custom dispatch system (configured in kq_link)
    blip = {
        sprite = 51,
        color = 1,
        scale = 1.0,
        flash = true,
    },
}

Config.app = {
    -- Usable items that open the dealer app. The plug phone is a modern smartphone the trap phone is an old-school burner phone
    -- On standalone servers, with no items, the item names get registered as commands instead (/kq_plugphone, /kq_trapphone)
    phoneItem = {
        enabled = true,
        item = 'kq_plugphone',
    },
    classicPhoneItem = {
        enabled = true,
        item = 'kq_trapphone',
    },

    -- The custom app registered into the server's phone resource.
    -- Phones are wired up in shared/editable/phoneIntegrations.lua
    -- Supported phone resources:
    -- lb-phone
    -- lb-tablet
    -- yseries
    -- qs-smartphone-pro
    -- gksphone
    -- high-phone
    -- sd-phone
    -- codem-phone
    -- 17mov_Phone
    -- roadphone (manual setup on the phone's side, see ROADPHONE_APP.md)
    customApp = {
        -- Whether to register the app into supported phone resources at all
        enabled = true,

        -- Whether to push notifications through the phone
        notifications = true,
    },

    -- Whether the trap phone screen should react to mouse clicks
    -- When disabled the phone is usable by its keypad and keyboard inputs
    classicTouchScreen = false,

    -- Whether to remove the Prices tab from the app
    hideMarketPrices = false,

    -- How many buyer conversations can run at the same time
    maxActiveThreads = 4,

    -- Seconds before an unanswered buyer walks away
    threadExpiry = 600,

    -- Star rating tiers. Stars go from 1.0 to 5.0 and get floored (2.7 counts as tier 2)
    -- priceTolerance multiplies the market price into the maximum buyers will accept
    starTiers = {
        [1] = { requestsPerHour = 3, priceTolerance = 0.85 },
        [2] = { requestsPerHour = 3, priceTolerance = 0.9 },
        [3] = { requestsPerHour = 4, priceTolerance = 1.0 },
        [4] = { requestsPerHour = 5, priceTolerance = 1.05 },
        [5] = { requestsPerHour = 6, priceTolerance = 1.15 },
    },

    -- Rating changes after every finished deal
    rating = {
        -- Delivered within this percentage of the buyer's deadline (0-100)
        fast = { within = 40, change = 0.05 },

        -- Delivered comfortably within it
        steady = { within = 70, change = 0.04 },

        -- Delivered close to the deadline
        slow = { change = 0.025 },

        -- The buyer gave up waiting, or the package was stolen before they arrived
        failed = { change = -0.08 },

        -- The player declined the buyer, or haggled until they walked off
        declined = { change = -0.02 },

        -- The buyer was ignored or left on read
        expired = { change = -0.005 },
    },

    -- (For Drugs using Metadata pricing only!)
    -- App buyers never ask for a specific grade/quality of a drug
    -- When delivering they expect at least "Neutral" satisfaction of the drug.
    -- Anything above will give extra standing. Anything below will reduce the standing gain
    quality = {
        -- Star change per quality class above/below the reference, applied to the delivered average
        -- For example, a drug with meta satisfaction of "Great" will receive + (2 * starsPerLevel) on the rating
        -- in this case +0.04 total rating on top of the deal rating gain
        starsPerLevel = 0.02,

        -- Contact standing change per quality class (used for drugs with metadata pricing + satisfaction levels)
        -- Same as "starsPerLevel", but on the contact standing instead when dealing with saved contacts
        standingPerLevel = 4,

        -- Added to the post-deal contact offer chance (0-100) per class above the reference
        -- The chance of the buyer to add the player to contacts based on the satisfaction of the drug
        -- When "addChancePerLevel = 8", when delivering "Great" satisfaction of a drug, the chances of the buyer requesting to be saved as contact are +16%
        addChancePerLevel = 8,
    },

    -- Reply delay in seconds
    replyDelay = {
        min = 6,
        max = 15,
    },

    -- The buyer sends a message once this many seconds are left for their delivery
    lowTimeWarning = 240,

    -- Buyer personas
    -- chance = how often this persona shows up, relative to the others
    -- budget = the buyer's hidden per-unit price ceiling as a multiple of the market value
    -- patience = how many counter offers they sit through before walking away
    personas = {
        { persona = 'broke',   chance = 12, budget = { min = 0.45, max = 0.75 }, patience = 4 },
        { persona = 'cheap',   chance = 22, budget = { min = 0.8, max = 1.02 }, patience = 3 },
        { persona = 'rushed',  chance = 16, budget = { min = 0.95, max = 1.2 }, patience = 1 },
        { persona = 'regular', chance = 36, budget = { min = 0.95, max = 1.10 }, patience = 3 },
        { persona = 'rich',   chance = 14, budget = { min = 1.15, max = 1.60 }, patience = 2 },
    },
}

-- Saved contacts
-- Repeat customers. A happy app buyer may ask to be saved after a completed deal
-- Saved contacts keep a persistent personality and drugs they buy, message the player on their own and can be offered deals directly
Config.contacts = {
    enabled = true,

    -- Chance (0-100) a buyer asks to be saved after a completed deal
    addChance = 15,

    -- Guarantees the first contact. Once the player has completed this many app deals and still has no active contacts
    -- 0 = disabled
    firstContactAfterDeals = 3,

    -- Contact slots by star rating
    -- Players will not get new contacts if they have the max amount for their rating
    maxByRating = {
        { stars = 4.8, max = 16 },
        { stars = 4.0, max = 13 },
        { stars = 3.5, max = 10 },
        { stars = 3.0, max = 8 },
        { stars = 2.0, max = 6 },
        { stars = 0.0, max = 5 },
    },

    -- How many (real) days a fresh contact stays for. After this time the contact will send a goodbye message and be unavailable
    lifetimeDays = { min = 4, max = 30 },

    -- Minutes between contact buy request (per contact)
    messageInterval = { min = 40, max = 160 },

    -- Minutes before the player can offer product to the same contact again
    -- When offered again within this time from the last deal/offer, the contacts standing will drop
    offerCooldownMinutes = 50,

    -- Minutes a contact stays quiet after the player declines their buy request
    declineSnoozeMinutes = 120,

    -- Chance (0-100) a contact never buys from player started offers, they only buy when they reach out by themselves
    neverBuysChance = 25,

    -- Per-contact standing, 0-100
    -- At 0 the contact blocks the player
    standing = {
        -- Default standing when gaining a new contact
        default = 40,

        -- Gained on a completed deal
        deal = 7,

        -- Lost when a delivery times out or the package gets stolen
        failed = 15,

        -- Lost when haggling makes them walk off
        walked = 9,

        -- Lost when the player declines or ignores their request
        declined = 4,

        -- Lost per offer sent within the offerCooldownMinutes window
        nag = 8,
    },

    -- Price tolerance per standing level (Bad..Great). Replaces the star tier's priceTolerance for contacts
    priceTolerance = {
        0.9, -- Bad standing
        0.95, -- Poor standing
        1.0, -- Neutral standing
        1.1, -- Good standing
        1.2,  -- Great standing
    },

    -- Chance (0-100) a contact accepts a player started offer, per standing level
    acceptChance = {
        30, -- Bad standing
        45, -- Poor standing
        65, -- Neutral standing
        75, -- Good standing
        85, -- Great standing
    },

    -- Referrals: a contact with good or great standing sends a friend over
    referral = {
        enabled = true,

        -- Chance (0-100) per hour, per contact at or above minStandingLevel to send a referral deal
        chancePerHour = 5,

        -- Standing level required before a contact vouches for the player (1 = Bad, 2 = Poor, 3 = Neutral, 4 = Good, 5 = Great)
        minStandingLevel = 4,
    },
}

-- Deliveries (phone app deals)
Config.delivery = {
    deaddrop = {
        -- Models of the deaddrop packages, randomized per deaddrop
        models = {
            'prop_mp_drug_package',
            'xm3_prop_xm3_backpack_01a',
            'v_ind_meatboxsml_02',
            'v_ind_meatboxsml',
        },

        -- Seconds before the buyer will collect the package
        collectAfter = 60,

        -- Whether to send an NPC to physically collect the package (only happens if the player stays near the package)
        collector = true,

        -- Npc models that will go out and collect the deaddrop package
        collectorModels = {
            'g_m_y_mexgoon_03',
            'a_m_m_soucent_01',
            'a_m_o_soucent_01',
            'g_m_y_ballasout_01',
            'a_m_y_downtown_01',
            'a_m_m_salton_03',
            'a_f_y_soucent_02',
            'g_m_y_armgoon_02',
            's_m_o_busker_01',
            'a_f_m_trampbeac_01',
        },
    },

    -- Minutes the player will have to deliver the package, randomized per deal and rounded to the nearest 5
    waitMinutes = { min = 15, max = 45 },
}

-- Organizations
Config.org = {
    enabled = true,

    -- Blip on an organizations active sell location, only shown once the player has unlocked the org
    blip = {
        enabled = true,
        sprite = 84,
        color = 5,
        scale = 0.7,
    },

    -- Per-character standing with each organization (stored as 0-100)
    -- 5 display levels (Bad, Poor, Neutral, Good, Great)
    standing = {
        -- Standing of a fresh organization relation (40-59 = Neutral)
        default = 40,

        -- Points gained with an org per batch sold to them
        pointsPerBatch = 2,

        -- Points lost per batch with every org that lists the buyer as an enemy
        enemyPointsPerBatch = 3,

        -- Hours of real time without organization activity before an org drops one level (20 points)
        -- 0 = no decay
        decayHours = 72,
    },

    -- Favours, allows players to perform favours for organizations to up their standing
    favour = {
        enabled = true,

        -- Blip on the favour target while one is active (hit and vehicle favours)
        blip = {
            enabled = true,
            sprite = 303,
            color = 6,
            scale = 1.0,
        },

        -- Blip on the drop-off location of a package delivery favour
        packageBlip = {
            enabled = true,
            sprite = 478,
            color = 6,
            scale = 1.0,
        },

        -- Minutes to finish the favour
        timeLimitMinutes = 30,

        -- Minutes before the same org offers another favour
        cooldownMinutes = 45,

        -- The item handed over for package favours
        packageItem = 'kq_drugpackage',

        -- Vehicle models for destruction favours
        vehicles = {
            'cavalcade2',
            'kuruma',
            'toros',
            'jubilee',
            'tulip',
            'dubsta2',
            'burrito3',
            'speedo',
            'reaper',
            'xls',
            'deviant',
            'youga',
        },

        -- Chance (0-100) the enemy org finds out and punishes the player
        enemyNoticeChance = 75,

        standing = {
            -- Standing gain after finishing a favour
            complete = 15,

            -- Standing lost after failing to finish a favour (on time)
            fail = 10,

            -- Standing lost when an enemy organization finds out about doing favours for others
            enemy = 25,
        },
    },
}

-- Minimum police requirements
Config.minimumPolice = {
    block = {
        -- Disallows selling entirely when not enough officers are online
        enabled = false,
    },

    -- Allows selling but lowers drug prices when not enough officers are online
    priceCut = {
        enabled = false,

        -- Percentage of the drug prices paid while not enough police online (0-100)
        factor = 30,
    },

    -- Officers needed per sale type
    street = 0,
    app = 0,
    org = 0,
    corner = 0,
}

-- Police sting operations
-- Officers run undercover buys through the sting phone item
Config.police = {
    enabled = true,

    -- Jobs with sting phone access
    -- view = minimum grade to open the app and watch the shared operation
    -- control = minimum grade to run it (pick sites, targets, terminate)
    jobs = {
        ['police'] = { view = 0, control = 1 },
    },

    -- Usable item that opens the sting phone. Only works for the jobs above
    phoneItem = {
        enabled = true,
        item = 'kq_stingphone',
    },

    -- Option to open the sting phone using a command instead of an item
    command = {
        enabled = false,
        command = 'stingphone',
    },

    -- Minutes before any officer can run another sting
    globalCooldown = 30,

    -- How many drop locations the app offers when starting an operation (max 8)
    locationChoices = 3,

    -- Blip on the agreed drop location, visible to officers only
    blip = {
        sprite = 478,
        color = 29,
        scale = 0.65,
    },

    -- The Hotspots app, a police-only heat map of where street deals happen
    heatmap = {
        enabled = true,
    },

    -- Registers "LSPD: Narcotics" (sting + hotspots in one app) into the same
    -- phone resources the Plug app supports. Everyone can install it; the app
    -- itself denies anyone without a police job from Config.police.jobs
    customApp = {
        enabled = true,
    },
}

-- Position of the deal popups
Config.uiPopup = {
    position = { -- CSS styling
        left = '50%',
        right = nil,
        top = nil,
        bottom = '2.5rem',
        transform = 'translateX(-50%)',
    },
}

-- Full UI customization via RGB color values
Config.uiStyling = {
    ['color-background'] = '18, 20, 19',
    ['color-background-light'] = '30, 32, 31',
    ['color-primary-dark'] = '120, 170, 0',
    ['color-primary'] = '178, 243, 0',
    ['color-primary-light'] = '211, 252, 98',
    ['color-secondary'] = '193, 207, 176',
    ['color-secondary-light'] = '226, 245, 203',
    ['color-secondary-dark'] = '111, 117, 103',
    ['color-white'] = '251, 251, 251',
    ['color-black'] = '10, 10, 10',
    ['border-radius-sm'] = '0.25rem',
    ['border-radius-md'] = '0.5rem',
    ['border-radius-lg'] = '0.75rem',
    ['border-radius-xl'] = '1.5rem',
    ['backdrop-blur'] = '16px',
}
