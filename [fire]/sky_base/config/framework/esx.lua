if Sky.Config.framework == "esx" then
    Sky.FW = {}
    local function _sky_dbg(name, ...)
        if not Sky.IsDebugActive("debug") then
            return
        end

        local count = select("#", ...)
        local parts = {}
        for i = 1, count do
            parts[i] = tostring(select(i, ...))
        end
        Sky.Debug("debug", "[sky_base][debug] %s(%s)", name, table.concat(parts, ", "))
    end

    local function resolveESX()
        if ESX then
            return ESX
        end

        local ok, sharedObject = pcall(function()
            return exports["es_extended"]:getSharedObject()
        end)
        if ok and sharedObject then
            return sharedObject
        end

        TriggerEvent("esx:getSharedObject", function(obj)
            _sky_dbg("esx:getSharedObject callback", obj)
            ESX = obj
        end)

        return ESX
    end

    local function waitForESX(timeoutMs)
        local waited = 0
        local timeout = timeoutMs or 5000

        while not ESX and waited <= timeout do
            ESX = resolveESX()
            if ESX then
                break
            end

            Wait(100)
            waited = waited + 100
        end

        return ESX
    end

    -- Get ESX for new & old versions without hard-failing on legacy ESX builds
    ESX = waitForESX(10000)
    if not ESX then
        print("^1[sky_base] ESX shared object could not be loaded. Make sure es_extended is started before sky_base.^0")
        return
    end

    -- Some ESX forks print every job grade from ESX.GetJobs() unconditionally.
    -- Keep those diagnostics tied to sky_base's debug setting without hiding
    -- unrelated warnings or errors emitted by the framework.
    local function getESXJobs()
        if Sky.IsDebugActive("debug") then
            return ESX.GetJobs()
        end

        local originalPrint = print
        print = function(...)
            local parts = {}
            for index = 1, select("#", ...) do
                parts[index] = tostring(select(index, ...))
            end

            local message = table.concat(parts, "\t")
            local isJobGradeDebug = message:find("Job:", 1, true)
                and message:find("Grade:", 1, true)
                and message:find("Name:", 1, true)

            if not isJobGradeDebug then
                originalPrint(...)
            end
        end

        local result
        local ok, err = xpcall(function()
            result = ESX.GetJobs()
        end, debug.traceback)
        print = originalPrint

        if not ok then
            error(err, 0)
        end

        return result
    end

    if IsDuplicityVersion() then goto server end
    -- Client Side from here

    Sky.FW.VehicleProperties = {
        get = ESX.Game.GetVehicleProperties,
        set = ESX.Game.SetVehicleProperties,
        codec = "esx"
    }

    --Update Hunger and Thirst
    AddEventHandler("esx_status:onTick", function(data)
        local newHunger, newThirst
        for i, v in pairs(data) do
            if v.name == "hunger" then
                newHunger = v.percent
            elseif v.name == "thirst" then
                newThirst = v.percent
            end
        end
        TriggerEvent("sky_base:updateHungerAndThirst", newHunger, newThirst)
    end)

    -- Is Player Loaded
    RegisterNetEvent('esx:playerLoaded', function()
        _sky_dbg("esx:playerLoaded (client)")
        TriggerEvent("sky_base:playerLoaded")
    end)

    RegisterNetEvent("esx:onPlayerLogout", function()
        _sky_dbg("esx:onPlayerLogout (client)")
        TriggerEvent("sky_base:playerUnloaded")
    end)

    function Sky.FW.GetPlayerState(key, server_id)
        local state_key = key == "isdead" and "isDead" or key
        if server_id then
            return Player(server_id).state[state_key]
        end
        return LocalPlayer.state[state_key]
    end

    --Update Money
    RegisterNetEvent('esx:setAccountMoney', function(account)
        _sky_dbg("esx:setAccountMoney", account)
        TriggerEvent("sky_base:updateAccountMoney", account.name, account.money)
    end)

    --Entered Car
    AddEventHandler('esx:enteredVehicle', function(vehicle, plate, seat, displayName, netId)
        _sky_dbg("esx:enteredVehicle", vehicle, plate, seat, displayName, netId)
        TriggerEvent("sky_base:enteredVehicle", vehicle, plate, seat)
    end)

    --Exited Car
    AddEventHandler('esx:exitedVehicle', function(vehicle, plate, seat, displayName, netId)
        _sky_dbg("esx:exitedVehicle", vehicle, plate, seat, displayName, netId)
        TriggerEvent("sky_base:exitedVehicle", vehicle, plate, seat)
    end)

    --Added Item
    RegisterNetEvent('esx:addInventoryItem', function(item, count)
        _sky_dbg("esx:addInventoryItem", item, count)
        TriggerEvent("sky_base:inventoryUpdated")
    end)

    --Removed Inventory
    RegisterNetEvent('esx:removeInventoryItem', function(item, count)
        _sky_dbg("esx:removeInventoryItem", item, count)
        TriggerEvent("sky_base:inventoryUpdated")
    end)

    --Update Job
    RegisterNetEvent('esx:setJob', function(job, lastJob)
        _sky_dbg("esx:setJob", job, lastJob)
        TriggerEvent("sky_base:updateJob", job)
        TriggerServerEvent("sky_base:updateJob", job)
    end)

    function Sky.FW.GetOwnedVehicleCount()
        return nil, "server_only"
    end

    ::server::
    if not IsDuplicityVersion() then return end
    -- Server Side from here

    local job_assignment_generation = 0
    for _, event_name in ipairs({ "onResourceStart", "onResourceStop" }) do
        AddEventHandler(event_name, function(resource_name)
            if resource_name == "es_extended" then job_assignment_generation = job_assignment_generation + 1 end
        end)
    end

    local jobUsersCache = {}
    local jobUsersCacheDuration = 60000

    local function invalidateJobUsersCache(oldJobName, newJobName)
        for cached_name in pairs(jobUsersCache) do
            if oldJobName == cached_name or oldJobName == "off" .. cached_name or oldJobName == "off_" .. cached_name
                or newJobName == cached_name or newJobName == "off" .. cached_name or newJobName == "off_" .. cached_name then
                jobUsersCache[cached_name] = nil
            end
        end
    end

    AddEventHandler("sky_base:jobMembers:changed", function(job_names)
        if (type(source) == "number" and source > 0) or GetInvokingResource() ~= "sky_base" then
            Sky.Debug("error", "[sky_base] Rejected unowned ESX member cache invalidation")
            return
        end
        for _, job_name in ipairs(job_names) do invalidateJobUsersCache(job_name, job_name) end
    end)

    -- ESX fires this server-locally from its login flow; AddEventHandler keeps it off the
    -- net surface so clients cannot inject playerLoaded for arbitrary sources
    AddEventHandler("esx:playerLoaded", function(playerId, xPlayer, isNew)
        _sky_dbg("esx:playerLoaded (server)", playerId, xPlayer, isNew)
        TriggerEvent("sky_base:playerLoaded", playerId)
    end)

    AddEventHandler("esx:playerLogout", function(playerId)
        _sky_dbg("esx:playerLogout (server)", playerId)
        TriggerEvent("sky_base:playerUnloaded", playerId)
    end)

    AddEventHandler("esx:setJob", function(player_id, job, previous_job)
        if type(source) == "number" and source > 0 then
            Sky.Debug("error", "[sky_base] Rejected network-origin esx:setJob from source %s", tostring(source))
            return
        end
        invalidateJobUsersCache(previous_job.name, job.name)
        TriggerEvent("sky_base:jobUpdated", player_id, job)
    end)

    local function publishESXJobs()
        if type(source) == "number" and source > 0 then
            Sky.Debug("error", "[sky_base] Rejected network-origin ESX job catalogue completion from source %s", tostring(source))
            return
        end
        -- RefreshJobs emits before setting JobsLoaded; use the framework's readiness contract.
        getESXJobs()
        jobUsersCache = {}
        TriggerEvent("sky_jobs_base:frameworkCatalog:updated")
        TriggerClientEvent("sky_jobs_base:frameworkCatalog:updated", -1)
    end
    AddEventHandler("esx:jobsRefreshed", publishESXJobs)
    AddEventHandler("esx:jobCreated", publishESXJobs)

    local function updateSkyJobsPlayerCache(src)
        if not src then
            return
        end
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            TriggerEvent("sky_base:jobUpdated", src, xPlayer.getJob())
        end
    end

    AddEventHandler("jobs_creator:toggleDuty", function(playerId, jobName, isOnDuty)
        if type(source) == "number" and source > 0 then
            Sky.Debug("error", "[sky_base] Rejected network-origin jobs_creator:toggleDuty from source %s", tostring(source))
            return
        end
        _sky_dbg("jobs_creator:toggleDuty", playerId, jobName, isOnDuty)
        if not playerId then return end
        updateSkyJobsPlayerCache(playerId)
    end)

    AddEventHandler("jobs_creator:boss:playerHired", function(playerId, jobName)
        if type(source) == "number" and source > 0 then
            Sky.Debug("error", "[sky_base] Rejected network-origin jobs_creator:boss:playerHired from source %s", tostring(source))
            return
        end
        _sky_dbg("jobs_creator:boss:playerHired", playerId, jobName)
        if not playerId then return end
        updateSkyJobsPlayerCache(playerId)
    end)

    AddEventHandler("jobs_creator:boss:employeeFired", function(employeeIdentifier, jobName)
        if type(source) == "number" and source > 0 then
            Sky.Debug("error", "[sky_base] Rejected network-origin jobs_creator:boss:employeeFired from source %s", tostring(source))
            return
        end
        _sky_dbg("jobs_creator:boss:employeeFired", employeeIdentifier, jobName)
        if not employeeIdentifier then return end
        local xPlayer = ESX.GetPlayerFromIdentifier(employeeIdentifier)
        if xPlayer then
            updateSkyJobsPlayerCache(xPlayer.source)
        end
    end)

    function Sky.FW.IsPlayerOnline(sourceOrIdentifier)
        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            return xPlayer and xPlayer.source or false
        end

        local identifier = tostring(sourceOrIdentifier)
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        if not xPlayer then
            local baseIdentifier = identifier:match("^char%d+:(.+)$")
            if baseIdentifier then
                xPlayer = ESX.GetPlayerFromIdentifier(baseIdentifier)
            end
        end

        return xPlayer and xPlayer.source or false
    end

    function Sky.FW.GetIdentifier(source)
        _sky_dbg("Sky.FW.GetIdentifier", source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return nil end
        return xPlayer.identifier
    end

    function Sky.FW.GetName(sourceOrIdentifier)
        _sky_dbg("Sky.FW.GetName", sourceOrIdentifier)
        
        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer then
                return xPlayer.getName()
            end
        else
           local user = Sky.DB.GetSingleRow("users", "identifier", sourceOrIdentifier)
            if user ~= nil then
                if user.firstname ~= nil and user.lastname ~= nil then
                    return Sky.String.SanitizeForSQL(user.firstname .. " " .. user.lastname)
                else
                    return "Unknown"
                end
            end
        end

        return nil
    end

    function Sky.FW.GetFirstname(sourceOrIdentifier)
        _sky_dbg("Sky.FW.GetFirstname", sourceOrIdentifier)

        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer then
                return xPlayer.get("firstName")
            end
        else
            local user = Sky.DB.GetSingleRow("users", "identifier", sourceOrIdentifier)
            if user then
                return Sky.String.SanitizeForSQL(user.firstname)
            end
        end

        return nil
    end

    function Sky.FW.GetLastname(sourceOrIdentifier)
        _sky_dbg("Sky.FW.GetLastname", sourceOrIdentifier)
        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer then
                return xPlayer.get("lastName")
            end
        else
            local user = Sky.DB.GetSingleRow("users", "identifier", sourceOrIdentifier)
            if user then
                return Sky.String.SanitizeForSQL(user.lastname)
            end
        end

        return nil
    end

    function Sky.FW.GetGender(sourceOrIdentifier)
        _sky_dbg("Sky.FW.GetGender", sourceOrIdentifier)
        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer then
               return xPlayer.get("sex")
            end
        else
            local user = Sky.DB.GetSingleRow("users", "identifier", sourceOrIdentifier)
            if user then
                return user.sex
            end
        end

        return nil
    end

    function Sky.FW.GetBirthdate(sourceOrIdentifier)
        _sky_dbg("Sky.FW.GetBirthdate", sourceOrIdentifier)
        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer then
               return xPlayer.get("dateofbirth") or xPlayer.get("dob")
            end
        else
            local user = Sky.DB.GetSingleRow("users", "identifier", sourceOrIdentifier)
            if user then
                return user.dateofbirth
            end
        end

        return nil
    end

    function Sky.FW.GetHeight(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return nil end
        return tonumber(xPlayer.get("height"))
    end

    function Sky.FW.GetPlayerDirectoryQueryConfig()
        return {
            from = "users u",
            joins = {
                "LEFT JOIN jobs j ON CAST(j.name AS CHAR) = CAST(u.job AS CHAR)"
            },
            identifier = "u.identifier",
            firstname = "u.firstname",
            lastname = "u.lastname",
            gender = [[CASE
                WHEN u.sex IN ('0', 'm', 'M', 'male', 'Male') THEN 'male'
                WHEN u.sex IN ('1', 'f', 'F', 'female', 'Female') THEN 'female'
                ELSE 'unknown'
            END]],
            dob = "u.dateofbirth",
            jobName = "u.job",
            jobLabel = "COALESCE(NULLIF(j.label, ''), u.job)",
            orderBy = "LOWER(u.firstname), LOWER(u.lastname), u.identifier"
        }
    end

    function Sky.FW.GetAccountMoney(source, account)
        _sky_dbg("Sky.FW.GetAccountMoney", source, account)
        if account == "cash" then
            account = "money"
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getAccount(account).money
    end

    function Sky.FW.AddAccountMoney(source, account, amount)
        _sky_dbg("Sky.FW.AddAccountMoney", source, account, amount)
        if account == "cash" then
            account = "money"
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney(account, amount)
    end

    function Sky.FW.RemoveAccountMoney(source, account, amount, options)
        _sky_dbg("Sky.FW.RemoveAccountMoney", source, account, amount)
        if account == "cash" then
            account = "money"
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        local allow_overdraft = type(options) == "table"
            and options.allowOverdraft == true
            and account == "bank"
        if allow_overdraft or xPlayer.getAccount(account).money >= amount then
            local reason = type(options) == "table" and options.reason or nil
            xPlayer.removeAccountMoney(account, amount, reason)
            return true
        end
        return false
    end

    -- Native membership counts; off-duty aliases follow GetJobUsers' inclusion rules.
    function Sky.FW.GetGroupMemberCounts()
        local counts = { job = {}, gang = {} }
        local stored = {}
        for _, row in ipairs(Sky.Query("SELECT job, COUNT(*) AS total FROM users WHERE job IS NOT NULL GROUP BY job", {})) do
            stored[row.job] = tonumber(row.total)
        end
        for key, definition in pairs(Sky.FW.GetJobs()) do
            local name = definition.name or key
            local aliases = { [name] = true, ["off" .. name] = true, ["off_" .. name] = true }
            local total = 0
            for alias in pairs(aliases) do total = total + (stored[alias] or 0) end
            counts.job[name] = total
        end
        return counts
    end

    ---@return {{identifier = string, job_grade = number, name = string|nil }, {...}}
    function Sky.FW.GetJobUsers(jobName)
        _sky_dbg("Sky.FW.GetJobUsers", jobName)
        local now = GetGameTimer()
        local cached = jobUsersCache[jobName]
        if cached and now - cached.createdAt < jobUsersCacheDuration then
            return cached.users
        end

        local users = {}
        local offset = 0
        local pageSize = 500

        while true do
            local page = MySQL.query.await([[
                SELECT identifier, job, job_grade, firstname, lastname
                FROM users
                WHERE job IN (@job, @offJob, @offUnderscoreJob)
                ORDER BY identifier
                LIMIT @limit OFFSET @offset
            ]], {
                ["@job"] = jobName,
                ["@offJob"] = "off" .. jobName,
                ["@offUnderscoreJob"] = "off_" .. jobName,
                ["@limit"] = pageSize,
                ["@offset"] = offset
            }) or {}

            for i = 1, #page do
                local row = page[i]
                if row.firstname or row.lastname then
                    -- Provide the display name here so consumers don't fall back to a per-user
                    -- Sky.FW.GetName() DB lookup (matches the QB/Qbox GetJobUsers return shape).
                    row.name = Sky.String.SanitizeForSQL((row.firstname or "") .. " " .. (row.lastname or ""))
                end
                users[#users + 1] = row
            end

            if #page < pageSize then
                break
            end
            offset = offset + pageSize
        end

        jobUsersCache[jobName] = {
            users = users,
            createdAt = now
        }
        return users
    end

    ---Get Job from online or offline Player
    ---@param source string|number Can be identifier or player id
    ---@return string
    function Sky.FW.GetGang()
        return nil
    end

    function Sky.FW.GetGangData()
        return nil
    end

    function Sky.FW.GetGangUsers()
        return {}
    end

    function Sky.FW.SetGang()
        return false
    end

    function Sky.FW.DoesGangExist()
        return false
    end

    function Sky.FW.GetGangs()
        return {}
    end

    function Sky.FW.GetJob(sourceOrIdentifier)
        _sky_dbg("Sky.FW.GetJob", sourceOrIdentifier)

        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer ~= nil then
                return xPlayer.job.name
            else
                return ""
            end
        else
            return Sky.DB.GetValue("users", "identifier", sourceOrIdentifier, "job") or ""
        end
    end

    ---Set Job for online or offline Player
    ---@param source string|number Can be identifier or player id
    ---@param jobName string
    ---@param jobGrade number
    function Sky.FW.SetJob(sourceOrIdentifier, jobName, jobGrade, expected_identifier, expected_member)
        if expected_member then return Sky.FW._SetMemberProfile(sourceOrIdentifier, "job", jobName, jobGrade, expected_identifier, expected_member) end
        _sky_dbg("Sky.FW.SetJob", sourceOrIdentifier, jobName, jobGrade)
        local grade = tonumber(jobGrade)
        if type(jobName) ~= "string" or jobName == "" or not grade or grade < 0 or grade % 1 ~= 0
            or expected_identifier ~= nil and (type(expected_identifier) ~= "string" or expected_identifier == ""
                or type(sourceOrIdentifier) ~= "number") then
            Sky.Debug("error", "[Sky.FW.SetJob] Invalid assignment: %s/%s to %s", tostring(jobName), tostring(jobGrade), tostring(sourceOrIdentifier))
            return false, "invalid_member"
        end
        grade = math.floor(grade)
        local facade, core, generation = Sky.FW, ESX, job_assignment_generation
        if Sky.Config.framework ~= "esx" or GetResourceState("es_extended") ~= "started" then return false, "framework_not_ready" end
        if not core.DoesJobExist(jobName, grade) then
            Sky.Debug("error", "[Sky.FW.SetJob] Unknown ESX job/grade: %s/%s", jobName, grade)
            return false, "member_profile_unsupported"
        end

        if type(sourceOrIdentifier) == "number" then
            if sourceOrIdentifier <= 0 or sourceOrIdentifier % 1 ~= 0 then return false, "invalid_member" end
            local player = core.GetPlayerFromId(sourceOrIdentifier)
            if not player then return false, "session_changed" end
            local identifier = player.identifier
            if expected_identifier ~= nil and identifier ~= expected_identifier then return false, "session_changed" end
            local previous_job = player.getJob()
            if type(previous_job) ~= "table" then return false, "member_profile_unsupported" end
            previous_job = Sky.Table.Clone(previous_job)
            if Sky.Config.framework ~= "esx" or Sky.FW ~= facade or ESX ~= core
                or job_assignment_generation ~= generation or GetResourceState("es_extended") ~= "started" then
                return false, "framework_changed"
            end
            player.setJob(jobName, grade)
            if Sky.Config.framework ~= "esx" or Sky.FW ~= facade or ESX ~= core
                or job_assignment_generation ~= generation or GetResourceState("es_extended") ~= "started" then
                return false, "member_persistence_pending"
            end
            player = core.GetPlayerFromId(sourceOrIdentifier)
            if not player or player.identifier ~= identifier then return false, "session_changed" end
            local current_job = player.getJob()
            if Sky.Config.framework ~= "esx" or Sky.FW ~= facade or ESX ~= core
                or job_assignment_generation ~= generation or GetResourceState("es_extended") ~= "started" then
                return false, "member_persistence_pending"
            end
            if current_job.name ~= jobName or tonumber(current_job.grade) ~= grade then
                Sky.Debug("error", "[Sky.FW.SetJob] ESX assignment was not confirmed for source %s", sourceOrIdentifier)
                return false, "member_update_failed"
            end
            invalidateJobUsersCache(previous_job.name, jobName)
            TriggerEvent("sky_base:jobMembers:changed", { previous_job.name, jobName })
            return true, false, previous_job
        end

        return Sky.FW._SetOfflineJob(sourceOrIdentifier, jobName, grade)
    end

    function Sky.FW.RefreshJobs()
        _sky_dbg("Sky.FW.RefreshJobs")
        if ESX.RefreshJobs then
            ESX.RefreshJobs()
        end
    end

    -- Read the actual persisted adoption scope; ESX's job catalogue is only a runtime snapshot.
    function Sky.FW.ReadGangMemberSnapshot(gang_name, authorize)
        Sky.Debug("error", "[Sky.FW.ReadGangMemberSnapshot] Raw gang membership snapshots are unsupported on ESX: %s", tostring(gang_name))
        return nil, "unsupported_framework"
    end

    function Sky.FW.DoesJobExist(jobName, grade)
        _sky_dbg("Sky.FW.DoesJobExist", jobName, grade)
        return ESX.DoesJobExist(jobName, tonumber(grade))
    end

    ---Get Jobs
    ---@return {name: string, label: string, grades: {[string]: {grade: number, name: string, label: string, payment: string}}}
    function Sky.FW.GetJobs()
        _sky_dbg("Sky.FW.GetJobs")
        local jobs = getESXJobs()
        for _, job in ipairs(jobs) do
            for _, grade in ipairs(job.grades) do
                grade.payment = grade.salary
            end
        end

        return jobs
    end

    function Sky.FW.GetPlayers()
        _sky_dbg("Sky.FW.GetPlayers")
        return ESX.GetPlayers()
    end

    function Sky.FW.IsVehicleOwnedByPlayer(source, plate)
        _sky_dbg("Sky.FW.IsVehicleOwnedByPlayer", source, plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        local isVehicleOwned = Sky.Query("SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner", {
            ["@plate"] = plate,
            ["@owner"] = xPlayer.identifier,
        })
        if not isVehicleOwned[1] or isVehicleOwned[1].owner ~= xPlayer.identifier then
            return false
        else
            return true
        end
    end

    ---Get the number of persistent vehicles owned by an online character.
    ---@param source number
    ---@return integer? count
    ---@return string? error_code
    function Sky.FW.GetOwnedVehicleCount(source)
        if not IsDuplicityVersion() then
            return nil, "server_only"
        end

        source = tonumber(source)
        if not source or source <= 0 or source ~= math.floor(source) then
            return nil, "invalid_source"
        end

        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetOwnedVehicleCount] Player not found for source: %s", tostring(source))
            return nil, "player_not_found"
        end

        local identifier = xPlayer.identifier
        if identifier == nil or tostring(identifier) == "" then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] ESX player has no persistent identifier for source: %s", tostring(source))
            return nil, "identifier_not_found"
        end
        if not Sky.DB or type(Sky.DB.Select) ~= "function" then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] Sky.DB.Select is unavailable.")
            return nil, "database_unavailable"
        end

        local rows = Sky.DB.Select(
            "SELECT COUNT(*) AS `vehicle_count` FROM `owned_vehicles` WHERE `owner` = ?",
            { identifier }
        )
        if type(rows) ~= "table" then
            return nil, "query_failed"
        end

        local count = tonumber(rows[1] and rows[1].vehicle_count)
        if not count or count < 0 or count ~= math.floor(count) then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] ESX vehicle count query returned an invalid result for source: %s", tostring(source))
            return nil, "invalid_result"
        end

        return math.floor(count)
    end

    ---Get Job Data from online or offline Player (offline only: "name"|"grade")
    ---@param source string|number Can be identifier or player id
    ---@param action "name"|"label"|"grade"|"grade_name"|"grade_label"|"duty"|string[]
    ---@return string|boolean|table
    function Sky.FW.GetJobData(sourceOrIdentifier, action)
        _sky_dbg("Sky.FW.GetJobData", sourceOrIdentifier, action)

        local requested = type(action) == "table" and action or nil

        if type(sourceOrIdentifier) == "number" then
            local xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            if xPlayer == nil then
                return requested and {} or ""
            end

            local job = xPlayer.getJob()
            local onDuty = job.onDuty
            local values = {
                name = job.name,
                label = job.label,
                grade = job.grade,
                grade_name = job.grade_name,
                grade_label = job.grade_label
            }
            if onDuty ~= nil then
                values.duty = onDuty == true
            end

            if requested then
                local result = {}
                for _, key in ipairs(requested) do
                    result[key] = values[key]
                end
                return result
            end

            return values[action]
        end

        local jobName = Sky.DB.GetValue("users", "identifier", sourceOrIdentifier, "job")
        local jobGrade = Sky.DB.GetValue("users", "identifier", sourceOrIdentifier, "job_grade")
        local values = {
            name = jobName,
            label = "N/A",
            grade = jobGrade,
            grade_name = "N/A",
            grade_label = "N/A",
            duty = nil
        }

        if requested then
            local result = {}
            for _, key in ipairs(requested) do
                result[key] = values[key]
            end
            return result
        end

        return values[action]
    end

    function Sky.FW.GetStatus(source, name)
        _sky_dbg("Sky.FW.GetStatus", source, name)
        local status = 0

        TriggerEvent('esx_status:getStatus', source, name, function(pStatus)
            _sky_dbg("esx_status:getStatus callback", pStatus)
            if pStatus then
                status = (pStatus.val / 10000)
            end
        end)

        return status
    end

    function Sky.FW.ChangePlayerName(sourceOrIdentifier, firstname, lastname)
        if not IsDuplicityVersion()
            or (type(sourceOrIdentifier) ~= 'number' and type(sourceOrIdentifier) ~= 'string')
            or type(firstname) ~= 'string' or firstname == ''
            or type(lastname) ~= 'string' or lastname == '' then
            return false
        end

        _sky_dbg('Sky.FW.ChangePlayerName', sourceOrIdentifier, firstname, lastname)

        local xPlayer
        local identifier = sourceOrIdentifier
        if type(sourceOrIdentifier) == "number" then
            xPlayer = ESX.GetPlayerFromId(sourceOrIdentifier)
            identifier = xPlayer and xPlayer.identifier or nil
        else
            xPlayer = ESX.GetPlayerFromIdentifier(sourceOrIdentifier)
        end
        if type(identifier) ~= "string" or identifier == ""
            or not Sky.DB.GetSingleRow("users", "identifier", identifier) then
            return false
        end

        if not Sky.DB.SetValues("users", {
            firstname = firstname,
            lastname = lastname,
        }, "identifier", identifier) then
            return false
        end

        if xPlayer then
            xPlayer.setName(firstname .. " " .. lastname)
            xPlayer.set("firstName", firstname)
            xPlayer.set("lastName", lastname)
        end
        return true
    end

    RegisterServerEvent('esx:onPlayerDeath')
    AddEventHandler('esx:onPlayerDeath', function(data)
        _sky_dbg("esx:onPlayerDeath", data)
        TriggerClientEvent("sky_base:onPlayerDeath", source)
    end)

    -- ESX Legacy Addons 1.16.0 introduced server-owned needs; resource version stays 1.1.
    local status_release = GetResourceMetadata("esx_status", "legacyversion", 0)
    local server_owned_status = false
    if status_release then
        local major, minor = status_release:match("^v?(%d+)%.(%d+)%.%d+$")
        assert(major, "[sky_base] Cannot select ESX status update path: invalid esx_status legacyversion " .. status_release)
        server_owned_status = tonumber(major) > 1 or (tonumber(major) == 1 and tonumber(minor) >= 16)
    end

    function Sky.FW.SetStatus(source, name, val)
        _sky_dbg("Sky.FW.SetStatus", source, name, val)
        local statusValue = tonumber(val) or 0
        if math.abs(statusValue) > 100 then
            statusValue = statusValue / 10000
        end

        if server_owned_status then
            TriggerEvent("esx_status:set", source, name, statusValue * 10000)
        else
            TriggerClientEvent("esx_status:set", source, name, statusValue * 10000)
        end
    end

    function Sky.FW.RemoveStatus(source, name, amount)
        _sky_dbg("Sky.FW.RemoveStatus", source, name, amount)
        local delta = math.max(0.0, tonumber(amount) or 0) * 10000
        if server_owned_status then
            TriggerEvent("esx_status:add", source, name, -delta)
        else
            TriggerClientEvent("esx_status:remove", source, name, delta)
        end
    end

    function Sky.FW.IsDead(source)
        _sky_dbg("Sky.FW.IsDead", source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.dead
    end

    function Sky.FW.SetPlayerState(source, key, value)
        _sky_dbg("Sky.FW.SetPlayerState", source, key, value)
        local state_key = key == "isdead" and "isDead" or key
        Player(source).state:set(state_key, value, true)
    end

    function Sky.FW.GetPlayerState(source, key)
        _sky_dbg("Sky.FW.GetPlayerState", source, key)
        local state_key = key == "isdead" and "isDead" or key
        return Player(source).state[state_key]
    end

    function Sky.FW.GetPlaytime(source)
        _sky_dbg("Sky.FW.GetPlaytime", source)
        local src = tonumber(source)
        if not src then
            Sky.Debug("warn", "GetPlaytime: Invalid 'source' provided. Must be a number.")
            return 0
        end

        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then
            return 0
        end

        local playtimeMinutes
        if xPlayer.getMetaData then
            playtimeMinutes = xPlayer.getMetaData('totalplaytime')
        elseif xPlayer.getMeta then
            playtimeMinutes = xPlayer.getMeta('totalplaytime')
        else
            local metadata = xPlayer.get and xPlayer.get('metadata')
            if metadata then
                playtimeMinutes = metadata.totalplaytime
            end
        end
        playtimeMinutes = playtimeMinutes or 0

        if playtimeMinutes == 0 and xPlayer.get('time') then
            playtimeMinutes = xPlayer.get('time') / 60000
        end

        return playtimeMinutes
    end

    function Sky.FW.HasCommandPermission(source, acePerm)
        if source == 0 then return true end
        return IsPlayerAceAllowed(source, acePerm)
    end

    ---Check if a player should be visible on CCTV/Bodycam/Dashcam
    ---@param source string|number
    ---@return boolean
    function Sky.FW.IsPlayerVisibleOnCamera(source)
        local ped = GetPlayerPed(source)
        if not ped or ped == 0 or not DoesEntityExist(ped) then
            return false
        end
        return IsEntityVisible(ped)
    end

    ---Set Duty status for a player
    ---@param source string|number
    ---@param onDuty boolean
    ---@return boolean success
    function Sky.FW.SetDuty(source, onDuty)
        _sky_dbg("Sky.FW.SetDuty", source, onDuty)

        local xPlayer = type(source) == "number" and ESX.GetPlayerFromId(source) or ESX.GetPlayerFromIdentifier(source)
        if not xPlayer then return false end

        local job = xPlayer.getJob()
        -- Legacy ESX has no native duty state; the caller owns it and needs no framework write.
        if job.onDuty == nil then return true end

        local requested_duty = onDuty == true
        -- ESX forces unemployed off duty; repeating an on-duty write would echo esx:setJob indefinitely.
        local desired_duty = requested_duty and job.name ~= "unemployed"
        if job.onDuty == desired_duty then return desired_duty == requested_duty end

        xPlayer.setJob(job.name, job.grade, desired_duty)
        return xPlayer.getJob().onDuty == requested_duty
    end

    ---Toggle Duty status for a player
    ---@param source string|number
    ---@return boolean success
    function Sky.FW.ToggleDuty(source)
        _sky_dbg("Sky.FW.ToggleDuty", source)

        local xPlayer = type(source) == "number" and ESX.GetPlayerFromId(source) or ESX.GetPlayerFromIdentifier(source)
        if not xPlayer then return false end

        local job = xPlayer.getJob()
        if job.onDuty == nil then
            Sky.Debug("warn", "Cannot toggle native duty for source %s: this ESX job has no onDuty field. Use the owning resource's duty state.", tostring(xPlayer.source))
            return false
        end

        return Sky.FW.SetDuty(xPlayer.source, not job.onDuty)
    end

    ---Get count of on-duty players for a specific job
    ---@param jobName string
    ---@return number count
    ---@return table sources
    function Sky.FW.GetOnDutyCount(jobName)
        local sources = {}
        for _, player_id in ipairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(player_id)
            if xPlayer then
                local job = xPlayer.getJob()
                if job.name == jobName and job.onDuty then
                    sources[#sources + 1] = player_id
                end
            end
        end

        return #sources, sources
    end
end
