--[[
    Client bridge: notifications and target (ox_target / qb-target). Open file (escrow_ignore).
]]

ClientBridge = {}

local ESX, QBCore
local function started(res) return GetResourceState(res) == 'started' end

local fw = Config.Framework
if fw == 'auto' then
    if started('qbx_core') then fw = 'qbox'
    elseif started('qb-core') then fw = 'qb'
    elseif started('es_extended') then fw = 'esx'
    else fw = 'standalone' end
end
ClientBridge.Framework = fw
if fw == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif fw == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function ClientBridge.Notify(message, nType)
    nType = nType or 'inform'
    if Config.Notify == 'framework' then
        if ESX then return ESX.ShowNotification(message) end
        if QBCore then
            local map = { inform = 'primary', success = 'success', error = 'error', warning = 'error' }
            return QBCore.Functions.Notify(message, map[nType] or 'primary', 5000)
        end
    end
    lib.notify({ title = _L('title'), description = message, type = nType, icon = 'circle-dot' })
end

RegisterNetEvent('rex_pool:client:notify', function(message, nType)
    ClientBridge.Notify(message, nType)
end)

local target = Config.Target
if target == 'auto' then
    target = started('ox_target') and 'ox_target' or (started('qb-target') and 'qb-target' or 'none')
end
ClientBridge.Target = target

---Registers interaction options on every supported table model.
---options = { { name, label, icon, onSelect(entity), canInteract(entity) } }
function ClientBridge.AddTableTarget(models, options)
    if target == 'ox_target' then
        local opts = {}
        for i, o in ipairs(options) do
            opts[i] = {
                name = 'rex_pool_' .. o.name, label = o.label, icon = 'fa-solid fa-' .. o.icon,
                distance = Config.InteractDistance + 1.2,
                onSelect = function(data) o.onSelect(data.entity) end,
                canInteract = o.canInteract and function(entity) return o.canInteract(entity) end or nil,
            }
        end
        exports.ox_target:addModel(models, opts)
        return true
    elseif target == 'qb-target' then
        local opts = {}
        for i, o in ipairs(options) do
            opts[i] = {
                label = o.label, icon = 'fas fa-' .. o.icon,
                action = function(entity) o.onSelect(entity) end,
                canInteract = o.canInteract and function(entity) return o.canInteract(entity) end or nil,
            }
        end
        exports['qb-target']:AddTargetModel(models, { options = opts, distance = Config.InteractDistance + 1.2 })
        return true
    end
    return false
end

function ClientBridge.RemoveTableTarget(models, names)
    if target == 'ox_target' then
        local list = {}
        for i, n in ipairs(names) do list[i] = 'rex_pool_' .. n end
        exports.ox_target:removeModel(models, list)
    elseif target == 'qb-target' then
        exports['qb-target']:RemoveTargetModel(models)
    end
end
