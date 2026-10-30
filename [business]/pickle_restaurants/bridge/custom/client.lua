-- Standalone bridge (client). Only runs when no supported framework is present.
if GetResourceState('es_extended') == 'started' then return end
-- Mirror of bridge/qb/client.lua's guard (and of the pair on the server): QBox runs
-- as `qbx_core` but registers the `qb-core` exports, so the QB bridge drives it
-- whenever that core object is reachable and we only stand in when it isn't.
if GetResourceState('qb-core') == 'started' then return end
if GetResourceState('qbx_core') == 'started' then
    local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
    if ok and type(core) == "table" then return end
end

function ShowNotification(text)
    lib.notify({ description = text })
end

RegisterNetEvent(GetCurrentResourceName() .. ":showNotification", function(text)
    ShowNotification(text)
end)

-- ─── inventory ───────────────────────────────────────────────────────────────
-- The client half is only the item catalogue mirror; bridge/inventory/client.lua
-- is the one copy of it.
CreateThread(function()
    Wait(100)
    InitializeInventory()
end)
