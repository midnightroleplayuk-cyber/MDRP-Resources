Util = {}

math.randomseed(os.time() + GetGameTimer())

local hex = '0123456789abcdef'

function Util.RandomHex(len)
    local out = {}
    for i = 1, len do
        local n = math.random(1, 16)
        out[i] = hex:sub(n, n)
    end
    return table.concat(out)
end

function Util.RandomCode()
    return ('%06d'):format(math.random(0, 999999))
end

function Util.UrlDecode(s)
    s = s:gsub('%+', ' ')
    return (s:gsub('%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end))
end

-- '/api/person?q=john' -> '/api/person', { q = 'john' }
function Util.ParsePath(path)
    local p, qs = path:match('^([^?]*)%??(.*)$')
    local query = {}
    for k, v in qs:gmatch('([^&=]+)=?([^&]*)') do
        query[Util.UrlDecode(k)] = Util.UrlDecode(v)
    end
    p = p:gsub('/+$', '')
    if p == '' then p = '/' end
    return p, query
end

function Util.Trim(s)
    if type(s) ~= 'string' then return '' end
    return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

function Util.Clamp(s, max)
    s = Util.Trim(s)
    if #s > max then s = s:sub(1, max) end
    return s
end

function Util.IpOf(address)
    if not address then return 'unknown' end
    return address:match('^%[?([^%]]+)%]?:%d+$') or address
end

function Util.DecodeJson(s)
    if type(s) ~= 'string' or s == '' then return nil end
    local ok, res = pcall(json.decode, s)
    if ok then return res end
end

function Util.Notify(src, message, kind)
    local mode = Config.Notify
    if mode == 'ox_lib' then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'MDT mobile', description = message, type = kind or 'inform', duration = 20000,
        })
    elseif mode == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, message, kind or 'primary', 20000)
    elseif mode == 'esx' then
        TriggerClientEvent('esx:showNotification', src, message)
    else
        TriggerClientEvent('chat:addMessage', src, { args = { 'MDT mobile', message } })
    end
end

-- Simple sliding one-minute counter
local buckets = {}
function Util.RateLimit(key, limit)
    local now = os.time()
    local b = buckets[key]
    if not b or now - b.start >= 60 then
        b = { start = now, count = 0 }
        buckets[key] = b
    end
    b.count = b.count + 1
    return b.count <= limit
end

CreateThread(function()
    while true do
        Wait(300000)
        local now = os.time()
        for k, b in pairs(buckets) do
            if now - b.start >= 120 then buckets[k] = nil end
        end
    end
end)
