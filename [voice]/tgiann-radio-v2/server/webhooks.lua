local webhooks = {
    connectLeave = "",
    changeUserDetail = "",
}

function sendDiscordLog(webhook, msg, src)
    TriggerEvent("tgiann-core:discordLog", webhooks[webhook], msg, src)
end
