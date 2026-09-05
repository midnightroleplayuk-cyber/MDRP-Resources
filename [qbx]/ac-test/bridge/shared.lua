-- CoreFx Bridge - Shared config & framework detection
Bridge = Bridge or {}

function Bridge.DetectFramework()
    if GetResourceState('qbx_core') == 'started' then
        Bridge.Framework = 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        Bridge.Framework = 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        Bridge.Framework = 'esx'
    else
        Bridge.Framework = 'standalone'
    end
    
    return Bridge.Framework
end

Bridge.DetectFramework()

Bridge.HasOxLib = GetResourceState('ox_lib') == 'started'
Bridge.HasOxMySQL = GetResourceState('oxmysql') == 'started'

-- check active inventory system
if GetResourceState('ox_inventory') == 'started' then
    Bridge.Inventory = 'ox'
elseif GetResourceState('qb-inventory') == 'started' or GetResourceState('ps-inventory') == 'started' or GetResourceState('lj-inventory') == 'started' then
    Bridge.Inventory = 'qb'
elseif GetResourceState('qs-inventory') == 'started' then
    Bridge.Inventory = 'qs'
else
    Bridge.Inventory = 'default'
end
