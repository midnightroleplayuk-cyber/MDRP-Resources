NDM.Stock = {}
NDM.Supply = {}

local DEPOT_REACH = 5.0
local STOCK_REACH = 4.0
local VEHICLE_REACH = 6.0
local MAX_PLACE_DISTANCE = 25.0
local BOX_MODEL = `hei_prop_heist_box`

local Stock = {}    -- [venueId][item] = quantity
local Depots = {}   -- [depotId] = row
local Orders = {}   -- [orderId] = open order with its live run state
local Carrying = {} -- [src] = { orderId, from = 'depot' | 'vehicle' }
local Ordering = {} -- [venueId] = true while payment is in flight

local HAUL_ERRORS = {
    already_carrying = 'You are already carrying a box.',
    no_box_here = 'There are no boxes left here.',
    no_permission = 'You do not work for this business.',
    not_carrying = 'You are not carrying a box.',
    order_missing = 'That stock order is no longer active.',
    too_far = 'You are too far away.',
    vehicle_empty = 'This vehicle has no boxes for that order.',
    vehicle_invalid = 'Stand next to the vehicle.',
    wrong_vehicle = 'This order is already being carried in another vehicle.',
}

local function decodeLines(value)
    local ok, result = pcall(json.decode, value or '[]')
    return ok and type(result) == 'table' and result or {}
end

local function trim(value)
    return (tostring(value or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

local function playerNear(src, x, y, z, distance)
    local ped = GetPlayerPed(src)
    if ped == 0 then return false end
    return #(GetEntityCoords(ped) - vector3(x, y, z)) <= distance
end

local function stockPoints(venueId)
    local points = {}
    for _, point in ipairs(NDM.Points.ForVenue(venueId)) do
        if point.type == 'stock' then points[#points + 1] = point end
    end
    return points
end

local function nearStockRoom(src, venueId)
    for _, point in ipairs(stockPoints(venueId)) do
        if playerNear(src, point.x, point.y, point.z, STOCK_REACH) then return true end
    end
    return false
end

local function catalogFor(venue)
    local items = {}
    for _, entry in ipairs(NDM.SupplyConfig.catalog[venue.type] or {}) do
        local label = Bridge.GetItemLabel(entry.item)
        if label then
            items[#items + 1] = { item = entry.item, label = label, price = entry.price, crafted = entry.crafted == true }
        end
    end
    return items
end

NDM.Supply.Catalog = catalogFor

local function catalogEntry(venue, item)
    for _, entry in ipairs(catalogFor(venue)) do
        if entry.item == item then return entry end
    end
    return nil
end

local function openOrderFor(venueId)
    for _, order in pairs(Orders) do
        if order.venue_id == venueId then return order end
    end
    return nil
end

local function carriersOf(orderId)
    local count = 0
    for _, carried in pairs(Carrying) do
        if carried.orderId == orderId then count = count + 1 end
    end
    return count
end

local function orderView(order)
    local venue = NDM.Venue.Get(order.venue_id)
    local depot = Depots[order.depot_id]
    if not venue or not depot then return nil end
    local stock = stockPoints(venue.id)[1]
    return {
        id = order.id,
        venueId = venue.id,
        venueLabel = venue.label,
        depot = { id = depot.id, label = depot.label, x = depot.x, y = depot.y, z = depot.z },
        stock = stock and { x = stock.x, y = stock.y, z = stock.z } or nil,
        boxes = order.boxes,
        atDepot = order.atDepot,
        loaded = order.loaded,
        delivered = order.delivered,
        carried = carriersOf(order.id),
        plate = order.plate,
    }
end

local function isStaffAudience(src, venue)
    local job = Bridge.GetJobInfo(src)
    if job and job.name == venue.job then return true end
    return venue.owner_citizenid ~= nil and Bridge.GetCitizenId(src) == venue.owner_citizenid
end

local function pushOrder(order, removed)
    local venue = NDM.Venue.Get(order.venue_id)
    if not venue then return end
    local view = not removed and orderView(order) or nil
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        if isStaffAudience(src, venue) then
            TriggerClientEvent('ndm_business:supply:order', src, order.id, view)
        end
    end
end

-- Stock -----------------------------------------------------------------------

function NDM.Stock.Get(venueId, item)
    return Stock[venueId] and Stock[venueId][item] or 0
end

function NDM.Stock.Add(venueId, item, quantity)
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 then return false end
    Stock[venueId] = Stock[venueId] or {}
    Stock[venueId][item] = (Stock[venueId][item] or 0) + quantity
    MySQL.insert([[
        INSERT INTO `ndm_business_stock` (`venue_id`, `item`, `quantity`) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE `quantity` = `quantity` + VALUES(`quantity`)
    ]], { venueId, item, quantity })
    return true
end

function NDM.Stock.Remove(venueId, item, quantity)
    quantity = math.floor(tonumber(quantity) or 0)
    if quantity <= 0 or NDM.Stock.Get(venueId, item) < quantity then return false end
    Stock[venueId][item] = Stock[venueId][item] - quantity
    MySQL.update('UPDATE `ndm_business_stock` SET `quantity` = `quantity` - ? WHERE `venue_id` = ? AND `item` = ? AND `quantity` >= ?', {
        quantity, venueId, item, quantity,
    })
    return true
end

function NDM.Supply.HasOpenOrder(venueId)
    return openOrderFor(venueId) ~= nil
end

-- Loading ---------------------------------------------------------------------

function NDM.Supply.Load()
    Stock, Depots, Orders = {}, {}, {}

    for _, row in ipairs(MySQL.query.await('SELECT * FROM `ndm_business_stock`') or {}) do
        Stock[row.venue_id] = Stock[row.venue_id] or {}
        Stock[row.venue_id][row.item] = row.quantity
    end
    for _, row in ipairs(MySQL.query.await('SELECT * FROM `ndm_business_depots`') or {}) do
        Depots[row.id] = row
    end

    -- Vehicles do not survive a restart, so undelivered boxes wait at the depot again.
    for _, row in ipairs(MySQL.query.await("SELECT * FROM `ndm_business_supply_orders` WHERE `status` = 'open'") or {}) do
        row.lines = decodeLines(row.lines)
        row.atDepot = row.boxes - row.delivered
        row.loaded = 0
        Orders[row.id] = row
    end

    for venueType, entries in pairs(NDM.SupplyConfig.catalog) do
        local missing = {}
        for _, entry in ipairs(entries) do
            if not Bridge.GetItemLabel(entry.item) then missing[#missing + 1] = entry.item end
        end
        if #missing > 0 then
            print(('^3[%s] %s supply items missing from ox_inventory: %s^7')
                :format(NDM.Resource, venueType, table.concat(missing, ', ')))
        end
    end
end

-- Panel -----------------------------------------------------------------------

function NDM.Supply.PanelData(venue, src)
    local items = {}
    local order = openOrderFor(venue.id)
    local onOrder = {}
    for _, line in ipairs(order and order.lines or {}) do
        onOrder[line.item] = (onOrder[line.item] or 0) + line.qty
    end

    for _, entry in ipairs(catalogFor(venue)) do
        items[#items + 1] = {
            item = entry.item,
            label = entry.label,
            price = entry.price,
            crafted = entry.crafted,
            quantity = NDM.Stock.Get(venue.id, entry.item),
            onOrder = onOrder[entry.item] or 0,
        }
    end

    local depots = {}
    for _, depot in pairs(Depots) do
        depots[#depots + 1] = { id = depot.id, label = depot.label }
    end
    table.sort(depots, function(a, b) return a.label < b.label end)

    return {
        items = items,
        depots = depots,
        order = order and orderView(order) or nil,
        hasStockRoom = #stockPoints(venue.id) > 0,
        atStockRoom = nearStockRoom(src, venue.id),
        unitsPerBox = NDM.SupplyConfig.unitsPerBox,
        maxBoxes = NDM.SupplyConfig.maxBoxesPerOrder,
        maxStock = NDM.SupplyConfig.maxStock,
    }
end

function NDM.Supply.PlaceOrder(src, venue, depotId, cart)
    if type(cart) ~= 'table' then return false, 'order_empty' end
    if Ordering[venue.id] or openOrderFor(venue.id) then return false, 'order_open' end
    if #stockPoints(venue.id) == 0 then return false, 'no_stock_room' end
    local depot = Depots[tonumber(depotId)]
    if not depot then return false, 'no_depot' end

    local lines, units, cost = {}, 0, 0
    for _, entry in ipairs(catalogFor(venue)) do
        local quantity = tonumber(cart[entry.item]) or 0
        if quantity ~= math.floor(quantity) or quantity < 0 then return false, 'order_invalid' end
        if quantity > 0 then
            if entry.crafted then return false, 'order_invalid' end
            if NDM.Stock.Get(venue.id, entry.item) + quantity > NDM.SupplyConfig.maxStock then
                return false, 'stock_cap'
            end
            lines[#lines + 1] = { item = entry.item, qty = math.floor(quantity) }
            units = units + quantity
            cost = cost + quantity * entry.price
        end
    end
    if units <= 0 then return false, 'order_empty' end

    local boxes = math.ceil(units / NDM.SupplyConfig.unitsPerBox)
    if boxes > NDM.SupplyConfig.maxBoxesPerOrder then return false, 'order_too_big' end

    local citizenId = Bridge.GetCitizenId(src)
    local actor = Bridge.GetCharacterName(src)
    Ordering[venue.id] = true
    local paid, err = NDM.Money.Spend(venue.id, cost, 'supply', ('%d items from %s'):format(units, depot.label), citizenId, actor)
    if not paid then
        Ordering[venue.id] = nil
        return false, err
    end

    local encoded = json.encode(lines)
    local id = MySQL.insert.await([[
        INSERT INTO `ndm_business_supply_orders` (`venue_id`, `depot_id`, `lines`, `boxes`, `cost`, `citizenid`)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], { venue.id, depot.id, encoded, boxes, cost, citizenId })
    Ordering[venue.id] = nil

    if not id then
        if not NDM.Money.Reimburse(venue.id, cost, 'supply_refund', 'Stock order could not be saved', citizenId, actor) then
            print(('^1[%s] CRITICAL: could not refund $%d to venue %d^7'):format(NDM.Resource, cost, venue.id))
        end
        return false, 'error'
    end

    local order = {
        id = id, venue_id = venue.id, depot_id = depot.id, lines = lines, boxes = boxes,
        delivered = 0, cost = cost, status = 'open', citizenid = citizenId,
        atDepot = boxes, loaded = 0,
    }
    Orders[id] = order
    pushOrder(order)
    TriggerClientEvent('ndm_business:supply:waypoint', src, depot.x, depot.y)
    return true
end

function NDM.Supply.CancelOrder(src, venue)
    local order = openOrderFor(venue.id)
    if not order then return false, 'order_missing' end
    if order.delivered > 0 or carriersOf(order.id) > 0 then return false, 'order_in_progress' end

    Orders[order.id] = nil
    local refunded, err = NDM.Money.Reimburse(venue.id, order.cost, 'supply_refund', 'Stock order cancelled',
        Bridge.GetCitizenId(src), Bridge.GetCharacterName(src))
    if not refunded then
        Orders[order.id] = order
        return false, err
    end
    MySQL.update("UPDATE `ndm_business_supply_orders` SET `status` = 'cancelled' WHERE `id` = ?", { order.id })
    pushOrder(order, true)
    return true
end

-- For a lost or destroyed vehicle. Paid boxes go back to the depot instead of vanishing.
function NDM.Supply.ResetRun(venue)
    local order = openOrderFor(venue.id)
    if not order then return false, 'order_missing' end
    order.atDepot = order.atDepot + order.loaded
    order.loaded = 0
    order.plate = nil
    pushOrder(order)
    return true
end

function NDM.Supply.MoveStock(src, venue, item, quantity, direction)
    local entry = catalogEntry(venue, tostring(item or ''))
    quantity = tonumber(quantity)
    if not entry then return false, 'order_invalid' end
    if not quantity or quantity <= 0 or quantity ~= math.floor(quantity) or quantity > NDM.SupplyConfig.maxStock then
        return false, 'invalid_amount'
    end
    quantity = math.floor(quantity)
    if not nearStockRoom(src, venue.id) then return false, 'not_at_stock_room' end

    if direction == 'take' then
        if NDM.Stock.Get(venue.id, entry.item) < quantity then return false, 'not_enough_stock' end
        if not Bridge.CanCarryItem(src, entry.item, quantity) then return false, 'cannot_carry' end
        if not NDM.Stock.Remove(venue.id, entry.item, quantity) then return false, 'not_enough_stock' end
        if not Bridge.GiveItem(src, entry.item, quantity) then
            NDM.Stock.Add(venue.id, entry.item, quantity)
            return false, 'cannot_carry'
        end
        return true
    end

    if NDM.Stock.Get(venue.id, entry.item) + quantity > NDM.SupplyConfig.maxStock then return false, 'stock_cap' end
    if Bridge.GetItemCount(src, entry.item) < quantity then return false, 'not_enough_items' end
    if not Bridge.TakeItem(src, entry.item, quantity) then return false, 'not_enough_items' end
    NDM.Stock.Add(venue.id, entry.item, quantity)
    return true
end

-- Hauling ---------------------------------------------------------------------

local function orderForHauling(src, orderId)
    local order = Orders[tonumber(orderId)]
    if not order then return nil, 'order_missing' end
    if not NDM.Venue.HasPerm(order.venue_id, src, 'work') then return nil, 'no_permission' end
    return order
end

local function vehicleFor(src, netId)
    netId = tonumber(netId)
    if not netId then return nil end
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 then return nil end
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > VEHICLE_REACH then return nil end
    return vehicle, trim(GetVehicleNumberPlateText(vehicle))
end

local function completeOrder(order, src)
    Orders[order.id] = nil
    MySQL.update("UPDATE `ndm_business_supply_orders` SET `status` = 'complete', `delivered` = ? WHERE `id` = ?", {
        order.boxes, order.id,
    })
    for _, line in ipairs(order.lines) do
        NDM.Stock.Add(order.venue_id, line.item, line.qty)
    end
    NDM.Money.Note(order.venue_id, 'supply_in', ('Stock order #%d delivered'):format(order.id), Bridge.GetCitizenId(src))
    pushOrder(order, true)
    Bridge.Notify(src, 'Delivery complete. The stock room has been updated.', 'success')
end

local function returnCarried(src)
    local carried = Carrying[src]
    if not carried then return end
    Carrying[src] = nil
    local order = Orders[carried.orderId]
    if not order then return end
    if carried.from == 'vehicle' and order.plate then
        order.loaded = order.loaded + 1
    else
        order.atDepot = order.atDepot + 1
    end
    pushOrder(order)
end

local function registerHaul(name, handler)
    lib.callback.register('ndm_business:supply:' .. name, function(src, payload)
        if not NDM.Ready then return { ok = false, error = 'The business system is still starting.' } end
        local ok, err = handler(src, type(payload) == 'table' and payload or {})
        if not ok then return { ok = false, error = HAUL_ERRORS[err] or tostring(err) } end
        return { ok = true, carrying = Carrying[src] and Carrying[src].orderId or nil }
    end)
end

registerHaul('take', function(src, payload)
    if Carrying[src] then return false, 'already_carrying' end
    local order, err = orderForHauling(src, payload.orderId)
    if not order then return false, err end
    local depot = Depots[order.depot_id]
    if not depot or not playerNear(src, depot.x, depot.y, depot.z, DEPOT_REACH) then return false, 'too_far' end
    if order.atDepot <= 0 then return false, 'no_box_here' end

    order.atDepot = order.atDepot - 1
    Carrying[src] = { orderId = order.id, from = 'depot' }
    pushOrder(order)
    return true
end)

registerHaul('load', function(src, payload)
    local carried = Carrying[src]
    if not carried then return false, 'not_carrying' end
    local order, err = orderForHauling(src, carried.orderId)
    if not order then return false, err end
    local vehicle, plate = vehicleFor(src, payload.netId)
    if not vehicle then return false, 'vehicle_invalid' end
    if order.plate and order.plate ~= plate then return false, 'wrong_vehicle' end

    order.plate = plate
    order.loaded = order.loaded + 1
    Carrying[src] = nil
    pushOrder(order)
    return true
end)

registerHaul('unload', function(src, payload)
    if Carrying[src] then return false, 'already_carrying' end
    local order, err = orderForHauling(src, payload.orderId)
    if not order then return false, err end
    local vehicle, plate = vehicleFor(src, payload.netId)
    if not vehicle then return false, 'vehicle_invalid' end
    if order.plate ~= plate or order.loaded <= 0 then return false, 'vehicle_empty' end

    order.loaded = order.loaded - 1
    Carrying[src] = { orderId = order.id, from = 'vehicle' }
    pushOrder(order)
    return true
end)

registerHaul('deliver', function(src)
    local carried = Carrying[src]
    if not carried then return false, 'not_carrying' end
    local order, err = orderForHauling(src, carried.orderId)
    if not order then return false, err end
    if not nearStockRoom(src, order.venue_id) then return false, 'too_far' end

    Carrying[src] = nil
    order.delivered = order.delivered + 1
    if order.delivered >= order.boxes then
        completeOrder(order, src)
    else
        MySQL.update('UPDATE `ndm_business_supply_orders` SET `delivered` = ? WHERE `id` = ?', { order.delivered, order.id })
        pushOrder(order)
    end
    return true
end)

registerHaul('putBack', function(src)
    if not Carrying[src] then return false, 'not_carrying' end
    returnCarried(src)
    return true
end)

lib.callback.register('ndm_business:supply:state', function(src)
    if not NDM.Ready then return nil end
    local depots, orders = {}, {}
    for _, depot in pairs(Depots) do
        depots[#depots + 1] = { id = depot.id, label = depot.label, x = depot.x, y = depot.y, z = depot.z }
    end
    for _, order in pairs(Orders) do
        local venue = NDM.Venue.Get(order.venue_id)
        if venue and isStaffAudience(src, venue) then
            local view = orderView(order)
            if view then orders[#orders + 1] = view end
        end
    end
    return { depots = depots, orders = orders, carrying = Carrying[src] and Carrying[src].orderId or nil }
end)

-- Depots ----------------------------------------------------------------------

lib.callback.register('ndm_business:supply:saveDepot', function(src, payload)
    if not NDM.Ready or not Bridge.IsAdmin(src) or type(payload) ~= 'table' then
        return { ok = false, error = 'You cannot place depots.' }
    end
    local x, y, z, heading = tonumber(payload.x), tonumber(payload.y), tonumber(payload.z), tonumber(payload.heading)
    local label = trim(payload.label):sub(1, 40)
    if not x or not y or not z or not heading or label == '' then return { ok = false, error = 'That depot is not valid.' } end
    if not playerNear(src, x, y, z, MAX_PLACE_DISTANCE) then return { ok = false, error = 'You are too far away.' } end

    local id = MySQL.insert.await('INSERT INTO `ndm_business_depots` (`label`, `x`, `y`, `z`, `heading`) VALUES (?, ?, ?, ?, ?)', {
        label, x + 0.0, y + 0.0, z + 0.0, (heading % 360.0) + 0.0,
    })
    if not id then return { ok = false, error = 'The depot could not be saved.' } end
    Depots[id] = { id = id, label = label, x = x + 0.0, y = y + 0.0, z = z + 0.0, heading = heading }
    -- Depots are rare admin edits, and every client needs the location for its target zone.
    TriggerClientEvent('ndm_business:supply:depot', -1, id, { id = id, label = label, x = x + 0.0, y = y + 0.0, z = z + 0.0 })
    return { ok = true, id = id }
end)

lib.addCommand('ndmbiz_depot_add', {
    help = 'Place a supplier depot',
    restricted = 'group.admin',
    params = {
        { name = 'name', type = 'longString', help = 'Depot name' },
    },
}, function(source, args)
    if source == 0 then return print('Run this command in-game.') end
    TriggerClientEvent('ndm_business:supply:placeDepot', source, args.name)
end)

lib.addCommand('ndmbiz_depot_list', {
    help = 'List supplier depots',
    restricted = 'group.admin',
}, function(source)
    local count = 0
    for id, depot in pairs(Depots) do
        count = count + 1
        Bridge.Notify(source, ('#%d %s (%.1f, %.1f, %.1f)'):format(id, depot.label, depot.x, depot.y, depot.z))
    end
    if count == 0 then Bridge.Notify(source, 'No depots exist yet.') end
end)

lib.addCommand('ndmbiz_depot_remove', {
    help = 'Remove a supplier depot',
    restricted = 'group.admin',
    params = {
        { name = 'depot', type = 'number', help = 'Depot ID' },
    },
}, function(source, args)
    if not Depots[args.depot] then return Bridge.Notify(source, 'Depot not found.', 'error') end
    for _, order in pairs(Orders) do
        if order.depot_id == args.depot then
            return Bridge.Notify(source, 'That depot still has an open stock order.', 'error')
        end
    end
    MySQL.update.await('DELETE FROM `ndm_business_depots` WHERE `id` = ?', { args.depot })
    Depots[args.depot] = nil
    TriggerClientEvent('ndm_business:supply:depot', -1, args.depot, nil)
    Bridge.Notify(source, 'Depot removed.', 'success')
end)

-- Only the carrier's own box prop is accepted, so this cannot be aimed at another entity.
RegisterNetEvent('ndm_business:supply:carryProp', function(netId)
    local src = source
    local carried = Carrying[src]
    netId = tonumber(netId)
    if not carried or not netId then return end
    local prop = NetworkGetEntityFromNetworkId(netId)
    if prop and prop ~= 0 and DoesEntityExist(prop) and GetEntityType(prop) == 3
        and GetEntityModel(prop) == BOX_MODEL and NetworkGetEntityOwner(prop) == src then
        carried.prop = prop
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local carried = Carrying[src]
    local prop = carried and carried.prop
    returnCarried(src)
    if prop and DoesEntityExist(prop) and GetEntityModel(prop) == BOX_MODEL then
        DeleteEntity(prop)
    end
end)
