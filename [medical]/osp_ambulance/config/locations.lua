Config = Config or {}

-- INCOMINNG INFORMATION SCREENS CONFIGURATION (ER SCREENS)
Config.ScreenProp = 'xm_prop_x17_tv_ceiling_01' -- The prop used for the screen

Config.IncomingRenderDistance = 70 -- The rendering distance of an incoming screen, recommended to keep above 30 to avoid sync issues.

Config.IncomingScreenSoundRange = 50

-- STATIONARY ECG CONFIGURATION (ICU SCREENS)
Config.StationaryECGProp = 'v_med_cor_ceilingmonitor' -- The prop used for the stationary ECG

Config.Hospitals = {
    {
        label = "Hospital",
        blip = {
            enable = true,
            icon = 61,
            color = 6,
            scale = 0.8,
            coords = vector3(-930.1700, -763.8700, 18.0200),
        },
        checking = {
            vector4(-314.17, -151.57, 40.24, 199.47),
            vector4(-312.62, -150.78, 40.24, 201.33),
        },

        duty = {
            vector3(-892.02, -725.89, 18.05),
            vector3(-929.53, -750.99, 18.05),
        },

        helicopter = {
            vector4(351.58, -587.45, 74.2, 160.5),
        },

        shop = {
            vector3(-923.1270, -712.1659, 18.3604), --DONE
            vector3(-945.0648, -711.7737, 18.14355), --DONE
            vector3(-951.9423, -707.9423, 18.4991), --DONE
            vector3(-915.3173, -734.7429, 18.4174), --DONE
            vector3(-897.9966, -729.9738, 18.4488), --DONE
            vector3(-901.5538, -728.8372, 24.6676), --DONE
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
            vector3(-935.4985, -705.4145, 18.3078), --Done --Archive Top Floor
        },

        bloodstorage = {
            vector3(-946.8049, -710.0671, 18.4323), --Done
        },

        donation = {
            {
                coords = vector4(-948.4269, -713.9419, 18.2327, 143.1327), --Done
                getOutOffset = 0.8,
                model = "",
            },
        },

        bloodanalysis = { -- station to analyze blood sample
            vector3(-946.7814, -712.6233, 18.3763), --Done
        },

        pharmacy = {
            vector4(-942.1526, -746.0865, 18.0503, 175.6100), --DONE
        },

        beds = {
            {coords = vector4(-911.33, -725.44, 18.10, 181.79), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 1 -ICU
            {coords = vector4(-907.37, -725.08, 18.10, 179.94), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 2 -ICU
            {coords = vector4(-903.35, -725.43, 18.10, 184.41), taken = false, model = "v_med_bed1"}, --Bed 4 -ICU
            {coords = vector4(-905.85, -735.19, 18.10, 359.11), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, --Bed 5 -ICU
            {coords = vector4(-926.05, -712.41, 18.10, 179.88), taken = false, model = "v_med_bed1", getOutOffset = 1.3, lockedBed = true}, --Surgery Bed
            {coords = vector4(-941.97, -712.44, 18.10, 178.35), taken = false, model = "v_med_bed1", getOutOffset = 1.3, lockedBed = true}, -- Surgery Bed
        },

        Xray = {
            {
                bedcoords = vector4(-960.3412, -733.7281, 17.9903, 367.1914), --Done
                screencoords = vector3(-956.31, -732.51, 18.10),
                screenrotation = vector3(0.0, 0.0, 71.6),
                screenscale = 0.067,
                screenProp = "v_res_lest_monitor",
                taken = false,
            },
        },

        IncomingScreenPos = {
            {
                coords = vector3(-915.50, -751.97, 21.50),
                rotation = vector3(0.0, 0.0, 290.0),
            },
            {
                coords = vector3(-899.45, -743.18, 21.40), --Garage Screen
                rotation = vector3(0.0, 0.0, 88.6),
            },
        },

        IncomingScreenSoundPos = {
            vector3(-915.50, -751.97, 21.50),
            vector3(-899.45, -743.18, 21.40),
        },

        StationaryECG = { -- Unlimited monitors supported
            {
                screen = {
                    coords = vector3(-909.89, -724.04, 20.51),
                    rotation = vector3(0.0, 0.0, 0.3),
                },
                bed = {
                    coords = vector3(-911.1840,-725.3710,17.9498),
                },
                name = "ICU 1"
            },
            {
                screen = {
                    coords = vector3(-906.30, -724.00, 20.52),
                    rotation = vector3(0.0, 0.0, -11.5),
                },
                bed = {
                    coords = vector3(-907.3382, -725.6155, 17.9300),
                },
                name = "ICU 2"
            },
            {
                screen = {
                    coords = vector3(-902.36, -724.02, 20.45),
                    rotation = vector3(0.0, 0.0, -10.5),
                },
                bed = {
                    coords = vector3(-903.3923, -725.5912, 17.9152),
                },
                name = "ICU 3"
            },
            {
                screen = {
                    coords = vector3(-903.10, -736.41, 20.52),
                    rotation = vector3(0.0, 0.0, 168.2),
                },
                bed = {
                    coords = vector3(-902.3159, -734.9402, 17.9560),
                },
                name = "ICU 4"
            },
        },

        -- Following actions only support integration for default esx
        boss = {},
        cloakroom = {},
    },
}

Config.JailBeds = {
    {coords = vector4(1761.96, 2597.74, 45.66, 270.14), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
    {coords = vector4(1761.96, 2591.51, 45.66, 269.8), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
    {coords = vector4(1771.8, 2598.02, 45.66, 89.05), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
    {coords = vector4(1771.85, 2591.8501, 45.66, 91.51), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
}