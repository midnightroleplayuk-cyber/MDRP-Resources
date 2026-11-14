Auth = {}

local pending = {} -- code -> { citizenid, name, expires }
local tokens  = {} -- token -> { citizenid, name, device, lastUsed }

function Auth.Load()
    local rows = MySQL.query.await([[
        SELECT token, citizenid, name, device, UNIX_TIMESTAMP(last_used) AS last_used
        FROM vinewood_mdt_mobile_tokens
    ]]) or {}
    for _, r in ipairs(rows) do
        tokens[r.token] = { citizenid = r.citizenid, name = r.name, device = r.device, lastUsed = r.last_used }
    end
    print(('[vinewood_mdt_mobile] %d linked phone(s) loaded'):format(#rows))
end

function Auth.CreateCode(player)
    for code, p in pairs(pending) do
        if p.citizenid == player.citizenid then pending[code] = nil end
    end
    local code
    repeat code = Util.RandomCode() until not pending[code]
    pending[code] = { citizenid = player.citizenid, name = player.name, expires = os.time() + Config.Pairing.codeLifetime }
    return code
end

local function devicesFor(cid)
    local list = {}
    for t, d in pairs(tokens) do
        if d.citizenid == cid then list[#list + 1] = { token = t, lastUsed = d.lastUsed or 0 } end
    end
    table.sort(list, function(a, b) return a.lastUsed < b.lastUsed end)
    return list
end

function Auth.Pair(code, device, ip)
    if not Util.RateLimit('pair:' .. ip, Config.Pairing.attemptsPerMin) then
        return nil, 'Too many attempts. Wait a minute and try again.'
    end
    local p = pending[code]
    if not p or p.expires < os.time() then
        pending[code] = nil
        return nil, 'That code is wrong or has expired. Type /' .. Config.Commands.link .. ' in the city for a new one.'
    end
    pending[code] = nil

    local existing = devicesFor(p.citizenid)
    while #existing >= Config.Pairing.maxDevices do
        Auth.Revoke(table.remove(existing, 1).token)
    end

    local token = Util.RandomHex(64)
    tokens[token] = { citizenid = p.citizenid, name = p.name, device = device, lastUsed = os.time() }
    MySQL.insert.await('INSERT INTO vinewood_mdt_mobile_tokens (token, citizenid, name, device) VALUES (?, ?, ?, ?)',
        { token, p.citizenid, p.name, device })
    return token, p
end

function Auth.Revoke(token)
    if not tokens[token] then return end
    tokens[token] = nil
    MySQL.query('DELETE FROM vinewood_mdt_mobile_tokens WHERE token = ?', { token })
end

function Auth.RevokeAll(cid)
    local n = 0
    for t, d in pairs(tokens) do
        if d.citizenid == cid then tokens[t] = nil; n = n + 1 end
    end
    MySQL.query('DELETE FROM vinewood_mdt_mobile_tokens WHERE citizenid = ?', { cid })
    return n
end

--- Returns { src, citizenid, name, role, token } or nil, status, message
function Auth.Authorize(header)
    local token = header and header:match('^Bearer%s+(%x+)$')
    local t = token and tokens[token]
    if not t then return nil, 401, 'This phone is no longer linked. Link it again.' end

    if (os.time() - (t.lastUsed or 0)) > Config.TokenIdleDays * 86400 then
        Auth.Revoke(token)
        return nil, 401, 'Signed out after not being used for a while. Link it again.'
    end
    if not Util.RateLimit('req:' .. token, Config.RequestsPerMin) then
        return nil, 429, 'Too many requests. Wait a moment.'
    end
    if os.time() - (t.lastUsed or 0) > 300 then
        MySQL.update('UPDATE vinewood_mdt_mobile_tokens SET last_used = NOW() WHERE token = ?', { token })
    end
    t.lastUsed = os.time()

    local player = Framework.GetByCitizenId(t.citizenid)
    if not player then
        return nil, 403, 'You need to be in the city to use the MDT.'
    end
    local role = exports[Config.MDTResource]:MobileAccess(player.source)
    if not role then
        return nil, 403, 'You don’t have MDT access right now. Check you’re on duty.'
    end
    return { src = player.source, citizenid = t.citizenid, name = player.name, role = role, token = token }
end

CreateThread(function()
    while true do
        Wait(30000)
        local now = os.time()
        for code, p in pairs(pending) do
            if p.expires < now then pending[code] = nil end
        end
    end
end)
