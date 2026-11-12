Discord = {}

local cfg = ServerConfig.Discord
local cache = {}         -- [discordId] = { roles = {}, at = os.time(), name = '' }
local guildRoles = nil   -- cached list of { id, name, color, position }
local guildRolesAt = 0
local API = 'https://discord.com/api/v10'

local function enabled()
    if not cfg.Enabled then return false end
    if cfg.Provider == 'badger' then return GetResourceState('Badger_Discord_API') == 'started' end
    return cfg.BotToken ~= '' and cfg.GuildId ~= ''
end
Discord.Enabled = enabled

local function request(path)
    local p = promise.new()
    local done = false
    PerformHttpRequest(API .. path, function(code, body)
        if done then return end
        done = true
        local data
        if body and body ~= '' then pcall(function() data = json.decode(body) end) end
        p:resolve({ code = code, data = data })
    end, 'GET', '', { ['Authorization'] = 'Bot ' .. cfg.BotToken, ['Content-Type'] = 'application/json' })
    SetTimeout(cfg.Timeout, function()
        if done then return end
        done = true
        p:resolve({ code = 0 })
    end)
    return Citizen.Await(p)
end

-- Returns a list of role ids (strings) for an online player
function Discord.GetPlayerRoles(src, force)
    if not enabled() then return {} end
    local did = Bridge.GetDiscord(src)
    if not did then return {} end

    local c = cache[did]
    if c and not force and os.time() - c.at < cfg.CacheSeconds then return c.roles end

    local roles = {}
    if cfg.Provider == 'badger' then
        local ok, r = pcall(function() return exports.Badger_Discord_API:GetDiscordRoles(src) end)
        if ok and type(r) == 'table' then
            for _, id in ipairs(r) do roles[#roles + 1] = tostring(id) end
        end
    else
        local res = request(('/guilds/%s/members/%s'):format(cfg.GuildId, did))
        if res.code == 200 and res.data and res.data.roles then
            for _, id in ipairs(res.data.roles) do roles[#roles + 1] = tostring(id) end
        elseif res.code == 404 then
            -- not in the guild, cache the empty result so we don't hammer the API
        elseif res.code ~= 200 then
            print(('^1[vinewood_multichar]^7 Discord lookup failed for %s (HTTP %s). Check bot token, guild id and that the bot is in the server.'):format(did, tostring(res.code)))
            if c then return c.roles end
        end
    end

    cache[did] = { roles = roles, at = os.time() }
    return roles
end

function Discord.HasRole(src, roleId)
    for _, r in ipairs(Discord.GetPlayerRoles(src)) do
        if r == tostring(roleId) then return true end
    end
    return false
end

-- For the admin menu dropdown
function Discord.GetGuildRoles(force)
    if not enabled() or cfg.Provider ~= 'bot' then return {} end
    if guildRoles and not force and os.time() - guildRolesAt < 600 then return guildRoles end
    local res = request(('/guilds/%s/roles'):format(cfg.GuildId))
    if res.code ~= 200 or type(res.data) ~= 'table' then return guildRoles or {} end
    local list = {}
    for _, r in ipairs(res.data) do
        if r.name ~= '@everyone' and not r.managed then
            list[#list + 1] = { id = tostring(r.id), name = r.name, color = r.color or 0, position = r.position or 0 }
        end
    end
    table.sort(list, function(a, b) return a.position > b.position end)
    guildRoles, guildRolesAt = list, os.time()
    return list
end

function Discord.ClearCache(src)
    if src then
        local did = Bridge.GetDiscord(src)
        if did then cache[did] = nil end
    else
        cache = {}
    end
end

-- Warm the cache while the player is loading in, so the selection screen opens instantly
AddEventHandler('playerJoining', function()
    local src = source
    SetTimeout(500, function() if enabled() then Discord.GetPlayerRoles(src) end end)
end)

AddEventHandler('playerDropped', function()
    local did = Bridge.GetDiscord(source)
    if did then cache[did] = nil end
end)
