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

--- Whether the player holds any of these roles in one of the permission systems turned on in
--- config.lua. With checkGroups, an ESX player's group (admin, superadmin) counts as well as their job.
local function hasAnyRole(source, roles, checkGroups)
    local permission = false

    if Config.Enable_Night_DiscordApi_Permissions then
        local isPermitted = exports.night_discordapi:IsMemberPartOfAnyOfTheseRoles(source, roles, false)
        if isPermitted then
            permission = true
        end
    end

    if Config.Enable_Ace_Permissions then
        for _, role in ipairs(roles) do
            if IsPlayerAceAllowed(source, role) then
                permission = true
                break
            end
        end
    end

    if Config.Enable_ESX_Permissions then
        if ESX == nil then
            print('[' .. GetCurrentResourceName() .. '] ESX permissions are enabled, but ESX was not found.')
            return false
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local group = checkGroups and xPlayer.getGroup and xPlayer.getGroup() or nil
            for _, role in pairs(roles) do
                if xPlayer.job.name == role or group == role then
                    permission = true
                end
            end
        end
    end

    if Config.Enable_QBCore_Permissions.Check_By_Job then
        if QBCore == nil then
            print('[' .. GetCurrentResourceName() .. '] QBCore job permissions are enabled, but QBCore was not found.')
            return false
        end
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            for _, role in pairs(roles) do
                if player.PlayerData.job.name == role then
                    permission = true
                end
            end
        end
    end

    if Config.Enable_QBCore_Permissions.Check_By_Permissions then
        if QBCore == nil then
            print('[' .. GetCurrentResourceName() .. '] QBCore group permissions are enabled, but QBCore was not found.')
            return false
        end
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            for _, role in pairs(roles) do
                if QBCore.Functions.HasPermission(source, role) then
                    permission = true
                end
            end
        end
    end

    return permission
end

function CheckPermission(source)
    if Config.EveryoneHasPermission then
        return true
    end

    if #Config.PermissionRoles < 1 then
        print('[' .. GetCurrentResourceName() .. '] No permission roles are set in config.lua')
        return false
    end

    return hasAnyRole(source, Config.PermissionRoles, false)
end

--- Admin actions such as /cleartapes. Config.EveryoneHasPermission does not apply here.
function CheckAdminPermission(source)
    if source == 0 then
        return true
    end

    local command = Config.Commands and Config.Commands.Clear
    if command and command ~= '' and IsPlayerAceAllowed(source, 'command.' .. command) then
        return true
    end

    local roles = Config.Clear and Config.Clear.AdminRoles or {}
    if #roles < 1 then
        return false
    end

    return hasAnyRole(source, roles, true)
end

function DebugPrint(msg)
    if Config.Debug and msg ~= nil then
        print('[' .. GetCurrentResourceName() .. '] ' .. msg)
    end
end

local inventoryWarned = false

local function warnInventory(message)
    if inventoryWarned then return end
    inventoryWarned = true
    print('[' .. GetCurrentResourceName() .. '] ' .. message)
end

local function itemSettings()
    local item = Config.Item
    if type(item) ~= 'table' or not item.Enabled then
        return nil
    end
    if type(item.Name) ~= 'string' or item.Name == '' then
        warnInventory('Item check is enabled, but Config.Item.Name is empty.')
        return nil
    end
    return item
end

local function ensureESX()
    if ESX ~= nil then return ESX end
    if GetResourceState('es_extended') ~= 'started' then return nil end
    ESX = exports['es_extended']:getSharedObject()
    return ESX
end

local function ensureQBCore()
    if QBCore ~= nil then return QBCore end
    if GetResourceState('qb-core') ~= 'started' then return nil end
    QBCore = exports['qb-core']:GetCoreObject()
    return QBCore
end

local function inventorySystem()
    local item = itemSettings()
    if not item then return nil end
    local system = item.System or 'auto'
    if system ~= 'auto' then
        return system
    end
    if GetResourceState('ox_inventory') == 'started' then return 'ox' end
    if GetResourceState('qbx_core') == 'started' then return 'qbox' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    warnInventory('Item check is enabled, but no ESX, ox_inventory, QBCore, or Qbox inventory was found.')
    return nil
end

local function oxCount(source, name)
    local count = exports.ox_inventory:Search(source, 'count', name)
    return tonumber(count) or 0
end

local function qbCount(player, name)
    if not player or not player.Functions or not player.Functions.GetItemByName then
        return nil
    end
    local item = player.Functions.GetItemByName(name)
    if not item then return 0 end
    return tonumber(item.amount or item.count) or 0
end

function PlayerHasTapeItem(source)
    local item = itemSettings()
    if not item then return true end
    local system = inventorySystem()
    if not system then return false end
    local name = item.Name

    if system == 'ox' then
        if GetResourceState('ox_inventory') ~= 'started' then
            warnInventory('Inventory system is ox, but ox_inventory is not started.')
            return false
        end
        return oxCount(source, name) >= 1
    end

    if system == 'esx' then
        local esx = ensureESX()
        if not esx then
            warnInventory('Inventory system is esx, but es_extended is not started.')
            return false
        end
        local xPlayer = esx.GetPlayerFromId(source)
        if not xPlayer then return false end
        local carried = xPlayer.getInventoryItem(name)
        local count = carried and tonumber(carried.count or carried.amount) or 0
        return count >= 1
    end

    if system == 'qb' then
        local core = ensureQBCore()
        if not core then
            warnInventory('Inventory system is qb, but qb-core is not started.')
            return false
        end
        local count = qbCount(core.Functions.GetPlayer(source), name)
        return count ~= nil and count >= 1
    end

    if system == 'qbox' then
        if GetResourceState('qbx_core') ~= 'started' then
            warnInventory('Inventory system is qbox, but qbx_core is not started.')
            return false
        end
        local player = exports.qbx_core:GetPlayer(source)
        local count = qbCount(player, name)
        if count == nil and GetResourceState('ox_inventory') == 'started' then
            return oxCount(source, name) >= 1
        end
        return count ~= nil and count >= 1
    end

    warnInventory('Unknown Config.Item.System "' .. tostring(system) .. '". Use auto, esx, ox, qb, or qbox.')
    return false
end

local function changeTapeItem(source, delta)
    local item = itemSettings()
    if not item then return true end
    local system = inventorySystem()
    if not system then return false end
    local name = item.Name

    if system == 'ox' then
        if delta < 0 then
            return exports.ox_inventory:RemoveItem(source, name, -delta) == true
        end
        return exports.ox_inventory:AddItem(source, name, delta) == true
    end

    if system == 'esx' then
        local esx = ensureESX()
        local xPlayer = esx and esx.GetPlayerFromId(source) or nil
        if not xPlayer then return false end
        if delta < 0 then
            xPlayer.removeInventoryItem(name, -delta)
        else
            xPlayer.addInventoryItem(name, delta)
        end
        return true
    end

    local player = nil
    if system == 'qb' then
        local core = ensureQBCore()
        player = core and core.Functions.GetPlayer(source) or nil
    elseif system == 'qbox' then
        if GetResourceState('qbx_core') == 'started' then
            player = exports.qbx_core:GetPlayer(source)
        end
        if (not player or not player.Functions or not player.Functions.RemoveItem) and GetResourceState('ox_inventory') == 'started' then
            if delta < 0 then
                return exports.ox_inventory:RemoveItem(source, name, -delta) == true
            end
            return exports.ox_inventory:AddItem(source, name, delta) == true
        end
    else
        return false
    end

    if not player or not player.Functions then return false end
    local result
    if delta < 0 then
        result = player.Functions.RemoveItem(name, -delta)
    else
        result = player.Functions.AddItem(name, delta)
    end
    -- Older QBCore builds remove the item and return nothing.
    return result ~= false
end

--- Returns whether placing may go ahead, and whether an item was actually taken.
function TakeTapeItem(source)
    local item = itemSettings()
    if not item or not item.RemoveOnPlace then
        return true, false
    end
    if not PlayerHasTapeItem(source) then
        return false, false
    end
    local taken = changeTapeItem(source, -1)
    return taken, taken
end

function ReturnTapeItem(source)
    local item = itemSettings()
    if not item or not item.RemoveOnPlace or not item.ReturnOnRemove then
        return true
    end
    return changeTapeItem(source, 1)
end
