--[[============================================================================
    apex_garage — shared/framework.lua   (open source, edit freely)
    ----------------------------------------------------------------------------
    Unified bridge over ESX Legacy / QBCore / QBox. Auto-detected.
    Only the surface a garage needs: identity, money, jobs/gangs, society funds,
    vehicle props (client) and the owned-vehicle table mapping (server).
============================================================================]]

Bridge = Bridge or {}

-- A resource that is still booting reports 'starting', NOT 'started'. Folder
-- load order can leave the core booting when this file runs, so accept both —
-- checking only 'started' would silently fall through to the ESX branch on a
-- QB server (wrong table, wrong export).
local function present(res)
    local state = GetResourceState(res)
    return state == 'started' or state == 'starting'
end

--[[⚠⚠ "WHEN I OPEN THE GARAGE IT SAYS INVALID."

     This file runs ONCE, when the resource starts, and the framework was
     decided right then. If the server.cfg ensures this resource BEFORE the core
     (the manifest depends on oxmysql and ox_lib only, so nothing makes the core
     go first), qb-core is still 'stopped' at that moment — installed, just not
     started yet — and detection fell through to its 'esx' fallback for the whole
     session, on a QBCore server:

       * no ESX core to ask, so Bridge:GetIdentifier answered nil and
         apex_garage:list refused every garage with 'invalid' ("Invalid.");
       * the schema migration ran against owned_vehicles, a table QB does not
         have, so player_vehicles never got its columns.

     The client was fine (it loads after everything has started), which is why
     nothing looked wrong until the server was asked who the player is.

     So: a core that is RUNNING wins, as before; failing that, a core that is
     INSTALLED wins (it is about to start — GetResourceState says 'stopped' for
     a resource that exists but has not started, 'missing' only when it does not
     exist); and while the answer is still that guess, it is re-checked when a
     core starts and the server's boot waits for it (Bridge.AwaitFramework). ]]
local CORES = {
    { res = 'qbx_core',    fw = 'qbx' },
    { res = 'qb-core',     fw = 'qb'  },
    { res = 'es_extended', fw = 'esx' },
}

local function installed(res)
    local state = GetResourceState(res)
    return state ~= nil and state ~= 'missing' and state ~= 'unknown'
end

-- Returns the framework and whether that is a fact (pinned, or its core is
-- running) rather than a guess made before the core started.
local function detect()
    local pinned = Config and Config.framework
    if pinned and pinned ~= 'auto' and pinned ~= '' then return pinned, true end
    for _, c in ipairs(CORES) do
        if present(c.res) then return c.fw, true end
    end
    for _, c in ipairs(CORES) do
        if installed(c.res) then return c.fw, false end
    end
    return 'esx', false
end

local function apply(fw, sure)
    Bridge.framework     = fw
    Bridge.frameworkSure = sure
    Bridge.isESX = fw == 'esx'
    Bridge.isQB  = fw == 'qb' or fw == 'qbx'
    Bridge.isQBX = fw == 'qbx'

    -- Owned-vehicle table per framework
    Bridge.vehTable    = Bridge.isQB and 'player_vehicles' or 'owned_vehicles'
    Bridge.vehOwnerCol = Bridge.isQB and 'citizenid'       or 'owner'
    Bridge.vehPropsCol = Bridge.isQB and 'mods'            or 'vehicle'
end

Bridge.present = present
apply(detect())

--[[ CALLING SOMEBODY ELSE'S EXPORT, SAFELY.

     ⚠ AN EXPORT THAT DOES NOT EXIST THROWS ON THE INDEX, NOT ON THE CALL.
     `exports.qbx_core.GetCoreObject` raises "No such export GetCoreObject in
     resource qbx_core" before the argument list is even reached, so a guard
     shaped `if exports.x.y then` IS the crash it was written to prevent. Both
     the index and the call therefore live inside the pcall.

     Returns (ok, value). `ok == false` means the export is not there or it
     raised; nothing above is allowed to tell those two apart, because the
     answer is the same either way: use something else. ]]
local function callExport(res, name, ...)
    local args = table.pack(...)
    local ok, ret = pcall(function()
        return exports[res][name](exports[res], table.unpack(args, 1, args.n))
    end)
    if ok then return true, ret end
    return false, ret
end
Bridge.CallExport = callExport

--[[ ⚠⚠ A FUNCTION THAT COMES FROM ANOTHER RESOURCE IS NOT A `function`.

     "Invalid." on every garage open, on ESX and on QBCore, with no error
     anywhere: this is why. getSharedObject() / GetCoreObject() hand back a COPY
     of the core, and every function inside it arrives as a function REFERENCE:
     a table whose metatable has __call (citizen/scripting/lua/scheduler.lua,
     funcref_mt). type() answers 'table', so the old `type(fn) ~= 'function'`
     guard refused ESX.GetPlayerFromId and QBCore.Functions.GetPlayer every
     time, GetIdentifier answered nil and apex_garage:list said 'invalid'. Only
     Qbox worked (its branch wraps the exports in local functions). The same
     guard also skipped ESX.Game.*VehicleProperties, so ESX stored cars in
     ox_lib's schema instead of its own.

     So "can this be called" is asked here, never with type(). ]]
local function callable(v)
    if type(v) == 'function' then return true end
    if type(v) ~= 'table' then return false end
    local mt = getmetatable(v)
    return type(mt) == 'table' and type(rawget(mt, '__call')) == 'function'
end
Bridge.Callable = callable

--[[ ⚠⚠ QBOX HAS NO GetCoreObject. THIS IS THE CRASH CUSTOMERS REPORTED.

     Qbox removed the qb-core compatibility object; `exports.qbx_core:
     GetCoreObject()` raises on a current qbx_core and everything that reached
     for it died with it. Because every identity call in this file starts with
     GetCore(), the raise came out of whatever was running at the time:

       * a server callback -> Garage.Guard's pcall caught it and answered
         'invalid', so every take-out on a Qbox server was refused with
         "vehicle unavailable";
       * a client thread  -> no pcall at all, so the THREAD DIED. The garage
         then stopped responding to E entirely until the player rejoined, which
         is what "I have to press it several times" looks like from inside.

     So the qbx branch does not use that object. It builds the shape the rest of
     this file asks for out of the exports Qbox really has, and resolves each one
     AT CALL TIME rather than now — which of them exist moves between Qbox
     versions, and this file must not have to be edited again when it moves. A
     fork that still ships the old shim is used as-is when it answers. ]]
local function qbxCore()
    local ok, obj = callExport('qbx_core', 'GetCoreObject')
    if ok and type(obj) == 'table' and (obj.Functions or obj.Shared) then return obj end

    local f = { Functions = {}, Shared = {}, Game = {} }
    if IsDuplicityVersion() then
        f.Functions.GetPlayer = function(src)
            local o, p = callExport('qbx_core', 'GetPlayer', src)
            return o and p or nil
        end
        f.Functions.GetPlayerByCitizenId = function(cid)
            local o, p = callExport('qbx_core', 'GetPlayerByCitizenId', cid)
            return o and p or nil
        end
    else
        f.Functions.GetPlayerData = function()
            local o, p = callExport('qbx_core', 'GetPlayerData')
            return o and p or nil
        end
    end
    -- Shared.Jobs / Shared.Vehicles are reads, so they are served lazily: asking
    -- Qbox for the whole job list at boot would run before the jobs exist.
    setmetatable(f.Shared, { __index = function(_, k)
        if k == 'Jobs' then
            local o, j = callExport('qbx_core', 'GetJobs')
            return o and type(j) == 'table' and j or nil
        end
        if k == 'Vehicles' then
            local o, v = callExport('qbx_core', 'GetVehiclesByName')
            return o and type(v) == 'table' and v or nil
        end
        return nil
    end })
    -- `Game` stays EMPTY on purpose: Qbox has no core.Game.*VehicleProperties,
    -- and serializersFor() below already prefers ox_lib on QB for that reason.
    return f
end

--[[ A core-shaped table that answers nothing, for the window before the core is
     up (or on a server where it never comes up). Every reader in this file tests
     the field it wants before calling it, so this is inert rather than fatal —
     and it is deliberately NOT cached, so the next call tries the real core
     again instead of being stuck with the placeholder for the session. ]]
local NO_CORE = { Functions = {}, Shared = {}, Game = {} }

local _core
local warnedNoCore = false
function Bridge:GetCore()
    if _core then return _core end
    local obj
    if self.isQBX then
        obj = qbxCore()
    elseif self.isQB then
        local ok, o = callExport('qb-core', 'GetCoreObject')
        obj = ok and o or nil
    else
        local ok, o = callExport('es_extended', 'getSharedObject')
        obj = ok and o or nil
    end
    if type(obj) ~= 'table' then
        if not warnedNoCore then
            warnedNoCore = true
            local msg = ('framework bridge: detected "%s" but its core object could not be obtained. ' ..
                         'If the core is simply still booting this clears itself; if it does not, ' ..
                         'run /garagediag and check Config.framework.'):format(tostring(self.framework))
            -- Utils loads above this file, but this path must not be able to
            -- fail on the way to reporting a failure.
            if Utils and Utils.Err then Utils.Err(msg) else print('[apex_garage] ' .. msg) end
        end
        return NO_CORE
    end
    _core = obj
    return _core
end

-- Did the core actually answer? Used by the diagnostic command; never a gate.
function Bridge:CoreReady()
    local c = self:GetCore()
    return c ~= NO_CORE
end

-- Ask again. A changed answer drops the cached core object, which belonged to
-- the framework we no longer think this is.
function Bridge:Redetect()
    local fw, sure = detect()
    if fw ~= self.framework then
        _core, warnedNoCore = nil, false
        if Utils and Utils.Debug then Utils.Debug(('framework re-detected: %s -> %s'):format(tostring(self.framework), fw)) end
    end
    apply(fw, sure)
end

-- A core starting after us settles a guess the moment it happens.
AddEventHandler('onResourceStart', function(res)
    if Bridge.frameworkSure then return end
    for _, c in ipairs(CORES) do
        if c.res == res then Bridge:Redetect() return end
    end
end)

--[[ Server boot: hold the schema work until the core is really running, so the
     migration and every callback behind DB.Ready() see the right framework. Only
     waits when detection was a guess, i.e. when this resource was started before
     the core; on a normal ensure order it returns immediately. ]]
function Bridge.AwaitFramework(timeoutMs)
    if Bridge.frameworkSure then return true end
    local deadline = GetGameTimer() + (timeoutMs or 60000)
    while not Bridge.frameworkSure and GetGameTimer() < deadline do
        Wait(250)
        Bridge:Redetect()
    end
    if not Bridge.frameworkSure then
        local msg = ('no framework core is running (qbx_core / qb-core / es_extended) — going with "%s". ' ..
                     'Ensure your core BEFORE this resource in server.cfg, or set Config.framework.'):format(Bridge.framework)
        if Utils and Utils.Err then Utils.Err(msg) else print('[apex_garage] ' .. msg) end
    end
    return Bridge.frameworkSure
end

if IsDuplicityVersion() then
    -- ======================================================================
    -- SERVER
    -- ======================================================================

    --[[ ⚠ THE FIELD IS TESTED, NOT ASSUMED. `core.Functions.GetPlayer(src)` on a
         core whose object could not be obtained is a nil index followed by a nil
         call, and it raised out of whatever was running — see GetCore() above.
         A bridge that cannot find the player returns nil, which every caller in
         this resource already handles; it never throws. ]]
    function Bridge:GetPlayer(src)
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.GetPlayer) or core.GetPlayerFromId
        if not callable(fn) then return nil end
        local ok, p = pcall(fn, src)
        return ok and p or nil
    end

    -- ====================================================================
    -- THE MODEL OF A VEHICLE ROW
    -- ====================================================================
    --[[ Every path in this resource used to read the model out of ONE place:
         `json.decode(row[Bridge.vehPropsCol]).model`. On ESX that is fine — the
         props blob is written at purchase and always carries a model.

         On QBCore and QBox it is not. Their purchase paths insert the row with
         `mods = '{}'`, and the blob only gains a model the first time the car is
         STORED through a garage. So a freshly bought car has no model anywhere in
         the blob: Garage.Lock was handed nil, the client got props with no model
         and died on e_invalid — and because the take-out is what has to happen
         before a store can ever happen, the car could never populate its own blob
         and was bricked permanently. Two of the three supported frameworks could
         not take a newly bought vehicle out of the garage at all.

         The fix is the one the author already wrote at
         server/modules/parking.lua:711-715 ("Row never had a model stored
         (legacy/imported vehicle)") — when the blob has no model, fall back to
         another source the SERVER can vouch for, never to the client. parking.lua
         has an entity in hand and reads GetEntityModel from it; the garage paths
         do not, so their server-side authority is the vehicle row's own model
         columns, which QB fills in at purchase precisely because its blob is
         empty:

           `hash`    QB/QBox: the joaat of the model, written at purchase.
           `vehicle` QB/QBox: the spawn NAME, also written at purchase.
                     NOT read on ESX — there `vehicle` IS the props blob.
           `model`   present on some ESX forks; harmless when absent.

         Same mechanism, same rule (server data only), just the source available
         at each call site. Returns nil when nothing anywhere knows the model,
         which every caller must still treat as "cannot be taken out". ]]
    local function decodeBlob(v)
        if type(v) == 'table' then return v end
        if type(v) ~= 'string' or v == '' then return {} end
        local ok, t = pcall(json.decode, v)
        return (ok and type(t) == 'table') and t or {}
    end

    --[[ One canonical form for a model hash: UNSIGNED 32-bit.

         A joaat is 32 bits, and this codebase now compares hashes that reach it
         from three different places — GetEntityModel on a live entity, a props
         blob written by whichever serializer stored the car, and QB's own `hash`
         column — and those sources do not agree on the SIGN of the top bit. Any
         model whose hash exceeds 0x7FFFFFFF (roughly half of them) can therefore
         arrive as the negative counterpart of the same value, and a raw `==` then
         reads one car as two. That is not a cosmetic difference: the same
         comparison guards confirmSpawn, the store's anti-spoof check and the
         impound's "plate is on the wrong car" refusal, so a sign mismatch would
         refuse legitimate cars rather than let bad ones through.

         Folding to unsigned makes those three sources directly comparable, and
         `nil` (0, blank, unparseable) stays nil so "no model" is never confused
         with the model whose hash happens to be zero. ]]
    local function u32(v)
        local n = math.tointeger(tonumber(v) or 0)
        if not n then return nil end
        n = n % 0x100000000
        return n ~= 0 and n or nil
    end

    -- Do these two values name the same model, whatever shape/sign they arrived
    -- in? False when either side is unknown — an absent model proves nothing and
    -- must never read as a match.
    function Bridge.SameModel(a, b)
        local x, y = u32(a), u32(b)
        return (x ~= nil and y ~= nil and x == y)
    end

    -- A model column may hold a hash (number, or a numeric string) or a spawn
    -- name. Resolve either to a hash; 0 and unparseable values yield nil.
    local function asModelHash(v)
        if v == nil then return nil end
        local n = tonumber(v)
        if n then return u32(n) end
        if type(v) ~= 'string' then return nil end
        local name = v:gsub('%s', ''):lower()
        if name == '' then return nil end
        local ok, h = pcall(joaat, name)
        if not ok then return nil end
        return u32(h)
    end

    -- `props` is optional: pass the already-decoded blob to avoid decoding twice.
    function Bridge:ModelFromRow(row, props)
        if type(row) ~= 'table' then return nil end
        local blob = decodeBlob(props ~= nil and props or row[self.vehPropsCol])
        local model = asModelHash(blob.model)
        if model then return model end
        -- Blob has no model: QB/QBox purchase rows, and legacy/imported rows.
        model = asModelHash(row.hash)
        if model then return model end
        -- Spawn name — QB only. On ESX `vehicle` is the props blob itself.
        if self.isQB then
            model = asModelHash(row.vehicle)
            if model then return model end
        end
        return asModelHash(row.model)
    end

    -- ====================================================================
    -- ESX'S OWN `stored` COLUMN
    -- ====================================================================
    --[[ ESX Legacy tracks whether a car is in a garage in
         `owned_vehicles.stored`, and its own xVehicle class both reads and writes
         it — see [core]/es_extended/server/classes/vehicle.lua:

           :34   SELECT `vehicle` ... WHERE `stored` = true AND owner = ? AND plate = ?
           :66   UPDATE ... SET `stored` = false      (spawning it into the world)
           :220  UPDATE ... SET `stored` = true       (putting it away)

         So `stored` means exactly what our `in_garage` means, and this resource
         tracked only its own column. Both directions broke:

           * A car taken out through apex_garage still read `stored = true` to
             ESX, so ESX.OneSync.SpawnVehicle / anything built on xVehicle would
             happily spawn a SECOND copy of a plate already being driven. A
             duplication bug needing no exploit at all — just two resources.

           * A car put away by another ESX resource read `in_garage = 0` here,
             i.e. "left out in the world", so the owner was charged
             Config.returnCost to recover a car that was already parked.

         Both are fixed by treating the two columns as one fact:
           - StoredSet() keeps `stored` in step on every write (below), and
           - RowInGarage() believes EITHER column on every read.

         QB/QBox have no such column and must never be given one, so both helpers
         are inert off ESX. And a server whose owned_vehicles predates the column
         (or a trimmed schema) must not have every UPDATE fail with "Unknown
         column 'stored'" — DB.HasColumn reports what SHOW COLUMNS actually found
         at boot, so the fragment simply disappears when the column is absent. ]]
    function Bridge:HasStoredColumn()
        if not self.isESX then return false end
        return (DB and DB.HasColumn and DB.HasColumn('stored')) and true or false
    end

    --[[ SQL fragment to append inside a SET clause, e.g.
             'SET `in_garage` = 0' .. Bridge:StoredSet(false)
         It is a literal, carrying no placeholder, so it can be concatenated
         anywhere without disturbing a caller's parameter order. Written in the
         SAME statement as in_garage on purpose: one row, one write, so the two
         columns cannot be left disagreeing by a crash in between. ]]
    function Bridge:StoredSet(inGarage)
        if not self:HasStoredColumn() then return '' end
        return inGarage and ', `stored` = 1' or ', `stored` = 0'
    end

    -- Is this row's vehicle sitting in a garage? Either column saying yes is a
    -- yes — see the note above on cars put away by other ESX resources.
    function Bridge:RowInGarage(row)
        if type(row) ~= 'table' then return false end
        if Utils.IsTrue(row.in_garage) then return true end
        if self.isESX and row.stored ~= nil and Utils.IsTrue(row.stored) then return true end
        return false
    end

    function Bridge:GetIdentifier(src)
        local p = self:GetPlayer(src)
        if not p then return nil end
        if self.isQB then return p.PlayerData.citizenid end
        return p.identifier
    end

    function Bridge:GetCharName(src)
        local p = self:GetPlayer(src)
        if not p then return GetPlayerName(src) or 'Unknown' end
        if self.isQB then
            local ci = p.PlayerData.charinfo or {}
            return ('%s %s'):format(ci.firstname or '?', ci.lastname or '')
        end
        return p.getName and p.getName() or (GetPlayerName(src) or 'Unknown')
    end

    function Bridge:GetJob(src)
        local p = self:GetPlayer(src)
        if not p then return { name = 'unemployed', grade = 0, label = 'Unemployed' } end
        if self.isQB then
            local j = p.PlayerData.job
            return { name = j.name, grade = j.grade.level, label = j.label, onduty = j.onduty }
        end
        local j = p.getJob()
        return { name = j.name, grade = j.grade, label = j.label }
    end

    --[[ Gangs are native to QB/QBox only. ESX servers can wire a custom resolver
         by overriding this in shared/integrations.lua.

         ALWAYS RETURNS A TABLE with a string `name` and a numeric `grade`, and
         never the hook's own value verbatim.

         The ESX branch used to `return Integrations.GetGang(src)` straight out,
         un-pcall'd — while integrations.lua documents nil as a perfectly valid
         answer ("Return { name = string, grade = number } or nil"). Every caller
         then indexes .name/.grade on it, so a resolver that returned nil, or
         threw, blew up INSIDE the list callback: lib.callback.await on the client
         never resolves, and the player is left staring at a garage that opens on
         to nothing, with no error and no message. parking.lua:452 defends itself
         with `or {}` and the other four sites do not, which is what shows the
         inconsistency was accidental rather than intended.

         So the normalisation happens once, here, and every caller is safe by
         construction — including the ones that only read `.grade`. A fresh table
         is returned each time so a caller mutating the result cannot poison the
         next one. ]]
    local GANG_NONE_WARNED = {}
    function Bridge:GetGang(src)
        if self.isQB then
            local p = self:GetPlayer(src)
            local g = p and p.PlayerData and p.PlayerData.gang
            if g then
                return { name = tostring(g.name or 'none'),
                         grade = math.floor(tonumber(g.grade and g.grade.level) or 0),
                         label = g.label }
            end
        end
        if Integrations and Integrations.GetGang then
            local ok, g = pcall(Integrations.GetGang, src)
            if not ok then
                -- Once per restart: a broken resolver is a config error the owner
                -- must fix, not a line to print on every list open.
                if not GANG_NONE_WARNED.threw then
                    GANG_NONE_WARNED.threw = true
                    Utils.Err(('Integrations.GetGang threw (%s) — treating everyone as gangless. Fix the resolver in shared/integrations.lua.')
                        :format(tostring(g)))
                end
            elseif type(g) == 'table' then
                return { name = tostring(g.name or 'none'),
                         grade = math.floor(tonumber(g.grade) or 0),
                         label = g.label }
            end
        end
        return { name = 'none', grade = 0 }
    end

    -- Prefer set* over add/remove on ESX (avoids "not safe for net" spam)
    local function esxApplyDelta(p, account, delta)
        if account == 'bank' then
            local acc = p.getAccount('bank') or { money = 0 }
            local new = math.max(0, (tonumber(acc.money) or 0) + delta)
            if p.setAccountMoney then p.setAccountMoney('bank', new)
            elseif delta > 0 then p.addAccountMoney('bank', delta)
            else p.removeAccountMoney('bank', -delta) end
            return true
        end
        local cur = p.getMoney and p.getMoney() or 0
        local new = math.max(0, cur + delta)
        if p.setMoney then p.setMoney(new)
        elseif delta > 0 then p.addMoney(delta)
        else p.removeMoney(-delta) end
        return true
    end

    function Bridge:GetMoney(src, account)
        local p = self:GetPlayer(src)
        if not p then return 0 end
        if self.isQB then
            return p.PlayerData.money[account == 'bank' and 'bank' or 'cash'] or 0
        end
        if account == 'bank' then
            local acc = p.getAccount('bank')
            return acc and acc.money or 0
        end
        return p.getMoney and p.getMoney() or 0
    end

    function Bridge:AddMoney(src, account, amount)
        local p = self:GetPlayer(src)
        if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        if self.isQB then return p.Functions.AddMoney(account, amount, 'apex_garage') end
        return esxApplyDelta(p, account, amount)
    end

    -- Charge a player, preferring bank, falling back to cash if bank is short.
    -- Returns true only if the full amount was taken.
    function Bridge:RemoveMoney(src, account, amount)
        local p = self:GetPlayer(src)
        if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return true end
        if self:GetMoney(src, account) < amount then return false end
        if self.isQB then return p.Functions.RemoveMoney(account, amount, 'apex_garage') end
        return esxApplyDelta(p, account, -amount)
    end

    --[[ Take a fee. `account` is optional:
           'bank' / 'cash' -> that account ONLY. Not enough there means the charge
                              fails, even if the other account could cover it —
                              that is the point of pinning it.
           anything else   -> the historic behaviour, bank first then cash.
         Every existing caller omits it and is unaffected. ]]
    function Bridge:Charge(src, amount, account)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return true end
        if account == 'bank' or account == 'cash' then
            if self:GetMoney(src, account) >= amount then return self:RemoveMoney(src, account, amount) end
            return false
        end
        if self:GetMoney(src, 'bank') >= amount then return self:RemoveMoney(src, 'bank', amount) end
        if self:GetMoney(src, 'cash') >= amount then return self:RemoveMoney(src, 'cash', amount) end
        return false
    end

    -- --------------------------------------------------------------------
    -- Society funds (fee sinks for return / transfer / impound)
    -- --------------------------------------------------------------------
    local function accountName(job)
        if present('esx_society') then
            local society
            TriggerEvent('esx_society:getSociety', job, function(s) society = s end)
            if society and society.account and society.account ~= '' then
                return society.account
            end
        end
        return 'society_' .. job
    end

    --[[ A FAILED SOCIETY DEPOSIT IS DESTROYED MONEY, AND MUST BE LOUD.

         This returned false whenever no society resource was installed, and both
         callers (server/main.lua's return fee and server/modules/impound.lua's
         impound fee) ignored the answer — the player had already been charged, so
         the fee simply vanished out of the economy with nothing printed anywhere.
         On a server with no esx_addonaccount, or a QB server running the society
         resource that was not on the two-name list below, that is every single
         garage fee, silently, forever.

         Two changes: qb-management is handled (it is the most widely installed QB
         society resource by a distance, and its absence here was the single most
         likely way for this to bite), and any failure now says so on the console
         — ONCE PER JOB per restart, not once per transaction. A fee sink that is
         misconfigured is misconfigured for every transaction, so per-transaction
         logging would only bury the line that matters under thousands of copies
         of itself. The return value is unchanged (false = the money did not
         arrive) so a caller that wants to refund still can. ]]
    local societyWarned = {}
    local function societyFailed(job, amount, why)
        if societyWarned[job] then return false end
        societyWarned[job] = true
        Utils.Err(([[society deposit FAILED for job "%s" (%s).
        The player was already charged, so this fee — and every later one for this job — is being DESTROYED.
        Fix: install/configure a society resource (ESX: esx_addonaccount; QB: qb-banking, qb-management or Renewed-Banking),
        or clear Config.returnCostSociety / Config.impoundFeeSociety so no fee is routed to a society at all.
        This warning prints once per job per restart.]]):format(tostring(job), why))
        if Webhooks then
            Webhooks.Send('economy', 'Society deposit FAILED — fee destroyed', 'danger', {
                { name = 'Job', value = job }, { name = 'Amount', value = amount },
                { name = 'Reason', value = why },
                { name = 'Framework', value = Bridge.framework },
            })
        end
        return false
    end

    function Bridge:AddSocietyMoney(job, amount)
        amount = math.floor(tonumber(amount) or 0)
        if not job or job == '' or amount <= 0 then return false end
        if self.isQB then
            if present('qb-banking') then
                local ok, res = pcall(function() return exports['qb-banking']:AddMoney(job, amount, 'apex_garage') end)
                if ok and res ~= false then return true end
            end
            if present('Renewed-Banking') then
                local ok, res = pcall(function() return exports['Renewed-Banking']:addAccountMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            -- qb-management: the stock QB society/boss-menu account resource, and
            -- the one most QB servers actually run. Job and gang accounts are
            -- separate there, so try the job account and fall back to the gang
            -- one — a gang garage's fee is filed under a gang name, and
            -- AddMoney would silently do nothing with it.
            if present('qb-management') then
                local ok, res = pcall(function() return exports['qb-management']:AddMoney(job, amount) end)
                if ok and res ~= false then return true end
                local okG, resG = pcall(function() return exports['qb-management']:AddGangMoney(job, amount) end)
                if okG and resG ~= false then return true end
            end
            return societyFailed(job, amount,
                'no supported QB society resource answered — looked for qb-banking, Renewed-Banking, qb-management')
        end
        if not present('esx_addonaccount') then
            return societyFailed(job, amount, 'esx_addonaccount is not running')
        end
        local account
        TriggerEvent('esx_addonaccount:getSharedAccount', accountName(job), function(acc) account = acc end)
        if not account then
            return societyFailed(job, amount,
                ('esx_addonaccount has no shared account named "%s"'):format(accountName(job)))
        end
        local ok, err = pcall(function() account.addMoney(amount) end)
        if not ok then return societyFailed(job, amount, ('addMoney threw: %s'):format(tostring(err))) end
        return true
    end

    function Bridge:GetJobs()
        local out = {}
        if self.isQB then
            -- One read, not two: on Qbox `Shared.Jobs` is a lazy export call
            -- behind a metatable, and asking for it twice asked Qbox twice.
            local shared = self:GetCore().Shared
            local jobs = type(shared) == 'table' and shared.Jobs or nil
            for name, j in pairs(jobs or {}) do
                out[#out + 1] = { name = name, label = j.label or name }
            end
        else
            local ok, jobs = pcall(function() return MySQL.query.await('SELECT name, label FROM jobs') end)
            for _, j in ipairs(ok and jobs or {}) do out[#out + 1] = { name = j.name, label = j.label or j.name } end
        end
        table.sort(out, function(a, b) return a.name < b.name end)
        return out
    end

else
    -- ======================================================================
    -- CLIENT
    -- ======================================================================

    --[[ ⚠ SAME RULE AS THE SERVER'S GetPlayer, and it matters MORE here: this one
         is called from CreateThread loops (the boot wait in client/main.lua, the
         access checks behind the proximity prompt). A raise in a thread is not
         caught by anything — the thread simply ends, the garage stops answering E
         and the player has to rejoin. That is what a missing GetCoreObject looked
         like from the driver's seat. ]]
    function Bridge:GetPlayerData()
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.GetPlayerData) or core.GetPlayerData
        if not callable(fn) then return nil end
        local ok, pd = pcall(fn)
        return ok and pd or nil
    end

    --[[ "Loaded" as the framework itself defines it. A non-empty player table is
         not that: ESX.PlayerData is filled piece by piece, and QBCore hands back a
         table with defaults before a character is picked. ESX answers through
         ESX.IsPlayerLoaded(), QBCore and Qbox through LocalPlayer.state.isLoggedIn;
         a core that has neither falls back to "the job is known". ]]
    function Bridge:IsPlayerLoaded()
        if self.isQB then
            local st = LocalPlayer and LocalPlayer.state
            if st and st.isLoggedIn ~= nil then return st.isLoggedIn == true end
        else
            local core = self:GetCore()
            local fn = core.IsPlayerLoaded
            if callable(fn) then
                local ok, v = pcall(fn)
                if ok then return v == true end
            end
        end
        local pd = self:GetPlayerData()
        return type(pd) == 'table' and (pd.job ~= nil or pd.citizenid ~= nil or pd.identifier ~= nil)
    end

    function Bridge:GetJob()
        local pd = self:GetPlayerData()
        if not pd then return { name = 'unemployed', grade = 0 } end
        if self.isQB then
            local j = pd.job or {}
            return { name = j.name, grade = j.grade and j.grade.level or 0, label = j.label }
        end
        local j = pd.job or {}
        return { name = j.name, grade = j.grade, label = j.label }
    end

    function Bridge:GetGang()
        local pd = self:GetPlayerData()
        if self.isQB and pd and pd.gang then
            return { name = pd.gang.name, grade = pd.gang.grade and pd.gang.grade.level or 0 }
        end
        return { name = 'none', grade = 0 }
    end

    -- A cosmetic failure printed only in the PLAYER's F8 console is invisible to
    -- the server owner, who is the only person able to fix the offending row or
    -- config. Mirror genuine failures to the server console too. Deduped by
    -- message so the same broken car pulled ten times still reports once, and a
    -- colour that simply is not stored (the normal case) never reports at all.
    local reported = {}
    local function report(msg)
        if reported[msg] then return end
        reported[msg] = true
        Utils.Err(msg)
        TriggerServerEvent('apex_garage:reportError', msg)
    end

    --[[ WHICH SERIALIZER READS/WRITES A VEHICLE'S PROPS

         ox_lib is a HARD dependency of this resource — fxmanifest.lua loads
         '@ox_lib/init.lua' as a shared_script and lists ox_lib under
         dependencies — so lib.getVehicleProperties / lib.setVehicleProperties
         exist on every server able to start apex_garage at all, ESX included.
         The FRAMEWORK's own serializer is therefore a preference, never a
         requirement, and neither call site may assume it is there:

           * QBox dropped core.Functions.*VehicleProperties entirely.
           * Not every ESX Legacy build carries ESX.Game.Get/SetVehicleProperties.
             `ESX.Game` is created as an EMPTY table in es_extended's
             client/main.lua and only filled in client/functions.lua, so a fork
             that trimmed those two functions — or an es_extended whose
             client/functions.lua threw before reaching them — leaves ESX.Game a
             perfectly valid table with the two fields missing. Any guard that
             checks `core.Game` still passes; the call is what dies.

         That last case is what customers were hitting, and each side failed
         differently:

           SET — `pcall(core.Game.SetVehicleProperties, ...)` hands pcall a nil
                 FUNCTION, which fails with the nameless "attempt to call a nil
                 value". Cosmetic, but reported on every take-out and preview.
           GET — the ESX branch called the field UNPROTECTED, so the missing
                 serializer threw straight out of Store.Vehicle before the store
                 callback was ever sent. That is why a car pulled out could not be
                 put back: the store simply died mid-way, silently.

         So: collect the serializers this server actually has, in preference
         order, and try them in turn. ESX's own goes first — owned_vehicles.vehicle
         is read back by es_extended's own xVehicle/garage code, which expects
         ESX's int-colour schema, so we write ESX's shape whenever ESX can produce
         it. QB puts ox_lib first because QBox has nothing else. ox_lib backstops
         both, which is what makes "no vehicle serializer available" unreachable
         on a correctly installed server.

         Built by appending: a nil inside a table constructor would truncate the
         list at the first missing candidate. ]]
    local function serializersFor(self, which)
        local core = self:GetCore()
        local name = which == 'get' and 'GetVehicleProperties' or 'SetVehicleProperties'
        local ox   = lib and lib[which == 'get' and 'getVehicleProperties' or 'setVehicleProperties']

        local own, first, second
        if self.isQB then
            own = type(core.Functions) == 'table' and core.Functions[name] or nil
            first, second = ox, own          -- QBox has no core.Functions.* at all
        else
            own = type(core.Game) == 'table' and core.Game[name] or nil
            first, second = own, ox          -- ESX's schema first, ox_lib as backstop
        end

        local out = {}
        if callable(first)  then out[#out + 1] = first  end
        if callable(second) then out[#out + 1] = second end
        return out
    end

    function Bridge:GetVehicleProps(vehicle)
        for _, fn in ipairs(serializersFor(self, 'get')) do
            local ok, props = pcall(fn, vehicle)
            if ok and type(props) == 'table' then return props end
        end
        -- Nothing could read the car. Every caller treats nil as "cannot store /
        -- cannot impound" and notifies the player, but the player cannot act on
        -- it — the owner can, so say so where the owner will see it.
        report('GetVehicleProps: no working vehicle serializer on this server ' ..
               '(framework serializer missing and ox_lib unavailable) — vehicles cannot be stored')
        return nil
    end

    -- Colours are applied by us, never by the framework serializer. ESX (and ox_lib)
    -- branch on the TYPE of color1/color2 but only type-check ONE slot at a time: a
    -- {r,g,b} TABLE primary paired with an INT secondary falls through to
    -- SetVehicleColours(vehicle, props.color1, props.color2) and hands a table to a
    -- native expecting an int. That throws HALF WAY through the setter, so the paint
    -- and every prop declared after it (pearlescent, wheels, tint, neon, extras, all
    -- the mods, livery) is lost and the car keeps the random colour CreateVehicle
    -- gave it — a different shade on every take-out. Rows written by the removed
    -- paint feature carry exactly that mixed shape, so normalise and apply here.
    -- Returns the normalised slot (palette int or {r,g,b}) plus a "could not
    -- understand it" flag. The flag matters: a shape we failed to parse must be
    -- LEFT ALONE, never dropped. Losing a player's paint because our parser did
    -- not recognise the row is a worse outcome than the bug we work around here.
    local function clampByte(v) return math.max(0, math.min(255, math.floor(v))) end

    local function colourSlot(c, depth)
        if c == nil then return nil, false end
        depth = depth or 0

        if type(c) == 'number' then
            local n = math.floor(c)
            if n < 0 then return nil, true end
            return n, false
        end

        -- STRINGS. This branch used to fall straight through to "unrecognised",
        -- and a string is one of the most common shapes there is: a TEXT column
        -- comes back from MySQL verbatim, and several paint/tuning resources
        -- write the colour as text rather than as a number. The result was a
        -- console full of
        --   SetVehicleProps: unrecognised colour shape (color1=string, color2=string)
        -- with every one of those cars taken out in a random colour, because a
        -- shape we cannot read is deliberately left for the framework — and the
        -- framework cannot read it either.
        if type(c) == 'string' then
            local s = c:gsub('^%s*(.-)%s*$', '%1')
            if s == '' then return nil, false end   -- blank is "not stored", not an error

            -- "12" — a palette index that round-tripped through text.
            local n = tonumber(s)
            if n then
                n = math.floor(n)
                if n < 0 then return nil, true end
                return n, false
            end

            -- "#FF8800" / "FF8800" — hex, what colour-picker UIs write.
            local hex = s:match('^#?(%x%x%x%x%x%x)$')
            if hex then
                return { clampByte(tonumber(hex:sub(1, 2), 16)),
                         clampByte(tonumber(hex:sub(3, 4), 16)),
                         clampByte(tonumber(hex:sub(5, 6), 16)) }, false
            end

            -- '[255,0,0]' / '{"r":255,...}' — JSON that was stored as a string
            -- instead of decoded, i.e. double-encoded by whoever wrote the row.
            -- Decode once and re-enter; the depth guard stops a pathological
            -- chain of nested encodings from looping.
            local head = s:sub(1, 1)
            if depth < 2 and (head == '[' or head == '{' or head == '"') then
                local ok, decoded = pcall(json.decode, s)
                if ok and decoded ~= nil then return colourSlot(decoded, depth + 1) end
            end

            -- "255,0,0" — a bare triplet.
            local r, g, b = s:match('^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$')
            if r then
                return { clampByte(tonumber(r)), clampByte(tonumber(g)), clampByte(tonumber(b)) }, false
            end

            return nil, true
        end

        if type(c) ~= 'table' then return nil, true end
        -- json.decode yields an ARRAY for [r,g,b] but a STRING-KEYED table for
        -- {"r":..,"g":..,"b":..}. Both shapes are written in the wild depending on
        -- which resource serialised the row, so both are first-class here.
        -- tonumber() on each part also covers a table of NUMERIC STRINGS,
        -- ["255","0","0"], which is what a JSON blob written by PHP looks like.
        local r = tonumber(c[1] or c.r or c.red)
        local g = tonumber(c[2] or c.g or c.green)
        local b = tonumber(c[3] or c.b or c.blue)
        if not (r and g and b) then return nil, true end
        return { clampByte(r), clampByte(g), clampByte(b) }, false
    end

    local function applyColours(vehicle, c1, c2, combo)
        if not c1 and not c2 then
            -- Nothing stored to restore. CreateVehicle rolls a RANDOM entry out of
            -- the model's carvariations, so leaving it be is what makes the same car
            -- come back a different shade every time. Pin a fixed combination
            -- instead — index 0 is the model's own default paint — so the car is at
            -- least always the same car. Silent: no stored colour is not an error.
            if combo then pcall(SetVehicleColourCombination, vehicle, combo) end
            return
        end
        local curPrimary, curSecondary = GetVehicleColours(vehicle)
        -- Palette pass first — SetVehicleColours clears the custom-colour flags, so a
        -- custom slot has to be written AFTER it or it gets wiped straight back off.
        SetVehicleColours(vehicle,
            type(c1) == 'number' and c1 or curPrimary,
            type(c2) == 'number' and c2 or curSecondary)
        if type(c1) == 'table' then SetVehicleCustomPrimaryColour(vehicle, c1[1], c1[2], c1[3]) end
        if type(c2) == 'table' then SetVehicleCustomSecondaryColour(vehicle, c2[1], c2[2], c2[3]) end
    end

    function Bridge:SetVehicleProps(vehicle, props)
        if not props then return end
        if not DoesEntityExist(vehicle) then return end

        local c1, bad1 = colourSlot(props.color1)
        local c2, bad2 = colourSlot(props.color2)

        -- Fixed carvariations index for cars with no stored paint of their own
        -- (job/gang spawner vehicles). Server-supplied; see server/main.lua.
        local combo = tonumber(props.colorCombination or props.colourCombination)
        if combo then
            combo = math.floor(combo)
            if combo < 0 then combo = nil end
        end

        local rest = props
        if bad1 or bad2 then
            -- We did not understand one of the slots. Leave BOTH keys exactly as
            -- they came so the framework serializer still gets its normal chance at
            -- the original pair — stripping only the half we parsed would hand it a
            -- pair it never saw and discard paint we simply failed to read. Loud,
            -- because an unreadable colour shape is a real data problem the owner
            -- wants to know about.
            report(('SetVehicleProps: unrecognised colour shape on %s (color1=%s, color2=%s) — left untouched for the framework'):format(
                Utils.CleanPlate(GetVehicleNumberPlateText(vehicle)) or '?',
                type(props.color1), type(props.color2)))
        elseif props.color1 ~= nil or props.color2 ~= nil or combo then
            -- Shallow copy minus the colours: whichever serializer runs below never
            -- sees the pair it cannot type-check, so it can no longer throw on it.
            -- Everything else (plate, fuel, damage, mods, wheels, extras) is untouched.
            rest = {}
            for k, v in pairs(props) do rest[k] = v end
            rest.color1, rest.color2 = nil, nil
            rest.colorCombination, rest.colourCombination = nil, nil
        end

        -- pcall every serializer, and only ones that actually EXIST (see
        -- serializersFor): a throw must not abort the spawn path (keys, fuel,
        -- damage, the spawn confirm) over what is only a cosmetic failure — the car
        -- is already in the world by now — but it must not be invisible either, so a
        -- real failure goes to the console via Utils.Err like any other genuine
        -- error. The next candidate is tried on a throw as well as on a missing
        -- serializer: ESX's setter can die HALF WAY through (see applyColours), and
        -- re-running the whole thing through ox_lib restores the props it dropped.
        local ok, err = false, 'no vehicle serializer available (is ox_lib started?)'
        for _, fn in ipairs(serializersFor(self, 'set')) do
            ok, err = pcall(fn, vehicle, rest)
            if ok then break end
        end
        if not ok then
            report(('SetVehicleProps failed for %s: %s'):format(
                Utils.CleanPlate(GetVehicleNumberPlateText(vehicle)) or '?', tostring(err)))
        end

        applyColours(vehicle, c1, c2, combo)
        return ok
    end
end

--[[============================================================================
    /garagediag — WHAT THE BRIDGE ACTUALLY RESOLVED TO
    ----------------------------------------------------------------------------
    The reason this exists: "No such export GetCoreObject in resource qbx_core"
    took a round of screenshots and guesswork to identify, and every symptom it
    produced (a garage that will not open, a take-out refused as "unavailable",
    a client that stops answering E) looks like a different bug from the outside.

    So the bridge says what it found, out loud, in one command:
      * which framework was detected and whether that was pinned or auto
      * whether the core object could actually be obtained
      * which of the calls this resource depends on answer, one by one

    Server side is console-only (`true` as the third argument to RegisterCommand
    restricts it), so a player cannot use it to probe the server.
============================================================================]]
local function diagLines()
    local out = {}
    local function add(fmt, ...) out[#out + 1] = select('#', ...) > 0 and fmt:format(...) or fmt end

    local pinned = Config and Config.framework
    add('framework   : %s  (%s)', tostring(Bridge.framework),
        (pinned and pinned ~= 'auto' and pinned ~= '') and ('pinned in config: ' .. tostring(pinned)) or 'auto-detected')
    if not Bridge.frameworkSure then
        add('  GUESS: no core was running when this resource started — ensure the core before it in server.cfg')
    end
    add('resources   : qbx_core=%s  qb-core=%s  es_extended=%s',
        GetResourceState('qbx_core'), GetResourceState('qb-core'), GetResourceState('es_extended'))
    add('core object : %s', Bridge:CoreReady() and 'OK' or 'NOT AVAILABLE (see the error above this line)')
    local core = Bridge:GetCore()
    local fns = type(core.Functions) == 'table' and core.Functions or {}
    local idFn
    if IsDuplicityVersion() then
        idFn = Bridge.isQB and fns.GetPlayer or core.GetPlayerFromId
    else
        idFn = Bridge.isQB and fns.GetPlayerData or core.GetPlayerData
    end
    add('identity fn : %s', callable(idFn) and 'OK' or 'MISSING (every garage answers "Invalid.")')

    -- Probe the exports this resource actually calls, and say which answered.
    if Bridge.isQBX then
        local names = IsDuplicityVersion()
            and { 'GetCoreObject', 'GetPlayer', 'GetPlayerByCitizenId', 'GetJobs' }
            or  { 'GetCoreObject', 'GetPlayerData' }
        for _, n in ipairs(names) do
            -- GetPlayer needs an argument; probing it with a source that does not
            -- exist still proves the export is THERE, which is all this asks.
            local ok = Bridge.CallExport('qbx_core', n, n == 'GetPlayer' and -1 or nil)
            add('  qbx_core:%-22s %s', n, ok and 'present' or 'MISSING')
        end
        add('  (GetCoreObject MISSING is normal on a current Qbox and is handled)')
    end

    if IsDuplicityVersion() then
        add('veh table   : %s  (owner column `%s`, props column `%s`)',
            Bridge.vehTable, Bridge.vehOwnerCol, Bridge.vehPropsCol)
        local okPath, where = pcall(GetResourcePath, GetCurrentResourceName())
        add('folder      : %s', okPath and tostring(where) or '?')
    else
        local pd = Bridge:GetPlayerData()
        add('player data : %s', (type(pd) == 'table' and next(pd)) and 'OK' or 'EMPTY (not logged in yet?)')
        add('serializers : ox_lib get=%s set=%s',
            tostring(type(lib and lib.getVehicleProperties) == 'function'),
            tostring(type(lib and lib.setVehicleProperties) == 'function'))
    end

    --[[ THE GARAGES THIS BUILD ACTUALLY LOADED, with their source.

         The second thing this command exists for: "I changed the vectors in
         shared/config.lua and the points did not move". Printed from the live
         tables, not from the file, so what appears here is what the running
         resource holds. Old coordinates after a restart mean the server loaded
         another copy of the resource (see `folder` above); a garage that is not
         in the `config` rows at all was created in /apexgarage and lives in the
         database, where no config edit can reach it. ]]
    local ids = {}
    local cfg = (Utils and Utils.ConfigGarages) and Utils.ConfigGarages() or {}
    for id in pairs(cfg) do ids[#ids + 1] = id end
    table.sort(ids)
    add('config garages (shared/config.lua): %d%s', #ids,
        (Config and Config.useConfigGarages == false) and '  — Config.useConfigGarages = false, so NONE of them is active' or '')
    for _, id in ipairs(ids) do
        local loc = cfg[id]
        local a = loc.access or vector3(0.0, 0.0, 0.0)
        local s1 = loc.spawns and loc.spawns[1]
        add('  config   %-14s %-24s %-7s %-4s access %8.2f, %8.2f, %6.2f  spawns %d%s',
            id, tostring(loc.label), tostring(loc.type), tostring(loc.class), a.x, a.y, a.z,
            loc.spawns and #loc.spawns or 0,
            s1 and ('  first %.2f, %.2f, %.2f h %.0f'):format(s1.x, s1.y, s1.z, s1.w or 0.0) or '')
    end
    local created = {}
    if IsDuplicityVersion() then
        if Garages and Garages.All then
            for _, loc in pairs(Garages.All()) do created[#created + 1] = loc end
        end
    else
        for _, g in ipairs((Garage and Garage.dbGarages) or {}) do created[#created + 1] = g end
    end
    table.sort(created, function(x, y) return tostring(x.id) < tostring(y.id) end)
    add('created garages (/apexgarage, database): %d', #created)
    for _, g in ipairs(created) do
        local z = g.zone or {}
        local cx, cy, cz = z.x, z.y, z.z
        if cx == nil and g.access then cx, cy, cz = g.access.x, g.access.y, g.access.z end
        add('  created  %-14s %-24s %-7s %-4s zone   %8.2f, %8.2f, %6.2f  spawns %d  (%s)',
            tostring(g.id), tostring(g.label), tostring(g.type), tostring(g.class),
            tonumber(cx) or 0.0, tonumber(cy) or 0.0, tonumber(cz) or 0.0,
            g.spawns and #g.spawns or 0, tostring(z.shape or 'circle'))
    end
    return out
end

if IsDuplicityVersion() then
    RegisterCommand('garagediag', function(src)
        if src ~= 0 then return end   -- console only
        print('[apex_garage] ---- bridge diagnostic (server) ----')
        for _, l in ipairs(diagLines()) do print('[apex_garage] ' .. l) end
        print('[apex_garage] -------------------------------------')
    end, true)
else
    RegisterCommand('garagediag', function()
        print('[apex_garage] ---- bridge diagnostic (client) ----')
        for _, l in ipairs(diagLines()) do print('[apex_garage] ' .. l) end
        print('[apex_garage] -------------------------------------')
    end, false)
end
