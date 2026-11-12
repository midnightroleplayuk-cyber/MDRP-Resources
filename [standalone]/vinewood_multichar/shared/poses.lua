-- Pose presets shown in the scene editor. Add your own freely.
-- type = 'anim'     -> dict + clip (+ flag, 1 = loop)
-- type = 'scenario' -> GTA scenario name (spawns its own props, e.g. cigarette, phone)
VMC.Poses = {
    { id = 'idle',       label = 'Standing still',     type = 'none' },
    { id = 'crossarms',  label = 'Arms crossed',       type = 'anim', dict = 'amb@world_human_hang_out_street@female_arms_crossed@idle_a', clip = 'idle_a', flag = 1 },
    { id = 'crossarms2', label = 'Arms crossed (casual)', type = 'anim', dict = 'amb@world_human_hang_out_street@male_c@idle_a', clip = 'idle_b', flag = 1 },
    { id = 'leanwall',   label = 'Leaning back on wall', type = 'anim', dict = 'amb@world_human_leaning@male@wall@back@foot_up@idle_a', clip = 'idle_a', flag = 1 },
    { id = 'think',      label = 'Thinking',           type = 'anim', dict = 'misscarsteal4@aliens', clip = 'rehearsal_base', flag = 1 },
    { id = 'lean',       label = 'Leaning (rail/bar)', type = 'scenario', scenario = 'WORLD_HUMAN_LEANING' },
    { id = 'smoke',      label = 'Smoking',            type = 'scenario', scenario = 'WORLD_HUMAN_SMOKING' },
    { id = 'phone',      label = 'On phone',           type = 'scenario', scenario = 'WORLD_HUMAN_STAND_MOBILE' },
    { id = 'coffee',     label = 'Holding coffee',     type = 'scenario', scenario = 'WORLD_HUMAN_AA_COFFEE' },
    { id = 'drink',      label = 'Drinking',           type = 'scenario', scenario = 'WORLD_HUMAN_DRINKING' },
    { id = 'clipboard',  label = 'Clipboard',          type = 'scenario', scenario = 'WORLD_HUMAN_CLIPBOARD' },
    { id = 'guard',      label = 'Guard stance',       type = 'scenario', scenario = 'WORLD_HUMAN_GUARD_STAND' },
    { id = 'cop',        label = 'Police idle',        type = 'scenario', scenario = 'WORLD_HUMAN_COP_IDLES' },
    { id = 'impatient',  label = 'Impatient',          type = 'scenario', scenario = 'WORLD_HUMAN_STAND_IMPATIENT' },
    { id = 'hangout',    label = 'Hanging out',        type = 'scenario', scenario = 'WORLD_HUMAN_HANG_OUT_STREET' },
    { id = 'flex',       label = 'Flexing',            type = 'scenario', scenario = 'WORLD_HUMAN_MUSCLE_FLEX' },
    { id = 'guitar',     label = 'Playing guitar',     type = 'scenario', scenario = 'WORLD_HUMAN_MUSICIAN' },
    { id = 'map',        label = 'Reading map',        type = 'scenario', scenario = 'WORLD_HUMAN_TOURIST_MAP' },
    { id = 'camera',     label = 'Taking photos',      type = 'scenario', scenario = 'WORLD_HUMAN_PAPARAZZI' },
    { id = 'binoculars', label = 'Binoculars',         type = 'scenario', scenario = 'WORLD_HUMAN_BINOCULARS' },
    { id = 'sitchair',   label = 'Sitting on chair',   type = 'scenario', scenario = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', sitting = true },
    { id = 'sitbench',   label = 'Sitting on bench',   type = 'scenario', scenario = 'PROP_HUMAN_SEAT_BENCH', sitting = true },
    { id = 'sitground',  label = 'Sitting on ground',  type = 'scenario', scenario = 'WORLD_HUMAN_PICNIC' },
    { id = 'yoga',       label = 'Yoga',               type = 'scenario', scenario = 'WORLD_HUMAN_YOGA' },
}

VMC.PoseById = {}
for _, p in ipairs(VMC.Poses) do VMC.PoseById[p.id] = p end

-- Common bones for attached props
VMC.Bones = {
    { id = 57005, label = 'Right hand' },
    { id = 18905, label = 'Left hand' },
    { id = 31086, label = 'Head' },
    { id = 24818, label = 'Chest' },
    { id = 11816, label = 'Pelvis' },
    { id = 40269, label = 'Right upper arm' },
    { id = 45509, label = 'Left upper arm' },
}
