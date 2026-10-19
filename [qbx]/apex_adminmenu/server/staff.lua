-- ============================================================
-- Staff & permission registry — backed by SQL, overrides
-- Config.AdminPerms.UserGroups by license. Falls back to the
-- existing UserGroups/Ace checks if a player isn't in the table.
-- ============================================================

local Groups   = {}  -- [name] = { label, hierarchy, permissions = { '*' or 'cat.*' or 'cat.action' }, color }
local Members  = {}  -- [license] = { nickname, group_name, avatar }

-- Defaults so the panel never explodes when SQL hasn't been imported.
local DEFAULT_GROUPS = {
    owner     = { label = 'Owner',     hierarchy = 0, permissions = { '*' },                                                                                          color = '#E5564B' },
    -- 'settings.*' is listed explicitly even though 'staff.*' already
    -- unlocked the settings page: a server that builds its own group in
    -- the panel copies this list, and the two used to be conflated, so an
    -- "admin"-like custom group could open Settings, type Discord webhook
    -- URLs, and have every save silently rejected.
    -- `staff.read`, NOT `staff.*` — this list must match the seed in
    -- install_admin_panel.sql, which is what every real install actually
    -- gets (the DB row overrides these defaults on every reload). The seed
    -- deliberately withholds `staff.*` so an admin can configure logging
    -- without also being able to promote themselves; having the no-database
    -- fallback be MORE privileged than the real thing was drift, and it is
    -- the kind that is invisible during development because the developer
    -- is `owner` with `*`.
    admin     = { label = 'Admin',     hierarchy = 1, permissions = { 'players.*','moderation.*','vehicles.*','staff.read','settings.*','console.read','resources.*','utility.*','events.*','blips.*','chat.*','items.*','jobs.*','logs.read' }, color = '#1F5EFF' },
    moderator = { label = 'Moderator', hierarchy = 2, permissions = { 'players.read','players.teleport','players.revive','players.heal','moderation.warn','moderation.kick','moderation.ban','jobs.read','reports.*','chat.read','chat.write' }, color = '#4E9CE5' },
    helper    = { label = 'Helper',    hierarchy = 3, permissions = { 'players.read','jobs.read','reports.read','reports.assist','chat.read','chat.write' }, color = '#E5A93C' }
}

-- Framework group name → panel group.
--
-- This closes a privilege-escalation hole. Config.AdminPerms.UserGroups
-- ships {'admin','god','mod','superadmin'} but the panel's groups are
-- {owner, admin, moderator, helper} — only "admin" overlapped. For every
-- other name getGroup() returned nil, and PanelHasPerm's nil-branch fell
-- through to `AdminPerms(src)`, which grants '*': console execution,
-- stopping resources, reading Discord webhook URLs, account resets.
--
-- Net effect: a "mod" had MORE power than a correctly configured
-- "helper". Mapping the common names means they resolve to a real,
-- bounded permission set instead.
local GROUP_ALIASES = {
    owner       = 'owner',
    god         = 'owner',
    superadmin  = 'owner',
    founder     = 'owner',
    admin       = 'admin',
    administrator = 'admin',
    mod         = 'moderator',
    moderator   = 'moderator',
    staff       = 'moderator',
    helper      = 'helper',
    support     = 'helper',
    trial       = 'helper',
    trialmod    = 'helper'
}

-- Resolve a group name to a live group definition, trying the alias
-- table when there's no direct match.
local function groupDef(name)
    if not name then return nil, nil end
    if Groups[name] then return name, Groups[name] end
    local alias = GROUP_ALIASES[tostring(name):lower()]
    if alias and Groups[alias] then return alias, Groups[alias] end
    return nil, nil
end

local function tableExists(name)
    local ok, res = pcall(function()
        return MySQL.scalar.await(
            "SELECT COUNT(*) FROM information_schema.tables "
         .. "WHERE table_schema = DATABASE() AND table_name = ?", { name })
    end)
    return ok and (res or 0) > 0
end

-- ── Cache loaders ───────────────────────────────────────────
local function reloadGroups()
    -- Always seed with defaults so the panel works even before the
    -- DB is set up. SQL rows override matching names below.
    Groups = {}
    for k, v in pairs(DEFAULT_GROUPS) do
        Groups[k] = {
            label = v.label, hierarchy = v.hierarchy,
            permissions = v.permissions, color = v.color
        }
    end

    if not tableExists('apex_staff_groups') then
        print('^3[apex_adminmenu]^7 apex_staff_groups table missing — run install_admin_panel.sql to enable persistent staff groups')
        return
    end

    local ok, rows = pcall(MySQL.query.await, 'SELECT * FROM apex_staff_groups')
    if not ok then return end
    for _, r in ipairs(rows or {}) do
        local perms = {}
        if r.permissions and r.permissions ~= '' then
            local okj, decoded = pcall(json.decode, r.permissions)
            if okj and type(decoded) == 'table' then perms = decoded end
        end
        Groups[r.name] = {
            label      = r.label,
            hierarchy  = tonumber(r.hierarchy) or 99,
            permissions = perms,
            color      = r.color
        }
    end
end

-- ── One identity, several spellings ─────────────────────────
-- The same account shows up under different strings depending on who
-- wrote it down:
--   GetPlayerIdentifiers      license:3f2a…   license2:9c1b…
--   ESX Legacy users.identifier   3f2a…        (ESX.GetIdentifier strips the prefix)
--   ESX multichar                 char1:3f2a…
--   QBCore players.license        license:3f2a…
--   QBox players.license          license2:9c1b…
-- Every list that merges "online players" with "rows from a table" used
-- to compare these raw, so one admin became two cards: an online
-- "license:3f2a…" and an offline "3f2a…". PanelLicKey folds the spellings
-- of the SAME hash onto one key; PanelPlayerKeys returns every key an
-- online player can be found under (license, license2, framework id), so
-- a row keyed by any of them matches that player.
function PanelLicKey(s)
    s = tostring(s or ''):lower():gsub('^%s+', ''):gsub('%s+$', '')
    s = s:gsub('^char%d+:', '')
    s = s:gsub('^license2?:', '')
    return s
end

function PanelPlayerKeys(src)
    local keys, seen = {}, {}
    local function add(v)
        local k = PanelLicKey(v)
        if k ~= '' and not seen[k] then seen[k] = true; keys[#keys + 1] = k end
    end
    if not src or src == 0 then return keys end
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        if id:find('^license2?:') then add(id) end
    end
    if PanelGetCharId then
        local ok, cid = pcall(PanelGetCharId, src)
        if ok and type(cid) == 'string' then add(cid) end
    end
    return keys
end

-- [PanelLicKey(license)] = the license string the row is stored under.
local MembersByKey = {}

local function reloadMembers()
    Members = {}
    MembersByKey = {}
    if not tableExists('apex_staff') then return end
    local ok, rows = pcall(MySQL.query.await, 'SELECT * FROM apex_staff')
    if not ok then return end
    for _, r in ipairs(rows or {}) do
        Members[r.license] = {
            nickname   = r.nickname,
            group_name = r.group_name,
            avatar     = r.avatar
        }
        local k = PanelLicKey(r.license)
        if k ~= '' and not MembersByKey[k] then MembersByKey[k] = r.license end
    end
end

CreateThread(function()
    Wait(2000) -- give oxmysql time to ready up
    reloadGroups()
    reloadMembers()
end)

-- ── Helpers ─────────────────────────────────────────────────
-- Must be the ACCOUNT license, not the framework's character id — see
-- the long note on getLicense in server/adminpanel.lua. apex_staff is
-- keyed on this, so returning a citizenid (which `GetIdentifier` does on
-- QBCore and QBox) made staff permissions follow the CHARACTER: an admin
-- who switched to a second character on the same account lost access.
local function getLicense(src)
    if not src or src == 0 then return '' end
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        if id:sub(1, 8) == 'license:' then return id end
    end
    if GetIdentifier then return GetIdentifier(src) or '' end
    return ''
end

-- Look a player up in apex_staff by EITHER identifier.
--
-- Servers that ran an earlier build have rows keyed by the framework's
-- character id (citizenid on QBCore/QBox), because getLicense used to
-- return that. Now that it correctly returns the account license, those
-- existing rows would stop matching and every admin on a QB/QBox server
-- would lose access on update. Checking the legacy key as well keeps
-- them working; new grants are written with the account license.
local function memberFor(src)
    local lic = getLicense(src)
    local m = Members[lic]
    if m then return m, lic end

    -- Legacy row keyed by citizenid / ESX identifier.
    if PanelGetCharId then
        local charId = PanelGetCharId(src)
        if charId and charId ~= '' and charId ~= lic then
            m = Members[charId]
            if m then return m, charId end
        end
    end

    -- Same account, other spelling: a row written as the bare hash (the
    -- "Add staff" picker lists ESX users that way), as license2:, or
    -- with a different case. See PanelLicKey.
    for _, k in ipairs(PanelPlayerKeys(src)) do
        local stored = MembersByKey[k]
        if stored and Members[stored] then return Members[stored], stored end
    end
    return nil, lic
end
StaffMemberFor = memberFor

-- The row a license string resolves to, by key (nil when there is none).
function PanelMemberByLicense(license)
    if not license or license == '' then return nil end
    if Members[license] then return Members[license], license end
    local stored = MembersByKey[PanelLicKey(license)]
    if stored and Members[stored] then return Members[stored], stored end
    return nil
end

-- Determine a player's group, preferring apex_staff over config.
local function getGroup(src)
    local m = memberFor(src)
    if m then
        local name, def = groupDef(m.group_name)
        if def then return name, def end
    end

    -- Fallback to Config.AdminPerms.UserGroups, now going through the
    -- alias table so names like 'mod' / 'god' / 'superadmin' resolve
    -- instead of falling off the end into the '*' branch.
    if Config and Config.AdminPerms and Config.AdminPerms.UserGroups
        and Config.AdminPerms.UserGroups.enabled then
        for _, g in ipairs(Config.AdminPerms.UserGroups.Groups) do
            if HasPermission and HasPermission(src, g) then
                local name, def = groupDef(g)
                if def then return name, def end
            end
        end
    end

    -- ACE permissions.
    --
    -- This branch was missing entirely, and it is the documented setup:
    -- `add_ace group.admin 'apex.adminmenu.allow' allow`. AdminPerms()
    -- checks ACE, but getGroup() only ever looked at UserGroups — so an
    -- ACE-only admin resolved to NO group. They kept working (AdminPerms
    -- said yes) but every feature that asks "which group are they in"
    -- saw nothing: the web panel's staff list read 0, the in-game staff
    -- tag was blank, and PanelHasPerm fell into its catch-all branch.
    if Config and Config.AdminPerms and Config.AdminPerms.AcePerms
        and Config.AdminPerms.AcePerms.enabled then
        local perm = Config.AdminPerms.AcePerms.AcePerm
        if perm and IsPlayerAceAllowed(src, perm) then
            -- Prefer a more specific ace if the server defines one, so a
            -- moderator doesn't silently become a full admin.
            for _, try in ipairs({ 'owner', 'admin', 'moderator', 'helper' }) do
                if IsPlayerAceAllowed(src, perm .. '.' .. try) then
                    local name, def = groupDef(try)
                    if def then return name, def end
                end
            end
            local name, def = groupDef('admin')
            if def then return name, def end
        end
    end

    return nil
end

-- Check a permission key like 'players.kick'. '*' always matches.
local function permMatch(perm, want)
    if perm == '*' then return true end
    if perm == want then return true end
    -- 'players.*' should match 'players.kick'
    if perm:sub(-2) == '.*' then
        local prefix = perm:sub(1, -3)
        return want:sub(1, #prefix) == prefix
    end
    return false
end

function PanelHasPerm(src, want)
    local _, grp = getGroup(src)
    if not grp then
        -- Backwards compat for ACE-only admins with no recognised group.
        --
        -- This used to `return AdminPerms(src)`, i.e. a plain `true`, which
        -- PanelHasPerm's callers read as "has EVERY permission" — console
        -- execution, resource control, webhook secrets, account resets.
        -- An unrecognised group name was therefore the most privileged
        -- state in the whole system.
        --
        -- Now it grants the ADMIN set instead: broad enough that existing
        -- setups keep working, bounded enough that it isn't a blank cheque.
        -- Ownership-level actions still require an explicit group.
        if not (AdminPerms and AdminPerms(src) == true) then return false end
        grp = Groups['admin'] or DEFAULT_GROUPS.admin
        if not grp then return false end
    end
    for _, p in ipairs(grp.permissions or {}) do
        if permMatch(p, want) then return true end
    end
    return false
end

function PanelCanOpen(src)
    return getGroup(src) ~= nil or (AdminPerms and AdminPerms(src))
end

-- ── Visible refusals ─────────────────────────────────────────
-- Every panel action used to be gated with `if not PanelHasPerm(...) then
-- return end`: a refusal did nothing at all. A customer whose staff group was
-- missing a key saw "we can't send in the admin chat, announce does nothing,
-- job changes don't save" with no clue that it was ONE missing permission,
-- and the few gates that did answer went through ox_lib notify, which is
-- drawn underneath the focused panel (it is a second NUI on the same screen).
--
-- PanelRequire(src, perms, what) is what the gates call now: true when the
-- player holds ANY of `perms`, otherwise it tells the admin which permission
-- the action needs and which group of theirs lacks it, and returns false.
-- The message goes to `apex_adminmenu:panel:toast`, which the client draws
-- INSIDE the panel while it is open and through the normal notify otherwise.

-- The player's effective permission list, the group it comes from and how
-- that group was resolved:
--   'member'    an apex_staff row (Staff > Members)
--   'framework' a framework group / ACE that maps onto a panel group
--               (admin, god -> owner, mod -> moderator, ...)
--   'fallback'  staff through Config.AdminPerms but with NO recognised group
--               (e.g. a framework group called "servermanagement"): gets the
--               Admin set, exactly like PanelHasPerm does
-- nil when the player is not staff at all.
function PanelEffectivePerms(src)
    local name, grp = getGroup(src)
    local how = 'framework'
    if grp then
        local m = memberFor(src)
        if m and groupDef(m.group_name) then how = 'member' end
    else
        if not (AdminPerms and AdminPerms(src) == true) then return nil end
        name = 'admin'
        grp  = Groups['admin'] or DEFAULT_GROUPS.admin
        how  = 'fallback'
    end
    local perms = {}
    for i, p in ipairs(grp.permissions or {}) do perms[i] = p end
    return perms, name, grp, how
end

-- Human label for the action in the refusal, keyed by the panel event or
-- callback name. Anything not listed is shown as the raw name.
local DENY_WHAT = {
    announce = 'Announce', setTime = 'Set the time', toggleTime = 'Pause the clock',
    setWeather = 'Set the weather', vehicleDeleteUpdate = 'Reset the vehicle cleanup timer',
    revivePlayer = 'Revive', teleportTo = 'Teleport', bringPlayer = 'Bring', healPlayer = 'Heal',
    freezePlayer = 'Freeze', spectatePlayer = 'Spectate', kickPlayer = 'Kick',
    giveMoneyTo = 'Give money', giveItemTo = 'Give item', setPlayerJob = 'Set job',
    removeItemFrom = 'Remove item', giveWeaponTo = 'Give weapon', setHealthOf = 'Set health',
    setArmorOf = 'Set armour', fixVehicleOf = 'Fix vehicle', cleanVehicleOf = 'Clean vehicle',
    spawnVehicleFor = 'Spawn vehicle', respawnPlayer = 'Respawn', setFlag = 'Flag player',
    banFromPanel = 'Ban', banFromPanelByLicense = 'Ban', unban = 'Unban', warnPlayer = 'Warn',
    warnPlayerByLicense = 'Warn', jailPlayer = 'Jail', jailPlayerByLicense = 'Jail',
    saveMember = 'Save staff member', removeMember = 'Remove staff member',
    saveGroup = 'Save staff group', deleteGroup = 'Delete staff group',
    deleteVehicle = 'Delete vehicle', consoleExec = 'Run a console command',
    resourceAction = 'Start/stop a resource', saveEvent = 'Save event', deleteEvent = 'Delete event',
    saveBlip = 'Save blip', deleteBlip = 'Delete blip', chatSend = 'Send in staff chat',
    saveSettings = 'Save your settings', saveGlobalSettings = 'Save server settings',
    saveKeybinds = 'Save keybinds', setStaffTag = 'Toggle the staff tag',
    saveJob = 'Save job', deleteJob = 'Delete job', saveEventRule = 'Save event rule',
    deleteEventRule = 'Delete event rule', clearEventLogs = 'Clear event logs',
    screenshotPlayer = 'Screenshot', resetAccount = 'Reset account',
    -- callbacks (page loads)
    home = 'Home page', homeStats = 'Home stats', players = 'Players list',
    playerDetail = 'Player profile', playerDetailOffline = 'Player profile',
    flags = 'Player flags', flagsAll = 'Player flags', bans = 'Bans list', warnings = 'Warnings list',
    jails = 'Jails list', staff = 'Staff page', usersBrowse = 'User search', logs = 'Logs page',
    items = 'Items page', vehicles = 'Vehicles page', consoleHistory = 'Console page',
    resources = 'Resources page', events = 'Events page', blips = 'Blips page',
    channels = 'Staff chat', chat = 'Staff chat', jobs = 'Jobs page', eventLogs = 'Event logs',
    globalSettings = 'Server settings', avatars = 'Avatars',
}

local denyLast = {}   -- [src .. '|' .. what] = GetGameTimer() of the last toast

-- Tell `src` that `what` was refused because none of `perms` is held.
-- `perms` may be nil for "you are not staff at all".
function PanelDeny(src, perms, what)
    if not src or src == 0 then return end
    what = DENY_WHAT[what] or tostring(what or 'This action')
    local key = tostring(src) .. '|' .. what
    local now = GetGameTimer()
    if denyLast[key] and now - denyLast[key] < 1500 then return end   -- the UI retries page loads
    denyLast[key] = now

    local list = {}
    if type(perms) == 'string' then perms = { perms } end
    for _, p in ipairs(perms or {}) do
        if p ~= '*' then list[#list + 1] = p end
    end
    local need = table.concat(list, ' or ')

    local _, gname, grp, how = PanelEffectivePerms(src)
    local msg
    if not grp then
        msg = ('%s: you are not a staff member of this panel.'):format(what)
    elseif need == '' then
        msg = ('%s: this needs the owner permission (*).'):format(what)
    elseif how == 'fallback' then
        msg = ('%s needs the permission %s. You are staff through Config.AdminPerms but have no panel group, which only gives the Admin set. '
            .. 'Ask the owner to add you on Staff > Members, or run  apexstaff <your id> owner  in the server console.')
            :format(what, need)
    else
        msg = ('%s needs the permission %s. Your staff group "%s" (%s) does not have it. '
            .. 'The owner can add it on Staff > Groups > edit %s.')
            :format(what, need, tostring(grp.label or gname), tostring(gname), tostring(gname))
    end
    TriggerClientEvent('apex_adminmenu:panel:toast', src, 'error', msg, 9000)
    if Config and Config.Debug then
        print(('^3[apex_adminmenu]^7 denied %s for %s (%s): needs %s'):format(what, tostring(src), tostring(gname), need))
    end
end

-- true when `src` holds ANY of `perms`; otherwise PanelDeny + false.
function PanelRequire(src, perms, what)
    if type(perms) == 'string' then perms = { perms } end
    for _, p in ipairs(perms or {}) do
        if PanelHasPerm(src, p) then return true end
    end
    PanelDeny(src, perms, what)
    return false
end

-- Console: `apexperms <server id>` prints how the panel sees a player —
-- group, where that group came from and every permission it grants. This
-- is the first thing to run when someone reports "X does nothing".
RegisterCommand('apexperms', function(src, args)
    if src ~= 0 then return end
    local id = tonumber(args[1])
    if not id or not GetPlayerName(id) then
        print('usage: apexperms <server id of an online player>')
        return
    end
    local perms, gname, grp, how = PanelEffectivePerms(id)
    local lic = getLicense(id)
    if not grp then
        print(('^1[apex_adminmenu] %s (%s) is NOT staff:^7 no apex_staff row for %s, no group from Config.AdminPerms.UserGroups and no ACE %s.')
            :format(GetPlayerName(id), id, lic, tostring(Config and Config.AdminPerms and Config.AdminPerms.AcePerms and Config.AdminPerms.AcePerms.AcePerm)))
        print('  To make them owner:  apexstaff ' .. id .. ' owner')
        return
    end
    local via = ({
        member    = 'apex_staff row (Staff > Members)',
        framework = 'framework group / ACE mapped onto a panel group',
        fallback  = 'Config.AdminPerms staff with no panel group -> Admin set',
    })[how] or how
    print(('^2[apex_adminmenu] %s (%s)^7  license %s'):format(GetPlayerName(id), id, lic))
    print(('  group: %s "%s"  hierarchy %s  via %s'):format(gname, tostring(grp.label), tostring(grp.hierarchy), via))
    print(('  permissions (%d): %s'):format(#perms, #perms > 0 and table.concat(perms, ', ') or '^1NONE - this group cannot do anything^7'))
    local checks = { 'chat.write', 'utility.announce', 'jobs.write', 'staff.read', 'staff.write', 'players.read', 'moderation.kick' }
    local out = {}
    for _, c in ipairs(checks) do out[#out + 1] = c .. '=' .. (PanelHasPerm(id, c) and 'yes' or 'NO') end
    print('  checks: ' .. table.concat(out, '  '))
end, true)

-- Who may OPEN a menu, on top of being staff (Config.MenuAccess).
--   groups   : panel group names, aliases accepted ('mod' -> moderator);
--              a listed group lets in everyone ranked at or above it, so
--              { 'admin' } means admins and owners.
--   licenses : exact identifiers, any type ('license:', 'discord:', ...).
-- Empty lists (or no entry at all) mean no restriction. A menu with at
-- least one non-empty list opens only for a player matching ONE of them.
-- This decides who can open the menu; what a player may DO inside it
-- stays with the group permissions and Config.PermissionLevels.
function MenuAllowed(src, menu)
    local rule = Config and Config.MenuAccess and Config.MenuAccess[menu]
    if type(rule) ~= 'table' then return true end
    local groups   = type(rule.groups) == 'table' and rule.groups or {}
    local licenses = type(rule.licenses) == 'table' and rule.licenses or {}
    if #groups == 0 and #licenses == 0 then return true end

    if #licenses > 0 and src and src ~= 0 then
        local mine = {}
        for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do mine[id:lower()] = true end
        for _, want in ipairs(licenses) do
            if type(want) == 'string' and mine[want:lower()] then return true end
        end
    end

    if #groups > 0 then
        local _, def = getGroup(src)
        -- ACE-only staff with no recognised group count as 'admin', the
        -- same fallback PanelHasPerm uses.
        if not def and AdminPerms and AdminPerms(src) == true then
            _, def = groupDef('admin')
        end
        if def then
            local rank = tonumber(def.hierarchy) or 99
            for _, g in ipairs(groups) do
                local _, want = groupDef(g)
                if want and rank <= (tonumber(want.hierarchy) or 99) then return true end
            end
        end
    end
    return false
end

function PanelGetGroup(src) return getGroup(src) end
-- name, def of a group name, following the aliases (mod -> moderator)
function PanelResolveGroup(name) return groupDef(name) end
-- Goes through memberFor so legacy citizenid-keyed rows are honoured
-- too — otherwise "on duty" would read false for pre-update admins.
function PanelGetMember(src) return (memberFor(src)) end
function PanelGetGroups() return Groups end
function PanelGetMembers() return Members end
function PanelReload()
    reloadGroups(); reloadMembers()
    -- Console-read permission is cached for a couple of seconds in
    -- adminpanel.lua; a promotion should show up immediately, not on the
    -- next tick of that cache.
    if PanelInvalidateConsoleReaders then PanelInvalidateConsoleReaders() end
end

-- ── Mutations ───────────────────────────────────────────────
-- Returns true, or false + a reason the panel can show. Every failure used
-- to be silent, and the Add staff form offered 'mod' as its default group,
-- which is not a group (the groups are owner/admin/moderator/helper): the
-- row was refused without a word and "adding staff does nothing" followed.
-- Aliases (mod, god, superadmin, support…) now resolve to the real group.
function PanelAddMember(license, nickname, group_name, avatar, by)
    license = tostring(license or ''):gsub('^%s+', ''):gsub('%s+$', '')
    if license == '' then return false, 'Enter the player\'s license (license:…) or pick an online player.' end
    local name = groupDef(group_name)
    if not name then
        local valid = {}
        for k in pairs(Groups) do valid[#valid + 1] = k end
        table.sort(valid)
        return false, ('Unknown group "%s". Use one of: %s'):format(tostring(group_name), table.concat(valid, ', '))
    end
    if not tableExists('apex_staff') then
        return false, 'The apex_staff table is missing. Import install_admin_panel.sql and restart the resource.'
    end
    local ok, err = pcall(MySQL.insert.await,
        'INSERT INTO apex_staff (license, nickname, group_name, avatar, created_by) '
     .. 'VALUES (?, ?, ?, ?, ?) '
     .. 'ON DUPLICATE KEY UPDATE nickname = VALUES(nickname), group_name = VALUES(group_name), avatar = VALUES(avatar)',
        { license, tostring(nickname or ''):sub(1, 64), name, avatar or '', tostring(by or 'system'):sub(1, 64) }
    )
    if not ok then return false, 'Database error: ' .. tostring(err) end
    reloadMembers()
    return true, name
end

function PanelRemoveMember(license)
    -- The card may carry another spelling of the stored license (see
    -- PanelLicKey); delete the row that actually exists. No row at all
    -- means the person is staff through a framework group or ACE, and a
    -- "removed" answer for that was a lie: the card came straight back.
    local _, stored = PanelMemberByLicense(license)
    if not stored then
        return false, ('%s has no Staff-page row to remove: they are staff through a framework group or ACE. '
            .. 'Change that in your framework (users.group / players.permission) or in server.cfg.'):format(tostring(license))
    end
    license = stored
    local ok, err = pcall(MySQL.query.await, 'DELETE FROM apex_staff WHERE license = ?', { license })
    if not ok then return false, 'Database error: ' .. tostring(err) end
    reloadMembers()
    return true
end

function PanelSaveGroup(name, label, hierarchy, permissions, color)
    name = tostring(name or ''):lower():gsub('[^%w_%-]', '')
    if name == '' then return false, 'The group needs an internal name (letters, numbers, _ or -).' end
    if not tableExists('apex_staff_groups') then
        return false, 'The apex_staff_groups table is missing. Import install_admin_panel.sql and restart the resource.'
    end
    hierarchy = tonumber(hierarchy) or 5
    local ok, err = pcall(MySQL.insert.await,
        'INSERT INTO apex_staff_groups (name, label, hierarchy, permissions, color) '
     .. 'VALUES (?, ?, ?, ?, ?) '
     .. 'ON DUPLICATE KEY UPDATE label = VALUES(label), hierarchy = VALUES(hierarchy), permissions = VALUES(permissions), color = VALUES(color)',
        { name, tostring(label or name), hierarchy, json.encode(permissions or {}), color or '#1a7249' }
    )
    if not ok then return false, 'Database error: ' .. tostring(err) end
    reloadGroups()
    return true, name
end

function PanelDeleteGroup(name)
    if name == 'owner' then return false, 'The owner group cannot be deleted.' end
    local ok, err = pcall(MySQL.query.await, 'DELETE FROM apex_staff_groups WHERE name = ?', { name })
    if not ok then return false, 'Database error: ' .. tostring(err) end
    reloadGroups()
    return true
end

-- ── Log helper used everywhere in the panel ─────────────────
-- Category → embed colour mapping for Discord logs. Keeps the
-- visual identity consistent across the panel and the webhook side.
local LOG_COLOURS = {
    moderation = 0xE5564B,
    economy    = 0xE5A93C,
    money      = 0xE5A93C,    -- legacy alias used by some callers
    player     = 0x1A7249,
    vehicle    = 0x4E9CE5,
    staff      = 0xA66DF0,
    panel      = 0xA66DF0,    -- panel-driven config changes
    quickmenu  = 0x34C77B,
    utility    = 0x34C77B,
    report     = 0xF0B429,
    reports    = 0xF0B429,
    console    = 0x6272A4,
    login      = 0x8BE9FD
}

-- Maps the raw `category` string the rest of the codebase uses to
-- the Discord webhook key configured in the panel.
local function mapCategoryToHook(category)
    if category == 'money'   then return 'economy'   end
    if category == 'utility' then return 'staff'     end
    if category == 'report'  then return 'reports'   end
    if category == 'panel'   then return 'staff'     end
    return category
end

function PanelLog(src, category, action, target, target_lic, details)
    local lic = getLicense(src)
    local name = GetPlayerName(src) or 'Console'
    pcall(function()
        MySQL.insert(
            'INSERT INTO apex_staff_log (admin_lic, admin, category, action, target, target_lic, details) '
         .. 'VALUES (?, ?, ?, ?, ?, ?, ?)',
            { lic, name, category, action, target, target_lic, details }
        )
    end)

    -- Feed the live Event Logs page too — exposed by adminpanel.lua.
    if PanelCaptureEvent then
        local label = ('panel:%s:%s'):format(category or '?', action or '?')
        pcall(PanelCaptureEvent, label, src, { target = target, license = target_lic, details = details })
    end

    -- Mirror to Discord via the helper added in adminpanel.lua. The
    -- helper itself silently no-ops when Discord is disabled, the
    -- category webhook isn't configured, or this event group is muted.
    if PanelDiscordSend then
        local fields = {}
        if target and target ~= '' then
            fields[#fields + 1] = { name = 'Target', value = tostring(target), inline = true }
        end
        if target_lic and target_lic ~= '' then
            fields[#fields + 1] = { name = 'License', value = ('`%s`'):format(target_lic), inline = true }
        end
        if details and details ~= '' then
            fields[#fields + 1] = { name = 'Details', value = tostring(details):sub(1, 1000), inline = false }
        end
        PanelDiscordSend(mapCategoryToHook(category), {
            title       = (category and category:sub(1,1):upper() .. category:sub(2) or 'Action') .. ' · ' .. tostring(action or '?'),
            description = ('Admin: **%s** `%s`'):format(name, lic or ''),
            color       = LOG_COLOURS[category] or 0x1A7249,
            fields      = fields,
            timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ'),
            footer      = { text = ('Apex Admin · src %s'):format(tostring(src or '?')) }
        })
    end

    -- Surface the most impactful actions as Home dashboard alerts so
    -- on-duty admins can see them at a glance.
    if PanelAddAlert then
        local sev = 'info'
        if category == 'moderation' then sev = (action == 'ban' or action == 'kick') and 'error' or 'warning' end
        if action == 'suspicious_key' then sev = 'warning' end
        if category == 'panel' and action and action:find('save') then sev = 'success' end
        local title = (category or 'admin') .. ' · ' .. (action or '?')
        local msg   = (name or 'Console') .. (target and (' → ' .. tostring(target)) or '')
        PanelAddAlert(sev, title, msg)
    end
end

-- Quick-menu hook: every quickmenu action also lands in the log so the
-- admin panel can browse it per-staff.
RegisterNetEvent('apex_adminmenu:logQuickAction', function(action, details)
    local src = source
    if not (AdminPerms and AdminPerms(src)) and not PanelHasPerm(src, '*') then return end
    PanelLog(src, 'quickmenu', tostring(action or '?'), nil, nil, tostring(details or ''))
end)
