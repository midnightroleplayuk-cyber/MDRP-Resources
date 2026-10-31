-- Client bridge: notifications and character load/unload.
VPO.ClientBridge = {}
local CB = VPO.ClientBridge

local function notifySystem()
    local want = tostring(Config.Notify or 'auto'):lower()
    if want ~= 'auto' then return want end
    if lib and lib.notify then return 'ox' end
    if GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    return 'native'
end

local system = notifySystem()

function VPO.ClientNotify(message, kind, duration)
    kind = kind or 'inform'
    if system == 'ox' then
        lib.notify({ title = Config.Force.name, description = message, type = kind, duration = duration or 5000 })
    elseif system == 'qb' then
        TriggerEvent('QBCore:Notify', message, kind == 'inform' and 'primary' or kind, duration or 5000)
    elseif system == 'esx' then
        TriggerEvent('esx:showNotification', message, kind == 'inform' and 'info' or kind, duration or 5000)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

local loadedCbs, unloadedCbs = {}, {}
function CB.OnPlayerLoaded(cb) loadedCbs[#loadedCbs + 1] = cb end
function CB.OnPlayerUnloaded(cb) unloadedCbs[#unloadedCbs + 1] = cb end

local function fire(list)
    for _, cb in ipairs(list) do
        local ok, err = pcall(cb)
        if not ok then VPO.Log.error('client load handler failed: %s', err) end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() fire(loadedCbs) end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() fire(unloadedCbs) end)
RegisterNetEvent('esx:playerLoaded', function() fire(loadedCbs) end)
RegisterNetEvent('esx:onPlayerLogout', function() fire(unloadedCbs) end)
