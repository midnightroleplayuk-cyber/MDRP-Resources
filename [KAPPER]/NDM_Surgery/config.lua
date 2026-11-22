Config = {}

-- Jobs that can perform surgery. Value = minimum grade (a procedure can ask for a higher one).
Config.Jobs = {
    ambulance = 0,
}
Config.RequireOnDuty = true

-- Operating tables. Add one entry per table.
--   coords = where the patient lies: x, y, z (top of the table) and the heading they face.
-- Tip: stand where you want and use /surgerypos to copy your coords + heading.
--
-- !! PLACEHOLDER: replace with the real operating theatre position in game !!
Config.Tables = {
    {
        label = 'Operating Theatre 1',
        coords = vector4(-328.63, -120.55, 39.08, 61.0),
    },
    {
        label = 'Operating Theatre 2',
        coords = vector4(-330.61, -126.83, 39.07, 61.0),
    },
}

Config.LayPatientRange = 4.0   -- how close the patient must be to the medic to be put on the table
Config.PatientRadius = 1.5     -- how close the patient must stay to the table point
Config.SurgeonRange = 3.0      -- how close the surgeon must be to the table

-- Allow surgery on patients in OSP last stand / dead.
Config.AllowDowned = true

-- Re-open the surgery menu after each procedure
Config.ReopenMenu = true

-- Keys used by the ox_lib skill checks
Config.SkillKeys = { 'w', 'a', 's', 'd' }

-- General anaesthesia. Awake patients must be put under before bullet removal / internal repair.
Config.Anaesthesia = {
    required = true,
    skipIfDowned = true,   -- downed / dead patients don't need it
    blackout = true,       -- patient's screen goes black while under
    maxTime = 900,         -- seconds; failsafe so nobody is stuck under forever
}

-- Bleeding left on a body part while the incision is open (needs stitching to stop it)
Config.OpenBleed = 0.05

-- OSP wounds that count as bullets
Config.BulletWounds = {
    lowvelocitywound = true,
    mediumvelocitywound = true,
    highvelocitywound = true,
}

-- OSP wounds that count as shrapnel (explosions / shotgun pellets)
Config.ShrapnelWounds = {
    velocitywound = true,
}

-- OSP wounds cleaned and closed by wound debridement
Config.DebrideWounds = {
    cut = true,
    laceration = true,
    abrasion = true,
}

-- OSP wounds that count as internal damage (repaired by "Internal damage repair")
Config.InternalWounds = {
    crush = true,
    puncturewound = true,
    avulsion = true,
}

-- Body parts where bleeding with no visible wound counts as internal bleeding
Config.InternalBleedParts = {
    Head = true,
    Torso = true,
}

-- Optional item given to the surgeon for each bullet removed (evidence). nil = none.
Config.BulletItem = nil -- e.g. 'bullet_fragment'

-- Procedures
--   duration   = ms of the progress bar
--   skill      = ox_lib skill check difficulties ({} = no skill check)
--   minGrade   = minimum job grade (overrides Config.Jobs if higher)
--   item       = ox_inventory item the surgeon needs (nil = none), removeItem = use it up
--   heal       = health given to the patient on success (OSP treatment heal)
--   failBleed  = bleeding added to the body part when the skill check fails
--   failPain   = pain added when the skill check fails
Config.Procedures = {
    anaesthesia = {
        label = 'General anaesthesia',
        duration = 6000,
        skill = {},
        minGrade = 0,
        item = nil,
        removeItem = false,
    },
    bullet = {
        label = 'Bullet removal',
        duration = 12000,
        skill = { 'easy', 'medium', 'medium' },
        minGrade = 0,
        item = nil,
        removeItem = false,
        heal = 6,
        failBleed = 0.2,
        failPain = 1.0,
    },
    internal = {
        label = 'Internal damage repair',
        duration = 18000,
        skill = { 'medium', 'medium', 'hard' },
        minGrade = 0,
        item = nil,
        removeItem = false,
        heal = 12,
        failBleed = 0.3,
        failPain = 1.5,
    },
    -- Shrapnel removal: each shrapnel wound has a random number of fragments (fragments = {min, max}),
    -- one fragment comes out per successful go.
    shrapnel = {
        label = 'Shrapnel removal',
        duration = 7000,
        skill = { 'easy', 'medium' },
        fragments = { 2, 4 },
        minGrade = 0,
        item = nil,
        removeItem = false,
        heal = 3,
        failBleed = 0.8,
        failPain = 0.3,
    },
    -- Fracture repair (ORIF): fixes the bone outright, no splint / cast / heal timer needed.
    fracture = {
        label = 'Fracture repair',
        duration = 20000,
        skill = { 'medium', 'medium', 'hard' },
        requireImaging = true, -- fracture must be found by X-ray / MRI first (or already splinted)
        minGrade = 0,
        item = nil,
        removeItem = false,
        heal = 10,
        failBleed = 0.2,
        failPain = 2.0,
    },
    -- Wound debridement: cleans and closes cuts / lacerations / abrasions on a body part in one go.
    -- No general anaesthesia needed.
    debride = {
        label = 'Wound debridement',
        duration = 10000,
        skill = { 'easy', 'easy' },
        minGrade = 0,
        item = nil,
        removeItem = false,
        heal = 6,
        failBleed = 0.1,
        failPain = 0.5,
    },
    stitch = {
        label = 'Stitching',
        duration = 9000,
        skill = { 'easy', 'medium' },
        minGrade = 0,
        item = nil,          -- e.g. 'sewing_kit'
        removeItem = false,
        heal = 10,
        failBleed = 0.0,
        failPain = 0.5,
    },
}

-- Major surgery: hands-on organ / limb mini-games (heart, kidney, lung, arm, leg).
-- Based on pickle_surgery by Pickle Mods, see CREDITS.md.
--
-- Each table can optionally set where the mini-game happens, if the default doesn't line up in game:
--   scene   = vector4(...)  -- scene centre (default: the table coords + sceneHeight)
--   surgeon = vector4(...)  -- where the surgeon is put (default: right-hand side of the table)
Config.MajorSurgery = {
    enabled = true,
    sceneHeight = 0.0,          -- move every surgery scene up (+) / down (-). Test values in game with /surgeryheight

    training = true,            -- "Surgical training" on the table: practise on a dummy, no patient needed
    showControls = {            -- show the control hints during the mini-game
        patient = false,
        training = true,
    },
    blood = {
        startingLevel = 4500,   -- ml the patient starts with in the mini-game
        lossPerBleed = 100,     -- ml lost per second for every open bleed
    },
    killOnFail = false,         -- true = the patient dies if the surgeon fails / cancels; false = complication only
    minTime = 20,               -- seconds; a "success" faster than this counts as a failure
    maxTime = 1200,             -- seconds; failsafe, the surgery is cancelled after this
    maxDistance = 5.0,          -- surgeon / patient further than this from the table cancels the surgery
    clothing = {                -- clothes put on for open chest surgery
        male = {
            arms = { 5, 0 },
            torso = { 15, 1 },
            accessories = { 15, 0 },
        },
        female = {
            arms = { 11, 0 },
            torso = { -1, 1 },
            accessories = { -1, 1 },
        },
    },
}

-- key            = which mini-game (heart / kidney / lung / arm / leg)
-- bodyType       = 'openRib' (open chest) or 'closed'
-- parts          = OSP body parts the surgery works on
-- repairInternal = success removes internal damage on those parts
-- repairFracture = success fixes fractures on those parts (splints are taken off)
-- requireFinding = only allow it when there is something on those parts to fix
-- heal           = health given on success, failBleed / failPain = complication on failure
-- items          = { { name = 'item', amount = 1, remove = true } } needed by the surgeon (not in training)
-- rewards / trainingRewards = { { type = 'cash' | 'bank', amount = 500 }, { type = 'item', name = 'x', amount = 1 } }
-- After a successful surgery the incision still has to be stitched.
Config.MajorSurgeries = {
    {
        key = 'heart',
        label = 'Heart transplant',
        description = 'Open the chest and replace the heart',
        icon = 'fa-solid fa-heart-pulse',
        bodyType = 'openRib',
        parts = { 'Torso' },
        repairInternal = true,
        repairFracture = false,
        requireFinding = false,
        minGrade = 0,
        heal = 25,
        failBleed = 1.0,
        failPain = 3.0,
        items = {},
        rewards = {},
        trainingRewards = {},
    },
    {
        key = 'kidney',
        label = 'Kidney transplant',
        description = 'Open the abdomen and replace the kidneys',
        icon = 'fa-solid fa-droplet',
        bodyType = 'openRib',
        parts = { 'Torso' },
        repairInternal = true,
        repairFracture = false,
        requireFinding = false,
        minGrade = 0,
        heal = 20,
        failBleed = 1.0,
        failPain = 3.0,
        items = {},
        rewards = {},
        trainingRewards = {},
    },
    {
        key = 'lung',
        label = 'Lung transplant',
        description = 'Open the chest and replace the lungs',
        icon = 'fa-solid fa-lungs',
        bodyType = 'openRib',
        parts = { 'Torso' },
        repairInternal = true,
        repairFracture = false,
        requireFinding = false,
        minGrade = 0,
        heal = 20,
        failBleed = 1.0,
        failPain = 3.0,
        items = {},
        rewards = {},
        trainingRewards = {},
    },
    {
        key = 'arm',
        label = 'Arm reconstruction',
        description = 'Implant rods to rebuild both arms',
        icon = 'fa-solid fa-hand',
        bodyType = 'closed',
        parts = { 'Larm', 'Rarm' },
        repairInternal = true,
        repairFracture = true,
        requireFinding = true,
        minGrade = 0,
        heal = 15,
        failBleed = 0.5,
        failPain = 2.0,
        items = {},
        rewards = {},
        trainingRewards = {},
    },
    {
        key = 'leg',
        label = 'Leg reconstruction',
        description = 'Implant rods to rebuild both legs',
        icon = 'fa-solid fa-person-walking',
        bodyType = 'closed',
        parts = { 'Lleg', 'Rleg' },
        repairInternal = true,
        repairFracture = true,
        requireFinding = true,
        minGrade = 0,
        heal = 15,
        failBleed = 0.5,
        failPain = 2.0,
        items = {},
        rewards = {},
        trainingRewards = {},
    },
}

-- Animations
Config.LieAnim = { dict = 'anim@gangops@morgue@table@', clip = 'body_search' }
Config.SurgeonAnim = { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 49 }

Config.Debug = false
