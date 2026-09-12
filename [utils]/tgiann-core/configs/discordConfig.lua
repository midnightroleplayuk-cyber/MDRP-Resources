-- Don't share the bot token with anyone
configCore.discordConfig = {
    guildId = '',                   -- Set to the ID of your guild
    botToken = '',                  -- Search google "How to get discord bot token"
    cacheDiscordRoles = true,       -- true to cache player roles, false to make a new Discord Request every time
    cacheDiscordRolesTime = 60,     -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
    disabledWarningMessage = false, -- Set to true to disable the warning message in console if the bot token is not set
}

configCore.discordLog = {
    name = "TGIANN",
    avatar = "",
}

---@class InfoType
---@field cid? string
---@field identifier? string
---@field name? string
---@field note? string

---@param player number|string
---@return InfoType info, string? playerName, string? playerId
local function buildPlayerInfo(player)
    local info = {}
    local identifier = GetPlayerIdentifiers(player)[1]
    local xPlayer = tgiCore.getPlayer(player)

    if xPlayer then
        local cid = tgiCore.getCid(xPlayer)
        local name = tgiCore.getCharacterName(xPlayer)
        info.cid = cid
        info.identifier = identifier
        info.name = name
        return info, name, cid
    end

    local name = GetPlayerName(player) or ("No Name! Server ID: " .. tostring(player))
    info.name = name
    info.identifier = identifier or "No Identifier"
    info.note = "xPlayer Not Found!"
    return info, name, identifier
end

configCore.customLog = {
    active = false,
    ---@param WebHook string
    ---@param Message string
    ---@param player number
    ---@param target number
    ---@param resource string
    fun = function(WebHook, Message, player, target, resource)
        -- Example code for custom logging to a database or external service
        local metadata = {}
        local playerName, playerId

        if player then
            local pInfo, pName, pId = buildPlayerInfo(player)
            metadata.player = pInfo
            playerName = pName
            playerId = pId

            if target then
                local tInfo = buildPlayerInfo(target)
                metadata.target = tInfo
            end
        end

        exports['tgiann-site-api']:Log({
            level = "info",
            resource = resource,
            message = Message,
            playerName = playerName,
            playerId = playerId,
            metadata = next(metadata) and metadata or nil,
        })
    end
}
