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

-- osp_ambulance stage events: 1 = last stand (crawling), 2 = stage 2 death (no signs of life).
local ospStage = 0
RegisterNetEvent('osp_ambulance:OnPlayerLastStand', function(on) ospStage = on and 1 or 0 end)
RegisterNetEvent('osp_ambulance:OnPlayerDeath', function() ospStage = 2 end)
RegisterNetEvent('osp_ambulance:OnPlayerDead', function() if ospStage == 0 then ospStage = 1 end end)
RegisterNetEvent('osp_ambulance:OnPlayerSpawn', function() ospStage = 0 end)
AddEventHandler('hospital:client:Revive', function() ospStage = 0 end)

---0 = up, 1 = last stand (down but alive), 2 = dead / no signs of life.
function Bridge.DownedStage()
    local state = LocalPlayer.state

    -- osp_ambulance keeps its own death / last stand state and doesn't set framework metadata.
    if started('osp_ambulance') then
        if ospStage > 0 then return ospStage end
        local bd = state.BodyDamage
        if type(bd) == 'table' then
            if bd.isDead then return 2 end
            if bd.inLastStand then return 1 end
        end
        return 0
    end

    local ped = PlayerPedId()
    if state.isDead or state.dead then return 2 end
    if state.isLaststand then return 1 end

    local meta
    if Bridge.Name == 'qbcore' then
        meta = QBCore.Functions.GetPlayerData().metadata
    elseif Bridge.Name == 'qbox' then
        local data = exports.qbx_core:GetPlayerData()
        meta = data and data.metadata
    elseif Bridge.Name == 'esx' and esxDead then
        return 2
    end
    if meta then
        if meta.isdead then return 2 end
        if meta.inlaststand then return 1 end
    end
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then return 2 end
    return 0
end

---True while the local player is dead, in last stand, or otherwise incapacitated.
function Bridge.IsDowned()
    return Bridge.DownedStage() > 0
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
