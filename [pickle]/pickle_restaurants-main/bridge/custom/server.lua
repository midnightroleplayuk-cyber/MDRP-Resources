-- Standalone bridge. Only runs when no supported framework is present.
-- Provides the same global API the modules rely on so the resource works
-- (and never errors) on a bare server. Inventory uses ox_inventory when
-- available; money is a lightweight oxmysql-backed cash store.
if GetResourceState('es_extended') == 'started' then return end

-- The MIRROR IMAGE of bridge/qb/server.lua's guard, and it has to stay that way: the
-- two files decide independently (custom loads first alphabetically, so it cannot ask
-- whether qb took over) and exactly one of them may define the globals. QBox ships as
-- `qbx_core` with no `qb-core` resource, but its compatibility layer registers the
-- `qb-core` EXPORTS — so the QB bridge drives QBox whenever that object is reachable,
-- and only when it isn't (compat bridge switched off) do we stand in as standalone.
local function QbCoreReachable()
    if GetResourceState('qb-core') == 'started' then return true end
    if GetResourceState('qbx_core') ~= 'started' then return false end
    local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
    return ok and type(core) == "table"
end
if QbCoreReachable() then return end

debugPrint("Loading standalone bridge (no ESX/QB detected).")

-- USABLE ITEMS. Item-use has no standard: ox_inventory calls a per-item export,
-- while every other inventory asks the FRAMEWORK's core for a usable-item
-- callback. We must not depend on the export alone — plenty of inventories don't
-- support one — so the core hook is wired wherever a core exists.
--
-- The case this exists for is a QBox server whose qb compatibility bridge is turned
-- off (`qbx:enablebridge false`): the QB bridge stands down, we load, and qbx_core is
-- still the thing that knows an item was used. Left undefined, `RegisterUsableItem`
-- would simply be nil and using a bag or a meal would silently do nothing on every
-- non-ox inventory.
function RegisterUsableItem(item, cb)
    if GetResourceState('qbx_core') == 'started' then
        exports.qbx_core:CreateUseableItem(item, cb)
        return true
    end
    return false
end

local Accounts = {} -- identifier -> { cash = number, bank = number }

local function IdentifierOf(source)
    return GetPlayerIdentifierByType(source, 'license') or ("src:" .. tostring(source))
end

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_accounts` (
            `identifier` VARCHAR(80) NOT NULL,
            `cash`       BIGINT      NOT NULL DEFAULT 5000,
            `bank`       BIGINT      NOT NULL DEFAULT 5000, -- card payments (e.g. phone orders)
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
end)

-- Which account column a currency maps to. Anything unknown (incl. nil and the
-- "money" the settings default uses) falls back to cash.
local function AccountKey(currency)
    return (currency == "bank") and "bank" or "cash"
end

local function LoadAccount(identifier)
    if Accounts[identifier] then return Accounts[identifier] end
    local row = MySQL.single.await("SELECT cash, bank FROM pickle_restaurant_accounts WHERE identifier = ?", { identifier })
    if not row then
        MySQL.insert.await("INSERT INTO pickle_restaurant_accounts (identifier, cash, bank) VALUES (?, ?, ?)", { identifier, 5000, 5000 })
        Accounts[identifier] = { cash = 5000, bank = 5000 }
    else
        Accounts[identifier] = { cash = row.cash, bank = row.bank or 0 }
    end
    return Accounts[identifier]
end

function ShowNotification(target, text)
    TriggerClientEvent(GetCurrentResourceName() .. ":showNotification", target, text)
end

function GetIdentifier(source)
    if not source or source == 0 then return end
    return IdentifierOf(source)
end

function GetSourceFromIdentifier(identifier)
    for _, src in ipairs(GetPlayers()) do
        if IdentifierOf(tonumber(src)) == identifier then return tonumber(src) end
    end
    return nil
end

function GetPlayerCharacterName(source)
    return GetPlayerName(source) or _L("name_unknown")
end

function GetCharacterNameByIdentifier(identifier)
    local src = GetSourceFromIdentifier(identifier)
    if src then return GetPlayerName(src) end
    return identifier
end

function CanAccessGroup(_, _) return true end

function CheckPermission(source, permission)
    if not permission or permission.ignorePermissions then return true end
    return IsPlayerAceAllowed(source, "command")
end

function IsPlayerAdmin(source)
    if IsPlayerAceAllowed(source, "command") then return true end
    for i = 1, #Config.AdminGroups do
        if IsPlayerAceAllowed(source, "group." .. Config.AdminGroups[i]) then return true end
    end
    return false
end

-- ─── the normalized JOB API (here, WE are the job system) ────────────────────
-- On a frameworkless server there is nothing to ask about jobs, so this bridge
-- provides them: the job LIST is the admin-editable `jobs` setting (validated on
-- read by core's StandaloneJobs) and who holds which job/grade lives in our own
-- `pickle_restaurant_job_players` table (declared in core's CreateTables).
--
-- `JobsAvailable()` is false here on purpose: it does not mean "no jobs", it means
-- "no FRAMEWORK job system" — which is what tells the admin panel to offer the jobs
-- editor instead of a read-only list of the framework's jobs.
JobPlayerCache = {}   -- [identifier] = { identifier, job, grade, name }

-- Loaded once the schema is up (core owns the table). Cached rather than queried per
-- call because the roster is read on every management payload, every payroll run and
-- every permission resolve.
CreateThread(function()
    while not RestaurantsReady do Wait(200) end
    for _, row in ipairs(MySQL.query.await(
        "SELECT identifier, job, grade, name FROM pickle_restaurant_job_players") or {}) do
        JobPlayerCache[row.identifier] = { identifier = row.identifier, job = row.job,
                                           grade = tonumber(row.grade) or 0, name = row.name }
    end
end)

function JobsAvailable() return false end

function GetJobList() return (StandaloneJobs and StandaloneJobs()) or {} end

function GetJobGradeList(jobName)
    if not jobName or jobName == "" then return {} end
    for _, j in ipairs(GetJobList()) do
        if j.name == jobName then return j.grades or {} end
    end
    return {}
end

function GetJobLabel(jobName)
    if not jobName or jobName == "" then return nil end
    for _, j in ipairs(GetJobList()) do
        if j.name == jobName then return j.label or j.name end
    end
    return jobName
end

function IsJobBossGrade(jobName, grade)
    grade = tonumber(grade) or 0
    for _, g in ipairs(GetJobGradeList(jobName)) do
        if g.grade == grade then return g.isboss == true end
    end
    return false
end

-- The grade LABEL for a stored assignment: the authored grade's name, else a plain
-- "Grade N" so a row whose grade an admin has since deleted still reads sensibly.
local function gradeLabelOf(jobName, grade)
    for _, g in ipairs(GetJobGradeList(jobName)) do
        if g.grade == grade then return g.label or _L("job_grade_n", grade) end
    end
    return _L("job_grade_n", grade)
end

function GetPlayerJobInfo(source)
    local id = GetIdentifier(tonumber(source)); if not id then return nil end
    local row = JobPlayerCache[id]
    if not row or not row.job or row.job == "" then return nil end
    local grade = tonumber(row.grade) or 0
    return {
        name       = row.job,
        label      = GetJobLabel(row.job),
        grade      = grade,
        gradeLabel = gradeLabelOf(row.job, grade),
        isBoss     = IsJobBossGrade(row.job, grade),
        -- No duty system to consult on a bare server: holding the job IS being on it.
        onDuty     = true,
    }
end

-- jobName nil/"" = FIRE. There is no "unemployed" job to move them to here, so the
-- row is DELETED — absence is unemployment, which is also what keeps the table small.
function SetPlayerJobGrade(source, jobName, grade)
    source = tonumber(source)
    local id = GetIdentifier(source); if not id then return false end
    if not jobName or jobName == "" then
        JobPlayerCache[id] = nil
        MySQL.update("DELETE FROM pickle_restaurant_job_players WHERE identifier = ?", { id })
        TriggerEvent("pickle_restaurants:jobChanged", source)
        return true
    end
    grade = tonumber(grade) or 0
    local name = GetPlayerCharacterName(source)
    JobPlayerCache[id] = { identifier = id, job = jobName, grade = grade, name = name }
    MySQL.update("INSERT INTO pickle_restaurant_job_players (identifier, job, grade, name) VALUES (?, ?, ?, ?) "
        .. "ON DUPLICATE KEY UPDATE job = VALUES(job), grade = VALUES(grade), name = VALUES(name)",
        { id, jobName, grade, name })
    TriggerEvent("pickle_restaurants:jobChanged", source)
    return true
end

-- The one roster that works OFFLINE: the store is ours, so a payroll run or a tip
-- split doesn't quietly skip whoever happens to be logged out.
function GetJobEmployees(jobName, cb)
    local out = {}
    if jobName and jobName ~= "" then
        for _, row in pairs(JobPlayerCache) do
            if row.job == jobName then
                local grade = tonumber(row.grade) or 0
                out[#out + 1] = { identifier = row.identifier, name = row.name or row.identifier,
                                  grade = grade, gradeLabel = gradeLabelOf(jobName, grade) }
            end
        end
    end
    if type(cb) == "function" then cb(out) end
    return out
end

-- The pre-existing framework-shaped helpers, expressed over the above so nothing
-- that reaches for them on a standalone server finds a nil.
function GetPlayerJobName(source)
    local info = GetPlayerJobInfo(source)
    return info and info.name or nil
end

function GetPlayerJob(source)
    local info = GetPlayerJobInfo(source)
    if not info then return { label = _L("job_unknown"), rank_label = _L("job_grade_unknown") } end
    return { label = info.label, rank_label = info.gradeLabel }
end

function SetPlayerJob(source, job, grade) return SetPlayerJobGrade(source, job, grade) end

function IsPlayerJobBoss(source, jobName)
    local info = GetPlayerJobInfo(source)
    return (info ~= nil and info.name == jobName and info.isBoss) or false
end

function GetJobGrades(jobName)
    local out = {}
    for _, g in ipairs(GetJobGradeList(jobName)) do
        out[#out + 1] = { level = g.grade, label = g.label }
    end
    return out
end

function GetEmployees(jobName, cb) return GetJobEmployees(jobName, cb) end

function GetMoney(source, currency)
    local id = GetIdentifier(source); if not id then return 0 end
    local acc = LoadAccount(id)
    return acc[AccountKey(currency)] or 0
end

function AddMoney(source, count, currency)
    local id = GetIdentifier(source); if not id then return end
    local acc = LoadAccount(id)
    local key = AccountKey(currency) -- only ever "cash" or "bank"
    acc[key] = (acc[key] or 0) + RoundMoney(count)
    MySQL.update(("UPDATE pickle_restaurant_accounts SET %s = ? WHERE identifier = ?"):format(key), { acc[key], id })
    TriggerClientEvent("pickle_restaurants:updateMoney", source, acc[key])
end

function RemoveMoney(source, count, currency)
    local id = GetIdentifier(source); if not id then return false end
    local acc = LoadAccount(id)
    local key = AccountKey(currency) -- only ever "cash" or "bank"
    count = RoundMoney(count)
    if (acc[key] or 0) < count then return false end
    acc[key] = acc[key] - count
    MySQL.update(("UPDATE pickle_restaurant_accounts SET %s = ? WHERE identifier = ?"):format(key), { acc[key], id })
    TriggerClientEvent("pickle_restaurants:updateMoney", source, acc[key])
    return true
end

-- No society API here either (bridge/society/server.lua owns it). On a frameworkless
-- server it falls back to one small table of ours — we are the bank only when there is
-- no bank.

-- ─── inventory ───────────────────────────────────────────────────────────────
-- bridge/inventory owns it. On a frameworkless server that means whichever
-- inventory resource is installed (ox, Quasar, …) or, with none at all, the
-- `none` driver — which reports honestly that it holds nothing, so `giveVessel`
-- falls back to the cooked-items tray instead of quietly destroying a meal.
CreateThread(function()
    Wait(100)
    InitializeInventory()
end)

-- No framework needs system on the standalone bridge: eating still consumes the
-- item and plays its animation, there is just nothing built in to top up. Both
-- values are 0-100 percentages of a needs bar. Hook the public event below from
-- your own status resource (or replace this function) to apply them.
function Nourish(source, hunger, thirst)
    TriggerEvent("pickle_restaurants:nourish", source,
        math.floor(tonumber(hunger) or 0), math.floor(tonumber(thirst) or 0))
end

-- Stress RELIEF, the counterpart to Nourish (it drains a bar rather than filling
-- one) — what a DLC toy out of a kid's meal does. Same story as above on the
-- standalone bridge: there is no stress system to drain, so this only announces
-- itself. Handle `pickle_restaurants:relax` from your own status resource.
function Relax(source, stress)
    stress = math.floor(tonumber(stress) or 0)
    if stress <= 0 then return end
    TriggerEvent("pickle_restaurants:relax", source, stress)
end
