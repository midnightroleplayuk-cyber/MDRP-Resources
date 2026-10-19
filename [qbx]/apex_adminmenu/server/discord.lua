-- ============================================================
-- APEX ADMIN — DISCORD DISPATCHER
-- ------------------------------------------------------------
-- Every webhook in this resource goes through here. It exists
-- because the previous code fired PerformHttpRequest with an empty
-- callback, so any failure — bad URL, malformed embed, rate limit —
-- was completely invisible. "The logs don't work" with no way to
-- find out why.
--
-- What this adds
--   • URL validation (an empty string is TRUTHY in Lua, which is why
--     an unconfigured webhook used to POST to "" forever)
--   • Discord's payload limits enforced before sending, since one
--     over-long field makes Discord reject the WHOLE message with 400
--   • A per-URL queue that respects 429 retry_after instead of
--     hammering and silently losing messages
--   • Real console diagnostics on every failure
--
-- Console commands: `apexdiscord` (status), `apexdiscordtest <url>`
-- ============================================================

ApexDiscord = ApexDiscord or {}

-- ── Discord's documented hard limits ────────────────────────
local LIMITS = {
    title       = 256,
    description = 4096,
    fields      = 25,
    fieldName   = 256,
    fieldValue  = 1024,
    footer      = 2048,
    authorName  = 256,
    totalEmbed  = 6000,
    embeds      = 10
}

local function trim(s)
    return (tostring(s or ''):gsub('^%s*(.-)%s*$', '%1'))
end

--- Is this a usable Discord webhook URL?
--- Returns ok, reason.
function ApexDiscord.ValidateUrl(url)
    if type(url) ~= 'string' then return false, 'not a string' end
    local u = trim(url)
    if u == '' then return false, 'empty' end
    if not u:match('^https://') then return false, 'not https' end
    if not u:lower():find('/api/webhooks/', 1, true) then
        return false, 'does not look like a Discord webhook URL'
    end
    return true
end

--- Clamp a string to `max` characters, adding an ellipsis when cut.
local function clamp(s, max)
    s = tostring(s or '')
    -- A non-positive budget must yield an EMPTY string. Without this
    -- guard `clamp(s, 0)` fell through to `s:sub(1, -1) .. '…'`, i.e. the
    -- whole string plus an ellipsis — so the over-budget trim below made
    -- the payload LONGER and Discord still rejected it with a 400.
    if max <= 0 then return '' end
    if #s <= max then return s end

    -- Byte-based truncation can land mid-UTF-8 and produce invalid JSON.
    -- Walk back off any continuation byte (10xxxxxx) before cutting.
    local cut = max - 1
    while cut > 0 do
        local b = s:byte(cut + 1)
        if not b or b < 0x80 or b >= 0xC0 then break end
        cut = cut - 1
    end
    return s:sub(1, cut) .. '…'
end

--- Normalise an embed so Discord can never reject it for shape.
--- This is the difference between "some logs arrive" and "all do".
local function sanitiseEmbed(embed)
    if type(embed) ~= 'table' then return nil end

    local out = {}

    if embed.title       then out.title       = clamp(embed.title, LIMITS.title) end
    if embed.description then out.description = clamp(embed.description, LIMITS.description) end
    if embed.url         then out.url         = embed.url end
    if embed.timestamp   then out.timestamp   = embed.timestamp end

    -- Discord wants an integer colour. A hex string here is a silent 400.
    if embed.color then
        local c = tonumber(embed.color)
        if c then out.color = math.floor(c) % 0x1000000 end
    end

    if type(embed.footer) == 'table' and embed.footer.text then
        out.footer = { text = clamp(embed.footer.text, LIMITS.footer) }
        if embed.footer.icon_url then out.footer.icon_url = embed.footer.icon_url end
    end

    if type(embed.author) == 'table' and embed.author.name then
        out.author = { name = clamp(embed.author.name, LIMITS.authorName) }
        if embed.author.icon_url then out.author.icon_url = embed.author.icon_url end
        if embed.author.url      then out.author.url      = embed.author.url end
    end

    if type(embed.thumbnail) == 'table' and embed.thumbnail.url then
        out.thumbnail = { url = embed.thumbnail.url }
    end

    -- Fields: Discord 400s on an empty name OR an empty value, so we
    -- drop those instead of letting one bad field kill the message.
    if type(embed.fields) == 'table' then
        local fields = {}
        for i = 1, #embed.fields do
            local f = embed.fields[i]
            if type(f) == 'table' then
                local name  = trim(f.name)
                local value = trim(f.value)
                if name ~= '' and value ~= '' and #fields < LIMITS.fields then
                    fields[#fields + 1] = {
                        name   = clamp(name,  LIMITS.fieldName),
                        value  = clamp(value, LIMITS.fieldValue),
                        inline = f.inline and true or false
                    }
                end
            end
        end
        if #fields > 0 then out.fields = fields end
    end

    -- An embed with nothing renderable is also a 400.
    if not (out.title or out.description or out.fields or out.author) then
        return nil
    end

    -- Total-character budget across the whole embed.
    local total = #(out.title or '') + #(out.description or '')
                + #((out.footer and out.footer.text) or '')
                + #((out.author and out.author.name) or '')
    if out.fields then
        for i = 1, #out.fields do
            total = total + #out.fields[i].name + #out.fields[i].value
        end
    end
    if total > LIMITS.totalEmbed and out.description then
        -- Trim the description first; it is the most compressible part.
        local over = total - LIMITS.totalEmbed
        out.description = clamp(out.description, math.max(0, #out.description - over - 1))
    end

    return out
end

ApexDiscord.SanitiseEmbed = sanitiseEmbed

-- ============================================================
-- Send queue
-- ------------------------------------------------------------
-- Discord allows roughly 5 requests per 2s per webhook and answers
-- 429 with a `retry_after` when you exceed it. Firing straight from
-- every admin action drops messages on a busy server, so each URL
-- gets its own serialised queue with a floor delay.
-- ============================================================

local queues   = {}   -- url → { items = {}, running = bool }
local MIN_GAP  = 400  -- ms between sends on the same webhook
local MAX_TRY  = 3

local stats = { sent = 0, failed = 0, dropped = 0, rateLimited = 0 }
ApexDiscord.stats = stats

local function post(url, body, attempt, done)
    PerformHttpRequest(url, function(status, text, _headers)
        -- 204 No Content is the documented success for webhooks; some
        -- proxies answer 200. Anything else needs explaining.
        if status == 200 or status == 204 then
            stats.sent = stats.sent + 1
            return done(true)
        end

        if status == 429 then
            stats.rateLimited = stats.rateLimited + 1
            local retryAfter = 1.0
            local ok, decoded = pcall(json.decode, text or '')
            if ok and type(decoded) == 'table' and tonumber(decoded.retry_after) then
                retryAfter = tonumber(decoded.retry_after)
                -- The v10 API returns seconds (float); older ones ms.
                if retryAfter > 100 then retryAfter = retryAfter / 1000 end
            end
            if attempt < MAX_TRY then
                SetTimeout(math.ceil(retryAfter * 1000) + 250, function()
                    post(url, body, attempt + 1, done)
                end)
                return
            end
            stats.dropped = stats.dropped + 1
            print(('^1[apex_adminmenu] Discord rate-limited after %d attempts — message dropped.^0'):format(MAX_TRY))
            return done(false)
        end

        stats.failed = stats.failed + 1

        -- status -1 means the HTTP request itself never completed
        -- (DNS, TLS, blocked outbound). Worth calling out separately.
        if status == -1 or status == 0 then
            print('^1[apex_adminmenu] Discord request failed to leave the server (status '
                .. tostring(status) .. '). Check the machine\'s outbound HTTPS/DNS.^0')
        elseif status == 401 or status == 403 then
            print('^1[apex_adminmenu] Discord rejected the webhook (401/403) — the URL is wrong or the webhook was deleted.^0')
        elseif status == 404 then
            print('^1[apex_adminmenu] Discord webhook not found (404) — it was deleted or the URL is mistyped.^0')
        elseif status == 400 then
            print('^1[apex_adminmenu] Discord refused the payload (400): ' .. tostring(text) .. '^0')
        else
            print(('^1[apex_adminmenu] Discord webhook error %s: %s^0'):format(tostring(status), tostring(text)))
        end
        done(false)
    end, 'POST', body, { ['Content-Type'] = 'application/json' })
end

local function pump(url)
    local q = queues[url]
    if not q or q.running then return end
    q.running = true

    CreateThread(function()
        while #q.items > 0 do
            local body = table.remove(q.items, 1)
            local finished = false
            post(url, body, 1, function() finished = true end)

            -- Wait for the request to resolve, then honour the floor gap.
            local waited = 0
            while not finished and waited < 15000 do
                Wait(50); waited = waited + 50
            end
            Wait(MIN_GAP)
        end
        q.running = false
    end)
end

--- Queue a raw Discord webhook payload.
--- @param url string webhook URL
--- @param payload table { username?, avatar_url?, content?, embeds? }
--- @return boolean queued
function ApexDiscord.Send(url, payload)
    local ok, reason = ApexDiscord.ValidateUrl(url)
    if not ok then
        -- Only shout about a genuinely malformed URL. An empty one just
        -- means "this route isn't configured", which is normal.
        if reason ~= 'empty' then
            print(('^3[apex_adminmenu] Skipping Discord send — %s: %s^0'):format(reason, tostring(url)))
        end
        return false
    end
    url = trim(url)

    if type(payload) ~= 'table' then return false end

    local body = {
        username   = payload.username,
        avatar_url = payload.avatar_url,
        content    = payload.content
    }

    -- Drop a placeholder avatar rather than sending a URL that 404s.
    if body.avatar_url then
        local a = trim(body.avatar_url)
        if a == '' or a:find('XXXXXXX', 1, true) then body.avatar_url = nil else body.avatar_url = a end
    end
    if body.username then
        local u = trim(body.username)
        body.username = u ~= '' and clamp(u, 80) or nil
    end

    if type(payload.embeds) == 'table' then
        local embeds = {}
        for i = 1, #payload.embeds do
            if #embeds >= LIMITS.embeds then break end
            local e = sanitiseEmbed(payload.embeds[i])
            if e then embeds[#embeds + 1] = e end
        end
        if #embeds > 0 then body.embeds = embeds end
    end

    -- Discord requires at least content or embeds.
    if not body.content and not body.embeds then
        print('^3[apex_adminmenu] Skipping Discord send — nothing renderable in the payload.^0')
        return false
    end

    queues[url] = queues[url] or { items = {}, running = false }
    queues[url].items[#queues[url].items + 1] = json.encode(body)
    pump(url)
    return true
end

--- Convenience wrapper: send a single embed.
function ApexDiscord.SendEmbed(url, embed, identity)
    identity = identity or {}
    return ApexDiscord.Send(url, {
        username   = identity.username,
        avatar_url = identity.avatar_url,
        embeds     = { embed }
    })
end

-- ============================================================
-- Diagnostics
-- ============================================================

RegisterCommand('apexdiscord', function(src)
    if src ~= 0 then return end
    print('^5[apex_adminmenu] Discord dispatcher^0')
    print(('  sent %d · failed %d · rate-limited %d · dropped %d')
        :format(stats.sent, stats.failed, stats.rateLimited, stats.dropped))

    local pending = 0
    for _, q in pairs(queues) do pending = pending + #q.items end
    print(('  queues: %d URL(s), %d message(s) pending'):format(
        (function() local n = 0 for _ in pairs(queues) do n = n + 1 end return n end)(), pending))

    -- Panel routes (stored in the DB, edited from the F6 Settings page).
    if ApexDiscordDescribeRoutes then
        print('  panel routes:')
        for _, line in ipairs(ApexDiscordDescribeRoutes()) do print('    ' .. line) end
    end

    -- Legacy quick-menu webhook from configs/config.lua.
    local legacy = Config and Config.Webhooks
    if legacy then
        local ok, reason = ApexDiscord.ValidateUrl(legacy.url)
        print(('  config.lua webhook: %s%s'):format(
            legacy.enabled == false and 'disabled · ' or '',
            ok and 'OK' or ('not usable (' .. tostring(reason) .. ')')))
    end
end, true)

RegisterCommand('apexdiscordtest', function(src, args)
    if src ~= 0 then return end
    local url = args[1]
    if not url then
        print('^3usage: apexdiscordtest <webhook url>^0')
        return
    end
    local ok, reason = ApexDiscord.ValidateUrl(url)
    if not ok then
        print(('^1Not a usable webhook URL (%s).^0'):format(reason))
        return
    end
    ApexDiscord.SendEmbed(url, {
        title       = '✅ Apex Admin — connection test',
        description = 'If you can read this, the dispatcher reaches Discord correctly.',
        color       = 0x34C77B,
        timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }, { username = 'Apex Admin' })
    print('^2Queued. Watch this console for an error if it does not arrive.^0')
end, true)
