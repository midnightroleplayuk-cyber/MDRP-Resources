-- Server-only file: keep webhook URLs here, never in server.cfg convars.
Config.Logs = {
    Discord = {
        enabled = false,
        username = 'Vinewood Prison',
        avatar = nil,
        webhooks = {
            default = '',
            reception = '',
            release = '',
            sentence = '',
            doors = '',
            editor = '',
            security = '',
            custody = '',
        },
    },
}
