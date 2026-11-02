-- Prison jobs. Prisoners apply at the kiosk; staff approve on the tablet (or it's automatic).
-- Workstations are placed in the editor as 'workstation' points and tied to a job.
-- anim: { scenario = '...' } or { dict = '...', clip = '...' }, optional prop = { model, bone, pos, rot }
Config.Industries = {
    AutoApprove = 'no_staff',   -- 'always' | 'no_staff' (only when nobody can approve) | 'never'
    WorkPhasesOnly = true,      -- tasks only during regime phases marked work = true
    MaxTasksPerPhase = 30,      -- per prisoner, per work phase
    LevelXp = { 0, 100, 300, 600, 1000 },  -- xp needed for level 1-5
    LevelPayBonus = 0.1,        -- +10% pay per level above 1
    OrderBonus = 5,             -- paid to everyone who worked on a work order when it is finished

    Jobs = {
        kitchen = {
            label = 'Kitchen', slots = 6, minIep = 'standard', categories = { 'B', 'C', 'D' },
            requires = 'food_hygiene',
            dailyOrder = { label = 'Meals for the wings', target = 40 },
            tasks = {
                { id = 'prep', label = 'Prepare vegetables', duration = 8000, pay = 1, xp = 8, anim = { dict = 'anim@heists@prison_heiststation@cop_reactions', clip = 'cop_b_idle' } },
                { id = 'cook', label = 'Cook on the range', duration = 12000, pay = 2, xp = 12, minLevel = 2, anim = { scenario = 'PROP_HUMAN_BBQ' } },
                { id = 'wash', label = 'Wash up', duration = 8000, pay = 1, xp = 6, anim = { scenario = 'WORLD_HUMAN_MAID_CLEAN' } },
            },
        },
        laundry = {
            label = 'Laundry', slots = 4, minIep = 'basic',
            dailyOrder = { label = 'Wing kit wash', target = 30 },
            tasks = {
                { id = 'load', label = 'Load the machines', duration = 8000, pay = 1, xp = 8, anim = { dict = 'mini@repair', clip = 'fixing_a_ped' } },
                { id = 'fold', label = 'Fold and bag kit', duration = 10000, pay = 1, xp = 10, anim = { scenario = 'PROP_HUMAN_PARKING_METER' } },
            },
        },
        cleaning = {
            label = 'Wing cleaner', slots = 6, minIep = 'basic',
            tasks = {
                { id = 'mop', label = 'Mop the landing', duration = 10000, pay = 1, xp = 8, anim = { scenario = 'WORLD_HUMAN_JANITOR' } },
                { id = 'wipe', label = 'Clean surfaces', duration = 8000, pay = 1, xp = 6, anim = { scenario = 'WORLD_HUMAN_MAID_CLEAN' } },
            },
        },
        maintenance = {
            label = 'Maintenance', slots = 3, minIep = 'enhanced', categories = { 'C', 'D' },
            requires = 'health_safety',
            tasks = {
                { id = 'repair', label = 'Repair fittings', duration = 12000, pay = 2, xp = 12, anim = { dict = 'mini@repair', clip = 'fixing_a_ped' } },
                { id = 'drill', label = 'Drill and fix', duration = 12000, pay = 2, xp = 14, minLevel = 2, anim = { scenario = 'WORLD_HUMAN_CONST_DRILL' } },
            },
        },
        carpentry = {
            label = 'Carpentry workshop', slots = 5, minIep = 'standard', categories = { 'B', 'C', 'D' },
            dailyOrder = { label = 'Garden benches', target = 20 },
            tasks = {
                { id = 'cut', label = 'Cut timber', duration = 10000, pay = 1, xp = 10, anim = { scenario = 'WORLD_HUMAN_HAMMERING' } },
                { id = 'build', label = 'Assemble a bench', duration = 15000, pay = 3, xp = 16, minLevel = 3, anim = { scenario = 'WORLD_HUMAN_HAMMERING' } },
            },
        },
        recycling = {
            label = 'Recycling', slots = 5, minIep = 'basic',
            dailyOrder = { label = 'Sorted recycling bales', target = 30 },
            tasks = {
                { id = 'sort', label = 'Sort recycling', duration = 8000, pay = 1, xp = 8, anim = { dict = 'anim@amb@business@weed@weed_sorting_seated@', clip = 'sorter_right_sort_v3_sorter02' } },
            },
        },
        gardens = {
            label = 'Gardens', slots = 4, minIep = 'standard', categories = { 'C', 'D' },
            tasks = {
                { id = 'plant', label = 'Plant and weed beds', duration = 10000, pay = 1, xp = 10, anim = { scenario = 'WORLD_HUMAN_GARDENER_PLANT' } },
                { id = 'leaves', label = 'Clear leaves', duration = 10000, pay = 1, xp = 8, anim = { scenario = 'WORLD_HUMAN_GARDENER_LEAF_BLOWER' } },
            },
        },
        workshop = {
            label = 'Engineering workshop', slots = 4, minIep = 'enhanced', categories = { 'C', 'D' },
            requires = 'health_safety',
            dailyOrder = { label = 'Metal brackets', target = 25 },
            tasks = {
                { id = 'weld', label = 'Weld brackets', duration = 14000, pay = 3, xp = 16, minLevel = 2, anim = { scenario = 'WORLD_HUMAN_WELDING' } },
                { id = 'assemble', label = 'Bench assembly', duration = 10000, pay = 2, xp = 10, anim = { dict = 'mini@repair', clip = 'fixing_a_ped' } },
            },
        },
    },
}
