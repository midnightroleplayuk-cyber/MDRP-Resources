-- ====================================================================
-- REGION 12 -- Crane Haul
-- ====================================================================
-- Two phases: load from pile A onto the truck bed, drive to B and unload.
-- Cross-zone, 1-2 players. Bed alignment is measured with the /j12bed tool.
-- ====================================================================

Config.Job12 = {}

Config.Job12.zoneA = 'job12_a'
Config.Job12.zoneB = 'job12_b'

Config.Job12.vehicleSpawn = { coords = vec3(1565.03, 1705.19, 110.13), heading = 89.16 }

Config.Job12.minPlayers    = 1
Config.Job12.maxPlayers    = 2
Config.Job12.cooldownHours = 0

Config.Job12.rentAllowed  = { 'winch' }
Config.Job12.crewProfiles = {
    [1] = { vehicles = { winch = 1 } },
    [2] = { vehicles = { winch = 2 } },
}

Config.Job12.aRespawnSeconds = 4

Config.Job12.networkedBedLoads = false

Config.Job12.freePlacement = true

Config.Job12.cargoPool = {
    'prop_box_wood04a',  'prop_box_wood07a',   'prop_boxpile_02b',
    'prop_cablespool_05','prop_conc_blocks01c','prop_cons_cements01',
    'prop_elecbox_05a',  'prop_portaloo_01a',  'prop_rub_generator',
    'prop_watercrate_01',
}

Config.Job12.manifestSize = 3

Config.Job12.bedRows = {
    { x = 0.0, y = -1.30 },
    { x = 0.0, y = -3.15 },
    { x = 0.0, y = -5.00 },
}
Config.Job12.bedFloorZ = 0.083

Config.Job12.targetSpacing = 2.60

Config.Job12.targetRowSide = 1

Config.Job12.depotShelf = {
    origin  = vec3(1563.019, 1700.194, 110.15),
    right   = vec3(0.0, 1.0, 0.0),
    forward = vec3(1.0, 0.0, 0.0),
    cell    = 2.40,
    rowGap  = 2.60,
    perRow  = 5,
}

function Job12DepotSources()
    local sh = Config.Job12.depotShelf
    local pool = Config.Job12.cargoPool or {}
    if not sh then return {} end
    local out = {}
    for i, model in ipairs(pool) do
        local col = (i - 1) % sh.perRow
        local row = math.floor((i - 1) / sh.perRow)
        out[i] = {
            model  = model,
            coords = vec3(
                sh.origin.x + sh.right.x * (col * sh.cell) + sh.forward.x * (row * sh.rowGap),
                sh.origin.y + sh.right.y * (col * sh.cell) + sh.forward.y * (row * sh.rowGap),
                sh.origin.z + sh.right.z * (col * sh.cell) + sh.forward.z * (row * sh.rowGap)),
            rot    = vec3(0.0, 0.0, 0.0),
        }
    end
    return out
end

Config.Job12.scenarios = {
    mixed1 = {
        labelKey = 'j12_cfg_scenario_mixed1', label = TL('j12_cfg_scenario_mixed1', 'Mixed load — 3 per bed (1 cement, 1 crate, 1 timber)'),
        loads = {
            {
                key       = 'cement',
                model     = 'prop_cons_cements01',
                aCoords   = vec3(1564.919, 1704.994, 110.227), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(-0.690, -1.185, 0.135),       bedRot = vec3(0.0, 0.0, 0.0),
            },
            {
                key       = 'crate',
                model     = 'prop_watercrate_01',
                aCoords   = vec3(1564.919, 1707.153, 110.063), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(0.685, -1.220, 0.085),        bedRot = vec3(0.0, 0.0, 0.0),
            },
            {
                key       = 'wood',
                model     = 'prop_woodpile_01b',
                aCoords   = vec3(1566.852, 1705.925, 110.107), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(0.000, -4.320, 0.080),        bedRot = vec3(0.0, 0.0, 0.0),
            },
        },
    },

    double = {
        labelKey = 'j12_cfg_scenario_double', label = TL('j12_cfg_scenario_double', 'Double load — 5 per bed (2 cement, 2 crates, 1 timber)'),
        loads = {
            {
                key       = 'cement1',
                model     = 'prop_cons_cements01',
                aCoords   = vec3(1564.919, 1704.994, 110.227), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(-0.690, -1.185, 0.135),       bedRot = vec3(0.0, 0.0, 0.0),
            },
            {
                key       = 'cement2',
                model     = 'prop_cons_cements01',
                aCoords   = vec3(1564.919, 1704.994, 110.227), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(-0.690, -1.185, 1.220),       bedRot = vec3(0.0, 0.0, 0.0),
                stackUnder = 1,
            },
            {
                key       = 'crate1',
                model     = 'prop_watercrate_01',
                aCoords   = vec3(1564.919, 1707.153, 110.063), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(0.685, -1.220, 0.085),        bedRot = vec3(0.0, 0.0, 0.0),
            },
            {
                key       = 'crate2',
                model     = 'prop_watercrate_01',
                aCoords   = vec3(1564.919, 1707.153, 110.063), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(0.685, -1.220, 1.190),        bedRot = vec3(0.0, 0.0, 0.0),
                stackUnder = 3,
            },
            {
                key       = 'wood',
                model     = 'prop_woodpile_01b',
                aCoords   = vec3(1566.852, 1705.925, 110.107), aRot = vec3(0.0, 0.0, 0.0),
                bedOffset = vec3(0.000, -4.320, 0.080),        bedRot = vec3(0.0, 0.0, 0.0),
            },
        },
    },
}

Config.Job12.bStack = {
    heightByModel = {
        prop_cons_cements01 = 1.085,
        prop_watercrate_01  = 1.105,
        prop_woodpile_01b   = 0.60,
    },
    defaultHeight = 0.80,
}

Config.Job12.bClusters = {
    {
        key   = 'b1',
        zone  = 'job12_b',
        labelKey = 'j12_cfg_cluster_b1', label = TL('j12_cfg_cluster_b1', 'Grapeseed drop-off'),
        sets  = {
            mixed1 = {
                { slot = 1, coords = vec3(1219.960, 1816.030, 78.130), rot = vec3(0.0, -4.5, 20.0) },
                { slot = 2, coords = vec3(1218.000, 1816.030, 78.030), rot = vec3(-2.5, 0.0, 14.0) },
                { slot = 3, coords = vec3(1216.000, 1816.030, 78.030), rot = vec3(0.0, 0.0, 17.5) },
                { slot = 1, coords = vec3(1219.960, 1813.030, 78.130), rot = vec3(0.0, -4.5, 20.0) },
                { slot = 2, coords = vec3(1218.000, 1813.030, 78.030), rot = vec3(-2.5, 0.0, 14.0) },
                { slot = 3, coords = vec3(1216.000, 1813.030, 78.030), rot = vec3(0.0, 0.0, 17.5) },
            },
            double = {
                { slot = 1, coords = vec3(1212.056, 1824.396, 78.242), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 2, coords = vec3(1212.056, 1824.386, 79.242), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 3, coords = vec3(1212.056, 1822.786, 78.042), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 4, coords = vec3(1212.056, 1822.786, 79.142), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 5, coords = vec3(1212.056, 1819.986, 77.837), rot = vec3(3.0, 0.0, 0.0) },
            },
        },
    },
    {
        key   = 'b2',
        zone  = 'job12_b2',
        labelKey = 'j12_cfg_cluster_b2', label = TL('j12_cfg_cluster_b2', 'Drop-off #2'),
        sets  = {
            mixed1 = {
                { slot = 1, coords = vec3(812.472, 2184.938, 51.477), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 2, coords = vec3(812.569, 2186.435, 51.377), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 3, coords = vec3(812.667, 2189.233, 51.262), rot = vec3(0.0, 0.0, 0.0) },
            },
        },
    },
    {
        key   = 'b3',
        zone  = 'job12_b3',
        labelKey = 'j12_cfg_cluster_b3', label = TL('j12_cfg_cluster_b3', 'Drop-off #3'),
        sets  = {
            mixed1 = {
                { slot = 1, coords = vec3(987.846, 2676.639, 38.734), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 2, coords = vec3(985.846, 2676.631, 38.734), rot = vec3(0.0, 0.0, 0.0) },
                { slot = 3, coords = vec3(983.846, 2676.622, 38.834), rot = vec3(0.0, 0.0, 0.0) },
            },
        },
    },
}

Config.Job12.activeScenario = 'random'

do
    local seen, out = {}, {}
    for _, sc in pairs(Config.Job12.scenarios or {}) do
        for _, ld in ipairs(sc.loads or {}) do
            local c = ld.aCoords
            if c then
                local key = ('%s|%.2f|%.2f|%.2f'):format(tostring(ld.model), c.x, c.y, c.z)
                if not seen[key] then
                    seen[key] = true
                    out[#out + 1] = { key = key, model = ld.model, coords = c, rot = ld.aRot }
                end
            end
        end
    end
    table.sort(out, function(a, b) return a.key < b.key end)
    Config.Job12.depotSources = out
end

do
    local seen, out = {}, {}
    local function add(m)
        if m and not seen[m] then seen[m] = true; out[#out + 1] = m end
    end
    for _, sc in pairs(Config.Job12.scenarios or {}) do
        for _, ld in ipairs(sc.loads or {}) do add(ld.model) end
    end
    for _, m in ipairs(Config.Job12.cargoPool or {}) do add(m) end
    table.sort(out)
    Config.Job12.modelCatalog = out
    local idx = {}
    for i, m in ipairs(out) do idx[m] = i end
    Config.Job12.modelIndex = idx
    local pidx = {}
    for i, m in ipairs(Config.Job12.cargoPool or {}) do pidx[m] = i end
    Config.Job12.poolIndex = pidx
end

function Job12ModelIndex(model) return model and Config.Job12.modelIndex[model] or nil end
function Job12PoolIndex(model) return model and Config.Job12.poolIndex[model] or nil end
function Job12ModelAt(mi)
    mi = tonumber(mi)
    return mi and Config.Job12.modelCatalog[mi] or nil
end

function Job12ValidPairs()
    local out = {}
    local lock = Config.Job12.activeScenario
    if lock == 'random' then lock = nil end
    for ci, cl in ipairs(Config.Job12.bClusters or {}) do
        for setKey, rows in pairs(cl.sets or {}) do
            local sc = Config.Job12.scenarios and Config.Job12.scenarios[setKey]
            local nl = sc and #(sc.loads or {}) or 0
            if sc and nl > 0 and #rows > 0 and (#rows % nl) == 0
                and (not lock or lock == setKey) then
                out[#out + 1] = { cluster = ci, cargo = setKey }
            end
        end
    end
    table.sort(out, function(a, b)
        if a.cluster ~= b.cluster then return a.cluster < b.cluster end
        return a.cargo < b.cargo
    end)
    return out
end

function Job12RollManifest()
    local pool = Config.Job12.cargoPool or {}
    local n = tonumber(Config.Job12.manifestSize) or #(Config.Job12.bedRows or {})
    if #pool == 0 then return {} end
    local out = {}
    for i = 1, math.min(n, #(Config.Job12.bedRows or {})) do
        out[i] = pool[math.random(1, #pool)]
    end
    return out
end

function Job12BootManifest()
    local pool = Config.Job12.cargoPool or {}
    local n = math.min(tonumber(Config.Job12.manifestSize) or 0,
                       #(Config.Job12.bedRows or {}), #pool)
    local out = {}
    for i = 1, n do out[i] = pool[i] end
    return out
end

function Job12LoadsFromManifest(manifest)
    local rows  = Config.Job12.bedRows or {}
    local shelf = Job12DepotSources()
    local out = {}
    for i, model in ipairs(manifest or {}) do
        local r = rows[i]
        if not r then break end
        local shelfIdx = (Job12PoolIndex and Job12PoolIndex(model)) or i
        local sp = shelf[shelfIdx] or shelf[1]
        out[i] = {
            key       = 'm' .. i,
            model     = model,
            aCoords   = sp and sp.coords,
            aRot      = vec3(0.0, 0.0, 0.0),
            bedOffset = vec3(r.x, r.y, Config.Job12.bedFloorZ),
            bedRot    = vec3(0.0, 0.0, 0.0),
        }
    end
    return out
end

function Job12BuildSelection(clusterIdx, cargoKey, manifest)
    local cl = Config.Job12.bClusters and Config.Job12.bClusters[clusterIdx]
    local rows = cl and cl.sets and cl.sets[cargoKey]
    local sc
    if manifest and #manifest > 0 then
        sc = { loads = Job12LoadsFromManifest(manifest) }
    else
        sc = Config.Job12.scenarios and Config.Job12.scenarios[cargoKey]
    end
    if not (cl and sc and sc.loads and #sc.loads > 0 and rows and #rows > 0) then return false end

    local sel = {
        cluster = clusterIdx,
        cargo   = cargoKey,
        loads   = sc.loads,
        bBase   = rows,
        zoneB   = cl.zone or Config.Job12.zoneB,
        per     = #(sc.loads or {}),
        manifest = manifest,
    }

    if manifest and #manifest > 0 then
        local flat = {}
        for _, b in ipairs(rows) do
            local dup = false
            for _, k in ipairs(flat) do
                if math.abs(k.coords.x - b.coords.x) < 0.30
                    and math.abs(k.coords.y - b.coords.y) < 0.30 then dup = true break end
            end
            if not dup then flat[#flat + 1] = b end
        end
        rows = flat
        sel.bBase = rows
    end

    if manifest and #manifest > 0 and #rows > 1 then
        local want = tonumber(Config.Job12.targetSpacing) or 0
        local minD
        for a = 1, #rows do
            for b = a + 1, #rows do
                local dx = rows[a].coords.x - rows[b].coords.x
                local dy = rows[a].coords.y - rows[b].coords.y
                local d = math.sqrt(dx * dx + dy * dy)
                if d > 0.05 and (not minD or d < minD) then minD = d end
            end
        end
        if minD and want > minD then
            local k = want / minD
            local cx, cy = 0.0, 0.0
            for _, b in ipairs(rows) do cx = cx + b.coords.x; cy = cy + b.coords.y end
            cx, cy = cx / #rows, cy / #rows
            local scaled = {}
            for i, b in ipairs(rows) do
                scaled[i] = {
                    slot = b.slot, rot = b.rot,
                    coords = vec3(cx + (b.coords.x - cx) * k,
                                  cy + (b.coords.y - cy) * k, b.coords.z),
                }
            end
            rows = scaled
            sel.bBase = rows
        end
    end

    local tg = {}
    local maxP = tonumber(Config.Job12.maxPlayers) or 1
    local nBase = #rows
    local nl    = #(sc.loads or {})
    local function underInRow(bi)
        local b = rows[bi]
        local ld = b and sc.loads[b.slot]
        local u  = ld and tonumber(ld.stackUnder)
        if not u or nl <= 0 then return nil end
        local rowStart = math.floor((bi - 1) / nl) * nl
        for j = rowStart + 1, math.min(rowStart + nl, nBase) do
            if rows[j] and rows[j].slot == u then return j end
        end
        return nil
    end
    local colSpan = {}
    do
        local function hOf(slot)
            local l2 = sc.loads[slot]
            return (l2 and Config.Job12.bStack.heightByModel[l2.model])
                or Config.Job12.bStack.defaultHeight
        end
        for bi, b in ipairs(rows) do
            local lo, hi, topSlot = b.coords.z, b.coords.z, b.slot
            for bj, b2 in ipairs(rows) do
                if math.abs(b2.coords.x - b.coords.x) < 0.30
                    and math.abs(b2.coords.y - b.coords.y) < 0.30 then
                    if b2.coords.z < lo then lo = b2.coords.z end
                    if b2.coords.z > hi then hi = b2.coords.z; topSlot = b2.slot end
                end
            end
            colSpan[bi] = (hi - lo) + hOf(topSlot)
        end
    end
    local poolSlots = manifest and #manifest > 0
    local perpX, perpY = 0.0, 1.0
    if poolSlots and #rows > 1 then
        local ax = rows[#rows].coords.x - rows[1].coords.x
        local ay = rows[#rows].coords.y - rows[1].coords.y
        local len = math.sqrt(ax * ax + ay * ay)
        if len > 0.05 then
            perpX, perpY = -(ay / len), (ax / len)
        end
    end
    local side  = tonumber(Config.Job12.targetRowSide) or 1
    local rowGapB = tonumber(Config.Job12.targetSpacing) or 2.60

    for copy = 1, maxP do
        for bi, b in ipairs(rows) do
            if poolSlots then b = { coords = b.coords, rot = b.rot,
                                    slot = ((bi - 1) % nl) + 1 } end
            local ld  = sc.loads[b.slot]
            local cx, cy, cz = b.coords.x, b.coords.y, b.coords.z
            if poolSlots then
                local off = rowGapB * (copy - 1) * side
                cx, cy = cx + perpX * off, cy + perpY * off
            else
                cz = cz + (colSpan[bi] or Config.Job12.bStack.defaultHeight) * (copy - 1)
            end
            tg[#tg + 1] = {
                slot   = b.slot,
                coords = vec3(cx, cy, cz),
                rot    = b.rot or vec3(0.0, 0.0, 0.0),
                base   = bi,
                copy   = copy,
                stackUnder = (not poolSlots) and (function()
                    local ur = underInRow(bi)
                    if ur then return ((copy - 1) * nBase) + ur end
                    if copy > 1 then return ((copy - 2) * nBase) + bi end
                    return nil
                end)() or nil,
            }
        end
    end
    sel.bTargets = tg

    if manifest and #manifest > 0 then
        sel.aSources = Job12DepotSources()
    else
        sel.aSources = Config.Job12.depotSources or {}
    end

    local locked = {}
    for i, ld in ipairs(sc.loads or {}) do
        local u = tonumber(ld.stackUnder)
        if u then locked[i] = true; locked[u] = true end
    end
    local freeOn = Config.Job12.freePlacement == true
    sel.genericSlot = {}
    for i = 1, #(sc.loads or {}) do sel.genericSlot[i] = freeOn and not locked[i] or false end

    local poolMode = manifest and #manifest > 0
    local tLocked = {}
    if not poolMode then
        for i, t in ipairs(tg) do
            local u = tonumber(t.stackUnder)
            if u then tLocked[i] = true; tLocked[u] = true end
        end
    end
    sel.genericTarget = {}
    for i = 1, #tg do sel.genericTarget[i] = freeOn and not tLocked[i] or false end
    return sel
end

function Job12ApplySelection(clusterIdx, cargoKey, manifest)
    local sel = Job12BuildSelection(clusterIdx, cargoKey, manifest)
    if not sel then return false end
    Config.Job12.activeCluster  = sel.cluster
    Config.Job12.activeCargo    = sel.cargo
    Config.Job12.activeManifest = sel.manifest
    Config.Job12.loads    = sel.loads
    Config.Job12.bBase    = sel.bBase
    Config.Job12.bTargets = sel.bTargets
    Config.Job12.aSources = sel.aSources
    Config.Job12.zoneB    = sel.zoneB
    Config.Job12.genericSlot   = sel.genericSlot
    Config.Job12.genericTarget = sel.genericTarget
    if Config.RegionBlipZone and Config.RegionBlipZone.job12 then
        Config.RegionBlipZone.job12 = { Config.Job12.zoneA or 'job12_a', sel.zoneB }
    end
    return true
end

-- Delivery sites added in game with /j12site land in config/data/job12_sites.json.
-- The zone polygon itself is written to config/data/builder_zones.json, the same
-- file the region 1 site designer uses. Sites shipped with the job cannot be
-- overwritten from there.
Config.Job12.maxJsonSites   = 12

-- Prefer drop-offs at least this far from the depot when any qualify. 0 = off.
Config.Job12.minDriveMeters = 0.0

Tworst = Tworst or {}
Tworst.PROTECTED_J12_SITES = { b1 = true, b2 = true, b3 = true }

local function j12num(v)
    v = tonumber(v)
    if not v or v ~= v or v == math.huge or v == -math.huge then return nil end
    return v
end

local function j12vec(v, need)
    if type(v) ~= 'table' then return nil end
    local x = j12num(v.x or v[1])
    local y = j12num(v.y or v[2])
    local z = j12num(v.z or v[3])
    if need and not (x and y and z) then return nil end
    return vec3(x or 0.0, y or 0.0, z or 0.0)
end

local function j12ZoneExists(name)
    for _, a in ipairs(Config.builderCoords or {}) do
        if a.name == name then return true end
    end
    return false
end

local function j12SetsFor(rows)
    local sets, any = {}, false
    for setKey, sc in pairs(Config.Job12.scenarios or {}) do
        local nl = #((sc and sc.loads) or {})
        if nl > 0 and (#rows % nl) == 0 then
            sets[setKey] = rows
            any = true
        end
    end
    if not any then return nil end
    return sets
end

function Job12SiteIndexByKey(key)
    for i, cl in ipairs(Config.Job12.bClusters or {}) do
        if cl.key == key then return i end
    end
    return nil
end

function Job12ApplySiteRecord(rec)
    if type(rec) ~= 'table' then return nil, 'record is not a table' end
    local key = rec.key
    if type(key) ~= 'string' or not key:match('^%l[%l%d_]+$') or #key > 24 then
        return nil, 'key must be lowercase letters, digits or _ (2-24 chars)'
    end
    if Tworst.PROTECTED_J12_SITES[key] then return nil, 'key is reserved by a shipped site' end
    if Job12SiteIndexByKey(key) then return nil, 'a site with this key already exists' end

    local zone = rec.zone
    if type(zone) ~= 'string' or zone == '' then return nil, 'zone name is missing' end
    if not j12ZoneExists(zone) then return nil, ('zone %s is not defined'):format(zone) end

    if type(rec.rows) ~= 'table' or #rec.rows == 0 then return nil, 'no unload slots' end
    local perLoad = tonumber(Config.Job12.manifestSize) or 3
    local rows = {}
    for i, r in ipairs(rec.rows) do
        local c = j12vec(r.coords, true)
        if not c then return nil, ('slot %d has broken coords'):format(i) end
        local slot = math.floor(j12num(r.slot) or (((i - 1) % perLoad) + 1))
        if slot < 1 or slot > perLoad then slot = ((i - 1) % perLoad) + 1 end
        rows[i] = { slot = slot, coords = c, rot = j12vec(r.rot) or vec3(0.0, 0.0, 0.0) }
    end

    local sets = j12SetsFor(rows)
    if not sets then
        return nil, ('%d slots do not divide into a cargo run (expected a multiple of %d)')
            :format(#rows, perLoad)
    end

    local mult = j12num(rec.payMult) or 1.0
    if mult < 0.5 then mult = 0.5 elseif mult > 2.0 then mult = 2.0 end

    Config.Job12.bClusters = Config.Job12.bClusters or {}
    Config.Job12.bClusters[#Config.Job12.bClusters + 1] = {
        key      = key,
        zone     = zone,
        label    = type(rec.label) == 'string' and rec.label ~= '' and rec.label or key,
        enabled  = rec.enabled ~= false,
        payMult  = mult,
        fromJson = true,
        sets     = sets,
    }
    return #Config.Job12.bClusters
end

local j12SitesLoaded = false
function Job12LoadSitesJson()
    if j12SitesLoaded then return 0 end
    j12SitesLoaded = true
    local raw = LoadResourceFile(GetCurrentResourceName(), 'config/data/job12_sites.json')
    if not raw or raw == '' then return 0 end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        print('^1[tw-builderjob][R12] config/data/job12_sites.json could not be read (broken JSON) '
            .. '— treated as empty, the file is NOT overwritten^7')
        return 0
    end
    local added = 0
    for _, rec in ipairs(data.sites or {}) do
        if added >= (tonumber(Config.Job12.maxJsonSites) or 12) then
            print('^3[tw-builderjob][R12] job12_sites.json: site limit reached, the rest are ignored^7')
            break
        end
        local idx, err = Job12ApplySiteRecord(rec)
        if idx then
            added = added + 1
        else
            print(('^3[tw-builderjob][R12] job12_sites.json: site %s skipped — %s^7')
                :format(tostring(rec and rec.key), tostring(err)))
        end
    end
    if added > 0 then
        print(('[tw-builderjob][R12] %d delivery site(s) loaded from job12_sites.json'):format(added))
    end
    return added
end

Job12LoadSitesJson()

do
    local pairsList = Job12ValidPairs()
    local first = pairsList[1]
    if first then
        Job12ApplySelection(first.cluster, first.cargo, Job12BootManifest())
    else
        Config.Job12.loads    = Config.Job12.loads or {}
        Config.Job12.bBase    = {}
        Config.Job12.bTargets = {}
        Config.Job12.aSources = {}
    end
end

function Job12TargetCount(crew, sel)
    local per = #((sel and sel.loads) or Config.Job12.loads or {})
    local all = #((sel and sel.bTargets) or Config.Job12.bTargets or {})
    crew = tonumber(crew) or 1
    if crew < 1 then crew = 1 end
    local maxP = tonumber(Config.Job12.maxPlayers) or 1
    if crew > maxP then crew = maxP end
    if per <= 0 or all <= 0 then return 0 end
    return math.min(all, per * crew)
end

function Job12TargetModel(tIdx, sel)
    local tgts  = (sel and sel.bTargets) or Config.Job12.bTargets
    local loads = (sel and sel.loads)    or Config.Job12.loads
    local t = tgts and tgts[tIdx]
    local l = t and loads and loads[t.slot]
    return l and l.model or nil
end

Config.Job12.grabRange       = 3.5
Config.Job12.placementRange  = 4.0
Config.Job12.maxWorkDistance = 60.0
Config.Job12.riggingMode     = '4corner'
Config.Job12.hookRigPoint    = vec3(0.0, 0.0, 0.25)

Config.Job12.crossLoad      = true

Config.Job12.bedBone = nil
