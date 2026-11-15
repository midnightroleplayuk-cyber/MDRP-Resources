--[[
    Sign-in works the other way round to most apps, so it's safe on stream:
      1. The app or website asks for a code and shows it (anyone can see it, it's useless on its own).
      2. The officer types /mdtlink <code> in the city.
      3. Only the device that asked for the code receives the sign-in, using a secret it never shows.
]]

Auth = {}

local requests = {} -- secret id -> { code, expires, device, token?, name? }
local byCode   = {} -- code -> secret id
local tokens   = {} -- token -> { citizenid, name, device, lastUsed }

function Auth.Load()
    local rows = MySQL.query.await([[
        SELECT token, citizenid, name, device, UNIX_TIMESTAMP(last_used) AS last_used
        FROM vinewood_mdt_mobile_tokens
    ]]) or {}
    for _, r in ipairs(rows) do
        tokens[r.token] = { citizenid = r.citizenid, name = r.name, device = r.device, lastUsed = r.last_used }
    end
    print(('[vinewood_mdt_mobile] %d linked device(s) loaded'):format(#rows))
end

local function dropRequest(id)
    local r = requests[id]
    if r then byCode[r.code] = nil end
    requests[id] = nil
end

--- A device asks to sign in. Returns { id, code, expires } or nil, error
function Auth.Start(ip, device)
    if not Util.RateLimit('start:' .. ip, Config.Pairing.startsPerMin) then
        return nil, 'Too many attempts. Wait a minute and try again.'
    end
    local code
    repeat code = Util.RandomCode() until not byCode[code]
    local id = Util.RandomHex(48)
    requests[id] = { code = code, expires = os.time() + Config.Pairing.codeLifetime, device = device }
    byCode[code] = id
    return { id = id, code = code, expires = Config.Pairing.codeLifetime }
end

local function devicesFor(cid)
    local list = {}
    for t, d in pairs(tokens) do
        if d.citizenid == cid then list[#list + 1] = { token = t, lastUsed = d.lastUsed or 0 } end
    end
    table.sort(list, function(a, b) return a.lastUsed < b.lastUsed end)
    return list
end

--- The officer approves a code in game. Returns device label or nil, error
function Auth.Approve(code, player)
    if not Util.RateLimit('approve:' .. player.citizenid, 6) then
        return nil, 'Too many attempts. Wait a minute.'
    end
    local id = byCode[code]
    local r = id and requests[id]
    if not r or r.expires < os.time() or r.token then
        return nil, 'That code is wrong or has run out. Get a new one from the app or website.'
    end

    local existing = devicesFor(player.citizenid)
    while #existing >= Config.Pairing.maxDevices do
        Auth.Revoke(table.remove(existing, 1).token)
    end

    local token = Util.RandomHex(64)
    tokens[token] = { citizenid = player.citizenid, name = player.name, device = r.device, lastUsed = os.time() }
    MySQL.insert.await('INSERT INTO vinewood_mdt_mobile_tokens (token, citizenid, name, device) VALUES (?, ?, ?, ?)',
        { token, player.citizenid, player.name, r.device })
    r.token, r.name = token, player.name
    r.expires = os.time() + 60 -- device has a minute to collect it
    byCode[code] = nil
    return r.device
end

--- The device checks whether its code has been approved yet.
--- Returns 'waiting' | 'expired' | token, name
function Auth.Poll(id)
    local r = requests[id]
    if not r or r.expires < os.time() then
        dropRequest(id)
        return 'expired'
    end
    if not r.token then return 'waiting' end
    local token, name = r.token, r.name
    dropRequest(id)
    return token, name
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
    if not t then return nil, 401, 'This device is no longer linked. Sign in again.' end

    if (os.time() - (t.lastUsed or 0)) > Config.TokenIdleDays * 86400 then
        Auth.Revoke(token)
        return nil, 401, 'Signed out after not being used for a while. Sign in again.'
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
        for id, r in pairs(requests) do
            if r.expires < now then dropRequest(id) end
        end
    end
end)
