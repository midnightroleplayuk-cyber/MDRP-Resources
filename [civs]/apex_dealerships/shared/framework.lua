--[[
    apex_dealerships — shared/framework.lua  (open source, edit freely)
    Unified bridge over ESX Legacy / QBCore / QBox. Auto-detected.
]]

Bridge = Bridge or {}

-- A resource that is still booting reports 'starting', NOT 'started'. If this
-- resource loads before the core finishes booting (very common — folder order
-- decides it), checking only for 'started' would silently fall through to the
-- ESX fallback ON A QBCORE SERVER: wrong vehicle table, wrong core export,
-- money taken and no car delivered. So accept both states.
local function present(res)
    local state = GetResourceState(res)
    return state == 'started' or state == 'starting'
end

--[[⚠⚠ "I'M NOT ABLE TO BUY ANY CAR" (and the showroom shows $0 cash / $0 bank).

     This file runs ONCE, when the resource starts, and the framework was
     decided right then. If the server.cfg ensures this resource BEFORE the core
     (the manifest depends on oxmysql and ox_lib only, so nothing makes the core
     go first), qb-core is still 'stopped' at that moment — installed, just not
     started yet — and detection fell through to its 'esx' fallback for the whole
     session, on a QBCore server: no ESX core to ask, so Bridge:GetIdentifier
     answered nil and every purchase was refused with 'no_identifier', the money
     read as 0, and the finance columns went to owned_vehicles, a table QB does
     not have. Test drives still started (they need no identity), which is why it
     looked like only buying was broken.

     So: a core that is RUNNING wins, as before; failing that, a core that is
     INSTALLED wins (it is about to start — GetResourceState says 'stopped' for a
     resource that exists but has not started, 'missing' only when it does not
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
    return 'esx', false -- safe fallback
end

local function apply(fw, sure)
    Bridge.framework     = fw
    Bridge.frameworkSure = sure
    Bridge.isESX = fw == 'esx'
    Bridge.isQB  = fw == 'qb' or fw == 'qbx'
    Bridge.isQBX = fw == 'qbx'

    -- Vehicle ownership table per framework
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
     raised; nothing above is allowed to tell those two apart. ]]
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

     "Character not loaded yet" on EVERY purchase, on ESX and on QBCore, with
     no error anywhere: this is why. getSharedObject() / GetCoreObject() hand
     back a COPY of the core, and every function inside it arrives as a function
     REFERENCE: a table whose metatable has __call
     (citizen/scripting/lua/scheduler.lua, funcref_mt). type() answers 'table',
     so the old `type(fn) ~= 'function'` guard refused ESX.GetPlayerFromId and
     QBCore.Functions.GetPlayer every time. GetIdentifier answered nil, the money
     read as $0, and only Qbox worked (its branch wraps the exports in local
     functions). The test drive still started because it needs no identity.

     So "can this be called" is asked here, never with type(). ]]
local function callable(v)
    if type(v) == 'function' then return true end
    if type(v) ~= 'table' then return false end
    local mt = getmetatable(v)
    return type(mt) == 'table' and type(rawget(mt, '__call')) == 'function'
end
Bridge.Callable = callable

--[[ ⚠⚠ QBOX HAS NO GetCoreObject. THIS IS THE CRASH CUSTOMERS REPORTED:

       Callback error: apex_dealerships:myEmployments
       @apex_dealerships/shared/framework.lua:42:
       No such export GetCoreObject in resource qbx_core

     Qbox removed the qb-core compatibility object, so every identity call in
     this file — and they all start with GetCore() — raised on a Qbox server.
     Inside a callback that surfaces as the error above and the panel stays
     empty; inside a client thread nothing catches it and the THREAD DIES.

     So the qbx branch does not use that object. It builds the shape the rest of
     this file asks for out of the exports Qbox really has, resolved AT CALL TIME
     rather than now: which of them exist moves between Qbox versions, and this
     file must not have to be edited again when it moves. A fork that still ships
     the old shim is used as-is when it answers. ]]
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
    -- Served lazily: asking Qbox for the whole job or vehicle list at boot would
    -- run before either of them exists.
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
    -- and the serializers below already prefer ox_lib on QB for that reason.
    return f
end

--[[ A core-shaped table that answers nothing, for the window before the core is
     up. Every reader below tests the field it wants before calling it, so this
     is inert rather than fatal — and it is deliberately NOT cached, so the next
     call tries the real core again instead of being stuck with it. ]]
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
                         'If the core is still booting this clears itself; if it does not, run ' ..
                         '/dealerdiag and check Config.framework.'):format(tostring(self.framework))
            if Utils and Utils.Err then Utils.Err(msg) else print('[apex_dealerships] ' .. msg) end
        end
        return NO_CORE
    end
    _core = obj
    return _core
end

-- Did the core actually answer? Used by the diagnostic command; never a gate.
function Bridge:CoreReady()
    return self:GetCore() ~= NO_CORE
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
     finance columns land on the right table and Stands.Boot/the callbacks behind
     Database.AwaitReady() see the right framework. Only waits when detection was
     a guess, i.e. when this resource was started before the core. ]]
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
        if Utils and Utils.Err then Utils.Err(msg) else print('[apex_dealerships] ' .. msg) end
    end
    return Bridge.frameworkSure
end

if IsDuplicityVersion() then
    -- ==================================================================
    -- SERVER
    -- ==================================================================

    --[[ ⚠ THE FIELD IS TESTED, NOT ASSUMED. `core.Functions.GetPlayer(src)` on a
         core object that could not be obtained is a nil index followed by a nil
         call, and it raised out of whatever was running. A bridge that cannot
         find the player returns nil, which every caller already handles. ]]
    function Bridge:GetPlayer(src)
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.GetPlayer) or core.GetPlayerFromId
        if not callable(fn) then return nil end
        local ok, p = pcall(fn, src)
        return ok and p or nil
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
        if self.isQB then return p.Functions.AddMoney(account, amount, 'apex_dealerships') end
        return esxApplyDelta(p, account, amount)
    end

    function Bridge:RemoveMoney(src, account, amount)
        local p = self:GetPlayer(src)
        if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        if self:GetMoney(src, account) < amount then return false end
        if self.isQB then return p.Functions.RemoveMoney(account, amount, 'apex_dealerships') end
        return esxApplyDelta(p, account, -amount)
    end

    function Bridge:GetAllPlayers()
        return GetPlayers()
    end

    function Bridge:GetPlayerByIdentifier(identifier)
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.GetPlayerByCitizenId)
                   or core.GetPlayerFromIdentifier
        if not callable(fn) then return nil end
        local ok, p = pcall(fn, identifier)
        return ok and p or nil
    end

    -- Credit an OFFLINE player's bank balance straight in the DB (stand
    -- sales, refunds). Online players should go through AddMoney instead.
    function Bridge:AddMoneyOffline(identifier, amount)
        amount = math.floor(tonumber(amount) or 0)
        if not identifier or amount <= 0 then return false end
        if self.isQB then
            local raw = MySQL.scalar.await('SELECT money FROM players WHERE citizenid = ?', { identifier })
            local money = raw and json.decode(raw)
            if not money then return false end
            money.bank = (money.bank or 0) + amount
            MySQL.update.await('UPDATE players SET money = ? WHERE citizenid = ?', { json.encode(money), identifier })
            return true
        end
        local raw = MySQL.scalar.await('SELECT accounts FROM users WHERE identifier = ?', { identifier })
        local accounts = raw and json.decode(raw)
        if not accounts then return false end
        accounts.bank = (accounts.bank or 0) + amount
        MySQL.update.await('UPDATE users SET accounts = ? WHERE identifier = ?', { json.encode(accounts), identifier })
        return true
    end

    -- All framework jobs with their grades — feeds the admin panel job
    -- dropdown. Normalized: { { name, label, grades = { {grade, label}... } } }
    function Bridge:GetJobs()
        local out = {}
        if self.isQB then
            local jobs
            if self.isQBX then
                local ok, res = pcall(function() return exports.qbx_core:GetJobs() end)
                jobs = ok and res or nil
            end
            -- One read, not two: on Qbox `Shared.Jobs` is a lazy export call
            -- behind a metatable, and asking for it twice asked Qbox twice.
            if not jobs then
                local shared = self:GetCore().Shared
                jobs = type(shared) == 'table' and shared.Jobs or nil
            end
            for name, j in pairs(jobs or {}) do
                local grades = {}
                for g, gd in pairs(j.grades or {}) do
                    local n = tonumber(g)
                    if n then grades[#grades + 1] = { grade = n, label = gd.name or gd.label or tostring(n) } end
                end
                table.sort(grades, function(a, b) return a.grade < b.grade end)
                out[#out + 1] = { name = name, label = j.label or name, grades = grades }
            end
        else
            -- ESX: the jobs/job_grades tables are the source of truth.
            -- pcall'd: a missing table must not break the admin panel.
            local okJ, jobs = pcall(function() return MySQL.query.await('SELECT name, label FROM jobs') end)
            local okG, grades = pcall(function() return MySQL.query.await('SELECT job_name, grade, label FROM job_grades ORDER BY grade') end)
            jobs = okJ and jobs or {}
            grades = okG and grades or {}
            local byJob = {}
            for _, g in ipairs(grades) do
                byJob[g.job_name] = byJob[g.job_name] or {}
                local t = byJob[g.job_name]
                t[#t + 1] = { grade = g.grade, label = g.label or tostring(g.grade) }
            end
            for _, j in ipairs(jobs) do
                out[#out + 1] = { name = j.name, label = j.label or j.name, grades = byJob[j.name] or {} }
            end
        end
        table.sort(out, function(a, b) return a.name < b.name end)
        return out
    end

    -- ---------------------------------------------------------------
    -- Society funds (for job/society vehicle purchases)
    -- ---------------------------------------------------------------
    -- Society accounts — the SAME money apex_bossmenu shows and manages.
    -- Mirrors its resolution order exactly (esx_society → esx_addonaccount →
    -- qb-management → qb-banking → Renewed-Banking) and awaits the callback,
    -- because those events answer asynchronously: reading the value straight
    -- after TriggerEvent gave nil, which is why the treasury showed $0.
    local function present(res)
        return GetResourceState(res) == 'started'
    end

    -- esx_society:getSociety only returns the DESCRIPTOR ({name,label,account});
    -- the money itself lives in the esx_addonaccount named `society.account`
    -- (usually 'society_<job>'). Resolve the account name, then the account.
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

    -- esx_addonaccount exposes its methods dot-style: account.addMoney(n)
    local function withAccount(job, fn)
        if not job or job == '' or not present('esx_addonaccount') then return nil end
        local account
        TriggerEvent('esx_addonaccount:getSharedAccount', accountName(job), function(acc)
            account = acc
        end)
        if not account then return nil end
        local ok, res = pcall(fn, account)
        if not ok then return nil end
        return res
    end

    -- A provider is usable when it is running AND the config either says 'auto'
    -- or names it explicitly. Pinning matters on servers that run two banking
    -- resources side by side, where detection order would decide silently.
    local function provider(name)
        local pinned = (Config and Config.societyProvider) or 'auto'
        if pinned ~= 'auto' and pinned ~= name then return false end
        return present(name)
    end

    -- NOTE: pcall's `ok` only means "the export did not error" — an export that
    -- RETURNS false (insufficient funds, unknown account) must not be treated as
    -- a successful transaction.
    --
    -- LGMods_Banking is different from the other QB providers: every business
    -- export requires a live player server ID. The escrowed Apex modules call the
    -- bridge with the original (job, amount) signature, so resolve that player ID
    -- here. During a player callback FiveM's event `source` is preferred. For
    -- withdrawals, where LGMods enforces job/minGrade, background work falls back
    -- to the highest-grade online member of the matching job.
    local function lgmodsAnySource(explicitSrc)
        local function valid(src)
            src = tonumber(src)
            if not src or src <= 0 then return nil end
            return Bridge:GetPlayer(src) and src or nil
        end

        local src = valid(explicitSrc)
        if src then return src end
        src = valid(rawget(_G, 'source'))
        if src then return src end

        -- GetAccountDetails/AddMoney only require a live player ID; they do not
        -- document the matching-job/minGrade restriction used by withdrawals.
        for _, id in ipairs(GetPlayers()) do
            src = valid(id)
            if src then return src end
        end
        return nil
    end

    local function lgmodsJobSource(job, explicitSrc)
        local function validForJob(src)
            src = tonumber(src)
            if not src or src <= 0 then return nil end
            local p = Bridge:GetPlayer(src)
            if not p then return nil end
            local j = Bridge:GetJob(src)
            if not j or j.name ~= job then return nil end
            return src
        end

        local src = validForJob(explicitSrc)
        if src then return src end
        src = validForJob(rawget(_G, 'source'))
        if src then return src end

        -- For background withdrawals choose the highest-grade online member.
        -- LGMods still performs its own minGrade check and can reject the call.
        local bestSrc, bestGrade = nil, -1
        for _, id in ipairs(GetPlayers()) do
            local candidate = validForJob(id)
            if candidate then
                local j = Bridge:GetJob(candidate)
                local grade = tonumber(j and j.grade) or 0
                if grade > bestGrade then
                    bestSrc, bestGrade = candidate, grade
                end
            end
        end
        return bestSrc
    end

    local function lgmodsBalance(job, explicitSrc)
        local src = lgmodsAnySource(explicitSrc)
        if not src then return nil end

        local p = promise.new()
        local settled = false
        local function finish(value)
            if settled then return end
            settled = true
            p:resolve(value)
        end

        local ok = pcall(function()
            exports['LGMods_Banking']:GetAccountDetails(src, 'business', job, function(data)
                if data and data.success == true and data.account then
                    finish(tonumber(data.account.balance))
                else
                    finish(nil)
                end
            end)
        end)

        if not ok then return nil end

        -- Do not leave an Apex callback hanging forever if the banking resource
        -- is stopped/restarted mid-request or never invokes its callback.
        SetTimeout(5000, function() finish(nil) end)
        return Citizen.Await(p)
    end

    function Bridge:GetSocietyMoney(job, src)
        if self.isQB then
            if provider('LGMods_Banking') then
                return lgmodsBalance(job, src)
            end
            if provider('qb-banking') then
                local ok, acc = pcall(function() return exports['qb-banking']:GetAccount(job) end)
                if ok and acc then return tonumber(acc.account_balance or acc.balance) end
                local ok2, bal = pcall(function() return exports['qb-banking']:GetAccountBalance(job) end)
                if ok2 and bal then return tonumber(bal) end
            end
            if provider('qb-management') then
                local ok, bal = pcall(function() return exports['qb-management']:GetAccount(job) end)
                if ok and bal then return tonumber(bal) end
            end
            if provider('okokBanking') then
                local ok, bal = pcall(function() return exports['okokBanking']:GetAccount(job) end)
                if ok and bal then return tonumber(type(bal) == 'table' and (bal.balance or bal.money) or bal) end
            end
            if provider('Renewed-Banking') then
                local ok, bal = pcall(function() return exports['Renewed-Banking']:getAccountMoney(job) end)
                if ok and bal then return tonumber(bal) end
            end
            return nil
        end
        return withAccount(job, function(acc)
            if callable(acc.getMoney) then
                local m = acc.getMoney()
                if type(m) == 'number' then return m end
            end
            return tonumber(acc.money)
        end)
    end

    function Bridge:AddSocietyMoney(job, amount, src)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        if self.isQB then
            if provider('LGMods_Banking') then
                local playerId = lgmodsAnySource(src)
                if not playerId then return false end
                local ok, res = pcall(function()
                    return exports['LGMods_Banking']:AddMoney(playerId, amount, 'business', job)
                end)
                return ok and res == true
            end
            if provider('qb-banking') then
                local ok, res = pcall(function() return exports['qb-banking']:AddMoney(job, amount, 'apex_dealerships') end)
                if ok and res ~= false then return true end
            end
            if provider('qb-management') then
                local ok, res = pcall(function() return exports['qb-management']:AddMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            if provider('okokBanking') then
                local ok, res = pcall(function() return exports['okokBanking']:AddMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            if provider('Renewed-Banking') then
                local ok, res = pcall(function() return exports['Renewed-Banking']:addAccountMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            return false
        end
        return withAccount(job, function(acc)
            acc.addMoney(amount)
            return true
        end) and true or false
    end

    function Bridge:RemoveSocietyMoney(job, amount, src)
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end

        if self.isQB and provider('LGMods_Banking') then
            local playerId = lgmodsJobSource(job, src)
            if not playerId then return false end

            local balance = lgmodsBalance(job, playerId)
            if not balance or balance < amount then return false end

            local ok, res = pcall(function()
                return exports['LGMods_Banking']:RemoveMoney(playerId, amount, 'business', job)
            end)
            return ok and res == true
        end

        local balance = self:GetSocietyMoney(job, src)
        if not balance or balance < amount then return false end
        if self.isQB then
            if provider('qb-banking') then
                local ok, res = pcall(function() return exports['qb-banking']:RemoveMoney(job, amount, 'apex_dealerships') end)
                if ok and res ~= false then return true end
            end
            if provider('qb-management') then
                local ok, res = pcall(function() return exports['qb-management']:RemoveMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            if provider('okokBanking') then
                local ok, res = pcall(function() return exports['okokBanking']:RemoveMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            if provider('Renewed-Banking') then
                local ok, res = pcall(function() return exports['Renewed-Banking']:removeAccountMoney(job, amount) end)
                if ok and res ~= false then return true end
            end
            return false
        end
        return withAccount(job, function(acc)
            acc.removeMoney(amount)
            return true
        end) and true or false
    end

    -- A QB server with no banking resource at all silently falls back to this
    -- resource's internal wallet, which then disagrees with whatever the boss
    -- menu shows. Say so at boot instead of letting the owner discover it.
    CreateThread(function()
        Wait(3000)
        if not Bridge.isQB then return end
        if provider('LGMods_Banking') or provider('qb-banking') or provider('qb-management')
            or provider('okokBanking') or provider('Renewed-Banking') then return end
        print('^3[apex_dealerships]^0 no society banking resource detected ' ..
            '(LGMods_Banking / qb-banking / qb-management / okokBanking / Renewed-Banking). ' ..
            'Business funds will use this resource\'s internal wallet.')
    end)

    -- ---------------------------------------------------------------
    -- Garage persistence (framework vehicle table)
    -- ---------------------------------------------------------------
    -- ESX garages filter `owned_vehicles.type`. A plane saved as 'car' never
    -- shows up in the hangar and a boat never shows up at the marina, so the
    -- domain the vehicle was sold under decides the type.
    local ESX_TYPE = { land = 'car', air = 'aircraft', sea = 'boat' }

    -- @param opts table|nil { domain = 'land'|'air'|'sea', garage = string }
    function Bridge:SaveVehicle(src, model, plate, props, financed, financeData, opts)
        local identifier = self:GetIdentifier(src)
        if not identifier then return false end
        opts = opts or {}
        props = props or {}
        props.plate = plate
        -- ESX garages need the model hash even if the client never sends full props
        props.model = props.model or joaat(model)
        -- oxmysql param arrays cannot contain nil: branch on financed instead
        local finJson = financed and financeData and json.encode(financeData) or nil
        local garage = opts.garage or (Config and Config.defaultGarage) or 'pillboxgarage'
        local vtype = ESX_TYPE[opts.domain or 'land'] or 'car'
        local fuel = math.floor((Config and Config.purchase and Config.purchase.fuelLevel) or 100)

        -- The INSERT is the point of no return for the buyer's money, so a
        -- failure here MUST be visible to the caller (schema drift on QBox,
        -- a duplicate plate, a missing column...) instead of reporting success
        -- and leaving the player paid-up with no vehicle.
        local ok, err = pcall(function()
            if self.isQB then
                local p = self:GetPlayer(src)
                local license = p and p.PlayerData.license or ''
                if finJson then
                    MySQL.insert.await([[
                        INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, fuel, engine, body, state, financed, finance_data)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1000, 1000, 0, 1, ?)
                    ]], { license, identifier, model, joaat(model), json.encode(props), plate, garage, fuel, finJson })
                else
                    MySQL.insert.await([[
                        INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, fuel, engine, body, state, financed, finance_data)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1000, 1000, 0, 0, NULL)
                    ]], { license, identifier, model, joaat(model), json.encode(props), plate, garage, fuel })
                end
            else
                if finJson then
                    MySQL.insert.await([[
                        INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored, financed, finance_data)
                        VALUES (?, ?, ?, ?, 0, 1, ?)
                    ]], { identifier, plate, json.encode(props), vtype, finJson })
                else
                    MySQL.insert.await([[
                        INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored, financed, finance_data)
                        VALUES (?, ?, ?, ?, 0, 0, NULL)
                    ]], { identifier, plate, json.encode(props), vtype })
                end
            end
        end)

        if not ok then
            Utils.Err('SaveVehicle failed (' .. tostring(self.framework) .. '):', tostring(err))
            return false
        end
        return true
    end

    function Bridge:GetOwnedVehicle(identifier, plate)
        return MySQL.single.await(
            ('SELECT * FROM %s WHERE %s = ? AND plate = ?'):format(self.vehTable, self.vehOwnerCol),
            { identifier, plate })
    end

    function Bridge:DeleteOwnedVehicle(identifier, plate)
        return MySQL.update.await(
            ('DELETE FROM %s WHERE %s = ? AND plate = ?'):format(self.vehTable, self.vehOwnerCol),
            { identifier, plate })
    end

else
    -- ==================================================================
    -- CLIENT
    -- ==================================================================

    --[[ ⚠ SAME RULE AS THE SERVER'S GetPlayer, and it matters MORE here: this one
         is called from CreateThread loops, and a raise in a thread is caught by
         nothing — the thread simply ends and the dealership stops responding. ]]
    function Bridge:GetPlayerData()
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.GetPlayerData) or core.GetPlayerData
        if not callable(fn) then return nil end
        local ok, pd = pcall(fn)
        return ok and pd or nil
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

    -- QBox moved vehicle properties to ox_lib and dropped the QBCore-style
    -- core.Functions.* helpers, so calling those there is a nil call — QB/QBox
    -- therefore prefer ox_lib.
    --
    -- ESX must NOT: the props we write end up in `owned_vehicles.vehicle`, which
    -- is read back by the server's own (third-party) garage script. ox_lib's
    -- schema differs from ESX's (custom colours come back as {r,g,b} tables
    -- where ESX expects ints), so a car bought here would come out of the garage
    -- broken. On ESX we stay on ESX's own serializer.
    function Bridge:GetVehicleProps(vehicle)
        if self.isQB and lib and lib.getVehicleProperties then
            local ok, props = pcall(lib.getVehicleProperties, vehicle)
            if ok and props then return props end
        end
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.GetVehicleProperties)
                   or (type(core.Game) == 'table' and core.Game.GetVehicleProperties)
        -- ⚠ `core.Game` is created as an EMPTY table by es_extended and only
        -- filled in client/functions.lua, so a trimmed fork leaves a perfectly
        -- valid table with the two functions missing. Testing the table passes
        -- and the CALL is what dies, which is why the function itself is tested.
        if not callable(fn) then return nil end
        local ok, props = pcall(fn, vehicle)
        return ok and props or nil
    end

    function Bridge:SetVehicleProps(vehicle, props)
        if not props then return end
        if self.isQB and lib and lib.setVehicleProperties then
            local ok = pcall(lib.setVehicleProperties, vehicle, props)
            if ok then return end
        end
        local core = self:GetCore()
        local fn = self.isQB and (core.Functions and core.Functions.SetVehicleProperties)
                   or (type(core.Game) == 'table' and core.Game.SetVehicleProperties)
        if not callable(fn) then return end
        pcall(fn, vehicle, props)
    end
end

--[[============================================================================
    /dealerdiag — WHAT THE BRIDGE ACTUALLY RESOLVED TO
    ----------------------------------------------------------------------------
    The reason this exists: "No such export GetCoreObject in resource qbx_core"
    took a round of screenshots and guesswork to identify, and every symptom it
    produced (an empty staff panel, missing blips, a callback that answers nil)
    looks like a different bug from the outside. So the bridge says what it
    found, out loud, in one command.

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
    add('identity fn : %s', callable(idFn) and 'OK' or 'MISSING (every purchase answers "Character not loaded yet")')

    if Bridge.isQBX then
        local names = IsDuplicityVersion()
            and { 'GetCoreObject', 'GetPlayer', 'GetPlayerByCitizenId', 'GetJobs', 'GetVehiclesByName' }
            or  { 'GetCoreObject', 'GetPlayerData' }
        for _, n in ipairs(names) do
            local ok = Bridge.CallExport('qbx_core', n, n == 'GetPlayer' and -1 or nil)
            add('  qbx_core:%-22s %s', n, ok and 'present' or 'MISSING')
        end
        add('  (GetCoreObject MISSING is normal on a current Qbox and is handled)')
    end

    if IsDuplicityVersion() then
        add('veh table   : %s  (owner column `%s`, props column `%s`)',
            Bridge.vehTable, Bridge.vehOwnerCol, Bridge.vehPropsCol)
    else
        local pd = Bridge:GetPlayerData()
        add('player data : %s', (type(pd) == 'table' and next(pd)) and 'OK' or 'EMPTY (not logged in yet?)')
        add('serializers : ox_lib get=%s set=%s',
            tostring(type(lib and lib.getVehicleProperties) == 'function'),
            tostring(type(lib and lib.setVehicleProperties) == 'function'))
    end
    return out
end

if IsDuplicityVersion() then
    RegisterCommand('dealerdiag', function(src)
        if src ~= 0 then return end   -- console only
        print('[apex_dealerships] ---- bridge diagnostic (server) ----')
        for _, l in ipairs(diagLines()) do print('[apex_dealerships] ' .. l) end
        print('[apex_dealerships] ------------------------------------')
    end, true)
else
    RegisterCommand('dealerdiag', function()
        print('[apex_dealerships] ---- bridge diagnostic (client) ----')
        for _, l in ipairs(diagLines()) do print('[apex_dealerships] ' .. l) end
        print('[apex_dealerships] ------------------------------------')
    end, false)
end
