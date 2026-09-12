function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    else
        ShowNotification(src, text, notifyType)
    end
end

function Webhook(message)
    if not ConfigSV.WebhookLink or ConfigSV.WebhookLink == '' then return end

    local msg = {{["color"] = Config.WebhookColor, ["title"] = "**".. _U('webhook_title') .."**", ["description"] = message, ["footer"] = { ["text"] = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(ConfigSV.WebhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), { ['Content-Type'] = 'application/json' })
end

---Allows you to add additional data to the sidebar, remember to add the table keys to the locales file, also, remember to add they keys to Config.SidebarOrder
---@param id number | string
---@param page string
---@return table<string>|nil
function GetAdditionalSidebarData(id, page)
    if page == 'profile' then
        return {
            --bloodType = {'B-'},
            --pets = {'dog', 'cat'},
        }
    end

    return
end

function BoloCreated(playerId, plate, vehModel, owner, incidentId, title, isReport, date)

end

function BoloRemoved(playerId, plate, vehModel, owner, incidentId, title, isReport, date)

end

function GetPhoneNumber(identifier)
    if Config.Phone == 'lb' then
        local success, phoneNumber = pcall(function()
            return exports["lb-phone"]:GetEquippedPhoneNumber(identifier)
        end)

        return (success and phoneNumber) or _U('unknown')
    elseif Config.Phone == 'qs' then
        local xPlayer = GetPlayerFromIdentifier(identifier)
        if not xPlayer then return _U('unknown') end

        local success, phoneNumber = pcall(function()
            return exports['qs-base']:GetPlayerPhone(GetSource(xPlayer))
        end)
        return (success and phoneNumber) or _U('unknown')
    elseif Config.Phone == 'gks' then
        local exists = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'gksphone_settings'")
        if exists == 0 then return _U('unknown') end

        local phoneNumber = MySQL.Sync.fetchScalar([[
            SELECT
                phone_number
            FROM
                gksphone_settings
            WHERE
                identifier = ?
        ]], {identifier})

        return phoneNumber or _U('unknown')
    elseif Config.Phone == 'gks2' then
        local exists = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'gksphone_settings'")
        if exists == 0 then return _U('unknown') end

        local uniqueID = MySQL.Sync.fetchScalar([[
            SELECT
                unique_id
            FROM
                gksphone_settings
            WHERE
                setup_owner = ?
        ]], {identifier})

        if not uniqueID then
            return _U('unknown')
        end

        local esimExists = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'gksphone_esim'")
        if esimExists == 0 then return _U('unknown') end

        local phoneNumber = MySQL.Sync.fetchScalar([[
            SELECT
                phone_number
            FROM
                gksphone_esim
            WHERE
                phone_id = ? AND is_active = 1
        ]], {uniqueID})

        return phoneNumber or _U('unknown')
    elseif Config.Phone == 'high' then
        local xPlayer = GetPlayerFromIdentifier(identifier)
        if not xPlayer then return _U('unknown') end

        local success, phoneNumber = pcall(function()
            return exports.high_phone:getPlayerPhoneNumber(GetSource(xPlayer))
        end)

        return (success and phoneNumber) or _U('unknown')
    elseif Config.Phone == 'yseries' then
        local success, phoneNumber = pcall(function()
            return exports.yseries:GetPhoneNumberByIdentifier(identifier)
        end)

        return (success and phoneNumber) or _U('unknown')
    elseif Config.Phone == 'okok' then
        local xPlayer = GetPlayerFromIdentifier(identifier)
        if not xPlayer then return _U('unknown') end

        local success, phoneNumber = pcall(function()
            return exports.okokPhone:getPhoneNumberFromSource(GetSource(xPlayer))
        end)

        return (success and phoneNumber) or _U('unknown')
    elseif Config.Framework == 'qb' then
        local success, phoneNumber = pcall(function()
            return MySQL.Sync.fetchScalar([[
                SELECT
                    JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.phone')) AS phone_number
                FROM
                    players
                WHERE
                    citizenid = ?
            ]], {identifier})
        end)
        return (success and phoneNumber) or _U('unknown')
    elseif Config.Framework == 'esx' then
        local columnExists = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'users' AND column_name = 'phone_number'")
        if columnExists == 0 then return _U('unknown') end

        local phoneNumber = MySQL.Sync.fetchScalar([[
            SELECT
                phone_number
            FROM
                users
            WHERE
                identifier = ?
        ]], {identifier})

        return phoneNumber or _U('unknown')
    end

    return _U('unknown')
end

function GetPropertiesByIdentifier(identifier)
    if Config.Housing == 'tk' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id
            FROM
                owned_houses
            WHERE
                owner = ?
        ]], {identifier})

        for _,v in pairs(data) do
            v.name = _U('house')
        end

        return data
    elseif Config.Housing == 'tk_v2' then
        local properties = exports.tk_housing:getPropertiesByIdentifier(identifier)

        for k,v in pairs(properties) do
            properties[k].name = v.name or v.address
        end

        return properties
    elseif Config.Housing == 'rx' then
        local ownedProperties = exports['RxHousing']:GetOwnedProperties(identifier) or {}

        for _, v in pairs(ownedProperties) do
            v.name = v.label
        end

        return ownedProperties
    elseif Config.Housing == 'qb' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id
            FROM
                player_houses
            WHERE
                citizenid = ?
        ]], {identifier})

        for _,v in pairs(data) do
            v.name = _U('house')
        end

        return data
    elseif Config.Housing == 'qbx' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id,
                property_name as name
            FROM
                properties
            WHERE
                owner = ?
        ]], {identifier})

        return data
    elseif Config.Housing == 'ps' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                property_id as id,
                street as name
            FROM
                properties
            WHERE
                owner_citizenid = ?
        ]], {identifier})

        return data
    elseif Config.Housing == 'loaf' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id
            FROM
                loaf_properties
            WHERE
                owner = ?
        ]], {identifier})

        for _,v in pairs(data) do
            v.name = _U('house')
        end

        return data
    elseif Config.Housing == 'qs' then
        local exists = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'houselocations'")
        if exists == 0 then return {} end

        local data = MySQL.Sync.fetchAll([[
            SELECT
                player_houses.id,
                houselocations.label as name
            FROM
                player_houses
            LEFT JOIN
                houselocations ON player_houses.house = houselocations.name
            WHERE
                owner = ?
        ]], {identifier})

        return data
    elseif Config.Housing == 'cylex' then
        local houses = exports.cylex_housing:getOwnedHouses(identifier) or {}

        local data = {}
        for _, v in pairs(houses) do
            data[#data+1] = {id = v.id, name = v.streetName}
        end

        return data
    elseif Config.Housing == 'nolag' then
        local houses = exports.nolag_properties:GetAllProperties(identifier, 'user', true) or {}

        local data = {}
        for _, v in pairs(houses) do
            data[#data+1] = {id = v.id, name = v.label}
        end

        return data
    elseif Config.Housing == 'bcs' then
        local houses = exports.bcs_housing:GetOwnedHomes(identifier) or {}

        local data = {}
        for _, v in pairs(houses) do
            data[#data+1] = { id = v.identifier, name = v.name }
        end

        return data
    elseif Config.Housing == 'vms' then
        local properties = exports['vms_housing']:GetPlayerProperties(identifier) or {}

        local data = {}
        for _, v in pairs(properties) do
            data[#data+1] = {
                id = v.id,
                name = v.name or v.address,
            }
        end

        return data
    end

    return {}
end

function GetProperties(profileData)
    Wait(10000)

    if Config.Housing == 'tk' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id,
                owner,
                coords
            FROM
                owned_houses
            WHERE
                owner IS NOT NULL
        ]])

        for _,v in pairs(data) do
            local c = json.decode(v.coords)
            v.coords = {x = c.enterCoords.x, y = c.enterCoords.y}
            v.owner = v.owner and GetCharName(v.owner)
            v.name = _U('house')
        end

        return data
    elseif Config.Housing == 'tk_v2' then
        local properties = exports.tk_housing:getProperties()

        for k,v in pairs(properties) do
            v.name = v.name or v.address
            v.owner = v.owner and GetCharName(v.owner)
        end

        return properties
    elseif Config.Housing == 'rx' then
        local properties = exports['RxHousing']:GetAllProperties()

        for id, v in pairs(properties) do
            v.name = v.label
            v.owner = v.owner and GetCharName(v.owner)
        end

        return properties
    elseif Config.Housing == 'qb' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id,
                citizenid as owner
            FROM
                player_houses
            WHERE
                citizenid IS NOT NULL
        ]])

        for _,v in pairs(data) do
            v.owner = GetCharName(v.owner)
            v.name = _U('house')
        end

        return data
    elseif Config.Housing == 'qbx' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id,
                owner,
                property_name as name
            FROM
                properties
            WHERE
                owner IS NOT NULL
        ]])

        for _,v in pairs(data) do
            v.owner = GetCharName(v.owner)
        end

        return data
    elseif Config.Housing == 'ps' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                property_id as id,
                street as name,
                owner_citizenid as owner
            FROM
                properties
            WHERE
                owner_citizenid IS NOT NULL
        ]])

        for _,v in pairs(data) do
            v.owner = GetCharName(v.owner)
        end

        return data
    elseif Config.Housing == 'loaf' then
        local data = MySQL.Sync.fetchAll([[
            SELECT
                id,
                owner
            FROM
                loaf_properties
            WHERE
                owner IS NOT NULL
        ]])

        for _,v in pairs(data) do
            v.owner = GetCharName(v.owner)
            v.name = _U('house')
        end

        return data
    elseif Config.Housing == 'qs' then
        local exists = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'houselocations'")
        if exists == 0 then return {} end

        local data = MySQL.Sync.fetchAll([[
            SELECT
                player_houses.id,
                player_houses.citizenid AS owner,
                houselocations.label AS name,
                houselocations.coords
            FROM
                player_houses
            LEFT JOIN
                houselocations ON BINARY player_houses.house = BINARY houselocations.name
            WHERE
                citizenid IS NOT NULL
        ]])

        for _,v in pairs(data) do
            local c = json.decode(v.coords)
            if type(c) == 'table' and c.enter?.x and c.center?.y then
                v.coords = {x = c.enter.x, y = c.enter.y}
            end
            v.owner = GetCharName(v.owner)
        end

        return data
    elseif Config.Housing == 'cylex' then
        local houses = exports.cylex_housing:getHousesData() or {}
        local data = {}

        for _, v in pairs(houses) do
            data[#data+1] = {
                id = v.id,
                name = v.streetName,
                coords = {x = v.enterCoords.x, y = v.enterCoords.y},
                owner = GetCharName(v.owner)
            }
        end

        return data
    elseif Config.Housing == 'nolag' then
        local houses = {}

        for _,profile in pairs(profileData) do
            local data = exports.nolag_properties:GetAllProperties(profile.identifier, 'user') or {}
            for _,v in pairs(data) do
                houses[#houses+1] = {
                    id = v.id,
                    name = v.label,
                    owner = GetCharName(profile.identifier),
                }
            end
        end

        return houses
    elseif Config.Housing == 'bcs' then
        local houses = exports.bcs_housing:GetHomes() or {}
        local data = {}

        for _,v in pairs(houses) do
            data[#data+1] = {
                id = v.identifier,
                name = v.name,
                owner = GetCharName(v.owner),
            }
        end

        return data
    elseif Config.Housing == 'vms' then
        local properties = exports['vms_housing']:GetAllProperties() or {}
        local data = {}

        for _, v in pairs(properties) do
            data[#data+1] = {
                id = v.id,
                name = v.name or v.address,
                owner = GetCharName(v.owner),
            }
        end

        return data
    end

    return {}
end

function GetProperty(id)
    local data = MySQL.Sync.fetchAll([[
        SELECT
            notes,
            tags,
            linkedProfiles,
            photos
        FROM
            tk_mdt_properties
        WHERE
            id = ?
    ]], {id})

    local property = data[1] or {}
    return property
end

local function GetPageByJob(job, grade)
    for page,data in pairs(Config.MDTs) do
        if type(data.jobs) == 'table' and data.jobs[job] and grade >= data.jobs[job] then
            return page
        end
    end

    return
end

function AddEmployee(playerId)
    local xPlayer = GetPlayerFromId(playerId)
    local jobName = GetJobName(xPlayer)
    local grade = GetGradeId(xPlayer)

    local page = GetPageByJob(jobName, grade)
    if not page then return end

    local employeeData = employees[page]
    if not employeeData then return end

    local gradeId = GetGradeId(xPlayer)
    local identifier = GetIdentifier(xPlayer)

    local employeeIndex = GetEmployeeIndexByIdentifier(identifier, employeeData)

    if employeeIndex then
        employeeData[employeeIndex].grade = GetGradeLabel(jobName, gradeId)
        employeeData[employeeIndex].gradeNumber = gradeId
        employeeData[employeeIndex].name = employeeData[employeeIndex].name or GetCharName(identifier)
        employeeData[employeeIndex].job = employeeData[employeeIndex].job or jobName
        employeeData[employeeIndex].phoneNumber = employeeData[employeeIndex].phoneNumber or GetPhoneNumber(identifier)
    else
        employeeIndex = #employeeData + 1
        employeeData[employeeIndex] = {
            identifier = GetIdentifier(xPlayer),
            name = GetCharName(GetIdentifier(xPlayer)),
            job = jobName,
            grade = GetGradeLabel(jobName, gradeId),
            gradeNumber = gradeId,
            callsign = 'N/A',
            phoneNumber = GetPhoneNumber(identifier),
            licenses = {},
            status = '',
            image = '',
            notes = '',
        }
    end

    SyncEmployeeData(playerId)

    local players = jobPlayers[page] or {}
    for i = 1, #players do
        TriggerClientEvent('tk_mdt:addEmployee', players[i], employeeData[employeeIndex])
    end
end

function SaveProfile(data, identifier, page)
    MySQL.Async.execute([[
        INSERT INTO
            tk_mdt_profiles (identifier, image, notes, tags, licenses, linkedProfiles, photos, page)
        VALUES
            (?, ?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            image = VALUES(image),
            notes = VALUES(notes),
            tags = VALUES(tags),
            licenses = VALUES(licenses),
            linkedProfiles = VALUES(linkedProfiles),
            photos = VALUES(photos)
    ]], {
        data.identifier,
        data.image,
        data.notes,
        type(data.sideBarData.tags) == 'table' and json.encode(data.sideBarData.tags) or nil,
        type(data.sideBarData.licenses) == 'table' and json.encode(data.sideBarData.licenses) or nil,
        type(data.sideBarData.linkedProfiles) == 'table' and json.encode(data.sideBarData.linkedProfiles) or nil,
        type(data.sideBarData.photos) == 'table' and json.encode(data.sideBarData.photos) or nil,
        page,
    })

    if Config.License == 'default' or type(data.sideBarData.licenses) ~= 'table' or type(Config.Licenses) ~= 'table' then return end

    local newLicenses = {}
    for _,v in pairs(data.sideBarData.licenses) do
        for name,label in pairs(Config.Licenses) do
            if v == label then
                newLicenses[name] = true
            end
        end
    end

    if Config.License == 'esx' then
        MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = ?', {data.identifier}, function(currentLicenses)
            local currentLicensesSet = {}
            for _,v in pairs(currentLicenses) do
                currentLicensesSet[v.type] = true
            end

            for _,v in pairs(currentLicenses) do
                if not newLicenses[v.type] then
                    MySQL.Sync.execute('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {v.type, data.identifier})
                end
            end

            for k in pairs(newLicenses) do
                if not currentLicensesSet[k] then
                    MySQL.Sync.execute('INSERT IGNORE INTO user_licenses (type, owner) VALUES (?, ?)', {k, data.identifier})
                end
            end
        end)
    elseif Config.License == 'qb' then
        local xPlayer = GetPlayerFromIdentifier(data.identifier)
        if xPlayer then
            xPlayer.Functions.SetMetaData("licences", newLicenses)
        end

        local metadata = json.decode(MySQL.Sync.fetchScalar('SELECT metadata FROM players WHERE citizenid = ?', {data.identifier}))
        metadata.licences = newLicenses

        MySQL.Sync.execute('UPDATE `players` SET `metadata` = ? WHERE citizenid = ?', {json.encode(metadata), data.identifier})
    end
end

function SaveReport(data)
    MySQL.Async.execute([[
        UPDATE
            tk_mdt_reports
        SET
            title = ?,
            content = ?,
            tags = ?,
            employees = ?,
            suspects = ?,
            civilians = ?,
            vehicles = ?,
            evidence = ?,
            weapons = ?,
            linkedIncidents = ?,
            linkedReports = ?,
            linkedPoliceReports = ?,
            photos = ?
        WHERE
            id = ?
    ]], {data.title, data.content, json.encode(data.sideBarData.tags), json.encode(data.sideBarData.employees), json.encode(data.sideBarData.suspects), json.encode(data.sideBarData.civilians), json.encode(data.sideBarData.vehicles), json.encode(data.sideBarData.evidence), json.encode(data.sideBarData.weapons), json.encode(data.sideBarData.linkedIncidents), json.encode(data.sideBarData.linkedReports), json.encode(data.sideBarData.linkedPoliceReports), json.encode(data.sideBarData.photos), data.id})
end

function SaveIncident(data, page)
    MySQL.Async.execute([[
        UPDATE tk_mdt_incidents
        SET
            title = ?,
            content = ?,
            tags = ?,
            employees = ?,
            criminals = ?,
            civilians = ?,
            vehicles = ?,
            evidence = ?,
            weapons = ?,
            linkedIncidents = ?,
            linkedReports = ?,
            linkedPoliceReports = ?,
            photos = ?
        WHERE
            id = ?
    ]], {data.title, data.content, json.encode(data.sideBarData.tags), json.encode(data.sideBarData.employees), json.encode(data.sideBarData.criminals), json.encode(data.sideBarData.civilians), json.encode(data.sideBarData.vehicles), json.encode(data.sideBarData.evidence), json.encode(data.sideBarData.weapons), json.encode(data.sideBarData.linkedIncidents), json.encode(data.sideBarData.linkedReports), json.encode(data.sideBarData.linkedPoliceReports), json.encode(data.sideBarData.photos), data.id})
end

function RemoveIncident(playerId, id)
    MySQL.Sync.execute([[
        DELETE FROM
            tk_mdt_incidents
        WHERE
            id = ?
        LIMIT 1
    ]], {id})
end

function RemoveReport(playerId, id, page)
    MySQL.Sync.execute([[
        DELETE FROM
            tk_mdt_reports
        WHERE
            id = ?
        LIMIT 1
    ]], {id})
end

function RemovePoliceReport(playerId, id)
    MySQL.Sync.execute([[
        DELETE FROM
            tk_mdt_police_reports
        WHERE
            id = ?
        LIMIT 1
    ]], {id})
end

function RemoveTrainingReport(playerId, id, page)
    MySQL.Sync.execute([[
        DELETE FROM
            tk_mdt_training_reports
        WHERE
            id = ?
        LIMIT 1
    ]], {id})
end

function RemoveEvidence(playerId, id)
    MySQL.Sync.execute([[
        DELETE FROM
            tk_mdt_evidence
        WHERE
            id = ?
        LIMIT 1
    ]], {id})
end

function RemoveWeapon(playerId, id)
    MySQL.Sync.execute([[
        DELETE FROM
            tk_mdt_weapons
        WHERE
            id = ?
        LIMIT 1
    ]], {id})
end

RegisterNetEvent('tk_mdt:jailPlayer', function(data)
    local src = source
    local xPlayer = GetPlayerFromId(src)
    local job = GetJobName(xPlayer)
    if not Config.MDTs.police.jobs[job] then return end

    local xTarget = GetPlayerFromIdentifier(data.targetIdentifier)
    if not xTarget then return end

    local targetId = GetSource(xTarget)
    if Config.Jail == 'pickle' then
        exports.pickle_prisons:JailPlayer(targetId, data.time, 'default')
    elseif Config.Jail == 'xt' then
        lib.callback.await('xt-prison:client:enterJail', targetId, data.time)
    end
end)

if Config.Dispatch == 'tk' then
    RegisterServerEvent('tk_dispatch:addCall', function(data)
        if type(data.jobs) == 'string' then
            data.jobs = {data.jobs}
        end

        local usedPages = {}

        for _,v in pairs(data.jobs) do
            local page = GetMDTPageByJob(v)
            if page and not usedPages[page] then
                usedPages[page] = true
                exports.tk_mdt:addCall({title = data.title, coords = data.coords, location = data.location, time = data.removeTime, callsign = data.code, gender = data.gender, vehicle = data.vehicle, weapon = data.weapon, type = page})
            end
        end
    end)
end

if Config.Dispatch == 'cd' then
    RegisterServerEvent('cd_dispatch:AddNotification', function(data)
        local usedPages = {}

        for _,v in pairs(data.job_table) do
            local page = GetMDTPageByJob(v)
            if page and not usedPages[page] then
                exports.tk_mdt:addCall({title = data.title, coords = data.coords, type = page})
            end
        end
    end)
end

if Config.Dispatch == 'qs' then
    RegisterServerEvent('qs-dispatch:server:CreateDispatchCall', function(data)
        local usedPages = {}
        local jobs = type(data.job) == 'string' and {data.job} or data.job

        for _,v in pairs(jobs) do
            local page = GetMDTPageByJob(v)
            if page and not usedPages[page] then
                usedPages[page] = true
                exports.tk_mdt:addCall({title = data.message, callsign = data.callCode?.code, coords = data.callLocation, type = page})
            end
        end
    end)
end

if Config.Dispatch == 'ps' then
    RegisterServerEvent('ps-dispatch:server:notify', function(data)
        local usedPages = {}

        if type(data.jobs) == 'string' then
            data.jobs = {data.jobs}
        end

        if type(data.jobs) ~= 'table' then return end

        for _,v in pairs(data.jobs) do
            local page = GetMDTPageByJob(v)
            if page and not usedPages[page] then
                usedPages[page] = true
                exports.tk_mdt:addCall({title = data.message, callsign = data.code, coords = data.coords, location = data.street, gender = data.gender, weapon = data.weapon, vehicle = data.vehicle and {plate = data.plate, color = data.color, name = data.vehicle}, type = page})
            end
        end
    end)
end

if Config.Dispatch == 'core' then
    RegisterServerEvent('core_dispatch:addMessage', function(data)
        local page = GetMDTPageByJob(data.job)
        if not page then return end

        exports.tk_mdt:addCall({title = data.message, coords = data.coords, type = page})
    end)
end

if Config.Dispatch == 'rcore' then
    RegisterServerEvent('rcore_dispatch:server:sendAlert', function(data)
        if type(data) ~= 'table' then return end

        local page = GetMDTPageByJob(data.job)
        if not page then return end

        exports.tk_mdt:addCall({title = data.text, coords = data.coords, callsign = data.code, type = page})
    end)
end

if Config.Dispatch == 'loverp' then
    RegisterServerEvent('emergencydispatch:emergencycall:new', function(job, message, coords)
        local page = GetMDTPageByJob(job)
        if not page then return end

        exports.tk_mdt:addCall({
            title = message,
            coords = coords,
            type = page
        })
    end)
end

RegisterCallback('tk_mdt:getIdFromIdentifier', function(src, cb, identifier)
    local xPlayer = GetPlayerFromIdentifier(identifier)
    if not xPlayer then
        cb()
        return
    end

    cb(GetSource(xPlayer))
end)