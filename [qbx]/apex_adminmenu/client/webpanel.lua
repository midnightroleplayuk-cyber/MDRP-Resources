-- ============================================================
-- WEB PANEL — client side
-- ------------------------------------------------------------
-- Handlers for the actions the web panel relay dispatches. Without
-- these the panel queues commands that nothing ever answers, which is
-- exactly how "clicking does nothing" happens.
--
-- See server/webpanel.lua for the transport.
--
-- Screen watch (the panel's Live Watch) is NOT here any more. It used to
-- run its own capture loop on this file, through screenshot-basic only:
-- on a server without that optional resource the browser's eye icon did
-- nothing but close its tile again, while the in-game Monitoring page
-- (own NUI capture) worked. The browser now rides the same stream the
-- in-game page uses — specBegin / spec:grab / specFrame in
-- client/adminpanel.lua — so both see the same frames and a client needs
-- nothing extra installed.
-- ============================================================

-- ── Vehicle actions ─────────────────────────────────────────

local function currentVehicle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then return GetVehiclePedIsIn(ped, false) end
    local c = GetEntityCoords(ped)
    local veh = GetClosestVehicle(c.x, c.y, c.z, 6.0, 0, 71)
    return (veh and veh ~= 0 and DoesEntityExist(veh)) and veh or nil
end

RegisterNetEvent('apex_adminmenu:panel:fixVehicle', function()
    local veh = currentVehicle()
    if not veh then return end
    SetVehicleFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehicleBodyHealth(veh, 1000.0)
    SetVehiclePetrolTankHealth(veh, 1000.0)
    SetVehicleDirtLevel(veh, 0.0)
    TriggerEvent('apex_adminmenu:notify', 'Web panel', 'Vehicle repaired', 'success')
end)

RegisterNetEvent('apex_adminmenu:panel:cleanVehicle', function()
    local veh = currentVehicle()
    if not veh then return end
    SetVehicleDirtLevel(veh, 0.0)
    WashDecalsFromVehicle(veh, 1.0)
    TriggerEvent('apex_adminmenu:notify', 'Web panel', 'Vehicle cleaned', 'success')
end)

RegisterNetEvent('apex_adminmenu:panel:spawnVehicle', function(model)
    model = tostring(model or 'adder')
    local hash = joaat(model)
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        TriggerEvent('apex_adminmenu:notify', 'Web panel', ('Unknown vehicle: %s'):format(model), 'error')
        return
    end

    lib.requestModel(hash, 10000)
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local veh = CreateVehicle(hash, c.x, c.y, c.z + 1.0, GetEntityHeading(ped), true, false)
    SetVehicleOnGroundProperly(veh)
    SetVehicleEngineOn(veh, true, true, false)
    TaskWarpPedIntoVehicle(ped, veh, -1)
    SetModelAsNoLongerNeeded(hash)
    TriggerEvent('apex_adminmenu:notify', 'Web panel', ('Spawned %s'):format(model), 'success')
end)

-- Older servers sent these two to start a screenshot-basic loop here. A
-- server running this build never does; they stay registered so a stale
-- panel build queuing them produces nothing worse than a no-op.
RegisterNetEvent('apex_adminmenu:panel:startWatch', function() end)
RegisterNetEvent('apex_adminmenu:panel:stopWatch',  function() end)
