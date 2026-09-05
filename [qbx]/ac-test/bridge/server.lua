-- CoreFx Server Bridge
-- handles server-side framework helpers, db queries, inventory, and vehicle ownership

Bridge = Bridge or {}
Bridge.Server = Bridge.Server or {}

QBCore = nil
ESX = nil

CreateThread(function()
    Wait(100)
    
    if Bridge.Framework == 'qbox' then
        if GetResourceState('qb-core') == 'started' then
            local success, result = pcall(function()
                return exports['qb-core']:GetCoreObject()
            end)
            if success and result then QBCore = result end
        end
        
        if not QBCore then
            local success, result = pcall(function()
                return exports['qbx_core']:GetCoreObject()
            end)
            
            if success and result then
                QBCore = result
            else
                local success2, result2 = pcall(function()
                    return exports['qbx_core']:GetSharedObject()
                end)
                if success2 and result2 then QBCore = result2 end
            end
        end
        
    elseif Bridge.Framework == 'qbcore' then
        local success, result = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if success and result then QBCore = result end
        
    elseif Bridge.Framework == 'esx' then
        local success, result = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if success and result then ESX = result end
    end
end)

-- player helpers
function Bridge.Server.GetPlayer(source)
    if Bridge.Framework == 'esx' then
        if ESX then return ESX.GetPlayerFromId(source) end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore then return QBCore.Functions.GetPlayer(source) end
    end
    
    return {
        source = source,
        identifier = GetPlayerIdentifierByType(source, 'license') or ('standalone_' .. source),
        name = GetPlayerName(source)
    }
end

function Bridge.Server.GetIdentifier(source)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return nil end
    
    if Bridge.Framework == 'esx' then
        return player.getIdentifier and player.getIdentifier() or player.identifier
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        return player.PlayerData and player.PlayerData.citizenid or nil
    else
        return player.identifier
    end
end

function Bridge.Server.GetName(source)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return GetPlayerName(source) end
    
    if Bridge.Framework == 'esx' then
        return player.getName and player.getName() or GetPlayerName(source)
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if player.PlayerData and player.PlayerData.charinfo then
            local charinfo = player.PlayerData.charinfo
            return (charinfo.firstname or '') .. ' ' .. (charinfo.lastname or '')
        end
        return GetPlayerName(source)
    else
        return GetPlayerName(source)
    end
end

-- db query wrappers
function Bridge.Server.ExecuteQuery(query, params, callback)
    if Bridge.HasOxMySQL then
        if callback then
            MySQL.query(query, params, callback)
        else
            MySQL.query(query, params)
        end
    else
        if callback then callback(nil) end
    end
end

function Bridge.Server.FetchQuery(query, params, callback)
    if Bridge.HasOxMySQL then
        MySQL.query(query, params, function(result)
            callback(result)
        end)
    else
        callback(nil)
    end
end

function Bridge.Server.InsertQuery(query, params, callback)
    if Bridge.HasOxMySQL then
        MySQL.insert(query, params, callback)
    else
        if callback then callback(nil) end
    end
end

function Bridge.Server.UpdateQuery(query, params, callback)
    if Bridge.HasOxMySQL then
        MySQL.update(query, params, callback)
    else
        if callback then callback(nil) end
    end
end

function Bridge.Server.IsQuerySuccess(result)
    if type(result) == 'number' then
        return result > 0
    elseif type(result) == 'table' then
        if result.affectedRows then
            return result.affectedRows > 0
        end
        return true
    end
    return false
end

-- vehicle ownership
function Bridge.Server.CheckVehicleOwnership(source, plate, callback)
    local identifier = Bridge.Server.GetIdentifier(source)
    if not identifier then
        callback(false, 'Player not found')
        return
    end
    
    if not Bridge.HasOxMySQL then
        callback(true, 'No database - allowing all vehicles')
        return
    end
    
    local query = ''
    local ownerColumn = ''
    
    if Bridge.Framework == 'esx' then
        query = 'SELECT owner FROM owned_vehicles WHERE plate = ?'
        ownerColumn = 'owner'
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        query = 'SELECT citizenid FROM player_vehicles WHERE plate = ?'
        ownerColumn = 'citizenid'
    else
        callback(true, 'Standalone mode - no ownership check')
        return
    end
    
    Bridge.Server.FetchQuery(query, {plate}, function(result)
        if result and #result > 0 then
            local vehicleOwner = result[1][ownerColumn]
            if vehicleOwner == identifier then
                callback(true, 'Player owns this vehicle')
            else
                callback(false, 'Vehicle owned by someone else')
            end
        else
            callback(false, 'Vehicle not in database')
        end
    end)
end

function Bridge.Server.RegisterVehicleOwnership(source, plate, vehicleProps, callback)
    local identifier = Bridge.Server.GetIdentifier(source)
    if not identifier then
        callback(false, 'Player not found')
        return
    end
    
    if not Bridge.HasOxMySQL then
        callback(true, 'No database - skipping registration')
        return
    end
    
    local vehicleJson = json.encode(vehicleProps or {})
    
    if Bridge.Framework == 'esx' then
        Bridge.Server.FetchQuery('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate}, function(result)
            if result and #result > 0 then
                Bridge.Server.UpdateQuery(
                    'UPDATE owned_vehicles SET owner = ?, vehicle = ? WHERE plate = ?',
                    {identifier, vehicleJson, plate},
                    function(rows)
                        callback(Bridge.Server.IsQuerySuccess(rows), 'Ownership updated')
                    end
                )
            else
                Bridge.Server.ExecuteQuery(
                    'INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`) VALUES (?, ?, ?, ?, ?)',
                    {identifier, plate, vehicleJson, 'car', 0},
                    function(rows)
                        callback(Bridge.Server.IsQuerySuccess(rows), 'Vehicle registered')
                    end
                )
            end
        end)
        
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        Bridge.Server.FetchQuery('SELECT plate FROM player_vehicles WHERE plate = ?', {plate}, function(result)
            if result and #result > 0 then
                Bridge.Server.UpdateQuery(
                    'UPDATE player_vehicles SET citizenid = ?, mods = ? WHERE plate = ?',
                    {identifier, vehicleJson, plate},
                    function(rows)
                        callback(Bridge.Server.IsQuerySuccess(rows), 'Ownership updated')
                    end
                )
            else
                local model = vehicleProps and vehicleProps.model or 'unknown'
                Bridge.Server.ExecuteQuery(
                    'INSERT INTO player_vehicles (citizenid, vehicle, plate, mods, state) VALUES (?, ?, ?, ?, ?)',
                    {identifier, model, plate, vehicleJson, 1},
                    function(rows)
                        callback(Bridge.Server.IsQuerySuccess(rows), 'Vehicle registered')
                    end
                )
            end
        end)
        
    else
        callback(true, 'Standalone mode - no database registration')
    end
end

function Bridge.Server.GetOwnedVehicles(source, callback)
    local identifier = Bridge.Server.GetIdentifier(source)
    if not identifier or not Bridge.HasOxMySQL then 
        callback({}) 
        return 
    end

    local query = ''
    if Bridge.Framework == 'esx' then
        query = 'SELECT plate, vehicle FROM owned_vehicles WHERE owner = ?'
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        query = 'SELECT plate, vehicle, mods FROM player_vehicles WHERE citizenid = ?'
    else
        callback({})
        return
    end

    Bridge.Server.FetchQuery(query, {identifier}, function(result)
        local vehicles = {}
        if result then
            for _, v in ipairs(result) do
                local model = 'Unknown'
                local mods = {}

                if Bridge.Framework == 'esx' then
                    if v.vehicle then
                        local success, vehicleData = pcall(json.decode, v.vehicle)
                        if success and vehicleData then
                            model = vehicleData.model or 'Unknown'
                            mods = vehicleData
                        end
                    end
                elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
                    model = v.vehicle
                    if v.mods then
                        mods = json.decode(v.mods)
                    end
                end

                table.insert(vehicles, {
                    plate = v.plate,
                    model = model,
                    mods = mods
                })
            end
        end
        callback(vehicles)
    end)
end

-- weapon helpers
function Bridge.Server.GiveWeapon(source, weaponName, ammo)
    weaponName = string.upper(weaponName)
    
    if GetResourceState('ox_inventory') == 'started' then
        local success = exports.ox_inventory:AddItem(source, weaponName, 1, {ammo = ammo})
        if not success then
            success = exports.ox_inventory:AddItem(source, string.lower(weaponName), 1, {ammo = ammo})
        end
        return success
    end
    
    if GetResourceState('qs-inventory') == 'started' then
        exports['qs-inventory']:AddItem(source, weaponName, 1)
        return true
    end
    
    local player = Bridge.Server.GetPlayer(source)
    if not player then return false end
    
    if Bridge.Framework == 'esx' then
        if player.addWeapon then
            player.addWeapon(weaponName, ammo)
            return true
        else
            player.addInventoryItem(weaponName, 1)
            return true
        end
        
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        local item = string.lower(weaponName)
        player.Functions.AddItem(item, 1)
        
        if QBCore.Shared and QBCore.Shared.Items and QBCore.Shared.Items[item] then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
        end
        return true
        
    else
        TriggerClientEvent('ac-test:receiveWeapon', source, weaponName)
        return true
    end
end

-- job management
function Bridge.Server.GetAllJobs()
    local jobs = {}
    
    if Bridge.Framework == 'esx' then
        if GetResourceState('oxmysql') == 'started' then
            local p = promise.new()
            exports.oxmysql:query('SELECT * FROM jobs', {}, function(res)
                if not res then p:resolve(nil) return end
                exports.oxmysql:query('SELECT * FROM job_grades', {}, function(grades)
                    p:resolve({jobs = res, grades = grades})
                end)
            end)
            local data = Citizen.Await(p)
            
            if data and data.jobs then
                local jobGrades = {}
                for _, g in ipairs(data.grades or {}) do
                    if not jobGrades[g.job_name] then jobGrades[g.job_name] = {} end
                    
                    local gradeNum = tonumber(g.grade)
                    local isDuplicate = false
                    for _, existing in ipairs(jobGrades[g.job_name]) do
                        if existing.grade == gradeNum then
                            isDuplicate = true
                            break
                        end
                    end

                    if not isDuplicate then
                        table.insert(jobGrades[g.job_name], {
                            grade = gradeNum,
                            label = g.label,
                            name = g.name
                        })
                    end
                end

                local processedJobs = {}
                for _, j in ipairs(data.jobs) do
                    if not processedJobs[j.name] then
                        processedJobs[j.name] = true
                        local gList = jobGrades[j.name] or {}
                        table.sort(gList, function(a, b) return a.grade < b.grade end)
                        
                        table.insert(jobs, {
                            name = j.name,
                            label = j.label,
                            grades = gList
                        })
                    end
                end
                
                if #jobs > 0 then
                    table.sort(jobs, function(a, b) return a.label < b.label end)
                    return jobs
                end
            end
        end

        if ESX and ESX.GetJobs then
            local esxJobs = ESX.GetJobs()
            for k, v in pairs(esxJobs) do
                local grades = {}
                for gk, gv in pairs(v.grades) do
                    table.insert(grades, {
                        grade = tonumber(gk),
                        label = gv.label,
                        name = gv.name
                    })
                end
                table.sort(grades, function(a, b) return a.grade < b.grade end)
                
                table.insert(jobs, {
                    name = k,
                    label = v.label,
                    grades = grades
                })
            end
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore and QBCore.Shared and QBCore.Shared.Jobs then
            for k, v in pairs(QBCore.Shared.Jobs) do
                local grades = {}
                for gk, gv in pairs(v.grades) do
                    table.insert(grades, {
                        grade = tonumber(gk),
                        label = gv.name,
                        name = gv.name
                    })
                end
                table.sort(grades, function(a, b) return a.grade < b.grade end)

                table.insert(jobs, {
                    name = k,
                    label = v.label,
                    grades = grades
                })
            end
        end
    end
    
    table.sort(jobs, function(a, b) return a.label < b.label end)
    return jobs
end

function Bridge.Server.SetJob(source, job, grade)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return false end
    
    if Bridge.Framework == 'esx' then
        if player.setJob then
            player.setJob(job, grade)
            return true
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if player.Functions and player.Functions.SetJob then
            return player.Functions.SetJob(job, grade)
        end
    end
    
    return false
end

function Bridge.Server.GetJob(source)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return nil end

    if Bridge.Framework == 'esx' then
        if player.job then
            return {
                name = player.job.name,
                label = player.job.label,
                grade = player.job.grade,
                grade_label = player.job.grade_label
            }
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if player.PlayerData and player.PlayerData.job then
            return {
                name = player.PlayerData.job.name,
                label = player.PlayerData.job.label,
                grade = player.PlayerData.job.grade and player.PlayerData.job.grade.level or 0,
                grade_label = player.PlayerData.job.grade and player.PlayerData.job.grade.name or 'Unknown'
            }
        end
    end
    
    return { name = 'unknown', label = 'Unknown', grade = 0, grade_label = 'None' }
end

function Bridge.Server.GetAccounts(source)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return {cash = 0, bank = 0} end

    if Bridge.Framework == 'esx' then
        local cash = player.getMoney()
        local bank = player.getAccount('bank').money
        return { cash = cash, bank = bank }
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if player.PlayerData and player.PlayerData.money then
            return {
                cash = player.PlayerData.money.cash or 0,
                bank = player.PlayerData.money.bank or 0
            }
        end
    end
    
    return { cash = 0, bank = 0 }
end

function Bridge.Server.IsAdmin(source)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return false end

    if Bridge.Framework == 'esx' then
        if player.getGroup then
            local group = player.getGroup()
            if group == 'admin' or group == 'superadmin' then return true end
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if QBCore.Functions.HasPermission then
            if QBCore.Functions.HasPermission(source, 'admin') or QBCore.Functions.HasPermission(source, 'god') then return true end
        end
    end

    return IsPlayerAceAllowed(source, 'command') or false
end

-- item loading helpers
local function LoadItemsFromFile(resource, file)
    local content = LoadResourceFile(resource, file)
    if not content then return {} end
    
    content = content:gsub("`([^`]+)`", 'joaat("%1")')

    local env = {
        vec3 = vec3,
        vector3 = vector3,
        vector4 = vector4,
        joaat = GetHashKey,
        print = function() end,
        _VERSION = _VERSION
    }
    setmetatable(env, { __index = _G })

    local func, err = load(content, file, "t", env)
    if not func then return {} end
    
    local success, result = pcall(func)
    if success and type(result) == 'table' then
        return result
    end
    return {}
end

function Bridge.Server.GetAllItems()
    local items = {}
    local processed = {}

    local function addResult(sourceTable)
        for name, data in pairs(sourceTable) do
            if not processed[name] and data.label then
                table.insert(items, { name = name, label = data.label })
                processed[name] = true
            end
        end
    end

    local oxState = GetResourceState('ox_inventory')
    if oxState == 'started' or oxState == 'missing' then 
        local fileItems = LoadItemsFromFile('ox_inventory', 'data/items.lua')
        if next(fileItems) then
             for name, data in pairs(fileItems) do
                if not processed[name] and data.label and not string.match(string.upper(name), "^WEAPON_") then
                    local img = nil
                    if data.client and data.client.image then img = data.client.image end
                    if not img and data.image then img = data.image end
                    table.insert(items, { name = name, label = data.label, image = img })
                    processed[name] = true
                end
            end
        end
    end

    local qbInvState = GetResourceState('qb-inventory')
    local ljInvState = GetResourceState('lj-inventory')
    
    if (qbInvState == 'started' or ljInvState == 'started') or (Bridge.Framework == 'qbcore' or Bridge.Framework == 'qbox') then
         if QBCore and QBCore.Shared and QBCore.Shared.Items then
             for name, data in pairs(QBCore.Shared.Items) do
                 if not processed[name] and not string.match(string.upper(name), "^WEAPON_") then
                    table.insert(items, { name = name, label = data.label, image = data.image })
                    processed[name] = true
                 end
             end
         else
             local qbItems = LoadItemsFromFile('qb-core', 'shared/items.lua')
             if next(qbItems) then
                 for name, data in pairs(qbItems) do
                     if not processed[name] and not string.match(string.upper(name), "^WEAPON_") then
                        table.insert(items, { name = name, label = data.label, image = data.image })
                        processed[name] = true
                     end
                 end
             end
         end
    end

    if GetResourceState('ox_inventory') == 'started' then
         local success, exportItems = pcall(function() return exports.ox_inventory:Items() end)
        if success and exportItems and next(exportItems) then
             for name, data in pairs(exportItems) do
                if not processed[name] and data.label and not string.match(string.upper(name), "^WEAPON_") then
                    local img = data.image
                    if not img and data.client and data.client.image then img = data.client.image end
                    table.insert(items, { name = name, label = data.label, image = img })
                    processed[name] = true
                end
            end
        end
    end

    if Bridge.Framework == 'esx' then
         local esxItems = (ESX and ESX.Items) or (ESX and ESX.GetItems and ESX.GetItems()) or {}
        if next(esxItems) then
             for k, v in pairs(esxItems) do
                local name = v.name or k
                if not processed[name] and not string.match(string.upper(name), "^WEAPON_") then
                    table.insert(items, { name = name, label = v.label or name, image = v.image })
                    processed[name] = true
                end
            end
        end
         if not next(items) and Bridge.HasOxMySQL then
             local p = promise.new()
             exports.oxmysql:query('SELECT name, label FROM items', {}, function(result) p:resolve(result) end)
             local dbItems = Citizen.Await(p)
             if dbItems then
                for _, i in ipairs(dbItems) do
                    if not processed[i.name] and not string.match(string.upper(i.name), "^WEAPON_") then
                        table.insert(items, { name = i.name, label = i.label })
                        processed[i.name] = true
                    end
                end
             end
        end
    end
    
    table.sort(items, function(a, b) return a.label < b.label end)
    return items
end

function nonil_count(t)
    local c = 0
    for _ in pairs(t) do c = c + 1 end
    return c
end

function Bridge.Server.GiveItem(source, item, count)
    local player = Bridge.Server.GetPlayer(source)
    if not player then return false end

    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(source, item, count)
    end

    if Bridge.Framework == 'esx' then
        if player.addInventoryItem then
            player.addInventoryItem(item, count)
            return true
        end
    elseif Bridge.Framework == 'qbox' or Bridge.Framework == 'qbcore' then
        if player.Functions.AddItem then
            player.Functions.AddItem(item, count)
            if QBCore.Shared and QBCore.Shared.Items and QBCore.Shared.Items[item] then
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
            end
            return true
        end
    end
    
    return false
end

-- exports
exports('GetPlayer', Bridge.Server.GetPlayer)
exports('GetPlayerIdentifier', Bridge.Server.GetIdentifier)
exports('GetPlayerName', Bridge.Server.GetName)
exports('CheckVehicleOwnership', Bridge.Server.CheckVehicleOwnership)
exports('RegisterVehicleOwnership', Bridge.Server.RegisterVehicleOwnership)
exports('GiveWeapon', Bridge.Server.GiveWeapon)
exports('GetAllJobs', Bridge.Server.GetAllJobs)
exports('SetJob', Bridge.Server.SetJob)
exports('GetServerFramework', function() return Bridge.Framework end)
exports('GetAllItems', Bridge.Server.GetAllItems)
exports('GiveItem', Bridge.Server.GiveItem)
