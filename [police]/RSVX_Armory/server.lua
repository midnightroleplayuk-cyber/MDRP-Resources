local CHARSET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'

local Armories = {}
local armoriesReady = false

local W = {}
local Weapons = {}
local Ammo = {}
local ammoTaken = {}

local function loadAmmo()
    Ammo = {}
    for _, r in ipairs(MySQL.query.await('SELECT item, data FROM armory_ammo ORDER BY id')) do
        local ok, a = pcall(json.decode, r.data)
        if ok and type(a) == 'table' then
            a.item = r.item
            Ammo[#Ammo + 1] = a
        end
    end
end

local function loadWeapons()
    Weapons = {}
    for k in pairs(W) do W[k] = nil end
    for _, r in ipairs(MySQL.query.await('SELECT name, data FROM armory_catalog ORDER BY id')) do
        local ok, w = pcall(json.decode, r.data)
        if ok and type(w) == 'table' then
            w.name = r.name
            Weapons[#Weapons + 1] = w
            W[r.name] = w
        end
    end
end

local rules = {}

local function loadRules()
    rules = {}
    for _, r in ipairs(MySQL.query.await('SELECT weapon, job, min_grade FROM armory_rules')) do
        rules[r.weapon] = rules[r.weapon] or {}
        rules[r.weapon][r.job] = r.min_grade
    end
end

local function minGradeFor(weapon, job)
    return (rules[weapon] and rules[weapon][job]) or Config.DefaultMinGrade
end

local function newSerial(prefix)
    while true do
        local s = ''
        for _ = 1, 8 do
            local i = math.random(#CHARSET)
            s = s .. CHARSET:sub(i, i)
        end
        s = ('%s-%s'):format(prefix, s)
        if not MySQL.scalar.await('SELECT 1 FROM armory_weapons WHERE serial = ?', { s }) then return s end
    end
end

local function addStock(weapon, qty)
    local cfg = W[weapon]
    for _ = 1, qty do
        MySQL.insert.await('INSERT INTO armory_weapons (serial, weapon, label) VALUES (?, ?, ?)',
            { newSerial(cfg.prefix), weapon, cfg.label })
    end
end

local function num(v, lo, hi)
    v = tonumber(v)
    if not v or v ~= v or v < lo or v > hi then return end
    return v
end

local function cleanOutfit(o)
    if type(o) ~= 'table' then return end
    local out = { components = {}, props = {} }
    local n = 0
    for k, c in pairs(type(o.components) == 'table' and o.components or {}) do
        local id, d, t = num(k, 0, 11), type(c) == 'table' and num(c[1], 0, 1000), type(c) == 'table' and num(c[2] or 0, 0, 100)
        if id and d and t then out.components[tostring(math.floor(id))] = { math.floor(d), math.floor(t) }; n = n + 1 end
    end
    for k, p in pairs(type(o.props) == 'table' and o.props or {}) do
        local id, d, t = num(k, 0, 7), type(p) == 'table' and num(p[1], -1, 1000), type(p) == 'table' and num(p[2] or 0, 0, 100)
        if id and d and t then out.props[tostring(math.floor(id))] = { math.floor(d), math.floor(t) }; n = n + 1 end
    end
    if n > 0 then return out end
end

local function loadArmories()
    Armories = {}
    for _, r in ipairs(MySQL.query.await('SELECT id, data FROM armory_points ORDER BY id')) do
        local ok, a = pcall(json.decode, r.data)
        if ok and type(a) == 'table' and type(a.coords) == 'table' then
            a.id = r.id
            a.outfit = cleanOutfit(a.outfit)
            a.mode = a.mode == 'target' and 'target' or 'ped'
            Armories[#Armories + 1] = a
        else
            print(('[armory_checkout] armory_points row %s is unreadable and was skipped'):format(r.id))
        end
    end
end

local function ensureColumn(tbl, col, def)
    local has = MySQL.scalar.await(
        'SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?',
        { tbl, col })
    if has == 0 then MySQL.query.await(('ALTER TABLE %s ADD COLUMN %s %s'):format(tbl, col, def)) end
end

CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_weapons (
            serial        VARCHAR(32) PRIMARY KEY,
            weapon        VARCHAR(64) NOT NULL,
            label         VARCHAR(64) NOT NULL,
            status        ENUM('in','out','lost','maint','retired') NOT NULL DEFAULT 'in',
            holder_id     VARCHAR(64) NULL,
            holder_name   VARCHAR(100) NULL,
            checked_out   INT NULL
        )
    ]])

    MySQL.query.await("ALTER TABLE armory_weapons MODIFY status ENUM('in','out','lost','maint','retired') NOT NULL DEFAULT 'in'")

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_logs (
            id            INT AUTO_INCREMENT PRIMARY KEY,
            serial        VARCHAR(32) NOT NULL,
            weapon        VARCHAR(64) NOT NULL,
            label         VARCHAR(64) NOT NULL,
            holder_id     VARCHAR(64) NOT NULL,
            holder_name   VARCHAR(100) NOT NULL,
            signature     VARCHAR(100) NULL,
            out_time      INT NOT NULL,
            in_time       INT NULL,
            duration      INT NULL,
            returned_by   VARCHAR(100) NULL,
            INDEX (serial),
            INDEX (holder_id)
        )
    ]])
    ensureColumn('armory_logs', 'signature', 'VARCHAR(100) NULL')
    ensureColumn('armory_logs', 'reason', 'VARCHAR(200) NULL')
    ensureColumn('armory_logs', 'kit', 'VARCHAR(255) NULL')
    ensureColumn('armory_logs', 'approved_by', 'VARCHAR(100) NULL')

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_rules (
            weapon      VARCHAR(64) NOT NULL,
            job         VARCHAR(50) NOT NULL,
            min_grade   INT NOT NULL,
            PRIMARY KEY (weapon, job)
        )
    ]])

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_pending (
            id          INT AUTO_INCREMENT PRIMARY KEY,
            holder_id   VARCHAR(64) NOT NULL,
            serial      VARCHAR(32) NOT NULL,
            weapon      VARCHAR(64) NOT NULL,
            created     INT NOT NULL
        )
    ]])
    loadRules()

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_points (
            id    INT AUTO_INCREMENT PRIMARY KEY,
            data  LONGTEXT NOT NULL
        )
    ]])
    if MySQL.scalar.await('SELECT COUNT(*) FROM armory_points') == 0 then
        for _, a in ipairs(Config.Armories) do
            local c = a.coords
            local seed = {
                label = a.label, mode = 'ped', coords = { x = c.x, y = c.y, z = c.z, w = c.w },
                model = a.model, scenario = a.scenario, blip = a.blip or false,
                weapons = a.weapons, ammo = a.ammo, jobs = a.jobs, outfit = a.outfit,
            }
            MySQL.insert.await('INSERT INTO armory_points (data) VALUES (?)', { json.encode(seed) })
        end
    end
    loadArmories()
    armoriesReady = true

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_catalog (
            id    INT AUTO_INCREMENT PRIMARY KEY,
            name  VARCHAR(64) NOT NULL UNIQUE,
            data  LONGTEXT NOT NULL
        )
    ]])
    if MySQL.scalar.await('SELECT COUNT(*) FROM armory_catalog') == 0 then
        for _, w in ipairs(Config.Weapons) do
            MySQL.insert.await('INSERT INTO armory_catalog (name, data) VALUES (?, ?)', { w.name, json.encode({
                label = w.label, prefix = w.prefix, stock = w.stock, desc = w.desc, kit = w.kit,
                requireReason = w.requireReason or false, approval = w.approval or false,
            }) })
        end
    end
    loadWeapons()

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS armory_ammo (
            id    INT AUTO_INCREMENT PRIMARY KEY,
            item  VARCHAR(64) NOT NULL UNIQUE,
            data  LONGTEXT NOT NULL
        )
    ]])
    if MySQL.scalar.await('SELECT COUNT(*) FROM armory_ammo') == 0 then
        for _, a in ipairs(Config.Ammo or {}) do
            MySQL.insert.await('INSERT INTO armory_ammo (item, data) VALUES (?, ?)', { a.item, json.encode({ label = a.label, amount = a.amount, desc = a.desc }) })
        end
    end
    loadAmmo()

    for _, w in ipairs(Weapons) do
        local have = MySQL.scalar.await('SELECT COUNT(*) FROM armory_weapons WHERE weapon = ?', { w.name })
        if w.stock > have then addStock(w.name, w.stock - have) end
    end
    print('[armory_checkout] stock ready')
end)

local function inList(list, v)
    for _, x in ipairs(list) do if x == v then return true end end
    return false
end

local function getOfficer(src)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end
    local d = player.PlayerData
    if not d.job.onduty then
        return { id = d.citizenid, name = '', police = false, command = false, can = {} }
    end
    local police = inList(Config.PoliceJobs, d.job.name)
    local command = police and d.job.grade.level >= Config.CommandGrade
    return {
        id = d.citizenid,
        name = ('%s %s'):format(d.charinfo.firstname, d.charinfo.lastname),
        police = police,
        job = d.job.name,
        grade = d.job.grade.level,
        command = command,

        can = (function()
            local ace = IsPlayerAceAllowed(src, 'armory.admin')
            local can = {}
            for tab, grade in pairs(Config.TabGrades) do
                can[tab] = ace or (police and d.job.grade.level >= grade)
            end
            return can
        end)(),
    }
end

local function notify(src, kind, text)
    TriggerClientEvent('ox_lib:notify', src, { type = kind, description = text })
end

local function fail(msg) return { ok = false, msg = msg } end

local function armorySerial(slot)
    return type(slot) == 'table' and type(slot.metadata) == 'table' and slot.metadata.serial
end

local function isSignedOut(serial)
    return serial and MySQL.scalar.await('SELECT 1 FROM armory_weapons WHERE serial = ? AND status = "out"', { serial }) ~= nil
end

exports.ox_inventory:registerHook('swapItems', function(p)
    if p.toInventory == p.fromInventory then return true end
    local leaving = p.fromType == 'player' and armorySerial(p.fromSlot)
    local swappedOut = p.toType == 'player' and armorySerial(p.toSlot)
    if isSignedOut(leaving) or isSignedOut(swappedOut) then
        notify(p.source, 'error', 'Armory weapons cannot leave your inventory. Return it at an armory.')
        return false
    end
    return true
end, {})

local function fmtDuration(s)
    s = math.max(0, math.floor(tonumber(s) or 0))
    local h, m, sec = s // 3600, (s % 3600) // 60, s % 60
    if h > 0 then return ('%dh %dm %ds'):format(h, m, sec) end
    if m > 0 then return ('%dm %ds'):format(m, sec) end
    return ('%ds'):format(sec)
end

local function fmtTime(t)
    return t and os.date('%d/%m/%Y %H:%M:%S', t) or '-'
end

local function trim(s) return (tostring(s or ''):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')) end

local function fmtLog(r, now)
    r.out_str = fmtTime(r.out_time)
    r.in_str = r.in_time and fmtTime(r.in_time) or nil
    r.duration_str = fmtDuration(r.duration or (now - r.out_time))
    return r
end

local function nearArmory(src)
    local pos = GetEntityCoords(GetPlayerPed(src))
    local best, bestDist = nil, Config.UseDistance + 3.0
    for _, a in ipairs(Armories) do
        local dist = #(pos - vec3(a.coords.x, a.coords.y, a.coords.z))
        if dist <= bestDist then best, bestDist = a, dist end
    end
    return best
end

local function armoryOffers(armory, weapon)
    if not armory.weapons then return true end
    return inList(armory.weapons, weapon)
end

local function accessArmory(src)
    local o = getOfficer(src)
    if not o or not o.police then return end
    local a = nearArmory(src)
    if not a or not inList(a.jobs or Config.PoliceJobs, o.job) then return end
    return o, a
end

local function findOxSlot(src, weapon, serial)
    local slots = exports.ox_inventory:Search(src, 'slots', weapon)
    for _, slot in pairs(slots or {}) do
        if slot.metadata and slot.metadata.serial == serial then return slot end
    end
end

local function sortedKit(weapon)
    local kit = W[weapon] and W[weapon].kit
    if not kit then return {} end
    local names = {}
    for item in pairs(kit) do names[#names + 1] = item end
    table.sort(names)
    return names, kit
end

local function kitLabel(weapon)
    local names, kit = sortedKit(weapon)
    local parts = {}
    for _, item in ipairs(names) do parts[#parts + 1] = ('%s x%d'):format(item, kit[item]) end
    return table.concat(parts, ', ')
end

local function giveKit(src, weapon)
    local names, kit = sortedKit(weapon)
    local parts = {}
    for _, item in ipairs(names) do
        if exports.ox_inventory:AddItem(src, item, kit[item]) then parts[#parts + 1] = ('%s x%d'):format(item, kit[item]) end
    end
    return #parts > 0 and table.concat(parts, ', ') or nil
end

local function takeKit(src, weapon)
    local names, kit = sortedKit(weapon)
    for _, item in ipairs(names) do
        local have = exports.ox_inventory:Search(src, 'count', item) or 0
        local n = math.min(have, kit[item])
        if n > 0 then exports.ox_inventory:RemoveItem(src, item, n) end
    end
end

local function completeReturn(serial, returnedBy, newStatus)
    local row = MySQL.single.await('SELECT weapon, label FROM armory_weapons WHERE serial = ? AND status = "out"', { serial })
    if not row then return false end
    local n = MySQL.update.await(
        'UPDATE armory_weapons SET status = ?, holder_id = NULL, holder_name = NULL, checked_out = NULL WHERE serial = ? AND status = "out"',
        { newStatus or 'in', serial })
    if n ~= 1 then return false end
    local t = os.time()
    MySQL.update.await(
        'UPDATE armory_logs SET in_time = ?, duration = ? - out_time, returned_by = ? WHERE serial = ? AND in_time IS NULL ORDER BY id DESC LIMIT 1',
        { t, t, returnedBy, serial })
    return row
end

local function stripWeapon(holderId, weapon, serial)
    local player = exports.qbx_core:GetPlayerByCitizenId(holderId)
    if player then
        local src = player.PlayerData.source
        local slot = findOxSlot(src, weapon, serial)
        if slot then
            exports.ox_inventory:RemoveItem(src, weapon, 1, nil, slot.slot)
            takeKit(src, weapon)
            return 'removed'
        end
    end
    MySQL.insert.await('INSERT INTO armory_pending (holder_id, serial, weapon, created) VALUES (?, ?, ?, ?)',
        { holderId, serial, weapon, os.time() })
    return 'queued'
end

local function forceReturnSerial(serial, byText, newStatus)
    local row = MySQL.single.await('SELECT weapon, label, holder_id FROM armory_weapons WHERE serial = ? AND status = "out"', { serial })
    if not row then return false end
    if not completeReturn(serial, byText, newStatus) then return false end
    row.removed = stripWeapon(row.holder_id, row.weapon, serial)
    return row
end

local function requestApproval(requesterSrc, o, labels, reason)
    local approvers = {}
    for _, id in ipairs(GetPlayers()) do
        id = tonumber(id)
        if id ~= requesterSrc then
            local a = getOfficer(id)
            if a and a.police and a.grade >= Config.ApproverGrade then approvers[#approvers + 1] = id end
        end
    end
    if #approvers == 0 then return nil, 'No supervisor is on duty to approve this request.' end

    notify(requesterSrc, 'inform', 'Waiting for supervisor approval...')

    local approvedBy
    local pending = #approvers
    local info = { who = o.name, items = table.concat(labels, ', '), reason = reason ~= '' and reason or 'None given' }
    for _, id in ipairs(approvers) do
        CreateThread(function()
            local yes = lib.callback.await('armory:askApproval', id, info)
            if yes and not approvedBy then
                local a = getOfficer(id)
                approvedBy = a and a.name or 'Supervisor'
            end
            pending = pending - 1
        end)
    end

    local deadline = GetGameTimer() + Config.ApprovalTimeout * 1000
    while not approvedBy and pending > 0 and GetGameTimer() < deadline do Wait(250) end

    for _, id in ipairs(approvers) do TriggerClientEvent('armory:closeApproval', id) end
    if approvedBy then return approvedBy end
    return nil, pending == 0 and 'Your request was denied.' or 'No supervisor responded in time.'
end

local busy = {}

local function issue(src, o, serials, signature, reason, summary)
    if trim(signature):lower() ~= trim(o.name):lower() then return fail('Signature does not match your name.') end
    reason = trim(reason):sub(1, 200)

    local out = MySQL.scalar.await('SELECT COUNT(*) FROM armory_weapons WHERE status = "out" AND holder_id = ?', { o.id })
    if out + #serials > Config.MaxOut then
        return fail(('You can have %d weapons out at once (you have %d).'):format(Config.MaxOut, out))
    end

    local armory = nearArmory(src)
    local list, needReason, needApproval = {}, false, false
    for _, serial in ipairs(serials) do
        local w = MySQL.single.await('SELECT weapon, label, status FROM armory_weapons WHERE serial = ?', { serial })
        if not w then return fail('Unknown weapon.') end
        if w.status ~= 'in' then return fail('That weapon is not available.') end
        if not armoryOffers(armory, w.weapon) then return fail('This armory does not issue that weapon.') end
        if o.grade < minGradeFor(w.weapon, o.job) then return fail('Your rank is not authorised to sign out this weapon.') end
        local cfg = W[w.weapon] or {}
        if cfg.requireReason then needReason = true end
        if cfg.approval then needApproval = true end
        list[#list + 1] = { serial = serial, weapon = w.weapon, label = w.label }
    end
    if needReason and #reason < 3 then return fail('A reason for issue is required.') end

    local approvedBy
    if needApproval and o.grade < Config.ApproverGrade then
        local labels = {}
        for _, item in ipairs(list) do labels[#labels + 1] = item.label end
        local who, err = requestApproval(src, o, labels, reason)
        if not who then return fail(err) end
        approvedBy = who

        local o2, a2 = accessArmory(src)
        if not o2 or not a2 then return fail('You are no longer at the armory.') end
    end

    local t = os.time()
    local function release(items)
        for _, item in ipairs(items) do
            MySQL.update.await('UPDATE armory_weapons SET status = "in", holder_id = NULL, holder_name = NULL, checked_out = NULL WHERE serial = ?', { item.serial })
        end
    end

    local claimed = {}
    for _, item in ipairs(list) do
        local n = MySQL.update.await(
            'UPDATE armory_weapons SET status = "out", holder_id = ?, holder_name = ?, checked_out = ? WHERE serial = ? AND status = "in"',
            { o.id, o.name, t, item.serial })
        if n ~= 1 then release(claimed) return fail('That weapon was just taken.') end
        claimed[#claimed + 1] = item
    end

    local given = {}
    for _, item in ipairs(list) do
        if not exports.ox_inventory:AddItem(src, item.weapon, 1, { serial = item.serial }) then
            for _, g in ipairs(given) do
                local slot = findOxSlot(src, g.weapon, g.serial)
                if slot then exports.ox_inventory:RemoveItem(src, g.weapon, 1, nil, slot.slot) end
            end
            release(claimed)
            return fail('You cannot carry that.')
        end
        given[#given + 1] = item
    end

    for _, item in ipairs(list) do
        local kit = giveKit(src, item.weapon)
        MySQL.insert.await(
            'INSERT INTO armory_logs (serial, weapon, label, holder_id, holder_name, signature, reason, kit, approved_by, out_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            { item.serial, item.weapon, item.label, o.id, o.name, trim(signature):sub(1, 100),
              reason ~= '' and reason or nil, kit, approvedBy, t })
    end

    return { ok = true, msg = summary or ('Checked out %s (%s)'):format(list[1].label, list[1].serial) }
end

lib.callback.register('armory:getData', function(src)
    local o, armory = accessArmory(src)
    if not o then return false end

    local rows = MySQL.query.await('SELECT serial, weapon FROM armory_weapons WHERE status = "in" ORDER BY serial')
    local serialsBy, counts = {}, {}
    for _, r in ipairs(rows) do
        serialsBy[r.weapon] = serialsBy[r.weapon] or {}
        table.insert(serialsBy[r.weapon], r.serial)
        counts[r.weapon] = (counts[r.weapon] or 0) + 1
    end

    local available = {}
    for _, w in ipairs(Weapons) do
        if armoryOffers(armory, w.name) then
            local minGrade = minGradeFor(w.name, o.job)
            available[#available + 1] = {
                name = w.name, label = w.label, desc = w.desc or '',
                serials = serialsBy[w.name] or {},
                minGrade = minGrade, allowed = o.grade >= minGrade,
                reason = w.requireReason or false,
                approval = (w.approval and o.grade < Config.ApproverGrade) or false,
                kit = kitLabel(w.name),
            }
        end
    end

    local ammo = {}
    for _, a in ipairs(Ammo) do
        if not armory.ammo or inList(armory.ammo, a.item) then
            local cap = Config.AmmoPerShift or 0
            local taken = ammoTaken[o.id] and ammoTaken[o.id][a.item] or 0
            ammo[#ammo + 1] = { item = a.item, label = a.label, amount = a.amount, desc = a.desc or '', left = cap > 0 and math.max(0, cap - taken) or nil }
        end
    end

    local mine = MySQL.query.await(
        'SELECT serial, weapon, label, checked_out FROM armory_weapons WHERE status = "out" AND holder_id = ? ORDER BY checked_out',
        { o.id })
    for _, m in ipairs(mine) do m.since = fmtTime(m.checked_out) end

    return { name = o.name, command = o.command, can = o.can, available = available, ammo = ammo, mine = mine }
end)

lib.callback.register('armory:checkout', function(src, serial, signature, reason)
    if busy[src] then return fail('Please wait...') end
    busy[src] = true
    local ok, res = pcall(function()
        local o = accessArmory(src)
        if not o then return fail('No access.') end
        return issue(src, o, { tostring(serial) }, signature, reason)
    end)
    busy[src] = nil
    if not ok then print('[armory_checkout] checkout error: ' .. tostring(res)) return fail('Something went wrong.') end
    return res
end)

lib.callback.register('armory:return', function(src, serial)
    local o = accessArmory(src)
    if not o then return fail('No access.') end

    local row = MySQL.single.await('SELECT weapon, holder_id FROM armory_weapons WHERE serial = ? AND status = "out"', { serial })
    if not row or row.holder_id ~= o.id then return fail('That weapon is not signed out to you.') end

    local slot = findOxSlot(src, row.weapon, serial)
    if not slot then return fail('You do not have that weapon on you.') end

    local newStatus = 'in'
    local dur = slot.metadata and tonumber(slot.metadata.durability)
    if Config.ServiceBelow > 0 and dur and dur < Config.ServiceBelow then newStatus = 'maint' end

    exports.ox_inventory:RemoveItem(src, row.weapon, 1, nil, slot.slot)
    takeKit(src, row.weapon)

    local done = completeReturn(serial, o.name, newStatus)
    if not done then return fail('Return failed.') end
    local msg = ('Returned %s (%s)'):format(done.label, serial)
    if newStatus == 'maint' then msg = msg .. ' - flagged for maintenance' end
    return { ok = true, msg = msg }
end)

local ammoCooldown = {}

lib.callback.register('armory:takeAmmo', function(src, item)
    local o, armory = accessArmory(src)
    if not o then return fail('No access.') end
    local cfg
    for _, a in ipairs(Ammo) do
        if a.item == item then cfg = a end
    end
    if not cfg or (armory.ammo and not inList(armory.ammo, item)) then return fail('This armory does not hand that out.') end

    local key = o.id .. ':' .. item
    local wait = (ammoCooldown[key] or 0) + Config.AmmoCooldown - os.time()
    if wait > 0 then return fail(('Please wait %d seconds before taking more.'):format(wait)) end

    local cap = Config.AmmoPerShift or 0
    local taken = ammoTaken[o.id] and ammoTaken[o.id][item] or 0
    if cap > 0 and taken >= cap then return fail(('You have taken all the %s allowed this shift.'):format(cfg.label)) end

    if not exports.ox_inventory:AddItem(src, item, cfg.amount) then return fail('You cannot carry that.') end
    ammoCooldown[key] = os.time()
    ammoTaken[o.id] = ammoTaken[o.id] or {}
    ammoTaken[o.id][item] = taken + 1
    return { ok = true, msg = ('Took %d x %s'):format(cfg.amount, cfg.label), left = cap > 0 and cap - taken - 1 or nil }
end)

lib.callback.register('armory:reportLost', function(src, serial)
    local o = getOfficer(src)
    if not o or not o.police then return fail('No access.') end
    local row = MySQL.single.await('SELECT holder_id FROM armory_weapons WHERE serial = ? AND status = "out"', { serial })
    if not row or row.holder_id ~= o.id then return fail('That weapon is not signed out to you.') end
    local done = forceReturnSerial(serial, ('REPORTED LOST by %s'):format(o.name), 'lost')
    if not done then return fail('Could not report that weapon.') end
    print(('[armory_checkout] %s reported %s (%s) lost'):format(o.name, done.label, serial))
    return { ok = true, msg = ('%s (%s) reported lost and removed from circulation.'):format(done.label, serial) }
end)

lib.callback.register('armory:getOut', function(src)
    local o = getOfficer(src)
    if not o or not o.command then return false end
    local rows = MySQL.query.await('SELECT serial, label, holder_id, holder_name, checked_out FROM armory_weapons WHERE status = "out" ORDER BY checked_out')
    local t = os.time()
    for _, r in ipairs(rows) do
        r.since = fmtTime(r.checked_out)
        r.elapsed = fmtDuration(t - r.checked_out)
        r.online = exports.qbx_core:GetPlayerByCitizenId(r.holder_id) ~= nil
    end
    return rows
end)

local function likeEscape(s) return (s:gsub('[\\%%_]', '\\%0')) end

local function parseDate(s)
    local y, m, d = tostring(s or ''):match('^(%d%d%d%d)-(%d%d)-(%d%d)$')
    if not y then return nil end
    return os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 0 })
end

lib.callback.register('armory:getHistory', function(src, page, filters)
    local o = getOfficer(src)
    if not o or not o.police then return false end
    filters = type(filters) == 'table' and filters or {}
    page = math.max(1, tonumber(page) or 1)
    local size = Config.HistoryPageSize

    local where, params = { '1=1' }, {}
    if not o.command or filters.mine then
        where[#where + 1] = 'holder_id = ?'
        params[#params + 1] = o.id
    else
        local officer, serial = trim(filters.officer), trim(filters.serial)
        if officer ~= '' then where[#where + 1] = 'holder_name LIKE ?' params[#params + 1] = '%' .. likeEscape(officer) .. '%' end
        if serial ~= '' then where[#where + 1] = 'serial LIKE ?' params[#params + 1] = '%' .. likeEscape(serial:upper()) .. '%' end
        local from, to = parseDate(filters.from), parseDate(filters['to'])
        if from then where[#where + 1] = 'out_time >= ?' params[#params + 1] = from end
        if to then where[#where + 1] = 'out_time < ?' params[#params + 1] = to + 86400 end
    end
    params[#params + 1] = size + 1
    params[#params + 1] = (page - 1) * size

    local rows = MySQL.query.await(
        'SELECT * FROM armory_logs WHERE ' .. table.concat(where, ' AND ') .. ' ORDER BY id DESC LIMIT ? OFFSET ?', params)
    local more = #rows > size
    if more then rows[#rows] = nil end
    local t = os.time()
    for _, r in ipairs(rows) do fmtLog(r, t) end
    return { rows = rows, more = more, page = page }
end)

lib.callback.register('armory:lookup', function(src, serial)
    local o = getOfficer(src)
    if not o or not o.can.lookup then return false end
    serial = trim(serial):upper():gsub('%s', '')
    local w = MySQL.single.await('SELECT serial, weapon, label, status, holder_name, checked_out FROM armory_weapons WHERE serial = ?', { serial })
    if not w then return { found = false } end
    if w.checked_out then w.since = fmtTime(w.checked_out) end
    local rows = MySQL.query.await('SELECT * FROM armory_logs WHERE serial = ? ORDER BY id DESC LIMIT 50', { serial })
    local t = os.time()
    for _, r in ipairs(rows) do fmtLog(r, t) end
    return { found = true, weapon = w, rows = rows }
end)

lib.callback.register('armory:forceReturn', function(src, serial)
    local o = getOfficer(src)
    if not o or not o.command then return fail('No access.') end
    local done = forceReturnSerial(serial, ('%s (command override)'):format(o.name), 'in')
    if not done then return fail('That weapon is not signed out.') end
    local extra = done.removed == 'removed' and 'Removed from their inventory.' or 'It will be removed from their inventory when it is next found on them.'
    return { ok = true, msg = ('%s (%s) returned. %s'):format(done.label, serial, extra) }
end)

lib.callback.register('armory:markLost', function(src, serial)
    local o = getOfficer(src)
    if not o or not o.command then return fail('No access.') end
    local done = forceReturnSerial(serial, ('LOST - marked by %s'):format(o.name), 'lost')
    if not done then return fail('That weapon is not signed out.') end
    return { ok = true, msg = ('%s (%s) marked lost.'):format(done.label, serial) }
end)

local TRANSITIONS = {
    ['in'] = { maint = true, retired = true },
    maint = { ['in'] = true, retired = true },
    lost = { ['in'] = true, retired = true },
    retired = { ['in'] = true },
}

local FILTERS = {
    attention = 'status IN ("maint","lost")',
    ['in'] = 'status = "in"',
    retired = 'status = "retired"',
}

lib.callback.register('armory:getStock', function(src, filter)
    local o = getOfficer(src)
    if not o or not o.can.stock then return false end

    local by = {}
    for _, r in ipairs(MySQL.query.await('SELECT weapon, status, COUNT(*) AS c FROM armory_weapons GROUP BY weapon, status')) do
        by[r.weapon] = by[r.weapon] or {}
        by[r.weapon][r.status] = r.c
    end
    local summary = {}
    for _, w in ipairs(Weapons) do
        summary[#summary + 1] = { name = w.name, label = w.label, counts = by[w.name] or {} }
    end

    local cond = FILTERS[filter] or FILTERS.attention
    local rows = MySQL.query.await(
        'SELECT serial, weapon, label, status, holder_name FROM armory_weapons WHERE ' .. cond .. ' ORDER BY label, serial LIMIT 100')
    return { summary = summary, rows = rows }
end)

lib.callback.register('armory:addStock', function(src, weapon, qty)
    local o = getOfficer(src)
    if not o or not o.can.stock then return fail('No access.') end
    qty = math.tointeger(tonumber(qty))
    if not W[weapon] or not qty or qty < 1 or qty > 50 then return fail('Invalid amount.') end
    addStock(weapon, qty)
    print(('[armory_checkout] %s added %d x %s'):format(o.name, qty, weapon))
    return { ok = true, msg = ('Added %d x %s with new serials.'):format(qty, W[weapon].label) }
end)

lib.callback.register('armory:setStatus', function(src, serial, status)
    local o = getOfficer(src)
    if not o or not o.can.stock then return fail('No access.') end
    local row = MySQL.single.await('SELECT status FROM armory_weapons WHERE serial = ?', { serial })
    if not row or not (TRANSITIONS[row.status] and TRANSITIONS[row.status][status]) then return fail('That change is not allowed.') end
    local n = MySQL.update.await('UPDATE armory_weapons SET status = ? WHERE serial = ? AND status = ?', { status, serial, row.status })
    if n ~= 1 then return fail('Status changed in the meantime.') end
    print(('[armory_checkout] %s set %s: %s -> %s'):format(o.name, serial, row.status, status))
    return { ok = true, msg = 'Updated.' }
end)

lib.callback.register('armory:getRules', function(src)
    local o = getOfficer(src)
    if not o or not o.can.rules then return false end

    local allJobs = exports.qbx_core:GetJobs()
    local jobs = {}
    for _, name in ipairs(Config.PoliceJobs) do
        local j = allJobs[name]
        local grades = {}
        if j then
            for lvl, g in pairs(j.grades) do grades[#grades + 1] = { level = tonumber(lvl), name = g.name } end
            table.sort(grades, function(a, b) return a.level < b.level end)
        end
        jobs[#jobs + 1] = { name = name, label = j and j.label or name, grades = grades }
    end

    local weapons = {}
    for _, w in ipairs(Weapons) do
        weapons[#weapons + 1] = { name = w.name, label = w.label, rules = rules[w.name] or {} }
    end
    return { jobs = jobs, weapons = weapons, default = Config.DefaultMinGrade }
end)

lib.callback.register('armory:setRule', function(src, weapon, job, grade)
    local o = getOfficer(src)
    if not o or not o.can.rules then return fail('No access.') end

    if not W[weapon] or not inList(Config.PoliceJobs, job) then return fail('Invalid rule.') end

    if grade == nil then
        MySQL.update.await('DELETE FROM armory_rules WHERE weapon = ? AND job = ?', { weapon, job })
    else
        grade = math.tointeger(tonumber(grade))
        if not grade or grade < 0 or grade > 99 then return fail('Invalid grade.') end
        MySQL.update.await(
            'INSERT INTO armory_rules (weapon, job, min_grade) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE min_grade = VALUES(min_grade)',
            { weapon, job, grade })
    end
    loadRules()
    print(('[armory_checkout] %s changed rank access: %s / %s -> %s'):format(o.name, weapon, job, grade or 'default'))
    return { ok = true, msg = 'Rank access updated.' }
end)

lib.addCommand('armorylog', { help = 'Open the armory weapon log (command staff)' }, function(src)
    local o = getOfficer(src)
    if o and (o.command or o.can.lookup or o.can.stock or o.can.rules) then
        TriggerClientEvent('armory:openLog', src, nil, { command = o.command, can = o.can })
    end
end)

lib.addCommand('checkserial', {
    help = 'Look up a weapon serial and its history (command staff)',
    params = { { name = 'serial', type = 'string', help = 'Weapon serial number' } },
}, function(src, args)
    local o = getOfficer(src)
    if o and o.can.lookup then TriggerClientEvent('armory:openLog', src, args.serial, { command = o.command, can = o.can }) end
end)

local function isAdmin(src) return IsPlayerAceAllowed(src, 'armory.admin') end

local function publicPoints()
    local out = {}
    for _, a in ipairs(Armories) do
        out[#out + 1] = {
            id = a.id, label = a.label, mode = a.mode, coords = a.coords, radius = a.radius,
            model = a.model, scenario = a.scenario, blip = a.blip, jobs = a.jobs, outfit = a.outfit,
        }
    end
    return out
end

lib.callback.register('armory:points', function()
    while not armoriesReady do Wait(200) end
    return publicPoints()
end)

lib.callback.register('armory:adminGet', function(src)
    if not isAdmin(src) then return false end
    local weapons, ammo, jobs = {}, {}, {}
    for _, w in ipairs(Weapons) do weapons[#weapons + 1] = { name = w.name, label = w.label } end
    for _, a in ipairs(Ammo) do ammo[#ammo + 1] = { item = a.item, label = a.label } end
    for name, j in pairs(exports.qbx_core:GetJobs()) do jobs[#jobs + 1] = { name = name, label = j.label or name } end
    table.sort(jobs, function(a, b) return a.name < b.name end)
    return { points = Armories, weapons = weapons, catalog = Weapons, ammo = ammo, ammoCatalog = Ammo, jobs = jobs, policeJobs = Config.PoliceJobs }
end)

local function pick(list, valid)
    if type(list) ~= 'table' then return end
    local out = {}
    for _, v in ipairs(list) do
        if valid[v] and not inList(out, v) then out[#out + 1] = v end
    end
    return out
end

lib.callback.register('armory:adminSave', function(src, d)
    if not isAdmin(src) then return fail('No access.') end
    if type(d) ~= 'table' or type(d.coords) ~= 'table' then return fail('Invalid data.') end

    local label = trim(d.label):sub(1, 40)
    if label == '' then return fail('Give the armory a name.') end
    local x, y, z, w = num(d.coords.x, -10000, 10000), num(d.coords.y, -10000, 10000), num(d.coords.z, -1000, 3000), num(d.coords.w or 0, 0, 360)
    if not (x and y and z and w) then return fail('Set a valid position.') end

    local validW, validA, validJ = {}, {}, {}
    for _, cw in ipairs(Weapons) do validW[cw.name] = true end
    for _, ca in ipairs(Ammo) do validA[ca.item] = true end
    for name in pairs(exports.qbx_core:GetJobs()) do validJ[name] = true end

    local a = {
        label = label,
        mode = d.mode == 'target' and 'target' or 'ped',
        coords = { x = x, y = y, z = z, w = w },
        radius = num(d.radius or 1.0, 0.5, 2.0) or 1.0,
        blip = d.blip == true,
        weapons = pick(d.weapons, validW),
        ammo = pick(d.ammo, validA),
        jobs = pick(d.jobs, validJ),
        model = trim(d.model):sub(1, 50),
        scenario = trim(d.scenario):sub(1, 60),
        outfit = cleanOutfit(d.outfit),
    }
    if a.jobs and #a.jobs == 0 then a.jobs = nil end
    if a.mode == 'ped' and a.model == '' then return fail('Choose a ped model.') end
    if a.scenario == '' then a.scenario = nil end

    local id = math.tointeger(tonumber(d.id))
    if id then
        if MySQL.update.await('UPDATE armory_points SET data = ? WHERE id = ?', { json.encode(a), id }) == 0
            and not MySQL.scalar.await('SELECT 1 FROM armory_points WHERE id = ?', { id }) then
            return fail('That armory no longer exists.')
        end
    else
        MySQL.insert.await('INSERT INTO armory_points (data) VALUES (?)', { json.encode(a) })
    end
    loadArmories()
    TriggerClientEvent('armory:sync', -1, publicPoints())
    print(('[armory_checkout] %s (%s) saved armory "%s"'):format(GetPlayerName(src), src, label))
    return { ok = true, msg = 'Armory saved.', points = Armories }
end)

lib.callback.register('armory:adminDelete', function(src, id)
    if not isAdmin(src) then return fail('No access.') end
    id = math.tointeger(tonumber(id))
    if not id then return fail('Invalid armory.') end
    MySQL.update.await('DELETE FROM armory_points WHERE id = ?', { id })
    loadArmories()
    TriggerClientEvent('armory:sync', -1, publicPoints())
    print(('[armory_checkout] %s (%s) deleted armory %d'):format(GetPlayerName(src), src, id))
    return { ok = true, msg = 'Armory deleted.', points = Armories }
end)


lib.callback.register('armory:weaponNames', function()
    local names = {}
    for _, w in ipairs(Weapons) do names[#names + 1] = w.name end
    for _, a in ipairs(Ammo) do names[#names + 1] = a.item end
    return names
end)

local function itemExists(name)
    local ok, item = pcall(function() return exports.ox_inventory:Items(name) end)
    return ok and item ~= nil and item ~= false
end

local function pickerList()
    local out = {}
    for _, w in ipairs(Weapons) do out[#out + 1] = { name = w.name, label = w.label } end
    return out
end

lib.callback.register('armory:adminSaveWeapon', function(src, d)
    if not isAdmin(src) then return fail('No access.') end
    if type(d) ~= 'table' then return fail('Invalid data.') end

    local name = trim(d.name):upper()
    if not name:match('^WEAPON_[A-Z0-9_]+$') or #name > 64 then return fail('Item name must look like WEAPON_PISTOL.') end
    if not itemExists(name) then return fail(('ox_inventory has no item called %s.'):format(name)) end
    local isNew = d.isNew == true
    if isNew and W[name] then return fail('That weapon already exists.') end
    if not isNew and not W[name] then return fail('That weapon no longer exists.') end

    local label = trim(d.label):sub(1, 40)
    if label == '' then return fail('Give the weapon a display name.') end
    local prefix = trim(d.prefix):upper()
    if not prefix:match('^[A-Z0-9][A-Z0-9][A-Z0-9]?[A-Z0-9]?$') then return fail('Serial prefix must be 2-4 letters or numbers.') end
    local stock = num(d.stock or 0, 0, 500)
    if not stock then return fail('Stock must be 0 - 500.') end

    local kit, kitCount = {}, 0
    for item, amount in pairs(type(d.kit) == 'table' and d.kit or {}) do
        amount = num(amount, 1, 1000)
        if type(item) ~= 'string' or not amount or not itemExists(item) then return fail(('Unknown ammo item or amount: %s'):format(tostring(item))) end
        kit[item] = math.floor(amount)
        kitCount = kitCount + 1
    end
    if kitCount > 6 then return fail('Too many ammo items (max 6).') end
    if kitCount == 0 then kit = nil end

    local data = {
        label = label, prefix = prefix, stock = math.floor(stock), desc = trim(d.desc):sub(1, 120), kit = kit,
        requireReason = d.requireReason == true, approval = d.approval == true,
    }
    if isNew then
        MySQL.insert.await('INSERT INTO armory_catalog (name, data) VALUES (?, ?)', { name, json.encode(data) })
    else
        MySQL.update.await('UPDATE armory_catalog SET data = ? WHERE name = ?', { json.encode(data), name })
        MySQL.update.await('UPDATE armory_weapons SET label = ? WHERE weapon = ?', { label, name })
    end
    loadWeapons()

    local have = MySQL.scalar.await('SELECT COUNT(*) FROM armory_weapons WHERE weapon = ?', { name })
    if data.stock > have then addStock(name, data.stock - have) end

    print(('[armory_checkout] %s (%s) saved weapon %s'):format(GetPlayerName(src), src, name))
    return { ok = true, msg = 'Weapon saved.', catalog = Weapons, weapons = pickerList() }
end)

lib.callback.register('armory:adminDeleteWeapon', function(src, name)
    if not isAdmin(src) then return fail('No access.') end
    if type(name) ~= 'string' or not W[name] then return fail('That weapon no longer exists.') end
    local out = MySQL.scalar.await('SELECT COUNT(*) FROM armory_weapons WHERE weapon = ? AND status = "out"', { name })
    if out > 0 then return fail(('%d still signed out. Wait until they are returned.'):format(out)) end
    MySQL.update.await('UPDATE armory_weapons SET status = "retired" WHERE weapon = ? AND status IN ("in", "maint")', { name })
    MySQL.update.await('DELETE FROM armory_catalog WHERE name = ?', { name })
    MySQL.update.await('DELETE FROM armory_rules WHERE weapon = ?', { name })
    loadWeapons()
    print(('[armory_checkout] %s (%s) deleted weapon %s'):format(GetPlayerName(src), src, name))
    return { ok = true, msg = 'Weapon removed. Existing serials were retired.', catalog = Weapons, weapons = pickerList() }
end)


local function ammoPicker()
    local out = {}
    for _, a in ipairs(Ammo) do out[#out + 1] = { item = a.item, label = a.label } end
    return out
end

lib.callback.register('armory:adminSaveAmmo', function(src, d)
    if not isAdmin(src) then return fail('No access.') end
    if type(d) ~= 'table' then return fail('Invalid data.') end

    local item = trim(d.item):lower()
    if not item:match('^[%w_%-]+$') or #item > 64 then return fail('Invalid item name.') end
    if not itemExists(item) then return fail(('ox_inventory has no item called %s.'):format(item)) end
    local isNew = d.isNew == true
    local exists = MySQL.scalar.await('SELECT 1 FROM armory_ammo WHERE item = ?', { item })
    if isNew and exists then return fail('That ammo already exists.') end
    if not isNew and not exists then return fail('That ammo no longer exists.') end

    local label = trim(d.label):sub(1, 40)
    if label == '' then return fail('Give the ammo a display name.') end
    local amount = num(d.amount, 1, 1000)
    if not amount then return fail('Amount per click must be 1 - 1000.') end

    local data = { label = label, amount = math.floor(amount), desc = trim(d.desc):sub(1, 80) }
    if isNew then
        MySQL.insert.await('INSERT INTO armory_ammo (item, data) VALUES (?, ?)', { item, json.encode(data) })
    else
        MySQL.update.await('UPDATE armory_ammo SET data = ? WHERE item = ?', { json.encode(data), item })
    end
    loadAmmo()
    print(('[armory_checkout] %s (%s) saved ammo %s'):format(GetPlayerName(src), src, item))
    return { ok = true, msg = 'Ammo saved.', ammoCatalog = Ammo, ammo = ammoPicker() }
end)

lib.callback.register('armory:adminDeleteAmmo', function(src, item)
    if not isAdmin(src) then return fail('No access.') end
    if type(item) ~= 'string' then return fail('Invalid ammo.') end
    MySQL.update.await('DELETE FROM armory_ammo WHERE item = ?', { item })
    loadAmmo()
    print(('[armory_checkout] %s (%s) deleted ammo %s'):format(GetPlayerName(src), src, item))
    return { ok = true, msg = 'Ammo removed.', ammoCatalog = Ammo, ammo = ammoPicker() }
end)

lib.addCommand('armoryadmin', { help = 'Set up armories: ped or third-eye, position, clothing, contents (admin)' }, function(src)
    if isAdmin(src) then TriggerClientEvent('armory:openAdmin', src) end
end)

local offSince = {}
local PENDING_MAX_AGE = 14 * 86400

local function sweep()
    local ar = Config.AutoReturn
    local now = os.time()

    for cid in pairs(ammoTaken) do
        local player = exports.qbx_core:GetPlayerByCitizenId(cid)
        local d = player and player.PlayerData
        if not d or not d.job.onduty or not inList(Config.PoliceJobs, d.job.name) then ammoTaken[cid] = nil end
    end

    for _, r in ipairs(MySQL.query.await('SELECT serial, weapon, label, holder_id FROM armory_weapons WHERE status = "out"')) do
        local player = exports.qbx_core:GetPlayerByCitizenId(r.holder_id)
        if player then
            local d = player.PlayerData
            if inList(Config.PoliceJobs, d.job.name) and d.job.onduty then
                offSince[r.holder_id] = nil
            elseif ar.offDuty then
                if not offSince[r.holder_id] then
                    offSince[r.holder_id] = now
                    notify(d.source, 'warning', ('You are off duty. Armory weapons will be taken back in %d seconds.'):format(ar.grace))
                end
                if now - offSince[r.holder_id] >= ar.grace then
                    local done = forceReturnSerial(r.serial, 'AUTO-RETURN (went off duty)', 'in')
                    if done then notify(d.source, 'inform', ('%s was returned to the armory.'):format(r.label)) end
                end
            end
        else
            offSince[r.holder_id] = nil
        end
    end

    for _, p in ipairs(MySQL.query.await('SELECT id, holder_id, serial, weapon, created FROM armory_pending')) do
        local player = exports.qbx_core:GetPlayerByCitizenId(p.holder_id)
        local done = false
        if player then
            local src = player.PlayerData.source
            local slot = findOxSlot(src, p.weapon, p.serial)
            if slot then
                exports.ox_inventory:RemoveItem(src, p.weapon, 1, nil, slot.slot)
                takeKit(src, p.weapon)
                notify(src, 'inform', 'An armory weapon that was returned while you were away has been taken back.')
                done = true
            end
        end
        if done or now - p.created > PENDING_MAX_AGE then
            MySQL.update.await('DELETE FROM armory_pending WHERE id = ?', { p.id })
        end
    end
end

CreateThread(function()
    Wait(10000)
    while true do
        local ok, err = pcall(sweep)
        if not ok then print('[armory_checkout] auto-return error: ' .. tostring(err)) end
        Wait(math.max(5, Config.AutoReturn.interval) * 1000)
    end
end)
