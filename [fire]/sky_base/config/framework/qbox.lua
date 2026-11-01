if Sky.Config.framework == "qbox" then
    Sky.FW = {}

    local metadata_player_states = {
        isdead = true,
        inlaststand = true,
        ishandcuffed = true
    }
    local player_metadata

    if IsDuplicityVersion() then goto server end
    -- Client Side from here

    -- Follow Qbox's PlayerData updates instead of exporting the whole character on each state check.
    RegisterNetEvent("QBCore:Player:SetPlayerData", function(player_data)
        local invoking_resource = GetInvokingResource()
        if invoking_resource and invoking_resource ~= "qbx_core" then
            Sky.Debug("debug", "[Qbox PlayerData] Ignored update from resource outside qbx_core: " .. invoking_resource)
            return
        end
        player_metadata = player_data.metadata
    end)
    player_metadata = exports.qbx_core:GetPlayerData().metadata

    Sky.FW.VehicleProperties = {
        get = exports.ox_lib.getVehicleProperties,
        set = exports.ox_lib.setVehicleProperties,
        codec = "ox",
        export = true
    }

    --Update Hunger and Thirst
    RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
        TriggerEvent("sky_base:updateHungerAndThirst", newHunger, newThirst)
    end)

    -- Is Player Loaded
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        player_metadata = exports.qbx_core:GetPlayerData().metadata
        TriggerEvent("sky_base:playerLoaded")
        TriggerEvent("sky_base:inventoryUpdated")
    end)

    RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
        player_metadata = nil
        TriggerEvent("sky_base:playerUnloaded")
    end)

    --Update Money
    RegisterNetEvent('QBCore:Client:OnMoneyChange', function(account)
        local player_data = exports.qbx_core:GetPlayerData()
        if not player_data.money then
            Sky.Debug("debug", "[QBCore:Client:OnMoneyChange] Ignored money update without a loaded character")
            return
        end
        local newMoney = player_data.money[account]
        TriggerEvent("sky_base:updateAccountMoney", account, newMoney)
    end)

    -- The Qbox QB bridge normalizes net IDs before emitting these local events.
    AddEventHandler("QBCore:Client:EnteredVehicle", function(data)
        TriggerEvent("sky_base:enteredVehicle", data.vehicle, data.plate, data.seat)
    end)

    AddEventHandler("QBCore:Client:LeftVehicle", function(data)
        TriggerEvent("sky_base:exitedVehicle", data.vehicle, data.plate, data.seat)
    end)

    -- server-bound sync runs via the server-side QBCore:Server:OnJobUpdate handler
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job_info)
        job_info.grade_label = job_info.grade.name
        TriggerEvent("sky_base:updateJob", job_info)
        TriggerServerEvent("sky_base:updateJob", job_info)
    end)

    -- catch direct duty toggle from QBCore/QBox native system
    RegisterNetEvent('QBCore:Client:SetDuty', function(onDuty)
        TriggerServerEvent("sky_base:syncDuty", onDuty == true)
    end)

    function Sky.FW.GetPlayerState(key, server_id)
        if server_id then
            return Player(server_id).state[key]
        end

        if metadata_player_states[key] then
            return player_metadata and player_metadata[key] or nil
        end
        return LocalPlayer.state[key]
    end

    AddEventHandler("onClientResourceStart", function(resource_name)
        if resource_name ~= GetCurrentResourceName() or not LocalPlayer.state.isLoggedIn then return end
        TriggerEvent("sky_base:playerLoaded")
        TriggerEvent("sky_base:inventoryUpdated")
    end)

    function Sky.FW.GetOwnedVehicleCount()
        return nil, "server_only"
    end

    ::server::
    if not IsDuplicityVersion() then return end
    -- Server Side from here

    local gang_snapshot_generation = 0
    for _, event_name in ipairs({ "onResourceStart", "onResourceStop" }) do
        AddEventHandler(event_name, function(resource_name)
            -- Native start/stop can be nested inside another server script's runtime.
            if resource_name == "qbx_core" then
                gang_snapshot_generation = gang_snapshot_generation + 1
            end
        end)
    end

    -- qbx_core fires this server-locally with the player object on login; AddEventHandler
    -- keeps it off the net surface so clients cannot inject playerLoaded for arbitrary
    -- sources. (QBCore:Server:OnPlayerLoaded is the client-fired variant without payload.)
    AddEventHandler("QBCore:Server:PlayerLoaded", function(player)
        TriggerEvent("sky_base:playerLoaded", player.PlayerData.source)
    end)

    -- qbx_core fires this server-locally on logout/character switch (multichar)
    AddEventHandler("QBCore:Server:OnPlayerUnload", function(src)
        TriggerEvent("sky_base:playerUnloaded", src)
    end)

    AddEventHandler("onResourceStart", function(resource_name)
        if resource_name ~= GetCurrentResourceName() then return end
        for src, player in pairs(exports.qbx_core:GetQBPlayers()) do
            TriggerEvent("sky_base:playerLoaded", player.PlayerData.source or src)
        end
    end)

    -- catch server-side job/duty changes from QBox (e.g. admin, other scripts)
    AddEventHandler("QBCore:Server:OnJobUpdate", function(src, job)
        if src and job and type(job) == "table" then
            TriggerEvent("sky_base:jobUpdated", src, job)
        end
    end)

    AddEventHandler("QBCore:Server:OnGangUpdate", function(src, gang)
        if src and gang and type(gang) == "table" then
            TriggerEvent("sky_base:gangUpdated", src, gang)
        end
    end)

    -- authoritative duty sync: qbx_core fires this server-locally from SetJobDuty;
    -- re-reads PlayerData.job (incl. onduty) instead of trusting any forwarded flag
    AddEventHandler("QBCore:Server:SetDuty", function(src)
        if not src then return end
        local xPlayer = exports.qbx_core:GetPlayer(src)
        if xPlayer then
            TriggerEvent("sky_base:jobUpdated", src, xPlayer.PlayerData.job)
        end
    end)

    function Sky.FW.IsPlayerOnline(sourceOrIdentifier)
        local xPlayer = exports.qbx_core:GetPlayer(sourceOrIdentifier)
        if xPlayer == nil then
            xPlayer = exports.qbx_core:GetPlayerByCitizenId(tostring(sourceOrIdentifier))
            if xPlayer == nil then
                return false
            else
                return xPlayer.PlayerData.source
            end
        else
            return xPlayer.PlayerData.citizenid
        end
    end

    function Sky.FW.GetIdentifier(source)
        local xPlayer = exports.qbx_core:GetPlayer(tonumber(source))
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetIdentifier] Player not found for source: " .. tostring(source))
            return
        end
        return tostring(xPlayer.PlayerData.citizenid)
    end

    local function getOfflinePlayerSafe(sourceOrIdentifier, context)
        local success, xPlayer = pcall(function()
            return exports.qbx_core:GetOfflinePlayer(sourceOrIdentifier)
        end)

        if not success then
            Sky.Debug("warn",
                "[qbox] GetOfflinePlayer failed for %s '%s'. This usually means qbx_core has a stale group/job member or the matching players row is missing. Error: %s",
                context or "identifier",
                tostring(sourceOrIdentifier),
                tostring(xPlayer)
            )
            return nil
        end

        return xPlayer
    end

    function Sky.FW.GetName(sourceOrIdentifier)
        local xPlayer = exports.qbx_core:GetPlayer(sourceOrIdentifier)
        if not xPlayer and tonumber(sourceOrIdentifier) and tonumber(sourceOrIdentifier) <= 0 then
            return "Unknown Player"
        end

        if not xPlayer then
            xPlayer = getOfflinePlayerSafe(sourceOrIdentifier, "name lookup identifier")
        end

        if not xPlayer or not xPlayer.PlayerData or not xPlayer.PlayerData.charinfo then
            return "Unknown Player"
        end

        return Sky.String.SanitizeForSQL(string.format(
            "%s %s",
            xPlayer.PlayerData.charinfo.firstname or "",
            xPlayer.PlayerData.charinfo.lastname or ""
        ))
    end

    function Sky.FW.GetFirstname(sourceOrIdentifier)
        local xPlayer = exports.qbx_core:GetPlayer(sourceOrIdentifier)
        if xPlayer == nil and tonumber(sourceOrIdentifier) and tonumber(sourceOrIdentifier) <= 0 then return end
        if xPlayer == nil then xPlayer = getOfflinePlayerSafe(sourceOrIdentifier, "firstname lookup identifier") end
        if not xPlayer or not xPlayer.PlayerData or not xPlayer.PlayerData.charinfo then return end
        return Sky.String.SanitizeForSQL(xPlayer.PlayerData.charinfo.firstname)
    end

    function Sky.FW.GetLastname(sourceOrIdentifier)
        local xPlayer = exports.qbx_core:GetPlayer(sourceOrIdentifier)
        if xPlayer == nil and tonumber(sourceOrIdentifier) and tonumber(sourceOrIdentifier) <= 0 then return end
        if xPlayer == nil then xPlayer = getOfflinePlayerSafe(sourceOrIdentifier, "lastname lookup identifier") end
        if not xPlayer or not xPlayer.PlayerData or not xPlayer.PlayerData.charinfo then return end
        return Sky.String.SanitizeForSQL(xPlayer.PlayerData.charinfo.lastname)
    end

    function Sky.FW.GetGender(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then return end
        return xPlayer.PlayerData.charinfo.gender
    end

    function Sky.FW.GetBirthdate(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then return end
        local charInfo = xPlayer.PlayerData and xPlayer.PlayerData.charinfo
        if type(charInfo) ~= "table" then return end
        return charInfo.birthdate
    end

    function Sky.FW.GetHeight(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then return nil end
        return tonumber(xPlayer.PlayerData.charinfo.height)
    end

    function Sky.FW.GetPlayerDirectoryQueryConfig()
        return {
            from = "players p",
            joins = {},
            identifier = "p.citizenid",
            firstname = "JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.firstname'))",
            lastname = "JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.lastname'))",
            gender = [[CASE
                WHEN JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.gender')) IN ('0', 'm', 'M', 'male', 'Male') THEN 'male'
                WHEN JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.gender')) IN ('1', 'f', 'F', 'female', 'Female') THEN 'female'
                ELSE 'unknown'
            END]],
            dob = "JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.birthdate'))",
            jobName = "JSON_UNQUOTE(JSON_EXTRACT(p.job, '$.name'))",
            jobLabel = "COALESCE(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p.job, '$.label')), ''), JSON_UNQUOTE(JSON_EXTRACT(p.job, '$.name')))",
            orderBy = "LOWER(JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.firstname'))), LOWER(JSON_UNQUOTE(JSON_EXTRACT(p.charinfo, '$.lastname'))), p.citizenid"
        }
    end

    -- qbx_core only exposes cash, bank, and crypto money types. Black money is item-backed.
    local function get_black_money_item_count(source)
        local item = Sky.FW.GetInventoryItem(source, "black_money")
        if type(item) == "number" then
            return math.max(0, item)
        end
        if type(item) ~= "table" then
            return 0
        end
        return math.max(0, tonumber(item.amount or item.count) or 0)
    end

    function Sky.FW.GetAccountMoney(source, account)
        if account == "black_money" or account == "black" then
            return get_black_money_item_count(source)
        end
        if account == "money" then
            account = "cash"
        end
        return exports.qbx_core:GetMoney(source, account) or 0
    end

    function Sky.FW.AddAccountMoney(source, account, amount)
        if account == "black_money" or account == "black" then
            amount = math.max(0, math.floor(tonumber(amount) or 0))
            return amount <= 0 or Sky.FW.AddItem(source, "black_money", amount)
        end
        if account == "money" then
            account = "cash"
        end
        return exports.qbx_core:AddMoney(source, account, amount)
    end

    function Sky.FW.RemoveAccountMoney(source, account, amount, options)
        if account == "black_money" or account == "black" then
            amount = math.max(0, math.floor(tonumber(amount) or 0))
            if amount <= 0 then return true end
            if get_black_money_item_count(source) < amount then return false end
            return Sky.FW.RemoveItem(source, "black_money", amount) >= amount
        end
        if account == "money" then
            account = "cash"
        end
        local reason = type(options) == "table" and options.reason or nil
        return exports.qbx_core:RemoveMoney(source, account, amount, reason)
    end

    local groupUsersCache = {
        job = {},
        gang = {}
    }
    local groupUsersCacheDuration = 60000

    AddEventHandler("sky_base:jobMembers:changed", function(group_names, kind)
        if (type(source) == "number" and source > 0) or GetInvokingResource() ~= "sky_base" then
            Sky.Debug("error", "[sky_base] Rejected unowned Qbox member cache invalidation")
            return
        end
        local cache = groupUsersCache[kind or "job"]
        for _, group_name in ipairs(group_names) do cache[group_name] = nil end
    end)

    local function getGroupUsers(groupName, groupType)
        local now = GetGameTimer()
        local cache = groupUsersCache[groupType]
        local cached = cache[groupName]
        if cached and now - cached.createdAt < groupUsersCacheDuration then
            return cached.users
        end

        local groupMembers = exports.qbx_core:GetGroupMembers(groupName, groupType)
        local users = {}
        for _, user in ipairs(groupMembers) do
            users[#users + 1] = {
                identifier = user.citizenid,
                job_grade = user.grade
            }
        end

        if #users > 0 then
            local placeholders = {}
            local params = {}
            for index, user in ipairs(users) do
                placeholders[index] = "?"
                params[index] = user.identifier
            end
            local rows = MySQL.query.await(
                ("SELECT citizenid, TRIM(CONCAT(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ''), ' ', COALESCE(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')), ''))) AS name FROM players WHERE citizenid IN (%s)")
                    :format(table.concat(placeholders, ", ")),
                params
            )
            local namesByCitizenId = {}
            for _, row in ipairs(rows or {}) do
                if row.name and row.name ~= "" then
                    namesByCitizenId[row.citizenid] = row.name
                end
            end
            for _, user in ipairs(users) do
                user.name = namesByCitizenId[user.identifier]
            end
        end

        cache[groupName] = {
            users = users,
            createdAt = now
        }
        return users
    end

    function Sky.FW.GetGroupMemberCounts()
        local counts = { job = {}, gang = {} }
        for _, row in ipairs(Sky.Query([[SELECT type AS kind, `group` AS name, COUNT(DISTINCT citizenid) AS total
            FROM player_groups WHERE type IN ('job', 'gang') GROUP BY type, `group`]], {})) do
            counts[row.kind][row.name] = tonumber(row.total)
        end
        return counts
    end

    ---@return {{identifier = string, job_grade = number, name = string|nil }, {...}}
    function Sky.FW.GetJobUsers(jobName)
        return getGroupUsers(jobName, "job")
    end

    ---@return {{identifier = string, job_grade = number, name = string|nil }, {...}}
    function Sky.FW.GetGangUsers(gangName)
        return getGroupUsers(gangName, "gang")
    end

    AddEventHandler("QBCore:Server:OnGangUpdate", function()
        groupUsersCache.gang = {}
    end)

    AddEventHandler("qbx_core:server:onGroupUpdate", function()
        groupUsersCache.job = {}
        groupUsersCache.gang = {}
    end)

    ---Get Job from online or offline Player
    ---@param source string|number Can be license or player id
    ---@return string
    function Sky.FW.GetJob(source)
        if Sky.FW.IsPlayerOnline(source) then
            local xPlayer = exports.qbx_core:GetPlayer(source)
            if xPlayer ~= nil then
                return xPlayer.PlayerData.job.name
            else
                return ""
            end
        else
            local jobData = Sky.DB.GetValue("players", "license", source, "job")
            if not jobData then
                Sky.Debug("warn",
                    "[Sky.FW.GetJob] No job data found for offline player with license: " .. tostring(source))
                return ""
            end
            return jobData.name
        end
    end

    function Sky.FW.GetGang(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if xPlayer and xPlayer.PlayerData.gang then
            return xPlayer.PlayerData.gang.name
        end
        return nil
    end

    function Sky.FW.GetGangData(source, what)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        local gang = xPlayer and xPlayer.PlayerData.gang or nil
        if not gang then
            return nil
        end
        local grade = gang.grade
        local values = {
            name = gang.name,
            label = gang.label,
            grade = type(grade) == "table" and (grade.level or grade.grade) or grade,
            grade_name = type(grade) == "table" and grade.name or nil,
            grade_label = type(grade) == "table" and (grade.label or grade.name) or nil,
        }
        return values[what]
    end

    ---Set Job for online or offline Player
    ---@param source string|number Can be license or player id
    ---@param jobName string
    ---@param jobGrade number
    function Sky.FW.SetJob(source, jobName, jobGrade, expected_identifier, expected_member)
        if expected_member then return Sky.FW._SetMemberProfile(source, "job", jobName, jobGrade, expected_identifier, expected_member) end
        local grade = tonumber(jobGrade)
        if type(jobName) ~= "string" or jobName == "" or not grade or grade < 0 or grade % 1 ~= 0
            or expected_identifier ~= nil and (type(expected_identifier) ~= "string" or expected_identifier == "" or type(source) ~= "number") then
            Sky.Debug("error", "[Sky.FW.SetJob] Invalid assignment: %s/%s to %s", tostring(jobName), tostring(jobGrade), tostring(source))
            return false, "invalid_member"
        end
        jobName, grade = jobName:lower(), math.floor(grade)
        local facade, generation = Sky.FW, gang_snapshot_generation
        if Sky.Config.framework ~= "qbox" or GetResourceState("qbx_core") ~= "started" then return false, "framework_not_ready" end
        local definition = exports.qbx_core:GetJobs()[jobName]
        if not definition or not definition.grades[grade] then
            Sky.Debug("error", "[Sky.FW.SetJob] Unknown Qbox job/grade: %s/%s", jobName, grade)
            return false, "member_profile_unsupported"
        end
        if type(source) ~= "number" then
            local success, error_code = exports.qbx_core:SetJob(source, jobName, grade)
            if success then groupUsersCache.job = {} end
            return success, error_code
        end
        if source <= 0 or source % 1 ~= 0 then return false, "invalid_member" end
        local player = exports.qbx_core:GetPlayer(source)
        if not player then return false, "session_changed" end
        local identifier = player.PlayerData.citizenid
        if expected_identifier ~= nil and identifier ~= expected_identifier then return false, "session_changed" end
        if type(player.PlayerData.job) ~= "table" or type(player.PlayerData.jobs) ~= "table" then return false, "member_profile_unsupported" end
        local previous_job, previous_jobs = Sky.Table.Clone(player.PlayerData.job), Sky.Table.Clone(player.PlayerData.jobs)
        if Sky.Config.framework ~= "qbox" or Sky.FW ~= facade or gang_snapshot_generation ~= generation
            or GetResourceState("qbx_core") ~= "started" then return false, "framework_changed" end
        local result = exports.qbx_core:SetJob(identifier, jobName, grade)
        if result == false then return false, "member_update_failed" end
        if Sky.Config.framework ~= "qbox" or Sky.FW ~= facade or gang_snapshot_generation ~= generation
            or GetResourceState("qbx_core") ~= "started" then return false, "member_persistence_pending" end
        player = exports.qbx_core:GetPlayer(source)
        if not player or player.PlayerData.citizenid ~= identifier then return false, "session_changed" end
        local current_job, current_jobs = player.PlayerData.job, player.PlayerData.jobs
        if Sky.Config.framework ~= "qbox" or Sky.FW ~= facade or gang_snapshot_generation ~= generation
            or GetResourceState("qbx_core") ~= "started" then return false, "member_persistence_pending" end
        if current_job.name ~= jobName or tonumber(current_job.grade.level) ~= grade then
            Sky.Debug("error", "[Sky.FW.SetJob] Qbox assignment was not confirmed for source %s", source)
            return false, "member_update_failed"
        end
        if type(current_jobs) ~= "table" then return false, "member_persistence_pending" end
        for name, previous_grade in pairs(previous_jobs) do
            if name ~= previous_job.name and name ~= jobName and current_jobs[name] ~= previous_grade then
                return false, "member_persistence_pending"
            end
        end
        for name, current_grade in pairs(current_jobs) do
            if name == jobName then
                if jobName == "unemployed" or current_grade ~= grade then return false, "member_persistence_pending" end
            elseif current_grade ~= previous_jobs[name] then
                return false, "member_persistence_pending"
            end
        end
        if jobName ~= "unemployed" and current_jobs[jobName] ~= grade then return false, "member_persistence_pending" end
        TriggerEvent("sky_base:jobMembers:changed", { previous_job.name, jobName })
        return true, false, previous_job, previous_jobs
    end

    ---Set Gang for an online or offline player
    ---@param source string|number Player source or citizenid
    ---@param gangName string
    ---@param gangGrade number
    ---@return boolean success
    function Sky.FW.SetGang(source, gangName, gangGrade, expected_identifier, expected_member)
        if expected_member then return Sky.FW._SetMemberProfile(source, "gang", gangName, gangGrade, expected_identifier, expected_member) end
        groupUsersCache.gang = {}
        return exports.qbx_core:SetGang(source, gangName, gangGrade)
    end

    ---Set Duty status for a player
    ---@param source string|number Can be license or player id
    ---@param onDuty boolean
    ---@return boolean success
    function Sky.FW.SetDuty(source, onDuty)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then return false end

        local desired_duty = onDuty == true
        -- Qbox emits SetDuty even for unchanged duty, which would echo back through Sky.
        if xPlayer.PlayerData.job.onduty == desired_duty then return true end

        exports.qbx_core:SetJobDuty(source, desired_duty)
        xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then return false end

        return xPlayer.PlayerData.job.onduty == desired_duty
    end

    ---Toggle Duty status for a player
    ---@param source string|number Can be license or player id
    ---@return boolean success
    function Sky.FW.ToggleDuty(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then return false end

        return Sky.FW.SetDuty(source, not xPlayer.PlayerData.job.onduty)
    end

    ---Get count of on-duty players for a specific job
    ---@param jobName string
    ---@return number count
    ---@return table sources Array of player sources
    function Sky.FW.GetOnDutyCount(jobName)
        return exports.qbx_core:GetDutyCountJob(jobName)
    end

    function Sky.FW.DoesJobExist(jobName, grade)
        local jobs = exports.qbx_core:GetJobs()
        local job = jobs[jobName]
        return job ~= nil and job.grades[tonumber(grade)] ~= nil
    end

    function Sky.FW.DoesGangExist(gangName, grade)
        local gangs = exports.qbx_core:GetGangs()
        local gang = gangs[gangName]
        return gang ~= nil and gang.grades[tonumber(grade)] ~= nil
    end

    function Sky.FW.ReadJobAdoptionSnapshot(job_name, aliases)
        Sky.Debug("error", "[Sky.FW.ReadJobAdoptionSnapshot] Persisted adoption snapshots are unsupported on Qbox: %s", tostring(job_name))
        return nil, "unsupported_framework"
    end


    ---Get Jobs
    ---@return {name: string, label: string, grades: {[string]: {grade: number, name: string, label?: string, payment: string}}}
    function Sky.FW.GetJobs()
        local jobs = {}
        for name, job in pairs(exports.qbx_core:GetJobs()) do
            local normalized_grades = {}
            for id, grade in pairs(job.grades) do
                normalized_grades[tostring(id)] = Sky.Table.Clone(grade)
                local normalized = normalized_grades[tostring(id)]
                normalized.grade, normalized.name, normalized.label, normalized.payment = tonumber(id), string.lower(grade.name), grade.name, grade.payment or 0
                normalized.isboss, normalized.bankAuth = grade.isboss == true, grade.bankAuth == true
            end
            jobs[name] = {
                name = name,
                label = job.label,
                grades = normalized_grades,
                type = job.type,
                defaultDuty = job.defaultDuty,
                offDutyPay = job.offDutyPay
            }
        end
        return jobs
    end

    ---Get Gangs
    ---@return {name: string, label: string, grades: {[string]: {grade: number, name: string, label?: string, payment: number}}}
    function Sky.FW.GetGangs()
        local gangs = {}
        for name, gang in pairs(exports.qbx_core:GetGangs()) do
            local normalizedGrades = {}
            for id, grade in pairs(gang.grades) do
                normalizedGrades[tostring(id)] = Sky.Table.Clone(grade)
                local normalized = normalizedGrades[tostring(id)]
                normalized.grade, normalized.name, normalized.label, normalized.payment = tonumber(id), string.lower(grade.name), grade.name, 0
                normalized.isboss = grade.isboss == true
            end
            gangs[name] = {
                name = name,
                label = gang.label,
                grades = normalizedGrades
            }
        end
        return gangs
    end

    function Sky.FW.GetPlayers()
        local players = {}
        for source in pairs(exports.qbx_core:GetQBPlayers()) do
            players[#players + 1] = source
        end
        return players
    end

    function Sky.FW.IsVehicleOwnedByPlayer(source, plate)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        local identifier = xPlayer and xPlayer.PlayerData.citizenid
        if type(identifier) ~= "string" or identifier == "" then
            Sky.Debug("debug", "[Sky.FW.IsVehicleOwnedByPlayer] Character not found for source: %s", tostring(source))
            return false
        end
        local rows = Sky.Query("SELECT citizenid FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid LIMIT 1", {
            ["@plate"] = plate,
            ["@citizenid"] = identifier,
        })
        local currentPlayer = exports.qbx_core:GetPlayer(source)
        if not currentPlayer or currentPlayer.PlayerData.citizenid ~= identifier then
            return false
        end
        return type(rows) == "table" and rows[1] ~= nil and rows[1].citizenid == identifier
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

        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetOwnedVehicleCount] Player not found for source: %s", tostring(source))
            return nil, "player_not_found"
        end

        local identifier = xPlayer.PlayerData and xPlayer.PlayerData.citizenid
        if identifier == nil or tostring(identifier) == "" then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] Qbox player has no citizen id for source: %s", tostring(source))
            return nil, "identifier_not_found"
        end
        if not Sky.DB or type(Sky.DB.Select) ~= "function" then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] Sky.DB.Select is unavailable.")
            return nil, "database_unavailable"
        end

        local rows = Sky.DB.Select(
            "SELECT COUNT(*) AS `vehicle_count` FROM `player_vehicles` WHERE `citizenid` = ?",
            { identifier }
        )
        if type(rows) ~= "table" then
            return nil, "query_failed"
        end

        local count = tonumber(rows[1] and rows[1].vehicle_count)
        if not count or count < 0 or count ~= math.floor(count) then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] Qbox vehicle count query returned an invalid result for source: %s", tostring(source))
            return nil, "invalid_result"
        end

        return math.floor(count)
    end

    ---Get Job Data from online or offline Player
    ---@param source string|number Can be license or player id
    ---@param what "name"|"label"|"grade"|"grade_name"|"grade_label"|"duty"|string[]
    ---@return string?|table
    function Sky.FW.GetJobData(source, what)
        local requested = type(what) == "table" and what or nil

        if Sky.FW.IsPlayerOnline(source) then
            local xPlayer = exports.qbx_core:GetPlayer(source)
            if not xPlayer then return requested and {} or nil end

            local values = {
                name = xPlayer.PlayerData.job.name,
                label = xPlayer.PlayerData.job.label,
                grade = xPlayer.PlayerData.job.grade.level,
                grade_name = xPlayer.PlayerData.job.grade.name,
                grade_label = xPlayer.PlayerData.job.grade.name,
                duty = xPlayer.PlayerData.job.onduty
            }

            if requested then
                local result = {}
                for _, key in ipairs(requested) do
                    result[key] = values[key]
                end
                return result
            end

            return values[what]
        end

        if type(source) == "number" then
            Sky.Debug("warn",
                "[Sky.FW.GetJobData] Offline player job data requested with player ID. License expected. Source: "
                .. tostring(source))
            return requested and {} or ""
        end

        local jobData = Sky.DB.GetValue("players", "license", source, "job")
        local values = {
            name = jobData.name,
            label = jobData.label,
            grade = jobData.grade.level,
            grade_name = jobData.grade.name,
            grade_label = jobData.grade.name,
            duty = nil
        }

        if requested then
            local result = {}
            for _, key in ipairs(requested) do
                result[key] = values[key]
            end
            return result
        end

        return values[what]
    end

    function Sky.FW.GetStatus(source, name)
        return tonumber(exports.qbx_core:GetMetadata(source, name)) or 0
    end

    function Sky.FW.SetStatus(source, name, value)
        exports.qbx_core:SetMetadata(source, name, value)
    end

    function Sky.FW.RemoveStatus(source, name, amount)
        local value = math.max(0.0, (tonumber(exports.qbx_core:GetMetadata(source, name)) or 0) - math.max(0.0, tonumber(amount) or 0))
        exports.qbx_core:SetMetadata(source, name, value)
    end

    function Sky.FW.ChangePlayerName(sourceOrIdentifier, firstname, lastname)
        if not IsDuplicityVersion()
            or (type(sourceOrIdentifier) ~= "number" and type(sourceOrIdentifier) ~= "string")
            or type(firstname) ~= "string" or firstname == ""
            or type(lastname) ~= "string" or lastname == "" then
            return false
        end

        local xPlayer = exports.qbx_core:GetPlayer(sourceOrIdentifier)
        if not xPlayer and type(sourceOrIdentifier) == "string" then
            xPlayer = exports.qbx_core:GetPlayerByCitizenId(sourceOrIdentifier)
        end
        if xPlayer then
            local player_source = xPlayer.PlayerData and xPlayer.PlayerData.source
            if not player_source then return false end
            exports.qbx_core:SetCharInfo(player_source, "firstname", firstname)
            exports.qbx_core:SetCharInfo(player_source, "lastname", lastname)
            exports.qbx_core:Save(player_source)
            return true
        end

        if type(sourceOrIdentifier) ~= "string"
            or not Sky.DB.GetSingleRow("players", "citizenid", sourceOrIdentifier) then
            Sky.Debug("debug", "[Sky.FW.ChangePlayerName] Player not found for identifier: " .. tostring(sourceOrIdentifier))
            return false
        end
        local result = Sky.Query([[
            UPDATE players
            SET charinfo = JSON_SET(charinfo, '$.firstname', ?, '$.lastname', ?)
            WHERE citizenid = ? AND JSON_VALID(charinfo)
        ]], { firstname, lastname, sourceOrIdentifier })
        return result ~= nil and result ~= false
    end

    RegisterServerEvent('hospital:server:SetDeathStatus', function(isDead)
        if isDead then
            TriggerClientEvent("sky_base:onPlayerDeath", source)
        end
    end)

    function Sky.FW.IsDead(source)
        return exports.qbx_core:GetMetadata(source, "isdead") == true
    end

    function Sky.FW.SetPlayerState(source, key, value)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.SetPlayerState] Player not found for source: " .. tostring(source))
            return
        end
        if metadata_player_states[key] then
            exports.qbx_core:SetMetadata(source, key, value)
        end
        Player(source).state:set(key, value, true)
    end

    function Sky.FW.GetPlayerState(source, key)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetPlayerState] Player not found for source: " .. tostring(source))
            return
        end
        if metadata_player_states[key] then
            return exports.qbx_core:GetMetadata(source, key)
        end
        return Player(source).state[key]
    end

    function Sky.FW.GetPlaytime(source)
        local src = tonumber(source)
        if not src then
            Sky.Debug("warn", "GetPlaytime: Invalid 'source' provided. Must be a number.")
            return 0
        end

        local Player = exports.qbx_core:GetPlayer(src)
        if not Player or not Player.PlayerData or not Player.PlayerData.metadata then
            return 0
        end

        local playtimeMinutes = Player.PlayerData.metadata["playtime"]
        if type(playtimeMinutes) ~= "number" then
            return 0
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
end
