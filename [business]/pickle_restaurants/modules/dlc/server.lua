-- =============================================
--  modules/dlc | server.lua
--  THE DLC REGISTRY. An add-on pack is its own FiveM resource that hands this one
--  a content table; everything the pack adds is READ OUT OF THAT RESOURCE and
--  nothing of it is ever written to our database.
--
--  That last part is the whole design. The base resource keeps its config in the
--  `pickle_restaurant_settings` table (authored in-game, admin-owned); a DLC's
--  content is not config an admin authored, it is content a resource SHIPS. So it
--  is held here in memory, OVERLAID on the three authored arrays at read time
--  (GetFoods / GetTools / GetIngredientsCfg in core/server.lua), and it vanishes
--  the moment the pack is stopped. Nothing to migrate, nothing to clean up, and
--  no orphaned rows pointing at models that are no longer streamed.
--
--  Because the overlay happens at those three getters — the ONE place the entire
--  runtime reads the menu from — a DLC needs no support anywhere else: recipes,
--  assemblies, crafts, prep models, the cooking bar, the POS catalogue, sync
--  validation, group filtering and the admin annotations all derive from them.
--
--  HANDSHAKE (either start order works):
--    • the pack calls  exports.pickle_restaurants:RegisterDLC(content)  when it
--      starts, and again whenever `pickle_restaurants:dlcRequest` fires;
--    • we fire `dlcRequest` at our own boot, so a pack that was already running
--      when this resource restarts re-registers itself;
--    • we watch onResourceStop ourselves rather than trusting a pack to
--      unregister — a crashed pack would never get the chance.
--
--  Registered content is UNTRUSTED in exactly the way the NUI is: it goes through
--  the same sanitizers the admin panel's writes do.
-- =============================================

-- [id] = { id, name, description, version, author, resource, foods, tools,
--          ingredients, consume_anims, ingredient_costs, item_images }
local Registry = {}
-- Registration order, so two packs touching the same thing resolve predictably
-- (first registered wins, exactly like the authored config wins over both).
local Order = {}

-- ─── merged views (read by core/server.lua's three getters) ──────────────────
-- Each returns the DLC half only; core appends it AFTER the authored array, so an
-- admin entry with the same id/item always shadows a pack's.

-- Rebuilt only when the registry actually changes. `DlcRev` (a global, bumped by
-- `touch` below) is the shared dirty flag: core's own merge memo watches the SAME
-- counter, so one registration invalidates both layers and nothing downstream has
-- to allocate per call. Without this, every IngredientDef lookup — of which the
-- cooking engine does a great many — would rebuild these lists from scratch.
local cache = {}

local function touch()
    DlcRev = (DlcRev or 0) + 1
    cache = {}
end

local function collect(field)
    local hit = cache[field]
    if hit then return hit end
    local out = {}
    for _, id in ipairs(Order) do
        local d = Registry[id]
        for _, e in ipairs((d and d[field]) or {}) do out[#out + 1] = e end
    end
    cache[field] = out
    return out
end

function DlcFoods()        return collect("foods") end
function DlcTools()        return collect("tools") end
function DlcIngredients()  return collect("ingredients") end
function DlcConsumeAnims() return collect("consume_anims") end

-- Default buy-in prices a pack ships for its own items. These sit UNDER the
-- `ingredient_costs` setting (IngredientCosts in core/server.lua), so a server that
-- prices a toy its own way keeps that price and a server that never touches it
-- still gets a working Supplies row instead of an unbuyable ingredient.
function DlcIngredientCosts()
    local hit = cache.__costs
    if hit then return hit end
    local out = {}
    for _, id in ipairs(Order) do
        for item, cost in pairs((Registry[id] or {}).ingredient_costs or {}) do
            if out[item] == nil then out[item] = cost end
        end
    end
    cache.__costs = out
    return out
end

-- Item art a pack ships with itself (`nui://<pack>/…`). Folded into ItemImageCache
-- under the admin's own `item_images` overrides (RebuildItemImages).
function DlcItemImages()
    local out = {}
    for _, id in ipairs(Order) do
        for item, url in pairs((Registry[id] or {}).item_images or {}) do
            if out[item] == nil then out[item] = url end
        end
    end
    return out
end

-- Is anything installed at all? (cheap guard for the hot paths)
function AnyDlcInstalled() return #Order > 0 end

-- What the admin panel lists: one row per installed pack plus a count of what each
-- one contributes, so "what did this add?" is answerable without reading a manifest.
function DlcList()
    local out = {}
    for _, id in ipairs(Order) do
        local d = Registry[id]
        local function names(field, key)
            local list = {}
            for _, e in ipairs(d[field] or {}) do
                -- A multi-faced entry is listed BY ITS FACES: one item holding five
                -- toys should read as the five toys, not as a single "Toy" row that
                -- undersells what the pack adds. (The one-item consolidation is the
                -- right shape for the inventory, not for an inventory LISTING.)
                if type(e.variants) == "table" and #e.variants > 0 then
                    for _, v in ipairs(e.variants) do
                        list[#list + 1] = { key = e[key] .. ":" .. v.id, label = v.label or v.id }
                    end
                else
                    list[#list + 1] = { key = e[key], label = e.label or (e[key] and GetItemLabel(e[key])) or e[key] }
                end
            end
            return list
        end
        out[#out + 1] = {
            id = d.id, name = d.name, description = d.description,
            version = d.version, author = d.author, resource = d.resource,
            foods       = names("foods", "id"),
            tools       = names("tools", "id"),
            ingredients = names("ingredients", "item"),
        }
    end
    return out
end

-- ─── registration ────────────────────────────────────────────────────────────

local function trim(v, max)
    if type(v) ~= "string" then return nil end
    v = v:gsub("^%s+", ""):gsub("%s+$", "")
    if v == "" then return nil end
    return v:sub(1, max or 128)
end

-- Stamp every entry a pack contributes with the pack it came from. This mark is
-- what makes the whole thing safe end-to-end: the admin panel renders a marked
-- entry read-only, and the three sanitizers DROP marked entries outright, so even
-- a NUI that posts a DLC food back at us can never persist it into the settings
-- table and strand it there after the pack is uninstalled.
local function stamp(list, dlcId)
    for _, e in ipairs(list) do e.dlc = dlcId end
    return list
end

-- Everything a pack sends is re-validated here. The sanitizers are the SAME ones
-- the admin panel's writes go through, so a malformed pack degrades exactly like a
-- malformed hand-edit: the bad entry is dropped, the rest works.
local function sanitizeContent(raw, resource)
    local id = trim(raw.id, 64)
    if not id then return nil, "a DLC must declare an `id`" end
    local costs = {}
    for item, cost in pairs(type(raw.ingredient_costs) == "table" and raw.ingredient_costs or {}) do
        if type(item) == "string" then costs[item] = math.max(0, math.floor(tonumber(cost) or 0)) end
    end
    local images = {}
    for item, v in pairs(type(raw.item_images) == "table" and raw.item_images or {}) do
        local url = trim(type(v) == "table" and v.url or v, 512)
        if type(item) == "string" and url then images[item] = url end
    end
    return {
        id          = id,
        name        = trim(raw.name, 64) or id,
        description = trim(raw.description, 512),
        version     = trim(raw.version, 32),
        author      = trim(raw.author, 64),
        resource    = resource,
        foods            = stamp(SanitizeFoods(raw.foods), id),
        tools            = stamp(SanitizeTools(raw.tools), id),
        ingredients      = stamp(SanitizeIngredients(raw.ingredients), id),
        consume_anims    = SanitizeConsumeAnims(raw.consume_anims),
        ingredient_costs = costs,
        item_images      = images,
    }
end

-- Re-derive + push. A pack can register before the database is up (it started
-- first), in which case boot's own RebuildDerived picks the content up — there is
-- nothing to sync to yet.
local function applyChange()
    touch() -- invalidate BOTH this file's lists and core's merge memo
    if not RestaurantsReady then return end
    RebuildDerived()
    SyncWorldSoon()
end

-- THE export a pack calls. Idempotent by id: re-registering (a pack restart, or
-- our dlcRequest reaching a pack that never stopped) replaces the entry in place
-- rather than stacking a second copy of its content.
exports("RegisterDLC", function(raw)
    local resource = GetInvokingResource() or "unknown"
    if type(raw) ~= "table" then
        return print(("[pickle_restaurants] ^1DLC '%s' sent no content table.^7"):format(resource))
    end
    local d, err = sanitizeContent(raw, resource)
    if not d then
        return print(("[pickle_restaurants] ^1DLC '%s' rejected: %s.^7"):format(resource, err))
    end
    if not Registry[d.id] then Order[#Order + 1] = d.id end
    Registry[d.id] = d
    applyChange()
    print(("[pickle_restaurants] DLC loaded: %s%s (%s) — %d food, %d tool, %d ingredient"):format(
        d.name, d.version and (" v" .. d.version) or "", resource,
        #d.foods, #d.tools, #d.ingredients))
    return true
end)

-- A pack going away takes its content with it. Done from OUR side (watching every
-- resource stop) rather than asking packs to unregister: a pack that errored on
-- start, or was killed, would never make that call, and its content would sit in
-- the menu pointing at models nothing is streaming any more.
AddEventHandler("onResourceStop", function(resource)
    local dropped = false
    for i = #Order, 1, -1 do
        local d = Registry[Order[i]]
        if d and d.resource == resource then
            Registry[Order[i]] = nil
            table.remove(Order, i)
            dropped = true
            print(("[pickle_restaurants] DLC unloaded: %s (%s)"):format(d.name, resource))
        end
    end
    if dropped then applyChange() end
end)

-- Our own boot. Ask everything already running to introduce itself — this is the
-- half of the handshake that covers "the pack started before us / we restarted",
-- which on a live server is the common case.
CreateThread(function()
    while not RestaurantsReady do Wait(200) end
    TriggerEvent("pickle_restaurants:dlcRequest")
end)
