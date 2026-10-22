ServerConfig = ServerConfig or {}

-- Logging destination: console, discord, ox_lib, fivemanage, fivemerr, custom, none.
ServerConfig.Logs = 'discord'

-- Discord webhook used when ServerConfig.Logs = 'discord'.
ServerConfig.DiscordWebhook = 'https://discord.com/api/webhooks/1562626632265498724/Y3kpSNtRFpzlzJneUwXjURHg3pexLHi0p3CrICJLbOvCxcRxVL1CiyQN15Skfgf2Z4mv'

-- Currency items used only when Config.Framework resolves to standalone.
ServerConfig.StandaloneMoneyItems = {
    Cash = 'money',
    Dirty = 'black_money'
}

-- Fivemanage logging.
ServerConfig.FiveManage = {
    ApiUrl = 'https://api.fivemanage.com/api/v3/logs',
    ApiKey = '',
    Resource = 'fa_shoprobbery',
    Level = 'info'
}

-- Fivemerr/custom support still uses resource exports for servers that prefer them.
ServerConfig.ExternalLogs = {
    Fivemerr = {
        resource = 'fivemerr',
        export = 'Log'
    },
    Custom = {
        resource = 'fa_logs',
        export = 'Write'
    }
}
