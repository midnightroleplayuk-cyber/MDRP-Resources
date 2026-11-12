Logger = {}

-------------------------------------------------------------------------------
-- Discord webhooks (config/server/webhooks.lua)
-------------------------------------------------------------------------------

local wh = Config.Webhooks or { enabled = false, channels = {} }

-- Which channel each event goes to, by the start of its name (first match wins)
local ROUTES = {
    { 'staff_', 'staff' }, { 'admin_', 'staff' },
    { 'treasury_', 'money' }, { 'shop_', 'money' }, { 'laundering_', 'money' }, { 'ledger_', 'money' },
    { 'hex_', 'turf' }, { 'tag_', 'turf' },
    { 'racket_', 'rackets' }, { 'enterprise_', 'rackets' }, { 'supply_', 'rackets' },
    { 'heist_', 'heists' },
    { 'airdrop_', 'events' }, { 'auction_', 'events' }, { 'director_', 'events' }, { 'contract_', 'events' },
    { 'safehouse_', 'police' }, { 'informant_', 'police' }, { 'drugs_', 'police' }, { 'leak_', 'police' },
    { 'gang_', 'gangs' }, { 'member_', 'gangs' }, { 'rank_', 'gangs' }, { 'leadership_', 'gangs' }, { 'deal_', 'gangs' },
}

-- Friendlier titles for the common ones (everything else: "staff_item_give" -> "Staff item give")
local TITLES = {
    staff_item_give = 'Item given', staff_item_take = 'Item taken', staff_package_sent = 'Package sent',
    staff_hex_given = 'Hex given', staff_hex_removed = 'Hex removed', staff_hex_resize = 'Hexes resized',
    gang_created = 'Gang created', gang_disbanded = 'Gang disbanded', member_joined = 'Member joined',
    member_left = 'Member left', member_kicked = 'Member kicked', member_grade = 'Rank changed',
    treasury_deposit = 'Treasury deposit', treasury_withdraw = 'Treasury withdrawal',
    treasury_deposit_dirty = 'Dirty money paid in', treasury_withdraw_dirty = 'Dirty money taken out',
    shop_purchase = 'Shop purchase', laundering_started = 'Money washing started',
    hex_expand = 'Hex bought', hex_lost = 'Hex lost', racket_agreed = 'Racket agreed', racket_collected = 'Racket collected',
    heist_started = 'Heist started', heist_done = 'Heist finished', heist_failed = 'Heist failed', heist_cancelled = 'Heist cancelled',
    airdrop_called = 'Air drop called in', airdrop_opened = 'Air drop opened',
    safehouse_raid = 'Safehouse raid', safehouse_breached = 'Safehouse breached', safehouse_searched = 'Safehouse searched',
}

local ignored = {}
for _, e in ipairs(wh.ignore or {}) do ignored[e] = true end

local function urlFor(value)
    if type(value) ~= 'string' or value == '' then return nil end
    if value:sub(1, 7) == 'convar:' then
        local v = GetConvar(value:sub(8), '')
        return v ~= '' and v or nil
    end
    return value
end

local function channelOf(event)
    for _, r in ipairs(ROUTES) do
        if event:sub(1, #r[1]) == r[1] then return r[2] end
    end
    return nil
end

local function titleOf(event)
    if TITLES[event] then return TITLES[event] end
    local t = event:gsub('_', ' ')
    return t:sub(1, 1):upper() .. t:sub(2)
end

---Who did it: character name, server ID and (optionally) Discord / licence identifiers.
local function playerField(src)
    if not src or src == 0 or not GetPlayerName(src) then return nil end
    local name = GetPlayerName(src)
    local char = Bridge and Bridge.GetCharName and Bridge.GetCharName(src) or nil
    local lines = { ('**%s**%s (ID %d)'):format(char or name, char and char ~= name and (' — ' .. name) or '', src) }
    if wh.showIdentifiers ~= false then
        for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
            if id:sub(1, 8) == 'discord:' then lines[#lines + 1] = ('<@%s>'):format(id:sub(9))
            elseif id:sub(1, 8) == 'license:' then lines[#lines + 1] = ('`%s`'):format(id) end
        end
    end
    return table.concat(lines, '\n')
end

-- A queue so a burst of events doesn't hit Discord's rate limit (and anything rate-limited is retried)
local queue, sending = {}, false

local function sendNext()
    local job = table.remove(queue, 1)
    if not job then sending = false return end
    PerformHttpRequest(job.url, function(status, _, headers)
        local wait = 600
        if status == 429 then
            -- Rate limited: put it back and wait as long as Discord asks
            table.insert(queue, 1, job)
            local after = headers and (tonumber(headers['retry-after'] or headers['Retry-After'] or '') or nil)
            wait = math.floor(((after or 2) * 1000) + 250)
        end
        SetTimeout(wait, sendNext)
    end, 'POST', job.body, { ['Content-Type'] = 'application/json' })
end

local function enqueue(url, body)
    if #queue >= 200 then table.remove(queue, 1) end -- never let it grow without end
    queue[#queue + 1] = { url = url, body = body }
    if not sending then sending = true sendNext() end
end

local function toDiscord(src, event, message)
    if not wh.enabled or ignored[event] then return end
    local channel = channelOf(event)
    local targets = {}
    local cu = channel and urlFor((wh.channels or {})[channel])
    if cu then targets[#targets + 1] = cu end
    local all = urlFor(wh.everything)
    if all and all ~= cu then targets[#targets + 1] = all end
    if #targets == 0 then return end

    local fields = {}
    local who = playerField(src)
    if who then fields[#fields + 1] = { name = 'Player', value = who, inline = false } end
    local embed = {
        title = titleOf(event),
        description = tostring(message or ''):sub(1, 3500),
        color = (wh.colours or {})[channel or ''] or 9807270,
        fields = fields,
        footer = { text = ('%s · %s'):format(channel or 'other', event) },
        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    }
    local body = json.encode({ username = wh.username or 'Vinewood Gangs', avatar_url = (wh.avatar ~= '' and wh.avatar) or nil, embeds = { embed } })
    for _, url in ipairs(targets) do enqueue(url, body) end
end

Logger.Channel = channelOf -- for tests

-------------------------------------------------------------------------------

-- Uses ox_lib's logger (Datadog / Fivemanage / Loki, configured via convars in ox_lib), and Discord webhooks
function Logger.Log(src, event, message)
    lib.logger(src or 0, ('vinewood_gangs:%s'):format(event), message)
    Utils.Debug(event, message)
    local ok, err = pcall(toDiscord, src, event, message)
    if not ok then Utils.Debug('webhook', tostring(err)) end
end
