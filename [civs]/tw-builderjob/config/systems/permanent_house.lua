-- ====================================================================
-- PERMANENT HOUSE (REGION 14)
-- ====================================================================
-- At 100% the ~100 construction props are deleted and one finished-house prop
-- takes their place. Per-model offset/scale lives here.
-- ====================================================================

Config = Config or {}

Config.PermanentHouse = {}

Config.PermanentHouse.enabled = true

Config.PermanentHouse.spawnDistance   = 200.0
Config.PermanentHouse.despawnDistance = 240.0

Config.PermanentHouse.swap = {
    startDelayMs = 2500,
    buildupMs    = 2500,
    fadeMs       = 3000,
    settleMs     = 2000,

    dust        = true,
    dustAsset   = 'core',
    dustName    = 'ent_dst_rocks',
    dustPoints  = 10,
    dustMargin  = 1.5,
    dustScale   = 3.5,
    dustEveryMs = 260,
    centreDust  = true,
    dustRadius  = 13.0,

    ground      = true,
    groundPoints = 14,
    groundMargin = 5.0,
    groundScale  = 4.5,
    groundZ      = -0.4,

    sound        = true,
    soundStart   = 'concrete_splash',
    soundBeat    = 'nail_hammer',
    soundBeatMs  = 700,
    soundEnd     = 'phase_complete',

    purgeProps  = true,
    purgeMargin    = 10.0,
    purgeMaxRadius = 35.0,

    shake        = true,
    shakeName    = 'SMALL_EXPLOSION_SHAKE',
    shakeAmp     = 0.35,
    shakeRange   = 60.0,
}

Config.PermanentHouse.shoot = {
    studio     = vector3(3151.5, 8690.32, 1414.83),
    altitude   = 400.0,

    fov        = 40.0,
    pitch      = -25.0,
    yaw        = 35.0,
    pad        = 1.40,
    dropRoom   = 0.12,

    backdropModel = nil,
    backdropBack  = 30.0,
    backdropDrop  = 8.0,
    settleMs   = 900,
    betweenMs  = 450,
    quality    = 0.95,
    sunny      = true,
}

Config.PermanentHouse.PropByDesign = {
    DESIGN_SITE1           = 'tw_constoutmaping',
    DESIGN_TOWER_1F        = 'tworst_house_tower_1f',
    DESIGN_SMALL_1F        = 'tworst_house_small_1f',
    DESIGN_WIDE_1F         = 'tworst_house_wide_1f',
    DESIGN_WIDE_2F         = 'tworst_house_wide_2f',
    DESIGN_L_1F            = 'tworst_house_l_1f',
    DESIGN_L_2F            = 'tworst_house_l_2f',
    DESIGN_VILLA_1F        = 'tworst_house_villa_1f',
    DESIGN_VILLA_2F        = 'tworst_house_villa_2f',
    DESIGN_BIG_1F          = 'tworst_house_big_1f',
    DESIGN_L_BIG_1F        = 'tworst_house_l_big_1f',
    DESIGN_L_BIG_2F        = 'tworst_house_l_big_2f',
    DESIGN_T_1F            = 'tworst_house_t_1f',
    DESIGN_T_UP_1F         = 'tworst_house_t_up_1f',
    DESIGN_T_UP_2F         = 'tworst_house_t_up_2f',
    DESIGN_U_1F            = 'tworst_house_u_1f',
    DESIGN_U_2F            = 'tworst_house_u_2f',
    DESIGN_Z_1F            = 'tworst_house_z_1f',
    DESIGN_Z_2F            = 'tworst_house_z_2f',
    DESIGN_C_2F            = 'tworst_house_c_2f',
    DESIGN_CORNER_1F       = 'tworst_house_corner_1f',
    DESIGN_CORNER_2F       = 'tworst_house_corner_2f',
    DESIGN_H_2F            = 'tworst_house_h_2f',
    DESIGN_PLUS_1F         = 'tworst_house_plus_1f',
    DESIGN_PLUS_2F         = 'tworst_house_plus_2f',
    DESIGN_STEP_1F         = 'tworst_house_step_1f',
    DESIGN_S_LONG_2F       = 'tworst_house_s_long_2f',
}

Config.PermanentHouse.catalog = {
    { model = 'tw_constoutmaping', label = 'Twostone — Finished House', ours = true },

    { model = 'lf_house_04_', label = 'House 04' },
    { model = 'lf_house_05_', label = 'House 05' },
    { model = 'lf_house_07_', label = 'House 07' },
    { model = 'lf_house_08_', label = 'House 08' },
    { model = 'lf_house_09_', label = 'House 09' },
    { model = 'lf_house_10_', label = 'House 10' },
    { model = 'lf_house_11_', label = 'House 11' },
    { model = 'lf_house_13_', label = 'House 13' },
    { model = 'lf_house_14_', label = 'House 14' },
    { model = 'lf_house_15_', label = 'House 15' },
    { model = 'lf_house_16_', label = 'House 16' },
    { model = 'lf_house_17_', label = 'House 17' },
    { model = 'lf_house_18_', label = 'House 18' },
    { model = 'lf_house_19_', label = 'House 19' },
    { model = 'lf_house_20_', label = 'House 20' },

}

do
    local seen = {}
    for _, e in ipairs(Config.PermanentHouse.catalog) do seen[e.model] = true end

    local models = {}
    for _, model in pairs(Config.PermanentHouse.PropByDesign) do
        if not seen[model] then seen[model] = true; models[#models + 1] = model end
    end
    table.sort(models)

    for _, model in ipairs(models) do
        local label = model:gsub('^tworst_house_', ''):gsub('_', ' ')
            :gsub('(%a[%w]*)', function(w) return w:sub(1, 1):upper() .. w:sub(2) end)
            :gsub('(%d)f$', '%1F')
        Config.PermanentHouse.catalog[#Config.PermanentHouse.catalog + 1] = {
            model = model, label = label, ours = true,
        }
    end
end

Config.PermanentHouse.models = {
    ['tw_constoutmaping'] = {
        xOffset       = 0.0,
        yOffset       = 0.0,
        zOffset       = 0.0,
        headingOffset = 0.0,
    },
}

Config.PermanentHouse.allowedModels = {}
