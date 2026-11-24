NDM = NDM or {}
NDM.Resource = GetCurrentResourceName()
NDM.Version = GetResourceMetadata(NDM.Resource, 'version', 0) or '0.0.0'
NDM.Ready = false

NDM.VenueTypes = { restaurant = true, club = true, business = true }
NDM.PlayerAccounts = { cash = true, bank = true }
NDM.MaxMoney = 1000000000

NDM.Permissions = {
    'work',
    'sell',
    'manage_venue',
    'manage_staff',
    'manage_stock',
    'view_finances',
    'manage_finances',
    'security',
}

NDM.AllPermissions = {}
for _, permission in ipairs(NDM.Permissions) do
    NDM.AllPermissions[permission] = true
end

NDM.DefaultRankPermissions = { work = true, sell = true }

NDM.PointTypes = {
    { id = 'management', label = 'Management desk', icon = 'fa-solid fa-briefcase' },
    { id = 'register', label = 'Register', icon = 'fa-solid fa-cash-register' },
    { id = 'stock', label = 'Stock room', icon = 'fa-solid fa-boxes-stacked' },
    { id = 'crafting', label = 'Crafting station', icon = 'fa-solid fa-hammer' },
    { id = 'shop', label = 'Customer shop', icon = 'fa-solid fa-store', public = true },
    { id = 'sale', label = 'For sale sign', icon = 'fa-solid fa-sign-hanging', public = true },
    { id = 'club_entry', label = 'Club entry desk', icon = 'fa-solid fa-ticket', public = true, venueTypes = { club = true } },
    { id = 'bar', label = 'Bar', icon = 'fa-solid fa-martini-glass-citrus', venueTypes = { club = true } },
    { id = 'club_exit', label = 'Throw-out spot', icon = 'fa-solid fa-door-open', noTarget = true, venueTypes = { club = true } },
}

NDM.PointTypeById = {}
for _, pointType in ipairs(NDM.PointTypes) do
    NDM.PointTypeById[pointType.id] = pointType
end

-- Returns a positive whole-dollar amount, or nil when the value is not valid money.
function NDM.WholeMoney(value)
    local number = tonumber(value)
    if not number or number ~= number or number <= 0 or number > NDM.MaxMoney then return nil end
    local whole = math.floor(number + 0.5)
    return whole > 0 and whole or nil
end
