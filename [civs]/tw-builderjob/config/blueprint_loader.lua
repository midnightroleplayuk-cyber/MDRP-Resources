
Tworst = Tworst or {}

do
    local res = GetCurrentResourceName()
    local chunk = LoadResourceFile(res, 'docs/blueprints.lua')
    if not chunk then
        print('[tw-builderjob] blueprint_loader: docs/blueprints.lua not found')
        Tworst.Blueprints = {}
    else
        local fn, err = load(chunk, '@docs/blueprints.lua', 't')
        if not fn then
            print(('[tw-builderjob] blueprint_loader: parse error: %s'):format(err))
            Tworst.Blueprints = {}
        else
            local ok, data = pcall(fn)
            if not ok or type(data) ~= 'table' then
                print(('[tw-builderjob] blueprint_loader: exec error: %s'):format(tostring(data)))
                Tworst.Blueprints = {}
            else
                Tworst.Blueprints = data
            end
        end
    end
end

local function splitByZ(objs)
    if #objs == 0 then return {}, {} end
    local zs = {}
    for i, o in ipairs(objs) do zs[i] = o.pos.z end
    table.sort(zs)
    local maxGap, gapIdx = 0.0, nil
    for i = 1, #zs - 1 do
        local g = zs[i + 1] - zs[i]
        if g > maxGap then maxGap = g; gapIdx = i end
    end
    if maxGap < 1.0 or not gapIdx then
        return objs, {}
    end
    local threshold = (zs[gapIdx] + zs[gapIdx + 1]) * 0.5
    local lower, upper = {}, {}
    for _, o in ipairs(objs) do
        if o.pos.z < threshold then
            lower[#lower + 1] = o
        else
            upper[#upper + 1] = o
        end
    end
    return lower, upper
end

local function toSlot(o)
    return {
        coords = vector3(o.pos.x, o.pos.y, o.pos.z),
        rot    = vector3(o.rot.x, o.rot.y, o.rot.z),
    }
end

local function toModelSlot(o)
    return {
        model  = o.model,
        coords = vector3(o.pos.x, o.pos.y, o.pos.z),
        rot    = vector3(o.rot.x, o.rot.y, o.rot.z),
    }
end

local function avgY(objs)
    if #objs == 0 then return 0.0 end
    local s = 0.0
    for _, o in ipairs(objs) do s = s + o.pos.y end
    return s / #objs
end

local function minX(objs)
    local m = math.huge
    for _, o in ipairs(objs) do
        if o.pos.x < m then m = o.pos.x end
    end
    return (m == math.huge) and 0.0 or m
end

local function deriveQuadrants(baseObjs)
    if #baseObjs == 0 then return {} end
    local minXv, maxXv = math.huge, -math.huge
    local minYv, maxYv = math.huge, -math.huge
    for _, o in ipairs(baseObjs) do
        if o.pos.x < minXv then minXv = o.pos.x end
        if o.pos.x > maxXv then maxXv = o.pos.x end
        if o.pos.y < minYv then minYv = o.pos.y end
        if o.pos.y > maxYv then maxYv = o.pos.y end
    end
    local medX = (minXv + maxXv) * 0.5
    local medY = (minYv + maxYv) * 0.5

    local quads = {
        { id = 1, label = 'NE', slots = {} },
        { id = 2, label = 'SE', slots = {} },
        { id = 3, label = 'NW', slots = {} },
        { id = 4, label = 'SW', slots = {} },
    }
    local sums = {
        { x = 0, y = 0, n = 0 }, { x = 0, y = 0, n = 0 },
        { x = 0, y = 0, n = 0 }, { x = 0, y = 0, n = 0 },
    }

    for idx, o in ipairs(baseObjs) do
        local q
        if o.pos.x >= medX and o.pos.y >= medY then
            q = 1
        elseif o.pos.x >= medX then
            q = 2
        elseif o.pos.y >= medY then
            q = 3
        else
            q = 4
        end
        quads[q].slots[#quads[q].slots + 1] = idx
        sums[q].x = sums[q].x + o.pos.x
        sums[q].y = sums[q].y + o.pos.y
        sums[q].n = sums[q].n + 1
    end

    local zCenter = baseObjs[1].pos.z + 0.5
    for q = 1, 4 do
        if sums[q].n > 0 then
            quads[q].center = vector3(sums[q].x / sums[q].n, sums[q].y / sums[q].n, zCenter)
        else
            quads[q].center = vector3(medX, medY, zCenter)
        end
    end

    return quads
end

local function genPileGroup(count, cfg)
    local out = {}
    if count <= 0 then return out end
    local points   = math.max(1, math.floor(tonumber(cfg.points) or 1))
    local perStack = math.max(1, math.floor(tonumber(cfg.perStack) or count))
    local spread   = tonumber(cfg.spread) or 0.0
    local axis     = cfg.axis or 'y'
    local step     = cfg.stackStep or vector3(0.0, 0.0, 0.0)
    local r        = cfg.rot or vector3(0.0, 0.0, 0.0)
    local x, y, z  = cfg.x or 0.0, cfg.y or 0.0, cfg.z or 0.0

    local start = -spread * 0.5
    local gap   = (points > 1) and (spread / (points - 1)) or 0.0

    for layer = 0, perStack - 1 do
        for i = 0, points - 1 do
            if #out < count then
                local ox, oy = 0.0, 0.0
                if axis == 'x' then ox = start + i * gap else oy = start + i * gap end
                out[#out + 1] = {
                    coords = vector3(x + ox + layer * step.x,
                                     y + oy + layer * step.y,
                                     z       + layer * step.z),
                    rot    = vector3(r.x, r.y, r.z),
                }
            end
        end
    end
    return out
end

local PLANK_PANEL_W = 2.99
local PLANK_OVERLAP = 0.94
local RING_OPENING  = 4.5

local function respacePlankRing(rawPlanks)
    local lines, order = {}, {}
    for _, o in ipairs(rawPlanks or {}) do
        local rz = o.rot.z % 360
        local alongX = (rz < 1.0) or (math.abs(rz - 180.0) < 1.0) or (rz > 359.0)
        local key = ('%d|%.3f'):format(math.floor(rz + 0.5), alongX and o.pos.y or o.pos.x)
        if not lines[key] then
            lines[key] = { alongX = alongX, items = {} }
            order[#order + 1] = key
        end
        local items = lines[key].items
        items[#items + 1] = o
    end

    local out = {}
    for _, key in ipairs(order) do
        local ln     = lines[key]
        local alongX = ln.alongX
        local function axisOf(o) return alongX and o.pos.x or o.pos.y end
        table.sort(ln.items, function(a, b) return axisOf(a) < axisOf(b) end)

        local run = { ln.items[1] }
        local function flushRun()
            local first = run[1]
            local a, b  = axisOf(first), axisOf(run[#run])
            local span  = b - a
            local n, step = 1, 0.0
            if #run > 1 and span > 0.001 then
                n    = math.ceil(span / (PLANK_PANEL_W * PLANK_OVERLAP)) + 1
                step = span / (n - 1)
            end
            for i = 1, n do
                local c = a + (i - 1) * step
                out[#out + 1] = {
                    coords = alongX and vector3(c, first.pos.y, first.pos.z)
                                     or vector3(first.pos.x, c, first.pos.z),
                    rot    = vector3(first.rot.x, first.rot.y, first.rot.z),
                }
            end
        end

        for i = 2, #ln.items do
            if (axisOf(ln.items[i]) - axisOf(ln.items[i - 1])) > RING_OPENING then
                flushRun()
                run = { ln.items[i] }
            else
                run[#run + 1] = ln.items[i]
            end
        end
        flushRun()
    end
    return out
end

local stageWarned = {}
local function resolveStage(stages, key)
    local all = Config.PlankStages
    local d = all and all[key]
    if not d then
        if not stageWarned[key] then
            stageWarned[key] = true
            print(('^1[tw-builderjob] Config.PlankStages.%s MISSING - the pile layout falls '
                .. 'back to default (did config/systems/plank_stages.lua load?)^7'):format(key))
        end
        d = {}
    end
    local o = (stages or {})[key]
    if not o then return d end
    local out = {}
    for k, v in pairs(d) do out[k] = v end
    for k, v in pairs(o) do if v ~= nil then out[k] = v end end

    for _, k in ipairs({ 'stackStep', 'rot' }) do
        local v = out[k]
        if type(v) == 'table' and v.x == nil and #v == 3 then
            out[k] = vector3(v[1] + 0.0, v[2] + 0.0, v[3] + 0.0)
        end
    end
    return out
end

local function buildLayout(bp, xf, dH, stages)
    dH = dH or 0.0
    local function tp(p)
        if not xf then return vector3(p.x, p.y, p.z) end
        local np = xf(p, nil)
        return np
    end
    local function tr(rz)
        if not xf then return rz end
        local _, nrz = xf(vector3(0.0, 0.0, 0.0), rz)
        return nrz
    end

    local objs, rawByModel = {}, {}
    for _, o in ipairs(bp.objects or {}) do
        local np = tp(o.pos)
        objs[#objs + 1] = {
            model = o.model,
            pos   = np,
            rot   = vector3(o.rot.x, o.rot.y, tr(o.rot.z) or o.rot.z),
        }
        rawByModel[o.model] = rawByModel[o.model] or {}
        rawByModel[o.model][#rawByModel[o.model] + 1] = o
    end
    local anchorT   = tp(bp.anchor or vector3(0.0, 0.0, 50.0))
    local anchorRaw = bp.anchor or vector3(0.0, 0.0, 50.0)
    local function xfStack(list)
        if not xf then return list end
        local out = {}
        for i, s in ipairs(list or {}) do
            local np, nrz = xf(s.coords, s.rot and s.rot.z or nil)
            out[i] = { coords = np, rot = s.rot and vector3(s.rot.x, s.rot.y, nrz or s.rot.z) or nil }
        end
        return out
    end

    local L = {}

    local byModel = {}
    for _, o in ipairs(objs) do
        byModel[o.model] = byModel[o.model] or {}
        byModel[o.model][#byModel[o.model] + 1] = o
    end

    L.plankSlots = xfStack(respacePlankRing(rawByModel.tworst_buildplank))

    L.baseSlots = {}
    for _, o in ipairs(byModel.tworst_buildbase1 or {}) do
        L.baseSlots[#L.baseSlots + 1] = toSlot(o)
    end
    L.baseSlotsFinal    = L.baseSlots
    L.concreteQuadrants = deriveQuadrants(byModel.tworst_buildbase1 or {})

    L.wireSlots = {}
    for _, o in ipairs(byModel.tworst_buildwire or {}) do
        L.wireSlots[#L.wireSlots + 1] = toSlot(o)
    end
    do
        local P = Config.PlankJob
        local baseZ  = L.baseSlots[1] and L.baseSlots[1].coords and L.baseSlots[1].coords.z
        local wire1  = L.wireSlots[1] and L.wireSlots[1].coords
        if baseZ and wire1 and P then
            local targetZ = baseZ + (P.baseGroundZOffset or 0.0) + (P.wireGroundLift or 0.0)
            local shift   = targetZ - wire1.z
            if math.abs(shift) > 0.0005 then
                for _, s in ipairs(L.wireSlots) do
                    s.coords = vector3(s.coords.x, s.coords.y, s.coords.z + shift)
                end
            end
        end
    end

    L.poleSlots = {}
    for _, o in ipairs(byModel.tworst_build1u or {}) do
        L.poleSlots[#L.poleSlots + 1] = toModelSlot(o)
    end
    for _, o in ipairs(byModel.tworst_build1u_1f or {}) do
        L.poleSlots[#L.poleSlots + 1] = toModelSlot(o)
    end
    do
        local nFull  = #(byModel.tworst_build1u    or {})
        local nShort = #(byModel.tworst_build1u_1f or {})
        if nShort > nFull then L.poleModel = 'tworst_build1u_1f'
        elseif nFull > 0   then L.poleModel = 'tworst_build1u' end
    end

    do
        local lower, upper = splitByZ(byModel.tworst_build1b or {})
        L.rebarSlots = {}
        for _, o in ipairs(lower) do L.rebarSlots[#L.rebarSlots + 1] = toModelSlot(o) end
        L.rebarSlotsUpper = {}
        for _, o in ipairs(upper) do L.rebarSlotsUpper[#L.rebarSlotsUpper + 1] = toModelSlot(o) end
    end

    L.frameCornerSlots = {}
    for _, o in ipairs(byModel.tworst_build1y or {}) do
        L.frameCornerSlots[#L.frameCornerSlots + 1] = toSlot(o)
    end
    L.frameEdgeSlots = {}

    do
        local wallObjs = {}
        for _, o in ipairs(byModel.tworst_buildwall1  or {}) do wallObjs[#wallObjs + 1] = o end
        for _, o in ipairs(byModel.tworst_builwall1a or {}) do wallObjs[#wallObjs + 1] = o end
        for _, o in ipairs(byModel.tworst_buildwindow or {}) do wallObjs[#wallObjs + 1] = o end
        for _, o in ipairs(byModel.tworst_buildwalld      or {}) do wallObjs[#wallObjs + 1] = o end
        for _, o in ipairs(byModel.tworst_builwall1a_win or {}) do wallObjs[#wallObjs + 1] = o end
        local lower, upper = splitByZ(wallObjs)
        L.groundWallSlots = {}
        for _, o in ipairs(lower) do L.groundWallSlots[#L.groundWallSlots + 1] = toModelSlot(o) end
        L.groundWallSlotsUpper = {}
        for _, o in ipairs(upper) do L.groundWallSlotsUpper[#L.groundWallSlotsUpper + 1] = toModelSlot(o) end
    end

    do
        local lower, upper = splitByZ(byModel.tworst_buildground or {})
        L.groundTopSlots = {}
        for _, o in ipairs(lower) do L.groundTopSlots[#L.groundTopSlots + 1] = toSlot(o) end
        L.groundTopSlotsUpper = {}
        for _, o in ipairs(upper) do L.groundTopSlotsUpper[#L.groundTopSlotsUpper + 1] = toSlot(o) end
    end

    local siteWestX = minX(rawByModel.tworst_buildbase1 or {})
    if siteWestX == 0.0 then siteWestX = anchorRaw.x + 4.0 end
    local siteCenterY = avgY(rawByModel.tworst_buildbase1 or {})
    if siteCenterY == 0.0 then siteCenterY = bp.center and bp.center.y or 0.0 end
    local zPickupBase = anchorRaw.z - 0.025

    local function pileFor(key, count, zBase)
        local c = resolveStage(stages, key)
        return genPileGroup(count, {
            x = siteWestX + (c.dx or 0.0),
            y = siteCenterY + (c.dy or 0.0),
            z = zBase,
            points    = c.points or math.ceil(count / 2),
            perStack  = c.perStack or count,
            spread    = c.spread or 0.0,
            axis      = c.axis or 'y',
            stackStep = c.stackStep or vector3(0.0, 0.0, 0.0),
            rot       = c.rot or vector3(0.0, 0.0, 0.0),
        })
    end

    L.polePickups = pileFor('pole', #L.poleSlots, zPickupBase)
    L.polePickups = xfStack(L.polePickups)

    do
        local total = #L.rebarSlots + #L.rebarSlotsUpper + #L.frameCornerSlots
        L.rebarCranePickups = xfStack(pileFor('rebar', total, zPickupBase))
    end

    local wallZ = anchorRaw.z + 0.4
    L.groundCranePickups       = xfStack(pileFor('ground',       #L.groundWallSlots,      wallZ))
    L.upperWallCranePickups    = xfStack(pileFor('upperWall',    #L.groundWallSlotsUpper, wallZ))
    L.ceilingCranePickups      = xfStack(pileFor('ceiling',      #L.groundTopSlots,       wallZ))
    L.upperCeilingCranePickups = xfStack(pileFor('upperCeiling', #L.groundTopSlotsUpper,  wallZ))

    L.activeBlueprintMeta = {
        anchor      = anchorT,
        center      = bp.center and tp(bp.center) or nil,
        size        = bp.size,
        objectCount = bp.object_count,
    }
    return L
end

local LAYOUT_FIELDS = {
    'plankSlots', 'baseSlots', 'baseSlotsFinal', 'concreteQuadrants',
    'wireSlots', 'poleSlots',
    'rebarSlots', 'rebarSlotsUpper', 'frameCornerSlots', 'frameEdgeSlots',
    'groundWallSlots', 'groundWallSlotsUpper', 'groundTopSlots', 'groundTopSlotsUpper',
    'polePickups', 'rebarCranePickups',
    'groundCranePickups', 'upperWallCranePickups',
    'ceilingCranePickups', 'upperCeilingCranePickups',
    'pileStacks',
}

local function ApplyBlueprintToPlankJob(designId)
    local bp = Tworst.Blueprints and Tworst.Blueprints[designId]
    if not bp then
        print(('[tw-builderjob] Blueprint not found: %s'):format(tostring(designId)))
        return false
    end
    local L = buildLayout(bp, nil)

    Config.PlankJob = Config.PlankJob or {}
    local PJ = Config.PlankJob
    for _, k in ipairs(LAYOUT_FIELDS) do PJ[k] = L[k] end
    if L.poleModel then PJ.poleModel = L.poleModel end
    PJ.wireGrid = nil
    PJ.activeBlueprint = {
        designId    = designId,
        anchor      = L.activeBlueprintMeta.anchor,
        center      = L.activeBlueprintMeta.center,
        size        = L.activeBlueprintMeta.size,
        objectCount = L.activeBlueprintMeta.objectCount,
    }

    print(('[tw-builderjob] Blueprint applied: %s — plank=%d base=%d wire=%d pole=%d rebar=%d/%d frame=%d wall=%d/%d top=%d/%d')
        :format(
            designId,
            #L.plankSlots, #L.baseSlots, #L.wireSlots, #L.poleSlots,
            #L.rebarSlots, #L.rebarSlotsUpper,
            #L.frameCornerSlots,
            #L.groundWallSlots, #L.groundWallSlotsUpper,
            #L.groundTopSlots, #L.groundTopSlotsUpper
        ))
    return true
end

local function makeXf(anchor, ref)
    local dH  = (anchor.w or 0.0) - (ref.w or 0.0)
    local rad = math.rad(dH)
    local c, s = math.cos(rad), math.sin(rad)
    return function(p, rz)
        local rx, ry = p.x - ref.x, p.y - ref.y
        return vector3(anchor.x + rx * c - ry * s,
                       anchor.y + rx * s + ry * c,
                       anchor.z + (p.z - ref.z)),
               rz and (rz + dH) or nil
    end, dH
end

local SITE_FIELD_REF = vector4(995.505, 2353.800, 50.0, 0.0)

function Tworst.BuildSiteLayout(designId, site)
    local bp = Tworst.Blueprints and Tworst.Blueprints[designId]
    if not bp then
        print(('[tw-builderjob] BuildSiteLayout: no blueprint: %s'):format(tostring(designId)))
        return nil
    end
    local xf, dH = nil, 0.0
    if site and site.anchor and bp.anchor then
        xf, dH = makeXf(site.anchor, bp.anchor)
    end
    local L = buildLayout(bp, xf, dH, site and site.stages or nil)

    if site and site.anchor then
        local xf2 = makeXf(site.anchor, SITE_FIELD_REF)
        local function xfSlotList(list)
            local out = {}
            for i, sl in ipairs(list or {}) do
                local np, nrz = xf2(sl.coords, sl.rot and sl.rot.z or nil)
                out[i] = {
                    id     = sl.id,
                    coords = np,
                    rot    = sl.rot and vector3(sl.rot.x, sl.rot.y, nrz or sl.rot.z) or nil,
                }
            end
            return out
        end
        local function xf4(v)
            local np, nh = xf2(vector3(v.x, v.y, v.z), v.w or 0.0)
            return vector4(np.x, np.y, np.z, nh or 0.0)
        end
        local function handPiles(list, key)
            local out = xfSlotList(list)
            local c = resolveStage(site and site.stages or nil, key)
            local dx, dy, dz = c.dx or 0.0, c.dy or 0.0, c.dz or 0.0
            if dx == 0.0 and dy == 0.0 and dz == 0.0 then return out end
            local rad = math.rad((site and site.anchor and site.anchor.w or 0.0)
                - SITE_FIELD_REF.w)
            local co, sn = math.cos(rad), math.sin(rad)
            local wx, wy = dx * co - dy * sn, dx * sn + dy * co
            for _, p in ipairs(out) do
                p.coords = vector3(p.coords.x + wx, p.coords.y + wy, p.coords.z + dz)
            end
            return out
        end
        L.pileSpawns     = handPiles(Config.PlankJob.pileSpawns,     'plank')
        L.wirePileSpawns = handPiles(Config.PlankJob.wirePileSpawns, 'wire')

        do
            local base = Config.PlankJob.pileStacks or {}
            local out = {}
            for _, key in ipairs({ 'plank', 'wire' }) do
                local b = base[key] or {}
                local c = resolveStage(site and site.stages or nil, key)
                out[key] = {
                    enabled    = (b.enabled ~= false),
                    model      = b.model,
                    stackCount = c.perStack or b.stackCount or 5,
                    baseOffset = b.baseOffset or vector3(0.0, 0.0, 0.0),
                    rot        = c.rot or b.rot,
                    stackStep  = c.stackStep or b.stackStep or vector3(0.0, 0.0, 0.1),
                }
            end
            L.pileStacks = out
        end
        local cvs = Config.PlankJob.craneVehicleSpawn
        if cvs and cvs.coords then
            local np, nh = xf2(cvs.coords, cvs.heading or 0.0)
            L.craneVehicleSpawn = { coords = np, heading = nh }
        end
        if Config.PlankJob.pump and Config.PlankJob.pump.spawn then
            L.pump = {}
            for k, v in pairs(Config.PlankJob.pump) do L.pump[k] = v end
            L.pump.spawn = xf4(Config.PlankJob.pump.spawn)
        end
    end
    return L
end

Tworst.ApplyBlueprintToPlankJob = ApplyBlueprintToPlankJob

Tworst.PROTECTED_SITES = { site1 = true }

function Tworst.ApplyZoneRecord(name, z)
    Config.builderCoords = Config.builderCoords or {}
    local taken, maxId = false, 0
    for _, a in ipairs(Config.builderCoords) do
        if a.name == name then taken = true end
        if type(a.id) == 'number' and a.id > maxId then maxId = a.id end
    end
    if taken then return nil, 'already defined' end

    local pts = type(z) == 'table' and z.points or nil
    if type(pts) ~= 'table' or #pts < 3 then return nil, 'polygon is broken (<3 points)' end

    local poly = {}
    for i, pt in ipairs(pts) do poly[i] = vector2(pt[1] + 0.0, pt[2] + 0.0) end
    local c = z.coords or { poly[1].x, poly[1].y, 50.0 }
    local rec = {
        id        = maxId + 1,
        name      = name,
        coords    = vector3(c[1] + 0.0, c[2] + 0.0, c[3] + 0.0),
        points    = poly,
        blipLabel = z.blipLabel,
        fromJson  = true,
    }
    Config.builderCoords[#Config.builderCoords + 1] = rec
    return rec
end

local zonesLoaded = false
function Tworst.LoadBuilderZonesJson()
    if zonesLoaded then return 0 end
    Config.builderCoords = Config.builderCoords or {}
    if #Config.builderCoords == 0 then return 0 end
    zonesLoaded = true
    local raw = LoadResourceFile(GetCurrentResourceName(), 'config/data/builder_zones.json')
    if not raw or raw == '' then return 0 end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        print('[tw-builderjob] config/data/builder_zones.json could not be read (broken JSON) — ignored')
        return 0
    end

    local names = {}
    for n in pairs(data) do names[#names + 1] = n end
    table.sort(names)

    local added = 0
    for _, name in ipairs(names) do
        local rec, why = Tworst.ApplyZoneRecord(name, data[name])
        if rec then
            added = added + 1
        else
            print(('[tw-builderjob] config/data/builder_zones.json: %s — %s'):format(name, why))
        end
    end
    if added > 0 then
        print(('[tw-builderjob] config/data/builder_zones.json: %d zone(s) added (total %d)')
            :format(added, #Config.builderCoords))
    end
    return added
end

function Tworst.RemoveSiteRecord(id)
    if type(id) ~= 'string' then return false, 'bad id' end
    if Tworst.PROTECTED_SITES[id] then return false, 'PROTECTED' end
    for i, cur in ipairs(Config.PlankSites or {}) do
        if cur.id == id then
            if cur.overrides then return false, 'override — restart needed' end
            table.remove(Config.PlankSites, i)
            return true
        end
    end
    return false, 'not loaded'
end

function Tworst.RemoveZoneRecord(name)
    if type(name) ~= 'string' then return false end
    for i, a in ipairs(Config.builderCoords or {}) do
        if a.name == name then
            if not a.fromJson then return false end
            table.remove(Config.builderCoords, i)
            return true
        end
    end
    return false
end

function Tworst.ApplySiteRecord(id, s)
    Config.PlankSites = Config.PlankSites or {}
    local a = type(s) == 'table' and s.anchor or nil
    if type(a) ~= 'table' or #a < 4 then return nil, 'anchor is broken' end

    local idx
    for i, cur in ipairs(Config.PlankSites) do
        if cur.id == id then idx = i break end
    end
    if idx and not s.overrides then return nil, 'already exists in the config' end
    if idx and Tworst.PROTECTED_SITES[id] then return nil, 'PROTECTED — override REJECTED' end

    local entry = {
        id       = id,
        label    = s.label or id,
        anchor   = vector4(a[1] + 0.0, a[2] + 0.0, a[3] + 0.0, a[4] + 0.0),
        zoneId   = s.zoneId,
        designId = s.designId,
        permanent     = s.permanent and true or nil,
        exteriorModel = s.exteriorModel,
        stages    = type(s.stages) == 'table' and s.stages or nil,
        fromJson  = true,
        overrides = idx and true or nil,
    }
    if entry.permanent and (type(entry.exteriorModel) ~= 'string' or entry.exteriorModel == '') then
        print(('[tw-builderjob] %s is PERMANENT but has no exteriorModel — '
            .. 'the finished house cannot be placed (set it in /tw_bp)'):format(id))
    end
    if idx then
        Config.PlankSites[idx] = entry
        return entry, true
    end
    Config.PlankSites[#Config.PlankSites + 1] = entry
    return entry, false
end

Tworst.SiteSettingsFromPanel = { randomSite = false, disabled = {} }
Tworst.SiteSettingsFromConfig = { randomSite = nil, enabled = {} }

function Tworst.LoadSiteSettingsJson()
    local base = Tworst.SiteSettingsFromConfig
    base.randomSite = Config.PlankJob and Config.PlankJob.randomSite or false
    for _, sc in ipairs(Config.PlankSites or {}) do
        base.enabled[sc.id] = (sc.enabled ~= false)
    end

    local raw = LoadResourceFile(GetCurrentResourceName(), 'config/data/site_settings.json')
    if not raw or raw == '' then return end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        print('[tw-builderjob] config/data/site_settings.json could not be read (broken JSON) — ignored')
        return
    end

    local src = Tworst.SiteSettingsFromPanel
    if type(data.randomSite) == 'boolean' then
        Config.PlankJob = Config.PlankJob or {}
        Config.PlankJob.randomSite = data.randomSite
        src.randomSite = true
    end
    if type(data.disabled) == 'table' then
        for _, sc in ipairs(Config.PlankSites or {}) do
            local v = data.disabled[sc.id]
            if type(v) == 'boolean' then
                sc.enabled = not v
                src.disabled[sc.id] = true
            end
        end
    end
end

function Tworst.LoadPlankSitesJson()
    if Tworst.LoadBuilderZonesJson then Tworst.LoadBuilderZonesJson() end
    Config.PlankSites = Config.PlankSites or {}
    local raw = LoadResourceFile(GetCurrentResourceName(), 'config/data/plank_sites.json')
    if not raw or raw == '' then return 0 end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        print('[tw-builderjob] config/data/plank_sites.json could not be read (broken JSON) — ignored')
        return 0
    end

    local ids = {}
    for id in pairs(data) do ids[#ids + 1] = id end
    table.sort(ids)

    local added, over = 0, 0
    for _, id in ipairs(ids) do
        local entry, res = Tworst.ApplySiteRecord(id, data[id])
        if entry then
            if res == true then
                over = over + 1
                print(('[tw-builderjob] config/data/plank_sites.json: %s is OVERWRITING the config record (override)'):format(id))
            else
                added = added + 1
            end
        else
            print(('[tw-builderjob] config/data/plank_sites.json: %s — %s'):format(id, res))
        end
    end
    if added > 0 or over > 0 then
        print(('[tw-builderjob] config/data/plank_sites.json: %d site(s) added, %d override(s) (total %d)')
            :format(added, over, #Config.PlankSites))
    end
    return added + over
end
