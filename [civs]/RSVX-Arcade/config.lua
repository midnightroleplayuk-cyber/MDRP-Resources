Config = {}

Config.Currency       = '£'
Config.PayAccount     = 'cash'    -- account a play is charged to, and takings are paid into
Config.OwnerCut       = 0.5       -- share of each play that goes into the machine's takings
Config.MaxPerPlayer   = 5         -- placed machines per character
Config.MinSpacing     = 0.9       -- metres between machines
Config.PlaceDistance  = 5.0       -- how far from yourself you can place
Config.RenderDistance = 60.0
Config.AdminAce       = 'rsvx.arcade.admin'   -- add_ace group.admin rsvx.arcade.admin allow

Config.Anim = {
    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
    clip = 'machinic_loop_mechandplayer',
}

-- Prize tickets handed out on game over. ticketEvery is set per machine below.
Config.Tickets = {
    enabled    = false,   -- off by default: there is nothing to spend tickets on yet
    item       = 'arcade_ticket',
    maxPerPlay = 50,
}

-- Key = game id (must match a file in web/games).
-- price        cost per play, 0 = free
-- maxScore / maxPerSecond   server-side sanity limits for a submitted score
-- ticketEvery  one prize ticket per this many points
-- rewards      optional score tiers; the highest tier reached is paid out on top of tickets
--              { min = 500, item = 'water', count = 1 }  or  { min = 500, money = 10 }
-- board = false  machine keeps no leaderboard
-- physical     custom prop with moving parts; falls back to model + on-screen game if not streamed
-- Bell Ringer skill check. The bar bounces between empty and full; Space swings.
Config.Strength = {
    bell     = 965,    -- power (out of 1000) needed to ring the bell and win the reward below
    speed    = 2.2,    -- how fast the bar moves to start with (bar lengths per second)
    step     = 0.3,    -- added every time the bar reaches the top
    maxSpeed = 3.8,
    jitter   = 0.2,    -- each bounce is up to this much faster or slower, so the rhythm cannot be learned
    volume   = 0.6,    -- bell sound, 0.0 to 1.0
    hearing  = 30.0,   -- metres other players hear the bell from
}

Config.Pinball = {
    balls    = 3,
    ballSave = 5,      -- seconds after a launch in which a drained ball is handed back (once per ball)
    camera   = true,   -- on the custom table, look down at the playfield while playing
}

Config.Hockey = {
    goals = 7,         -- first to this many wins
    time  = 180,       -- seconds; whoever is ahead when it runs out wins
    ai    = 0.6,       -- computer opponent: 0.3 is easy, 0.9 is hard
    camera = true,     -- on the custom table, fix the view above your end and hide your own character
}

Config.Machines = {
    snake = {
        label = 'Viper',
        item  = 'arcade_viper',
        model = `ch_prop_arcade_degenatron_01a`,
        price = 2,
        maxScore = 11000, maxPerSecond = 15,
        ticketEvery = 50,
    },
    brickfall = {
        label = 'Brickfall',
        item  = 'arcade_brickfall',
        model = `ch_prop_arcade_monkey_01a`,
        price = 2,
        maxScore = 500000, maxPerSecond = 600,
        ticketEvery = 500,
    },
    rally = {
        label = 'Rally',
        item  = 'arcade_rally',
        model = `ch_prop_arcade_penetrator_01a`,
        price = 2,
        maxScore = 50000, maxPerSecond = 40,
        ticketEvery = 150,
    },
    siege = {
        label = 'Star Siege',
        item  = 'arcade_siege',
        model = `ch_prop_arcade_space_01a`,
        price = 2,
        maxScore = 100000, maxPerSecond = 60,
        ticketEvery = 200,
    },

    whack = {
        label = 'Mole Mash',
        item  = 'arcade_molemash',
        model = `ch_prop_arcade_wizard_01a`,
        price = 2,
        maxScore = 1500, maxPerSecond = 40,
        ticketEvery = 40,
        rewards = {
            { min = 400, money = 5 },
            { min = 600, money = 15 },
        },
    },
    hoops = {
        label = 'Hoops',
        item  = 'arcade_hoops',
        physical = `rsvx_hoops`,
        model = `ch_prop_arcade_street_01a`,
        price = 2,
        maxScore = 400, maxPerSecond = 8,
        ticketEvery = 8,
    },
    strength = {
        label = 'Bell Ringer',
        item  = 'arcade_bellringer',
        physical = `rsvx_bell`,
        model = `ch_prop_arcade_street_01b`,
        price = 1,
        maxScore = 1000, maxPerSecond = 1000,
        ticketEvery = 100,
        rewards = {
            { min = Config.Strength.bell, money = 50 },
        },
    },
    -- A leaderboard you place next to the Bell Ringer. Nothing to play: it shows the top ten
    -- and the bell prize. display = the game whose scores it lists.
    strength_board = {
        label = 'Bell Ringer Leaderboard',
        item  = 'arcade_bellboard',
        physical = `rsvx_bell_board`,
        model = `prop_tv_flat_01`,
        display = 'strength',
        price = 0,
        board = false,
        maxScore = 0, maxPerSecond = 0,
    },
    claw = {
        label = 'Grabber',
        item  = 'arcade_grabber',
        physical = `rsvx_grabber`,
        model = `ch_prop_arcade_claw_01a`,
        price = 3,
        board = false,
        maxScore = 100, maxPerSecond = 100,
        winAlign  = 70,     -- how well lined up (0-100) the drop has to be to stand a chance
        winChance = 0.35,   -- chance of the claw holding on once lined up
        -- What sits in the machine. Each prize is a real inventory item (or cash) shown as its own prop;
        -- the player wins the one the claw lands on. weight = how often it appears in a machine.
        -- z lifts a prop off the floor of the cabinet if its origin is not at its base.
        prizes = {
            { label = 'Water',  item = 'water',  count = 1, model = `prop_ld_flow_bottle`, weight = 28 },
            { label = 'Burger', item = 'burger', count = 1, model = `prop_cs_burger_01`,   weight = 24, z = 0.03 },
            { label = 'Sprunk', item = 'sprunk', count = 1, model = `prop_ld_can_01`,      weight = 24 },
            { label = 'Radio',  item = 'radio',  count = 1, model = `prop_cs_hand_radio`,  weight = 10, z = 0.03 },
            { label = 'Phone',  item = 'phone',  count = 1, model = `prop_npc_phone_02`,   weight = 7,  z = 0.03 },
            { label = '£50',    money = 50,                 model = `prop_cash_pile_01`,   weight = 7 },
        },
    },
    -- fallback = cabinet used if model does not exist on your game build
    kapperman = {
        label = 'KapperMan',
        item  = 'arcade_kapperman',
        physical = `rsvx_kapperman`,
        model = `ch_prop_arcade_invade_01a`, fallback = `ch_prop_arcade_space_01a`,
        price = 2,
        maxScore = 500000, maxPerSecond = 120,
        ticketEvery = 300,
    },
    pinball = {
        label = 'Pinball',
        item  = 'arcade_pinball',
        physical = `rsvx_pinball`,
        model = `ch_prop_arcade_wizard_01a`, fallback = `ch_prop_arcade_space_01a`,
        price = 2,
        maxScore = 5000000, maxPerSecond = 2000,
        ticketEvery = 2000,
        boardFooter = 'Pinball high scores',
        boardColours = { bar = '#3f1c61', edge = '#f2c14a', text = '#f4e6c2', lead = '#f2c14a' },
    },
    -- versus = a second player can join at the other end of the custom table
    airhockey = {
        label = 'Air Hockey',
        item  = 'arcade_airhockey',
        physical = `rsvx_hockey`,
        model = `prop_airhockey_01`, fallback = `ch_prop_arcade_street_01b`,
        price = 2,
        maxScore = 1, maxPerSecond = 1,
        tally = true,      -- the leaderboard counts wins instead of keeping a best score
        versus = true,
        boardFooter = 'Air Hockey: most wins',
        boardColours = { bar = '#17191c', edge = '#c8392b', text = '#eceef0', lead = '#e0503f' },
    },
    -- Leaderboards to place next to the tables, like the Bell Ringer one.
    pinball_board = {
        label = 'Pinball Leaderboard',
        item  = 'arcade_pinballboard',
        physical = `rsvx_pinball_board`,
        model = `prop_tv_flat_01`,
        display = 'pinball',
        price = 0,
        board = false,
        maxScore = 0, maxPerSecond = 0,
    },
    airhockey_board = {
        label = 'Air Hockey Leaderboard',
        item  = 'arcade_hockeyboard',
        physical = `rsvx_hockey_board`,
        model = `prop_tv_flat_01`,
        display = 'airhockey',
        price = 0,
        board = false,
        maxScore = 0, maxPerSecond = 0,
    },
    fortune = {
        label = 'Mystic',
        item  = 'arcade_mystic',
        model = `ch_prop_arcade_fortune_01a`,
        price = 1,
        board = false,
        maxScore = 0, maxPerSecond = 0,
    },
    love = {
        label = 'Heart Meter',
        item  = 'arcade_heartmeter',
        model = `ch_prop_arcade_love_01a`,
        price = 1,
        board = false,
        maxScore = 0, maxPerSecond = 0,
    },
}

-- Hoops (physical machine): a real basketball is thrown and left to the game's physics
Config.Hoops = {
    seconds   = 45,
    ball      = `prop_bskball_01`,
    angle     = 50.0,     -- launch angle in degrees; much steeper and the ball hits the cage roof
    releaseHeight = 0.55, -- where the ball leaves the hands, in metres above the player's hips (chest height)
    releaseMs = 350,      -- how far into the throw animation the ball leaves the hand
    -- first animation that exists on your game build is used
    throwAnims = {
        { dict = 'weapons@projectile@grenade_str', clip = 'throw_h_fb_stand' },
        { dict = 'weapons@projectile@', clip = 'throw_m_fb_stand' },
        { dict = 'reaction@shove', clip = 'shove_var_a' },
        { dict = 'amb@world_human_cheering@male_a', clip = 'base' },
    },
}

-- Permanent machines (for an MLO). Nobody owns these and they can't be picked up.
Config.StaticMachines = {
    -- { game = 'snake', coords = vec4(1695.2, 4785.1, 41.0, 90.0) },
}
