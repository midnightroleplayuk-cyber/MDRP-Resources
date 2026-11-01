if Sky.Config.framework == "qb" then
    Sky.FW = {}

    local black_money_mode = Sky.Config.QBBlackMoney.mode
    local black_money_item = Sky.Config.QBBlackMoney.item
    local black_money_worth_key = Sky.Config.QBBlackMoney.worthKey
    assert(black_money_mode == "account" or black_money_mode == "item" or black_money_mode == "markedbills",
        "[sky_base] Invalid QBBlackMoney.mode; expected account, item or markedbills")

    -- Get Qb
    QBCore = exports['qb-core']:GetCoreObject()

    AddEventHandler("sky_jobs_base:injectFramework", function(snapshot)
        if (type(source) == "number" and source > 0) or GetInvokingResource() ~= "sky_jobs_base" then
            Sky.Debug("error", "[sky_base] Rejected unowned framework injection")
            return
        end
        QBCore.Shared.Jobs = snapshot.jobs
        QBCore.Shared.Gangs = snapshot.gangs
    end)

    local metadata_player_states = {
        isdead = true,
        inlaststand = true,
        ishandcuffed = true
    }

    if IsDuplicityVersion() then goto server end

    -- Jobs Creator (https://documentation.jaksam-scripts.com/jobs-creator/client)
    RegisterNetEvent("jobs_creator:injectJobs", function(jobs)
        QBCore.Shared.Jobs = jobs
    end)

    -- Client Side from here

    Sky.FW.VehicleProperties = {
        get = QBCore.Functions.GetVehicleProperties,
        set = QBCore.Functions.SetVehicleProperties,
        codec = "qb"
    }

    --Update Hunger and Thirst
    RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
        TriggerEvent("sky_base:updateHungerAndThirst", newHunger, newThirst)
    end)

    -- Is Player Loaded
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerEvent("sky_base:playerLoaded")
        TriggerEvent("sky_base:inventoryUpdated")
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        TriggerEvent("sky_base:playerUnloaded")
    end)

    --Update Money
    RegisterNetEvent('QBCore:Client:OnMoneyChange', function(account)
        local player_data = QBCore.Functions.GetPlayerData()
        if not player_data.money then
            Sky.Debug("debug", "[QBCore:Client:OnMoneyChange] Ignored money update without a loaded character")
            return
        end
        local newMoney = player_data.money[account]
        TriggerEvent("sky_base:updateAccountMoney", account, newMoney)
    end)

    -- QBCore normalizes the raw VehicleInfo payload before emitting these local events.
    AddEventHandler("QBCore:Client:EnteredVehicle", function(data)
        TriggerEvent("sky_base:enteredVehicle", data.vehicle, data.plate, data.seat)
    end)

    AddEventHandler("QBCore:Client:LeftVehicle", function(data)
        TriggerEvent("sky_base:exitedVehicle", data.vehicle, data.plate, data.seat)
    end)

    -- server-bound sync runs via the server-side QBCore:Server:OnJobUpdate handler
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobInfo)
        jobInfo.grade_label = jobInfo.grade.name
        TriggerEvent("sky_base:updateJob", jobInfo)
        TriggerServerEvent("sky_base:updateJob", jobInfo)
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
            local player_data = QBCore.Functions.GetPlayerData()
            return player_data.metadata and player_data.metadata[key] or nil
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
            if resource_name == "qb-core" then
                gang_snapshot_generation = gang_snapshot_generation + 1
            end
        end)
    end

    -- QBCore fires this server-locally with the player object on login; AddEventHandler
    -- keeps it off the net surface so clients cannot inject playerLoaded for arbitrary
    -- sources. (QBCore:Server:OnPlayerLoaded is the client-fired variant without payload.)
    AddEventHandler("QBCore:Server:PlayerLoaded", function(player)
        TriggerEvent("sky_base:playerLoaded", player.PlayerData.source)
    end)

    -- QBCore fires this server-locally on logout/character switch (multichar)
    AddEventHandler("QBCore:Server:OnPlayerUnload", function(src)
        TriggerEvent("sky_base:playerUnloaded", src)
    end)

    AddEventHandler("onResourceStart", function(resource_name)
        if resource_name ~= GetCurrentResourceName() then return end
        for src, player in pairs(QBCore.Functions.GetQBPlayers()) do
            local player_source = player.PlayerData.source or src
            TriggerEvent("sky_base:playerLoaded", player_source)
        end
    end)

    -- catch server-side job/duty changes from QBCore (e.g. admin, other scripts)
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

    local function updateSkyJobsPlayerCache(src)
        if not src or not Sky_Jobs or not Sky_Jobs.PlayerCache or not Sky_Jobs.PlayerCache.UpdateJob then
            return
        end
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer and xPlayer.PlayerData and xPlayer.PlayerData.job then
            Sky_Jobs.PlayerCache.UpdateJob(src, xPlayer.PlayerData.job)
        end
    end

    -- authoritative duty sync: QBCore fires this server-locally from SetJobDuty;
    -- re-reads PlayerData.job (incl. onduty) instead of trusting any forwarded flag
    AddEventHandler("QBCore:Server:SetDuty", function(src)
        updateSkyJobsPlayerCache(src)
    end)

    -- Jobs Creator (https://documentation.jaksam-scripts.com/jobs-creator/server)
    AddEventHandler("jobs_creator:injectJobs", function(jobs)
        if type(source) == "number" and source > 0 then
            Sky.Debug("debug", "[jobs_creator:injectJobs] Ignored a client-origin compatibility event")
            return
        end
        QBCore.Shared.Jobs = jobs
    end)

    AddEventHandler("jobs_creator:toggleDuty", function(playerId, jobName, isOnDuty)
        if type(source) == "number" and source > 0 then
            Sky.Debug("debug", "[jobs_creator:toggleDuty] Ignored a client-origin compatibility event")
            return
        end
        if not playerId then return end
        updateSkyJobsPlayerCache(playerId)
    end)

    AddEventHandler("jobs_creator:boss:playerHired", function(playerId, jobName)
        if type(source) == "number" and source > 0 then
            Sky.Debug("debug", "[jobs_creator:boss:playerHired] Ignored a client-origin compatibility event")
            return
        end
        if not playerId then return end
        updateSkyJobsPlayerCache(playerId)
    end)

    AddEventHandler("jobs_creator:boss:employeeFired", function(employeeIdentifier, jobName)
        if type(source) == "number" and source > 0 then
            Sky.Debug("debug", "[jobs_creator:boss:employeeFired] Ignored a client-origin compatibility event")
            return
        end
        if not employeeIdentifier then return end
        local xPlayer = QBCore.Functions.GetPlayerByCitizenId(employeeIdentifier)
        if xPlayer then
            updateSkyJobsPlayerCache(xPlayer.PlayerData.source)
        end
    end)

    function Sky.FW.IsPlayerOnline(sourceOrIdentifier)
        local xPlayer = QBCore.Functions.GetPlayer(sourceOrIdentifier)
        if xPlayer == nil then
            xPlayer = QBCore.Functions.GetPlayerByCitizenId(tostring(sourceOrIdentifier))
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
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(source))
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetIdentifier] Player not found for source: " .. tostring(source))
            return
        end
        return tostring(xPlayer.PlayerData.citizenid)
    end

    function Sky.FW.GetName(source)
        local xPlayer = tonumber(source) and QBCore.Functions.GetPlayer(tonumber(source))
        local identifier = source
        if xPlayer then
            identifier = xPlayer.PlayerData.citizenid
        end
        if tonumber(identifier) and tonumber(identifier) <= 0 then
            return
        end

        local result = Sky.DB.GetValue("players", "citizenid", identifier, "charinfo")

        if result then
            local charinfo = json.decode(result)
            return Sky.String.SanitizeForSQL(charinfo.firstname .. " " .. charinfo.lastname)
        end
    end

    function Sky.FW.GetFirstname(source)
        local xPlayer = tonumber(source) and QBCore.Functions.GetPlayer(tonumber(source))
        local identifier = source
        if xPlayer then
            return Sky.String.SanitizeForSQL(xPlayer.PlayerData.charinfo.firstname)
        end
        if tonumber(identifier) and tonumber(identifier) <= 0 then
            return
        end

        local result = Sky.DB.GetValue("players", "citizenid", identifier, "charinfo")
        if result then
            local charinfo = json.decode(result)
            if charinfo then
                return Sky.String.SanitizeForSQL(charinfo.firstname)
            end
        end
    end

    function Sky.FW.GetLastname(source)
        local xPlayer = tonumber(source) and QBCore.Functions.GetPlayer(tonumber(source))
        local identifier = source
        if xPlayer then
            return Sky.String.SanitizeForSQL(xPlayer.PlayerData.charinfo.lastname)
        end
        if tonumber(identifier) and tonumber(identifier) <= 0 then
            return
        end

        local result = Sky.DB.GetValue("players", "citizenid", identifier, "charinfo")
        if result then
            local charinfo = json.decode(result)
            if charinfo then
                return Sky.String.SanitizeForSQL(charinfo.lastname)
            end
        end
    end

    function Sky.FW.GetGender(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then return end
        return xPlayer.PlayerData.charinfo.gender
    end

    function Sky.FW.GetBirthdate(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then return end
        local charInfo = xPlayer.PlayerData and xPlayer.PlayerData.charinfo
        if type(charInfo) ~= "table" then return end
        return charInfo.birthdate
    end

    function Sky.FW.GetHeight(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
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

    local function get_black_money_items(source)
        local slots, balance = Sky.FW.GetInventorySlotsWithItem(source, black_money_item), 0
        for _, item in ipairs(slots) do
            balance = balance + item.count
        end
        return slots, balance
    end

    local function remove_black_money_items(source, amount)
        local slots, balance = get_black_money_items(source)
        if balance < amount then return false end
        local removed, remaining = {}, amount
        for _, item in ipairs(slots) do
            if remaining == 0 then break end
            local count = math.min(remaining, item.count)
            if Sky.FW.RemoveItem(source, black_money_item, count, item.slot, item.metadata) ~= count then
                for _, original in ipairs(removed) do
                    if not Sky.FW.AddItem(source, black_money_item, original.count, original.slot, original.metadata) then
                        error(("[sky_base] Failed to restore black-money items for player %s, slot %s")
                            :format(source, original.slot))
                    end
                end
                return false
            end
            removed[#removed + 1] = { slot = item.slot, count = count, metadata = item.metadata }
            remaining = remaining - count
        end
        return remaining == 0
    end

    local function get_marked_bills(source)
        local bags, balance = {}, 0
        for _, item in ipairs(Sky.FW.GetInventorySlotsWithItem(source, black_money_item)) do
            local worth = tonumber(item.metadata and item.metadata[black_money_worth_key])
            local count = tonumber(item.count or item.amount)
            if not worth or worth <= 0 or worth % 1 ~= 0 or count ~= 1 then
                Sky.Debug("error", "[sky_base] Invalid marked-bills slot %s: expected one unique bag with positive integer worth", tostring(item.slot))
                return nil, 0
            end
            bags[#bags + 1] = { slot = item.slot, worth = worth, metadata = item.metadata }
            balance = balance + worth
        end
        table.sort(bags, function(left, right) return left.slot < right.slot end)
        return bags, balance
    end

    local function remove_marked_bills(source, amount)
        local bags, balance = get_marked_bills(source)
        if not bags or balance < amount then return false end
        local removed, remaining = {}, amount
        for _, bag in ipairs(bags) do
            if remaining == 0 then break end
            local success
            if bag.worth > remaining then
                local metadata = {}
                for key, value in pairs(bag.metadata) do metadata[key] = value end
                metadata[black_money_worth_key] = bag.worth - remaining
                success = Sky.FW.SetInventorySlotMetadata(source, bag.slot, metadata)
                if success then return true end
            else
                success = Sky.FW.RemoveItem(source, black_money_item, 1, bag.slot, bag.metadata) == 1
                if success then
                    removed[#removed + 1] = bag
                    remaining = remaining - bag.worth
                end
            end
            if not success then
                for _, original in ipairs(removed) do
                    if not Sky.FW.AddItem(source, black_money_item, 1, original.slot, original.metadata) then
                        error(("[sky_base] Failed to restore marked-bills bag for player %s, slot %s, worth %s")
                            :format(source, original.slot, original.worth))
                    end
                end
                return false
            end
        end
        return remaining == 0
    end

    function Sky.FW.GetAccountMoney(source, account)
        if (account == "black_money" or account == "black") and black_money_mode == "item" then
            local _, balance = get_black_money_items(source)
            return balance
        end
        if (account == "black_money" or account == "black") and black_money_mode == "markedbills" then
            local _, balance = get_marked_bills(source)
            return balance
        end
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetAccountMoney] Player not found for source: " .. tostring(source))
            return 0
        end
        if account == "money" then
            account = "cash"
        elseif account == "black_money" then
            account = "black"
        end
        return xPlayer.PlayerData.money[account] or 0
    end

    function Sky.FW.AddAccountMoney(source, account, amount)
        if (account == "black_money" or account == "black") and black_money_mode == "item" then
            amount = tonumber(amount)
            if not amount or amount <= 0 or amount % 1 ~= 0 then return false end
            return Sky.FW.AddItem(source, black_money_item, amount)
        end
        if (account == "black_money" or account == "black") and black_money_mode == "markedbills" then
            amount = tonumber(amount)
            if not amount or amount <= 0 or amount % 1 ~= 0 then return false end
            return Sky.FW.AddItem(source, black_money_item, 1, nil, { [black_money_worth_key] = amount })
        end
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.AddAccountMoney] Player not found for source: " .. tostring(source))
            return false
        end
        if account == "money" then
            account = "cash"
        elseif account == "black_money" then
            account = "black"
        end
        return xPlayer.Functions.AddMoney(account, amount)
    end

    function Sky.FW.RemoveAccountMoney(source, account, amount, options)
        if (account == "black_money" or account == "black") and black_money_mode == "item" then
            amount = tonumber(amount)
            if not amount or amount <= 0 or amount % 1 ~= 0 then return false end
            return remove_black_money_items(source, amount)
        end
        if (account == "black_money" or account == "black") and black_money_mode == "markedbills" then
            amount = tonumber(amount)
            if not amount or amount <= 0 or amount % 1 ~= 0 then return false end
            return remove_marked_bills(source, amount)
        end
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.RemoveAccountMoney] Player not found for source: " .. tostring(source))
            return false
        end
        if account == "money" then
            account = "cash"
        elseif account == "black_money" then
            account = "black"
        end
        local allow_overdraft = type(options) == "table"
            and options.allowOverdraft == true
            and account == "bank"
        if allow_overdraft or (xPlayer.PlayerData.money[account] or 0) >= amount then
            local reason = type(options) == "table" and options.reason or nil
            return xPlayer.Functions.RemoveMoney(account, amount, reason) ~= false
        end
        return false
    end

    local jobUsersCache = {}
    local jobUsersCacheDuration = 60000

    function Sky.FW.GetGroupMemberCounts()
        local counts = { job = {}, gang = {} }
        for _, row in ipairs(Sky.Query([[SELECT 'job' AS kind, JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) AS name, COUNT(*) AS total
            FROM players GROUP BY JSON_UNQUOTE(JSON_EXTRACT(job, '$.name'))
            UNION ALL SELECT 'gang' AS kind, JSON_UNQUOTE(JSON_EXTRACT(gang, '$.name')) AS name, COUNT(*) AS total
            FROM players GROUP BY JSON_UNQUOTE(JSON_EXTRACT(gang, '$.name'))]], {})) do
            if row.name then counts[row.kind][row.name] = tonumber(row.total) end
        end
        return counts
    end

    ---@return {{identifier = string, job_grade = number, name = string|nil }, {...}}
    function Sky.FW.GetJobUsers(jobName)
        local now = GetGameTimer()
        local cached = jobUsersCache[jobName]
        if cached and now - cached.createdAt < jobUsersCacheDuration then
            return cached.users
        end

        local users = {}
        local result = MySQL.query.await(
            "SELECT citizenid, job, name, charinfo FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) = @job",
            {
                ["@job"] = jobName
            })
        for _, user in ipairs(result) do
            if user ~= nil then
                local charinfo = user.charinfo and json.decode(user.charinfo) or nil
                local name = user.name
                if not name and charinfo and charinfo.firstname then
                    name = string.format("%s %s", charinfo.firstname, charinfo.lastname or "")
                end
                table.insert(users, {
                    identifier = user.citizenid,
                    job_grade = json.decode(user.job).grade.level,
                    name = name
                })
            end
        end

        jobUsersCache[jobName] = {
            users = users,
            createdAt = now
        }
        return users
    end

    local gangUsersCache = {}

    AddEventHandler("sky_base:jobMembers:changed", function(group_names, kind)
        if (type(source) == "number" and source > 0) or GetInvokingResource() ~= "sky_base" then
            Sky.Debug("error", "[sky_base] Rejected unowned QB member cache invalidation")
            return
        end
        local cache = kind == "gang" and gangUsersCache or jobUsersCache
        for _, group_name in ipairs(group_names) do cache[group_name] = nil end
    end)

    ---@return {{identifier = string, job_grade = number, name = string|nil }, {...}}
    function Sky.FW.GetGangUsers(gangName)
        local now = GetGameTimer()
        local cached = gangUsersCache[gangName]
        if cached and now - cached.createdAt < jobUsersCacheDuration then
            return cached.users
        end

        local users = {}
        local result = MySQL.query.await(
            "SELECT citizenid, gang, name, charinfo FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(gang, '$.name')) = @gang",
            {
                ["@gang"] = gangName
            })
        for _, user in ipairs(result) do
            local gang = user.gang and json.decode(user.gang) or nil
            if gang then
                local charinfo = user.charinfo and json.decode(user.charinfo) or nil
                local name = user.name
                if not name and charinfo and charinfo.firstname then
                    name = string.format("%s %s", charinfo.firstname, charinfo.lastname or "")
                end
                users[#users + 1] = {
                    identifier = user.citizenid,
                    job_grade = type(gang.grade) == "table" and (gang.grade.level or gang.grade.grade) or gang.grade,
                    name = name
                }
            end
        end

        gangUsersCache[gangName] = {
            users = users,
            createdAt = now
        }
        return users
    end

    AddEventHandler("QBCore:Server:OnGangUpdate", function()
        gangUsersCache = {}
    end)

    -- Current QBCore also publishes typed player-data updates; retain legacy events above.
    AddEventHandler("QBCore:Server:OnPlayerUpdated", function(src, key, value)
        if key == "gang" or key == "all" then
            gangUsersCache = {}
            TriggerEvent("sky_base:gangUpdated", src, key == "all" and value.gang or value)
        end
        if key == "job" or key == "all" then
            jobUsersCache = {}
            TriggerEvent("sky_base:jobUpdated", src, key == "all" and value.job or value)
        end
    end)

    ---Get Job from online or offline Player
    ---@param source string|number Can be license or player id
    ---@return string
    function Sky.FW.GetJob(source)
        if Sky.FW.IsPlayerOnline(source) then
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if xPlayer ~= nil then
                return xPlayer.PlayerData.job.name
            else
                return ""
            end
        else
            if type(source) == "string" then
                local jobData = Sky.DB.GetValue("players", "license", source, "job")
                if not jobData then
                    Sky.Debug("warn",
                        "[Sky.FW.GetJob] No job data found for offline player with license: " .. tostring(source))
                    return ""
                end
                return jobData.name
            end
        end
    end

    function Sky.FW.GetGang(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer and xPlayer.PlayerData.gang then
            return xPlayer.PlayerData.gang.name
        end
        return nil
    end

    function Sky.FW.GetGangData(source, what)
        local xPlayer = QBCore.Functions.GetPlayer(source)
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
    ---@param source string|number Citizen ID or player source
    ---@param jobName string
    ---@param jobGrade number
    function Sky.FW.SetJob(source, jobName, jobGrade, expected_identifier, expected_member)
        if expected_member then return Sky.FW._SetMemberProfile(source, "job", jobName, jobGrade, expected_identifier, expected_member) end
        local grade, numeric_source = tonumber(jobGrade), type(source) == "number" and source or nil
        if type(jobName) ~= "string" or jobName == "" or not grade or grade < 0 or grade % 1 ~= 0
            or expected_identifier ~= nil and (type(expected_identifier) ~= "string" or expected_identifier == "" or not numeric_source) then
            Sky.Debug("error", "[Sky.FW.SetJob] Invalid assignment: %s/%s to %s", tostring(jobName), tostring(jobGrade), tostring(source))
            return false, "invalid_member"
        end
        jobName, grade = jobName:lower(), math.floor(grade)
        local facade, core, generation = Sky.FW, QBCore, gang_snapshot_generation
        if Sky.Config.framework ~= "qb" or GetResourceState("qb-core") ~= "started" then return false, "framework_not_ready" end
        local definition = exports["qb-core"]:GetCoreObject({ "Shared" }).Shared.Jobs[jobName]
        if not definition or not definition.grades[tostring(grade)] then
            Sky.Debug("error", "[Sky.FW.SetJob] Unknown QB job/grade: %s/%s", jobName, grade)
            return false, "member_profile_unsupported"
        end
        if numeric_source then
            if numeric_source <= 0 or numeric_source % 1 ~= 0 then return false, "invalid_member" end
            local player = core.Functions.GetPlayer(numeric_source)
            if not player then return false, "session_changed" end
            local identifier = player.PlayerData.citizenid
            if expected_identifier ~= nil and identifier ~= expected_identifier then return false, "session_changed" end
            if type(player.PlayerData.job) ~= "table" then return false, "member_profile_unsupported" end
            local previous_job = Sky.Table.Clone(player.PlayerData.job)
            if Sky.Config.framework ~= "qb" or Sky.FW ~= facade or QBCore ~= core
                or gang_snapshot_generation ~= generation or GetResourceState("qb-core") ~= "started" then
                return false, "framework_changed"
            end
            local result = player.Functions.SetJob(jobName, grade)
            if result == false then return false, "member_update_failed" end
            if Sky.Config.framework ~= "qb" or Sky.FW ~= facade or QBCore ~= core
                or gang_snapshot_generation ~= generation or GetResourceState("qb-core") ~= "started" then
                return false, "member_persistence_pending"
            end
            player = core.Functions.GetPlayer(numeric_source)
            if not player or player.PlayerData.citizenid ~= identifier then return false, "session_changed" end
            local current_job = player.PlayerData.job
            if Sky.Config.framework ~= "qb" or Sky.FW ~= facade or QBCore ~= core
                or gang_snapshot_generation ~= generation or GetResourceState("qb-core") ~= "started" then
                return false, "member_persistence_pending"
            end
            if current_job.name ~= jobName or tonumber(current_job.grade.level) ~= grade then
                Sky.Debug("error", "[Sky.FW.SetJob] QB assignment was not confirmed for source %s", numeric_source)
                return false, "member_update_failed"
            end
            TriggerEvent("sky_base:jobMembers:changed", { previous_job.name, jobName })
            return true, false, previous_job
        end

        return Sky.FW._SetOfflineJob(source, jobName, grade)
    end

    ---Set Gang for an online player or offline citizen ID
    ---@param source string|number Player source or citizen ID
    ---@param gangName string
    ---@param gangGrade number
    ---@return boolean success
    function Sky.FW.SetGang(source, gangName, gangGrade, expected_identifier, expected_member)
        if expected_member then return Sky.FW._SetMemberProfile(source, "gang", gangName, gangGrade, expected_identifier, expected_member) end
        gangGrade = tonumber(gangGrade)
        local definition = QBCore.Shared.Gangs[gangName]
        local grade = gangGrade and gangGrade >= 0 and gangGrade % 1 == 0
            and definition and definition.grades[tostring(math.floor(gangGrade))]
        if not grade then
            Sky.Debug("error", "[Sky.FW.SetGang] Unknown gang/grade: %s/%s", tostring(gangName), tostring(gangGrade))
            return false
        end
        gangGrade = math.floor(gangGrade)
        local numericSource = tonumber(source)
        local xPlayer
        if numericSource then
            xPlayer = QBCore.Functions.GetPlayer(numericSource)
        else
            xPlayer = QBCore.Functions.GetPlayerByCitizenId(tostring(source))
        end
        gangUsersCache = {}
        if xPlayer then
            return xPlayer.Functions.SetGang(gangName, gangGrade) == true
        end
        if numericSource then return false end
        local gang = {
            name = gangName, label = definition.label, isboss = grade.isboss == true,
            grade = { name = grade.name, level = gangGrade, isboss = grade.isboss == true },
        }
        local changed = Sky.DB.Update("UPDATE players SET gang = ? WHERE citizenid = ?", { json.encode(gang), tostring(source) })
        -- A character may have finished loading while the database call yielded.
        xPlayer = QBCore.Functions.GetPlayerByCitizenId(tostring(source))
        if xPlayer then return xPlayer.Functions.SetGang(gangName, gangGrade) == true end
        return changed == 1
    end

    ---Set Duty status for a player
    ---@param source string|number Can be license or player id
    ---@param onDuty boolean
    ---@return boolean success
    function Sky.FW.SetDuty(source, onDuty)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then return false end

        local desired_duty = onDuty == true
        -- QBCore emits OnJobUpdate even for unchanged duty, which would echo back through Sky.
        if xPlayer.PlayerData.job.onduty == desired_duty then return true end

        xPlayer.Functions.SetJobDuty(desired_duty)
        return xPlayer.PlayerData.job.onduty == desired_duty
    end

    ---Toggle Duty status for a player
    ---@param source string|number Can be license or player id
    ---@return boolean success
    function Sky.FW.ToggleDuty(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then return false end

        return Sky.FW.SetDuty(source, not xPlayer.PlayerData.job.onduty)
    end

    ---Get count of on-duty players for a specific job
    ---@param jobName string
    ---@return number count
    ---@return table sources Array of player sources
    function Sky.FW.GetOnDutyCount(jobName)
        local sources = {}
        local players = QBCore.Functions.GetPlayers()
        local jobsCreatorStarted = GetResourceState("jobs_creator") == "started"
        for _, playerId in pairs(players) do
            local xPlayer = QBCore.Functions.GetPlayer(playerId)
            if xPlayer and xPlayer.PlayerData and xPlayer.PlayerData.job then
                local job = xPlayer.PlayerData.job
                local isOnDuty
                if jobsCreatorStarted then
                    isOnDuty = exports["jobs_creator"]:isPlayerOnDuty(playerId)
                else
                    isOnDuty = job.onduty
                end
                if job.name == jobName and isOnDuty then
                    sources[#sources + 1] = playerId
                end
            end
        end

        return #sources, sources
    end

    function Sky.FW.DoesJobExist(jobName, grade)
        local jobs = QBCore.Shared.Jobs
        local job = jobs[jobName]
        if job then
            local grade = job.grades[tostring(grade)]
            if grade then
                return true
            end
        end
        return false
    end

    function Sky.FW.DoesGangExist(gangName, grade)
        local gang = QBCore.Shared.Gangs[gangName]
        return gang ~= nil and gang.grades[tostring(grade)] ~= nil
    end

    function Sky.FW.ReadJobAdoptionSnapshot(job_name, aliases)
        Sky.Debug("error", "[Sky.FW.ReadJobAdoptionSnapshot] Persisted adoption snapshots are unsupported on QBCore: %s", tostring(job_name))
        return nil, "unsupported_framework"
    end


    ---Get Jobs
    ---@return {name: string, label: string, grades: {[string]: {grade: number, name: string, label: string, payment: string}}}
    function Sky.FW.GetJobs()
        local jobs = {}
        local shared = exports["qb-core"]:GetCoreObject({ "Shared" }).Shared
        for name, job in pairs(shared.Jobs) do
            local grades = {}
            for grade_index, grade in pairs(job.grades) do
                local grade_key = tostring(grade_index)
                local normalized = Sky.Table.Clone(job.grades[grade_key] or grade)
                normalized.grade, normalized.name, normalized.label = tonumber(grade_index), string.lower(normalized.name), normalized.name
                normalized.isboss, normalized.bankAuth = normalized.isboss == true, normalized.bankAuth == true
                grades[grade_key] = normalized
            end
            jobs[name] = {
                name = name,
                label = job.label,
                grades = grades,
                type = job.type,
                defaultDuty = job.defaultDuty,
                offDutyPay = job.offDutyPay
            }
        end
        return jobs
    end

    ---Get Gangs
    ---@return {name: string, label: string, grades: {[string]: {grade: number, name: string, label: string, payment: number}}}
    function Sky.FW.GetGangs()
        local gangs = {}
        local shared = exports["qb-core"]:GetCoreObject({ "Shared" }).Shared
        for name, gang in pairs(shared.Gangs) do
            local grades = {}
            for gradeIndex, grade in pairs(gang.grades) do
                grades[tostring(gradeIndex)] = Sky.Table.Clone(grade)
                local normalized = grades[tostring(gradeIndex)]
                normalized.grade, normalized.name, normalized.label, normalized.payment = tonumber(gradeIndex), string.lower(grade.name), grade.name, 0
                normalized.isboss = grade.isboss == true
            end
            gangs[name] = {
                name = name,
                label = gang.label,
                grades = grades
            }
        end
        return gangs
    end

    function Sky.FW.GetPlayers()
        return QBCore.Functions.GetPlayers()
    end

    function Sky.FW.IsVehicleOwnedByPlayer(source, plate)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local identifier = xPlayer and xPlayer.PlayerData.citizenid
        if type(identifier) ~= "string" or identifier == "" then
            Sky.Debug("debug", "[Sky.FW.IsVehicleOwnedByPlayer] Character not found for source: %s", tostring(source))
            return false
        end

        local legacyOwned = false
        if GetResourceState("jobs_creator") == "started" then
            legacyOwned = exports["jobs_creator"]:isPlayerOwnerOfVehiclePlate(source, plate)
        end

        local rows
        if not legacyOwned then
            rows = Sky.Query("SELECT citizenid FROM player_vehicles WHERE plate = @plate AND citizenid = @citizenid LIMIT 1", {
                ["@plate"] = plate,
                ["@citizenid"] = identifier,
            })
        end

        local currentPlayer = QBCore.Functions.GetPlayer(source)
        if not currentPlayer or currentPlayer.PlayerData.citizenid ~= identifier then
            return false
        end
        if legacyOwned then
            return true
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

        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetOwnedVehicleCount] Player not found for source: %s", tostring(source))
            return nil, "player_not_found"
        end

        local identifier = xPlayer.PlayerData and xPlayer.PlayerData.citizenid
        if identifier == nil or tostring(identifier) == "" then
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] QB player has no citizen id for source: %s", tostring(source))
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
            Sky.Debug("error", "[Sky.FW.GetOwnedVehicleCount] QB vehicle count query returned an invalid result for source: %s", tostring(source))
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
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if not xPlayer then return requested and {} or nil end

            local duty = xPlayer.PlayerData.job.onduty
            if GetResourceState("jobs_creator") == "started" then
                duty = exports["jobs_creator"]:isPlayerOnDuty(source)
            end

            local values = {
                name = xPlayer.PlayerData.job.name,
                label = xPlayer.PlayerData.job.label,
                grade = xPlayer.PlayerData.job.grade.level,
                grade_name = xPlayer.PlayerData.job.grade.name,
                grade_label = xPlayer.PlayerData.job.grade.name,
                duty = duty
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
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetStatus] Player not found for source: " .. tostring(source))
            return 0
        end
        return tonumber(xPlayer.Functions.GetMetaData(name)) or 0
    end

    function Sky.FW.ChangePlayerName(sourceOrIdentifier, firstname, lastname)
        if not IsDuplicityVersion()
            or (type(sourceOrIdentifier) ~= "number" and type(sourceOrIdentifier) ~= "string")
            or type(firstname) ~= "string" or firstname == ""
            or type(lastname) ~= "string" or lastname == "" then
            return false
        end

        local xPlayer = type(sourceOrIdentifier) == "number"
            and QBCore.Functions.GetPlayer(sourceOrIdentifier)
            or QBCore.Functions.GetPlayerByCitizenId(sourceOrIdentifier)
        if xPlayer then
            local char_info = xPlayer.PlayerData and xPlayer.PlayerData.charinfo
            if type(char_info) ~= "table" then return false end
            char_info.firstname = firstname
            char_info.lastname = lastname
            xPlayer.Functions.SetPlayerData("charinfo", char_info)
            xPlayer.Functions.Save()
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

    function Sky.FW.SetStatus(source, name, value)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.SetStatus] Player not found for source: " .. tostring(source))
            return
        end
        xPlayer.Functions.SetMetaData(name, value)
    end

    function Sky.FW.RemoveStatus(source, name, amount)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.RemoveStatus] Player not found for source: " .. tostring(source))
            return
        end
        local value = math.max(0.0, (tonumber(xPlayer.Functions.GetMetaData(name)) or 0) - math.max(0.0, tonumber(amount) or 0))
        xPlayer.Functions.SetMetaData(name, value)
    end

    function Sky.FW.IsDead(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.IsDead] Player not found for source: " .. tostring(source))
            return false
        end
        return xPlayer.Functions.GetMetaData("isdead") == true
    end

    function Sky.FW.SetPlayerState(source, key, value)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.SetPlayerState] Player not found for source: " .. tostring(source))
            return
        end
        if metadata_player_states[key] then
            xPlayer.Functions.SetMetaData(key, value)
        end
        Player(source).state:set(key, value, true)
    end

    function Sky.FW.GetPlayerState(source, key)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if not xPlayer then
            Sky.Debug("debug", "[Sky.FW.GetPlayerState] Player not found for source: " .. tostring(source))
            return
        end
        if metadata_player_states[key] then
            return xPlayer.Functions.GetMetaData(key)
        end
        return Player(source).state[key]
    end

    function Sky.FW.GetPlaytime(source)
        local src = tonumber(source)
        if not src then
            Sky.Debug("warn", "GetPlaytime: Invalid 'source' provided. Must be a number.")
            return 0
        end

        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then
            return 0
        end

        local playtimeMinutes = Player.PlayerData.metadata["playtime"] or 0

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
