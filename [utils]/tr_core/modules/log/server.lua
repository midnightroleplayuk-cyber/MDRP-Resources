---@class TRLog
local log = ...

---@class TRDiscordEmbed
---@field title? string
---@field description? string
---@field color? integer
---@field fields? { name: string, value: string, inline?: boolean }[]

---Queues a Discord embed for the channel's webhook in tr_core/server_config.lua (webhooks.<channel>,
---else webhooks.default).
---@param channel string e.g. 'money', 'admin', 'security'
---@param embed TRDiscordEmbed
function log.discord(channel, embed)
    exports.tr_core:discord(channel, embed, GetCurrentResourceName())
end

return log
