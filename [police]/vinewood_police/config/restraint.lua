---------------------------------------------------------------------------
-- Handcuffs, escort and putting people in vehicles.
---------------------------------------------------------------------------
Config.Restraint = {
    -- Officer must carry this item to cuff someone (it isn't used up).
    Item = 'handcuffs',
    RequireItem = true,

    Distance = 2.0,             -- how close to cuff, uncuff or escort (metres)
    VehicleDistance = 5.0,      -- how close to a vehicle to put someone in or take them out
    EscortBreakDistance = 10.0, -- escort ends if the officer gets further than this away

    EscortRequiresCuffs = true,
    BlockVehicleExit = true,    -- cuffed people can't open the door themselves
    Seats = { 1, 2, 0 },        -- seats to put prisoners in, in order: 1 rear left, 2 rear right, 0 front passenger

    -- Commands that act on the closest person (false to turn one off).
    Commands = { cuff = 'cuff', uncuff = 'uncuff', escort = 'escort' },

    -- Attach flags are AttachEntityToEntity's last six arguments:
    -- p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot
    Rear = {
        Label = 'Handcuff (rear)',
        Time = 3800,
        Officer = { dict = 'mp_arrest_paired', clip = 'cop_p2_back_right', flag = 0 },
        Suspect = {
            dict = 'mp_arrest_paired', clip = 'crook_p2_back_right', flag = 0,
            -- Held in position against the officer for the paired animation
            attach = { bone = 0, offset = vec3(-0.1, 0.45, 0.0), rot = vec3(0.0, 0.0, 20.0) },
        },
        Idle = { dict = 'mp_arresting', clip = 'idle', flag = 49 },
        Prop = {
            model = 'p_cs_cuffs_02_s', bone = 60309,
            offset = vec3(-0.055, 0.06, 0.04), rot = vec3(265.0, 155.0, 80.0),
            flags = { true, false, false, false, 0, true },
        },
    },

    Front = {
        Label = 'Handcuff (front)',
        Time = 2500,
        Officer = { dict = 'mp_arresting', clip = 'a_uncuff', flag = 49 },
        Suspect = nil, -- turns to face the officer
        -- Vinewood front-cuff pose and rigid cuffs (stream/)
        Idle = { dict = 'anim_vinewoodpoliceinteration', clip = 'frontcuff_speed', flag = 49 },
        Prop = {
            model = 'ukpolice_cuffs', bone = 57005,
            offset = vec3(0.020, -0.082, -0.004), rot = vec3(114.5, 44.3, -42.0),
            flags = { true, true, false, true, 1, true },
            fallback = 'p_cs_cuffs_02_s', -- used if the custom model fails to load
        },
    },

    Uncuff = {
        Time = 2500,
        Officer = { dict = 'mp_arresting', clip = 'a_uncuff', flag = 49 },
        Suspect = { dict = 'mp_arresting', clip = 'b_uncuff', flag = 49 },
    },

    -- bone 0 is the officer's root, which stays upright (the pelvis, 11816, rocks as they walk and tilts the prisoner)
    Escort = { bone = 0, offset = vec3(0.38, 0.45, 0.0), rot = vec3(0.0, 0.0, 0.0) },
    -- Key to let go of the person you're escorting (players can rebind it in GTA settings)
    LetGoKey = 'G',
}

-- Quick keys for officers (on duty, on foot), acting on the closest person. Players can rebind them in
-- GTA settings under FiveM. Set Enabled = false to have none.
Config.Restraint.Keybinds = {
    Enabled = true,
    Cuff = 'UP',      -- handcuff (rear)
    Escort = 'LEFT',  -- escort / let go
    Uncuff = 'DOWN',  -- remove handcuffs
}

-- The handcuffs item: using it takes the cuffs out, in your hand. Then cuff the person in front
-- (E or the cuff key), or put them away (Backspace or use the item again).
Config.Restraint.HandcuffsItem = {
    Item = 'handcuffs',
    Prop = { model = 'p_cs_cuffs_02_s', bone = 57005, offset = vec3(0.12, 0.03, -0.03), rot = vec3(-90.0, 0.0, 0.0) },
}
