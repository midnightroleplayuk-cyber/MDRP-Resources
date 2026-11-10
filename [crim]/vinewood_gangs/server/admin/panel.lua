-- /gangadmin opens the staff panel. Two levels: Management (everything) and Staff (what management allow).

local OWNER_ACE = 'command.gangadmin'           -- people in Config.Admin.group (existing admins): management
local MANAGEMENT_ACE = 'vinewood_gangs.management'
local STAFF_ACE = 'vinewood_gangs.staff'

-- Every staff action belongs to a group; Staff can only use the groups management tick for them.
local GROUPS = {
    view       = 'See everything (lists, details)',
    teleport   = 'Teleport to places (Go to buttons)',
    reviews    = 'Approve or turn down logos and tag designs',
    tags       = 'Remove tags from walls',
    gangs      = 'Create and disband gangs, manage members, ranks and tiers',
    economy    = 'Change reputation and hex control',
    world      = 'Build in the world: hex turf, safehouses, shops, contract spots, heists',
    events     = 'Run street events, auctions and air drops; cancel deals',
    informants = 'See informants (sensitive)',
    settings   = 'Change settings such as what can be sold on the street',
}
local ACTION_GROUP = {
    listGangs = 'view', gangDetail = 'view', auctions = 'view', director = 'view', agreements = 'view',
    drugItems = 'view', heists = 'view', contractSpots = 'view', enterprises = 'view', safehouses = 'view',
    safehouseShells = 'view', rackets = 'view', pendingDesigns = 'view', pendingLogos = 'view', listTags = 'view',
    onlinePlayers = 'view', searchItems = 'view', airdrops = 'view', hexGang = 'view', hexSettings = 'view', hexMap = 'view', tagTiming = 'view', tagTimingSave = 'tags', tagTimingReset = 'tags',
    hexGive = 'world', hexRemove = 'world', hexMain = 'world', hexControl = 'economy', hexSettingsSave = 'settings', hexResize = 'settings',
    heistLaptops = 'view', heistLaptopAdd = 'world', heistLaptopRemove = 'world', heistLootTables = 'view', heistLootTablesSave = 'world',
    itemCount = 'view', itemGive = 'economy', itemTake = 'economy',
    packages = 'view', packageSave = 'economy', packageDelete = 'economy', packageSend = 'economy', shopGet = 'view', shopSave = 'settings', shopReset = 'settings',
    customContracts = 'view', customContractSave = 'world', customContractDelete = 'world', customContractOffer = 'events',
    contractSettings = 'view', contractSettingsSave = 'settings', contractSettingsReset = 'settings',
    gotoTag = 'teleport', gotoSafehouse = 'teleport', gotoContractSpot = 'teleport', gotoRacketShop = 'teleport', gotoPoint = 'teleport',
    reviewLogo = 'reviews', reviewDesign = 'reviews',
    removeTag = 'tags',
    gangCreation = 'view', gangCreationSave = 'gangs', gangCreationReset = 'gangs',
    createGang = 'gangs', disband = 'gangs', addMember = 'gangs', removeMember = 'gangs', setGrade = 'gangs', setTier = 'gangs',
    adjustReputation = 'economy',
    createSafehouse = 'world', shellPreview = 'world', shellPreviewEnd = 'world',
    evictSafehouse = 'world', deleteSafehouse = 'world', addRacketShop = 'world', deleteRacketShop = 'world', releaseRacket = 'world',
    addContractSpot = 'world', deleteContractSpot = 'world', closeEnterprise = 'world',
    heistCreate = 'world', heistSave = 'world', heistDelete = 'world', heistReset = 'world', heistStop = 'world', heistHere = 'world',
    directorStart = 'events', directorEnd = 'events', auctionOpen = 'events', auctionCancel = 'events', cancelAgreement = 'events',
    blackmarketSettings = 'view', blackmarketSave = 'settings', blackmarketReset = 'settings', blackmarketOpen = 'events',
    airdropCancel = 'events', airdropAdminCall = 'events', airdropSchedules = 'view',
    airdropScheduleSave = 'events', airdropScheduleDelete = 'events', airdropScheduleToggle = 'events', airdropLoot = 'view', airdropLootSave = 'settings', airdropLootReset = 'settings',
    informants = 'informants', informantActive = 'informants',
    drugItemsSave = 'settings', drugItemsReset = 'settings',
    -- anything not listed here (e.g. Staff access itself) is management only
}

local staffUsers = {}  -- staffUsers[license] = { role = 'staff'|'management', name }
local staffPerms = {}  -- staffPerms[group] = true for what Staff can do

local function license(src)
    return src and src > 0 and GetPlayerIdentifierByType(src, 'license') or nil
end

local function loadAccess()
    local users = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'admin_users'")
    local perms = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'admin_staff_perms'")
    staffUsers = users and json.decode(users) or {}
    staffPerms = {}
    local list = perms and json.decode(perms) or Config.Admin.defaultStaffPermissions or {}
    for _, g in ipairs(list) do if GROUPS[g] then staffPerms[g] = true end end
end

local function saveSetting(key, value, src)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { key, json.encode(value), license(src) or 'console' })
end

---'management', 'staff' or nil.
local function roleOf(src)
    if src == 0 then return 'management' end
    if IsPlayerAceAllowed(src, OWNER_ACE) or IsPlayerAceAllowed(src, MANAGEMENT_ACE) then return 'management' end
    local stored = staffUsers[license(src) or '']
    if stored and stored.role == 'management' then return 'management' end
    if IsPlayerAceAllowed(src, STAFF_ACE) or (stored and stored.role == 'staff') then return 'staff' end
    return nil
end

local function can(src, group)
    local role = roleOf(src)
    if role == 'management' then return true end
    if role == 'staff' and group and staffPerms[group] then return true end
    return false
end

local function permsFor(src)
    local role = roleOf(src)
    local out = {}
    for g in pairs(GROUPS) do out[g] = role == 'management' or (role == 'staff' and staffPerms[g] == true) end
    return role, out
end

function AdminAccess_Can(src, group) return can(src, group) end -- for other files

-- The command itself is open; who gets in is decided here (so in-game staff without ACE can use it)
RegisterCommand('gangadmin', function(src)
    if src == 0 then return print('[vinewood_gangs] /gangadmin is in-game only') end
    local role, perms = permsFor(src)
    if not role then return Bridge.Notify(src, locale('no_permission'), 'error') end
    TriggerClientEvent('vinewood_gangs:client:openAdmin', src, { role = role, perms = perms })
end, false)

local function admin(name, fn)
    lib.callback.register('vinewood_gangs:admin:' .. name, function(src, ...)
        local group = ACTION_GROUP[name]
        if not can(src, group) then
            Logger.Log(src, 'admin_denied', ('blocked admin call %s (%s)'):format(name, group or 'management only'))
            return false, roleOf(src) and 'staff_not_allowed' or 'no_permission'
        end
        if not Security.Throttle(src, 'admin_' .. name, 200) then return false, 'slow_down' end
        return fn(src, ...)
    end)
end

-------------------------------------------------------------------------------
-- Staff access (management only)
-------------------------------------------------------------------------------

admin('staffAccess', function()
    local list = {}
    for lic, u in pairs(staffUsers) do list[#list + 1] = { license = lic, role = u.role, name = u.name } end
    table.sort(list, function(a, b) return (a.name or '') < (b.name or '') end)
    local groups = {}
    for key, label in pairs(GROUPS) do groups[#groups + 1] = { key = key, label = label, on = staffPerms[key] == true } end
    table.sort(groups, function(a, b) return a.key < b.key end)
    return { users = list, groups = groups }
end)

admin('staffGrant', function(src, target, role)
    target = tonumber(target)
    if role ~= 'staff' and role ~= 'management' then return false, 'invalid' end
    local lic = target and license(target)
    if not lic then return false, 'player_offline' end
    staffUsers[lic] = { role = role, name = GetPlayerName(target) }
    saveSetting('admin_users', staffUsers, src)
    Logger.Log(src, 'staff_access_granted', ('%s given %s'):format(GetPlayerName(target), role))
    return true
end)

admin('staffRevoke', function(src, lic)
    lic = tostring(lic or '')
    if not staffUsers[lic] then return false, 'invalid' end
    if lic == license(src) then return false, 'staff_not_yourself' end
    Logger.Log(src, 'staff_access_removed', ('removed %s (%s)'):format(staffUsers[lic].name or lic, staffUsers[lic].role))
    staffUsers[lic] = nil
    saveSetting('admin_users', staffUsers, src)
    return true
end)

admin('staffPerms', function(src, list)
    if type(list) ~= 'table' then return false, 'invalid' end
    staffPerms = {}
    local saved = {}
    for _, g in ipairs(list) do if GROUPS[g] then staffPerms[g] = true saved[#saved + 1] = g end end
    saveSetting('admin_staff_perms', saved, src)
    Logger.Log(src, 'staff_permissions_changed', table.concat(saved, ', '))
    return true
end)

CreateThread(function()
    while not MySQL do Wait(100) end
    MySQL.ready(function() loadAccess() end)
end)

local function gangSummary(g)
    local zones = 0
    for zone in pairs(Config.Zones) do
        if Influence.GetOwner(zone) == g.id then zones = zones + 1 end
    end
    return {
        id = g.id, name = g.name, label = g.label, colour = g.colour, logo = Gangs.ApprovedLogo(g.id),
        members = Gangs.MemberCount(g.id), heat = Utils.Round(g.heat, 1), reputation = g.reputation, zones = zones,
    }
end

admin('listGangs', function()
    local list = {}
    for _, g in pairs(Gangs.All()) do list[#list + 1] = gangSummary(g) end
    table.sort(list, function(a, b) return a.label:lower() < b.label:lower() end)
    return list
end)

admin('gangDetail', function(_, gangId)
    local g = Gangs.Get(tonumber(gangId))
    if not g then return false, 'gang_missing' end
    local zones = {}
    for zone in pairs(Config.Zones) do
        if Influence.GetOwner(zone) == g.id then zones[#zones + 1] = Zones.Label(zone) end
    end
    table.sort(zones)
    local summary = gangSummary(g)
    summary.zoneNames = zones
    summary.tier = Progression.Tier(g.id)
    summary.tierLabel = Config.Progression.tiers[summary.tier] and Config.Progression.tiers[summary.tier].label or nil

    summary.clean = Ledger.GetBalance(g.id, 'clean')
    summary.dirty = Ledger.GetBalance(g.id, 'dirty')
    return { gang = summary, members = Gangs.GetMembers(g.id), ranks = Gangs.GetRanks(g.id), maxMembers = Config.Gangs.maxMembers }
end)

admin('gangCreation', function() return Gangs.CreationRules() end)
admin('gangCreationSave', function(src, data) return Gangs.AdminSaveCreationRules(src, data) end)
admin('gangCreationReset', function(src) return Gangs.AdminResetCreationRules(src) end)

admin('createGang', function(src, target, name, label, colour)
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return false, 'invalid_target' end
    return Gangs.Create(target, name, label, colour, { free = true, actor = src })
end)

admin('disband', function(src, gangId)
    return Gangs.Disband(tonumber(gangId), { actor = src, reason = 'staff' })
end)

admin('addMember', function(src, target, gangId, grade)
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return false, 'invalid_target' end
    return Gangs.AdminSetMember(target, tonumber(gangId), grade, src)
end)

admin('setTier', function(src, gangId, tier) return Progression.AdminSetTier(src, gangId, tier) end)
admin('adjustReputation', function(src, gangId, amount)
    gangId, amount = tonumber(gangId), math.floor(tonumber(amount) or 0)
    local g = gangId and Gangs.Get(gangId)
    if not g or amount == 0 then return false, 'invalid' end
    Gangs.AddReputation(g.id, amount) -- never goes below 0; tiers update
    Logger.Log(src, 'staff_reputation', ('%s %+d reputation (now %d)'):format(g.name, amount, g.reputation))
    return true
end)
admin('removeMember', function(src, cid) return Gangs.AdminRemoveMember(tostring(cid), src) end)
admin('setGrade', function(src, cid, grade) return Gangs.AdminSetGrade(tostring(cid), grade, src) end)


admin('auctions', function() return Auctions.AdminList() end)
admin('auctionOpen', function(src)
    local n = Auctions.Open()
    if n == 0 then return false, 'failed' end
    Logger.Log(src, 'staff_auction_open', ('opened %d lots'):format(n))
    return true
end)
admin('auctionCancel', function(src, id) return Auctions.AdminCancel(src, id) end)

admin('informants', function() return Informants.AdminList() end)
admin('informantActive', function(src, cid, active) return Informants.AdminSetActive(src, cid, active == true) end)

admin('director', function() return Director.AdminView() end)
admin('directorStart', function(src, kind)
    local e = Director.Trigger(tostring(kind))
    if not e then return false, 'director_no_target' end
    Logger.Log(src, 'staff_director_start', ('started %s'):format(kind))
    return true
end)
admin('directorEnd', function(src, id)
    Logger.Log(src, 'staff_director_end', ('ended event %s'):format(tostring(id)))
    return Director.End(tonumber(id), 'staff')
end)

admin('agreements', function() return Relations.AdminList() end)
admin('cancelAgreement', function(src, id) return Relations.AdminCancel(src, id) end)

admin('hexGang', function(_, gangId) return Hexes.AdminGang(gangId) end)
admin('hexGive', function(src, gangId, q, r) return Hexes.AdminGive(src, gangId, q, r) end)
admin('hexMap', function() return Hexes.AdminMap() end)
admin('hexRemove', function(src, key) return Hexes.AdminRemove(src, key) end)
admin('hexControl', function(src, key, value) return Hexes.AdminSetControl(src, key, value) end)
admin('hexMain', function(src, key) return Hexes.AdminSetMain(src, key) end)
admin('hexSettings', function() return Hexes.AdminSettings() end)
admin('tagTiming', function() return Graffiti.AdminTiming() end)
admin('tagTimingSave', function(src, data) return Graffiti.AdminSaveTiming(src, data) end)
admin('tagTimingReset', function(src) return Graffiti.AdminResetTiming(src) end)
admin('hexResize', function(src, size, mode) return Hexes.AdminResize(src, size, mode) end)
admin('hexSettingsSave', function(src, data) return Hexes.AdminSaveSettings(src, data) end)

admin('blackmarketSettings', function() return Auctions.AdminSettings() end)
admin('blackmarketSave', function(src, data) return Auctions.AdminSaveSettings(src, data) end)
admin('blackmarketOpen', function(src, on) return Auctions.AdminSetOpen(src, on) end)
admin('blackmarketReset', function(src) return Auctions.AdminResetSettings(src) end)

admin('airdrops', function() return Airdrops.AdminList() end)
admin('airdropCancel', function(src, id) return Airdrops.AdminCancel(src, id) end)
admin('airdropAdminCall', function(src, opts) return Airdrops.AdminCall(src, opts) end)
admin('airdropLoot', function() return Airdrops.AdminLoot() end)
admin('airdropSchedules', function() return Airdrops.AdminSchedules() end)
admin('airdropScheduleSave', function(src, data) return Airdrops.AdminSaveSchedule(src, data) end)
admin('airdropScheduleDelete', function(src, id) return Airdrops.AdminDeleteSchedule(src, id) end)
admin('airdropScheduleToggle', function(src, id, on) return Airdrops.AdminToggleSchedule(src, id, on) end)
admin('airdropLootSave', function(src, data) return Airdrops.AdminSaveLoot(src, data) end)
admin('airdropLootReset', function(src) return Airdrops.AdminResetLoot(src) end)
admin('searchItems', function(_, query) return Bridge.SearchItems(query, 30) end)
admin('drugItems', function() return Drugs.AdminGet() end)
admin('drugItemsSave', function(src, list) return Drugs.AdminSave(src, list) end)
admin('drugItemsReset', function(src) return Drugs.AdminReset(src) end)

admin('heists', function() return Heists.AdminList() end)
admin('heistCreate', function(src, template) return Heists.AdminCreate(src, template) end)
admin('heistSave', function(src, id, data) return Heists.AdminSave(src, id, data) end)
admin('heistDelete', function(src, id) return Heists.AdminDelete(src, id) end)
admin('heistReset', function(src, id) return Heists.AdminReset(src, id) end)
admin('heistStop', function(src, id) return Heists.AdminStop(src, id) end)
-- Items: give items to online players, or take them away
local function itemTarget(target, item, count)
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return nil, 'player_offline' end
    if type(item) ~= 'string' or not Bridge.ItemExists(item) then return nil, 'item_not_found' end
    count = math.floor(tonumber(count) or 1)
    if count < 1 or count > 10000 then return nil, 'invalid_amount' end
    return target, item, count
end
admin('itemCount', function(_, target, item)
    target = tonumber(target)
    if not target or not GetPlayerName(target) or type(item) ~= 'string' then return false, 'invalid' end
    return Bridge.CountItem(target, item)
end)
admin('itemGive', function(src, target, item, count)
    local t, it, n = itemTarget(target, item, count)
    if not t then return false, it end
    if not Bridge.AddItem(t, it, n) then return false, 'item_give_failed' end
    Logger.Log(src, 'staff_item_give', ('gave %d x %s to %s (%d)'):format(n, it, GetPlayerName(t) or '?', t))
    return Bridge.CountItem(t, it)
end)
admin('itemTake', function(src, target, item, count)
    local t, it, n = itemTarget(target, item, count)
    if not t then return false, it end
    local has = Bridge.CountItem(t, it)
    if has < n then return false, 'item_take_not_enough', has end
    if not Bridge.RemoveItem(t, it, n) then return false, 'item_take_failed' end
    Logger.Log(src, 'staff_item_take', ('took %d x %s from %s (%d)'):format(n, it, GetPlayerName(t) or '?', t))
    return Bridge.CountItem(t, it)
end)

-- Item packages: premade kits (a starter kit, say) staff send to a player in one go
local packages, nextPackageId = nil, 1
local function loadPackages()
    if packages then return end
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'item_packages'")
    local ok, data = pcall(json.decode, raw or '')
    if ok and type(data) == 'table' then packages, nextPackageId = data.list or {}, data.nextId or 1 else packages, nextPackageId = {}, 1 end
end
local function savePackages(src)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('item_packages', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ nextId = nextPackageId, list = packages }), Bridge.GetCitizenId(src) or 'console' })
end
admin('packages', function()
    loadPackages()
    local out = {}
    for _, p in ipairs(packages) do
        local items = {}
        for _, it in ipairs(p.items) do items[#items + 1] = { item = it.item, count = it.count, label = Bridge.ItemLabel(it.item), exists = Bridge.ItemExists(it.item) } end
        out[#out + 1] = { id = p.id, name = p.name, cash = p.cash or 0, items = items }
    end
    return out
end)
admin('packageSave', function(src, input)
    loadPackages()
    if type(input) ~= 'table' or type(input.items) ~= 'table' then return false, 'invalid' end
    local name = tostring(input.name or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 40)
    if #name < 2 then return false, 'invalid_label' end
    local items = {}
    for _, it in ipairs(input.items) do
        if type(it) == 'table' and type(it.item) == 'string' then
            if not Bridge.ItemExists(it.item) then return false, 'item_not_found' end
            if #items < 30 then items[#items + 1] = { item = it.item, count = math.floor(math.max(1, math.min(10000, tonumber(it.count) or 1))) } end
        end
    end
    local cash = math.floor(math.max(0, math.min(100000000, tonumber(input.cash) or 0)))
    if #items == 0 and cash == 0 then return false, 'package_empty' end
    local id = tonumber(input.id)
    for _, p in ipairs(packages) do
        if p.id == id then
            p.name, p.items, p.cash = name, items, cash
            savePackages(src)
            return true
        end
    end
    packages[#packages + 1] = { id = nextPackageId, name = name, items = items, cash = cash }
    nextPackageId = nextPackageId + 1
    savePackages(src)
    Logger.Log(src, 'staff_package_saved', ('saved item package "%s"'):format(name))
    return true
end)
admin('packageDelete', function(src, id)
    loadPackages()
    for i, p in ipairs(packages) do
        if p.id == tonumber(id) then table.remove(packages, i) savePackages(src) return true end
    end
    return false, 'invalid'
end)
---Sends everything in a package to a player. Anything that won't go in (full pockets) is reported, the rest still goes.
admin('packageSend', function(src, target, id)
    loadPackages()
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return false, 'player_offline' end
    local pkg
    for _, p in ipairs(packages) do if p.id == tonumber(id) then pkg = p end end
    if not pkg then return false, 'invalid' end
    local given, missed = {}, {}
    for _, it in ipairs(pkg.items) do
        local label = ('%d x %s'):format(it.count, Bridge.ItemLabel(it.item))
        if Bridge.ItemExists(it.item) and Bridge.AddItem(target, it.item, it.count) then given[#given + 1] = label else missed[#missed + 1] = label end
    end
    if (pkg.cash or 0) > 0 then
        local label = Utils.FormatMoney(pkg.cash) .. ' cash'
        if Bridge.AddMoney(target, 'cash', pkg.cash, 'staff-package') then given[#given + 1] = label else missed[#missed + 1] = label end
    end
    Logger.Log(src, 'staff_package_sent', ('sent "%s" to %s (%d): %s%s'):format(pkg.name, GetPlayerName(target) or '?', target,
        table.concat(given, ', '), #missed > 0 and (' | not given: ' .. table.concat(missed, ', ')) or ''))
    if #given > 0 then Bridge.Notify(target, locale('package_received', pkg.name), 'success') end
    return { given = given, missed = missed }
end)

admin('shopGet', function() return Shop.AdminGet() end)
admin('shopSave', function(src, data) return Shop.AdminSave(src, data) end)
admin('shopReset', function(src) return Shop.AdminReset(src) end)

admin('heistLootTables', function() return Heists.AdminLootTables() end)
admin('heistLootTablesSave', function(src, data) return Heists.AdminSaveLootTables(src, data) end)
admin('heistLaptops', function() return Heists.AdminLaptops() end)
admin('heistLaptopAdd', function(src, p, label) return Heists.AdminAddLaptop(src, p, label) end)
admin('heistLaptopRemove', function(src, id) return Heists.AdminRemoveLaptop(src, id) end)
admin('heistHere', function(src) return Heists.AdminHere(src) end)
admin('gotoPoint', function(_, p)
    if type(p) ~= 'table' or not tonumber(p.x) then return false, 'invalid' end
    -- A spot picked on the map has no height: the staff member's game finds the ground there
    if not tonumber(p.z) then return { x = tonumber(p.x), y = tonumber(p.y), z = 0.0, w = tonumber(p.w) or 0.0, ground = true } end
    return { x = tonumber(p.x), y = tonumber(p.y), z = tonumber(p.z) + 1.0, w = tonumber(p.w) or 0.0 }
end)

admin('contractSettings', function() return Contracts.AdminSettings() end)
admin('contractSettingsSave', function(src, data) return Contracts.AdminSaveSettings(src, data) end)
admin('contractSettingsReset', function(src) return Contracts.AdminResetSettings(src) end)
admin('customContracts', function() return CustomContracts.AdminList() end)
admin('customContractSave', function(src, data) return CustomContracts.AdminSave(src, data) end)
admin('customContractDelete', function(src, id) return CustomContracts.AdminDelete(src, id) end)
admin('customContractOffer', function(src, id, gangId) return CustomContracts.AdminOfferNow(src, id, gangId) end)

admin('contractSpots', function() return ContractSpots.List() end)
admin('addContractSpot', function(src, pool, label) return ContractSpots.Add(src, tostring(pool), label) end)
admin('deleteContractSpot', function(src, pool, id) return ContractSpots.Delete(src, tostring(pool), id) end)
admin('gotoContractSpot', function(_, pool, index)
    local c = ContractSpots.Coords(tostring(pool), index)
    if not c then return false, 'invalid' end
    return c
end)

admin('enterprises', function() return Enterprises.AdminList() end)
admin('closeEnterprise', function(src, id) return Enterprises.AdminClose(src, id) end)

admin('safehouses', function() return Safehouses.AdminList() end)
admin('createSafehouse', function(src, data) return Safehouses.AdminCreate(src, data) end)
admin('shellPreview', function(src, model) return Safehouses.AdminShellPreview(src, tostring(model)) end)
admin('shellPreviewEnd', function(src) return Safehouses.AdminShellPreviewEnd(src) end)
admin('safehouseShells', function() return Safehouses.Shells() end)
admin('evictSafehouse', function(src, id) return Safehouses.AdminEvict(src, id) end)
admin('deleteSafehouse', function(src, id) return Safehouses.AdminDelete(src, id) end)
admin('gotoSafehouse', function(_, id)
    local e = Safehouses.Entrance(id)
    if not e then return false, 'invalid' end
    return { x = e.x, y = e.y, z = e.z, w = e.w }
end)

admin('rackets', function() return Rackets.AdminList() end)
admin('releaseRacket', function(src, key) return Rackets.AdminRelease(tostring(key), src) end)
admin('addRacketShop', function(src, label, income) return Rackets.AdminAddShop(src, label, income) end)
admin('deleteRacketShop', function(src, key) return Rackets.AdminDeleteShop(src, key) end)
admin('gotoRacketShop', function(_, key)
    local c = Rackets.ShopCoords(key)
    if not c then return false, 'invalid' end
    return c
end)

admin('pendingDesigns', function() return Graffiti.PendingDesigns() end)
admin('pendingLogos', function() return Gangs.PendingLogos() end)
admin('reviewLogo', function(src, gangId, approve) return Gangs.ReviewLogo(gangId, approve == true, src) end)
admin('reviewDesign', function(src, id, approve) return Graffiti.ReviewDesign(id, approve == true, src) end)
admin('listTags', function() return Graffiti.ListTags(60) end)
admin('removeTag', function(src, id) return Graffiti.AdminRemove(id, src) end)
admin('gotoTag', function(_, id)
    local c = Graffiti.GetTagCoords(id)
    if not c then return false, 'tag_gone' end
    return c
end)

admin('onlinePlayers', function()
    local list = {}
    for _, s in ipairs(GetPlayers()) do
        local id = tonumber(s)
        local cid = Bridge.GetCitizenId(id)
        if cid then
            local m = Gangs.GetMembership(cid)
            local g = m and Gangs.Get(m.gangId)
            list[#list + 1] = { id = id, name = Bridge.GetCharName(id), gang = g and g.label or nil }
        end
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end)
