-- ====================================================================
-- VEHICLE RENTAL
-- ====================================================================
-- Rent from the company lot with [E], pay a deposit, hand it back when the
-- job ends. Every vehicle type has its own parking spot, stock and deposit.
-- ====================================================================

Config.VehicleRental = {
    enabled = true,

    -- 'spawn_point' : every vehicle waits on its bay; walk up and press [E].
    -- 'npc'         : the bays stay empty. Players pick a vehicle from the
    --                 rental clerk and it spawns on its bay only then. Use this
    --                 if you want the lot free for something else.
    rentalMode = 'spawn_point',

    -- Rental clerk (used only when rentalMode = 'npc').
    npc = {
        coords  = vector4(1527.09, 1674.69, 112.68, 2.261),
        model   = 's_m_m_autoshop_01',
        radius  = 2.5,
        blip    = { enabled = true, sprite = 326, color = 3, scale = 0.8 },
    },

    -- Angle for the rental menu photos (/permshoot vehicles). yaw 90 is a flat
    -- side view; a little less shows some of the front.
    photo = { yaw = 75.0, pitch = -5.0, fov = 30.0, pad = 1.55, settleMs = 1600 },

    depositEnabled = true,

    depositAccount = Config.MoneyAccount,

    damagePenalty = {
        enabled        = true,
        multiplier     = 1.0,
        graceHealthPct = 95,
        useEngine      = true,
        useBody        = true,
    },

    requireReturnToFinish = true,

    fullFuelOnRent = true,

    returnRadius = 5.0,
    returnTimeoutMs = 300000,

    returnPoint = vector4(1534.41, 1703.69, 111.52, 269.27),

    spotMarker = {
        enabled      = true,
        drawDistance = 60.0,
        height       = 3.5,
        scale        = 0.9,
        color        = { r = 255, g = 255, b = 255, a = 200 },
    },

    returnMarker = {
        enabled      = true,
        height       = 2.6,
        scale        = 1.0,
        zOffset      = 0.0,
        color        = { r = 255, g = 180, b = 40, a = 180 },
        drawDistance = 30.0,
    },

}

local TOLHAULMA_PALETTE = { 4, 8, 27, 34, 53, 62, 88, 111, 137, 0 }

Config.RentalVehicles = {
    winch    = {
        type = 'winch',
        label = TL('rentveh_cranev2', 'Crane'),
        labelKey = 'rentveh_cranev2',
        model = 'twhaulma',
        deposit = 5000,
        coords = vector4(1539.58, 1667.12, 113.01, 1.08),
        restockDistance = 20.0,
        customization = {
            plate = 'TWORST 1',
            extras = { [1] = true, [2] = true, [3] = true, [4] = true },
            extrasDefault = 'keep',
            colors = { primary = TOLHAULMA_PALETTE, secondary = 12 },
            dirtLevel = 0.0
        }
    },
    pump     = {
        type = 'pump',
        label = TL('rentveh_pump', 'Pump'),
        labelKey = 'rentveh_pump',
        model = 'twhaulma',
        deposit = 5000,
        coords = vector4(1546.05, 1666.77, 113.02, 357.21),
        restockDistance = 20.0,
        customization = {
            plate = 'TWORST 2',
            extras = {},
            extrasDefault = 'off',
            colors = { primary = TOLHAULMA_PALETTE, secondary = 12 },
            dirtLevel = 0.0
        }
    },
    mixer    = {
        type = 'mixer',
        label = TL('rentveh_mixer', 'Mixer'),
        labelKey = 'rentveh_mixer',
        model = 'twmixer',
        deposit = 3000,
        coords = vector4(1552.15, 1667.17, 112.30, 357.81),
        customization = {
            plate = 'TWORST 3',
            colors = { primary = 14, secondary = 14 },
            dirtLevel = 0.0
        }
    },
    jcb      = {
        type = 'jcb',
        label = TL('rentveh_jcb', 'Excavator'),
        labelKey = 'rentveh_jcb',
        model = 'twdigmas',
        deposit = 5000,
        coords = vector4(1557.75, 1666.69, 111.66, 357.65),
        customization = {
            plate = 'TWORST 4',
            extras = { [1] = true },
            extrasDefault = 'off',
            colors = { primary = 42, secondary = 42 },
            dirtLevel = 0.0
        }
    },
    tiptruck = {
        type = 'tiptruck',
        label = TL('rentveh_tiptruck', 'Truck'),
        labelKey = 'rentveh_tiptruck',
        model = 'twtiptruck',
        deposit = 4000,
        coords = vector4(1563.27, 1666.15, 112.32, 357.95),
        customization = {
            plate = 'TWORST 5',
            extras = {},
            extrasDefault = 'off',
            colors = { primary = 42, secondary = 12 },
            pearlescent = 12,
            dirtLevel = 0.0
        }
    },
    bison2   = {
        type = 'bison2',
        label = TL('rentveh_bison', 'Van'),
        labelKey = 'rentveh_bison',
        model = 'bison2',
        deposit = 4000,
        coords = vector4(1533.18, 1667.42, 112.22, 359.22),
        customization = {
            plate = 'TWORST 6',
            extrasDefault = 'on',
            colors = { primary = 4, secondary = 1 },
            dirtLevel = 0.0
        }
    },
}

Config.VehicleRental.uniquePlates = true

Config.VehicleRental.restockCheckMs = 5000
Config.VehicleRental.spotClearRadius = 4.0

Config.VehicleRental.spawnHideDropZ = 25.0
Config.VehicleRental.spawnHideMs = 2500

Config.VehicleRental.spotRestockDistance = 15.0

Config.VehicleRental.stockStreamDistance = 250.0

do
    local m = tonumber(Config.DepositMultiplier)
    if m and m ~= 1.0 then
        for _, spot in pairs(Config.RentalVehicles or {}) do
            if tonumber(spot.deposit) then
                spot.deposit = math.max(0, math.floor(spot.deposit * m + 0.5))
            end
        end
    end
end
