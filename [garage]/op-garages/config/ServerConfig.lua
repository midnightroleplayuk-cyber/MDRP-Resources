ServerConfig = {}

ServerConfig.SteamApiKey = "" -- For Administrator avatars.
ServerConfig.WebHook = "" -- Discord WebHook for admin commands logs.
ServerConfig.ImpoundWebHook = "" -- Discord WebHook for impound/tow logs. Falls back to WebHook when empty.
ServerConfig.AutoMysql = true -- Disable/Enable mysql. True = enabled