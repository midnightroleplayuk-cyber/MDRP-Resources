Graffiti = {}

local cfg = Config.Graffiti
local tags = {}      -- tags[id] = { id, gangId, designId, zone, p, status, crossedBy, createdBy }
local designs = {}   -- designs[id] = { id, gangId, name, spec, status }
local lastSpray = {} -- lastSpray[citizenid] = os.time()
local loaded = false

local validFonts, validStyles = {}, {}
for _, f in ipairs(cfg.fonts) do validFonts[f.key] = true end
for _, s in ipairs(cfg.styles) do validStyles[s] = true end

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

local function trim(s) return (tostring(s or ''):gsub('^%s+', ''):gsub('%s+$', '')) end

---Validates a tag design coming from the tablet.
local function cleanSpec(spec)
    if type(spec) ~= 'table' then return nil, 'invalid' end

    -- Picture tags: an image link on an allowed host (checked the same way as gang logos)
    if spec.kind == 'image' then
        if not cfg.allowPictures then return nil, 'invalid' end
        local url, err = Gangs.ValidateLogoUrl(spec.url)
        if not url or url == '' then return nil, err or 'invalid_logo' end
        return { kind = 'image', url = url }
    end

    local text = trim(spec.text)
    if #text < 1 or #text > cfg.maxTextLength or not text:match("^[%w %.%-_!&'#]+$") then
        return nil, 'invalid_tag_text'
    end
    local hex = '^#%x%x%x%x%x%x$'
    if not validFonts[spec.font] or not validStyles[spec.style] then return nil, 'invalid' end
    if not tostring(spec.fill):match(hex) or not tostring(spec.outline):match(hex) then return nil, 'invalid_colour' end
    return { text = text, font = spec.font, style = spec.style, fill = spec.fill:upper(), outline = spec.outline:upper() }
end

local function round3(n) return math.floor(n * 1000 + 0.5) / 1000 end

local function cleanPlacement(src, p)
    if type(p) ~= 'table' then return nil, 'invalid' end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    local nx, ny, nz, w = tonumber(p.nx), tonumber(p.ny), tonumber(p.nz), tonumber(p.w)
    if not (x and y and z and nx and ny and nz and w) then return nil, 'invalid' end

    local len = math.sqrt(nx * nx + ny * ny + nz * nz)
    if len < 0.9 or len > 1.1 then return nil, 'invalid' end
    nx, ny, nz = nx / len, ny / len, nz / len

    -- Which surfaces can be tagged (walls, floors and ramps, ceilings)
    local surfaces = cfg.surfaces or { walls = true }
    if nz > 0.35 and not surfaces.floors then return nil, 'not_a_wall' end
    if nz < -0.35 and not surfaces.ceilings then return nil, 'not_a_wall' end
    if math.abs(nz) <= 0.35 and surfaces.walls == false then return nil, 'not_a_wall' end

    local pos = vector3(x, y, z)
    if #(GetEntityCoords(GetPlayerPed(src)) - pos) > cfg.maxDistance + 1.0 then return nil, 'too_far' end

    w = math.max(cfg.minWidth, math.min(cfg.maxWidth, w))
    local out = {
        x = round3(x), y = round3(y), z = round3(z),
        nx = round3(nx), ny = round3(ny), nz = round3(nz),
        w = round3(w),
    }

    -- Which way the lettering faces (floor tags read upright from where they were sprayed). Must lie on the surface.
    local ux, uy, uz = tonumber(p.ux), tonumber(p.uy), tonumber(p.uz)
    if ux and uy and uz then
        local ulen = math.sqrt(ux * ux + uy * uy + uz * uz)
        if ulen > 0.9 and ulen < 1.1 and math.abs((ux * nx + uy * ny + uz * nz) / ulen) < 0.2 then
            out.ux, out.uy, out.uz = round3(ux / ulen), round3(uy / ulen), round3(uz / ulen)
        end
    end
    return out
end

local function paintOverContains(list, tag)
    for _, t in ipairs(list) do if t == tag then return true end end
    return false
end

local function tagPos(tag) return vector3(tag.p.x, tag.p.y, tag.p.z) end

local function nearTag(src, tag, range)
    return #(GetEntityCoords(GetPlayerPed(src)) - tagPos(tag)) <= (range or cfg.maxDistance + 1.5)
end

local function hasSprayItem(src)
    return not cfg.sprayItem or Bridge.HasItem(src, cfg.sprayItem, 1)
end

local function useSprayItem(src)
    if cfg.sprayItem and cfg.consumeItem then Bridge.RemoveItem(src, cfg.sprayItem, 1) end
end

---Shape sent to clients for rendering.
local function clientTag(tag)
    local crosser = tag.crossedBy and Gangs.Get(tag.crossedBy)
    return {
        id = tag.id, gangId = tag.gangId, designId = tag.designId, p = tag.p, status = tag.status,
        crossColour = tag.status == 'crossed' and (crosser and crosser.colour or '#C8553D') or nil,
    }
end

local function clientDesign(d)
    return { id = d.id, gangId = d.gangId, spec = d.spec }
end

local function broadcastUpsert(tag)
    TriggerClientEvent('vinewood_gangs:client:graffitiUpsert', -1, clientTag(tag), clientDesign(designs[tag.designId]))
end

local function setRemoved(tag, reason)
    tags[tag.id] = nil
    MySQL.update("UPDATE vg_graffiti SET status = 'removed' WHERE id = ?", { tag.id })
    TriggerClientEvent('vinewood_gangs:client:graffitiRemove', -1, tag.id)
    Utils.Debug('tag removed', tag.id, reason)
end

-------------------------------------------------------------------------------
-- Loading and sync
-------------------------------------------------------------------------------

function Graffiti.Load()
    tags, designs = {}, {}

    for _, d in ipairs(MySQL.query.await('SELECT id, gang_id, name, design, status FROM vg_tag_designs')) do
        if Gangs.Get(d.gang_id) then
            local ok, spec = pcall(json.decode, d.design)
            if ok and spec then
                designs[d.id] = { id = d.id, gangId = d.gang_id, name = d.name, spec = spec, status = d.status }
            end
        end
    end

    if cfg.expiryDays and cfg.expiryDays > 0 then
        MySQL.update.await("UPDATE vg_graffiti SET status = 'removed' WHERE status <> 'removed' AND created_at < DATE_SUB(NOW(), INTERVAL ? DAY)", { cfg.expiryDays })
    end

    for _, t in ipairs(MySQL.query.await("SELECT id, gang_id, design_id, zone, placement, status, crossed_by, created_by, UNIX_TIMESTAMP(created_at) AS created FROM vg_graffiti WHERE status IN ('active','crossed')")) do
        local ok, p = pcall(json.decode, t.placement)
        if ok and p and designs[t.design_id] and Gangs.Get(t.gang_id) then
            tags[t.id] = {
                id = t.id, gangId = t.gang_id, designId = t.design_id, zone = t.zone, p = p,
                status = t.status, crossedBy = t.crossed_by, createdBy = t.created_by, createdAt = t.created or os.time(),
            }
        end
    end
    loaded = true
end

---Full snapshot for a client that just started.
function Graffiti.Snapshot()
    if not loaded then return nil end
    local outTags, outDesigns = {}, {}
    for _, t in pairs(tags) do
        outTags[#outTags + 1] = clientTag(t)
        outDesigns[t.designId] = outDesigns[t.designId] or clientDesign(designs[t.designId])
    end
    local designList = {}
    for _, d in pairs(outDesigns) do designList[#designList + 1] = d end
    return { tags = outTags, designs = designList }
end

-------------------------------------------------------------------------------
-- Designs (tablet)
-------------------------------------------------------------------------------

function Graffiti.GetGangOverview(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end

    local list, active, zones = {}, 0, {}
    for _, d in pairs(designs) do
        if d.gangId == gang.id then
            local inUse = 0
            for _, t in pairs(tags) do if t.designId == d.id then inUse = inUse + 1 end end
            list[#list + 1] = { id = d.id, name = d.name, spec = d.spec, status = d.status, inUse = inUse }
        end
    end
    table.sort(list, function(a, b) return a.id < b.id end)

    for _, t in pairs(tags) do
        if t.gangId == gang.id and t.status == 'active' then
            active = active + 1
            if t.zone then zones[t.zone] = true end
        end
    end
    local zoneCount = 0
    for _ in pairs(zones) do zoneCount = zoneCount + 1 end

    return {
        designs = list,
        canSpray = Gangs.HasPermission(cid, 'graffiti'),
        canDesign = Gangs.HasPermission(cid, 'graffiti'),
        requireApproval = cfg.requireApproval,
        maxDesigns = cfg.maxDesigns,
        maxTextLength = cfg.maxTextLength,
        maxPerZone = cfg.maxPerZone,
        activeTags = active,
        activeZones = zoneCount,
        fonts = cfg.fonts,
        styles = cfg.styles,
        sprayItem = cfg.sprayItem,
        allowPictures = cfg.allowPictures,
        onlyInAreas = cfg.onlyInAreas,
        logo = Gangs.ApprovedLogo(gang.id),
        hosts = Config.Logos.allowedHosts,
        anyHost = Config.Logos.allowAnyHost,
        onWalls = Graffiti.GangTags(gang.id),
        canRemove = Gangs.HasPermission(cid, 'graffiti'),
    }
end

---Every tag a gang has up, grouped by area, for the tablet.
function Graffiti.GangTags(gangId)
    local byArea, now = {}, os.time()
    for _, t in pairs(tags) do
        if t.gangId == gangId then
            local key = t.zone or '_none'
            byArea[key] = byArea[key] or { area = t.zone and Zones.Label(t.zone) or 'Outside any area', inArea = t.zone ~= nil, tags = {}, active = 0 }
            local d = designs[t.designId]
            local crosser = t.crossedBy and Gangs.Get(t.crossedBy)
            table.insert(byArea[key].tags, {
                id = t.id, design = d and d.name or 'Tag', spec = d and d.spec or nil, status = t.status,
                crossedBy = crosser and crosser.label or nil, age = now - (t.createdAt or now),
                x = t.p.x, y = t.p.y,
            })
            if t.status == 'active' then byArea[key].active = byArea[key].active + 1 end
        end
    end
    local list = {}
    for _, a in pairs(byArea) do
        table.sort(a.tags, function(x, y) return x.age < y.age end)
        a.limit = a.inArea and cfg.maxPerZone or nil
        list[#list + 1] = a
    end
    table.sort(list, function(x, y)
        if x.inArea ~= y.inArea then return x.inArea end
        return x.area < y.area
    end)
    return list
end

---Remove one of your own gang's tags from the tablet.
function Graffiti.RemoveOwn(src, tagId)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'graffiti') then return false, 'no_permission' end
    local tag = tags[tonumber(tagId)]
    if not tag then return false, 'tag_gone' end
    if tag.gangId ~= gang.id then return false, 'invalid' end
    setRemoved(tag, 'removed from tablet')
    Logger.Log(src, 'tag_removed_tablet', ('%s removed tag %d'):format(cid, tag.id))
    return true
end

function Graffiti.SubmitDesign(src, name, spec)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'graffiti') then return false, 'no_permission' end

    local count = 0
    for _, d in pairs(designs) do if d.gangId == gang.id then count = count + 1 end end
    if count >= cfg.maxDesigns then return false, 'too_many_designs' end

    local clean, err = cleanSpec(spec)
    if not clean then return false, err end
    name = trim(name):gsub('[<>]', ''):sub(1, 48)
    if #name == 0 then name = clean.text or 'Picture' end

    local status = (cfg.requireApproval or clean.kind == 'image') and 'pending' or 'approved'
    local id = MySQL.insert.await('INSERT INTO vg_tag_designs (gang_id, name, design, status) VALUES (?, ?, ?, ?)', { gang.id, name, json.encode(clean), status })
    if not id then return false, 'db_error' end

    designs[id] = { id = id, gangId = gang.id, name = name, spec = clean, status = status }
    Logger.Log(src, 'tag_design_submitted', ('%s submitted design %d for gang %d'):format(cid, id, gang.id))
    if status == 'pending' then TriggerEvent('vinewood_gangs:server:designPending', id) end
    return true
end

function Graffiti.DeleteDesign(src, designId)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'graffiti') then return false, 'no_permission' end
    local d = designs[tonumber(designId)]
    if not d or d.gangId ~= gang.id then return false, 'invalid' end
    for _, t in pairs(tags) do
        if t.designId == d.id then return false, 'design_in_use' end
    end
    MySQL.update.await('DELETE FROM vg_tag_designs WHERE id = ?', { d.id })
    designs[d.id] = nil
    return true
end

-------------------------------------------------------------------------------
-- Spraying
-------------------------------------------------------------------------------

---Checks everything about a spray. Used before the animation and again before saving.
local function validateSpray(src, designId, placement)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'graffiti') then return nil, 'no_permission' end

    local design = designs[tonumber(designId)]
    if not design or design.gangId ~= gang.id then return nil, 'invalid' end
    if design.status ~= 'approved' then return nil, 'design_not_approved' end
    if not hasSprayItem(src) then return nil, 'need_spraycan' end

    local last = lastSpray[cid]
    if last and os.time() - last < cfg.cooldown then return nil, 'spray_cooldown' end

    local p, err = cleanPlacement(src, placement)
    if not p then return nil, err end
    local pos = vector3(p.x, p.y, p.z)
    local zone = Zones.FromCoords(pos)
    if not zone and cfg.onlyInAreas then return nil, 'graffiti_no_area' end

    local paintOver, perZone = {}, 0
    for _, t in pairs(tags) do
        if #(tagPos(t) - pos) < cfg.minSpacing then
            if t.status == 'active' then return nil, 'too_close' end
            paintOver[#paintOver + 1] = t -- crossed-out tags get painted over
        end
        if zone and t.zone == zone and t.gangId == gang.id and t.status == 'active' then
            perZone = perZone + 1
        end
    end
    do -- tags only go on your own turf; the first on the main hex; more as the gang holds more hexes
        if not zone or Influence.GetOwner(zone) ~= gang.id then return nil, 'graffiti_not_your_turf' end
        local active, onMain = 0, false
        local main = Hexes.MainOf(gang.id)
        for _, t in pairs(tags) do
            if t.gangId == gang.id and t.status == 'active' and not paintOverContains(paintOver, t) then
                active = active + 1
                if t.zone == main then onMain = true end
            end
        end
        if not onMain and zone ~= main then return nil, 'graffiti_main_first' end
        if active >= Hexes.SpraySlots(gang.id) then return nil, 'graffiti_no_slots' end
    end

    return { gang = gang, cid = cid, design = design, p = p, pos = pos, zone = zone, paintOver = paintOver }
end

function Graffiti.CanPlace(src, designId, placement)
    local ctx, err = validateSpray(src, designId, placement)
    if not ctx then return false, err end
    return true
end

function Graffiti.Place(src, designId, placement)
    local ctx, err = validateSpray(src, designId, placement)
    if not ctx then return false, err end

    useSprayItem(src)
    for _, old in ipairs(ctx.paintOver) do setRemoved(old, 'painted over') end

    local id = MySQL.insert.await([[
        INSERT INTO vg_graffiti (gang_id, design_id, zone, placement, created_by)
        VALUES (?, ?, NULLIF(?, ''), ?, ?)
    ]], { ctx.gang.id, ctx.design.id, ctx.zone or '', json.encode(ctx.p), ctx.cid })
    if not id then return false, 'db_error' end

    local tag = { id = id, gangId = ctx.gang.id, designId = ctx.design.id, zone = ctx.zone, p = ctx.p, status = 'active', createdBy = ctx.cid, createdAt = os.time() }
    tags[id] = tag
    lastSpray[ctx.cid] = os.time()

    Activity.Record({ type = 'graffiti_tag', gangId = ctx.gang.id, citizenid = ctx.cid, zone = ctx.zone, coords = ctx.pos, metadata = { tagId = id } })
    Bridge.Dispatch.Witness(Config.Witnesses.graffiti, {
        title = 'Criminal damage', code = 'CRIM DAM', priority = 3, coords = ctx.pos, approximate = true,
        description = 'Caller reports someone spraying graffiti on a wall.',
    })
    broadcastUpsert(tag)
    return true
end

function Graffiti.Cross(src, tagId)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'graffiti') then return false, 'no_permission' end

    local tag = tags[tonumber(tagId)]
    if not tag or tag.status ~= 'active' then return false, 'tag_gone' end
    if tag.gangId == gang.id then return false, 'own_tag' end
    if Relations.IsProtected(gang.id, tag.gangId, tag.zone) then return false, 'diplomacy_protected' end
    if not nearTag(src, tag) then return false, 'too_far' end
    if not hasSprayItem(src) then return false, 'need_spraycan' end

    useSprayItem(src)
    tag.status, tag.crossedBy = 'crossed', gang.id
    MySQL.update("UPDATE vg_graffiti SET status = 'crossed', crossed_by = ? WHERE id = ?", { gang.id, tag.id })

    Activity.Record({ type = 'graffiti_cross', gangId = gang.id, citizenid = cid, zone = tag.zone, coords = tagPos(tag), targetGangId = tag.gangId,
        multiplier = Relations.HostileMultiplier(gang.id, tag.gangId), metadata = { tagId = tag.id } })
    Gangs.NotifyGang(tag.gangId, locale('tag_crossed_alert', Zones.Label(tag.zone)), 'error')
    broadcastUpsert(tag)
    return true
end

---Cleaners (configured jobs) scrub any tag; gang members can remove their own.
function Graffiti.Clean(src, tagId)
    local tag = tags[tonumber(tagId)]
    if not tag then return false, 'tag_gone' end
    if not nearTag(src, tag) then return false, 'too_far' end

    local job = Bridge.GetJob(src)
    local isCleaner = job and cfg.cleanJobs[job]
    local gang, _, cid = Gangs.GetPlayerGang(src)
    local isOwner = gang and gang.id == tag.gangId and Gangs.HasPermission(cid, 'graffiti')
    if not isCleaner and not isOwner then return false, 'no_permission' end

    setRemoved(tag, isCleaner and 'cleaned' or 'removed by owner')

    if isCleaner and not isOwner then
        local def = Config.Activities.graffiti_cleaned
        if tag.zone and def and def.rivalInfluence and Gangs.Get(tag.gangId) then
            Influence.Add(tag.zone, tag.gangId, def.rivalInfluence)
        end
        if cfg.cleanReward > 0 then Bridge.AddMoney(src, 'bank', cfg.cleanReward, 'graffiti-cleaning') end
        Logger.Log(src, 'tag_cleaned', ('%s cleaned tag %d'):format(Bridge.GetCitizenId(src) or '?', tag.id))
    end
    return true
end

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

function Graffiti.PendingDesigns()
    local list = {}
    for _, d in pairs(designs) do
        if d.status == 'pending' then
            local g = Gangs.Get(d.gangId)
            list[#list + 1] = { id = d.id, name = d.name, spec = d.spec, gang = g and g.label or '?', colour = g and g.colour }
        end
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

function Graffiti.ReviewDesign(designId, approve, actor)
    local d = designs[tonumber(designId)]
    if not d or d.status ~= 'pending' then return false, 'invalid' end
    d.status = approve and 'approved' or 'rejected'
    MySQL.update.await('UPDATE vg_tag_designs SET status = ?, reviewed_by = ? WHERE id = ?', { d.status, tostring(actor and Bridge.GetCitizenId(actor) or 'console'), d.id })
    Gangs.NotifyGang(d.gangId, locale(approve and 'design_approved' or 'design_rejected', d.name), approve and 'success' or 'error')
    Logger.Log(actor or 0, 'tag_design_reviewed', ('design %d %s'):format(d.id, d.status))
    return true
end

function Graffiti.ListTags(limit)
    local list = {}
    for _, t in pairs(tags) do
        local g = Gangs.Get(t.gangId)
        list[#list + 1] = {
            id = t.id, gang = g and g.label or '?', colour = g and g.colour, zone = t.zone and Zones.Label(t.zone) or 'Outside any area',
            status = t.status, design = designs[t.designId] and designs[t.designId].spec,
        }
    end
    table.sort(list, function(a, b) return a.id > b.id end)
    while #list > (limit or 60) do table.remove(list) end
    return list
end

function Graffiti.AdminRemove(tagId, actor)
    local tag = tags[tonumber(tagId)]
    if not tag then return false, 'tag_gone' end
    setRemoved(tag, 'staff')
    Logger.Log(actor or 0, 'staff_tag_removed', ('tag %d removed'):format(tag.id))
    return true
end

function Graffiti.GetTagCoords(tagId)
    local tag = tags[tonumber(tagId)]
    if not tag then return nil end
    -- Stand a metre in front of the wall
    return { x = tag.p.x + tag.p.nx * 1.2, y = tag.p.y + tag.p.ny * 1.2, z = tag.p.z, nx = tag.p.nx, ny = tag.p.ny }
end

-------------------------------------------------------------------------------
-- Ticks and lifecycle
-------------------------------------------------------------------------------

function Graffiti.Start() end -- tags mark turf; control comes from dealing (server/systems/hexes.lua)

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    for _, t in pairs(tags) do
        if t.gangId == gangId then setRemoved(t, 'gang disbanded') end
    end
    for id, d in pairs(designs) do
        if d.gangId == gangId then designs[id] = nil end
    end
end)
