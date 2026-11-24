-- Admin commands for testing the core until the management UI exists.
local function reply(src, message, notifyType)
    Bridge.Notify(src, message, notifyType)
end

local function ready(src)
    if NDM.Ready then return true end
    reply(src, 'NDM_Business is not ready. Check the server console.', 'error')
    return false
end

lib.addCommand('ndmbiz_create', {
    help = 'Create an NDM business venue',
    restricted = 'group.admin',
    params = {
        { name = 'type', type = 'string', help = 'restaurant, club or business' },
        { name = 'job', type = 'string', help = 'Qbox job name' },
        { name = 'label', type = 'longString', help = 'Venue name' },
    },
}, function(source, args)
    if not ready(source) then return end
    local venue, err = NDM.Venue.Create({ type = args.type, job = args.job, label = args.label })
    if not venue then return reply(source, ('Could not create venue: %s'):format(err), 'error') end
    reply(source, ('Created venue #%d: %s (%s, job %s)'):format(venue.id, venue.label, venue.type, venue.job), 'success')
end)

lib.addCommand('ndmbiz_list', {
    help = 'List NDM business venues',
    restricted = 'group.admin',
}, function(source)
    if not ready(source) then return end
    local count = 0
    for id, venue in pairs(NDM.Venue.All()) do
        count = count + 1
        reply(source, ('#%d %s (%s, job %s)'):format(id, venue.label, venue.type, venue.job))
    end
    if count == 0 then reply(source, 'No venues exist yet.') end
end)

lib.addCommand('ndmbiz_balance', {
    help = 'Show a venue society balance',
    restricted = 'group.admin',
    params = {
        { name = 'venue', type = 'number', help = 'Venue ID' },
    },
}, function(source, args)
    if not ready(source) then return end
    local venue = NDM.Venue.Get(args.venue)
    if not venue then return reply(source, 'Venue not found.', 'error') end
    local balance = NDM.Money.Balance(venue.id)
    if not balance then return reply(source, ('No readable society account for job %s.'):format(venue.job), 'error') end
    reply(source, ('%s balance: $%d'):format(venue.label, balance))
end)

lib.addCommand('ndmbiz_perms', {
    help = 'Show what a player can do at a venue',
    restricted = 'group.admin',
    params = {
        { name = 'venue', type = 'number', help = 'Venue ID' },
        { name = 'player', type = 'playerId', help = 'Player server ID' },
    },
}, function(source, args)
    if not ready(source) then return end
    local venue = NDM.Venue.Get(args.venue)
    if not venue then return reply(source, 'Venue not found.', 'error') end

    local permissions, isBoss = NDM.Venue.ResolvePerms(venue.id, args.player)
    if not permissions then return reply(source, 'That player has no access to this venue.') end

    local granted = {}
    for _, permission in ipairs(NDM.Permissions) do
        if permissions[permission] then granted[#granted + 1] = permission end
    end
    reply(source, ('%s%s'):format(isBoss and 'Boss: ' or '', #granted > 0 and table.concat(granted, ', ') or 'none'))
end)
