--[[
    Apex Handling Studio: Framework Bridge
    ────────────────────────────────────────────────────────────
    Auto-detects the running framework and exposes ONE tiny API
    everything else consumes. No framework code anywhere else.

        Bridge.framework          'esx' | 'qb' | 'qbx' | 'standalone'
        Bridge.isESX / isQB / isQBX / isStandalone   (booleans)
        Bridge.Ready()            true once a framework answered

        server:
        Bridge.GetPlayerInfo(src) { identifier, group, job } in ONE lookup
        Bridge.GetIdentifier(src) stable per-character id, or NIL when a
                                  framework is running but the character
                                  has not loaded (never a forged key)
        Bridge.GetJob(src)        { name, grade, label }
        Bridge.GetGroup(src)      admin/staff group string ('user' if none)
        Bridge.HasGroup(src, t)   is the player in any group in list `t`,
                                  checking BOTH the ace tree and the
                                  framework's own permission store

        client:
        Bridge.Notify(msg, type)  framework-native notification

    ── Verified API notes (checked against real sources, not memory) ──

    ESX Legacy 1.13: `exports['es_extended']:getSharedObject()` is
    declared in es_extended/shared/main.lua, so it resolves on the
    server AND the client. ESX.GetPlayerFromId(src) returns nil until
    the character loads. The xPlayer copy carries `.identifier`,
    `.group` and `.job` as PLAIN FIELDS (player.lua:157-161), so we
    read those directly instead of invoking getGroup()/getJob() across
    the resource boundary. ESX also runs
    `add_principal identifier.<license> group.<group>` (player.lua:187),
    which is why the ace tree works on ESX.

    QBCore: admins are granted principals under the `qbcore.*`
    namespace, NOT `group.*`. Checking only `group.admin` silently
    denies every qb-core admin, so HasGroup probes both trees and also
    asks QBCore.Functions.GetPermission as a last resort.

    QBox: `exports.qbx_core:GetPlayer(src)` is the real API and
    permissions go through lib.addPrincipal('player.<src>', 'group.<g>'),
    so the ace tree does work there. qbx_core does NOT publish
    GetCoreObject (only the optional qb compat bridge does), so we
    never ask for it.

    Standalone fallback: with no framework, identifiers fall back to
    the rockstar license and jobs report as 'unemployed'.
]]

Bridge = Bridge or {}

local IS_SERVER = IsDuplicityVersion()
local FRAMEWORK_RESOURCES = { 'es_extended', 'qbx_core', 'qb-core' }

local coreCache = nil
-- Latches once any framework has been seen. A framework that restarts
-- makes detect() briefly answer 'standalone'; this remembers the truth so
-- identity handling never degrades to a license key on a framework server.
local sawFramework = false

-- ─── Detection ──────────────────────────────────────────────
-- qbx_core is checked before qb-core because QBox ships an optional
-- qb-core compatibility bridge; we want the real one to win.
local function resourceUp(name)
    local state = GetResourceState(name)
    return state == 'started' or state == 'starting'
end

local function detect()
    if resourceUp('es_extended') then return 'esx' end
    if resourceUp('qbx_core') then return 'qbx' end
    if resourceUp('qb-core') then return 'qb' end
    return 'standalone'
end

local function applyFramework(fw)
    local changed = (Bridge.framework ~= fw)
    if fw ~= 'standalone' then sawFramework = true end
    Bridge.framework    = fw
    Bridge.isESX        = (fw == 'esx')
    Bridge.isQB         = (fw == 'qb')
    Bridge.isQBX        = (fw == 'qbx')
    Bridge.isStandalone = (fw == 'standalone')
    if changed then
        coreCache = nil
        -- guarded: this runs at load, and a manifest reorder must never
        -- turn a log line into a hard error
        if Utils and Utils.Log then Utils.Log('framework detected:', fw) end
    end
end

applyFramework(detect())

function Bridge.Ready()
    return not Bridge.isStandalone
end

-- Re-detect whenever a framework resource cycles. This replaces the old
-- bounded 10s poll, which gave up permanently on a slow-booting server,
-- and it is also what stops a stale core object from surviving a
-- `restart es_extended` and locking everyone out of the studio.
local function onFrameworkCycle(res)
    for _, name in ipairs(FRAMEWORK_RESOURCES) do
        if res == name then
            coreCache = nil
            applyFramework(detect())
            return
        end
    end
end

if IS_SERVER then
    AddEventHandler('onResourceStart', onFrameworkCycle)
    AddEventHandler('onResourceStop', onFrameworkCycle)
else
    AddEventHandler('onClientResourceStart', onFrameworkCycle)
    AddEventHandler('onClientResourceStop', onFrameworkCycle)
end

-- qb-core hands out a rebuilt core object on reload and announces it with
-- a LOCAL TriggerEvent, so AddEventHandler is what receives it. Using
-- RegisterNetEvent here would also expose the name to the network and let
-- any client flush the cache on demand, turning the access path into a
-- client-controlled cost.
if IS_SERVER then
    AddEventHandler('QBCore:Server:UpdateObject', function() coreCache = nil end)
else
    AddEventHandler('QBCore:Client:UpdateObject', function() coreCache = nil end)
end

-- Frameworks usually start before us, but if this resource is ensured
-- first the detection above starts as standalone. Nudge it for a while
-- in case the framework never fires a resource event we can see.
CreateThread(function()
    for _ = 1, 60 do
        if Bridge.Ready() then return end
        Wait(1000)
        applyFramework(detect())
    end
end)

-- ─── Core object ────────────────────────────────────────────
-- Cached, but the cache is dropped on every framework lifecycle event
-- above, so it can never outlive the runtime it points into.
function Bridge.GetCore()
    if coreCache ~= nil then return coreCache end
    local core
    if Bridge.isESX then
        local ok, obj = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok then core = obj end
    elseif Bridge.isQB then
        local ok, obj = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok then core = obj end
    end
    -- QBox: no GetCoreObject exists on qbx_core itself, so there is
    -- nothing to fetch. Everything QBX needs goes through its exports.
    coreCache = core
    return core
end

-- ─── Job normalizer ─────────────────────────────────────────
-- Everything downstream sees { name, grade, label } regardless of the
-- framework's own job table shape.
--   ESX: job.grade is a NUMBER, job.label is the job label.
--   QB/QBX: job.grade is a TABLE with .level and .name; job.label is
--           still the job label (grade.name is the RANK name, which we
--           deliberately do not use as the job label).
local function normalizeJob(job)
    if type(job) ~= 'table' then
        return { name = 'unemployed', grade = 0, label = 'Unemployed' }
    end
    local grade = 0
    if type(job.grade) == 'table' then
        grade = tonumber(job.grade.level) or 0
    else
        grade = tonumber(job.grade) or 0
    end
    return {
        name  = job.name or 'unemployed',
        grade = grade,
        label = job.label or job.name or 'Unemployed',
    }
end

Bridge.NormalizeJob = normalizeJob

-- ════════════════════════════════════════════════════════════
if IS_SERVER then
-- ════════════════════════════════════════════════════════════

    local function licenseOf(src)
        local id = GetPlayerIdentifierByType(src, 'license')
        if id then return id end
        -- Defensive: scan the identifier list (older artifacts).
        for i = 0, GetNumPlayerIdentifiers(src) - 1 do
            local ident = GetPlayerIdentifier(src, i)
            if ident and ident:find('license:', 1, true) == 1 then
                return ident
            end
        end
        return ('src:%s'):format(src)
    end

    --- The framework's player object, or nil. Every call into a
    --- framework is pcall-guarded: a mid-restart core would otherwise
    --- throw out through accessOf and turn "no permission" into a
    --- hard error for every player.
    function Bridge.GetPlayer(src)
        src = tonumber(src)
        if not src then return nil end
        if Bridge.isESX then
            local core = Bridge.GetCore()
            if core and core.GetPlayerFromId then
                local ok, player = pcall(core.GetPlayerFromId, src)
                if ok then return player end
                coreCache = nil          -- stale reference, re-fetch next time
            end
        elseif Bridge.isQB then
            local core = Bridge.GetCore()
            if core and core.Functions and core.Functions.GetPlayer then
                local ok, player = pcall(core.Functions.GetPlayer, src)
                if ok then return player end
                coreCache = nil
            end
        elseif Bridge.isQBX then
            local ok, player = pcall(function()
                return exports['qbx_core']:GetPlayer(src)
            end)
            if ok then return player end
        end
        return nil
    end

    --- Identifier, group and job from ONE player lookup. The old code
    --- resolved the player separately for each, crossing the resource
    --- boundary (and copying the whole xPlayer) two or three times per
    --- access check.
    --- identifier is nil when a framework is running but the character
    --- has not loaded: callers must treat that as "not ready" rather
    --- than storing data under a different key.
    function Bridge.GetPlayerInfo(src)
        local player = Bridge.GetPlayer(src)
        local info = { identifier = nil, group = 'user', job = normalizeJob(nil) }

        if player then
            if Bridge.isESX then
                if player.identifier then info.identifier = player.identifier end
                -- .group is a plain field on the copy; getGroup() would be
                -- a needless call back into es_extended
                if type(player.group) == 'string' and player.group ~= '' then
                    info.group = player.group
                end
                if player.job then info.job = normalizeJob(player.job) end
            elseif Bridge.isQB or Bridge.isQBX then
                local pd = player.PlayerData
                if pd then
                    if pd.citizenid then info.identifier = pd.citizenid end
                    if pd.job then info.job = normalizeJob(pd.job) end
                    -- QBox multi-job store: a map keyed by job name
                    if type(pd.jobs) == 'table' then info.jobs = pd.jobs end
                end
            end
        end

        -- The license fallback is ONLY for a genuinely frameworkless
        -- server. `isStandalone` alone is not enough: it flips true for a
        -- few seconds while the framework restarts, and forging a key in
        -- that window is exactly what profileIdent exists to prevent.
        -- `sawFramework` latches, so a server that has ever had one never
        -- falls back mid-restart.
        if info.identifier == nil and Bridge.isStandalone and not sawFramework then
            info.identifier = licenseOf(src)
        end
        return info
    end

    function Bridge.GetIdentifier(src)
        return Bridge.GetPlayerInfo(src).identifier
    end

    function Bridge.GetJob(src)
        return Bridge.GetPlayerInfo(src).job
    end

    function Bridge.GetGroup(src)
        return Bridge.GetPlayerInfo(src).group
    end

    --- Is this player in ANY of the groups in `list`?
    --- Checks every place a framework can record staff rank:
    ---   1. the ace tree under group.<name>  (ESX, QBox, txAdmin, manual)
    ---   2. the ace tree under qbcore.<name> (QBCore's own namespace)
    ---   3. the framework's own permission store
    --- Missing #2 is what silently denied every qb-core admin.
    function Bridge.HasGroup(src, list, info)
        if type(list) ~= 'table' then return false end

        for _, g in ipairs(list) do
            if IsPlayerAceAllowed(src, 'group.' .. g) then return true end
            if (Bridge.isQB or Bridge.isQBX) and IsPlayerAceAllowed(src, 'qbcore.' .. g) then
                return true
            end
        end

        -- framework-native group (ESX stores it on the player)
        info = info or Bridge.GetPlayerInfo(src)
        for _, g in ipairs(list) do
            if info.group == g then return true end
        end

        -- QBCore keeps permissions in its own store as well
        if Bridge.isQB then
            local core = Bridge.GetCore()
            if core and core.Functions and core.Functions.HasPermission then
                for _, g in ipairs(list) do
                    local ok, has = pcall(core.Functions.HasPermission, src, g)
                    if ok and has then return true end
                end
            end
        end

        return false
    end

    --- Does the player hold any of these JOBS?
    --- QBox characters can hold several jobs at once, so we also look at
    --- its multi-job store. We deliberately do NOT use qbx_core:HasGroup
    --- here: that predicate spans jobs, GANGS and the citizenid, so a
    --- gang named "mechanic" would inherit the mechanic's editor and the
    --- three frameworks would disagree about what simpleJobs means.
    --- Jobs only, on every framework.
    function Bridge.HasJob(src, list, info)
        if type(list) ~= 'table' or #list == 0 then return false end

        info = info or Bridge.GetPlayerInfo(src)
        for _, j in ipairs(list) do
            if info.job.name == j then return true end
            if info.jobs and info.jobs[j] ~= nil then return true end
        end
        return false
    end

-- ════════════════════════════════════════════════════════════
else -- client
-- ════════════════════════════════════════════════════════════

    --- Framework-native notification, used when the studio UI is closed
    --- and cannot show its own toast. Layered so it can never be a
    --- silent no-op: framework, then ox_lib, then chat, then the GTA
    --- native feed which is always present.
    local NOTIFY_COLORS = {
        success = { 52, 199, 123 },
        error   = { 229, 86, 75 },
        info    = { 31, 94, 255 },
        warning = { 229, 169, 60 },
    }

    function Bridge.Notify(message, msgType, title)
        msgType = msgType or 'info'
        message = tostring(message or '')
        title = title or 'Handling Studio'

        if Bridge.isESX then
            local core = Bridge.GetCore()
            if core and core.ShowNotification then
                -- ESX takes (message, type, duration); passing the type
                -- through is what makes an error read as an error
                local esxType = (msgType == 'warning') and 'error' or msgType
                local ok = pcall(core.ShowNotification, message, esxType, 5000)
                if ok then return true end
            end
        elseif Bridge.isQB or Bridge.isQBX then
            -- qb-core's Notify types are primary/success/error
            local map = { info = 'primary', warning = 'error' }
            local ok = pcall(function()
                exports['qb-core']:Notify(message, map[msgType] or msgType, 5000)
            end)
            if ok then return true end
        end

        if GetResourceState('ox_lib') == 'started' then
            local ok = pcall(function()
                exports.ox_lib:notify({
                    title = title, description = message, type = msgType,
                })
            end)
            if ok then return true end
        end

        if GetResourceState('chat') == 'started' then
            TriggerEvent('chat:addMessage', {
                color = NOTIFY_COLORS[msgType] or NOTIFY_COLORS.info,
                args = { title, message },
            })
            return true
        end

        -- Always-available last resort: nothing here can be missing.
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(('%s: %s'):format(title, message))
        EndTextCommandThefeedPostTicker(false, true)
        return true
    end

end
