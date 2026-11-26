Config = {}

-- Price per player, per game. Set to 0 for free play.
Config.Fee = 40
Config.Currency = '£'
-- Accounts tried in this order when charging the fee.
Config.Payment = { 'cash', 'bank' }

Config.MaxPlayers = 6

-- Lanes can be listed here, or placed in game with /bowlinglane (saved to data/lanes.json).
-- coords  = centre of the foul line, at lane surface height
-- heading = direction the ball travels (towards the pins)
-- console = optional, where players book the lane. Defaults to the right of the approach.
-- screen  = optional scoreboard screen drawn in the world (see README).
Config.Lanes = {
    -- {
    --     coords = vec3(0.0, 0.0, 0.0),
    --     heading = 0.0,
    --     console = vec3(0.0, 0.0, 0.0),
    --     screen = { coords = vec3(0.0, 0.0, 0.0), heading = 180.0, width = 1.6, height = 0.8 },
    -- },
}

-- Overhead scoreboards. With `auto` on, every lane gets one above its pins,
-- facing the bowler, with no setup. A lane's own `screen` entry overrides it,
-- and `screen = false` on a lane in Config.Lanes turns it off for that lane.
Config.Screens = {
    auto = true,
    height = 2.3,    -- metres above the lane surface, to the middle of the screen
    width = 1.5,
    pairWidth = 3.0, -- width of a scoreboard shared by a pair of lanes
    tall = 0.75,
    setback = 0.4,   -- metres past the head pin
    tilt = 0.0,      -- degrees; positive leans the top towards the bowler
}

-- Distance at which pins and screens for a lane are created for a player.
Config.RenderDistance = 60.0

Config.Props = {
    ball = `prop_bowling_ball`,
    pin = `prop_bowling_pin`,
    -- Height of each prop's origin above the lane surface. Adjust if they float or sink.
    ballZ = 0.108,
    pinZ = 0.0,
    -- Ball position/rotation in the right hand while lining up.
    hand = { pos = vec3(0.12, 0.02, -0.06), rot = vec3(0.0, 0.0, 0.0) },
}

-- How forgiving the game is. With these values a perfectly lined-up ball
-- strikes a little under half the time.
Config.Difficulty = {
    carry = 0.09,   -- pin carry, 0.08 (hard) to 0.11 (very easy). Biggest effect on strike rate
    wobble = 0.15,  -- random drift on the aim, as a fraction of the full aim range
    drift = 0.03,   -- random sideways drift on the release point, in metres
}

Config.Throw = {
    maxOffset = 0.45,    -- metres either side of lane centre
    maxAngle = 2.0,      -- degrees either side of straight
    minSpeed = 5.5,      -- m/s at empty power
    maxSpeed = 9.0,      -- m/s at full power
    powerPeriod = 1500,  -- ms for the power bar to go up and back
    camera = 'free',     -- 'free' leaves the player's own camera alone, 'fixed' locks it behind the bowler
    guide = true,        -- draw the ball's expected path while lining up
    guideLength = 8.0,   -- metres of path shown. The full lane is about 18.5
    anim = { dict = 'anim@heists@narcotics@trash', name = 'throw_b', releaseMs = 550 },
    followCam = false,   -- chase the ball with the camera after release
}

Config.Timing = {
    turn = 60,        -- seconds a player has to bowl before the ball is counted as a miss
    settle = 6200,    -- ms after the pins stop before the next ball (must cover the pinsetter cycle)
    sweepDelay = 600, -- ms the fallen pins lie there before the sweeper comes down
    results = 14,     -- seconds the final scores stay up before the lane frees up
}

-- Pinsetter and sweeper. Drawn as plain shaded boxes by default. If you have
-- proper models (streamed with your MLO, say), put their names in `models` and
-- they are used instead. Model origin should be the centre of the part.
Config.Machine = {
    enabled = true,
    showParked = true,   -- draw the parts while they sit idle above the pins
    models = { sweeper = nil, deck = nil },
    sweeperColour = { 58, 62, 66 },
    deckColour = { 44, 48, 52 },
    -- ms per movement. A full cycle is 2x sweeperDrop + 4x deckMove + sweep + sweepReturn,
    -- and has to fit inside Timing.settle minus Timing.sweepDelay.
    timing = { sweeperDrop = 400, deckMove = 550, sweep = 750, sweepReturn = 600 },
}

-- Player must be this close to the lane to book, join or bowl.
Config.InteractRange = 8.0

Config.Sounds = true

-- Ace needed for /bowlinglane (add_ace group.admin command.bowlinglane allow)
Config.AdminCommand = 'bowlinglane'
-- Gap between lane centres when placing several at once.
Config.LaneSpacing = 1.72
