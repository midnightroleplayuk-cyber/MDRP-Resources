-- ------------------------------------------------------------------------------
-- Framework / Client / ESX
-- ------------------------------------------------------------------------------

local function bind()
    if not Fr.ShouldBind('esx') then return false end
    if GetResourceState('es_extended') ~= 'started' then return false end

    Config.Framework = 'esx'
    ESX = true
    Framework = exports['es_extended']:getSharedObject()

    Fr.PlayerLoadedEvt = 'esx:playerLoaded'
    Fr.PlayerUnloadEvt = 'esx:onPlayerLogout'

    Fr.TriggerCallback = function(name, cb, ...)
        if Framework and Framework.TriggerServerCallback then
            return Framework.TriggerServerCallback(name, cb, ...)
        elseif cb then
            cb(nil)
        end
    end

    Fr.GetPlayerData = function()
        return Framework and Framework.GetPlayerData() or {}
    end

    Fr.IsLoaded = function()
        local pd = Fr.GetPlayerData()
        return pd and pd.identifier ~= nil
    end

    Fr.IsDead = function()
        local pd = Fr.GetPlayerData()
        return pd and pd.dead == true
    end

    Fr.GetJob = function()
        local pd = Fr.GetPlayerData()
        if not pd or not pd.job then return nil, 0 end
        return pd.job.name, tonumber(pd.job.grade) or 0
    end

    Fr.MarkReady('esx')
    return true
end

CreateThread(function()
    if not Fr.ShouldBind('esx') then return end
    if bind() then return end
    if not Fr.WaitForResource('es_extended', 60000) then return end
    bind()
end)