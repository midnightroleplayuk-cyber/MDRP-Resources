-- ECONOMY MODEL (OPTIONAL) — derives rewards from workload.
-- OFF by default: payouts come from config/config.lua -> Config.RegionAwards.
-- Turning it on makes Apply() OVERWRITE RegionAwards money/xp.
-- Only want bigger/smaller payouts? Use Config.RewardMultiplier instead.
-- Console command `ekonomi` prints current vs proposed.

Config.Economy = {
    enabled = false, -- true = derived values replace the hand-written rewards

    -- ---------------------------------------------------------------- rates
    -- Money per effort-minute. Changing this single number scales the whole economy.
    moneyPerMinute = 300,
    -- XP per effort-minute (a ~30 min mission gives ~1,350 XP at 45).
    xpPerMinute = 45,

    -- ------------------------------------------------- unit durations (SECONDS)
    -- Average time one unit of work takes. Adjust after timing your own players.
    unitSeconds = {
        hand  = 20,  -- hand-carried slot (take from the pile, walk, place)
        crane = 75,  -- crane slot (position, hook up, lift, place, swing back)
        pour  = 45,  -- pump/concrete pour unit
        dig   = 90,  -- excavator dig + load-onto-truck cycle
        drive = 120, -- haul leg (load/drive/unload)
    },

    -- --------------------------------------------------- difficulty multipliers
    -- The reward difference per second: machine work demands more attention/risk
    -- (rolling over, collisions, operator handover, rope snapping).
    difficulty = {
        hand  = 1.00,
        crane = 1.35,
        pour  = 1.20,
        dig   = 1.25,
        drive = 1.10,
    },

    -- ------------------------------------------------------ CREW POLICY
    -- 'sharedPot': pot = base x (1 + bonusPerExtra x (players - 1)), split evenly.
    --   bonusPerExtra 0.5 -> 1p 1.00x, 2p 0.75x, 3p 0.67x, 4p 0.63x per head.
    -- 'perPlayer': every member receives the full base reward (old behaviour).
    team = {
        model         = 'sharedPot', -- 'sharedPot' | 'perPlayer' (old behaviour)
        bonusPerExtra = 0.5,
    },

    -- ------------------------------------------------------- JOB PROFILES
    -- units = { hand=, crane=, pour=, dig=, drive= }; measured = counts verified in code.
    regions = {
        [1]  = {
            name = 'R1 Frame & Concrete',
            units = { hand = 180, crane = 25, pour = 12 },
            measured = false,
            note = '10-phase flagship. ESTIMATE — the per-phase piece counts were not counted.'
        },
        [2]  = {
            name = 'R2 Tower Crane (main)',
            units = { crane = 20 },
            measured = true,
            note = 'kulestone slots = 20 (measured).'
        },
        [3]  = {
            name = 'R3 Tower Crane (site2)',
            units = { crane = 20 },
            measured = false,
            note = 'the sideWalls count could not be read — assumed equal to R2.'
        },
        [4]  = {
            name = 'R4 Pipe Laying',
            units = { crane = 28 },
            measured = true,
            note = '28 pipes (AGENTS.md).'
        },
        [5]  = {
            name = 'R5 Panel Wall',
            units = { hand = 175 },
            measured = true,
            note = 'slots = 175 (measured). ⚠ QUOTA model: a single lobby does not do all of them — '
                .. 'after the quota ratio is settled, units.hand must be pulled down to the quota.'
        },
        [6]  = {
            name = 'R6 Pump & Crane',
            units = { pour = 20, crane = 15 },
            measured = false,
            note = '2 phases (pour concrete + stone wall). ESTIMATE.'
        },
        [7]  = {
            name = 'R7 Underground Pipe',
            units = { crane = 18 },
            measured = true,
            note = '18 pipes, 3 trenches (AGENTS.md).'
        },
        [8]  = {
            name = 'R8 Excavator & Haul',
            units = { dig = 20, drive = 4 },
            measured = false,
            note = 'digsPerTruck = 5 (measured); how many truck runs is an ESTIMATE.'
        },
        [9]  = {
            name = 'R9 Lumber Stacking',
            units = { hand = 217 },
            measured = true,
            note = 'slots = 217 (measured; the stale value shown in the UI was 218).'
        },
        [10] = {
            name = 'R10 Decking',
            units = { hand = 91 },
            measured = true,
            note = 'slots = 91 (measured).'
        },
        [11] = {
            name = 'R11 Mixed Wall/Roof',
            units = { hand = 60, crane = 38 },
            measured = true,
            note = '60 hand + 38 crane = 98 slots (measured).'
        },
        [12] = {
            name = 'R12 Crane Haul',
            units = { crane = 6, drive = 6 },
            measured = false,
            note = 'loads = 3 (measured); the number of runs is an ESTIMATE.'
        },
    },
}

-- ====================================================================
-- CALCULATOR — pure function, no side effects.
-- ====================================================================
function Config.Economy.Compute(regionId)
    local E = Config.Economy
    local r = E.regions[regionId]
    if not r then return nil end
    local effortSec = 0
    for kind, count in pairs(r.units or {}) do
        local sec  = E.unitSeconds[kind] or 0
        local diff = E.difficulty[kind] or 1.0
        effortSec  = effortSec + (count * sec * diff)
    end
    local minutes = effortSec / 60
    return {
        minutes = minutes,
        money   = math.floor(minutes * E.moneyPerMinute / 50 + 0.5) * 50, -- round to 50
        xp      = math.floor(minutes * E.xpPerMinute / 25 + 0.5) * 25,    -- round to 25
    }
end

-- Crew share, called by the reward layer. Returns the PER-PLAYER amount.
function Config.Economy.TeamShare(baseMoney, playerCount)
    local E     = Config.Economy
    baseMoney   = tonumber(baseMoney) or 0
    playerCount = math.max(1, tonumber(playerCount) or 1)
    if playerCount == 1 then return baseMoney end
    if E.team.model == 'perPlayer' then return baseMoney end -- old behaviour
    local pot = baseMoney * (1 + (E.team.bonusPerExtra or 0.5) * (playerCount - 1))
    return math.floor(pot / playerCount + 0.5)
end

-- ====================================================================
-- APPLIER -- writes the derived values into the region selector (regionAwards)
-- and into the slot jobs' own configs (rewardPerSlot / rewardXP), so what the
-- screen shows always equals what is paid. The completion bonus is preserved.
-- ====================================================================
local SLOT_JOBS = {
    [5]  = function() return Config.PanelWall end,
    [9]  = function() return Config.Job9 end,
    [10] = function() return Config.Job7 end,
    [11] = function() return Config.Job8 end,
}

function Config.Economy.Apply()
    local E = Config.Economy
    if not E.enabled then return false, 'disabled' end
    local applied = 0

    for _, region in pairs((Config.Job and Config.Job.regionData) or {}) do
        local c = region.regionID and Config.Economy.Compute(region.regionID)
        if c and region.regionAwards then
            region.regionAwards.money = c.money
            region.regionAwards.xp    = c.xp
            applied                   = applied + 1

            local getCfg              = SLOT_JOBS[region.regionID]
            local jc                  = getCfg and getCfg()
            if jc then
                local slots = #(jc.slots or {})
                local bonus = tonumber(jc.rewardCompletionBonus) or 0
                if slots > 0 then
                    -- Derive backwards so that pot = perSlot×slots + bonus.
                    jc.rewardPerSlot = math.max(1, math.floor((c.money - bonus) / slots))
                end
                jc.rewardXP = c.xp
            end
        end
    end
    print(('[economy] derived rewards APPLIED — %d regions (model: effort-minutes × %d $/min)')
        :format(applied, E.moneyPerMinute))
    return true
end

-- Runs after every config file has loaded; client and server compute the same numbers.
CreateThread(function()
    if Config.Economy.enabled then Config.Economy.Apply() end
end)

-- ====================================================================
-- COMPARISON TABLE — print to the console (current vs proposed).
-- In the server console: `ekonomi`
-- ====================================================================
if Config.DebugCommands then
    RegisterCommand('ekonomi', function(source)
        if source ~= 0 then return end -- console only
        local E = Config.Economy
        print(('\n[economy] model=%s  $/min=%d  XP/min=%d  crew=%s(+%.2f)  APPLY=%s')
            :format('effort-minutes', E.moneyPerMinute, E.xpPerMinute,
                E.team.model, E.team.bonusPerExtra, E.enabled and 'ACTIVE' or 'OFF'))
        print(('%-24s %7s %9s %9s %9s %9s  %s'):format(
            'Region', 'minutes', 'money(new)', 'money(old)', 'XP(new)', 'XP(old)', 'measure'))
        for id = 1, 12 do
            local c = Config.Economy.Compute(id)
            if c then
                local cur = { money = 0, xp = 0 }
                for _, reg in pairs((Config.Job and Config.Job.regionData) or {}) do
                    if reg.regionID == id and reg.regionAwards then
                        cur.money = tonumber(reg.regionAwards.money) or 0
                        cur.xp    = tonumber(reg.regionAwards.xp) or 0
                    end
                end
                print(('%-24s %7.1f %9d %9d %9d %9d  %s'):format(
                    E.regions[id].name, c.minutes, c.money, cur.money, c.xp, cur.xp,
                    E.regions[id].measured and 'measured' or 'ESTIMATE'))
            end
        end
        print('[economy] 1/2/3/4 player share (for a base of 10,000): '
            .. table.concat({
                Config.Economy.TeamShare(10000, 1),
                Config.Economy.TeamShare(10000, 2),
                Config.Economy.TeamShare(10000, 3),
                Config.Economy.TeamShare(10000, 4),
            }, ' / '))
    end, true)
end
