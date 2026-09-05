--[[
           _   _ _   _  ____   _____
     /\   | \ | | \ | |/ __ \ / ____|
    /  \  |  \| |  \| | |  | | (___
   / /\ \ | . ` | . ` | |  | |\___ \
  / ____ \| |\  | |\  | |__| |____) |
 /_/    \_\_| \_|_| \_|\____/|_____/


--]]
---@class audioConfig
---@field audioName string
---@field audioRef? string the audioBank to use, if for example you use custom serverside sirens

---@class SirenConfigTable
---@field sirenModes table<number, audioConfig> the key is the siren mode
---@field horn? audioConfig

---@class ParkPatternConfig
---@field extra number the main extra to enable when parked
---@field linkextras? number[] additional extras to enable when parked
---@field offextras? number[] extras to hide when parked

---@class ElsExtraConfig
---@field Color string color name from GlobalSettings.Colors
---@field Environments boolean true = cast a DrawSpotLight onto the environment, false = extra flashes but no spotlight
---@field Offset {x: number, y: number, z: number} world offset for the light source
---@field Direction? {x: number, y: number, z: number} vehicle-relative spotlight direction vector (default {0,0,-1} = straight down)
---@field Range number distance the light reaches
---@field Intensity number base brightness of the light
---@field BPM? number (legacy single-stage format only) beats per minute
---@field Sequencer? number (legacy single-stage format only) decimal 32-bit binary flash pattern

---@class ElsStageExtraConfig
---@field BPM number beats per minute controlling flash speed for this stage
---@field Sequencer number decimal representation of 32-bit binary flash pattern for this stage

---@class ElsConfig
---@field Extras table<number, ElsExtraConfig> keyed by extra ID — visual/spatial properties
---@field Stages? table<number, table<number, ElsStageExtraConfig>> per-stage pattern definitions (omit for single-stage legacy format)
---@field ParkPattern? table<number, table<number, ElsStageExtraConfig>> per-stage park flash patterns: ParkPattern[stage][extraId]
---@field ParkPatternOff? table<number, table<number, number>> per-stage extras to turn OFF when parked: ParkPatternOff[stage] = { extraId, ... }
---@field Takedowns? table<number, number> list of extra IDs for takedown/alley lights, toggled independently with H key (steady-on)

---@class SoundEffectsConfig
---@field use boolean master toggle for NUI sound effects
---@field sync boolean true = nearby players also hear SFX via state bags | false = only the controlling player
---@field on_volume number volume for lights-on sound (0.0-1.0)
---@field off_volume number volume for lights-off sound (0.0-1.0)
---@field upgrade_volume number volume for stage/siren upgrade sound (0.0-1.0)
---@field downgrade_volume number volume for stage/siren downgrade sound (0.0-1.0)
---@field hazards_volume number volume for park pattern toggle sound (0.0-1.0)
---@field lock_volume number volume for horn press/release sound (0.0-1.0)
---@field reminder_volume number volume for reminder sound (0.0-1.0)

---@class VehicleConfig : SirenConfigTable, ParkPatternConfig
---@field Els? ElsConfig ELS lighting configuration (omit for non-ELS vehicles)
---@field scenesync? boolean true = sync flash patterns with other scenesync vehicles via shared clock


--[[
   _____ ____  _   _ ______ _____ _____
  / ____/ __ \| \ | |  ____|_   _/ ____|
 | |   | |  | |  \| | |__    | || |  __
 | |   | |  | | . ` |  __|   | || | |_ |
 | |___| |__| | |\  | |     _| || |__| |
  \_____\____/|_| \_|_|    |_____\_____|


--]]
return {

    --[[
   _____  ______ _____  __  __ _____  _____ _____ _____ ____  _   _  _____
  |  __ \|  ____|  __ \|  \/  |_   _|/ ____/ ____|_   _/ __ \| \ | |/ ____|
  | |__) | |__  | |__) | \  / | | | | (___| (___   | || |  | |  \| | (___
  |  ___/|  __| |  _  /| |\/| | | |  \___ \\___ \  | || |  | | . ` |\___ \
  | |    | |____| | \ \| |  | |_| |_ ____) |___) |_| || |__| | |\  |____) |
  |_|    |______|_|  \_\_|  |_|_____|_____/_____/|_____\____/|_| \_|_____/

    Permission gates.
    replace the isEnabled() body with your own framework logic
    (QBCore job check, ESX grade, ace perms, etc.).
--]]

    Perms = {
        usematrix = {
            name = 'usematrix',
            isEnabled = function()
                return true
            end,
        },
        useelssetup = {
            name = 'useelssetup',
            isEnabled = function()
                return true
            end,
        },
    },
    --[[
   _____ _      ____  ____          _
  / ____| |    / __ \|  _ \   /\   | |
 | |  __| |   | |  | | |_) | /  \  | |
 | | |_ | |   | |  | |  _ < / /\ \ | |
 | |__| | |___| |__| | |_) / ____ \| |____
  \_____|______\____/|____/_/    \_\______|

GlobalSettings
These are the default/fallback settings that apply to ALL emergency vehicles
unless overridden in VehiclesSettings below.

--]]

    AudioBanks = {
        'DLC_WMSIRENS\\SIRENPACK_ONE',
    },

    GlobalSettings = {

        -- Key Binds
        controls = {
            policeLights     = 'Q',     -- Cycles light stages
            policeHorn       = 'E',     -- Hold to sound the horn
            sirenToggle      = 'LMENU', -- Toggles siren on/off while lights are active (Left Alt)
            sirenCycle       = 'R',     -- Hold to activate siren, press again while held to cycle modes (1->2->3), releases to off
            takedown         = 'H',     -- Toggle takedown/alley lights on ELS vehicles (steady-on extras)
            driverMenu       = 'F5',    -- Opens the driver preferences menu
            matrixMenu       = 'F6',    -- Opens the matrix board text input menu
            matrixTextToggle = 'K',     -- Toggle matrix board text on/off (prop stays, text blanks)
        },

        ---  ELS Lighting Settings  ---
        DebugMode = true,                      -- Set to false in production. When true: ELS debug tool (/elsdebug) enabled; any client can export/save config.
        DayTimeIntensityMultiplier = 5.0,      -- Spotlight intensity multiplier during daytime (peaks at noon)
        NightTimeIntensityMultiplier = 5.0,    -- Spotlight intensity multiplier at night (00:00-05:00, 20:00-24:00)
        MaximumAmountOfVehiclesWithLights = 5, -- Max number of nearby ELS vehicles that render spotlights (closest N). nil = unlimited
        MaxRenderDistance = 100.0,             -- Max distance (in metres) to render DrawSpotLight for ELS vehicles. Vehicles beyond this skip spotlight rendering. nil = unlimited
        KeepEngineRunning = true,              -- Keep the engine on when exiting a vehicle with active lights (required for extras to work correctly)

        -- Siren Behaviour
        sirenShutOff = true,         -- true = siren automatically turns off when exiting the vehicle
        disableDamagedSirens = true, -- true = never play the broken siren sound | false = play it when vehicle health is below damageThreshold
        useEngineHealth = true,      -- false = use body health for damage check | true = use engine health instead
        damageThreshold = 300,       -- Health value (0-1000) below which the vehicle is considered damaged

        -- Park Pattern Settings
        -- Park patterns automatically toggle vehicle extras when the vehicle comes to a stop with lights on.
        -- Vehicles must have automaticpark defined in VehiclesSettings below to use this feature.
        enabled = true,      -- Master toggle: true = park patterns active | false = disabled entirely
        speedThreshold = 1,  -- Speed (MPH) below which the vehicle is considered "parked"
        checkInterval = 500, -- How often (ms) to check vehicle speed for park state. Minimum 500. Higher = less CPU, slower response
        debounceTime = 1000, -- How long (ms) the vehicle must stay stopped before park pattern activates. Prevents flickering at traffic lights

        -- Auto Siren Modes
        autoSiren = {
            enabled = true,
            enableIntersectionMode = true, -- true = allow automatic yelp when exceeding intersectionSpeed
            enablePursuitMode = true,      -- true = allow automatic priority siren when exceeding pursuitSpeed
            intersectionSpeed = 60,        -- MPH above which intersection mode activates
            intersectionExitSpeed = 50,    -- MPH below which intersection mode deactivates (hysteresis gap prevents flickering)
            intersectionSirenMode = 2,     -- Siren mode to use for intersection (default 2 = Yelp)
            pursuitSpeed = 80,             -- MPH above which pursuit mode activates (overrides intersection)
            pursuitExitSpeed = 70,         -- MPH below which pursuit mode deactivates
            pursuitSirenMode = 3,          -- Siren mode to use for pursuit (default 3 = Priority)
            debounceTime = 1500,           -- ms speed must stay above/below threshold before switching
            checkInterval = 500,           -- ms between speed checks. Higher = less CPU, slower response
        },

        -- Controller HUD
        controllerHud = {
            scale = 0.75,
            rightOffset = 20,
            verticalPosition = 50,
        },

        -- Sound Effects
        ---@type SoundEffectsConfig
        soundeffects = {
            use = true,
            sync = true,
            on_volume = 0.5,
            off_volume = 0.7,
            upgrade_volume = 0.5,
            downgrade_volume = 0.7,
            hazards_volume = 0.09,
            lock_volume = 0.25,
            reminder_volume = 0.09,
        },

        -- Driver Preferences
        driverPreferences = {
            enabled             = true,
            autoSiren           = true,
            soundEffects        = true,
            parkPattern         = true,
            sirenShutOff        = true,
            keepEngineRunning   = true,
            scenesync           = true,
            environmentLighting = true, -- Allow driver to toggle we recommend leaving this true
            controller          = true,
        },

        ---@type SirenConfigTable
        -- Siren & Horn Sounds
        {
            sirenModes = {
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, -- Siren mode 1
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, -- Siren mode 2
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, -- Siren mode 3
            },

            horn       = {
                audioName = 'SIREN_ALPHA',
                audioRef = "DLC_WMSIRENS_SOUNDSET",
            },
        },

        --[[{--DEFAULT SIREN SOUNDS (GTA)
            sirenModes = {
                { audioName = 'VEHICLES_HORNS_SIREN_1' },        -- Siren mode 1 (Wail)
                { audioName = 'VEHICLES_HORNS_SIREN_2' },        -- Siren mode 2 (Yelp)
                { audioName = 'VEHICLES_HORNS_POLICE_WARNING' }, -- Siren mode 3 (Priority)
            },

            horn = {
                audioName = 'SIRENS_AIRHORN' -- Default horn sound
            }
        },--]]


        -- ELS Environment Light Colors
        Colors = {
            ['blue']  = { r = 0, g = 0, b = 255 },
            ['red']   = { r = 255, g = 0, b = 0 },
            ['amber'] = { r = 255, g = 100, b = 0 },
            ['green'] = { r = 0, g = 255, b = 0 },
            ['white'] = { r = 255, g = 255, b = 255 },
        },

        -- 32-bit decimal Pattern Presets
        PatternPresets = {
            ['Steady Burn']    = 4294967295,
            ['Off']            = 0,
            ['Alternating A']  = 2863311530,
            ['Alternating B']  = 1431655765,
            ['Wig-Wag A']      = 4042322160,
            ['Wig-Wag B']      = 252645135,
            ['Fast Wig-Wag A'] = 3435973836,
            ['Fast Wig-Wag B'] = 858993459,
            ['Double Flash A'] = 3233218560,
            ['Double Flash B'] = 1061158911,
            ['Triple Flash A'] = 3773292544,
            ['Triple Flash B'] = 521805823,
            ['Quad Flash A']   = 4042260480,
            ['Quad Flash B']   = 252706815,
            ['Single Pulse A'] = 2147483648,
            ['Single Pulse B'] = 2147483647,
            ['Strobe A']       = 2290649224,
            ['Strobe B']       = 2004318071,
            ['Fast Strobe A']  = 4008636142,
            ['Fast Strobe B']  = 286331153,
            ['Slow Flash A']   = 4294901760,
            ['Slow Flash B']   = 65535,
            ['Beacon A']       = 4278190080,
            ['Beacon B']       = 16777215,
            ['March A']        = 4261412864,
            ['March B']        = 33554431,
            ['Chase Left']     = 4177461248,
            ['Chase Right']    = 521142272,
        },

        -- Matrix board
        MatrixBoardEnabled = true,
        MatrixBoardEmergencyClassOnly = true,
        MatrixBoardDefaultText = 'POLICE',

        -- Used when no entry exists in matrix_presets.json for that vehicle model key yet (leave this)
        MatrixBoardAttachDefaults = {
            attachBone = 0,
            attachOffset = { x = 0.0, y = 0.0, z = 0.0 },
            attachRotation = { x = 0.0, y = 0.0, z = 0.0 },
        },

        -- Vehicle bones for matrix board attachment
        MatrixVehicleBones = {
            { id = 'chassis',   label = 'Chassis' },
            { id = 'bodyshell', label = 'Body' },
            { id = 'bumper_f',  label = 'Front bumper' },
            { id = 'bumper_r',  label = 'Rear bumper' },
            { id = 'bonnet',    label = 'Bonnet (hood)' },
            { id = 'boot',      label = 'Boot (trunk)' },
            { id = 'roof',      label = 'Roof' },
            { id = 'roof2',     label = 'Roof 2' },
        },

        -- Matrix board render optimization
        MatrixMaxRenderDistance = 100.0,
        MatrixMaximumAmountOfVehicles = 20,
        MatrixDisableCustomMessages = false, -- true = drivers can only select preset messages, no custom text
        MatrixMessagePresets = {
            ['Standard Police'] = {
                'POLICE STOP',
                'STOP POLICE',
                'FOLLOW ME',
                'DO NOT PASS',
                'KEEP BACK',
                'STAY BACK',
                'SLOW DOWN',
                'MOVE OVER',
                'PULL OVER NOW',
            },
            ['Urgent / Enforcement'] = {
                'STOP IMMEDIATELY',
                'PULL OVER – LEFT',
                'PULL OVER – RIGHT',
                'REMAIN IN VEHICLE',
                'TURN ENGINE OFF',
                'WAIT FOR OFFICER',
                'DO NOT MOVE',
            },
            ['Traffic Control'] = {
                'ROAD CLOSED',
                'LANE CLOSED',
                'MERGE LEFT',
                'MERGE RIGHT',
                'USE OTHER LANE',
                'TRAFFIC AHEAD',
                'ACCIDENT AHEAD',
                'EXPECT DELAYS',
            },
            ['Safety / Advisory'] = {
                'KEEP YOUR DISTANCE',
                'MAINTAIN SAFE DISTANCE',
                'HAZARD AHEAD',
                'ICY ROAD',
                'SLOW CONDITIONS',
                'CHECK SPEED',
            },
            ['Pursuit / High-Speed'] = {
                'STOP POLICE PURSUIT',
                'PURSUIT IN PROGRESS',
                'DO NOT INTERFERE',
                'CLEAR THE ROAD',
                'YIELD TO POLICE',
            },
        },


        -- Matrix prop pool
        MatrixPropPool = {
            { model = 'prop_sm_i1',  origTxd = 'prop_sm_i1',  name = 'Matrix Board 1',  width = 2048, height = 480 },
            { model = 'prop_sm_i2',  origTxd = 'prop_sm_i2',  name = 'Matrix Board 2',  width = 2048, height = 480 },
            { model = 'prop_sm_i3',  origTxd = 'prop_sm_i3',  name = 'Matrix Board 3',  width = 2048, height = 480 },
            { model = 'prop_sm_i4',  origTxd = 'prop_sm_i4',  name = 'Matrix Board 4',  width = 2048, height = 480 },
            { model = 'prop_sm_i5',  origTxd = 'prop_sm_i5',  name = 'Matrix Board 5',  width = 2048, height = 480 },
            { model = 'prop_sm_i6',  origTxd = 'prop_sm_i6',  name = 'Matrix Board 6',  width = 2048, height = 480 },
            { model = 'prop_sm_i7',  origTxd = 'prop_sm_i7',  name = 'Matrix Board 7',  width = 2048, height = 480 },
            { model = 'prop_sm_i8',  origTxd = 'prop_sm_i8',  name = 'Matrix Board 8',  width = 2048, height = 480 },
            { model = 'prop_sm_i9',  origTxd = 'prop_sm_i9',  name = 'Matrix Board 9',  width = 2048, height = 480 },
            { model = 'prop_sm_i10', origTxd = 'prop_sm_i10', name = 'Matrix Board 10', width = 2048, height = 480 },
            { model = 'prop_sm_i11', origTxd = 'prop_sm_i11', name = 'Matrix Board 11', width = 2048, height = 480 },
            { model = 'prop_sm_i12', origTxd = 'prop_sm_i12', name = 'Matrix Board 12', width = 2048, height = 480 },
            { model = 'prop_sm_i13', origTxd = 'prop_sm_i13', name = 'Matrix Board 13', width = 2048, height = 480 },
            { model = 'prop_sm_i14', origTxd = 'prop_sm_i14', name = 'Matrix Board 14', width = 2048, height = 480 },
            { model = 'prop_sm_i15', origTxd = 'prop_sm_i15', name = 'Matrix Board 15', width = 2048, height = 480 },
            { model = 'prop_sm_i16', origTxd = 'prop_sm_i16', name = 'Matrix Board 16', width = 2048, height = 480 },
            { model = 'prop_sm_i17', origTxd = 'prop_sm_i17', name = 'Matrix Board 17', width = 2048, height = 480 },
            { model = 'prop_sm_i18', origTxd = 'prop_sm_i18', name = 'Matrix Board 18', width = 2048, height = 480 },
            { model = 'prop_sm_i19', origTxd = 'prop_sm_i19', name = 'Matrix Board 19', width = 2048, height = 480 },
            { model = 'prop_sm_i20', origTxd = 'prop_sm_i20', name = 'Matrix Board 20', width = 2048, height = 480 },
        },

    },


    --[[
 __      ________ _    _ _____ _____ _      ______
 \ \    / /  ____| |  | |_   _/ ____| |    |  ____|
  \ \  / /| |__  | |__| | | || |    | |    | |__
   \ \/ / |  __| |  __  | | || |    | |    |  __|
    \  /  | |____| |  | |_| || |____| |____| |____
     \/   |______|_|  |_|_____\_____|______|______|


--]]

    ---@type table<number, VehicleConfig>
    VehiclesSettings = {

        -- Non-ELS vehicle example with Stages, Park Patterns and Takedowns

        [`l90rpd`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 9, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 9, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 2, linkextras = { 3,4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`vx90rpd`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 9, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 9, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 2, linkextras = { 3,4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`e90rpd`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 9, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 9, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 2, linkextras = { 3,4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },

        [`l90rmk`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`l90rmd`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`l90rhw`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`l90rum`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 5, linkextras = { 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },

        [`e90rmk`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`e90rmd`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`e90rhw`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`e90rum`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 5, linkextras = { 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },

        [`vx90rhw`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`vx90rmk`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`vx90rmd`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 3, linkextras = { 4, 5, 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },
        [`vx90rum`] = {

            sirenModes    = {                                                        --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn          = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            automaticpark = { extra = 2, linkextras = {}, offextras = {} },  -- extras to turn on when parked automatically (for non els siren nodes must be placed in an extra heirarchy in zmodler or blender)

            takedowns     = { extra = 10, linkextras = {}, offextras = {} }, -- extras to turn on when key pressed H (takwdown must be set up as an extra  in zmodler or blender

            Stages        = {                                                --
                [1] = {
                    extra = 2, linkextras = {}, offextras = {},              -- 1 → At Scene
                },
                [2] = {
                    extra = 4, linkextras = { 6 }, offextras = {}, -- 2 → Urgent
                },
                [3] = {
                    extra = 5, linkextras = { 6, 7, 8 }, offextras = {}, -- 3 → 999 MODE Full emergency
                },
            },

        },

        -- ELS vehicle example
        [`smspenisula`] = {

            sirenModes = {                                                           --addon siren sounds vehicle specific
                { audioName = 'SIREN_CHARLIE', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --Primary // dlc bank name
                { audioName = 'SIREN_DELTA',   audioRef = "DLC_WMSIRENS_SOUNDSET" }, --yelp // dlc bank name
                { audioName = 'SIREN_FOXTROT', audioRef = "DLC_WMSIRENS_SOUNDSET" }, --wail // dlc bank name
            },

            horn       = {
                audioName = 'SIREN_ALPHA', audioRef = "DLC_WMSIRENS_SOUNDSET", -- horn sound // dlc bank name
            },

            scenesync  = true, -- sync flash patterns with other scenesync vehicles via shared clock

            -- ELS configuration
            Els        = {
                -- Extras: visual/spatial properties per extra (defined once, shared across all stages) create this via elsdebug tool for easy work flow
                Extras = {
                    [1] = { Color = 'blue', Environments = true, Offset = { x = -0.360, y = -0.330, z = 1.330 }, Direction = { x = -5.000, y = -5.000, z = -1.000 }, Range = 50.5, Intensity = 0.1020 },
                    [2] = { Color = 'blue', Environments = true, Offset = { x = -0.360, y = -0.330, z = 1.330 }, Direction = { x = -5.000, y = 10.000, z = -1.000 }, Range = 50.5, Intensity = 0.1020 },
                    [3] = { Color = 'blue', Environments = true, Offset = { x = 0.360, y = -0.330, z = 1.330 }, Direction = { x = 5.000, y = 10.000, z = -1.000 }, Range = 50.5, Intensity = 0.1020 },
                    [4] = { Color = 'blue', Environments = true, Offset = { x = 0.360, y = -0.330, z = 1.330 }, Direction = { x = 5.000, y = -5.000, z = -1.000 }, Range = 50.5, Intensity = 0.1020 },
                    [5] = { Color = 'white', Environments = true, Offset = { x = -0.320, y = 2.190, z = 0.200 }, Direction = { x = 0.000, y = 10.000, z = -1.000 }, Range = 48.5, Intensity = 0.1330 },
                    [6] = { Color = 'white', Environments = true, Offset = { x = 0.320, y = 2.190, z = 0.200 }, Direction = { x = 0.000, y = 10.000, z = -1.000 }, Range = 48.5, Intensity = 0.1330 },
                    [7] = { Color = 'red', Environments = true, Offset = { x = 0.150, y = -0.450, z = 1.320 }, Direction = { x = 0.000, y = -10.000, z = -1.000 }, Range = 49.0, Intensity = 0.1270 },
                    [9] = { Color = 'red', Environments = true, Offset = { x = -0.150, y = -0.450, z = 1.320 }, Direction = { x = 0.000, y = -10.000, z = -1.000 }, Range = 49.0, Intensity = 0.1270 },
                    [11] = { Color = 'white', Environments = false, Offset = { x = 0.000, y = 0.000, z = 1.000 }, Direction = { x = 0.000, y = 0.000, z = -1.000 }, Range = 10.0, Intensity = 0.0500 },
                    [12] = { Color = 'white', Environments = true, Offset = { x = 0.000, y = -0.320, z = 1.320 }, Direction = { x = 0.000, y = 0.000, z = -1.000 }, Range = 100.0, Intensity = 0.1740 },
                },
                -- per-stage park flash patterns
                ParkPattern = {
                    [1] = { -- park pattern when stage 1 is active
                        [7] = { BPM = 100, Sequencer = 2863311530 },
                        [9] = { BPM = 100, Sequencer = 1431655765 },
                    },
                    [2] = { -- park pattern when stage 2 is active
                        [7] = { BPM = 500, Sequencer = 88166443 },
                        [9] = { BPM = 500, Sequencer = 2821327552 },
                    },
                    [3] = { -- park pattern when stage 3 is active
                        [7] = { BPM = 800, Sequencer = 88166443 },
                        [9] = { BPM = 800, Sequencer = 2821327552 },
                    },
                },

                ParkPatternOff = { -- per-stage extras to turn OFF when parked
                    [1] = {},      --add extras to turn off when parked in stage 1
                    [2] = {},      --add extras to turn off when parked in stage 2
                    [3] = {},      --add extras to turn off when parked in stage 3
                },

                Takedowns = { extra = 5, linkextras = { 6 }, offextras = {} }, --  -- Extra IDs that act as takedown/alley lights, toggled with H (steady-on)

                -- Stages: each stage defines which extras are active and their flash pattern
                Stages = {
                    [1] = { -- Stage 1
                        [7] = { BPM = 100, Sequencer = 2863311530 },
                        [9] = { BPM = 100, Sequencer = 1431655765 },
                    },
                    [2] = { -- Stage 2
                        [1] = { BPM = 500, Sequencer = 2821327552 },
                        [4] = { BPM = 500, Sequencer = 88166443 },
                        [5] = { BPM = 500, Sequencer = 2821327552 },
                        [6] = { BPM = 500, Sequencer = 88166443 },
                    },
                    [3] = { -- Stage 3
                        [1] = { BPM = 800, Sequencer = 2821327552 },
                        [2] = { BPM = 800, Sequencer = 2821327552 },
                        [3] = { BPM = 800, Sequencer = 88166443 },
                        [4] = { BPM = 800, Sequencer = 88166443 },
                        [5] = { BPM = 800, Sequencer = 2821327552 },
                        [6] = { BPM = 800, Sequencer = 88166443 },
                    },
                },
            },
        },
    },
}
