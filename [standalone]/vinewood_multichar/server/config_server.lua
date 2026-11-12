--[[ ─────────────────────────────────────────────────────────────
    SERVER-ONLY CONFIG
    This file is never sent to clients, so the bot token is safe here.
───────────────────────────────────────────────────────────── ]]
ServerConfig = {}

ServerConfig.Discord = {
    Enabled  = false,

    -- 'bot'    : this resource talks to Discord directly with your bot token (recommended)
    -- 'badger' : uses Badger_Discord_API if you already run it
    Provider = 'bot',

    BotToken = '',          -- Bot token from https://discord.com/developers/applications
    GuildId  = '',          -- Right click your server > Copy Server ID (developer mode on)

    CacheSeconds = 300,     -- how long a player's roles are cached
    Timeout = 5000,         -- ms to wait for Discord before falling back to no roles

    -- Default role bonuses. Once you save from the admin menu, the menu values are used instead.
    Roles = {
        -- { roleId = '123456789012345678', slots = 1, label = 'Server Booster' },
        -- { roleId = '234567890123456789', slots = 2, label = 'VIP Gold' },
    },
}

-- Optional webhook for logging admin changes (slot overrides, scene saves, deletions)
ServerConfig.LogWebhook = ''
