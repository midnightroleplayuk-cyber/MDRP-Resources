-- Discord webhook logs. URLs live in server/webhooks.lua (server-only, never sent to clients).
-- Categories: carriers, incidents, treatment, rewards, admin

Logs = Logs or {}

local cfg = Config.Logs or {}

local COLOURS = {
    green = 0x2ECC71,
    red = 0xE74C3C,
    orange = 0xE67E22,
    yellow = 0xF1C40F,
    blue = 0x3498DB,
    purple = 0x9B59B6,
    grey = 0x95A5A6,
}

local queues = {} -- [url] = { embed, ... }

local function webhookFor(category)
    local hooks = Webhooks or {}
    local url = hooks[category]
    if not url or url == '' then url = hooks.default end
    return url ~= '' and url or nil
end

---"Name (id) | citizenid | <@discord>" for a player.
function Logs.Player(src)
    if not src or src <= 0 or not GetPlayerName(src) then
        return ('offline (%s)'):format(tostring(src))
    end
    local parts = { ('**%s** (%d)'):format(Bridge.GetName(src) or GetPlayerName(src) or '?', src) }
    local char = Bridge.GetIdentifier(src)
    if char then parts[#parts + 1] = ('`%s`'):format(char) end
    local discord = GetPlayerIdentifierByType(src, 'discord')
    if discord then parts[#parts + 1] = ('<@%s>'):format(discord:gsub('discord:', '')) end
    local license = GetPlayerIdentifierByType(src, 'license')
    if license then parts[#parts + 1] = ('`%s`'):format(license) end
    return table.concat(parts, ' | ')
end

function Logs.Coords(c)
    if not c then return 'unknown' end
    return ('%.1f, %.1f, %.1f'):format(c.x, c.y, c.z)
end

---Queue a log embed.
---@param category string carriers | incidents | treatment | rewards | admin
---@param title string
---@param colour string key of COLOURS
---@param fields table list of { name, value, inline? }
function Logs.Send(category, title, colour, fields)
    if not cfg.Enabled then return end
    if cfg.Categories and cfg.Categories[category] == false then return end
    local url = webhookFor(category)
    if not url then return end

    -- Discord rejects the whole message (HTTP 400) if any field name or value is empty.
    local embedFields = {}
    for i, f in ipairs(fields or {}) do
        local name = tostring(f[1] or '')
        local value = tostring(f[2] == nil and '' or f[2])
        embedFields[i] = {
            name = (name ~= '' and name or '-'):sub(1, 256),
            value = (value ~= '' and value or '-'):sub(1, 1024),
            inline = f[3] == true,
        }
    end
    local queue = queues[url] or {}
    queues[url] = queue
    GoodCiv.Debug(('log queued [%s] %s'):format(category, title))
    queue[#queue + 1] = {
        title = tostring(title):sub(1, 256),
        color = COLOURS[colour] or COLOURS.grey,
        fields = embedFields,
        footer = { text = ('GoodCiv | %s'):format(category) },
        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    }
end

-- Batch up to 10 embeds per request so busy periods stay inside Discord's rate limit.
CreateThread(function()
    while true do
        Wait(2000)
        for url, queue in pairs(queues) do
            if #queue > 0 then
                local batch = {}
                for i = 1, math.min(10, #queue) do batch[i] = table.remove(queue, 1) end
                PerformHttpRequest(url, function(status, body, _, err)
                    if status ~= 200 and status ~= 204 then
                        print(('^1[goodciv]^7 webhook failed (HTTP %s): %s'):format(
                            tostring(status), tostring(err or body or 'no response')))
                    end
                end, 'POST', json.encode({
                    username = cfg.Username or 'GoodCiv Logs',
                    avatar_url = cfg.Avatar,
                    embeds = batch,
                }), { ['Content-Type'] = 'application/json' })
            end
        end
    end
end)

CreateThread(function()
    if not cfg.Enabled then
        print('^3[goodciv]^7 Discord logs are off (Config.Logs.Enabled = false).')
    elseif not Webhooks then
        print('^1[goodciv]^7 server/webhooks.lua did not load. Check it is in fxmanifest.lua server_scripts.')
    elseif not webhookFor('incidents') then
        print('^3[goodciv]^7 Config.Logs is enabled but no webhook is set. Add your URL to server/webhooks.lua.')
    else
        print('^2[goodciv]^7 Discord logs enabled.')
    end
end)

-- Console / admin: /goodcivlogtest  sends one test log to every category's webhook.
RegisterCommand('goodcivlogtest', function(src)
    if src ~= 0 and not IsPlayerAceAllowed(src, 'goodciv.admin') then return end
    for _, category in ipairs({ 'carriers', 'incidents', 'treatment', 'rewards', 'admin' }) do
        Logs.Send(category, 'Test log', 'purple', {
            { 'Category', category, true },
            { 'Sent by', src == 0 and 'Server console' or Logs.Player(src), true },
        })
    end
    print('^2[goodciv]^7 Test logs queued. Check Discord, or this console for a "webhook failed" error.')
end, false)

Logs.Ready = true
