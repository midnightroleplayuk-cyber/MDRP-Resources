TR.player.bridge.registerEvents()

---------------------------------------------------------------------------------------------------
-- Discord webhooks: one shared queue per webhook for every TR resource so Discord rate limits are
-- respected. Up to 10 embeds go in one message, one message every 2 s per webhook; a 429 waits as
-- long as Discord says. Text is cut to Discord's limits, which would otherwise reject the message.
---------------------------------------------------------------------------------------------------

local GAP = 2000      -- ms between two messages to one webhook (Discord allows 30 a minute)
local BATCH = 10      -- embeds in one message (Discord's most)
local CHARS = 5800    -- what a message's embeds may add up to (Discord's most is 6000)
local QUEUE_MAX = 200 -- embeds a webhook's queue holds before it drops the oldest
local TRIES = 2       -- sends per embed when Discord or the network fails (5xx, no answer)

local hooks = {} ---@type table<string, { list: table[], busy: boolean, dropped: integer }>

local function webhookUrl(channel)
    local url = GetConvar(('tr:webhook:%s'):format(channel), '')
    if url == '' then url = GetConvar('tr:webhook', '') end
    return url ~= '' and url or nil
end

---Cuts text to `max` characters (Discord counts characters, not bytes).
local function cut(text, max)
    text = tostring(text or '')
    local length = utf8.len(text)
    if not length then
        text = text:gsub('[\128-\255]', '?')
        length = #text
    end
    if length <= max then return text end
    return text:sub(1, utf8.offset(text, max) - 1) .. '…'
end

---A copy of the embed inside Discord's limits, and roughly what it counts towards a message's 6000.
---@param embed TRDiscordEmbed
---@return table embed
---@return integer size
local function fit(embed, footer)
    local out = { color = math.tointeger(embed.color) or 0x3498DB, timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ') }
    local size = 0

    if embed.title then out.title = cut(embed.title, 256) size = size + utf8.len(out.title) end
    if embed.description then out.description = cut(embed.description, 4096) size = size + utf8.len(out.description) end

    if type(embed.fields) == 'table' then
        out.fields = {}
        for _, field in ipairs(embed.fields) do
            if #out.fields >= 25 then break end
            if type(field) == 'table' then
                local name, value = cut(field.name, 256), cut(field.value, 1024)
                -- Discord rejects empty names and values.
                if name == '' then name = '-' end
                if value == '' then value = '-' end
                out.fields[#out.fields + 1] = { name = name, value = value, inline = field.inline == true }
                size = size + utf8.len(name) + utf8.len(value)
            end
        end
    end

    out.footer = { text = cut(footer, 2048) }
    return out, size + utf8.len(out.footer.text)
end

local function warn(hook, key, message, ...)
    local now = GetGameTimer()
    if (hook[key] or -math.huge) > now then return end
    hook[key] = now + 60000
    TR.log.warn(message, ...)
end

---How long Discord said to wait, in ms.
local function retryAfter(body, headers)
    if type(body) == 'string' then
        local seconds = tonumber(body:match('"retry_after"%s*:%s*([%d%.]+)'))
        if seconds then return seconds * 1000 end
    end
    if type(headers) == 'table' then
        local seconds = tonumber(headers['Retry-After'] or headers['retry-after'])
        if seconds then return seconds * 1000 end
    end
    return 5000
end

local send

local function schedule(url, ms)
    SetTimeout(math.ceil(ms), function() send(url) end)
end

---Posts the next message's worth of a webhook's queue.
function send(url)
    local hook = hooks[url]
    local batch, size = {}, 0
    while #batch < BATCH and hook.list[1] do
        local weight = hook.list[1].size
        if #batch > 0 and size + weight > CHARS then break end
        batch[#batch + 1] = table.remove(hook.list, 1)
        size = size + weight
    end
    if #batch == 0 then
        hook.busy = false
        return
    end

    local embeds = {}
    for i, item in ipairs(batch) do embeds[i] = item.embed end
    -- No parse list: nothing in a log pings anyone (player names can say @everyone).
    local body = json.encode({ username = 'TR Scripts', embeds = embeds, allowed_mentions = { replied_user = false } })

    PerformHttpRequest(url, function(status, data, headers, err)
        status = tonumber(status) or 0

        local retry = status == 429 and 'all' or (status == 0 or status >= 500) and 'tries' or nil
        if retry then
            -- Back to the front, in order; on 429 they wait as long as Discord said.
            for i = #batch, 1, -1 do
                local item = batch[i]
                item.tries = item.tries + (retry == 'tries' and 1 or 0)
                if item.tries < TRIES then table.insert(hook.list, 1, item) end
            end
            while #hook.list > QUEUE_MAX do table.remove(hook.list) end
            if status ~= 429 then warn(hook, 'warnedFail', 'discord webhook returned HTTP %s, sending again', status) end
            return schedule(url, status == 429 and retryAfter(data or err, headers) + 250 or GAP)
        end

        if status < 200 or status >= 300 then
            warn(hook, 'warnedFail', 'discord webhook returned HTTP %s; %d logs were lost', status, #batch)
        end
        schedule(url, GAP)
    end, 'POST', body, { ['Content-Type'] = 'application/json' })
end

---@param channel string
---@param embed TRDiscordEmbed
---@param origin? string resource that sent the log
exports('discord', function(channel, embed, origin)
    if type(channel) ~= 'string' or type(embed) ~= 'table' then return end
    local url = webhookUrl(channel)
    if not url then return end

    local item, size = fit(embed, ('%s • %s'):format(origin or GetInvokingResource() or 'tr_core', channel))

    local hook = hooks[url]
    if not hook then
        hook = { list = {}, busy = false }
        hooks[url] = hook
    end

    if #hook.list >= QUEUE_MAX then
        table.remove(hook.list, 1)
        warn(hook, 'warnedFull', 'more logs than Discord takes: the oldest waiting are being dropped')
    end
    hook.list[#hook.list + 1] = { embed = item, size = size, tries = 0 }

    if not hook.busy then
        hook.busy = true
        send(url)
    end
end)

---------------------------------------------------------------------------------------------------

TR.log.info('^2tr_core v%s^7 | framework: %s | inventory: %s | target: %s | keys: %s | fuel: %s | dispatch: %s',
    TR.version, TR.system('framework'), TR.system('inventory'), TR.system('target'), TR.system('keys'), TR.system('fuel'),
    TR.system('dispatch'))
