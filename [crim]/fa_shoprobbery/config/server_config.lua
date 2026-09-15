ServerConfig = ServerConfig or {}

-- Logging destination: console, discord, ox_lib, fivemanage, fivemerr, custom, none.
ServerConfig.Logs = 'console'

-- Discord webhook used when ServerConfig.Logs = 'discord'.
ServerConfig.DiscordWebhook = ''

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
