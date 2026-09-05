-- ------------------------------------------------------------------------------
-- Framework / Client / QBox
-- ------------------------------------------------------------------------------

local function bind()
    if not Fr.ShouldBind('qbox') then return false end
    if GetResourceState('qbx_core') ~= 'started' then return false end

    Config.Framework = 'qbox'
    QBX = true
    Framework = exports.qbx_core

    Fr.PlayerLoadedEvt = 'QBCore:Client:OnPlayerLoaded'
    Fr.PlayerUnloadEvt = 'QBCore:Client:OnPlayerUnload'

    Fr.TriggerCallback = function(name, cb, ...)
        if lib and lib.callback then
            local args = { ... }
            CreateThread(function()
                local res = lib.callback.await(name, false, table.unpack(args))
                if cb then cb(res) end
            end)
            return
        end
        if cb then cb(nil) end
    end

    Fr.GetPlayerData = function()
        return (Framework and Framework.GetPlayerData and Framework:GetPlayerData()) or {}
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

    Fr.MarkReady('qbox')
    return true
end

CreateThread(function()
    if not Fr.ShouldBind('qbox') then return end
    if bind() then return end
    if not Fr.WaitForResource('qbx_core', 60000) then return end
    bind()
end)