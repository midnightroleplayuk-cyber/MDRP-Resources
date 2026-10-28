-- World info boards (DUI): texture, resolution and refresh interval.
Config.PropDUI = {
    enabled = true,

    model   = 'tw_redline_int_tv',
    texture = 'PlasticColor',

    sourceTxd = 'tw_tv',
    extraTxd  = {
        'tw_redline_int_tv1',
        'tw_redline_int_tv2',
    },

    screens = nil,

    url     = nil,

    width   = 1920,
    height  = 1080,

    calibrate = false,

    applyDelay = 100,
    streamRetries = 12,

    tryCaseVariants = true,

    txdName = nil,
    texName = nil,
}
