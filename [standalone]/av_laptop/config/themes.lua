if lib.context == "server" then return end
Config = Config or {}
Config.Themes = {
    {accent = "#00f0ff", glow = "rgba(0, 240, 255, 0.5)"},
    {accent = "#bc6ff1", glow = "rgba(188, 111, 241, 0.5)"},
    {accent = "#39ff14", glow = "rgba(57, 255, 20, 0.5)"},
    {accent = "#ff2d55", glow = "rgba(255, 45, 85, 0.5)"},
    {accent = "#ffcc00", glow = "rgba(255, 204, 0, 0.5)"},
    {accent = "#ff00ff", glow = "rgba(255, 0, 255, 0.5)"},
    {accent = "#ff5e00", glow = "rgba(255, 94, 0, 0.5)"},
    {accent = "#00ff41", glow = "rgba(0, 255, 65, 0.5)"},
    {accent = "#0077ff", glow = "rgba(0, 119, 255, 0.5)"},
    {accent = "#9d00ff", glow = "rgba(157, 0, 255, 0.5)"},
    {accent = "#e0e0e0", glow = "rgba(224, 224, 224, 0.4)"},
}

RegisterNUICallback('getThemes', function(_,cb)
    cb({enabled = Config.CanUseThemes, themes = Config.Themes})
end)