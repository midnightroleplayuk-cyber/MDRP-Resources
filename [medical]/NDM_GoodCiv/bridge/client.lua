-- Client-side framework bridge: only needs to know whether the local player is down.
Bridge = {}

local function started(res) return GetResourceState(res) == 'started' end

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if started('qbx_core') then return 'qbox' end
    if started('qb-core') then return 'qbcore' end
    if started('es_extended') then return 'esx' end
    return 'standalone'
end

Bridge.Name = detect()

local QBCore
if Bridge.Name == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local esxDead = false
if Bridge.Name == 'esx' then
    AddEventHandler('esx:onPlayerDeath', function() esxDead = true end)
    AddEventHandler('esx:onPlayerSpawn', function() esxDead = false end)
    AddEventHandler('esx_ambulancejob:revive', function() esxDead = false end)
end

---True while the local player is dead, in last stand, or otherwise incapacitated.
function Bridge.IsDowned()
    local ped = PlayerPedId()
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then return true end

    local state = LocalPlayer.state
    if state.isDead or state.isLaststand or state.dead then return true end

    -- osp_ambulance keeps its own death / last stand state and doesn't set framework metadata.
    if started('osp_ambulance') then
        local ok, dead = pcall(function() return exports.osp_ambulance:isDead() end)
        if ok then return dead == true end
    end

    if Bridge.Name == 'qbcore' then
        local meta = QBCore.Functions.GetPlayerData().metadata
        return meta ~= nil and (meta.isdead or meta.inlaststand) or false
    elseif Bridge.Name == 'qbox' then
        local data = exports.qbx_core:GetPlayerData()
        local meta = data and data.metadata
        return meta ~= nil and (meta.isdead or meta.inlaststand) or false
    elseif Bridge.Name == 'esx' then
        return esxDead
    end
    return false
end

-- Standalone revive used on hospital handover when no framework is running.
RegisterNetEvent('goodciv:client:standaloneRevive', function()
    if GetInvokingResource() then return end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    ClearPedTasksImmediately(ped)
end)
