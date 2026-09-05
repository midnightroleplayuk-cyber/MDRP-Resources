Config = {}

Config.Framework = 'standalone' -- Accepted values are standalone, oEssentials, PoliceEssentials, QBCore, TMC, ESX.

Config.ShowPrompt = true -- This will show a prompt to the user if they are near a coordinate listed in ActivationPoints

Config.AllowedJobs = { -- This is only checked when Framework is set to QBCore, TMC or ESX.
    "Job1",
    "Job2"
}

Config.Targetting = {
    Enabled = false, -- If you want to use the "third-eye" functionality for keypads
    Framework = "qtarget" -- The name of the targetting framework you use for 3rd Eye integration, if you use ox_target leave this as qtarget as well.
}

Config.ActivationPoints = { -- These are the places where users can do the commands to activate the gate.
    vec3(-449.39, 6028, 31.49),
    vec3(-460.2, 6025.86, 31.34)
}

Config.Gate = {
    ActivationDistance = 4.0, -- The distance from the panels to interact with the gate.
    TimeOpen = 5, -- How long should the gate be open in seconds
    MoveIncrement = 0.1, -- The higher this is the faster the gate moves.
}

Config.GateCode = {
    Required = true, -- If set to true, despite the user being authorised above they will need a code.
    Code = "1234" -- MAXIMUM OF 4 CHARACTERS
}

Config.Commands = {
    OpenGate = "paletogate", -- The command to open the gates
}

Config.Sounds = { -- This is used to determine the volume of the gate and alarm sounds for users.
    Radius = 20.0,
    Volume = 1.0 -- Maximum volume is 1.0
}
