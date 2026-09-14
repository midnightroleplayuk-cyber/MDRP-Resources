Framework = {}
Config.Framework = "auto" -- "auto", "qb", "esx"

local function DetectFramework()
    if Config.Framework == "qb" then return "qb" end
    if Config.Framework == "esx" then return "esx" end

    if GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
        return "qb"
    elseif GetResourceState('es_extended') == 'started' then
        return "esx"
    end
    return nil
end

Framework.Type = DetectFramework()
Framework.UsesQbx = (GetResourceState('qbx_core') == 'started')

function Framework.GetPlate(veh)
    if not veh or veh == 0 then return "" end
    local plate = GetVehicleNumberPlateText(veh)
    if plate then
        -- Trim spaces
        return string.gsub(plate, "^%s*(.-)%s*$", "%1")
    end
    return ""
end

if Framework.Type == "qb" then
    pcall(function()
        Framework.Core = exports['qb-core']:GetCoreObject()
    end)
    if not Framework.Core then
        pcall(function()
            Framework.Core = exports['qbx_core']:GetCoreObject()
        end)
    end
elseif Framework.Type == "esx" then
    Framework.Core = exports['es_extended']:getSharedObject()
end

-- Shared Functions
function Framework.GetPlayerData()
    if Framework.Type == "qb" then
        local data = nil

        if Framework.Core and Framework.Core.Functions and Framework.Core.Functions.GetPlayerData then
            data = Framework.Core.Functions.GetPlayerData()
        elseif Framework.UsesQbx then
            local ok, qbxData = pcall(function()
                return exports['qbx_core']:GetPlayerData()
            end)
            if ok then data = qbxData end
        end

        if not data or not data.job then return nil end

        local firstName = (data.charinfo and data.charinfo.firstname) or data.firstname or ""
        local lastName = (data.charinfo and data.charinfo.lastname) or data.lastname or ""
        local fullName = (firstName ~= "" or lastName ~= "") and ((firstName .. " " .. lastName):gsub("^%s*(.-)%s*$", "%1")) or
            (data.name or GetPlayerName(PlayerId()))
        local gradeLevel = (data.job.grade and (data.job.grade.level or data.job.grade)) or 0
        local gradeName = (data.job.grade and (data.job.grade.name or data.job.grade.label)) or data.job.gradeLabel or "Officer"

        return {
            citizenid = data.citizenid or data.citizenId or data.identifier,
            name = fullName,
            charinfo = data.charinfo or {
                firstname = firstName,
                lastname = lastName
            },
            job = {
                name = data.job.name,
                label = data.job.label,
                grade = gradeLevel,
                gradeLabel = gradeName,
                onduty = data.job.onduty,
                dept = data.job.dept -- Custom property used in this script
            },
            money = data.money
        }
    elseif Framework.Type == "esx" then
        local data = Framework.Core.GetPlayerData()
        if not data or not data.job then return nil end
        
        return {
            citizenid = data.identifier,
            name = data.firstName and (data.firstName .. " " .. data.lastName) or GetPlayerName(PlayerId()),
            charinfo = {
                firstname = data.firstName,
                lastname = data.lastName
            },
            job = {
                name = data.job.name,
                label = data.job.label,
                grade = data.job.grade,
                gradeLabel = data.job.grade_label,
                onduty = true, -- ESX usually doesn't have a default duty system
                dept = nil -- Will be filled later
            },
            money = data.accounts
        }
    end
end

if IsDuplicityVersion() then
    -- Server Side
    function Framework.GetPlayer(src)
        if Framework.Type == "qb" then
            local p = Framework.Core.Functions.GetPlayer(src)
            if not p then return nil end
            return {
                source = src,
                PlayerData = p.PlayerData, -- Keep for backward compatibility if needed, but discouraged
                citizenid = p.PlayerData.citizenid,
                identifier = p.PlayerData.citizenid,
                name = p.PlayerData.charinfo.firstname .. " " .. p.PlayerData.charinfo.lastname,
                charinfo = p.PlayerData.charinfo,
                job = {
                    name = p.PlayerData.job.name,
                    label = p.PlayerData.job.label,
                    grade = p.PlayerData.job.grade.level,
                    gradeLabel = p.PlayerData.job.grade.name,
                    onduty = p.PlayerData.job.onduty
                },
                functions = {
                    AddMoney = function(type, amount, reason) return p.Functions.AddMoney(type, amount, reason) end,
                    RemoveMoney = function(type, amount, reason) return p.Functions.RemoveMoney(type, amount, reason) end,
                    GetMoney = function(type) return p.Functions.GetMoney(type) end,
                    AddItem = function(item, amount, slot, info) return p.Functions.AddItem(item, amount, slot, info) end,
                    RemoveItem = function(item, amount, slot) return p.Functions.RemoveItem(item, amount, slot) end,
                    GetItemByName = function(item) return p.Functions.GetItemByName(item) end,
                    SetJob = function(job, grade) return p.Functions.SetJob(job, grade) end,
                    SetDuty = function(status) 
                        if p.Functions.SetJobDuty then
                            p.Functions.SetJobDuty(status)
                        else
                            p.PlayerData.job.onduty = status
                            p.Functions.SetJob(p.PlayerData.job.name, p.PlayerData.job.grade.level)
                        end
                    end
                }
            }
        elseif Framework.Type == "esx" then
            local p = Framework.Core.GetPlayerFromId(src)
            if not p then return nil end
            
            -- Try different key variations for names
            local firstName = p.get('firstName') or p.get('firstname') or ""
            local lastName = p.get('lastName') or p.get('lastname') or ""
            local name = (firstName ~= "" and lastName ~= "") and (firstName .. " " .. lastName) or p.getName()
            
            return {
                source = src,
                PlayerData = nil, -- ESX doesn't have this
                citizenid = p.identifier,
                identifier = p.identifier,
                name = name,
                charinfo = {
                    firstname = firstName,
                    lastname = lastName
                },
                job = {
                    name = p.job.name,
                    label = p.job.label,
                    grade = p.job.grade,
                    gradeLabel = p.job.grade_label,
                    onduty = true
                },
                functions = {
                    AddMoney = function(type, amount, reason) 
                        if type == "cash" then p.addAccountMoney('money', amount)
                        else p.addAccountMoney(type, amount) end
                        return true
                    end,
                    RemoveMoney = function(type, amount, reason) 
                        local acc = type == "cash" and "money" or type
                        if p.getAccount(acc).money >= amount then
                            p.removeAccountMoney(acc, amount)
                            return true
                        end
                        return false
                    end,
                    GetMoney = function(type)
                        local acc = type == "cash" and "money" or type
                        return p.getAccount(acc).money
                    end,
                    AddItem = function(item, amount, slot, info) p.addInventoryItem(item, amount); return true end,
                    RemoveItem = function(item, amount, slot) p.removeInventoryItem(item, amount); return true end,
                    SetJob = function(job, grade) p.setJob(job, grade); return true end
                }
            }
        end
    end

    function Framework.GetPlayerByCitizenId(cid)
        if Framework.Type == "qb" then
            local p = Framework.Core.Functions.GetPlayerByCitizenId(cid)
            if not p then return nil end
            return Framework.GetPlayer(p.PlayerData.source)
        elseif Framework.Type == "esx" then
            local p = Framework.Core.GetPlayerFromIdentifier(cid)
            if not p then return nil end
            return Framework.GetPlayer(p.source)
        end
    end

    function Framework.CreateCallback(name, cb)
        if Framework.Type == "qb" then
            Framework.Core.Functions.CreateCallback(name, cb)
        elseif Framework.Type == "esx" then
            Framework.Core.RegisterServerCallback(name, cb)
        end
    end

    function Framework.RegisterUsableItem(itemName, cb)
        if not itemName or type(cb) ~= "function" then return false end

        if Framework.Type == "qb" then
            if Framework.Core and Framework.Core.Functions then
                if Framework.Core.Functions.CreateUseableItem then
                    local ok = pcall(function()
                        Framework.Core.Functions.CreateUseableItem(itemName, function(source, item)
                            cb(source, item)
                        end)
                    end)
                    if ok then return true end
                end

                if Framework.Core.Functions.CreateUsableItem then
                    local ok = pcall(function()
                        Framework.Core.Functions.CreateUsableItem(itemName, function(source, item)
                            cb(source, item)
                        end)
                    end)
                    if ok then return true end
                end
            end

            -- Qbox fallback APIs (depending on core version)
            local okQbox = pcall(function()
                exports['qbx_core']:CreateUseableItem(itemName, function(source, item)
                    cb(source, item)
                end)
            end)
            if okQbox then return true end

            local okQboxAlt = pcall(function()
                exports['qbx_core']:CreateUsableItem(itemName, function(source, item)
                    cb(source, item)
                end)
            end)
            if okQboxAlt then return true end

            return false
        elseif Framework.Type == "esx" then
            if Framework.Core and Framework.Core.RegisterUsableItem then
                local ok = pcall(function()
                    Framework.Core.RegisterUsableItem(itemName, function(source)
                        cb(source, nil)
                    end)
                end)
                return ok
            end
            return false
        end

        return false
    end

    function Framework.Notify(src, msg, type)
        if not Config.ShowNotifications then return end
        TriggerClientEvent('plt_departments:client:Notify', src, msg, type)
    end

    function Framework.HasPermission(src, perm)
        if Framework.Type == "qb" then
            if not Framework.Core or not Framework.Core.Functions then return false end
            return Framework.Core.Functions.HasPermission(src, perm)
        elseif Framework.Type == "esx" then
            local p = Framework.Core.GetPlayerFromId(src)
            if not p then return false end
            return p.getGroup() == perm or p.getGroup() == 'admin' or p.getGroup() == 'superadmin'
        end
        return false
    end

    function Framework.GetIdentifier(src, type)
        local idType = type or "license"
        for _, id in ipairs(GetPlayerIdentifiers(src)) do
            if string.find(id, idType .. ":") then
                return id
            end
        end
        return nil
    end

else
    -- Client Side
    function Framework.Notify(msg, type)
        if not Config.ShowNotifications then return end
        TriggerEvent('plt_departments:client:Notify', msg, type)
    end

    function Framework.TriggerCallback(name, cb, ...)
        local args = { ... }
        if Framework.Type == "qb" then
            if Framework.Core and Framework.Core.Functions and Framework.Core.Functions.TriggerCallback then
                Framework.Core.Functions.TriggerCallback(name, cb, ...)
                return
            end

            if Framework.UsesQbx then
                local ok = pcall(function()
                    exports['qbx_core']:TriggerCallback(name, cb, table.unpack(args))
                end)
                if ok then return end
            end
        elseif Framework.Type == "esx" then
            Framework.Core.TriggerServerCallback(name, cb, ...)
        end
    end

    function Framework.SpawnVehicle(model, cb, coords, isNetworked)
        if Framework.Type == "qb" then
            Framework.Core.Functions.SpawnVehicle(model, cb, coords, isNetworked)
        elseif Framework.Type == "esx" then
            local modelHash = type(model) == "number" and model or joaat(model)
            if not IsModelInCdimage(modelHash) or not IsModelAVehicle(modelHash) then
                if cb then cb(nil) end
                return
            end

            RequestModel(modelHash)
            local waited = 0
            while not HasModelLoaded(modelHash) and waited < 5000 do
                Wait(10)
                waited = waited + 10
            end

            if not HasModelLoaded(modelHash) then
                if cb then cb(nil) end
                return
            end

            local x = tonumber(coords and coords.x) or 0.0
            local y = tonumber(coords and coords.y) or 0.0
            local z = tonumber(coords and coords.z) or 0.0
            local h = tonumber((coords and (coords.h or coords.w))) or 0.0
            local net = isNetworked ~= false

            local veh = CreateVehicle(modelHash, x, y, z, h, net, true)
            if veh and veh ~= 0 then
                SetEntityAsMissionEntity(veh, true, true)
            end

            SetModelAsNoLongerNeeded(modelHash)
            if cb then cb(veh) end
        end
    end

    function Framework.SetVehicleProperties(veh, props)
        if Framework.Type == "qb" then
            Framework.Core.Functions.SetVehicleProperties(veh, props)
        elseif Framework.Type == "esx" then
            Framework.Core.Game.SetVehicleProperties(veh, props)
        end
    end

    function Framework.GetClosestPlayer()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local closestPlayer = -1
        local closestDistance = -1
        
        local players = GetActivePlayers()
        for _, id in ipairs(players) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= ped then
                local targetCoords = GetEntityCoords(targetPed)
                local dist = #(coords - targetCoords)
                if closestDistance == -1 or dist < closestDistance then
                    closestPlayer = id
                    closestDistance = dist
                end
            end
        end
        return closestPlayer, closestDistance
    end

    function Framework.GetClosestVehicle(coords)
        local ped = PlayerPedId()
        local pCoords = coords or GetEntityCoords(ped)
        
        if Framework.Type == "qb" then
            if Framework.Core.Functions and Framework.Core.Functions.GetClosestVehicle then
                local veh = Framework.Core.Functions.GetClosestVehicle(pCoords)
                if veh and DoesEntityExist(veh) then return veh end
            end
        elseif Framework.Type == "esx" then
            if Framework.Core.Game and Framework.Core.Game.GetClosestVehicle then
                local veh = Framework.Core.Game.GetClosestVehicle(pCoords)
                if veh and DoesEntityExist(veh) then return veh end
            end
        end

        -- Native fallback (more robust)
        local veh = GetClosestVehicle(pCoords.x, pCoords.y, pCoords.z, 5.0, 0, 71)
        if not veh or veh == 0 then
            -- Try another flag if 71 fails (71 is usually all vehicles)
            veh = GetClosestVehicle(pCoords.x, pCoords.y, pCoords.z, 5.0, 0, 127)
        end
        return veh
    end

    function Framework.Progressbar(name, label, duration, useLib, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        if Framework.Type == "qb" then
            Framework.Core.Functions.Progressbar(name, label, duration, false, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        elseif Framework.Type == "esx" then
            -- Fallback or use a progress bar script if available
            -- For now, just a wait and then finish
            CreateThread(function()
                Wait(duration)
                if onFinish then onFinish() end
            end)
        end
    end

    function Framework.ShowTextUI(msg, type)
        if Framework.Type == "qb" then
            TriggerEvent('qb-core:client:DrawText', msg, 'right')
        else
            -- Simple fallback if no UI script exists
            BeginTextCommandPrint("STRING")
            AddTextComponentString(msg)
            EndTextCommandPrint(1000, 1)
        end
    end

    function Framework.HideTextUI()
        if Framework.Type == "qb" then
            TriggerEvent('qb-core:client:HideText')
        end
    end
end

