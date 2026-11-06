Gangs = {}

-- gangs[id]          = { id, name, label, colour, reputation, heat, ranks = { [grade] = { label, wage, permissions = set } } }
-- members[citizenid] = { gangId, grade, heat, name }
-- invites[citizenid] = { gangId, inviter, expires }
local gangs, members, byName, invites = {}, {}, {}, {}
local onlineCid = {} -- onlineCid[src] = citizenid, used for last_seen on drop

local function permissionSet(list)
    local set = {}
    for _, p in ipairs(list or {}) do set[p] = true end
    return set
end

local function permissionList(set)
    local list = {}
    for p in pairs(set or {}) do list[#list + 1] = p end
    table.sort(list)
    return list
end

local validPermissions = permissionSet(Config.Permissions)

-------------------------------------------------------------------------------
-- Loading and lookups
-------------------------------------------------------------------------------

function Gangs.Load()
    gangs, members, byName = {}, {}, {}

    for _, g in ipairs(MySQL.query.await("SELECT id, name, label, colour, logo_url, logo_status, reputation, heat FROM vg_gangs WHERE status = 'active'")) do
        g.heat = tonumber(g.heat) or 0
        g.ranks = {}
        g.logo = g.logo_url
        g.logoStatus = g.logo_status or 'none'
        g.logo_url, g.logo_status = nil, nil
        gangs[g.id] = g
        byName[g.name] = g.id
    end

    for _, r in ipairs(MySQL.query.await('SELECT gang_id, grade, label, permissions, wage FROM vg_ranks')) do
        local g = gangs[r.gang_id]
        if g then
            g.ranks[r.grade] = { label = r.label, wage = r.wage, permissions = permissionSet(json.decode(r.permissions)) }
        end
    end

    for _, m in ipairs(MySQL.query.await('SELECT citizenid, name, gang_id, grade, personal_heat FROM vg_members')) do
        if gangs[m.gang_id] then
            members[m.citizenid] = { gangId = m.gang_id, grade = m.grade, heat = tonumber(m.personal_heat) or 0, name = m.name }
        end
    end
end

function Gangs.Get(id) return gangs[id] end
function Gangs.All() return gangs end
function Gangs.GetMembership(citizenid) return members[citizenid] end

function Gangs.GetByName(name)
    local id = byName[tostring(name or ''):lower()]
    return id and gangs[id]
end

function Gangs.GetPlayerGang(src)
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    return m and gangs[m.gangId], m, cid
end

function Gangs.HasPermission(citizenid, permission)
    local m = members[citizenid]
    local g = m and gangs[m.gangId]
    local rank = g and g.ranks[m.grade]
    if not rank then return false end
    return rank.permissions['*'] == true or rank.permissions[permission] == true
end

function Gangs.TopGrade(gangId)
    local top
    for grade in pairs(gangs[gangId] and gangs[gangId].ranks or {}) do
        if not top or grade > top then top = grade end
    end
    return top or 0
end

function Gangs.LowestGrade(gangId)
    local low
    for grade in pairs(gangs[gangId] and gangs[gangId].ranks or {}) do
        if not low or grade < low then low = grade end
    end
    return low or 0
end

function Gangs.RankLabel(gangId, grade)
    local g = gangs[gangId]
    return g and g.ranks[grade] and g.ranks[grade].label or ('Grade %d'):format(grade or 0)
end

function Gangs.MemberCount(gangId)
    local n = 0
    for _, m in pairs(members) do
        if m.gangId == gangId then n = n + 1 end
    end
    return n
end

function Gangs.GetMembers(gangId)
    local list = {}
    for cid, m in pairs(members) do
        if m.gangId == gangId then
            list[#list + 1] = {
                citizenid = cid,
                name = m.name or 'Unknown',
                grade = m.grade,
                rank = Gangs.RankLabel(gangId, m.grade),
                online = Bridge.GetSourceFromCitizenId(cid) ~= nil,
            }
        end
    end
    table.sort(list, function(a, b)
        if a.grade ~= b.grade then return a.grade > b.grade end
        return a.name < b.name
    end)
    return list
end

function Gangs.GetRanks(gangId)
    local g = gangs[gangId]
    local list = {}
    for grade, r in pairs(g and g.ranks or {}) do
        list[#list + 1] = { grade = grade, label = r.label, wage = r.wage, permissions = permissionList(r.permissions) }
    end
    table.sort(list, function(a, b) return a.grade > b.grade end)
    return list
end

-------------------------------------------------------------------------------
-- Client sync and notifications
-------------------------------------------------------------------------------

---Sends the player's own gang data to their client only (not replicated to other players).
---What a player's own client is told about their gang (nil when they're not in one).
function Gangs.ClientData(src, cid)
    cid = cid or Bridge.GetCitizenId(src)
    if not cid then return nil end
    onlineCid[src] = cid

    local m = members[cid]
    local g = m and gangs[m.gangId]
    local data
    if g then
        local rank = g.ranks[m.grade]
        data = {
            id = g.id, name = g.name, label = g.label, colour = g.colour,
            grade = m.grade, rank = Gangs.RankLabel(g.id, m.grade),
            isBoss = m.grade == Gangs.TopGrade(g.id),
            permissions = rank and permissionList(rank.permissions) or {},
            logo = Gangs.ApprovedLogo(g.id),
            tier = Progression.Tier(g.id),
            unlocks = Progression.Unlocks(g.id),
            logoUrl = g.logo,
            logoStatus = g.logoStatus,
        }
    end
    return data
end

---Pushes the player's gang data to their client.
function Gangs.SyncPlayer(src, cid)
    cid = cid or Bridge.GetCitizenId(src)
    if not cid then return end
    TriggerClientEvent('vinewood_gangs:client:setGang', src, Gangs.ClientData(src, cid))
end

local function syncCid(cid)
    local src = Bridge.GetSourceFromCitizenId(cid)
    if src then Gangs.SyncPlayer(src, cid) end
end

local function syncGang(gangId)
    for cid, m in pairs(members) do
        if m.gangId == gangId then syncCid(cid) end
    end
end

function Gangs.SyncGang(gangId) syncGang(gangId) end

function Gangs.NotifyGang(gangId, message, notifyType, minGrade)
    for cid, m in pairs(members) do
        if m.gangId == gangId and (not minGrade or m.grade >= minGrade) then
            local src = Bridge.GetSourceFromCitizenId(cid)
            if src then Bridge.Notify(src, message, notifyType) end
        end
    end
end

local function notifyCid(cid, message, notifyType)
    local src = Bridge.GetSourceFromCitizenId(cid)
    if src then Bridge.Notify(src, message, notifyType) end
end

-------------------------------------------------------------------------------
-- Internal membership writes
-------------------------------------------------------------------------------

local function addMember(cid, gangId, grade, name)
    name = name or 'Unknown'
    MySQL.insert.await([[
        INSERT INTO vg_members (citizenid, name, gang_id, grade) VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE name = VALUES(name), gang_id = VALUES(gang_id), grade = VALUES(grade),
            personal_heat = 0, joined_at = CURRENT_TIMESTAMP
    ]], { cid, name, gangId, grade })
    members[cid] = { gangId = gangId, grade = grade, heat = 0, name = name }
    invites[cid] = nil
    syncCid(cid)
end

local function removeMember(cid)
    MySQL.update.await('DELETE FROM vg_members WHERE citizenid = ?', { cid })
    members[cid] = nil
    syncCid(cid)
end

local function setGrade(cid, grade)
    MySQL.update.await('UPDATE vg_members SET grade = ? WHERE citizenid = ?', { grade, cid })
    members[cid].grade = grade
    syncCid(cid)
end

-- Actor must be in the same gang and strictly outrank the target
local function canManage(actorCid, targetCid)
    local a, t = members[actorCid], members[targetCid]
    if not a then return false, 'not_in_gang' end
    if not t or a.gangId ~= t.gangId then return false, 'not_same_gang' end
    if actorCid == targetCid then return false, 'cannot_target_self' end
    if a.grade <= t.grade then return false, 'insufficient_rank' end
    return true
end

-------------------------------------------------------------------------------
-- Creation and disbanding
-------------------------------------------------------------------------------

---@param opts? { free?:boolean, actor?:number }
---@return number|false gangId, string|nil err
function Gangs.Create(src, name, label, colour, opts)
    opts = opts or {}
    local cid = Bridge.GetCitizenId(src)
    if not cid then return false, 'no_player' end
    if members[cid] then return false, 'already_in_gang' end
    if not opts.free and not Config.Gangs.allowPlayerCreation then return false, 'creation_disabled' end

    name = tostring(name or ''):lower()
    local cfg = Config.Gangs
    if #name < cfg.nameMin or #name > cfg.nameMax or not name:match('^[%w_]+$') then
        return false, 'invalid_name'
    end
    if not tostring(colour or ''):match('^#%x%x%x%x%x%x$') then colour = '#FFFFFF' end
    label = tostring(label or name):sub(1, 64)

    if MySQL.scalar.await('SELECT 1 FROM vg_gangs WHERE name = ?', { name }) then
        return false, 'name_taken'
    end

    local cost = opts.free and 0 or cfg.creationCost
    if cost > 0 and not Bridge.RemoveMoney(src, 'bank', cost, 'gang-creation') then
        return false, 'insufficient_funds'
    end

    local gangId = MySQL.insert.await('INSERT INTO vg_gangs (name, label, colour, created_by) VALUES (?, ?, ?, ?)', { name, label, colour, cid })
    if not gangId then
        if cost > 0 then Bridge.AddMoney(src, 'bank', cost, 'gang-creation-refund') end
        return false, 'db_error'
    end

    local rankRows, ranks = {}, {}
    for _, r in ipairs(Config.DefaultRanks) do
        rankRows[#rankRows + 1] = { gangId, r.grade, r.label, json.encode(r.permissions), r.wage }
        ranks[r.grade] = { label = r.label, wage = r.wage, permissions = permissionSet(r.permissions) }
    end
    MySQL.prepare.await('INSERT INTO vg_ranks (gang_id, grade, label, permissions, wage) VALUES (?, ?, ?, ?, ?)', rankRows)
    MySQL.prepare.await('INSERT INTO vg_accounts (gang_id, account, balance) VALUES (?, ?, 0)', { { gangId, 'clean' }, { gangId, 'dirty' } })

    gangs[gangId] = { id = gangId, name = name, label = label, colour = colour, reputation = 0, heat = 0, ranks = ranks, logoStatus = 'none' }
    byName[name] = gangId

    addMember(cid, gangId, Gangs.TopGrade(gangId), Bridge.GetCharName(src))

    Logger.Log(opts.actor or src, 'gang_created', ('%s created gang %s (%d)%s'):format(cid, name, gangId, opts.actor and ' [staff]' or ''))
    TriggerEvent('vinewood_gangs:server:gangCreated', gangId)
    return gangId
end

---@param opts? { actor?:number, reason?:string }
function Gangs.Disband(gangId, opts)
    opts = opts or {}
    local g = gangs[gangId]
    if not g then return false, 'gang_missing' end

    -- Refund clean treasury to an online boss
    if Config.Gangs.disbandRefund then
        local top = Gangs.TopGrade(gangId)
        for cid, m in pairs(members) do
            if m.gangId == gangId and m.grade == top then
                local bossSrc = Bridge.GetSourceFromCitizenId(cid)
                local balance = Ledger.GetBalance(gangId, 'clean')
                if bossSrc and balance > 0 then
                    local ok = Ledger.Transact(gangId, 'clean', -balance, 'disband_refund', { citizenid = cid })
                    if ok then Bridge.AddMoney(bossSrc, 'bank', balance, 'gang-disband-refund') end
                end
                break
            end
        end
    end

    Gangs.NotifyGang(gangId, locale('gang_disbanded', g.label), 'error')

    local affected = {}
    for cid, m in pairs(members) do
        if m.gangId == gangId then affected[#affected + 1] = cid end
    end

    MySQL.update.await('DELETE FROM vg_members WHERE gang_id = ?', { gangId })
    -- Free the name for reuse; '#' can't appear in a valid gang name so this never collides
    MySQL.update.await("UPDATE vg_gangs SET status = 'disbanded', disbanded_at = NOW(), name = CONCAT(LEFT(name, 20), '#', id) WHERE id = ?", { gangId })

    for cid, inv in pairs(invites) do
        if inv.gangId == gangId then invites[cid] = nil end
    end
    for _, cid in ipairs(affected) do members[cid] = nil end
    byName[g.name] = nil
    gangs[gangId] = nil

    Influence.RemoveGang(gangId)
    for _, cid in ipairs(affected) do syncCid(cid) end

    Logger.Log(opts.actor or 0, 'gang_disbanded', ('Gang %s (%d) disbanded%s'):format(g.name, gangId, opts.reason and (': ' .. opts.reason) or ''))
    TriggerEvent('vinewood_gangs:server:gangDisbanded', gangId)
    return true
end

-------------------------------------------------------------------------------
-- Player-driven membership actions
-------------------------------------------------------------------------------

function Gangs.Invite(src, targetSrc)
    local cid = Bridge.GetCitizenId(src)
    if not cid or not members[cid] then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'manage_members') then return false, 'no_permission' end

    targetSrc = tonumber(targetSrc)
    if not targetSrc or targetSrc == src or not GetPlayerName(targetSrc) then return false, 'invalid_target' end
    local targetCid = Bridge.GetCitizenId(targetSrc)
    if not targetCid then return false, 'invalid_target' end
    if members[targetCid] then return false, 'target_in_gang' end

    local gangId = members[cid].gangId
    if Gangs.MemberCount(gangId) >= Config.Gangs.maxMembers then return false, 'gang_full' end

    local maxDist = Config.Gangs.inviteDistance
    if maxDist and maxDist > 0 then
        local a = GetEntityCoords(GetPlayerPed(src))
        local b = GetEntityCoords(GetPlayerPed(targetSrc))
        if #(a - b) > maxDist then return false, 'too_far' end
    end

    local existing = invites[targetCid]
    if existing and existing.expires > os.time() then return false, 'invite_pending' end

    invites[targetCid] = { gangId = gangId, inviter = cid, expires = os.time() + Config.Gangs.inviteExpirySeconds }
    TriggerClientEvent('vinewood_gangs:client:invite', targetSrc, {
        gang = gangs[gangId].label,
        inviter = Bridge.GetCharName(src),
        expires = Config.Gangs.inviteExpirySeconds,
    })
    Logger.Log(src, 'member_invited', ('%s invited %s to gang %d'):format(cid, targetCid, gangId))
    return true
end

function Gangs.RespondInvite(src, accept)
    local cid = Bridge.GetCitizenId(src)
    local inv = cid and invites[cid]
    if not inv then return false, 'no_invite' end
    invites[cid] = nil

    if inv.expires < os.time() then return false, 'invite_expired' end
    local g = gangs[inv.gangId]
    if not g then return false, 'gang_missing' end

    local name = Bridge.GetCharName(src)
    if not accept then
        notifyCid(inv.inviter, locale('invite_declined', name), 'error')
        return true
    end

    if members[cid] then return false, 'already_in_gang' end
    if Gangs.MemberCount(g.id) >= Config.Gangs.maxMembers then return false, 'gang_full' end

    addMember(cid, g.id, Gangs.LowestGrade(g.id), name)
    Gangs.NotifyGang(g.id, locale('member_joined', name, g.label), 'success')
    Logger.Log(src, 'member_joined', ('%s joined gang %d'):format(cid, g.id))
    return true
end

function Gangs.Kick(src, targetCid)
    local cid = Bridge.GetCitizenId(src)
    if not cid or not Gangs.HasPermission(cid, 'manage_members') then return false, 'no_permission' end
    local ok, err = canManage(cid, targetCid)
    if not ok then return false, err end

    local gangId = members[cid].gangId
    local name = members[targetCid].name or targetCid
    removeMember(targetCid)
    notifyCid(targetCid, locale('you_were_kicked', gangs[gangId].label), 'error')
    Gangs.NotifyGang(gangId, locale('member_kicked', name), 'inform')
    Logger.Log(src, 'member_kicked', ('%s kicked %s from gang %d'):format(cid, targetCid, gangId))
    return true
end

function Gangs.SetGrade(src, targetCid, newGrade)
    local cid = Bridge.GetCitizenId(src)
    if not cid or not Gangs.HasPermission(cid, 'manage_members') then return false, 'no_permission' end
    local ok, err = canManage(cid, targetCid)
    if not ok then return false, err end

    newGrade = tonumber(newGrade)
    local gangId = members[cid].gangId
    if not newGrade or not gangs[gangId].ranks[newGrade] then return false, 'invalid_grade' end
    if newGrade >= members[cid].grade then return false, 'insufficient_rank' end
    if newGrade == members[targetCid].grade then return true end

    local promoted = newGrade > members[targetCid].grade
    setGrade(targetCid, newGrade)
    notifyCid(targetCid, locale(promoted and 'you_were_promoted' or 'you_were_demoted', Gangs.RankLabel(gangId, newGrade)), promoted and 'success' or 'inform')
    Logger.Log(src, 'member_grade', ('%s set %s to grade %d in gang %d'):format(cid, targetCid, newGrade, gangId))
    return true
end

---Moves one grade up or down from the target's current grade.
function Gangs.StepGrade(src, targetCid, direction)
    local t = members[targetCid]
    if not t then return false, 'not_same_gang' end
    local g = gangs[t.gangId]
    local best
    for grade in pairs(g.ranks) do
        if direction > 0 and grade > t.grade and (not best or grade < best) then best = grade end
        if direction < 0 and grade < t.grade and (not best or grade > best) then best = grade end
    end
    if not best then return false, 'invalid_grade' end
    return Gangs.SetGrade(src, targetCid, best)
end

function Gangs.TransferLeadership(src, targetCid)
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    if not m then return false, 'not_in_gang' end
    local top = Gangs.TopGrade(m.gangId)
    if m.grade ~= top then return false, 'boss_only' end
    local t = members[targetCid]
    if not t or t.gangId ~= m.gangId or targetCid == cid then return false, 'invalid_target' end

    local below
    for grade in pairs(gangs[m.gangId].ranks) do
        if grade < top and (not below or grade > below) then below = grade end
    end

    setGrade(targetCid, top)
    setGrade(cid, below or Gangs.LowestGrade(m.gangId))
    Gangs.NotifyGang(m.gangId, locale('leadership_transferred', t.name or targetCid), 'inform')
    Logger.Log(src, 'leadership_transferred', ('%s transferred gang %d to %s'):format(cid, m.gangId, targetCid))
    return true
end

function Gangs.Leave(src)
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    if not m then return false, 'not_in_gang' end
    local gangId = m.gangId

    if m.grade == Gangs.TopGrade(gangId) then
        if Gangs.MemberCount(gangId) > 1 then return false, 'transfer_first' end
        return Gangs.Disband(gangId, { actor = src, reason = 'last member left' })
    end

    local name = m.name or cid
    removeMember(cid)
    Gangs.NotifyGang(gangId, locale('member_left', name), 'inform')
    Logger.Log(src, 'member_left', ('%s left gang %d'):format(cid, gangId))
    return true
end

function Gangs.PlayerDisband(src)
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    if not m then return false, 'not_in_gang' end
    if m.grade ~= Gangs.TopGrade(m.gangId) then return false, 'boss_only' end
    return Gangs.Disband(m.gangId, { actor = src, reason = 'disbanded by boss' })
end

---Edit a rank's label and permissions. Ranks at or above your own are locked,
---and you can only grant permissions you hold yourself.
function Gangs.EditRank(src, grade, label, permissions)
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    if not m then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'manage_ranks') then return false, 'no_permission' end

    local g = gangs[m.gangId]
    grade = tonumber(grade)
    local rank = grade and g.ranks[grade]
    if not rank then return false, 'invalid_grade' end

    local isTop = m.grade == Gangs.TopGrade(g.id)
    if grade >= m.grade and not (isTop and grade == m.grade) then return false, 'insufficient_rank' end

    label = tostring(label or rank.label):gsub('[<>]', ''):sub(1, 48)
    if #label == 0 then return false, 'invalid_label' end

    local newPerms
    if grade == Gangs.TopGrade(g.id) then
        newPerms = { '*' } -- boss permissions can't be reduced
    else
        newPerms = {}
        for _, p in ipairs(type(permissions) == 'table' and permissions or permissionList(rank.permissions)) do
            if validPermissions[p] and Gangs.HasPermission(cid, p) then
                newPerms[#newPerms + 1] = p
            end
        end
    end

    MySQL.update.await('UPDATE vg_ranks SET label = ?, permissions = ? WHERE gang_id = ? AND grade = ?', { label, json.encode(newPerms), g.id, grade })
    rank.label = label
    rank.permissions = permissionSet(newPerms)
    syncGang(g.id)
    Logger.Log(src, 'rank_edited', ('%s edited grade %d in gang %d'):format(cid, grade, g.id))
    return true
end

-------------------------------------------------------------------------------
-- Staff actions (no rank checks; callers must verify staff permission)
-------------------------------------------------------------------------------

function Gangs.AdminSetMember(targetSrc, gangId, grade, actor)
    local cid = Bridge.GetCitizenId(targetSrc)
    if not cid then return false, 'invalid_target' end
    local g = gangs[gangId]
    if not g then return false, 'gang_missing' end
    grade = tonumber(grade) or Gangs.LowestGrade(gangId)
    if not g.ranks[grade] then return false, 'invalid_grade' end

    addMember(cid, gangId, grade, Bridge.GetCharName(targetSrc))
    Logger.Log(actor or 0, 'staff_set_member', ('%s placed in gang %d grade %d'):format(cid, gangId, grade))
    return true
end

function Gangs.AdminSetGrade(cid, grade, actor)
    local m = members[cid]
    if not m then return false, 'not_in_gang' end
    grade = tonumber(grade)
    if not grade or not gangs[m.gangId].ranks[grade] then return false, 'invalid_grade' end
    setGrade(cid, grade)
    Logger.Log(actor or 0, 'staff_set_grade', ('%s set to grade %d in gang %d'):format(cid, grade, m.gangId))
    return true
end

function Gangs.AdminRemoveMember(cid, actor)
    if not members[cid] then return false, 'not_in_gang' end
    local gangId = members[cid].gangId
    removeMember(cid)
    Logger.Log(actor or 0, 'staff_remove_member', ('%s removed from gang %d'):format(cid, gangId))
    return true
end

-------------------------------------------------------------------------------
-- Player lifecycle
-------------------------------------------------------------------------------

function Gangs.OnPlayerLoaded(src)
    local cid = Bridge.GetCitizenId(src)
    if not cid then return end
    local m = members[cid]
    if m then
        m.name = Bridge.GetCharName(src)
        MySQL.update('UPDATE vg_members SET name = ?, last_seen = NOW() WHERE citizenid = ?', { m.name, cid })
    end
    Gangs.SyncPlayer(src, cid)
end

function Gangs.SyncAllOnline()
    for _, s in ipairs(GetPlayers()) do
        Gangs.SyncPlayer(tonumber(s))
    end
end

AddEventHandler('playerDropped', function()
    local src = source
    local cid = onlineCid[src]
    onlineCid[src] = nil
    if cid and members[cid] then
        MySQL.update('UPDATE vg_members SET last_seen = NOW() WHERE citizenid = ?', { cid })
    end
end)

-------------------------------------------------------------------------------
-- Tablet helpers
-------------------------------------------------------------------------------

---Boss-only: change display name and colour.
function Gangs.UpdateDetails(src, label, colour)
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    if not m then return false, 'not_in_gang' end
    if m.grade ~= Gangs.TopGrade(m.gangId) then return false, 'boss_only' end

    label = tostring(label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 64)
    if #label < Config.Gangs.nameMin then return false, 'invalid_label' end
    if not tostring(colour or ''):match('^#%x%x%x%x%x%x$') then return false, 'invalid_colour' end

    local g = gangs[m.gangId]
    MySQL.update.await('UPDATE vg_gangs SET label = ?, colour = ? WHERE id = ?', { label, colour:upper(), g.id })
    g.label, g.colour = label, colour:upper()
    syncGang(g.id)
    Influence.Publish()
    Logger.Log(src, 'gang_details', ('%s updated gang %d details'):format(cid, g.id))
    return true
end

---Players near src who could be invited (not in a gang).
function Gangs.GetNearbyInvitable(src)
    local maxDist = Config.Gangs.inviteDistance > 0 and Config.Gangs.inviteDistance or 10.0
    local origin = GetEntityCoords(GetPlayerPed(src))
    local list = {}
    for _, s in ipairs(GetPlayers()) do
        local target = tonumber(s)
        if target ~= src then
            local dist = #(origin - GetEntityCoords(GetPlayerPed(target)))
            local cid = dist <= maxDist and Bridge.GetCitizenId(target)
            if cid and not members[cid] then
                list[#list + 1] = {
                    id = target,
                    name = Config.Tablet.showNearbyNames and Bridge.GetCharName(target) or nil,
                    distance = math.floor(dist + 0.5),
                }
            end
        end
    end
    table.sort(list, function(a, b) return a.distance < b.distance end)
    return list
end

-------------------------------------------------------------------------------
-- Logos and reputation
-------------------------------------------------------------------------------

local allowedExt = {}
for _, e in ipairs(Config.Logos.extensions) do allowedExt[e] = true end

local function hostAllowed(host)
    for _, allowed in ipairs(Config.Logos.allowedHosts) do
        if host == allowed or host:sub(-(#allowed + 1)) == '.' .. allowed then return true end
    end
    return false
end

---Only https links to an allowed image host, ending in an image extension.
function Gangs.ValidateLogoUrl(url)
    url = tostring(url or ''):match('^%s*(.-)%s*$')
    if #url == 0 then return '' end
    if #url > 255 or url:find('[%s"\'<>\\]') then return nil, 'invalid_logo' end
    local host, path = url:match('^https://([%w%.%-]+)(/[^?#]*)')
    if not host then
        return nil, url:match('^http://') and 'logo_needs_https' or 'invalid_logo'
    end
    -- Any website allowed: just needs to be a well-formed https link (staff check what it shows)
    if Config.Logos.allowAnyHost then return url end
    if not hostAllowed(host:lower()) then return nil, 'logo_host_not_allowed' end
    local ext = path:match('%.(%w+)$')
    if not ext or not allowedExt[ext:lower()] then return nil, 'invalid_logo' end
    return url
end

function Gangs.ApprovedLogo(gangId)
    local g = gangs[gangId]
    if not g or not Config.Logos.enabled or g.logoStatus ~= 'approved' then return nil end
    return g.logo
end

---Boss-only. An empty link removes the logo.
function Gangs.SetLogo(src, url)
    if not Config.Logos.enabled then return false, 'invalid' end
    local cid = Bridge.GetCitizenId(src)
    local m = cid and members[cid]
    if not m then return false, 'not_in_gang' end
    if m.grade ~= Gangs.TopGrade(m.gangId) then return false, 'boss_only' end

    local clean, err = Gangs.ValidateLogoUrl(url)
    if not clean then return false, err end

    local g = gangs[m.gangId]
    local status = clean == '' and 'none' or (Config.Logos.requireApproval and 'pending' or 'approved')
    MySQL.update.await('UPDATE vg_gangs SET logo_url = NULLIF(?, \'\'), logo_status = ? WHERE id = ?', { clean, status, g.id })
    g.logo = clean ~= '' and clean or nil
    g.logoStatus = status
    syncGang(g.id)
    Logger.Log(src, 'gang_logo', ('%s set logo for gang %d (%s)'):format(cid, g.id, status))
    return true, status
end

function Gangs.PendingLogos()
    local list = {}
    for _, g in pairs(gangs) do
        if g.logoStatus == 'pending' and g.logo then
            list[#list + 1] = { gangId = g.id, label = g.label, colour = g.colour, url = g.logo }
        end
    end
    table.sort(list, function(a, b) return a.gangId < b.gangId end)
    return list
end

function Gangs.ReviewLogo(gangId, approve, actor)
    local g = gangs[tonumber(gangId)]
    if not g or g.logoStatus ~= 'pending' then return false, 'invalid' end
    g.logoStatus = approve and 'approved' or 'rejected'
    MySQL.update.await('UPDATE vg_gangs SET logo_status = ? WHERE id = ?', { g.logoStatus, g.id })
    syncGang(g.id)
    Gangs.NotifyGang(g.id, locale(approve and 'logo_approved' or 'logo_rejected'), approve and 'success' or 'error', Gangs.TopGrade(g.id))
    Logger.Log(actor or 0, 'gang_logo_reviewed', ('gang %d logo %s'):format(g.id, g.logoStatus))
    return true
end

function Gangs.AddReputation(gangId, amount)
    local g = gangs[gangId]
    if not g or amount == 0 then return end
    g.reputation = math.max(0, (g.reputation or 0) + math.floor(amount))
    MySQL.update('UPDATE vg_gangs SET reputation = ? WHERE id = ?', { g.reputation, gangId })
    Progression.Check(gangId)
end

---Every online member of a gang: { source, citizenid }.
function Gangs.OnlineMembers(gangId)
    local out = {}
    for src, cid in pairs(onlineCid) do
        local m = members[cid]
        if m and m.gangId == gangId and GetPlayerName(src) then out[#out + 1] = { source = src, citizenid = cid } end
    end
    return out
end

function Gangs.HasOnlineMember(gangId)
    for cid, m in pairs(members) do
        if m.gangId == gangId and Bridge.GetSourceFromCitizenId(cid) then return true end
    end
    return false
end
