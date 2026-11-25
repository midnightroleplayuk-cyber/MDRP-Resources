NDM.Ownership = {}

local SIGN_REACH = 4.0
local TRANSFER_REACH = 10.0
local Busy = {} -- [venueId] = true while ownership is changing

local function salePrice(venue)
    return math.floor(tonumber(venue.metadata.sale_price) or 0)
end

local function purchasePrice(venue)
    return math.floor(tonumber(venue.metadata.purchase_price) or 0)
end

local function sellValue(venue)
    return math.floor(purchasePrice(venue) * NDM.BusinessConfig.sellScale)
end

-- The owner joins the job at its top grade so staff-only target points appear for them.
local function assignOwner(venue, citizenId)
    local previous = venue.owner_citizenid
    if citizenId then
        local joined, err = Bridge.SetJobGrade(citizenId, venue.job, Bridge.GetTopJobGrade(venue.job))
        if not joined then
            print(('^3[%s] new owner of venue %d could not join job %s: %s^7')
                :format(NDM.Resource, venue.id, venue.job, tostring(err)))
        end
    end
    if previous and previous ~= citizenId then
        Bridge.RemoveFromJob(previous, venue.job)
    end
    venue.owner_citizenid = citizenId
    NDM.Venue.SaveOwnership(venue)
    NDM.Points.RefreshVenue(venue.id)
end

local function signContext(src, pointId)
    local point = NDM.Points.Get(pointId)
    if not point or point.type ~= 'sale' then return nil end
    local venue = NDM.Venue.Get(point.venue_id)
    local ped = GetPlayerPed(src)
    if not venue or ped == 0 then return nil end
    if #(GetEntityCoords(ped) - vector3(point.x, point.y, point.z)) > SIGN_REACH then return nil end
    return venue
end

lib.callback.register('ndm_business:ownership:info', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return nil end
    local venue = signContext(src, payload.point)
    if not venue or venue.owner_citizenid or salePrice(venue) <= 0 then return nil end
    return { label = venue.label, type = venue.type, price = salePrice(venue) }
end)

lib.callback.register('ndm_business:ownership:buy', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return { ok = false, error = 'Try again in a moment.' } end
    local venue = signContext(src, payload.point)
    if not venue then return { ok = false, error = 'You are too far from the sign.' } end
    if venue.owner_citizenid or salePrice(venue) <= 0 then return { ok = false, error = 'This business is not for sale.' } end
    if tonumber(payload.price) ~= salePrice(venue) then return { ok = false, error = 'The price changed. Check it and try again.' } end
    if Busy[venue.id] then return { ok = false, error = 'Someone else is buying this business.' } end

    local citizenId = Bridge.GetCitizenId(src)
    if not citizenId then return { ok = false, error = 'Your character is not loaded.' } end

    Busy[venue.id] = true
    local price = salePrice(venue)
    local charged = NDM.Money.ChargePlayer(src, price, 'bank', ('Bought business: %s'):format(venue.label))
    if not charged then
        Busy[venue.id] = nil
        return { ok = false, error = 'Your bank account cannot cover this.' }
    end

    venue.metadata.sale_price = nil
    venue.metadata.purchase_price = price
    assignOwner(venue, citizenId)
    NDM.Money.Note(venue.id, 'ownership', ('Bought for $%d'):format(price), citizenId)
    Busy[venue.id] = nil
    return { ok = true }
end)

function NDM.Ownership.PanelData(venue)
    return {
        purchasePrice = purchasePrice(venue),
        sellValue = sellValue(venue),
        sellScale = NDM.BusinessConfig.sellScale,
        balance = NDM.Money.Balance(venue.id),
    }
end

function NDM.Ownership.Sell(src, venue)
    local citizenId = Bridge.GetCitizenId(src)
    if not citizenId or venue.owner_citizenid ~= citizenId then return false, 'not_owner' end
    if Busy[venue.id] then return false, 'busy' end
    if NDM.Supply.HasOpenOrder(venue.id) then return false, 'order_still_open' end
    if NDM.Money.Balance(venue.id) ~= 0 then return false, 'balance_not_empty' end

    Busy[venue.id] = true
    local purchase, value = purchasePrice(venue), sellValue(venue)
    if value > 0 and not Bridge.AddMoney(src, 'bank', value, ('Sold business: %s'):format(venue.label)) then
        Busy[venue.id] = nil
        return false, 'payout_refused'
    end

    venue.metadata.purchase_price = nil
    venue.metadata.sale_price = purchase > 0 and purchase or nil
    assignOwner(venue, nil)
    NDM.Money.Note(venue.id, 'ownership', ('Sold back for $%d'):format(value), citizenId)
    Busy[venue.id] = nil
    return true
end

function NDM.Ownership.Transfer(src, venue, target)
    local citizenId = Bridge.GetCitizenId(src)
    target = tonumber(target)
    if not citizenId or venue.owner_citizenid ~= citizenId then return false, 'not_owner' end
    if not target or target == src or not Bridge.GetPlayer(target) then return false, 'invalid_player' end

    local function isClose()
        local pedA, pedB = GetPlayerPed(src), GetPlayerPed(target)
        return pedA ~= 0 and pedB ~= 0 and #(GetEntityCoords(pedA) - GetEntityCoords(pedB)) <= TRANSFER_REACH
    end
    if not isClose() then return false, 'too_far' end
    if Busy[venue.id] then return false, 'busy' end

    Busy[venue.id] = true
    local called, accepted = pcall(lib.callback.await, 'ndm_business:ownership:confirmTransfer', target, {
        venue = venue.label,
        from = Bridge.GetCharacterName(src),
    })
    if not called or accepted ~= true then
        Busy[venue.id] = nil
        return false, 'transfer_declined'
    end

    local targetCitizenId = Bridge.GetCitizenId(target)
    if venue.owner_citizenid ~= citizenId or not targetCitizenId or not isClose() then
        Busy[venue.id] = nil
        return false, 'too_far'
    end

    assignOwner(venue, targetCitizenId)
    NDM.Money.Note(venue.id, 'ownership', 'Ownership transferred', citizenId)
    Busy[venue.id] = nil
    Bridge.Notify(target, ('You now own %s.'):format(venue.label), 'success')
    return true
end

-- Admin setup actions, called from the Admin view of /business.
function NDM.Ownership.AdminSetPrice(venue, price)
    if not venue then return false, 'invalid_venue' end
    if venue.owner_citizenid then return false, 'has_owner' end
    price = tonumber(price)
    if not price or price ~= math.floor(price) or (price ~= 0 and not NDM.WholeMoney(price)) then
        return false, 'invalid_price'
    end

    venue.metadata.sale_price = price ~= 0 and NDM.WholeMoney(price) or nil
    NDM.Venue.SaveOwnership(venue)
    NDM.Points.RefreshVenue(venue.id)
    if price == 0 then return true, ('%s is no longer for sale.'):format(venue.label) end
    return true, ('%s is listed for $%d.'):format(venue.label, salePrice(venue))
end

function NDM.Ownership.AdminSetOwner(venue, target)
    if not venue then return false, 'invalid_venue' end
    local citizenId = target and Bridge.GetCitizenId(target)
    if not citizenId then return false, 'invalid_player' end
    if Busy[venue.id] then return false, 'busy' end

    Busy[venue.id] = true
    venue.metadata.sale_price = nil
    venue.metadata.purchase_price = nil
    assignOwner(venue, citizenId)
    Busy[venue.id] = nil
    Bridge.Notify(target, ('You now own %s.'):format(venue.label), 'success')
    return true, ('%s now has an owner.'):format(venue.label)
end

function NDM.Ownership.IsBusy(venueId)
    return Busy[venueId] == true
end

function NDM.Ownership.AdminClearOwner(venue)
    if not venue then return false, 'invalid_venue' end
    if not venue.owner_citizenid then return false, 'no_owner' end
    if Busy[venue.id] then return false, 'busy' end

    Busy[venue.id] = true
    venue.metadata.purchase_price = nil
    assignOwner(venue, nil)
    Busy[venue.id] = nil
    return true, ('%s no longer has an owner.'):format(venue.label)
end
