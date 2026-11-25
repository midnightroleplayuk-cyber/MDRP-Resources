local HIRE_RANGE = 10.0
local PendingOffers = {}

local ERRORS = {
    already_employed = 'That player already works here.',
    busy = 'Another payment is still processing.',
    cannot_manage = 'You cannot manage that employee.',
    charge_refused = 'The payment was refused.',
    error = 'Something went wrong. Nothing was charged.',
    insufficient_funds = 'There are not enough funds.',
    invalid_account = 'Choose cash or bank.',
    invalid_amount = 'Enter a valid amount.',
    invalid_grade = 'You cannot assign that rank.',
    invalid_player = 'That player is not available.',
    invalid_point = 'That location is not valid.',
    too_many_points = 'This venue has reached its location limit.',
    cannot_carry = 'You cannot carry that much.',
    no_depot = 'Choose a supplier depot.',
    no_stock_room = 'Place a stock room in Locations first.',
    not_at_stock_room = 'You must be at the stock room to move stock.',
    not_enough_items = 'You do not have that many.',
    not_enough_stock = 'There is not enough stock.',
    order_empty = 'Add something to the order first.',
    order_in_progress = 'Boxes are already being moved, so this order cannot be cancelled.',
    order_invalid = 'That order is not valid.',
    order_missing = 'There is no active stock order.',
    order_open = 'Finish the current stock order first.',
    order_too_big = 'That order is too large for one trip.',
    stock_cap = 'That would exceed the stock limit.',
    balance_not_empty = 'Withdraw all business funds before selling.',
    not_owner = 'Only the owner can do that.',
    order_still_open = 'Finish or cancel the stock order before selling.',
    transfer_declined = 'The player declined the transfer.',
    invalid_venue = 'That venue no longer exists.',
    no_funds = 'The business account cannot cover that.',
    no_permission = 'You do not have permission to do that.',
    not_found = 'This job has no business account.',
    not_ready = 'The business system is still starting.',
    offer_declined = 'The player declined the job offer.',
    offer_pending = 'That player already has a job offer open.',
    payout_refused = 'The payout was refused and the business account was restored.',
    society_refused = 'The business account refused the transfer.',
    too_far = 'That player is too far away.',
}

local function errorText(key)
    return ERRORS[key] or tostring(key or 'Something went wrong.')
end

local function actorFor(venueId, src)
    local permissions, isBoss, job = NDM.Venue.ResolvePerms(venueId, src)
    if not permissions then return nil end
    return {
        permissions = permissions,
        isBoss = isBoss == true,
        level = job and job.grade or math.huge,
        citizenid = Bridge.GetCitizenId(src),
    }
end

local function canOpen(actor)
    if not actor then return false end
    local permissions = actor.permissions
    return actor.isBoss
        or permissions.manage_staff == true
        or permissions.manage_venue == true
        or permissions.manage_stock == true
        or permissions.view_finances == true
        or permissions.manage_finances == true
end

local function gradeFor(job, grade)
    grade = tonumber(grade)
    for _, jobGrade in ipairs(Bridge.GetJobGrades(job)) do
        if jobGrade.grade == grade then return jobGrade end
    end
    return nil
end

local function canAssign(actor, job, grade)
    if actor.permissions.manage_staff ~= true then return false end
    local jobGrade = gradeFor(job, grade)
    if not jobGrade then return false end
    if actor.level ~= math.huge and jobGrade.grade >= actor.level then return false end
    if jobGrade.isBoss and not actor.isBoss then return false end
    return true
end

local function canManageMember(actor, member)
    if actor.permissions.manage_staff ~= true then return false end
    if member.citizenid == actor.citizenid then return false end
    return actor.level == math.huge or member.grade < actor.level
end

local function canEditRank(actor, grade)
    return actor.isBoss and (actor.level == math.huge or grade < actor.level)
end

local function findMember(job, citizenId)
    for _, member in ipairs(Bridge.GetJobMembers(job)) do
        if member.citizenid == citizenId then return member end
    end
    return nil
end

local function playersAreClose(a, b)
    local pedA, pedB = GetPlayerPed(a), GetPlayerPed(b)
    if pedA == 0 or pedB == 0 then return false end
    return #(GetEntityCoords(pedA) - GetEntityCoords(pedB)) <= HIRE_RANGE
end

local function buildStaff(venue, actor)
    local grades = Bridge.GetJobGrades(venue.job)
    local assignable = {}
    for _, grade in ipairs(grades) do
        if canAssign(actor, venue.job, grade.grade) then
            assignable[#assignable + 1] = { grade = grade.grade, label = grade.label }
        end
    end

    local labels = {}
    for _, grade in ipairs(grades) do labels[grade.grade] = grade.label end

    local members = {}
    for _, member in ipairs(Bridge.GetJobMembers(venue.job)) do
        members[#members + 1] = {
            citizenid = member.citizenid,
            name = member.name,
            online = member.online,
            grade = member.grade,
            gradeLabel = labels[member.grade] or ('Grade %d'):format(member.grade),
            canManage = canManageMember(actor, member),
        }
    end
    return { members = members, assignable = assignable }
end

local function buildRanks(venue, actor)
    local ranks = {}
    for _, grade in ipairs(Bridge.GetJobGrades(venue.job)) do
        local rank = NDM.Venue.RankFor(venue.id, grade.grade)
        ranks[#ranks + 1] = {
            grade = grade.grade,
            label = grade.label,
            boss = grade.isBoss,
            permissions = rank.permissions,
            commission = rank.commission,
            salary = rank.salary,
            canEdit = canEditRank(actor, grade.grade) and not grade.isBoss,
        }
    end
    return ranks
end

local function buildFinance(venue, actor)
    local rows = MySQL.query.await([[
        SELECT `kind`, `amount`, `description`, UNIX_TIMESTAMP(`created_at`) AS `time`
        FROM `ndm_business_ledger`
        WHERE `venue_id` = ?
        ORDER BY `id` DESC
        LIMIT 50
    ]], { venue.id }) or {}
    return {
        balance = NDM.Money.Balance(venue.id),
        canMove = actor.permissions.manage_finances == true,
        ledger = rows,
    }
end

local function buildData(venueId, src)
    local venue = NDM.Venue.Get(venueId)
    local actor = venue and actorFor(venue.id, src)
    if not canOpen(actor) then return nil end

    local data = {
        venue = {
            id = venue.id,
            label = venue.label,
            type = venue.type,
            job = venue.job,
            jobLabel = Bridge.GetJobLabel(venue.job),
        },
        me = { isBoss = actor.isBoss },
        permissions = NDM.Permissions,
    }
    if actor.permissions.manage_staff then data.staff = buildStaff(venue, actor) end
    if actor.isBoss then data.ranks = buildRanks(venue, actor) end
    if actor.permissions.view_finances or actor.permissions.manage_finances then
        data.finance = buildFinance(venue, actor)
    end
    -- Only admins create and move locations. Owners and staff run the venue once it is built.
    if Bridge.IsAdmin(src) then
        data.points = NDM.Points.ForVenue(venue.id)
        data.pointTypes = {}
        for _, pointType in ipairs(NDM.PointTypes) do
            if not pointType.venueTypes or pointType.venueTypes[venue.type] then
                data.pointTypes[#data.pointTypes + 1] = {
                    id = pointType.id,
                    label = pointType.label,
                    props = NDM.PropOptions[pointType.id] or {},
                }
            end
        end
    end
    if actor.permissions.manage_venue and venue.type == 'club' then
        data.club = NDM.Club.PanelData(venue)
    end
    if actor.permissions.manage_stock then
        data.stock = NDM.Supply.PanelData(venue, src)
    end
    if actor.permissions.manage_venue then
        data.menu = NDM.Register.MenuData(venue)
    end
    if actor.citizenid and venue.owner_citizenid == actor.citizenid then
        data.ownership = NDM.Ownership.PanelData(venue)
    end
    return data
end

local function venueList(src)
    local list = {}
    for id, venue in pairs(NDM.Venue.All()) do
        if canOpen(actorFor(id, src)) then
            list[#list + 1] = { id = id, label = venue.label, type = venue.type }
        end
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    return list
end

-- Every mutating action re-resolves permissions and returns a fresh panel payload.
local function registerAction(name, handler)
    lib.callback.register('ndm_business:mgmt:' .. name, function(src, payload)
        if not NDM.Ready then return { ok = false, error = errorText('not_ready') } end
        payload = type(payload) == 'table' and payload or {}

        local venue = NDM.Venue.Get(payload.venue)
        if not venue then return { ok = false, error = errorText('invalid_venue') } end
        local actor = actorFor(venue.id, src)
        if not canOpen(actor) then return { ok = false, error = errorText('no_permission') } end

        local ok, err = handler(src, venue, actor, payload)
        if not ok then
            return { ok = false, error = errorText(err), data = buildData(venue.id, src) }
        end
        return { ok = true, message = type(err) == 'string' and err or nil, data = buildData(venue.id, src) }
    end)
end

lib.callback.register('ndm_business:mgmt:open', function(src, payload)
    if not NDM.Ready then return { ok = false, error = errorText('not_ready') } end
    local venues = venueList(src)
    local isAdmin = Bridge.IsAdmin(src)
    if #venues == 0 then
        -- Admins can open the panel before any business exists, so they can create one.
        if isAdmin then return { ok = true, venues = {}, admin = true } end
        return { ok = false, error = 'You do not manage a business.' }
    end

    local selected = venues[1].id
    local requested = type(payload) == 'table' and tonumber(payload.venue) or nil
    if requested then
        local allowed = false
        for _, venue in ipairs(venues) do
            if venue.id == requested then allowed = true end
        end
        if not allowed then return { ok = false, error = errorText('no_permission') } end
        selected = requested
    end
    return { ok = true, venues = venues, data = buildData(selected, src), admin = isAdmin }
end)

registerAction('getData', function()
    return true
end)

lib.callback.register('ndm_business:mgmt:nearbyPlayers', function(src, payload)
    if not NDM.Ready or type(payload) ~= 'table' then return {} end
    local venue = NDM.Venue.Get(payload.venue)
    local actor = venue and actorFor(venue.id, src)
    if not actor or actor.permissions.manage_staff ~= true then return {} end

    local nearby = {}
    for _, id in ipairs(GetPlayers()) do
        local target = tonumber(id)
        if target ~= src and playersAreClose(src, target) then
            local player = Bridge.GetPlayer(target)
            local jobs = player and player.PlayerData.jobs or {}
            if player and jobs[venue.job] == nil then
                nearby[#nearby + 1] = { id = target, name = Bridge.GetCharacterName(target) }
            end
        end
    end
    return nearby
end)

registerAction('hire', function(src, venue, actor, payload)
    local target, grade = tonumber(payload.target), tonumber(payload.grade)
    if not target or target == src then return false, 'invalid_player' end
    if not canAssign(actor, venue.job, grade) then return false, 'invalid_grade' end

    local player = Bridge.GetPlayer(target)
    if not player then return false, 'invalid_player' end
    if not playersAreClose(src, target) then return false, 'too_far' end
    if player.PlayerData.jobs and player.PlayerData.jobs[venue.job] ~= nil then return false, 'already_employed' end
    if PendingOffers[target] then return false, 'offer_pending' end

    PendingOffers[target] = true
    local called, accepted = pcall(lib.callback.await, 'ndm_business:mgmt:confirmHire', target, {
        venue = venue.label,
        grade = gradeFor(venue.job, grade).label,
    })
    PendingOffers[target] = nil
    if not called or accepted ~= true then return false, 'offer_declined' end

    -- The world can change while the prompt is open, so every condition is checked again.
    local current = actorFor(venue.id, src)
    if not current or not canAssign(current, venue.job, grade) then return false, 'no_permission' end
    player = Bridge.GetPlayer(target)
    if not player then return false, 'invalid_player' end
    if not playersAreClose(src, target) then return false, 'too_far' end
    if player.PlayerData.jobs and player.PlayerData.jobs[venue.job] ~= nil then return false, 'already_employed' end

    local hired, err = Bridge.HireToJob(player.PlayerData.citizenid, venue.job, grade)
    if not hired then return false, err end
    Bridge.Notify(target, ('You now work at %s.'):format(venue.label), 'success')
    return true, 'Employee hired.'
end)

registerAction('setGrade', function(_, venue, actor, payload)
    local citizenId, grade = tostring(payload.citizenid or ''), tonumber(payload.grade)
    local member = findMember(venue.job, citizenId)
    if not member or not canManageMember(actor, member) then return false, 'cannot_manage' end
    if not canAssign(actor, venue.job, grade) then return false, 'invalid_grade' end
    if member.grade == grade then return true end

    local updated, err = Bridge.SetJobGrade(citizenId, venue.job, grade)
    if not updated then return false, err end
    return true, 'Rank updated.'
end)

registerAction('fire', function(_, venue, actor, payload)
    local citizenId = tostring(payload.citizenid or '')
    local member = findMember(venue.job, citizenId)
    if not member or not canManageMember(actor, member) then return false, 'cannot_manage' end

    local removed, err = Bridge.RemoveFromJob(citizenId, venue.job)
    if not removed then return false, err end
    return true, 'Employee removed.'
end)

registerAction('setRank', function(_, venue, actor, payload)
    local grade = tonumber(payload.grade)
    local jobGrade = gradeFor(venue.job, grade)
    if not jobGrade or jobGrade.isBoss or not canEditRank(actor, grade) then return false, 'no_permission' end

    local saved = NDM.Venue.SetRank(venue.id, grade, {
        permissions = payload.permissions,
        commission = payload.commission,
        salary = payload.salary,
    })
    if not saved then return false, 'error' end
    return true, 'Rank saved.'
end)

registerAction('deposit', function(src, venue, _, payload)
    local moved, err = NDM.Money.Deposit(src, venue.id, payload.amount, payload.account)
    if not moved then return false, err end
    return true, 'Deposit complete.'
end)

registerAction('withdraw', function(src, venue, _, payload)
    local moved, err = NDM.Money.Withdraw(src, venue.id, payload.amount, payload.account)
    if not moved then return false, err end
    return true, 'Withdrawal complete.'
end)

registerAction('savePoint', function(src, venue, _, payload)
    if not Bridge.IsAdmin(src) then return false, 'no_permission' end
    local saved, err = NDM.Points.Save(src, venue.id, payload)
    if not saved then return false, err end
    return true, 'Location saved.'
end)

registerAction('deletePoint', function(src, venue, _, payload)
    if not Bridge.IsAdmin(src) then return false, 'no_permission' end
    local removed, err = NDM.Points.Remove(venue.id, payload.pointId)
    if not removed then return false, err end
    return true, 'Location removed.'
end)

registerAction('stockOrder', function(src, venue, actor, payload)
    if actor.permissions.manage_stock ~= true then return false, 'no_permission' end
    local placed, err = NDM.Supply.PlaceOrder(src, venue, payload.depot, payload.cart)
    if not placed then return false, err end
    return true, 'Order paid. Collect it from the depot on your map.'
end)

registerAction('stockCancel', function(src, venue, actor)
    if actor.permissions.manage_stock ~= true then return false, 'no_permission' end
    local cancelled, err = NDM.Supply.CancelOrder(src, venue)
    if not cancelled then return false, err end
    return true, 'Order cancelled and refunded.'
end)

registerAction('stockReset', function(_, venue, actor)
    if actor.permissions.manage_stock ~= true then return false, 'no_permission' end
    local reset, err = NDM.Supply.ResetRun(venue)
    if not reset then return false, err end
    return true, 'Loaded boxes returned to the depot.'
end)

registerAction('clubSettings', function(_, venue, actor, payload)
    if venue.type ~= 'club' or actor.permissions.manage_venue ~= true then return false, 'no_permission' end
    local saved, err = NDM.Club.SaveSettings(venue, payload)
    if not saved then return false, err end
    return true, 'Club settings saved.'
end)

registerAction('clubUnban', function(_, venue, actor, payload)
    if venue.type ~= 'club' or actor.permissions.manage_venue ~= true then return false, 'no_permission' end
    local removed, err = NDM.Club.Unban(venue, tostring(payload.citizenid or ''))
    if not removed then return false, err end
    return true, 'Ban removed.'
end)

registerAction('ownerSell', function(src, venue)
    local sold, err = NDM.Ownership.Sell(src, venue)
    if not sold then return false, err end
    return true, 'Business sold.'
end)

registerAction('ownerTransfer', function(src, venue, _, payload)
    local transferred, err = NDM.Ownership.Transfer(src, venue, payload.target)
    if not transferred then return false, err end
    return true, 'Ownership transferred.'
end)

registerAction('setPrice', function(_, venue, actor, payload)
    if actor.permissions.manage_venue ~= true then return false, 'no_permission' end
    local saved, err = NDM.Register.SetPrice(venue, tostring(payload.item or ''), payload.price)
    if not saved then return false, err end
    return true, 'Price saved.'
end)

registerAction('stockMove', function(src, venue, actor, payload)
    if actor.permissions.manage_stock ~= true then return false, 'no_permission' end
    local direction = payload.direction == 'take' and 'take' or 'store'
    local moved, err = NDM.Supply.MoveStock(src, venue, payload.item, payload.quantity, direction)
    if not moved then return false, err end
    return true, direction == 'take' and 'Stock taken.' or 'Stock stored.'
end)

AddEventHandler('playerDropped', function()
    PendingOffers[source] = nil
end)
