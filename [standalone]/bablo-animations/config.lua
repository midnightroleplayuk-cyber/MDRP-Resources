Config = Config or {}

Config.Debug = false      -- Enable debug mode

Config.Framework = 'auto' -- esx, qbcore, auto or standalone
Config.Locale = 'en'      -- add more locales in shared/locales
Config.Logs = false       -- Enable/disable discord webhook logs config in webhooks.lua

Config.OpenMenu = 'F4'    -- Open menu keybind or false to disable keymapping
Config.CancelEmote = 'X'  -- Cancel emote keybind or false to disable keymapping
Config.CloseMenuKeys = {  -- Usejavascript keys easy converter https://www.toptal.com/developers/keycode
    'Escape',
    'F4'
}

Config.EmoteCommand = 'e'                   -- Emote command
Config.OpenCommand = 'emotemenu'            -- Command to open emote menu or false to disable
Config.AnimAdjustCommand = 'animpos'        -- Command to adjust animations or false to disable
Config.AnimAdjustGizmo = true               -- 3D gizmo (press G in /animpos) to position the ped; false = arrow keys only
Config.AnimPosGizmoMaxRadius = 3.0          -- Max distance (metres) the /animpos gizmo can drag the ped from its start point
Config.EmoteCreatorCommand = 'emotecreator' -- Command to open shared emote creator tool or false to disable

-- Text UI system for help text, instructions, etc.
-- 'default' = built-in custom ui, no dependencies
-- 'ox_lib'  = ox_lib TextUI (requires ox_lib)
-- 'custom'  = Custom implementation (edit ShowTextUI/HideTextUI in shared/funcs.lua)
Config.Interaction = 'default'

-- Where the on-screen help bar (the key hint strip) is drawn
-- 'bottom-center' (default), 'top-center', 'left-center' or 'right-center'
-- The two side positions stack the key hints vertically instead of in a row
-- Anything else falls back to 'bottom-center'
Config.HelpBarPosition = 'bottom-center'

Config.DisarmPlayer = true              -- Disarm player when playing an animation

Config.EnablePlaceAnimation = true      -- Enable placing animations
Config.FreezeEntityOnPlace = true       -- Freeze entity when placing animations
Config.PlaceDistance = 20.0             -- Raycast distance for placing animations
Config.PlaceMaxHeight = 2.0             -- Max height for placing animations
Config.BlockAnimposAfterPlace = true    -- Block /animpos command after using place animation feature
Config.RestorePositionAfterPlace = true -- Move the player back to where they stood before a placed animation when they cancel it (stops place mode being used to clip through walls)
Config.DisablePhaseThruObjects = true   -- Block phasing through objects/doors during /animpos (true = can't phase through, false = can phase through)
Config.GroupMaxDistance = 5.0           -- Max distance for group members to sync animations
Config.Timeout = 2                      -- Timeout for animation requests in seconds

Config.CustomGunStyles = true           -- Enable custom gun styles
Config.DisableIdleCam = true            -- Disable idle camera when playing animations

Config.DisablePreviews = false          -- Disable emote previews in menu

Config.DisableKeybinds = false          -- Disable all keybinds
Config.DisableNumpadKeybinds = false    -- Disable numpad keys for animation keybinds
Config.EnableFreeLookToggle = true      -- Enable Alt key to toggle menu focus (free look)

Config.ServerSideSpawn = false          -- Spawn emote props on the server
Config.DisablePropCollision = false     -- Disable collision on spawned emote props

Config.CancelOnNewEmote = false         -- Cancel current emote when a new one is played

Config.EmoteWheel = true                -- Enable the favorite emote wheel
Config.AllowEmoteWheelInVehicle = false -- Allow opening emote wheel while in a vehicle

Config.EditDancesSpeed = true           -- Auto-enable speed control on all dance animations (uses animationOptions.editAnimSpeed)
Config.AnimMaxSpeed = 2.0               -- Max animation speed multiplier (default 1.0, min 0.1)
Config.AnimSpeedStep = 0.1              -- Speed change per key press

-- Supports Ox Target, Vivum Target, and QB Target. If you have more than one target system, it will use the first one it detects based on the order below.
Config.CopyAnimationTargetOption = true -- Enable "Copy Target's Animation Options" in emote menu when copying an animation from another playerSrc

Config.Music = {
    Enabled = true,    -- Enable music in animations
    MaxDistance = 5.0, -- Max distance for music to be heard
    MaxDuration = 180, -- Max duration (seconds) before auto-stopping music
}

-- Data here is used to either share saved data between characters or to save data for a specific character
Config.CharacterSpecific = {
    expression = true,
    walkingstyle = true,
    weaponstyle = true,
    favorites = true,
    keybinds = true,
}

-- Default Settings for menu
Config.DefaultSettings = {
    menuAlign = "LEFT",
    menuScale = 67,
    musicVolume = 50,
    showGifs = true,
    performanceMode = false,
    bigMenu = false,
    solidPrimary = false,
    emoteWheelKey = "",
    playTogetherButton = "MOUSE3", -- Mouse button that asks the closest player to play an emote with you: MOUSE3, MOUSE4, MOUSE5 or "" to disable
}

-- custom animations creators that are already configured enable said creator in the table below to use their animations
Config.Creators = {
    ["Pazeee_FreeFootBallEmote"] = true,
    ["Pazeee_VehicleFunnyEmote"] = false,
    ["Pazeee_CatUAI"] = false,
    ["Pazeee_CR7SIU"] = false,
    ["Pazeee_DonaldTrumpDance"] = false,
    ["Pazeee_FortnitePack_1"] = false,
    ["Pazeee_FunHide"] = false,
    ["Pazeee_GaramDanMaduDance"] = false,
    ["Pazeee_KawaikuteGomenDance"] = false,
    ["Pazeee_NewFortniteDancePackV2"] = false,
    ["Pazeee_PUBGDanceItsMyLife"] = false,
    ["Pazeee_PUBGHaidilaoDance"] = false,
    ["Pazeee_PUBGNastyGirl"] = false,
    ["Pazeee_SnowEmotePack"] = false,
    ["Pazeee_SquidGameRoundAndRound"] = false,
    ["Pazeee_WaitDance"] = false,
    ["Pazeee_PUBGMeninaDoJob"] = false,
    ["Pazeee_RatDance"] = false,
    ["Pazeee_TrashCanEmotePack"] = false,
    ["Pazeee_Dances"] = false,
    ["Pazeee_FortniteDancePackV4"] = false,
    ["Pazeee_CarryFunnyEmotePack"] = false,
    ["Pazeee_FortniteDancePackV5"] = false,
    ["Pazeee_FortniteDancePackV6"] = false,
    ["Pazeee_NewFortniteDancePackV3"] = false,
    ["Pazeee_SixFunnyEmotePack"] = false,
    ["Pazeee_NewRoleplayEmotePack"] = false,
    ["Pazeee_PunishmentFunnyEmotePack"] = false,
    ["Pazeee_DancePackV7"] = false,
    ["Pazeee_FlagEmotePack"] = false,
    ["Pazeee_SnowEmotePackV2"] = false,
    ["Pazeee_FireworkEmotePack"] = false,
    ["Pazeee_SadEmotePack"] = false,
}

Config.AnimationsBlacklistedInVehicles = {
    -- 'animation_name',  type animation name to blacklist it in vehicles
}

Config.AnimalPeds = {
    "a_c_poodle",
    "a_c_pug",
    "a_c_westy",
    "a_c_chop",
    "a_c_husky",
    "a_c_retriever",
    "a_c_shepherd",
    "a_c_rottweiler",
}

-- Enable or disable modules
Config.Modules = {
    ['Pointing'] = true,
    ['Handsup'] = true,
    ['Ragdoll'] = true,
    ['Crouch'] = true,
    ['Crawl'] = true,
    ['Holstering'] = false,
    ['IdleAnimations'] = false,
    ['DisableCombatRoll'] = false,
    ['DisableLeaning'] = false,
    ['SitAnyChair'] = false, -- Requires ox_target or qb-target
}

Config.Crouch = {
    ObjectClearance = true,
    CapsuleRadius = false,
}

Config.Climbing = {
    ReachDistance = 1.15,      -- Maximum horizontal distance from the player to the edge (metres)
    MinHorizontalSpeed = 0.45, -- Must be moving toward the edge
    MinTopOffset = -0.35,      -- Edge height relative to the airborne player's position
    MaxTopOffset = 2.15,
    ForwardAssist = 1.1,       -- Horizontal speed when requesting GTA's native climb
    UpwardAssist = 0.18,       -- Minimum upward speed for the grab
    Cooldown = 900,            -- Milliseconds between attempts, including failed native climbs
}

-- weapons that can be used with weapon styles
Config.Weapons = {
    "WEAPON_PISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_FLAREGUN",
    "WEAPON_STUNGUN",
    "WEAPON_REVOLVER",
    "WEAPON_DOUBLEACTION",
    "WEAPON_NAVYREVOLVER",
    "WEAPON_MINISMG",
    "WEAPON_MICROSMG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_TECPISTOL",
    "WEAPON_DBSHOTGUN",
}

Config.Categories = {
    {
        label = "Favorites",
        icon = "star",
        name = "favorites",
    },
    {
        label = "All",
        icon = "list",
        name = "all",
    },
    {
        label = "Emotes",
        icon = "person",
        name = "emotes",
        get = function()
            return Config.Emotes, true
        end
    },
    {
        label = "Props",
        icon = "person-carry-box",
        name = "props",
        get = function()
            return Config.Props, true
        end
    },
    {
        label = "Dances",
        icon = "hands",
        name = "dances",
        get = function()
            return Config.Dances, true
        end
    },
    {
        label = "In Vehicle",
        icon = "car",
        name = "vehicle",
        get = function()
            return Config.InVehicle, true
        end
    },
    {
        label = "Animal Emotes",
        icon = "dog",
        name = "animal",
        get = function()
            return Config.Animal, true
        end
    },
    {
        label = "Walking Styles",
        icon = "person-walking",
        name = "walkingstyles",
        type = "walkingstyle",
        get = function()
            return Config.Walks
        end
    },
    {
        label = "Expressions",
        icon = "face-smile",
        name = "expressions",
        type = "expression",
        get = function()
            return Config.Expressions
        end
    },
    {
        label = "Shared",
        icon = "people-pulling",
        name = "shared",
        type = "shared",
        get = function()
            return Config.Shared
        end
    },
    {
        label = "Gun Styles",
        icon = "person-rifle",
        name = "weaponstyles",
        type = "weaponstyles",
        get = function()
            return Config.WeaponStyles
        end
    },
    {
        label = "Sequences",
        icon = "arrows-repeat",
        name = "sequence",
        type = "sequence",
        get = function()
            return Config.Sequences
        end
    },
}

Config.placeableTypes = {
    'animation',
    'scenario'
}

Config.Groups = {
    -- ["example"] = function() -- client sided check
    --     local hasAccess = true

    --     return hasAccess
    -- end
}

Config.ScenarioModels = {
    `p_amb_coffeecup_01`,
    `p_amb_joint_01`,
    `p_cs_ciggy_01`,
    `p_cs_ciggy_01b_s`,
    `p_cs_clipboard`,
    `prop_curl_bar_01`,
    `p_cs_joint_01`,
    `p_cs_joint_02`,
    `prop_acc_guitar_01`,
    `prop_amb_ciggy_01`,
    `prop_amb_phone`,
    `prop_beggers_sign_01`,
    `prop_beggers_sign_02`,
    `prop_beggers_sign_03`,
    `prop_beggers_sign_04`,
    `prop_bongos_01`,
    `prop_cigar_01`,
    `prop_cigar_02`,
    `prop_cigar_03`,
    `prop_cs_beer_bot_40oz_02`,
    `prop_cs_paper_cup`,
    `prop_cs_trowel`,
    `prop_fib_clipboard`,
    `prop_fish_slice_01`,
    `prop_fishing_rod_01`,
    `prop_fishing_rod_02`,
    `prop_notepad_02`,
    `prop_parking_wand_01`,
    `prop_rag_01`,
    `prop_scn_police_torch`,
    `prop_sh_cigar_01`,
    `prop_sh_joint_01`,
    `prop_tool_broom`,
    `prop_tool_hammer`,
    `prop_tool_jackham`,
    `prop_tennis_rack_01`,
    `prop_weld_torch`,
    `w_me_gclub`,
    `p_amb_clipboard_01`
}

Config.AnimPos = {
    -- Edit controls for right clicking on a animation
    { type = 'control', phase = 'edit',     name = 'goUp',            code = 85 },  -- Q
    { type = 'control', phase = 'edit',     name = 'goDown',          code = 48 },  -- Z
    { type = 'control', phase = 'edit',     name = 'goLeft',          code = 34 },  -- A
    { type = 'control', phase = 'edit',     name = 'goRight',         code = 35 },  -- D
    { type = 'control', phase = 'edit',     name = 'goForward',       code = 32 },  -- W
    { type = 'control', phase = 'edit',     name = 'goBackward',      code = 33 },  -- S
    { type = 'control', phase = 'edit',     name = 'turnLeft',        code = 14 },  -- Mouse Wheel Down
    { type = 'control', phase = 'edit',     name = 'turnRight',       code = 15 },  -- Mouse Wheel Up
    { type = 'control', phase = 'edit',     name = 'pitchUp',         code = 172 }, -- Arrow Up
    { type = 'control', phase = 'edit',     name = 'pitchDown',       code = 173 }, -- Arrow Down
    { type = 'control', phase = 'edit',     name = 'confirm',         code = 38 },  -- E
    { type = 'control', phase = 'edit',     name = 'cancel',          code = 200 }, -- ESC

    -- Placement controls for /animpos command
    { type = 'control', phase = 'place',    name = 'increaseHeight',  code = 44 },  -- Q
    { type = 'control', phase = 'place',    name = 'decreaseHeight',  code = 48 },  -- Z
    { type = 'control', phase = 'place',    name = 'setOnGround',     code = 47 },  -- G
    { type = 'control', phase = 'place',    name = 'rotateLeftFast',  code = 14 },  -- Mouse Wheel Down (+10)
    { type = 'control', phase = 'place',    name = 'rotateRightFast', code = 15 },  -- Mouse Wheel Up (-10)
    { type = 'control', phase = 'place',    name = 'rotateUpSlow',    code = 172 }, -- Arrow Up (+1)
    { type = 'control', phase = 'place',    name = 'rotateDownSlow',  code = 173 }, -- Arrow Down (-1)
    { type = 'control', phase = 'place',    name = 'rotateLeftSlow',  code = 174 }, -- Arrow Left (-3)
    { type = 'control', phase = 'place',    name = 'rotateRightSlow', code = 175 }, -- Arrow Right (+3)
    { type = 'control', phase = 'place',    name = 'pitchUp',         code = 10 },  -- PageUp (+1)
    { type = 'control', phase = 'place',    name = 'pitchDown',       code = 11 },  -- PageDown (-1)
    { type = 'control', phase = 'place',    name = 'confirm',         code = 38 },  -- E
    { type = 'control', phase = 'place',    name = 'cancel',          code = 200 }, -- ESC

    -- Help overlay: when right clicking on a animation
    { type = 'help',    phase = 'help',     key = 'E',                textKey = 'PLACE_ANIMATION' },
    { type = 'help',    phase = 'help',     key = 'Q',                textKey = 'HEIGHT_UP_ANIMATION' },
    { type = 'help',    phase = 'help',     key = 'Z',                textKey = 'HEIGHT_DOWN_ANIMATION' },
    { type = 'help',    phase = 'help',     key = 'G',                textKey = 'SET_ON_GROUND_ANIMATION' },
    { type = 'help',    phase = 'help',     icon = 'SCROLL',          textKey = 'ROTATE_ANIMATION' },
    { type = 'help',    phase = 'help',     key = 'ESC',              textKey = 'CANCEL_ANIMATION' },

    -- Help overlay: when using /animpos command
    { type = 'help',    phase = 'helpEdit', key = 'E',                textKey = 'PLACE_ANIMATION' },
    { type = 'help',    phase = 'helpEdit', key = 'Q',                textKey = 'HEIGHT_UP_ANIMATION' },
    { type = 'help',    phase = 'helpEdit', key = 'Z',                textKey = 'HEIGHT_DOWN_ANIMATION' },
    { type = 'help',    phase = 'helpEdit', icon = 'SCROLL',          textKey = 'ROTATE_ANIMATION' },
    { type = 'help',    phase = 'helpEdit', key = 'UP',               textKey = 'ROTATE_UP' },
    { type = 'help',    phase = 'helpEdit', key = 'DOWN',             textKey = 'ROTATE_DOWN' },
    { type = 'help',    phase = 'helpEdit', key = 'ESC',              textKey = 'CANCEL_ANIMATION' },

    -- Speed control overlay labels (shown when editAnimSpeed is active)
    { type = 'help',    phase = 'speed',    key = 'PGUP',             textKey = 'SPEED_UP_ANIMATION' },
    { type = 'help',    phase = 'speed',    key = 'PGDN',             textKey = 'SPEED_DOWN_ANIMATION' },
}

-- SitAnyChair configuration
-- xOffset = left/right, yOffset = forward/backward, zOffset = up/down, rotOffset = rotation/heading
-- sitEmote = which sit animation to use (sitchair, sitchair2, sitchair3, etc.)
Config.SitAnyChair = {
    -- BENCH
    ['prop_bench_01a'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_01b'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_01c'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_04'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_06'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_05'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_08'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_09'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_10'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_bench_11'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_fib_3b_bench'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_ld_bench01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_wait_bench_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- CHAIR
    ['vw_prop_vw_offchair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['vw_prop_vw_offchair_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['vw_prop_vw_offchair_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_club_stagechair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['hei_prop_heist_off_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['hei_prop_hei_skid_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_01a'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_01b'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_04a'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_04b'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['apa_mp_h_din_chair_12'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_06'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_05'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_08'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_09'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chair_10'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_chateau_chair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_clown_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_cs_office_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_direct_chair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_direct_chair_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_gc_chair02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_off_chair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_off_chair_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_off_chair_04'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_off_chair_04b'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_off_chair_04_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_off_chair_05'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_old_deck_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_old_wood_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_rock_chair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_skid_chair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_skid_chair_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_skid_chair_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_sol_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_wheelchair_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_wheelchair_01_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_armchair_01_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_clb_officechair_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_dinechair_01_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_ilev_p_easychair_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_soloffchair_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_yacht_chair_01_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_club_officechair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_corp_bk_chair3'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_corp_cd_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_corp_offchair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_chair02_ped'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_hd_chair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_p_easychair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ret_gc_chair03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ind_ss_chair01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_ld_farm_chair01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_04_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_05_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_06_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_leath_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_01_chr_a'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_01_chr_b'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_02_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_03b_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_table_03_chr'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_torture_ch_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_fh_dineeamesa'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_res_m_armchair'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['xm_prop_x17_avengerchair_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- STOOL
    ['v_ilev_tort_stool'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_fh_kitchenstool'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- SEAT
    ['hei_prop_yah_seat_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['hei_prop_yah_seat_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['hei_prop_yah_seat_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_waiting_seat_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_yacht_seat_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_yacht_seat_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_yacht_seat_03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_hobo_seat_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- COUCH
    ['prop_rub_couch01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['miss_rub_couch_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_ld_farm_couch01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_ld_farm_couch02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_rub_couch02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_rub_couch03'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_rub_couch04'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- SOFA
    ['p_lev_sofa_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_res_sofa_l_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_v_med_p_sofa_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['p_yacht_sofa_01_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_ilev_m_sofa'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_res_tre_sofa_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_tre_sofa_mess_a_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_tre_sofa_mess_b_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_tre_sofa_mess_c_s'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- MISC
    ['prop_roller_car_01'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['prop_roller_car_02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- CUSTOM
    ['v_ret_gc_chair02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
    ['v_serv_ct_chair02'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },

    -- PITSTOP
    ['imp_prop_impexp_offchair_01a'] = { xOffset = 0.0, yOffset = 0.0, zOffset = 0.0 },
}
