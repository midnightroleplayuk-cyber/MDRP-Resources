Config = Config or {}
Config.PCs = {
    {
        coords = { x = 447.9599, y = -973.4294, z = 30.6896 },
        canUse = function() -- add your own check and return true or false
            return exports['av_laptop']:hasJob("police")
        end,
        password = "12345",
        serial = "sapd_boss_office",
        name = "SAPD Boss",
        avatar = "https://img.freepik.com/premium-vector/person-with-hat-their-head_169196-13010.jpg",
        wallpaper = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/police_wallpaper.jpg",
        theme = {accent = "#00f0ff", glow = "rgba(0, 240, 255, 0.5)"},
        apps = {
            ["documents"] = true,
            ["business"] = true,
            ["files"] = true,
            ["calculator"] = true,
        },
        storage = 100,
    }
}