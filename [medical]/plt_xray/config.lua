Config = {}

Config.Debug = false
Config.Framework = "auto" -- "auto", "QB", or "ESX"
Config.NotifyType = "auto" -- "auto", "qb", "esx", or "chat"

Config.AllowedJobs = { -- who can use the xray machine
    ambulance = true
}

-- X-Ray Computer Location (3D NUI only, no prop)
-- You can use /xrayedit to move this around in-game!
Config.Computer = {
    pos = vector3(307.25, -595.14, 43.28), -- Default Pillbox location
    screenNormal = vector3(0.0, -1.0, 0.0),
    screenUp = vector3(0.0, 0.0, 1.0),
    width = 0.47,
    height = 0.31,
}

-- Scanning Bed Location (where the patient should be)
Config.ScanBed = {
    pos = vector3(35.25, -583.56, 30.63),
    radius = 2.0
}

-- Bone Mapping (Match with plt_ambulance_job)
Config.Bones = {
    { name = "head", label = "Cranium / Head", bone = 31086 },
    { name = "chest", label = "Thorax / Chest", bone = 24818 },
    { name = "left_arm", label = "Left Humerus/Radius", bone = 18905 },
    { name = "right_arm", label = "Right Humerus/Radius", bone = 57005 },
    { name = "left_leg", label = "Left Femur/Tibia", bone = 14201 },
    { name = "right_leg", label = "Right Femur/Tibia", bone = 52301 }
}

Config.ScanTime = 5000 -- ms duration of the "scanning" animation in UI

Config.AutoSpawn = true -- Set to false if you are spawning the screen via another script's exports

Config.Commands = {
    interact = "xray_interact", -- Keybind 'J' by default to use 3D mouse
    ui = "xray",               -- Command to pop up the full screen UI
    place = "xrayplace",       -- Command to place screen in front of you
    edit = "xrayedit",         -- Command to move/rotate the screen
    location = "xraylocation", -- Command to set patient scan location
    test = "xraytest",         -- Debug command to force UI open
    debug = "xraydebug"        -- Debug command to show position info
}
