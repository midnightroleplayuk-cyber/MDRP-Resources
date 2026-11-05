-- /gangadmin opens the staff panel. Access is the ACE 'command.gangadmin', granted to Config.Admin.group.

local ACE = 'command.gangadmin'

local function isStaff(src)
    return src == 0 or IsPlayerAceAllowed(src, ACE)
end

lib.addCommand('gangadmin', {
    help = 'Open the gang staff panel',
    restricted = Config.Admin.group,
}, function(src)
    if src == 0 then return print('[vinewood_gangs] /gangadmin is in-game only') end
    TriggerClientEvent('vinewood_gangs:client:openAdmin', src)
end)

local function admin(name, fn)
    lib.callback.register('vinewood_gangs:admin:' .. name, function(src, ...)
        if not isStaff(src) then
            Logger.Log(src, 'admin_denied', ('blocked admin call %s'):format(name))
            return false, 'no_permission'
        end
        if not Security.Throttle(src, 'admin_' .. name, 200) then return false, 'slow_down' end
        return fn(src, ...)
    end)
end

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

    -- Every area this gang has influence in (and the ones it doesn't, for adding)
    local influence, others = {}, {}
    for zone in pairs(Config.Zones) do
        local amount = Influence.Get(zone, g.id)
        if amount > 0 then
            influence[#influence + 1] = { key = zone, label = Zones.Label(zone), amount = Utils.Round(amount, 1), owned = Influence.GetOwner(zone) == g.id }
        else
            others[#others + 1] = { key = zone, label = Zones.Label(zone) }
        end
    end
    table.sort(influence, function(a, b) return a.amount > b.amount end)
    table.sort(others, function(a, b) return a.label < b.label end)
    summary.influence, summary.otherZones = influence, others
    summary.captureThreshold = Config.Influence.captureThreshold
    summary.clean = Ledger.GetBalance(g.id, 'clean')
    summary.dirty = Ledger.GetBalance(g.id, 'dirty')
    return { gang = summary, members = Gangs.GetMembers(g.id), ranks = Gangs.GetRanks(g.id), maxMembers = Config.Gangs.maxMembers }
end)

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

admin('zones', function()
    local zones = {}
    for key in pairs(Config.Zones) do
        local ownerId = Influence.GetOwner(key)
        local owner = ownerId and Gangs.Get(ownerId)
        local breakdown = {}
        for _, row in ipairs(Influence.GetZoneBreakdown(key)) do
            local g = Gangs.Get(row.gangId)
            if g then breakdown[#breakdown + 1] = { gangId = g.id, label = g.label, colour = g.colour, influence = row.influence } end
        end
        zones[#zones + 1] = {
            key = key, label = Zones.Label(key), drawn = not Zones.IsFromConfig(key),
            value = Config.Zones[key].value or 1.0,
            owner = owner and { label = owner.label, colour = owner.colour } or nil,
            breakdown = breakdown,
        }
    end
    table.sort(zones, function(a, b) return a.label < b.label end)

    local gangs = {}
    for _, g in pairs(Gangs.All()) do gangs[#gangs + 1] = { id = g.id, label = g.label } end
    table.sort(gangs, function(a, b) return a.label:lower() < b.label:lower() end)

    return {
        zones = zones, gangs = gangs,
        captureThreshold = Config.Influence.captureThreshold,
        tickMinutes = Config.Influence.tickMinutes,
    }
end)

admin('addInfluence', function(src, zone, gangId, amount)
    gangId, amount = tonumber(gangId), tonumber(amount)
    local g = gangId and Gangs.Get(gangId)
    if not g or not Config.Zones[zone] or not amount or amount == 0 then return false, 'invalid' end
    -- Divide out the zone multiplier so staff get exactly what they typed
    Influence.Add(zone, g.id, amount / (Config.Zones[zone].value or 1.0))
    Logger.Log(src, 'staff_influence', ('%s %+.1f influence in %s'):format(g.name, amount, zone))
    return true
end)

admin('saveZone', function(src, label, value, points)
    local ok, res, extra = ZoneStore.Save(src, label, value, points)
    if not ok and res == 'zone_overlap' then return false, 'zone_overlap', extra end
    return ok, res
end)
admin('deleteZone', function(src, key) return ZoneStore.Delete(src, tostring(key)) end)

admin('tick', function()
    Influence.Tick()
    Heat.Tick()
    return true
end)

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

admin('heists', function() return Heists.AdminList() end)
admin('heistCreate', function(src, template) return Heists.AdminCreate(src, template) end)
admin('heistSave', function(src, id, data) return Heists.AdminSave(src, id, data) end)
admin('heistDelete', function(src, id) return Heists.AdminDelete(src, id) end)
admin('heistReset', function(src, id) return Heists.AdminReset(src, id) end)
admin('heistStop', function(src, id) return Heists.AdminStop(src, id) end)
admin('heistHere', function(src) return Heists.AdminHere(src) end)
admin('gotoPoint', function(_, p)
    if type(p) ~= 'table' or not tonumber(p.x) then return false, 'invalid' end
    return { x = tonumber(p.x), y = tonumber(p.y), z = tonumber(p.z) + 1.0, w = tonumber(p.w) or 0.0 }
end)

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
