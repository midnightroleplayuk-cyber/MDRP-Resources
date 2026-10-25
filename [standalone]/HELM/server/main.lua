local function debug(...)
    if Config.Debug then print('[helm]', ...) end
end

-- ---------------------------------------------------------------------------
-- HTTP helper
-- ---------------------------------------------------------------------------

-- Token: server_config.lua, or the `helm_token` convar in server.cfg (preferred, nothing on disk in the resource).
local SERVER_TOKEN = GetConvar('helm_token', '')
if SERVER_TOKEN == '' then SERVER_TOKEN = Config.ServerToken or '' end
if SERVER_TOKEN == '' or SERVER_TOKEN == 'hs_replace_me' then
    print('^1[helm] No server token set. Put it in server_config.lua or add  set helm_token "hs_..."  to server.cfg.^7')
end

local function api(method, path, body)
    local p = promise.new()
    PerformHttpRequest((Config.PanelUrl:gsub('/+$', '')) .. path, function(status, text)
        local data = nil
        if text and text ~= '' then data = json.decode(text) end
        p:resolve({ status = status, data = data })
    end, method, body and json.encode(body) or '', {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. SERVER_TOKEN,
    })
    return Citizen.Await(p)
end

HelmApi = api

-- ---------------------------------------------------------------------------
-- Framework helpers
-- ---------------------------------------------------------------------------

local function identifiersFor(src)
    local ids = {}
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        -- IP addresses are deliberately not sent to the panel.
        if not id:find('^ip:') then ids[#ids + 1] = id end
    end
    return ids
end

local function licenseFor(src)
    return GetPlayerIdentifierByType(src, 'license')
end

-- Hardware tokens: the panel compares them with banned players to spot someone back on a new account.
local function tokensFor(src)
    local out = {}
    local n = GetNumPlayerTokens(src) or 0
    for i = 0, math.min(n, 30) - 1 do
        local t = GetPlayerToken(src, i)
        if t then out[#out + 1] = t end
    end
    return out
end

HelmIdentifiers = identifiersFor
HelmLicense = licenseFor

local function sourceByLicense(license)
    for _, src in ipairs(GetPlayers()) do
        if licenseFor(tonumber(src)) == license then return tonumber(src) end
    end
    return nil
end

-- Staff can turn staff alerts off for themselves in game (staff menu or /helmalerts). Kept per game license
-- in the resource's KVP store, so the choice survives reconnects and restarts.
local function alertsKey(src)
    local license = licenseFor(src)
    return license and ('alerts_off:' .. license) or nil
end

function HelmAlertsOn(src)
    local key = alertsKey(src)
    return not key or GetResourceKvpInt(key) ~= 1
end

function HelmSetAlerts(src, on)
    local key = alertsKey(src)
    if not key then return end
    if on then DeleteResourceKvp(key) else SetResourceKvpInt(key, 1) end
end

-- Shows a notice to the online staff the panel listed (paired game accounts only), unless they turned alerts off.
local function notifyStaff(licenses, title, message)
    if type(licenses) ~= 'table' or #licenses == 0 or not message then return end
    local wanted = {}
    for _, l in ipairs(licenses) do wanted[l] = true end
    for _, s in ipairs(GetPlayers()) do
        local src = tonumber(s)
        if wanted[licenseFor(src)] and HelmAlertsOn(src) then
            TriggerClientEvent('helm:client:staffNotice', src, title, message)
            if GetResourceState('chat') == 'started' then
                TriggerClientEvent('chat:addMessage', src, { args = { 'HELM ' .. title:upper(), message } })
            end
        end
    end
end
HelmNotifyStaff = notifyStaff

-- ---------------------------------------------------------------------------
-- Connect check: bans + allowlist
-- ---------------------------------------------------------------------------

-- '2026-10-12T20:00:00.000Z' -> '2026-10-12 20:00 UTC'
local function formatExpiry(iso)
    local d, t = tostring(iso):match('^(%d+%-%d+%-%d+)T(%d+:%d+)')
    return d and (d .. ' ' .. t .. ' UTC') or tostring(iso)
end

-- How long the rejection card stays up before the connection is closed anyway, in milliseconds.
local CARD_SECONDS = 30

-- Rejects a connection with a Helm-branded card (logo, title, details) in the connecting screen.
-- The player closes it, or it closes itself after CARD_SECONDS; FiveM then shows the plain message.
-- FiveM renders Adaptive Cards version 1.0 only, so the card sticks to 1.0 elements and properties.
-- Turn off with Config.BrandedRejections = false.
local function rejectWithCard(deferrals, title, facts, help, plain)
    if Config.BrandedRejections == false then
        deferrals.done(plain)
        return
    end

    local finished = false
    local function finish()
        if finished then return end
        finished = true
        deferrals.done(plain)
    end

    local ok, err = pcall(function()
        local body = {
            -- helm-card.png is sized for the card, since 1.0 cannot set an image's pixel size.
            { type = 'Image', url = (Config.PanelUrl:gsub('/+$', '')) .. '/helm-card.png', size = 'auto', horizontalAlignment = 'center' },
            { type = 'TextBlock', text = title, size = 'large', weight = 'bolder', color = 'attention', horizontalAlignment = 'center', wrap = true, spacing = 'large' },
        }
        if facts then body[#body + 1] = { type = 'FactSet', facts = facts, spacing = 'medium' } end
        body[#body + 1] = { type = 'TextBlock', text = help, wrap = true, isSubtle = true, horizontalAlignment = 'center', spacing = 'medium' }

        local card = {
            type = 'AdaptiveCard',
            ['$schema'] = 'http://adaptivecards.io/schemas/adaptive-card.json',
            version = '1.0',
            body = body,
            actions = { { type = 'Action.Submit', title = 'Close', data = { action = 'close' } } },
        }
        deferrals.presentCard(json.encode(card), function() finish() end)
    end)
    if not ok then
        print(('^3[helm]^7 could not show the rejection card (%s); using the plain message'):format(tostring(err)))
        finish()
        return
    end
    SetTimeout(CARD_SECONDS * 1000, finish)
end

-- ---------------------------------------------------------------------------
-- Local ban list. The panel stays the source of truth; this copy only matters when the panel cannot be
-- reached at connect time, so a banned player cannot get in by waiting for an outage. It is refreshed
-- every Config.BanListSeconds and saved to banlist.json so it survives a restart. Disable with
-- Config.BanCache = false.
-- ---------------------------------------------------------------------------

local BAN_FILE = 'banlist.json'
local banIndex = {}      -- identifier -> { reason, expiresAtMs }
local banCount = 0

local function indexBans(list)
    local idx, n = {}, 0
    for _, b in ipairs(list or {}) do
        local entry = { reason = b.reason, expiresAtMs = b.expiresAtMs }
        if b.license then idx[b.license] = entry end
        for _, id in ipairs(b.identifiers or {}) do idx[id] = entry end
        n = n + 1
    end
    banIndex, banCount = idx, n
end

if Config.BanCache ~= false then
    local saved = LoadResourceFile(GetCurrentResourceName(), BAN_FILE)
    if saved and saved ~= '' then
        local ok, data = pcall(json.decode, saved)
        if ok and type(data) == 'table' then indexBans(data.bans) end
    end

    CreateThread(function()
        Wait(5000)
        while true do
            local res = api('GET', '/api/game/bans')
            if res.status == 200 and res.data and type(res.data.bans) == 'table' then
                indexBans(res.data.bans)
                SaveResourceFile(GetCurrentResourceName(), BAN_FILE, json.encode({ bans = res.data.bans }), -1)
                debug(('ban list refreshed: %d active bans'):format(banCount))
            end
            Wait((Config.BanListSeconds or 120) * 1000)
        end
    end)
end

--- Returns the ban entry for this player from the local copy, or nil.
local function cachedBan(license, identifiers)
    if Config.BanCache == false then return nil end
    local nowMs = os.time() * 1000
    local function live(e) return e and (not e.expiresAtMs or e.expiresAtMs > nowMs) and e or nil end
    local hit = live(banIndex[license])
    if hit then return hit end
    for _, id in ipairs(identifiers or {}) do
        hit = live(banIndex[id])
        if hit then return hit end
    end
    return nil
end

local function checkAccess(src, deferrals)
    deferrals.update('Checking access...')

    local license = licenseFor(src)
    if not license then
        deferrals.done('No Rockstar license found. Restart FiveM and try again.')
        return
    end

    local identifiers = identifiersFor(src)
    local res = api('POST', '/api/game/ban-check', {
        license = license, name = GetPlayerName(src), identifiers = identifiers, tokens = tokensFor(src),
    })
    -- Panel unreachable: refuse anyone on the saved ban list, otherwise let people in so an outage does not
    -- lock the whole server out.
    if res.status ~= 200 or not res.data then
        debug('ban-check failed, status', res.status)
        local ban = cachedBan(license, identifiers)
        if ban then
            local expires = ban.expiresAtMs and os.date('!%Y-%m-%d %H:%M UTC', math.floor(ban.expiresAtMs / 1000)) or nil
            local plain = ('You are banned. Reason: %s. %s'):format(ban.reason or 'n/a', expires and ('Expires: ' .. expires) or 'This ban is permanent.')
            rejectWithCard(deferrals, 'You are banned from this server', {
                { title = 'Reason', value = ban.reason or 'No reason given' },
                { title = 'Expires', value = expires or 'Never (permanent)' },
            }, 'If you think this is a mistake, contact the server staff.', plain)
            return false
        end
        return true, 0
    end

    if res.data.banned then
        local expires = res.data.expiresAt and formatExpiry(res.data.expiresAt) or nil
        local plain = ('You are banned. Reason: %s. %s'):format(res.data.reason or 'n/a', expires and ('Expires: ' .. expires) or 'This ban is permanent.')
        local facts = {
            { title = 'Reason', value = res.data.reason or 'No reason given' },
            { title = 'Expires', value = expires or 'Never (permanent)' },
        }
        if res.data.banRef then facts[#facts + 1] = { title = 'Ban ID', value = res.data.banRef } end
        local help = 'If you think this is a mistake, contact the server staff.'
        if res.data.appealUrl then
            help = ('To appeal, go to %s and sign in with Discord. Your ban ID is %s.'):format(res.data.appealUrl, res.data.banRef or '')
            plain = plain .. ' Appeal at ' .. res.data.appealUrl .. ' (ban ID ' .. (res.data.banRef or '') .. ').'
        end
        rejectWithCard(deferrals, 'You are banned from this server', facts, help, plain)
        return
    end

    if res.data.evasion then
        notifyStaff(res.data.notify, 'Ban evasion', res.data.staffNotice)
        if Config.BlockBanEvasion then
            rejectWithCard(deferrals, 'You are banned from this server', {
                { title = 'Reason', value = res.data.evasion.reason or 'No reason given' },
            }, 'This device is linked to a banned account. If you think this is a mistake, contact the server staff.',
                'You are banned from this server.')
            return
        end
    end

    if Config.EnforceAllowlist and not res.data.allowlisted then
        -- The panel says what to do when the allowlist is by Discord role (join the server, get the role, link Discord).
        local help = res.data.allowlistHelp or 'This server is allowlist only. Ask the server staff to add you, then connect again.'
        rejectWithCard(deferrals, 'You are not allowlisted', nil, help, 'You are not allowlisted on this server. ' .. help)
        return false
    end

    return true, tonumber(res.data.priority) or 0
end

AddEventHandler('playerConnecting', function(name, _, deferrals)
    local src = source
    deferrals.defer()
    -- FiveM requires at least one tick between defer() and any update / presentCard / done.
    Wait(0)
    -- An unexpected error must never leave the player stuck on "Checking access...". Like a panel outage,
    -- it fails open and is printed to the server console.
    -- checkAccess answers (true, queue priority) when the player may join; otherwise it has already rejected them.
    local ok, allowed, priority = pcall(checkAccess, src, deferrals)
    if not ok then
        print(('^1[helm]^7 connect check failed for %s: %s'):format(tostring(name), tostring(allowed)))
        allowed, priority = true, 0
    end
    if allowed then HelmQueueJoin(src, licenseFor(src), priority, deferrals) end
end)

-- ---------------------------------------------------------------------------
-- Sessions
-- ---------------------------------------------------------------------------

AddEventHandler('playerJoining', function()
    local src = source
    local license = licenseFor(src)
    if not license then return end
    local res = api('POST', '/api/game/session', {
        event = 'join',
        license = license,
        name = GetPlayerName(src) or 'unknown',
        identifiers = identifiersFor(src),
        tokens = tokensFor(src),
        src = src,
    })
    -- Someone with recent warnings, kicks, bans or staff notes: tell staff who are online.
    if res.status == 200 and res.data and res.data.staffNotice then
        notifyStaff(res.data.notify, 'Player joined', res.data.staffNotice)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local license = licenseFor(src)
    if not license then return end
    api('POST', '/api/game/session', {
        event = 'leave',
        license = license,
        name = GetPlayerName(src) or 'unknown',
        identifiers = identifiersFor(src),
        reason = reason,
    })
end)

-- ---------------------------------------------------------------------------
-- Heartbeat
-- ---------------------------------------------------------------------------

CreateThread(function()
    while true do
        local live = {}
        for _, s in ipairs(GetPlayers()) do
            local src = tonumber(s)
            local license = licenseFor(src)
            if license and #live < 300 then
                local entry = { id = src, license = license, name = GetPlayerName(src) or 'unknown', ping = GetPlayerPing(src) }
                local char = Bridge.Character(src)
                if char then
                    entry.character = ('%s %s'):format(char.firstname, char.lastname)
                    entry.job = char.job
                end
                local ped = GetPlayerPed(src)
                if ped and ped ~= 0 then
                    local c = GetEntityCoords(ped)
                    entry.x, entry.y, entry.z = math.floor(c.x), math.floor(c.y), math.floor(c.z)
                    -- The vehicle they're in, for the panel's player page and map.
                    local veh = GetVehiclePedIsIn(ped, false)
                    if veh and veh ~= 0 then
                        local plate = (GetVehicleNumberPlateText(veh) or ''):gsub('^%s+', ''):gsub('%s+$', '')
                        entry.vehicle = { plate = plate, model = GetEntityModel(veh), driver = GetPedInVehicleSeat(veh, -1) == ped }
                    end
                end
                live[#live + 1] = entry
            end
        end
        api('POST', '/api/game/heartbeat', {
            playerCount = #GetPlayers(),
            maxPlayers = GetConvarInt('sv_maxclients', 48),
            players = live,
            framework = Bridge.Detected().framework,
            -- Lets the panel kick players whose Discord allowlist role is removed, only where it is enforced.
            enforceAllowlist = Config.EnforceAllowlist == true,
        })
        Wait(Config.HeartbeatSeconds * 1000)
    end
end)

-- ---------------------------------------------------------------------------
-- Remote command execution
-- ---------------------------------------------------------------------------

local handlers = {}

-- Tells a player that staff did something to them, as a card at the top of their screen. Each kind can be switched
-- off in Config.Notices.TellPlayer; spectate, screenshots and staff going to a player stay quiet unless switched on.
local TELL_DEFAULTS = { ['goto'] = false, spectate = false, screenshot = false, live_view = false }
function HelmTellPlayer(src, kind, text, by)
    local tell = (Config.Notices or {}).TellPlayer or {}
    local on = tell[kind]
    if on == nil then on = TELL_DEFAULTS[kind] ~= false end
    if not on or not src then return end
    local who = ((Config.Notices or {}).ShowStaffName ~= false and by) and by or 'Staff'
    -- A function replacement, so a % in an item name or similar is never read as a pattern.
    TriggerClientEvent('helm:client:staffNotice', src, 'Staff action', (text:gsub('{who}', function() return who end)))
end

-- Shows Helm's removal screen (logo, reason, who, expiry) for a few seconds, then disconnects.
-- The server drops the player on its own timer, so a modified client cannot stay connected.
handlers.kick = function(p)
    local src = sourceByLicense(p.license)
    if not src then return true, 'player offline' end
    local kind = p.kind == 'ban' and 'ban' or 'kick'
    local detail = p.detail or p.reason or 'Removed by staff'
    local plain
    if kind == 'ban' then
        plain = ('You have been banned. Reason: %s. %s'):format(detail,
            p.expiresAt and ('Expires: ' .. formatExpiry(p.expiresAt)) or 'This ban is permanent.')
    else
        plain = ('You have been kicked. Reason: %s'):format(detail)
    end

    local seconds = math.max(0, math.min(tonumber((Config.Notices or {}).RemovalSeconds) or 8, 30))
    if seconds == 0 then
        DropPlayer(src, plain)
        return true
    end
    TriggerClientEvent('helm:client:removed', src, {
        kind = kind, reason = detail, by = p.by, expiresAt = p.expiresAt, seconds = seconds,
    })
    local license = p.license
    SetTimeout(seconds * 1000, function()
        -- Same player still on that server ID? Then drop them.
        if GetPlayerName(src) and licenseFor(src) == license then DropPlayer(src, plain) end
    end)
    return true
end

-- Chat is optional: many QBox servers don't run it, so notices also go to Helm's own on-screen UI.
local function chatRunning()
    return GetResourceState('chat') == 'started' and ((Config.Notices or {}).AlsoChat ~= false)
end

local pendingWarnings = {}
AddEventHandler('playerDropped', function() pendingWarnings[source] = nil end)

handlers.warn = function(p)
    local src = sourceByLicense(p.license)
    if not src then return true, 'player offline' end
    pendingWarnings[src] = (pendingWarnings[src] or 0) + 1
    TriggerClientEvent('helm:client:warn', src, p.reason or '', p.by)
    if chatRunning() then
        TriggerClientEvent('chat:addMessage', src, { args = { 'STAFF WARNING', p.reason or '' } })
    end
    return true
end

handlers.announce = function(p)
    TriggerClientEvent('helm:client:announce', -1, p.message or '', p.by)
    if chatRunning() then
        TriggerClientEvent('chat:addMessage', -1, { args = { 'ANNOUNCEMENT', p.message or '' } })
    end
    return true
end

-- Scheduled restart from the panel's Schedules page: everyone is dropped with the message, then the server quits.
-- txAdmin (or the host's auto-restart) brings it back up. Off unless Config.ScheduledRestarts is true.
handlers.restart = function(p)
    if not Config.ScheduledRestarts then return false, 'Config.ScheduledRestarts is off in config.lua' end
    -- A restart queued while this server was down must not fire after it comes back.
    if tonumber(p.at) and os.time() - tonumber(p.at) > 300 then return false, 'restart was more than 5 minutes old' end
    local msg = (p.message and p.message ~= '') and p.message or 'Server restarting. Back in a few minutes.'
    for _, id in ipairs(GetPlayers()) do DropPlayer(id, msg) end
    print('^3[helm]^7 Scheduled restart: quitting in 3 seconds.')
    SetTimeout(3000, function() ExecuteCommand('quit') end)
    return true
end

-- The player clicked "I understand" on their warning(s). Recorded in the activity log.
RegisterNetEvent('helm:server:warnAck', function(count)
    local src = source
    -- Only accept an acknowledgement for warnings this player was actually sent.
    local pending = pendingWarnings[src]
    if not pending or pending < 1 then return end
    local n = math.max(1, math.min(tonumber(count) or 1, pending))
    pendingWarnings[src] = pending - n
    pcall(function()
        exports[GetCurrentResourceName()]:Log(src, 'custom', 'warning_ack',
            n == 1 and 'Acknowledged a staff warning' or ('Acknowledged %d staff warnings'):format(n))
    end)
end)

handlers.revive = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    Bridge.Revive(src)
    HelmTellPlayer(src, 'revive', '{who} revived you.', p.by)
    return true
end

-- ---------------------------------------------------------------------------
-- Staff tools on players: freeze, heal, send back and private messages. Used by panel commands and the F7 menu.
-- ---------------------------------------------------------------------------

local frozen = {}       -- src -> true while staff have them frozen
local lastPosition = {} -- src -> where they were before staff last brought or teleported them

function HelmRememberPosition(src)
    local ped = GetPlayerPed(src)
    if ped ~= 0 then lastPosition[src] = GetEntityCoords(ped) end
    if HelmAntiCheatGrace then HelmAntiCheatGrace(src) end -- Helm is about to move them; not a teleport cheat
end

function HelmIsFrozen(src) return frozen[src] == true end

function HelmFreeze(src, on, by)
    frozen[src] = on and true or nil
    TriggerClientEvent('helm:client:freeze', src, on == true, by)
end

function HelmHeal(src, by)
    TriggerClientEvent('helm:client:heal', src)
    HelmTellPlayer(src, 'heal', '{who} restored your health and armour.', by)
end

function HelmSendBack(src, by)
    local c = lastPosition[src]
    if not c then return false, 'staff have not moved this player, so there is nowhere to send them back to' end
    lastPosition[src] = nil
    if HelmAntiCheatGrace then HelmAntiCheatGrace(src) end
    TriggerClientEvent('helm:client:teleport', src, c.x, c.y, c.z)
    HelmTellPlayer(src, 'sendback', '{who} sent you back to where you were.', by)
    return true
end

-- Shown on that player's screen only, and in their chat if the chat resource is running.
function HelmMessage(src, text, by)
    TriggerClientEvent('helm:client:staffNotice', src, ('Message from %s'):format(by or 'staff'), text, 20)
    if chatRunning() then
        TriggerClientEvent('chat:addMessage', src, { args = { ('STAFF (%s)'):format(by or 'Staff'), text } })
    end
end

AddEventHandler('playerDropped', function()
    frozen[source] = nil
    lastPosition[source] = nil
end)

handlers.teleport = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    HelmRememberPosition(src)
    TriggerClientEvent('helm:client:teleport', src, p.x, p.y, p.z)
    HelmTellPlayer(src, 'teleport', '{who} teleported you.', p.by)
    return true
end

-- ---------------------------------------------------------------------------
-- Clean-up tools: from the in-game menu (around the staff member) and the panel (everything a player spawned).
-- Server-side with OneSync, so they work on entities any player created.
-- ---------------------------------------------------------------------------

-- Anyone (player or NPC) sitting in it.
local function occupied(veh)
    for seat = -1, 6 do
        if GetPedInVehicleSeat(veh, seat) ~= 0 then return true end
    end
    return false
end

-- Who created each script/menu-spawned entity. Ownership moves between players as they walk around, so the
-- creator is recorded when the entity appears; "delete everything they spawned" uses this, not current ownership.
local spawnedBy = {}
AddEventHandler('entityCreated', function(e)
    if not DoesEntityExist(e) or GetEntityPopulationType(e) ~= 7 then return end
    local owner = NetworkGetEntityOwner(e)
    if owner and owner > 0 then spawnedBy[e] = owner end
end)
AddEventHandler('entityRemoved', function(e) spawnedBy[e] = nil end)
AddEventHandler('playerDropped', function()
    local src = source
    for e, o in pairs(spawnedBy) do if o == src then spawnedBy[e] = nil end end
end)

local function within(entity, center, radius)
    return #(GetEntityCoords(entity) - center) <= radius
end

-- Vehicles nobody is sitting in, around a point.
function HelmCleanupVehicles(center, radius)
    local n = 0
    for _, veh in ipairs(GetAllVehicles()) do
        if within(veh, center, radius) and not occupied(veh) and GetEntityAttachedTo(veh) == 0 then DeleteEntity(veh); n = n + 1 end
    end
    return n
end

-- Props made by scripts or mod menus (not the map's own objects), around a point.
function HelmCleanupProps(center, radius)
    local n = 0
    for _, obj in ipairs(GetAllObjects()) do
        if GetEntityPopulationType(obj) == 7 and within(obj, center, radius) then DeleteEntity(obj); n = n + 1 end
    end
    return n
end

function HelmReviveNearby(center, radius, by)
    local n = 0
    for _, s in ipairs(GetPlayers()) do
        local id = tonumber(s)
        local ped = GetPlayerPed(id)
        if ped ~= 0 and within(ped, center, radius) and GetEntityHealth(ped) <= 0 then
            Bridge.Revive(id)
            HelmTellPlayer(id, 'revive', '{who} revived you.', by)
            n = n + 1
        end
    end
    return n
end

-- Everything a player's game spawned since they joined (props, NPCs, vehicles nobody is in), as recorded above.
-- Their own garage car counts if it's empty, so this is meant for modders.
function HelmCleanupSpawnsOf(src)
    local n = 0
    for e, o in pairs(spawnedBy) do
        if o == src and DoesEntityExist(e) then
            local skip = (GetEntityType(e) == 1 and IsPedAPlayer(e))
                or (GetEntityType(e) == 2 and occupied(e))
            if not skip then DeleteEntity(e); n = n + 1 end
        end
        spawnedBy[e] = nil
    end
    return n
end

handlers.cleanup_spawns = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    local n = HelmCleanupSpawnsOf(src)
    return true, ('deleted %d entities'):format(n)
end

handlers.freeze = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    HelmFreeze(src, p.frozen == true, p.by)
    return true
end

handlers.heal = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    HelmHeal(src, p.by)
    return true
end

handlers.send_back = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    return HelmSendBack(src, p.by)
end

handlers.message = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    if type(p.text) ~= 'string' or p.text == '' then return false, 'empty message' end
    HelmMessage(src, p.text:sub(1, 300), p.by)
    return true
end

handlers.give_item = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    if not Bridge.GiveItem(src, p.item, p.amount) then return false, 'item could not be added' end
    HelmTellPlayer(src, 'give_item', ('{who} gave you %dx %s.'):format(tonumber(p.amount) or 1, tostring(p.item)), p.by)
    return true
end

handlers.set_job = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    local ok, err = Bridge.SetJob(src, p.job, p.grade or 0)
    if ok then HelmTellPlayer(src, 'set_job', ('{who} set your job to %s (grade %d).'):format(tostring(p.job), tonumber(p.grade) or 0), p.by) end
    return ok, err
end

handlers.remove_item = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    if not Bridge.RemoveItem(src, p.item, p.amount) then return false, 'item could not be removed' end
    HelmTellPlayer(src, 'remove_item', ('{who} removed %dx %s from your inventory.'):format(tonumber(p.amount) or 1, tostring(p.item)), p.by)
    return true
end

handlers.clear_inventory = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    if not Bridge.ClearInventory(src) then return false, 'inventory could not be cleared' end
    HelmTellPlayer(src, 'clear_inventory', '{who} cleared your inventory.', p.by)
    return true
end

handlers.set_money = function(p)
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    local ok, err = Bridge.SetMoney(src, p.account, p.amount)
    if ok then HelmTellPlayer(src, 'set_money', ('{who} set your %s to $%d.'):format(tostring(p.account), tonumber(p.amount) or 0), p.by) end
    return ok, err
end
-- A staff reply (or closing note) to a /report, shown to the player who sent it.
handlers.report_reply = function(p)
    local src = sourceByLicense(p.license)
    if not src then return true, 'player offline' end
    local title = ('Report %s'):format(p.ref or '')
    TriggerClientEvent('helm:client:staffNotice', src, title, ('%s: %s'):format(p.by or 'Staff', p.text or ''))
    if chatRunning() then
        TriggerClientEvent('chat:addMessage', src, { args = { ('STAFF (%s)'):format(p.by or 'Staff'), p.text or '' } })
    end
    return true
end

-- Screenshot of a player's screen, asked for on the panel. The player's game captures it (client/main.lua) and
-- sends it back here; only a capture this server asked for, from that same player, is passed on to the panel.
local pendingShots = {} -- request id -> { src, license, at }
local shotConfig = Config.Screenshots or {}

handlers.screenshot = function(p)
    if shotConfig.Enabled == false then return false, 'screenshots are turned off in config.lua' end
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    if type(p.requestId) ~= 'string' then return false, 'bad request' end
    pendingShots[p.requestId] = { src = src, license = p.license, at = GetGameTimer() }
    HelmTellPlayer(src, 'screenshot', '{who} took a screenshot of your screen.', p.by)
    TriggerClientEvent('helm:client:screenshot', src, p.requestId, {
        maxWidth = tonumber(shotConfig.MaxWidth) or 1280,
        quality = tonumber(shotConfig.Quality) or 0.75,
    })
    return true
end

RegisterNetEvent('helm:server:screenshot', function(requestId, image, err)
    local src = source
    local pending = type(requestId) == 'string' and pendingShots[requestId]
    if not pending or pending.src ~= src or licenseFor(src) ~= pending.license then return end
    pendingShots[requestId] = nil
    if GetGameTimer() - pending.at > 60000 then return end
    local body = { requestId = requestId }
    -- About 4 MB of JPEG at most once base64 encoded; the panel checks it again.
    if type(image) == 'string' and #image <= 5600000 then body.image = image end
    if type(err) == 'string' then body.error = err:sub(1, 200) end
    if not body.image and not body.error then body.error = 'The picture was too large' end
    local res = api('POST', '/api/game/screenshot', body)
    if res.status ~= 200 then debug('screenshot upload failed', res.status, res.data and res.data.error) end
end)

-- Live view on the panel: a smaller screenshot every couple of seconds while staff keep the page open. The panel
-- renews it every 20 seconds; it stops by itself when they leave, or straight away with seconds = 0.
local liveViews = {} -- src -> { id, untilAt }

handlers.live_view = function(p)
    if shotConfig.Enabled == false then return false, 'screenshots are turned off in config.lua' end
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    local seconds = tonumber(p.seconds) or 0
    if seconds <= 0 then
        -- Stop only the stream that was closed, so a stop that arrives after a new start doesn't end it.
        if liveViews[src] and (p.streamId == nil or p.streamId == '' or liveViews[src].id == p.streamId) then liveViews[src] = nil end
        return true
    end
    if type(p.streamId) ~= 'string' or not p.streamId:match('^live_%w+$') then return false, 'bad request' end
    local current = liveViews[src]
    if current and current.id == p.streamId then
        current.untilAt = GetGameTimer() + math.min(seconds, 60) * 1000
        return true
    end
    -- A new stream: its own loop, which ends as soon as it is no longer the current one for this player.
    local mine = { id = p.streamId, untilAt = GetGameTimer() + math.min(seconds, 60) * 1000 }
    liveViews[src] = mine
    HelmTellPlayer(src, 'live_view', '{who} is watching your screen.', p.by)
    CreateThread(function()
        while liveViews[src] == mine and GetGameTimer() < mine.untilAt and GetPlayerName(src) do
            pendingShots[mine.id] = { src = src, license = p.license, at = GetGameTimer() }
            TriggerClientEvent('helm:client:screenshot', src, mine.id, { maxWidth = 960, quality = 0.5 })
            Wait(2000)
        end
        if liveViews[src] == mine then liveViews[src] = nil end
    end)
    return true
end

-- Live video on the panel: the player's game streams its screen to the staff member's browser over WebRTC (set up
-- in html/index.html). Only the connection setup goes through the panel. Renewed every 20 seconds like live_view.
local liveVideos = {} -- src -> { id, untilAt }

handlers.live_video = function(p)
    if shotConfig.Enabled == false then return false, 'screenshots are turned off in config.lua' end
    local src = sourceByLicense(p.license)
    if not src then return false, 'player offline' end
    local seconds = tonumber(p.seconds) or 0
    local current = liveVideos[src]
    if seconds <= 0 then
        if current and (p.streamId == nil or p.streamId == '' or current.id == p.streamId) then
            liveVideos[src] = nil
            TriggerClientEvent('helm:client:liveVideo', src, false)
        end
        return true
    end
    if type(p.streamId) ~= 'string' or not p.streamId:match('^live_%w+$') then return false, 'bad request' end
    local untilAt = GetGameTimer() + math.min(seconds, 60) * 1000
    if not p.token then
        if not current or current.id ~= p.streamId then return false, 'not streaming' end
        current.untilAt = untilAt
        return true
    end
    if type(p.token) ~= 'string' or not p.token:match('^%x+$') then return false, 'bad request' end
    local mine = { id = p.streamId, untilAt = untilAt }
    liveVideos[src] = mine
    if not current then HelmTellPlayer(src, 'live_view', '{who} is watching your screen.', p.by) end
    TriggerClientEvent('helm:client:liveVideo', src, {
        id = p.streamId, token = p.token, url = (Config.PanelUrl:gsub('/+$', '')), iceServers = p.iceServers,
    })
    CreateThread(function()
        while liveVideos[src] == mine and GetGameTimer() < mine.untilAt and GetPlayerName(src) do Wait(1000) end
        if liveVideos[src] == mine then
            liveVideos[src] = nil
            TriggerClientEvent('helm:client:liveVideo', src, false)
        end
    end)
    return true
end

AddEventHandler('playerDropped', function()
    local src = source
    liveViews[src] = nil
    liveVideos[src] = nil
    for id, p in pairs(pendingShots) do
        if p.src == src then pendingShots[id] = nil end
    end
end)

-- Spectate started from the panel. Both players must be on this server.
handlers.spectate = function(p)
    local staffSrc = sourceByLicense(p.staffLicense)
    if not staffSrc then return false, 'you are not in game on this server' end
    local target = sourceByLicense(p.license)
    if not target then return false, 'player offline' end
    if staffSrc == target then return false, 'you cannot spectate yourself' end
    HelmStartSpectate(staffSrc, target)
    HelmTellPlayer(target, 'spectate', '{who} is spectating you.', p.by)
    return true
end

-- Works offline too: the vehicle is written straight to the character's garage.
handlers.give_vehicle = function(p)
    if type(p.model) ~= 'string' or not p.model:match('^[%w_]+$') then return false, 'invalid model' end
    if type(p.citizenId) ~= 'string' or p.citizenId == '' then return false, 'missing character' end
    local ok, err = Bridge.GiveVehicle({
        license = p.license,
        citizenId = p.citizenId,
        model = p.model,
        plate = p.plate,
        garage = p.garage or Config.DefaultGarage or 'pillboxgarage',
    })
    if not ok then return false, err or 'vehicle could not be added' end
    local src = p.license and sourceByLicense(p.license)
    if src then
        TriggerClientEvent('chat:addMessage', src, { args = { 'VEHICLE', ('You received a %s (plate %s). Check your garage.'):format(p.model, p.plate or '?') } })
        HelmTellPlayer(src, 'give_vehicle', ('{who} gave you a %s (plate %s). Check your garage.'):format(p.model, p.plate or '?'), p.by)
    end
    return true, p.plate
end


CreateThread(function()
    while true do
        local res = api('GET', '/api/game/commands')
        if res.status == 200 and res.data and res.data.commands then
            for _, cmd in ipairs(res.data.commands) do
                local handler = handlers[cmd.type]
                local ok, result = false, 'unknown command'
                if handler then
                    local success, a, b = pcall(handler, cmd.payload or {})
                    if success then ok, result = a, b else ok, result = false, tostring(a) end
                end
                api('POST', '/api/game/commands/' .. cmd.id, { ok = ok, result = result })
            end
        end
        Wait(Config.CommandPollSeconds * 1000)
    end
end)

-- ---------------------------------------------------------------------------
-- Character / vehicle sync (online characters only)
-- ---------------------------------------------------------------------------

CreateThread(function()
    Wait(15000)
    while true do
        local characters, citizenIds = {}, {}
        for _, s in ipairs(GetPlayers()) do
            local src = tonumber(s)
            local c = Bridge.Character(src)
            if c then
                characters[#characters + 1] = {
                    license = licenseFor(src),
                    citizenId = c.citizenid,
                    firstName = c.firstname,
                    lastName = c.lastname,
                    job = c.job,
                    cash = c.cash,
                    bank = c.bank,
                    inventory = Bridge.Inventory(src),
                }
                citizenIds[#citizenIds + 1] = c.citizenid
            end
        end

        local vehicles = {}
        if #citizenIds > 0 then vehicles = Bridge.OwnedVehicles(citizenIds) end

        if #characters > 0 then
            api('POST', '/api/game/sync', { characters = characters, vehicles = vehicles })
        end
        Wait(Config.SyncSeconds * 1000)
    end
end)

-- ---------------------------------------------------------------------------
-- Pair this game account with a panel staff account:  /helmlink CODE
-- The code comes from the panel's Account page. The panel then trusts this account's Cfx.re license
-- (authenticated by the platform) instead of a Discord ID the player's client could fake.
-- ---------------------------------------------------------------------------

local lastLink = {}
RegisterCommand('helmlink', function(src, args)
    if src == 0 then print('[helm] /helmlink is for players in game.') return end
    local now = GetGameTimer()
    if lastLink[src] and now - lastLink[src] < 3000 then return end
    lastLink[src] = now

    local function say(msg) TriggerClientEvent('chat:addMessage', src, { args = { 'HELM', msg } }) end
    local code = tostring(args[1] or '')
    local license = licenseFor(src)
    if code == '' or not license then say('Usage: /helmlink CODE (get a code on the panel Account page)') return end

    local res = api('POST', '/api/game/link', { code = code, license = license })
    if res.status == 200 and res.data and res.data.ok then
        say(('Linked to staff account %s. The staff menu now recognises this game account.'):format(res.data.name or ''))
    else
        say('Link failed: ' .. ((res.data and res.data.error) or ('panel returned ' .. tostring(res.status))))
    end
end, false)
AddEventHandler('playerDropped', function() lastLink[source] = nil end)

-- ---------------------------------------------------------------------------
-- Spectate. The server decides who may spectate (panel or in-game menu) and tells the staff member's client.
-- ---------------------------------------------------------------------------

local spectating = {} -- staff src -> target src

function HelmStartSpectate(staffSrc, target)
    local ped = GetPlayerPed(target)
    local c = ped ~= 0 and GetEntityCoords(ped) or nil
    spectating[staffSrc] = target
    TriggerClientEvent('helm:client:spectate', staffSrc, target, c and { x = c.x, y = c.y, z = c.z } or nil, GetPlayerName(target))
end

-- The client asks for fresh coordinates when the target has moved out of range; only for the player it is watching.
RegisterNetEvent('helm:server:spectateWhere', function()
    local src = source
    local target = spectating[src]
    if not target or not GetPlayerName(target) then
        spectating[src] = nil
        TriggerClientEvent('helm:client:spectateEnd', src, 'The player left')
        return
    end
    local c = GetEntityCoords(GetPlayerPed(target))
    TriggerClientEvent('helm:client:spectateWhere', src, { x = c.x, y = c.y, z = c.z })
end)

RegisterNetEvent('helm:server:spectateStopped', function() spectating[source] = nil end)

AddEventHandler('playerDropped', function()
    local src = source
    spectating[src] = nil
    for staff, target in pairs(spectating) do
        if target == src then
            spectating[staff] = nil
            TriggerClientEvent('helm:client:spectateEnd', staff, 'The player left')
        end
    end
end)

-- ---------------------------------------------------------------------------
-- /report [player id] message  - goes to the panel's Reports page and to online staff.
-- ---------------------------------------------------------------------------

local lastReport = {}
RegisterCommand(Config.ReportCommand or 'report', function(src, args)
    if src == 0 then print('[helm] /report is for players in game.') return end
    local function say(msg)
        TriggerClientEvent('helm:client:staffNotice', src, 'Report', msg)
        if GetResourceState('chat') == 'started' then TriggerClientEvent('chat:addMessage', src, { args = { 'REPORT', msg } }) end
    end

    local now = GetGameTimer()
    if lastReport[src] and now - lastReport[src] < 30000 then
        say('Please wait a little before sending another report.')
        return
    end

    -- An optional first argument that is an online player's server ID marks who the report is about.
    local target
    local first = tonumber(args[1])
    if first and GetPlayerName(first) and #args > 1 then
        target = first
        table.remove(args, 1)
    end
    local message = table.concat(args, ' ')
    if #message < 3 then
        say(('Usage: /%s [player id] what happened'):format(Config.ReportCommand or 'report'))
        return
    end
    lastReport[src] = now

    local ped = GetPlayerPed(src)
    local pos = GetEntityCoords(ped)
    local nearby = {}
    for _, s in ipairs(GetPlayers()) do
        local other = tonumber(s)
        if other ~= src then
            local d = #(GetEntityCoords(GetPlayerPed(other)) - pos)
            if d <= 50.0 and #nearby < 20 then
                nearby[#nearby + 1] = { id = other, name = GetPlayerName(other) or 'unknown', distance = math.floor(d * 10) / 10 }
            end
        end
    end
    table.sort(nearby, function(a, b) return a.distance < b.distance end)

    local res = api('POST', '/api/game/reports', {
        license = licenseFor(src),
        name = GetPlayerName(src) or 'unknown',
        src = src,
        message = message:sub(1, 500),
        target = target and { src = target, license = licenseFor(target), name = GetPlayerName(target) } or nil,
        position = { x = math.floor(pos.x), y = math.floor(pos.y), z = math.floor(pos.z) },
        nearby = nearby,
    })
    if res.status == 200 and res.data and res.data.ok then
        say(('Report %s sent. Staff have been notified.'):format(res.data.ref or ''))
        notifyStaff(res.data.notify, 'New report', res.data.staffNotice)
    else
        lastReport[src] = nil
        say('Your report could not be sent: ' .. ((res.data and res.data.error) or 'the panel did not answer') .. '.')
    end
end, false)
AddEventHandler('playerDropped', function() lastReport[source] = nil end)
