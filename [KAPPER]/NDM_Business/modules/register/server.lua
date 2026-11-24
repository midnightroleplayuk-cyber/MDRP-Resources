NDM.Register = {}

local REGISTER_REACH = 3.5
local CUSTOMER_REACH = 6.0
local MAX_LINE_QUANTITY = 100
local MAX_PRICE = 1000000

local Prices = {}   -- [venueId][item] = price
local Charging = {} -- [cashier] = true
local Pending = {}  -- [customer] = true

local ERRORS = {
    busy = 'That customer is already paying for something.',
    cannot_carry = 'The customer cannot carry that order.',
    charge_refused = 'The payment was refused.',
    customer_declined = 'The customer declined the payment.',
    customer_far = 'That customer is too far away.',
    empty_cart = 'Add something to the order first.',
    error = 'Something went wrong. Nothing was charged.',
    insufficient_funds = 'The customer cannot afford that.',
    invalid_account = 'Choose cash or bank.',
    invalid_cart = 'That order is not valid.',
    invalid_customer = 'Choose a customer.',
    no_permission = 'You cannot use this register.',
    not_enough_stock = 'There is not enough stock for that order.',
    not_for_sale = 'An item in that order is no longer for sale.',
    not_found = 'This job has no business account.',
    price_changed = 'The order changed while waiting. Check it and charge again.',
    society_refused = 'The business account refused the payment.',
    too_far = 'You are too far from the register.',
}

local function errorText(key)
    return ERRORS[key] or tostring(key or 'Something went wrong.')
end

local function distanceBetween(a, b)
    local pedA, pedB = GetPlayerPed(a), GetPlayerPed(b)
    if pedA == 0 or pedB == 0 then return math.huge end
    return #(GetEntityCoords(pedA) - GetEntityCoords(pedB))
end

local function contextFor(src, pointId)
    local point = NDM.Points.Get(pointId)
    if not point or (point.type ~= 'register' and point.type ~= 'shop') then return nil, 'no_permission' end
    local venue = NDM.Venue.Get(point.venue_id)
    if not venue then return nil, 'no_permission' end
    if point.type == 'register' and not NDM.Venue.HasPerm(venue.id, src, 'sell') then
        return nil, 'no_permission'
    end

    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - vector3(point.x, point.y, point.z)) > REGISTER_REACH then
        return nil, 'too_far'
    end
    return point, venue
end

local function priceOf(venueId, item)
    return Prices[venueId] and Prices[venueId][item] or 0
end

local function buildData(src, point, venue)
    local items = {}
    for _, entry in ipairs(NDM.Supply.Catalog(venue)) do
        local price = priceOf(venue.id, entry.item)
        if price > 0 then
            items[#items + 1] = {
                item = entry.item,
                label = entry.label,
                price = price,
                available = NDM.Stock.Get(venue.id, entry.item),
            }
        end
    end

    local customers = { { id = src, name = ('%s (you)'):format(Bridge.GetCharacterName(src) or 'You') } }
    if point.type == 'register' then
        for _, id in ipairs(GetPlayers()) do
            local target = tonumber(id)
            if target ~= src and Bridge.GetPlayer(target) and distanceBetween(src, target) <= CUSTOMER_REACH then
                customers[#customers + 1] = { id = target, name = Bridge.GetCharacterName(target) or 'Customer' }
            end
        end
    end

    return {
        point = point.id,
        mode = point.type,
        venue = { id = venue.id, label = venue.label },
        items = items,
        customers = customers,
    }
end

local function resolveCart(venue, cart)
    if type(cart) ~= 'table' then return nil, 'invalid_cart' end
    local lines, total = {}, 0
    for _, entry in ipairs(NDM.Supply.Catalog(venue)) do
        local requested = cart[entry.item]
        if requested ~= nil then
            local quantity = tonumber(requested)
            if not quantity or quantity < 1 or quantity > MAX_LINE_QUANTITY or quantity ~= math.floor(quantity) then
                return nil, 'invalid_cart'
            end
            quantity = math.floor(quantity)
            local price = priceOf(venue.id, entry.item)
            if price <= 0 then return nil, 'not_for_sale' end
            if NDM.Stock.Get(venue.id, entry.item) < quantity then return nil, 'not_enough_stock' end
            lines[#lines + 1] = { item = entry.item, label = entry.label, quantity = quantity, price = price }
            total = total + quantity * price
        end
    end
    if #lines == 0 then return nil, 'empty_cart' end
    if total > NDM.MaxMoney then return nil, 'invalid_cart' end
    return lines, total
end

local function summarize(lines)
    local parts = {}
    for _, line in ipairs(lines) do
        parts[#parts + 1] = ('%dx %s'):format(line.quantity, line.label)
    end
    return table.concat(parts, ', ')
end

local function payCommission(cashier, customer, venue, net)
    if cashier == customer then return end
    local _, _, job = NDM.Venue.ResolvePerms(venue.id, cashier)
    if not job then return end
    local rank = NDM.Venue.RankFor(venue.id, job.grade)
    local commission = math.floor(net * (rank.commission or 0) / 100)
    if commission <= 0 then return end

    local paid = NDM.Money.PayStaff(cashier, venue.id, commission, 'commission', 'Register commission')
    if paid then
        Bridge.Notify(cashier, ('You earned $%d commission.'):format(commission), 'success')
    end
end

NDM.Register.PayCommission = payCommission

-- Stock is taken before the charge, then returned if payment or item delivery fails.
local function completeSale(cashier, customer, venue, lines, total, account)
    for index, line in ipairs(lines) do
        if not Bridge.CanCarryItem(customer, line.item, line.quantity)
            or not NDM.Stock.Remove(venue.id, line.item, line.quantity) then
            for restore = 1, index - 1 do
                NDM.Stock.Add(venue.id, lines[restore].item, lines[restore].quantity)
            end
            return false, 'cannot_carry'
        end
    end

    local charged, err = NDM.Money.Sale(customer, venue.id, total, account, summarize(lines))
    if not charged then
        for _, line in ipairs(lines) do
            NDM.Stock.Add(venue.id, line.item, line.quantity)
        end
        return false, err
    end

    local undelivered = 0
    for _, line in ipairs(lines) do
        if not Bridge.GiveItem(customer, line.item, line.quantity) then
            NDM.Stock.Add(venue.id, line.item, line.quantity)
            undelivered = undelivered + line.quantity * line.price
        end
    end

    if undelivered > 0 then
        local refunded = NDM.Money.Refund(customer, venue.id, undelivered, account, 'Items could not be delivered')
        if not refunded then
            print(('^1[%s] CRITICAL: could not refund $%d to player %d^7'):format(NDM.Resource, undelivered, customer))
        end
    end

    local net = total - undelivered
    if net <= 0 then return false, 'cannot_carry' end
    payCommission(cashier, customer, venue, net)
    return true, net
end

function NDM.Register.Load()
    Prices = {}
    for _, row in ipairs(MySQL.query.await('SELECT * FROM `ndm_business_prices`') or {}) do
        Prices[row.venue_id] = Prices[row.venue_id] or {}
        Prices[row.venue_id][row.item] = row.price
    end
end

function NDM.Register.MenuData(venue)
    local items = {}
    for _, entry in ipairs(NDM.Supply.Catalog(venue)) do
        items[#items + 1] = {
            item = entry.item,
            label = entry.label,
            cost = entry.price,
            crafted = entry.crafted,
            price = priceOf(venue.id, entry.item),
            quantity = NDM.Stock.Get(venue.id, entry.item),
        }
    end
    return items
end

function NDM.Register.SetPrice(venue, item, price)
    local isListed = false
    for _, entry in ipairs(NDM.Supply.Catalog(venue)) do
        if entry.item == item then isListed = true end
    end
    price = tonumber(price)
    if not isListed or not price or price < 0 or price > MAX_PRICE or price ~= math.floor(price) then
        return false, 'invalid_amount'
    end
    price = math.floor(price)

    Prices[venue.id] = Prices[venue.id] or {}
    if price == 0 then
        Prices[venue.id][item] = nil
        MySQL.update.await('DELETE FROM `ndm_business_prices` WHERE `venue_id` = ? AND `item` = ?', { venue.id, item })
    else
        Prices[venue.id][item] = price
        MySQL.insert.await([[
            INSERT INTO `ndm_business_prices` (`venue_id`, `item`, `price`) VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE `price` = VALUES(`price`)
        ]], { venue.id, item, price })
    end
    return true
end

lib.callback.register('ndm_business:register:open', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = errorText('error') } end
    local point, venue = contextFor(src, payload.point)
    if not point then return { ok = false, error = errorText(venue) } end
    return { ok = true, data = buildData(src, point, venue) }
end)

lib.callback.register('ndm_business:register:refresh', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = errorText('error') } end
    local point, venue = contextFor(src, payload.point)
    if not point then return { ok = false, error = errorText(venue) } end
    return { ok = true, data = buildData(src, point, venue) }
end)

lib.callback.register('ndm_business:register:charge', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = errorText('error') } end
    if Charging[src] then return { ok = false, error = errorText('busy') } end

    local point, venue = contextFor(src, payload.point)
    if not point then return { ok = false, error = errorText(venue) } end

    -- A self-service shop always charges the player using it.
    local customer = point.type == 'shop' and src or tonumber(payload.customer)
    local account = payload.account
    if not customer or not Bridge.GetPlayer(customer) then return { ok = false, error = errorText('invalid_customer') } end
    if not NDM.PlayerAccounts[account] then return { ok = false, error = errorText('invalid_account') } end
    if customer ~= src and distanceBetween(src, customer) > CUSTOMER_REACH then
        return { ok = false, error = errorText('customer_far') }
    end
    if Pending[customer] then return { ok = false, error = errorText('busy') } end

    local lines, total = resolveCart(venue, payload.cart)
    if not lines then return { ok = false, error = errorText(total) } end
    if (Bridge.GetMoney(customer, account) or 0) < total then
        return { ok = false, error = errorText('insufficient_funds') }
    end

    Charging[src], Pending[customer] = true, true
    local accepted = customer == src
    if not accepted then
        local called, answer = pcall(lib.callback.await, 'ndm_business:register:confirm', customer, {
            venue = venue.label,
            summary = summarize(lines),
            total = total,
            account = account,
        })
        accepted = called and answer == true
    end

    local ok, err = false, 'customer_declined'
    if accepted then
        -- Prices, stock, distance and access can all change while the prompt is open.
        local currentPoint, currentVenue = contextFor(src, point.id)
        local currentLines, currentTotal = nil, nil
        if not currentPoint then
            err = currentVenue
        elseif not Bridge.GetPlayer(customer) then
            err = 'invalid_customer'
        elseif customer ~= src and distanceBetween(src, customer) > CUSTOMER_REACH then
            err = 'customer_far'
        else
            currentLines, currentTotal = resolveCart(currentVenue, payload.cart)
            if not currentLines then
                err = currentTotal
            elseif currentTotal ~= total then
                err = 'price_changed'
            else
                ok, err = completeSale(src, customer, currentVenue, currentLines, currentTotal, account)
            end
        end
    end
    Charging[src], Pending[customer] = nil, nil

    local data = nil
    local currentPoint, currentVenue = contextFor(src, point.id)
    if currentPoint then data = buildData(src, currentPoint, currentVenue) end
    if not ok then return { ok = false, error = errorText(err), data = data } end

    local net = err
    if customer ~= src then
        Bridge.Notify(customer, ('You paid $%d at %s.'):format(net, venue.label), 'success')
    end
    return { ok = true, message = ('Sale complete: $%d.'):format(net), data = data }
end)

AddEventHandler('playerDropped', function()
    Charging[source] = nil
    Pending[source] = nil
end)
