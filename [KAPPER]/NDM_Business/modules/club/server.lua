NDM.Club = {}

local POINT_REACH = 3.5
local CUSTOMER_REACH = 6.0
local TARGET_REACH = 4.0
local MAX_PRICE = 100000
local ACTION_COOLDOWN = 10
local SERVE_COOLDOWN = 3000

local Passes = {}  -- [venueId][citizenId] = { type, expires }
local Bans = {}    -- [venueId][citizenId] = name
local Pending = {} -- [customer] = true
local LastAction = {}
local LastServe = {}

local DrinkById = {}
for _, drink in ipairs(NDM.ClubConfig.drinks) do DrinkById[drink.id] = drink end

local ERRORS = {
    banned = 'You are banned from this club.',
    busy = 'That customer is already paying for something.',
    charge_refused = 'The payment was refused.',
    customer_banned = 'That customer is banned from this club.',
    customer_declined = 'The customer declined the drink.',
    customer_far = 'That customer is too far away.',
    has_pass = 'You already have that pass.',
    in_vehicle = 'They need to be on foot.',
    insufficient_funds = 'There is not enough money for that.',
    invalid_account = 'Choose cash or bank.',
    invalid_customer = 'Choose a customer.',
    invalid_drink = 'That drink is not available.',
    no_exit = 'Place a throw-out spot in Locations first.',
    no_permission = 'You cannot do that here.',
    no_vip = 'VIP passes are not available.',
    not_found = 'This job has no business account.',
    on_cooldown = 'Wait a moment before doing that again.',
    protected = 'Club security cannot act on this person.',
    society_refused = 'The business account refused the payment.',
    target_far = 'That person is too far away.',
    too_far = 'You are too far away.',
}

local function errorText(key)
    return ERRORS[key] or tostring(key or 'Something went wrong.')
end

local function settings(venue)
    local club = venue.metadata.club
    return type(club) == 'table' and club or {}
end

local function entryPrice(venue)
    return math.floor(tonumber(settings(venue).entryPrice) or NDM.ClubConfig.entryPrice)
end

local function vipPrice(venue)
    return math.floor(tonumber(settings(venue).vipPrice) or NDM.ClubConfig.vipPrice)
end

local function baseDrinkPrice(venue, drink)
    local prices = settings(venue).drinks
    local price = type(prices) == 'table' and tonumber(prices[drink.id]) or nil
    return math.floor(price or drink.price)
end

local function currentPass(venueId, citizenId)
    local pass = citizenId and Passes[venueId] and Passes[venueId][citizenId]
    if not pass then return nil end
    if pass.expires <= os.time() then
        Passes[venueId][citizenId] = nil
        MySQL.update('DELETE FROM `ndm_business_club_passes` WHERE `venue_id` = ? AND `citizenid` = ?', { venueId, citizenId })
        return nil
    end
    return pass
end

local function isBanned(venueId, citizenId)
    return citizenId ~= nil and Bans[venueId] ~= nil and Bans[venueId][citizenId] ~= nil
end

local function drinkPriceFor(venue, drink, citizenId)
    local price = baseDrinkPrice(venue, drink)
    local pass = currentPass(venue.id, citizenId)
    if pass and pass.type == 'vip' then
        price = math.floor(price * (100 - NDM.ClubConfig.vipDrinkDiscount) / 100)
    end
    return price
end

local function setPass(venueId, citizenId, passType)
    local expires = os.time() + NDM.ClubConfig.passHours * 3600
    Passes[venueId] = Passes[venueId] or {}
    Passes[venueId][citizenId] = { type = passType, expires = expires }
    MySQL.insert([[
        INSERT INTO `ndm_business_club_passes` (`venue_id`, `citizenid`, `type`, `expires_at`) VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE `type` = VALUES(`type`), `expires_at` = VALUES(`expires_at`)
    ]], { venueId, citizenId, passType, expires })
end

local function clearPass(venueId, citizenId)
    if Passes[venueId] then Passes[venueId][citizenId] = nil end
    MySQL.update('DELETE FROM `ndm_business_club_passes` WHERE `venue_id` = ? AND `citizenid` = ?', { venueId, citizenId })
end

local function distanceBetween(a, b)
    local pedA, pedB = GetPlayerPed(a), GetPlayerPed(b)
    if pedA == 0 or pedB == 0 then return math.huge end
    return #(GetEntityCoords(pedA) - GetEntityCoords(pedB))
end

local function pointContext(src, pointId, pointType)
    local point = NDM.Points.Get(pointId)
    if not point or point.type ~= pointType then return nil, 'no_permission' end
    local venue = NDM.Venue.Get(point.venue_id)
    if not venue or venue.type ~= 'club' then return nil, 'no_permission' end
    if pointType == 'bar' and not NDM.Venue.HasPerm(venue.id, src, 'sell') then return nil, 'no_permission' end
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - vector3(point.x, point.y, point.z)) > POINT_REACH then
        return nil, 'too_far'
    end
    return point, venue
end

-- The club this player can currently act for as security.
local function securityVenue(src)
    local ped = GetPlayerPed(src)
    if ped == 0 then return nil end
    local coords = GetEntityCoords(ped)
    for id, venue in pairs(NDM.Venue.All()) do
        if venue.type == 'club' and NDM.Venue.HasPerm(id, src, 'security') then
            for _, point in ipairs(NDM.Points.ForVenue(id)) do
                if #(coords - vector3(point.x, point.y, point.z)) <= NDM.ClubConfig.securityRange then
                    return venue
                end
            end
        end
    end
    return nil
end

local function isProtected(venue, target)
    local job = Bridge.GetJobInfo(target)
    if job and (NDM.ClubConfig.protectedJobs[job.name] or job.name == venue.job) then return true end
    return venue.owner_citizenid ~= nil and Bridge.GetCitizenId(target) == venue.owner_citizenid
end

local function throwOut(venue, target)
    local exit
    for _, point in ipairs(NDM.Points.ForVenue(venue.id)) do
        if point.type == 'club_exit' then exit = NDM.Points.Get(point.id) break end
    end
    if not exit then return false, 'no_exit' end

    local ped = GetPlayerPed(target)
    if ped == 0 then return false, 'target_far' end
    if GetVehiclePedIsIn(ped, false) ~= 0 then return false, 'in_vehicle' end
    SetEntityCoords(ped, exit.x, exit.y, exit.z, false, false, false, false)
    SetEntityHeading(ped, exit.heading + 0.0)
    return true
end

function NDM.Club.Load()
    Passes, Bans = {}, {}
    MySQL.update.await('DELETE FROM `ndm_business_club_passes` WHERE `expires_at` <= ?', { os.time() })
    for _, row in ipairs(MySQL.query.await('SELECT * FROM `ndm_business_club_passes`') or {}) do
        Passes[row.venue_id] = Passes[row.venue_id] or {}
        Passes[row.venue_id][row.citizenid] = { type = row.type, expires = row.expires_at }
    end
    for _, row in ipairs(MySQL.query.await('SELECT * FROM `ndm_business_club_bans`') or {}) do
        Bans[row.venue_id] = Bans[row.venue_id] or {}
        Bans[row.venue_id][row.citizenid] = row.name
    end
end

function NDM.Club.PanelData(venue)
    local drinks, bans, activePasses = {}, {}, 0
    for _, drink in ipairs(NDM.ClubConfig.drinks) do
        drinks[#drinks + 1] = {
            id = drink.id,
            label = drink.label,
            alcohol = drink.alcohol,
            price = baseDrinkPrice(venue, drink),
        }
    end
    for citizenId, name in pairs(Bans[venue.id] or {}) do
        bans[#bans + 1] = { citizenid = citizenId, name = name ~= '' and name or 'Unknown' }
    end
    table.sort(bans, function(a, b) return a.name < b.name end)
    for citizenId in pairs(Passes[venue.id] or {}) do
        if currentPass(venue.id, citizenId) then activePasses = activePasses + 1 end
    end
    return {
        entryPrice = entryPrice(venue),
        vipPrice = vipPrice(venue),
        vipEnabled = NDM.ClubConfig.vipEnabled,
        vipDiscount = NDM.ClubConfig.vipDrinkDiscount,
        passHours = NDM.ClubConfig.passHours,
        activePasses = activePasses,
        drinks = drinks,
        bans = bans,
    }
end

function NDM.Club.SaveSettings(venue, payload)
    local entry, vip = tonumber(payload.entryPrice), tonumber(payload.vipPrice)
    local function valid(price)
        return price and price >= 0 and price <= MAX_PRICE and price == math.floor(price)
    end
    if not valid(entry) or not valid(vip) or type(payload.drinks) ~= 'table' then return false, 'invalid_amount' end

    local prices = {}
    for _, drink in ipairs(NDM.ClubConfig.drinks) do
        local price = tonumber(payload.drinks[drink.id])
        if not valid(price) then return false, 'invalid_amount' end
        prices[drink.id] = math.floor(price)
    end

    venue.metadata.club = { entryPrice = math.floor(entry), vipPrice = math.floor(vip), drinks = prices }
    NDM.Venue.SaveOwnership(venue)
    return true
end

function NDM.Club.Unban(venue, citizenId)
    if not Bans[venue.id] or Bans[venue.id][citizenId] == nil then return false, 'invalid_player' end
    Bans[venue.id][citizenId] = nil
    MySQL.update.await('DELETE FROM `ndm_business_club_bans` WHERE `venue_id` = ? AND `citizenid` = ?', { venue.id, citizenId })
    return true
end

-- Entry -----------------------------------------------------------------------

lib.callback.register('ndm_business:club:entryInfo', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local point, venue = pointContext(src, payload.point, 'club_entry')
    if not point then return { ok = false, error = errorText(venue) } end
    local citizenId = Bridge.GetCitizenId(src)
    if isBanned(venue.id, citizenId) then return { ok = false, error = errorText('banned') } end

    local pass = currentPass(venue.id, citizenId)
    return {
        ok = true,
        venue = venue.label,
        entryPrice = entryPrice(venue),
        vipPrice = vipPrice(venue),
        vipEnabled = NDM.ClubConfig.vipEnabled,
        passHours = NDM.ClubConfig.passHours,
        pass = pass and pass.type or nil,
        minutesLeft = pass and math.ceil((pass.expires - os.time()) / 60) or nil,
    }
end)

lib.callback.register('ndm_business:club:buyPass', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local point, venue = pointContext(src, payload.point, 'club_entry')
    if not point then return { ok = false, error = errorText(venue) } end

    local citizenId = Bridge.GetCitizenId(src)
    if not citizenId or isBanned(venue.id, citizenId) then return { ok = false, error = errorText('banned') } end
    local passType = payload.type == 'vip' and 'vip' or 'entry'
    if passType == 'vip' and not NDM.ClubConfig.vipEnabled then return { ok = false, error = errorText('no_vip') } end
    if not NDM.PlayerAccounts[payload.account] then return { ok = false, error = errorText('invalid_account') } end

    local pass = currentPass(venue.id, citizenId)
    if pass and (pass.type == 'vip' or pass.type == passType) then return { ok = false, error = errorText('has_pass') } end

    local price = passType == 'vip' and vipPrice(venue) or entryPrice(venue)
    if price > 0 then
        local paid, err = NDM.Money.Sale(src, venue.id, price, payload.account, passType == 'vip' and 'VIP pass' or 'Entry pass')
        if not paid then return { ok = false, error = errorText(err) } end
    end
    setPass(venue.id, citizenId, passType)
    return { ok = true, type = passType, hours = NDM.ClubConfig.passHours }
end)

-- Bar -------------------------------------------------------------------------

lib.callback.register('ndm_business:club:barMenu', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local point, venue = pointContext(src, payload.point, 'bar')
    if not point then return { ok = false, error = errorText(venue) } end

    local drinks = {}
    for _, drink in ipairs(NDM.ClubConfig.drinks) do
        drinks[#drinks + 1] = {
            id = drink.id,
            label = drink.label,
            alcohol = drink.alcohol,
            price = baseDrinkPrice(venue, drink),
        }
    end

    local customers = { { id = src, name = ('%s (you)'):format(Bridge.GetCharacterName(src) or 'You') } }
    for _, id in ipairs(GetPlayers()) do
        local target = tonumber(id)
        if target ~= src and Bridge.GetPlayer(target) and distanceBetween(src, target) <= CUSTOMER_REACH then
            customers[#customers + 1] = { id = target, name = Bridge.GetCharacterName(target) or 'Customer' }
        end
    end
    return { ok = true, venue = venue.label, drinks = drinks, customers = customers }
end)

lib.callback.register('ndm_business:club:serve', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local now = GetGameTimer()
    if LastServe[src] and now - LastServe[src] < SERVE_COOLDOWN then return { ok = false, error = errorText('on_cooldown') } end

    local point, venue = pointContext(src, payload.point, 'bar')
    if not point then return { ok = false, error = errorText(venue) } end
    local drink = DrinkById[payload.drink]
    local customer = tonumber(payload.customer)
    local account = payload.account
    if not drink then return { ok = false, error = errorText('invalid_drink') } end
    if not customer or not Bridge.GetPlayer(customer) then return { ok = false, error = errorText('invalid_customer') } end
    if not NDM.PlayerAccounts[account] then return { ok = false, error = errorText('invalid_account') } end
    if customer ~= src and distanceBetween(src, customer) > CUSTOMER_REACH then return { ok = false, error = errorText('customer_far') } end
    if Pending[customer] then return { ok = false, error = errorText('busy') } end

    local citizenId = Bridge.GetCitizenId(customer)
    if isBanned(venue.id, citizenId) then return { ok = false, error = errorText('customer_banned') } end
    local price = drinkPriceFor(venue, drink, citizenId)
    if price > 0 and (Bridge.GetMoney(customer, account) or 0) < price then
        return { ok = false, error = errorText('insufficient_funds') }
    end

    LastServe[src] = now
    Pending[customer] = true
    local accepted = customer == src
    if not accepted then
        local called, answer = pcall(lib.callback.await, 'ndm_business:register:confirm', customer, {
            venue = venue.label,
            summary = drink.label,
            total = price,
            account = account,
        })
        accepted = called and answer == true
    end
    Pending[customer] = nil
    if not accepted then return { ok = false, error = errorText('customer_declined') } end

    -- The price, access or distance may have changed while the prompt was open.
    local currentPoint, currentVenue = pointContext(src, point.id, 'bar')
    if not currentPoint then return { ok = false, error = errorText(currentVenue) } end
    if not Bridge.GetPlayer(customer) or Bridge.GetCitizenId(customer) ~= citizenId then
        return { ok = false, error = errorText('invalid_customer') }
    end
    if customer ~= src and distanceBetween(src, customer) > CUSTOMER_REACH then return { ok = false, error = errorText('customer_far') } end
    if isBanned(venue.id, citizenId) then return { ok = false, error = errorText('customer_banned') } end
    if drinkPriceFor(currentVenue, drink, citizenId) ~= price then
        return { ok = false, error = 'The price changed. Serve the drink again.' }
    end

    if price > 0 then
        local paid, err = NDM.Money.Sale(customer, venue.id, price, account, ('Bar: %s'):format(drink.label))
        if not paid then return { ok = false, error = errorText(err) } end
        NDM.Register.PayCommission(src, customer, venue, price)
    end

    TriggerClientEvent('ndm_business:club:consume', customer, drink.label, drink.alcohol)
    return { ok = true, message = ('%s served for $%d.'):format(drink.label, price) }
end)

-- Security --------------------------------------------------------------------

lib.callback.register('ndm_business:club:inspect', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local venue = securityVenue(src)
    if not venue then return { ok = false, error = errorText('no_permission') } end
    local target = tonumber(payload.target)
    if not target or target == src or not Bridge.GetPlayer(target) then return { ok = false, error = errorText('invalid_customer') } end
    if distanceBetween(src, target) > TARGET_REACH then return { ok = false, error = errorText('target_far') } end

    local citizenId = Bridge.GetCitizenId(target)
    local pass = currentPass(venue.id, citizenId)
    return {
        ok = true,
        venue = venue.label,
        name = Bridge.GetCharacterName(target) or 'Unknown',
        pass = pass and pass.type or nil,
        banned = isBanned(venue.id, citizenId),
        protected = isProtected(venue, target),
    }
end)

lib.callback.register('ndm_business:club:securityAction', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local venue = securityVenue(src)
    if not venue then return { ok = false, error = errorText('no_permission') } end
    local target = tonumber(payload.target)
    if not target or target == src or not Bridge.GetPlayer(target) then return { ok = false, error = errorText('invalid_customer') } end
    if distanceBetween(src, target) > TARGET_REACH then return { ok = false, error = errorText('target_far') } end
    if isProtected(venue, target) then return { ok = false, error = errorText('protected') } end

    local nowSeconds = os.time()
    if LastAction[target] and nowSeconds - LastAction[target] < ACTION_COOLDOWN then
        return { ok = false, error = errorText('on_cooldown') }
    end

    local citizenId = Bridge.GetCitizenId(target)
    local action = payload.action
    if action == 'revoke' then
        clearPass(venue.id, citizenId)
        Bridge.Notify(target, ('Your pass for %s was revoked.'):format(venue.label), 'error')
    elseif action == 'throw' then
        local thrown, err = throwOut(venue, target)
        if not thrown then return { ok = false, error = errorText(err) } end
        clearPass(venue.id, citizenId)
        Bridge.Notify(target, ('You were thrown out of %s.'):format(venue.label), 'error')
    elseif action == 'ban' then
        local name = (Bridge.GetCharacterName(target) or ''):sub(1, 100)
        Bans[venue.id] = Bans[venue.id] or {}
        Bans[venue.id][citizenId] = name
        MySQL.insert.await([[
            INSERT INTO `ndm_business_club_bans` (`venue_id`, `citizenid`, `name`) VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE `name` = VALUES(`name`)
        ]], { venue.id, citizenId, name })
        clearPass(venue.id, citizenId)
        throwOut(venue, target)
        Bridge.Notify(target, ('You were banned from %s.'):format(venue.label), 'error')
    else
        return { ok = false, error = errorText('no_permission') }
    end

    LastAction[target] = nowSeconds
    NDM.Money.Note(venue.id, 'security', ('%s: %s'):format(action, Bridge.GetCharacterName(target) or 'Unknown'), Bridge.GetCitizenId(src))
    return { ok = true }
end)

AddEventHandler('playerDropped', function()
    Pending[source] = nil
    LastAction[source] = nil
    LastServe[source] = nil
end)
