-- Hex territory: the hexes gangs hold are the script's territory, and a hex's control % is its "influence".
-- Everything that asks Zones / Influence gets hex answers.
Hexes = {}

local cfg = Config.Hexes
local standingOn = {} -- where each player stood last turf check (see the notices below)
local CONFIG_GRID = { size = cfg.size, origin = { x = cfg.origin.x, y = cfg.origin.y } } -- what config/hexes.lua says
local hexes = {}    -- hexes[key] = { key, q, r, gangId, control, main, compound, claimedAt }
local reveals = {}  -- reveals[gangId][key] = os.time() the gang found it
local dirty = {}    -- control values to write back
local warned = {}   -- warned[key] = true once the owner's been told it's running low
local settings = {} -- the numbers staff can change in game (start from config/hexes.lua)

local EDITABLE = { 'mapEnabled', 'mapMinimap', 'mapShowTo', 'turfDrugs', 'anyDrugCounts', 'decayOnlyOnline', 'controlPerSale', 'rivalLoss', 'decayPerHour', 'startControl', 'expandAt', 'expandCost', 'sprayEvery' }

local function now() return os.time() end
-- Turf on the pause map: Config.Territory.map until staff change it in /gangadmin > Turf
local mapCfg = (Config.Territory and Config.Territory.map) or {} -- copes with the map section missing from config
local MAP_DEFAULTS = { mapEnabled = mapCfg.enabled ~= false, mapMinimap = mapCfg.minimap == true,
    mapShowTo = mapCfg.showTo == 'everyone' and 'everyone' or 'gangs' }
local function S(name)
    if settings[name] ~= nil then return settings[name] end
    if MAP_DEFAULTS[name] ~= nil then return MAP_DEFAULTS[name] end
    return cfg[name]
end

local function publishMap()
    GlobalState.vg_turf_map = { enabled = S('mapEnabled') == true, minimap = S('mapMinimap') == true, showTo = S('mapShowTo') }
end

function Hexes.Setting(name) return S(name) end

-------------------------------------------------------------------------------
-- What each gang can see
-------------------------------------------------------------------------------

local function rebuildZones()
    local defs = {}
    for key, h in pairs(hexes) do
        defs[key] = { label = Hex.Label(h.q, h.r), value = 1.0, points = Hex.Corners(h.q, h.r) }
    end
    Zones.Set(defs)
end

local function owned(gangId)
    local list = {}
    for _, h in pairs(hexes) do if h.gangId == gangId then list[#list + 1] = h end end
    return list
end

function Hexes.Count(gangId) return #owned(gangId) end

function Hexes.MainOf(gangId)
    for key, h in pairs(hexes) do if h.gangId == gangId and h.main then return key end end
end

---Tags a gang may have up: one, plus one for every sprayEvery hexes.
function Hexes.SpraySlots(gangId)
    local n = Hexes.Count(gangId)
    if n == 0 then return 0 end
    return 1 + math.floor(n / math.max(1, S('sprayEvery')))
end

local function revealedTo(gangId, key)
    local r = reveals[gangId] and reveals[gangId][key]
    if not r then return false end
    local days = cfg.revealDays or 0
    return days <= 0 or now() - r < days * 86400
end

---Everything a gang's members' games are told about: their own hexes and the rivals' they've found.
function Hexes.ViewFor(gangId)
    local out = {}
    if not gangId then return out end
    for key, h in pairs(hexes) do
        local mine = h.gangId == gangId
        if mine or revealedTo(gangId, key) then
            local g = Gangs.Get(h.gangId)
            out[#out + 1] = {
                key = key, q = h.q, r = h.r, label = Hex.Label(h.q, h.r), mine = mine, main = mine and h.main or nil,
                compound = mine and h.compound or nil, control = mine and math.floor(h.control * 10 + 0.5) / 10 or nil,
                owner = g and { id = g.id, label = g.label, colour = g.colour } or nil,
            }
        end
    end
    return out
end

local function pushGang(gangId)
    if not gangId then return end
    local view = Hexes.ViewFor(gangId)
    for _, m in ipairs(Gangs.OnlineMembers(gangId)) do
        TriggerClientEvent('vinewood_gangs:client:hexes', m.source, view)
    end
end
Hexes.Push = pushGang

-- Gangs that can currently see a hex (its owner and anyone who's found it)
local function watchers(key)
    local list, seen = {}, {}
    local h = hexes[key]
    if h then list[#list + 1] = h.gangId seen[h.gangId] = true end
    for gid, keys in pairs(reveals) do
        if keys[key] and not seen[gid] then list[#list + 1] = gid seen[gid] = true end
    end
    return list
end

function Hexes.Reveal(gangId, key)
    local h = hexes[key]
    if not h or h.gangId == gangId or revealedTo(gangId, key) then return false end
    reveals[gangId] = reveals[gangId] or {}
    reveals[gangId][key] = now()
    MySQL.insert('INSERT INTO vg_hex_reveals (gang_id, hex_key, revealed_at) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE revealed_at = VALUES(revealed_at)', { gangId, key, now() })
    local owner = Gangs.Get(h.gangId)
    Gangs.NotifyGang(gangId, locale('hex_revealed', owner and owner.label or '?', Hex.Label(h.q, h.r)), 'warning')
    pushGang(gangId)
    return true
end

-------------------------------------------------------------------------------
-- Claiming and losing
-------------------------------------------------------------------------------

local function claim(key, gangId, control, main, compound)
    local q, r = Hex.Parse(key)
    hexes[key] = { key = key, q = q, r = r, gangId = gangId, control = control, main = main == true, compound = compound == true, claimedAt = now() }
    MySQL.insert.await('INSERT INTO vg_hexes (hex_key, gang_id, control, is_main, compound, claimed_at) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE gang_id = VALUES(gang_id), control = VALUES(control), is_main = VALUES(is_main), compound = VALUES(compound), claimed_at = VALUES(claimed_at)',
        { key, gangId, control, main and 1 or 0, compound and 1 or 0, now() })
    warned[key] = nil
    rebuildZones()
end

local function lose(key, reason)
    local h = hexes[key]
    if not h then return end
    local watching = watchers(key)
    hexes[key], dirty[key], warned[key] = nil, nil, nil
    for _, keys in pairs(reveals) do keys[key] = nil end
    MySQL.update('DELETE FROM vg_hexes WHERE hex_key = ?', { key })
    MySQL.update('DELETE FROM vg_hex_reveals WHERE hex_key = ?', { key })
    rebuildZones()
    Gangs.NotifyGang(h.gangId, locale(reason or 'hex_lost', Hex.Label(h.q, h.r)), 'error')
    local g = Gangs.Get(h.gangId)
    Logger.Log(nil, 'hex_lost', ('%s lost %s (%s)'):format(g and g.label or ('gang ' .. tostring(h.gangId)), Hex.Label(h.q, h.r),
        reason == 'hex_lost' and 'its control ran out' or tostring(reason or 'lost')))
    for _, gid in ipairs(watching) do pushGang(gid) end
end

local function setControl(h, value)
    local before = h.control
    h.control = math.max(0, math.min(100, value))
    dirty[h.key] = true
    if h.control <= 0 and not (h.compound and cfg.protectCompound) then
        lose(h.key, 'hex_lost')
        return
    end
    if h.control < 25 and before >= 25 and not warned[h.key] then
        warned[h.key] = true
        Gangs.NotifyGang(h.gangId, locale('hex_low', Hex.Label(h.q, h.r), math.floor(h.control)), 'warning')
    elseif h.control >= 25 then
        warned[h.key] = nil
    end
    -- The tablet shows the exact %, the map only needs to know when something changes hands
    if math.floor(before / 10) ~= math.floor(h.control / 10) then pushGang(h.gangId) end
end

-------------------------------------------------------------------------------
-- Dealing (server/modules/drugs.lua calls these)
-------------------------------------------------------------------------------

---The turf drugs as { item, perUnit } (perUnit nil = the default % per unit). Older settings and config/hexes.lua
---may list plain item names; those use the default.
local function turfList()
    local out = {}
    for _, d in ipairs(S('turfDrugs') or {}) do
        if type(d) == 'string' then out[#out + 1] = { item = d }
        elseif type(d) == 'table' and d.item then out[#out + 1] = { item = d.item, perUnit = tonumber(d.perUnit) } end
    end
    return out
end

---How much control one unit of this drug builds on your own hex (nil = it doesn't).
local function controlFor(item)
    for _, d in ipairs(turfList()) do
        if d.item == item then return d.perUnit or S('controlPerSale') end
    end
    if S('anyDrugCounts') then return S('controlPerSale') end
    return nil
end

local function isTurfDrug(item) return controlFor(item) ~= nil end

function Hexes.IsTurfDrug(item) return isTurfDrug(item) end

---Adds control to a gang's weakest hex (the black market's "connections" lot). Returns that hex's label.
---Adds control to one of the gang's hexes (a racket collection there, say). Returns the new control %.
function Hexes.Boost(key, gangId, amount)
    local h = hexes[key]
    if not h or h.gangId ~= gangId or (tonumber(amount) or 0) <= 0 then return nil end
    setControl(h, h.control + amount)
    return h.control
end

function Hexes.BoostWeakest(gangId, amount)
    local weakest
    for _, h in ipairs(owned(gangId)) do if not weakest or h.control < weakest.control then weakest = h end end
    if not weakest then return nil end
    setControl(weakest, weakest.control + amount)
    return Hex.Label(weakest.q, weakest.r)
end

---A sale on a hex. Own hex + turf drug builds control; a rival's sale costs the owner control and reveals the hex.
---Returns what happened, for the dealer's message: { own, counted, label, gained, control } or { rival = true }.
function Hexes.OnSale(key, sellerGangId, item, qty)
    local h = hexes[key]
    if not h or not sellerGangId then return nil end
    if h.gangId == sellerGangId then
        local label = Hex.Label(h.q, h.r)
        local per = controlFor(item)
        if not per then
            local names = {}
            for _, d in ipairs(turfList()) do names[#names + 1] = Bridge.ItemLabel(d.item) end
            return { own = true, counted = false, label = label, needs = table.concat(names, ' or ') }
        end
        local before = h.control
        setControl(h, h.control + per * qty)
        return { own = true, counted = true, label = label, gained = math.floor((h.control - before) * 10 + 0.5) / 10,
            control = math.floor(h.control) }
    end
    Hexes.Reveal(sellerGangId, key)
    if hexes[key] then setControl(h, h.control - S('rivalLoss') * qty) end
    return { rival = true }
end

-------------------------------------------------------------------------------
-- Expanding (tablet)
-------------------------------------------------------------------------------

---Hexes this gang could buy next: touching one of theirs that's at the expand threshold.
function Hexes.Options(gangId)
    local mine, out, seen = owned(gangId), {}, {}
    for _, h in ipairs(mine) do
        if h.control >= S('expandAt') then
            for _, n in ipairs(Hex.Neighbours(h.q, h.r)) do
                local key = Hex.Key(n[1], n[2])
                local other = hexes[key]
                if not seen[key] and not (other and other.gangId == gangId) then
                    seen[key] = true
                    -- Rival ground the gang hasn't found stays a mystery until they try to buy it
                    local known = other and revealedTo(gangId, key)
                    if not known then out[#out + 1] = { key = key, q = n[1], r = n[2], label = Hex.Label(n[1], n[2]) } end
                end
            end
        end
    end
    return out
end

function Hexes.Expand(src, q, r)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'expand_turf') then return false, 'no_permission' end
    q, r = math.floor(tonumber(q) or 0), math.floor(tonumber(r) or 0)
    local key = Hex.Key(q, r)
    if hexes[key] and hexes[key].gangId == gang.id then return false, 'hex_already_yours' end

    local touching = false
    for _, h in ipairs(owned(gang.id)) do
        if h.control >= S('expandAt') and Hex.Touching(h.q, h.r, q, r) then touching = true break end
    end
    if not touching then return false, 'hex_not_touching' end
    if hexes[key] then
        Hexes.Reveal(gang.id, key)
        return false, 'hex_taken'
    end

    local cost = S('expandCost') or {}
    if cost.item and cost.count and cost.count > 0 and not Bridge.HasItem(src, cost.item, cost.count) then
        return false, 'hex_need_drugs', ('%d x %s'):format(cost.count, Bridge.ItemLabel(cost.item))
    end
    if (cost.money or 0) > 0 and not Ledger.Transact(gang.id, cost.account or 'dirty', -cost.money, 'hex_expand', { citizenid = cid, note = Hex.Label(q, r) }) then
        return false, 'insufficient_funds'
    end
    if cost.item and cost.count and cost.count > 0 then Bridge.RemoveItem(src, cost.item, cost.count) end

    claim(key, gang.id, S('startControl'), false, false)
    Gangs.NotifyGang(gang.id, locale('hex_bought', Hex.Label(q, r)), 'success')
    Logger.Log(src, 'hex_expand', ('%s bought %s for gang %d'):format(cid, key, gang.id))
    pushGang(gang.id)
    return true
end

---For the tablet's Territory app.
function Hexes.TabletView(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local cost = S('expandCost') or {}
    local used = 0
    for _, t in ipairs(Graffiti and Graffiti.GangTags and Graffiti.GangTags(gang.id) or {}) do used = used + (t.active or 0) end
    return {
        mode = 'hexes', hexes = Hexes.ViewFor(gang.id), options = Hexes.Options(gang.id),
        canExpand = Gangs.HasPermission(cid, 'expand_turf'), expandAt = S('expandAt'),
        cost = { money = cost.money or 0, account = cost.account or 'dirty', item = cost.item and Bridge.ItemLabel(cost.item) or nil, count = cost.count or 0 },
        decayPerHour = S('decayPerHour'), controlPerSale = S('controlPerSale'), decayOnlyOnline = S('decayOnlyOnline') ~= false,
        turfDrugs = (function() local l = {} for _, d in ipairs(turfList()) do l[#l + 1] = Bridge.ItemLabel(d.item) end return l end)(),
        -- Each turf drug and how much control a unit builds, for the Territory app
        turfRates = (function() local l = {} for _, d in ipairs(turfList()) do l[#l + 1] = { label = Bridge.ItemLabel(d.item), perUnit = d.perUnit or S('controlPerSale') } end return l end)(),
        sprays = { used = used, slots = Hexes.SpraySlots(gang.id), every = S('sprayEvery'), main = Hexes.MainOf(gang.id) },
        balance = Ledger.GetBalance(gang.id, cost.account or 'dirty'),
    }
end

-------------------------------------------------------------------------------
-- Ticking, saving, loading
-------------------------------------------------------------------------------

local function flush()
    local rows = {}
    for key in pairs(dirty) do
        local h = hexes[key]
        if h then rows[#rows + 1] = { math.floor(h.control * 100 + 0.5) / 100, key } end
    end
    dirty = {}
    if #rows > 0 then MySQL.prepare('UPDATE vg_hexes SET control = ? WHERE hex_key = ?', rows) end
end
Hexes.Flush = flush

local function tick()
    local loss = S('decayPerHour') / 60 -- runs every minute
    local onlineOnly = S('decayOnlyOnline') ~= false
    local online = {} -- online[gangId] = true/false, worked out once per tick
    local list = {}
    for _, h in pairs(hexes) do
        if onlineOnly and online[h.gangId] == nil then online[h.gangId] = Gangs.HasOnlineMember(h.gangId) == true end
        -- A gang with nobody on doesn't lose control just for being offline
        if not onlineOnly or online[h.gangId] then list[#list + 1] = h end
    end
    for _, h in ipairs(list) do if hexes[h.key] then setControl(h, h.control - loss) end end
    flush()
end
Hexes._tick = tick

-------------------------------------------------------------------------------
-- Changing the grid size or origin: move existing turf onto the new grid, in the same place
-------------------------------------------------------------------------------

local SQ3 = math.sqrt(3)
local function centreOn(grid, q, r)
    return grid.origin.x + grid.size * SQ3 * (q + r / 2), grid.origin.y + grid.size * 1.5 * r
end
local function cornersOn(grid, q, r)
    local cx, cy = centreOn(grid, q, r)
    local out = {}
    for i = 0, 5 do
        local a = math.rad(60 * i - 30)
        out[#out + 1] = { x = cx + grid.size * math.cos(a), y = cy + grid.size * math.sin(a) }
    end
    return out
end

---The new hexes an old hex becomes: the one at its centre first, then (in 'fill' mode) the rest inside it.
local function newKeysFor(old, q, r)
    local cx, cy = centreOn(old, q, r)
    local cq, cr = Hex.FromCoords(cx, cy)
    local keys = { Hex.Key(cq, cr) }
    if (cfg.onResize or 'centre') ~= 'fill' then return keys end
    local poly = cornersOn(old, q, r)
    local reach = math.ceil(old.size / cfg.size) + 2
    for dq = -reach * 2, reach * 2 do
        for dr = -reach * 2, reach * 2 do
            local nq, nr = cq + dq, cr + dr
            if not (nq == cq and nr == cr) then
                local x, y = Hex.Centre(nq, nr)
                if Zones.PointInPolygon(poly, x, y) then keys[#keys + 1] = Hex.Key(nq, nr) end
            end
        end
    end
    return keys
end

local function sameGrid(a, b)
    return math.abs((a.size or 0) - cfg.size) < 0.001 and math.abs((a.origin and a.origin.x or 0) - cfg.origin.x) < 0.001
        and math.abs((a.origin and a.origin.y or 0) - cfg.origin.y) < 0.001
end

---Runs once when the grid in config/hexes.lua no longer matches the one the turf was made on.
local function convertTurf(old, rows, revealRows)
    local moved, merged, newRows, map = 0, 0, {}, {}
    table.sort(rows, function(a, b) return (a.is_main == 1 and 1 or 0) > (b.is_main == 1 and 1 or 0) end) -- main hexes first
    for _, row in ipairs(rows) do
        local q, r = Hex.Parse(row.hex_key)
        if q then
            map[row.hex_key] = {}
            for n, key in ipairs(newKeysFor(old, q, r)) do
                if newRows[key] then
                    merged = merged + 1 -- two old hexes landed on the same new one: the first keeps it
                else
                    newRows[key] = { hex_key = key, gang_id = row.gang_id, control = row.control,
                        is_main = (n == 1 and (row.is_main == 1 or row.is_main == true)) and 1 or 0,
                        compound = (row.compound == 1 or row.compound == true) and 1 or 0, claimed_at = row.claimed_at }
                    map[row.hex_key][#map[row.hex_key] + 1] = key
                end
            end
            moved = moved + 1
        end
    end
    MySQL.update.await('DELETE FROM vg_hexes')
    for _, n in pairs(newRows) do
        MySQL.insert.await('INSERT INTO vg_hexes (hex_key, gang_id, control, is_main, compound, claimed_at) VALUES (?, ?, ?, ?, ?, ?)',
            { n.hex_key, n.gang_id, n.control, n.is_main, n.compound, n.claimed_at })
    end
    -- Rival hexes each gang had found: found the new ones they became
    MySQL.update.await('DELETE FROM vg_hex_reveals')
    for _, rv in ipairs(revealRows) do
        for _, key in ipairs(map[rv.hex_key] or {}) do
            MySQL.insert.await('INSERT IGNORE INTO vg_hex_reveals (gang_id, hex_key, revealed_at) VALUES (?, ?, ?)', { rv.gang_id, key, rv.revealed_at })
        end
    end
    -- Tags: re-match each one to the hex it's now in, from where it actually is
    for _, t in ipairs(MySQL.query.await("SELECT id, placement FROM vg_graffiti WHERE status = 'active'") or {}) do
        local ok, p = pcall(json.decode, t.placement or '')
        if ok and type(p) == 'table' and tonumber(p.x) and tonumber(p.y) then
            local key = Hex.Key(Hex.FromCoords(tonumber(p.x), tonumber(p.y)))
            MySQL.update.await('UPDATE vg_graffiti SET zone = ? WHERE id = ?', { newRows[key] and key or nil, t.id })
        end
    end
    local count = 0 for _ in pairs(newRows) do count = count + 1 end
    lib.print.info(('Hex grid changed (%sm -> %sm): moved %d hexes onto the new grid as %d (%s mode)%s.'):format(
        old.size, cfg.size, moved, count, cfg.onResize or 'centre', merged > 0 and (', ' .. merged .. ' overlapped and were merged') or ''))
end

local function publishGrid()
    GlobalState.vg_hex_grid = { size = cfg.size, origin = { x = cfg.origin.x, y = cfg.origin.y } }
end

local function saveGrid(fromAdmin)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('hex_grid', ?, 'server') ON DUPLICATE KEY UPDATE value = VALUES(value)",
        { json.encode({ size = cfg.size, origin = { x = cfg.origin.x, y = cfg.origin.y }, fromAdmin = fromAdmin or nil,
            configSize = CONFIG_GRID.size, configOrigin = CONFIG_GRID.origin }) })
end

---Which grid to use, and moving turf onto it if it changed. A size set in game stays until someone edits
---the size in config/hexes.lua; then the config wins.
local function checkGrid()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'hex_grid'")
    local ok, grid = pcall(json.decode, raw or '')
    grid = ok and type(grid) == 'table' and grid or nil
    local keepAdmin = grid and grid.fromAdmin and math.abs((grid.configSize or 0) - CONFIG_GRID.size) < 0.001
        and grid.configOrigin and math.abs((grid.configOrigin.x or 0) - CONFIG_GRID.origin.x) < 0.001
        and math.abs((grid.configOrigin.y or 0) - CONFIG_GRID.origin.y) < 0.001
    if keepAdmin then
        cfg.size, cfg.origin = grid.size, { x = grid.origin.x, y = grid.origin.y }
    else
        cfg.size, cfg.origin = CONFIG_GRID.size, { x = CONFIG_GRID.origin.x, y = CONFIG_GRID.origin.y }
    end
    local rows = MySQL.query.await('SELECT hex_key, gang_id, control, is_main, compound, claimed_at FROM vg_hexes') or {}
    -- Turf made before the grid was recorded was made on the original 150 m grid
    if not grid and #rows > 0 then grid = { size = cfg.convertFrom or 150.0, origin = { x = 0.0, y = 0.0 } } end
    if grid and #rows > 0 and not sameGrid(grid) then
        convertTurf(grid, rows, MySQL.query.await('SELECT gang_id, hex_key, revealed_at FROM vg_hex_reveals') or {})
    end
    saveGrid(keepAdmin)
    publishGrid()
end

local loadTurf

function Hexes.Load()
    checkGrid()
    loadTurf()
end

loadTurf = function()
    hexes, reveals = {}, {}
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'hex_settings'")
    settings = raw and json.decode(raw) or {}
    publishMap()
    for _, row in ipairs(MySQL.query.await('SELECT hex_key, gang_id, control, is_main, compound, claimed_at FROM vg_hexes') or {}) do
        local q, r = Hex.Parse(row.hex_key)
        if q then
            hexes[row.hex_key] = { key = row.hex_key, q = q, r = r, gangId = row.gang_id, control = tonumber(row.control) or 0,
                main = row.is_main == 1 or row.is_main == true, compound = row.compound == 1 or row.compound == true, claimedAt = row.claimed_at }
        end
    end
    for _, row in ipairs(MySQL.query.await('SELECT gang_id, hex_key, revealed_at FROM vg_hex_reveals') or {}) do
        reveals[row.gang_id] = reveals[row.gang_id] or {}
        reveals[row.gang_id][row.hex_key] = row.revealed_at
    end
    rebuildZones()
end

function Hexes.Start()
    CreateThread(function()
        while true do
            Wait(60000)
            local ok, err = pcall(tick)
            if not ok then lib.print.error(('hex tick: %s'):format(err)) end
        end
    end)
end

AddEventHandler('onResourceStop', function(res) if res == GetCurrentResourceName() then flush() end end)

-------------------------------------------------------------------------------
-- "You're on ... turf" notices. Worked out here because only the server knows every hex: a player is told
-- they're on a rival's turf without that hex (or, unless they've found it, the gang) being revealed to them.
-------------------------------------------------------------------------------

local notice = Config.Territory.enterNotice
standingOn = {} -- standingOn[src] = owner gang id, or false on free ground (reset when the grid is resized)
local lastTold = {}   -- lastTold[src][kind] = os.time()

local function tell(src, kind, message, ntype)
    lastTold[src] = lastTold[src] or {}
    if lastTold[src][kind] and now() - lastTold[src][kind] < (notice.cooldown or 60) then return end
    lastTold[src][kind] = now()
    Bridge.Notify(src, message, ntype)
end

local bannerOn = {} -- bannerOn[src] = the hex key their turf banner was last set for ('' = none)
local banner = Config.Territory.banner ~= false -- the bar at the top of the screen while you're on turf

---Tells a player's game what the turf banner should say (nothing on free ground). Only what they're allowed to
---know: their own hexes by name, rival turf by gang only if their gang has found it.
local function sendBanner(src, gang, h)
    local key = h and h.key or ''
    if bannerOn[src] == key then return end
    bannerOn[src] = key
    local info = nil
    if h then
        if gang and h.gangId == gang.id then
            info = { own = true, label = Hex.Label(h.q, h.r), main = h.main or nil }
        else
            local known = gang and revealedTo(gang.id, h.key)
            local g = known and Gangs.Get(h.gangId)
            info = { rival = true, gang = g and g.label or nil, colour = g and g.colour or nil }
        end
    end
    TriggerClientEvent('vinewood_gangs:client:turfBanner', src, info)
end

local function checkPlayer(src)
    local gang = Gangs.GetPlayerGang(src)
    if notice.showTo ~= 'everyone' and not gang then
        standingOn[src] = nil
        if bannerOn[src] and bannerOn[src] ~= '' then bannerOn[src] = '' TriggerClientEvent('vinewood_gangs:client:turfBanner', src, nil) end
        return
    end
    local c = GetEntityCoords(GetPlayerPed(src))
    local h = hexes[Hex.Key(Hex.FromCoords(c.x, c.y))]
    if banner then sendBanner(src, gang, h) end
    local owner = h and h.gangId or false
    local before = standingOn[src]
    standingOn[src] = owner
    if not notice.enabled then return end
    if before == nil or before == owner then return end -- just joined, or still on the same gang's ground

    if not owner then
        if notice.onLeave then tell(src, 'left', locale('turf_left'), 'inform') end
    elseif gang and owner == gang.id then
        tell(src, 'own', locale('turf_entered_own'), 'success')
    else
        -- Name the gang only if this player's gang has already found this hex
        local known = gang and revealedTo(gang.id, h.key)
        local g = known and Gangs.Get(owner)
        tell(src, 'rival:' .. owner, g and locale('turf_entered_known', g.label) or locale('turf_entered_rival'), 'warning')
    end
end

CreateThread(function()
    if not notice.enabled and not banner then return end
    Wait(10000)
    while true do
        for _, id in ipairs(GetPlayers()) do
            local src = tonumber(id)
            local ok = pcall(checkPlayer, src)
            if not ok then standingOn[src] = nil end
        end
        Wait(2000)
    end
end)

AddEventHandler('playerDropped', function() standingOn[source], lastTold[source], bannerOn[source] = nil, nil, nil end)
Hexes._revealedTo = function(g, k) return revealedTo(g, k) end -- for tests
Hexes._checkPlayer = checkPlayer -- for tests

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

function Hexes.AdminGang(gangId)
    local list = {}
    for _, h in ipairs(owned(tonumber(gangId))) do
        list[#list + 1] = { key = h.key, label = Hex.Label(h.q, h.r), control = math.floor(h.control * 10 + 0.5) / 10, main = h.main, compound = h.compound }
    end
    table.sort(list, function(a, b) return (a.main and 1 or 0) > (b.main and 1 or 0) or (a.main == b.main and a.label < b.label) end)
    return { hexes = list, startHexes = cfg.startHexes }
end

---The hex at a spot (claimed or not) and who holds it: key, ownerGangId (nil = free ground), label.
function Hexes.At(coords)
    local q, r = Hex.FromCoords(coords.x, coords.y)
    local key = Hex.Key(q, r)
    local h = hexes[key]
    return key, h and h.gangId or nil, Hex.Label(q, r)
end

---A gang takes a free hex because a business in it agreed to pay them (rackets). Returns the hex's label.
function Hexes.ClaimForRacket(key, gangId)
    if hexes[key] then return nil end
    claim(key, gangId, S('startControl'), false, false)
    local h = hexes[key]
    Gangs.NotifyGang(gangId, locale('hex_from_racket', Hex.Label(h.q, h.r)), 'success')
    pushGang(gangId)
    return Hex.Label(h.q, h.r)
end


---Every claimed hex, for the staff map picker. Staff see all turf (players only see what their gang knows).
function Hexes.AdminMap()
    local out = {}
    for key, h in pairs(hexes) do
        local g = Gangs.Get(h.gangId)
        out[#out + 1] = { key = key, q = h.q, r = h.r, gangId = h.gangId, label = Hex.Label(h.q, h.r),
            gang = g and g.label or '?', colour = g and g.colour or '#888888', control = math.floor(h.control), main = h.main }
    end
    return out
end

---Gives a gang a hex: the one the staff member is standing in, or the one picked on the map (q, r).
---Their first hexes are the compound (the first is main).
function Hexes.AdminGive(src, gangId, q, r)
    gangId = tonumber(gangId)
    if not gangId or not Gangs.Get(gangId) then return false, 'invalid' end
    q, r = tonumber(q), tonumber(r)
    if q and r then
        q, r = math.floor(q), math.floor(r)
        -- Keep it on the map (roughly the playable area)
        local x, y = Hex.Centre(q, r)
        if math.abs(x) > 5000 or y < -4500 or y > 8500 then return false, 'invalid' end
    else
        local c = GetEntityCoords(GetPlayerPed(src))
        q, r = Hex.FromCoords(c.x, c.y)
    end
    local key = Hex.Key(q, r)
    local other = hexes[key]
    if other and other.gangId ~= gangId then
        local g = Gangs.Get(other.gangId)
        return false, 'hex_taken_by', g and g.label or '?'
    end
    if other then return false, 'hex_already_theirs' end
    local count = Hexes.Count(gangId)
    claim(key, gangId, S('startControl'), count == 0, count < (cfg.startHexes or 2))
    Logger.Log(src, 'staff_hex_given', ('gave %s to gang %d'):format(key, gangId))
    pushGang(gangId)
    return true, Hex.Label(q, r)
end

function Hexes.AdminRemove(src, key)
    local h = hexes[tostring(key)]
    if not h then return false, 'invalid' end
    local gangId = h.gangId
    lose(h.key, 'hex_removed_staff')
    Logger.Log(src, 'staff_hex_removed', ('removed %s from gang %d'):format(key, gangId))
    -- If the main hex went, the oldest remaining one becomes main
    if not Hexes.MainOf(gangId) then
        local oldest
        for _, x in ipairs(owned(gangId)) do if not oldest or x.claimedAt < oldest.claimedAt then oldest = x end end
        if oldest then oldest.main = true MySQL.update('UPDATE vg_hexes SET is_main = 1 WHERE hex_key = ?', { oldest.key }) pushGang(gangId) end
    end
    return true
end

function Hexes.AdminSetControl(src, key, value)
    local h = hexes[tostring(key)]
    value = tonumber(value)
    if not h or not value then return false, 'invalid' end
    setControl(h, value)
    flush()
    Logger.Log(src, 'staff_hex_control', ('%s set to %.0f%%'):format(key, value))
    return true
end

function Hexes.AdminSetMain(src, key)
    local h = hexes[tostring(key)]
    if not h then return false, 'invalid' end
    for _, x in ipairs(owned(h.gangId)) do x.main = x.key == h.key end
    MySQL.update('UPDATE vg_hexes SET is_main = (hex_key = ?) WHERE gang_id = ?', { h.key, h.gangId })
    pushGang(h.gangId)
    return true
end

---Resizes the grid now, moving every gang's turf onto it in the same place ('centre' or 'fill').
function Hexes.AdminResize(src, size, mode)
    size = tonumber(size)
    if not size or size < 20 or size > 500 then return false, 'hex_size_range' end
    size = math.floor(size * 10 + 0.5) / 10
    if math.abs(size - cfg.size) < 0.001 then return false, 'hex_size_same' end
    mode = mode == 'fill' and 'fill' or 'centre'
    flush()
    local before = 0 for _ in pairs(hexes) do before = before + 1 end
    local old = { size = cfg.size, origin = { x = cfg.origin.x, y = cfg.origin.y } }
    local rows = MySQL.query.await('SELECT hex_key, gang_id, control, is_main, compound, claimed_at FROM vg_hexes') or {}
    local revealRows = MySQL.query.await('SELECT gang_id, hex_key, revealed_at FROM vg_hex_reveals') or {}
    cfg.size = size
    local savedMode = cfg.onResize
    cfg.onResize = mode
    if #rows > 0 then convertTurf(old, rows, revealRows) end
    cfg.onResize = savedMode
    saveGrid(true)
    publishGrid()
    loadTurf()
    if Graffiti and Graffiti.Rezone then Graffiti.Rezone() end
    -- Everyone's game: new grid, new turf
    for id in pairs(Gangs.All()) do pushGang(id) end
    standingOn = {}
    local after = 0 for _ in pairs(hexes) do after = after + 1 end
    Logger.Log(src, 'staff_hex_resize', ('resized hexes %sm -> %sm (%s): %d hexes became %d'):format(old.size, size, mode, before, after))
    return true, { from = old.size, to = size, before = before, after = after }
end

function Hexes.AdminSettings()
    local out = {}
    for _, k in ipairs(EDITABLE) do out[k] = S(k) end
    -- Flag turf drugs that can't build control: not a real item, or not on the Street dealing list
    local sellable = {}
    for _, it in ipairs(Drugs and Drugs.Items and Drugs.Items() or {}) do sellable[it.item] = true end
    out.turfDrugItems = {}
    for _, d in ipairs(turfList()) do
        out.turfDrugItems[#out.turfDrugItems + 1] = { name = d.item, label = Bridge.ItemLabel(d.item), perUnit = d.perUnit,
            exists = Bridge.ItemExists(d.item), sellable = sellable[d.item] == true }
    end
    local cost = S('expandCost') or {}
    out.expandItemLabel = cost.item and Bridge.ItemLabel(cost.item) or nil
    out.size = cfg.size
    out.configSize = CONFIG_GRID.size
    out.onResize = cfg.onResize or 'centre'
    return out
end

function Hexes.AdminSaveSettings(src, input)
    if type(input) ~= 'table' then return false, 'invalid' end
    local n = function(v, lo, hi, d) v = tonumber(v) return v and math.max(lo, math.min(hi, v)) or d end
    local drugs, seen = {}, {}
    for _, d in ipairs(type(input.turfDrugs) == 'table' and input.turfDrugs or {}) do
        -- { item, perUnit } (or a plain item name, which uses the default rate)
        local item = type(d) == 'table' and d.item or d
        if type(item) ~= 'string' or not Bridge.ItemExists(item) then return false, 'item_not_found' end
        if not seen[item] then
            seen[item] = true
            local per = type(d) == 'table' and tonumber(d.perUnit) or nil
            drugs[#drugs + 1] = { item = item, perUnit = per and n(per, 0.01, 100, nil) or nil }
        end
    end
    if #drugs == 0 and input.anyDrugCounts ~= true then return false, 'hex_need_turf_drug' end
    local cost = type(input.expandCost) == 'table' and input.expandCost or {}
    local item = cost.item and cost.item ~= '' and tostring(cost.item) or nil
    if item and not Bridge.ItemExists(item) then return false, 'item_not_found' end
    local new = {
        mapEnabled = input.mapEnabled ~= false, mapMinimap = input.mapMinimap == true, mapShowTo = input.mapShowTo == 'everyone' and 'everyone' or 'gangs',
        turfDrugs = drugs, anyDrugCounts = input.anyDrugCounts == true, decayOnlyOnline = input.decayOnlyOnline ~= false,
        controlPerSale = n(input.controlPerSale, 0.1, 100, cfg.controlPerSale),
        rivalLoss = n(input.rivalLoss, 0, 100, cfg.rivalLoss),
        decayPerHour = n(input.decayPerHour, 0, 100, cfg.decayPerHour),
        startControl = n(input.startControl, 0, 100, cfg.startControl),
        expandAt = n(input.expandAt, 1, 100, cfg.expandAt),
        sprayEvery = math.floor(n(input.sprayEvery, 1, 50, cfg.sprayEvery)),
        expandCost = { money = math.floor(n(cost.money, 0, 100000000, 0)), account = cost.account == 'clean' and 'clean' or 'dirty',
            item = item, count = item and math.floor(n(cost.count, 1, 10000, 1)) or 0 },
    }
    settings = new
    publishMap()
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('hex_settings', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode(new), Bridge.GetCitizenId(src) or 'console' })
    Logger.Log(src, 'staff_hex_settings', 'changed turf settings')
    return true, Hexes.AdminSettings()
end

-------------------------------------------------------------------------------
-- Territory for the rest of the script: the claimed hexes ARE the areas, and control is "influence"
-------------------------------------------------------------------------------

-- Only these server-side lookups know about every claimed hex; players' games are only told their own
-- and the rivals' they've found (fog of war), so nothing here is broadcast.
function Zones.FromCoords(coords)
    local key = Hex.Key(Hex.FromCoords(coords.x, coords.y))
    return hexes[key] and key or nil
end
function Zones.Label(key)
    local q, r = Hex.Parse(key)
    return q and Hex.Label(q, r) or 'Unknown'
end

Influence = {}
function Influence.Start() Hexes.Start() end
function Influence.Publish() end
function Influence.Flush() flush() end
function Influence.Tick() tick() end
---Other systems can only take control away (a rival crossing out a tag, a police raid, a street event).
---Building it up only happens by dealing the turf drug (Hexes.OnSale).
function Influence.Add(key, gangId, amount)
    local h = hexes[key]
    if h and h.gangId == gangId and (tonumber(amount) or 0) < 0 then setControl(h, h.control + amount) end
end
function Influence.Get(key, gangId) local h = hexes[key] return (h and h.gangId == gangId) and h.control or 0 end
function Influence.GetOwner(key) local h = hexes[key] return h and h.gangId or nil end
function Influence.GetZoneBreakdown(key) local h = hexes[key] return h and { { gangId = h.gangId, influence = h.control } } or {} end
function Influence.RemoveGang(gangId) for _, h in ipairs(owned(gangId)) do lose(h.key, 'hex_lost') end end
function Influence.ClearZone(key) lose(key, 'hex_removed_staff') end

-- For tests
Hexes._hexes = hexes
