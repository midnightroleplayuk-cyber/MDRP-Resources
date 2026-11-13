Api = { routes = {} }

local VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '1.0.0'

local function forceName()
    return Config.ForceName or GetConvar('sv_projectName', GetConvar('sv_hostname', 'Police'))
end

local function audit(officer, action, detail)
    if not Config.Audit then return end
    MySQL.insert('INSERT INTO vinewood_mdt_mobile_audit (citizenid, name, action, detail) VALUES (?, ?, ?, ?)',
        { officer.citizenid, officer.name, action, detail and Util.Clamp(detail, 200) or nil })
end

local function officerOut(o, mode)
    return {
        citizenid = o.citizenid, name = o.name, callsign = o.callsign,
        grade = o.grade, gradeName = o.gradeName, job = o.jobLabel or o.job,
        mode = mode,
    }
end

local function route(method, pattern, opts, fn)
    Api.routes[#Api.routes + 1] = { method = method, pattern = '^' .. pattern .. '$', auth = opts.auth, write = opts.write, fn = fn }
end

-- Public -----------------------------------------------------------------

route('GET', '/api/ping', {}, function()
    return 200, { app = 'vinewood_mdt_mobile', version = VERSION, force = forceName() }
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

-- Signed in --------------------------------------------------------------

route('GET', '/api/me', { auth = true }, function(ctx)
    return 200, officerOut(ctx.officer, ctx.mode)
end)

route('POST', '/api/unpair', { auth = true }, function(ctx)
    Auth.Revoke(ctx.officer.token)
    return 200, { ok = true }
end)

route('GET', '/api/people', { auth = true }, function(ctx)
    local q = Util.Clamp(ctx.query.q, 60)
    if #q < 2 then return 400, { error = 'Type at least 2 characters.' } end
    audit(ctx.officer, 'person_search', q)
    return 200, { results = Adapter.SearchPeople(q) }
end)

route('GET', '/api/people/([%w%-_:]+)', { auth = true }, function(ctx, cid)
    local p = Adapter.GetProfile(cid)
    if not p then return 404, { error = 'No record found for that person.' } end
    audit(ctx.officer, 'person_view', cid)
    return 200, p
end)

route('GET', '/api/vehicles', { auth = true }, function(ctx)
    local plate = Util.Clamp(ctx.query.plate, 10):gsub('%s', ''):upper()
    if #plate < 2 then return 400, { error = 'Type at least 2 characters of the plate.' } end
    audit(ctx.officer, 'vehicle_search', plate)
    return 200, { results = Adapter.SearchVehicle(plate) }
end)

route('GET', '/api/warrants', { auth = true }, function()
    return 200, { results = Adapter.GetWarrants() }
end)

route('GET', '/api/bolos', { auth = true }, function()
    return 200, { results = Adapter.GetBolos() }
end)

route('POST', '/api/bolos', { auth = true, write = true }, function(ctx)
    local b = ctx.body or {}
    local data = {
        kind    = b.kind == 'vehicle' and 'vehicle' or 'person',
        title   = Util.Clamp(b.title, 80),
        details = Util.Clamp(b.details, 1000),
        plate   = b.kind == 'vehicle' and Util.Clamp(b.plate, 10):upper() or nil,
    }
    if #data.title < 3 then return 400, { error = 'Give the BOLO a short title.' } end
    if data.kind == 'vehicle' and (not data.plate or #data.plate < 2) then
        return 400, { error = 'Add the plate for a vehicle BOLO.' }
    end
    local bolo, err = Adapter.CreateBolo(data, ctx.officer)
    if not bolo then return 500, { error = err or 'The BOLO could not be saved.' } end
    audit(ctx.officer, 'bolo_create', data.title)
    TriggerEvent('vinewood_mdt_mobile:boloCreated', bolo, ctx.officer)
    return 200, bolo
end)

route('GET', '/api/units', { auth = true }, function()
    local out = {}
    for _, o in ipairs(Framework.GetOnlinePolice()) do
        out[#out + 1] = { name = o.name, callsign = o.callsign, gradeName = o.gradeName, onDuty = o.onDuty }
    end
    table.sort(out, function(a, b)
        if a.onDuty ~= b.onDuty then return a.onDuty end
        return (a.callsign or a.name) < (b.callsign or b.name)
    end)
    return 200, { results = out }
end)

-- Dispatcher -------------------------------------------------------------

function Api.Handle(ctx)
    for _, r in ipairs(Api.routes) do
        if r.method == ctx.method then
            local caps = { ctx.path:match(r.pattern) }
            if #caps > 0 or ctx.path:match(r.pattern) then
                if r.auth then
                    local officer, mode, msg = Auth.Authorize(ctx.headers['Authorization'] or ctx.headers['authorization'])
                    if not officer then return mode, { error = msg } end
                    if r.write and mode ~= 'live' then
                        return 403, { error = 'Read-only access. Be in the city and on duty to make changes.' }
                    end
                    ctx.officer, ctx.mode = officer, mode
                end
                return r.fn(ctx, table.unpack(caps))
            end
        end
    end
    return 404, { error = 'Not found' }
end
