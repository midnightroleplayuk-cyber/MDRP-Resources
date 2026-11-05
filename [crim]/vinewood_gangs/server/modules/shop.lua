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
    if not cfg.enabled then return nil, 'invalid' end
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
