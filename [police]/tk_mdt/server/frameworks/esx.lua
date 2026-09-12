if Config.Framework ~= 'esx' then return end

ESX = exports["es_extended"]:getSharedObject()

RegisterCallback = ESX.RegisterServerCallback
CreateUsableItem = ESX.RegisterUsableItem

function ShowNotification(src, text, notifyType)
    TriggerClientEvent('esx:showNotification', src, text)
end

function GetPlayerFromId(playerId)
    return ESX.GetPlayerFromId(playerId)
end

function GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function GetSource(xPlayer)
    if type(xPlayer) == 'number' then
        xPlayer = GetPlayerFromId(xPlayer)
    end

    return xPlayer.source
end

function GetIdentifier(xPlayer)
    if type(xPlayer) == 'number' then
        xPlayer = GetPlayerFromId(xPlayer)
    end

    return xPlayer.identifier
end

function GetCurrentPlayers()
    return ESX.GetPlayers()
end

function IsAdmin(playerId)
    local xPlayer = GetPlayerFromId(playerId)
    return Config.AdminGroups[xPlayer.getGroup()]
end

function GetCharName(identifier)
    local xTarget = GetPlayerFromIdentifier(identifier)
    if xTarget then return xTarget.getName() end

	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users where identifier = ?', {identifier})
    local name = ('%s %s'):format(result?[1]?.firstname, result?[1]?.lastname)

    return name
end

function IsOnDuty(xPlayer)
    return true
end

function GetJob(xPlayer)
    return xPlayer.job
end

function GetJobName(xPlayer)
    return xPlayer.job.name
end

function GetGradeId(xPlayer)
    return xPlayer.job.grade
end

function SetJob(xPlayer, job, grade)
    xPlayer.setJob(job, grade)
end

function GetAccountMoney(xPlayer, account)
    return xPlayer.getAccount(account).money
end

function AddAccountMoney(xPlayer, account, amount)
    xPlayer.addAccountMoney(account, amount)
end

function RemoveAccountMoney(xPlayer, account, amount)
    xPlayer.removeAccountMoney(account, amount)
end

function GetItemAmount(xPlayer, item)
    if Config.Inventory == 'default' and string.upper(string.sub(item, 0, 7)) == 'WEAPON_' then
        local has = xPlayer.getWeapon(item)
        return has
    end

    local xItem = xPlayer.getInventoryItem(item)
    return xItem?.count or xItem?.amount or 0
end

function AddItem(xPlayer, item, amount, metadata)
    if Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(GetSource(xPlayer), item, amount, metadata)
        return
    end

    if Config.Inventory == 'default' and string.upper(string.sub(item, 0, 7)) == 'WEAPON_' then
        xPlayer.addWeapon(item, amount)
        return
    end

    xPlayer.addInventoryItem(item, amount)
end

function RemoveItem(xPlayer, item, amount)
    if Config.Inventory == 'default' and string.upper(string.sub(item, 0, 7)) == 'WEAPON_' then
        xPlayer.removeWeapon(item, amount)
        return
    end

    xPlayer.removeInventoryItem(item, amount)
end

function GetItemLabel(item)
    if Config.Inventory == 'default' and string.upper(string.sub(item, 0, 7)) == 'WEAPON_' then
        return ESX.GetWeaponLabel(item) or item
    end

    return ESX.GetItemLabel(item) or item
end

function GetGradeLabels()
    local data = MySQL.Sync.fetchAll([[
        SELECT
            job_name,
            grade,
            label
        FROM
            job_grades
    ]])

    local labels = {}

    for _,v in pairs(data) do
        if not v.job_name then goto skip end

        if not labels[v.job_name] then
            labels[v.job_name] = {}
        end

        labels[v.job_name][v.grade] = v.label

        ::skip::
    end

    return labels
end

function GetJobLabels()
    local data = MySQL.Sync.fetchAll([[
        SELECT
            name,
            label
        FROM
            jobs
    ]])

    local labels = {}
    for _,v in ipairs(data) do
        labels[v.name] = v.label
    end

    return labels
end

local gradeLabels = GetGradeLabels()
local jobLabels = GetJobLabels()

function GetJobLabelsByPage(page)
    local labels = {}

    if type(Config.MDTs[page].jobs) ~= 'table' then return labels end

    for job in pairs(Config.MDTs[page].jobs) do
        if jobLabels[job] then
            labels[job] = jobLabels[job]
        end
    end

    return labels
end

function GetGradeLabelsByPage(page)
    local labels = {}

    if type(Config.MDTs[page].jobs) ~= 'table' then return labels end

    for job in pairs(Config.MDTs[page].jobs) do
        if gradeLabels[job] then
            labels[job] = gradeLabels[job]
        end
    end

    return labels
end

function GetGradeLabel(job, grade)
    return gradeLabels?[job]?[grade]
end

function GetGrades()
    local grades = {}

    for job,data in pairs(gradeLabels) do
        for gradeId in pairs(data) do
            grades[#grades+1] = {job = job, id = gradeId, jobLabel = jobLabels[job], gradeLabel = gradeLabels[job][gradeId]}
        end
    end

    return grades
end

local function GetIndexByValue(table, valueName, value)
    for k,v in pairs(table) do
        if v[valueName] == value then
            return k
        end
    end

    return #table + 1
end

function GetProfiles()
    local data = MySQL.Sync.fetchAll([[
        SELECT
            identifier,
            image,
            tags,
            page
        FROM
            tk_mdt_profiles
    ]])

    local pageData = {}

    for _,v in pairs(data) do
        if not v.page then goto skip end

        pageData[v.page] = pageData[v.page] or {}
        pageData[v.page][#pageData[v.page]+1] = {
            identifier = v.identifier,
            image = v.image,
            sideBarData = {
                tags = json.decode(v.tags) or {},
            }
        }

        ::skip::
    end

    local batchSize = 500
    local offset = 0
    local keepFetching = true

    local profiles = {}

    while keepFetching do
        local result = MySQL.Sync.fetchAll([[
            SELECT
                identifier,
                CONCAT(firstname, ' ', lastname) AS name,
                dateofbirth as dob
            FROM
                users
            LIMIT ? OFFSET ?
        ]], {batchSize, offset})

        for _, profile in ipairs(result) do
            if type(profile.name) == 'string' and string.len(profile.name) > 1 then
                profiles[#profiles+1] = profile
            end
        end

        offset = offset + batchSize
        keepFetching = #result == batchSize

        Wait(10)
    end

    local profilePages = {}
    for page,v in pairs(Config.MDTs) do
        for _,v2 in pairs(v.pages) do
            if v2.name == 'profiles' then
                profilePages[#profilePages+1] = page
            end
        end
    end

    for _,profile in pairs(profiles) do
        for _,page in pairs(profilePages) do
            local warrants = GetWarrantsByIdentifier(profile.identifier, page)

            pageData[page] = pageData[page] or {}
            local index = GetIndexByValue(pageData[page], 'identifier', profile.identifier)

            pageData[page][index] = pageData[page][index] or {identifier = profile.identifier}
            pageData[page][index].sideBarData = pageData[page][index].sideBarData or {}
            pageData[page][index].sideBarData.warrants = warrants
        end
    end

    return profiles, pageData
end

function GetEmployees()
    local jobs = {}
    for _,data in pairs(Config.MDTs) do
        if type(data.jobs) == 'table' then
            for job in pairs(data.jobs) do
                jobs[#jobs+1] = job
            end
        end
    end

    local data = MySQL.Sync.fetchAll([[
        SELECT
            identifier,
            image,
            callsign,
            status,
            licenses,
            notes,
            page
        FROM
            tk_mdt_employees
    ]])

    local pageData = {}

    for _,v in pairs(data) do
        if not v.page or not Config.MDTs[v.page] then goto skip end

        pageData[#pageData+1] = {
            identifier = v.identifier,
            image = v.image,
            callsign = v.callsign,
            status = v.status or Config.MDTs[v.page].statuses?[1],
            licenses = json.decode(v.licenses) or {},
            notes = v.notes,
            page = v.page,
        }

        ::skip::
    end

    local employees = MySQL.Sync.fetchAll([[
        SELECT
            identifier,
            CONCAT(firstname, ' ', lastname) AS name,
            job,
            job_grade as gradeNumber
        FROM
            users
        WHERE
            job IN (?)
    ]], {jobs})

    for _,v in pairs(employees) do
        v.phoneNumber = GetPhoneNumber(v.identifier)
        v.grade = v.job and v.gradeNumber and gradeLabels[v.job]?[v.gradeNumber] or _U('unknown')
    end

    return employees, pageData
end

function GetVehicles()
    local data = MySQL.Sync.fetchAll([[
        SELECT
            plate,
            image,
            tags,
            page
        FROM
            tk_mdt_vehicles
    ]])

    local pageData = {}

    for _,v in ipairs(data) do
        pageData[v.page] = pageData[v.page] or {}
        pageData[v.page][v.plate] = {
            plate = v.plate,
            image = v.image,
            sideBarData = {
                tags = json.decode(v.tags) or {},
            }
        }
    end

    local vehicles = MySQL.Sync.fetchAll([[
        SELECT
            owned_vehicles.plate,
            JSON_EXTRACT(vehicle, '$.model') AS model,
            CONCAT(users.firstname, ' ', users.lastname) AS owner
        FROM
            owned_vehicles
        LEFT JOIN
            users ON BINARY owned_vehicles.owner = BINARY users.identifier
    ]])

    local vehiclePages = {}
    for page,v in pairs(Config.MDTs) do
        for _,v2 in pairs(v.pages) do
            if v2.name == 'vehicles' then
                vehiclePages[#vehiclePages+1] = page
            end
        end
    end

    for _,vehicle in pairs(vehicles) do
        if not vehicle.model then goto skip end

        for _,page in pairs(vehiclePages) do
            pageData[page] = pageData[page] or {}
            pageData[page][vehicle.plate] = pageData[page][vehicle.plate] or {plate = vehicle.plate}
            pageData[page][vehicle.plate].sideBarData = pageData[page][vehicle.plate].sideBarData or {}
            pageData[page][vehicle.plate].sideBarData.bolos = GetBOLOsByPlate(vehicle.plate, page)
        end

        ::skip::
    end

    return vehicles, pageData
end

function GetBusinesses()
    local data = MySQL.Sync.fetchAll([[
        SELECT
            name,
            image,
            page
        FROM
            tk_mdt_businesses
    ]])

    local pageData = {}

    for _,v in pairs(data) do
        pageData[v.page] = pageData[v.page] or {}
        pageData[v.page][#pageData[v.page]+1] = {
            name = v.name,
            image = v.image,
            sideBarData = {
                employees = GetEmployeesByBusiness(v.name),
                tags = json.decode(v.tags) or {},
            }
        }
    end

    local businesses = MySQL.Sync.fetchAll(string.format([[
        SELECT
            name,
            label
        FROM
            jobs
        WHERE
            name NOT IN ('%s')
    ]], table.concat(Config.ExcludedBusinesses, "','")))

    return businesses, pageData
end

function GetVehiclesByIdentifier(identifier)
    local data = MySQL.Sync.fetchAll([[
        SELECT
            plate,
            JSON_EXTRACT(vehicle, '$.model') AS model
        FROM
            owned_vehicles
        WHERE
            owner = ?
    ]], {identifier})

    return data
end

function GetLicenses(identifier)
    local licenses = {}
    local data = MySQL.Sync.fetchAll('SELECT type FROM user_licenses WHERE owner = ?', {identifier})

    for _,v in pairs(data) do
        local label = MySQL.Sync.fetchScalar('SELECT label FROM licenses WHERE type = ?', {v.type})
        if label then
            licenses[#licenses+1] = label
        end
    end

    return licenses
end

function GetProfileData(identifier, page)
    local profileData = MySQL.Sync.fetchAll([[
        SELECT
            sex as gender,
            job,
            job_grade
        FROM
            users
        WHERE
            identifier = ?
    ]], {identifier})

    local mdtData = MySQL.Sync.fetchAll([[
        SELECT
            notes,
            tags,
            photos,
            licenses,
            linkedProfiles
        FROM
            tk_mdt_profiles
        WHERE
            identifier = ? AND page = ?
    ]], {identifier, page})

    local profile = profileData[1]
    if not profile then return {} end

    if mdtData[1] then
        for k,v in pairs(mdtData[1]) do
            profile[k] = v
        end
    end

    if not next(profile) then return {} end

    profile.phoneNumber = GetPhoneNumber(identifier)
    profile.gender = profile.gender == 'm' and 'male' or profile.gender == 'f' and 'female' or 'unknown'
    profile.jobs = profile.job and jobLabels[profile.job] and {('%s - %s'):format(jobLabels[profile.job], gradeLabels[profile.job][profile.job_grade])} or {'Unemployed'}
    profile.charges = GetChargesByIdentifier(identifier, page)
    profile.warrants = GetWarrantsByIdentifier(identifier, page)
    profile.points = Config.LicensePointsDuration and GetLicensePointsByIdentifier(identifier)
    profile.properties = GetPropertiesByIdentifier(identifier)
    profile.vehicles = GetVehiclesByIdentifier(identifier)
    profile.weapons = GetWeaponsByIdentifier(identifier)
    profile.linkedIncidents = GetIncidentsByIdentifier(identifier)
    profile.linkedReports = GetReportsByIdentifier(identifier)

    if Config.License == 'esx' then
        profile.licenses = GetLicenses(identifier) or {}
    end

    return profile
end

function GetVehicle(plate, page)
    local ownedVehiclesQuery = [[
        SELECT
            JSON_EXTRACT(vehicle, '$.primaryColor') AS customColor,
            JSON_EXTRACT(vehicle, '$.color1') AS color
    ]]

    if HasColumn('owned_vehicles', 'garage') then
        ownedVehiclesQuery = ownedVehiclesQuery .. ', garage'
    end

    ownedVehiclesQuery = ownedVehiclesQuery .. [[
        FROM
            owned_vehicles
        WHERE
            owned_vehicles.plate = ?
    ]]

    local mdtVehicleQuery = [[
        SELECT
            notes,
            tags,
            photos
        FROM
            tk_mdt_vehicles
        WHERE
            tk_mdt_vehicles.plate = ? AND tk_mdt_vehicles.page = ?
    ]]

    local ownedVehicleData = MySQL.Sync.fetchAll(ownedVehiclesQuery, {plate})
    local mdtVehicleData = MySQL.Sync.fetchAll(mdtVehicleQuery, {plate, page})

    local vehicle = ownedVehicleData[1]
    if vehicle and mdtVehicleData[1] then
        vehicle.notes = mdtVehicleData[1].notes
        vehicle.tags = mdtVehicleData[1].tags
        vehicle.photos = mdtVehicleData[1].photos
    end
    if not vehicle then return {} end

    vehicle.color = vehicle?.customColor and ColorToName(json.decode(vehicle.customColor)) or Config.Colors[tonumber(vehicle.color)] or _U('unknown')
    vehicle.garage = vehicle?.garage or _U('unknown')
    vehicle.bolos = GetBOLOsByPlate(plate, page)
    vehicle.linkedIncidents = GetIncidentsByPlate(plate)
    vehicle.linkedReports = GetReportsByPlate(plate)

    return vehicle
end

function GetEmployeesByBusiness(name)
    local data = MySQL.Sync.fetchAll([[
        SELECT
            identifier,
            CONCAT(firstname, ' ', lastname) AS name,
            job_grade
        FROM
            users
        WHERE
            users.job = ?
    ]], {name})

    for k,v in pairs(data) do
        local gradeLabel = gradeLabels?[name]?[v.job_grade] or _U('unknown')
        data[k].name = ('%s - %s'):format(v.name, gradeLabel)
        data[k].job_grade = nil
    end

    return data
end

function GetTrainingReports()
    local data = MySQL.Sync.fetchAll([[
        SELECT
            tk_mdt_training_reports.id,
            tk_mdt_training_reports.title,
            tk_mdt_training_reports.trainee,
            tk_mdt_training_reports.date,
            tk_mdt_training_reports.creator,
            tk_mdt_training_reports.page,
            CONCAT(users.firstname, ' ', users.lastname) AS traineeName
        FROM
            tk_mdt_training_reports
        LEFT JOIN
            users ON BINARY tk_mdt_training_reports.trainee = users.identifier
    ]])

    for _,v in pairs(data) do
        v.trainee = v.traineeName
    end

    return data
end

RegisterCallback('tk_mdt:getItemLabel', function(src, cb, item)
	cb(GetItemLabel(item))
end)

RegisterCallback('tk_mdt:getCharName', function(src, cb)
	cb(GetCharName(GetIdentifier(GetPlayerFromId(src))))
end)

RegisterCallback('tk_mdt:getPhoneNumber', function(src, cb)
	cb(GetPhoneNumber(GetIdentifier(GetPlayerFromId(src))))
end)

--[[ RegisterNetEvent('esx_identity:completedRegistration', function(src, data)
    RegisterCharacter(src, {
        name = ('%s %s'):format(data.firstname, data.lastname),
        dob = data.dateofbirth,
    })
end) ]]

RegisterNetEvent('esx:playerLoaded', function (playerId, xPlayer, isNew)
    if not isNew then return end

    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, dateofbirth FROM users WHERE identifier = ?', {xPlayer.identifier})
    if not result?[1] or type(result[1]) ~= 'table' then return end

    local firstName = result[1].firstname
    local lastName = result[1].lastname
    local dob = result[1].dateofbirth

    if type(firstName) ~= 'string' or type(lastName) ~= 'string' or type(dob) ~= 'string' then return end

    RegisterCharacter(playerId, {
        name = ('%s %s'):format(firstName, lastName),
        dob = dob,
    })
end)

CreateThread(function()
    repeat Wait(100) until ESX

    frameworkLoaded = true
end)