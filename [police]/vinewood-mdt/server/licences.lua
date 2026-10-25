-- Licence checks across several licensing scripts.
-- Every source returns a block: { source, title, items = { {label, status, detail} }, ...extra }
Licences = {}

local function safe(fn, ...)
    local r = table.pack(pcall(fn, ...))
    if r[1] then return table.unpack(r, 2, r.n) end
    print(('[vinewood-mdt] licence lookup error: %s'):format(r[2]))
end

---------------------------------------------------------------------------
-- DVLA driver record: vinewood_licensing (new) or citydriving (older name).
-- Categories, endorsements, totting up, bans, and (vinewood_licensing) an
-- offline queue: points and bans issued while the driver is offline apply at login.
---------------------------------------------------------------------------
local function dvlaCfg() return Config.Licences.dvla or Config.Licences.citydriving end

--- The running licensing resource: exports object, name, supportsQueue
function Licences.DvlaResource()
    local cfg = dvlaCfg()
    if not cfg or cfg.enabled == false then return nil end
    local names = cfg.resources or { cfg.resource or 'citydriving' }
    for _, name in ipairs(names) do
        if Schema.Running(name) then
            -- vinewood_licensing queues offline actions; older citydriving builds don't.
            local queue = name ~= 'citydriving'
            if not queue then
                local ok = pcall(function() return exports[name]:GetPendingActions('') end)
                queue = ok
            end
            return exports[name], name, queue
        end
    end
end


-- The licensing script keeps a flat mirror table of every driver record, written
-- on each change and on disconnect. It holds things that otherwise only exist on
-- the physical item (licence number, photo, address), so an offline lookup can
-- show a full record rather than just categories and points.
local RECORDS = 'vinewood_licensing_records'

local function recordsTable()
    return Schema.Has(RECORDS, 'citizenid', 'licence_number')
end

--- The mirror row for a driver, or nil.
function Licences.DvlaRecord(cid)
    if not cid or not recordsTable() then return nil end
    local row = MySQL.single.await(('SELECT * FROM %s WHERE citizenid = ?'):format(RECORDS), { cid })
    if type(row) ~= 'table' then return nil end
    if type(row.endorsements) == 'string' then
        row.endorsements = Bridge.Decode(row.endorsements) or {}
    end
    return row
end

--- Citizen ids matching a licence number (or name) — lets officers search by
--- the number on a licence they are holding.
function Licences.FindCids(q)
    if not q or #q < 3 or not recordsTable() then return {} end
    local like = '%' .. q .. '%'
    local rows = MySQL.query.await(([[
        SELECT citizenid FROM %s
        WHERE licence_number LIKE ? OR lastname LIKE ? OR firstname LIKE ?
        LIMIT 20
    ]]):format(RECORDS), { like, like, like }) or {}
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = r.citizenid end
    return out
end

local function now() return os.time() end

-- Offline: read the saved character straight from the database. The MDT does this itself
-- rather than relying on the licence script's offline lookups, so an offline driver's
-- licence, points and ban always show.
local function offlineMeta(cid)
    if Bridge.Framework() == 'esx' or not Schema.Has('players', 'citizenid', 'metadata') then return nil end
    local row = MySQL.single.await('SELECT metadata FROM players WHERE citizenid = ?', { cid })
    if not row then return nil end
    local meta = Bridge.Decode(row.metadata)
    return type(meta) == 'table' and meta or nil
end

local function offlineRecord(cid)
    local meta = offlineMeta(cid)
    return meta and type(meta.dvla) == 'table' and meta.dvla or nil
end

local function endorsementsFrom(rec)
    local list, total = {}, 0
    for _, e in ipairs(type(rec) == 'table' and (rec.points or {}) or {}) do
        local expires = tonumber(e.expires)
        if not expires or expires > now() then
            list[#list + 1] = e
            total = total + (tonumber(e.points) or 0)
        end
    end
    return total, list
end

local function banFrom(rec)
    local b = type(rec) == 'table' and rec.ban or nil
    if type(b) ~= 'table' then return false, nil end
    local untilTs = tonumber(b.until_ or b['until'])
    if b.permanent or (untilTs and untilTs > now()) then return true, b end
    return false, nil
end

local function categoryLabel(cat)
    local labels = (dvlaCfg() or {}).categoryLabels or {}
    return labels[cat] or (tostring(cat):gsub('^%l', string.upper))
end

local function dvla(cid, src)
    local res, resName, queue = Licences.DvlaResource()
    if not res then return nil end
    local id = src or cid

    local data = safe(function() return res:GetLicenceData(id) end) or {}

    -- Offline driver: take licence categories, points and ban from the saved character.
    local meta = not src and offlineMeta(cid) or nil
    if meta then
        local saved = type(meta.licences) == 'table' and meta.licences or {}
        local fromExport = type(data.licences) == 'table' and data.licences or {}
        local merged = {}
        for k, v in pairs(fromExport) do merged[k] = v end
        for k, v in pairs(saved) do if merged[k] == nil or v == true then merged[k] = v end end
        data.licences = merged
    end
    local block = {
        source = resName,
        title = 'DVLA driver record',
        dvla = true,
        online = src ~= nil,
        queue = queue,
        -- With the queue, officers can endorse and disqualify offline drivers too.
        canEndorse = src ~= nil or queue,
        canRevoke = src ~= nil,
        number = data.number,
        categories = data.categories,
        issued = data.issued,
        expiry = data.expiry,
        photo = data.photo,
        address = data.address,
        provisional = data.hasProvisional or data.provisionalOnly or false,
        items = {},
    }

    -- Offline: the mirror table carries what the physical licence holds
    if not src then
        local row = safe(Licences.DvlaRecord, cid)
        if row then
            -- Empty strings from the export count as missing, so the saved values are used.
            local function pick(a, b)
                if a ~= nil and a ~= '' then return a end
                if b ~= nil and b ~= '' then return b end
                return nil
            end
            block.number = pick(block.number, row.licence_number)
            block.categories = pick(block.categories, row.categories)
            block.issued = pick(block.issued, row.issued)
            block.expiry = pick(block.expiry, row.expiry)
            block.photo = pick(block.photo, row.photo)
            block.address = pick(block.address, row.address)
            -- oxmysql returns TINYINT(1) as true/false, other drivers as 1/0
            if block.provisional == false then block.provisional = row.provisional == true or row.provisional == 1 end
            block.record = true
        end
    end

    -- Endorsements (+ queued ones still waiting for the driver to log in)
    local total, endorsements, queued = safe(function() return res:GetPoints(id) end)
    if total == nil and data.points ~= nil then
        total, endorsements = tonumber(data.points), data.endorsements
    end
    local offlineRec
    if meta then
        -- Offline: the saved record is the truth for current endorsements.
        offlineRec = type(meta.dvla) == 'table' and meta.dvla or nil
        total, endorsements = endorsementsFrom(offlineRec)
    elseif total == nil then
        offlineRec = offlineRecord(cid)
        total, endorsements = endorsementsFrom(offlineRec)
    end
    block.points = tonumber(total) or 0
    block.endorsements = endorsements or {}
    block.queuedPoints = type(queued) == 'table' and queued or {}

    -- Disqualification (a queued ban reports as banned with ban.pending = true)
    local banned, ban = safe(function() return res:IsBanned(id) end)
    if meta then
        -- Offline: a ban on the saved record wins; otherwise keep any queued ban the script reports.
        local savedBanned, savedBan = banFrom(offlineRec)
        if savedBanned then banned, ban = true, savedBan
        elseif not (banned and type(ban) == 'table' and ban.pending) then banned, ban = false, nil end
    elseif banned == nil then
        if data.banned ~= nil then
            banned, ban = data.banned, data.ban
        else
            banned, ban = banFrom(offlineRec or offlineRecord(cid))
        end
    end
    block.banned = banned == true
    block.ban = ban

    -- Everything else waiting in the queue (clear points, unban...)
    if queue then
        local pending = safe(function() return res:GetPendingActions(cid) end)
        block.pending = {}
        for _, row in ipairs(type(pending) == 'table' and pending or {}) do
            local p = type(row.payload) == 'table' and row.payload or {}
            block.pending[#block.pending + 1] = {
                action = row.action, by = row.issued_by or p.officer, at = row.created_at,
                points = p.points, code = p.code, reason = p.reason, days = p.days,
            }
        end
    end

    -- Status line per category
    -- Only driving categories that are actually held. Framework keys (driver, weapon,
    -- business) live in the same metadata and are left to the "Certificates" panel.
    local labels = (dvlaCfg() or {}).categoryLabels or {}
    local held = {}
    for cat, v in pairs(type(data.licences) == 'table' and data.licences or {}) do
        if v == true and (next(labels) == nil or labels[cat]) then held[cat] = true end
    end
    for cat in pairs(held) do
        block.items[#block.items + 1] = {
            key = cat,
            label = categoryLabel(cat),
            status = block.banned and not (ban and ban.pending) and 'disqualified' or 'valid',
        }
    end
    if #block.items == 0 then
        block.items[1] = {
            label = 'Driving entitlement',
            status = block.banned and 'disqualified' or (block.provisional and 'provisional' or 'none'),
        }
    end
    table.sort(block.items, function(a, b) return a.label < b.label end)
    block.heldKeys = held
    return block
end

---------------------------------------------------------------------------
-- Qbox / QBCore metadata.licences
---------------------------------------------------------------------------
local function framework(cid, src)
    local cfg = Config.Licences.framework
    local fw = Bridge.Framework()
    if not cfg or not cfg.enabled or (fw ~= 'qbx' and fw ~= 'qb') then return nil end

    local lic
    if src then
        lic = (Bridge.GetMetadata(src) or {}).licences
    else
        local row = MySQL.single.await('SELECT metadata FROM players WHERE citizenid = ?', { cid })
        lic = row and Bridge.Decode(row.metadata).licences
    end
    if type(lic) ~= 'table' or next(lic) == nil then return nil end

    -- vinewood_licensing / citydriving keep driving categories in metadata.licences too.
    -- Those already show in the DVLA panel, so leave them out here.
    local skip = {}
    if Licences.DvlaResource() then
        for k in pairs((dvlaCfg() or {}).categoryLabels or {}) do skip[k] = true end
    end
    local block = { source = 'framework', title = 'Certificates and permits', items = {} }
    for name, held in pairs(lic) do
        if skip[name] then goto continue end
        block.items[#block.items + 1] = {
            label = cfg.labels[name] or name,
            status = held and 'valid' or 'revoked',
        }
        ::continue::
    end
    if #block.items == 0 then return nil end
    table.sort(block.items, function(a, b) return a.label < b.label end)
    return block
end

---------------------------------------------------------------------------
-- esx_license (user_licenses)
---------------------------------------------------------------------------
local function esxLicense(cid)
    local cfg = Config.Licences.esx_license
    if not cfg or not cfg.enabled or not Schema.Has('user_licenses', 'type', 'owner') then return nil end
    local rows = MySQL.query.await('SELECT type FROM user_licenses WHERE owner = ?', { cid }) or {}
    if #rows == 0 then return nil end
    local block = { source = 'esx_license', title = 'Licences', items = {} }
    for _, r in ipairs(rows) do
        block.items[#block.items + 1] = { label = cfg.labels[r.type] or r.type, status = 'valid' }
    end
    return block
end

function Licences.Get(cid)
    local src = Bridge.GetSource(cid)
    local out = {}
    for _, fn in ipairs({ dvla, framework, esxLicense }) do
        local b = safe(fn, cid, src)
        if b then out[#out + 1] = b end
    end
    if type(Config.Licences.custom) == 'function' then
        local items = safe(Config.Licences.custom, cid, src)
        if type(items) == 'table' and #items > 0 then
            out[#out + 1] = { source = 'custom', title = 'Other licences', items = items }
        end
    end
    return out
end

function Licences.Summary(cid)
    -- Short flag for search results: 'disqualified' | 'valid' | 'provisional' | 'none'
    local list = Licences.Get(cid)
    for _, b in ipairs(list) do
        if b.dvla then
            if b.banned then return 'disqualified', b.points end
            for _, i in ipairs(b.items) do if i.status == 'valid' then return 'valid', b.points end end
            if b.provisional then return 'provisional', b.points end
            return 'none', b.points
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- DVLA actions. With vinewood_licensing these work offline too: the action is
-- queued and applied when the driver next logs in (status = 'queued').
---------------------------------------------------------------------------
local function target(cid)
    local res, _, queue = Licences.DvlaResource()
    if not res then return nil, nil, 'The driving licence system is not running.' end
    local src = Bridge.GetSource(cid)
    if src then return res, src end
    if queue then return res, cid end
    return nil, nil, 'The driver must be in the city for this licence system.'
end

function Licences.Endorse(cid, points, code, reason, officer)
    local res, id, err = target(cid)
    if not res then return false, err end
    local ok, total, autoBanned, status = safe(function() return res:AddPoints(id, points, code, reason, officer) end)
    if not ok then return false, 'The endorsement was rejected by the licence system.' end
    return true, nil, total, autoBanned, status == 'queued'
end

function Licences.Disqualify(cid, days, reason, officer)
    local res, id, err = target(cid)
    if not res then return false, err end
    local ok, _, status = safe(function() return res:BanDriver(id, days, reason, officer) end)
    if ok == false then return false, 'The disqualification was rejected.' end
    return true, nil, status == 'queued'
end

function Licences.LiftDisqualification(cid)
    local res, id, err = target(cid)
    if not res then return false, err end
    local ok, status = safe(function() return res:UnbanDriver(id) end)
    if ok == false then return false, 'Could not lift the disqualification.' end
    return true, nil, status == 'queued'
end

function Licences.ClearPoints(cid)
    local res, id, err = target(cid)
    if not res then return false, err end
    local ok, status = safe(function() return res:ClearPoints(id) end)
    if ok == false then return false, 'Could not clear the points.' end
    return true, nil, status == 'queued'
end

-- Revoking a category needs the driver online (it changes their licence item).
function Licences.RevokeCategory(cid, category)
    local res = Licences.DvlaResource()
    if not res then return false, 'The driving licence system is not running.' end
    local src = Bridge.GetSource(cid)
    if not src then return false, 'The driver must be in the city to revoke a licence category.' end
    local ok = safe(function() return res:RevokeLicence(src, category) end)
    if not ok then return false, 'The licence system refused the revocation.' end
    return true
end

function Licences.ClearPending(cid)
    local res, _, queue = Licences.DvlaResource()
    if not res or not queue then return false, 'Nothing is queued.' end
    safe(function() return res:ClearPendingActions(cid) end)
    return true
end
