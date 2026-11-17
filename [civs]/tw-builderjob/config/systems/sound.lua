-- Audio: machine loops and one-shots, with distance falloff.
Config = Config or {}

Config.Sound = {
    falloff = {
        { 0.0,  1.0 },
        { 8.0,  1.0 },
        { 25.0, 0.6 },
        { 50.0, 0.2 },
        { 60.0, 0.0 },
    },

    channels = {
        ui      = { enabled = true, volume = 80 },
        machine = { enabled = true, volume = 10 },
    },
}
