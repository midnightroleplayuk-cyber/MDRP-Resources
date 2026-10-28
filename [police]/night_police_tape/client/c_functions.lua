QBCore = nil
ESX = nil

CreateThread(function()
    if Config.Enable_QBCore_Permissions.Check_By_Job or Config.Enable_QBCore_Permissions.Check_By_Permissions then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    if Config.Enable_ESX_Permissions then
        ESX = exports['es_extended']:getSharedObject()
    end
end)

function PermissionCheck()
    local permission = false

    if Config.EveryoneHasPermission then
        return true
    end

    if #Config.PermissionRoles < 1 then
        print('[' .. GetCurrentResourceName() .. '] No permission roles are set in config.lua')
        return false
    end

    if Config.Enable_ESX_Permissions then
        if ESX == nil then
            print('[' .. GetCurrentResourceName() .. '] ESX permissions are enabled, but ESX was not found.')
            return false
        end
        if ESX.IsPlayerLoaded() then
            local xPlayer = ESX.GetPlayerData()
            if xPlayer and xPlayer.job then
                for _, role in pairs(Config.PermissionRoles) do
                    if xPlayer.job.name == role then
                        permission = true
                        break
                    end
                end
            end
        end
    end

    if Config.Enable_QBCore_Permissions.Check_By_Job then
        if QBCore == nil then
            print('[' .. GetCurrentResourceName() .. '] QBCore job permissions are enabled, but QBCore was not found.')
            return false
        end
        local player = QBCore.Functions.GetPlayerData()
        if player and player.job then
            for _, role in pairs(Config.PermissionRoles) do
                if player.job.name == role then
                    permission = true
                    break
                end
            end
        end
    end

    return permission
end

function notify(notificationText)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(notificationText)
    EndTextCommandThefeedPostTicker(false, false)
end

function ShowHelp(lineOne, lineTwo, lineThree)
    BeginTextCommandDisplayHelp('THREESTRINGS')
    AddTextComponentSubstringPlayerName(lineOne or '')
    AddTextComponentSubstringPlayerName(lineTwo or '')
    AddTextComponentSubstringPlayerName(lineThree or '')
    EndTextCommandDisplayHelp(0, false, false, -1)
end

function DebugPrint(msg)
    if Config.Debug and msg ~= nil then
        print('[' .. GetCurrentResourceName() .. '] ' .. msg)
    end
end
