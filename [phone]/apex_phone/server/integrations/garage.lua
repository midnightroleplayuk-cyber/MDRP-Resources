-- ------------------------------------------------------------
-- INTEGRATIONS / GARAGE: known garage resources for the Garage app (dispatcher: server/integrations.lua).
-- list(src, cid) returns the PUBLIC shape:
--   { plate, model, hash?, label?, garage? (id), garageLabel?, state = 'garage'|'out'|'impound',
--     fuel? (0-100), engine? (0-1000), body? (0-1000), mileage?, coords? {x,y,z} of the garage, nickname? }
-- track(src, cid, plate) (optional) returns {x,y,z} of the vehicle; every adapter here asks the live world
-- first (server entity, same as builtin) and only then the resource's own record (parked position).
--
-- Most garage resources keep their state in extra columns of the framework vehicles table and have no
-- "list my vehicles" export, so those adapters READ the table (never write); the garage coordinates come
-- from an export when there is one, else from the resource's open config file (read in a sandbox, see
-- PI.readResourceTable). Every export call goes through PI.callExport (pcall, index included).
-- verified = false: written from the vendor's public docs / integration snippets, not against the source.
--
-- 'auto' picks the FIRST started resource in the order the providers are defined below: the specific
-- third-party garages first, the framework defaults (qbx_garages, qb-garages, esx_garage) last, because
-- servers often leave the default garage started next to the one they really use.
--
-- 1.1.9 DELIVERY (Garage app "Pedir entrega", engine in server/garage.lua): the ONLY write the phone makes to a
-- garage's data. Once the phone has checked (list) that the vehicle is in a garage, it marks it OUT the way that
-- garage reads it and creates it next to the player. The engine always starts from the framework's own column
-- (ESX owned_vehicles.stored = 0, QBCore/QBox player_vehicles.state = 0: the column ESX's xVehicle, qb-garages and
-- most garages keep in step) and adds the provider's own:
--   deliverOut(row) -> { column = value, ... }   extra columns that mean "out" in this garage (PI.SQL_NULL = NULL)
--   deliverBase = false                          skip the framework column (op-garages, where 1 means out)
--   deliverAfter(src, cid, plate, veh, netId, row)  after the spawn (anti-dupe registries), always in pcall
-- Only columns that EXIST in the table are written, in ONE conditional UPDATE that also checks the values just
-- read (compare-and-set): a garage that takes the same car out in between makes the delivery fail cleanly, never
-- a second copy. When none of those columns changes (a garage that keeps its state somewhere the phone cannot
-- see), the delivery is REFUSED rather than guessed: a buyer's adapter can give takeOut/putBack instead
-- (integrations/custom.lua).
-- ------------------------------------------------------------
local PI = PhoneIntegrations
if not PI then return end   -- server/integrations.lua did not load: server/integrations/escrow_check.lua says why in the console

-- delivery: "write NULL" in deliverOut (a nil would just drop the key from the table)
PI.SQL_NULL = PI.SQL_NULL or setmetatable({}, { __tostring = function() return 'NULL' end })

local function vehTable()
    if FW.name == 'esx' then return 'owned_vehicles', 'owner' end
    return 'player_vehicles', 'citizenid'
end

local function q(sql, args)
    local ok, rows = pcall(function() return MySQL.query.await(sql, args) end)
    if ok and type(rows) == 'table' then return rows end
    return nil, rows
end

-- non-empty string (NULL, '' and 'null' are "nothing")
local function nz(s)
    if s == nil or s == false then return nil end
    s = tostring(s)
    if s == '' or s == 'null' or s == 'NULL' then return nil end
    return s
end

local function isOne(v) return v == true or tonumber(v) == 1 end

-- fields every adapter shares: plate, model, hash, fuel/engine/body, mileage (framework row)
local function common(r)
    local props = PI.decode(FW.name == 'esx' and r.vehicle or r.mods)
    local model
    if FW.name == 'esx' then model = r.model or r.vehicle_name or r.vehiclename or props.modelName or props.name or props.model
    else model = r.vehicle or props.modelName or props.model end
    local label = r.vehiclename or r.vehicle_name or r.custom_label or r.label
    if r.name ~= nil and r.name ~= 'Unknown' and label == nil and FW.name == 'esx' then label = r.name end
    return {
        plate = r.plate, model = model ~= nil and tostring(model) or nil, hash = tonumber(r.hash) or tonumber(props.model),
        label = (type(label) == 'string' and label ~= '') and label or nil,
        fuel = PI.num(r.fuel) or PI.num(props.fuelLevel), engine = PI.num(r.engine) or PI.num(props.engineHealth),
        body = PI.num(r.body) or PI.num(props.bodyHealth),
        mileage = PI.num(r.drivingdistance) or PI.num(r.mileage) or PI.num(props.mileage) or PI.num(props.odometer),
    }
end

local function ownedRows(cid, extraWhere)
    local tbl, col = vehTable()
    local rows, err = q(('SELECT * FROM %s WHERE %s = ?%s'):format(tbl, col, extraWhere or ''), { cid })
    if not rows and extraWhere then rows, err = q(('SELECT * FROM %s WHERE %s = ?'):format(tbl, col), { cid }) end
    -- a broken query must reach the dispatcher (fallback to builtin + warning), not look like "no vehicles"
    if not rows then error(('%s query failed: %s'):format(tbl, tostring(err))) end
    return rows
end

-- export that must answer: a failure is raised so the dispatcher falls back to builtin with one warning
local function mustExport(res, name, ...)
    local ok, r = PI.callExport(res, name, ...)
    if not ok or type(r) ~= 'table' then error(('%s:%s failed: %s'):format(res, name, tostring(r))) end
    return r
end

-- export that may be missing (older versions): nil on any failure
local function tryExport(res, name, ...)
    local ok, r, r2, r3 = PI.callExport(res, name, ...)
    if not ok then return nil end
    return r, r2, r3
end

-- every plate in the world right now (server entities, OneSync): plateKey -> entity
local function worldPlates()
    local set = {}
    local ok, vehs = pcall(GetAllVehicles)
    if not ok or type(vehs) ~= 'table' then return set end
    for _, e in ipairs(vehs) do
        local okP, p = pcall(GetVehicleNumberPlateText, e)
        if okP and p then set[PI.plateKey(p)] = e end
    end
    return set
end

local function playerPos(src)
    local ok, c = pcall(function() return GetEntityCoords(GetPlayerPed(src)) end)
    if ok and c then return PI.xyz(c) end
    return nil
end

-- the entry of `list` ({ coords = {x,y,z}, ... }) closest to the player; the first one when unknown
local function nearest(list, pos)
    local best, bestD
    for _, e in ipairs(list) do
        if e.coords then
            if not pos then return e end
            local dx, dy = e.coords.x - pos.x, e.coords.y - pos.y
            local d = dx * dx + dy * dy
            if not bestD or d < bestD then best, bestD = e, d end
        end
    end
    return best
end

local function centroid(points)
    if type(points) ~= 'table' then return nil end
    local sx, sy, sz, n = 0, 0, 0, 0
    for _, p in ipairs(points) do
        local c = PI.xyz(p)
        if c then sx, sy, sz, n = sx + c.x, sy + c.y, sz + c.z, n + 1 end
    end
    if n == 0 then return nil end
    return { x = sx / n, y = sy / n, z = sz / n }
end

-- first usable {x,y,z} among the candidates (a vector of zeros counts as "not set")
local function firstXYZ(...)
    for i = 1, select('#', ...) do
        local c = PI.xyz((select(i, ...)))
        if c and not (c.x == 0 and c.y == 0) then return c end
    end
    return nil
end

-- live world position first (same as builtin), then the resource's own idea of where the car is
local function trackWith(src, cid, plate, fallback)
    local B = PI.builtin and PI.builtin.garage
    if B and PI.isCallable(B.track) then
        local c = B.track(src, cid, plate)
        if c then return c end
    end
    if fallback then
        local ok, c = pcall(fallback)
        if ok then return PI.xyz(c) end
    end
    return nil
end

-- ------------------------------------------------------------
-- apex_garage (VERIFIED against apex_garage 1.1.2, our own resource)
--   in_garage 0/1 (ESX: in_garage OR stored, the resource writes both), garage_id, nickname, mileage (km);
--   job_vehicle / gang_vehicle rows are not personal. Impound = an OPEN record in apex_garage_impounds
--   (released_at IS NULL): the vehicle row keeps in_garage = 0 and the origin garage_id, so without the
--   record an impounded car looks "out". Records through export GetOpenImpounds(identifier).
--   Locations: export GetConfiguredGarages() (Config.garages: label, access), then apex_garage_garages
--   (in-game created: gid, label, zone {x,y,z}, spawns), then apex_garage_private ('priv_<id>', x, y, z).
-- ------------------------------------------------------------
local function apexLocations()
    local locs = {}
    local cfgG = tryExport('apex_garage', 'GetConfiguredGarages')
    if type(cfgG) == 'table' then
        for id, g in pairs(cfgG) do
            if type(g) == 'table' then
                locs[tostring(id)] = { label = g.label, coords = firstXYZ(g.access, g.store, type(g.spawns) == 'table' and g.spawns[1] or nil) }
            end
        end
    end
    for _, r in ipairs(q('SELECT gid, label, zone, spawns FROM `apex_garage_garages`') or {}) do
        if r.gid ~= nil and not locs[tostring(r.gid)] then
            local sp = PI.decode(r.spawns)
            locs[tostring(r.gid)] = { label = r.label, coords = firstXYZ(PI.decode(r.zone), sp[1]) }
        end
    end
    for _, r in ipairs(q('SELECT id, label, x, y, z FROM `apex_garage_private`') or {}) do
        locs['priv_' .. tostring(r.id)] = { label = r.label, coords = firstXYZ(r) }
    end
    return locs
end

PI.define('garage', 'apex_garage', {
    label = 'apex_garage', resources = { 'apex_garage' },
    list = function(src, cid)
        local held = {}
        local imp = tryExport('apex_garage', 'GetOpenImpounds', cid)
        if type(imp) ~= 'table' then
            imp = q('SELECT plate, garage_id FROM `apex_garage_impounds` WHERE owner = ? AND released_at IS NULL', { cid }) or {}
        end
        for _, r in ipairs(imp) do
            if type(r) == 'table' and r.plate then held[PI.plateKey(r.plate)] = r end
        end
        local locs, out = apexLocations(), {}
        for _, r in ipairs(ownedRows(cid, ' AND job_vehicle = 0 AND gang_vehicle = 0')) do
            local v = common(r)
            local h = held[PI.plateKey(r.plate)]
            local gid
            if h then
                v.state, gid = 'impound', h.garage_id
            else
                local inG = isOne(r.in_garage) or (FW.name == 'esx' and isOne(r.stored))
                v.state, gid = inG and 'garage' or 'out', r.garage_id
            end
            gid = nz(gid)
            local loc = gid and locs[gid] or nil
            v.garage, v.garageLabel, v.coords = gid, loc and loc.label or nil, loc and loc.coords or nil
            v.nickname = nz(r.nickname)
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    -- delivery: o mesmo UPDATE que o take-out do apex_garage faz (in_garage = 0 e, no ESX, stored = 0 pela base) e o
    -- carro entra no mapa anti-dupe dele com o netId (export RegisterVehicleOutside): sem isso o "Recover & drive" via
    -- in_garage = 0 sem claim e cobrava a taxa de recuperação por um carro que está na rua, à frente do dono.
    deliverOut = function() return { in_garage = 0 } end,
    deliverAfter = function(src, cid, plate, veh, netId)
        PI.callExport('apex_garage', 'RegisterVehicleOutside', plate, netId)
    end,
})

-- ------------------------------------------------------------
-- jg-advancedgarages (VERIFIED against the local v3.2.1: install/run-*.sql, framework/main.lua,
-- server/sv-impound.lua, sv-garage.lua; v4 from the official docs: same columns, garages in the DB)
--   in_garage 0/1, impound 0/1 (wins over in_garage: impounding does not touch in_garage), garage_id =
--   garage (or impound) NAME, nickname, mileage; job/gang vehicles excluded.
--   coords: export getAllGarages() (v3 and v4: { name, label, takeVehicle }, covers DB garages of v4 and
--   private ones), then config/config.lua *Locations[name].coords (v3), then player_priv_garages (x, y, z)
-- ------------------------------------------------------------
local function jgCoords(name)
    if name == nil then return nil end
    for _, t in ipairs({ 'Config.GarageLocations', 'Config.ImpoundLocations', 'Config.JobGarageLocations', 'Config.GangGarageLocations' }) do
        local list = PI.readResourceTable('jg-advancedgarages', 'config/config.lua', t)
        local g = type(list) == 'table' and list[name] or nil
        if type(g) == 'table' then return PI.xyz(g.coords) end
    end
    return nil
end

PI.define('garage', 'jg-advancedgarages', {
    label = 'jg-advancedgarages', resources = { 'jg-advancedgarages' },
    list = function(src, cid)
        local byName = {}
        local all = tryExport('jg-advancedgarages', 'getAllGarages')
        if type(all) == 'table' then
            for k, g in pairs(all) do
                if type(g) == 'table' then
                    local n = g.name or (type(k) == 'string' and k) or nil
                    if n ~= nil then byName[tostring(n)] = firstXYZ(g.takeVehicle, g.putVehicle, g.spawnPoint, g.coords) end
                end
            end
        end
        local out, priv = {}, nil
        for _, r in ipairs(ownedRows(cid, ' AND job_vehicle = 0 AND gang_vehicle = 0')) do
            local v = common(r)
            v.state = isOne(r.impound) and 'impound' or isOne(r.in_garage) and 'garage' or 'out'
            v.garage = r.garage_id
            v.nickname = r.nickname
            v.coords = (r.garage_id ~= nil and byName[tostring(r.garage_id)]) or jgCoords(r.garage_id)
            if not v.coords and r.garage_id then
                priv = priv or {}
                if priv[r.garage_id] == nil then
                    local g = q('SELECT x, y, z FROM player_priv_garages WHERE name = ? LIMIT 1', { r.garage_id })
                    priv[r.garage_id] = (g and g[1]) and PI.xyz(g[1]) or false
                end
                v.coords = priv[r.garage_id] or nil
            end
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    deliverOut = function() return { in_garage = 0 } end,   -- delivery: o take-out do jg só escreve in_garage = 0
})

-- ------------------------------------------------------------
-- cd_garage (DOCS: docs.codesign.pro v6 exports/phone integration + the v5 archive) verified = false
--   in_garage 0 out / 1 in / 2 impound, garage_id (v6: random id, never shown), custom_label (v5)
--   label: export GetGarageLabelFromGarageId (v6.0.3+); coords: export GetGarageLocations() keyed by
--   garage_id, { garage_label, coords = { open = {x,y,z}, spawn = {...} } } (v6), older flat shapes
--   searched defensively; the impound lot of an impounded car from GetVehicleImpoundData(plate)
-- ------------------------------------------------------------
local function cdLocations()
    local locs = tryExport('cd_garage', 'GetGarageLocations')
    local byId = {}
    if type(locs) ~= 'table' then return byId end
    for k, g in pairs(locs) do
        if type(g) == 'table' then
            local gid = g.garage_id or g.Garage_ID or g.id or g.garageId or k
            local c = type(g.coords) == 'table' and (g.coords.open or g.coords.spawn) or nil
            byId[tostring(gid)] = {
                label = g.garage_label or g.label,
                coords = firstXYZ(c, g.coords, { x = g.x_1 or g.x, y = g.y_1 or g.y, z = g.z_1 or g.z }),
            }
        end
    end
    return byId
end

PI.define('garage', 'cd_garage', {
    label = 'cd_garage', resources = { 'cd_garage' }, verified = false,
    list = function(src, cid)
        local out, labels = {}, {}
        local locs = cdLocations()
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local st = tonumber(r.in_garage)
            if st == nil and r.in_garage == true then st = 1 end
            v.state = (st == 2 or isOne(r.impound)) and 'impound' or (st == 1) and 'garage' or 'out'
            local gid = nz(r.garage_id or r.garage)
            if v.state == 'impound' then
                -- v6 { impound = { id, label } } / v5 flat { impound, impound_label }
                local d = tryExport('cd_garage', 'GetVehicleImpoundData', r.plate)
                if type(d) == 'table' then
                    local i = type(d.impound) == 'table' and d.impound or nil
                    local lot = nz(i and i.id or (type(d.impound) ~= 'table' and d.impound or nil))
                    if lot then gid = lot end
                    local lbl = nz(i and i.label or d.impound_label)
                    if lbl then labels[gid or lbl] = labels[gid or lbl] or lbl end
                end
            end
            v.garage = gid
            if gid ~= nil then
                if labels[gid] == nil then
                    local l = tryExport('cd_garage', 'GetGarageLabelFromGarageId', gid)
                    labels[gid] = (type(l) == 'string' and l ~= '') and l or (locs[gid] and locs[gid].label) or false
                end
                v.garageLabel = labels[gid] or nil
                v.coords = locs[gid] and locs[gid].coords or nil
            end
            if nz(r.custom_label) then v.nickname = r.custom_label end
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    deliverOut = function() return { in_garage = 0 } end,   -- delivery: 0 = fora (1 garagem, 2 depósito)
})

-- ------------------------------------------------------------
-- okokGarage (DOCS: okokGarage config + qb-phone support page) verified = false
--   QB: state 0/1/2 + garage/parking id; ESX: stored + parking, impound when impoundTime is set
--   coords: config.lua Config.Garages (array, .id / .coords) and Config.Impound
-- ------------------------------------------------------------
local function okokCoords(id)
    local list = PI.readResourceTable('okokGarage', 'config.lua', 'Config.Garages')
    if type(list) ~= 'table' then return nil, nil end
    for _, g in pairs(list) do
        if type(g) == 'table' and g.id ~= nil and tostring(g.id) == tostring(id) then return PI.xyz(g.coords), g.name end
    end
    return nil, nil
end

PI.define('garage', 'okokGarage', {
    label = 'okokGarage', resources = { 'okokGarage' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            if FW.name == 'esx' then
                local impounded = (type(r.impoundTime) == 'string' and r.impoundTime ~= '') or (type(r.pound) == 'string' and r.pound ~= '')
                v.state = impounded and 'impound' or (tonumber(r.stored) == 1 or r.stored == true) and 'garage' or 'out'
            else
                v.state = PI.vehState(r.state)
            end
            local gid = r.parking or r.garage
            v.garage = gid
            if gid ~= nil then
                local c, name = okokCoords(gid)
                v.coords, v.garageLabel = c, name
            end
            if type(r.vehiclename) == 'string' and r.vehiclename ~= '' then v.label = r.vehiclename end
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- qs-advancedgarages (DOCS: Quasar install SQL + the stock lb-phone qs branch) verified = false
--   garage = garage NAME, 'OUT' when out (ESX: the only state; QB: the framework `state` 0/1/2 is kept);
--   jobVehicle non-empty = job car (excluded). Garages created in game: player_garages (name, coords JSON
--   { menuCoords, spawnCoords }, isImpound). Export GetGarages() is tried first (recent builds only).
-- ------------------------------------------------------------
local function qsGarages()
    local map = {}
    local list = tryExport('qs-advancedgarages', 'GetGarages')
    if type(list) == 'table' then
        for k, g in pairs(list) do
            if type(g) == 'table' then
                local c = type(g.coords) == 'table' and g.coords or {}
                local n = tostring(g.name or g.id or k)
                map[n] = { label = g.label or g.name, impound = isOne(g.isImpound), coords = firstXYZ(c.menuCoords, c.spawnCoords, g.coords) }
            end
        end
    end
    for _, r in ipairs(q('SELECT name, coords, isImpound FROM player_garages') or {}) do
        if r.name ~= nil and not map[tostring(r.name)] then
            local c = PI.decode(r.coords)
            map[tostring(r.name)] = { label = r.name, impound = isOne(r.isImpound), coords = firstXYZ(c.menuCoords, c.spawnCoords, c) }
        end
    end
    return map
end

PI.define('garage', 'qs-advancedgarages', {
    label = 'qs-advancedgarages', resources = { 'qs-advancedgarages' }, verified = false,
    list = function(src, cid)
        local gmap, out = qsGarages(), {}
        for _, r in ipairs(ownedRows(cid)) do
            if not nz(r.jobVehicle) then
                local v = common(r)
                local g = nz(r.garage)
                local isOut = (g == nil) or g:upper() == 'OUT'
                local info = (not isOut) and gmap[g] or nil
                if FW.name ~= 'esx' and tonumber(r.state) ~= nil then v.state = PI.vehState(r.state)
                else v.state = isOut and 'out' or 'garage' end
                if v.state == 'garage' and info and info.impound then v.state = 'impound' end
                if not isOut then
                    v.garage, v.garageLabel, v.coords = g, info and info.label or nil, info and info.coords or nil
                end
                out[#out + 1] = v
            end
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    -- delivery: 'OUT' é o que o list acima lê como fora (no QB o `state` = 0 vai pela base)
    deliverOut = function() return { garage = 'OUT' } end,
})

-- ------------------------------------------------------------
-- vms_garagesv2 (DOCS: installation SQL + VMS's own lb-phone/qs-smartphone integration code) verified = false
--   garage = Config.Garages / Config.Impounds key while the car is inside, NULL when out;
--   impound_date set = in an impound (also brand-new cars delivered to the impound); company / gang set =
--   job or gang car (excluded). Label and coords: export getGarageInfo(id) -> label, coords.
-- ------------------------------------------------------------
PI.define('garage', 'vms_garagesv2', {
    label = 'vms_garagesv2', resources = { 'vms_garagesv2' }, verified = false,
    list = function(src, cid)
        local info, out = {}, {}
        for _, r in ipairs(ownedRows(cid)) do
            if not nz(r.company) and not nz(r.gang) then
                local v = common(r)
                local g = nz(r.garage)
                v.state = (r.impound_date ~= nil and nz(r.impound_date)) and 'impound' or g and 'garage' or 'out'
                if g then
                    if info[g] == nil then
                        local ok, label, coords = PI.callExport('vms_garagesv2', 'getGarageInfo', g)
                        info[g] = ok and { label = type(label) == 'string' and label or nil, coords = firstXYZ(coords) } or false
                    end
                    v.garage = g
                    v.garageLabel = info[g] and info[g].label or nil
                    v.coords = info[g] and info[g].coords or nil
                end
                v.mileage = v.mileage or PI.num(r.milage)
                out[#out + 1] = v
            end
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    deliverOut = function() return { garage = PI.SQL_NULL } end,   -- delivery: garage NULL = fora
})

-- ------------------------------------------------------------
-- codem-garagesv2 "Supreme Garages" (DOCS: codem gitbook exports page) verified = false
--   exports GetPlayerVehicles(citizenId) (rows: plate, state 0 out / 1 in / 2 impounded, garage, fuel,
--   engine, body, props), GetGarages() / GetImpounds() keyed by name ({ label, coords }), GetImpoundData(plate)
-- ------------------------------------------------------------
PI.define('garage', 'codem-garagesv2', {
    label = 'codem-garagesv2', resources = { 'codem-garagesv2' }, verified = false,
    list = function(src, cid)
        local rows = mustExport('codem-garagesv2', 'GetPlayerVehicles', cid)
        local garages = tryExport('codem-garagesv2', 'GetGarages') or {}
        local impounds = tryExport('codem-garagesv2', 'GetImpounds') or {}
        local function place(name)
            if name == nil then return nil end
            local g = (type(garages) == 'table' and garages[name]) or (type(impounds) == 'table' and impounds[name]) or nil
            if type(g) ~= 'table' then return nil end
            return { label = g.label, coords = firstXYZ(g.coords, g.coord, g.position) }
        end
        local out = {}
        for _, r in ipairs(rows) do
            if type(r) == 'table' and r.plate and not nz(r.fleet) then
                local props = PI.decode(r.props or r.mods or (FW.name == 'esx' and r.vehicle or nil))
                local model = r.model or r.modelName or (FW.name ~= 'esx' and r.vehicle or nil) or props.model
                local v = {
                    plate = r.plate, model = model ~= nil and tostring(model) or nil, hash = tonumber(r.hash) or tonumber(props.model),
                    state = PI.vehState(r.state),
                    fuel = PI.num(r.fuel) or PI.num(props.fuelLevel), engine = PI.num(r.engine) or PI.num(props.engineHealth),
                    body = PI.num(r.body) or PI.num(props.bodyHealth), mileage = PI.num(r.mileage),
                }
                local gid = nz(r.garage)
                if v.state == 'impound' then
                    local imp = type(r.impound) == 'table' and r.impound or tryExport('codem-garagesv2', 'GetImpoundData', r.plate)
                    if type(imp) == 'table' and nz(imp.lot) then gid = imp.lot end
                end
                local p = place(gid)
                v.garage, v.garageLabel, v.coords = gid, p and p.label or nil, p and p.coords or nil
                v.nickname = nz(r.nickname or r.custom_label or r.label)
                out[#out + 1] = v
            end
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- codem-garage / mGarage v1.3 (columns and config read in the v1.3 source: esx/qb-insert.sql,
-- server/main.lua, config.lua; marked best effort because only unofficial copies of it are public)
--   ESX: stored 0/1; QB: the framework `state` (0/1, 2 from police scripts); parking = Config.Garages KEY.
--   coords: config.lua Config.Garages[key].car.garage (store point) / .npc.npc, Config.JobGarages likewise
-- ------------------------------------------------------------
local function codemPlace(key)
    if key == nil then return nil end
    for _, t in ipairs({ 'Config.Garages', 'Config.JobGarages' }) do
        local list = PI.readResourceTable('codem-garage', 'config.lua', t)
        local g = type(list) == 'table' and list[key] or nil
        if type(g) == 'table' then
            local car, npc = type(g.car) == 'table' and g.car or {}, type(g.npc) == 'table' and g.npc or {}
            return firstXYZ(car.garage, npc.npc, car.spawncar)
        end
    end
    return nil
end

PI.define('garage', 'codem-garage', {
    label = 'codem-garage', resources = { 'codem-garage' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            if FW.name == 'esx' then v.state = PI.vehState(tonumber(r.stored) or (r.stored == true and 1) or 0)
            else v.state = PI.vehState(tonumber(r.state) or 0) end
            local key = nz(r.parking)
            v.garage, v.coords = key, codemPlace(key)
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- op-garages v3 (DOCS: OTHERPLANET exports page + their own lb-phone integration code) verified = false
--   stored (ESX) / state (QB) is INVERTED: 0 = in the garage, 1 = out; vehicleGarage = garage index,
--   isTowedOut 1 = impounded at vehicleImpound (impound index).
--   exports getGarageByIndex(idx) { Label, AccessPoint, CenterOfZone }, getImpoundByIndex(idx) { Label, Coords }
--   (the docs show both wrapped in their key, their own code reads .Label directly: both handled)
-- ------------------------------------------------------------
local function opPlace(fn, idx)
    if idx == nil then return nil end
    local g = tryExport('op-garages', fn, tostring(idx))
    if type(g) ~= 'table' then return nil end
    if g.Label == nil and type(g[tostring(idx)]) == 'table' then g = g[tostring(idx)] end
    return { label = g.Label, coords = firstXYZ(g.AccessPoint, g.CenterOfZone, g.Coords, g.onespawn) }
end

PI.define('garage', 'op-garages', {
    label = 'op-garages', resources = { 'op-garages' }, verified = false,
    list = function(src, cid)
        local cache, out = {}, {}
        local function place(fn, idx)
            local key = fn .. tostring(idx)
            if cache[key] == nil then cache[key] = opPlace(fn, idx) or false end
            return cache[key] or nil
        end
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local raw = r.stored
            if FW.name ~= 'esx' or raw == nil then raw = r.state end
            local storedNum = tonumber(raw) or (raw == true and 1) or 0
            local p
            if isOne(r.isTowedOut) then
                v.state, v.garage = 'impound', nz(r.vehicleImpound)
                p = v.garage and place('getImpoundByIndex', v.garage) or nil
            else
                v.state, v.garage = (storedNum == 0) and 'garage' or 'out', nz(r.vehicleGarage)
                p = v.garage and place('getGarageByIndex', v.garage) or nil
            end
            v.garageLabel, v.coords = p and p.label or nil, p and p.coords or nil
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    -- delivery: aqui 1 = FORA, por isso a base (stored/state = 0, que no op-garages quer dizer "na garagem") fica de
    -- fora; a coluna é a mesma que o list acima lê (ESX: stored, ou state quando o stored não existe)
    deliverBase = false,
    deliverOut = function(r)
        if FW.name == 'esx' and r.stored ~= nil then return { stored = 1 } end
        return { state = 1 }
    end,
})

-- ------------------------------------------------------------
-- kartik-garages (DOCS: kartik-scripts gitbook server exports) verified = false
--   exports GetPlayerVehicles(citizenId) -> { plate, model, garage, status ('Stored'|'Out'|'Impounded'|
--   'Parked'), mileage }, GetGarage(id) (shape undocumented: label/coords searched defensively),
--   GetParkedVehicle(plate) (street-parking record) for "locate". Fuel/engine/body from the framework row.
-- ------------------------------------------------------------
local KARTIK_STATE = { stored = 'garage', out = 'out', parked = 'out', impounded = 'impound' }

PI.define('garage', 'kartik-garages', {
    label = 'kartik-garages', resources = { 'kartik-garages' }, verified = false,
    list = function(src, cid)
        local rows = mustExport('kartik-garages', 'GetPlayerVehicles', cid)
        local extra = {}
        for _, r in ipairs(q(('SELECT * FROM %s WHERE %s = ?'):format(vehTable()), { cid }) or {}) do
            if r.plate then extra[PI.plateKey(r.plate)] = common(r) end
        end
        local places, out = {}, {}
        for _, r in ipairs(rows) do
            if type(r) == 'table' and r.plate then
                local e = extra[PI.plateKey(r.plate)] or {}
                local gid = nz(r.garage)
                if gid and places[gid] == nil then
                    local g = tryExport('kartik-garages', 'GetGarage', gid)
                    places[gid] = type(g) == 'table' and {
                        label = g.label or g.name,
                        coords = firstXYZ(g.coords, g.location, g.position, g.entry, g.blip, type(g.spawn_coords) == 'table' and g.spawn_coords[1] or g.spawn_coords),
                    } or false
                end
                local p = gid and places[gid] or nil
                out[#out + 1] = {
                    plate = r.plate, model = r.model ~= nil and tostring(r.model) or e.model, hash = e.hash,
                    state = KARTIK_STATE[tostring(r.status or ''):lower()] or 'out',
                    garage = gid, garageLabel = p and p.label or nil, coords = p and p.coords or nil,
                    fuel = e.fuel, engine = e.engine, body = e.body, mileage = PI.num(r.mileage) or e.mileage,
                }
            end
        end
        return out
    end,
    track = function(src, cid, plate)
        return trackWith(src, cid, plate, function()
            local rec = tryExport('kartik-garages', 'GetParkedVehicle', plate)
            return type(rec) == 'table' and (rec.coords or rec) or nil
        end)
    end,
})

-- ------------------------------------------------------------
-- tgiann-realparking (DOCS: tgiann gitbook exports page) verified = false
--   exports GetPlayerVehicleDetails(citizenid) -> { plate, properties, state 'garaged'|'out'|'impounded',
--   garageKey?, garageLabel?, coords?, netId?, job? } (yields while its garages load),
--   GetGarageList() -> [key] = { label, type 'garage'|'impound', x, y, z }. An impounded car has no lot
--   in the record: the GPS goes to the impound closest to the player.
-- ------------------------------------------------------------
local TGIANN_STATE = { garaged = 'garage', out = 'out', impounded = 'impound' }

PI.define('garage', 'tgiann-realparking', {
    label = 'tgiann-realparking', resources = { 'tgiann-realparking' }, verified = false,
    list = function(src, cid)
        local rows = mustExport('tgiann-realparking', 'GetPlayerVehicleDetails', cid)
        local glist = tryExport('tgiann-realparking', 'GetGarageList') or {}
        local impounds, pos = {}, nil
        if type(glist) == 'table' then
            for k, g in pairs(glist) do
                if type(g) == 'table' and g.type == 'impound' then impounds[#impounds + 1] = { key = k, label = g.label, coords = firstXYZ(g) } end
            end
        end
        local out = {}
        for _, r in ipairs(rows) do
            if type(r) == 'table' and r.plate then
                local props = PI.decode(r.properties)
                local v = {
                    plate = r.plate, model = props.modelName or (props.model ~= nil and tostring(props.model) or nil), hash = tonumber(props.model),
                    state = TGIANN_STATE[tostring(r.state or '')] or 'out',
                    fuel = PI.num(props.fuelLevel), engine = PI.num(props.engineHealth), body = PI.num(props.bodyHealth),
                }
                if v.state == 'garage' then
                    local g = r.garageKey and type(glist) == 'table' and glist[r.garageKey] or nil
                    v.garage = nz(r.garageKey)
                    v.garageLabel = r.garageLabel or (type(g) == 'table' and g.label) or nil
                    v.coords = firstXYZ(r.coords, g)
                elseif v.state == 'impound' then
                    pos = pos or playerPos(src) or false
                    local i = nearest(impounds, pos or nil)
                    if i then v.garage, v.garageLabel, v.coords = tostring(i.key), i.label, i.coords end
                end
                out[#out + 1] = v
            end
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- tgiann-garage (old, DOCS: tgiann gitbook SQL files) verified = false
--   stored 1 = in a garage, 0 = out (impound not stored in a documented way); garageNumber = index of
--   its client-only config (no coordinates readable on the server); job non-empty = job car (excluded)
-- ------------------------------------------------------------
PI.define('garage', 'tgiann-garage', {
    label = 'tgiann-garage', resources = { 'tgiann-garage' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            if not nz(r.job) then
                local v = common(r)
                local st = r.stored
                if st == nil then st = r.state end
                v.state = isOne(st) and 'garage' or (tonumber(st) == 2 and 'impound') or 'out'
                v.garage = nz(r.garageNumber)
                out[#out + 1] = v
            end
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    deliverOut = function() return { stored = 0 } end,   -- delivery: o list lê o stored primeiro (também no QB)
})

-- ------------------------------------------------------------
-- ak47_garage (multi-framework, DOCS: docs.menanak47.com) verified = false
--   framework table: stored 0 out / 1 stored / 2 impounded (QB builds that keep `state` are read too),
--   garage = garage id, customname = nickname.
--   exports GetGarageById(gid) { name, polyzone { points }, spawns { {x,y,z,w} } }, GetVehicleLocation(plate)
-- ------------------------------------------------------------
PI.define('garage', 'ak47_garage', {
    label = 'ak47_garage', resources = { 'ak47_garage' }, verified = false,
    list = function(src, cid)
        local places, out = {}, {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local st = tonumber(r.stored)
            if st == nil then st = (r.stored == true and 1) or tonumber(r.state) or 0 end
            v.state = PI.vehState(st)
            local gid = nz(r.garage)
            if gid and places[gid] == nil then
                local g = tryExport('ak47_garage', 'GetGarageById', gid)
                if type(g) == 'table' then
                    local pz = type(g.polyzone) == 'table' and g.polyzone or {}
                    places[gid] = { label = g.name or g.label, coords = firstXYZ(type(g.spawns) == 'table' and g.spawns[1] or nil, centroid(pz.points), g.coords) }
                else
                    places[gid] = false
                end
            end
            local p = gid and places[gid] or nil
            v.garage, v.garageLabel, v.coords = gid, p and p.label or nil, p and p.coords or nil
            v.nickname = nz(r.customname)
            out[#out + 1] = v
        end
        return out
    end,
    deliverOut = function() return { stored = 0 } end,   -- delivery: o ak47 usa o stored nos dois frameworks
    track = function(src, cid, plate)
        return trackWith(src, cid, plate, function() return (tryExport('ak47_garage', 'GetVehicleLocation', plate)) end)
    end,
})

-- QBCore vehicle rule shared by qb-garages / ak47_qb_garage / MojiaGarages: state 1 = garaged, 2 = impounded,
-- 0 = out, EXCEPT 0 with depotprice > 0 = waiting at the depot (qb-policejob's depot impound and the
-- restart sweep write exactly that: qb-garages server.lua:13 and :180, qb-policejob vehicle.lua:42)
local function qbState(state, depotprice)
    local st = tonumber(state) or 0
    if st == 1 then return 'garage' end
    if st == 2 then return 'impound' end
    if (tonumber(depotprice) or 0) > 0 then return 'impound' end
    return 'out'
end

-- ------------------------------------------------------------
-- ak47_qb_garage (QBCore-only legacy build, DOCS: its integration page uses state + depotprice) verified = false
-- ------------------------------------------------------------
PI.define('garage', 'ak47_qb_garage', {
    label = 'ak47_qb_garage', resources = { 'ak47_qb_garage' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            v.state = qbState(r.state, r.depotprice)
            v.garage = nz(r.garage)
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- zerio-garage (DOCS: Zerio's documentation repo) verified = false
--   only the documented part is mapped: ESX stored / QB state (framework columns), nickname column,
--   garage id from the framework `garage` column when present, labels/coords from exports GetGarages()
--   and GetImpounds() (arrays of { name, label?, coords? }). How it marks an impound on the row is not
--   documented: a state 2 is shown as impounded, nothing else is guessed.
-- ------------------------------------------------------------
PI.define('garage', 'zerio-garage', {
    label = 'zerio-garage', resources = { 'zerio-garage' }, verified = false,
    list = function(src, cid)
        local places = {}
        for _, fn in ipairs({ 'GetGarages', 'GetImpounds' }) do
            local list = tryExport('zerio-garage', fn)
            if type(list) == 'table' then
                for k, g in pairs(list) do
                    if type(g) == 'table' then
                        local n = g.name or g.id or k
                        places[tostring(n)] = { label = g.label or g.name, coords = firstXYZ(g.coords, g.marker, g.prop, { x = g.prop_x, y = g.prop_y, z = g.prop_z }) }
                    end
                end
            end
        end
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local st = FW.name == 'esx' and r.stored or r.state
            v.state = PI.vehState(tonumber(st) or (st == true and 1) or 0)
            local gid = nz(r.garage)
            local p = gid and places[gid] or nil
            v.garage, v.garageLabel, v.coords = gid, p and p.label or nil, p and p.coords or nil
            v.nickname = nz(r.nickname)
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- renzu_garage (VERIFIED against the GitHub source v1.8: framework/sv_wrapper.lua, server/server.lua,
-- conf/public_garage.lua, conf/impound.lua, *_garage.sql)
--   ESX: stored + garage_id; QB: state + garage. impound 1 = impounded (garage id = the impound lot);
--   isparked 1 + park_coord JSON = parked in the world. Nicknames: GlobalState.VehicleNickNames[plate].
--   coords: conf/public_garage.lua `garagecoord` and conf/impound.lua `impoundcoord` (garage, name, garage_x/y/z)
-- ------------------------------------------------------------
local function renzuPlace(id)
    if id == nil then return nil end
    for _, spec in ipairs({ { 'conf/public_garage.lua', 'garagecoord' }, { 'conf/impound.lua', 'impoundcoord' } }) do
        local list = PI.readResourceTable('renzu_garage', spec[1], spec[2])
        if type(list) == 'table' then
            for _, g in ipairs(list) do
                if type(g) == 'table' and tostring(g.garage) == tostring(id) then
                    return { label = g.name or g.garage, coords = firstXYZ({ x = g.garage_x, y = g.garage_y, z = g.garage_z }) }
                end
            end
        end
    end
    return nil
end

PI.define('garage', 'renzu_garage', {
    label = 'renzu_garage', resources = { 'renzu_garage' },
    list = function(src, cid)
        local okN, nicks = pcall(function() return GlobalState.VehicleNickNames end)
        nicks = (okN and type(nicks) == 'table') and nicks or {}
        local places, out = {}, {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local stored = FW.name == 'esx' and r.stored or r.state
            v.state = isOne(r.impound) and 'impound' or isOne(stored) and 'garage' or 'out'
            local gid = nz(FW.name == 'esx' and r.garage_id or r.garage)
            if gid and places[gid] == nil then places[gid] = renzuPlace(gid) or false end
            local p = gid and places[gid] or nil
            v.garage, v.garageLabel, v.coords = gid, p and p.label or nil, p and p.coords or nil
            local n = nicks[r.plate] or nicks[PI.plate(r.plate)]
            v.nickname = type(n) == 'string' and n ~= '' and n or nil
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate)
        return trackWith(src, cid, plate, function()
            local tbl = vehTable()
            local rows = q(('SELECT park_coord FROM %s WHERE TRIM(UPPER(plate)) = ? AND isparked = 1 LIMIT 1'):format(tbl), { PI.plate(plate):upper() })
            return rows and rows[1] and PI.decode(rows[1].park_coord) or nil
        end)
    end,
})

-- ------------------------------------------------------------
-- rhd_garage (MRI Qbox, VERIFIED against the GitHub source v1.4.1: bridge/framework/qb.lua + esx.lua,
-- server/main.lua, sql/*.sql)
--   QB state / ESX stored: 1 = in a garage, 2 = confiscated by the police (police_impound.garage = lot
--   label), 0 = out when the plate is in the world, else at the insurance lot (shown as impound, like
--   rhd's own phone callback). vehicle_name = nickname.
--   coords: export Garage() -> [name] = { interaction = { coords } | 'keypressed', zones = { points },
--   spawnPoint, impound = true for insurance lots }
-- ------------------------------------------------------------
local function rhdCoords(g)
    if type(g) ~= 'table' then return nil end
    local inter = type(g.interaction) == 'table' and g.interaction.coords or nil
    local zones = type(g.zones) == 'table' and g.zones.points or nil
    return firstXYZ(inter, centroid(zones), type(g.spawnPoint) == 'table' and g.spawnPoint[1] or nil)
end

PI.define('garage', 'rhd_garage', {
    label = 'rhd_garage', resources = { 'rhd_garage' },
    list = function(src, cid)
        local zones = tryExport('rhd_garage', 'Garage') or {}
        local lots, pos, world = {}, nil, nil
        if type(zones) == 'table' then
            for name, g in pairs(zones) do
                if type(g) == 'table' and g.impound == true then lots[#lots + 1] = { name = name, coords = rhdCoords(g) } end
            end
        end
        local seized = {}
        for _, r in ipairs(q('SELECT plate, garage FROM police_impound WHERE citizenid = ?', { cid }) or {}) do
            if r.plate then seized[PI.plateKey(r.plate)] = r.garage end
        end
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local st = tonumber(FW.name == 'esx' and r.stored or r.state) or 0
            local gid = nz(r.garage)
            if st == 1 then
                v.state = 'garage'
            elseif st == 2 then
                v.state = 'impound'
                gid = nz(seized[PI.plateKey(r.plate)]) or gid
            else
                world = world or worldPlates()
                if world[PI.plateKey(r.plate)] then
                    v.state = 'out'
                else
                    v.state = 'impound'
                    pos = pos or playerPos(src) or false
                    local lot = nearest(lots, pos or nil)
                    if lot then gid = tostring(lot.name) end
                end
            end
            local g = gid and type(zones) == 'table' and zones[gid] or nil
            v.garage, v.coords = gid, rhdCoords(g)
            v.nickname = nz(r.vehicle_name)
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- lunar_garage (VERIFIED against the GitHub source v2.0.3: server/db.lua, server/main.lua, config/config.lua)
--   stored 1 = in a garage; otherwise "out" while the car exists in the world, else at the impound
--   (its own rule, server/main.lua:17-33). job set = society car (excluded). No garage per vehicle: any
--   garage of its type works, so the GPS goes to the closest Config.Garages / Config.Impounds entry of
--   that type; the label is Config.Blips[type].Garage / .Impound .Name.
-- ------------------------------------------------------------
local function lunarPlaces(list, vtype)
    local out = {}
    if type(list) ~= 'table' then return out end
    for _, g in ipairs(list) do
        if type(g) == 'table' and (g.Type or 'car') == vtype then
            out[#out + 1] = { coords = firstXYZ(g.Position, g.PedPosition, g.SpawnPosition) }
        end
    end
    return out
end

PI.define('garage', 'lunar_garage', {
    label = 'lunar_garage', resources = { 'lunar_garage' },
    list = function(src, cid)
        local garages = PI.readResourceTable('lunar_garage', 'config/config.lua', 'Config.Garages')
        local impounds = PI.readResourceTable('lunar_garage', 'config/config.lua', 'Config.Impounds')
        local blips = PI.readResourceTable('lunar_garage', 'config/config.lua', 'Config.Blips')
        local world, pos, out = nil, nil, {}
        for _, r in ipairs(ownedRows(cid, ' AND job IS NULL')) do
            if not nz(r.job) then
                local v = common(r)
                local vtype = nz(r.type) or 'car'
                if isOne(r.stored) then
                    v.state = 'garage'
                else
                    world = world or worldPlates()
                    v.state = world[PI.plateKey(r.plate)] and 'out' or 'impound'
                end
                if v.state ~= 'out' then
                    local kind = v.state == 'garage' and 'Garage' or 'Impound'
                    pos = pos or playerPos(src) or false
                    local p = nearest(lunarPlaces(v.state == 'garage' and garages or impounds, vtype), pos or nil)
                    local b = type(blips) == 'table' and type(blips[vtype]) == 'table' and blips[vtype][kind] or nil
                    v.garageLabel = type(b) == 'table' and b.Name or nil
                    v.coords = p and p.coords or nil
                end
                out[#out + 1] = v
            end
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    -- delivery: stored = 0 + o carro no mundo = "out" na regra do próprio lunar (server/main.lua:17-33)
    deliverOut = function() return { stored = 0 } end,
})

-- ------------------------------------------------------------
-- MojiaGarages (QBCore, VERIFIED against the GitHub source v1.1.0: server.lua, config.lua, sql.sql)
--   state 1 garaged / 2 impounded / 0 + depotprice > 0 in the depot / 0 + depotprice 0 out (real parking:
--   posX/posY/posZ = where it was left). config.lua global `Garages` [key] = { label, blippoint,
--   garastate 0 depot / 1 garage / 2 impound }
-- ------------------------------------------------------------
PI.define('garage', 'MojiaGarages', {
    label = 'MojiaGarages', resources = { 'MojiaGarages' },
    list = function(src, cid)
        local all = PI.readResourceTable('MojiaGarages', 'config.lua', 'Garages')
        all = type(all) == 'table' and all or {}
        local lots = { [0] = {}, [2] = {} }
        for key, g in pairs(all) do
            local gs = type(g) == 'table' and tonumber(g.garastate) or nil
            if gs and lots[gs] then lots[gs][#lots[gs] + 1] = { key = key, label = g.label, coords = firstXYZ(g.blippoint) } end
        end
        local pos, out = nil, {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            v.state = qbState(r.state, r.depotprice)
            local gid, label, coords = nz(r.garage), nil, nil
            if v.state == 'garage' then
                local g = gid and all[gid] or nil
                label, coords = type(g) == 'table' and g.label or nil, type(g) == 'table' and firstXYZ(g.blippoint) or nil
            elseif v.state == 'impound' then
                pos = pos or playerPos(src) or false
                local lot = nearest(lots[(tonumber(r.state) == 2) and 2 or 0], pos or nil)
                if lot then gid, label, coords = tostring(lot.key), lot.label, lot.coords end
            end
            v.garage, v.garageLabel, v.coords = gid, label, coords
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate)
        return trackWith(src, cid, plate, function()
            local rows = q('SELECT posX, posY, posZ FROM player_vehicles WHERE TRIM(UPPER(plate)) = ? AND state = 0 LIMIT 1', { PI.plate(plate):upper() })
            local r = rows and rows[1]
            return r and { x = r.posX, y = r.posY, z = r.posZ } or nil
        end)
    end,
})

-- ------------------------------------------------------------
-- t1ger_garage (ESX, VERIFIED against the GitHub source v1.0.6: t1ger_garage.sql, server/main.lua, config.lua)
--   owned_vehicles.state 1 = in a garage (garage = name, unique per vehicle type), 0 = out;
--   garage 'impound' = at the impound of its type; seized 1 = held by the police (Config.Impound.Seize.pos).
--   Society cars are owned by the job name, so `owner = identifier` already leaves them out.
-- ------------------------------------------------------------
PI.define('garage', 't1ger_garage', {
    label = 't1ger_garage', resources = { 't1ger_garage' },
    list = function(src, cid)
        local cfgPath = 'config.lua'
        local garages = PI.readResourceTable('t1ger_garage', cfgPath, 'Config.Garage.Locations')
        local impounds = PI.readResourceTable('t1ger_garage', cfgPath, 'Config.Impound.Locations')
        local seize = PI.readResourceTable('t1ger_garage', cfgPath, 'Config.Impound.Seize')
        local useNames = PI.readResourceTable('t1ger_garage', cfgPath, 'Config.Garage.UseNames')
        local function find(list, name, vtype)
            if type(list) ~= 'table' then return nil end
            for _, g in pairs(list) do
                if type(g) == 'table' and (g.type or 'car') == vtype and (name == nil or tostring(g.name) == tostring(name)) then return g end
            end
            return nil
        end
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local vtype, gname = nz(r.type) or 'car', nz(r.garage)
            local g
            if isOne(r.seized) then
                v.state, v.garage = 'impound', 'impound'
                if type(seize) == 'table' then
                    v.coords = firstXYZ(seize.pos)
                    v.garageLabel = type(seize.blip) == 'table' and seize.blip.name or nil
                end
            elseif gname == 'impound' then
                v.state, v.garage = 'impound', 'impound'
                g = find(impounds, nil, vtype)
            else
                v.state = isOne(r.state) and 'garage' or 'out'
                v.garage = gname
                if gname and gname ~= 'private' then g = find(garages, gname, vtype) end
            end
            if g then
                v.coords = v.coords or firstXYZ(g.pos)
                local bname = type(g.blip) == 'table' and g.blip.name or nil
                if v.state == 'garage' and bname and useNames ~= false then v.garageLabel = bname .. ': ' .. tostring(gname)
                else v.garageLabel = v.garageLabel or bname end
            end
            if v.fuel == nil then v.fuel = PI.num(r.fuel) end
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    deliverOut = function() return { state = 0 } end,   -- delivery: o t1ger usa o `state` mesmo no ESX (não o stored)
})

-- ------------------------------------------------------------
-- esx_advancedgarage (VERIFIED against HumanTree92 source 1.6+ and the 2019 version)
--   owned_vehicles.stored 1 = garage, 0 = out OR at the pound (the resource does not tell them apart),
--   no per-vehicle garage, `name` column = label in 1.6+
-- ------------------------------------------------------------
PI.define('garage', 'esx_advancedgarage', {
    label = 'esx_advancedgarage', resources = { 'esx_advancedgarage' },
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            v.state = (tonumber(r.stored) == 1 or r.stored == true) and 'garage' or 'out'
            if r.garage ~= nil and r.garage ~= 'all' then v.garage = r.garage end
            out[#out + 1] = v
        end
        return out
    end,
})

-- =========================================================================================
-- Framework defaults: LAST, so a specific garage started next to them wins in 'auto'
-- =========================================================================================

-- ------------------------------------------------------------
-- qbx_garages + qbx_vehicles (VERIFIED against qbx_garages 1.1.4 / qbx_vehicles 1.4.2 source)
--   exports.qbx_vehicles:GetPlayerVehicles({ citizenid }) -> { id, modelName, garage, state, props }
--   exports.qbx_garages:GetGarages() -> [name] = { label, accessPoints = { { coords = vec4 } } }
--   state IMPOUNDED (2) = in a depot (qbx_garages SetVehicleGarage to a depot), the garage is the depot
-- ------------------------------------------------------------
PI.define('garage', 'qbx_garages', {
    label = 'qbx_garages', resources = { 'qbx_garages', 'qbx_vehicles' },
    list = function(src, cid)
        local ok, rows = PI.callExport('qbx_vehicles', 'GetPlayerVehicles', { citizenid = cid })
        if not ok or type(rows) ~= 'table' then error('qbx_vehicles:GetPlayerVehicles failed: ' .. tostring(rows)) end
        local okG, garages = PI.callExport('qbx_garages', 'GetGarages')
        garages = (okG and type(garages) == 'table') and garages or {}
        -- fuel/engine/body/plate columns are not returned by the export: read them once
        local extra = {}
        for _, r in ipairs(q('SELECT id, plate, fuel, engine, body, drivingdistance FROM player_vehicles WHERE citizenid = ?', { cid }) or {}) do extra[r.id] = r end
        local out = {}
        for _, r in ipairs(rows) do
            local props = type(r.props) == 'table' and r.props or {}
            local e = extra[r.id] or {}
            local g = r.garage and garages[r.garage] or nil
            local ap = type(g) == 'table' and type(g.accessPoints) == 'table' and g.accessPoints[1] or nil
            out[#out + 1] = {
                plate = e.plate or props.plate, model = r.modelName, hash = tonumber(props.model), garage = r.garage,
                garageLabel = type(g) == 'table' and g.label or nil, state = PI.vehState(r.state),
                fuel = PI.num(e.fuel) or PI.num(props.fuelLevel), engine = PI.num(e.engine) or PI.num(props.engineHealth),
                body = PI.num(e.body) or PI.num(props.bodyHealth), mileage = PI.num(e.drivingdistance),
                coords = ap and PI.xyz(ap.coords) or nil,
            }
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
    -- delivery: state = 0 pela base; o qbx_garages reconhece o carro ao guardar pelo state bag `vehicleid` (e, sem ele,
    -- pela matrícula em qbx_vehicles:GetVehicleIdByPlate): pô-lo poupa a procura e é o que o take-out dele faz
    deliverAfter = function(src, cid, plate, veh, netId, row)
        local id = row and tonumber(row.id)
        if id and veh then Entity(veh).state:set('vehicleid', id, false) end
    end,
})

-- ------------------------------------------------------------
-- qb-garages (VERIFIED against the local + upstream qb-garages: player_vehicles.state 0/1/2, depotprice,
-- export getAllGarages)
--   impounded = state 2 (police seizure) OR state 0 with depotprice > 0 (in the depot: qb-policejob's
--   depot impound and the restart sweep); the GPS of an impounded car goes to the depot (type 'depot')
-- ------------------------------------------------------------
PI.define('garage', 'qb-garages', {
    label = 'qb-garages', resources = { 'qb-garages' },
    list = function(src, cid)
        local ok, all = PI.callExport('qb-garages', 'getAllGarages')
        local byName, depot = {}, nil
        if ok and type(all) == 'table' then
            for _, g in ipairs(all) do
                if type(g) == 'table' and g.name then
                    byName[g.name] = g
                    if g.type == 'depot' and (depot == nil or g.vehicle == 'car' and depot.vehicle ~= 'car') then depot = g end
                end
            end
        end
        local depotPrice = {}
        for _, r in ipairs(q('SELECT plate, depotprice FROM player_vehicles WHERE citizenid = ? AND depotprice > 0', { cid }) or {}) do
            if r.plate then depotPrice[r.plate] = r.depotprice end
        end
        local out = {}
        for _, v in ipairs(FW.GetVehicles(cid, true)) do
            local state = v.state
            if state == 'out' and (tonumber(depotPrice[v.plate]) or 0) > 0 then state = 'impound' end
            local g = v.garage and byName[v.garage] or nil
            if state == 'impound' and depot and not (g and g.type == 'depot') then g = depot end
            local own = (not g) and v.garage and type(Config.Garages) == 'table' and Config.Garages[v.garage] or nil
            out[#out + 1] = {
                plate = v.plate, model = v.model, hash = v.hash, label = v.label, garage = g and g.name or v.garage,
                garageLabel = g and g.label or nil, state = state, fuel = v.fuel, engine = v.engine, body = v.body,
                coords = (g and PI.xyz(g.takeVehicle)) or PI.xyz(own),
            }
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})

-- ------------------------------------------------------------
-- esx_garage (default ESX, VERIFIED against ESX-Legacy-Addons esx_garage 2.0.0 and the legacy 1.x)
--   owned_vehicles: stored 0 = out; 1 = in the garage `parking`, unless `pound` is set (2.0.0 impounds
--   with stored 1 + pound); 2 = impounded at `pound` (1.x). custom_name = nickname, mileage (2.0.0).
--   exports getGarages() / getImpounds(): 2.0.0 arrays { id, label, entryPoint / getOutPoint },
--   1.x tables keyed by name { EntryPoint / GetOutPoint = {x,y,z} }
-- ------------------------------------------------------------
local function esxGaragePlaces()
    local places = {}
    for _, fn in ipairs({ 'getGarages', 'getImpounds' }) do
        local list = tryExport('esx_garage', fn)
        if type(list) == 'table' then
            for k, g in pairs(list) do
                if type(g) == 'table' then
                    local id = tostring(g.id or k)
                    places[id] = { label = g.label or (type(k) == 'string' and k) or id,
                        coords = firstXYZ(g.entryPoint, g.EntryPoint, g.getOutPoint, g.GetOutPoint) }
                end
            end
        end
    end
    return places
end

PI.define('garage', 'esx_garage', {
    label = 'esx_garage', resources = { 'esx_garage' },
    list = function(src, cid)
        local places, out = esxGaragePlaces(), {}
        for _, r in ipairs(ownedRows(cid)) do
            local v = common(r)
            local st = tonumber(r.stored) or (r.stored == true and 1) or 0
            local pound, parking = nz(r.pound), nz(r.parking)
            local gid
            if st == 2 or (st == 1 and pound) then v.state, gid = 'impound', pound
            elseif st == 1 then v.state, gid = 'garage', parking
            else v.state = 'out' end
            local p = gid and places[gid] or nil
            v.garage, v.garageLabel, v.coords = gid, p and p.label or nil, p and p.coords or nil
            v.nickname = nz(r.custom_name)
            out[#out + 1] = v
        end
        return out
    end,
    track = function(src, cid, plate) return trackWith(src, cid, plate) end,
})
