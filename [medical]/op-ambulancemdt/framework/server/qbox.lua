QBox = GetResourceState('qbx_core') == 'started' and true or false

if not QBox then return end

Framework = exports['qb-core']:GetCoreObject()
Fr.usersTable = "players"
Fr.identificatorTable = "citizenid"
Fr.Table = 'player_vehicles'
Fr.VehProps = 'mods'
Fr.OwnerTable = "citizenid"
Fr.StoredTable = 'state'
Fr.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
Fr.DefaultJob = {
    job = "unemployed",
    grade = 0
}

Fr.RegisterServerCallback = function(...)
    return Framework.Functions.CreateCallback(...)
end
Fr.GetPlayerFromIdentifier = function(identifier)
    return Framework.Functions.GetPlayerByCitizenId(identifier)
end
Fr.getPlayerFromId = function(...)
    return Framework.Functions.GetPlayer(...)
end
Fr.GetMoney = function(Player, account)
    if account == "money" then account = "cash" end
    return Player.PlayerData.money[account]
end
Fr.ManageMoney = function(Player, account, action, amount)
    if account == "money" then account = "cash" end
    if action == "add" then
        return Player.Functions.AddMoney(account, amount)
    else
        return Player.Functions.RemoveMoney(account, amount)
    end
end
Fr.GetIndentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.PlayerData.citizenid
end
Fr.GetPlayerName = function(sourceOrIdentifier)
    local xPlayer = Fr.getPlayerFromId(sourceOrIdentifier)
    local name, lastname

    if xPlayer then
        name = xPlayer.PlayerData.charinfo.firstname
        lastname = xPlayer.PlayerData.charinfo.lastname
    else
        local result = MySQL.Sync.fetchAll(
            "SELECT charinfo FROM players WHERE citizenid = @citizenid",
            {['@citizenid'] = trim(sourceOrIdentifier)}
        )
        if result and result[1] then
            result[1].charinfo = json.decode(result[1].charinfo)
            name = result[1].charinfo.firstname
            lastname = result[1].charinfo.lastname
        else
            name = "Unknown"
            lastname = "Unknown"
        end
    end

    return {name = name, lastname = lastname}
end
Fr.GetSourceFromPlayerObject = function(xPlayer)
    if xPlayer then
        return xPlayer.PlayerData.source
    else
        return nil
    end
end
Fr.GetPlayerJob = function(xPlayer)
    local job = {
        name = xPlayer.PlayerData.job.name,
        grade = xPlayer.PlayerData.job.grade.level,
        grade_label = xPlayer.PlayerData.job.grade.name,
    }
    return job
end
Fr.GetActiveEmployees = function(cb, jobName)
    local employees = {}
	local xPlayers = exports.qbx_core:GetGroupMembers(jobName, "job")
    local Jobs = Framework.Shared.Jobs

	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]
        local details = getPlayerDetailsInJob(xPlayer.citizenid, jobName)

        if details.status ~= "offduty" then
            local player = exports.qbx_core:GetPlayerByCitizenId(xPlayer.citizenid) or exports.qbx_core:GetOfflinePlayer(xPlayer.citizenid)
            table.insert(employees, {
                name = player.PlayerData.charinfo.firstname,
                source = Fr.GetSourceFromPlayerObject(player),
                lastname = player.PlayerData.charinfo.lastname,
                charId = xPlayer.citizenid,
                rankLabel = player.PlayerData.job.grade.name,
                rankGrade = player.PlayerData.job.grade.level,
                onDutyTime = msToHours(getEmployeeDutyTimeMs(xPlayer.citizenid, jobName, Fr.GetSourceFromPlayerObject(player))),
                avatar = details.avatar,
                callsign = "", -- not used, leave blank
                status = details.status,
                badgeNumber = details.badgeNumber,
            })
        end
	end
		
    cb(employees)
end
Fr.GetEmployees = function(cb, jobName)
    local employees = {}
	local xPlayers = exports.qbx_core:GetGroupMembers(jobName, "job")
    local Jobs = Framework.Shared.Jobs

	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]
        local details = getPlayerDetailsInJob(xPlayer.citizenid, jobName)
        local player = exports.qbx_core:GetPlayerByCitizenId(xPlayer.citizenid) or exports.qbx_core:GetOfflinePlayer(xPlayer.citizenid)

		table.insert(employees, {
			name = player.PlayerData.charinfo.firstname,
            lastname = player.PlayerData.charinfo.lastname,
			charId = xPlayer.citizenid,
            rankLabel = player.PlayerData.job.grade.name,
            rankGrade = player.PlayerData.job.grade.level,
            onDutyTime = msToHours(getEmployeeDutyTimeMs(xPlayer.citizenid, jobName, Fr.GetSourceFromPlayerObject(player))),
            avatar = details.avatar,
            callsign = "", -- not used, leave blank
            status = details.status,
            badgeNumber = details.badgeNumber,
		})
	end
		
    cb(employees)
end
Fr.SetJob = function(xPlayer, jobName, jobGrade)
    if not xPlayer then return end
    xPlayer.Functions.SetJob(jobName, tonumber(jobGrade))
end
Fr.GetJobData = function(jobName)
    local Jobs = Framework.Shared.Jobs
    if not Jobs[jobName] then return {} end

    local jobTable = {
        name = jobName,
        label = Jobs[jobName].label,
        grades = {}
    }

    for k, v in pairs(Jobs[jobName].grades) do 
        jobTable.grades[tostring(k)] = {
            name = tostring(k),
            grade = k,
            label = v.name
        }
    end

    return jobTable
end
Fr.SetOfflineJob = function(charId, jobName, jobGrade)
    exports.qbx_core:SetJob(charId, jobName, jobGrade)
end
Fr.GetJobVehicles = function(jobName)
    local allVehicles

    if Config.GarageScript == 'jg-advancedgarages' then
        local jobOwner = getJgJobOwnerId(jobName)
        allVehicles = MySQL.query.await([[
            SELECT * FROM `]] .. Fr.Table .. [[`
            WHERE `job` = @job
               OR (
                    `job_vehicle` = 1
                    AND (`citizenid` IN (@jobOwner, @jobName) OR `license` IN (@jobOwner, @jobName))
               )
        ]], {
            ["@job"] = jobName,
            ["@jobOwner"] = jobOwner,
            ["@jobName"] = jobName,
        })
    else
        allVehicles = MySQL.query.await("SELECT * FROM `".. Fr.Table .."` WHERE `job` = @job", {["@job"] = jobName})
    end

    if not allVehicles then allVehicles = {} end
    local finalVehicles = {}

    for k, v in pairs(allVehicles) do 
        local jobConfig = Config.VehicleShop[jobName] or {}
        local vehConfig = {}

        for _, configValues in pairs(jobConfig) do 
            if configValues.model == v.configName then 
                vehConfig = configValues
                break;
            end
        end
        local props = json.decode(v.mods or v.vehicle or '{}')

        local currentDriver = {
            charId = "",
            name = "",
            lastname = "",
            uniqueid = ""
        }

        if Config.GarageScript == "op-garages" then 
            v.citizenid = v.jobPrivate
        end

        if v.citizenid ~= nil and v.citizenid ~= "" and not isJgJobVehicleOwner(v.citizenid, jobName) then
            local names = Fr.GetPlayerName(v.citizenid) 
            currentDriver = {
                charId = v.citizenid,
                name = names.name,
                lastname = names.lastname,
                uniqueid = v.citizenid
            }
        end

        table.insert(finalVehicles, {
            label = vehConfig.label or "Not Found",
            plate = v.plate,
            model = vehConfig.model or props.model,
            currentDriver = currentDriver,
            resellPrice = vehConfig.resellPrice or 0,
            image = vehConfig.image or "",
        })
    end

    return finalVehicles
end
Fr.VehiclePurchased = function(model, jobName, plate, mods)
    local readyModel = joaat(model)
    local modsJson = mods or json.encode({model = readyModel, plate = plate})

    if Config.GarageScript == 'jg-advancedgarages' then
        local jobOwner = getJgJobOwnerId(jobName)

        MySQL.Async.insert([[
            INSERT INTO `player_vehicles`
            (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `gang`, `configName`, `job_vehicle`, `job_vehicle_rank`, `job`)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            jobOwner,
            model,
            readyModel,
            jobOwner,
            plate,
            modsJson,
            nil,
            model,
            1,
            0,
            jobName,
        }, function(insertId)
            if not insertId then
                print(("[^1ERROR^7] Vehicle insert failed for plate %s"):format(plate))
            else
                local insertInfo = ("[^2INFO^7] Vehicle inserted with ID: %s, plate: %s"):format(insertId, plate)
                if mods then 
                    print(insertInfo)
                else
                    debugPrint(insertInfo)
                end
            end
        end)
        return
    end

    MySQL.Async.insert([[
        INSERT INTO `player_vehicles`
        (`license`, `vehicle`, `hash`, `citizenid`, `plate`, `mods`, `job`, `configName`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        nil, model, readyModel, nil, plate, modsJson, jobName, model
    }, function(insertId)
        if not insertId then
            print(("[^1ERROR^7] Vehicle insert failed for plate %s"):format(plate))
        else
            local insertInfo = ("[^2INFO^7] Vehicle inserted with ID: %s, plate: %s"):format(insertId, plate)
            if mods then 
                print(insertInfo)
            else
                debugPrint(insertInfo)
            end
        end
    end)
end
Fr.IsPlateTaken = function(plate)
    local p = promise.new()
    
    MySQL.scalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate},
    function(result)
        p:resolve(result ~= nil)
    end)

    return Citizen.Await(p)
end
Fr.VehicleSold = function(plate)
    MySQL.Async.execute("DELETE FROM `".. Fr.Table .."` WHERE `plate` = @plate", {
        ['@plate'] = plate,
    })
end 
Fr.SetDriver = function(plate, charId, jobName)
    if Config.GarageScript == 'op-garages' then 
        MySQL.Async.execute('UPDATE `'.. Fr.Table ..'` SET `jobPrivate` = @owner WHERE plate = @plate',
        {['@owner'] = charId or "", ['@plate'] = plate})
    elseif Config.GarageScript == 'jg-advancedgarages' then
        local jobOwner = getJgJobOwnerId(jobName)

        if charId then
            local license = MySQL.scalar.await(
                'SELECT license FROM players WHERE citizenid = ? LIMIT 1',
                { charId }
            )

            MySQL.Async.execute([[
                UPDATE `]] .. Fr.Table .. [[`
                SET `citizenid` = @owner, `license` = @license, `job_vehicle` = 0
                WHERE plate = @plate
            ]], {
                ['@owner'] = charId,
                ['@license'] = license,
                ['@plate'] = plate,
            })
        else
            MySQL.Async.execute([[
                UPDATE `]] .. Fr.Table .. [[`
                SET `citizenid` = @owner, `license` = @owner, `job_vehicle` = 1
                WHERE plate = @plate
            ]], {
                ['@owner'] = jobOwner,
                ['@plate'] = plate,
            })
        end
    else 
        MySQL.Async.execute('UPDATE `'.. Fr.Table ..'` SET `citizenid` = @owner WHERE plate = @plate',
        {['@owner'] = charId, ['@plate'] = plate})
    end
end
Fr.GetPatients = function()
    local query = [[
        SELECT citizenid, charinfo, mdt_image, insuranceDate
        FROM ]].. Fr.usersTable ..[[ LIMIT 8 ]]

    local patientsList = MySQL.query.await(query)
    if not patientsList then patientsList = {} end

    local finalData = {}

    for _, v in pairs(patientsList) do
        local ok, res = compareIsoUtcToNow(v.insuranceDate)
        local insurance = ok and res.relation == "future"
        local patientCharInfo = json.decode(v.charinfo)
        local sex = patientCharInfo.gender == 0 and "m" or "f"

        table.insert(finalData, {
            name = patientCharInfo.firstname,           
            lastname = patientCharInfo.lastname,
            birthday = patientCharInfo.birthdate,
            charId = v.citizenid,
            image = v.mdt_image,
            insuranceDate = v.insuranceDate,
            gender = TranslateIt('gender_' .. tostring(sex)),
            insurance = insurance
        })
    end

    return finalData
end
Fr.GetPatient = function(charId)
    local query = [[
        SELECT
            citizenid,
            charinfo,
            mdt_image,
            insuranceDate
        FROM ]] .. Fr.usersTable .. [[
        WHERE citizenid = ?
        LIMIT 1
    ]]

    local patientsList = MySQL.query.await(query, { charId })
    if #patientsList < 1 then return false end
    local patientData = patientsList[1]

    if not patientData then return false end

    local ok, res = compareIsoUtcToNow(patientData.insuranceDate)
    local insurance = ok and res.relation == "future"
    local patientCharInfo = json.decode(patientData.charinfo)
    local sex = patientCharInfo.gender == 0 and "m" or "f"

    return {
        name = patientCharInfo.firstname,                
        lastname = patientCharInfo.lastname,
        birthday = patientCharInfo.birthdate,
        charId = patientData.citizenid,
        image = patientData.mdt_image,
        insuranceDate = patientData.insuranceDate,
        gender = TranslateIt('gender_' .. tostring(sex)),
        insurance = insurance
    }
end
Fr.SearchPatients = function(search)
    if not search then return {} end

    search = tostring(search):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
    if search == "" then return {} end

    local like = "%" .. string.lower(search) .. "%"

    local query = [[
        SELECT citizenid, charinfo, insuranceDate
        FROM ]] .. Fr.usersTable .. [[
        WHERE
            LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))) LIKE ? OR
            LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))) LIKE ? OR
            LOWER(citizenid) LIKE ?
        LIMIT 8
    ]]

    local patientsList = MySQL.query.await(query, { like, like, like }) or {}
    local finalData = {}

    for _, v in pairs(patientsList) do
        local haveInsurance = false
        local patientCharInfo = json.decode(v.charinfo or "{}") or {}

        if v.insuranceDate then
            local ok, res = compareIsoUtcToNow(v.insuranceDate)
            haveInsurance = ok and res.relation == "future"
        end

        table.insert(finalData, {
            name = patientCharInfo.firstname or "",
            lastname = patientCharInfo.lastname or "",
            uniqueid = v.citizenid or false,
            haveInsurance = haveInsurance
        })
    end

    return finalData
end

Fr.SearchPatientsLong = function(search)
    if not search then return {} end

    search = tostring(search):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
    if search == "" then return {} end

    local like = "%" .. string.lower(search) .. "%"
    local firstNameSearch, lastNameSearch = search:match("^(%S+)%s+(.+)$")

    local query = [[
        SELECT
            citizenid,
            charinfo,
            insuranceDate,
            mdt_image
        FROM ]] .. Fr.usersTable .. [[
        WHERE
            LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))) LIKE ? OR
            LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))) LIKE ? OR
            LOWER(TRIM(CONCAT(
                TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname'))),
                ' ',
                TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))
            ))) LIKE ? OR
            LOWER(TRIM(CONCAT(
                TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))),
                ' ',
                TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))
            ))) LIKE ? OR
            LOWER(citizenid) LIKE ?
    ]]

    local params = { like, like, like, like, like }

    if firstNameSearch and lastNameSearch then
        query = query .. [[
            OR (
                LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))) LIKE ? AND
                LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))) LIKE ?
            ) OR (
                LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))) LIKE ? AND
                LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))) LIKE ?
            )
        ]]

        local firstLike = "%" .. string.lower(firstNameSearch) .. "%"
        local lastLike = "%" .. string.lower(lastNameSearch) .. "%"

        params[#params + 1] = firstLike
        params[#params + 1] = lastLike
        params[#params + 1] = lastLike
        params[#params + 1] = firstLike
    end

    query = query .. [[
        ORDER BY citizenid
        LIMIT 8
    ]]

    local patientsList = MySQL.query.await(query, params) or {}
    local finalData = {}

    for _, v in pairs(patientsList) do
        local haveInsurance = false
        local patientCharInfo = json.decode(v.charinfo or "{}") or {}
        local sex = patientCharInfo.gender == 0 and "m" or "f"

        if v.insuranceDate then
            local ok, res = compareIsoUtcToNow(v.insuranceDate)
            haveInsurance = ok and res.relation == "future"
        end

        table.insert(finalData, {
            name = patientCharInfo.firstname,
            lastname = patientCharInfo.lastname,
            birthday = patientCharInfo.birthdate,
            charId = v.citizenid,
            image = v.mdt_image,
            insuranceDate = v.insuranceDate,
            gender = TranslateIt('gender_' .. tostring(sex)),
            insurance = haveInsurance
        })
    end

    return finalData
end