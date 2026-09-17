Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Parts mapping + wholesale catalog
-- Strategies: flat | perModification | perLevel | perWheel
-- ──────────────────────────────────────────────────────────────────────────────
Config.Parts = {
    requireParts = true,
    requireTools = false,
    tools = {
        item = 'mechanic_tools',
        amount = 1,
    },

    defaults = {
        strategy = 'perModification',
        amount = 1,
        item = 'body_parts',
    },

    -- Optional: one dedicated item per performance tier (UI level 1 = GTA mod 0).
    -- When enabled, installing Engine 2 consumes engine_upgrade_2 (not N x engine_parts).
    -- Stock / remove (value -1) still costs nothing. Unmapped levels fall back to rules below.
    performanceLevelItems = {
        enabled = false,
        amount = 1,
        items = {
            ['performance.engine'] = {
                [1] = 'engine_upgrade_1',
                [2] = 'engine_upgrade_2',
                [3] = 'engine_upgrade_3',
                [4] = 'engine_upgrade_4',
            },
            ['performance.brakes'] = {
                [1] = 'brake_upgrade_1',
                [2] = 'brake_upgrade_2',
                [3] = 'brake_upgrade_3',
            },
            ['performance.transmission'] = {
                [1] = 'transmission_upgrade_1',
                [2] = 'transmission_upgrade_2',
                [3] = 'transmission_upgrade_3',
            },
            ['performance.suspension'] = {
                [1] = 'suspension_upgrade_1',
                [2] = 'suspension_upgrade_2',
                [3] = 'suspension_upgrade_3',
                [4] = 'suspension_upgrade_4',
            },
            ['performance.armor'] = {
                [1] = 'armor_upgrade_1',
                [2] = 'armor_upgrade_2',
                [3] = 'armor_upgrade_3',
                [4] = 'armor_upgrade_4',
                [5] = 'armor_upgrade_5',
            },
        },
    },

    rules = {
        ['wheels.model'] = { item = 'wheel_parts', strategy = 'flat', amount = 1 },
        ['wheels.color'] = { item = 'paint_supplies', strategy = 'flat', amount = 1 },
        ['wheels.tireSmoke'] = { item = 'tire_parts', strategy = 'flat', amount = 1 },
        ['wheels.customTires'] = { item = 'tire_parts', strategy = 'flat', amount = 1 },
        ['wheels.bulletproof'] = { item = 'tire_parts', strategy = 'flat', amount = 1 },

        ['paint.primary.color'] = { item = 'paint_supplies', strategy = 'flat', amount = 1 },
        ['paint.secondary.color'] = { item = 'paint_supplies', strategy = 'flat', amount = 1 },
        ['paint.primary.finish'] = { item = 'paint_supplies', strategy = 'flat', amount = 1 },
        ['paint.secondary.finish'] = { item = 'paint_supplies', strategy = 'flat', amount = 1 },
        ['paint.pearlescent'] = { item = 'paint_supplies', strategy = 'flat', amount = 1 },
        ['paint.dashboard'] = { item = 'interior_parts', strategy = 'flat', amount = 1 },
        ['paint.interior'] = { item = 'interior_parts', strategy = 'flat', amount = 1 },

        ['performance.engine'] = { item = 'engine_parts', strategy = 'perLevel', amount = 1 },
        ['performance.turbo'] = { item = 'engine_parts', strategy = 'flat', amount = 2 },
        ['tuning.antilag'] = { item = 'exhaust_parts', strategy = 'flat', amount = 2 },
        ['performance.brakes'] = { item = 'brake_parts', strategy = 'perLevel', amount = 1 },
        ['performance.transmission'] = { item = 'transmission_parts', strategy = 'perLevel', amount = 1 },
        ['performance.suspension'] = { item = 'suspension_parts', strategy = 'perLevel', amount = 1 },
        ['performance.armor'] = { item = 'body_parts', strategy = 'perLevel', amount = 1 },

        ['body.'] = { item = 'body_parts', strategy = 'perModification', amount = 1 },
        ['body.exhaust'] = { item = 'exhaust_parts', strategy = 'flat', amount = 1 },
        ['body.horn'] = { item = 'body_parts', strategy = 'flat', amount = 1 },

        ['lights.'] = { item = 'lighting_parts', strategy = 'perModification', amount = 1 },
        ['interior.'] = { item = 'interior_parts', strategy = 'perModification', amount = 1 },
        ['extras.'] = { item = 'body_parts', strategy = 'perModification', amount = 1 },
        ['nitro.kit'] = { item = 'nitrous_install_kit', strategy = 'flat', amount = 1 },
        ['rgb.controller'] = { item = 'rgb_controller', strategy = 'flat', amount = 1 },
        ['tuning.'] = { item = 'engine_parts', strategy = 'flat', amount = 1 },
        ['stance.'] = { item = 'suspension_parts', strategy = 'perModification', amount = 1 },
        ['repair.wash'] = { skip = true },
        ['repair.'] = { item = 'body_parts', strategy = 'flat', amount = 1 },
    },

    catalog = {
        { id = 'wheel_parts', item = 'wheel_parts', price = 450, max = 20 },
        { id = 'tire_parts', item = 'tire_parts', price = 320, max = 20 },
        { id = 'paint_supplies', item = 'paint_supplies', price = 280, max = 20 },
        { id = 'engine_parts', item = 'engine_parts', price = 900, max = 15 },
        { id = 'brake_parts', item = 'brake_parts', price = 520, max = 15 },
        { id = 'transmission_parts', item = 'transmission_parts', price = 780, max = 15 },
        { id = 'suspension_parts', item = 'suspension_parts', price = 610, max = 15 },
        { id = 'body_parts', item = 'body_parts', price = 400, max = 20 },
        { id = 'exhaust_parts', item = 'exhaust_parts', price = 480, max = 15 },
        { id = 'lighting_parts', item = 'lighting_parts', price = 360, max = 20 },
        { id = 'rgb_controller', item = 'rgb_controller', price = 1450, max = 10 },
        { id = 'interior_parts', item = 'interior_parts', price = 340, max = 20 },
        { id = 'nitrous_bottle', item = 'nitrous_bottle', price = 650, max = 20 },
        { id = 'empty_nitrous_bottle', item = 'empty_nitrous_bottle', price = 80, max = 20 },
        { id = 'car_wax', item = 'car_wax', price = 180, max = 40 },
        { id = 'engine_kit', item = 'engine_kit', price = 950, max = 25 },
        { id = 'body_kit', item = 'body_kit', price = 850, max = 25 },
        { id = 'cleaning_kit', item = 'cleaning_kit', price = 120, max = 40 },
        { id = 'engine_swap_i4', item = 'engine_swap_i4', price = 8500, max = 6 },
        { id = 'engine_swap_v6', item = 'engine_swap_v6', price = 12000, max = 6 },
        { id = 'engine_swap_v8', item = 'engine_swap_v8', price = 16000, max = 4 },
        { id = 'engine_swap_v12', item = 'engine_swap_v12', price = 21000, max = 3 },
        { id = 'tyre_track_slick', item = 'tyre_track_slick', price = 2400, max = 12 },
        { id = 'tyre_street_semi', item = 'tyre_street_semi', price = 1600, max = 12 },
        { id = 'tyre_trail_mud', item = 'tyre_trail_mud', price = 1800, max = 12 },
        { id = 'brake_race_ceramic', item = 'brake_race_ceramic', price = 3200, max = 8 },
        { id = 'brake_endurance', item = 'brake_endurance', price = 2400, max = 8 },
        { id = 'drivetrain_awd', item = 'drivetrain_awd', price = 9800, max = 4 },
        { id = 'drivetrain_rwd', item = 'drivetrain_rwd', price = 7200, max = 4 },
        { id = 'drivetrain_fwd', item = 'drivetrain_fwd', price = 6400, max = 4 },
        { id = 'engine_oil', item = 'engine_oil', price = 180, max = 20 },
        { id = 'clutch_kit', item = 'clutch_kit', price = 720, max = 10 },
        { id = 'air_filter', item = 'air_filter', price = 140, max = 20 },
        { id = 'spark_plugs', item = 'spark_plugs', price = 90, max = 40 },
        { id = 'brake_pads', item = 'brake_pads', price = 260, max = 20 },
        { id = 'service_suspension', item = 'service_suspension', price = 540, max = 12 },
        { id = 'tyre_set', item = 'tyre_set', price = 480, max = 12 },
        { id = 'alternator', item = 'alternator', price = 640, max = 10 },
        { id = 'ev_motor', item = 'ev_motor', price = 2200, max = 4 },
        { id = 'ev_battery', item = 'ev_battery', price = 1800, max = 4 },
        { id = 'ev_coolant', item = 'ev_coolant', price = 220, max = 16 },

        -- Enable performanceLevelItems above, register these in your inventory, then uncomment:
        -- { id = 'engine_upgrade_1', item = 'engine_upgrade_1', price = 2500, max = 10 },
        -- { id = 'engine_upgrade_2', item = 'engine_upgrade_2', price = 5000, max = 10 },
        -- { id = 'engine_upgrade_3', item = 'engine_upgrade_3', price = 8500, max = 8 },
        -- { id = 'engine_upgrade_4', item = 'engine_upgrade_4', price = 12000, max = 6 },
        -- { id = 'brake_upgrade_1', item = 'brake_upgrade_1', price = 1500, max = 10 },
        -- { id = 'brake_upgrade_2', item = 'brake_upgrade_2', price = 3000, max = 10 },
        -- { id = 'brake_upgrade_3', item = 'brake_upgrade_3', price = 4500, max = 8 },
        -- { id = 'transmission_upgrade_1', item = 'transmission_upgrade_1', price = 2000, max = 10 },
        -- { id = 'transmission_upgrade_2', item = 'transmission_upgrade_2', price = 4000, max = 10 },
        -- { id = 'transmission_upgrade_3', item = 'transmission_upgrade_3', price = 6500, max = 8 },
        -- { id = 'suspension_upgrade_1', item = 'suspension_upgrade_1', price = 1200, max = 10 },
        -- { id = 'suspension_upgrade_2', item = 'suspension_upgrade_2', price = 2400, max = 10 },
        -- { id = 'suspension_upgrade_3', item = 'suspension_upgrade_3', price = 3800, max = 8 },
        -- { id = 'suspension_upgrade_4', item = 'suspension_upgrade_4', price = 5200, max = 6 },
        -- { id = 'armor_upgrade_1', item = 'armor_upgrade_1', price = 2000, max = 10 },
        -- { id = 'armor_upgrade_2', item = 'armor_upgrade_2', price = 4000, max = 10 },
        -- { id = 'armor_upgrade_3', item = 'armor_upgrade_3', price = 6500, max = 8 },
        -- { id = 'armor_upgrade_4', item = 'armor_upgrade_4', price = 9000, max = 6 },
        -- { id = 'armor_upgrade_5', item = 'armor_upgrade_5', price = 12000, max = 4 },
    },
}
