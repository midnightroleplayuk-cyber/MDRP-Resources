Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Dyno + car lift (admin-placed per shop)
-- ──────────────────────────────────────────────────────────────────────────────
Config.WorkshopEquipment = {
    enabled = true,

    dynoModel = 'opmechanic_dyno', -- RWD
    dynoModelAwd = 'opmechanic_dyno2', -- AWD
    liftModel = 'opmechanic_lift',
    rampModel = 'opmechanic_ramp',

    rampOffset = { x = 0.0, y = 0.0, z = 0.0 },

    raiseHeight = 2.15,
    raiseSpeed = 0.28,
    interactDistance = 2.2,

    publicUse = false, -- false = on-duty mechanic only

    syncRadius = 40.0,

    dyno = {
        vehicleDistance = 4.5,
        duration = 10.0,
        sampleRate = 20,
        wheelSpin = 44.1,
        hpScale = 1.0,
        nmScale = 1.0,
        showDriverHud = true,
        hudHoldMs = 5000,
        rpmHoldPeakMs = 550,
        wheelCoastMs = 7200,
        coastEase = 'easeIn', -- easeIn | easeOut
        coastIdleRpm = 0.12,
        releaseSettleMs = 350,
        releaseSoftMs = 220,

        antiLag = {
            enabled = true,
            forceChance = false, -- false = use car setting
            showScale = 1.35,
            coastMinRpm = 0.28,
        },

        screenModel = 'prop_tv_flat_01',
        screenTxd = 'prop_tv_flat_01',
        screenTxn = 'script_rt_tvscreen',
        duiWidth = 1280,
        duiHeight = 720,
        screenBindDistance = 28.0,
    },
}