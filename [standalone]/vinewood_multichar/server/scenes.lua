Scenes = {}

local list = {} -- [id] = scene

local function rowToScene(r)
    local ok, data = pcall(json.decode, r.data)
    data = (ok and type(data) == 'table') and data or {}
    data.id = r.id
    data.name = r.name
    data.enabled = r.enabled == 1 or r.enabled == true
    data.weight = r.weight
    data.updatedBy = r.updated_by
    data.updatedAt = r.updated_at
    return data
end

function Scenes.Load()
    DB.Await()
    list = {}
    local rows = MySQL.query.await('SELECT * FROM vinewood_multichar_scenes') or {}
    for _, r in ipairs(rows) do list[r.id] = rowToScene(r) end
end

function Scenes.All()
    local out = {}
    for _, s in pairs(list) do out[#out + 1] = s end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end

function Scenes.Get(id)
    return list[tonumber(id) or -1]
end

function Scenes.Save(scene, by)
    local id = tonumber(scene.id)
    local clean = VMC.SanitiseScene(scene)
    local data = json.encode({ env = clean.env, camera = clean.camera, spots = clean.spots, props = clean.props })
    if id and list[id] then
        MySQL.update.await('UPDATE vinewood_multichar_scenes SET name = ?, enabled = ?, weight = ?, data = ?, updated_by = ? WHERE id = ?',
            { clean.name, clean.enabled and 1 or 0, clean.weight, data, by, id })
    else
        id = MySQL.insert.await('INSERT INTO vinewood_multichar_scenes (name, enabled, weight, data, updated_by) VALUES (?, ?, ?, ?, ?)',
            { clean.name, clean.enabled and 1 or 0, clean.weight, data, by })
    end
    local row = MySQL.single.await('SELECT * FROM vinewood_multichar_scenes WHERE id = ?', { id })
    if row then list[id] = rowToScene(row) end
    return list[id]
end

function Scenes.SetEnabled(id, enabled)
    id = tonumber(id)
    if not list[id] then return end
    MySQL.update.await('UPDATE vinewood_multichar_scenes SET enabled = ? WHERE id = ?', { enabled and 1 or 0, id })
    list[id].enabled = enabled
end

function Scenes.Delete(id)
    id = tonumber(id)
    MySQL.query.await('DELETE FROM vinewood_multichar_scenes WHERE id = ?', { id })
    list[id] = nil
end

function Scenes.Duplicate(id, by)
    local s = Scenes.Get(id)
    if not s then return end
    local copy = VMC.Copy(s)
    copy.id = nil
    copy.name = (s.name .. ' (copy)'):sub(1, 48)
    copy.enabled = false
    return Scenes.Save(copy, by)
end

-- Picks the scene a player sees on the selection screen
function Scenes.Pick()
    local s = Slots.GetSettings()
    if s.sceneMode == 'fixed' and s.fixedScene and list[s.fixedScene] then
        return list[s.fixedScene]
    end
    local pool, total = {}, 0
    for _, sc in pairs(list) do
        if sc.enabled and (sc.weight or 1) > 0 and sc.spots and #sc.spots > 0 then
            pool[#pool + 1] = sc
            total = total + (sc.weight or 1)
        end
    end
    if #pool == 0 then return Config.FallbackScene end
    local r = math.random() * total
    for _, sc in ipairs(pool) do
        r = r - (sc.weight or 1)
        if r <= 0 then return sc end
    end
    return pool[#pool]
end

CreateThread(function()
    math.randomseed(os.time())
    Scenes.Load()
end)
