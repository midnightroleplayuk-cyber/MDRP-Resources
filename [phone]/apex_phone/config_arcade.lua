-- ------------------------------------------------------------
-- ARCADE: server leaderboards, player stats and turn based multiplayer (server/arcade.lua)
-- Every game of the phone (base games, board games and action games) submits its score to a "board".
-- A board is the game id, or "<game>:<variant>" when the game has difficulties or sizes
-- (mines:facil, memory:12, sudoku:dificil, sliding:4). Unknown boards are refused, so a modified
-- client cannot invent tables. Scores outside [min, max] are refused as well.
--   best = 'high'  the bigger the better (points)      best = 'low'  the smaller the better (seconds, moves)
--   min / max      sane limits for one submission
--   variants = true  accepts "<game>:<anything>" with the same limits (only if you add your own variants)
-- ------------------------------------------------------------
Config.Arcade = {
    enabled = true,
    keep = 100,                 -- entries shown per board (the rank is still computed over everyone)
    submitGapMs = 3000,         -- one submission per player per board every 3 s
    turnSeconds = 45,           -- time per move in online matches (the player who runs out loses)
    inviteSeconds = 60,         -- an invite without an answer expires after this
    nearbyRange = 30.0,         -- "players near me": online players with a phone within this distance (metres)
    stateMaxBytes = 16000,      -- the JSON state a client may store per move (chess / checkers)
    maxMatchesPerPlayer = 4,    -- active matches at the same time (one per game at most)

    -- Multiplayer games. rules = 'server': the server validates every move and decides the result (4 in a row,
    -- tic tac toe). rules = 'client': both phones validate (chess, checkers); the server only enforces turns,
    -- the timer and records the result reported by the player who moved.
    Multiplayer = {
        c4       = { rules = 'server' },
        ttt      = { rules = 'server' },
        chess    = { rules = 'client' },
        checkers = { rules = 'client' },
    },

    Games = {
        -- classic games (html/js/apps/games-classic.js)
        snake            = { best = 'high', min = 1,  max = 200000 },
        g2048            = { best = 'high', min = 4,  max = 4000000 },     -- 4x4 board
        ['g2048:5']       = { best = 'high', min = 4,  max = 50000000 },    -- 5x5 board
        blocks           = { best = 'high', min = 1,  max = 5000000 },     -- Marathon (points)
        ['blocks:sprint'] = { best = 'low',  min = 15, max = 3600 },        -- Sprint: seconds to clear 40 lines
        ['blocks:ultra']  = { best = 'high', min = 1,  max = 5000000 },     -- Ultra: points in 2 minutes
        ['mines:facil']   = { best = 'low',  min = 1,  max = 3600 },
        ['mines:medio']   = { best = 'low',  min = 3,  max = 3600 },
        ['mines:dificil'] = { best = 'low',  min = 5,  max = 3600 },
        breakout         = { best = 'high', min = 1,  max = 2000000 },
        ['memory:8']      = { best = 'low',  min = 8,  max = 2000 },
        ['memory:12']     = { best = 'low',  min = 12, max = 3000 },
        ['memory:18']     = { best = 'low',  min = 18, max = 5000 },
        ['memory:clock']  = { best = 'high', min = 1,  max = 300 },         -- pairs found against the clock
        -- two player board games (html/js/apps/games-board.js): online wins count up
        chess            = { best = 'high', min = 1,  max = 100000 },
        checkers         = { best = 'high', min = 1,  max = 100000 },
        c4               = { best = 'high', min = 1,  max = 100000 },
        ttt              = { best = 'high', min = 1,  max = 100000 },
        -- puzzles (html/js/apps/games-puzzle.js): times, taps and moves rank low
        ['sudoku:facil']   = { best = 'low',  min = 20, max = 14400 },
        ['sudoku:medio']   = { best = 'low',  min = 30, max = 14400 },
        ['sudoku:dificil'] = { best = 'low',  min = 40, max = 14400 },
        ['sudoku:perito']  = { best = 'low',  min = 60, max = 14400 },
        words            = { best = 'high', min = 1,  max = 100000 },      -- win streak
        ['words:rapido']  = { best = 'high', min = 1,  max = 60 },          -- words guessed in 90 seconds
        solitaire        = { best = 'low',  min = 15, max = 14400 },
        lights           = { best = 'low',  min = 1,  max = 100000 },      -- 5x5
        ['lights:6']      = { best = 'low',  min = 5,  max = 100000 },      -- 6x6
        ['sliding:3']     = { best = 'low',  min = 1,  max = 100000 },
        ['sliding:4']     = { best = 'low',  min = 1,  max = 100000 },
        ['sliding:5']     = { best = 'low',  min = 10, max = 100000 },
        -- action games (html/js/apps/games-action.js and games-action2.js)
        glide            = { best = 'high', min = 1,  max = 200000 },      -- Classic and Night
        ['glide:dificil'] = { best = 'high', min = 1,  max = 200000 },      -- Hard
        rocks            = { best = 'high', min = 1,  max = 5000000 },
        runner           = { best = 'high', min = 1,  max = 5000000 },
        -- pong and air hockey submit to "pong:facil" / "pong:medio" / "pong:dificil" (and the same for airhockey); a lost match
        -- scores 0 and still counts as a played game, so min is 0 here
        pong             = { best = 'high', min = 0,  max = 10000, variants = true },
        airhockey        = { best = 'high', min = 0,  max = 10000, variants = true },
        slice            = { best = 'high', min = 1,  max = 2000000 },     -- Classic (3 lives)
        ['slice:arcada']  = { best = 'high', min = 1,  max = 200000 },      -- Arcade (60 seconds)
        ['slice:zen']     = { best = 'high', min = 1,  max = 200000 },      -- Zen (90 seconds, no bombs)
        stack            = { best = 'high', min = 1,  max = 100000 },      -- Classic
        ['stack:rapido']  = { best = 'high', min = 1,  max = 100000 },      -- Fast
        hop              = { best = 'high', min = 1,  max = 1000000 },
    },
}
