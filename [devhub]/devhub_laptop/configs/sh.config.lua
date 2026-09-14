if not Config then Config = {} end

Config.Debug = false

Config.Command = 'laptop' -- set to false to disable
Config.Item = 'devhub_laptop' -- set to false to disable

Config.DefaultWallpapers = { -- first one is active by default, cannot be removed by user
    "https://cfx-nui-devhub_laptop/html/images/wallpapers/wallpaper_1.webp",
    "https://cfx-nui-devhub_laptop/html/images/wallpapers/wallpaper_2.webp",
    "https://cfx-nui-devhub_laptop/html/images/wallpapers/wallpaper_3.webp",
}

Config.DefaultAvatars = {
    "https://cfx-nui-devhub_laptop/html/images/avatars/avatar_1.webp",
    "https://cfx-nui-devhub_laptop/html/images/avatars/avatar_2.webp",
    "https://cfx-nui-devhub_laptop/html/images/avatars/avatar_3.webp",
    "https://cfx-nui-devhub_laptop/html/images/avatars/avatar_4.webp",
}

Config.DefaultSettings = {
    wifi = true,
    bluetooth = false,
    soundless = false,
    ecoMode = false,
    brightness = 100,
    volume = 20,
}

Config.PreInstalledApps = {
    'notepad',
    'calculator',
    'cmd',
    'browser',
    'appStore',
    'clock',
}

Config.WorldClocks = {
    {name = "Warsaw (CET)", timezone = "Europe/Warsaw"},
    {name = "New York (EST)", timezone = "America/New_York"},
    {name = "Tokyo (JST)", timezone = "Asia/Tokyo"},
    {name = "London (GMT)", timezone = "Europe/London"},
}

-- Browser Quick Links Configuration
Config.BrowserQuickLinks = {
    {title = "Google", url = "https://www.google.com/search?igu=1", icon = "fab fa-google"},
    {title = "CodeSandbox", url = "https://codesandbox.io/embed/new?codemirror=1", icon = "fas fa-code"},
    {title = "Devhub Store", url = "https://store.devhub.gg", icon = "fas fa-laptop-code"},
    {title = "Wikipedia", url = "https://wikipedia.org", icon = "fas fa-book"},
}
