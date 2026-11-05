Config.Safehouses = {
    maxPerGang   = 2,
    sellRefund   = 0.5,    -- share of the price (and upgrades) paid back when a gang sells
    graceDays    = 3,      -- days of unpaid upkeep before the safehouse is repossessed
    bucketBase   = 7000,   -- routing bucket = bucketBase + safehouse id

    stash = { slots = 40, weight = 200000 },

    -- Shells: a safehouse can use a shell prop instead of an interior on the map. The shell is spawned when
    -- someone goes in (only for them, in that safehouse's own instance) and removed when they leave.
    -- Every shell safehouse shares this hidden spot under the map; instances keep them apart.
    shellOrigin = { x = 2050.0, y = 3050.0, z = -60.0 },

    -- Shell models your server streams (a shell pack such as K4MB1's). model = the prop name;
    -- start = where staff are first put inside it while setting a safehouse up (offset from the shell's origin).
    -- These are common free starter shells: remove any you don't have and add your own.
    shells = {
        { model = 'shell_v16low',     label = 'Low-end apartment',  start = { x = 4.7,  y = -6.0,  z = 1.0 } },
        { model = 'shell_v16mid',     label = 'Mid-range apartment', start = { x = 1.4,  y = -14.0, z = 1.0 } },
        { model = 'shell_trevor',     label = 'Trevor\'s trailer',   start = { x = 0.2,  y = -3.6,  z = 1.0 } },
        { model = 'shell_trailer',    label = 'Trailer',            start = { x = -1.4, y = -2.0,  z = 1.0 } },
        { model = 'shell_lester',     label = 'Lester\'s house',     start = { x = -1.6, y = -6.0,  z = 1.0 } },
        { model = 'shell_ranch',      label = 'Ranch house',        start = { x = -1.0, y = -5.5,  z = 2.0 } },
        { model = 'shell_frankaunt',  label = 'Aunt\'s house',       start = { x = -0.3, y = -5.8,  z = 1.0 } },
        { model = 'shell_garagem',    label = 'Medium garage',      start = { x = 14.0, y = 1.8,   z = 1.0 } },
        { model = 'shell_warehouse1', label = 'Warehouse',          start = { x = -8.9, y = 0.1,   z = 1.0 } },
    },

    upgrades = {
        stash = {          -- bought in order
            { price = 15000, slots = 60, weight = 400000 },
            { price = 35000, slots = 90, weight = 800000 },
        },
        cctv = { price = 12000 },                         -- members are warned when police start a raid
        door = { price = 20000, breachMultiplier = 2.0 }, -- reinforced door takes longer to breach
    },

    raid = {
        jobs = { police = true },
        minGrade = 0,
        breachTime = 15000,         -- ms, doubled by a reinforced door
        openMinutes = 10,           -- door stays open to police this long after a breach
        needWarrant = true,         -- an active search warrant on vinewood-mdt matching the address
        warrantTypes = { 'pace8', 'mda23', 'fa46' },
        closeWarrant = true,        -- mark the warrant executed on the MDT after the raid
        noMdtGrade = 3,             -- if the MDT isn't running, this grade and above can raid without one
    },
}
