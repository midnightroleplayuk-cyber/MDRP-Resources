CBridge = {}

local function started(r) return GetResourceState(r) == 'started' end

function CBridge.IsLoggedIn()
    if LocalPlayer.state.isLoggedIn then return true end
    if started('es_extended') then
        local ok, loaded = pcall(function() return exports.es_extended:getSharedObject().IsPlayerLoaded() end)
        if ok and loaded then return true end
    end
    return false
end

function CBridge.Notify(text, kind)
    lib.notify({ description = text, type = kind or 'inform' })
end
