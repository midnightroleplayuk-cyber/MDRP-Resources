Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Mechanic admin panel
-- Permissions -> Config.AdminPanelPlayers / Config.RanksPermissions
-- ──────────────────────────────────────────────────────────────────────────────
Config.MechanicAdmin = {
    enable = true,
    command = 'mechanicadmin',

    defaultCommission = 15,
    defaultBlip = {
        enabled = true,
        sprite = 446,
        color = 5,
        scale = 0.85,
        shortRange = true,
    },
}