-- ============================================================
-- Admin Panel — server endpoints (HOME, PLAYERS, MODERATION,
-- MONITORING, CHATS, ITEMS, VEHICLES, CONSOLE, EVENTS, STAFF,
-- BLIPS, SETTINGS). Auth = PanelHasPerm/PanelCanOpen from
-- server/staff.lua.
-- ============================================================

local panelConsoleBuffer = {}  -- last ~200 server console lines
local MAX_CONSOLE_LINES  = 200

-- ── Console capture (best-effort) ──────────────────────────
-- Hooks into the resource console output via print monkey-patch
-- so we can stream lines to the admin panel. EVERY call is wrapped
-- in pcall + xpcall to guarantee a faulty downstream resource can't
-- crash core engine prints (the broadcast was previously crashing
-- because GetPlayers() was being called from a bridge load error).
--
-- "Who may read the console?" used to be recomputed for EVERY printed line:
-- GetPlayers() plus a full permission resolution per player (apex_staff row →
-- framework group → ACE tree). A server printing 50 lines a second with 40
-- players online performed 2,000 of those resolutions per second — to answer a
-- question whose answer only changes when someone joins, leaves or is
-- promoted. The gate is unchanged and still server-side; it is just no longer
-- re-derived fifty times a second.
local consoleReaders, consoleReadersAt = {}, 0
local CONSOLE_READERS_TTL = 2000  -- ms
local resolvingReaders = false

local function consoleReaderList()
    local now = GetGameTimer()
    if now - consoleReadersAt < CONSOLE_READERS_TTL then return consoleReaders end
    -- A permission check that itself printed would recurse straight back in
    -- here; serve the stale list rather than risk it.
    if resolvingReaders then return consoleReaders end

    resolvingReaders   = true
    consoleReadersAt   = now
    local out = {}
    if PanelHasPerm and GetPlayers then
        for _, src in pairs(GetPlayers() or {}) do
            local s = tonumber(src)
            if s and PanelHasPerm(s, 'console.read') then out[#out + 1] = s end
        end
    end
    consoleReaders     = out
    resolvingReaders   = false
    return out
end

--- Force the next printed line to re-resolve who can read the console.
function PanelInvalidateConsoleReaders() consoleReadersAt = 0 end

local _print = print
print = function(...)
    -- Always print first, even if the rest fails.
    local nargs = select('#', ...)
    local parts = {}
    for i = 1, nargs do parts[i] = tostring(select(i, ...)) end
    _print(...)

    pcall(function()
        local line = table.concat(parts, '\t')
        panelConsoleBuffer[#panelConsoleBuffer + 1] = {
            time = os.time(),
            text = line,
            type = 'log'
        }
        while #panelConsoleBuffer > MAX_CONSOLE_LINES do
            table.remove(panelConsoleBuffer, 1)
        end

        -- Mirror to the WEB panel too. Defined in server/webpanel.lua,
        -- which loads after this file, hence the existence check.
        if PanelRelayConsole then
            PanelRelayConsole(panelConsoleBuffer[#panelConsoleBuffer])
        end
        if not PanelHasPerm then return end -- staff.lua not loaded yet
        local row = panelConsoleBuffer[#panelConsoleBuffer]
        for _, s in ipairs(consoleReaderList()) do
            TriggerClientEvent('apex_adminmenu:panel:consoleLine', s, row)
        end
    end)
end

-- ── Helpers ────────────────────────────────────────────────
-- Resilient query: returns {} instead of throwing if the table
-- doesn't exist yet (e.g. SQL not imported on a fresh install).
local function safeQuery(sql, args)
    local ok, rows = pcall(MySQL.query.await, sql, args)
    if not ok then return {} end
    return rows or {}
end
local function safeSingle(sql, args)
    local ok, row = pcall(MySQL.single.await, sql, args)
    if not ok then return nil end
    return row
end

-- ── Identity ───────────────────────────────────────────────
-- There are TWO different identifiers in play and conflating them was
-- the single worst bug in this resource:
--
--   • the ACCOUNT license  ("license:abc123…") — stable per FiveM
--     account, survives character switches. Every apex_* table
--     (apex_bans, apex_staff, apex_warnings, apex_jail, apex_staff_log,
--     apex_player_flags) is keyed on this.
--   • the CHARACTER id     (ESX identifier / QB+QBox citizenid) — what
--     the framework's own tables (players, player_vehicles) use.
--
-- `getLicense` used to return `GetIdentifier(src)`, which on QBCore and
-- QBox is the CITIZENID. That silently poisoned every moderation table
-- on those two frameworks: ban history never rendered, unbans didn't
-- unban, staff permissions followed the character instead of the
-- account, and every online player was also listed as offline because
-- the dedup compared a citizenid against players.license.
--
-- ESX was accidentally correct because its identifier IS the license.
local function getLicense(src)
    if not src or src == 0 then return '' end
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        if id:sub(1, 8) == 'license:' then return id end
    end
    -- No license identifier (very old builds / odd server config): fall
    -- back to the framework id so we degrade instead of returning ''.
    if GetIdentifier then return GetIdentifier(src) or '' end
    return ''
end

-- The framework's own character key, for `players` / `player_vehicles`.
local function getCharId(src)
    if not src or src == 0 then return '' end
    if GetIdentifier then return GetIdentifier(src) or '' end
    return getLicense(src)
end
PanelGetCharId = getCharId

local function getPlayerLabel(src)
    return GetPlayerName(src) or ('ID ' .. tostring(src))
end

-- Try to read player coords. Falls back to 0,0,0 if not connected.
local function getCoords(src)
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then
        local c = GetEntityCoords(ped)
        return { x = c.x, y = c.y, z = c.z }
    end
    return { x = 0, y = 0, z = 0 }
end

-- ============================================================
-- Steam avatar lookup (hoisted so every callback can use it
-- from the very first call, including the bootstrap).
-- Cache is populated by the resolver further below.
-- ============================================================
local steamAvatarCache = {}  -- [steamHex] = url

-- Negative cache. Without it, a player whose avatar cannot be resolved —
-- no Steam linked, a private profile, Steam's XML endpoint down — was
-- looked up again on EVERY panel open: a DB round-trip per player plus an
-- outbound HTTP request per player, and a bootstrap that blocked on it.
-- A "no" is an answer too, and it is worth remembering for a while.
local avatarMisses    = {}   -- [steamHex|license] = os.time() when it expires
local AVATAR_MISS_TTL = 600  -- 10 minutes

local function avatarMissed(key)
    if not key or key == '' then return false end
    local until_ = avatarMisses[key]
    if not until_ then return false end
    if os.time() >= until_ then avatarMisses[key] = nil; return false end
    return true
end

local function markAvatarMiss(key)
    if not key or key == '' then return end
    avatarMisses[key] = os.time() + AVATAR_MISS_TTL
end

-- A resolve that finally succeeds must clear the miss, or the cached "no"
-- would keep shadowing the real answer for the rest of the TTL.
local function clearAvatarMiss(key)
    if key then avatarMisses[key] = nil end
end

local function getSteamHexEarly(src)
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        if id:sub(1, 6) == 'steam:' then return id end
    end
    return nil
end

local function getAvatar(src)
    local hex = getSteamHexEarly(src)
    return hex and steamAvatarCache[hex] or nil
end

-- Forward-declared so the bootstrap callback above can synchronously
-- request a resolve. The real implementation lives lower in the file.
local ensureAvatar = function(_, cb) if cb then cb(nil) end end
-- Wrapper so calls to ensureAvatar() always defer to the latest impl.
local function _ensureAvatar(src, cb) return ensureAvatar(src, cb) end

-- Forward-declared broadcaster — the real one lives next to the
-- Steam resolver further down. Stub here so the bootstrap thread and
-- the sweep thread above don't trip over a nil. Reassigned when the
-- real definition is parsed.
local broadcastAvatar = function(_, _) end

-- Direct license -> avatar URL lookup. Used everywhere the row
-- already has a license (bans/warnings/jails/logs/chats) so the
-- UI can render the Steam picture without a player source.
local function avatarForLicenseEarly(lic)
    if not lic or lic == '' then return nil end
    -- Memory cache.
    if steamAvatarCache[lic] then return steamAvatarCache[lic] end
    -- A recent "no" short-circuits the DB round-trip below. This function is
    -- called once per row of every list the panel renders, so without it a
    -- 300-row ban list meant 300 awaited queries for avatars that were
    -- already known not to exist.
    if avatarMissed(lic) then return nil end
    -- Map license back to currently-online player's steam hex.
    for _, p in ipairs(GetPlayers() or {}) do
        local s = tonumber(p)
        if s and (GetIdentifier and GetIdentifier(s)) == lic then
            local hex = getSteamHexEarly(s)
            if hex and steamAvatarCache[hex] then
                steamAvatarCache[lic] = steamAvatarCache[hex]
                return steamAvatarCache[hex]
            end
        end
    end
    -- DB fallback — prefer base64 data URI (avatar_b64). Both columns
    -- may be empty until the steam resolver fills them.
    local row = safeSingle('SELECT avatar, avatar_b64 FROM apex_steam_avatars WHERE steam = ?', { lic })
    if row then
        local cached = (row.avatar_b64 and row.avatar_b64 ~= '') and row.avatar_b64
                    or (row.avatar and row.avatar ~= '' and row.avatar)
                    or nil
        if cached then
            steamAvatarCache[lic] = cached
            clearAvatarMiss(lic)
            return cached
        end
    end
    markAvatarMiss(lic)
    return nil
end

-- Walk an array of rows and inject `avatar` / `target_avatar` /
-- `admin_avatar` for any field that names a license. Safe to call
-- with an empty table.
local function enrichRowsWithAvatars(rows)
    if type(rows) ~= 'table' then return rows end

    -- Avatars resolve to a base64 `data:` URI whenever apex_steam_avatars
    -- has one cached, and a single portrait is tens of kilobytes. Stamping
    -- it onto all 500 rows of a log/ban list — often twice per row, for the
    -- admin AND the target — is what produced
    --   "sending large event __ox_cb_apex_adminmenu (3851345 bytes)".
    --
    -- The panel does not need the repeats. Its avatar layer caches by
    -- license (harvestAvatars -> avatarCache) and paints every element
    -- carrying that data-license from the cache, so one copy per license
    -- per payload renders exactly the same UI. Short CDN URLs are left on
    -- every row untouched: they cost nothing and deduping them would only
    -- add a way to be subtly wrong.
    local sentBig = {}
    local function pick(license)
        if not license or license == '' then return nil end
        local url = avatarForLicenseEarly(license)
        if not url then return nil end
        if #url < 512 then return url end          -- a plain URL: send as-is
        if sentBig[license] then return nil end    -- already in this payload
        sentBig[license] = true
        return url
    end

    for _, r in ipairs(rows) do
        if r.license     and not r.avatar        then r.avatar        = pick(r.license)    end
        if r.target      and not r.target_avatar then r.target_avatar = pick(r.target)     end
        if r.target_lic  and not r.target_avatar then r.target_avatar = pick(r.target_lic) end
        if r.author_lic  and not r.author_avatar then r.author_avatar = pick(r.author_lic) end
        if r.admin_lic   and not r.admin_avatar  then r.admin_avatar  = pick(r.admin_lic)  end
    end
    return rows
end

-- Hoisted so playerDetail can read live session length safely.
sessionStart = sessionStart or {}  -- [src] = unix timestamp

-- ============================================================
-- AUTH callback
-- ============================================================
lib.callback.register('apex_adminmenu:panel:bootstrap', function(source)
    if not PanelCanOpen(source) then return { allowed = false } end
    -- Staff, but the panel itself is closed to them (Config.MenuAccess).
    if MenuAllowed and not MenuAllowed(source, 'AdminPanel') then return { allowed = false } end
    -- The framework's player object (`ESX.GetPlayerFromId`, etc.) can
    -- still be nil on the very first /adminpanel of a session, which
    -- makes `getGroup()` return nil even though the player *is* staff.
    -- Retry a few times with small sleeps so the group label always
    -- arrives on the first open instead of requiring a second one.
    --
    -- The retry only helps while the framework object itself is still
    -- being built, which is the case it was written for. It does NOT help
    -- an ACE-only admin: PanelCanOpen lets them in through AdminPerms()
    -- while getGroup() legitimately returns nil for them, so the old
    -- `for _ = 1, 10 do Wait(150) end` burned a flat 1.5 SECONDS on every
    -- single panel open for those admins and then gave up anyway. Waiting
    -- on the player object instead means we wait only when waiting can
    -- actually change the answer.
    local grpName, grp = PanelGetGroup(source)
    if not grp and GetPlayer and not GetPlayer(source) then
        for _ = 1, 8 do
            Wait(80)                                   -- ≤ 640 ms, not 1500
            if GetPlayer(source) then
                grpName, grp = PanelGetGroup(source)
                break
            end
        end
    end
    local member = PanelGetMember(source)
    local lic    = getLicense(source)

    -- Try the in-memory cache first.
    local avatar = getAvatar(source) or avatarForLicenseEarly(lic)

    -- If we still don't have one, kick off a resolve so the very FIRST open
    -- shows the picture. The old soft cap was `os.time() + 2`, and os.time()
    -- only ticks once a SECOND — so a player whose avatar could not be
    -- resolved (no Steam, private profile, Steam unreachable) paid up to two
    -- full seconds here, on every open, forever, because a "no" was never
    -- remembered. Now the miss is cached, the wait is a short grace period,
    -- and anything slower simply arrives over `panel:avatarReady` a moment
    -- after the panel has already painted.
    if not avatar and not avatarMissed(lic) then
        local resolved, done = nil, false
        ensureAvatar(source, function(url) resolved = url; done = true end)
        local waited = 0
        while not done and waited < 400 do
            Wait(50); waited = waited + 50
        end
        avatar = resolved or getAvatar(source) or steamAvatarCache[lic]
    end

    -- Build a complete avatar snapshot for every player currently
    -- online and ship it back inside the bootstrap response. The NUI
    -- then has every known avatar in its cache *before* the home page
    -- renders, so pictures show up on the very first paint.
    --
    -- For players whose avatar isn't yet resolved, kick off the Steam
    -- lookup in the background — the live `panel:avatarReady` broadcast
    -- (now wired to forward unconditionally on the client) will fill
    -- them in as URLs arrive.
    --
    -- Cache reads only. This loop used to call avatarForLicenseEarly (an
    -- awaited DB query) AND ensureAvatar (an outbound Steam request) for
    -- every player who wasn't cached — so opening the panel on a 30-player
    -- server fired 30 sequential queries and 30 HTTP requests before the
    -- first pixel was drawn. The background resolves are still kicked off,
    -- just AFTER the response has gone out, and only for players we have no
    -- recent answer for.
    local avatarSnapshot = {}
    if lic and avatar then avatarSnapshot[lic] = avatar end

    local toResolve = {}
    for _, p in ipairs(GetPlayers() or {}) do
        local s    = tonumber(p)
        local plic = s and getLicense(s)
        if plic and plic ~= '' then
            local av = steamAvatarCache[plic] or getAvatar(s)
            if av then
                avatarSnapshot[plic] = av
            elseif not avatarMissed(plic) then
                toResolve[#toResolve + 1] = s
            end
        end
    end

    if #toResolve > 0 then
        CreateThread(function()
            for _, s in ipairs(toResolve) do
                if GetPlayerName(s) then _ensureAvatar(s) end
                Wait(150)   -- don't burst Steam with one request per player
            end
        end)
    end

    return {
        allowed         = true,
        -- Shown in the panel's sidebar and printed in F8 on open, so "did
        -- the update actually land?" can be answered from a screenshot.
        version         = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?',
        license         = lic,
        name            = getPlayerLabel(source),
        group           = grpName,
        groupLabel      = grp and grp.label,
        hierarchy       = grp and grp.hierarchy,
        -- The EFFECTIVE list (an ACE-only admin gets the Admin set here, the
        -- same one PanelHasPerm applies), so the Staff page can show the
        -- admin what they themselves hold next to the groups they edit.
        permissions     = PanelEffectivePerms and (PanelEffectivePerms(source)) or (grp and grp.permissions),
        permSource      = PanelEffectivePerms and (select(4, PanelEffectivePerms(source))) or nil,
        -- What the panel may offer, decided here with the same PanelHasPerm
        -- the server gates use. `permissions` above is nil for an ACE-only
        -- admin, so the NUI cannot work this out on its own.
        can             = {
            spectate    = PanelHasPerm(source, 'players.spectate') == true,
            playersRead = PanelHasPerm(source, 'players.read') == true
        },
        avatar          = avatar or (member and member.avatar),
        avatarSnapshot  = avatarSnapshot,
        -- So the Vehicles page can tell "this is the whole list" from
        -- "this is the first page" without guessing at a threshold.
        vehPageSize     = PanelVehiclePageSize and PanelVehiclePageSize() or 250
    }
end)

-- ============================================================
-- HOME — players, weather, time, vehicle delete countdown
-- ============================================================
local nextVehicleDeleteTs = os.time() + (5 * 3600)  -- 5h default

-- ── Server time keeper ─────────────────────────────────────
-- We keep an authoritative in-game clock here so the Home page
-- always shows the same time for every admin and we can broadcast
-- changes to every client. Defaults to current real-world time.
local serverTime = {
    hour    = tonumber(os.date('%H')) or 12,
    minute  = tonumber(os.date('%M')) or 0,
    paused  = false,
    -- Game minutes per real second (default 2 = 1 minute every 30s, like GTA).
    speed   = 2.0
}
local lastTimeTick = os.time()

CreateThread(function()
    while true do
        Wait(1000)
        if not serverTime.paused then
            local now = os.time()
            local elapsed = now - lastTimeTick
            lastTimeTick = now
            local addMinutes = elapsed * serverTime.speed
            local total = serverTime.hour * 60 + serverTime.minute + addMinutes
            total = total % (24 * 60)
            serverTime.hour   = math.floor(total / 60)
            serverTime.minute = math.floor(total % 60)
        end
    end
end)

-- Push clock to every client every 30s (or after a change). Clients
-- can use this to sync their own in-game clock if they wish.
local function broadcastTime()
    TriggerClientEvent('apex_adminmenu:panel:timeSync', -1,
        serverTime.hour, serverTime.minute)
end
CreateThread(function()
    while true do Wait(30000); broadcastTime() end
end)

RegisterNetEvent('apex_adminmenu:panel:setTime', function(hour, minute)
    local src = source
    if not PanelRequire(src, { 'utility.time', 'utility.*' }, 'setTime') then return end
    hour   = tonumber(hour)   or 12
    minute = tonumber(minute) or 0
    if hour < 0 or hour > 23 or minute < 0 or minute > 59 then return end
    serverTime.hour   = hour
    serverTime.minute = minute
    lastTimeTick = os.time()
    broadcastTime()
    PanelLog(src, 'utility', 'set_time', nil, nil, ('%02d:%02d'):format(hour, minute))
end)

RegisterNetEvent('apex_adminmenu:panel:toggleTime', function()
    local src = source
    if not PanelRequire(src, { 'utility.time', 'utility.*' }, 'toggleTime') then return end
    serverTime.paused = not serverTime.paused
    lastTimeTick = os.time()
    PanelLog(src, 'utility', serverTime.paused and 'pause_time' or 'resume_time')
end)

-- ── Server uptime tracking ─────────────────────────────────
-- We record when *this resource* started. Closest practical proxy
-- to "server up time" without poking external monitor APIs. If the
-- resource is restarted alone, the value resets — that's a feature,
-- because it tells admins something just changed.
local serverStartedAt = os.time()

-- Latest in-game clock observed from any client. The GetClock* natives
-- only exist client-side, so we collect them from one of the connected
-- players (any of them — the world clock is synced across the network).
RegisterNetEvent('apex_adminmenu:panel:reportTime', function(h, m)
    h = tonumber(h); m = tonumber(m)
    if not h or not m then return end
    if h < 0 or h > 23 or m < 0 or m > 59 then return end
    serverTime.hour   = h
    serverTime.minute = m
    lastTimeTick      = os.time()
end)

-- Max slots from sv.cfg (sv_maxclients) so we can show "X/Y players".
local function getMaxSlots()
    return GetConvarInt('sv_maxclients', 64)
end

-- ── Home callback ──────────────────────────────────────────
lib.callback.register('apex_adminmenu:panel:home', function(source)
    if not PanelRequire(source, { 'players.read' }, 'home') then return nil end

    local players = {}
    for _, p in ipairs(GetPlayers()) do
        local s = tonumber(p)
        local lic = getLicense(s)
        -- Try every avatar source we have. If still nothing, kick off
        -- an async resolve so the live broadcast will patch any visible
        -- row on the panel as soon as Steam answers.
        local av = getAvatar(s) or avatarForLicenseEarly(lic)
        if not av then ensureAvatar(s) end

        -- Job + staff flag — enables the Home map filters.
        local job, isStaff = nil, false
        if Framework == 'qb' and QBCore then
            local pl = QBCore.Functions.GetPlayer(s)
            if pl and pl.PlayerData and pl.PlayerData.job then
                job = pl.PlayerData.job.name
            end
        elseif ESX then
            local x = ESX.GetPlayerFromId(s)
            if x and x.getJob then job = x.getJob().name end
        end
        if PanelCanOpen and PanelCanOpen(s) then isStaff = true end

        -- Vehicle the player is currently in (if any) so the map can
        -- render a separate vehicle layer. GetVehiclePedIsIn occasionally
        -- returns 0 server-side when the network owner is still the
        -- client, so we also probe with the last-vehicle fallback.
        -- NB: GetDisplayNameFromVehicleModel is client-only — server
        -- side we only have the model hash, so we fall back to the
        -- plate (which IS server-readable) for a human-friendly label.
        local ped = GetPlayerPed(s)
        local vehModel, vehCoords = nil, nil
        if ped and ped ~= 0 then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh == 0 then veh = GetVehiclePedIsIn(ped, true) end    -- last vehicle as fallback
            if veh ~= 0 and DoesEntityExist(veh) then
                local m = GetEntityModel(veh)
                local plate
                local ok = pcall(function() plate = GetVehicleNumberPlateText(veh) end)
                if ok and plate and plate ~= '' then
                    vehModel = plate:gsub('%s+$', '')   -- trim trailing spaces
                else
                    vehModel = ('model_%x'):format(m or 0)
                end
                local c = GetEntityCoords(veh)
                vehCoords = { x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0 }
            end
        end

        players[#players + 1] = {
            id      = s,
            name    = GetPlayerName(s),
            license = lic,
            coords  = getCoords(s),
            ping    = GetPlayerPing(s),
            avatar  = av,
            job     = job,
            isStaff = isStaff,
            vehicle = vehModel,
            vehicleCoords = vehCoords
        }
    end

    return {
        players      = players,
        playerCount  = #players,
        maxSlots     = getMaxSlots(),
        uptime       = os.time() - serverStartedAt,  -- seconds since resource start
        startedAt    = serverStartedAt,
        weather      = { current = 'CLEAR', transition = 0.0, rain = 0.0 },
        time         = {
            hour   = serverTime.hour,
            minute = serverTime.minute,
            paused = serverTime.paused
        },
        vehicleDelete = {
            nextAt = nextVehicleDeleteTs,
            in_    = math.max(0, nextVehicleDeleteTs - os.time())
        }
    }
end)

-- ============================================================
-- HOME — KPI tiles, hourly chart, live alerts
-- ============================================================
-- Rolling buffer of {hour ts, count} samples updated every minute.
-- Chart shows the last 24h (48 samples at 30-min resolution).
local statsHistory = {}              -- circular array of player counts
local STATS_MAX    = 48              -- last 24h at 30-min sampling
local liveAlerts   = {}              -- ring buffer of recent alerts

-- Quick helper used by other parts of the codebase + the homeStats
-- callback. Severity is 'info' | 'success' | 'warning' | 'error'.
function PanelAddAlert(severity, title, message)
    table.insert(liveAlerts, 1, {
        severity = severity or 'info',
        title    = tostring(title or 'Alert'),
        message  = tostring(message or ''),
        time     = os.date('%H:%M'),
        ts       = os.time()
    })
    if #liveAlerts > 30 then liveAlerts[#liveAlerts] = nil end
end

-- Sampler thread — appends a player-count point every 30 minutes.
CreateThread(function()
    Wait(15000)   -- let resources finish booting
    -- Seed with a few zeroes so the chart line shows up immediately.
    for _ = 1, 4 do statsHistory[#statsHistory + 1] = #(GetPlayers() or {}) end
    while true do
        statsHistory[#statsHistory + 1] = #(GetPlayers() or {})
        if #statsHistory > STATS_MAX then table.remove(statsHistory, 1) end
        Wait(30 * 60 * 1000)
    end
end)

-- Hook into existing events to populate alerts.
AddEventHandler('playerDropped', function(reason)
    local src = source
    PanelAddAlert('info', 'Player left',
        (GetPlayerName(src) or 'Unknown') .. ' · ' .. tostring(reason or '?'))
end)

lib.callback.register('apex_adminmenu:panel:homeStats', function(source)
    if not PanelCanOpen(source) then return nil end

    -- Player + staff counts.
    local players = GetPlayers() or {}
    local pCount  = #players
    local staffCount = 0
    for _, p in ipairs(players) do
        local s = tonumber(p)
        if s and PanelCanOpen(s) then staffCount = staffCount + 1 end
    end

    -- New today — count player_stats rows with first_seen >= today.
    local newToday = 0
    local row = safeSingle(
        "SELECT COUNT(*) AS c FROM apex_player_stats WHERE DATE(first_seen) = CURDATE()")
    if row and tonumber(row.c) then newToday = tonumber(row.c) end

    -- Open reports. These live in memory in server/reports.lua — there is
    -- no apex_reports table, so ask the store instead of querying a table
    -- that does not exist (which is why this used to always read 0).
    local openReports = 0
    if ApexOpenReportCount then
        local ok, n = pcall(ApexOpenReportCount)
        if ok and tonumber(n) then openReports = tonumber(n) end
    end

    -- FPS / Memory / CPU — best-effort via GetGameTimer + resource
    -- profile. FiveM's server has no direct CPU API exposed to Lua,
    -- so we approximate from `PerformHttpRequest` health if available
    -- and fall back to nil (UI shows '—').
    local memMB = nil
    local cpuPct = nil
    local fps   = nil
    if GetResourceState and GetResourceMetadata then
        -- Some artifacts expose `getMemorySize` for the resource.
        local ok, mem = pcall(function()
            return collectgarbage('count') / 1024
        end)
        if ok and mem then memMB = mem end
    end

    return {
        players      = pCount,
        maxSlots     = getMaxSlots(),
        staff        = staffCount,
        newToday     = newToday,
        openReports  = openReports,
        fps          = fps,
        memMB        = memMB,
        cpuPct       = cpuPct,
        history      = statsHistory,
        alerts       = liveAlerts
    }
end)

-- Lightweight callback for the global topbar — just the bits it needs,
-- so the panel can poll it cheaply every few seconds.
lib.callback.register('apex_adminmenu:panel:topbar', function(source)
    if not PanelCanOpen(source) then return nil end
    return {
        playerCount = #(GetPlayers() or {}),
        maxSlots    = getMaxSlots(),
        uptime      = os.time() - serverStartedAt,
        time        = { hour = serverTime.hour, minute = serverTime.minute },
        avatar      = getAvatar(source)
    }
end)

-- Server announcement broadcast.
-- Announce — supports a notification type (info/success/warning/error),
-- a target spec (all / staff / job:<name> / id:<n>), a screen position
-- (3x3 grid: top-left, top-center, …, bottom-right), an optional title
-- and duration. Sends a NUI slide-in instead of a basic chat/notify.
RegisterNetEvent('apex_adminmenu:panel:announce', function(payload)
    local src = source
    if not PanelRequire(src, { 'utility.announce', 'utility.*', '*' }, 'announce') then return end

    -- Accept either the legacy "string" form or the new table form.
    local message, kind, target, annTitle, position, duration
    if type(payload) == 'table' then
        message  = tostring(payload.message  or ''):sub(1, 500)
        kind     = tostring(payload.type     or 'info'):lower()
        target   = tostring(payload.target   or 'all'):lower()
        annTitle = tostring(payload.title    or ''):sub(1, 80)
        position = tostring(payload.position or 'top-center')
        duration = tonumber(payload.duration) or 8
    else
        message  = tostring(payload or ''):sub(1, 500)
        kind     = 'info'
        target   = 'all'
        annTitle = ''
        position = 'top-center'
        duration = 8
    end
    if message == '' then return end
    if kind ~= 'info' and kind ~= 'success' and kind ~= 'warning' and kind ~= 'error' then kind = 'info' end
    local validPositions = {
        ['top-left']=true,    ['top-center']=true,    ['top-right']=true,
        ['middle-left']=true, ['middle-center']=true, ['middle-right']=true,
        ['bottom-left']=true, ['bottom-center']=true, ['bottom-right']=true
    }
    if not validPositions[position] then position = 'top-center' end
    duration = math.max(2, math.min(60, duration))

    -- Resolve the receivers list according to the target spec.
    local recipients = nil
    local defaultTitle = 'Announcement'
    if target == 'all' or target == '' then
        recipients = nil   -- nil means broadcast (-1)
    elseif target == 'staff' then
        recipients = {}
        for _, p in ipairs(GetPlayers() or {}) do
            local s = tonumber(p)
            if s and PanelCanOpen(s) then recipients[#recipients + 1] = s end
        end
        defaultTitle = 'Staff Broadcast'
    elseif target:sub(1, 4) == 'job:' then
        local jobName = target:sub(5)
        recipients = {}
        for _, p in ipairs(GetPlayers() or {}) do
            local s = tonumber(p)
            if s then
                local has = false
                if HasGroup then
                    local ok = pcall(function() has = HasGroup(s, jobName) end)
                    if not ok then has = false end
                end
                if has then recipients[#recipients + 1] = s end
            end
        end
        defaultTitle = 'Job Broadcast · ' .. jobName
    elseif target:sub(1, 3) == 'id:' then
        local tid = tonumber(target:sub(4))
        -- `recipients` staying nil means "broadcast to -1". Leaving it nil
        -- here turned a mistyped, blank or offline ID into a SERVER-WIDE
        -- announcement of what the admin believed was a private message.
        -- An empty list is the correct failure mode: send to nobody.
        recipients = {}
        if tid and GetPlayerName(tid) then
            recipients[1] = tid
        else
            TriggerClientEvent('apex_adminmenu:notify', src, 'Announce',
                ('No player online with ID %s — nothing was sent.'):format(tostring(target:sub(4))),
                'error')
            return
        end
        defaultTitle = 'Direct Message'
    end

    if annTitle == '' then annTitle = defaultTitle end

    local payloadOut = {
        title    = annTitle,
        message  = message,
        type     = kind,
        position = position,
        duration = duration
    }

    local sentTo
    if recipients == nil then
        TriggerClientEvent('apex_adminmenu:announceSlide', -1, payloadOut)
        sentTo = ('everyone (%d online)'):format(#(GetPlayers() or {}))
    else
        for _, s in ipairs(recipients) do
            TriggerClientEvent('apex_adminmenu:announceSlide', s, payloadOut)
        end
        sentTo = ('%d player(s)'):format(#recipients)
    end
    -- The panel no longer claims "Announcement sent." on its own; this is
    -- the confirmation, and it only exists when the broadcast really went out.
    TriggerClientEvent('apex_adminmenu:panel:toast', src, 'success',
        ('Announcement sent to %s.'):format(sentTo), 4000)

    PanelLog(src, 'utility', 'announce', nil, nil,
        ('[%s → %s @ %s] %s'):format(kind, target, position, message))
end)

RegisterNetEvent('apex_adminmenu:panel:vehicleDeleteUpdate', function()
    local src = source
    if not PanelRequire(src, { 'vehicles.*' }, 'vehicleDeleteUpdate') then return end
    nextVehicleDeleteTs = os.time() + (5 * 3600)
    PanelLog(src, 'vehicle', 'reset_purge_timer')
    -- Broadcast a cleanup signal to clients so they unspawn idle vehicles.
    TriggerClientEvent('apex_adminmenu:panel:purgeIdleVehicles', -1)
end)

RegisterNetEvent('apex_adminmenu:panel:setWeather', function(weather)
    local src = source
    if not PanelRequire(src, { 'utility.weather' }, 'setWeather') then return end
    weather = tostring(weather or 'CLEAR'):upper()
    TriggerClientEvent('apex_adminmenu:weathersync', -1, weather)
    PanelLog(src, 'utility', 'set_weather', nil, nil, weather)
end)

RegisterNetEvent('apex_adminmenu:panel:revivePlayer', function(targetId)
    local src = source
    if not PanelRequire(src, { 'players.revive', 'players.*' }, 'revivePlayer') then return end
    targetId = tonumber(targetId)
    if not targetId then return end
    ApexRevivePlayer(targetId)
    PanelLog(src, 'player', 'revive', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:teleportTo', function(targetId)
    local src = source
    if not PanelRequire(src, { 'players.teleport', 'players.*' }, 'teleportTo') then return end
    targetId = tonumber(targetId)
    if not targetId then return end
    local ped = GetPlayerPed(targetId)
    if ped == 0 then return end
    local c = GetEntityCoords(ped)
    TriggerClientEvent('apex_adminmenu:reports:teleportTo', src,
        { x = c.x, y = c.y, z = c.z })
    PanelLog(src, 'player', 'tp_to', GetPlayerName(targetId), getLicense(targetId))
end)

-- ============================================================
-- PLAYERS — list, detail
-- ============================================================
lib.callback.register('apex_adminmenu:panel:players', function(source, q, mode)
    if not PanelRequire(source, { 'players.read' }, 'players') then return {} end
    q    = (q    and tostring(q):lower() or '')
    mode = mode or 'online'    -- 'online' | 'offline' | 'all'
    local out = {}

    local online = {}  -- [license] = true so we can dedup
    if mode ~= 'offline' then
        for _, p in ipairs(GetPlayers()) do
            local s = tonumber(p)
            local lic = getLicense(s)
            online[lic] = true
            -- Try every avatar source we have. If still nothing, kick
            -- off an async resolve so the next refresh will have it
            -- (and the live broadcast will patch any visible row).
            local av = getAvatar(s) or avatarForLicenseEarly(lic)
            if not av then ensureAvatar(s) end
            local row = {
                id      = s,
                name    = GetPlayerName(s),
                license = lic,
                ping    = GetPlayerPing(s),
                onDuty  = PanelGetMember(s) ~= nil,
                avatar  = av,
                online  = true
            }
            if q == '' or row.name:lower():find(q, 1, true)
                or row.license:lower():find(q, 1, true) then
                out[#out + 1] = row
            end
        end
    end

    if mode ~= 'online' then
        -- Pull from the framework users table, augmented with playtime.
        local rows = {}
        if Framework == 'qb' then
            rows = safeQuery([[
                SELECT p.license, p.charinfo, p.name,
                       s.last_name, s.playtime, s.last_seen, s.last_login
                FROM players p
                LEFT JOIN apex_player_stats s ON s.license = p.license
                ORDER BY (s.last_seen IS NULL), s.last_seen DESC
                LIMIT 500
            ]])
        else
            rows = safeQuery([[
                SELECT u.identifier AS license, u.firstname, u.lastname,
                       s.last_name, s.playtime, s.last_seen, s.last_login
                FROM users u
                LEFT JOIN apex_player_stats s ON s.license = u.identifier
                ORDER BY (s.last_seen IS NULL), s.last_seen DESC
                LIMIT 500
            ]])
        end
        for _, r in ipairs(rows) do
            local lic = r.license
            if not online[lic] then
                local nm = r.last_name
                if (not nm or nm == '') then
                    if r.firstname then
                        nm = (r.firstname or '') .. ' ' .. (r.lastname or '')
                    elseif r.charinfo then
                        local ok, ci = pcall(json.decode, r.charinfo)
                        if ok and ci then nm = (ci.firstname or '') .. ' ' .. (ci.lastname or '') end
                    end
                end
                nm = (nm and nm:gsub('^%s+', ''):gsub('%s+$', '')) or 'Unknown'
                local row = {
                    id        = nil,
                    name      = nm,
                    license   = lic,
                    avatar    = steamAvatarCache[lic],
                    playtime  = tonumber(r.playtime) or 0,
                    last_seen = r.last_seen,
                    online    = false
                }
                if q == '' or nm:lower():find(q, 1, true)
                    or (lic and lic:lower():find(q, 1, true)) then
                    out[#out + 1] = row
                end
            end
        end
    end

    return out
end)

-- Detail for an OFFLINE player: pull from the framework's users table.
lib.callback.register('apex_adminmenu:panel:playerDetailOffline', function(source, license)
    if not PanelRequire(source, { 'players.read' }, 'playerDetailOffline') then return nil end
    if not license or license == '' then return nil end

    local row, fw = nil, { framework = Framework, accounts = {}, inventory = {} }
    if Framework == 'qb' then
        row = safeSingle([[
            SELECT p.*, s.playtime, s.last_seen, s.last_login, s.sessions
            FROM players p
            LEFT JOIN apex_player_stats s ON s.license = p.license
            WHERE p.license = ? LIMIT 1
        ]], { license })
        if row then
            if row.charinfo then
                local ok, ci = pcall(json.decode, row.charinfo); if ok then fw.charinfo = ci end
            end
            if row.money then
                local ok, m = pcall(json.decode, row.money)
                if ok and type(m) == 'table' then
                    for k, v in pairs(m) do fw.accounts[#fw.accounts + 1] = { name = k, amount = v } end
                end
            end
            if row.job then
                local ok, j = pcall(json.decode, row.job); if ok then fw.job = j end
            end
            if row.gang then
                local ok, g = pcall(json.decode, row.gang); if ok then fw.gang = g end
            end
            if row.inventory then
                local ok, inv = pcall(json.decode, row.inventory)
                if ok and type(inv) == 'table' then
                    for _, it in pairs(inv) do
                        if it and it.name then
                            fw.inventory[#fw.inventory + 1] = {
                                name = it.name, label = it.label, amount = it.amount or it.count
                            }
                        end
                    end
                end
            end
            fw.cid = row.citizenid
        end
    else
        row = safeSingle([[
            SELECT u.*, s.playtime, s.last_seen, s.last_login, s.sessions
            FROM users u
            LEFT JOIN apex_player_stats s ON s.license = u.identifier
            WHERE u.identifier = ? LIMIT 1
        ]], { license })
        if row then
            fw.cid = row.identifier
            fw.charinfo = { firstname = row.firstname, lastname = row.lastname,
                            sex = row.sex, dateofbirth = row.dateofbirth, phone = row.phone_number }
            fw.accounts = {
                { name = 'cash',        amount = row.money },
                { name = 'bank',        amount = row.bank },
                { name = 'black_money', amount = row.black_money }
            }
            if row.job then fw.job = { name = row.job, grade = row.job_grade, label = row.job } end
            if row.inventory then
                local ok, inv = pcall(json.decode, row.inventory)
                if ok and type(inv) == 'table' then
                    for _, it in pairs(inv) do
                        if it and it.name and (it.count or 0) > 0 then
                            fw.inventory[#fw.inventory + 1] = {
                                name = it.name, label = it.label, amount = it.count
                            }
                        end
                    end
                end
            end
        end
    end

    if not row then return nil end

    return {
        id        = nil,
        online    = false,
        license   = license,
        name      = fw.charinfo and ((fw.charinfo.firstname or '') .. ' ' .. (fw.charinfo.lastname or ''))
                 or (row.last_name or 'Unknown'),
        avatar    = steamAvatarCache[license],
        playtime  = tonumber(row.playtime)  or 0,
        last_seen = row.last_seen,
        last_login= row.last_login,
        sessions  = tonumber(row.sessions)  or 0,
        framework = fw,
        flag      = safeSingle('SELECT * FROM apex_player_flags WHERE license = ?', { license }),
        warnings  = safeQuery('SELECT * FROM apex_warnings WHERE target = ? ORDER BY created_at DESC LIMIT 50', { license }),
        bans      = safeQuery('SELECT * FROM apex_bans WHERE license = ? ORDER BY ban_time DESC LIMIT 20', { license }),
        jails     = safeQuery('SELECT * FROM apex_jail WHERE target = ? ORDER BY created_at DESC LIMIT 20', { license }),
        logs      = safeQuery('SELECT * FROM apex_staff_log WHERE target_lic = ? ORDER BY created_at DESC LIMIT 50', { license })
    }
end)

-- Try to gather framework-specific player info (money/job/charinfo/etc).
local function gatherFrameworkInfo(src)
    local out = {
        framework = Framework or 'unknown',
        accounts  = {},
        job       = nil,
        gang      = nil,
        charinfo  = nil,
        inventory = {},
        cid       = nil
    }

    if Framework == 'qb' and QBCore then
        local p = QBCore.Functions.GetPlayer(src)
        if p and p.PlayerData then
            local d = p.PlayerData
            out.cid = d.citizenid
            out.charinfo = d.charinfo
            out.job      = d.job
            out.gang     = d.gang
            -- Money buckets
            for name, amount in pairs(d.money or {}) do
                out.accounts[#out.accounts + 1] = { name = name, amount = amount }
            end
            -- Metadata picks
            out.metadata = {
                health = d.metadata and d.metadata.health,
                armor  = d.metadata and d.metadata.armor,
                hunger = d.metadata and d.metadata.hunger,
                thirst = d.metadata and d.metadata.thirst,
                stress = d.metadata and d.metadata.stress,
            }
            -- Inventory (qb-inventory players store it in PlayerData.items)
            for _, it in ipairs(d.items or {}) do
                if it and it.name then
                    out.inventory[#out.inventory + 1] = {
                        name = it.name, label = it.label, amount = it.amount or it.count
                    }
                end
            end
        end
    elseif Framework == 'esx' and ESX then
        local p = ESX.GetPlayerFromId(src)
        if p then
            out.cid = p.identifier
            out.job = p.job
            for _, acc in ipairs(p.getAccounts() or {}) do
                out.accounts[#out.accounts + 1] = { name = acc.name, amount = acc.money }
            end
            for _, it in ipairs(p.getInventory() or {}) do
                if (it.count or 0) > 0 then
                    out.inventory[#out.inventory + 1] = {
                        name = it.name, label = it.label, amount = it.count
                    }
                end
            end
        end
    end

    -- ox_inventory override (more accurate when used).
    if GetResourceState('ox_inventory') == 'started' then
        local ok, inv = pcall(function() return exports.ox_inventory:GetInventoryItems(src) end)
        if ok and type(inv) == 'table' then
            out.inventory = {}
            for _, it in pairs(inv) do
                if it and it.name and (it.count or 0) > 0 then
                    out.inventory[#out.inventory + 1] = {
                        name = it.name, label = it.label or it.name, amount = it.count
                    }
                end
            end
        end
    end

    table.sort(out.inventory, function(a, b) return (a.label or a.name) < (b.label or b.name) end)
    return out
end

lib.callback.register('apex_adminmenu:panel:playerDetail', function(source, targetId)
    if not PanelHasPerm(source, 'players.read') then
        print(('^3[apex_adminmenu]^7 playerDetail denied for %s (no perm)'):format(source))
        return nil
    end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        print(('^3[apex_adminmenu]^7 playerDetail bad target: %s'):format(tostring(targetId)))
        return nil
    end

    -- Wrap the whole thing in pcall so a single missing framework helper
    -- (e.g. PlayerData being nil on a slot 0 ESX session) cannot break
    -- the callback and leave the UI with "Could not load player detail".
    local ok, result = pcall(function()
        local lic    = getLicense(targetId)
        -- Make sure we resolve the Steam avatar synchronously here. The
        -- detail screen is the primary place where we'd want the photo
        -- visible right away, so we wait up to 2s for a hit.
        if lic and not steamAvatarCache[lic] then
            local resolved, done = nil, false
            ensureAvatar(targetId, function(url) resolved = url; done = true end)
            local deadline = os.time() + 2
            while not done and os.time() < deadline do Wait(50) end
        end
        local ped    = GetPlayerPed(targetId)
        local coords = ped ~= 0 and GetEntityCoords(ped) or vector3(0,0,0)
        local heading = ped ~= 0 and GetEntityHeading(ped) or 0.0
        local hp      = ped ~= 0 and (GetEntityHealth(ped) - 100) or 0
        local armor   = ped ~= 0 and GetPedArmour(ped) or 0
        local veh     = ped ~= 0 and GetVehiclePedIsIn(ped, false) or 0
        local vehLabel = nil
        if veh ~= 0 then
            -- GetDisplayNameFromVehicleModel is client-only; on the
            -- server we use the plate (or model hash as a last resort)
            -- as the human-readable label.
            local plate
            local okp = pcall(function() plate = GetVehicleNumberPlateText(veh) end)
            if okp and plate and plate ~= '' then
                vehLabel = plate:gsub('%s+$', '')
            else
                vehLabel = ('model_%x'):format(GetEntityModel(veh) or 0)
            end
        end

        -- Split identifiers into a friendly map.
        local idMap = {}
        for _, id in ipairs(GetPlayerIdentifiers(targetId) or {}) do
            local prefix = id:match('^([^:]+):')
            if prefix then idMap[prefix] = id end
        end

        local stats = safeSingle('SELECT * FROM apex_player_stats WHERE license = ?', { lic }) or {}
        local live  = sessionStart[targetId] and (os.time() - sessionStart[targetId]) or 0

        -- Defensive: framework gather can be the source of nil errors.
        local fwOK, fw = pcall(gatherFrameworkInfo, targetId)
        if not fwOK then
            print(('^1[apex_adminmenu]^7 gatherFrameworkInfo failed for %s: %s')
                :format(targetId, tostring(fw)))
            fw = { framework = Framework or 'unknown', accounts = {}, inventory = {} }
        end

        return {
            id       = targetId,
            online   = true,
            name     = GetPlayerName(targetId),
            license  = lic,
            avatar   = getAvatar(targetId) or avatarForLicenseEarly(lic),
            ping     = GetPlayerPing(targetId),
            playtime = (tonumber(stats.playtime) or 0) + live,
            first_seen = stats.first_seen,
            last_login = stats.last_login,
            sessions = tonumber(stats.sessions) or 0,
            coords   = { x = coords.x, y = coords.y, z = coords.z },
            heading  = heading,
            health   = math.max(0, hp),
            armor    = armor,
            vehicle  = vehLabel,
            identifiers = GetPlayerIdentifiers(targetId),
            ids      = idMap,
            framework   = fw,
            flag     = safeSingle('SELECT * FROM apex_player_flags WHERE license = ?', { lic }),
            warnings = safeQuery('SELECT * FROM apex_warnings WHERE target = ? ORDER BY created_at DESC LIMIT 50', { lic }),
            bans     = safeQuery('SELECT * FROM apex_bans WHERE license = ? ORDER BY ban_time DESC LIMIT 20', { lic }),
            jails    = safeQuery('SELECT * FROM apex_jail WHERE target = ? ORDER BY created_at DESC LIMIT 20', { lic }),
            logs     = safeQuery('SELECT * FROM apex_staff_log WHERE target_lic = ? ORDER BY created_at DESC LIMIT 50', { lic })
        }
    end)

    if not ok then
        print(('^1[apex_adminmenu]^7 playerDetail crashed for %s: %s'):format(targetId, tostring(result)))
        -- Minimal payload so the UI still renders something instead of error.
        return {
            id      = targetId,
            online  = true,
            name    = GetPlayerName(targetId) or 'Unknown',
            license = getLicense(targetId),
            avatar  = getAvatar(targetId),
            ping    = GetPlayerPing(targetId),
            framework = { framework = Framework or 'unknown', accounts = {}, inventory = {} },
            warnings = {}, bans = {}, jails = {}, logs = {},
            error   = tostring(result)
        }
    end
    return result
end)

-- ── More actions (give money / item / spectate / freeze / kick / heal / bring) ──
RegisterNetEvent('apex_adminmenu:panel:bringPlayer', function(targetId)
    local src = source
    if not PanelRequire(src, { 'players.teleport', 'players.*' }, 'bringPlayer') then return end
    targetId = tonumber(targetId)
    local adminPed = GetPlayerPed(src)
    if adminPed == 0 then return end
    local c = GetEntityCoords(adminPed)
    TriggerClientEvent('apex_adminmenu:reports:teleportTo', targetId, { x = c.x, y = c.y, z = c.z })
    PanelLog(src, 'player', 'bring', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:healPlayer', function(targetId)
    local src = source
    if not PanelRequire(src, { 'players.*', 'players.heal' }, 'healPlayer') then return end
    ApexHealPlayer(targetId)
    PanelLog(src, 'player', 'heal', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:freezePlayer', function(targetId, state)
    local src = source
    if not PanelRequire(src, { 'players.*', 'players.freeze' }, 'freezePlayer') then return end
    TriggerClientEvent('apex_adminmenu:setPlayerFrozen', -1, tonumber(targetId), state and true or false)
    PanelLog(src, 'player', state and 'freeze' or 'unfreeze', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:spectatePlayer', function(targetId)
    local src = source
    if not PanelHasPerm(src, 'players.spectate') then
        -- The keybind lands here too, where a silent refusal looked broken.
        TriggerClientEvent('apex_adminmenu:notify', src, 'Spectate',
            'Your staff group needs the players.spectate permission.', 'error')
        return
    end
    TriggerClientEvent('apex_adminmenu:panel:beginSpectate', src, tonumber(targetId))
    PanelLog(src, 'player', 'spectate', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:kickPlayer', function(targetId, reason)
    local src = source
    if not PanelRequire(src, { 'moderation.kick', 'moderation.*' }, 'kickPlayer') then return end
    targetId = tonumber(targetId)
    if not targetId then return end
    PanelLog(src, 'moderation', 'kick', GetPlayerName(targetId), getLicense(targetId), reason)
    DropPlayer(targetId, reason or 'Kicked by staff')
end)

RegisterNetEvent('apex_adminmenu:panel:giveMoneyTo', function(targetId, account, amount)
    local src = source
    if not PanelRequire(src, { 'money.give', 'players.*' }, 'giveMoneyTo') then return end
    targetId, amount = tonumber(targetId), tonumber(amount)
    if not targetId or not amount or amount <= 0 then return end
    if AddMoney then AddMoney(targetId, account or 'bank', amount) end
    PanelLog(src, 'money', 'give', GetPlayerName(targetId), getLicense(targetId),
        ('%s %d'):format(account or 'bank', amount))
end)

RegisterNetEvent('apex_adminmenu:panel:giveItemTo', function(targetId, item, amount)
    local src = source
    if not PanelRequire(src, { 'items.give', 'players.*' }, 'giveItemTo') then return end
    targetId, amount = tonumber(targetId), tonumber(amount) or 1
    if not targetId or not item or item == '' then return end
    if AddItem then AddItem(targetId, item, amount) end
    PanelLog(src, 'money', 'give_item', GetPlayerName(targetId), getLicense(targetId),
        ('%s x%d'):format(item, amount))
end)

-- Assign a framework job (+ grade) to a player from the Jobs page.
RegisterNetEvent('apex_adminmenu:panel:setPlayerJob', function(targetId, jobName, grade)
    local src = source
    if not PanelRequire(src, { 'players.*', 'jobs.*' }, 'setPlayerJob') then return end
    targetId, grade = tonumber(targetId), tonumber(grade) or 0
    if not targetId or not jobName or jobName == '' then return end
    if not GetPlayerName(targetId) then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Jobs', 'That player is no longer online.', 'error')
        return
    end
    if not SetJob then return end

    -- The framework can refuse the pair (ESX validates job+grade against its
    -- own table). It used to do that silently, leaving a console warning and
    -- an admin who had no idea the change never happened.
    local ok, reason = SetJob(targetId, jobName, grade)
    if ok == false then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Jobs',
            reason or ('Could not set %s to grade %d.'):format(jobName, grade), 'error')
        return
    end

    TriggerClientEvent('apex_adminmenu:notify', src, 'Jobs',
        ('%s → %s (grade %d)'):format(GetPlayerName(targetId) or targetId, jobName, grade), 'success')
    PanelLog(src, 'players', 'set_job', GetPlayerName(targetId), getLicense(targetId),
        ('%s (grade %d)'):format(jobName, grade))
end)

-- ── Extra player actions wired by the panel profile ───────────
RegisterNetEvent('apex_adminmenu:panel:removeItemFrom', function(targetId, item, amount)
    local src = source
    if not PanelRequire(src, { 'items.give', 'players.*' }, 'removeItemFrom') then return end
    targetId, amount = tonumber(targetId), tonumber(amount) or 1
    if not targetId or not item or item == '' then return end
    if RemoveItem then RemoveItem(targetId, item, amount) end
    PanelLog(src, 'money', 'remove_item', GetPlayerName(targetId), getLicense(targetId),
        ('%s x%d'):format(item, amount))
end)

RegisterNetEvent('apex_adminmenu:panel:giveWeaponTo', function(targetId, weapon, ammo)
    local src = source
    if not PanelRequire(src, { 'items.give', 'players.*' }, 'giveWeaponTo') then return end
    targetId = tonumber(targetId)
    if not targetId or not weapon or weapon == '' then return end
    ammo = tonumber(ammo) or 100
    TriggerClientEvent('apex_adminmenu:giveWeapon', targetId, weapon, ammo)
    PanelLog(src, 'player', 'give_weapon', GetPlayerName(targetId), getLicense(targetId),
        ('%s x%d'):format(weapon, ammo))
end)

RegisterNetEvent('apex_adminmenu:panel:setHealthOf', function(targetId, hp)
    local src = source
    if not PanelRequire(src, { 'players.*', 'players.heal' }, 'setHealthOf') then return end
    targetId, hp = tonumber(targetId), tonumber(hp)
    if not targetId or not hp then return end
    TriggerClientEvent('apex_adminmenu:setHealth', targetId, math.max(0, math.min(200, hp)))
    PanelLog(src, 'player', 'set_health', GetPlayerName(targetId), getLicense(targetId), tostring(hp))
end)

RegisterNetEvent('apex_adminmenu:panel:setArmorOf', function(targetId, ar)
    local src = source
    if not PanelRequire(src, { 'players.*', 'players.heal' }, 'setArmorOf') then return end
    targetId, ar = tonumber(targetId), tonumber(ar)
    if not targetId or not ar then return end
    TriggerClientEvent('apex_adminmenu:setArmor', targetId, math.max(0, math.min(100, ar)))
    PanelLog(src, 'player', 'set_armor', GetPlayerName(targetId), getLicense(targetId), tostring(ar))
end)

RegisterNetEvent('apex_adminmenu:panel:fixVehicleOf', function(targetId)
    local src = source
    if not PanelRequire(src, { 'vehicles.*', 'vehicles.fix' }, 'fixVehicleOf') then return end
    targetId = tonumber(targetId)
    if not targetId then return end
    TriggerClientEvent('apex_adminmenu:fixVehicle', targetId)
    PanelLog(src, 'vehicle', 'fix', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:cleanVehicleOf', function(targetId)
    local src = source
    if not PanelRequire(src, { 'vehicles.*', 'vehicles.fix' }, 'cleanVehicleOf') then return end
    targetId = tonumber(targetId)
    if not targetId then return end
    TriggerClientEvent('apex_adminmenu:cleanVehicle', targetId)
    PanelLog(src, 'vehicle', 'clean', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:spawnVehicleFor', function(targetId, model)
    local src = source
    if not PanelRequire(src, { 'vehicles.*', 'vehicles.spawn' }, 'spawnVehicleFor') then return end
    targetId = tonumber(targetId)
    if not targetId or not model or model == '' then return end
    TriggerClientEvent('apex_adminmenu:spawnVehicleForTarget', targetId, model)
    PanelLog(src, 'vehicle', 'spawn_for', GetPlayerName(targetId), getLicense(targetId), tostring(model))
end)

RegisterNetEvent('apex_adminmenu:panel:respawnPlayer', function(targetId)
    local src = source
    if not PanelRequire(src, { 'players.*', 'players.revive' }, 'respawnPlayer') then return end
    targetId = tonumber(targetId)
    if not targetId then return end
    TriggerClientEvent('apex_adminmenu:respawn', targetId)
    PanelLog(src, 'player', 'respawn', GetPlayerName(targetId), getLicense(targetId))
end)

-- ============================================================
-- Spectate stream — admin asks server to ask target client to
-- start sending a small frame of its screen (Config.Monitoring,
-- ~2 per second) and forward each one to the watching admins. Pure
-- peer-to-peer via server-events; no media backends needed.
-- ============================================================
-- [targetId] = { watchers = { [adminSrc] = true }, web = bool, lastFrameAt, startedAt }
-- `web` is the browser panel (server/webpanel.lua) watching this target;
-- it rides the same capture loop as the in-game admins.
local specStreams = {}

local PANEL_NO_WATCH_PERM = 'Your staff group needs the players.spectate permission to watch screens.'

-- A stream with no watchers left must die, whatever removed the last
-- one: the tile's close button, the panel closing, or the admin
-- dropping. Leaving it alive is what kept the target capturing and
-- uploading a frame every 1.5s to nobody until their link gave out.
local function collapseIfEmpty(targetId)
    local s = specStreams[targetId]
    if not s or next(s.watchers) ~= nil or s.web then return end
    specStreams[targetId] = nil
    if GetPlayerName(targetId) then
        TriggerClientEvent('apex_adminmenu:panel:specEnd', targetId)
    end
end

-- The first frame crosses two latent hops at 200KB/s, so the old 5s
-- deadline expired on perfectly healthy streams above 1080p — and then
-- blamed a dependency that was running fine. The target now reports a
-- failed capture itself (panel:specUnavailable), which leaves this
-- timer to say only what it can actually know: nothing arrived.
local FIRST_FRAME_GRACE_MS = 15000

-- The stream record for a target, starting the target's capture loop
-- the first time anyone asks. nil when the target is not online.
local function ensureStream(targetId)
    if not targetId or not GetPlayerName(targetId) then return nil end
    local s = specStreams[targetId]
    if s then return s end
    s = { watchers = {}, web = false, lastFrameAt = 0, startedAt = os.time() }
    specStreams[targetId] = s
    TriggerClientEvent('apex_adminmenu:panel:specBegin', targetId)
    SetTimeout(FIRST_FRAME_GRACE_MS, function()
        local cur = specStreams[targetId]
        if cur and cur.lastFrameAt == 0 then
            local msg = 'No frames yet — the target\'s upload may be too slow to keep up'
            for ws in pairs(cur.watchers) do
                TriggerClientEvent('apex_adminmenu:panel:specError', ws, targetId, msg)
            end
            if cur.web and PanelRelayWatchNotice then PanelRelayWatchNotice(targetId, msg) end
        end
    end)
    return s
end

local function startStreamFor(adminSrc, targetId)
    local s = ensureStream(targetId)
    if not s then return end
    s.watchers[adminSrc] = true
end
local function stopStreamFor(adminSrc, targetId)
    local s = specStreams[targetId]; if not s then return end
    s.watchers[adminSrc] = nil
    collapseIfEmpty(targetId)
end

-- The browser panel's Live Watch (server/webpanel.lua). The panel has
-- already authenticated the admin, so there is no per-source permission
-- to check here; the relay's startWatch command is the gate.
function PanelWebWatchStart(targetId)
    targetId = tonumber(targetId)
    local s = ensureStream(targetId)
    if not s then return false, 'That player is no longer online.' end
    s.web = true
    return true
end
function PanelWebWatchStop(targetId)
    targetId = tonumber(targetId)
    local s = specStreams[targetId]; if not s then return end
    s.web = false
    collapseIfEmpty(targetId)
end

RegisterNetEvent('apex_adminmenu:panel:startSpectateStream', function(targetId)
    local src = source
    targetId = tonumber(targetId)
    -- Watching a player's screen is its own permission: players.spectate
    -- ('*' and 'players.*' include it), the same one in-game Spectate and
    -- Screenshot use. It used to accept players.read as well, so every
    -- group that could open the Players page could also watch screens,
    -- with no way to allow the one without the other.
    if not PanelHasPerm(src, 'players.spectate') then
        if targetId then
            TriggerClientEvent('apex_adminmenu:panel:specError', src, targetId, PANEL_NO_WATCH_PERM)
        end
        return
    end
    if not targetId or not GetPlayerName(targetId) then
        print(('[apex_adminmenu] spectate target %s is not online'):format(tostring(targetId)))
        return
    end
    print(('[apex_adminmenu] spectate: admin %s -> target %s'):format(src, targetId))
    startStreamFor(src, targetId)
    PanelLog(src, 'player', 'spectate_start', GetPlayerName(targetId), getLicense(targetId))
end)

RegisterNetEvent('apex_adminmenu:panel:stopSpectateStream', function(targetId)
    stopStreamFor(source, tonumber(targetId))
end)

-- The target says it cannot capture at all. Reporting it here is honest;
-- inferring it from a silent 5s window was not.
RegisterNetEvent('apex_adminmenu:panel:specUnavailable', function()
    local target = source
    local s = specStreams[target]; if not s then return end
    local msg = 'That player\'s game cannot capture its screen (start screenshot-basic as a fallback)'
    for adminSrc in pairs(s.watchers) do
        -- The target tried its own NUI capture first; this only fires when
        -- that failed AND screenshot-basic is missing too.
        TriggerClientEvent('apex_adminmenu:panel:specError', adminSrc, target, msg)
    end
    if s.web then
        s.web = false
        if PanelRelayWatchEnd then PanelRelayWatchEnd(target, msg) end
        collapseIfEmpty(target)
    end
end)

-- Target client posts a frame; relay it to every watching admin.
RegisterNetEvent('apex_adminmenu:panel:specFrame', function(dataUri)
    local target = source
    local s = specStreams[target]; if not s then return end
    if type(dataUri) ~= 'string' then return end
    if #dataUri > 1500000 then
        -- Dropping this in silence read as "no frames" forever. Say it,
        -- and still ack so the target is not left waiting for one.
        local msg = 'Frame too large to relay — that player is running a very high resolution'
        for adminSrc in pairs(s.watchers) do
            TriggerClientEvent('apex_adminmenu:panel:specError', adminSrc, target, msg)
        end
        if s.web and PanelRelayWatchNotice then PanelRelayWatchNotice(target, msg) end
        TriggerClientEvent('apex_adminmenu:panel:specAck', target)
        return
    end
    s.lastFrameAt = os.time()
    for adminSrc in pairs(s.watchers) do
        -- Latent so the network doesn't trip on the larger payload. Faster
        -- than the target's 300 KB/s upload, so this leg drains quicker
        -- than the ack-paced upload can fill it.
        TriggerLatentClientEvent('apex_adminmenu:panel:specFrame', adminSrc, 400 * 1024,
            target, dataUri)
    end
    -- The browser panel gets the newest frame on the next relay heartbeat.
    if s.web and PanelRelayWatchFrame then PanelRelayWatchFrame(target, dataUri) end
    -- Closes the loop: the target captures again only once this frame has
    -- actually landed, so the send queue can never outrun the link and
    -- time the player out.
    TriggerClientEvent('apex_adminmenu:panel:specAck', target)
end)

AddEventHandler('playerDropped', function()
    local src = source
    -- Clean up any streams either side.
    if specStreams[src] then
        for adminSrc in pairs(specStreams[src].watchers) do
            -- specError closes the ADMIN's tile. specEnd is the
            -- target-side "stop capturing" signal and has no business
            -- going to a watcher — sending it here decremented that
            -- admin's own capture counter instead.
            TriggerClientEvent('apex_adminmenu:panel:specError', adminSrc, src,
                'Player disconnected')
        end
        if specStreams[src].web and PanelRelayWatchEnd then
            PanelRelayWatchEnd(src, 'Player disconnected')
        end
        specStreams[src] = nil
    end
    for tgt, s in pairs(specStreams) do
        if s.watchers[src] then
            s.watchers[src] = nil
            -- Without this the stream outlived the admin who opened it:
            -- the target kept uploading, and the leftover entry made
            -- every later attempt on that player start dead.
            collapseIfEmpty(tgt)
        end
    end
end)

-- ============================================================
-- Playtime / sessions tracker
-- Records first_seen, last_seen and accumulates `playtime` (seconds)
-- per license. A row is inserted on join and updated periodically
-- + on drop with the elapsed time delta.
-- ============================================================
-- sessionStart was hoisted earlier as a global so playerDetail can use it.

local function bumpPlaytime(src, finalize)
    local lic = getLicense(src)
    if not lic or lic == '' then return end
    local started = sessionStart[src]
    if not started then return end
    local now = os.time()
    local delta = now - started
    if delta < 0 then delta = 0 end
    sessionStart[src] = finalize and nil or now

    pcall(function()
        MySQL.insert(
            [[INSERT INTO apex_player_stats (license, last_name, playtime, last_seen, last_login, sessions)
              VALUES (?, ?, ?, FROM_UNIXTIME(?), FROM_UNIXTIME(?), 0)
              ON DUPLICATE KEY UPDATE
                  last_name = VALUES(last_name),
                  playtime  = playtime + VALUES(playtime),
                  last_seen = VALUES(last_seen)]],
            { lic, GetPlayerName(src) or '', delta, now, started }
        )
    end)
end

AddEventHandler('playerJoining', function()
    local src = source
    sessionStart[src] = os.time()
    SetTimeout(2000, function()
        local lic = getLicense(src)
        if not lic or lic == '' then return end
        pcall(function()
            MySQL.insert(
                [[INSERT INTO apex_player_stats (license, last_name, last_login, sessions)
                  VALUES (?, ?, FROM_UNIXTIME(?), 1)
                  ON DUPLICATE KEY UPDATE
                      last_name  = VALUES(last_name),
                      last_login = VALUES(last_login),
                      sessions   = sessions + 1]],
                { lic, GetPlayerName(src) or '', os.time() }
            )
        end)
        -- Mirror player joins to Discord on the `login` webhook so
        -- ops can see who's coming online in real time.
        if PanelDiscordSend then
            PanelDiscordSend('login', {
                title       = '🟢 Player joined',
                description = ('**%s** connected.'):format(GetPlayerName(src) or '?'),
                color       = 0x34C77B,
                fields      = {
                    { name = 'Server ID', value = tostring(src),    inline = true },
                    { name = 'License',   value = ('`%s`'):format(lic), inline = true }
                },
                timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
            })
        end
    end)
end)

-- Mirror player drops too — useful for moderation timelines.
AddEventHandler('playerDropped', function(reason)
    local src = source
    if not PanelDiscordSend then return end
    local lic = getLicense(src) or ''
    PanelDiscordSend('login', {
        title       = '🔴 Player left',
        description = ('**%s** disconnected.'):format(GetPlayerName(src) or '?'),
        color       = 0xE5564B,
        fields      = {
            { name = 'Server ID', value = tostring(src),    inline = true },
            { name = 'License',   value = ('`%s`'):format(lic), inline = true },
            { name = 'Reason',    value = tostring(reason or 'unknown'), inline = false }
        },
        timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
    })
end)

-- Periodic flush so admins see accurate playtime even mid-session.
CreateThread(function()
    while true do
        Wait(60000)
        for _, p in ipairs(GetPlayers()) do bumpPlaytime(tonumber(p), false) end
    end
end)

AddEventHandler('playerDropped', function()
    bumpPlaytime(source, true)
end)

-- ============================================================
-- Steam avatar resolver (cache itself is hoisted earlier in the file).
-- ============================================================
local function steamHexToSteamID64(hex)
    if not hex or hex == '' then return nil end
    local raw = hex:gsub('steam:', '')
    local id = tonumber(raw, 16)
    return id and tostring(id) or nil
end

local getSteamHex = getSteamHexEarly

-- Tiny base64 encoder. We only need to encode, not decode, so this is
-- intentionally trivial (and avoids pulling in a dependency).
local B64_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64Encode(data)
    if not data or data == '' then return '' end
    local out = {}
    local len = #data
    local i = 1
    while i <= len do
        local b1 = string.byte(data, i)     or 0
        local b2 = string.byte(data, i + 1) or 0
        local b3 = string.byte(data, i + 2) or 0
        local trip = b1 * 65536 + b2 * 256 + b3
        local c1 = math.floor(trip / 262144) % 64
        local c2 = math.floor(trip / 4096)   % 64
        local c3 = math.floor(trip / 64)     % 64
        local c4 = trip                      % 64
        out[#out + 1] = B64_ALPHABET:sub(c1 + 1, c1 + 1)
        out[#out + 1] = B64_ALPHABET:sub(c2 + 1, c2 + 1)
        out[#out + 1] = (i + 1 <= len) and B64_ALPHABET:sub(c3 + 1, c3 + 1) or '='
        out[#out + 1] = (i + 2 <= len) and B64_ALPHABET:sub(c4 + 1, c4 + 1) or '='
        i = i + 3
    end
    return table.concat(out)
end

-- Guess the data: MIME type from the file extension in the URL. Steam
-- mostly serves JPGs; fall back to jpeg if unknown.
local function mimeFromUrl(url)
    local ext = (url or ''):match('%.([A-Za-z0-9]+)$')
    if not ext then return 'image/jpeg' end
    ext = ext:lower()
    if ext == 'png'  then return 'image/png'  end
    if ext == 'gif'  then return 'image/gif'  end
    if ext == 'webp' then return 'image/webp' end
    return 'image/jpeg'
end

-- Persist a steam→url pair to the in-memory cache AND the DB. The
-- optional `b64` argument is the inline base64 data URI we'll prefer
-- for serving to the panel (so the UI never has to talk to Steam).
local function persistAvatar(key, url, b64)
    if not key or key == '' then return end
    if not url or url == '' then return end
    steamAvatarCache[key] = b64 or url    -- prefer the data URI in memory
    pcall(function()
        if b64 and b64 ~= '' then
            MySQL.insert(
                'INSERT INTO apex_steam_avatars (steam, avatar, avatar_b64) VALUES (?, ?, ?) '
             .. 'ON DUPLICATE KEY UPDATE avatar = VALUES(avatar), avatar_b64 = VALUES(avatar_b64)',
                { key, url, b64 }
            )
        else
            MySQL.insert(
                'INSERT INTO apex_steam_avatars (steam, avatar) VALUES (?, ?) '
             .. 'ON DUPLICATE KEY UPDATE avatar = VALUES(avatar)',
                { key, url }
            )
        end
    end)
end

-- Downloads the bytes of an image URL and returns a base64 data URI.
-- Calls cb(dataUri) on success, cb(nil) on failure. The Steam CDN
-- responds with the raw image bytes when fetched without an Accept
-- header, so PerformHttpRequest's body parameter is the binary blob.
local function downloadAndBase64(url, cb)
    if not url or url == '' then return cb(nil) end
    PerformHttpRequest(url, function(status, body, _)
        if status ~= 200 or not body or body == '' then return cb(nil) end
        local enc = base64Encode(body)
        if not enc or enc == '' then return cb(nil) end
        cb(('data:%s;base64,%s'):format(mimeFromUrl(url), enc))
    end, 'GET', '', {
        ['User-Agent'] = 'Mozilla/5.0 apex_adminmenu',
        -- Critical: ask for any content type. Some FiveM versions
        -- default to text/plain which breaks binary downloads.
        ['Accept']     = '*/*'
    })
end

-- Steam Web API (no auth) → public XML profile.
-- The endpoint occasionally times out / returns 429, so we retry with
-- a small back-off and fall back to a community URL pattern that
-- (almost) always serves a default-avatar image keyed by steamID.
local STEAM_DEFAULT = 'https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg'

local function fetchSteamAvatar(steam64, cb, attempt)
    attempt = attempt or 1
    PerformHttpRequest(
        ('https://steamcommunity.com/profiles/%s?xml=1'):format(steam64),
        function(status, body, _)
            local url
            if status == 200 and body then
                url = body:match('<avatarFull>%s*<!%[CDATA%[(.-)%]%]>%s*</avatarFull>')
                   or body:match('<avatarMedium>%s*<!%[CDATA%[(.-)%]%]>%s*</avatarMedium>')
                   or body:match('<avatarIcon>%s*<!%[CDATA%[(.-)%]%]>%s*</avatarIcon>')
            end
            if url and url ~= '' then return cb(url) end

            -- Retry up to 3 times with back-off for transient failures.
            if attempt < 3 then
                SetTimeout(2000 * attempt, function()
                    fetchSteamAvatar(steam64, cb, attempt + 1)
                end)
            else
                -- Always give them SOMETHING. Steam's default avatar URL.
                cb(STEAM_DEFAULT)
            end
        end,
        'GET', '',
        { ['User-Agent'] = 'Mozilla/5.0 apex_adminmenu' }
    )
end

-- Push the avatar to every admin currently online so their UI refreshes.
-- (Reassigns the up-value declared near the top of the file so any code
-- that ran before this point — bootstrap, sweep — also picks up the
-- real implementation.)
broadcastAvatar = function(license, url)
    if not license or license == '' or not url or url == '' then return end
    TriggerClientEvent('apex_adminmenu:panel:avatarReady', -1, license, url)
end

-- Resolves the avatar for a given player source. Steps:
--   1. In-memory cache hit (steam hex OR license).
--   2. DB cache hit.
--   3. Steam Web XML lookup (with retries + steam default fallback).
-- NB: reassigning the up-value `ensureAvatar` that was hoisted near
-- the top of the file so callbacks higher up can use it.
ensureAvatar = function(src, cb)
    cb = cb or function() end
    if not src or src == 0 then return cb(nil) end
    local hex = getSteamHex(src)
    local lic = getLicense(src)

    -- 1) Memory cache (by hex OR license — whichever populated first).
    if hex and steamAvatarCache[hex] then return cb(steamAvatarCache[hex]) end
    if lic and steamAvatarCache[lic] then return cb(steamAvatarCache[lic]) end

    -- 1b) A recent "no". Every step below this line costs either a DB
    --     round-trip or an outbound HTTP request, and re-paying that for a
    --     player who simply has no Steam profile — on every panel open, for
    --     the whole session — is what made the panel feel like it hung.
    if avatarMissed(hex) or avatarMissed(lic) then return cb(nil) end

    -- 2) DB cache — prefer the base64 data URI (avatar_b64). Falls
    --    back to the remote URL only if the bytes weren't cached yet.
    local row
    if hex then row = safeSingle('SELECT avatar, avatar_b64 FROM apex_steam_avatars WHERE steam = ?', { hex }) end
    if (not row) and lic ~= '' then
        row = safeSingle('SELECT avatar, avatar_b64 FROM apex_steam_avatars WHERE steam = ?', { lic })
    end
    if row then
        local cached = (row.avatar_b64 and row.avatar_b64 ~= '') and row.avatar_b64
                    or (row.avatar and row.avatar ~= '' and row.avatar)
                    or nil
        if cached then
            if hex then steamAvatarCache[hex] = cached; clearAvatarMiss(hex) end
            if lic then steamAvatarCache[lic] = cached; clearAvatarMiss(lic) end
            -- Back-fill the base64 column lazily — if we only had the
            -- URL, download the bytes now so future lookups are local.
            if (not row.avatar_b64 or row.avatar_b64 == '') and row.avatar and row.avatar ~= '' then
                downloadAndBase64(row.avatar, function(b64)
                    if b64 then
                        if hex then persistAvatar(hex, row.avatar, b64) end
                        if lic then persistAvatar(lic, row.avatar, b64) end
                        broadcastAvatar(lic, b64)
                    end
                end)
            end
            return cb(cached)
        end
    end

    -- 3) Steam Web XML → download bytes → base64 data URI.
    if hex then
        local id64 = steamHexToSteamID64(hex)
        if id64 then
            return fetchSteamAvatar(id64, function(url)
                if not url or url == '' then
                    -- Private profile, or Steam is not answering. Remember
                    -- the "no" so the next panel open doesn't ask again.
                    markAvatarMiss(hex); markAvatarMiss(lic)
                    return cb(nil)
                end
                downloadAndBase64(url, function(b64)
                    local final = b64 or url    -- worst case: serve remote URL
                    persistAvatar(hex, url, b64)
                    clearAvatarMiss(hex)
                    if lic then
                        steamAvatarCache[lic] = final
                        persistAvatar(lic, url, b64)
                        clearAvatarMiss(lic)
                    end
                    broadcastAvatar(lic, final)
                    cb(final)
                end)
            end)
        end
    end

    -- No Steam id — there's nothing we can resolve. Return nil; the UI
    -- will show the initial-letter fallback.
    markAvatarMiss(hex); markAvatarMiss(lic)
    cb(nil)
end

local function getCachedAvatar(src)
    local hex = getSteamHex(src)
    return hex and steamAvatarCache[hex] or nil
end

-- Trigger on join AND on resource start for every player already online,
-- so the cache is always populated. We try a few times in case the
-- player's identifiers aren't fully exposed at the very first tick.
local function resolveAvatarAggressively(src, attempt)
    attempt = attempt or 1
    if not src or src == 0 or not GetPlayerName(src) then return end
    local hex = getSteamHex(src)
    -- If steam isn't there yet, retry a few times — some setups expose
    -- identifiers a couple seconds after playerJoining.
    if not hex and attempt < 5 then
        SetTimeout(2000, function() resolveAvatarAggressively(src, attempt + 1) end)
        return
    end
    ensureAvatar(src)
end

AddEventHandler('playerJoining', function()
    local src = source
    SetTimeout(3000, function() resolveAvatarAggressively(src, 1) end)
end)
AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    -- Warm the in-memory cache from the DB. Prefer the base64 column
    -- so the panel doesn't need to talk to Steam at all once the
    -- bytes have been downloaded once.
    CreateThread(function()
        -- Wait for the schema auto-installer before touching the table.
        local guard = 0
        while not PanelSchemaReady and guard < 100 do Wait(200); guard = guard + 1 end
        local ok, rows = pcall(function()
            return MySQL.query.await('SELECT steam, avatar, avatar_b64 FROM apex_steam_avatars') or {}
        end)
        if not ok or not rows then return end
        local loaded = 0
        for _, r in ipairs(rows) do
            local v = (r.avatar_b64 and r.avatar_b64 ~= '') and r.avatar_b64
                   or (r.avatar     and r.avatar     ~= '') and r.avatar
                   or nil
            if v and r.steam then
                steamAvatarCache[r.steam] = v
                loaded = loaded + 1
            end
        end
        print(('^2[apex_adminmenu]^7 avatar cache warmed (%d entries)'):format(loaded))
    end)
    SetTimeout(4000, function()
        for _, p in ipairs(GetPlayers()) do resolveAvatarAggressively(tonumber(p), 1) end
    end)
    -- Back-fill base64 for any cached avatar that only has the URL.
    -- Throttled (one every 1.5s) so we don't hammer Steam's CDN when
    -- the DB has hundreds of legacy rows.
    SetTimeout(6000, function()
        local ok, rows = pcall(function()
            return MySQL.query.await(
                "SELECT steam, avatar FROM apex_steam_avatars WHERE (avatar_b64 IS NULL OR avatar_b64 = '') AND avatar IS NOT NULL AND avatar <> ''"
            ) or {}
        end)
        if not ok or not rows or #rows == 0 then return end
        print(('^3[apex_adminmenu]^7 back-filling %d steam avatars to base64…'):format(#rows))
        local i = 1
        local function next()
            local r = rows[i]
            if not r then
                print('^2[apex_adminmenu]^7 avatar back-fill complete')
                return
            end
            i = i + 1
            downloadAndBase64(r.avatar, function(b64)
                if b64 then
                    persistAvatar(r.steam, r.avatar, b64)
                    broadcastAvatar(r.steam, b64)
                end
                SetTimeout(1500, next)
            end)
        end
        next()
    end)
end)
CreateThread(function()
    Wait(2500)
    for _, p in ipairs(GetPlayers()) do resolveAvatarAggressively(tonumber(p), 1) end
end)

-- Recurring sweep: every 30s, walk every online player and re-trigger
-- the resolver for anyone whose avatar still isn't in the cache. Cheap
-- because cached players short-circuit instantly inside ensureAvatar.
-- Also re-broadcasts the cached URL so any newly-opened admin panel
-- gets the picture without having to refresh anything.
CreateThread(function()
    while true do
        Wait(30000)
        for _, p in ipairs(GetPlayers() or {}) do
            local s   = tonumber(p)
            local lic = getLicense(s)
            local av  = getAvatar(s) or (lic and avatarForLicenseEarly(lic))
            if av and lic then
                -- Re-broadcast every cached avatar so panels opened mid-
                -- session catch up without needing a callback round-trip.
                broadcastAvatar(lic, av)
            else
                ensureAvatar(s)
            end
        end
    end
end)

-- Bulk fetch — used by player list to show thumbnails in one go.
lib.callback.register('apex_adminmenu:panel:avatars', function(source)
    if not PanelRequire(source, { 'players.read' }, 'avatars') then return {} end
    local out = {}
    for _, p in ipairs(GetPlayers()) do
        local s   = tonumber(p)
        local hex = getSteamHex(s)
        if hex then
            local url = steamAvatarCache[hex]
            if not url then
                -- Trigger a fetch but don't wait for it on the first call.
                ensureAvatar(s)
            end
            out[tostring(s)] = url or false
        end
    end
    return out
end)

-- ============================================================
-- Player flags — staff-only visual tag (None/Suspicious/Trusted/...)
-- ============================================================
local VALID_FLAGS = {
    none       = { label = 'None',       color = '#7C7C82' },
    suspicious = { label = 'Suspicious', color = '#E5A93C' },
    trusted    = { label = 'Trusted',    color = '#34C77B' },
    streamer   = { label = 'Streamer',   color = '#A66DF0' },
    vip        = { label = 'VIP',        color = '#F0B429' },
    flagged    = { label = 'Flagged',    color = '#E5564B' }
}

local function getFlag(license)
    if not license or license == '' then return nil end
    return safeSingle('SELECT * FROM apex_player_flags WHERE license = ?', { license })
end

lib.callback.register('apex_adminmenu:panel:flags', function(source)
    return VALID_FLAGS
end)

RegisterNetEvent('apex_adminmenu:panel:setFlag', function(targetIdOrLic, flag, note)
    local src = source
    if not PanelRequire(src, { 'players.flag', 'players.*' }, 'setFlag') then return end

    -- Accept either a server id or a license string.
    local lic, target_name = nil, nil
    if type(targetIdOrLic) == 'number' or tonumber(targetIdOrLic) then
        local tid = tonumber(targetIdOrLic)
        if GetPlayerName(tid) then
            lic = getLicense(tid)
            target_name = GetPlayerName(tid)
        end
    end
    if not lic and type(targetIdOrLic) == 'string' and targetIdOrLic:find(':') then
        lic = targetIdOrLic
    end
    if not lic or lic == '' then return end

    flag = tostring(flag or 'none'):lower()
    if not VALID_FLAGS[flag] then flag = 'none' end
    note = tostring(note or ''):sub(1, 240)

    if flag == 'none' then
        pcall(function()
            MySQL.query('DELETE FROM apex_player_flags WHERE license = ?', { lic })
        end)
    else
        pcall(function()
            MySQL.insert(
                [[INSERT INTO apex_player_flags (license, flag, note, set_by, set_by_lic)
                  VALUES (?, ?, ?, ?, ?)
                  ON DUPLICATE KEY UPDATE
                      flag = VALUES(flag),
                      note = VALUES(note),
                      set_by = VALUES(set_by),
                      set_by_lic = VALUES(set_by_lic)]],
                { lic, flag, note, GetPlayerName(src) or 'Console', getLicense(src) }
            )
        end)
    end
    PanelLog(src, 'player', 'set_flag', target_name, lic, flag .. (note ~= '' and (' · ' .. note) or ''))

    -- Broadcast new flag to every staff member so wallhack/etc can pick it up.
    TriggerClientEvent('apex_adminmenu:panel:flagSync', -1, lic, flag, note)
end)

-- Bulk fetch — useful for wallhack / monitoring to colour names.
lib.callback.register('apex_adminmenu:panel:flagsAll', function(source)
    if not PanelRequire(source, { 'players.read' }, 'flagsAll') then return {} end
    local rows = safeQuery('SELECT license, flag, note FROM apex_player_flags')
    local out = {}
    for _, r in ipairs(rows or {}) do out[r.license] = r end
    return out
end)

RegisterNetEvent('apex_adminmenu:panel:banFromPanel', function(targetId, reason, hours)
    local src = source
    if not PanelRequire(src, { 'moderation.ban', 'moderation.*' }, 'banFromPanel') then return end
    targetId = tonumber(targetId); hours = tonumber(hours)
    if not targetId or not GetPlayerName(targetId) then return end
    if BanPlayer then BanPlayer(targetId, hours or 'perm', reason or 'Banned by staff', src) end
    PanelLog(src, 'moderation', 'ban', GetPlayerName(targetId), getLicense(targetId),
        ('%s · %s'):format(tostring(hours or 'perm'), reason or ''))
end)

-- ============================================================
-- MODERATION — bans, warnings, jails
-- ============================================================
lib.callback.register('apex_adminmenu:panel:bans', function(source, q)
    if not PanelRequire(source, { 'moderation.ban', 'moderation.*' }, 'bans') then return {} end
    local rows = MySQL.query.await('SELECT * FROM apex_bans ORDER BY ban_time DESC LIMIT 500') or {}
    if q and q ~= '' then
        local needle = q:lower()
        local f = {}
        for _, r in ipairs(rows) do
            if (r.player or ''):lower():find(needle, 1, true)
                or (r.reason or ''):lower():find(needle, 1, true)
                or (r.license or ''):lower():find(needle, 1, true) then
                f[#f + 1] = r
            end
        end
        rows = f
    end
    return enrichRowsWithAvatars(rows)
end)

lib.callback.register('apex_adminmenu:panel:warnings', function(source, q)
    if not PanelRequire(source, { 'moderation.warn', 'moderation.*' }, 'warnings') then return {} end
    local rows = safeQuery('SELECT * FROM apex_warnings ORDER BY created_at DESC LIMIT 500')
    if q and q ~= '' then
        local needle = q:lower()
        local f = {}
        for _, r in ipairs(rows) do
            if (r.player or ''):lower():find(needle, 1, true)
                or (r.reason or ''):lower():find(needle, 1, true) then
                f[#f + 1] = r
            end
        end
        rows = f
    end
    return enrichRowsWithAvatars(rows)
end)

lib.callback.register('apex_adminmenu:panel:jails', function(source, q)
    if not PanelRequire(source, { 'moderation.jail', 'moderation.*' }, 'jails') then return {} end
    return enrichRowsWithAvatars(safeQuery('SELECT * FROM apex_jail ORDER BY created_at DESC LIMIT 500'))
end)

RegisterNetEvent('apex_adminmenu:panel:warnPlayer', function(targetId, reason)
    local src = source
    if not PanelRequire(src, { 'moderation.warn', 'moderation.*' }, 'warnPlayer') then return end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then return end
    local lic = getLicense(targetId)
    MySQL.insert.await(
        'INSERT INTO apex_warnings (target, player, reason, admin, admin_lic) VALUES (?, ?, ?, ?, ?)',
        { lic, GetPlayerName(targetId), reason or '', GetPlayerName(src) or 'Console', getLicense(src) }
    )
    PanelLog(src, 'moderation', 'warn', GetPlayerName(targetId), lic, reason)
    TriggerClientEvent('apex_adminmenu:notify', targetId,
        'Warning', 'You were warned by staff: ' .. (reason or ''), 'error', 'fa-triangle-exclamation')
    -- Confirm to the admin as well. The panel toasts "Warning sent." with
    -- no server round-trip, so a warning that reached nobody was
    -- indistinguishable from one that landed.
    TriggerClientEvent('apex_adminmenu:notify', src, 'Warning',
        ('%s was warned.'):format(GetPlayerName(targetId) or ('ID ' .. targetId)),
        'success', 'fa-triangle-exclamation')
end)

RegisterNetEvent('apex_adminmenu:panel:unban', function(license)
    local src = source
    if not PanelRequire(src, { 'moderation.ban', 'moderation.*' }, 'unban') then return end
    if not license or license == '' then return end
    MySQL.query.await('DELETE FROM apex_bans WHERE license = ?', { license })
    PanelLog(src, 'moderation', 'unban', nil, license)
end)

-- Put the player in an actual cell.
--
-- The panel used to write the apex_jail row, fire a notification, and stop
-- there — client/adminpanel.lua even labelled its handler a "jail
-- notification stub". Nothing teleported, froze or timed anything, so a
-- jail was a database entry and nothing more.
--
-- Rather than grow a bespoke cell (coords, freeze loop, countdown, release,
-- relog persistence), hand off to the jail resource the server already
-- runs. qb-prison keeps the sentence in player metadata ('injail') and
-- re-enters the cell on the next login, so a relog does not void a jail —
-- persistence we would otherwise have to build against the unused
-- `released` column.
--
-- Route matters. qb-prison guards `prison:client:Enter` with an
-- invoking-resource whitelist (qb-policejob / qb-ambulancejob / itself), so
-- reaching it from a client script here is refused outright.
-- `police:client:SendToJail` is the supported door: qb-policejob registers
-- it as a plain net event and re-fires `prison:client:Enter` locally, where
-- the whitelist passes — and it clears handcuff/escort state on the way,
-- which an admin-panel jail wants anyway. Triggering it from the SERVER
-- also keeps it out of reach of a client trying to jail someone else.
--
-- Units: qb-prison's countdown does `Wait(1000 * 60)` then `jailTime -= 1`,
-- so its `time` is minutes — the same unit the panel collects.
--
-- @return string|nil  how it was delivered, nil when no jail system is up
local function dispatchJail(targetId, minutes)
    local mode = Config and Config.Jail
    if mode == nil then mode = 'auto' end
    if mode == false or mode == 'none' then return nil end

    -- An explicit event name wins: 'some_jail:client:Jail' is triggered on
    -- the target with (minutes), for a server running something else.
    if type(mode) == 'string' and mode ~= 'auto' and mode:find(':') then
        TriggerClientEvent(mode, targetId, minutes)
        return mode
    end

    if GetResourceState('qb-policejob') == 'started' then
        TriggerClientEvent('police:client:SendToJail', targetId, minutes)
        return 'qb-policejob -> qb-prison'
    end
    -- qb-prison without qb-policejob: a server-sent event has no invoking
    -- resource, so the whitelist above lets it through.
    if GetResourceState('qb-prison') == 'started' then
        TriggerClientEvent('prison:client:Enter', targetId, minutes)
        return 'qb-prison'
    end
    return nil
end

RegisterNetEvent('apex_adminmenu:panel:jailPlayer', function(targetId, minutes, reason)
    local src = source
    if not PanelRequire(src, { 'moderation.jail', 'moderation.*' }, 'jailPlayer') then return end
    targetId = tonumber(targetId)
    minutes  = tonumber(minutes) or 10
    if not targetId or not GetPlayerName(targetId) then return end
    local lic = getLicense(targetId)
    MySQL.insert.await(
        'INSERT INTO apex_jail (target, player, reason, admin, admin_lic, minutes) VALUES (?, ?, ?, ?, ?, ?)',
        { lic, GetPlayerName(targetId), reason or '', GetPlayerName(src) or 'Console', getLicense(src), minutes }
    )
    PanelLog(src, 'moderation', 'jail', GetPlayerName(targetId), lic, ('%dm: %s'):format(minutes, reason or ''))

    local via = dispatchJail(targetId, minutes)
    TriggerClientEvent('apex_adminmenu:panel:jailed', targetId, minutes, reason)

    -- Tell the admin what actually happened. The panel's NUI pops
    -- "Jail sent." the instant the button is clicked, with no server
    -- round-trip, so without this a jail that enforced nothing looked
    -- exactly like one that worked.
    if via then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Jail',
            ('%s jailed for %d min.'):format(GetPlayerName(targetId) or ('ID ' .. targetId), minutes),
            'success', 'fa-handcuffs')
    else
        local msg = 'Logged the sentence, but no jail system is running — the player was not confined.'
        print(('^3[apex_adminmenu]^7 jail: %s (Config.Jail=%s, qb-prison=%s, qb-policejob=%s)')
            :format(msg, tostring(Config and Config.Jail),
                    GetResourceState('qb-prison'), GetResourceState('qb-policejob')))
        TriggerClientEvent('apex_adminmenu:notify', src, 'Jail', msg, 'warning', 'fa-handcuffs')
    end
end)

-- ── Offline / by-license variants ─────────────────────────
-- Used by the Moderation Create modal when the operator pastes
-- a license string directly (player not online).
local function lastKnownName(lic)
    local row = safeSingle('SELECT last_name FROM apex_player_stats WHERE license = ?', { lic })
    return (row and row.last_name) or '(offline)'
end

RegisterNetEvent('apex_adminmenu:panel:banFromPanelByLicense', function(license, reason, hours)
    local src = source
    if not PanelRequire(src, { 'moderation.ban', 'moderation.*' }, 'banFromPanelByLicense') then return end
    license = tostring(license or '')
    if license == '' then return end
    -- Allow hours to be a number, "perm" or anything BanPlayer accepts.
    local h = tonumber(hours) or (tostring(hours):lower() == 'perm' and 'perm') or 'perm'
    local name = lastKnownName(license)
    -- apex_bans stores UNIX timestamps, and PERMANENT is -1 (see
    -- server/ban.lua). The old version of this insert used columns that
    -- do not exist (`time_left`) and passed NOW() into an INT column, so
    -- every offline ban failed silently inside the pcall.
    local now = os.time()
    local expires = (type(h) == 'number') and (now + h * 3600) or -1
    local ok, err = pcall(function()
        MySQL.insert.await(
            'INSERT INTO apex_bans (license, player, reason, author, author_lic, ban_time, exp_time) '
         .. 'VALUES (?, ?, ?, ?, ?, ?, ?)',
            {
                license, name, reason or 'Banned by staff',
                GetPlayerName(src) or 'Console', getLicense(src),
                now, expires
            }
        )
    end)
    if not ok then
        print(('^1[apex_adminmenu]^7 offline ban failed for %s: %s'):format(license, tostring(err)))
        return
    end
    PanelLog(src, 'moderation', 'ban_offline', name, license,
        ('%s · %s'):format(tostring(h), reason or ''))
end)

RegisterNetEvent('apex_adminmenu:panel:warnPlayerByLicense', function(license, reason)
    local src = source
    if not PanelRequire(src, { 'moderation.warn', 'moderation.*' }, 'warnPlayerByLicense') then return end
    license = tostring(license or '')
    if license == '' then return end
    local name = lastKnownName(license)
    pcall(function()
        MySQL.insert.await(
            'INSERT INTO apex_warnings (target, player, reason, admin, admin_lic) VALUES (?, ?, ?, ?, ?)',
            { license, name, reason or '', GetPlayerName(src) or 'Console', getLicense(src) }
        )
    end)
    PanelLog(src, 'moderation', 'warn_offline', name, license, reason)
end)

RegisterNetEvent('apex_adminmenu:panel:jailPlayerByLicense', function(license, minutes, reason)
    local src = source
    if not PanelRequire(src, { 'moderation.jail', 'moderation.*' }, 'jailPlayerByLicense') then return end
    license = tostring(license or '')
    minutes  = tonumber(minutes) or 10
    if license == '' then return end
    local name = lastKnownName(license)
    pcall(function()
        MySQL.insert.await(
            'INSERT INTO apex_jail (target, player, reason, admin, admin_lic, minutes) VALUES (?, ?, ?, ?, ?, ?)',
            { license, name, reason or '', GetPlayerName(src) or 'Console', getLicense(src), minutes }
        )
    end)
    PanelLog(src, 'moderation', 'jail_offline', name, license, ('%dm: %s'):format(minutes, reason or ''))
end)

-- ============================================================
-- STAFF — list, groups, mutations
-- ============================================================
-- STAFF-LIST-BEGIN
-- Builds the Staff page: { groups, members = { [license] = card } }. Shared
-- by the panel callback below and the `apexstaffdiag` console command.
local function buildStaffList()
    local groups  = PanelGetGroups() or {}
    local members = {}

    -- One card per ACCOUNT, whatever spelling each source uses for it.
    --
    -- The three sources below name the same person differently: an online
    -- player is "license:3f2a…" (GetPlayerIdentifiers), an ESX users row is
    -- the bare "3f2a…" (ESX.GetIdentifier strips the prefix), a QBox players
    -- row is "license2:…", and an apex_staff row is whatever was typed or
    -- picked when it was added. Comparing those raw is why one owner showed
    -- up twice — an online card AND an offline card, with the same hash in
    -- two spellings. `byKey` maps PanelLicKey(spelling) -> the card, and an
    -- online player claims every key they can be found under before the
    -- offline rows are read, so a row for someone who is online is folded
    -- into their online card instead of becoming a second one.
    local byKey = {}         -- [PanelLicKey] = card key in `members`
    local onlineByKey = {}   -- [PanelLicKey] = src, for everyone online
    local srcKeys = {}       -- [src] = PanelPlayerKeys(src)
    for _, p in ipairs(GetPlayers() or {}) do
        local s = tonumber(p)
        if s then
            srcKeys[s] = PanelPlayerKeys(s)
            for _, k in ipairs(srcKeys[s]) do onlineByKey[k] = s end
        end
    end

    local function claim(cardKey, keys)
        for _, k in ipairs(keys) do
            if k ~= '' and not byKey[k] then byKey[k] = cardKey end
        end
    end
    local function alreadyListed(keys)
        for _, k in ipairs(keys) do
            if byKey[k] then return byKey[k] end
        end
        return nil
    end
    local function keysFor(lic, src)
        local keys = { PanelLicKey(lic) }
        if src and srcKeys[src] then
            for _, k in ipairs(srcKeys[src]) do keys[#keys + 1] = k end
        end
        return keys
    end

    -- apex_player_stats is keyed by the account license as
    -- GetPlayerIdentifiers spells it, so a bare ESX identifier needs the
    -- prefix put back to find its row (the old SQL JOIN never matched).
    local function statsFor(lic, src)
        local candidates, seen = {}, {}
        local function add(v) if v and v ~= '' and not seen[v] then seen[v] = true; candidates[#candidates + 1] = v end end
        add(lic)
        if src then add(getLicense(src)) end
        local bare = PanelLicKey(lic)
        if bare ~= '' then add('license:' .. bare); add('license2:' .. bare) end
        for _, c in ipairs(candidates) do
            local row = safeSingle('SELECT last_name, last_seen, playtime FROM apex_player_stats WHERE license = ?', { c })
            if row then return row end
        end
        return nil
    end

    -- Helper to attach common stats + avatar.
    local function buildMember(lic, nickname, group_name, source_kind, online_src, manual_avatar)
        local stats = statsFor(lic, online_src)
        members[lic] = {
            license    = lic,
            nickname   = nickname,
            group_name = group_name,
            avatar     = (manual_avatar and manual_avatar ~= '') and manual_avatar
                      or (online_src and getAvatar(online_src))
                      or avatarForLicenseEarly(lic),
            last_name  = stats and stats.last_name,
            last_seen  = stats and stats.last_seen,
            playtime   = stats and tonumber(stats.playtime) or 0,
            online     = online_src ~= nil,
            online_id  = online_src,
            source     = source_kind   -- 'manual' (apex_staff row) or 'framework'
        }
        claim(lic, keysFor(lic, online_src))
    end

    -- 1) Explicit staff entries from apex_staff (highest priority — keep
    --    the operator-provided nickname/group instead of falling back).
    --    The card is keyed by the STORED license so Edit / Remove on it
    --    address the row that exists.
    for lic, m in pairs(PanelGetMembers() or {}) do
        local onlineSrc = onlineByKey[PanelLicKey(lic)]
        if onlineSrc and not GetPlayerName(onlineSrc) then onlineSrc = nil end
        if not alreadyListed(keysFor(lic, onlineSrc)) then
            buildMember(lic, m.nickname, m.group_name, 'manual', onlineSrc, m.avatar)
        end
    end

    -- 2) Currently-online players whose framework group matches one of the
    --    configured admin groups. These show up as staff even if nobody
    --    added them to the apex_staff table.
    if Config and Config.AdminPerms and Config.AdminPerms.UserGroups
        and Config.AdminPerms.UserGroups.enabled then
        local staffGroupNames = {}
        for _, g in ipairs(Config.AdminPerms.UserGroups.Groups or {}) do
            staffGroupNames[g] = true
        end
        for _, p in ipairs(GetPlayers() or {}) do
            local s   = tonumber(p)
            local lic = getLicense(s)
            if lic and lic ~= '' and not alreadyListed(keysFor(lic, s)) then
                -- Probe each staff group via HasPermission so we work with
                -- ESX, QBCore, or any custom framework hook.
                local matched = nil
                for g, _ in pairs(staffGroupNames) do
                    if HasPermission and HasPermission(s, g) and groups[g] then
                        matched = g; break
                    end
                end
                if matched then
                    buildMember(lic, GetPlayerName(s), matched, 'framework', s, nil)
                end
            end
        end
    end

    -- 3) Offline framework users whose stored `group` column matches one
    --    of the configured admin groups (ESX has a `users.group` column;
    --    QBCore stores it inside `players.permission`). Anyone who is
    --    online is already on a card above (claimed under every spelling),
    --    so a row that resolves to an online player is skipped here instead
    --    of becoming the "offline twin".
    local function offlineCard(lic, nm, grp, r)
        local key = PanelLicKey(lic)
        if key == '' or byKey[key] or onlineByKey[key] then return end
        local stats = (r.last_seen ~= nil or r.last_name ~= nil) and r or statsFor(lic, nil)
        members[lic] = {
            license    = lic,
            nickname   = nm,
            group_name = grp,
            avatar     = avatarForLicenseEarly(lic),
            last_name  = stats and stats.last_name,
            last_seen  = stats and stats.last_seen,
            playtime   = stats and tonumber(stats.playtime) or 0,
            online     = false,
            source     = 'framework'
        }
        byKey[key] = lic
    end

    if Framework == 'qb' then
        local rows = safeQuery([[
            SELECT p.license, p.name, p.charinfo, p.permission AS grp,
                   s.last_name, s.last_seen, s.playtime
            FROM players p
            LEFT JOIN apex_player_stats s ON s.license = p.license
            WHERE p.permission IS NOT NULL AND p.permission <> '' AND p.permission <> 'user'
        ]])
        for _, r in ipairs(rows or {}) do
            local lic = r.license
            if lic and groups[r.grp] then
                local nm = r.last_name
                if (not nm or nm == '') and r.charinfo then
                    local ok, ci = pcall(json.decode, r.charinfo)
                    if ok and ci then nm = ((ci.firstname or '') .. ' ' .. (ci.lastname or ''))
                        :gsub('^%s+', ''):gsub('%s+$', '') end
                end
                offlineCard(lic, (nm and nm ~= '') and nm or r.name, r.grp, r)
            end
        end
    else
        local rows = safeQuery([[
            SELECT u.identifier AS license, u.firstname, u.lastname,
                   u.`group` AS grp,
                   s.last_name, s.last_seen, s.playtime
            FROM users u
            LEFT JOIN apex_player_stats s
                   ON s.license = u.identifier
                   OR s.license = CONCAT('license:', u.identifier)
            WHERE u.`group` IS NOT NULL AND u.`group` <> '' AND u.`group` <> 'user'
        ]])
        for _, r in ipairs(rows or {}) do
            local lic = r.license
            if lic and groups[r.grp] then
                local nm = r.last_name
                if (not nm or nm == '') then
                    nm = ((r.firstname or '') .. ' ' .. (r.lastname or ''))
                        :gsub('^%s+', ''):gsub('%s+$', '')
                end
                offlineCard(lic, nm, r.grp, r)
            end
        end
    end

    return {
        groups  = groups,
        members = members
    }
end
PanelBuildStaffList = buildStaffList

lib.callback.register('apex_adminmenu:panel:staff', function(source)
    if not PanelRequire(source, { 'staff.read', 'staff.*' }, 'staff') then return nil end
    -- Force a fresh reload from DB so new rows added externally show up.
    if PanelReload then pcall(PanelReload) end
    return buildStaffList()
end)

-- Console: apexstaffdiag — prints the Staff page exactly as the panel
-- builds it right now, one line per card with the account key the cards
-- are merged on and the spelling each source used, so a "listed twice"
-- report can be settled from the console instead of from screenshots.
RegisterCommand('apexstaffdiag', function(src)
    if src ~= 0 then return end
    CreateThread(function()
        if PanelReload then pcall(PanelReload) end
        local list = buildStaffList()
        local rows, byKey, dups = {}, {}, 0
        for lic, m in pairs(list.members or {}) do
            local k = PanelLicKey and PanelLicKey(lic) or lic
            if byKey[k] then dups = dups + 1 end
            byKey[k] = true
            rows[#rows + 1] = ('  %-7s %-9s %-14s %-24s key=%s  stored as: %s'):format(
                m.online and 'online' or 'offline', m.source or '?', tostring(m.group_name),
                tostring(m.nickname or m.last_name or '?'):sub(1, 24), k, lic)
        end
        table.sort(rows)
        local manual = 0
        for _ in pairs(PanelGetMembers and PanelGetMembers() or {}) do manual = manual + 1 end
        print(('^5[apex_adminmenu]^7 v%s staff page: %d card(s) · %d apex_staff row(s) · %d player(s) online · framework %s')
            :format(GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?', #rows, manual, #(GetPlayers() or {}), tostring(Framework)))
        for _, r in ipairs(rows) do print(r) end
        if dups > 0 then
            print(('^1  %d card(s) share an account key - please report this output^7'):format(dups))
        else
            print('^2  no two cards share an account key^7')
        end
        for _, p in ipairs(GetPlayers() or {}) do
            local s = tonumber(p)
            if s and PanelPlayerKeys then
                print(('  online %s %s -> keys: %s'):format(s, GetPlayerName(s) or '?', table.concat(PanelPlayerKeys(s), ', ')))
            end
        end
    end)
end, true)

-- Browse all framework users (online + offline) for "Add staff" picker.
lib.callback.register('apex_adminmenu:panel:usersBrowse', function(source, q, limit)
    if not PanelRequire(source, { 'staff.write', 'staff.*' }, 'usersBrowse') then return {} end
    q = (q and tostring(q):lower()) or ''
    limit = tonumber(limit) or 200

    local rows = {}
    if Framework == 'qb' then
        rows = safeQuery([[
            SELECT p.license, p.name, p.charinfo,
                   s.last_name, s.last_seen, s.playtime
            FROM players p
            LEFT JOIN apex_player_stats s ON s.license = p.license
            ORDER BY (s.last_seen IS NULL), s.last_seen DESC
            LIMIT ?
        ]], { limit + 100 })
    else
        rows = safeQuery([[
            SELECT u.identifier AS license, u.firstname, u.lastname,
                   s.last_name, s.last_seen, s.playtime
            FROM users u
            LEFT JOIN apex_player_stats s ON s.license = u.identifier
            ORDER BY (s.last_seen IS NULL), s.last_seen DESC
            LIMIT ?
        ]], { limit + 100 })
    end

    -- Mark who is currently online so the picker can show that.
    local onlineLic = {}
    for _, p in ipairs(GetPlayers()) do
        local s = tonumber(p)
        onlineLic[getLicense(s)] = s
    end

    local out, n = {}, 0
    for _, r in ipairs(rows) do
        local lic = r.license
        if lic and lic ~= '' then
            local nm = r.last_name or ''
            if (not nm or nm == '') then
                if r.firstname then
                    nm = ((r.firstname or '') .. ' ' .. (r.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
                elseif r.charinfo then
                    local ok, ci = pcall(json.decode, r.charinfo)
                    if ok and ci then
                        nm = ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
                    end
                end
            end
            if nm == '' then nm = 'Unknown' end

            -- Search filter across name + license.
            local hay = (nm .. ' ' .. lic):lower()
            if q == '' or hay:find(q, 1, true) then
                n = n + 1
                out[n] = {
                    license   = lic,
                    name      = nm,
                    avatar    = steamAvatarCache[lic],
                    online    = onlineLic[lic] ~= nil,
                    onlineId  = onlineLic[lic],
                    last_seen = r.last_seen,
                    playtime  = tonumber(r.playtime) or 0
                }
                if n >= limit then break end
            end
        end
    end
    return out
end)

RegisterNetEvent('apex_adminmenu:panel:saveMember', function(license, nickname, group_name, avatar)
    local src = source
    if not PanelRequire(src, { 'staff.write', 'staff.*' }, 'saveMember') then return end
    PanelAddMember(license, nickname, group_name, avatar, GetPlayerName(src) or 'console')
    PanelLog(src, 'staff', 'save_member', nickname, license, group_name)
end)

RegisterNetEvent('apex_adminmenu:panel:removeMember', function(license)
    local src = source
    if not PanelRequire(src, { 'staff.write', 'staff.*' }, 'removeMember') then return end
    PanelRemoveMember(license)
    PanelLog(src, 'staff', 'remove_member', nil, license)
end)

RegisterNetEvent('apex_adminmenu:panel:saveGroup', function(name, label, hierarchy, permissions, color)
    local src = source
    if not PanelRequire(src, { 'staff.write', 'staff.*' }, 'saveGroup') then return end
    PanelSaveGroup(name, label, hierarchy, permissions, color)
    PanelLog(src, 'staff', 'save_group', nil, nil, name)
end)

RegisterNetEvent('apex_adminmenu:panel:deleteGroup', function(name)
    local src = source
    if not PanelRequire(src, { 'staff.write', 'staff.*' }, 'deleteGroup') then return end
    PanelDeleteGroup(name)
    PanelLog(src, 'staff', 'delete_group', nil, nil, name)
end)

-- ── Awaited staff actions ───────────────────────────────────
-- The page used to fire the events above and reload 300 ms later: the reload
-- regularly beat the database write (so nothing changed on screen) and every
-- refusal was silent. These answer { ok, error } once the write is done, so
-- the page refreshes on the real result and shows WHY when it is refused.
-- The net events above stay for anything still calling them.
local STAFF_NO_PERM = 'Only the owner can manage staff groups. Server owner? Type  apexstaff <your id> owner  in the server console (txAdmin) once.'

local function staffCan(src)
    return PanelHasPerm(src, 'staff.write') or PanelHasPerm(src, 'staff.*')
end

-- Rank of the acting admin: hierarchy of their group (0 = top). ACE-only admins
-- with no recognised group count as 'admin', the same fallback PanelHasPerm uses.
local function actorRank(src)
    local name, def = PanelGetGroup(src)
    if not def and AdminPerms and AdminPerms(src) == true then
        name, def = PanelResolveGroup('admin')
    end
    if not def then return nil end
    return tonumber(def.hierarchy) or 99, name
end

--[[ Member changes. Full rights: staff.write / staff.* (owner). Otherwise, with
     Config.StaffManagement.lowerRanks, a staff group may manage members strictly
     BELOW its own rank: an admin can add, move and remove moderators and helpers,
     but can never create, touch or remove another admin or an owner. Without this
     an ESX server's owner, who is usually in the plain 'admin' group, could not
     add a single staff member and had no way to find out why. ]]
local function memberWriteCheck(src, license, newGroup)
    if staffCan(src) then return true end
    local sm = Config.StaffManagement
    local rank, myGroup = actorRank(src)
    if not (sm == nil or sm.lowerRanks ~= false) or not rank then return false, STAFF_NO_PERM end
    local below = ('Your group (%s) can only manage staff ranked below it. To make someone %s or higher, the server owner runs  apexstaff <id> <group>  in the server console.')
    if newGroup ~= nil then
        local tname, tdef = PanelResolveGroup(newGroup)
        if tdef and (tonumber(tdef.hierarchy) or 99) <= rank then return false, below:format(myGroup, tname) end
    end
    local current = license and PanelGetMembers and PanelGetMembers()[license]
    if current then
        local _, cdef = PanelResolveGroup(current.group_name)
        if cdef and (tonumber(cdef.hierarchy) or 99) <= rank then return false, below:format(myGroup, current.group_name) end
    end
    return true
end

-- "license:…" as typed, or a server id of an online player.
local function resolveStaffLicense(input)
    input = tostring(input or ''):gsub('^%s+', ''):gsub('%s+$', '')
    local id = tonumber(input)
    if id and GetPlayerName(id) then
        local lic = getLicense(id)
        if lic and lic ~= '' then return lic, GetPlayerName(id) end
        return nil
    end
    if input:match('^license2?:%x+$') then return input:lower() end
    return nil
end

lib.callback.register('apex_adminmenu:panel:staffSaveMember', function(src, license, nickname, group_name, avatar)
    if not (staffCan(src) or actorRank(src)) then return { ok = false, error = STAFF_NO_PERM } end
    local lic, onlineName = resolveStaffLicense(license)
    if not lic then
        return { ok = false, error = 'Enter a license (license:…) or the server ID of an online player.' }
    end
    local allowed, why = memberWriteCheck(src, lic, group_name)
    if not allowed then return { ok = false, error = why } end
    nickname = tostring(nickname or '')
    if nickname == '' then nickname = onlineName or '' end
    local ok, res = PanelAddMember(lic, nickname, group_name, avatar, GetPlayerName(src) or 'console')
    if not ok then return { ok = false, error = res } end
    PanelLog(src, 'staff', 'save_member', nickname, lic, res)
    return { ok = true, license = lic, group = res }
end)

--[[ SERVER CONSOLE ONLY: the way a server owner makes themselves 'owner' the
     first time (nobody in game can grant a rank at or above their own), and a
     recovery door if the staff table ever locks everyone out.
       apexstaff <server id | license:xxx> [group]   (group defaults to owner)
       apexstaff remove <license:xxx>
       apexstaff list ]]
RegisterCommand('apexstaff', function(src, args)
    if src ~= 0 then return end
    local a1, a2 = args[1], args[2]
    if not a1 then
        print('usage: apexstaff <server id | license:xxx> [group]   |   apexstaff remove <license:xxx>   |   apexstaff list')
        return
    end
    if a1 == 'list' then
        for lic, m in pairs(PanelGetMembers and PanelGetMembers() or {}) do
            print(('  %-12s %-24s %s'):format(tostring(m.group_name), tostring(m.nickname), lic))
        end
        return
    end
    if a1 == 'remove' then
        local ok, err = PanelRemoveMember(tostring(a2 or ''))
        print(ok and ('^2[apex_adminmenu] removed %s^7'):format(tostring(a2)) or ('^1[apex_adminmenu] %s^7'):format(tostring(err)))
        return
    end
    local lic, name = resolveStaffLicense(a1)
    if not lic then
        print('^1[apex_adminmenu] Not an online server id or a license:xxx value.^7')
        return
    end
    local ok, res = PanelAddMember(lic, name or '', a2 or 'owner', '', 'console')
    if ok then
        print(('^2[apex_adminmenu] %s is now %s. Reopen the admin panel.^7'):format(name or lic, res))
    else
        print(('^1[apex_adminmenu] %s^7'):format(tostring(res)))
    end
end, true)

lib.callback.register('apex_adminmenu:panel:staffRemoveMember', function(src, license)
    local allowed, why = memberWriteCheck(src, tostring(license or ''), nil)
    if not allowed then return { ok = false, error = why } end
    local ok, err = PanelRemoveMember(tostring(license or ''))
    if not ok then return { ok = false, error = err } end
    PanelLog(src, 'staff', 'remove_member', nil, license)
    return { ok = true }
end)

lib.callback.register('apex_adminmenu:panel:staffSaveGroup', function(src, name, label, hierarchy, permissions, color)
    if not staffCan(src) then return { ok = false, error = STAFF_NO_PERM } end
    local ok, res = PanelSaveGroup(name, label, hierarchy, permissions, color)
    if not ok then return { ok = false, error = res } end
    PanelLog(src, 'staff', 'save_group', nil, nil, res)
    return { ok = true, name = res }
end)

lib.callback.register('apex_adminmenu:panel:staffDeleteGroup', function(src, name)
    if not staffCan(src) then return { ok = false, error = STAFF_NO_PERM } end
    local ok, err = PanelDeleteGroup(name)
    if not ok then return { ok = false, error = err } end
    PanelLog(src, 'staff', 'delete_group', nil, nil, name)
    return { ok = true }
end)

-- ============================================================
-- LOGS — generic browser
-- ============================================================
lib.callback.register('apex_adminmenu:panel:logs', function(source, filter)
    if not PanelRequire(source, { 'logs.read', 'staff.*' }, 'logs') then return {} end
    filter = filter or {}
    local where, args = '1=1', {}
    if filter.admin_lic and filter.admin_lic ~= '' then
        where = where .. ' AND admin_lic = ?'
        args[#args + 1] = filter.admin_lic
    end
    if filter.category and filter.category ~= '' then
        where = where .. ' AND category = ?'
        args[#args + 1] = filter.category
    end
    if filter.q and filter.q ~= '' then
        where = where .. ' AND (action LIKE ? OR details LIKE ? OR target LIKE ?)'
        args[#args + 1] = '%' .. filter.q .. '%'
        args[#args + 1] = '%' .. filter.q .. '%'
        args[#args + 1] = '%' .. filter.q .. '%'
    end
    return enrichRowsWithAvatars(safeQuery(
        'SELECT * FROM apex_staff_log WHERE ' .. where .. ' ORDER BY created_at DESC LIMIT 500',
        args
    ))
end)

-- ============================================================
-- ITEMS & VEHICLES databases
-- ============================================================

-- ── Item catalogue ──────────────────────────────────────────
--
-- This used to be two branches: ox_inventory's Items() export, else
-- `SELECT * FROM apex_items_cache`. The second one can never return a
-- row. apex_items_cache is CREATEd by install_admin_panel.sql and read
-- right here, and that is the entire life of the table — nothing in this
-- resource, or in any other resource on any server, has ever written to
-- it. So every install not running ox_inventory got a permanently empty
-- Items page, and got it silently: the query succeeds, zero rows is not
-- an error, and an empty catalogue is indistinguishable from "this
-- server genuinely has no items".
--
-- QBCore keeps its catalogue in the QBCore.Shared.Items table and was
-- never consulted at all. That is the whole bug on a qb-inventory server
-- with hundreds of items defined in qb-core/shared/items.lua.
--
-- Three smaller traps handled below:
--   * `ok and items` is true for an EMPTY table, so an ox_inventory that
--     is running but has not finished loading its data used to END the
--     chain rather than fall through to a source that does have items.
--     Every source here has to prove it returned something.
--   * icon paths differ per inventory. The NUI hardcoded ox_inventory's
--     web/images/, so on qb-inventory every icon 404'd into the generic
--     box placeholder. Only the server knows which provider answered, so
--     the absolute nui:// URL is resolved here.
--   * Config.Inventory was ignored outright. Setting it to 'qb' on a
--     server that also happens to have ox_inventory installed changed
--     nothing whatsoever, which is a confusing thing for a documented
--     setting to do.

local ITEM_IMAGE_DIRS = {
    ox_inventory         = 'web/images/',
    ['qb-inventory']     = 'html/images/',
    ['ps-inventory']     = 'html/images/',
    ['qs-inventory']     = 'html/images/',
    ['origen_inventory'] = 'html/images/',
    ['codem-inventory']  = 'html/itemimages/'
}

--- Absolute NUI icon base for one inventory resource, or nil when that
--- resource is not running. A nil base leaves `image` unset and the UI
--- falls back to its own box glyph, which is the correct degradation.
local function itemImageBase(res)
    local dir = res and ITEM_IMAGE_DIRS[res]
    if not dir or GetResourceState(res) ~= 'started' then return nil end
    return ('nui://%s/%s'):format(res, dir)
end

--- First running QBCore-family inventory, for icon purposes only.
local function qbImageBase()
    for _, res in ipairs({ 'qb-inventory', 'ps-inventory', 'qs-inventory', 'origen_inventory', 'codem-inventory' }) do
        local base = itemImageBase(res)
        if base then return base end
    end
    return nil
end

--- Join an icon base with whatever filename the provider gave us.
--- QBCore stores `image = 'water_bottle.png'` (extension included) but
--- leaves it nil for most items; ox keeps it under client.image. Anything
--- arriving without an extension gets .png.
local function itemImageUrl(base, file, name)
    if not base then return nil end
    local f = (file and file ~= '') and file or (name .. '.png')
    if not f:find('%.%w+$') then f = f .. '.png' end
    return base .. f
end

local function itemsFromOx()
    if GetResourceState('ox_inventory') ~= 'started' then return nil end
    local ok, items = pcall(function() return exports.ox_inventory:Items() end)
    if not ok or type(items) ~= 'table' or next(items) == nil then return nil end
    local base, out = itemImageBase('ox_inventory'), {}
    for name, it in pairs(items) do
        if type(it) == 'table' then
            out[#out + 1] = {
                name   = name,
                label  = it.label or name,
                weight = tonumber(it.weight) or 0,
                image  = itemImageUrl(base, it.client and it.client.image, name)
            }
        end
    end
    return out
end

--- QBCore. `QBCore` is the global the qb bridge sets from
--- exports['qb-core']:GetCoreObject() (bridge/qb/server.lua:6), and
--- `QBCore.Shared.Jobs` is already read this way by the Jobs page.
---
--- Returns nil on QBox: the shim in bridge/qbx/server.lua deliberately
--- mirrors only Shared.Jobs, so Shared.Items is absent there. That is
--- fine — QBox servers run ox_inventory and are answered above.
local function itemsFromQB()
    local shared = QBCore and QBCore.Shared and QBCore.Shared.Items
    if type(shared) ~= 'table' or next(shared) == nil then return nil end
    local base, out = qbImageBase(), {}
    for key, it in pairs(shared) do
        if type(it) == 'table' then
            local name = it.name or key
            out[#out + 1] = {
                name   = name,
                label  = it.label or name,
                weight = tonumber(it.weight) or 0,
                image  = itemImageUrl(base, it.image, name)
            }
        end
    end
    if #out == 0 then return nil end
    return out
end

--- ESX keeps its catalogue in the `items` table and mirrors it into
--- ESX.Items. Note this is the ONLY source the old webpanel.lua resolver
--- knew about, which is why that one returned nothing on a QB schema:
--- QBCore has no `items` table at all.
local function itemsFromESX()
    local out = {}
    local pool = ESX and ESX.Items
    if type(pool) == 'table' and next(pool) ~= nil then
        for name, it in pairs(pool) do
            out[#out + 1] = {
                name   = name,
                label  = (type(it) == 'table' and (it.label or it.name)) or name,
                weight = (type(it) == 'table' and tonumber(it.weight)) or 0
            }
        end
        return out
    end
    -- Only worth a query on ESX; safeQuery swallows the "no such table"
    -- error elsewhere, but there is no reason to make it on QB at all.
    if Framework ~= 'esx' then return nil end
    local rows = safeQuery('SELECT name, label, weight FROM items ORDER BY label')
    if not rows or #rows == 0 then return nil end
    for _, r in ipairs(rows) do
        out[#out + 1] = { name = r.name, label = r.label or r.name, weight = tonumber(r.weight) or 0 }
    end
    return out
end

--- The legacy cache table. Kept last, and kept at all only because an
--- install may have filled it by hand; nothing here ever writes it.
local function itemsFromCache()
    local rows = safeQuery('SELECT name, label, weight, image FROM apex_items_cache ORDER BY label')
    if not rows or #rows == 0 then return nil end
    local out = {}
    for _, r in ipairs(rows) do
        out[#out + 1] = {
            name   = r.name,
            label  = r.label or r.name,
            weight = tonumber(r.weight) or 0,
            image  = r.image
        }
    end
    return out
end

local ITEM_SOURCES  = { ox = itemsFromOx, qb = itemsFromQB, esx = itemsFromESX, cache = itemsFromCache }
local ITEM_FALLBACK = { 'ox', 'qb', 'esx', 'cache' }

-- Config.Inventory ids whose catalogue lives in QBCore.Shared.Items.
local QB_INVENTORY_IDS = {
    qb = true, ps = true, qs = true, origen = true, codem = true,
    core = true, tgiann = true, cheeza = true, mf = true
}

--- Full item catalogue for the panel, sorted by label.
--- Global so server/webpanel.lua can share it rather than keeping its own
--- divergent copy — the two used to disagree about which table to read.
--- @return table list  array of { name, label, weight, image }
--- @return string source  which provider answered ('none' when empty)
function PanelItemCatalog()
    local order = ITEM_FALLBACK
    local cfg   = Config and Config.Inventory

    -- An explicit Config.Inventory only ever REORDERS the chain, it never
    -- truncates it: a server that names a provider it isn't actually
    -- running should still get a populated page rather than a blank one.
    if type(cfg) == 'string' and cfg ~= 'auto' then
        local first = (cfg == 'ox' and 'ox')
                   or (cfg == 'esx' and 'esx')
                   or (QB_INVENTORY_IDS[cfg] and 'qb')
                   or nil
        if first then
            order = { first }
            for _, k in ipairs(ITEM_FALLBACK) do
                if k ~= first then order[#order + 1] = k end
            end
        end
    end

    for _, key in ipairs(order) do
        local ok, list = pcall(ITEM_SOURCES[key])
        if ok and list and #list > 0 then
            table.sort(list, function(a, b)
                return (a.label or a.name or ''):lower() < (b.label or b.name or ''):lower()
            end)
            return list, key
        end
    end
    return {}, 'none'
end

lib.callback.register('apex_adminmenu:panel:items', function(source)
    if not PanelRequire(source, { 'items.read', 'players.*' }, 'items') then return {} end

    local list, src = PanelItemCatalog()

    -- An empty catalogue used to be returned silently, which is exactly
    -- how a permanently blank Items page went unexplained for so long.
    -- Say it out loud: reaching here is always a configuration problem,
    -- never a normal state for a running server.
    if #list == 0 then
        print(('^3[apex_adminmenu]^7 Items page: no item catalogue found (tried ox_inventory, '
            .. 'QBCore.Shared.Items, ESX, apex_items_cache). Framework=%s, Config.Inventory=%s')
            :format(tostring(Framework), tostring(Config and Config.Inventory)))
    elseif Config and Config.Debug then
        print(('^2[apex_adminmenu]^7 Items page: %d item(s) from %s'):format(#list, src))
    end

    return list
end)

-- How many owned vehicles one page of the panel pulls.
--
-- This used to be a flat `LIMIT 1500`, fetched in full every time the
-- Vehicles page opened. On a server with a real player base that meant
--   "apex_adminmenu executed a query with an oversized result set (1084 results)"
-- on every visit, plus the whole table crossing the wire so the CLIENT
-- could filter it. Searching belongs in SQL, where there is an index.
-- Global on purpose: the bootstrap callback sits earlier in this file and
-- needs the same number to tell the UI whether a page was capped.
function PanelVehiclePageSize()
    local n = Config and Config.OwnedVehicles and tonumber(Config.OwnedVehicles.panelPageSize)
    if not n or n < 25 then n = 250 end
    if n > 900 then n = 900 end   -- stay under oxmysql's oversized-result warning
    return math.floor(n)
end
local vehiclePageSize = PanelVehiclePageSize

lib.callback.register('apex_adminmenu:panel:vehicles', function(source, query)
    if not PanelRequire(source, { 'vehicles.read', 'vehicles.*', '*', 'players.read' }, 'vehicles') then
        return {}
    end

    local limit = vehiclePageSize()
    local q     = tostring(query or ''):gsub('^%s*(.-)%s*$', '%1')
    -- A single character matches almost everything, so it buys nothing but
    -- a full scan. Below the threshold we just serve the first page.
    local searching = #q >= 2
    local like      = '%' .. q:gsub('[%%_\\]', '\\%0') .. '%'

    -- Pull from whichever framework table is available. Each row
    -- ends up with { plate, model, owner, ownerName, garage, fuel,
    -- damage }. Missing columns degrade gracefully.
    local rows = {}
    if Framework == 'qb' then
        local where, args = '', {}
        if searching then
            -- charinfo is JSON; LIKE over the raw text catches first/last
            -- name without needing a generated column on every schema.
            where = [[ WHERE v.plate LIKE ? OR v.vehicle LIKE ?
                          OR p.name LIKE ? OR p.charinfo LIKE ? ]]
            args  = { like, like, like, like }
        end
        -- `limit` is inlined rather than bound: mysql2 sends bound values as
        -- strings and MySQL rejects a string after LIMIT. It is our own
        -- clamped integer from vehiclePageSize(), never operator input.
        rows = safeQuery([[
            SELECT v.plate, v.vehicle AS model, v.license AS owner,
                   v.garage, v.state, v.fuel, v.engine, v.body,
                   COALESCE(p.charinfo, '') AS charinfo, p.name AS account_name
            FROM player_vehicles v
            LEFT JOIN players p ON p.license = v.license
        ]] .. where .. ' ORDER BY v.plate ASC LIMIT ' .. limit, args) or {}

        for _, r in ipairs(rows) do
            local nm
            if r.charinfo and r.charinfo ~= '' then
                local ok, ci = pcall(json.decode, r.charinfo)
                if ok and ci then nm = ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '') end
            end
            r.ownerName = (nm and nm ~= '' and nm) or r.account_name or '—'
            r.label = r.model
            r.charinfo = nil   -- the whole character blob is not the panel's business
        end
    else
        local where, args = '', {}
        if searching then
            where = [[ WHERE v.plate LIKE ? OR v.owner LIKE ?
                          OR u.firstname LIKE ? OR u.lastname LIKE ?
                          OR CONCAT(COALESCE(u.firstname,''), ' ', COALESCE(u.lastname,'')) LIKE ? ]]
            args  = { like, like, like, like, like }
        end
        rows = safeQuery([[
            SELECT v.plate, v.vehicle AS json_vehicle, v.owner, v.stored, v.job,
                   v.type, COALESCE(u.firstname, '') AS firstname,
                   COALESCE(u.lastname, '') AS lastname
            FROM owned_vehicles v
            LEFT JOIN users u ON u.identifier = v.owner
        ]] .. where .. ' ORDER BY v.plate ASC LIMIT ' .. limit, args) or {}

        for _, r in ipairs(rows) do
            -- ESX stores the model inside a JSON `vehicle` blob.
            if r.json_vehicle and r.json_vehicle ~= '' then
                local ok, v = pcall(json.decode, r.json_vehicle)
                if ok and v and v.model then r.model = tostring(v.model) end
            end
            r.label     = r.model or '—'
            r.ownerName = ((r.firstname or '') .. ' ' .. (r.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
            if r.ownerName == '' then r.ownerName = r.owner or '—' end
            r.garage = r.job or 'civilian'
            r.state  = (r.stored == 1) and 'stored' or 'out'
            -- None of these are read by the UI; the JSON blob in particular
            -- is the single biggest field on the row.
            r.json_vehicle, r.firstname, r.lastname, r.stored, r.job = nil, nil, nil, nil, nil
        end
    end
    return rows
end)

-- Server-side delete for a vehicle by plate.
RegisterNetEvent('apex_adminmenu:panel:deleteVehicle', function(plate)
    local src = source
    if not PanelRequire(src, { 'vehicles.*', 'vehicles.delete', '*' }, 'deleteVehicle') then return end
    plate = tostring(plate or ''):upper():gsub('%s+$', '')
    if plate == '' then return end
    -- One pcall per statement. Sharing a single pcall meant that on
    -- QBCore/QBox the first DELETE threw (owned_vehicles is an ESX table
    -- and doesn't exist) and aborted before player_vehicles was ever
    -- touched — vehicle deletion silently did nothing on both.
    pcall(MySQL.query.await, 'DELETE FROM owned_vehicles WHERE plate = ?',  { plate })
    pcall(MySQL.query.await, 'DELETE FROM player_vehicles WHERE plate = ?', { plate })
    PanelLog(src, 'vehicle', 'delete', nil, nil, plate)
end)

-- ============================================================
-- CONSOLE
-- ============================================================
lib.callback.register('apex_adminmenu:panel:consoleHistory', function(source)
    if not PanelRequire(source, { 'console.read' }, 'consoleHistory') then return {} end
    return panelConsoleBuffer
end)

RegisterNetEvent('apex_adminmenu:panel:consoleExec', function(command)
    local src = source
    if not PanelRequire(src, { 'console.exec' }, 'consoleExec') then return end
    if type(command) ~= 'string' or command == '' then return end
    PanelLog(src, 'panel', 'console_exec', nil, nil, command:sub(1, 200))
    ExecuteCommand(command)
end)

-- Resources list
lib.callback.register('apex_adminmenu:panel:resources', function(source)
    if not PanelRequire(source, { 'resources.read', 'resources.*' }, 'resources') then return {} end
    local out = {}
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        out[#out + 1] = {
            name    = name,
            state   = GetResourceState(name),
            version = GetResourceMetadata(name, 'version', 0)
        }
    end
    table.sort(out, function(a, b) return a.name < b.name end)
    return out
end)

RegisterNetEvent('apex_adminmenu:panel:resourceAction', function(name, action)
    local src = source
    if not (PanelHasPerm(src, '*')
         or PanelHasPerm(src, 'resources.write')
         or PanelHasPerm(src, 'resources.*')
         or PanelHasPerm(src, 'staff.*')
         or PanelHasPerm(src, 'console.*')) then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Resources',
            'You do not have permission to manage resources.', 'error')
        return
    end
    if type(name) ~= 'string' or name == '' then return end
    if GetResourceState(name) == 'missing' then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Resources',
            ('Resource "%s" not found.'):format(name), 'error')
        return
    end
    local ok = false
    if action == 'start' then
        ok = StartResource(name) == true
    elseif action == 'stop' then
        ok = StopResource(name) == true
    elseif action == 'restart' then
        StopResource(name)
        SetTimeout(500, function() StartResource(name) end)
        ok = true
    else
        return
    end
    TriggerClientEvent('apex_adminmenu:notify', src, 'Resources',
        ('%s "%s" %s'):format((action:gsub("^%l", string.upper)), name, ok and 'ok' or 'failed'),
        ok and 'success' or 'error')
    PanelLog(src, 'panel', 'resource_' .. action, name)
end)

-- ============================================================
-- EVENTS
-- ============================================================
lib.callback.register('apex_adminmenu:panel:events', function(source)
    if not PanelRequire(source, { 'events.read', 'staff.*' }, 'events') then return {} end
    return MySQL.query.await('SELECT * FROM apex_events ORDER BY starts_at ASC') or {}
end)

RegisterNetEvent('apex_adminmenu:panel:saveEvent', function(id, title, description, color, starts_at)
    local src = source
    if not PanelRequire(src, { 'events.write', 'staff.*' }, 'saveEvent') then return end
    if id and tonumber(id) then
        MySQL.query.await('UPDATE apex_events SET title=?, description=?, color=?, starts_at=? WHERE id=?',
            { title, description, color, starts_at, tonumber(id) })
    else
        MySQL.insert.await(
            'INSERT INTO apex_events (title, description, author, author_lic, color, starts_at) VALUES (?, ?, ?, ?, ?, ?)',
            { title, description, GetPlayerName(src), getLicense(src), color, starts_at }
        )
    end
    PanelLog(src, 'panel', 'save_event', nil, nil, title)
end)

RegisterNetEvent('apex_adminmenu:panel:deleteEvent', function(id)
    local src = source
    if not PanelRequire(src, { 'events.write', 'staff.*' }, 'deleteEvent') then return end
    MySQL.query.await('DELETE FROM apex_events WHERE id=?', { tonumber(id) })
    PanelLog(src, 'panel', 'delete_event', nil, nil, tostring(id))
end)

-- ============================================================
-- BLIPS
-- ============================================================
lib.callback.register('apex_adminmenu:panel:blips', function(source)
    if not PanelRequire(source, { 'blips.read', 'staff.*' }, 'blips') then return {} end
    return MySQL.query.await('SELECT * FROM apex_blips ORDER BY category, label') or {}
end)

RegisterNetEvent('apex_adminmenu:panel:saveBlip', function(b)
    local src = source
    if not PanelRequire(src, { 'blips.write', 'staff.*' }, 'saveBlip') then return end
    if not b or type(b) ~= 'table' then return end
    if b.id and tonumber(b.id) then
        MySQL.query.await(
            'UPDATE apex_blips SET label=?, category=?, x=?, y=?, z=?, sprite=?, color=?, scale=?, display=?, short_range=? WHERE id=?',
            { b.label, b.category, b.x, b.y, b.z, b.sprite, b.color, b.scale, b.display, b.short_range and 1 or 0, tonumber(b.id) }
        )
    else
        MySQL.insert.await(
            'INSERT INTO apex_blips (label, category, x, y, z, sprite, color, scale, display, short_range) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            { b.label, b.category, b.x, b.y, b.z, b.sprite, b.color, b.scale, b.display, b.short_range and 1 or 0 }
        )
    end
    PanelLog(src, 'panel', 'save_blip', nil, nil, b.label)
    -- Sync to all clients.
    TriggerClientEvent('apex_adminmenu:panel:blipsSync', -1,
        MySQL.query.await('SELECT * FROM apex_blips ORDER BY category, label') or {})
end)

RegisterNetEvent('apex_adminmenu:panel:deleteBlip', function(id)
    local src = source
    if not PanelRequire(src, { 'blips.write', 'staff.*' }, 'deleteBlip') then return end
    MySQL.query.await('DELETE FROM apex_blips WHERE id=?', { tonumber(id) })
    PanelLog(src, 'panel', 'delete_blip', nil, nil, tostring(id))
    TriggerClientEvent('apex_adminmenu:panel:blipsSync', -1,
        MySQL.query.await('SELECT * FROM apex_blips ORDER BY category, label') or {})
end)

-- Sync blips on player join.
AddEventHandler('playerJoining', function()
    local src = source
    SetTimeout(3000, function()
        TriggerClientEvent('apex_adminmenu:panel:blipsSync', src,
            MySQL.query.await('SELECT * FROM apex_blips ORDER BY category, label') or {})
    end)
end)

-- ============================================================
-- STAFF CHAT — channels + DMs
-- ============================================================

-- License -> avatar URL helper (defers to the early-resolved cache,
-- so offline players also surface a Steam picture once the resolver
-- has populated the DB).
local function avatarForLicense(lic)
    return avatarForLicenseEarly(lic)
end

local function enrichMessage(m)
    m.avatar = avatarForLicense(m.author_lic)
    return m
end

-- DMs are named "dm:<sortedA>:<sortedB>" so any two licenses always
-- produce the same channel id.
local function dmChannelName(licA, licB)
    if not licA or not licB then return nil end
    if licA < licB then return ('dm:%s:%s'):format(licA, licB) end
    return ('dm:%s:%s'):format(licB, licA)
end

-- Allowed-to-read check.
local function canReadChannel(src, channelName)
    if not PanelCanOpen(src) and not (AdminPerms and AdminPerms(src)) then return false end
    if channelName == 'staff' or channelName == 'reports' then return true end
    if channelName:sub(1, 3) == 'dm:' then
        return channelName:find(getLicense(src), 1, true) ~= nil
    end
    return false
end

-- List the channels visible to this user (built-in + their own DMs).
lib.callback.register('apex_adminmenu:panel:channels', function(source)
    if not PanelCanOpen(source) then return {} end
    local myLic = getLicense(source)
    local rows  = MySQL.query.await('SELECT * FROM apex_chat_channels ORDER BY kind DESC, label') or {}
    local out = {}
    for _, r in ipairs(rows) do
        local include = true
        if r.kind == 'dm' then
            include = (r.name:find(myLic, 1, true) ~= nil)
        end
        if include then
            -- For DMs, replace the label with the *other* member's name+avatar.
            if r.kind == 'dm' then
                local ok, members = pcall(json.decode, r.members or '[]')
                if ok and members then
                    local other
                    for _, l in ipairs(members) do if l ~= myLic then other = l end end
                    if other then
                        r.label  = avatarForLicense(other) and r.label or r.label
                        r.peer   = other
                        r.avatar = avatarForLicense(other)
                    end
                end
            end
            out[#out + 1] = r
        end
    end
    return out
end)

-- Open / get-or-create a DM between source and a target player id.
lib.callback.register('apex_adminmenu:panel:openDM', function(source, targetId)
    if not PanelCanOpen(source) then return nil end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then return nil end

    local myLic     = getLicense(source)
    local theirLic  = getLicense(targetId)
    if not myLic or not theirLic or myLic == theirLic then return nil end

    local name = dmChannelName(myLic, theirLic)
    local exists = MySQL.single.await('SELECT name FROM apex_chat_channels WHERE name = ?', { name })
    if not exists then
        MySQL.insert.await(
            'INSERT INTO apex_chat_channels (name, kind, label, members) VALUES (?, ?, ?, ?)',
            { name, 'dm', GetPlayerName(targetId),
              json.encode({ myLic, theirLic }) }
        )
    end
    return {
        name   = name,
        label  = GetPlayerName(targetId),
        avatar = getAvatar(targetId),
        peer   = theirLic
    }
end)

lib.callback.register('apex_adminmenu:panel:chat', function(source, channel)
    if not canReadChannel(source, channel or 'staff') then return {} end
    channel = channel or 'staff'
    local rows = MySQL.query.await(
        'SELECT * FROM apex_staff_chat WHERE channel = ? ORDER BY created_at DESC LIMIT 200',
        { channel }
    ) or {}
    for _, m in ipairs(rows) do enrichMessage(m) end
    return rows
end)

RegisterNetEvent('apex_adminmenu:panel:chatSend', function(channel, text)
    local src = source
    channel = channel or 'staff'
    if not canReadChannel(src, channel) then
        TriggerClientEvent('apex_adminmenu:panel:toast', src, 'error',
            'You are not a member of that chat.', 6000)
        return
    end
    -- Sending needs chat.write (the Moderator and Helper seeds carry it,
    -- Admin has chat.*, Owner has *). A group without it used to get its
    -- message swallowed with no answer at all.
    if not PanelRequire(src, { 'chat.write', 'chat.*', 'staff.*' }, 'chatSend') then return end
    text = tostring(text or ''):sub(1, 500)
    if text == '' then return end

    local row = {
        channel    = channel,
        author     = GetPlayerName(src) or 'Console',
        author_lic = getLicense(src),
        text       = text,
        created_at = os.date('%Y-%m-%d %H:%M:%S')
    }
    MySQL.insert(
        'INSERT INTO apex_staff_chat (channel, author, author_lic, text) VALUES (?, ?, ?, ?)',
        { channel, row.author, row.author_lic, row.text }
    )
    enrichMessage(row)

    -- Decide who gets the message:
    --   - "staff" / "reports" → every admin with chat.read
    --   - "dm:..."            → both members in that DM
    local recipients = {}
    if channel:sub(1, 3) == 'dm:' then
        local ch = MySQL.single.await('SELECT members FROM apex_chat_channels WHERE name = ?', { channel })
        if ch then
            local ok, members = pcall(json.decode, ch.members or '[]')
            if ok and members then
                local needed = {}
                for _, l in ipairs(members) do needed[l] = true end
                for _, p in ipairs(GetPlayers()) do
                    local s = tonumber(p)
                    if needed[getLicense(s)] then recipients[s] = true end
                end
            end
        end
    else
        for _, p in ipairs(GetPlayers()) do
            local s = tonumber(p)
            if PanelHasPerm(s, 'chat.read') or PanelHasPerm(s, 'chat.*')
                or PanelHasPerm(s, 'staff.*') then
                recipients[s] = true
            end
        end
    end
    -- The author always sees their own line. The panel clears the input
    -- as soon as it sends and only draws what the server echoes back, so a
    -- sender who could write but not read watched every message vanish.
    recipients[src] = true

    for s in pairs(recipients) do
        TriggerClientEvent('apex_adminmenu:panel:chatMsg', s, row)
    end
end)

-- ============================================================
-- SETTINGS (per-staff JSON blob + global key/value store)
-- ============================================================
lib.callback.register('apex_adminmenu:panel:settings', function(source)
    if not PanelCanOpen(source) then return {} end
    local lic = getLicense(source)
    local row = MySQL.single.await('SELECT data FROM apex_staff_settings WHERE license = ?', { lic })
    if not row or not row.data then return {} end
    local ok, decoded = pcall(json.decode, row.data)
    return ok and decoded or {}
end)

RegisterNetEvent('apex_adminmenu:panel:saveSettings', function(data)
    local src = source
    if not PanelCanOpen(src) then return end
    local lic = getLicense(src)
    MySQL.insert(
        'INSERT INTO apex_staff_settings (license, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
        { lic, json.encode(data or {}) }
    )
end)

-- ── Global settings (server-wide, admin-only) ──────────────
-- Stored in apex_panel_settings as JSON-encoded values keyed by
-- dotted name (e.g. "discord.webhooks"). We expose the whole map
-- so the panel renderer can grab everything in one call.
-- Every Discord category the panel and configs/config.lua know about,
-- in display order. Declared here because both the settings writer
-- below and the route resolver further down need it.
local WEBHOOK_CATEGORIES = {
    'moderation', 'economy', 'player', 'vehicle',
    'staff', 'console', 'reports', 'login', 'global'
}
PanelWebhookCategories = WEBHOOK_CATEGORIES

-- Guarded: server/discord.lua is a separate file and the load order is
-- not ours to assume. Falling back to "accept it" is deliberate — never
-- refuse to store an operator's URL just because the validator is late.
local function validateWebhookUrl(url)
    if ApexDiscord and ApexDiscord.ValidateUrl then return ApexDiscord.ValidateUrl(url) end
    return true
end

local GlobalSettings = {}
local GlobalSettingsLoaded = false
local GlobalSettingsStoreOk = false   -- false = the table is missing / unreadable

local function loadGlobalSettings()
    local ok, rows = pcall(MySQL.query.await, 'SELECT k, v FROM apex_panel_settings')
    if not ok then
        -- Do NOT blank the cache on a read failure: whatever is already in
        -- memory is better than nothing, and wiping it here is how a
        -- transient DB hiccup used to look exactly like "the panel deleted
        -- my webhooks".
        GlobalSettingsStoreOk = false
        GlobalSettingsLoaded  = true
        print('^1[apex_adminmenu] Could not read apex_panel_settings — panel settings (Discord webhooks included) '
           .. 'cannot be saved. Import install_admin_panel.sql, then restart the resource.^0')
        return false
    end

    local fresh = {}
    for _, r in ipairs(rows or {}) do
        local okj, val = pcall(json.decode, r.v or 'null')
        fresh[r.k] = okj and val or r.v
    end
    GlobalSettings       = fresh
    GlobalSettingsStoreOk = true
    GlobalSettingsLoaded  = true
    return true
end
CreateThread(function()
    -- Wait for server/sqlinstall.lua, which CREATEs apex_panel_settings on
    -- start-up. The old flat `Wait(3000)` raced it: on a slow first DB
    -- connection the read landed before the table existed. That used to be
    -- merely cosmetic, but a failed read now marks the store unusable and
    -- would refuse every save for the rest of the session.
    local waited = 0
    while not PanelSchemaReady and waited < 30000 do
        Wait(250); waited = waited + 250
    end
    Wait(500)
    if not loadGlobalSettings() then
        Wait(5000)   -- one retry; a slow pool on shared hosting is common
        loadGlobalSettings()
    end
end)

local function getGlobal(key, fallback)
    if GlobalSettings[key] ~= nil then return GlobalSettings[key] end
    return fallback
end

--- Persist one key. Returns immediately; `cb(ok, err)` fires when the
--- write resolves.
---
--- This used to be a bare `MySQL.insert` wrapped in pcall. oxmysql's
--- non-await form runs the query on its own thread, so pcall caught
--- nothing and a failed write — missing table, dead connection, value
--- too long — was completely silent. The panel said "Settings saved",
--- the row never landed, and the URLs were gone on the next restart.
local function setGlobal(key, value, by, cb)
    GlobalSettings[key] = value

    local encoded
    local okEnc, err = pcall(function() encoded = json.encode(value) end)
    if not okEnc or type(encoded) ~= 'string' then
        print(('^1[apex_adminmenu] Refusing to save setting "%s" — it could not be encoded (%s).^0')
            :format(tostring(key), tostring(err)))
        if cb then cb(false, 'encode failed') end
        return
    end

    MySQL.insert(
        'INSERT INTO apex_panel_settings (k, v, updated_by) VALUES (?, ?, ?) '
     .. 'ON DUPLICATE KEY UPDATE v = VALUES(v), updated_by = VALUES(updated_by)',
        { key, encoded, by or '' },
        function(result)
            -- oxmysql hands back nil when the statement failed. It also
            -- prints its own error, but that scrolls past — say plainly
            -- which setting was lost so the operator can act on it.
            if result == nil then
                GlobalSettingsStoreOk = false
                print(('^1[apex_adminmenu] Failed to save panel setting "%s" to apex_panel_settings. '
                    .. 'Import install_admin_panel.sql and check the oxmysql error above.^0'):format(tostring(key)))
                if cb then cb(false, 'write failed') end
                return
            end
            GlobalSettingsStoreOk = true
            if cb then cb(true) end
        end
    )
end
PanelSetGlobalSetting = setGlobal

-- Who may read the real webhook URLs and change server-wide settings.
-- 'settings.*' / 'settings.write' are accepted alongside the older
-- 'staff.*' so a custom group built in the panel can be given exactly
-- this power without also handing over the whole staff namespace.
local function canEditGlobalSettings(src)
    return PanelHasPerm(src, '*')
        or PanelHasPerm(src, 'staff.*')
        or PanelHasPerm(src, 'settings.*')
        or PanelHasPerm(src, 'settings.write')
end
PanelCanEditSettings = canEditGlobalSettings

-- Shallow copy, one level deep for table values, so the panel can never
-- be handed a live reference to the settings cache (the UI mutates what
-- it receives — that used to mutate server state directly).
local function copySettings(src_tbl)
    local out = {}
    for k, v in pairs(src_tbl) do
        if type(v) == 'table' then
            local inner = {}
            for ik, iv in pairs(v) do inner[ik] = iv end
            out[k] = inner
        else
            out[k] = v
        end
    end
    return out
end

lib.callback.register('apex_adminmenu:panel:globalSettings', function(source)
    if not PanelCanOpen(source) then return {} end
    local copy = copySettings(GlobalSettings)
    -- Non-editors get the webhook URLs masked so we don't leak secrets to
    -- view-only mods. The mask is also flagged, so the client knows its
    -- copy is incomplete and must never send it back as a full update.
    if not canEditGlobalSettings(source) then
        copy['discord.webhooks'] = {}
        copy['_masked'] = true
    end
    copy['_storeOk'] = GlobalSettingsStoreOk
    return copy
end)

RegisterNetEvent('apex_adminmenu:panel:saveGlobalSettings', function(payload)
    local src = source

    local function ack(ok, message)
        TriggerClientEvent('apex_adminmenu:panel:globalSettingsSaved', src, ok, message,
            ok and copySettings(GlobalSettings) or nil)
    end

    if not canEditGlobalSettings(src) then
        -- Previously a silent `return`. The panel showed "Settings saved."
        -- anyway, so an under-privileged admin typed webhook URLs, was told
        -- it worked, and found the fields empty on the next open — which is
        -- exactly what "the panel deletes my webhooks" turned out to be.
        ack(false, 'You do not have permission to change server settings (needs settings.* or staff.*).')
        return
    end
    if type(payload) ~= 'table' then
        ack(false, 'Malformed settings payload.')
        return
    end
    if not GlobalSettingsStoreOk then
        -- Re-probe before giving up: the flag may be stale from a read that
        -- happened while the schema was still being installed.
        loadGlobalSettings()
    end
    if not GlobalSettingsStoreOk then
        ack(false, 'The apex_panel_settings table is not readable — import install_admin_panel.sql, then restart the resource.')
        return
    end

    local by       = GetPlayerName(src) or 'Console'
    local rejected = {}

    -- Webhooks are merged key-by-key rather than replaced wholesale.
    --
    -- The client ships its entire settings object on save. If that object
    -- was ever built from a masked read, or from a page that rendered
    -- before the settings callback resolved, a plain replace wipes every
    -- URL on the server. Merging makes a partial or stale payload harmless:
    -- the worst it can do is leave things as they were.
    local incoming = payload['discord.webhooks']
    payload['discord.webhooks'] = nil   -- handled here, not by the generic loop

    if type(incoming) == 'table' then
        local current = getGlobal('discord.webhooks', {})
        if type(current) ~= 'table' then current = {} end

        local merged, changed = {}, false
        for k, v in pairs(current) do merged[k] = v end

        for _, key in ipairs(WEBHOOK_CATEGORIES) do
            local v = incoming[key]
            if v ~= nil then
                local url = tostring(v):gsub('^%s*(.-)%s*$', '%1')
                if url == '' then
                    -- Explicitly cleared in the UI: honour it.
                    if merged[key] ~= nil and merged[key] ~= '' then changed = true end
                    merged[key] = ''
                else
                    local okUrl, reason = validateWebhookUrl(url)
                    if okUrl then
                        if merged[key] ~= url then changed = true end
                        merged[key] = url
                    else
                        -- Keep whatever was there rather than storing junk,
                        -- and tell the operator why it didn't take.
                        rejected[#rejected + 1] = ('%s (%s)'):format(key, tostring(reason))
                    end
                end
            end
        end

        if #rejected > 0 then
            print('^3[apex_adminmenu] Rejected webhook URL(s): ' .. table.concat(rejected, ', ')
                .. '. A Discord webhook looks like https://discord.com/api/webhooks/<id>/<token>.^0')
        end
        if changed then
            payload['discord.webhooks'] = merged
        end
    elseif incoming ~= nil then
        print('^3[apex_adminmenu] Ignoring discord.webhooks — expected a table, got ' .. type(incoming) .. '.^0')
    end

    -- One ack for the whole save, fired when the last write resolves.
    local pending, failed, answered = 0, false, false
    local function finish()
        if answered then return end
        answered = true
        if failed then
            ack(false, 'Some settings could not be written — check the server console.')
        elseif #rejected > 0 then
            ack(false, 'Saved, except these routes which are not valid Discord webhook URLs: '
                .. table.concat(rejected, ', '))
        else
            ack(true, 'Settings saved.')
        end
    end

    -- Count first, dispatch second. setGlobal can answer synchronously
    -- (a value that fails to encode never reaches the DB), which with a
    -- counter incremented inside the loop would drive `pending` back to
    -- zero mid-flight and ack before the remaining writes were issued.
    local keys = {}
    for k in pairs(payload) do
        -- Never let the client write our own diagnostic markers back.
        if k ~= '_masked' and k ~= '_storeOk' then keys[#keys + 1] = k end
    end
    pending = #keys

    for _, k in ipairs(keys) do
        setGlobal(k, payload[k], by, function(ok)
            if not ok then failed = true end
            pending = pending - 1
            if pending == 0 then finish() end
        end)
    end
    if pending == 0 then finish() end

    PanelLog(src, 'panel', 'save_global_settings', nil, nil, nil)
end)

-- ============================================================
-- Discord webhook helper
-- ============================================================
local function discordEnabled()
    -- A value stored by the panel wins. With nothing stored we honour
    -- configs/config.lua, so an operator who only ever edits the file
    -- still gets the behaviour they asked for.
    local stored = getGlobal('discord.enabled', nil)
    if stored ~= nil then return stored ~= false end
    if Config and Config.Webhooks and Config.Webhooks.enabled == false then return false end
    return true
end

-- A blank/whitespace string is "not configured", not a URL. This
-- matters because in Lua '' is TRUTHY: the Settings UI writes an empty
-- string for every category the admin ever typed into (and the Clear
-- button writes '' explicitly), so a naive `hooks[cat] or hooks.global`
-- short-circuits on '' and drops the message instead of falling back.
local function usableUrl(v)
    if type(v) ~= 'string' then return nil end
    local t = v:gsub('^%s*(.-)%s*$', '%1')
    return t ~= '' and t or nil
end

-- Routes configured in configs/config.lua. These are the operator's
-- file-based setup and can never be erased by the panel, so they act as
-- the backstop underneath whatever the database holds.
local function configRoute(category)
    local w = Config and Config.Webhooks
    if type(w) ~= 'table' then return nil end
    local routes = w.routes
    if type(routes) == 'table' and category then
        local hit = usableUrl(routes[category])
        if hit then return hit end
    end
    return nil
end

-- Resolve the webhook for a category.
--
-- Most specific first, and config.lua is checked BEFORE falling back to
-- a catch-all so that a per-category route in the file is not shadowed
-- by a global route in the database:
--   1. panel route for this category
--   2. config.lua route for this category
--   3. panel catch-all           ("global")
--   4. config.lua catch-all      (routes.global, then Config.Webhooks.url)
-- Returns the URL plus where it came from ('panel' | 'config'), because
-- the bot identity has to follow the route's source — see discordSend.
local function discordWebhookFor(category)
    local hooks = getGlobal('discord.webhooks', {}) or {}
    if type(hooks) ~= 'table' then hooks = {} end

    local hit = usableUrl(hooks[category]);          if hit then return hit, 'panel'  end
    hit = configRoute(category);                     if hit then return hit, 'config' end
    hit = usableUrl(hooks.global);                   if hit then return hit, 'panel'  end
    hit = configRoute('global');                     if hit then return hit, 'config' end
    hit = usableUrl(Config and Config.Webhooks and Config.Webhooks.url)
    if hit then return hit, 'config' end
    return nil
end

local function eventGroupAllowed(group)
    local evt = getGlobal('discord.log_events', {}) or {}
    if type(evt) ~= 'table' then return true end
    return evt[group] ~= false
end

-- Fire-and-forget webhook send. `embed` is a Lua table mapped 1:1
-- to a Discord embed object (title/description/color/fields/footer/timestamp).
-- Delivery, retries, payload sanitising and error reporting all live in
-- server/discord.lua.
local function discordSend(category, embed)
    -- Settings are read from the DB once the schema installer has finished.
    -- Anything logged before that (player connects during startup, console
    -- commands) used to be silently thrown away because the webhook map
    -- was still empty.
    if not GlobalSettingsLoaded then
        CreateThread(function()
            local waited = 0
            while not GlobalSettingsLoaded and waited < 30000 do
                Wait(250); waited = waited + 250
            end
            if GlobalSettingsLoaded then discordSend(category, embed) end
        end)
        -- Optimistic: we genuinely will try once settings land, so callers
        -- must not treat this as "no panel route" and double-send.
        return true
    end

    if not discordEnabled() then return false end
    if not eventGroupAllowed(category) then
        -- Muted on purpose — report handled so nothing else re-sends it.
        return true
    end

    local url, origin = discordWebhookFor(category)
    if not url then return false end

    -- The identity follows the route's SOURCE. Anything landing on the
    -- config.lua webhook must still show the bot name set in config.lua:
    -- now that the legacy quick-menu sender falls through to this
    -- dispatcher, using the panel's identity unconditionally would rename
    -- the operator's bot out from under them.
    local username, avatar
    if origin == 'config' and Config and Config.Webhooks then
        username = Config.Webhooks.botName
        avatar   = Config.Webhooks.botAvatar
    end
    if type(username) ~= 'string' or username == '' then
        username = getGlobal('discord.username', 'Apex Admin')
    end
    if type(avatar) ~= 'string' or avatar == '' then
        avatar = getGlobal('discord.avatar', '')
    end
    if type(avatar) ~= 'string' or avatar == '' then avatar = nil end

    return ApexDiscord.SendEmbed(url, embed, {
        username   = username,
        avatar_url = avatar
    })
end

-- Used by the `apexdiscord` console command to show what is routed
-- where. Names the SOURCE of every route, because "I set it and it
-- still doesn't log" is almost always a route resolving somewhere the
-- operator didn't expect.
function ApexDiscordDescribeRoutes()
    local out   = {}
    local hooks = getGlobal('discord.webhooks', {}) or {}
    local evt   = getGlobal('discord.log_events', {}) or {}

    if not GlobalSettingsLoaded then
        out[#out + 1] = '^3Settings not loaded from the database yet (this is normal in the first seconds after boot).^0'
    end
    if not discordEnabled() then
        out[#out + 1] = '^3Discord logging is DISABLED in panel settings.^0'
    end
    if type(hooks) ~= 'table' then
        out[#out + 1] = '^1discord.webhooks is not a table — the settings row is corrupt. Run: apexwebhook reset^0'
        hooks = {}
    end

    local any = false
    for _, key in ipairs(WEBHOOK_CATEGORIES) do
        -- Report where the route actually comes from, not just that one exists.
        local origin, raw
        if usableUrl(hooks[key])   then origin, raw = 'panel',      hooks[key]
        elseif configRoute(key)    then origin, raw = 'config.lua', configRoute(key)
        elseif usableUrl(hooks.global)   then origin, raw = 'panel (catch-all)',      hooks.global
        elseif configRoute('global')     then origin, raw = 'config.lua (catch-all)', configRoute('global')
        elseif usableUrl(Config and Config.Webhooks and Config.Webhooks.url) then
            origin, raw = 'config.lua (Webhooks.url)', Config.Webhooks.url
        end

        local ok, reason = false, 'not configured'
        if raw then ok, reason = ApexDiscord.ValidateUrl(raw) end
        if ok and origin == 'panel' then any = true end

        local muted = (type(evt) == 'table' and evt[key] == false) and '  ^3(events muted)^0' or ''
        if not raw then
            out[#out + 1] = ('%-11s ^3—^0%s'):format(key, muted)
        elseif ok then
            out[#out + 1] = ('%-11s ^2OK^0  via %s%s'):format(key, origin, muted)
        else
            out[#out + 1] = ('%-11s ^1BAD^0 via %s (%s)%s'):format(key, origin, tostring(reason), muted)
        end
    end

    if not any then
        out[#out + 1] = '^3No per-category webhook is saved in the panel. Set one with'
                     .. ' `apexwebhook <category> <url>` or in F6 -> Settings -> Discord.^0'
    end
    return out
end
-- Expose globally so other resources / files in this resource can use it.
PanelDiscordSend = discordSend

-- ── Test webhook ───────────────────────────────────────────
-- Fires one test embed down EVERY category route, not just the
-- catch-all. "Send test message to all configured webhooks" said all,
-- and only ever proved the global route worked — so a per-category
-- route that was mistyped still looked healthy.
RegisterNetEvent('apex_adminmenu:panel:testWebhook', function()
    local src = source
    if not canEditGlobalSettings(src) then return end
    local who = GetPlayerName(src) or 'Console'

    local seen, sent = {}, 0
    for _, category in ipairs(WEBHOOK_CATEGORIES) do
        local url = discordWebhookFor(category)
        -- One message per distinct URL: with a single catch-all configured
        -- every category resolves to it, and nobody wants nine copies.
        if url and not seen[url] then
            seen[url] = true
            sent = sent + 1
            discordSend(category, {
                title       = '✅ Webhook test',
                description = ('Triggered by **%s**.\nThis channel is receiving the **%s** route.')
                    :format(who, category),
                color       = 0x1A7249,
                timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
            })
        end
    end

    if sent == 0 then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Discord',
            'No webhook is configured yet — nothing to test.', 'error')
    end
end)

-- ============================================================
-- Console: read and write the webhook routes without the panel
-- ------------------------------------------------------------
-- `apexwebhook <category> <url>` is the escape hatch for exactly the
-- situation this whole block exists for: the operator cannot get a URL
-- to stick from the UI and needs a path that reports its own result.
-- Server console only — these print secrets.
-- ============================================================
local function isKnownCategory(name)
    for _, k in ipairs(WEBHOOK_CATEGORIES) do
        if k == name then return true end
    end
    return false
end

RegisterCommand('apexwebhook', function(src, args)
    if src ~= 0 then return end   -- server console only

    local function usage()
        print('^5[apex_adminmenu] Discord webhook routes^0')
        print('  apexwebhook                      list every route and where it resolves from')
        print('  apexwebhook <category> <url>     set a route')
        print('  apexwebhook <category> clear     remove a route')
        print('  apexwebhook reset                clear ALL routes stored by the panel')
        print('  categories: ' .. table.concat(WEBHOOK_CATEGORIES, ', '))
    end

    local sub = args[1] and tostring(args[1]):lower() or nil

    if not sub then
        usage()
        print('')
        for _, line in ipairs(ApexDiscordDescribeRoutes()) do print('  ' .. line) end
        return
    end

    if not GlobalSettingsLoaded then
        print('^3[apex_adminmenu] Settings have not finished loading from the database yet — try again in a moment.^0')
        return
    end
    if not GlobalSettingsStoreOk then
        print('^1[apex_adminmenu] apex_panel_settings is not readable — import install_admin_panel.sql first. '
           .. 'Until then, use Config.Webhooks.routes in configs/config.lua.^0')
        return
    end

    local hooks = getGlobal('discord.webhooks', {})
    if type(hooks) ~= 'table' then hooks = {} end
    local merged = {}
    for k, v in pairs(hooks) do merged[k] = v end

    if sub == 'reset' then
        setGlobal('discord.webhooks', {}, 'console', function(ok)
            print(ok and '^2[apex_adminmenu] All panel webhook routes cleared.^0'
                      or '^1[apex_adminmenu] Reset failed — see the error above.^0')
        end)
        return
    end

    if not isKnownCategory(sub) then
        print(('^1Unknown category "%s".^0'):format(tostring(args[1])))
        usage()
        return
    end

    local value = args[2]
    if not value then
        local resolved = discordWebhookFor(sub)
        print(('%s -> %s'):format(sub, resolved or 'not configured'))
        return
    end

    if tostring(value):lower() == 'clear' then
        merged[sub] = ''
        setGlobal('discord.webhooks', merged, 'console', function(ok)
            print(ok and ('^2[apex_adminmenu] Route "%s" cleared.^0'):format(sub)
                      or '^1[apex_adminmenu] Write failed — see the error above.^0')
        end)
        return
    end

    -- Rejoin: a URL should never contain spaces, but a stray paste can,
    -- and silently keeping only the first fragment is worse than trying.
    local url = table.concat(args, ' ', 2):gsub('^%s*(.-)%s*$', '%1')
    local okUrl, reason = validateWebhookUrl(url)
    if not okUrl then
        print(('^1Not a usable Discord webhook URL (%s).^0'):format(tostring(reason)))
        print('  Expected: https://discord.com/api/webhooks/<id>/<token>')
        return
    end

    merged[sub] = url
    setGlobal('discord.webhooks', merged, 'console', function(ok)
        if not ok then
            print('^1[apex_adminmenu] Write failed — the route is active in memory but will not survive a restart.^0')
            return
        end
        print(('^2[apex_adminmenu] Route "%s" saved.^0'):format(sub))
        discordSend(sub, {
            title       = '✅ Webhook route configured',
            description = ('The **%s** route was set from the server console.'):format(sub),
            color       = 0x1A7249,
            timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
        })
        print('  A confirmation embed was queued — if it does not arrive, run `apexdiscord` for the delivery stats.')
    end)
end, true)

-- ============================================================
-- Per-staff keybinds
-- ============================================================
lib.callback.register('apex_adminmenu:panel:keybinds', function(source)
    if not PanelCanOpen(source) then return nil end
    local lic = getLicense(source)
    local row = MySQL.single.await('SELECT data FROM apex_staff_keybinds WHERE license = ?', { lic })
    if not row or not row.data then return nil end
    local ok, decoded = pcall(json.decode, row.data)
    return ok and decoded or nil
end)

-- Panel toggle for the floating "[STAFF] <Name>" tag above the
-- admin's head. Delegates to the shared ApplyStaffTagFor helper in
-- stafftag.lua so the broadcast / tag drawing path stays unchanged.
RegisterNetEvent('apex_adminmenu:panel:setStaffTag', function(enabled)
    local src = source
    if not PanelCanOpen(src) then return end
    if ApplyStaffTagFor then
        ApplyStaffTagFor(src, enabled and true or false, GetPlayerName(src) or 'Staff')
    end
end)

RegisterNetEvent('apex_adminmenu:panel:saveKeybinds', function(data)
    local src = source
    if not PanelCanOpen(src) then
        PanelDeny(src, nil, 'saveKeybinds')
        return
    end
    if type(data) ~= 'table' then return end
    local lic = getLicense(src)
    -- Awaited, in a pcall: the fire-and-forget insert this used to be
    -- reported nothing when the row did not land (table missing, DB user
    -- without INSERT, connection dropped), so the key showed as changed in
    -- the list, worked until the next restart, and was then "gone".
    local ok, err = pcall(MySQL.insert.await,
        'INSERT INTO apex_staff_keybinds (license, data) VALUES (?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
        { lic, json.encode(data) }
    )
    if not ok then
        TriggerClientEvent('apex_adminmenu:panel:toast', src, 'error',
            ('Keybinds were NOT saved: %s. The row goes to apex_staff_keybinds; run install_admin_panel.sql if the table is missing.')
                :format(tostring(err)), 10000)
        return
    end
    -- Push the live update so the client can rebind without a reconnect.
    TriggerClientEvent('apex_adminmenu:panel:keybindsUpdated', src, data)
    TriggerClientEvent('apex_adminmenu:panel:toast', src, 'success', 'Keybinds saved.', 2500)
end)

-- ============================================================
-- JOBS — list, create, edit, delete (jobs + grades)
--
-- Sources of truth, picked in this priority order:
--   • QBox  (qbx_core)   → exports['qbx_core']:GetJobs()
--   • QBCore             → QBCore.Shared.Jobs
--   • ESX                → `jobs` + `job_grades` DB tables
--
-- For QBCore/QBox we mirror every save into our own
-- `apex_jobs_overrides` table so changes survive a restart;
-- the resource start-up replays the overrides back into the core.
-- ============================================================
-- Permission gating is intentionally lenient: any staff member who
-- can open the panel and has `players.*` or staff-level access can
-- see the jobs list. Writing is also accepted when the admin already
-- has `staff.*` (the panel's authoritative "operator" perm) so the
-- feature works out-of-the-box without forcing a SQL update to the
-- existing apex_staff_groups rows.
-- Both answer the admin when they refuse (PanelRequire), so "no changes in
-- the Jobs page" names the missing key instead of looking like a dead button.
local function jobsPermCheck(src, what)
    if not PanelCanOpen(src) then PanelDeny(src, nil, what or 'jobs'); return false end
    return PanelRequire(src, { '*', 'jobs.read', 'jobs.*', 'players.*', 'staff.*', 'players.read' }, what or 'jobs')
end
local function jobsWriteCheck(src, what)
    if not PanelCanOpen(src) then PanelDeny(src, nil, what or 'saveJob'); return false end
    return PanelRequire(src, { '*', 'jobs.write', 'jobs.*', 'staff.*' }, what or 'saveJob')
end

-- Detect which framework variant we're running on top of.
local function detectJobsBackend()
    if GetResourceState and GetResourceState('qbx_core') == 'started' then return 'qbox' end
    if Framework == 'qb' and QBCore then return 'qbcore' end
    return 'esx'
end

-- Lazy QBox getter — only loaded if qbx_core is up.
local function qbxJobs()
    if GetResourceState and GetResourceState('qbx_core') == 'started' then
        local ok, jobs = pcall(function() return exports.qbx_core:GetJobs() end)
        if ok and type(jobs) == 'table' then return jobs end
    end
    return nil
end

-- Quick helper to count how many players have a given job.
local function countJobUsage(jobName)
    if not jobName or jobName == '' then return 0 end
    local backend = detectJobsBackend()
    if backend == 'qbox' or backend == 'qbcore' then
        local row = safeSingle('SELECT COUNT(*) AS c FROM players WHERE JSON_EXTRACT(job, "$.name") = ?', { jobName })
        return (row and tonumber(row.c)) or 0
    else
        local row = safeSingle('SELECT COUNT(*) AS c FROM users WHERE job = ?', { jobName })
        return (row and tonumber(row.c)) or 0
    end
end

-- Same counts, one query. countJobUsage above runs an awaited COUNT(*) per
-- job, so opening the Jobs page on a server with 60 jobs meant 60 sequential
-- round-trips before the list could be sent.
local function jobUsageMap()
    local rows
    if detectJobsBackend() == 'esx' then
        rows = safeQuery('SELECT job AS name, COUNT(*) AS c FROM users GROUP BY job')
    else
        rows = safeQuery('SELECT JSON_UNQUOTE(JSON_EXTRACT(job, "$.name")) AS name, '
                      .. 'COUNT(*) AS c FROM players GROUP BY name')
    end
    local out = {}
    for _, r in ipairs(rows or {}) do
        if r.name then out[tostring(r.name)] = tonumber(r.c) or 0 end
    end
    return out
end

-- ESX's in-memory job table — the SAME table xPlayer.setJob() validates
-- against. Reading the `jobs` DB table instead is why the panel could offer
-- a job that ESX then refused with
--     [ESX] [WARNING] Ignoring invalid .setJob() usage for ID: 1, Job: vagos
-- A job added to the database after es_extended booted, or one with no rows
-- in `job_grades`, exists for us and does not exist for ESX.
local function esxJobPool()
    if Framework ~= 'esx' or not ESX then return nil end
    local ok, jobs = pcall(function()
        if ESX.GetJobs then return ESX.GetJobs() end
        return ESX.Jobs
    end)
    if not ok or type(jobs) ~= 'table' or next(jobs) == nil then return nil end
    return jobs
end

--- Would ESX accept this job/grade pair? Returns false + a reason when not.
--- @return boolean ok, string|nil reason
local function esxJobAccepts(name, grade)
    local pool = esxJobPool()
    if not pool then return true end          -- can't tell — let ESX decide
    local job = pool[name]
    if not job then
        return false, ('ESX has no job named "%s" loaded. It may exist in the '
                    .. '`jobs` table but was added after the server started — '
                    .. 'restart es_extended (or the server) to load it.'):format(tostring(name))
    end
    local grades = job.grades or {}
    if grades[tostring(grade)] == nil and grades[tonumber(grade) or -1] == nil then
        local have = {}
        for g in pairs(grades) do have[#have + 1] = tostring(g) end
        table.sort(have)
        return false, ('Job "%s" has no grade %s. Available: %s'):format(
            tostring(name), tostring(grade),
            #have > 0 and table.concat(have, ', ') or '(none — the job has no rows in job_grades)')
    end
    return true
end
ApexEsxJobAccepts = esxJobAccepts

-- Jobs + grades straight from the ESX tables, keyed by job name. This is the
-- state the server boots into, so it is the one a save has to be judged
-- against — the in-memory pool above only says what ESX accepts right now.
local function esxJobsFromDb()
    local rows = safeQuery('SELECT name, label FROM jobs')
    if #rows == 0 then return {} end
    local grdRs = safeQuery('SELECT job_name, grade, name, label, salary, skin_male, skin_female FROM job_grades')
    if #grdRs == 0 then
        -- Legacy schemas without the label / skin_* columns.
        grdRs = safeQuery('SELECT job_name, grade, name, salary FROM job_grades')
    end
    local byJob = {}
    for _, g in ipairs(grdRs) do
        local list = byJob[g.job_name]
        if not list then list = {}; byJob[g.job_name] = list end
        list[#list + 1] = {
            grade       = tonumber(g.grade) or 0,
            name        = g.name,
            label       = g.label or g.name,
            payment     = tonumber(g.salary) or 0,
            salary      = tonumber(g.salary) or 0,
            skin_male   = g.skin_male,
            skin_female = g.skin_female
        }
    end
    local out = {}
    for _, r in ipairs(rows) do
        local grades = byJob[r.name] or {}
        table.sort(grades, function(a, b) return a.grade < b.grade end)
        out[r.name] = { name = r.name, label = r.label or r.name, grades = grades }
    end
    return out
end

-- ESX reads `jobs` / `job_grades` into memory exactly once, at boot
-- (es_extended/server/common.lua calls ESX.RefreshJobs there and nowhere
-- else). Writing to those tables therefore changed nothing for a running
-- server: xPlayer.setJob() kept refusing the new job, and the panel's own
-- list — which reads that same pool — showed the job, or a newly added
-- grade, vanish the instant the page reloaded after a save.
--
-- So ask ESX to re-read the tables. `refreshjobs` is the console-allowed
-- admin command es_extended registers for exactly this, and covers forks
-- whose shared object does not expose the function.
local function esxRefreshJobs()
    if Framework ~= 'esx' then return false end
    if ESX and ESX.RefreshJobs then
        local ok = pcall(function() ESX.RefreshJobs() end)
        if ok then return true end
    end
    return pcall(ExecuteCommand, 'refreshjobs') == true
end

-- QBCore hands out a COPY of its core object (exports are serialised across
-- resource boundaries), so the `QBCore` the bridge grabbed at start-up holds
-- a snapshot of Shared.Jobs from that moment. AddJob updates qb-core's table,
-- never ours — the same disappearing-job symptom as ESX, one framework over.
-- Re-fetch on every read.
local function qbSharedJobs()
    local ok, jobs = pcall(function() return exports['qb-core']:GetCoreObject().Shared.Jobs end)
    if ok and type(jobs) == 'table' and next(jobs) ~= nil then return jobs end
    return (QBCore and QBCore.Shared and QBCore.Shared.Jobs) or {}
end

-- Used by QBCore/QBox so edits survive a restart.
local function persistJobOverride(name, payload)
    if not name or name == '' then return end
    pcall(function()
        MySQL.insert.await(
            'INSERT INTO apex_jobs_overrides (name, data) VALUES (?, ?) '
         .. 'ON DUPLICATE KEY UPDATE data = VALUES(data)',
            { name, json.encode(payload) }
        )
    end)
end
local function dropJobOverride(name)
    if not name or name == '' then return end
    pcall(function()
        MySQL.query.await('DELETE FROM apex_jobs_overrides WHERE name = ?', { name })
    end)
end

-- Re-apply persisted QB/QBox overrides on resource start so
-- panel-created jobs survive a server restart.
AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    SetTimeout(3500, function()
        local backend = detectJobsBackend()
        if backend == 'esx' then return end   -- ESX already persists natively
        local rows = safeQuery('SELECT name, data FROM apex_jobs_overrides') or {}
        for _, r in ipairs(rows) do
            local ok, payload = pcall(json.decode, r.data)
            if ok and payload then
                local jobObj = {
                    label       = payload.label or r.name,
                    defaultDuty = payload.defaultDuty and true or false,
                    offDutyPay  = payload.offDutyPay  and true or false,
                    type        = payload.type or 'none',
                    grades      = {}
                }
                for _, g in ipairs(payload.grades or {}) do
                    jobObj.grades[tostring(tonumber(g.grade) or 0)] = {
                        name    = g.name or ('grade_' .. tostring(g.grade or 0)),
                        payment = tonumber(g.payment) or 0,
                        isboss  = g.isboss and true or false
                    }
                end
                -- Update first: a job edited in the panel already exists in
                -- the core's shared.lua, and AddJob refuses those outright,
                -- which is how an edit could survive the save and still be
                -- missing after the restart that was supposed to apply it.
                -- The return value matters: UpdateJob answers
                -- false, 'job_not_exists' for a name the core has never
                -- seen, and that one has to fall through to AddJob.
                local ok, applied = pcall(function()
                    if backend == 'qbox' then
                        return exports.qbx_core:UpdateJob(r.name, jobObj)
                    elseif QBCore then
                        return QBCore.Functions.UpdateJob(r.name, jobObj)
                    end
                    return false
                end)
                if not (ok and applied) then
                    if backend == 'qbox' then
                        pcall(function() exports.qbx_core:AddJob(r.name, jobObj) end)
                    elseif backend == 'qbcore' and QBCore then
                        pcall(function() QBCore.Functions.AddJob(r.name, jobObj) end)
                    end
                end
            end
        end
        if #rows > 0 then
            print(('^2[apex_adminmenu]^7 replayed %d job override(s) into %s'):format(#rows, backend))
        end
    end)
end)

lib.callback.register('apex_adminmenu:panel:jobs', function(source)
    -- Both prints here used to be unconditional. The Jobs page refreshes on
    -- open and on every save, so a customer's console filled with
    --   jobs callback OK for source 1 — backend=esx, 14 job(s)
    -- three times in a row for a completely healthy request. Diagnostics
    -- belong behind Config.Debug.
    local debug = Config and Config.Debug

    if not jobsPermCheck(source) then
        if debug then
            print(('^3[apex_adminmenu]^7 jobs callback DENIED for source %s (no perm)'):format(tostring(source)))
        end
        return { jobs = {}, framework = Framework, backend = 'unknown' }
    end

    local backend  = detectJobsBackend()
    local usage    = jobUsageMap()
    local jobs     = {}

    if backend == 'qbox' or backend == 'qbcore' then
        local pool = backend == 'qbox' and qbxJobs() or qbSharedJobs() or {}
        for name, j in pairs(pool) do
            local grades = {}
            for gi, g in pairs(j.grades or {}) do
                grades[#grades + 1] = {
                    grade   = tonumber(gi) or 0,
                    name    = g.name,
                    label   = g.name,
                    payment = tonumber(g.payment) or 0,
                    isboss  = g.isboss and true or false
                }
            end
            table.sort(grades, function(a, b) return a.grade < b.grade end)
            jobs[#jobs + 1] = {
                name        = name,
                label       = j.label or name,
                defaultDuty = j.defaultDuty,
                offDutyPay  = j.offDutyPay,
                type        = j.type,
                grades      = grades,
                usage       = usage[name] or 0
            }
        end
    else
        -- ESX keeps two versions of the truth: the `jobs` / `job_grades`
        -- tables (what the server boots into) and its in-memory pool (what
        -- xPlayer.setJob() accepts right now). Reading only the pool is why
        -- a job or a grade saved seconds earlier "disappeared" on refresh;
        -- reading only the tables is what produced
        -- "[ESX] [WARNING] Ignoring invalid .setJob() usage" for a job ESX
        -- had never loaded. So show the database — it is what the operator
        -- just wrote and what survives a restart — and flag every entry the
        -- running ESX has not picked up yet.
        local pool   = esxJobPool()
        local dbJobs = esxJobsFromDb()
        local seen   = {}

        for name, j in pairs(dbJobs) do
            seen[name] = true
            local pending = false
            if pool then
                local live = pool[name]
                if not live then
                    pending = true
                else
                    local n = 0
                    for _ in pairs(live.grades or {}) do n = n + 1 end
                    pending = n ~= #j.grades
                end
            end
            jobs[#jobs + 1] = {
                name    = name,
                label   = j.label,
                grades  = j.grades,
                usage   = usage[name] or 0,
                pending = pending or nil
            }
        end

        -- Anything ESX holds that the tables do not (a fork seeding jobs
        -- from a config file, or a DB we could not read) still belongs in
        -- the list.
        for name, j in pairs(pool or {}) do
            if not seen[name] then
                local grades = {}
                for gi, g in pairs(j.grades or {}) do
                    grades[#grades + 1] = {
                        grade       = tonumber(gi) or 0,
                        name        = g.name,
                        label       = g.label or g.name,
                        payment     = tonumber(g.salary) or 0,
                        salary      = tonumber(g.salary) or 0,
                        skin_male   = g.skin_male,
                        skin_female = g.skin_female
                    }
                end
                table.sort(grades, function(a, b) return a.grade < b.grade end)
                jobs[#jobs + 1] = {
                    name   = name,
                    label  = j.label or name,
                    grades = grades,
                    usage  = usage[name] or 0
                }
            end
        end
    end

    table.sort(jobs, function(a, b) return (a.label or a.name):lower() < (b.label or b.name):lower() end)
    if debug then
        print(('^2[apex_adminmenu]^7 jobs callback OK for source %s — backend=%s, %d job(s)'):format(
            tostring(source), backend, #jobs))
    end
    return { jobs = jobs, framework = Framework or 'unknown', backend = backend }
end)

RegisterNetEvent('apex_adminmenu:panel:saveJob', function(payload)
    local src = source
    if not jobsWriteCheck(src) then return end
    if type(payload) ~= 'table' then return end
    local name    = tostring(payload.name or ''):lower():gsub('[^a-z0-9_%-]', '')
    local label   = tostring(payload.label or name)
    local oldName = payload.oldName and tostring(payload.oldName) or nil
    local grades  = payload.grades or {}
    if name == '' or label == '' then return end

    -- Sanity: at least one grade so players assigned to this job don't
    -- end up in an invalid state.
    if #grades == 0 then
        grades = { { grade = 0, name = 'unemployed', label = 'Unemployed', payment = 0 } }
    end

    local backend = detectJobsBackend()

    if backend == 'qbox' or backend == 'qbcore' then
        local jobGrades = {}
        for _, g in ipairs(grades) do
            local gi = tostring(tonumber(g.grade) or 0)
            jobGrades[gi] = {
                name    = g.name or g.label or ('grade_' .. gi),
                payment = tonumber(g.payment) or 0,
                isboss  = g.isboss and true or false
            }
        end
        local jobObj = {
            label       = label,
            defaultDuty = payload.defaultDuty and true or false,
            offDutyPay  = payload.offDutyPay  and true or false,
            type        = payload.type or 'none',
            grades      = jobGrades
        }
        if oldName and oldName ~= '' and oldName ~= name then
            if backend == 'qbox' then
                pcall(function() exports.qbx_core:RemoveJob(oldName) end)
            else
                pcall(function() QBCore.Functions.RemoveJob(oldName) end)
            end
            dropJobOverride(oldName)
        end
        -- AddJob REFUSES a name the core already knows — qb-core returns
        -- false, 'job_exists' and changes nothing. Every edit to an existing
        -- job was therefore a no-op on the running server (it only came back
        -- after a restart, when the override replay hit a core that had not
        -- loaded it yet). UpdateJob is the one that replaces a live job.
        local pool    = backend == 'qbox' and (qbxJobs() or {}) or qbSharedJobs()
        local exists  = pool[name] ~= nil
        local applied = false
        if exists then
            local ok, res = pcall(function()
                if backend == 'qbox' then
                    return exports.qbx_core:UpdateJob(name, jobObj)
                end
                return QBCore.Functions.UpdateJob(name, jobObj)
            end)
            applied = ok and res ~= false    -- nil = a fork that returns nothing
        end
        if not applied then
            -- New job, or a core with no UpdateJob (older qb-core / a fork).
            pcall(function()
                if backend == 'qbox' then
                    exports.qbx_core:AddJob(name, jobObj)
                else
                    QBCore.Functions.AddJob(name, jobObj)
                end
            end)
        end
        TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Jobs', name, jobObj)
        persistJobOverride(name, {
            label       = label,
            type        = jobObj.type,
            defaultDuty = jobObj.defaultDuty,
            offDutyPay  = jobObj.offDutyPay,
            grades      = grades
        })
        TriggerClientEvent('apex_adminmenu:notify', src, 'Job saved',
            ('"%s" saved with %d grade(s).'):format(label, #grades), 'success')
        PanelLog(src, 'panel', 'save_job', nil, nil, name)
    else
        -- ESX: persist into `jobs` + `job_grades`.
        if oldName and oldName ~= '' and oldName ~= name then
            pcall(function()
                MySQL.query.await('DELETE FROM jobs WHERE name = ?', { oldName })
                MySQL.query.await('DELETE FROM job_grades WHERE job_name = ?', { oldName })
            end)
        end
        pcall(function()
            MySQL.insert.await(
                'INSERT INTO jobs (name, label) VALUES (?, ?) '
             .. 'ON DUPLICATE KEY UPDATE label = VALUES(label)',
                { name, label }
            )
            MySQL.query.await('DELETE FROM job_grades WHERE job_name = ?', { name })
            for _, g in ipairs(grades) do
                local gnum  = tonumber(g.grade) or 0
                local gname = g.name  or ('grade_' .. tostring(gnum))
                local glab  = g.label or g.name or ('Grade ' .. tostring(gnum))
                local gpay  = tonumber(g.payment) or tonumber(g.salary) or 0
                -- One INSERT per grade, each in its own pcall: the grades
                -- were deleted a line ago, so letting the first bad row
                -- abort the loop would leave the job with fewer grades than
                -- it started with. The retry covers `job_grades` tables
                -- without the label / skin_* columns, which the read path
                -- already expects.
                local ok = pcall(MySQL.insert.await,
                    'INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) '
                 .. 'VALUES (?, ?, ?, ?, ?, ?, ?)',
                    { name, gnum, gname, glab, gpay, g.skin_male or '{}', g.skin_female or '{}' })
                if not ok then
                    pcall(MySQL.insert.await,
                        'INSERT INTO job_grades (job_name, grade, name, salary) VALUES (?, ?, ?, ?)',
                        { name, gnum, gname, gpay })
                end
            end
        end)

        -- esx_society conventions: every job needs a matching society
        -- entry in `addon_account`, `datastore` and `addon_inventory`
        -- so members can use boss menus, society bank, society stash.
        -- Each one is keyed `society_<jobname>`. We do this via
        -- INSERT IGNORE so re-saving doesn't clobber existing data.
        local soc = 'society_' .. name
        pcall(function()
            MySQL.insert.await(
                'INSERT IGNORE INTO addon_account (name, label, shared) VALUES (?, ?, 1)',
                { soc, label }
            )
            -- Make sure the linked data row exists with zero money so
            -- accessing the account never returns nil.
            MySQL.insert.await(
                'INSERT IGNORE INTO addon_account_data (account_name, money, owner) VALUES (?, 0, NULL)',
                { soc }
            )
            MySQL.insert.await(
                'INSERT IGNORE INTO datastore (name, label, shared) VALUES (?, ?, 1)',
                { soc, label }
            )
            MySQL.insert.await(
                'INSERT IGNORE INTO addon_inventory (name, label, shared) VALUES (?, ?, 1)',
                { soc, label }
            )
        end)

        -- Also rename the society if the job was renamed, so existing
        -- balances / stashes / data carry over instead of being orphaned.
        if oldName and oldName ~= '' and oldName ~= name then
            local oldSoc = 'society_' .. oldName
            pcall(function()
                MySQL.query.await('UPDATE addon_account     SET name = ? WHERE name = ?', { soc, oldSoc })
                MySQL.query.await('UPDATE addon_account_data SET account_name = ? WHERE account_name = ?', { soc, oldSoc })
                MySQL.query.await('UPDATE datastore         SET name = ? WHERE name = ?', { soc, oldSoc })
                MySQL.query.await('UPDATE datastore_data    SET name = ? WHERE name = ?', { soc, oldSoc })
                MySQL.query.await('UPDATE addon_inventory   SET name = ? WHERE name = ?', { soc, oldSoc })
                MySQL.query.await('UPDATE addon_inventory_items SET inventory_name = ? WHERE inventory_name = ?', { soc, oldSoc })
            end)
        end

        -- The rows are in. Make the RUNNING server agree with them, or the
        -- job exists only after the next restart. Then check the pool rather
        -- than trusting the refresh: a fork with no ESX.RefreshJobs swallows
        -- the console fallback without saying so.
        local live = true
        if Framework == 'esx' then          -- this branch is also the fallback
            live = esxRefreshJobs()         -- for frameworks we don't know
            if live then
                local pool = esxJobPool()
                local j    = pool and pool[name]
                if j then
                    local n = 0
                    for _ in pairs(j.grades or {}) do n = n + 1 end
                    live = n == #grades
                elseif pool then
                    live = false
                end
            end
        end
        TriggerClientEvent('apex_adminmenu:notify', src,
            'Job saved',
            live and ('"%s" saved with %d grade(s).'):format(label, #grades)
                 or  ('"%s" was written to the database, but ESX would not reload it. '
                   .. 'Run /refreshjobs or restart es_extended to activate it.'):format(label),
            live and 'success' or 'warning')

        PanelLog(src, 'panel', 'save_job', nil, nil, name)
    end
end)

RegisterNetEvent('apex_adminmenu:panel:deleteJob', function(name)
    local src = source
    if not jobsWriteCheck(src, 'deleteJob') then return end
    name = tostring(name or ''):lower()
    if name == '' or name == 'unemployed' then return end

    -- Refuse if any players currently have this job assigned — admin
    -- has to reassign them first to avoid orphaned framework state.
    local using = countJobUsage(name)
    if using > 0 then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Job in use',
            ('Cannot delete "%s": %d player(s) still have it. Reassign them first.'):format(name, using),
            'error')
        return
    end

    local backend = detectJobsBackend()
    if backend == 'qbox' then
        pcall(function() exports.qbx_core:RemoveJob(name) end)
        dropJobOverride(name)
    elseif backend == 'qbcore' then
        pcall(function() QBCore.Functions.RemoveJob(name) end)
        dropJobOverride(name)
    else
        -- Remove the job + its grades from ESX, and also the matching
        -- esx_society rows so we don't leave behind orphan accounts,
        -- inventories and datastores.
        local soc = 'society_' .. name
        pcall(function()
            MySQL.query.await('DELETE FROM job_grades WHERE job_name = ?', { name })
            MySQL.query.await('DELETE FROM jobs WHERE name = ?', { name })
            MySQL.query.await('DELETE FROM addon_account_data WHERE account_name = ?', { soc })
            MySQL.query.await('DELETE FROM addon_account WHERE name = ?', { soc })
            MySQL.query.await('DELETE FROM datastore_data WHERE name = ?', { soc })
            MySQL.query.await('DELETE FROM datastore WHERE name = ?', { soc })
            MySQL.query.await('DELETE FROM addon_inventory_items WHERE inventory_name = ?', { soc })
            MySQL.query.await('DELETE FROM addon_inventory WHERE name = ?', { soc })
        end)
        -- Drop it from ESX's live pool too, or the job keeps working until
        -- the next restart and then comes back as a deleted-but-assigned mess.
        esxRefreshJobs()
    end
    PanelLog(src, 'panel', 'delete_job', nil, nil, name)
end)

-- ============================================================
-- EVENT LOGS — server-wide event capture + rules
-- ============================================================
local EventRules = {}                -- compiled rules cached in memory
local function reloadEventRules()
    EventRules = {}
    local rows = safeQuery('SELECT * FROM apex_event_rules WHERE enabled = 1 ORDER BY id') or {}
    for _, r in ipairs(rows) do
        EventRules[#EventRules + 1] = {
            id          = r.id,
            event       = r.event,
            action      = r.action,
            webhook_key = r.webhook_key,
            template    = r.template
        }
    end
end
CreateThread(function() Wait(3500); reloadEventRules() end)

-- Match an event name against the rule set. Returns the *first*
-- matching rule (so order in the table is effectively priority).
local function matchEventRule(name)
    for _, r in ipairs(EventRules) do
        if r.event == name then return r end
        if r.event:sub(-1) == '*' then
            local prefix = r.event:sub(1, -2)
            if name:sub(1, #prefix) == prefix then return r end
        end
    end
    return nil
end

-- Recent in-memory rolling buffer of events for the live panel feed.
-- DB has the full history; this is just to avoid hitting MySQL for
-- the most recent screen worth of rows on every callback.
local RecentEvents = {}
local MAX_RECENT   = 500

-- Push a row to all clients. The client side gates on `panelOpen`
-- before forwarding to the NUI, so non-admins simply ignore the
-- message. This is simpler and avoids edge cases where the perm
-- check fails for an admin who's still loading (no PlayerData yet).
local function pushEventToOpenPanels(row)
    TriggerClientEvent('apex_adminmenu:panel:eventRow', -1, row)
end

-- Truncate a serialised args blob so we never store a 10 MB string.
local function truncatePayload(s, maxLen)
    s = tostring(s or '')
    if #s > (maxLen or 800) then s = s:sub(1, maxLen) .. '…(truncated)' end
    return s
end

-- Coerce whatever arrived as a "source" into a real player id, or nil.
-- FiveM only fills the `source` global with a numeric id for events that
-- came in over the network; a server-local TriggerEvent (QBCore fires
-- OnJobUpdate / OnGangUpdate that way) leaves it as an EMPTY STRING.
-- Lua treats '' as truthy and `'' ~= 0` as true, so it used to slip
-- through the guards below straight into the INT `source` column, which
-- MySQL rejects in strict mode. Anything not a positive number is nil
-- here so the insert binds NULL.
local function normalizeSource(src)
    local n = tonumber(src)
    if not n or n <= 0 then return nil end
    return math.floor(n)
end

-- The hot path called by AddEventHandler('*') below. Applies any
-- matching rule (block/hide/webhook) and persists the event to DB
-- unless it's been hidden.
local function captureEvent(name, src, payloadStr)
    src = normalizeSource(src)
    local rule = matchEventRule(name)
    if rule and rule.action == 'block' then
        -- "block" means: refuse to record AND signal the caller. We
        -- can't actually cancel the event handler chain from here
        -- (FiveM doesn't expose that), but blocking still removes
        -- it from the audit trail and from the feed.
        return 'blocked'
    end
    local srcName, srcLic
    if src and GetPlayerName(src) then
        srcName = GetPlayerName(src)
        srcLic  = getLicense(src)
    end
    local row = {
        event      = name,
        source     = src,
        src_name   = srcName,
        src_lic    = srcLic,
        payload    = payloadStr,
        created_at = os.date('!%Y-%m-%d %H:%M:%S')
    }

    if not (rule and rule.action == 'hide') then
        -- Hold off DB persistence until the schema auto-installer has
        -- created the tables. Start-up events (onResourceStart, etc.)
        -- fire before that thread runs; the in-memory feed below still
        -- works regardless, so nothing visible is lost.
        if PanelSchemaReady then
            pcall(function()
                MySQL.insert(
                    'INSERT INTO apex_event_logs (event, source, src_name, src_lic, payload) '
                 .. 'VALUES (?, ?, ?, ?, ?)',
                    { name, row.source, srcName, srcLic, payloadStr }
                )
            end)
        end
        table.insert(RecentEvents, 1, row)
        if #RecentEvents > MAX_RECENT then RecentEvents[#RecentEvents] = nil end
        pushEventToOpenPanels(row)
    end

    if rule and rule.action == 'webhook' and PanelDiscordSend then
        PanelDiscordSend(rule.webhook_key or 'global', {
            title       = '⚡ ' .. name,
            description = srcName and ('From **%s** (`%s`)'):format(srcName, srcLic or '?') or 'No source',
            color       = 0x6272A4,
            fields      = { { name = 'Payload', value = '```\n' .. (payloadStr or '(empty)'):sub(1, 900) .. '\n```', inline = false } },
            timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
        })
    end
end

-- FiveM does not support `AddEventHandler('*')` as a catch-all, so
-- instead we (a) log every action coming through PanelLog and (b)
-- explicitly hook the most useful built-in / framework events. The
-- `PanelCaptureEvent` global lets any other resource feed into the
-- live event-logs feed too.
local IGNORED_PREFIXES = {
    '__cfx_internal:',
    'apex_adminmenu:panel:event',
    'apex_adminmenu:panel:cb',
    'apex_adminmenu:panel:eventRow'
}
local function isIgnored(name)
    if not name then return true end
    for _, p in ipairs(IGNORED_PREFIXES) do
        if name:sub(1, #p) == p then return true end
    end
    return false
end

-- Public hook so PanelLog + framework wrappers can push events.
function PanelCaptureEvent(evt, src, ...)
    if isIgnored(evt) then return end
    local args = {...}
    local ok, payload = pcall(json.encode, args)
    captureEvent(evt, src, ok and truncatePayload(payload, 1200) or nil)
end

-- Helper for the explicit hooks below.
--
-- `net` decides whether this name is allowed to arrive from a CLIENT, and
-- getting it wrong is visible in two different ways.
--
-- Engine events — playerDropped, rconCommand, onResourceStart/Stop,
-- explosionEvent — must NEVER be registered as net events. The engine
-- delivers them with an `internal-net:` / local source, which the Lua
-- scheduler passes straight through, so AddEventHandler alone is enough.
-- Registering them would additionally let any client TriggerServerEvent
-- them and forge rows in the staff audit log.
--
-- Framework events are the exact opposite case. `esx:onPlayerSpawn` is
-- sent by the CLIENT (es_extended registers it server-side, which is why
-- ESX itself works fine), and citizen/scripting/lua/scheduler.lua refuses
-- to run a `net:`-sourced event in a resource that only called
-- AddEventHandler:
--
--     if eventSource:sub(1, 3) == 'net' then
--         if not eventHandlerEntry.safeForNet then
--             Citizen.Trace('event ' .. eventName .. " was not safe for net\n")
--             return                      -- <- handler never runs
--
-- So the old code printed that warning on EVERY player spawn and never
-- captured the event it existed to capture. RegisterNetEvent fixes both.
-- The handler only ever writes a log row, and the rate limit below stops a
-- client turning that into a flood.
local netEventFloor = {}    -- [src] = GetGameTimer() value we'll accept again at
local NET_EVENT_GAP = 250   -- ms between accepted net events per player

local function hookEvent(name, net)
    if net then RegisterNetEvent(name) end

    AddEventHandler(name, function(...)
        -- Server-local events (QBCore:Server:OnJobUpdate / OnGangUpdate,
        -- esx:setJob, explosionEvent, ...) leave the `source` global
        -- empty and carry the player id as their first argument instead,
        -- so fall back to it before giving up and logging NULL.
        local src = source
        local fromPlayer = normalizeSource(src)

        if net and fromPlayer then
            local now, floor = GetGameTimer(), netEventFloor[fromPlayer]
            if floor and now < floor then return end
            netEventFloor[fromPlayer] = now + NET_EVENT_GAP
        end

        if not fromPlayer then
            local a1 = (...)
            if normalizeSource(a1) then src = a1 end
        end
        PanelCaptureEvent(name, src, ...)
    end)
end

AddEventHandler('playerDropped', function()
    netEventFloor[normalizeSource(source) or -1] = nil
end)

-- Built-in FiveM engine events — local delivery, never RegisterNetEvent.
hookEvent('playerJoining')
hookEvent('playerConnecting')
hookEvent('playerDropped')
hookEvent('onResourceStart')
hookEvent('onResourceStop')
hookEvent('rconCommand')
hookEvent('explosionEvent')

-- ESX core events — client-originated, so they need RegisterNetEvent.
for _, e in ipairs({
    'esx:onPlayerSpawn', 'esx:onPlayerDeath', 'esx:onPlayerLogout',
    'esx:setJob', 'esx:onAddInventoryItem', 'esx:onRemoveInventoryItem',
    'esx:onAddMoney', 'esx:onRemoveMoney', 'esx_society:registerSociety',
    'esx_society:withdrawMoney', 'esx_society:depositMoney',
    'esx_billing:sendBill'
}) do hookEvent(e, true) end

-- QBCore / QBox core events — same reasoning.
for _, e in ipairs({
    'QBCore:Server:OnPlayerLoaded', 'QBCore:Server:OnPlayerUnload',
    'QBCore:Server:OnJobUpdate',    'QBCore:Server:OnGangUpdate',
    'QBCore:Server:UseItem',        'QBCore:Server:RemoveItem',
    'QBCore:Server:AddMoney',       'QBCore:Server:RemoveMoney',
    'qbx_core:server:onPlayerLoaded','qbx_core:server:onPlayerLogout'
}) do hookEvent(e, true) end

-- chatMessage so we can audit player chat through the panel feed.
AddEventHandler('chatMessage', function(src, name, msg)
    PanelCaptureEvent('chatMessage', src, name, msg)
end)

-- Resource lifecycle hooks bubble through onResourceStart / Stop but
-- also via these server-only signals. Keep them for completeness.
AddEventHandler('onServerResourceStart', function(res)
    PanelCaptureEvent('onServerResourceStart', 0, res)
end)
AddEventHandler('onServerResourceStop', function(res)
    PanelCaptureEvent('onServerResourceStop', 0, res)
end)

-- Boot announcement — guarantees the very first opened panel sees at
-- least one row, which is useful when verifying the live feed works.
CreateThread(function()
    Wait(4500)
    PanelCaptureEvent('apex_adminmenu:ready', 0,
        { time = os.time(), msg = 'Event Logs are live' })
end)

-- Heartbeat — emits a `apex:tick` event every 30s carrying a
-- snapshot of the player count + uptime. Gives a constant "pulse"
-- in the feed so admins can confirm the live stream is alive even
-- when no other event is firing.
CreateThread(function()
    Wait(8000)
    while true do
        PanelCaptureEvent('apex:tick', 0,
            { online = #(GetPlayers() or {}), uptime = os.time() - serverStartedAt })
        Wait(30000)
    end
end)

-- ── Callbacks / events the panel uses to manage the feed ──
lib.callback.register('apex_adminmenu:panel:eventLogs', function(source)
    if not PanelCanOpen(source) then return { rows = {}, rules = {} } end
    -- Last 200 rows from memory (already newest-first).
    local rows = {}
    for i = 1, math.min(200, #RecentEvents) do rows[i] = RecentEvents[i] end
    -- Plus the full rule list (so the editor sees disabled ones too).
    local rules = safeQuery('SELECT * FROM apex_event_rules ORDER BY id DESC') or {}
    return { rows = rows, rules = rules }
end)

RegisterNetEvent('apex_adminmenu:panel:saveEventRule', function(payload)
    local src = source
    if not (PanelHasPerm(src, '*') or PanelHasPerm(src, 'settings.*') or PanelHasPerm(src, 'staff.*')) then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Event Rules',
            'You do not have permission to manage event rules.', 'error')
        return
    end
    if type(payload) ~= 'table' then return end

    local id      = payload.id and tonumber(payload.id) or nil
    local event   = tostring(payload.event   or ''):sub(1, 160)
    local action  = tostring(payload.action  or 'log')
    local hook    = payload.webhook_key and tostring(payload.webhook_key) or nil
    local enabled = (payload.enabled == false) and 0 or 1

    if action ~= 'log' and action ~= 'block' and action ~= 'hide' and action ~= 'webhook' then
        action = 'log'
    end

    if id then
        -- Editing an existing rule. If only the enabled flag was sent
        -- (toggle from the list), keep the other columns intact; if
        -- a full payload arrived, update everything.
        local fields, args = {}, {}
        table.insert(fields, 'enabled = ?'); table.insert(args, enabled)
        if payload.event       ~= nil then table.insert(fields, 'event = ?');       table.insert(args, event)  end
        if payload.action      ~= nil then table.insert(fields, 'action = ?');      table.insert(args, action) end
        if payload.webhook_key ~= nil then table.insert(fields, 'webhook_key = ?'); table.insert(args, hook)   end
        table.insert(args, id)
        local sql = ('UPDATE apex_event_rules SET %s WHERE id = ?'):format(table.concat(fields, ', '))
        pcall(function() MySQL.query.await(sql, args) end)
    else
        if event == '' then
            TriggerClientEvent('apex_adminmenu:notify', src, 'Event Rules', 'Event name is required.', 'warning')
            return
        end
        pcall(function()
            MySQL.insert.await(
                'INSERT INTO apex_event_rules (event, action, webhook_key, enabled, created_by) VALUES (?, ?, ?, ?, ?)',
                { event, action, hook, enabled, GetPlayerName(src) or 'Console' }
            )
        end)
    end
    reloadEventRules()
    -- Push the refreshed rules list to every open panel so other
    -- admins watching the same screen see the change immediately.
    local rules = safeQuery('SELECT * FROM apex_event_rules ORDER BY id DESC') or {}
    TriggerClientEvent('apex_adminmenu:panel:eventRulesUpdated', -1, rules)
    PanelLog(src, 'panel', 'event_rule_save', nil, nil, ('%s → %s'):format(event, action))
end)

RegisterNetEvent('apex_adminmenu:panel:deleteEventRule', function(id)
    local src = source
    if not PanelRequire(src, { '*', 'settings.*', 'staff.*' }, 'deleteEventRule') then return end
    id = tonumber(id)
    if not id then return end
    pcall(function() MySQL.query.await('DELETE FROM apex_event_rules WHERE id = ?', { id }) end)
    reloadEventRules()
    local rules = safeQuery('SELECT * FROM apex_event_rules ORDER BY id DESC') or {}
    TriggerClientEvent('apex_adminmenu:panel:eventRulesUpdated', -1, rules)
    PanelLog(src, 'panel', 'event_rule_delete', nil, nil, tostring(id))
end)

RegisterNetEvent('apex_adminmenu:panel:clearEventLogs', function()
    local src = source
    if not PanelRequire(src, { '*', 'settings.*', 'staff.*' }, 'clearEventLogs') then return end
    pcall(function() MySQL.query.await('TRUNCATE apex_event_logs') end)
    RecentEvents = {}
    TriggerClientEvent('apex_adminmenu:panel:eventLogsCleared', -1)
    PanelLog(src, 'panel', 'event_logs_clear')
end)

-- ============================================================
-- Screenshot a target player and deliver it to the requesting admin
-- ============================================================
-- Reuses screenshot-basic (via the target's client) and chunks the
-- base64 payload to fit FiveM's net event size limit. Each request
-- gets a unique token so multiple simultaneous captures don't mix.
local screenshotBuffers = {}    -- [token] = { admin, target, parts = {}, total }

RegisterNetEvent('apex_adminmenu:panel:screenshotPlayer', function(targetId)
    local src = source
    if not (PanelHasPerm(src, '*') or PanelHasPerm(src, 'players.*') or PanelHasPerm(src, 'players.spectate')) then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Screenshot',
            'You do not have permission.', 'error')
        return
    end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then return end
    local token = ('%d:%d:%d'):format(src, targetId, os.time())
    screenshotBuffers[token] = { admin = src, target = targetId, parts = {}, total = 0, started = os.time() }
    TriggerClientEvent('apex_adminmenu:panel:takeScreenshot', targetId, token)
    PanelLog(src, 'player', 'screenshot', GetPlayerName(targetId), getLicense(targetId))
end)

-- Target client sends back the chunked payload here.
RegisterNetEvent('apex_adminmenu:panel:screenshotChunk', function(token, idx, total, part)
    local src = source
    local buf = screenshotBuffers[token]
    if not buf then return end
    -- Only the target whose screen we asked for can submit chunks.
    if buf.target ~= src then return end
    if type(part) ~= 'string' or total < 1 or total > 200 then return end
    if buf.parts[idx] then return end
    buf.parts[idx] = part
    buf.total = math.max(buf.total, total)
    -- Count how many we have so far.
    local got = 0
    for _ in pairs(buf.parts) do got = got + 1 end
    if got >= buf.total then
        local assembled = {}
        for i = 1, buf.total do assembled[#assembled + 1] = buf.parts[i] or '' end
        local uri = table.concat(assembled)
        if not uri:find('^data:image') then uri = 'data:image/jpeg;base64,' .. uri end
        TriggerClientEvent('apex_adminmenu:panel:screenshotReady', buf.admin,
            uri, buf.target, GetPlayerName(buf.target))
        screenshotBuffers[token] = nil
    end
end)

-- Time out abandoned captures after 20s so the buffer table doesn't
-- grow unbounded if a target client crashes mid-upload.
CreateThread(function()
    while true do
        Wait(10000)
        local now = os.time()
        for token, buf in pairs(screenshotBuffers) do
            if now - (buf.started or now) > 20 then
                TriggerClientEvent('apex_adminmenu:notify', buf.admin, 'Screenshot',
                    'Capture timed out for player ' .. tostring(buf.target), 'error')
                screenshotBuffers[token] = nil
            end
        end
    end
end)

-- ============================================================
-- Anti-cheat key telemetry
-- ============================================================
-- Clients report when they press any of a curated list of "suspicious"
-- keys (menu-launchers, common cheat hotkeys). We log them through
-- PanelLog so they appear in the Event Logs feed and Discord.
RegisterNetEvent('apex_adminmenu:panel:suspiciousKey', function(key, context)
    local src = source
    if type(key) ~= 'string' then return end
    local name = GetPlayerName(src) or 'Unknown'
    local lic  = getLicense(src) or ''
    PanelLog(src, 'moderation', 'suspicious_key', name, lic,
        ('Key %s pressed%s'):format(key, context and (' · ' .. tostring(context)) or ''))
    if PanelDiscordSend then
        PanelDiscordSend('moderation', {
            title       = '⚠️ Suspicious key press',
            description = ('**%s** pressed `%s`'):format(name, key),
            color       = 0xE5A93C,
            fields      = {
                { name = 'Server ID', value = tostring(src), inline = true },
                { name = 'License',   value = ('`%s`'):format(lic), inline = true },
                { name = 'Context',   value = tostring(context or 'none'), inline = false }
            },
            timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ')
        })
    end
end)

-- ============================================================
-- Reset Account — wipe every DB row attached to a license
-- ============================================================
-- The list of tables below covers stock ESX, QBCore and the
-- Apex panel's own tables. Missing tables are silently skipped
-- (pcall around each statement) so the action is safe on any
-- framework subset.
RegisterNetEvent('apex_adminmenu:panel:resetAccount', function(license)
    local src = source
    if not (PanelHasPerm(src, '*') or PanelHasPerm(src, 'moderation.*') or PanelHasPerm(src, 'staff.*')) then
        TriggerClientEvent('apex_adminmenu:notify', src, 'Reset Account',
            'You do not have permission for this destructive action.', 'error')
        return
    end
    license = tostring(license or '')
    if license == '' then return end

    -- Drop them from the server first so the wipe isn't racing with
    -- the framework rewriting their row on disconnect.
    for _, p in ipairs(GetPlayers() or {}) do
        local s = tonumber(p)
        if s and getLicense(s) == license then
            pcall(function() DropPlayer(s, 'Your account is being reset by staff.') end)
        end
    end

    -- Framework users / characters.
    local stmts = {
        -- ESX
        { 'DELETE FROM users WHERE identifier = ?',                  { license } },
        { 'DELETE FROM owned_vehicles WHERE owner = ?',              { license } },
        { 'DELETE FROM owned_properties WHERE owner = ?',            { license } },
        { 'DELETE FROM user_inventory WHERE identifier = ?',         { license } },
        { 'DELETE FROM user_licenses WHERE owner = ?',               { license } },
        { 'DELETE FROM user_accounts WHERE identifier = ?',          { license } },
        { 'DELETE FROM addon_account_data WHERE owner = ?',          { license } },
        { 'DELETE FROM datastore_data WHERE owner = ?',              { license } },
        { 'DELETE FROM phone_users WHERE identifier = ?',            { license } },
        { 'DELETE FROM phone_messages WHERE transmitter = ? OR receiver = ?', { license, license } },
        { 'DELETE FROM esx_skin WHERE identifier = ?',               { license } },
        { 'DELETE FROM characters WHERE identifier = ?',             { license } },

        -- QBCore / QBox
        { 'DELETE FROM players WHERE license = ?',                   { license } },
        { 'DELETE FROM player_vehicles WHERE license = ?',           { license } },
        { 'DELETE FROM player_houses WHERE citizenid IN (SELECT citizenid FROM players WHERE license = ?)', { license } },
        { 'DELETE FROM bank_accounts_new WHERE citizenid IN (SELECT citizenid FROM players WHERE license = ?)', { license } },
        { 'DELETE FROM playerskins WHERE citizenid IN (SELECT citizenid FROM players WHERE license = ?)', { license } },

        -- Apex panel own tables
        { 'DELETE FROM apex_warnings WHERE target = ?',            { license } },
        { 'DELETE FROM apex_bans WHERE license = ?',               { license } },
        { 'DELETE FROM apex_jail WHERE target = ?',                { license } },
        { 'DELETE FROM apex_player_flags WHERE license = ?',       { license } },
        { 'DELETE FROM apex_player_stats WHERE license = ?',       { license } },
        { 'DELETE FROM apex_staff_log WHERE target_lic = ?',       { license } },
        { 'DELETE FROM apex_staff_chat WHERE author_lic = ?',      { license } },
        { 'DELETE FROM apex_staff_settings WHERE license = ?',     { license } },
        { 'DELETE FROM apex_staff_keybinds WHERE license = ?',     { license } },
        { 'DELETE FROM apex_staff WHERE license = ?',              { license } },
        { 'DELETE FROM apex_steam_avatars WHERE steam = ?',        { license } }
    }
    local touched = 0
    for _, q in ipairs(stmts) do
        local ok = pcall(function() MySQL.query.await(q[1], q[2]) end)
        if ok then touched = touched + 1 end
    end

    PanelLog(src, 'moderation', 'reset_account', nil, license,
        ('wiped %d table(s)'):format(touched))
    TriggerClientEvent('apex_adminmenu:notify', src, 'Reset Account',
        ('Account wiped — %d table(s) touched.'):format(touched), 'success')
end)
