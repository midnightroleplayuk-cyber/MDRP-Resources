-- ------------------------------------------------------------------------------
-- Framework / Client / QBCore
-- ------------------------------------------------------------------------------

local function bind()
    if not Fr.ShouldBind('qb') then return false end
    if GetResourceState('qb-core') ~= 'started' then return false end
    if GetResourceState('qbx_core') == 'started' and (not Config.Framework or Config.Framework == 'auto') then
        return false
    end

    Config.Framework = 'qb'
    QBCore = true
    Framework = exports['qb-core']:GetCoreObject()

    Fr.PlayerLoadedEvt = 'QBCore:Client:OnPlayerLoaded'
    Fr.PlayerUnloadEvt = 'QBCore:Client:OnPlayerUnload'

    Fr.TriggerCallback = function(name, cb, ...)
        if Framework and Framework.Functions and Framework.Functions.TriggerCallback then
            return Framework.Functions.TriggerCallback(name, cb, ...)
        elseif cb then
            cb(nil)
        end
    end

    Fr.GetPlayerData = function()
        return Framework and Framework.Functions.GetPlayerData() or {}
    end

    Fr.IsLoaded = function()
        local pd = Fr.GetPlayerData()
        return pd and pd.citizenid ~= nil
    end

    Fr.IsDead = function()
        local pd = Fr.GetPlayerData()
        return pd and (pd.metadata and pd.metadata.isdead) == true
    end

    Fr.GetJob = function()
        local pd = Fr.GetPlayerData()
        if not pd or not pd.job then return nil, 0 end
        return pd.job.name, tonumber(pd.job.grade and pd.job.grade.level) or 0
    end

    Fr.GetGang = function()
        local pd = Fr.GetPlayerData()
        if not pd or not pd.gang then return nil, 0 end
        return pd.gang.name, tonumber(pd.gang.grade and pd.gang.grade.level) or 0
    end

    Fr.MarkReady('qb')
    return true
end

CreateThread(function()
    if not Fr.ShouldBind('qb') then return end
    if bind() then return end
    if not Fr.WaitForResource('qb-core', 60000) then return end
    bind()
end)