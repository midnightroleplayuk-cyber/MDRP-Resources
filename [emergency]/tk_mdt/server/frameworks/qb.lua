if Config.Framework ~= 'qb' then return end

QBCore = exports['qb-core']:GetCoreObject()

RegisterCallback = QBCore.Functions.CreateCallback
CreateUsableItem = QBCore.Functions.CreateUseableItem

function ShowNotification(src, text, notifyType)
    if notifyType == 'inform' then notifyType = 'primary' end
    TriggerClientEvent('QBCore:Notify', src, text, notifyType)
end

function GetPlayerFromId(playerId)
    return QBCore.Functions.GetPlayer(playerId)
end

function GetPlayerFromIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end

function GetSource(player)
    if type(player) == 'number' then
        player = GetPlayerFromId(player)
    end

    return player.PlayerData.source
end

function GetIdentifier(player)
    if type(player) == 'number' then
        player = GetPlayerFromId(player)
    end

    return player.PlayerData.citizenid
end

function GetCurrentPlayers()
    return QBCore.Functions.GetQBPlayers()
end

function IsAdmin(playerId)
    for k in pairs(Config.AdminGroups) do
        if QBCore.Functions.HasPermission(playerId, k) then
            return true
        end
    end

    return
end

function GetCharName(identifier)
    local targetPlayer = GetPlayerFromIdentifier(identifier)
    if targetPlayer then
        local name = ('%s %s'):format(targetPlayer.PlayerData.charinfo.firstname, targetPlayer.PlayerData.charinfo.lastname)
        return name
    end

	local result = MySQL.Sync.fetchAll('SELECT charinfo FROM players where citizenid = ?', {identifier})
    local charinfo = json.decode(result?[1]?.charinfo)
    local name = ('%s %s'):format(charinfo?.firstname, charinfo?.lastname)

    return name
end

function IsOnDuty(player)
    return true --player.PlayerData.job.onduty
end

function GetJob(player)
    return player.PlayerData.job
end

function GetJobName(player)
    return player.PlayerData.job.name
end

function GetGradeId(player)
    return player.PlayerData.job.grade.level
end

function SetJob(player, job, grade)
    player.Functions.SetJob(job, grade)
end

function GetAccountMoney(player, account)
    if account == 'money' then account = 'cash' end
    return player.Functions.GetMoney(account)
end

function AddAccountMoney(player, account, amount)
    if account == 'money' then account = 'cash' end
    player.Functions.AddMoney(account, amount)
end

function RemoveAccountMoney(player, account, amount)
    if account == 'money' then account = 'cash' end
    player.Functions.RemoveMoney(account, amount)
end

function GetItemAmount(player, item)
    if item == 'money' then
        return GetAccountMoney(player, item)
    end

    local invItem = player.Functions.GetItemByName(item)
    return invItem?.amount or invItem?.count or 0
end

function AddItem(player, item, amount, metadata)
    if item == 'money' then
        return AddAccountMoney(player, item, amount)
    end

    if Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(GetSource(player), item, amount, metadata)
        return
    end

    player.Functions.AddItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item], 'add')
end

function RemoveItem(player, item, amount)
    if item == 'money' then
        return RemoveAccountMoney(player, item, amount)
    end

    player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item], 'remove')
end

function GetItemLabel(item)
    return QBCore.Shared.Items?[string.lower(item)]?.label or item
end

function GetGradeLabels()
    local labels = {}

    for job,data in pairs(QBCore.Shared.Jobs) do
        if type(data?.grades) == 'table' then
            for gradeId,gradeData in pairs(data.grades) do
                if not labels[job] then labels[job] = {} end
                gradeId = tonumber(gradeId)
                if gradeId then
                    labels[job][gradeId] = gradeData.name
                end
            end
        end
    end

    return labels
end

function GetJobLabels()
    local labels = {}
    for job,data in pairs(QBCore.Shared.Jobs) do
        labels[job] = data.label
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

    local profiles = MySQL.Sync.fetchAll([[
        SELECT
            citizenid as identifier,
            CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ', JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) AS name,
            JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.birthdate')) AS dob,
            JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.fingerprint')) AS fingerprint
        FROM
            players
    ]])

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
            citizenid as identifier,
            CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ', JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) AS name,
            JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) AS job,
            JSON_UNQUOTE(JSON_EXTRACT(job, '$.grade.level')) AS gradeNumber
        FROM
            players
        WHERE
            JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) IN (?)
    ]], {jobs})

    for _,v in pairs(employees) do
        v.phoneNumber = GetPhoneNumber(v.identifier)
        v.gradeNumber = tonumber(v.gradeNumber)
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
            player_vehicles.plate,
            hash AS model,
            CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ', JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) AS owner
        FROM
            player_vehicles
        LEFT JOIN
            players ON BINARY player_vehicles.citizenid = BINARY players.citizenid
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
        for _,page in pairs(vehiclePages) do
            pageData[page] = pageData[page] or {}
            pageData[page][vehicle.plate] = pageData[page][vehicle.plate] or {plate = vehicle.plate}
            pageData[page][vehicle.plate].sideBarData = pageData[page][vehicle.plate].sideBarData or {}
            pageData[page][vehicle.plate].sideBarData.bolos = GetBOLOsByPlate(vehicle.plate, page)
        end
    end

    return vehicles, pageData
end

local function IsExcludedBusiness(name)
    for _,v in pairs(Config.ExcludedBusinesses) do
        if name == v then
            return true
        end
    end

    return
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

    local businesses = {}
    for k,v in pairs(QBCore.Shared.Jobs) do
        if not IsExcludedBusiness(k) then
            businesses[#businesses+1] = {name = k, label = v.label}
        end
    end

    return businesses, pageData
end

function GetVehiclesByIdentifier(identifier)
    local data = MySQL.Sync.fetchAll([[
        SELECT
            plate,
            hash AS model
        FROM
            player_vehicles
        WHERE
            citizenid = ?
    ]], {identifier})

    return data
end

function GetLicenses(identifier)
    local licenses = {}
    local data = MySQL.Sync.fetchScalar("SELECT JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.licences')) FROM players WHERE citizenid = ?", {identifier})
    data = data and json.decode(data) or {}

    for k,v in pairs(data) do
        if v and Config.Licenses[k] then
            licenses[#licenses+1] = Config.Licenses[k]
        end
    end

    return licenses
end

function GetProfileData(identifier, page)
    local profileData = MySQL.Sync.fetchAll([[
        SELECT
            JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.gender')) AS gender,
            JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) AS job,
            JSON_UNQUOTE(JSON_EXTRACT(job, '$.grade.level')) AS job_grade,
            JSON_UNQUOTE(JSON_EXTRACT(metadata, '$.bloodtype')) AS bloodType
        FROM
            players
        WHERE
            players.citizenid = ?
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

    local profile = profileData[1] or {}
    if not profile then return {} end

    if mdtData[1] then
        for k,v in pairs(mdtData[1]) do
            profile[k] = v
        end
    end

    if not next(profile) then return {} end

    profile.gender = profile.gender == '0' and 'male' or profile.gender == '1' and 'female' or 'unknown'
    profile.phoneNumber = GetPhoneNumber(identifier)
    local grade = tonumber(profile.job_grade)
    profile.jobs = profile.job and {('%s - %s'):format(jobLabels[profile.job], gradeLabels[profile.job][grade] or gradeLabels[profile.job][tostring(grade)])} or {_U('unemployed')}
    profile.charges = GetChargesByIdentifier(identifier, page)
    profile.warrants = GetWarrantsByIdentifier(identifier, page)
    profile.points = Config.LicensePointsDuration and GetLicensePointsByIdentifier(identifier)
    profile.properties = GetPropertiesByIdentifier(identifier)
    profile.vehicles = GetVehiclesByIdentifier(identifier)
    profile.weapons = GetWeaponsByIdentifier(identifier)
    profile.linkedIncidents = GetIncidentsByIdentifier(identifier)
    profile.linkedReports = GetReportsByIdentifier(identifier)

    if Config.License == 'qb' then
        profile.licenses = GetLicenses(identifier) or {}
    end

    return profile
end

function GetVehicle(plate, page)
    local ownedVehicleData = MySQL.Sync.fetchAll([[
        SELECT
            garage,
            JSON_EXTRACT(mods, '$.primaryColor') AS customColor,
            JSON_EXTRACT(mods, '$.color1') AS color
        FROM
            player_vehicles
        WHERE
            plate = ?
    ]], {plate})

    local mdtVehicleData = MySQL.Sync.fetchAll([[
        SELECT
            notes,
            tags,
            photos
        FROM
            tk_mdt_vehicles
        WHERE
            plate = ? AND page = ?
    ]], {plate, page})

    local vehicle = ownedVehicleData[1] or {}
    if mdtVehicleData[1] then
        vehicle.notes = mdtVehicleData[1].notes
        vehicle.tags = mdtVehicleData[1].tags
        vehicle.photos = mdtVehicleData[1].photos
    end
    vehicle.color = vehicle.customColor and ColorToName(json.decode(vehicle.customColor)) or Config.Colors[tonumber(vehicle.color)] or _U('unknown')
    vehicle.garage = vehicle.garage or _U('unknown')
    vehicle.bolos = GetBOLOsByPlate(plate, page)
    vehicle.linkedIncidents = GetIncidentsByPlate(plate)
    vehicle.linkedReports = GetReportsByPlate(plate)

    return vehicle
end

function GetEmployeesByBusiness(name)
    local likePattern = '%' .. name .. '%'
    local data = MySQL.Sync.fetchAll([[
        SELECT
            citizenid as identifier,
            CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ', JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) AS name,
            JSON_UNQUOTE(JSON_EXTRACT(job, '$.grade.level')) AS job_grade
        FROM
            players
        WHERE
            job LIKE ?
    ]], {likePattern})

    for k,v in pairs(data) do
        local grade = tonumber(v.job_grade)
        data[k].name = ('%s - %s'):format(v.name, gradeLabels[name][grade] or _U('unknown'))
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
                CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ', JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) AS name
            FROM
                tk_mdt_training_reports
            LEFT JOIN
                players ON BINARY tk_mdt_training_reports.trainee = players.citizenid
    ]])

    for _,v in pairs(data) do
        v.trainee = v.traineeName
    end

    return data
end

RegisterCallback('tk_mdt:getCharName', function(src, cb)
	cb(GetCharName(GetIdentifier(GetPlayerFromId(src))))
end)

RegisterCallback('tk_mdt:getPhoneNumber', function(src, cb)
	cb(GetPhoneNumber(GetIdentifier(GetPlayerFromId(src))))
end)

--[[ RegisterNetEvent('qb-multicharacter:server:createCharacter', function(data)
    if type(data) ~= 'table' then return end

    local src = source
    RegisterCharacter(src, {
        name = ('%s %s'):format(data.firstname, data.lastname),
        dob = data.birthdate,
    })
end) ]]

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local xPlayer = GetPlayerFromId(src)
    local timeout = GetGameTimer() + 10000

    repeat Wait(100) until type(xPlayer) == 'table' or GetGameTimer() > timeout

    local charInfo = xPlayer?.PlayerData?.charinfo
    if type(charInfo) ~= 'table' then return end

    RegisterCharacter(src, {
        name = ('%s %s'):format(charInfo.firstname, charInfo.lastname),
        dob = charInfo.birthdate or charInfo.dateofbirth,
    })
end)

CreateThread(function()
    repeat Wait(100) until QBCore

    frameworkLoaded = true
end)