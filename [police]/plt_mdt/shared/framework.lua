Framework = {}
Framework.Name = nil
Framework.Object = nil

local function DetectFramework()
    if GetResourceState('qbx_core') == 'started' then
        Framework.Name = 'qbox'
        Framework.Object = exports.qbx_core
    elseif GetResourceState('qb-core') == 'started' then
        Framework.Name = 'qbcore'
        Framework.Object = exports['qb-core']:GetCoreObject()
    elseif GetResourceState('es_extended') == 'started' then
        Framework.Name = 'esx'
        Framework.Object = exports['es_extended']:getSharedObject()
    end
end

DetectFramework()

function Framework.GetFramework()
    return Framework.Name
end

-- Server-side helpers
if IsDuplicityVersion() then
    function Framework.GetPlayer(source)
        if Framework.Name == 'esx' then
            local xPlayer = Framework.Object.GetPlayerFromId(source)
            if not xPlayer then return nil end
            
            -- Add unified 'set' method for ESX xPlayer if it doesn't exist (it usually does for metadata)
            -- But we'll wrap it to be safe
            local pObj = {
                identifier = xPlayer.identifier,
                name = xPlayer.getName(),
                job = {
                    name = xPlayer.job.name,
                    label = xPlayer.job.label,
                    grade = {
                        level = xPlayer.job.grade,
                        name = xPlayer.job.grade_label
                    },
                    onduty = true
                },
                source = xPlayer.source,
                -- Native xPlayer access
                xPlayer = xPlayer,
                set = function(key, val)
                    -- In ESX, we can use set() for session variables
                    xPlayer.set(key, val)
                end,
                get = function(key)
                    return xPlayer.get(key)
                end
            }
            return pObj
        elseif Framework.Name == 'qbox' then
            local Player = exports.qbx_core:GetPlayer(source)
            if not Player then return nil end
            local pData = Player.PlayerData
            
            local pObj = {
                identifier = pData.citizenid,
                name = pData.charinfo.firstname .. " " .. pData.charinfo.lastname,
                job = {
                    name = pData.job.name,
                    label = pData.job.label,
                    grade = {
                        level = pData.job.grade.level,
                        name = pData.job.grade.name
                    },
                    onduty = pData.job.onduty
                },
                source = pData.source,
                -- Native Player access
                Player = Player,
                set = function(key, val)
                    Player.Functions.SetMetaData(key, val)
                end,
                get = function(key)
                    return pData.metadata[key]
                end,
                addMoney = function(type, amount, reason)
                    Player.Functions.AddMoney(type, amount, reason)
                end,
                removeMoney = function(type, amount, reason)
                    Player.Functions.RemoveMoney(type, amount, reason)
                end,
                getCoords = function()
                    local ped = GetPlayerPed(pData.source)
                    return GetEntityCoords(ped)
                end
            }
            return pObj
        elseif Framework.Name == 'qbcore' then
            local Player = Framework.Object.Functions.GetPlayer(source)
            if not Player then return nil end
            local pData = Player.PlayerData
            
            local pObj = {
                identifier = pData.citizenid,
                name = pData.charinfo.firstname .. " " .. pData.charinfo.lastname,
                job = {
                    name = pData.job.name,
                    label = pData.job.label,
                    grade = {
                        level = pData.job.grade.level,
                        name = pData.job.grade.name
                    },
                    onduty = pData.job.onduty
                },
                source = pData.source,
                -- Native Player access
                Player = Player,
                set = function(key, val)
                    Player.Functions.SetMetaData(key, val)
                end,
                get = function(key)
                    return pData.metadata[key]
                end,
                addMoney = function(type, amount, reason)
                    Player.Functions.AddMoney(type, amount, reason)
                end,
                removeMoney = function(type, amount, reason)
                    Player.Functions.RemoveMoney(type, amount, reason)
                end,
                getCoords = function()
                    local ped = GetPlayerPed(pData.source)
                    return GetEntityCoords(ped)
                end
            }
            return pObj
        end
    end

    function Framework.GetPlayerFromIdentifier(identifier)
        if Framework.Name == 'esx' then
            local xPlayer = Framework.Object.GetPlayerFromIdentifier(identifier)
            if not xPlayer then return nil end
            return Framework.GetPlayer(xPlayer.source)
        elseif Framework.Name == 'qbox' then
            local Player = exports.qbx_core:GetPlayerByCitizenId(identifier)
            if not Player then return nil end
            return Framework.GetPlayer(Player.PlayerData.source)
        elseif Framework.Name == 'qbcore' then
            local Player = Framework.Object.Functions.GetPlayerByCitizenId(identifier)
            if not Player then return nil end
            return Framework.GetPlayer(Player.PlayerData.source)
        end
    end

    function Framework.JailPlayer(source, time)
        if Framework.Name == 'qbcore' or Framework.Name == 'qbox' then
            TriggerEvent('police:server:JailPlayer', source, tonumber(time))
        elseif Framework.Name == 'esx' then
            -- Common ESX jail script trigger
            TriggerEvent('esx_jailer:sendToJail', source, tonumber(time) * 60)
        end
    end

    function Framework.JailPlayerRcore(source, time, reason, officerSource)
        if GetResourceState('rcore_prison') ~= 'started' then return false end

        local targetSource = tonumber(source)
        if not targetSource or targetSource <= 0 or not GetPlayerName(targetSource) then
            return false
        end

        local jailTime = tonumber(time) or 0
        local cleanReason = tostring(reason or "MDT Sentence"):gsub("[\r\n]", " ")
        local officerId = tonumber(officerSource)

        local ok, result = pcall(function()
            return exports['rcore_prison']:Jail(targetSource, jailTime, cleanReason, officerId)
        end)

        if not ok then
            print(('[plt_mdt] rcore_prison:Jail failed for source %s'):format(tostring(targetSource)))
            return false
        end

        return result ~= false
    end

    function Framework.UnjailPlayerRcore(source)
        if GetResourceState('rcore_prison') ~= 'started' then return false end

        local targetSource = tonumber(source)
        if not targetSource or targetSource <= 0 or not GetPlayerName(targetSource) then
            return false
        end

        local ok, result = pcall(function()
            return exports['rcore_prison']:Unjail(targetSource, false)
        end)

        if not ok then
            print(('[plt_mdt] rcore_prison:Unjail failed for source %s'):format(tostring(targetSource)))
            return false
        end

        return result ~= false
    end

    function Framework.JailPlayerTk(source, time, reason)
        if GetResourceState('tk_jail') ~= 'started' then return false end
        local jailTime = tonumber(time) or 0
        local cleanReason = tostring(reason or "MDT Sentence"):gsub("[\r\n]", " ")
        exports.tk_jail:jail(tostring(source), jailTime, 'jail', nil, true, cleanReason)
        return true
    end

    function Framework.UnjailPlayerTk(source)
        if GetResourceState('tk_jail') ~= 'started' then return false end
        exports.tk_jail:unjail(tostring(source), true)
        return true
    end

    function Framework.Notify(source, msg, type)
        if Framework.Name == 'esx' then
            TriggerClientEvent('esx:showNotification', source, msg, type)
        elseif Framework.Name == 'qbcore' then
            TriggerClientEvent('QBCore:Notify', source, msg, type)
        elseif Framework.Name == 'qbox' then
            TriggerClientEvent('ox_lib:notify', source, { title = 'MDT', description = msg, type = type })
        end
    end
else
    -- Client-side helpers
    function Framework.GetPlayerData()
        if Framework.Name == 'esx' then
            local pData = Framework.Object.GetPlayerData()
            return {
                identifier = pData.identifier,
                name = pData.firstName and (pData.firstName .. " " .. pData.lastName) or "Unknown",
                job = {
                    name = pData.job.name,
                    label = pData.job.label,
                    grade = {
                        level = pData.job.grade,
                        name = pData.job.grade_label
                    },
                    onduty = true
                }
            }
        elseif Framework.Name == 'qbox' then
            local pData = exports.qbx_core:GetPlayerData()
            return {
                identifier = pData.citizenid,
                name = pData.charinfo.firstname .. " " .. pData.charinfo.lastname,
                job = {
                    name = pData.job.name,
                    label = pData.job.label,
                    grade = {
                        level = pData.job.grade.level,
                        name = pData.job.grade.name
                    },
                    onduty = pData.job.onduty
                }
            }
        elseif Framework.Name == 'qbcore' then
            local pData = Framework.Object.Functions.GetPlayerData()
            return {
                identifier = pData.citizenid,
                name = pData.charinfo.firstname .. " " .. pData.charinfo.lastname,
                job = {
                    name = pData.job.name,
                    label = pData.job.label,
                    grade = {
                        level = pData.job.grade.level,
                        name = pData.job.grade.name
                    },
                    onduty = pData.job.onduty
                }
            }
        end
    end

    function Framework.Notify(msg, type)
        if Framework.Name == 'esx' then
            Framework.Object.ShowNotification(msg, type)
        elseif Framework.Name == 'qbcore' then
            Framework.Object.Functions.Notify(msg, type)
        elseif Framework.Name == 'qbox' then
            exports.qbx_core:Notify(msg, type)
        end
    end
end

-- Database Configuration
Framework.DB = {
    PlayersTable = (Framework.Name == 'esx') and 'users' or 'players',
    VehiclesTable = (Framework.Name == 'esx') and 'owned_vehicles' or 'player_vehicles',
    IdentifierColumn = (Framework.Name == 'esx') and 'identifier' or 'citizenid',
    VehicleOwnerColumn = (Framework.Name == 'esx') and 'owner' or 'citizenid'
}
