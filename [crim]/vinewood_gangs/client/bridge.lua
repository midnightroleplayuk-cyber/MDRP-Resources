-- Notifications from this resource stay on screen for Config.Notify.duration unless they set their own time
do
    local notify = lib.notify
    lib.notify = function(data)
        if type(data) == 'table' and not data.duration then data.duration = Config.Notify and Config.Notify.duration or 7000 end
        return notify(data)
    end
end

ClientBridge = {}

local function started(res) return GetResourceState(res) == 'started' end

local framework = Config.Framework
if framework == 'auto' then
    if started('qbx_core') then framework = 'qbox'
    elseif started('qb-core') then framework = 'qb'
    elseif started('es_extended') then framework = 'esx'
    end
end

local QBCore, ESX
if framework == 'qb' then QBCore = exports['qb-core']:GetCoreObject() end
if framework == 'esx' then ESX = exports.es_extended:getSharedObject() end

function ClientBridge.GetJob()
    local data
    if framework == 'qbox' then data = exports.qbx_core:GetPlayerData()
    elseif framework == 'qb' then data = QBCore.Functions.GetPlayerData()
    elseif framework == 'esx' then data = ESX.GetPlayerData()
    end
    return data and data.job and data.job.name
end
