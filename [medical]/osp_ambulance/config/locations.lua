Config = Config or {}

-- INCOMINNG INFORMATION SCREENS CONFIGURATION (ER SCREENS)
Config.ScreenProp = 'xm_prop_x17_tv_ceiling_01' -- The prop used for the screen

Config.IncomingRenderDistance = 70 -- The rendering distance of an incoming screen, recommended to keep above 30 to avoid sync issues.

Config.IncomingScreenSoundRange = 50

-- STATIONARY ECG CONFIGURATION (ICU SCREENS)
Config.StationaryECGProp = 'v_med_cor_ceilingmonitor' -- The prop used for the stationary ECG

Config.Hospitals = {
    {
        label = "Burton Hospital",
        blip = {
            enable = true,
            icon = 61,
            color = 6,
            scale = 0.8,
            coords = vector3(-309.2064, -162.6781, 39.2400),
        },
        checking = {
            vector4(-314.1700, -151.5700, 40.2400, 199.4700),
            vector4(-312.6200, -150.7800, 40.2400, 201.3300),
        },

        duty = {
            vector3(-337.7195, -172.1763, 40.9025),
            vector3(-343.4665, -128.4014, 39.2467),
        },

        helicopter = {
            vector4(351.5800, -587.4500, 74.2000, 160.5000),
        },

        shop = {
            vector3(-343.7902, -124.9753, 38.6600), --Recovery
            vector3(-352.8016, -103.0631, 38.7941), --Major
            vector3(-344.1620, -103.3250, 38.6600), --Resus
            vector3(-338.6257, -174.4952, 38.3936), --Garage
            vector3(-332.2993, -146.5459, 40.1600), --Ward 1
        },

        elevator = {
            {
                label = "Main Elevator",
                floors = {
                    {
                        label = "Main",
                        coords = vector4(332.3166, -595.6741, 43.2841, 245.5),
                    },
                    {
                        label = "Roof",
                        coords = vector4(338.5, -583.85, 74.16, 245.5),
                    },
                },
            },
        },

        stash = {
            vector3(-345.4592, -157.5180, 38.9611),
            vector3(-338.7900, -151.6216, 38.9490),
        },

        bloodstorage = {
            vector3(-360.2426, -99.9705, 39.1072),
        },

        donation = {
            {
                coords = vector4(-359.1487, -98.1472, 38.7885, 68.1275),
                getOutOffset = 0.8,
                model = "",
            },
            {
                coords = vector4(-358.2263, -95.7368, 38.8128, 66.7281),
                getOutOffset = 0.8,
                model = "",
            },
            {
                coords = vector4(-357.3681, -93.2896, 38.8190, 67.4821),
                getOutOffset = 0.8,
                model = "",
            },
        },

        bloodanalysis = { -- station to analyze blood sample
            vector3(-362.1788, -100.1889, 38.9297),
        },

        pharmacy = {
            vector4(-316.4900, -133.9500, 40.2400, 242.4000), --DONE
        },

        beds = {
            {coords = vector4(-323.9619, -152.2204, 40.1413, 337.7379), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 1
            {coords = vector4(-326.6215, -151.2420, 40.1303, 337.7892), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 2
            {coords = vector4(-329.3216, -150.2216, 40.1262, 336.9239), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 3
            {coords = vector4(-331.9048, -149.2940, 40.1645, 333.3730), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 4
            {coords = vector4(-328.3973, -139.0886, 40.0909, 156.0540), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 5
            {coords = vector4(-325.7433, -140.0889, 40.1000, 154.8701), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 6
            {coords = vector4(-322.9490, -141.1869, 40.1320, 156.1173), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 7
            {coords = vector4(-320.3400, -142.1119, 40.0951, 157.5866), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 8
        },

        Xray = {
            {
                bedcoords = vector4(-337.3838, -104.8620, 38.5021, 69.0794),
                screencoords = vector3(-339.39, -100.21, 38.59),
                screenrotation = vector3(0.0, 0.0, -109.3),
                screenscale = 0.067,
                screenProp = "v_res_lest_monitor",
                taken = false,
            },
        },

        IncomingScreenPos = {
            {
                coords = vector3(-314.30, -149.61, 43.44),
                rotation = vector3(0.0, 0.0, 23.8),
            },
        },

        IncomingScreenSoundPos = {
            vector3(-314.8719, -150.1792, 41.2665),
        },

        StationaryECG = {}, -- Unlimited monitors supported

        -- Following actions only support integration for default esx
        boss = {},
        cloakroom = {
            vector3(-344.0894, -160.0056, 38.9464),
            vector3(-341.5859, -150.6040, 39.0560),
        },
    },

    {
        label = "Paleto Hospital",
        blip = {
            enable = true,
            icon = 61,
            color = 6,
            scale = 0.8,
            coords = vector3(-250.86, 6313.62, 32.43), -- TODO: placeholder (pharmacy position), raycast a proper spot
        },
        checking = {
            vector4(-253.05, 6324.81, 32.45, 215.52)
        },
        duty = {
            vector4(-255.76, 6332.22, 32.45, 38.03)
        },
        helicopter = {

        },
        shop = {
            vector3(-257.9102, 6338.9126, 32.4071),
        },
        elevator = {

        },
        stash = {
            vector3(-263.0877, 6343.9976, 32.6824),
        },
        bloodstorage = {

        },
        donation = {

        },
        bloodanalysis = {

        },
        pharmacy = {
            vector4(-267.9306, 6318.0181, 32.4452, 229.8135),
        },
        beds = {

        },
        Xray = {

        },
        IncomingScreenPos = {

        },
        IncomingScreenSoundPos = {

        },
        StationaryECG = {
            
        },

        -- Following actions only support integration for default esx
        boss = {},
        cloakroom = {
            vector3(-265.3901, 6343.8438, 32.6363),
        },
    },
}

Config.JailBeds = {
    {coords = vector4(1761.96, 2597.74, 45.66, 270.14), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
    {coords = vector4(1761.96, 2591.51, 45.66, 269.8), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
    {coords = vector4(1771.8, 2598.02, 45.66, 89.05), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
    {coords = vector4(1771.85, 2591.8501, 45.66, 91.51), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
}