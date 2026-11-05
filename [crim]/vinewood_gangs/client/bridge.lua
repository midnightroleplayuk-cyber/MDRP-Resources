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
