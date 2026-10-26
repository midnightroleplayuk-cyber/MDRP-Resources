function _event(name)
    return (Config.EventPrefix or "tw-litejobpack") .. ":" .. name
end

-- vRP must be initialized synchronously at script load so all helpers
-- (GetPlayer, GetIdentifier, etc.) can use it immediately. Doing this in a
-- CreateThread leaves a nil window during early calls.
if Config.Framework == 'vrp' or Config.Framework == 'vrp2' then
    local ok, Proxy = pcall(module, "vrp", "lib/Proxy")
    if ok and Proxy then
        vRP = Proxy.getInterface("vRP")
    else
        print("[tw-litejobpack] module() not available, falling back to GetCore()")
        local core = GetCore()
        if core then
            vRP = core
        end
    end
end

-- vRP 0.x Proxy (fcall(args, callback)) takes ONE table of arguments:
-- vRP.getUserId({source}). Every call site in this file uses the vRP 1.0
-- varargs form, which on 0.x makes the vrp side table.unpack() a number
-- ("attempt to get length of a number value" in the vrp console), no value
-- comes back, and GetIdentifier returns nil -> invalid_player. Sniff the very
-- Proxy file we loaded and pack the varargs, so both generations share the
-- same call sites.
local vrpLegacyProxy = false
if vRP and (Config.Framework == 'vrp' or Config.Framework == 'vrp2') then
    local proxySrc = LoadResourceFile("vrp", "lib/Proxy.lua")
    vrpLegacyProxy = proxySrc ~= nil and proxySrc:find("function%s*%(%s*args%s*,%s*callback%s*%)") ~= nil
    if vrpLegacyProxy then
        local rawVRP = vRP
        vRP = setmetatable({}, { __index = function(t, key)
            local fcall = rawVRP[key]
            local packed = function(...) return fcall({ ... }) end
            t[key] = packed
            return packed
        end })
        print("[tw-litejobpack] vRP 0.x Proxy detected, packing proxy call arguments")
    end
end

_G.serverCallbacks = _G.serverCallbacks or {}

_G.PlayerState = _G.PlayerState or {}

function GetPlayerSelectedJob(src)
    return _G.PlayerState[src] and _G.PlayerState[src].selectedJob or nil
end

function IsJobSelectedFor(src, jobId)
    if not Config.RequireSelectedJob then return true end
    return GetPlayerSelectedJob(src) == jobId
end

local function usesSqlPersistence()
    return Config.RealJob == 'sql' or Config.RealJob == 'both'
end

local function usesFrameworkSync()
    return Config.RealJob == 'framework' or Config.RealJob == 'both'
end

function SetPlayerSelectedJob(src, jobId)
    if not _G.PlayerState[src] then
        _G.PlayerState[src] = {}
    end
    _G.PlayerState[src].selectedJob = jobId

    if usesSqlPersistence() and jobId then
        local identifier = GetIdentifier(src)
        if identifier then
            ExecuteSQL("UPDATE `tw_jobpack` SET selected_job = ? WHERE identifier = ?", { jobId, identifier })
        end
    end

    if usesFrameworkSync() and jobId then
        SetFrameworkJob(src, jobId)
    end
end

-- While the pack itself is writing the framework job (SetFrameworkJob below),
-- the framework fires its own job-update event right back at us. The live-sync
-- listeners further down must ignore that echo or they'd re-process our own
-- write. Window is per-source, in ms.
local frameworkSyncSuppress = {}

function SetFrameworkJob(src, jobId)
    if not src or not jobId then return end
    frameworkSyncSuppress[src] = GetGameTimer() + 3000
    local Framework = Config.Framework

    local job = Config.Jobs and Config.Jobs[jobId]
    local frameworkJobName = (job and job.frameworkJob) or jobId

    pcall(function()
        if Framework == 'qb' or Framework == 'oldqb' then
            local Player = Core.Functions.GetPlayer(src)
            if Player then
                Player.Functions.SetJob(frameworkJobName, 0)
            end
        elseif Framework == 'tmc' then
            local Player = Core.Functions.GetPlayer(src)
            if Player then
                Player.Functions.AddJob(frameworkJobName, 0)
            end
        elseif Framework == 'esx' or Framework == 'oldesx' then
            local xPlayer = Core.GetPlayerFromId(src)
            if xPlayer then
                xPlayer.setJob(frameworkJobName, 0)
            end
        end
    end)
end

function GetFrameworkJobName(src)
    local Framework = Config.Framework
    local jobName = nil

    pcall(function()
        if Framework == 'qb' or Framework == 'oldqb' then
            local Player = Core.Functions.GetPlayer(src)
            if Player and Player.PlayerData and Player.PlayerData.job then
                jobName = Player.PlayerData.job.name
            end
        elseif Framework == 'tmc' then
            local Player = Core.Functions.GetPlayer(src)
            if Player then
                local job, _grade = Player.Functions.IsOnDuty()
                if job then
                    jobName = job
                end
            end
        elseif Framework == 'esx' or Framework == 'oldesx' then
            local xPlayer = Core.GetPlayerFromId(src)
            if xPlayer then
                local job = xPlayer.getJob()
                if job then
                    jobName = job.name
                end
            end
        end
    end)

    return jobName
end

function ResolveFrameworkJobToJobId(frameworkJobName)
    if not frameworkJobName or not Config.Jobs then return nil end

    if Config.Jobs[frameworkJobName] and Config.Jobs[frameworkJobName].enabled then
        return frameworkJobName
    end

    for jobId, job in pairs(Config.Jobs) do
        if job.enabled and job.frameworkJob == frameworkJobName then
            return jobId
        end
    end

    return nil
end

-- Identifier lookups sit on the hottest server path (every JobUtils.Validate
-- does 2-3 of them) and on ESX each uncached call costs two cross-resource
-- proxy hops into es_extended (GetPlayerFromId + getIdentifier). The
-- identifier is immutable for a connected player: resolve once per session.
local IdentifierCache = {}

-- Reverse map, kept in sync with IdentifierCache. Lets the lobby broadcast
-- helpers answer "which source owns this identifier" instead of guessing with
-- tonumber(). Critical on vRP, where identifiers are small integers that
-- collide with real server IDs -- see SessionManager.SendToLobbyPlayers.
local SourceByIdentifier = {}

-- A dropping player's identifier has to survive the drop chain: server.lua,
-- xp.lua, quest_manager and editable.lua all call GetIdentifier() from their
-- own playerDropped handlers to save XP and tear the lobby down, and by then
-- the framework has usually already forgotten the player (on vRP it is a race
-- against the vrp resource's own playerDropped). The snapshot lives in its own
-- table, never in the live cache, so a recycled server ID can never read the
-- previous occupant's identity.
local DroppedIdentifier = {}
local DroppedSources = {}
local DROPPED_GRACE_MS = 10000

local function forgetSource(src)
    local cached = IdentifierCache[src]
    if cached and SourceByIdentifier[cached] == src then
        SourceByIdentifier[cached] = nil
    end
    IdentifierCache[src] = nil
    DroppedIdentifier[src] = nil
    DroppedSources[src] = nil
end

-- server/utility.lua is the first server script in fxmanifest, so this handler
-- is registered -- and therefore runs -- before every other playerDropped
-- handler in the resource. The snapshot is always in place by the time they run.
AddEventHandler('playerDropped', function(reason)
    local src = source
    if _G.PlayerState[src] then
        _G.PlayerState[src] = nil
    end
    frameworkSyncSuppress[src] = nil

    local cached = IdentifierCache[src]
    if cached then
        DroppedIdentifier[src] = cached
        DroppedSources[src] = true
        if SourceByIdentifier[cached] == src then
            SourceByIdentifier[cached] = nil
        end
        Citizen.SetTimeout(DROPPED_GRACE_MS, function()
            DroppedIdentifier[src] = nil
            DroppedSources[src] = nil
        end)
    end
    IdentifierCache[src] = nil
end)

-- A server ID can be handed to a new player well inside DROPPED_GRACE_MS.
-- Drop the snapshot the moment that happens, so GetIdentifier can never hand
-- the newcomer the previous occupant's identifier.
AddEventHandler('playerJoining', function()
    forgetSource(source)
end)

-- Used by SessionManager to resolve a lobbyId (== owner identifier) back to a
-- live source without tonumber(). Returns nil for a disconnected player.
function GetSourceByIdentifier(identifier)
    if identifier == nil then return nil end
    return SourceByIdentifier[identifier]
end

-- ═══════════════════════════════════════════════════════
-- Live framework-job sync listeners (RealJob = 'framework')
-- ═══════════════════════════════════════════════════════
-- These are deliberately AddEventHandler (NOT RegisterNetEvent): both events
-- are fired locally by the framework's server core. Registering them as net
-- events would let any client spoof a job change.
-- This file is escrow-ignored so forks that rename these events can adapt.
-- The core logic (HandleFrameworkJobChange) lives in server/server.lua.

local function onFrameworkJobChanged(src, jobName)
    if not src or not jobName then return end
    if Config.LiveFrameworkJobSync == false then return end
    if Config.RealJob ~= 'framework' then return end
    if frameworkSyncSuppress[src] and GetGameTimer() < frameworkSyncSuppress[src] then return end
    if type(HandleFrameworkJobChange) == 'function' then
        HandleFrameworkJobChange(src, jobName)
    end
end

if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
    AddEventHandler('QBCore:Server:OnJobUpdate', function(src, job)
        onFrameworkJobChanged(src, job and job.name)
    end)
elseif Config.Framework == 'esx' or Config.Framework == 'oldesx' then
    AddEventHandler('esx:setJob', function(playerId, job, lastJob)
        onFrameworkJobChanged(playerId, job and job.name)
    end)
end

local StandalonePlayers = {}

if Config.Framework == "standalone" then
    AddEventHandler('playerJoining', function(oldID)
        local src = source

        CreateThread(function()
            Wait(500)

            local identifier = GetPlayerIdentifierByType(src, 'license')
            local playerName = GetPlayerName(src)

            if identifier and playerName then
                StandalonePlayers[src] = {
                    source = src,
                    identifier = identifier,
                    name = playerName,
                    money = {
                        cash = 5000,
                        bank = 10000
                    }
                }
            end
        end)
    end)

    AddEventHandler('playerDropped', function(reason)
        local src = source
        StandalonePlayers[src] = nil
    end)
end

local function WaitForCore(timeout)
    timeout = timeout or 100
    local attempts = 0

    while not Core and attempts < timeout do
        Wait(50)
        attempts = attempts + 1
    end

    if not Core then
        print(string.format("[^1ERROR^7][tw-litejobpack] Core not loaded after %d seconds", (timeout * 50) / 1000))
        return false
    end

    return true
end

RegisterServerCallback = function(eventName, callback)
    CreateThread(function()
        if Config.Framework ~= 'vrp' and Config.Framework ~= 'vrp2' then
            if not WaitForCore(100) then
                print(string.format("[^1ERROR^7][tw-litejobpack] Failed to register server callback: ^5%s^7", eventName))
                return
            end
        end

        _G.serverCallbacks[eventName] = callback
    end)
end

RegisterNetEvent(_event('triggerServerCallback'), function(eventName, requestId, invoker, ...)
    if not _G.serverCallbacks[eventName] then
        print(string.format("[^1ERROR^7][tw-litejobpack] Server Callback not registered: ^5%s^7 (invoker: ^5%s^7)",
            eventName, invoker))
        return
    end

    local src = source
    _G.serverCallbacks[eventName](src, function(...)
        TriggerClientEvent(_event('serverCallback'), src, requestId, invoker, ...)
    end, ...)
end)

function ExecuteSql(query, parameters)
    local prom = promise.new()

    if Config.SQL == "oxmysql" then
        if parameters then
            exports.oxmysql:execute(query, parameters, function(result)
                prom:resolve(result)
            end)
        else
            exports.oxmysql:execute(query, {}, function(result)
                prom:resolve(result)
            end)
        end
    elseif Config.SQL == "ghmattimysql" then
        if parameters then
            exports.ghmattimysql:execute(query, parameters, function(result)
                prom:resolve(result)
            end)
        else
            exports.ghmattimysql:execute(query, {}, function(result)
                prom:resolve(result)
            end)
        end
    elseif Config.SQL == "mysql-async" then
        if parameters then
            MySQL.Async.fetchAll(query, parameters, function(result)
                prom:resolve(result)
            end)
        else
            MySQL.Async.fetchAll(query, {}, function(result)
                prom:resolve(result)
            end)
        end
    end

    return Citizen.Await(prom)
end

function ExecuteSQL(query, parameters, callback)
    if Config.SQL == "oxmysql" then
        exports.oxmysql:execute(query, parameters or {}, function(result)
            if callback then callback(result) end
        end)
    elseif Config.SQL == "ghmattimysql" then
        exports.ghmattimysql:execute(query, parameters or {}, function(result)
            if callback then callback(result) end
        end)
    elseif Config.SQL == "mysql-async" then
        MySQL.Async.fetchAll(query, parameters or {}, function(result)
            if callback then callback(result) end
        end)
    end
end

function WaitCore()
    while Core == nil do
        Wait(0)
    end
end

function GetPlayer(source)
    local Player = false

    if Config.Framework == 'standalone' then
        if StandalonePlayers[source] then
            return StandalonePlayers[source]
        end

        local identifier = GetPlayerIdentifierByType(source, 'license')
        local playerName = GetPlayerName(source)

        if identifier and playerName then
            StandalonePlayers[source] = {
                source = source,
                identifier = identifier,
                name = playerName,
                money = {
                    cash = 5000,
                    bank = 10000
                }
            }

            return StandalonePlayers[source]
        end

        return nil
    end

    while Core == nil do
        Citizen.Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Player = Core.GetPlayerFromId(source)
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
        Player = Core.Functions.GetPlayer(source)
    elseif Config.Framework == 'vrp' then
        -- vRP1's Proxy has no readiness guard: calling into it before the vrp
        -- resource registered its interface blocks on r:wait() forever, and
        -- indexing a nil vRP is a hard error that kills the calling thread.
        -- Bound the wait so a missing/broken vrp resource degrades to nil
        -- instead of hanging every job callback.
        local vrpWait = 0
        while vRP == nil and vrpWait < 50 do
            Wait(100)
            vrpWait = vrpWait + 1
        end
        if vRP == nil then return false end

        -- vRP.getUserId is vRP.users[GetPlayerIdentifiers(src)[1]] -- nil until
        -- vRP registers the player, which on character-select forks lands well
        -- after they are already in the session. We deliberately do NOT retry
        -- here: GetIdentifier is on the hot path (2-3 calls per
        -- JobUtils.Validate) and a blocking retry would stall every callback
        -- from a player vRP genuinely has no user for. WaitForIdentifier owns
        -- the waiting. The pcall is for the Proxy itself, not for the lookup.
        local ok, userId = pcall(vRP.getUserId, source)
        Player = ok and userId or nil
    elseif Config.Framework == 'vrp2' then
        -- Same bounded guard as the vrp1 branch above: never wait forever on a
        -- missing/broken vrp resource.
        local vrpWait = 0
        while vRP == nil and vrpWait < 50 do
            Wait(100)
            vrpWait = vrpWait + 1
        end
        if vRP == nil then return false end

        -- vRP.Passport returns FALSE (not nil) until the player picks a
        -- character. This used to retry 50 x 100ms, so every single GetPlayer
        -- call on a not-yet-loaded player blocked for five seconds -- including
        -- the ones WaitForIdentifier makes, which turned its 500ms poll into a
        -- ~5.5s one and made the job center show up seconds after the character
        -- was actually chosen. Same rule as vrp1: no retry here, WaitForIdentifier
        -- owns the waiting. The pcall is for the Proxy itself, not for the lookup.
        local ok, passport = pcall(vRP.Passport, source)
        Player = (ok and passport) or false
    end
    return Player
end

function GetIdentifier(source)
    local cached = IdentifierCache[source]
    if cached then return cached end

    -- Mid-drop: the framework no longer knows this player, but our own
    -- playerDropped handlers still need the identifier to save XP and clean up
    -- the lobby. Serve the snapshot rather than nil.
    if DroppedSources[source] then
        return DroppedIdentifier[source]
    end

    local identifier

    if Config.Framework == 'standalone' then
        identifier = GetPlayerIdentifierByType(source, 'license')
        if not identifier then
            local player = StandalonePlayers[source]
            identifier = player and player.identifier or nil
        end
    else
        local Player = GetPlayer(source)
        if Player then
            if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
                identifier = Player.getIdentifier()
            elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
                identifier = Player.PlayerData.citizenid
            elseif Config.Framework == 'vrp' then
                -- GetPlayer already IS vRP.getUserId(source) for this branch.
                -- Calling it again here was a second, unprotected Proxy hop on
                -- the hot path for a value we are already holding.
                identifier = Player
            elseif Config.Framework == 'vrp2' then
                identifier = tostring(Player)
            end
        end
    end

    -- Never cache a nil (player still loading): the next call must retry.
    if identifier then
        IdentifierCache[source] = identifier
        SourceByIdentifier[identifier] = source
    end
    return identifier
end

-- Diagnostic for the one failure customers actually report: "Failed to get
-- identifier for source: N". That message never said WHICH half broke, so a
-- fork mismatch could not be told apart from a timing race without a live
-- session. Report both halves instead.
--
-- Deliberately does NOT call into vRP: vRP1's Proxy blocks on r:wait() with no
-- timeout when the interface isn't registered, and hanging inside an error
-- reporter would be worse than the error. Presence checks only.
function DescribeIdentifierFailure(source)
    local parts = { ('framework=%s'):format(tostring(Config.Framework)) }

    parts[#parts + 1] = ('connected=%s'):format(GetPlayerName(source) and 'yes' or 'no')

    local ok, ids = pcall(GetPlayerIdentifiers, source)
    if ok and type(ids) == 'table' then
        parts[#parts + 1] = ('nativeIds=%d'):format(#ids)
        if ids[1] then
            parts[#parts + 1] = ('firstId=%s'):format(tostring(ids[1]))
        end
    else
        parts[#parts + 1] = 'nativeIds=unavailable'
    end

    if Config.Framework == 'vrp' or Config.Framework == 'vrp2' then
        parts[#parts + 1] = ('vRPInterface=%s'):format(vRP ~= nil and 'ok' or 'nil')
        if vRP ~= nil then
            local apiName = (Config.Framework == 'vrp') and 'getUserId' or 'Passport'
            local ok2, isFn = pcall(function() return type(vRP[apiName]) == 'function' end)
            parts[#parts + 1] = ('vRPApi.%s=%s'):format(apiName, (ok2 and isFn) and 'present' or 'missing')
        end
    elseif Config.Framework ~= 'standalone' then
        parts[#parts + 1] = ('core=%s'):format(Core and 'ok' or 'nil')
    end

    return table.concat(parts, ' ')
end

function GetPlayerHours(source)
    local hrCfg = Config.HoursRequirement
    if not hrCfg or not hrCfg.enabled then return nil end

    local identifier
    if hrCfg.identifierType == "auto" or not hrCfg.identifierType then
        identifier = GetIdentifier(source)
    elseif hrCfg.identifierType == "license" then
        identifier = GetPlayerIdentifierByType(source, 'license')
    elseif hrCfg.identifierType == "steam" then
        identifier = GetPlayerIdentifierByType(source, 'steam')
    elseif hrCfg.identifierType == "discord" then
        identifier = GetPlayerIdentifierByType(source, 'discord')
    else
        identifier = GetIdentifier(source)
    end

    if not identifier then
        print(('[JobPack] [HoursRequirement] Could not resolve identifier for source %s'):format(tostring(source)))
        return 0
    end

    local sql = string.format("SELECT `%s` FROM `%s` WHERE `%s` = ? LIMIT 1", hrCfg.column, hrCfg.table, hrCfg
        .identifier)
    local ok, rows = pcall(ExecuteSql, sql, { identifier })

    if not ok then
        print(('[JobPack] [HoursRequirement] SQL error: %s'):format(tostring(rows)))
        return 0
    end

    if rows and rows[1] then
        return tonumber(rows[1][hrCfg.column]) or 0
    end

    return 0
end

function CheckHoursRequirement(source, jobConfig)
    local hrCfg = Config.HoursRequirement
    if not hrCfg or not hrCfg.enabled then return true, nil, 0, 0 end

    local playerHours = GetPlayerHours(source) or 0

    local requiredHours = jobConfig.requiredHours or 0
    if requiredHours > 0 and playerHours < requiredHours then
        return false, "min", playerHours, requiredHours
    end

    local maxHours = jobConfig.maxHours or 0
    if maxHours > 0 and playerHours >= maxHours then
        return false, "max", playerHours, maxHours
    end

    return true, nil, playerHours, 0
end

function ChecklistItem(item)
    for _i, v in pairs(Config.InventoryAccess.allowedItems) do
        if item == v then
            return true
        end
    end
    return false
end

function GetPlayerInventory(source)
    local data = {}

    if Config.Framework == 'standalone' then
        return {}
    end

    local Player = GetPlayer(source)
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        for _i, v in pairs(Player.getInventory()) do
            if v then
                v.count = v.count or v.amount
                if v and tonumber(v.count) > 0 and ChecklistItem(v.name) then
                    local formattedData = v
                    formattedData.name = string.lower(v.name)
                    formattedData.label = v.label
                    formattedData.amount = v.count
                    formattedData.image = v.image or (string.lower(v.name) .. '.png')
                    local metadata = v.metadata or v.info
                    if not metadata or next(metadata) == nil then
                        metadata = false
                    end
                    formattedData.metadata = metadata
                    table.insert(data, formattedData)
                end
            end
        end
    elseif Config.Framework == "qb" or Config.Framework == "oldqb" or Config.Framework == "tmc" then
        for _i, v in pairs(Player.PlayerData.items) do
            if v then
                local amount = v.count or v.amount
                if tonumber(amount) > 0 and ChecklistItem(v.name) then
                    local formattedData = v
                    formattedData.name = string.lower(v.name)
                    formattedData.label = v.label
                    formattedData.amount = amount
                    formattedData.image = v.image or (string.lower(v.name) .. '.png')
                    local metadata = v.metadata or v.info
                    if not metadata or next(metadata) == nil then
                        metadata = false
                    end
                    formattedData.metadata = metadata
                    table.insert(data, formattedData)
                end
            end
        end
    elseif Config.Framework == "vrp" then
        for _i, v in pairs(vRP.getInventory(Player)) do
            if v then
                local amount = v.count or v.amount
                if tonumber(amount) > 0 and ChecklistItem(v.name) then
                    local formattedData = v
                    formattedData.name = string.lower(v.name)
                    formattedData.label = v.label
                    formattedData.amount = amount
                    formattedData.image = v.image or (string.lower(v.name) .. '.png')
                    local metadata = v.metadata or v.info
                    if not metadata or next(metadata) == nil then
                        metadata = false
                    end
                    formattedData.metadata = metadata
                    table.insert(data, formattedData)
                end
            end
        end
    end
    return data
end

-- Which name API this vrp2 fork actually answers on: 'identity' | 'fullname'.
-- Resolved once from a real call, because a Proxy interface cannot be probed
-- (see the comment in GetName's vrp2 branch).
local vrp2NameApi = nil

function GetName(source)
    if Config.Framework == 'standalone' then
        local playerName = GetPlayerName(source)
        if playerName then
            return playerName
        end

        local player = StandalonePlayers[source]
        return player and player.name or "Unknown"
    end

    if Config.Framework == "oldesx" or Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
        local Player = GetPlayer(tonumber(source))
        if Player and Player.PlayerData and Player.PlayerData.charinfo then
            local firstname = Player.PlayerData.charinfo.firstname or "Unknown"
            local lastname = Player.PlayerData.charinfo.lastname or ""
            return firstname .. ' ' .. lastname
        else
            return "0"
        end
    elseif Config.Framework == 'vrp' then
        local user_id = vRP.getUserId(source)
        local identity
        if vrpLegacyProxy then
            -- 0.x getUserIdentity(user_id, cbr) only answers through cbr; called
            -- without one, its Task() calls nil on the vrp side. Task() fires cbr
            -- with nil after 5s at the latest, so this cannot hang.
            local p = promise.new()
            vRP.getUserIdentity(user_id, function(row) p:resolve(row or false) end)
            identity = Citizen.Await(p)
        else
            identity = vRP.getUserIdentity(user_id)
        end
        if identity then
            local firstName = identity.firstname or identity.nome or "Unknown"
            local lastName = identity.name or identity.sobrenome or ""
            return firstName .. " " .. lastName
        end
    elseif Config.Framework == 'vrp2' then
        local vrpWait = 0
        while vRP == nil and vrpWait < 50 do
            Wait(100)
            vrpWait = vrpWait + 1
        end
        if vRP == nil then return "Firstname Lastname" end

        local Player = GetPlayer(source)
        if Player then
            -- The Proxy's __index synthesises a callable for EVERY key, so
            -- `type(vRP.FullName) == 'function'` is true even on forks that
            -- have no FullName at all: the probe told us nothing and we paid a
            -- wasted round trip on every single GetName. Call one of them for
            -- real, remember which one answered, and go straight there after.
            -- Identity goes first: vRPex bases expose the character row there
            -- (name / name2), and it is a plain table lookup while the player
            -- is online.
            local name

            if vrp2NameApi ~= 'fullname' then
                local identity = vRP.Identity(Player)
                if type(identity) == 'table' and identity.name then
                    name = identity.name2 and (identity.name .. " " .. identity.name2) or identity.name
                    vrp2NameApi = 'identity'
                end
            end

            if not name and vrp2NameApi ~= 'identity' then
                name = vRP.FullName(Player)
                if name then vrp2NameApi = 'fullname' end
            end

            if name then
                return name
            end
        end
        return "Firstname Lastname"
    end
end

function SendPaymentNotification(src, msg, type)
    if Config.PaymentNotifications == false then return end
    TriggerClientEvent(_event('client:sendNotification'), src, msg, type or "success")
end

-- ─────────────────────────────────────────────────────────────
-- Payment debug logger. Gated by Config.DebugPayment (false by default).
-- Use to troubleshoot "why did player X receive $Y from job Z" reports.
-- All output goes to the SERVER console only — not exposed to clients.
-- ─────────────────────────────────────────────────────────────

local function _payPlayerLabel(src)
    if not src or src == 0 then return "system" end
    local name = "?"
    local pcallOk, n = pcall(GetName, src)
    if pcallOk and n then name = n end
    local id = "?"
    local idOk, ident = pcall(GetIdentifier, src)
    if idOk and ident then id = ident end
    return ("%s [%s] (src=%s)"):format(tostring(name), tostring(id), tostring(src))
end

-- One-liner, parseable log. Use for stage events (calc, coop, payout, etc.).
-- Example: LogPayment("calc", { job="fruitpicker", lobby="ABC", src=12, base=84, final=84 })
function LogPayment(stage, fields)
    if not Config.DebugPayment then return end
    local parts = {}
    if fields then
        local keys = {}
        for k in pairs(fields) do keys[#keys + 1] = k end
        table.sort(keys)
        for _, k in ipairs(keys) do
            local v = fields[k]
            if type(v) == "number" then
                if math.floor(v) == v then
                    parts[#parts + 1] = ("%s=%d"):format(k, v)
                else
                    parts[#parts + 1] = ("%s=%.2f"):format(k, v)
                end
            else
                parts[#parts + 1] = ("%s=%s"):format(k, tostring(v))
            end
        end
    end
    print(("[PAY][%s] %s"):format(stage, table.concat(parts, " ")))
end

-- Multi-line human-readable summary. Use AFTER the final AddMoney call so
-- the customer can see "Player X earned $Y from job Z, broken down as ...".
--   breakdown = {
--     { name = "Daily Bonus",   mult = 1.50, diff = 200, after = 600 },
--     { name = "Negotiator",    mult = 1.10, diff =  60, after = 660 },
--     ...
--   }
function LogPaymentSummary(src, jobId, baseAmount, breakdown, finalAmount, accountType, extras)
    if not Config.DebugPayment then return end
    local label = _payPlayerLabel(src)
    local symbol = (Config and Config.CurrencySymbol) or "$"

    print("[PAY-SUMMARY] ═══════════════════════════════════════════════════════════")
    print(("[PAY-SUMMARY]  Player : %s"):format(label))
    print(("[PAY-SUMMARY]  Job    : %s"):format(tostring(jobId)))
    print(("[PAY-SUMMARY]  Base   : %s%s"):format(symbol, tostring(baseAmount or 0)))
    print("[PAY-SUMMARY] ───────────────────────────────────────────────────────────")
    if breakdown and #breakdown > 0 then
        for _, b in ipairs(breakdown) do
            local sign = (b.diff and b.diff >= 0) and "+" or ""
            print(("[PAY-SUMMARY]   + %-18s %.2fx   (%s%s%s)   → %s%s"):format(
                tostring(b.name or "?"),
                tonumber(b.mult) or 1.0,
                sign, symbol, tostring(b.diff or 0),
                symbol, tostring(b.after or 0)
            ))
        end
    else
        print("[PAY-SUMMARY]   (no multipliers applied)")
    end
    if extras then
        for _, line in ipairs(extras) do
            print(("[PAY-SUMMARY]   %s"):format(tostring(line)))
        end
    end
    print("[PAY-SUMMARY] ───────────────────────────────────────────────────────────")
    print(("[PAY-SUMMARY]  DELIVERED: %s%s   to %s account"):format(
        symbol, tostring(finalAmount or 0), tostring(accountType or "?")))
    print("[PAY-SUMMARY] ═══════════════════════════════════════════════════════════")
end

function AddMoney(source, type, value, jobId)
    if jobId and Config.RewardMultiplierResolver and source and source > 0 then
        local identifier = GetIdentifier(source)
        local ok, mult = pcall(Config.RewardMultiplierResolver, source, identifier, jobId, value)
        if ok and tonumber(mult) and tonumber(mult) > 0 then
            value = math.floor(tonumber(value) * tonumber(mult))
        end
    end

    if Config.Framework == 'standalone' then
        local player = StandalonePlayers[source]
        if player and player.money[type] then
            player.money[type] = player.money[type] + tonumber(value)
        end
        return
    end

    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if type == 'bank' then
                Player.addAccountMoney('bank', tonumber(value))
            end
            if type == 'cash' then
                Player.addMoney(value)
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
            if type == 'bank' then
                Player.Functions.AddMoney('bank', value, 'tw-litejobpack')
            end
            if type == 'cash' then
                Player.Functions.AddMoney('cash', value, 'tw-litejobpack')
            end
        elseif Config.Framework == 'vrp' then
            if type == 'bank' then
                local user_id = vRP.getUserId(source)
                vRP.giveBankMoney(user_id, value)
            end
            if type == 'cash' then
                local user_id = vRP.getUserId(source)
                vRP.giveMoney(user_id, value)
            end
        elseif Config.Framework == 'vrp2' then
            while vRP == nil do
                Wait(100)
            end
            if type == 'bank' then
                vRP.GenerateItem(Player, "dollar", value, true)
            end
            if type == 'cash' then
                vRP.GenerateItem(Player, "dollar", value, true)
            end
        end
    end
end

function RemoveMoney(source, type, value)
    if Config.Framework == 'standalone' then
        local player = StandalonePlayers[source]
        if player and player.money[type] then
            player.money[type] = math.max(0, player.money[type] - tonumber(value))
        end
        return
    end

    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if type == 'bank' then
                Player.removeAccountMoney('bank', value)
            end
            if type == 'cash' then
                Player.removeMoney(value)
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
            if type == 'bank' then
                Player.Functions.RemoveMoney('bank', value, 'tw-litejobpack')
            end
            if type == 'cash' then
                Player.Functions.RemoveMoney('cash', value, 'tw-litejobpack')
            end
        elseif Config.Framework == 'vrp' then
            local user_id = vRP.getUserId(source)
            if type == 'bank' then
                vRP.tryWithdraw(user_id, value)
            end
            if type == 'cash' then
                vRP.tryPayment(user_id, value)
            end
        elseif Config.Framework == 'vrp2' then
            while vRP == nil do
                Wait(100)
            end
            if type == 'bank' then
                vRP.TakeItem(Player, "dollar", value)
            end
            if type == 'cash' then
                vRP.TakeItem(Player, "dollar", value)
            end
        end
    end
end

function AddXP(source, xp)
    if not xp or xp <= 0 then return end

    local identifier = GetIdentifier(source)
    local data = playerJobData[identifier]
    if not data then return end

    local profiledata = data.profiledata
    profiledata.xp = profiledata.xp + tonumber(xp)

    if profiledata.level > #Config.RequiredXP then
        TriggerClientEvent(_event('client:sendNotification'), source, _('xp.maxLevel'), "info")
        return
    end

    if profiledata.xp >= Config.RequiredXP[profiledata.level] then
        profiledata.level = profiledata.level + 1
        profiledata.xp = 0
    end

    profiledata.lasttime = os.date('%Y-%m-%d %H:%M:%S')
end

function addItem(src, item, amount, slot, info)
    local amount = tonumber(amount) or 1

    if Config.Framework == 'standalone' then
        return true
    end

    local Player = GetPlayer(src)
    if not Player then
        return false
    end

    if Config.Framework == 'vrp' then
        local user_id = vRP.getUserId(src)
        vRP.giveInventoryItem(user_id, item, amount)
    elseif Config.Framework == 'vrp2' then
        while vRP == nil do
            Wait(100)
        end
        vRP.GenerateItem(Player, item, amount, true)
    elseif Config.Inventory == "qb_inventory" then
        Player.Functions.AddItem(item, amount, slot, info)
    elseif Config.Inventory == "esx_inventory" then
        Player.addInventoryItem(item, amount)
    elseif Config.Inventory == "ox_inventory" then
        exports.ox_inventory:AddItem(src, item, amount, info)
    elseif Config.Inventory == "codem-inventory" then
        exports["codem-inventory"]:AddItem(src, item, amount, slot, info)
    elseif Config.Inventory == "qs_inventory" then
        exports['qs-inventory']:AddItem(src, item, amount)
    elseif Config.Inventory == "tgiann-inventory" then
        exports["tgiann-inventory"]:AddItem(src, item, amount, slot, info, false)
    elseif Config.Inventory == "ps-inventory" then
        exports["ps-inventory"]:AddItem(src, item, amount, slot, info)
    elseif Config.Inventory == "core_inventory" then
        exports["core_inventory"]:addItem(src, item, amount, info)
    elseif Config.Inventory == "origen_inventory" then
        exports["origen_inventory"]:AddItem(src, item, amount, slot, info)
    else
        print(('[addItem] ^1ERROR^7 No inventory configured! Config.Inventory = %s, item: %s x%d for player %d'):format(
            tostring(Config.Inventory), item, amount, src))
        return false
    end

    return true
end

function GetPlayerMoney(source, value)
    if Config.Framework == 'standalone' then
        local player = StandalonePlayers[source]
        if player and player.money[value] then
            return player.money[value]
        end
        return 0
    end

    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if value == 'bank' then
                return Player.getAccount('bank').money
            end
            if value == 'cash' then
                return Player.getMoney()
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
            if value == 'bank' then
                return Player.PlayerData.money['bank']
            end
            if value == 'cash' then
                return Player.PlayerData.money['cash']
            end
        elseif Config.Framework == 'vrp' then
            local user_id = vRP.getUserId(source)
            if value == 'bank' then
                return vRP.getBankMoney(user_id)
            end
            if value == 'cash' then
                return vRP.getMoney(user_id)
            end
        elseif Config.Framework == 'vrp2' then
            while vRP == nil do
                Wait(100)
            end
            if value == 'bank' then
                local amount = vRP.InventoryItemAmount(Player, "dollar")
                return amount and amount[1] or 0
            end
            if value == 'cash' then
                local amount = vRP.InventoryItemAmount(Player, "dollar")
                return amount and amount[1] or 0
            end
        end
    end
end

function calculateDistance(coord1, coord2)
    local dx = coord1.x - coord2.x
    local dy = coord1.y - coord2.y
    local dz = coord1.z - coord2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function HasItem(source, item)
    if Config.Framework == 'standalone' then
        return true
    end

    local Player = GetPlayer(source)
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        if Config.Inventory == 'codem-inventory' then
            local item = exports["codem-inventory"]:CheckItemValid(source, item.name, tonumber(item.amount))
            return item
        elseif Config.Inventory == 'qs_inventory' then
            local itemCount = exports['qs-inventory']:GetItemTotalAmount(source, item.name)
            if itemCount == 0 or itemCount == nil then
                return false
            end
            return true
        elseif Config.Inventory == 'ox_inventory' then
            local count = exports.ox_inventory:GetItemCount(source, item.name)
            if count and count >= tonumber(item.amount or 1) then
                return true
            else
                return false
            end
        elseif Config.Inventory == 'tgiann-inventory' then
            local src = source
            local has1 = exports["tgiann-inventory"]:HasItem(src, item.name, tonumber(item.amount or 1))
            if has1 then
                return true
            else
                return false
            end
        elseif Config.Inventory == 'ps-inventory' then
            local count = exports["ps-inventory"]:GetItemCount(source, item.name)
            return count and count >= tonumber(item.amount or 1)
        elseif Config.Inventory == 'core_inventory' then
            local count = exports["core_inventory"]:getItemCount(source, item.name)
            return count and count >= tonumber(item.amount or 1)
        elseif Config.Inventory == 'origen_inventory' then
            local count = exports["origen_inventory"]:GetItemCount(source, item.name)
            return count and count >= tonumber(item.amount or 1)
        else
            local playerItem = Player.getInventoryItem(item.name)
            if not playerItem then
                return false
            end
            local amount = playerItem.count or playerItem.amount
            if tonumber(amount) >= tonumber(item.amount) then
                return true
            end
        end
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
        if Config.Inventory == 'codem-inventory' then
            local item = exports["codem-inventory"]:CheckItemValid(source, item.name, tonumber(item.amount))
            return item
        elseif Config.Inventory == 'qs_inventory' then
            local itemCount = exports['qs-inventory']:GetItemTotalAmount(source, item.name)
            if itemCount == 0 or itemCount == nil then
                return false
            end
            return true
        elseif Config.Inventory == 'ox_inventory' then
            local item = exports.ox_inventory:GetItemCount(source, item.name)
            if item and item >= 1 then
                return true
            else
                return false
            end
        elseif Config.Inventory == 'tgiann-inventory' then
            local src = source
            local has1 = exports["tgiann-inventory"]:HasItem(src, item.name, tonumber(item.amount or 1))
            if has1 then
                return true
            else
                return false
            end
        elseif Config.Inventory == 'ps-inventory' then
            local count = exports["ps-inventory"]:GetItemCount(source, item.name)
            return count and count >= tonumber(item.amount or 1)
        elseif Config.Inventory == 'core_inventory' then
            local count = exports["core_inventory"]:getItemCount(source, item.name)
            return count and count >= tonumber(item.amount or 1)
        elseif Config.Inventory == 'origen_inventory' then
            local count = exports["origen_inventory"]:GetItemCount(source, item.name)
            return count and count >= tonumber(item.amount or 1)
        else
            return Core.Functions.HasItem(source, item.name, tonumber(item.amount))
        end
    elseif Config.Framework == 'vrp' then
        local user_id = vRP.getUserId(source)
        if not user_id then return false end
        local amount = vRP.getInventoryItemAmount(user_id, item.name)
        if amount and amount >= tonumber(item.amount) then
            return true
        end
    elseif Config.Framework == 'vrp2' then
        while vRP == nil do
            Wait(100)
        end
        local Player = GetPlayer(source)
        if Player then
            local itemData = vRP.InventoryItemAmount(Player, item.name)
            local itemAmount = itemData and itemData[1] or 0
            if itemAmount >= tonumber(item.amount) then
                return true
            end
        end
    end
    return false
end

function removeItem(src, item, amount)
    amount = tonumber(amount) or 1

    if Config.Framework == 'standalone' then
        return true
    end

    local Player = GetPlayer(src)
    if Player then
        if Config.Framework == 'vrp' then
            local user_id = vRP.getUserId(src)
            vRP.tryGetInventoryItem(user_id, item, amount)
        end
        if Config.Framework == 'vrp2' then
            while vRP == nil do
                Wait(100)
            end
            vRP.TakeItem(Player, item, amount)
        end
        if Config.Inventory == "qb_inventory" then
            Player.Functions.RemoveItem(item, amount)
        elseif Config.Inventory == "esx_inventory" then
            Player.removeInventoryItem(item, amount)
        elseif Config.Inventory == "ox_inventory" then
            exports.ox_inventory:RemoveItem(src, item, amount)
        elseif Config.Inventory == "codem-inventory" then
            exports["codem-inventory"]:RemoveItem(src, item, amount)
        elseif Config.Inventory == "qs_inventory" then
            exports['qs-inventory']:RemoveItem(src, item, amount)
        elseif Config.Inventory == "tgiann-inventory" then
            local itemData = exports["tgiann-inventory"]:GetItemByName(src, item)
            if itemData.amount > 0 then
                local success = exports["tgiann-inventory"]:RemoveItem(src, item, amount, itemData.key)
            end
        elseif Config.Inventory == "ps-inventory" then
            exports["ps-inventory"]:RemoveItem(src, item, amount)
        elseif Config.Inventory == "core_inventory" then
            exports["core_inventory"]:removeItem(src, item, amount)
        elseif Config.Inventory == "origen_inventory" then
            exports["origen_inventory"]:RemoveItem(src, item, amount)
        end
        return true
    end
end

-- Inventory-agnostic usable item registration.
-- Jobs call RegisterUsableItem(name, callback). For qb/esx we bind to the native
-- framework usable-item system. Every callback is also stored in _G.UsableItemHandlers
-- so customers on vrp / vrp2 / standalone / custom inventories can fire the same
-- guarded logic from their own item handler via the exported helper:
--
--     exports['tw-litejobpack']:TriggerUsableItem("standartrod", source)
--
-- Lives in escrow_ignore'd utility.lua so it's freely editable downstream.
_G.UsableItemHandlers = _G.UsableItemHandlers or {}

function RegisterUsableItem(itemName, callback)
    if type(itemName) ~= 'string' or type(callback) ~= 'function' then
        return false
    end

    _G.UsableItemHandlers[itemName] = callback

    local Framework = Config.Framework
    local Inventory = Config.Inventory

    -- ox_inventory bypasses qb-core/esx native usable-item registries. We rely on
    -- the global ox_inventory:usedItem listener (installed below) which dispatches
    -- from UsableItemHandlers. Customer must still define the item in
    -- ox_inventory/data/items.lua so the "Use" action shows up in the UI.
    --
    -- Runtime check trumps Config.Inventory: customers routinely leave
    -- Config.Inventory on the default ("qb_inventory") even after switching to
    -- ox_inventory, which double-registers the callback through the qb/qbx
    -- bridge and produces opaque "@ox_inventory/modules/bridge/qbx/server.lua"
    -- crashes. If ox_inventory is actually running we always take this path.
    if Inventory == 'ox_inventory' or GetResourceState('ox_inventory') == 'started' then
        return true
    end

    if Framework == 'qb' or Framework == 'oldqb' or Framework == 'tmc' then
        if type(Core) == 'table' and Core.Functions and Core.Functions.CreateUseableItem then
            Core.Functions.CreateUseableItem(itemName, callback)
            return true
        end
    elseif Framework == 'esx' or Framework == 'oldesx' then
        if type(Core) == 'table' and Core.RegisterUsableItem then
            Core.RegisterUsableItem(itemName, callback)
            return true
        end
    elseif Framework == 'vrp' or Framework == 'vrp2' or Framework == 'standalone' then
        -- No native callback wiring on these frameworks. The customer registers the
        -- item in their own config (e.g. vRP.defInventoryItem) and calls
        -- exports['tw-litejobpack']:TriggerUsableItem(itemName, source) from the
        -- "Use" choice. The callback here is already stored in UsableItemHandlers.
        return true
    end

    print(('[tw-litejobpack] RegisterUsableItem: unsupported framework "%s" for item "%s"'):format(
        tostring(Framework), tostring(itemName)))
    return false
end

-- ox_inventory dispatch bridge. Fires whenever any item is used in ox_inventory;
-- we look it up in our registry and run the guarded callback. Harmless when
-- ox_inventory isn't running — the event simply never fires.
AddEventHandler('ox_inventory:usedItem', function(source, name, slot, metadata)
    if not name or not source then return end
    local fn = _G.UsableItemHandlers[name]
    if type(fn) == 'function' then
        fn(source)
    end
end)

-- Public trigger for the registered usable-item callback. Use this from custom
-- inventory / framework item handlers (vRP defInventoryItem "Use" choice, qs/ox
-- custom hooks, standalone chat commands, etc.) to run the same guarded logic
-- jobs install via RegisterUsableItem. Returns true if a handler ran.
function TriggerUsableItem(itemName, source)
    local fn = _G.UsableItemHandlers[itemName]
    if type(fn) ~= 'function' or not source then return false end
    fn(source)
    return true
end

-- Inventory-agnostic item count.
-- Returns the number of items of `itemName` the player owns across their inventory.
-- Works with all Config.Inventory values that expose a count API; returns 0 otherwise.
function GetItemCount(src, itemName)
    if Config.Framework == 'standalone' then return 0 end

    if Config.Inventory == "ox_inventory" then
        return exports.ox_inventory:GetItemCount(src, itemName) or 0
    elseif Config.Inventory == "qs_inventory" then
        return exports['qs-inventory']:GetItemTotalAmount(src, itemName) or 0
    elseif Config.Inventory == "codem-inventory" then
        local ok = exports["codem-inventory"]:CheckItemValid(src, itemName, 1)
        return ok and 1 or 0
    elseif Config.Inventory == "tgiann-inventory" then
        local data = exports["tgiann-inventory"]:GetItemByName(src, itemName)
        return (data and data.amount) or 0
    elseif Config.Inventory == "ps-inventory" then
        return exports["ps-inventory"]:GetItemCount(src, itemName) or 0
    elseif Config.Inventory == "core_inventory" then
        return exports["core_inventory"]:getItemCount(src, itemName) or 0
    elseif Config.Inventory == "origen_inventory" then
        return exports["origen_inventory"]:GetItemCount(src, itemName) or 0
    end

    local Player = GetPlayer(src)
    if not Player then return 0 end

    if Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'tmc' then
        local it = Player.Functions.GetItemByName(itemName)
        return it and (it.amount or it.count) or 0
    elseif Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local it = Player.getInventoryItem(itemName)
        return it and (it.count or it.amount) or 0
    end

    return 0
end

-- True when Config.Inventory stores weapons as inventory items (ox-style).
-- Used by jobs that hand out weapons via the inventory API instead of native GiveWeaponToPed.
function IsItemBasedWeaponInventory()
    return Config.Inventory == "ox_inventory"
        or Config.Inventory == "core_inventory"
end

function waitFor(cb, errMessage, timeout)
    local value = cb()
    if value ~= nil then return value end

    if timeout or timeout == nil then
        if type(timeout) ~= 'number' then timeout = 1000 end
    end

    local startTime = timeout and os.time()
    local elapsed = 0

    while value == nil do
        Citizen.Wait(100)

        if timeout then
            elapsed = os.time() - startTime
            if elapsed * 1000 > timeout then
                return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', elapsed * 1000), 2)
            end
        end

        value = cb()
    end

    return value
end

RegisterServerCallback('getPlayerIdentifier', function(src, cb)
    local identifier = GetIdentifier(src)
    cb(identifier)
end)

RegisterServerCallback('selectJob', function(src, cb, jobId)
    if not jobId or not Config.Jobs[jobId] then
        cb(false, "Invalid job")
        return
    end

    if not Config.Jobs[jobId].enabled then
        cb(false, "This job is not available")
        return
    end

    SetPlayerSelectedJob(src, jobId)

    TriggerClientEvent(_event('client:setSelectedJob'), src, jobId)
    cb(true, jobId)
end)

RegisterServerCallback('getSelectedJob', function(src, cb)
    local selectedJob = GetPlayerSelectedJob(src)
    cb(selectedJob)
end)

RegisterServerCallback('canStartJobAtNPC', function(src, cb, jobId)
    if not jobId or not Config.Jobs[jobId] then
        cb({ success = false, message = "Invalid job" })
        return
    end

    if not Config.Jobs[jobId].enabled then
        cb({ success = false, message = "This job is not available" })
        return
    end

    local meetsHours, failReason, playerHours, limitValue = CheckHoursRequirement(src, Config.Jobs[jobId])
    if not meetsHours then
        if failReason == "max" then
            cb({ success = false, message = _('notify.exceededMaxHours', { current = playerHours, max = limitValue }) })
        else
            cb({
                success = false,
                message = _('notify.insufficientHours',
                    { required = limitValue, current = playerHours })
            })
        end
        return
    end

    local identifier = GetIdentifier(src)
    if identifier then
        local lobbyInfo = Lobby.GetPlayerLobbyByIdentifier(identifier)
        if lobbyInfo then
            local lobby = lobbyInfo.lobbyData
            if lobby.roomSetting.startJob and not lobby.roomSetting.finishJob then
                cb({
                    success = true,
                    inActiveJob = true,
                    isOwner = lobbyInfo.isOwner,
                    jobId = lobby.roomSetting.jobId,
                })
                return
            end
        end
    end

    if not Config.RequireSelectedJob then
        cb({ success = true })
        return
    end

    local selectedJob = GetPlayerSelectedJob(src)

    if not selectedJob then
        cb({ success = false, message = "You must first select a job from the Job Center" })
        return
    end

    if selectedJob ~= jobId then
        local jobName = Config.Jobs[jobId].name or jobId
        cb({ success = false, message = "You must select " .. jobName .. " from the Job Center first" })
        return
    end

    cb({ success = true })
end)
