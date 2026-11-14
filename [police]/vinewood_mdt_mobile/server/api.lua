Api = { routes = {} }

local VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '2.0.0'
local MDT = Config.MDTResource

local function forceName()
    return Config.ForceName or GetConvar('sv_projectName', GetConvar('sv_hostname', 'Police'))
end

local function mdt() return exports[MDT] end

local function route(method, pattern, opts, fn)
    Api.routes[#Api.routes + 1] = { method = method, pattern = '^' .. pattern .. '$', auth = opts.auth, fn = fn }
end

-- The MDT's own web files, sent to the app so phones always run the same UI version as the server
local uiCache
local function loadUi()
    local version = GetResourceMetadata(MDT, 'version', 0) or '0'
    if uiCache and uiCache.version == version then return uiCache end
    local html = LoadResourceFile(MDT, 'web/index.html')
    local css  = LoadResourceFile(MDT, 'web/style.css')
    local js   = LoadResourceFile(MDT, 'web/app.js')
    if not html or not css or not js then return nil end
    uiCache = { version = version, html = html, css = css, js = js }
    return uiCache
end

-- Public -----------------------------------------------------------------

route('GET', '/api/ping', {}, function()
    return 200, { app = 'vinewood_mdt_mobile', version = VERSION, force = forceName(),
        mdt = GetResourceState(MDT) == 'started' }
end)

route('POST', '/api/pair', {}, function(ctx)
    local code = Util.Trim(tostring(ctx.body and ctx.body.code or '')):gsub('%D', '')
    local device = Util.Clamp(ctx.body and ctx.body.device or 'Android phone', 60)
    if #code ~= 6 then return 400, { error = 'Enter the 6-digit code from /' .. Config.Commands.link .. '.' } end
    local token, p = Auth.Pair(code, device, ctx.ip)
    if not token then return 401, { error = p } end
    print(('[vinewood_mdt_mobile] %s (%s) linked a phone: %s'):format(p.name, p.citizenid, device))
    return 200, { token = token, name = p.name, force = forceName() }
end)

-- MDT images (crest etc.) referenced as nui:// paths. Images only.
local IMAGE_TYPES = { png = 'image/png', jpg = 'image/jpeg', jpeg = 'image/jpeg', webp = 'image/webp', svg = 'image/svg+xml', gif = 'image/gif' }
route('GET', '/asset', {}, function(ctx)
    local path = tostring(ctx.query.path or '')
    local ext = path:match('%.(%w+)$')
    if path:find('%.%.') or not ext or not IMAGE_TYPES[ext:lower()] then return 404, { error = 'Not found' } end
    local data = LoadResourceFile(MDT, path)
    if not data then return 404, { error = 'Not found' } end
    return 200, data, IMAGE_TYPES[ext:lower()]
end)

-- Signed in --------------------------------------------------------------

route('GET', '/api/me', { auth = true }, function(ctx)
    return 200, { name = ctx.user.name, role = ctx.user.role, force = forceName() }
end)

-- Works even when out of the city, so a phone can always sign itself out
route('POST', '/api/unpair', {}, function(ctx)
    local h = ctx.headers['Authorization'] or ctx.headers['authorization']
    local token = h and h:match('^Bearer%s+(%x+)$')
    if token then Auth.Revoke(token) end
    return 200, { ok = true }
end)

route('GET', '/api/ui', { auth = true }, function(ctx)
    local ui = loadUi()
    if not ui then return 503, { error = 'The MDT files could not be loaded. Is ' .. MDT .. ' started?' } end
    if ctx.query.v == ui.version then return 200, { version = ui.version, same = true } end
    return 200, ui
end)

-- Every MDT action: same permission checks, audit and webhooks as the tablet
route('POST', '/api/mdt', { auth = true }, function(ctx)
    local b = ctx.body or {}
    if type(b.action) ~= 'string' then return 400, { error = 'Unknown request.' } end
    return 200, mdt():MobileRequest(ctx.user.src, b.action, type(b.data) == 'table' and b.data or {}) or {}
end)

route('POST', '/api/location', { auth = true }, function(ctx)
    return 200, mdt():MobileLocation(ctx.user.src) or {}
end)

route('POST', '/api/waypoint', { auth = true }, function(ctx)
    local b = ctx.body or {}
    mdt():MobileWaypoint(ctx.user.src, b.x, b.y)
    return 200, { ok = true }
end)

route('POST', '/api/respond', { auth = true }, function(ctx)
    mdt():MobileRespond(ctx.user.src, ctx.body or {})
    return 200, { ok = true }
end)

-- Dispatcher -------------------------------------------------------------

function Api.Handle(ctx)
    for _, r in ipairs(Api.routes) do
        if r.method == ctx.method and ctx.path:match(r.pattern) then
            if r.auth then
                if GetResourceState(MDT) ~= 'started' then
                    return 503, { error = 'The MDT isn’t running on the server right now.' }
                end
                local user, status, msg = Auth.Authorize(ctx.headers['Authorization'] or ctx.headers['authorization'])
                if not user then return status, { error = msg } end
                ctx.user = user
            end
            return r.fn(ctx)
        end
    end
    return 404, { error = 'Not found' }
end
