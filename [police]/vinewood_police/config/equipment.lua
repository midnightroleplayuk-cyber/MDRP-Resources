---------------------------------------------------------------------------
-- Equipment lockers. Item names must exist in your inventory: the names below are
-- ox_inventory's. On qb-inventory use its names (e.g. 'pistol_ammo').
--   item        inventory item name
--   label       shown in the locker
--   max         most an officer can hold at once (drawing again is refused until they return some)
--   count       how many one draw gives (default 1, capped by max)
--   permission  from Config.Permissions (rank / qualifications)
--   units       only when signed on as one of these units
--   serial      issue with a serial number and track it (weapons, Tasers)
---------------------------------------------------------------------------
Config.Equipment = {
    -- What happens to issued kit still held at sign-off:
    -- 'return' takes it back automatically, 'keep' leaves it with the officer (still listed as outstanding).
    OnSignOff = 'return',
    -- Audit every draw and return. false = only serialised items (weapons, Tasers).
    AuditAll = false,

    -- armoury = true: only issued at a station armoury (Config.Stations[].armouries), signed out and
    -- handed back there with ammunition accounted for. Everything else comes from the equipment lockers.
    -- ammo (on a firearm): the ammunition item it takes, so rounds still loaded count when it's handed in.
    Items = {
        { item = 'handcuffs',          label = 'Handcuffs (rigid)', max = 1, permission = 'equipment.basic' },
        { item = 'WEAPON_NIGHTSTICK',  label = 'Baton',             max = 1, permission = 'equipment.basic' },
        { item = 'WEAPON_FLASHLIGHT',  label = 'Torch',             max = 1, permission = 'equipment.basic' },
        { item = 'radio',              label = 'Radio',             max = 1, permission = 'equipment.basic' },
        { item = 'bandage',            label = 'First aid dressings', max = 4, count = 2, permission = 'equipment.basic' },

        { item = 'WEAPON_STUNGUN',      label = 'Taser',            max = 1, permission = 'equipment.taser', serial = true, armoury = true },
        { item = 'WEAPON_PISTOL',       label = 'Glock 17',         max = 1, permission = 'equipment.firearms', serial = true, armoury = true, units = { 'arv' }, ammo = 'ammo-9' },
        { item = 'ammo-9',              label = '9mm rounds',       max = 51, count = 17, permission = 'equipment.firearms', armoury = true, units = { 'arv' } },
        { item = 'WEAPON_CARBINERIFLE', label = 'Carbine',          max = 1, permission = 'equipment.firearms', serial = true, armoury = true, units = { 'arv' }, ammo = 'ammo-rifle' },
        { item = 'ammo-rifle',          label = '5.56mm rounds',    max = 60, count = 30, permission = 'equipment.firearms', armoury = true, units = { 'arv' } },
    },
}

---------------------------------------------------------------------------
-- Uniforms. Applied straight to the ped, so they work with any clothing script.
-- Component ids: 1 mask, 3 arms, 4 legs, 5 bag, 6 shoes, 7 accessory, 8 undershirt,
-- 9 body armour, 10 decals, 11 jacket. Props: 0 hat, 1 glasses.
-- The values below are base-game examples: replace them with your server's uniform pack.
--   minRank / units / qualifications: who may wear it
---------------------------------------------------------------------------
Config.Uniforms = {
    -- Put the officer's own clothes back when they sign off.
    RestoreOnSignOff = true,

    Outfits = {
        {
            id = 'patrol', label = 'Patrol uniform', minRank = 'student',
            male = {
                components = { [3] = { 0, 0 }, [4] = { 35, 0 }, [6] = { 25, 0 }, [8] = { 58, 0 }, [11] = { 55, 0 } },
                props = {},
            },
            female = {
                components = { [3] = { 14, 0 }, [4] = { 34, 0 }, [6] = { 25, 0 }, [8] = { 35, 0 }, [11] = { 48, 0 } },
                props = {},
            },
        },
        {
            id = 'patrol_hat', label = 'Patrol uniform with cap', minRank = 'student',
            male = {
                components = { [3] = { 0, 0 }, [4] = { 35, 0 }, [6] = { 25, 0 }, [8] = { 58, 0 }, [11] = { 55, 0 } },
                props = { [0] = { 46, 0 } },
            },
            female = {
                components = { [3] = { 14, 0 }, [4] = { 34, 0 }, [6] = { 25, 0 }, [8] = { 35, 0 }, [11] = { 48, 0 } },
                props = { [0] = { 45, 0 } },
            },
        },
        {
            id = 'arv', label = 'Armed response', minRank = 'pc', units = { 'arv' },
            male = {
                components = { [3] = { 0, 0 }, [4] = { 31, 0 }, [6] = { 25, 0 }, [8] = { 58, 0 }, [9] = { 7, 0 }, [11] = { 53, 0 } },
                props = {},
            },
            female = {
                components = { [3] = { 14, 0 }, [4] = { 30, 0 }, [6] = { 25, 0 }, [8] = { 35, 0 }, [9] = { 7, 0 }, [11] = { 46, 0 } },
                props = {},
            },
        },
        {
            id = 'supervisor', label = 'Supervisor (white shirt)', minRank = 'insp',
            male = {
                components = { [3] = { 0, 0 }, [4] = { 35, 0 }, [6] = { 10, 0 }, [8] = { 58, 0 }, [11] = { 13, 0 } },
                props = {},
            },
            female = {
                components = { [3] = { 14, 0 }, [4] = { 34, 0 }, [6] = { 29, 0 }, [8] = { 35, 0 }, [11] = { 27, 0 } },
                props = {},
            },
        },
    },
}
