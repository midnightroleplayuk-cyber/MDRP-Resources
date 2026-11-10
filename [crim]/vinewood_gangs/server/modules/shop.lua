Shop = {}

local cfg = Config.Shop
local TREASURY = { clean = true, dirty = true }

---Is this entry in use on this server (its feature switched on)?
local function available(entry)
    if entry.needs == 'graffiti' then
        return Config.Modules.graffiti and Config.Graffiti.sprayItem ~= false
    elseif entry.needs == 'informants' then
        return Config.Modules.informants and Config.Informants.item ~= false
    elseif entry.needs == 'tabletItem' then
        return Config.Tablet.item ~= false and Config.Tablet.item ~= nil
    end
    return true
end

-- The spray can, phone and tablet follow whatever item names the rest of the config uses
local function itemName(entry)
    if entry.needs == 'graffiti' then return Config.Graffiti.sprayItem end
    if entry.needs == 'informants' then return Config.Informants.item end
    if entry.needs == 'tabletItem' then return Config.Tablet.item end
    return entry.item
end

local function findEntry(item)
    for _, entry in ipairs(cfg.items) do
        if available(entry) and itemName(entry) == item then return entry end
    end
end

---Why this member can't buy the item, if anything.
local function blocker(gang, cid, entry)
    if entry.tier and Progression.Tier(gang.id) < entry.tier then return 'tier_locked' end
    if entry.permission and not Gangs.HasPermission(cid, entry.permission) then return 'no_permission' end
    if TREASURY[entry.pay] and not Gangs.HasPermission(cid, 'treasury_withdraw') then return 'no_permission' end
    return nil
end

function Shop.View(src)
    if not cfg.enabled then return nil, 'shop_closed' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local items = {}
    for _, entry in ipairs(cfg.items) do
        if available(entry) then
            local why = blocker(gang, cid, entry)
            items[#items + 1] = {
                item = itemName(entry), label = entry.label, description = entry.description,
                price = entry.price, pay = entry.pay or 'cash', max = entry.max or 1, image = entry.image,
                blocked = why, tier = why == 'tier_locked' and entry.tier or nil,
            }
        end
    end
    return {
        items = items,
        cash = Bridge.GetMoney(src, 'cash'),
        bank = Bridge.GetMoney(src, 'bank'),
        canTreasury = Gangs.HasPermission(cid, 'treasury_view'),
        dirty = Gangs.HasPermission(cid, 'treasury_view') and Ledger.GetBalance(gang.id, 'dirty') or nil,
        clean = Gangs.HasPermission(cid, 'treasury_view') and Ledger.GetBalance(gang.id, 'clean') or nil,
    }
end

function Shop.Buy(src, item, amount)
    if not cfg.enabled then return false, 'invalid' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    local entry = findEntry(tostring(item))
    if not entry then return false, 'invalid' end
    local why = blocker(gang, cid, entry)
    if why then return false, why end

    amount = math.floor(tonumber(amount) or 0)
    if amount < 1 or amount > (entry.max or 1) then return false, 'invalid_amount' end
    local total = entry.price * amount
    local pay = entry.pay or 'cash'
    local name = itemName(entry)

    -- Take the money first, give the items, and put the money back if they couldn't be carried
    if TREASURY[pay] then
        local ok = Ledger.Transact(gang.id, pay, -total, 'shop', { citizenid = cid, note = ('%dx %s'):format(amount, entry.label) })
        if not ok then return false, 'insufficient_funds' end
        if not Bridge.AddItem(src, name, amount) then
            Ledger.Transact(gang.id, pay, total, 'shop_refund', { citizenid = cid, note = entry.label })
            return false, 'auction_cant_carry'
        end
    else
        if not Bridge.RemoveMoney(src, pay, total, 'gang-shop') then return false, 'insufficient_funds' end
        if not Bridge.AddItem(src, name, amount) then
            Bridge.AddMoney(src, pay, total, 'gang-shop-refund')
            return false, 'auction_cant_carry'
        end
    end

    Logger.Log(src, 'shop_purchase', ('%s bought %dx %s for %d (%s)'):format(cid, amount, name, total, pay))
    return true
end

-------------------------------------------------------------------------------
-- Editing the shop in game (/gangadmin > Shop): config/shop.lua until staff change it
-------------------------------------------------------------------------------

local DEFAULTS = { enabled = cfg.enabled ~= false, items = cfg.items }
local PAY = { cash = true, bank = true, clean = true, dirty = true }

local function publishOpen() GlobalState.vg_shop_open = cfg.enabled ~= false end

function Shop.AdminGet()
    local list = {}
    for _, e in ipairs(cfg.items) do
        local name = itemName(e)
        list[#list + 1] = { item = name, label = e.label, price = e.price, pay = e.pay or 'cash', max = e.max or 1,
            description = e.description or '', image = e.image, tier = e.tier, permission = e.permission, needs = e.needs,
            itemLabel = name and Bridge.ItemLabel(name) or nil, inUse = available(e), exists = name and Bridge.ItemExists(name) or false }
    end
    local perms = {}
    for _, p in ipairs(Config.Permissions or {}) do perms[#perms + 1] = { key = p, label = locale('perm_' .. p) } end
    local tiers = {}
    for i, t in ipairs(Config.Progression.tiers) do tiers[i] = t.label end
    return { enabled = cfg.enabled ~= false, items = list, permissions = perms, tiers = tiers,
        fromConfig = cfg.items == DEFAULTS.items and (cfg.enabled ~= false) == DEFAULTS.enabled }
end

function Shop.AdminSave(src, input)
    if type(input) ~= 'table' or type(input.items) ~= 'table' or #input.items > 60 then return false, 'invalid' end
    local items = {}
    for _, e in ipairs(input.items) do
        if type(e) ~= 'table' or type(e.item) ~= 'string' or not Bridge.ItemExists(e.item) then return false, 'item_not_found' end
        local label = tostring(e.label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 40)
        local desc = tostring(e.description or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 160)
        local entry = {
            item = e.item, label = #label > 0 and label or Bridge.ItemLabel(e.item),
            price = math.floor(math.max(0, math.min(100000000, tonumber(e.price) or 0))),
            pay = PAY[e.pay] and e.pay or 'cash',
            max = math.floor(math.max(1, math.min(1000, tonumber(e.max) or 1))),
            description = #desc > 0 and desc or nil,
            image = type(e.image) == 'string' and e.image:sub(1, 300) or nil,
            tier = tonumber(e.tier) and math.floor(math.max(1, math.min(#Config.Progression.tiers, tonumber(e.tier)))) or nil,
            permission = (type(e.permission) == 'string' and e.permission ~= '') and e.permission or nil,
        }
        -- Keep the link to the spray can / burner phone / tablet item names while it's still that item
        if e.needs and (e.needs == 'graffiti' and e.item == Config.Graffiti.sprayItem
            or e.needs == 'informants' and e.item == Config.Informants.item
            or e.needs == 'tabletItem' and e.item == Config.Tablet.item) then entry.needs = e.needs end
        items[#items + 1] = entry
    end
    cfg.items, cfg.enabled = items, input.enabled ~= false
    publishOpen()
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('tablet_shop', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ enabled = cfg.enabled, items = items }), Bridge.GetCitizenId(src) or 'console' })
    Logger.Log(src, 'staff_shop', ('saved the tablet shop: %d items, %s'):format(#items, cfg.enabled and 'open' or 'closed'))
    return true, Shop.AdminGet()
end

function Shop.AdminReset(src)
    cfg.items, cfg.enabled = DEFAULTS.items, DEFAULTS.enabled
    publishOpen()
    MySQL.update.await("DELETE FROM vg_settings WHERE `key` = 'tablet_shop'")
    return true, Shop.AdminGet()
end

function Shop.Load()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'tablet_shop'")
    local ok, saved = pcall(json.decode, raw or '')
    if ok and type(saved) == 'table' and type(saved.items) == 'table' then
        cfg.items, cfg.enabled = saved.items, saved.enabled ~= false
    end
    publishOpen()
end
