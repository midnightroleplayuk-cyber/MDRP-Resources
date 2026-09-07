if not lib then return end

--[[
    Dynamic (database-backed, in-game created) crafting benches.

    Definitions live in `ox_inventory_crafting` and are registered with the
    crafting module on resource start (and on create/edit). Clients are told
    about each one so they can build the interaction zone / spawn the prop.
]]

local db = require 'modules.mysql.server'
local Items = require 'modules.items.server'

local CustomCraft = {}

-- Builds a sorted {name,label} list of every real item for the UI dropdowns.
local function getItemList()
    local list = {}
    for name, item in pairs(Items() or {}) do
        if type(item) == 'table' and (item.label or item.name) then
            list[#list + 1] = { name = name, label = item.label or name }
        end
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    return list
end

---@type table<string, table> id -> definition (decoded)
local benches = {}

local ACE_PERMISSION = 'ox_inventory.admin'

local function isAdmin(source)
    if source == 0 then return true end
    return IsPlayerAceAllowed(source --[[@as string]], ACE_PERMISSION)
end

-- Coerces a tinyint column that may arrive as 1/0 (from the DB) or true/false
-- (from buildRow before a DB round-trip) into a boolean.
local function toBool(v, default)
    if v == nil then return default end
    return v == 1 or v == true
end

local function decodeBench(row)
    return {
        id = row.id,
        label = row.label,
        groups = row.groups and json.decode(row.groups) or nil,
        recipes = row.recipes and json.decode(row.recipes) or {},
        coords = row.coords and json.decode(row.coords) or nil,
        target = row.target and json.decode(row.target) or nil,
        prop = row.prop and json.decode(row.prop) or nil,
        showMarker = toBool(row.showmarker, true),
        blip = toBool(row.blip, false),
    }
end

-- Returns an array of { x, y, z, heading } from a bench's coords (single or array).
local function getLocations(bench)
    local out = {}
    local c = bench.coords

    if c then
        if c[1] then
            for i = 1, #c do out[#out + 1] = c[i] end
        else
            out[#out + 1] = c
        end
    elseif bench.target and bench.target.coords then
        local t = bench.target.coords
        out[#out + 1] = { x = t.x, y = t.y, z = t.z, heading = bench.target.heading or 0.0 }
    end

    return out
end

-- Builds the data table the crafting module expects and registers it (many points).
local function applyBench(bench)
    local locations = getLocations(bench)

    -- Map UI recipes → ox crafting recipe shape.
    local items = {}
    for i = 1, #bench.recipes do
        local r = bench.recipes[i]
        local ingredients = {}
        for _, ing in ipairs(r.ingredients or {}) do
            if ing.name and ing.name ~= '' then
                ingredients[ing.name] = tonumber(ing.count) or 1
            end
        end
        items[#items + 1] = {
            name = r.name,
            ingredients = ingredients,
            duration = tonumber(r.duration) or 3000,
            count = tonumber(r.count) or 1,
            metadata = r.metadata,
        }
    end

    local points, zones = {}, {}
    for i = 1, #locations do
        local l = locations[i]
        local v = vec3(l.x + 0.0, l.y + 0.0, l.z + 0.0)
        points[i] = v
        zones[i] = { coords = v, size = vec3(2.0, 2.0, 2.0), rotation = l.heading or 0.0, groups = bench.groups }
    end

    exports.ox_inventory:RegisterCraftingBench(bench.id, {
        name = bench.id,
        label = bench.label,
        groups = bench.groups,
        items = items,
        points = #points > 0 and points or nil,
        zones = #zones > 0 and zones or nil,
    })
end

local function syncToClients(bench, target)
    TriggerClientEvent('ox_inventory:registerCustomCraft', target or -1, bench)
end

-- One-time migration of the original static benches into the DB.
-- Guarded by a persistent KVP flag so deleting every bench never re-triggers it.
local MIGRATION_KEY = 'ox_inventory:crafting_migrated'

local function migrateStaticCrafting(force)
    if not force then
        if GetResourceKvpInt(MIGRATION_KEY) == 1 then return 0 end
        -- Mark as done up-front so it can never run twice, even if it inserts nothing.
        SetResourceKvpInt(MIGRATION_KEY, 1)
        if db.countDynamicCrafting() > 0 then return 0 end
    else
        SetResourceKvpInt(MIGRATION_KEY, 1)
    end

    local ok, static = pcall(lib.load, 'data.crafting_migrate')
    if not ok or type(static) ~= 'table' then return 0 end

    local migrated = 0

    for key, def in pairs(static) do
        local id = def.name or key
        local cid = tostring(id):gsub('[^%w_]', '_')

        -- Never re-import the example bench, and on a forced merge skip benches
        -- that already exist.
        if cid ~= 'debug_crafting' and not (force and benches[cid]) then
        local loc = (def.zones and def.zones[1] and def.zones[1].coords) or (def.points and def.points[1])

        -- Build UI-shaped recipes from the static items.
        local recipes = {}
        for i = 1, #(def.items or {}) do
            local item = def.items[i]
            local ingredients = {}
            for ing, count in pairs(item.ingredients or {}) do
                ingredients[#ingredients + 1] = { name = ing, count = count }
            end
            recipes[#recipes + 1] = {
                name = item.name,
                count = item.count or 1,
                duration = (item.duration or 3000) / 1000,
                ingredients = ingredients,
            }
        end

            local row = {
                id = cid,
                label = def.label or tostring(id),
                groups = def.groups and json.encode(def.groups) or nil,
                recipes = json.encode(recipes),
                coords = loc and json.encode({ x = loc.x, y = loc.y, z = loc.z, heading = (def.zones and def.zones[1] and def.zones[1].rotation) or 0.0 }) or nil,
                target = nil,
                prop = nil,
                showmarker = true,
                blip = false,
                createdby = 'migration',
            }

            db.saveDynamicCrafting(row)

            -- On a forced merge, register immediately so it appears without a restart.
            if force then
                local bench = decodeBench(row)
                benches[bench.id] = bench
                applyBench(bench)
                syncToClients(bench)
            end

            migrated += 1
        end
    end

    if migrated > 0 then
        print(('[ox_inventory] migrated %s static crafting benches into the database'):format(migrated))
    end

    return migrated
end

function CustomCraft.LoadAll()
    local rows = db.loadDynamicCrafting()
    for i = 1, #rows do
        local bench = decodeBench(rows[i])
        benches[bench.id] = bench
        applyBench(bench)
    end
    return benches
end

local function clientList()
    local list = {}
    for _, bench in pairs(benches) do
        list[#list + 1] = bench
    end
    return list
end

RegisterNetEvent('ox_inventory:requestCustomCraft', function()
    TriggerClientEvent('ox_inventory:setCustomCraft', source, clientList())
end)

local function buildRow(data, source)
    if type(data.id) ~= 'string' or data.id == '' then return false, 'invalid_id' end
    if type(data.label) ~= 'string' or data.label == '' then return false, 'invalid_label' end

    local id = data.id:lower():gsub('[^%w_]', '_')

    return true, {
        id = id,
        label = data.label,
        groups = (data.groups and next(data.groups)) and json.encode(data.groups) or nil,
        recipes = data.recipes and json.encode(data.recipes) or json.encode({}),
        coords = data.coords and json.encode(data.coords) or nil,
        target = data.target and json.encode(data.target) or nil,
        prop = data.prop and json.encode(data.prop) or nil,
        showmarker = data.showMarker ~= false,
        blip = data.blip == true,
        createdby = GetPlayerName(source) or 'unknown',
    }
end

-- ── NUI callbacks ──────────────────────────────────────────────

lib.callback.register('ox_inventory:getCraftAdminData', function(source)
    if not isAdmin(source) then return { allowed = false } end

    return {
        allowed = true,
        benches = clientList(),
        items = getItemList(),
    }
end)

lib.callback.register('ox_inventory:saveCustomCraft', function(source, data)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end

    local ok, row = buildRow(data, source)
    if not ok then return { ok = false, error = row } end

    db.saveDynamicCrafting(row)

    local bench = decodeBench(row)
    benches[bench.id] = bench
    applyBench(bench)
    syncToClients(bench)

    return { ok = true, bench = bench }
end)

lib.callback.register('ox_inventory:deleteCustomCraft', function(source, id)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end
    if not benches[id] then return { ok = false, error = 'not_found' } end

    db.deleteDynamicCrafting(id)
    benches[id] = nil
    exports.ox_inventory:RemoveCraftingBench(id)
    TriggerClientEvent('ox_inventory:removeCustomCraft', -1, id)

    return { ok = true }
end)

-- Force a merge-migration from data/crafting_migrate.lua (used by /oxinventory_migrate).
function CustomCraft.ForceMigrate()
    return migrateStaticCrafting(true)
end

CreateThread(function()
    Wait(1500)
    migrateStaticCrafting()
    CustomCraft.LoadAll()
end)

return CustomCraft
