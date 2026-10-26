-- Internal pack settings — edit config.lua for server setup

Config.DevMode = false -- true = enable dev/debug features (jobeditor / gizmo / polish_placer commands) | false = production mode (recommended for live servers)

Config.NPCCamera = {
    enabled = true,    -- true = cinematic camera on NPC interaction | false = normal camera
    hidePlayer = true, -- true = hide player model during NPC camera | false = show player
    distance = 2.3,    -- camera distance from NPC (meters)
    sideOffset = 0.0,  -- horizontal camera offset from center
    height = 0.3,      -- camera height offset
    fov = 25.0,        -- camera field of view (degrees)
    pitch = 5.0,       -- camera vertical angle (degrees)
    dofLens = 24.0,
    dofFocalLength = 50.0,
    transitionMs = 500, -- camera transition duration (milliseconds)
}

Config.Debug = false                   -- true = print debug logs to console | false = silent
Config.DebugPayment = false            -- true = print detailed payment breakdown (base / multipliers / quest / global event / coop / final delivered) to server console | false = silent. Use ONLY for troubleshooting "why did player receive $X" reports — it is verbose.
Config.Test = false                    -- true = enable test mode | false = normal mode
Config.EventPrefix = "tw-litejobpack"
Config.PreventVehicleWithTool = true   -- true = block entering vehicles while holding a job tool | false = allow
Config.LockWeaponsOnJob = false        -- true = disable weapons (firing + melee + switch) while a job session is active | false = allow
Config.BreakSessionFirstPerson = false -- true = force first person during break sessions | false = any camera angle
Config.PaymentNotifications = true     -- true = show money-related notifications (e.g. "+$80 cleaned") | false = silence them

Config.QualitySystem = {
    enabled = false,        -- true = items have quality tiers (Common/Rare/etc.) | false = no quality system

    levelChanceBonus = 0.5, -- % bonus chance for higher tier per player level
    levelPayBonus = 0.02,   -- % bonus pay per player level (0.02 = 2% per level)

    defaultTiers = {
        { name = "Common",    chance = 55, multiplier = 1.0 },
        { name = "Uncommon",  chance = 25, multiplier = 1.3 },
        { name = "Rare",      chance = 13, multiplier = 1.8 },
        { name = "Legendary", chance = 7,  multiplier = 2.5 },
    },
}

Config.Economy = {
    enabled = false,       -- true = dynamic economy (supply/demand affects prices) | false = fixed prices
    recoveryInterval = 10, -- minutes between stock recovery ticks
    MinMultiplier = 0.5,   -- lowest price multiplier when stock is high (0.5 = 50% of base)
    MaxMultiplier = 2.0,   -- highest price multiplier when stock is low (2.0 = 200% of base)

    BaseStocks = {

        ['coal_ore'] = 2000,
        ['iron_ore'] = 1000,
        ['gold_ore'] = 500,
        ['emerald_ore'] = 300,
        ['diamond_ore'] = 200,

        ['wood_log'] = 1500,
        ['high_grade_log'] = 500,

        ['metal_scrap'] = 2000,
        ['electronics_scrap'] = 800,

        ['wheat'] = 2000,
        ['pumpkin'] = 1000,
        ['fruitpicker'] = 1500,

        ['meat'] = 3000,
        ['horn'] = 500,
        ['pelt'] = 1000,
    }
}

Config.GlobalEvents = {
    enabled = false, -- true = enable server-wide job events | false = no global events
    events = {
        {
            id = "clean_city",
            jobId = "cleanup",
            title = "City Cleanup Initiative",
            description = "The mayor has ordered a city-wide cleanup! We need all hands on deck to collect trash.",
            target = 500,
            reward = {
                money = 5000,
                xp = 1000,
            }
        },

    }
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  ROUTE LEVEL CHECK                                                        │
-- │                                                                           │
-- │  Controls how route/area level requirements are checked in coop lobbies.  │
-- │                                                                           │
-- │  checkAllPlayers = true:                                                  │
-- │    Checks EVERY player's level in the lobby. The LOWEST level is used.    │
-- │    If a Level 1 player joins a Level 5 player, the whole lobby is         │
-- │    limited to Level 1 routes. Prevents carrying low-level players.        │
-- │                                                                           │
-- │  checkAllPlayers = false:                                                 │
-- │    Only the lobby owner's level is checked. High-level owners can         │
-- │    access better routes even with low-level teammates.                    │
-- │                                                                           │
-- │  blockStartIfTooLow = true:                                               │
-- │    When true, Lobby.StartJob refuses to start the job if any member's     │
-- │    level is below the job's minimum required level (job baseline OR the   │
-- │    lowest required level among the job's routes/areas/zones — whichever  │
-- │    is higher). Owner gets a notification naming the under-leveled player. │
-- │                                                                           │
-- │  enforcement = "clamp" (default):                                         │
-- │    When the owner picks a route that some member can't meet, the system   │
-- │    silently clamps the selection down to the highest-level route that     │
-- │    everyone qualifies for. Owner is notified.                             │
-- │                                                                           │
-- │  enforcement = "block":                                                   │
-- │    Same situation, but the route selection is REJECTED entirely. The      │
-- │    owner has to pick a different route or remove the under-leveled       │
-- │    player. Use this if you want strict gating instead of auto-clamp.      │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.RouteLevelCheck = {
    checkAllPlayers    = true,    -- true: checks all lobby members' levels, uses the lowest level for route access
    blockStartIfTooLow = false,   -- true: Lobby.StartJob fails if any member is under the job's minimum level
    enforcement        = "clamp", -- "clamp" (auto-downgrade route) | "block" (reject selection, owner picks again)
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  JOB COOLDOWN                                                             │
-- │                                                                           │
-- │  Prevents players from spamming jobs back-to-back.                        │
-- │  When enabled, a timer starts after completing a job.                     │
-- │                                                                           │
-- │  mode = "perJob":                                                         │
-- │    Cooldown is tracked per job. Finishing "miner" blocks starting         │
-- │    "miner" again for [duration] seconds, but "lumberjack" is allowed.    │
-- │                                                                           │
-- │  mode = "global":                                                         │
-- │    Cooldown applies to ALL jobs. Finishing any job blocks starting        │
-- │    ANY job for [duration] seconds.                                        │
-- │                                                                           │
-- │  In coop: if ANY lobby member has an active cooldown, the entire          │
-- │  lobby is blocked from starting that job.                                 │
-- │                                                                           │
-- │  maxRounds (anti-farm via Continue):                                      │
-- │    The "Continue" button reuses the same session, so it never ends the    │
-- │    job — without a cap, players could Continue forever and the cooldown   │
-- │    would never trigger. maxRounds limits how many rounds (the first run   │
-- │    + Continues) a player gets before Continue is blocked, the job is       │
-- │    force-ended and the cooldown starts. Counted server-side per session   │
-- │    (correct for coop). Only applies when enabled = true.                  │
-- │      e.g. maxRounds = 3 → first run + 2 Continues, then cooldown.         │
-- │      maxRounds = 1 → no Continue at all (cooldown after every round).     │
-- │      maxRounds = 0 → unlimited Continues (old behaviour).                 │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.JobCooldown = {
    enabled = false, -- true = cooldown between jobs | false = no cooldown
    mode = "perJob", -- "perJob" = cooldown per specific job | "global" = cooldown for all jobs
    duration = 120,  -- cooldown duration in seconds
    maxRounds = 3,   -- max rounds (first run + Continues) before Continue is blocked & cooldown starts. 0 = unlimited
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  MAX CONCURRENT LOBBIES                                                    │
-- │                                                                           │
-- │  Limits how many teams/lobbies (solo players count as a 1-man team) can   │
-- │  do the SAME job at the same time. The cap is set PER JOB via the         │
-- │  `maxConcurrentLobbies` field inside shared/jobs/<job>.lua. A job with no  │
-- │  field set is unlimited. When the cap is reached, the next team is blocked │
-- │  from starting that job and notified to pick another career.              │
-- │                                                                           │
-- │  This switch only turns the whole feature on/off. enabled=false keeps the │
-- │  old behaviour (unlimited) regardless of per-job values.                  │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.MaxConcurrentLobbies = {
    enabled = false, -- true = enforce per-job maxConcurrentLobbies limits | false = unlimited
}

Config.Lobby = {
    maxPlayers = 3,      -- max players per coop lobby
    inviteRadius = 8.0,  -- max distance to invite a player (meters)
    inviteTimeout = 30,  -- seconds before invite expires
    kickCooldown = 5,    -- seconds before kicked player can be re-invited
    inviteCooldown = 10, -- seconds between sending invites
}

Config.Keys = {
    inviteAccept  = 246, -- Y key
    inviteDecline = 306, -- CTRL key
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  COOP PAYMENT                                                             │
-- │                                                                           │
-- │  Controls how payment is distributed when multiple players work together. │
-- │  These are GLOBAL defaults — individual jobs can override with            │
-- │  job.payment.coopMode and job.payment.coopBonus.                          │
-- │                                                                           │
-- │  When disabled: all players receive the base job payment, no adjustment.  │
-- │                                                                           │
-- │  mode = "full" + bonus = 1.2:                                             │
-- │    Each player gets: basePay × 1.2  (everyone gets full pay + 20% bonus) │
-- │    Example: $1000 base, 2 players → each gets $1200                       │
-- │                                                                           │
-- │  mode = "split" + bonus = 1.2:                                            │
-- │    Each player gets: (basePay / playerCount) × 1.2                        │
-- │    Example: $1000 base, 2 players → each gets $600  (500 × 1.2)          │
-- │                                                                           │
-- │  Bonus behavior:                                                          │
-- │    bonus >= 1.0 → flat multiplier (1.2 = always 20% bonus)               │
-- │    bonus <  1.0 → scales per extra player                                 │
-- │      formula: 1.0 + bonus × (playerCount - 1)                            │
-- │      e.g. bonus=0.1, 3 players → 1.0 + 0.1×2 = 1.20 (20% bonus)        │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  PAY ROUNDING — how the final payout is rounded                            │
-- │                                                                           │
-- │  Job math (item prices, quality/level bonuses, coop split) runs on RAW    │
-- │  floats, so fractional prices add up exactly — set a fruit to 0.40 and    │
-- │  20 of them pay 8.00. Rounding happens ONCE, on the amount actually       │
-- │  handed to the player.                                                    │
-- │                                                                           │
-- │    'ceil'    → complete to the next whole unit, 0.40 pays 1 (default —    │
-- │                QB/ESX money is integer-only and half-up would pay 0       │
-- │                for a sub-0.50 payout)                                     │
-- │    'integer' → whole units, standard half-up rounding (0.40 → 0)          │
-- │    'cents'   → two decimals, e.g. 8.40 (needs a fractional economy)       │
-- │    'none'    → pay the raw value untouched (framework decides)            │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.PayRounding = 'integer'

Config.CoopPayment = {
    enabled = false, -- true = apply coop payment rules | false = everyone gets base pay
    mode = "full",   -- "full" = everyone gets full pay | "split" = pay divided by player count
    bonus = 1.2,     -- coop pay multiplier (1.2 = 20% bonus when playing together)
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  DAILY BONUS                                                              │
-- │                                                                           │
-- │  Every day, random jobs are selected to receive a pay bonus.              │
-- │  Selection resets at midnight (server time) — same bonus jobs all day.    │
-- │                                                                           │
-- │  How it works:                                                            │
-- │    1. System picks random number of jobs (bonusJobCount min-max)          │
-- │    2. Each selected job gets a random pay multiplier (bonusRange min-max) │
-- │    3. All players doing that job today earn boosted pay                    │
-- │                                                                           │
-- │  Example with defaults:                                                   │
-- │    Today: "miner" (1.35x) and "delivery" (1.48x) are bonus jobs          │
-- │    Miner earning $1000 → gets $1350 instead                               │
-- │    Tomorrow: different random jobs will be selected                        │
-- │                                                                           │
-- │  excludeJobs: list of job IDs that should never be selected               │
-- │    e.g. excludeJobs = { "taxi", "trucker" }                               │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.DailyBonus = {
    enabled = false,                         -- true = random daily bonus jobs | false = no daily bonus
    bonusJobCount = { min = 1, max = 3 },    -- how many jobs get daily bonus (random between min-max)
    bonusRange = { min = 1.25, max = 1.50 }, -- pay multiplier range for bonus jobs (1.25 = 25% bonus)
    excludeJobs = {},                        -- job IDs to exclude from daily bonus rotation
}

Config.CoopLeaderboard = {
    enabled = true,           -- true = show coop leaderboard in UI | false = hide it
    broadcastInterval = 5000, -- leaderboard update interval (milliseconds)
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  WEATHER IMPACT                                                           │
-- │                                                                           │
-- │  Adjusts job pay based on current in-game weather. Client detects         │
-- │  weather every [reportInterval] ms and reports to server.                 │
-- │                                                                           │
-- │  Rules format:  WEATHER = { default = X, jobId = Y, ... }                │
-- │                                                                           │
-- │  Multiplier values:                                                       │
-- │    1.0  = no effect (neutral)                                             │
-- │    >1.0 = bonus   (1.20 = +20% pay — harder/riskier work in weather)     │
-- │    <1.0 = penalty  (0.85 = -15% pay — weather makes job easier/less)     │
-- │                                                                           │
-- │  "default" = fallback for jobs not explicitly listed in that weather.     │
-- │  Empty table {} = no impact for that weather (e.g. CLEAR = normal pay).   │
-- │                                                                           │
-- │  Example: RAIN + farmer → 1.20 (rain helps crops, +20% pay)              │
-- │           RAIN + cleaner → 0.85 (rain already cleans, -15% pay)           │
-- │           RAIN + miner → not listed, uses default 1.0 (no effect)         │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.WeatherImpact = {
    enabled = false,        -- true = weather affects job pay | false = no weather impact
    reportInterval = 60000, -- weather check interval (milliseconds)
    rules = {
        RAIN = { default = 1.0, cleaner = 0.85, powerwash = 0.85, farmer = 1.20, landscaping = 1.20, fruitpicker = 1.15 },
        THUNDER = { default = 1.0, miner = 1.15, lumberjack = 1.15, scrapyard = 1.15 },
        FOGGY = { default = 1.0, delivery = 1.15, trucker = 1.15, newspaper = 1.15 },
        SNOW = { default = 1.0, powerlines = 1.20, fishing = 0.80, diving = 0.80 },
        CLEAR = {},
        EXTRASUNNY = { default = 1.0, farmer = 1.10, fruitpicker = 1.10 },
    },
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  SHIFT SYSTEM                                                             │
-- │                                                                           │
-- │                                                                           │
-- │  Adjusts job pay based on server time-of-day. Uses os.date (server time). │
-- │                                                                           │
-- │  hours = { start, end } → start is inclusive, end is exclusive             │
-- │    {6, 12}  = 06:00 – 11:59  (morning)                                   │
-- │    {12, 18} = 12:00 – 17:59  (afternoon)                                 │
-- │    {18, 24} = 18:00 – 23:59  (evening)                                   │
-- │    {0, 6}   = 00:00 – 05:59  (night)                                     │
-- │                                                                           │
-- │  rules: same system as WeatherImpact — default = fallback multiplier,     │
-- │    job-specific overrides possible (e.g. diving = 0.80 at night).         │
-- │    1.0 = no change, >1.0 = bonus, <1.0 = penalty.                        │
-- │                                                                           │
-- │  icon: UI display icon for the shift indicator (shown in job HUD).        │
-- │                                                                           │
-- │  Example: Night shift → all jobs get 1.30x (+30% bonus) but              │
-- │           diving only gets 0.80x (-20% penalty, too dark to dive).        │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.ShiftSystem = {
    enabled = false, -- true = time-of-day affects pay | false = no shift bonuses
    shifts = {
        morning   = { label = "Morning Shift", icon = "sun", hours = { 6, 12 }, rules = { default = 0.90 } },
        afternoon = { label = "Afternoon Shift", icon = "cloud", hours = { 12, 18 }, rules = { default = 1.00 } },
        evening   = { label = "Evening Shift", icon = "moon", hours = { 18, 24 }, rules = { default = 1.15 } },
        night     = { label = "Night Shift", icon = "star", hours = { 0, 6 }, rules = { default = 1.30, diving = 0.80 } },
    },
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  REFERRAL BONUS                                                           │
-- │                                                                           │
-- │  Awards XP when a player invites someone to their coop lobby.             │
-- │  Triggers automatically when an invite is ACCEPTED (not on send).         │
-- │  BOTH the inviter and the invited player receive the XP reward.           │
-- │                                                                           │
-- │  Same player pair can only earn bonus once per day (prevents abuse).      │
-- │  maxBonusesPerDay limits total referral bonuses per player per day.       │
-- │  Resets at midnight (server time).                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.ReferralBonus = {
    enabled = false,      -- true = XP bonus for referring new players | false = no referral system
    xpReward = 150,       -- XP given to BOTH inviter and invited player
    maxBonusesPerDay = 5, -- max referral bonuses each player can earn per day
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  JOB FUNCTIONS (GLOBAL)                                                   │
-- │                                                                           │
-- │  Custom functions that run before/after every job.                        │
-- │  These apply to ALL jobs unless a specific job overrides them             │
-- │  with its own startJobFunction / endJobFunction in shared/jobs/*.lua.     │
-- │                                                                           │
-- │  Per-job override: set enabled = true on a job's startJobFunction /       │
-- │  endJobFunction / resetJobFunction in shared/jobs/*.lua. If enabled on    │
-- │  the job, the global function here is skipped for that job.               │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- This function is called for each player in the lobby before starting the job
-- Return true to allow the player to start, false to prevent
-- @param source: Player's server ID
-- @param ownerIdentifier: Lobby owner's identifier (license/steam/etc)
-- @param jobId: The job being started (e.g. "miner", "fishing")
Config.startJobFunction = {
    enabled = false, -- true = enable global start check for ALL jobs | false = skip
    func = function(source, ownerIdentifier, jobId)
        -- Example: Check if player has specific job limit
        -- local JobLimit = exports['santosvibe-utility']:GetJobLimit(source, jobId)
        -- if not JobLimit.success then
        --     TriggerClientEvent('codem-notification:send', source, 'error', JobLimit.message, 5000)
        --     return false
        -- end

        return true -- Default: Allow everyone
    end,
}

-- This function is called for each player in the lobby when the job is completed
-- @param source        : Player's server ID
-- @param ownerIdentifier : Lobby owner's identifier (license/steam/etc)
-- @param jobId         : The job that was completed
-- @param lobbyMoney    : total money earned by the entire lobby during this job
-- @param playerMoney   : lobbyMoney divided by the number of lobby players (this player's share)
-- @param lobbyAmount   : total "work units" done by the entire lobby (meaning depends on the job)
-- @param playerAmount  : lobbyAmount divided by the number of lobby players (this player's share)
--
-- What "amount" means per job:
--   delivery        -> boxes delivered
--   newspaper       -> newspapers delivered
--   cardetailer     -> cars washed + polished
--   cleanup         -> trash bags collected
--   dogwalking      -> dogs returned home
--   warehouse       -> boxes+pallets loaded
--   forklift        -> crates placed on belt / shelf
--   hunting         -> carcasses processed
--   landscaping     -> bushes trimmed + lawns mowed
--   trucker         -> trailers delivered
--   treasurehunter  -> treasures loaded into the boat
--   miner           -> ore rocks processed on the scale
--   lumberjack      -> logs processed
--   scrapyard       -> scrap items processed
--   farmer          -> crop boxes processed
--   fruitpicker     -> fruit boxes processed
--   cleaner         -> stains cleaned
--   powerwash       -> stains cleaned
--   windowscleaner  -> windows cleaned
--   powerlines      -> panels/poles fixed
--   tiretechnician  -> tires repaired
-- NOT included (satış bazlı veya disabled): fishing, diving, taxi
Config.endJobFunction = {
    enabled = false, -- true = enable global end function for ALL jobs | false = skip
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
        print(('[tw-litejobpack][endJobFunction] src=%s owner=%s job=%s | lobbyMoney=$%s playerMoney=$%s | lobbyAmount=%s playerAmount=%s')
            :format(tostring(source), tostring(ownerIdentifier), tostring(jobId),
                tostring(lobbyMoney), tostring(playerMoney),
                tostring(lobbyAmount), tostring(playerAmount)))
        -- Example: Add job limit after completion
        -- exports['santosvibe-utility']:AddJobLimit(source, jobId, 1)
    end,
}

-- This function is called for each player in the lobby when the job is CANCELLED
-- (not completed) — e.g. owner leaves mid-job, member leaves mid-job, lobby
-- disbands before finishJob, or session cleanup occurs without jobCompleted.
-- @param source         : Player's server ID
-- @param ownerIdentifier : Lobby owner's identifier (license/steam/etc)
-- @param jobId          : The job that was cancelled
-- @param lobbyMoney     : total money accumulated by the lobby up to cancel (0 if not tracked)
-- @param playerMoney    : lobbyMoney divided by the number of lobby players
-- @param lobbyAmount    : total work units done by the lobby up to cancel (0 if not tracked)
-- @param playerAmount   : lobbyAmount divided by the number of lobby players
--
-- Use cases: refund a job-limit charge, clear a per-run buff, log cancels, etc.
Config.resetJobFunction = {
    enabled = false, -- true = enable global reset function for ALL jobs | false = skip
    func = function(source, ownerIdentifier, jobId, lobbyMoney, playerMoney, lobbyAmount, playerAmount)
        print(('[tw-litejobpack][resetJobFunction] src=%s owner=%s job=%s | lobbyMoney=$%s playerMoney=$%s | lobbyAmount=%s playerAmount=%s')
            :format(tostring(source), tostring(ownerIdentifier), tostring(jobId),
                tostring(lobbyMoney), tostring(playerMoney),
                tostring(lobbyAmount), tostring(playerAmount)))
        -- Example: Refund a job limit that was consumed at start
        -- exports['santosvibe-utility']:AddJobLimit(source, jobId, 1)
    end,
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  ACHIEVEMENTS                                                             │
-- │                                                                           │
-- │  Tracks player progress and awards XP when milestones are reached.        │
-- │  Saved to SQL (tw_jobpack_achievements) — persists across sessions.       │
-- │                                                                           │
-- │  Achievement types:                                                       │
-- │    "level"    → reach a specific level in a job                           │
-- │    "collect"  → collect X items (mining, chopping, etc.)                  │
-- │    "earn"     → earn $X total from jobs                                   │
-- │    "complete" → finish X job runs                                         │
-- │    "process"  → process X items (refinery, sell point, etc.)              │
-- │                                                                           │
-- │  jobId = "*" → tracks across ALL jobs (global stat)                       │
-- │  jobId = "miner" → only counts actions in that specific job              │
-- │                                                                           │
-- │  discordWebhook: requires DiscordLogConfig.webhooks.achievement URL       │
-- │  to be set in server/editable.lua. Sends embed with player name,         │
-- │  achievement label, and XP reward when unlocked.                          │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  ACHIEVEMENTS                                                              │
-- │                                                                            │
-- │  Achievement labels & descriptions shown in the UI are loaded from locale  │
-- │  files: html/dist/locales/{lang}.json -> "achievements" section            │
-- │    e.g. "achievements.miner_lv5.label", "achievements.miner_lv5.desc"      │
-- │                                                                            │
-- │  Only id, jobId, type, target, and xpReward are configured here.           │
-- │  discordWebhook: requires DiscordLogConfig.webhooks.achievement URL        │
-- │  to be set in server/editable.lua.                                         │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.Achievements = {
    enabled = true,        -- true = achievement system active | false = no achievements
    discordWebhook = true, -- true = send achievement notifications to Discord | false = no webhook
    list = {

        { id = "miner_lv5",          jobId = "miner",          type = "level",    target = 5,      xpReward = 500 },
        { id = "miner_lv10",         jobId = "miner",          type = "level",    target = 10,     xpReward = 2000 },
        { id = "lumberjack_lv5",     jobId = "lumberjack",     type = "level",    target = 5,      xpReward = 500 },
        { id = "fishing_lv5",        jobId = "fishing",        type = "level",    target = 5,      xpReward = 500 },
        { id = "cleanup_lv5",        jobId = "cleanup",        type = "level",    target = 5,      xpReward = 500 },
        { id = "delivery_lv5",       jobId = "delivery",       type = "level",    target = 5,      xpReward = 500 },
        { id = "trucker_lv5",        jobId = "trucker",        type = "level",    target = 5,      xpReward = 500 },
        { id = "hunting_lv5",        jobId = "hunting",        type = "level",    target = 5,      xpReward = 500 },
        { id = "taxi_lv5",           jobId = "taxi",           type = "level",    target = 5,      xpReward = 500 },
        { id = "powerlines_lv5",     jobId = "powerlines",     type = "level",    target = 5,      xpReward = 500 },
        { id = "diving_lv5",         jobId = "diving",         type = "level",    target = 5,      xpReward = 500 },
        { id = "cleaner_lv5",        jobId = "cleaner",        type = "level",    target = 5,      xpReward = 500 },
        { id = "powerwash_lv5",      jobId = "powerwash",      type = "level",    target = 5,      xpReward = 500 },
        { id = "windowscleaner_lv5", jobId = "windowscleaner", type = "level",    target = 5,      xpReward = 500 },
        { id = "cardetailer_lv5",    jobId = "cardetailer",    type = "level",    target = 5,      xpReward = 500 },
        { id = "farmer_lv5",         jobId = "farmer",         type = "level",    target = 5,      xpReward = 500 },
        { id = "fruitpicker_lv5",    jobId = "fruitpicker",    type = "level",    target = 5,      xpReward = 500 },
        { id = "landscaping_lv5",    jobId = "landscaping",    type = "level",    target = 5,      xpReward = 500 },
        { id = "dogwalking_lv5",     jobId = "dogwalking",     type = "level",    target = 5,      xpReward = 500 },
        { id = "newspaper_lv5",      jobId = "newspaper",      type = "level",    target = 5,      xpReward = 500 },
        { id = "scrapyard_lv5",      jobId = "scrapyard",      type = "level",    target = 5,      xpReward = 500 },
        { id = "warehouse_lv5",      jobId = "warehouse",      type = "level",    target = 5,      xpReward = 500 },
        { id = "forklift_lv5",       jobId = "forklift",       type = "level",    target = 5,      xpReward = 500 },

        { id = "collect_100",        jobId = "*",              type = "collect",  target = 100,    xpReward = 300 },
        { id = "collect_500",        jobId = "*",              type = "collect",  target = 500,    xpReward = 800 },
        { id = "collect_1000",       jobId = "*",              type = "collect",  target = 1000,   xpReward = 1500 },

        { id = "miner_collect_500",  jobId = "miner",          type = "collect",  target = 500,    xpReward = 1000 },
        { id = "lumber_collect_500", jobId = "lumberjack",     type = "collect",  target = 500,    xpReward = 1000 },

        { id = "earn_10000",         jobId = "*",              type = "earn",     target = 10000,  xpReward = 500 },
        { id = "earn_50000",         jobId = "*",              type = "earn",     target = 50000,  xpReward = 2000 },
        { id = "earn_100000",        jobId = "*",              type = "earn",     target = 100000, xpReward = 5000 },

        { id = "complete_10",        jobId = "*",              type = "complete", target = 10,     xpReward = 300 },
        { id = "complete_50",        jobId = "*",              type = "complete", target = 50,     xpReward = 1000 },
        { id = "complete_100",       jobId = "*",              type = "complete", target = 100,    xpReward = 2000 },

        { id = "process_100",        jobId = "*",              type = "process",  target = 100,    xpReward = 500 },
        { id = "process_500",        jobId = "*",              type = "process",  target = 500,    xpReward = 1500 },
    },
}

Config.RequiredXP = {
    [1] = 1000,
    [2] = 1500,
    [3] = 2000,
    [4] = 2500,
    [5] = 3000,
    [6] = 3500,
    [7] = 4000,
    [8] = 4500,
    [9] = 5000,
    [10] = 6000,
}

Config.MaxLevel = 10 -- maximum player level cap

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  RP Mode — disables progression for strict roleplay servers                │
-- │                                                                             │
-- │  When enabled = true:                                                       │
-- │    • XP grants become no-ops (no XP awarded, no level-ups)                 │
-- │    • Existing player levels are preserved (turning RPMode off restores)    │
-- │    • Admin SetLevel still works (manual overrides unaffected)              │
-- │                                                                             │
-- │  Recommended companion settings for a "pure RP jobs" setup:                │
-- │    Config.MaxLevel = 1                                                      │
-- │    Config.Quests.enabled = false                                            │
-- │    Config.Achievements.enabled = false                                      │
-- │    Config.DailyBonus.enabled = false                                        │
-- │    All Config.Perks[*].enabled = false                                      │
-- │                                                                             │
-- │  Note: the level/XP UI panel still renders (always shows level 1).         │
-- │  Hiding the UI requires NUI changes — separate update.                     │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.RPMode = {
    enabled = false, -- true = strict RP server (no progression) | false = full progression system
}

-- (opsiyonel) Tablo yerine formül kullan. Nil ise Config.RequiredXP tablosu kullanılır.
-- Örn: function(level) return 1000 + (level - 1) * 500 end
Config.RequiredXPFormula = nil

-- (opsiyonel) Job reward'ına dışarıdan çarpan uygulamak için resolver.
-- Nil ise çarpan uygulanmaz. Dönen değer 1.0 = değişiklik yok.
-- Örn: function(source, identifier, jobId, baseAmount)
--     local globalLevel = exports['my-global-xp']:GetLevel(source) or 1
--     return 1.0 + (globalLevel * 0.01) -- her global level %1 bonus
-- end
Config.RewardMultiplierResolver = nil

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  External Level Bridge — delegate level reads to YOUR own level/skill system │
-- │                                                                             │
-- │  When set to a function, EVERY level read in the pack uses the value YOU     │
-- │  return instead of tw-litejobpack's internal XP:                            │
-- │    • route / area / rod unlock gates (requiredLevel)                        │
-- │    • level pay bonus + level loot-chance bonus                             │
-- │    • NUI level panel + leaderboard reads                                    │
-- │                                                                             │
-- │  Return: a number → the player's level for that job (used everywhere)        │
-- │          nil      → fall back to the pack's own level (partial adoption OK)  │
-- │                                                                             │
-- │  Setting this ALSO makes AddXP a no-op — your system owns XP now, so the     │
-- │  pack stops writing levels. (Config.RPMode not required; both is harmless.) │
-- │                                                                             │
-- │  Args:                                                                       │
-- │    identifier → framework identifier (citizenid / license / …)              │
-- │    jobId      → job being checked ("miner","fishing"…). Ignore if your       │
-- │                 system is a single global level.                            │
-- │    source     → server id when available (nil on some UI-only reads).        │
-- │                                                                             │
-- │  Scale note: route requiredLevel values are on a 0–10 scale. If your system │
-- │  uses a different range (e.g. 1–100), map it to 0–10 before returning, or    │
-- │  set every requiredLevel in shared/jobs/*.lua to 0 to drop route gating.    │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Example:
-- Config.ExternalLevelResolver = function(identifier, jobId, source)
--     local src = source or 0
--     return exports['my-skills']:GetSkillLevel(src, jobId) -- must return a number
-- end
Config.ExternalLevelResolver = nil

Config.Tools = {
    miner = {

        default = {
            id = "default",
            label = "Rusty Pickaxe",
            prop = "prop_tool_pickaxe_rusted",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 2,
            },

            handAttach = {
                boneId = 28422,
                x = 0.07,
                y = 0.02,
                z = 0.0,
                rotX = 300.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.16,
                z = 0.03,
                rotX = 182.1,
                rotY = 92.0,
                rotZ = 0.0
            },
        },

        v2 = {
            id = "v2",
            label = "Steel Pickaxe",
            prop = "prop_tool_pickaxe",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.06,
                y = 0.02,
                z = 0.0,
                rotX = 300.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.16,
                z = 0.03,
                rotX = 182.1,
                rotY = 92.0,
                rotZ = 0.0
            },
        },

        hilti = {
            id = "hilti",
            label = "Carbon Pickaxe",
            prop = "prop_tool_pickaxe_pro",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            breakSession = {
                ballCount = { min = 3, max = 4 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.06,
                y = 0.03,
                z = 0.0,
                rotX = 300.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.16,
                z = 0.03,
                rotX = 182.1,
                rotY = 92.0,
                rotZ = 0.0
            },
        },
    },

    lumberjack = {

        default = {
            id = "default",
            label = "Rusty Hatchet",
            prop = "prop_tool_fireaxe_rusted",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 2,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.0,
                z = 0.0,
                rotX = 270.01,
                rotY = 180.01,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.2,
                y = -0.14,
                z = -0.1,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0
            },
        },

        v2 = {
            id = "v2",
            label = "Steel Hatchet",
            prop = "prop_ld_fireaxe",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.0,
                z = 0.0,
                rotX = 270.01,
                rotY = 180.01,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.2,
                y = -0.14,
                z = -0.1,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0
            },
        },

        chainsaw = {
            id = "chainsaw",
            label = "Carbon Axe",
            prop = "prop_tool_fireaxe_pro",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            breakSession = {
                ballCount = { min = 3, max = 4 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.059,
                y = 0.001,
                z = -0.026,
                rotX = 231.01,
                rotY = 180.01,
                rotZ = 0.0
            },

            beltAttach = {
                x = 0.2,
                y = -0.16,
                z = 0.0,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0
            },
        },
    },

    farmer = {

        default = {
            id = "default",
            label = "Basic Trowel",
            prop = "prop_cs_trowel",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 2,
            },
            handAttach = {
                boneId = 28422,
                x = 0.08,
                y = 0.05,
                z = 0.0,
                rotX = 120.0,
                rotY = -10.0,
                rotZ = -50.0
            },
            beltAttach = {
                boneId = 11816,
                x = 0.1,
                y = 0.02,
                z = -0.24,
                rotX = 80.0,
                rotY = 200.0,
                rotZ = 80.0
            },
        },

        v2 = {
            id = "v2",
            label = "Steel Trowel",
            prop = "prop_tool_shovel2",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.05,
                z = 0.0,
                rotX = 120.0,
                rotY = -10.0,
                rotZ = -50.0
            },
            beltAttach = {
                boneId = 11816,
                x = 0.12,
                y = 0.02,
                z = -0.24,
                rotX = 80.0,
                rotY = 200.0,
                rotZ = 80.0
            },
        },

        v3 = {
            id = "v3",
            label = "Power Tiller",
            prop = "prop_tool_shovel2",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            breakSession = {
                ballCount = { min = 3, max = 4 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.05,
                z = 0.0,
                rotX = 120.0,
                rotY = -10.0,
                rotZ = -50.0
            },
            beltAttach = {
                boneId = 11816,
                x = 0.12,
                y = 0.02,
                z = -0.24,
                rotX = 80.0,
                rotY = 200.0,
                rotZ = 80.0
            },
        },
    },

    scrapyard = {

        default = {
            id = "default",
            label = "Basic Crowbar",
            prop = "w_me_crowbar",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 2,
            },
            handAttach = {
                boneId = 28422,
                x = 0.08,
                y = 0.02,
                z = 0.0,
                rotX = 280.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                boneId = 11816,
                x = 0.18,
                y = -0.12,
                z = -0.08,
                rotX = 180.0,
                rotY = 80.0,
                rotZ = 0.0
            },
        },

        v2 = {
            id = "v2",
            label = "Reinforced Crowbar",
            prop = "w_me_crowbar",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            breakSession = {
                ballCount = { min = 3, max = 4 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.08,
                y = 0.02,
                z = 0.0,
                rotX = 280.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                boneId = 11816,
                x = 0.18,
                y = -0.12,
                z = -0.08,
                rotX = 180.0,
                rotY = 80.0,
                rotZ = 0.0
            },
        },

        cutter = {
            id = "cutter",
            label = "Electric Cutter",
            prop = "prop_tool_consaw",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            breakSession = {
                ballCount = { min = 2, max = 3 },
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.15,
                y = 0.05,
                z = 0.0,
                rotX = 0.0,
                rotY = 90.0,
                rotZ = 0.0
            },
            beltAttach = {
                boneId = 11816,
                x = 0.25,
                y = -0.15,
                z = -0.1,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0
            },
        },
    },

    powerlines = {
        default = {
            id = "default",
            label = "Screwdriver",
            prop = "prop_tool_screwdvr01",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            handAttach = {
                boneId = 28422,
                x = 0.0,
                y = 0.0,
                z = 0.0,
                rotX = 0.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.1,
                y = -0.08,
                z = -0.05,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0
            },
        },
        v2 = {
            id = "v2",
            label = "Power Drill",
            prop = "prop_tool_drill",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.02,
                z = 0.0,
                rotX = 0.0,
                rotY = 90.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.1,
                z = -0.1,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0
            },
        },

        v3 = {
            id = "v3",
            label = "Impact Driver",
            prop = "prop_tool_drill",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.02,
                z = 0.0,
                rotX = 0.0,
                rotY = 90.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.1,
                z = -0.1,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0
            },
        },
    },

    cleaner = {
        default = {
            id = "default",
            label = "Basic Mop",
            prop = "prop_cs_mop_s",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            breakSession = {
                ballsPerSession = 4,
                repeatPerBall = 2,
            },
            handAttach = {
                boneId = 28422,
                x = -0.02,
                y = -0.06,
                z = -0.2,
                rotX = -13.377,
                rotY = 10.3568,
                rotZ = 17.9681,
            },
            beltAttach = {
                x = 0.25,
                y = -0.15,
                z = -0.1,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0,
            },
        },
        v2 = {
            id = "v2",
            label = "Industrial Mop",
            prop = "prop_cs_mop_s",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            breakSession = {
                ballsPerSession = 4,
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = -0.02,
                y = -0.06,
                z = -0.2,
                rotX = -13.377,
                rotY = 10.3568,
                rotZ = 17.9681,
            },
            beltAttach = {
                x = 0.25,
                y = -0.15,
                z = -0.1,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0,
            },
        },
        v3 = {
            id = "v3",
            label = "Steam Mop",
            prop = "prop_cs_mop_s",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            breakSession = {
                ballsPerSession = 3,
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = -0.02,
                y = -0.06,
                z = -0.2,
                rotX = -13.377,
                rotY = 10.3568,
                rotZ = 17.9681,
            },
            beltAttach = {
                x = 0.25,
                y = -0.15,
                z = -0.1,
                rotX = 180.0,
                rotY = 90.0,
                rotZ = 0.0,
            },
        },
    },

    windowscleaner = {
        default = {
            id = "default",
            label = "Basic Sponge",
            prop = "prop_sponge_01",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            breakSession = {
                ballsPerSession = 4,
                repeatPerBall = 2,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.0,
                z = -0.03,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0,
            },
            beltAttach = {
                x = 0.15,
                y = -0.1,
                z = -0.1,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0,
            },
        },
        v2 = {
            id = "v2",
            label = "Pro Squeegee",
            prop = "prop_sponge_01",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            breakSession = {
                ballsPerSession = 4,
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.0,
                z = -0.03,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0,
            },
            beltAttach = {
                x = 0.15,
                y = -0.1,
                z = -0.1,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0,
            },
        },
        v3 = {
            id = "v3",
            label = "Electric Scrubber",
            prop = "prop_sponge_01",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            breakSession = {
                ballsPerSession = 3,
                repeatPerBall = 1,
            },
            handAttach = {
                boneId = 28422,
                x = 0.1,
                y = 0.0,
                z = -0.03,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0,
            },
            beltAttach = {
                x = 0.15,
                y = -0.1,
                z = -0.1,
                rotX = 90.0,
                rotY = 0.0,
                rotZ = 0.0,
            },
        },
    },

    cardetailer = {
        default = {
            id = "default",
            label = "Basic Wand",
            prop = "w_ar_pressure1",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            handAttach = {
                boneId = 18905,
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
            beltAttach = {
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
        },
        v2 = {
            id = "v2",
            label = "Pro Wand",
            prop = "w_ar_pressure1",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            handAttach = {
                boneId = 18905,
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
            beltAttach = {
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
        },
        v3 = {
            id = "v3",
            label = "Industrial Wand",
            prop = "w_ar_pressure1",
            price = 15000,
            levelRequired = 0,
            efficiency = 2.0,
            handAttach = {
                boneId = 18905,
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
            beltAttach = {
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
        },
    },

    powerwash = {
        default = {
            id = "default",
            label = "Basic Washer",
            prop = "w_ar_pressure1",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            handAttach = {
                boneId = 18905,
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
            beltAttach = {
                x = 0.7,
                y = -0.1,
                z = -0.33,
                rotX = 77.0,
                rotY = 270.0,
                rotZ = -10.0,
            },
        },
        v2 = {
            id = "v2",
            label = "Turbo Washer",
            prop = "w_ar_pressure1",
            price = 5000,
            levelRequired = 0,
            efficiency = 1.5,
            handAttach = {
                boneId = 18905,
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
            beltAttach = {
                x = 0.7,
                y = -0.1,
                z = -0.33,
                rotX = 77.0,
                rotY = 270.0,
                rotZ = -10.0,
            },
        },
        v3 = {
            id = "v3",
            label = "Industrial Washer",
            prop = "w_ar_pressure1",
            price = 15000,
            levelRequired = 0,
            efficiency = 3.0,
            handAttach = {
                boneId = 18905,
                x = 0.09,
                y = 0.01,
                z = 0.0,
                rotX = 300.0,
                rotY = 720.0,
                rotZ = 330.0,
            },
            beltAttach = {
                x = 0.7,
                y = -0.1,
                z = -0.33,
                rotX = 77.0,
                rotY = 270.0,
                rotZ = -10.0,
            },
        },
    },

    hunting = {
        default = {
            id = "default",
            label = "Hunting Rifle",
            prop = nil,
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,
            weaponHash = "weapon_musket",
            ammo = 30,
            damageMultiplier = 1.0,
        },
        sniper = {
            id = "sniper",
            label = "Bolt-Action Rifle",
            prop = nil,
            price = 5000,
            levelRequired = 0,
            efficiency = 1.3,
            weaponHash = "weapon_sniperrifle",
            ammo = 40,
            damageMultiplier = 1.3,
        },
        heavy = {
            id = "heavy",
            label = "Heavy Sniper",
            prop = nil,
            price = 15000,
            levelRequired = 0,
            efficiency = 1.6,
            weaponHash = "weapon_heavysniper",
            ammo = 50,
            damageMultiplier = 1.6,
        },
    },

    dogwalking = {
        default = {
            id = "default",
            label = "Basic Leash",
            prop = nil,
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)
            leash = {
                canSprint = false,
                hasRope = true,
                ropeLength = 3.0,
                dogSpeed = 2.0,
            },
        },
        v2 = {
            id = "v2",
            label = "Pro Leash",
            prop = nil,
            price = 3000,
            levelRequired = 0,
            efficiency = 1.5,
            leash = {
                canSprint = true,
                hasRope = true,
                ropeLength = 5.0,
                maxDistance = 8.0,
                dogSpeed = 4.0,
            },
        },
        whistle = {
            id = "whistle",
            label = "Whistle Training",
            prop = nil,
            price = 10000,
            levelRequired = 0,
            efficiency = 2.0,
            leash = {
                canSprint = true,
                hasRope = false,
                dogSpeed = 5.0,
            },
        },
    },

    metaldetector = {

        default = {
            id = "default",
            label = "Basic Detector",
            prop = "bostra_detector",
            price = 0,         -- purchase price ($0 = free/default tool)
            levelRequired = 0, -- minimum level to unlock (0 = available from start)
            efficiency = 1.0,  -- work speed multiplier (1.0 = normal, 2.0 = twice as fast)

            -- Tier gameplay: rangeMult scales the detection/beep range,
            -- lootBonus is added to the rare loot weights on the dig roll
            -- (the fishing rods' catchBonus, detector flavored).
            detector = { rangeMult = 1.0, lootBonus = 0 },
            breakSession = {
                ballCount = { min = 4, max = 5 },
                repeatPerBall = 1,
            },

            handAttach = {
                boneId = 28422,
                x = 0.10,
                y = 0.02,
                z = 0.10,
                rotX = 180.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.16,
                z = 0.03,
                rotX = 182.1,
                rotY = 92.0,
                rotZ = 0.0
            },
        },

        v2 = {
            id = "v2",
            label = "Carbon Detector",
            prop = "bostra_detector", -- same prop for now; swap per tier when variants exist
            price = 5000,
            levelRequired = 3,
            efficiency = 1.5,

            detector = { rangeMult = 1.25, lootBonus = 6 },
            breakSession = {
                ballCount = { min = 3, max = 4 },
                repeatPerBall = 1,
            },

            handAttach = {
                boneId = 28422,
                x = 0.10,
                y = 0.02,
                z = 0.10,
                rotX = 180.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.16,
                z = 0.03,
                rotX = 182.1,
                rotY = 92.0,
                rotZ = 0.0
            },
        },

        pro = {
            id = "pro",
            label = "Pulse Pro Detector",
            prop = "bostra_detector", -- same prop for now; swap per tier when variants exist
            price = 15000,
            levelRequired = 5,
            efficiency = 2.0,

            detector = { rangeMult = 1.5, lootBonus = 12 },
            breakSession = {
                ballCount = { min = 2, max = 3 },
                repeatPerBall = 1,
            },

            handAttach = {
                boneId = 28422,
                x = 0.10,
                y = 0.02,
                z = 0.10,
                rotX = 180.0,
                rotY = 0.0,
                rotZ = 0.0
            },
            beltAttach = {
                x = 0.15,
                y = -0.16,
                z = 0.03,
                rotX = 182.1,
                rotY = 92.0,
                rotZ = 0.0
            },
        },
    },
}

function Config.GetToolConfig(jobId, toolId)
    if Config.Tools[jobId] and Config.Tools[jobId][toolId] then
        return Config.Tools[jobId][toolId]
    end

    if Config.Tools[jobId] and Config.Tools[jobId].default then
        return Config.Tools[jobId].default
    end
    return nil
end

function Config.GetJobTools(jobId)
    return Config.Tools[jobId] or {}
end

function Config.CanUnlockTool(jobId, toolId, playerLevel)
    local tool = Config.GetToolConfig(jobId, toolId)
    if not tool then return false end

    if tool.levelRequired == 0 then
        return true
    end

    return playerLevel >= tool.levelRequired
end

Config.Leaderboard = {
    topCount = 20,        -- number of players shown on leaderboard
    refreshInterval = 60, -- seconds between leaderboard refresh
    rankBy = "level",     -- "level" = rank by player level | "xp" = rank by total XP | "earnings" = rank by money earned
}

Config.Jobs = {}

-- Developer toggles. Production servers should leave these off.
Config.Dev = {
    -- true = run the economy save-pipeline test harness automatically on
    -- resource start (~5s after load). The harness simulates the admin panel
    -- save flow against EVERY rate of EVERY job in memory and prints a per-job
    -- pass/fail report to the server console. You can also run it on demand
    -- with the `econ_test` server-console command at any time.
    economyTestOnStart = false,
}


-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  RECONNECTION                                                             │
-- │                                                                           │
-- │  Allows players to rejoin their active job after a crash/disconnect.      │
-- │                                                                           │
-- │  Flow:                                                                    │
-- │    1. Player disconnects → state saved, grace timer starts                │
-- │    2. Player reconnects within gracePeriod → restored to lobby & job      │
-- │    3. Grace period expires OR max attempts exceeded → job cancelled        │
-- │                                                                           │
-- │  resetAttemptsAfterSeconds: if player stays connected for this long       │
-- │    after reconnecting, their attempt counter resets back to 0.            │
-- │    (e.g. 600 = 10 min stable connection resets attempts)                  │
-- │                                                                           │
-- │  ownerTransfer: when the lobby OWNER disconnects, ownership is            │
-- │    transferred to another player instead of dissolving the lobby.         │
-- │    priorityByLevel=true → highest level gets it.                          │
-- │    priorityByLevel=false → earliest joiner gets it.                       │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.Reconnection = {
    enabled = true,                  -- true = allow players to reconnect to active job | false = job lost on disconnect
    gracePeriodSeconds = 300,        -- seconds to reconnect before job is cancelled (300 = 5 min)
    maxReconnectAttempts = 3,        -- max reconnect attempts before job is cancelled
    resetAttemptsAfterSeconds = 600, -- seconds before reconnect attempt counter resets
    debugLogs = false,               -- true = log reconnection events to console | false = silent

    ownerTransfer = {
        enabled = true,         -- true = transfer lobby ownership on disconnect | false = lobby dissolves
        priorityByLevel = true, -- true = highest level player gets ownership | false = earliest joiner
    },

    notifications = {
        notifyOnDisconnect = true,      -- true = notify lobby when someone disconnects
        notifyOnReconnect = true,       -- true = notify lobby when someone reconnects
        notifyAttemptsRemaining = true, -- true = show remaining reconnect attempts
    },
}

Config.ExampleProfilePicture = "https://r2.fivemanage.com/biv23I9cFWICSObhZsr4C/LogoNEW.png"

Config.JobProgressDetail = {
    keyName = 'h',
    holdTime = 2000,
}

function Config.GetJob(jobId)
    return Config.Jobs[jobId]
end

function Config.GetExternalJob(jobId)
    if not Config.ExternalJobs then return nil end
    for _, ext in ipairs(Config.ExternalJobs) do
        if ext.id == jobId then return ext end
    end
    return nil
end

function Config.GetEnabledJobs()
    local enabled = {}
    for id, job in pairs(Config.Jobs) do
        if job.enabled then
            enabled[id] = job
        end
    end
    return enabled
end

function Config.GetRequiredXP(level)
    if Config.RequiredXPFormula then
        local ok, val = pcall(Config.RequiredXPFormula, level)
        if ok and tonumber(val) and tonumber(val) > 0 then
            return math.floor(tonumber(val))
        end
    end
    return Config.RequiredXP[level] or Config.RequiredXP[Config.MaxLevel]
end

function Config.CalculateLevelFromXP(totalXP)
    local level = 1
    local remainingXP = totalXP

    for lvl = 1, Config.MaxLevel do
        local required = Config.GetRequiredXP(lvl) or 0
        if remainingXP >= required then
            remainingXP = remainingXP - required
            level = lvl + 1
        else
            break
        end
    end

    if level > Config.MaxLevel then
        level = Config.MaxLevel
    end

    return level, remainingXP
end

function Config.GetJobListForUI()
    local jobs = {}
    for id, job in pairs(Config.Jobs) do
        if job.enabled then
            local locationData = nil
            if job.location then
                local coords = job.location.coords
                locationData = {
                    label = job.location.label,
                    x = coords and coords.x or 0.0,
                    y = coords and coords.y or 0.0,
                    z = coords and coords.z or 0.0,
                    blip = job.location.blip
                }
            end

            local areasData = nil
            if job.runtime and job.runtime.areas then
                areasData = {}
                for _i, area in ipairs(job.runtime.areas) do
                    local areaCoord = area.coord
                    table.insert(areasData, {
                        id = area.id,
                        name = area.name,
                        type = area.type,
                        requiredLevel = area.requiredLevel or 0,
                        coord = areaCoord and {
                            x = areaCoord.x or 0.0,
                            y = areaCoord.y or 0.0,
                            z = areaCoord.z or 0.0,
                        } or nil,
                    })
                end
            end

            local routesData = nil
            if job.runtime and job.runtime.routes then
                routesData = {}
                for i, route in ipairs(job.runtime.routes) do
                    local routeCoord = route.coord
                    table.insert(routesData, {
                        name = route.name or ("Route " .. i),
                        requiredLevel = route.requiredLevel or 0,
                        coord = routeCoord and {
                            x = routeCoord.x or 0.0,
                            y = routeCoord.y or 0.0,
                            z = routeCoord.z or 0.0,
                        } or nil,
                    })
                end
            end

            -- Only surface the hour requirement in the UI when the system is
            -- actually enforcing it, otherwise the badge would advertise a gate
            -- that never triggers.
            local hoursEnabled = Config.HoursRequirement and Config.HoursRequirement.enabled
            local requiredHours = hoursEnabled and (tonumber(job.requiredHours) or 0) or 0

            table.insert(jobs, {
                id = job.id,
                name = job.name,
                subtitle = job.subtitle,
                color = job.color,
                icon = job.icon,
                image = job.image,
                video = job.video,
                location = locationData,
                description = job.description,
                areas = areasData,
                routes = routesData,
                requiredHours = requiredHours,
            })
        end
    end

    -- Append external jobs to the UI list
    if Config.ExternalJobs then
        for _, ext in ipairs(Config.ExternalJobs) do
            if ext.id and ext.name then
                local extLocation = nil
                if ext.coords then
                    extLocation = {
                        label = ext.name,
                        x = ext.coords.x or 0.0,
                        y = ext.coords.y or 0.0,
                        z = ext.coords.z or 0.0,
                    }
                end
                table.insert(jobs, {
                    id = ext.id,
                    name = ext.name,
                    subtitle = ext.subtitle,
                    icon = ext.icon,
                    image = ext.image,
                    description = ext.description,
                    location = extLocation,
                    isExternal = true,
                    directHire = ext.directHire,
                })
            end
        end
    end

    return jobs
end

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  QUESTS                                                                   │
-- │                                                                           │
-- │  Repeatable quests that reset on a schedule. Players earn extra rewards   │
-- │  (money + XP) for completing quest objectives. Saved to SQL               │
-- │  (tw_jobpack_quests) — progress persists across sessions.                 │
-- │                                                                           │
-- │  Quest fields:                                                            │
-- │    id            → unique quest identifier                                │
-- │    jobId         → which job this quest belongs to                         │
-- │    action        → what the player must do:                               │
-- │                     "collect"  = collect X items                           │
-- │                     "process"  = process X items (refinery, sell, etc.)   │
-- │                     "earn"     = earn $X from the job                     │
-- │                     "complete" = finish X job runs                         │
-- │    target        → goal amount to complete the quest                      │
-- │    resetPeriod   → when the quest resets:                                 │
-- │                     "daily"   = resets at midnight                         │
-- │                     "weekly"  = resets Monday 00:00                        │
-- │                     "monthly" = resets 1st of month 00:00                 │
-- │    requiredLevel → minimum player level to see/track this quest           │
-- │    rewards       → { money = $, xp = X } given on quest completion       │
-- │                                                                           │
-- │  showProgressNotification: shows quest progress updates during gameplay   │
-- │  (e.g. "Quest: 3/5 items collected")                                      │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.Quests = {
    enabled = true,                  -- true = quest system active | false = no quests

    showProgressNotification = true, -- true = show quest progress in-game | false = silent tracking

    list = {

        { id = "daily_miner_collect",          jobId = "miner",          action = "collect",  target = 5,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 500, xp = 200 } },
        { id = "weekly_miner_process",         jobId = "miner",          action = "process",  target = 30,    resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 3000, xp = 1000 } },
        { id = "monthly_miner_earn",           jobId = "miner",          action = "earn",     target = 10000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 2000 } },

        { id = "daily_lumber_collect",         jobId = "lumberjack",     action = "collect",  target = 5,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 500, xp = 200 } },
        { id = "weekly_lumber_process",        jobId = "lumberjack",     action = "process",  target = 25,    resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_lumber_earn",          jobId = "lumberjack",     action = "earn",     target = 10000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 2000 } },

        { id = "daily_scrap_collect",          jobId = "scrapyard",      action = "collect",  target = 5,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 450, xp = 180 } },
        { id = "weekly_scrap_process",         jobId = "scrapyard",      action = "process",  target = 20,    resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2000, xp = 700 } },
        { id = "monthly_scrap_earn",           jobId = "scrapyard",      action = "earn",     target = 8000,  resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 4000, xp = 1500 } },

        { id = "daily_hunting_collect",        jobId = "hunting",        action = "collect",  target = 3,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 600, xp = 250 } },
        { id = "weekly_hunting_process",       jobId = "hunting",        action = "process",  target = 15,    resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 3500, xp = 1200 } },
        { id = "monthly_hunting_earn",         jobId = "hunting",        action = "earn",     target = 12000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5500, xp = 2000 } },

        { id = "daily_farmer_complete",        jobId = "farmer",         action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 150 } },
        { id = "weekly_farmer_earn",           jobId = "farmer",         action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_farmer_earn",          jobId = "farmer",         action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_fruitpicker_complete",   jobId = "fruitpicker",    action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 150 } },
        { id = "weekly_fruitpicker_earn",      jobId = "fruitpicker",    action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_fruitpicker_earn",     jobId = "fruitpicker",    action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_cleaner_complete",       jobId = "cleaner",        action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 350, xp = 140 } },
        { id = "weekly_cleaner_earn",          jobId = "cleaner",        action = "earn",     target = 4000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2000, xp = 700 } },
        { id = "monthly_cleaner_earn",         jobId = "cleaner",        action = "earn",     target = 12000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 4500, xp = 1600 } },

        { id = "daily_powerwash_complete",     jobId = "powerwash",      action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_powerwash_earn",        jobId = "powerwash",      action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_powerwash_earn",       jobId = "powerwash",      action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_windowcleaner_complete", jobId = "windowscleaner", action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 350, xp = 140 } },
        { id = "weekly_windowcleaner_earn",    jobId = "windowscleaner", action = "earn",     target = 4000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2000, xp = 700 } },
        { id = "monthly_windowcleaner_earn",   jobId = "windowscleaner", action = "earn",     target = 12000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 4500, xp = 1600 } },

        { id = "daily_cardetailer_complete",   jobId = "cardetailer",    action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_cardetailer_earn",      jobId = "cardetailer",    action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_cardetailer_earn",     jobId = "cardetailer",    action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_newspaper_complete",     jobId = "newspaper",      action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 300, xp = 120 } },
        { id = "weekly_newspaper_earn",        jobId = "newspaper",      action = "earn",     target = 3000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 1500, xp = 500 } },
        { id = "monthly_newspaper_earn",       jobId = "newspaper",      action = "earn",     target = 8000,  resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 3500, xp = 1200 } },

        { id = "daily_cleanup_complete",       jobId = "cleanup",        action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 350, xp = 140 } },
        { id = "weekly_cleanup_earn",          jobId = "cleanup",        action = "earn",     target = 4000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2000, xp = 700 } },
        { id = "monthly_cleanup_earn",         jobId = "cleanup",        action = "earn",     target = 12000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 4500, xp = 1600 } },

        { id = "daily_trucker_complete",       jobId = "trucker",        action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 500, xp = 200 } },
        { id = "weekly_trucker_earn",          jobId = "trucker",        action = "earn",     target = 8000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 4000, xp = 1500 } },
        { id = "monthly_trucker_earn",         jobId = "trucker",        action = "earn",     target = 25000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 8000, xp = 3000 } },

        { id = "daily_taxi_complete",          jobId = "taxi",           action = "complete", target = 3,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_taxi_earn",             jobId = "taxi",           action = "earn",     target = 6000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 3000, xp = 1000 } },
        { id = "monthly_taxi_earn",            jobId = "taxi",           action = "earn",     target = 18000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 6000, xp = 2200 } },

        { id = "daily_dogwalking_complete",    jobId = "dogwalking",     action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 300, xp = 120 } },
        { id = "weekly_dogwalking_earn",       jobId = "dogwalking",     action = "earn",     target = 3000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 1500, xp = 500 } },
        { id = "monthly_dogwalking_earn",      jobId = "dogwalking",     action = "earn",     target = 8000,  resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 3500, xp = 1200 } },

        { id = "daily_powerlines_complete",    jobId = "powerlines",     action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 450, xp = 180 } },
        { id = "weekly_powerlines_earn",       jobId = "powerlines",     action = "earn",     target = 6000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 3000, xp = 1000 } },
        { id = "monthly_powerlines_earn",      jobId = "powerlines",     action = "earn",     target = 18000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 6000, xp = 2200 } },

        { id = "daily_delivery_complete",      jobId = "delivery",       action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_delivery_earn",         jobId = "delivery",       action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_delivery_earn",        jobId = "delivery",       action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_warehouse_complete",     jobId = "warehouse",      action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_warehouse_earn",        jobId = "warehouse",      action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_warehouse_earn",       jobId = "warehouse",      action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_landscaping_complete",   jobId = "landscaping",    action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 350, xp = 140 } },
        { id = "weekly_landscaping_earn",      jobId = "landscaping",    action = "earn",     target = 4000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2000, xp = 700 } },
        { id = "monthly_landscaping_earn",     jobId = "landscaping",    action = "earn",     target = 12000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 4500, xp = 1600 } },

        { id = "daily_fishing_complete",       jobId = "fishing",        action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_fishing_earn",          jobId = "fishing",        action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_fishing_earn",         jobId = "fishing",        action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },

        { id = "daily_diving_complete",        jobId = "diving",         action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 450, xp = 180 } },
        { id = "weekly_diving_earn",           jobId = "diving",         action = "earn",     target = 6000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 3000, xp = 1000 } },
        { id = "monthly_diving_earn",          jobId = "diving",         action = "earn",     target = 18000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 6000, xp = 2200 } },

        { id = "daily_forklift_complete",      jobId = "forklift",       action = "complete", target = 2,     resetPeriod = "daily",   requiredLevel = 1, rewards = { money = 400, xp = 160 } },
        { id = "weekly_forklift_earn",         jobId = "forklift",       action = "earn",     target = 5000,  resetPeriod = "weekly",  requiredLevel = 2, rewards = { money = 2500, xp = 800 } },
        { id = "monthly_forklift_earn",        jobId = "forklift",       action = "earn",     target = 15000, resetPeriod = "monthly", requiredLevel = 3, rewards = { money = 5000, xp = 1800 } },
    },
}

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │  PERKS (SKILLS)                                                            │
-- │                                                                            │
-- │  Perk names & descriptions shown in the UI are loaded from locale files:   │
-- │    html/dist/locales/{lang}.json -> "perks" section                        │
-- │    e.g. "perks.trunk_capacity.name", "perks.trunk_capacity.desc"           │
-- │                                                                            │
-- │  Only cost, multiplier and enabled fields are configured here.             │
-- │  enabled = false hides the perk from the UI entirely.                      │
-- └─────────────────────────────────────────────────────────────────────────────┘
Config.Perks = {
    trunk_capacity = {
        tiers = {
            [1] = { cost = 1, multiplier = 1.25 },
            [2] = { cost = 2, multiplier = 1.50 },
            [3] = { cost = 3, multiplier = 2.00 },
        }
    },
    strong_muscles = {
        tiers = {
            [1] = { cost = 1, multiplier = 1.10 },
            [2] = { cost = 2, multiplier = 1.20 },
            [3] = { cost = 4, multiplier = 1.20 },
        }
    },
    negotiator = {
        enabled = true,
        tiers = {
            [1] = { cost = 1, multiplier = 1.05 },
            [2] = { cost = 2, multiplier = 1.10 },
            [3] = { cost = 3, multiplier = 1.15 },
        }
    },
    xp_boost = {
        tiers = {
            [1] = { cost = 1, multiplier = 1.10 },
            [2] = { cost = 2, multiplier = 1.20 },
            [3] = { cost = 3, multiplier = 1.30 },
        }
    },
    speed_demon = {
        tiers = {
            [1] = { cost = 2, multiplier = 1.10 },
            [2] = { cost = 3, multiplier = 1.20 },
            [3] = { cost = 4, multiplier = 1.35 },
        }
    },
    store_discount = {
        -- multiplier is a PRICE multiplier applied to in-resource purchases
        -- (fishing shop + tool upgrades). 0.95 = 5% off, 0.85 = 15% off.
        -- Default when the player has no perk is 1.0 (full price), so this is
        -- safe — never make it the discount fraction (0.05) or "no perk" would
        -- evaluate to a free purchase.
        tiers = {
            [1] = { cost = 3, multiplier = 0.95 },
            [2] = { cost = 4, multiplier = 0.90 },
            [3] = { cost = 5, multiplier = 0.85 },
        }
    },
    breath_capacity = {
        tiers = {
            [1] = { cost = 2, multiplier = 1.25 },
            [2] = { cost = 3, multiplier = 1.50 },
            [3] = { cost = 5, multiplier = 2.00 },
        }
    },
    repair_speed = {
        tiers = {
            [1] = { cost = 2, multiplier = 0.90 },
            [2] = { cost = 3, multiplier = 0.75 },
            [3] = { cost = 5, multiplier = 0.50 },
        }
    },
}
