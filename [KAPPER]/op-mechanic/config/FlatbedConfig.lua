Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Flatbed load / unload (F6 Mechanic Menu)
-- ──────────────────────────────────────────────────────────────────────────────
Config.Flatbed = {
    enabled = true,
    showInF6Menu = true,

    flatbedDistance = 12.0,
    vehicleDistance = 8.0,
    maxLoadGap = 10.0,

    loadDurationMs = 4500,
    unloadDurationMs = 3500,
    releaseDurationMs = 2000,

    unloadOffset = { x = 0.0, y = -8.5, z = 0.2 },
    unloadClearRadius = 3.2,

    freezeCargo = true,
    disableCargoCollision = true,
    autoLiftFromCargo = true,
    cargoLiftBase = 0.55,
    liftPadding = 0.10,

    models = {
        flatbed = {
            bone = 'bodyshell',
            offset = { x = 0.0, y = -2.0, z = 0.82 },
            rotation = { x = 0.0, y = 0.0, z = 0.0 },
        },
        flatbed2 = {
            bone = 'bodyshell',
            offset = { x = 0.0, y = -2.0, z = 0.82 },
            rotation = { x = 0.0, y = 0.0, z = 0.0 },
        },
        flatbed3 = {
            bone = 'bodyshell',
            offset = { x = 0.0, y = 1.5, z = 0.55 },
            rotation = { x = 0.0, y = 0.0, z = 0.0 },
            bed = {
                mode = 'prop', -- prop | extra | door | none
                prop = 'inm_flatbed_base',
                bone = 'chassis',
                hideExtra = 1,
                raised = { pos = { x = 0.0, y = -3.8, z = 0.45 }, rot = { x = 0.0, y = 0.0, z = 0.0 } },
                back = { pos = { x = 0.0, y = -4.0, z = 0.0 }, rot = { x = 0.0, y = 0.0, z = 0.0 } },
                lowered = { pos = { x = 0.0, y = -0.4, z = -1.0 }, rot = { x = 12.0, y = 0.0, z = 0.0 } },
                slideMs = 2500,
                tiltMs = 2000,
            },
            winch = {
                maxLength = 20.0,
                pullSpeed = 2.8,
                cargoBone = 'bumper_f',
                hookOffset = { x = 0.0, y = 0.05, z = -0.52 },
            },
        },
        -- ['mtlflatbed'] = {
        --     bone = 'bodyshell',
        --     offset = { x = 0.0, y = -2.0, z = 1.0 },
        --     rotation = { x = 0.0, y = 0.0, z = 0.0 },
        -- },
    },

    advanced = {
        enabled = true,
        outline = true,
        outlineColor = { 40, 140, 255, 220 },

        hookProp = 'prop_rope_hook_01',
        hookBone = 57005,
        hookOffset = { x = 0.12, y = 0.02, z = -0.02 },
        hookRotation = { x = -80.0, y = 0.0, z = 0.0 },

        hookDistance = 6.0,
        hookMaxGap = 22.0,
        secureDistance = 2.4,
        windControlDistance = 3.5,
        secureMs = 3000,

        ropeType = 4,
    },

    blacklist = {
        'flatbed',
        'flatbed2',
        'flatbed3',
        'towtruck',
        'towtruck2',
        'scrap',
        'rallytruck',
        'phantom',
        'phantom3',
        'hauler',
        'packer',
        'handler',
    },

    allowBikes = true,
    allowBoats = false,
    allowHelis = false,
    allowPlanes = false,
}