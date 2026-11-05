ZoneStore = {}

local function publish(defs)
    Zones.Set(defs)
    GlobalState.vg_zone_defs = defs
end

---Config areas plus drawn areas. Drawn areas never replace config ones.
function ZoneStore.Load()
    local defs = Zones.Serialise(Config.Zones)
    for _, r in ipairs(MySQL.query.await('SELECT zone, label, value, points FROM vg_zones')) do
        local ok, pts = pcall(json.decode, r.points)
        if ok and type(pts) == 'table' and #pts >= 3 and not Zones.IsFromConfig(r.zone) then
            defs[r.zone] = { label = r.label, value = tonumber(r.value) or 1.0, points = pts, drawn = true }
        end
    end
    publish(defs)
end

local function overlaps(points)
    for key, z in pairs(Config.Zones) do
        for _, p in ipairs(points) do
            if Zones.PointInPolygon(z.points, p.x, p.y) then return key end
        end
        for _, p in ipairs(z.points) do
            if Zones.PointInPolygon(points, p.x, p.y) then return key end
        end
    end
end

function ZoneStore.Save(src, label, value, points)
    label = tostring(label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 64)
    if #label < 2 then return false, 'invalid_label' end
    value = math.max(0.25, math.min(3.0, tonumber(value) or 1.0))
    if type(points) ~= 'table' or #points < 3 or #points > 40 then return false, 'zone_points' end

    local clean = {}
    for i, p in ipairs(points) do
        local x, y = tonumber(type(p) == 'table' and p.x), tonumber(type(p) == 'table' and p.y)
        if not x or not y then return false, 'zone_points' end
        clean[i] = { x = math.floor(x * 10 + 0.5) / 10, y = math.floor(y * 10 + 0.5) / 10 }
    end

    local clash = overlaps(clean)
    if clash then return false, 'zone_overlap', Zones.Label(clash) end

    local key = label:lower():gsub('[^%w]+', '_'):gsub('^_+', ''):gsub('_+$', ''):sub(1, 40)
    if #key == 0 then key = 'area' end
    local base, n = key, 1
    while Config.Zones[key] do
        n = n + 1
        key = ('%s_%d'):format(base, n)
    end

    MySQL.insert.await('INSERT INTO vg_zones (zone, label, value, points, created_by) VALUES (?, ?, ?, ?, ?)',
        { key, label, value, json.encode(clean), Bridge.GetCitizenId(src) or 'console' })

    local defs = Zones.Serialise(Config.Zones)
    for k, z in pairs(Config.Zones) do defs[k].drawn = z.drawn end
    defs[key] = { label = label, value = value, points = clean, drawn = true }
    publish(defs)
    Influence.Publish()
    Logger.Log(src, 'staff_zone_created', ('area %s (%s) drawn with %d corners'):format(key, label, #clean))
    return true, key
end

function ZoneStore.Delete(src, key)
    local z = Config.Zones[key]
    if not z then return false, 'zone_not_found' end
    if Zones.IsFromConfig(key) then return false, 'zone_from_config' end

    MySQL.update.await('DELETE FROM vg_zones WHERE zone = ?', { key })
    MySQL.update.await('DELETE FROM vg_zone_influence WHERE zone = ?', { key })
    MySQL.update.await('DELETE FROM vg_zone_state WHERE zone = ?', { key })

    local defs = {}
    for k, v in pairs(Config.Zones) do
        if k ~= key then defs[k] = v end
    end
    publish(defs)
    Influence.ClearZone(key)
    Logger.Log(src, 'staff_zone_deleted', ('area %s deleted'):format(key))
    return true
end
