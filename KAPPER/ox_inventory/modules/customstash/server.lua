if not lib then return end

--[[
    Dynamic (database-backed, in-game created) stashes.

    Definitions live in the `ox_inventory_stashes` table and are registered with
    ox_inventory on resource start (and whenever one is created/edited in-game).
    The client is told about each definition so it can build the interaction zone
    or spawn the prop.
]]

local db = require 'modules.mysql.server'

local CustomStash = {}

---@type table<string, table> name -> definition (decoded)
local stashes = {}

local ACE_PERMISSION = 'ox_inventory.admin'

local function isAdmin(source)
    if source == 0 then return true end -- console
    return IsPlayerAceAllowed(source --[[@as string]], ACE_PERMISSION)
end

-- Coerces a tinyint column that may arrive as 1/0 (from the DB) or true/false
-- (from buildRow before a DB round-trip) into a boolean.
local function toBool(v, default)
    if v == nil then return default end
    return v == 1 or v == true
end

-- Normalises a stored/edited definition row into the shape the client + register need.
local function decodeStash(row)
    local groups = row.groups and json.decode(row.groups) or nil
    local coords = row.coords and json.decode(row.coords) or nil
    local target = row.target and json.decode(row.target) or nil
    local prop = row.prop and json.decode(row.prop) or nil

    return {
        name = row.name,
        label = row.label,
        owner = row.owner == 'true' and true or (row.owner ~= '' and row.owner or nil),
        slots = row.slots,
        maxWeight = row.maxweight or row.maxWeight,
        groups = groups,
        coords = coords,
        target = target,
        prop = prop,
        instance = row.instance,
        showMarker = toBool(row.showmarker, true),
    }
end

-- Registers a single definition with ox_inventory so it can be opened.
local function applyStash(stash)
    local coords

    if stash.prop and stash.prop.enabled and stash.prop.coords then
        coords = vec3(stash.prop.coords.x, stash.prop.coords.y, stash.prop.coords.z)
    elseif stash.target and stash.target.coords then
        coords = vec3(stash.target.coords.x, stash.target.coords.y, stash.target.coords.z)
    elseif stash.coords then
        coords = vec3(stash.coords.x, stash.coords.y, stash.coords.z)
    end

    exports.ox_inventory:RegisterStash(
        stash.name,
        stash.label,
        stash.slots,
        stash.maxWeight,
        stash.owner,
        stash.groups,
        coords,
        stash.instance
    )
end

-- Broadcasts the full (or a single) definition to clients to build zones/props.
local function syncToClients(stash, target)
    TriggerClientEvent('ox_inventory:registerCustomStash', target or -1, stash)
end

-- One-time migration of the original static stashes into the DB.
-- Guarded by a persistent KVP flag so deleting every stash never re-triggers it.
local MIGRATION_KEY = 'ox_inventory:stashes_migrated'

local function migrateStaticStashes(force)
    if not force then
        if GetResourceKvpInt(MIGRATION_KEY) == 1 then return 0 end
        SetResourceKvpInt(MIGRATION_KEY, 1)
        if db.countDynamicStashes() > 0 then return 0 end
    else
        SetResourceKvpInt(MIGRATION_KEY, 1)
    end

    local ok, static = pcall(lib.load, 'data.stashes_migrate')
    if not ok or type(static) ~= 'table' then return 0 end

    local migrated = 0

    for _, def in pairs(static) do
        local name = def.name and tostring(def.name):lower():gsub('[^%w_]', '_') or nil

        -- On a forced merge skip stashes that already exist (don't clobber edits).
        if name and not (force and stashes[name]) then
            local t = def.target
            local coords = def.coords or (t and t.loc)
            local target = (t and t.loc) and {
                coords = { x = t.loc.x, y = t.loc.y, z = t.loc.z },
                heading = t.heading or 0.0,
                size = { x = t.width or 1.5, y = t.length or 1.5, z = math.abs((t.maxZ or 0) - (t.minZ or 0)) + 1.0 },
                label = t.label,
            } or nil

            local row = {
                name = name,
                label = def.label or def.name,
                owner = def.owner == true and 'true' or (def.owner or ''),
                slots = def.slots or 50,
                maxweight = def.weight or def.maxWeight or 100000,
                groups = def.groups and json.encode(def.groups) or (def.jobs and json.encode(def.jobs)) or nil,
                coords = coords and json.encode({ x = coords.x, y = coords.y, z = coords.z }) or nil,
                target = target and json.encode(target) or nil,
                prop = nil,
                instance = nil,
                showmarker = true,
                createdby = 'migration',
            }

            db.saveDynamicStash(row)

            -- On a forced merge, register immediately so it appears without a restart.
            if force then
                local stash = decodeStash(row)
                stashes[stash.name] = stash
                applyStash(stash)
                syncToClients(stash)
            end

            migrated += 1
        end
    end

    if migrated > 0 then
        print(('[ox_inventory] migrated %s static stashes into the database'):format(migrated))
    end

    return migrated
end

function CustomStash.LoadAll()
    local rows = db.loadDynamicStashes()

    for i = 1, #rows do
        local stash = decodeStash(rows[i])
        stashes[stash.name] = stash
        applyStash(stash)
    end

    return stashes
end

-- Client list payload (lightweight; only what a zone/prop needs).
local function clientList()
    local list = {}

    for _, stash in pairs(stashes) do
        list[#list + 1] = stash
    end

    return list
end

-- Send everything to a client that just loaded the UI / spawned in.
RegisterNetEvent('ox_inventory:requestCustomStashes', function()
    local src = source
    TriggerClientEvent('ox_inventory:setCustomStashes', src, clientList())
end)

-- Build a row out of a UI payload (validates + json-encodes the complex fields).
local function buildRow(data, source)
    if type(data.name) ~= 'string' or data.name == '' then return false, 'invalid_name' end
    if type(data.label) ~= 'string' or data.label == '' then return false, 'invalid_label' end

    local slots = tonumber(data.slots) or 50
    local maxWeight = tonumber(data.maxWeight) or 100000

    -- owner: 'shared' | 'personal' (true) | identifier string
    local owner
    if data.owner == 'personal' then
        owner = 'true'
    elseif data.owner and data.owner ~= 'shared' and data.owner ~= '' then
        owner = tostring(data.owner)
    else
        owner = ''
    end

    -- sanitise name to a safe identifier
    local name = data.name:lower():gsub('[^%w_]', '_')

    return true, {
        name = name,
        label = data.label,
        owner = owner,
        slots = math.floor(slots),
        maxweight = math.floor(maxWeight),
        groups = (data.groups and next(data.groups)) and json.encode(data.groups) or nil,
        coords = data.coords and json.encode(data.coords) or nil,
        target = data.target and json.encode(data.target) or nil,
        prop = data.prop and json.encode(data.prop) or nil,
        instance = data.instance and tonumber(data.instance) or nil,
        showmarker = data.showMarker ~= false,
        createdby = GetPlayerName(source) or 'unknown',
    }
end

-- ── NUI callbacks ──────────────────────────────────────────────

lib.callback.register('ox_inventory:getStashAdminData', function(source)
    if not isAdmin(source) then return { allowed = false } end

    return {
        allowed = true,
        stashes = clientList(),
        jobs = db.getJobsList and db.getJobsList() or {},
    }
end)

lib.callback.register('ox_inventory:saveCustomStash', function(source, data)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end

    local ok, row = buildRow(data, source)
    if not ok then return { ok = false, error = row } end

    db.saveDynamicStash(row)

    local stash = decodeStash(row)
    stashes[stash.name] = stash
    applyStash(stash)
    syncToClients(stash)

    return { ok = true, stash = stash }
end)

lib.callback.register('ox_inventory:deleteCustomStash', function(source, name)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end
    if not stashes[name] then return { ok = false, error = 'not_found' } end

    db.deleteDynamicStash(name)
    stashes[name] = nil

    TriggerClientEvent('ox_inventory:removeCustomStash', -1, name)

    return { ok = true }
end)

-- Force a merge-migration from data/stashes_migrate.lua (used by /oxinventory_migrate).
function CustomStash.ForceMigrate()
    return migrateStaticStashes(true)
end

-- Load on start (after the DB thread had a chance to create the table).
CreateThread(function()
    Wait(1000)
    migrateStaticStashes()
    CustomStash.LoadAll()
end)

return CustomStash
