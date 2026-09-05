Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Custom tuning kits
--
-- Each entry in `slots` = one option in the Tuning category.
-- Kit handling:
--   mult = { field = 1.2 }   → multiply stock value
--   set  = { field = 0.5 }   → overwrite stock value
--   set  = { nInitialDriveGears = 5 }  → gear count (int, supported)
-- Optional: label (plain text), labelKey, descriptionKey, item, price, audioHash,
--           blacklist = { 'modelname', ... }, powertrain = 'any'|'ice'|'ev'
--
-- Examples below (turbo / transmission) are COMMENTED — uncomment to enable.
-- Add matching items to your inventory + Config.Parts.catalog if you use parts order.
-- ──────────────────────────────────────────────────────────────────────────────
Config.TuningKits = {
    enabled = true,

    slots = {
        {
            id = 'engine',
            labelKey = 'option.tuning.engine',
            focus = 'engine',
            openHood = true,
            order = 1,
            powertrain = 'ice', -- any | ice | ev
            stockLabelKey = 'level.stock',
            kits = {
                {
                    id = 'twin_i4',
                    labelKey = 'option.tuning.engine.twin_i4',
                    descriptionKey = 'option.tuning.engine.twin_i4.desc',
                    item = 'engine_swap_i4',
                    price = 28000,
                    audioHash = 'sultan2',
                    mult = {
                        fInitialDriveForce = 1.12,
                        fDriveInertia = 1.05,
                        fInitialDriveMaxFlatVel = 1.06,
                        fClutchChangeRateScaleUpShift = 1.15,
                        fClutchChangeRateScaleDownShift = 1.1,
                    },
                },
                {
                    id = 'street_v6',
                    labelKey = 'option.tuning.engine.street_v6',
                    descriptionKey = 'option.tuning.engine.street_v6.desc',
                    item = 'engine_swap_v6',
                    price = 42000,
                    audioHash = 'comet4',
                    mult = {
                        fInitialDriveForce = 1.22,
                        fDriveInertia = 1.0,
                        fInitialDriveMaxFlatVel = 1.12,
                        fClutchChangeRateScaleUpShift = 1.25,
                        fClutchChangeRateScaleDownShift = 1.2,
                    },
                },
                {
                    id = 'forged_v8',
                    labelKey = 'option.tuning.engine.forged_v8',
                    descriptionKey = 'option.tuning.engine.forged_v8.desc',
                    item = 'engine_swap_v8',
                    price = 62000,
                    audioHash = 'jugular',
                    mult = {
                        fInitialDriveForce = 1.35,
                        fDriveInertia = 0.95,
                        fInitialDriveMaxFlatVel = 1.18,
                        fClutchChangeRateScaleUpShift = 1.4,
                        fClutchChangeRateScaleDownShift = 1.3,
                    },
                },
                {
                    id = 'motorsport_v12',
                    labelKey = 'option.tuning.engine.motorsport_v12',
                    descriptionKey = 'option.tuning.engine.motorsport_v12.desc',
                    item = 'engine_swap_v12',
                    price = 78000,
                    audioHash = 'schafter3',
                    blacklist = { 'panto', 'issi2', 'issi3' },
                    mult = {
                        fInitialDriveForce = 1.45,
                        fDriveInertia = 0.92,
                        fInitialDriveMaxFlatVel = 1.25,
                        fClutchChangeRateScaleUpShift = 1.35,
                        fClutchChangeRateScaleDownShift = 1.25,
                    },
                },
            },
        },
        {
            id = 'tires',
            labelKey = 'option.tuning.tires',
            focus = 'wheels',
            order = 4,
            powertrain = 'any',
            stockLabelKey = 'level.stock',
            kits = {
                {
                    id = 'track_slick',
                    labelKey = 'option.tuning.tires.track_slick',
                    descriptionKey = 'option.tuning.tires.track_slick.desc',
                    item = 'tyre_track_slick',
                    price = 18000,
                    mult = {
                        fTractionCurveMin = 1.18,
                        fTractionCurveMax = 1.22,
                        fLowSpeedTractionLossMult = 0.85,
                    },
                },
                {
                    id = 'street_semi',
                    labelKey = 'option.tuning.tires.street_semi',
                    descriptionKey = 'option.tuning.tires.street_semi.desc',
                    item = 'tyre_street_semi',
                    price = 12000,
                    mult = {
                        fTractionCurveMin = 1.1,
                        fTractionCurveMax = 1.12,
                    },
                },
                {
                    id = 'trail_mud',
                    labelKey = 'option.tuning.tires.trail_mud',
                    descriptionKey = 'option.tuning.tires.trail_mud.desc',
                    item = 'tyre_trail_mud',
                    price = 14000,
                    set = {
                        fTractionLossMult = 0.15,
                    },
                    mult = {
                        fTractionCurveMin = 1.05,
                        fTractionCurveMax = 1.08,
                    },
                },
            },
        },
        {
            id = 'brakes',
            labelKey = 'option.tuning.brakes',
            focus = 'wheels',
            order = 3,
            powertrain = 'any',
            stockLabelKey = 'level.stock',
            kits = {
                {
                    id = 'race_ceramic',
                    labelKey = 'option.tuning.brakes.race_ceramic',
                    descriptionKey = 'option.tuning.brakes.race_ceramic.desc',
                    item = 'brake_race_ceramic',
                    price = 22000,
                    mult = {
                        fBrakeForce = 1.35,
                        fBrakeBiasFront = 1.0,
                    },
                },
                {
                    id = 'endurance',
                    labelKey = 'option.tuning.brakes.endurance',
                    descriptionKey = 'option.tuning.brakes.endurance.desc',
                    item = 'brake_endurance',
                    price = 16000,
                    mult = {
                        fBrakeForce = 1.18,
                        fHandBrakeForce = 1.1,
                    },
                },
            },
        },
        {
            id = 'drivetrain',
            labelKey = 'option.tuning.drivetrain',
            focus = 'engine',
            openHood = true,
            order = 2,
            powertrain = 'any',
            stockLabelKey = 'level.stock',
            kits = {
                {
                    id = 'awd',
                    labelKey = 'option.tuning.drivetrain.awd',
                    descriptionKey = 'option.tuning.drivetrain.awd.desc',
                    item = 'drivetrain_awd',
                    price = 45000,
                    set = { fDriveBiasFront = 0.5 },
                },
                {
                    id = 'rwd',
                    labelKey = 'option.tuning.drivetrain.rwd',
                    descriptionKey = 'option.tuning.drivetrain.rwd.desc',
                    item = 'drivetrain_rwd',
                    price = 32000,
                    set = { fDriveBiasFront = 0.0 },
                },
                {
                    id = 'fwd',
                    labelKey = 'option.tuning.drivetrain.fwd',
                    descriptionKey = 'option.tuning.drivetrain.fwd.desc',
                    item = 'drivetrain_fwd',
                    price = 28000,
                    set = { fDriveBiasFront = 1.0 },
                },
            },
        },

        --[[ EXAMPLE: turbocharger slot (uncomment to enable)
        {
            id = 'turbo',
            label = 'Turbo',
            labelKey = 'option.tuning.turbo',
            focus = 'engine',
            openHood = true,
            order = 5,
            powertrain = 'ice',
            stockLabelKey = 'level.stock',
            kits = {
                {
                    id = 'street',
                    label = 'Street Turbo',
                    labelKey = 'option.tuning.turbo.standard',
                    item = 'turbocharger',
                    price = 10500,
                    -- Absolute handling overwrite (set), not multiplier:
                    set = {
                        fInitialDriveForce = 1.05,
                        fInitialDriveMaxFlatVel = 150.0,
                        fClutchChangeRateScaleUpShift = 1.1,
                        fClutchChangeRateScaleDownShift = 0.95,
                    },
                },
            },
        },
        ]]

        --[[ EXAMPLE: transmission / gearbox slot (uncomment to enable)
        {
            id = 'transmission',
            label = 'Transmission',
            labelKey = 'option.tuning.transmission',
            focus = 'engine',
            openHood = true,
            order = 6,
            powertrain = 'any',
            stockLabelKey = 'level.stock',
            kits = {
                {
                    id = 'gears6',
                    label = '6-speed',
                    labelKey = 'option.tuning.transmission.gears6',
                    item = 'transmission_6speed',
                    price = 9800,
                    -- Gear count uses set + nInitialDriveGears (integer handling field):
                    set = { nInitialDriveGears = 5 },
                },
            },
        },
        ]]
    },
}