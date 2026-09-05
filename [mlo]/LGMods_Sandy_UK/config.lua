Config = {}

Config.Framework = "standalone"

Config.AllowedJobs = {
    "police",
    "sheriff",
    "ambulance"
}

Config.ShowPrompt = true

Config.Commands = {
    OpenGate = "opengate",
    ResetAlarm = "resetalarm"
}

Config.GateCode = {
    Required = true,
    Code = "1234"
}

Config.Gate = { --  main gate
    ActivationDistance = 2.0,
    TimeOpen = 10000,
    SwingSpeed = 0.2
}

Config.SideGate = {
    TimeOpen = 10000,
    SwingSpeed = 0.2
}

Config.Sounds = {
    Volume = 0.5,
    Radius = 50.0
}

Config.Items = {
    Enabled = false,
    oxInventory = false
}

Config.Targetting = {
    Enabled = false,
    TargetSystem = "ox_target" -- qb-target or ox_target
} 