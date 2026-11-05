Informants = {}

local cfg = Config.Informants
local DAY = 86400
local sources = {}       -- sources[citizenid] = { code, tips, earned, day, tipsToday, active }
local kindCooldown = {}  -- kindCooldown[citizenid][kind] = os.time() it ends
local targetCooldown = {} -- targetCooldown[targetKey] = os.time() it ends

local function today() return math.floor(os.time() / DAY) end

local function save(cid)
    local s = sources[cid]
    MySQL.prepare('UPDATE vg_informants SET tips = ?, earned = ?, day = ?, tips_today = ?, active = ? WHERE citizenid = ?',
        { s.tips, s.earned, s.day, s.tipsToday, s.active and 1 or 0, cid })
end

local function newCode()
    for _ = 1, 50 do
        local code = ('CHIS-%04X'):format(math.random(0, 0xFFFF))
        local taken = false
        for _, s in pairs(sources) do if s.code == code then taken = true break end end
        if not taken then return code end
    end
    return ('CHIS-%d'):format(os.time() % 100000)
end

local function grading(s, kind)
    local source = s.tips >= cfg.reliableAfter and '1' or '2'
    return source .. (cfg.tips[kind].grade or 'B') .. cfg.handlingCode
end

-------------------------------------------------------------------------------
-- What this member could tell the police about their own gang
-------------------------------------------------------------------------------

local function optionList(gang, cid)
    local opts = {}
    for _, h in ipairs(Safehouses and Safehouses.OwnedBy(gang.id) or {}) do
        opts[#opts + 1] = { key = 'safehouse:' .. h.id, kind = 'safehouse', label = locale('tip_safehouse', h.label), target = h }
    end
    for _, e in ipairs(Enterprises and Enterprises.ForGang(gang.id) or {}) do
        local h = Safehouses.Get(e.safehouseId)
        if h then
            opts[#opts + 1] = { key = 'enterprise:' .. e.id, kind = 'enterprise', label = locale('tip_enterprise', Config.Enterprises.types[e.type].label, h.label), target = { e = e, h = h } }
        end
    end
    local shops = Rackets and Rackets.ProtectedBy(gang.id) or {}
    if #shops > 0 then
        opts[#opts + 1] = { key = 'rackets:' .. gang.id, kind = 'rackets', label = locale('tip_rackets', #shops), target = shops }
    end
    for _, run in ipairs(Supply and Supply.ActiveRuns(gang.id) or {}) do
        opts[#opts + 1] = { key = 'run:supply:' .. run.id, kind = 'run', label = locale('tip_run_supply'), target = run }
    end
    local job = Contracts and Contracts.ActiveFor(gang.id)
    if job and job.coords then
        opts[#opts + 1] = { key = 'run:contract:' .. job.id, kind = 'run', label = locale('tip_run_contract', job.title), target = job }
    end
    for _, m in ipairs(Gangs.GetMembers(gang.id)) do
        if m.citizenid ~= cid then
            opts[#opts + 1] = { key = 'member:' .. m.citizenid, kind = 'member', label = locale('tip_member', m.name, m.rank), target = m }
        end
    end
    return opts
end

local function blocked(cid, opt)
    local now = os.time()
    local s = sources[cid]
    if s.day == today() and s.tipsToday >= cfg.maxTipsPerDay then return 'informant_daily' end
    local kc = kindCooldown[cid] and kindCooldown[cid][opt.kind]
    if kc and kc > now then return 'informant_wait', math.ceil((kc - now) / 60) end
    if targetCooldown[opt.key] and targetCooldown[opt.key] > now then return 'informant_known' end
    return nil
end

-------------------------------------------------------------------------------
-- Turning a tip into police intelligence
-------------------------------------------------------------------------------

local function zoneOf(p) return Zones.FromCoords(vector3(p.x, p.y, p.z)) end

local filers = {}

function filers.safehouse(s, gang, h, kind)
    Intel.CreateLead({
        gangId = gang.id, source = 'informant', precision = 'exact', zone = zoneOf(h.entrance), force = true,
        summary = ('%s uses a property at %s as a safehouse.'):format(gang.label, h.address),
        subject = { type = 'place', id = ('safehouse_%d'):format(h.id), label = h.address }, grading = grading(s, kind),
    })
    return ('the safehouse at %s'):format(h.label)
end

function filers.enterprise(s, gang, t, kind)
    local ty = Config.Enterprises.types[t.e.type]
    Intel.CreateLead({
        gangId = gang.id, source = 'informant', precision = 'exact', zone = zoneOf(t.h.entrance), force = true,
        summary = ('%s is running a %s at %s.'):format(gang.label, ty.label:lower(), t.h.address),
        subject = { type = 'place', id = ('safehouse_%d'):format(t.h.id), label = t.h.address }, grading = grading(s, kind),
    })
    return ('the %s'):format(ty.label:lower())
end

function filers.rackets(s, gang, shops, kind)
    Intel.CreateLead({
        gangId = gang.id, source = 'informant', precision = 'exact', force = true,
        summary = ('%s is taking protection money from: %s.'):format(gang.label, table.concat(shops, ', ')):sub(1, 255),
        subject = { type = 'place', id = 'rackets_' .. gang.id, label = 'Businesses paying ' .. gang.label }, grading = grading(s, kind),
    })
    return 'the protection rackets'
end

function filers.member(s, gang, m, kind)
    Intel.CreateLead({
        gangId = gang.id, citizenid = m.citizenid, source = 'informant', precision = 'exact', force = true,
        summary = ('%s is a member of %s (%s).'):format(m.name, gang.label, m.rank),
        subject = { type = 'person', id = m.citizenid, label = m.name }, grading = grading(s, kind),
    })
    return ('who %s is'):format(m.name)
end

function filers.run(s, gang, run, kind)
    Bridge.Dispatch.Alert({
        title = 'Informant: criminal movement in progress', code = 'INTEL', priority = 2, coords = run.coords, approximate = true,
        description = ('A source reports %s moving %s in this area right now.%s'):format(gang.label,
            run.title and ('on "' .. run.title .. '"') or 'drug supplies', run.plate and (' Vehicle plate ' .. run.plate .. '.') or ''),
    })
    Intel.CreateLead({
        gangId = gang.id, source = 'informant', precision = 'area', zone = Zones.FromCoords(run.coords), force = true,
        summary = ('Source reported %s moving goods in real time.'):format(gang.label), grading = grading(s, kind),
    })
    return run.plate and 'the supply run' or 'the job'
end

local function onlineMembers(gangId)
    local out = {}
    for _, m in ipairs(Gangs.GetMembers(gangId)) do
        if m.online then out[#out + 1] = m.citizenid end
    end
    return out
end

local function recordLeak(gang, cid, kind, detail)
    local id = MySQL.insert.await('INSERT INTO vg_informant_leaks (gang_id, kind, detail, informant, online, created_at) VALUES (?, ?, ?, ?, ?, ?)',
        { gang.id, kind, detail, cid, json.encode(onlineMembers(gang.id)), os.time() })
    if not id or math.random() >= cfg.suspicionChance then return end

    local delay = math.random(cfg.reportDelay[1], cfg.reportDelay[2]) * 60000
    SetTimeout(delay, function()
        if not Gangs.Get(gang.id) then return end
        MySQL.update('UPDATE vg_informant_leaks SET reported = 1 WHERE id = ?', { id })
        -- Leaders only: anyone who can manage members
        for _, m in ipairs(Gangs.GetMembers(gang.id)) do
            if m.online and Gangs.HasPermission(m.citizenid, 'manage_members') then
                local src = Bridge.GetSourceFromCitizenId(m.citizenid)
                if src then Bridge.Notify(src, locale('leak_suspected', detail), 'error') end
            end
        end
    end)
end

-------------------------------------------------------------------------------
-- Phone menu
-------------------------------------------------------------------------------

function Informants.Menu(src)
    if not Config.Modules.informants then return nil, 'invalid' end
    local cid = Bridge.GetCitizenId(src)
    if not cid then return nil, 'no_player' end
    local s = sources[cid]
    if not s or not s.active then return { registered = false, stopped = s ~= nil } end

    local gang = Gangs.GetPlayerGang(src)
    local out = {}
    if gang then
        for _, opt in ipairs(optionList(gang, cid)) do
            local why, minutes = blocked(cid, opt)
            out[#out + 1] = { key = opt.key, label = opt.label, pay = cfg.tips[opt.kind].pay,
                blocked = why and locale(why, minutes) or nil }
        end
    end
    return { registered = true, code = s.code, tips = s.tips, earned = s.earned, inGang = gang ~= nil, options = out,
        left = math.max(0, cfg.maxTipsPerDay - (s.day == today() and s.tipsToday or 0)) }
end

function Informants.Register(src)
    if not Config.Modules.informants then return false, 'invalid' end
    local cid = Bridge.GetCitizenId(src)
    if not cid then return false, 'no_player' end
    if sources[cid] then return false, sources[cid].active and 'informant_already' or 'informant_stopped' end
    if cfg.item and not Bridge.HasItem(src, cfg.item, 1) then return false, 'informant_need_phone' end

    local code = newCode()
    MySQL.insert.await('INSERT INTO vg_informants (citizenid, code) VALUES (?, ?)', { cid, code })
    sources[cid] = { code = code, tips = 0, earned = 0, day = today(), tipsToday = 0, active = true }
    Logger.Log(src, 'informant_registered', ('%s registered as %s'):format(cid, code))
    return true, code
end

function Informants.Tip(src, key)
    if not Config.Modules.informants then return false, 'invalid' end
    local cid = Bridge.GetCitizenId(src)
    local s = cid and sources[cid]
    if not s or not s.active then return false, 'invalid' end
    if cfg.item and not Bridge.HasItem(src, cfg.item, 1) then return false, 'informant_need_phone' end
    local gang = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end

    local opt
    for _, o in ipairs(optionList(gang, cid)) do if o.key == key then opt = o break end end
    if not opt then return false, 'informant_stale' end
    local why = blocked(cid, opt)
    if why then return false, why end

    local detail = filers[opt.kind](s, gang, opt.target, opt.kind)
    local tip = cfg.tips[opt.kind]
    local now = os.time()
    kindCooldown[cid] = kindCooldown[cid] or {}
    kindCooldown[cid][opt.kind] = now + tip.cooldown * 60
    targetCooldown[opt.key] = now + tip.targetHours * 3600

    if s.day ~= today() then s.day, s.tipsToday = today(), 0 end
    s.tips, s.tipsToday, s.earned = s.tips + 1, s.tipsToday + 1, s.earned + tip.pay
    save(cid)
    Bridge.AddMoney(src, 'cash', tip.pay, 'informant-payment')
    recordLeak(gang, cid, opt.kind, detail)
    Logger.Log(src, 'informant_tip', ('%s (%s) leaked %s about gang %d'):format(s.code, cid, opt.key, gang.id))
    return true, tip.pay
end

-------------------------------------------------------------------------------
-- Gang leaders: suspicious activity and looking into it
-------------------------------------------------------------------------------

function Informants.Leaks(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'manage_members') then return { canSee = false } end
    local rows = MySQL.query.await('SELECT id, detail, suspects, created_at FROM vg_informant_leaks WHERE gang_id = ? AND reported = 1 ORDER BY id DESC LIMIT 10', { gang.id }) or {}
    local out = {}
    for _, r in ipairs(rows) do
        local ok, suspects = pcall(json.decode, r.suspects or 'null')
        out[#out + 1] = { id = r.id, detail = r.detail, ago = os.time() - r.created_at, suspects = ok and suspects or nil }
    end
    return { canSee = true, leaks = out, cost = cfg.investigateCost, enabled = Config.Modules.informants }
end

function Informants.Investigate(src, leakId)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'manage_members') then return false, 'no_permission' end
    local leak = MySQL.single.await('SELECT id, informant, online, suspects FROM vg_informant_leaks WHERE id = ? AND gang_id = ? AND reported = 1', { tonumber(leakId), gang.id })
    if not leak then return false, 'invalid' end
    if leak.suspects then return false, 'leak_already_checked' end

    local ok = Ledger.Transact(gang.id, 'dirty', -cfg.investigateCost, 'investigation', { citizenid = cid, refType = 'leak', refId = leak.id })
    if not ok then return false, 'insufficient_funds' end

    local okOnline, online = pcall(json.decode, leak.online)
    online = okOnline and online or {}
    local pool, list = {}, {}
    for _, c in ipairs(online) do
        if c ~= leak.informant and c ~= cid then pool[#pool + 1] = c end
    end
    -- The real source makes the list most of the time, if they were around
    local includeSource = math.random() < cfg.investigateAccuracy
    if includeSource then list[#list + 1] = leak.informant end
    while #list < cfg.shortlistSize and #pool > 0 do
        list[#list + 1] = table.remove(pool, math.random(#pool))
    end
    -- Shuffle so position gives nothing away
    for i = #list, 2, -1 do
        local j = math.random(i)
        list[i], list[j] = list[j], list[i]
    end

    local names = {}
    for _, c in ipairs(list) do
        local m = Gangs.GetMembership(c)
        names[#names + 1] = m and m.name or locale('former_member')
    end
    MySQL.update.await('UPDATE vg_informant_leaks SET suspects = ? WHERE id = ?', { json.encode(names), leak.id })
    Logger.Log(src, 'leak_investigated', ('%s investigated leak %d (source listed: %s)'):format(cid, leak.id, tostring(includeSource)))
    return true, names
end

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

function Informants.AdminList()
    local out = {}
    for cid, s in pairs(sources) do
        local m = Gangs.GetMembership(cid)
        local g = m and Gangs.Get(m.gangId)
        out[#out + 1] = { citizenid = cid, code = s.code, name = m and m.name or cid, gang = g and g.label or nil,
            tips = s.tips, earned = s.earned, active = s.active }
    end
    table.sort(out, function(a, b) return a.tips > b.tips end)
    return out
end

function Informants.AdminSetActive(src, cid, active)
    local s = sources[tostring(cid)]
    if not s then return false, 'invalid' end
    s.active = active == true
    save(tostring(cid))
    Logger.Log(src, 'staff_informant', ('%s set %s'):format(s.code, s.active and 'active' or 'stopped'))
    return true
end

function Informants.Load()
    sources = {}
    for _, r in ipairs(MySQL.query.await('SELECT citizenid, code, tips, earned, day, tips_today, active FROM vg_informants')) do
        sources[r.citizenid] = { code = r.code, tips = r.tips, earned = r.earned, day = r.day, tipsToday = r.tips_today,
            active = r.active == 1 or r.active == true }
    end
end

function Informants.Start()
    if not Config.Modules.informants then return end
    if cfg.item then
        Bridge.RegisterUsableItem(cfg.item, function(src)
            TriggerClientEvent('vinewood_gangs:client:burner', src)
        end)
    end
end
