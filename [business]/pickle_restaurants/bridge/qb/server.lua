-- QB **and QBox**. QBox ships as `qbx_core` and no `qb-core`, so guarding on
-- GetResourceState('qb-core') alone sent every QBox server down the standalone
-- bridge — which is why RegisterUsableItem there has a qbx_core special case. What
-- makes one bridge serve both is that qbx_core's compatibility layer REGISTERS THE
-- `qb-core` EXPORTS (`__cfx_export_qb-core_GetCoreObject`), so the core object below
-- is reachable under that name on either framework. `provide 'qb-core'` does not
-- reliably show up as a started resource, so we test for qbx_core by its own name.
--
-- bridge/custom's negative guard MUST stay the mirror image of this one (it checks
-- qbx_core too) — the two files decide independently, and only one may take over.
local QBOX = GetResourceState('qbx_core') == 'started'
if GetResourceState('qb-core') ~= 'started' and not QBOX then return end

-- A QBox server that has turned its qb compatibility bridge off (convar
-- `qbx:enablebridge false`) exposes no core object at all. Say so plainly and stand
-- down rather than erroring on every call: a silent nil QBCore would break the
-- resource in a hundred confusing places instead of one clear line.
local okCore, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
if not okCore or type(core) ~= "table" then
    print("[pickle_restaurants] qbx_core is running but its qb-core compatibility bridge is disabled (convar `qbx:enablebridge`). Enable it so this resource can talk to the framework.")
    return
end
QBCore = core

function RegisterCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function RegisterUsableItem(...)
    QBCore.Functions.CreateUseableItem(...)
end

function ShowNotification(target, text)
	TriggerClientEvent(GetCurrentResourceName()..":showNotification", target, text)
end

function GetIdentifier(source)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))?.PlayerData
    if not xPlayer or not xPlayer.citizenid then return end
    return xPlayer.citizenid 
end

function GetSourceFromIdentifier(identifier)
    local xPlayer = QBCore.Functions.GetPlayerByCitizenId(identifier)
    return xPlayer and xPlayer?.PlayerData.source or nil
end

function GetPlayerCharacterName(source)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    if not xPlayer or not xPlayer.PlayerData then return _L("name_unknown") end
    return xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
end

function CanAccessGroup(source, data)
    if not data then return true end
    local pdata = QBCore.Functions.GetPlayer(tonumber(source)).PlayerData
    for k,v in pairs(data) do 
        if (pdata.job.name == k and pdata.job.grade.level >= v) then return true end
    end
    return false
end

function CheckPermission(source, permission)
    if permission.ignorePermissions then return true end
    local source = tonumber(source)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))?.PlayerData
    if not xPlayer then return end
    local name = xPlayer.job.name
    local rank = xPlayer.job.grade.level
    if permission.jobs[name] and permission.jobs[name] <= rank then 
        return true
    end
    for i=1, #(permission.groups or {}) do 
        if QBCore.Functions.HasPermission(source, permission.groups[i]) then 
            return true 
        end
    end
end

function AddMoney(source, count, currency)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    local currency = currency or "money"
    if (currency == "money") then
        xPlayer.Functions.AddMoney('cash', count)
    elseif (currency == "bank") then
        xPlayer.Functions.AddMoney('bank', count)
    elseif (currency == "dirty") then
        local setting = Config.FrameworkSettings.dirtyMoney
        Inventory.AddItem(source, setting == "DEFAULT" and 'dirty_money' or setting, count)
    end
    TriggerClientEvent("pickle_restaurants:updateMoney", source, money)
end

function RemoveMoney(source, count, currency)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    local currency = currency or "money"
    if (currency == "money") then
        xPlayer.Functions.RemoveMoney('cash', count)
    elseif (currency == "bank") then
        xPlayer.Functions.RemoveMoney('bank', count)
    elseif (currency == "dirty") then
        local setting = Config.FrameworkSettings.dirtyMoney
        Inventory.RemoveItem(source, setting == "DEFAULT" and 'dirty_money' or setting, count)
    end
    TriggerClientEvent("pickle_restaurants:updateMoney", source, money)
end

function GetMoney(source, currency)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    local currency = currency or "money"
    local money = 0
    if (currency == "money") then
        money = xPlayer.PlayerData.money.cash
    elseif (currency == "bank") then
        money = xPlayer.PlayerData.money.bank or 0
    elseif (currency == "dirty") then
        local setting = Config.FrameworkSettings.dirtyMoney
        money = Inventory.GetItemCount(source, setting == "DEFAULT" and 'dirty_money' or setting)
    end
    TriggerClientEvent("pickle_restaurants:updateMoney", source, money)
    return money
end

function GetOwnedVehicleFromPlate(plate)
    local data = MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE plate=@plate;", {
        ['@plate'] = plate,
    })[1]
    return data and {owner = data.citizenid} or nil
end

function AddOwnedVehicle(source, model)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    local plate = ""
    local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
    local numbers = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
    for i = 1, 3 do
        plate = plate .. letters[math.random(1, #letters)]
    end
    plate = plate .. " "
    for i = 1, 3 do
        plate = plate .. numbers[math.random(1, #numbers)]
    end
    MySQL.Async.fetchAll('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, plate, garage, state) VALUES (@license, @citizenid, @vehicle, @hash, @plate, @garage, @state)',
    {
        ['@license'] = xPlayer.PlayerData.license,
        ['@citizenid'] = xPlayer.PlayerData.citizenid,
        ['@vehicle'] = model,
        ['@hash'] = joaat(model),
        ['@plate'] = toupper(plate),
        ['@garage'] = "pillboxgarage",
        ['@state'] = 0
    })
end

function UpdateVehiclePlate(source, plate, newPlate)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    MySQL.Async.execute('UPDATE player_vehicles SET plate = @newPlate WHERE plate = @plate AND citizenid = @citizenid',
    {
        ['@newPlate'] = newPlate,
        ['@plate'] = plate,
        ['@citizenid'] = xPlayer.PlayerData.citizenid
    })
end

function GetPlayerJob(source)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    if not xPlayer then return end
    return {label = xPlayer.PlayerData.job.label, rank_label = xPlayer.PlayerData.job.grade.name}
end

function GetPlayerJobName(source)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    if not xPlayer or not xPlayer.PlayerData or not xPlayer.PlayerData.job then return nil end
    return xPlayer.PlayerData.job.name
end

function SetPlayerJob(source, job, grade)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    xPlayer.Functions.SetJob(job, grade)
end

function IsPlayerJobBoss(source, jobName)
    if not jobName then return false end
    local player = QBCore.Functions.GetPlayer(tonumber(source))
    if not player or not player.PlayerData or not player.PlayerData.job then return false end
    if player.PlayerData.job.name ~= jobName then return false end
    if player.PlayerData.job.isboss == true then return true end
    if player.PlayerData.job.grade and player.PlayerData.job.grade.isboss == true then return true end
    return false
end

function GetEmployees(jobName, cb)
    local employees = {}
    local players = QBCore.Functions.GetQBPlayers()
    for _, player in pairs(players) do
        if player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.name == jobName then
            employees[#employees + 1] = {
                source = player.PlayerData.source,
                name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
                grade = player.PlayerData.job.grade.level,
                gradeLabel = player.PlayerData.job.grade.name,
                online = true,
            }
        end
    end
    if type(cb) == "function" then cb(employees) end
    return employees
end

function GetJobGrades(jobName)
    local job = QBCore.Shared.Jobs[jobName]
    if not job or not job.grades then return {} end
    local grades = {}
    for level, grade in pairs(job.grades) do
        grades[#grades + 1] = {
            level = tonumber(level),
            label = grade.name or ("Grade " .. level),
        }
    end
    table.sort(grades, function(a, b) return a.level < b.level end)
    return grades
end

-- ─── the normalized JOB API ───────────────────────────────────────────────────
-- A restaurant is STAFFED BY A FRAMEWORK JOB (its `metadata.job`) rather than by a
-- private employee table, so every bridge variant answers the same questions about
-- jobs in the same shape. Core's ResolvePerms and the admin/management panels only
-- ever speak this API — they never touch QB(ox) directly.
--
-- QBox is preferred through its OWN export (`exports.qbx_core:GetJobs()`): the
-- compat object's `Shared.Jobs` is a snapshot kept in step by an event, while the
-- export is the live table. Both frameworks agree on the shape a grade has —
-- numeric level as the KEY, display name in `name`, boss flag per grade in `isboss`.

function JobsAvailable() return true end

local function jobDefs()
    if QBOX then
        local ok, jobs = pcall(function() return exports.qbx_core:GetJobs() end)
        if ok and type(jobs) == "table" then return jobs end
    end
    return (QBCore.Shared and QBCore.Shared.Jobs) or {}
end

local function qbGradeList(job)
    local grades = {}
    for level, g in pairs((job and job.grades) or {}) do
        local lvl = tonumber(level) or tonumber(g.grade) or 0
        grades[#grades + 1] = {
            grade  = lvl,
            label  = g.name or g.label or _L("job_grade_n", lvl),
            isboss = g.isboss == true,
        }
    end
    table.sort(grades, function(a, b) return a.grade < b.grade end)
    return grades
end

function GetJobList()
    local out = {}
    for name, job in pairs(jobDefs()) do
        out[#out + 1] = { name = name, label = job.label or name, grades = qbGradeList(job) }
    end
    table.sort(out, function(a, b) return (a.label or a.name):lower() < (b.label or b.name):lower() end)
    return out
end

function GetJobGradeList(jobName)
    local job = jobName and jobDefs()[jobName]
    return job and qbGradeList(job) or {}
end

function GetJobLabel(jobName)
    if not jobName or jobName == "" then return nil end
    local job = jobDefs()[jobName]
    return (job and job.label) or jobName
end

function GetPlayerJobInfo(source)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    local job = xPlayer and xPlayer.PlayerData and xPlayer.PlayerData.job
    if not job or not job.name then return nil end
    -- `grade` is a TABLE on both frameworks ({ name, level }); tolerate a flat
    -- number too, since a fork that stores it that way is not worth crashing on.
    local grade = (type(job.grade) == "table" and tonumber(job.grade.level)) or tonumber(job.grade) or 0
    local gradeLabel = (type(job.grade) == "table" and job.grade.name) or _L("job_grade_n", grade)
    local isBoss = job.isboss == true
        or (type(job.grade) == "table" and job.grade.isboss == true)
        or IsJobBossGrade(job.name, grade)
    return {
        name = job.name, label = job.label or GetJobLabel(job.name),
        grade = grade, gradeLabel = gradeLabel, isBoss = isBoss,
        -- QB tracks duty; treat an absent flag as ON so a server that never toggles
        -- it doesn't have a restaurant nobody can work.
        onDuty = job.onduty ~= false,
    }
end

-- jobName nil/"" = FIRE: 'unemployed' is the fallback job both frameworks ship.
function SetPlayerJobGrade(source, jobName, grade)
    source = tonumber(source)
    jobName = (jobName and jobName ~= "") and jobName or "unemployed"
    grade = tonumber(grade) or 0
    if QBOX then
        local ok, res = pcall(function() return exports.qbx_core:SetJob(source, jobName, grade) end)
        if ok then return res ~= false end
    end
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if not xPlayer then return false end
    xPlayer.Functions.SetJob(jobName, grade)
    return true
end

function IsJobBossGrade(jobName, grade)
    grade = tonumber(grade) or 0
    for _, g in ipairs(GetJobGradeList(jobName)) do
        if g.grade == grade then return g.isboss == true end
    end
    return false
end

-- ONLINE players only. QB keeps offline job data in the `players` JSON blob, which
-- would mean a raw query against one framework's schema from the bridge; a roster of
-- who is actually on shift is also the more useful answer for tips + payroll.
function GetJobEmployees(jobName, cb)
    local out = {}
    if jobName and jobName ~= "" then
        for _, player in pairs(QBCore.Functions.GetQBPlayers() or {}) do
            local pd = player and player.PlayerData
            if pd and pd.job and pd.job.name == jobName then
                local grade = (type(pd.job.grade) == "table" and tonumber(pd.job.grade.level)) or tonumber(pd.job.grade) or 0
                out[#out + 1] = {
                    identifier = pd.citizenid,
                    name       = pd.charinfo and (pd.charinfo.firstname .. " " .. pd.charinfo.lastname) or pd.citizenid,
                    grade      = grade,
                    gradeLabel = (type(pd.job.grade) == "table" and pd.job.grade.name) or _L("job_grade_n", grade),
                }
            end
        end
    end
    if type(cb) == "function" then cb(out) end
    return out
end

-- ONE resource event for "this player's job may have changed", whatever the
-- framework calls it. Core listens and invalidates what it derived from the old job.
-- QBox fires the same player-level event through its compat layer; its
-- `qbx_core:server:onJobUpdate` is a JOB DEFINITION edit (grades renamed, boss flag
-- moved), which changes what every holder of that job may do — so it counts too, and
-- is announced with no source (every player re-resolves).
AddEventHandler("QBCore:Server:OnJobUpdate", function(src, _job)
    TriggerEvent("pickle_restaurants:jobChanged", tonumber(src))
end)
AddEventHandler("qbx_core:server:onJobUpdate", function(_jobName, _job)
    TriggerEvent("pickle_restaurants:jobChanged", nil)
end)

function IsPlayerAdmin(source)
    local source = tonumber(source)
    local permissions = QBCore.Functions.GetPermission(source)
    for i=1, #Config.AdminGroups do 
        if QBCore.Functions.HasPermission(source, Config.AdminGroups[i]) or IsPlayerAceAllowed(source, "command") then 
            return true 
        end
    end
    return false
end

-- The society/business account API lives in bridge/society/server.lua (it probes for the
-- PROVIDER — qb-management, qb-banking, Renewed-Banking — rather than assuming one per
-- framework). `Config.FrameworkSettings.society` is still read, there.

-- ─── inventory ───────────────────────────────────────────────────────────────
-- bridge/inventory owns it now (one layer, one driver per inventory resource).
-- qb-core's own item storage is itself a driver there — see bridge/inventory/qb.
CreateThread(function()
    Wait(100)
    InitializeInventory()
end)

-- Feed the framework's needs system after a customer eats/drinks something out of
-- a restaurant vessel (modules/consume). `hunger`/`thirst` are plain 0-100
-- percentages; QBCore keeps both as 0-100 player metadata and repaints the HUD from
-- one event, so they apply directly. The public event at the end lets ANY other
-- needs system hook in without touching this bridge.
function Nourish(source, hunger, thirst)
    hunger, thirst = math.floor(tonumber(hunger) or 0), math.floor(tonumber(thirst) or 0)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    if xPlayer and (hunger > 0 or thirst > 0) then
        local meta = xPlayer.PlayerData.metadata or {}
        local h = math.min(100, (tonumber(meta.hunger) or 0) + hunger)
        local t = math.min(100, (tonumber(meta.thirst) or 0) + thirst)
        if hunger > 0 then xPlayer.Functions.SetMetaData("hunger", h) end
        if thirst > 0 then xPlayer.Functions.SetMetaData("thirst", t) end
        TriggerClientEvent("hud:client:UpdateNeeds", source, h, t)
    end
    TriggerEvent("pickle_restaurants:nourish", source, hunger, thirst)
end

-- Stress RELIEF (0-100 percentage of the bar), the counterpart to Nourish: it
-- DRAINS a bar rather than filling one, which is why it isn't a fourth argument up
-- there. Used by anything whose effect is calming rather than feeding — a DLC toy
-- out of a kid's meal.
--
-- QBCore and QBox both keep stress as 0-100 player metadata and repaint the HUD
-- from one event, exactly like the needs above (QBox runs through this bridge —
-- qbx_core exposes the qb-core object we bound at the top of this file). We write
-- the metadata AND fire `hud:client:UpdateStress`, which is what qb-smallresources'
-- own relief path does, so a server using either sees the bar move immediately. The
-- public event at the end is the supported hook for any other stress system.
function Relax(source, stress)
    stress = math.floor(tonumber(stress) or 0)
    if stress <= 0 then return end
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
    if xPlayer then
        local meta = xPlayer.PlayerData.metadata or {}
        local s = math.max(0, (tonumber(meta.stress) or 0) - stress)
        xPlayer.Functions.SetMetaData("stress", s)
        TriggerClientEvent("hud:client:UpdateStress", source, s)
    end
    TriggerEvent("pickle_restaurants:relax", source, stress)
end
