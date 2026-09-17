Config = Config or {}

-- INCOMINNG INFORMATION SCREENS CONFIGURATION (ER SCREENS)
Config.ScreenProp = 'xm_prop_x17_tv_ceiling_01' -- The prop used for the screen

Config.IncomingRenderDistance = 70 -- The rendering distance of an incoming screen, recommended to keep above 30 to avoid sync issues.

Config.IncomingScreenSoundRange = 50

-- STATIONARY ECG CONFIGURATION (ICU SCREENS)
Config.StationaryECGProp = 'v_med_cor_ceilingmonitor' -- The prop used for the stationary ECG

Config.Hospitals = {
    {
        label = "MHS Pillbox",
        blip = {
            enable = true,
            icon = 61,
            color = 25,
            scale = 0.8,
            coords = vector3(305.8421, -587.4172, 42.2841),
        },
        checking = {
            vector4(311.5817, -594.0681, 43.3602, 333.727),
        },

        duty = {
            vector3(310.3887, -597.3732, 43.2976),
        },

        vehicle = {
            vector4(294.707, -607.2061, 43.0078, 68.8774),
            vector4(331.9502, -579.1585, 28.5665, 339.8551),
        },

        helicopter = {
            vector4(351.58, -587.45, 74.2, 160.5),
        },

        shop = {
            vector3(311.791, -564.0659, 43.2841),
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
            vector3(308.5978, -562.2446, 43.5902),
        },

        bloodstorage = {
            vector3(310.1, -569.426, 43.53),
        },

        donation = {
            {
                coords = vector4(353.7715, -596.6701, 43.3237, 332.0782),
                getOutOffset = 0.8,
                model = "",
            },
        },

        bloodanalysis = { -- station to analyze blood sample
            vector3(310.1265, -589.2836, 43.4048),
        },

        pharmacy = {
            vector4(308.3599, -595.5425, 43.2841, 75.0),
        },

        beds = {
            {coords = vector4(319.3285, -581.0463, 43.204, 155.2395), taken = false, model = "v_med_bed1", getOutOffset = 1.3, lockedBed = true}, -- You can add the lockedBed = true variable to any bed you'd like to be locked from be used as a checkin bed (eg for surgery)
            {coords = vector4(324.1608, -582.8101, 43.204, 157.6627), taken = false, model = "v_med_bed1", getOutOffset = 1.3}, -- This is a normal bed, and is how most of your beds should look like. 
            {coords = vector4(322.6, -586.9601, 43.204, 340.9906), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(317.6, -585.3027, 43.204, 340.0982), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(314.5, -584.0378, 43.204, 340.4092), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(311.0, -582.7598, 43.204, 340.4864), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(307.8, -581.4847, 43.204, 340.6982), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(309.1634, -577.5354, 43.204, 157.5351), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(313.8121, -579.1085, 43.204, 157.746), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(-247.04, 6317.9502, 32.34, 134.64), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
            {coords = vector4(-255.98, 6315.6699, 32.34, 313.91), taken = false, model = "v_med_bed1", getOutOffset = 1.3},
        },

        Xray = {
            {
                bedcoords = vector4(348.7, -579.4, 43.1971, 157.0),
                screencoords = vector3(345.0926, -576.9894, 43.6041),
                screenrotation = vector3(0.0, 0.0, -65.196),
                screenscale = 0.067,
                screenProp = "v_res_lest_monitor",
                taken = false,
                model = "v_med_bed1",
                getOutOffset = 1.3,
            },
        },

        IncomingScreenPos = {
            {
                coords = vector3(327.4461, -577.2789, 45.7839),
                rotation = vector3(0.0, 0.0, 25.8079),
            },
            {
                coords = vector3(313.6346, -593.3488, 45.7839),
                rotation = vector3(0.0, 0.0, -148.4772),
            },
        },

        IncomingScreenSoundPos = {
            vector3(309.2776, -589.0244, 45.1519),
            vector3(329.5522, -579.1614, 44.6322),
        },

        StationaryECG = { -- Unlimited monitors supported
            {
                screen = {
                    coords = vector3(318.8376, -579.6915, 45.7846),
                    rotation = vector3(0.0, 0.0, -20.0),
                },
                bed = {
                    coords = vector3(319.2666, -581.1186, 44.204),
                },
                name = "ICU 1"
            },
            {
                screen = {
                    coords = vector3(323.7489, -581.5202, 45.8),
                    rotation = vector3(0.0, 0.0, -20.0),
                },
                bed = {
                    coords = vector3(324.2232, -583.0401, 44.204),
                },
                name = "ICU 2"
            },
            {
                screen = {
                    coords = vector3(321.3699, -587.7664, 45.8),
                    rotation = vector3(0.0, 0.0, 160.0),
                },
                bed = {
                    coords = vector3(322.6256, -586.7698, 44.213),
                },
                name = "ICU 3"
            },
            {
                screen = {
                    coords = vector3(316.4125, -586.0515, 45.8),
                    rotation = vector3(0.0, 0.0, 160.0),
                },
                bed = {
                    coords = vector3(317.5998, -585.4157, 44.204),
                },
                name = "ICU 4"
            },
            {
                screen = {
                    coords = vector3(313.1407, -584.6058, 45.8),
                    rotation = vector3(0.0, 0.0, 160.0),
                },
                bed = {
                    coords = vector3(314.5409, -583.9615, 44.204),
                },
                name = "ICU 5"
            },
            {
                screen = {
                    coords = vector3(309.6808, -583.5556, 45.8),
                    rotation = vector3(0.0, 0.0, 160.0),
                },
                bed = {
                    coords = vector3(311.2327, -582.8145, 44.204),
                },
                name = "ICU 6"
            },
            {
                screen = {
                    coords = vector3(308.3385, -582.8965, 45.8),
                    rotation = vector3(0.0, 0.0, 160.0),
                },
                bed = {
                    coords = vector3(307.7694, -581.361, 44.2049),
                },
                name = "ICU 7"
            },
            {
                screen = {
                    coords = vector3(310.475, -576.9198, 45.8),
                    rotation = vector3(0.0, 0.0, -20.0),
                },
                bed = {
                    coords = vector3(309.2775, -577.711, 44.2044),
                },
                name = "ICU 8"
            },
            {
                screen = {
                    coords = vector3(315.0273, -578.4716, 45.8),
                    rotation = vector3(0.0, 0.0, -20.0),
                },
                bed = {
                    coords = vector3(313.8342, -579.3513, 44.204),
                },
                name = "ICU 9"
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
