-- The Admin view of /business. Every action here is admin-only and checked on the server.
local TYPE_LABELS = { restaurant = 'Restaurant', club = 'Club', business = 'Business' }

local ERRORS = {
    busy = 'Ownership is already changing. Try again in a moment.',
    database_error = 'The business could not be saved.',
    depot_in_use = 'That depot still has an open stock order.',
    has_owner = 'Remove the owner before listing it for sale.',
    invalid_depot = 'That depot no longer exists.',
    invalid_job = 'Choose a job.',
    invalid_label = 'Enter a business name.',
    invalid_player = 'That player is not online.',
    invalid_price = 'Enter a whole price, or 0 to remove the listing.',
    invalid_type = 'Choose a business type.',
    invalid_venue = 'That business no longer exists.',
    no_owner = 'That business has no owner.',
    delete_failed = 'The business could not be deleted. Nothing was changed.',
    order_open = 'Finish or cancel its stock order before deleting it.',
}

local function venueRows()
    local rows = {}
    for id, venue in pairs(NDM.Venue.All()) do
        rows[#rows + 1] = {
            id = id,
            label = venue.label,
            type = venue.type,
            typeLabel = TYPE_LABELS[venue.type] or venue.type,
            job = venue.job,
            jobLabel = Bridge.GetJobLabel(venue.job),
            owner = venue.owner_citizenid and (Bridge.GetNameByCitizenId(venue.owner_citizenid) or venue.owner_citizenid) or nil,
            salePrice = math.floor(tonumber(venue.metadata.sale_price) or 0),
            balance = NDM.Money.Balance(venue.id),
        }
    end
    table.sort(rows, function(a, b) return a.label < b.label end)
    return rows
end

local function buildData()
    local types = {}
    for _, id in ipairs({ 'restaurant', 'club', 'business' }) do
        types[#types + 1] = { id = id, label = TYPE_LABELS[id] }
    end

    local players = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        local name = Bridge.GetCharacterName(src)
        if name then players[#players + 1] = { id = src, name = name } end
    end
    table.sort(players, function(a, b) return a.name < b.name end)

    return {
        venues = venueRows(),
        types = types,
        jobs = Bridge.GetJobs(),
        players = players,
        depots = NDM.Supply.DepotList(),
    }
end

-- The panel's venue picker, in the same shape the management panel uses.
local function panelVenues()
    local list = {}
    for id, venue in pairs(NDM.Venue.All()) do
        list[#list + 1] = { id = id, label = venue.label, type = venue.type }
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    return list
end

local function register(name, handler)
    lib.callback.register('ndm_business:admin:' .. name, function(src, payload)
        if not NDM.Ready then return { ok = false, error = 'The business system is still starting.' } end
        if not Bridge.IsAdmin(src) then return { ok = false, error = 'Only admins can do that.' } end
        payload = type(payload) == 'table' and payload or {}

        local ok, result = handler(src, payload)
        local reply = { ok = ok == true, admin = buildData(), venues = panelVenues() }
        if reply.ok then
            reply.message = type(result) == 'string' and result or nil
        else
            reply.error = ERRORS[result] or tostring(result or 'Something went wrong.')
        end
        return reply
    end)
end

register('data', function()
    return true
end)

register('createVenue', function(_, payload)
    local venue, err = NDM.Venue.Create({ type = payload.type, job = payload.job, label = payload.label })
    if not venue then return false, err end
    return true, ('%s created.'):format(venue.label)
end)

register('setSalePrice', function(_, payload)
    return NDM.Ownership.AdminSetPrice(NDM.Venue.Get(payload.venue), payload.price)
end)

register('setOwner', function(_, payload)
    return NDM.Ownership.AdminSetOwner(NDM.Venue.Get(payload.venue), tonumber(payload.target))
end)

register('clearOwner', function(_, payload)
    return NDM.Ownership.AdminClearOwner(NDM.Venue.Get(payload.venue))
end)

register('deleteVenue', function(_, payload)
    local venue = NDM.Venue.Get(payload.venue)
    if not venue then return false, 'invalid_venue' end
    if NDM.Supply.IsBusy(venue.id) then return false, 'order_open' end
    if NDM.Ownership.IsBusy(venue.id) then return false, 'busy' end

    -- Clearing the owner also takes them out of the business job.
    if venue.owner_citizenid then
        local cleared, err = NDM.Ownership.AdminClearOwner(venue)
        if not cleared then return false, err end
    end

    local label = venue.label
    if not NDM.Venue.Delete(venue.id) then return false, 'delete_failed' end
    NDM.Points.ForgetVenue(venue.id)
    NDM.Stock.ForgetVenue(venue.id)
    NDM.Register.ForgetVenue(venue.id)
    NDM.Club.ForgetVenue(venue.id)
    return true, ('%s deleted.'):format(label)
end)

register('removeDepot', function(_, payload)
    return NDM.Supply.RemoveDepot(payload.depot)
end)
