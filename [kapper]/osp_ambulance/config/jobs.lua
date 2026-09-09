Config = Config or {}

-- Job access. Add as many jobs as you need; each job can have different access.
-- Players whose job is not listed here use the `civilian` profile.
--
-- ems = true  -> medical staff (dispatch, doctor count, job blips, prescriptions, wheelchair, incoming, blood draw)
-- medicalMenu -> can open the medical menu
-- Action keys -> who can use that medical action (cpr, casts, etc.)
-- Medications are still locked individually with lockAccess in Config.Medication (ems jobs only).
--
-- Hospital facilities (stash, shop, vehicles, etc.) require being on duty.
-- Medical menu treatment actions use the job profile even when off duty.
-- Anyone else falls back to civilian.

Config.Jobs = {
    civilian = {
        ems = false,
        medicalMenu = true, -- false = only listed jobs can open the medical menu

        cpr = false,
        bodybag = false,
        revivekit = false,
        transportation = true,
        cast = false,
        splint = false,
        quickChecks = true,
        castsaw = false,
        stripclothes = true,

        duty = false,
        stash = false,
        shop = false,
        vehicles = false,
        helicopter = false,
        roof = true,
        main = true,
        elevator = true,
        bloodstorage = false,
        bloodanalysis = false,
        boss = false,
        cloakroom = false,
    },

    ambulance = {
        ems = true,
        medicalMenu = true,

        cpr = true,
        bodybag = true,
        revivekit = true,
        transportation = true,
        cast = true,
        splint = true,
        quickChecks = true,
        castsaw = true,
        stripclothes = true,

        duty = true,
        stash = true,
        shop = true,
        vehicles = true,
        helicopter = true,
        roof = true,
        main = true,
        elevator = true,
        bloodstorage = true,
        bloodanalysis = true,
        boss = true,
        cloakroom = true,
    },

    police = {
        ems = false,
        medicalMenu = true,

        cpr = true,
        bodybag = true,
        revivekit = true,
        transportation = true,
        cast = false,
        splint = false,
        quickChecks = false,
        castsaw = false,
        stripclothes = false,

        duty = false,
        stash = false,
        shop = false,
        vehicles = false,
        helicopter = false,
        roof = true,
        main = true,
        elevator = true,
        bloodstorage = false,
        bloodanalysis = false,
        boss = false,
        cloakroom = false,
    },

    -- Example: limited access for another job
    -- police = {
    --     ems = false,
    --     medicalMenu = true,
    --     cpr = true,
    --     bodybag = true,
    --     revivekit = false,
    --     transportation = true,
    --     cast = false,
    --     splint = false,
    --     quickChecks = true,
    --     castsaw = false,
    --     stripclothes = true,
    --     duty = false,
    --     stash = false,
    --     shop = false,
    --     vehicles = false,
    --     helicopter = false,
    --     roof = false,
    --     main = false,
    --     elevator = false,
    --     bloodstorage = false,
    --     bloodanalysis = false,
    --     boss = false,
    --     cloakroom = false,
    -- },
}
