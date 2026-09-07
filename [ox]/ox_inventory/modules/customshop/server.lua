if not lib then return end

--[[
    Dynamic (database-backed, in-game created) shops.

    On first boot, the shops defined in data/shops.lua are migrated into the
    `ox_inventory_shops` table. From then on they (and any created in-game) are
    registered with the shops module via the RegisterShop export.
]]

local db = require 'modules.mysql.server'
local Items = require 'modules.items.server'

local CustomShop = {}

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
local shops = {}

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

local function decodeShop(row)
    return {
        id = row.id,
        label = row.label,
        groups = row.groups and json.decode(row.groups) or nil,
        inventory = row.inventory and json.decode(row.inventory) or {},
        coords = row.coords and json.decode(row.coords) or nil, -- single {x,y,z,heading} or array
        prop = row.prop and json.decode(row.prop) or nil,
        ped = row.ped and json.decode(row.ped) or nil,
        showMarker = toBool(row.showmarker, true),
        blip = toBool(row.blip, false),
        blipSprite = row.blipsprite,
        blipColor = row.blipcolor,
        createdby = row.createdby,
    }
end

-- Builds the OxShop definition the shops module expects, and registers it.
local function applyShop(shop)
    -- Normalise locations into an array of vec3 + matching targets.
    local locs = {}
    local targets = {}

    local function addLoc(c, heading)
        locs[#locs + 1] = vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
        targets[#targets + 1] = {
            loc = vec3(c.x + 0.0, c.y + 0.0, c.z + 0.0),
            length = 1.0,
            width = 1.0,
            heading = heading or 0.0,
            minZ = c.z - 1.0,
            maxZ = c.z + 1.0,
            distance = 2.5,
        }
    end

    local coords = shop.coords
    if coords then
        if coords[1] then
            for i = 1, #coords do addLoc(coords[i], coords[i].heading) end
        else
            addLoc(coords, coords.heading)
        end
    end

    -- Map UI products → ox shop inventory shape.
    local inventory = {}
    for i = 1, #shop.inventory do
        local p = shop.inventory[i]
        local entry = { name = p.name, price = tonumber(p.price) or 0 }
        if p.currency and p.currency ~= 'money' then entry.currency = p.currency end
        if p.grade ~= nil and p.grade ~= '' then entry.grade = tonumber(p.grade) end
        if p.license and p.license ~= '' then entry.license = p.license end
        if p.metadata then entry.metadata = p.metadata end
        inventory[#inventory + 1] = entry
    end

    if #inventory == 0 then return end -- a shop with no items can't register

    exports.ox_inventory:RegisterShop(shop.id, {
        name = shop.label,
        groups = shop.groups,
        inventory = inventory,
        locations = #locs > 0 and locs or nil,
        targets = #targets > 0 and targets or nil,
    })
end

local function syncToClients(shop, target)
    TriggerClientEvent('ox_inventory:registerCustomShop', target or -1, shop)
end

-- One-time migration of the original static shops into the DB.
-- Reads from data/shops_migrate.lua (a copy of the original shops.lua) because
-- data/shops.lua itself is now emptied so the native loader makes no zones.
-- Guarded by a persistent KVP flag so deleting every shop never re-triggers it.
local MIGRATION_KEY = 'ox_inventory:shops_migrated'

local function migrateStaticShops(force)
    -- Normal boot: guarded by a KVP flag so deleting every shop never re-imports.
    -- Forced (via /oxinventory_migrate): ignores the flag and merges in anything
    -- from data/shops_migrate.lua that isn't already in the DB.
    if not force then
        if GetResourceKvpInt(MIGRATION_KEY) == 1 then return 0 end
        SetResourceKvpInt(MIGRATION_KEY, 1)
        if db.countDynamicShops() > 0 then return 0 end
    else
        SetResourceKvpInt(MIGRATION_KEY, 1)
    end

    local ok, static = pcall(lib.load, 'data.shops_migrate')
    if not ok or type(static) ~= 'table' then return 0 end
    local migrated = 0

    for shopType, def in pairs(static) do
        local sid = tostring(shopType):gsub('[^%w_]', '_')

        -- Model/prop-based shops (vending machines etc.) have no fixed location —
        -- they bind to every world prop of a model and are handled statically from
        -- data/shops.lua. Migrating them would create an unopenable "ghost" DB row
        -- (no coords, no target), so skip anything with no locations/targets.
        local isModelShop = not def.locations and not def.targets

        -- On a forced merge, re-import originals but skip shops an admin has
        -- created/edited in-game (those aren't tagged 'migration').
        local existing = shops[sid]
        if not isModelShop and not (force and existing and existing.createdby ~= 'migration') then
            -- Build a coords array from this shop's locations, matching each to
            -- its target heading by index when available.
            local coords = {}
            local sourceLocs = def.locations
            local targets = def.targets

            if sourceLocs then
                for i = 1, #sourceLocs do
                    local l = sourceLocs[i]
                    local heading = (targets and targets[i] and targets[i].heading) or 0.0
                    coords[#coords + 1] = { x = l.x, y = l.y, z = l.z, heading = heading }
                end
            end

            local inventory = {}
            for i = 1, #(def.inventory or {}) do
                local p = def.inventory[i]
                inventory[#inventory + 1] = {
                    name = p.name,
                    price = p.price or 0,
                    currency = p.currency,
                    grade = p.grade,
                    license = p.license,
                    metadata = p.metadata,
                }
            end

            local row = {
                id = sid,
                label = def.name or sid,
                groups = def.groups and json.encode(def.groups) or nil,
                inventory = json.encode(inventory),
                coords = next(coords) and json.encode(coords) or nil,
                prop = nil,
                ped = nil,
                showmarker = true,
                -- Keep a map blip if the original shop defined one.
                blip = def.blip ~= nil,
                createdby = 'migration',
            }

            db.saveDynamicShop(row)

            -- On a forced merge, register immediately so it appears without a
            -- restart. On normal boot LoadAll() handles registration right after.
            if force then
                local shop = decodeShop(row)
                shops[shop.id] = shop
                applyShop(shop)
                syncToClients(shop)
            end

            migrated += 1
        end
    end

    if migrated > 0 then
        print(('[ox_inventory] migrated %s static shops into the database'):format(migrated))
    end

    return migrated
end

function CustomShop.LoadAll()
    local rows = db.loadDynamicShops()
    for i = 1, #rows do
        local shop = decodeShop(rows[i])

        -- Clean up legacy "ghost" rows: model-based shops (e.g. vending machines)
        -- that an earlier migration wrote to the DB with no coords/prop/ped. They
        -- can never be opened and are now handled statically from data/shops.lua,
        -- so delete them instead of registering a dead shop.
        if shop.createdby == 'migration' and not shop.coords and not shop.prop and not shop.ped then
            db.deleteDynamicShop(shop.id)
            goto continue
        end

        shops[shop.id] = shop
        applyShop(shop)

        ::continue::
    end
    return shops
end

local function clientList()
    local list = {}
    for _, shop in pairs(shops) do
        list[#list + 1] = shop
    end
    return list
end

RegisterNetEvent('ox_inventory:requestCustomShops', function()
    TriggerClientEvent('ox_inventory:setCustomShops', source, clientList())
end)

local function buildRow(data, source)
    if type(data.id) ~= 'string' or data.id == '' then return false, 'invalid_id' end
    if type(data.label) ~= 'string' or data.label == '' then return false, 'invalid_label' end

    local id = data.id:gsub('[^%w_]', '_')

    return true, {
        id = id,
        label = data.label,
        groups = (data.groups and next(data.groups)) and json.encode(data.groups) or nil,
        inventory = data.inventory and json.encode(data.inventory) or json.encode({}),
        coords = data.coords and json.encode(data.coords) or nil,
        prop = data.prop and json.encode(data.prop) or nil,
        ped = data.ped and json.encode(data.ped) or nil,
        showmarker = data.showMarker ~= false,
        blip = data.blip == true,
        blipsprite = tonumber(data.blipSprite) or nil,
        blipcolor = tonumber(data.blipColor) or nil,
        createdby = GetPlayerName(source) or 'unknown',
    }
end

-- ── NUI callbacks ──────────────────────────────────────────────

lib.callback.register('ox_inventory:getShopAdminData', function(source)
    if not isAdmin(source) then return { allowed = false } end

    local currencies = { 'money' }
    if server.accounts then
        currencies = {}
        for acc in pairs(server.accounts) do currencies[#currencies + 1] = acc end
    end
    if not lib.table.contains(currencies, 'black_money') then
        currencies[#currencies + 1] = 'black_money'
    end

    return {
        allowed = true,
        shops = clientList(),
        items = getItemList(),
        currencies = currencies,
    }
end)

lib.callback.register('ox_inventory:saveCustomShop', function(source, data)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end

    local ok, row = buildRow(data, source)
    if not ok then return { ok = false, error = row } end

    db.saveDynamicShop(row)

    local shop = decodeShop(row)
    shops[shop.id] = shop
    applyShop(shop)
    syncToClients(shop)

    return { ok = true, shop = shop }
end)

lib.callback.register('ox_inventory:deleteCustomShop', function(source, id)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end
    if not shops[id] then return { ok = false, error = 'not_found' } end

    db.deleteDynamicShop(id)
    shops[id] = nil
    TriggerClientEvent('ox_inventory:removeCustomShop', -1, id)

    return { ok = true }
end)

-- Force a merge-migration from data/shops_migrate.lua (used by /oxinventory_migrate).
function CustomShop.ForceMigrate()
    return migrateStaticShops(true)
end

CreateThread(function()
    Wait(2000)
    migrateStaticShops()
    CustomShop.LoadAll()
end)

return CustomShop
