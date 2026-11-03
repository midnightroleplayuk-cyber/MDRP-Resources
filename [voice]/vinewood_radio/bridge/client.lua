Bridge = {}

local FW, Core

if GetResourceState('qbx_core') ~= 'missing' then
    FW = 'qbx'
elseif GetResourceState('qb-core') ~= 'missing' then
    FW = 'qb'
    Core = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') ~= 'missing' then
    FW = 'esx'
    Core = exports.es_extended:getSharedObject()
end

Bridge.Framework = FW

function Bridge.HasItem(item)
    if GetResourceState('ox_inventory') == 'started' then
        return (exports.ox_inventory:Search('count', item) or 0) > 0
    end
    if FW == 'qb' then return Core.Functions.HasItem(item) end
    if FW == 'esx' then
        for _, v in pairs(Core.GetPlayerData().inventory or {}) do
            if v.name == item and (v.count or 0) > 0 then return true end
        end
        return false
    end
    return true
end

-- Fires whenever job/duty might have changed, so the server can re-check access
function Bridge.OnJobChange(cb)
    RegisterNetEvent('QBCore:Client:OnJobUpdate', cb)
    RegisterNetEvent('QBCore:Client:SetDuty', cb)
    RegisterNetEvent('esx:setJob', cb)
end

function Bridge.OnLogout(cb)
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', cb)
    RegisterNetEvent('qbx_core:client:playerLoggedOut', cb)
    RegisterNetEvent('esx:onPlayerLogout', cb)
end
