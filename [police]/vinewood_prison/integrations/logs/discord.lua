local COLOURS = {
    reception = 1938616,  -- blue
    release = 28732,      -- green
    sentence = 16750592,  -- amber
    security = 13907228,  -- red
    doors = 5263440,
    editor = 8421504,
    custody = 1938616,
}

local function webhookFor(category)
    local hooks = Config.Logs.Discord.webhooks
    local url = hooks[category]
    if not url or url == '' then url = hooks.default end
    if url and url ~= '' then return url end
end

Prison.adapters.logs.discord = {
    enabled = function() return Config.Logs.Discord.enabled end,
    send = function(category, action, actor, target, payload)
        local url = webhookFor(category)
        if not url then return end
        local fields = {
            { name = 'Action', value = action, inline = true },
            { name = 'By', value = actor, inline = true },
            { name = 'Time', value = Prison.ukTime(), inline = true },
        }
        if target then fields[#fields + 1] = { name = 'Target', value = tostring(target), inline = true } end
        if payload then
            local text = json.encode(payload)
            if #text > 1000 then text = text:sub(1, 1000) .. '...' end
            fields[#fields + 1] = { name = 'Details', value = '```json\n' .. text .. '\n```' }
        end
        PerformHttpRequest(url, function() end, 'POST', json.encode({
            username = Config.Logs.Discord.username,
            avatar_url = Config.Logs.Discord.avatar,
            embeds = { {
                title = Config.UI.prisonDisplayName,
                color = COLOURS[category] or 1938616,
                fields = fields,
                footer = { text = 'Vinewood Prison' },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
            } },
        }), { ['Content-Type'] = 'application/json' })
    end,
}
