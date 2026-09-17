ESX = GetResourceState('es_extended') == 'started' and true or false

if not ESX then return end
Framework = exports["es_extended"]:getSharedObject()

Fr.usersTable = "users"
Fr.identificatorTable = "identifier"
Fr.Table = 'owned_vehicles'
Fr.VehProps = 'vehicle'
Fr.OwnerTable = "owner"
Fr.StoredTable = "stored"
Fr.PlayerLoaded = 'esx:playerLoaded'
Fr.DefaultJob = {
    job = "unemployed",
    grade = 0
}

Fr.RegisterServerCallback = function(...)
    return Framework.RegisterServerCallback(...)
end
Fr.GetPlayerFromIdentifier = function(identifier)
    return Framework.GetPlayerFromIdentifier(identifier)
end
Fr.getPlayerFromId = function(...)
    return Framework.GetPlayerFromId(...)
end
Fr.GetMoney = function(xPlayer, account)
    return xPlayer.getAccount(account).money
end
Fr.ManageMoney = function(xPlayer, account, action, amount)
    if action == "add" then
        return xPlayer.addAccountMoney(account, amount)
    else
        return xPlayer.removeAccountMoney(account, amount)
    end
end
Fr.GetIndentifier = function(source)
    local xPlayer = Fr.getPlayerFromId(source)
    if not xPlayer then return nil end
    return xPlayer.identifier
end
Fr.GetPlayerName = function(sourceOrIdentifier)
    local xPlayer = Fr.getPlayerFromId(sourceOrIdentifier)
    local name, lastname

    if xPlayer then
        name = xPlayer.get('firstName')
        lastname = xPlayer.get('lastName')
    else
        local result = MySQL.Sync.fetchAll(
            "SELECT firstname, lastname, identifier FROM users WHERE identifier = @identifier",
            {['@identifier'] = trim(sourceOrIdentifier)}
        )
        if result and result[1] then
            if result[1].firstname and result[1].lastname then
                name = result[1].firstname 
                lastname = result[1].lastname
            else
                name = "Unknown"
                lastname = "Unknown"
            end
        else
            name = "Unknown"
            lastname = "Unknown"
        end
    end

    return {name = name, lastname = lastname}
end
Fr.GetSourceFromPlayerObject = function(xPlayer)
    if xPlayer then
        return xPlayer.source
    else
        return nil
    end
end
Fr.GetPlayerJob = function(xPlayer)
    local job = {
        name = xPlayer.job.name,
        grade = xPlayer.job.grade,
        grade_label = xPlayer.job.grade_label
    }
    return job
end
Fr.GetActiveEmployees = function(cb, jobName)
    local employees = {}
	local xPlayers = Framework.GetExtendedPlayers('job', jobName)
    local Jobs = Framework.GetJobs()

	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]
		local job = xPlayer.getJob()
        local details = getPlayerDetailsInJob(xPlayer.identifier, jobName)

        if details.status ~= "offduty" then
            table.insert(employees, {
                name = xPlayer.get('firstName'),
                source = Fr.GetSourceFromPlayerObject(xPlayer),
                lastname = xPlayer.get('lastName'),
                charId = xPlayer.identifier,
                rankLabel = job.grade_label,
                rankGrade = job.grade,
                onDutyTime = msToHours(getEmployeeDutyTimeMs(xPlayer.identifier, jobName, Fr.GetSourceFromPlayerObject(xPlayer))),
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
	local xPlayers = Framework.GetExtendedPlayers('job', jobName)
    local Jobs = Framework.GetJobs()

	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]
		local job = xPlayer.getJob()
        local details = getPlayerDetailsInJob(xPlayer.identifier, jobName)

		table.insert(employees, {
			name = xPlayer.get('firstName'),
            lastname = xPlayer.get('lastName'),
			charId = xPlayer.identifier,
            rankLabel = job.grade_label,
            rankGrade = job.grade,
            onDutyTime = msToHours(getEmployeeDutyTimeMs(xPlayer.identifier, jobName, Fr.GetSourceFromPlayerObject(xPlayer))),
            avatar = details.avatar,
            callsign = "", -- not used, leave blank
            status = details.status,
            badgeNumber = details.badgeNumber,
		})
	end
		
    local query = "SELECT identifier, job_grade, firstname, lastname FROM `users` WHERE `job`= ? ORDER BY job_grade DESC"

	MySQL.query(query, {jobName},
	function(result)
		for k, row in pairs(result) do
			local alreadyInTable
			local identifier = row.identifier

			for k, v in pairs(employees) do
				if v.charId == identifier then
					alreadyInTable = true
				end
			end

            local rankLabel = "Unknown"

            if Jobs[jobName] and Jobs[jobName].grades and Jobs[jobName].grades[tostring(row.job_grade)] then
                rankLabel = Jobs[jobName].grades[tostring(row.job_grade)].label
            end

			if not alreadyInTable then
                local details = getPlayerDetailsInJob(identifier, jobName)
				table.insert(employees, {
                    name = row.firstname,
                    lastname = row.lastname ,
                    charId = identifier,
                    rankLabel = rankLabel,
                    rankGrade = row.job_grade,
                    onDutyTime = msToHours(getEmployeeDutyTimeMs(identifier, jobName)),
                    avatar = details?.avatar,
                    callsign = "", -- not used, leave blank
                    status = details?.status,
                    badgeNumber = details?.badgeNumber,
				})
			end
		end

		cb(employees)
	end)
end

Fr.SetJob = function(xPlayer, jobName, jobGrade)
    if not xPlayer then return end
    xPlayer.setJob(jobName, tonumber(jobGrade), false)
end

Fr.GetJobData = function(jobName)
    local Jobs = Framework.GetJobs()
    if not Jobs[jobName] then return {} end

    local jobTable = {
        name = Jobs[jobName].name,
        label = Jobs[jobName].label,
        grades = {}
    }

    for k, v in pairs(Jobs[jobName].grades) do 
        jobTable.grades[tostring(v.grade)] = {
            name = v.name,
            grade = v.grade,
            label = v.label
        }
    end

    return jobTable
end

Fr.SetOfflineJob = function(charId, jobName, jobGrade)
    MySQL.Async.execute("UPDATE `users` SET `job` = @job, `job_grade` = @job_grade WHERE `identifier` = @identifier", {
        ['@job'] = jobName,
        ['@job_grade'] = jobGrade,
        ['@identifier'] = charId,
    })
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
                    AND `owner` IN (@jobOwner, @jobName)
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
        local props = json.decode(v.vehicle)

        local currentDriver = {
            charId = "",
            name = "",
            lastname = "",
            uniqueid = ""
        }

        if Config.GarageScript == "op-garages" then 
            v.owner = v.jobPrivate
        end

        if v.owner ~= nil and v.owner ~= "" and not isJgJobVehicleOwner(v.owner, jobName) then
            local names = Fr.GetPlayerName(v.owner)
            currentDriver = {
                charId = v.owner,
                name = names.name,
                lastname = names.lastname,
                uniqueid = v.owner
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

    if Config.GarageScript == 'jg-advancedgarages' then
        local jobOwner = getJgJobOwnerId(jobName)

        MySQL.Async.insert([[
            INSERT INTO `owned_vehicles`
            (`owner`, `plate`, `vehicle`, `job`, `configName`, `job_vehicle`, `job_vehicle_rank`)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ]], {
            jobOwner,
            plate,
            mods or json.encode({ model = readyModel, plate = plate }),
            jobName,
            model,
            1,
            0,
        }, function(insertId)
            if not insertId then
                print(("[^1ERROR^7] Failed to insert vehicle with plate %s into owned_vehicles"):format(plate))
            else
                local insertInfo = ("[^2INFO^7] Inserted vehicle into owned_vehicles. ID: %s, Plate: %s"):format(insertId, plate)
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
        INSERT INTO `owned_vehicles`
        (`owner`, `plate`, `vehicle`, `job`, `configName`)
        VALUES (?, ?, ?, ?, ?)
    ]], {
        nil,
        plate,
        mods or json.encode({ model = readyModel, plate = plate }),
        jobName,
        model
    }, function(insertId)
        if not insertId then
            print(("[^1ERROR^7] Failed to insert vehicle with plate %s into owned_vehicles"):format(plate))
        else
            local insertInfo = ("[^2INFO^7] Inserted vehicle into owned_vehicles. ID: %s, Plate: %s"):format(insertId, plate)
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
    
    MySQL.scalar('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate},
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

        MySQL.Async.execute([[
            UPDATE `]] .. Fr.Table .. [[`
            SET `owner` = @owner, `job_vehicle` = @job_vehicle
            WHERE plate = @plate
        ]], {
            ['@owner'] = charId or jobOwner,
            ['@plate'] = plate,
            ['@job_vehicle'] = charId and 0 or 1,
        })
    else 
        MySQL.Async.execute('UPDATE `'.. Fr.Table ..'` SET `owner` = @owner WHERE plate = @plate',
        {['@owner'] = charId, ['@plate'] = plate})
    end
end

Fr.GetPatients = function()
    local query = [[
        SELECT identifier, dateofbirth, firstname, lastname, mdt_image, insuranceDate, sex
        FROM ]].. Fr.usersTable ..[[ LIMIT 8 ]]

    local patientsList = MySQL.query.await(query)
    if not patientsList then patientsList = {} end

    local finalData = {}

    for _, v in pairs(patientsList) do
        local ok, res = compareIsoUtcToNow(v.insuranceDate)
        local insurance = ok and res.relation == "future"

        table.insert(finalData, {
            name = v.firstname,                
            lastname = v.lastname,
            birthday = v.dateofbirth,
            charId = v.identifier,
            image = v.mdt_image,
            insuranceDate = v.insuranceDate,
            gender = TranslateIt('gender_' .. tostring(v.sex)),
            insurance = insurance
        })
    end

    return finalData
end

Fr.GetPatient = function(charId)
    local query = [[
        SELECT
            identifier,
            dateofbirth,
            firstname,
            lastname,
            mdt_image,
            insuranceDate,
            sex
        FROM ]] .. Fr.usersTable .. [[
        WHERE identifier = ?
        LIMIT 1
    ]]

    local patientsList = MySQL.query.await(query, { charId })
    if #patientsList < 1 then return false end
    local patientData = patientsList[1]

    if not patientData then return false end

    local ok, res = compareIsoUtcToNow(patientData.insuranceDate)
    local insurance = ok and res.relation == "future"

    return {
        name = patientData.firstname,                
        lastname = patientData.lastname,
        birthday = patientData.dateofbirth,
        charId = patientData.identifier,
        image = patientData.mdt_image,
        insuranceDate = patientData.insuranceDate,
        gender = TranslateIt('gender_' .. tostring(patientData.sex)),
        insurance = insurance
    }
end

Fr.SearchPatients = function(search)
    if not search or search == "" then return {} end

    local like = "%" .. search .. "%"

    local query = [[
        SELECT identifier, firstname, lastname, insuranceDate
        FROM ]] .. Fr.usersTable .. [[
        WHERE
            firstname LIKE ? OR
            lastname LIKE ? OR
            identifier LIKE ?
        LIMIT 8
    ]]

    local patientsList = MySQL.query.await(query, {
        like, like, like
    })

    if not patientsList then patientsList = {} end

    local finalData = {}

    for _, v in pairs(patientsList) do
        local haveInsurance = false

        if v.insuranceDate then
            local ok, res = compareIsoUtcToNow(v.insuranceDate)
            haveInsurance = ok and res.relation == "future"
        end

        table.insert(finalData, {
            name = v.firstname or "",
            lastname = v.lastname or "",
            uniqueid = v.identifier or false,
            haveInsurance = haveInsurance
        })
    end

    return finalData
end

Fr.SearchPatientsLong = function(search)
    if not search then return {} end

    search = tostring(search):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
    if search == "" then return {} end

    local like = "%" .. search .. "%"
    local firstNameSearch, lastNameSearch = search:match("^(%S+)%s+(.+)$")

    local query = [[
        SELECT 
            identifier,
            firstname,
            lastname,
            insuranceDate,
            dateofbirth,
            sex,
            mdt_image
        FROM ]] .. Fr.usersTable .. [[
        WHERE
            firstname LIKE ? OR
            lastname LIKE ? OR
            CONCAT(firstname, ' ', lastname) LIKE ? OR
            CONCAT(lastname, ' ', firstname) LIKE ? OR
            identifier LIKE ?
    ]]

    local params = { like, like, like, like, like }

    if firstNameSearch and lastNameSearch then
        query = query .. [[
            OR (
                firstname LIKE ? AND
                lastname LIKE ?
            ) OR (
                firstname LIKE ? AND
                lastname LIKE ?
            )
        ]]

        local firstLike = "%" .. firstNameSearch .. "%"
        local lastLike = "%" .. lastNameSearch .. "%"

        params[#params + 1] = firstLike
        params[#params + 1] = lastLike
        params[#params + 1] = lastLike
        params[#params + 1] = firstLike
    end

    query = query .. [[
        ORDER BY identifier
        LIMIT 8
    ]]

    local patientsList = MySQL.query.await(query, params) or {}
    local finalData = {}

    for _, v in pairs(patientsList) do
        local haveInsurance = false

        if v.insuranceDate then
            local ok, res = compareIsoUtcToNow(v.insuranceDate)
            haveInsurance = ok and res.relation == "future"
        end

        table.insert(finalData, {
            name = v.firstname,
            lastname = v.lastname,
            birthday = v.dateofbirth,
            charId = v.identifier,
            image = v.mdt_image,
            insuranceDate = v.insuranceDate,
            gender = TranslateIt('gender_' .. tostring(v.sex)),
            insurance = haveInsurance
        })
    end

    return finalData
end