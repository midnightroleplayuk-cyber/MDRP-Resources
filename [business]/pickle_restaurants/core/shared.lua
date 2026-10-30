-- =============================================
--  pickle_restaurants | core/shared.lua
--  Runtime configuration + shared utilities.
--
--  There is intentionally NO config.lua in this resource. Every piece of
--  gameplay configuration (restaurants, props, recipes, menus, employees,
--  tunables) lives in the database and is created/edited in-game. The table
--  below only holds *engine* constants and values auto-detected at runtime
--  (framework / target / inventory). Tunables that an admin may want to
--  change live in the `pickle_restaurant_settings` DB table instead.
-- =============================================

Config = Config or {}

Config.ResourceName     = GetCurrentResourceName()
Config.Debug            = false
Config.Language         = "en"

-- Interaction engine (consumed by core/client.lua)
Config.InteractDistance = 2.0
Config.RenderDistance   = 50.0
Config.NoModelTargeting = false
Config.Marker           = { enabled = false, id = 1, scale = 0.3, color = { 255, 255, 255, 100 } }

-- Target system is auto-detected; no manual toggle required.
Config.UseTarget =
    (GetResourceState("ox_target") == "started") or
    (GetResourceState("qb-target") == "started") or
    (GetResourceState("qtarget")   == "started")

-- Framework bridge settings (consumed by bridge/*). These are sane defaults;
-- if a server uses a non-default dirty-money item or society system the
-- value can be changed here without it being "content" config.
Config.FrameworkSettings = {
    dirtyMoney = "DEFAULT",       -- QB dirty money item, "DEFAULT" => dirty_money
    society    = "qb-management", -- "qb-management" | "qb-banking"
}

-- Admin groups used by the bridge IsPlayerAdmin() checks.
Config.AdminGroups   = { "admin", "superadmin", "god" }
Config.InventoryLimit = false

-- The food picture painted inside an open takeout box (modules/quad), in METRES of
-- the box's own local space: `w` runs side to side, `h` front to back, `dz` is its
-- height above the box's base (raise it if the art z-fights the bed).
--
-- EMBEDDED config, deliberately NOT a `pickle_restaurant_settings` row: it's a
-- property of the shipped box model, tuned once against that mesh — not something a
-- server operator should be adjusting per install. It lives here (shared) rather
-- than in modules/cooking/client.lua so the ADMIN PANEL can read the same numbers
-- read-only: the "Inside the box" cropper locks its frame to this aspect, so what an
-- admin crops is exactly what lands in the box. Three readers, one constant — the
-- drawn quad, the DUI surface's aspect, and that crop frame. TUNE IN-GAME.
Config.BoxQuad = { w = 0.17, h = 0.17, dz = 0.012 }

-- ─── Seat styles (how a placed seat anchor sits a player) ────────────────────
-- A seat anchor (prop_type "seat") stores which of these it is in
-- `metadata.style`. It only decides the POSTURE — a bar stool, a booth bench and a
-- dining chair are different heights and different shapes of sit. The furniture
-- itself is the server's own; a seat anchor is just a point, a facing and one of
-- these.
--
-- Fields:
--   id     stable key stored in the prop row (never rename one in place)
--   label  locale KEY, resolved with _L() at use time (never at load — the locale
--          table isn't populated when this file runs)
--   anim   the looping clip. The placement ghost and the real sit play the SAME
--          clip at the SAME point, which is the entire reason placement is
--          WYSIWYG: what the admin positions is exactly what a player gets.
--   dz     fine height trim in metres. Applied to the ghost AND the sit, so it
--          never desyncs the two. Normally 0 — only reach for it if a style sits
--          consistently high or low on your furniture.
--
-- DELIBERATELY NOT SCENARIOS. `TaskStartScenarioAtPosition` was tried and reverted:
-- a scenario decides for itself where to put the ped, which planted people through
-- the floor, and the natives that report whether a ped is in one are unreliable
-- enough that a repair tick re-tasked forever (an endless sit-down loop). A clip we
-- play at coordinates we set is exact, and exactness is what a placed anchor is for.
--
-- Shared (not client-only) because the placement callback validates the submitted
-- id against this list — the NUI is untrusted. TUNE IN-GAME.
Config.SeatStyles = {
    { id = "chair",    label = "seat.style_chair",    dz = 0.0,
      anim = { dict = "timetable@ron@ig_5_p3",    clip = "ig_5_p3_base" } },
    { id = "bar",      label = "seat.style_bar",      dz = 0.0,
      anim = { dict = "timetable@ron@ig_5_p3",    clip = "ig_5_p3_base" } },
    { id = "bench",    label = "seat.style_bench",    dz = 0.0,
      anim = { dict = "timetable@reunited@ig_10", clip = "base_amanda"  } },
    { id = "armchair", label = "seat.style_armchair", dz = 0.0,
      anim = { dict = "timetable@ron@ig_3_couch", clip = "base"         } },
    { id = "couch",    label = "seat.style_couch",    dz = 0.0,
      anim = { dict = "timetable@maid@couch@",    clip = "base"         } },
}

-- The style a seat with no recorded style uses (every seat placed before styles
-- existed, and the default selection in the placement picker).
Config.DefaultSeatStyle = "chair"

-- Look a style up by id. Returns the DEFAULT style for an unknown/absent id rather
-- than nil, so no call site has to defend against a seat row naming a style that a
-- later version renamed away.
function GetSeatStyle(id)
    local fallback
    for _, s in ipairs(Config.SeatStyles) do
        if s.id == id then return s end
        if s.id == Config.DefaultSeatStyle then fallback = s end
    end
    return fallback or Config.SeatStyles[1]
end

-- ─── Render targets (the ONE place every DUI-painted texture is defined) ──────
-- Every runtime texture we paint onto a prop — food-packaging brands, the kiosk
-- brand/order screen, the customer menu/orders boards, and the staff register POS —
-- is ONE entry here. This is the single editable source of truth for a target's
-- resolution + orientation; the modules that paint them (rendertarget, screens,
-- kiosk, register) all READ this table instead of keeping their own copy, and the
-- NUI is fed the brand-editable ones (BrandRenderTargets → the crop UI) so the panel
-- can never drift from the aspect the game actually renders at.
--
-- Fields:
--   key    stable id (config url/crop key + the debug commands)
--   group  which module paints it: "packaging" | "kiosk" | "screen" | "register"
--   txd    the model's embedded texture dictionary (== model name for these props)
--   txn    the branded texture inside it that we replace
--   w / h  the UPRIGHT DISPLAY aspect — the size/shape as you SEE it on the prop and
--          as you crop it in the panel (so the config value always matches the UI). The
--          actual DUI/texture SURFACE aspect is derived from this + `rot`
--          (RenderTargetSurface): a 90/270 turn swaps w/h for the surface, and the page
--          rotates the content back upright. Edit these as the upright dimensions.
--   rot    0|90|180|270 clockwise turn applied so a correct image lands upright
--   flipx / flipy  mirror to fix a back/upside-down UV (default false)
-- Group-specific extras:
--   packaging/kiosk: debugGap (layout footprint), blackDefault
--                    (unbranded → solid black, not the baked placeholder), configKey
--                    (borrow another target's brand config)
--   screen/register: kind (menu|orders|register), prop_type (placed prop that drives
--                    it), gap (layout footprint)
-- w/h are the UPRIGHT display aspect (see the field notes above). A 90/270 `rot` means
-- the on-prop content is portrait/landscape-swapped from the texture's own pixels; the
-- surface the DUI actually renders at is RenderTargetSurface(t) (w/h swapped for 90/270).
Config.RenderTargets = {
    -- food-packaging brands (modules/rendertarget)
    { key = "pizza_box", group = "packaging", txd = "pickle_pizza_box_02",      txn = "pizza_brand",             w = 1024, h = 1024, rot = 270 },
    { key = "cup",       group = "packaging", txd = "pickle_drink_container_01", txn = "cup_brand",               w = 1792, h = 1024, rot = 90 },
    { key = "tray",      group = "packaging", txd = "pickle_tray_paper_01",      txn = "tray_paper",              w = 1792, h = 1024, rot = 180 },
    { key = "side",      group = "packaging", txd = "pickle_side_container_01",  txn = "side_container_brand_01", w = 2304, h = 1024, rot = 0 },
    { key = "bag",       group = "packaging", txd = "pickle_restaurant_bag_01",  txn = "bag_brand",              w = 1024, h = 1024, rot = 0 },
    -- the self-order kiosk's brand SCREEN (rendered as a brand by rendertarget; the
    -- kiosk ORDER DUI, modules/kiosk, reuses the same aspect). Both kiosk models embed
    -- `kiosk_large_brand`; the floor kiosk borrows the wall one's brand config.
    -- The wall model's UV runs `kiosk_large_brand` a HALF TURN from the floor model's,
    -- so the two can't share one painted surface — each carries its own `rot` and they
    -- share the brand CONFIG via `configKey`.
    { key = "kiosk",        group = "kiosk", txd = "pickle_kiosk_large_01", txn = "kiosk_large_brand", w = 1080, h = 1920, rot = 180, debugGap = 3.5, blackDefault = true },
    { key = "kiosk_ground", group = "kiosk", txd = "pickle_kiosk_large_02", txn = "kiosk_large_brand", w = 1080, h = 1920, rot = 0, debugGap = 3.5, blackDefault = true, configKey = "kiosk" },
    -- customer-facing info boards (modules/screens)
    { key = "menu",   group = "screen", kind = "menu",   prop_type = "menu_screen",   txd = "pickle_screen_menu_01",   txn = "s_m_brand", w = 1920, h = 1080, rot = 90, gap = 3.5 },
    { key = "orders", group = "screen", kind = "orders", prop_type = "orders_screen", txd = "pickle_screen_orders_01", txn = "s_o_brand", w = 1920, h = 1080, rot = 90, gap = 3.5 },
    -- the staff POS register, painted on the counter's screen (modules/register). SQUARE.
    { key = "register", group = "register", kind = "register", prop_type = "counter", txd = "pickle_register_01", txn = "register_brand", w = 1024, h = 1024, rot = 0, gap = 2.0 },
}

-- All render targets in a group, in registry order (the module tables are just a
-- filtered VIEW of Config.RenderTargets — edit geometry there, once).
function RenderTargetsByGroup(...)
    local want = {}
    for _, g in ipairs({ ... }) do want[g] = true end
    local out = {}
    for _, t in ipairs(Config.RenderTargets) do
        if want[t.group] then out[#out + 1] = t end
    end
    return out
end

function RenderTargetByKey(key)
    for _, t in ipairs(Config.RenderTargets) do
        if t.key == key then return t end
    end
    return nil
end

-- The SURFACE aspect the DUI actually renders at (the texture's own pixel dims): a
-- 90/270 turn swaps the upright w/h back. The painting modules (rendertarget, screens,
-- kiosk, register) size their DUIs with this; the page then rotates the content upright.
function RenderTargetSurface(t)
    local rot = (t.rot or 0) % 360
    if rot == 90 or rot == 270 then return t.h, t.w end
    return t.w, t.h
end

-- The brand-editable targets (packaging + kiosk) with their UPRIGHT display aspect (==
-- the config w/h, so the crop UI always matches what's in Config.RenderTargets), for the
-- NUI. A target that borrows another's brand config (`configKey`, e.g. the floor kiosk)
-- is NOT independently editable, so it's skipped — its primary already appears.
function BrandRenderTargets()
    local out = {}
    for _, t in ipairs(Config.RenderTargets) do
        if (t.group == "packaging" or t.group == "kiosk") and not t.configKey then
            out[#out + 1] = { key = t.key, w = t.w, h = t.h }
        end
    end
    return out
end

-- ─── Generic utilities ───────────────────────────────────────────────────────

Templates = {}

function lerp(a, b, t) return a + (b - a) * t end

function v3(coords) return vec3(coords.x, coords.y, coords.z), coords.w end

function GetRandomInt(min, max, exclude)
    for _ = 1, 1000 do
        local int = math.random(min, max)
        if exclude == nil or exclude ~= int then
            return int
        end
    end
end

function debugPrint(...)
    if Config.Debug then
        print("[pickle_restaurants]", ...)
    end
end

-- Detect the active inventory's nui image base path. Ordered by specificity;
-- the first started resource wins. Covers the inventories people actually run;
-- an unknown one returns nil so the UI shows its placeholder instead of a broken
-- image. Add a row here to support another inventory.
local INVENTORY_IMAGE_BASES = {
    { res = "ox_inventory",     base = "nui://ox_inventory/web/images/" },
    { res = "qs-inventory",     base = "nui://qs-inventory/html/images/" },
    { res = "ps-inventory",     base = "nui://ps-inventory/html/images/" },
    { res = "qb-inventory",     base = "nui://qb-inventory/html/images/" },
    { res = "lj-inventory",     base = "nui://lj-inventory/html/images/" },
    { res = "origen_inventory", base = "nui://origen_inventory/html/images/" },
    { res = "codem-inventory",  base = "nui://codem-inventory/html/itemimages/" },
    { res = "core_inventory",   base = "nui://core_inventory/html/img/" },
    { res = "tgiann-inventory", base = "nui://tgiann-inventory/html/images/" },
    { res = "jaksam_inventory", base = "nui://jaksam_inventory/_images/" },
}

function InventoryImageBase()
    for _, e in ipairs(INVENTORY_IMAGE_BASES) do
        if GetResourceState(e.res) == "started" then return e.base end
    end
    return nil
end

-- Build an inventory image nui:// url. `base` is the inventory's web image path
-- (nil => no image, returns nil), `name` the item id, `file` the item's
-- configured image (may be nil/extension-less). Falls back to "<name>.png" — the
-- convention our generated items use.
function InvImageUrl(base, name, file)
    if not base then return nil end
    local f = (type(file) == "string" and file ~= "") and file or (tostring(name) .. ".png")
    if not f:find("%.") then f = f .. ".png" end
    return base .. f
end

function NumberWithCommas(x, noCurrency)
    local left, num = string.match(tostring(x), '^([^%d]*%d)(%d*)')
    if not left then return (not noCurrency and "$" or "") .. tostring(x) end
    return (not noCurrency and "$" or "") .. left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse())
end

function tolower(str) return string.lower(str) end
function toupper(str) return string.upper(str) end

function GetCurrencyString(amount) return NumberWithCommas(amount) end

-- "raw_beef_patty" / "frosting" -> "Raw Beef Patty" / "Frosting". Used as the
-- display fallback when an item isn't in the inventory catalogue (e.g. a finish
-- tool that hasn't been installed yet), so codenames never show up lowercase.
function PrettyItemName(name)
    return (tostring(name):gsub("[_%-]+", " "):gsub("(%a)([%w]*)", function(a, b) return a:upper() .. b:lower() end))
end

function GetItemLabel(name)
    if not name then return "Unknown" end
    if Inventory and Inventory.Items and Inventory.Items[name] then
        return Inventory.Items[name].label
    elseif Inventory and Inventory.Items and Inventory.Items[toupper(name)] then
        return Inventory.Items[toupper(name)].label
    end
    return PrettyItemName(name)
end

function WeightedRandom(weights)
    local total = 0
    for _, w in pairs(weights) do total = total + w end
    if total <= 0 then return nil end
    local roll = math.random() * total
    local cumulative = 0
    for key, w in pairs(weights) do
        cumulative = cumulative + w
        if roll <= cumulative then return key end
    end
    local last
    for key in pairs(weights) do last = key end
    return last
end

-- Rounds to a whole number of dollars; used everywhere money changes hands so
-- commissions never leave fractional cents on a player or a society account.
function RoundMoney(amount)
    return math.floor((tonumber(amount) or 0) + 0.5)
end
