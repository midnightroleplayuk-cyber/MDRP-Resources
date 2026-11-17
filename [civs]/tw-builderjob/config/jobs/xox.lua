Config = Config or {}

-- ====================================================================
-- XOX -- single-player crane mini-game (tic-tac-toe)
-- ====================================================================
-- Props (tw-builder-stream, tw_xox.ytyp): tw_xoxw frame, tw_xoxx X piece, tw_xoxo O piece.
-- Lift an X off the pile with the crane and set it on the board; the game answers with an O.
-- Cell coords were lattice-fitted; small drift is normal, nudge them freely.
Config.XOX = {
    frame = {
        model  = 'tw_xoxw',
        coords = vec3(1308.135, 3072.430, 39.461),
        rot    = vec3(0.0, 0.0, 16.627),
    },

    pieceX = 'tw_xoxx',
    pieceO = 'tw_xoxo',
    pieceRot = vec3(0.0, 0.0, 16.627), -- pieces follow the board heading

    -- id 1..9: 1-3 bottom row, 4-6 middle, 7-9 top; within a row right to left
    -- (the order the cells were measured in). i/j are the lattice coordinates
    -- the win lines are checked against.
    cells = {
        { id = 1, i = 0, j = 0, coords = vec3(1305.889, 3073.771, 39.518) }, -- bottom-right  MEASURED
        { id = 2, i = 1, j = 0, coords = vec3(1307.643, 3074.332, 39.518) }, -- bottom-middle MEASURED
        { id = 3, i = 2, j = 0, coords = vec3(1309.398, 3074.893, 39.518) }, -- bottom-left   MEASURED
        { id = 4, i = 0, j = 1, coords = vec3(1306.416, 3071.951, 39.518) }, -- right-middle  derived
        { id = 5, i = 1, j = 1, coords = vec3(1308.170, 3072.512, 39.518) }, -- CENTRE        derived
        { id = 6, i = 2, j = 1, coords = vec3(1309.924, 3073.073, 39.518) }, -- left-middle   MEASURED
        { id = 7, i = 0, j = 2, coords = vec3(1306.942, 3070.130, 39.518) }, -- top-right     derived
        { id = 8, i = 1, j = 2, coords = vec3(1308.697, 3070.691, 39.518) }, -- top-middle    derived
        { id = 9, i = 2, j = 2, coords = vec3(1310.451, 3071.252, 39.518) }, -- top-left      MEASURED
    },

    -- One pile per mark, five each: a full game uses at most five X and four O,
    -- so an empty X pile means the board is full.
    piles = {
        X = { coords = vec3(1307.785, 3067.217, 39.518), count = 5 },
        O = { coords = vec3(1311.294, 3068.339, 39.518), count = 5 },
    },

    -- Stack step and sit correction are measured at runtime from the model bounds, not set here.
    stackGap = 0.02,   -- clearance between stacked pieces (measured path only)

    -- Fallbacks used while the props report no usable bounds (GTA's default 2 x 2 x 2 box).
    -- The client detects that box, uses these two values instead and says so in the console.
    -- Re-export the props WITH a collision bound and the measured path takes over automatically.
    stepFallback = 0.35, -- vertical distance between stacked pieces
    sitFallback  = 0.00, -- lift applied when placing (0 = trust the prop pivot)

    -- Crane spawn used by /xox (7.6 m to the X pile, 11.4 m to the board centre). Required.
    crane = { coords = vec3(1301.051, 3063.587, 40.805), heading = 16.627 },
    -- The 8 winning lines as cell ids.
    winLines = {
        { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 },   -- rows
        { 1, 4, 7 }, { 2, 5, 8 }, { 3, 6, 9 },   -- columns
        { 1, 5, 9 }, { 3, 5, 7 },                -- diagonals
    },

    -- Chance the game plays a random move instead of its best one, so it can be beaten.
    -- 0.0 = unbeatable, 1.0 = plays at random.
    mistakeChance = 0.25,

    -- Seconds the finished board stays up before it clears and the piles restock.
    resetAfter = 6,
}
