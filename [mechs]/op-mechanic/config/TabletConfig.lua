Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Mechanic tablet
-- Open command -> Config.Commands.openTablet
-- ──────────────────────────────────────────────────────────────────────────────
Config.Tablet = {
    item = 'mechanic_tablet', -- false = command only
    playerMoneyAccount = 'cash',

    Animation = {
        enable = true,
        disableInVehicle = true,
        dict = 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a',
        name = 'idle_a',
        prop = {
            Prop = 'prop_cs_tablet',
            PropBone = 28422,
            PropPlacement = { -0.05, 0.0, 0.0, 0.0, -90.0, 0.0 },
        },
    },
}