Config = {}

Config.Debug = false

Config.VersionCheck = true

Config.UIEnabled = true
Config.UIDefaultOn = false
Config.UICommand = "toggleELSUI"

Config.DefaultKeybinds = {} -- Intentionally left empty, edit tables below.

Config.DefaultKeybinds.Keyboard = {
    PrimaryLights = "Q",
    SecondaryLights = "K",
    WarningLights = "L",
    SirensToggle = "G",
    SirensSwitch = "R",
    Bullhorn = "X",
    LeftAlleyLight = "",
    RightAlleyLight = "",
    IndicatorsLeft = "LEFT",
    IndicatorsRight = "RIGHT",
    Hazards = "BACK",
    SecondSirenToggle = "",
    SecondSirenSwitch = ""
}

Config.DefaultKeybinds.Controller = {
    PrimaryLights = "LLEFT_INDEX",
    SirensToggle = "LDOWN_INDEX",
    SirensSwitch = "RRIGHT_INDEX",
    SecondSirenToggle = "",
    SecondSirenSwitch = "",
    Bullhorn = "RDOWN_INDEX",
    IndicatorsLeft = "",
    IndicatorsRight = "",
    Hazards = ""
}

Config.Soundpacks = {
    -- Uncomment the 3 lines below for the LGMods British Server Sided Sirens (https://docs.lgmods.co.uk/misc/british-sirens)
    -- "DLC_LGMODS\\sirenpack_one",
    -- "DLC_LGMODS\\sirenpack_two",
    -- "DLC_LGMODS\\sirenpack_three"
    -- Uncomment the 3 lines below for the LGMods London Server Sided Sirens (https://docs.lgmods.co.uk/misc/london-sirens)
    -- "DLC_LGMODS_LONDONSIRENS\\sirenpack_one",
    -- "DLC_LGMODS_LONDONSIRENS\\sirenpack_two",
    -- "DLC_LGMODS_LONDONSIRENS\\sirenpack_three"
}

Config.Optilink = {
    Enabled = true,
    Use999Sound = {
        -- `Vehicle Spawn Code` (ENSURE YOU ARE USING `` AROUND THE SPAWN CODE AND NOT "")
    }
}

Config.NonELS = {
    -- `Vehicle Spawn Code` (ENSURE YOU ARE USING `` AROUND THE SPAWN CODE AND NOT "")
    [`NONELS`] = {
        PrimaryLights = {1},
        SecondaryLights = {3},
        WarningLights = {4},
        OnSceneLights = {2}
    }
}

Config.WigWags = true

Config.PrimaryPatterns = {
    ["leds"] = {{{1, 2}, 75}, {{}, 75}, {{1, 2}, 75}, {{3, 4}, 75}, {{}, 75}, {{3, 4}, 75}},
    ["btp"] = {{{1, 2}, 75}, {{}, 75}, {{1, 2}, 75}, {{3, 4}, 75}, {{}, 75}, {{3, 4}, 75}},
    ["rotator"] = {{{1}, 75}, {{2}, 75}, {{3}, 75}, {{4}, 75}},
}

Config.OnScenePatterns = {
    ["leds"] = {{{1}, 75}, {{}, 75}, {{1}, 75}, {{4}, 75}, {{}, 75}, {{4}, 75}},
    ["btp"] = {{{1,9}, 75}, {{}, 75}, {{1,9}, 75}, {{4,7}, 75}, {{}, 75}, {{4,7}, 75}},
    ["rotator"] = {{{}, 75}},
}

Config.SecondaryPatterns = {
    ["leds"] = {{{9}, 120}, {{}, 120}, {{7}, 120}, {{}, 120}},
    ["btp"] = {{{9}, 120}, {{}, 120}, {{7}, 120}, {{}, 120}},
    ["rotator"] = {{{9}, 240}, {{}, 240}, {{7}, 240}, {{}, 240}}
}

Config.WarningPatterns = {
    ["leds"] = {{{6}, 280}, {{}, 160}, {{5}, 280}, {{}, 160}},
    ["btp"] = {{{6}, 280}, {{}, 160}, {{5}, 280}, {{}, 160}},
    ["rotator"] = {{{6}, 280}, {{}, 160}, {{5}, 280}, {{}, 160}}
}
