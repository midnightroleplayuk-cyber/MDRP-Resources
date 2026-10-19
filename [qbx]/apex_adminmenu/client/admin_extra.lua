-- ============================================================
-- Apex Admin Menu — added client features
-- ------------------------------------------------------------
-- These globals are wired into the existing menu builders
-- (playeroptions.lua / vehiclemenu.lua / selfoptions.lua). The
-- dialog confirmations they open are routed through the central
-- dialogResponse handler in main.lua (keyed by currentDialog).
-- ============================================================

-- Shared scratch state for dialogs that need extra context.
ApexPendingPlate = nil   -- plate awaiting a remove-vehicle confirm

local function notify(title, msg, ntype, icon)
    TriggerEvent('apex_adminmenu:notify', title, msg, ntype or 'info', icon)
end

-- ============================================================
-- DIMENSIONS — dialogs
-- ============================================================
ApexSetSelfDimensionDialog = function()
    ShowInputDialog(Strings.dialog_dimension, {
        { type = 'input', label = Strings.dimension_input_label, placeholder = Strings.dimension_input_placeholder }
    }, 'setSelfDimension')
end

ApexSetPlayerDimensionDialog = function(target, name)
    SetSelectedPlayer(target, name)
    ShowInputDialog(Strings.dialog_dimension, {
        { type = 'input', label = Strings.dimension_input_label, placeholder = Strings.dimension_input_placeholder }
    }, 'setPlayerDimension')
end

-- ============================================================
-- REMOVE MONEY — dialog (mirrors givePlayerMoney)
-- ============================================================
ApexRemovePlayerMoneyDialog = function(target, name)
    local dialogOptions = {
        { value = 'money', label = Strings.givemoney_select_option1 },
        { value = 'bank',  label = Strings.givemoney_select_option2 }
    }
    if Framework == 'esx' then
        dialogOptions[#dialogOptions + 1] = { value = 'black_money', label = Strings.givemoney_select_option3 }
    end

    SetSelectedPlayer(target, name)

    ShowInputDialog(Strings.dialog_removemoney, {
        { type = 'input',  label = Strings.removemoney_input_label, placeholder = Strings.removemoney_input_placeholder },
        { type = 'select', label = Strings.removemoney_select,      options = dialogOptions }
    }, 'removePlayerMoney')
end

-- ============================================================
-- TELEPORT INTO A PLAYER'S VEHICLE (recovery aid)
-- ============================================================
ApexTeleportIntoVehicle = function(target, name)
    CreateThread(function()
        local coords = lib.callback.await('apex_adminmenu:getPlayerCoords', false, target)
        if not coords then
            notify(Strings.notify_error, Strings.notify_invalidid_desc, 'error', 'fa-xmark')
            return
        end

        local ped = cache.ped
        -- Drop in slightly above the player so we stream their vehicle in.
        SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.0, false, false, false, false)

        local targetVeh = 0
        local tries = 0
        while tries < 60 do
            local tPed = GetPlayerPed(GetPlayerFromServerId(target))
            if tPed and tPed ~= 0 and DoesEntityExist(tPed) then
                local veh = GetVehiclePedIsIn(tPed, false)
                if veh and veh ~= 0 and DoesEntityExist(veh) then
                    targetVeh = veh
                    break
                end
            end
            tries = tries + 1
            Wait(50)
        end

        if targetVeh == 0 or not DoesEntityExist(targetVeh) then
            notify(Strings.notify_tp_vehicle_fail, Strings.notify_tp_vehicle_fail_desc:format(name or target), 'error', 'fa-car')
            return
        end

        -- Find a free seat, else force the driver seat.
        local seats = GetVehicleModelNumberOfSeats(GetEntityModel(targetVeh))
        local placed = false
        for s = -1, (seats - 2) do
            if IsVehicleSeatFree(targetVeh, s) then
                TaskWarpPedIntoVehicle(ped, targetVeh, s)
                placed = true
                break
            end
        end
        if not placed then
            TaskWarpPedIntoVehicle(ped, targetVeh, -1)
        end

        notify(Strings.notify_tp_vehicle_success, Strings.notify_tp_vehicle_success_desc:format(name or target), 'success', 'fa-car')
    end)
end

-- ============================================================
-- RECOVER / FLIP VEHICLE (sea / overturned)
-- ============================================================
RecoverVehicle = function()
    local ped = cache.ped
    local veh
    if IsPedInAnyVehicle(ped, false) then
        veh = GetVehiclePedIsIn(ped, false)
    else
        local coords = GetEntityCoords(ped)
        veh = GetClosestVehicle(coords.x, coords.y, coords.z, 8.0, 0, 71)
    end

    if not veh or veh == 0 or not DoesEntityExist(veh) then
        return notify(Strings.notify_error, Strings.notify_no_vehicle, 'error', 'fa-xmark')
    end

    -- Request control so we can move a networked / player-owned vehicle.
    local attempts = 0
    while not NetworkHasControlOfEntity(veh) and attempts < 20 do
        NetworkRequestControlOfEntity(veh)
        attempts = attempts + 1
        Wait(10)
    end

    local vcoords = GetEntityCoords(veh)
    local found, nodePos, nodeHeading = GetClosestVehicleNodeWithHeading(vcoords.x, vcoords.y, vcoords.z, 1, 3.0, 0)

    SetEntityAsMissionEntity(veh, true, true)
    if found and nodePos then
        SetEntityCoords(veh, nodePos.x, nodePos.y, nodePos.z + 0.5, false, false, false, false)
        SetEntityHeading(veh, nodeHeading or GetEntityHeading(veh))
    end

    -- Flip upright (keep current Z heading).
    local rot = GetEntityRotation(veh, 2)
    SetEntityRotation(veh, 0.0, 0.0, rot.z, 2, true)
    SetVehicleOnGroundProperly(veh)
    SetVehicleFixed(veh)
    SetVehicleEngineOn(veh, true, true, false)

    notify(Strings.vehicle_recovered, Strings.vehicle_recovered_desc, 'success', 'fa-check')
end

-- ============================================================
-- OWNED VEHICLES — view / add / remove submenu
-- ============================================================
ApexOpenOwnedVehicles = function(target, name)
    local list = lib.callback.await('apex_adminmenu:getOwnedVehicles', false, target) or {}

    local options = {
        {
            icon = 'fas fa-plus',
            label = Strings.owned_vehicles_add,
            description = Strings.owned_vehicles_add_desc,
            close = false
        }
    }

    if #list == 0 then
        options[#options + 1] = {
            icon = 'fas fa-car',
            label = Strings.owned_vehicles_none,
            description = Strings.owned_vehicles_none_desc,
            close = false
        }
    else
        for i = 1, #list do
            options[#options + 1] = {
                icon = 'fas fa-car-side',
                label = list[i].label,
                description = Strings.owned_vehicle_desc:format(list[i].plate),
                close = false
            }
        end
    end

    local menuTitle = Strings.owned_vehicles_menu:format(name)

    SendNUIMessage({
        action = 'openSubMenu',
        title = menuTitle,
        items = options,
        parent = Strings.player_options:format(name)
    })

    RegisterNUICallback('menuSelected', function(data, cb)
        if data.menu == menuTitle then
            if data.index == 0 then
                -- Add a vehicle.
                SetSelectedPlayer(target, name)
                ShowInputDialog(Strings.dialog_add_vehicle, {
                    { type = 'input', label = Strings.add_vehicle_model_label, placeholder = Strings.add_vehicle_model_placeholder },
                    { type = 'input', label = Strings.add_vehicle_plate_label, placeholder = Strings.add_vehicle_plate_placeholder }
                }, 'addOwnedVehicle')
            elseif #list > 0 then
                -- options[1] is "Add" (index 0); list[i] therefore lines up
                -- with NUI index i.
                local veh = list[data.index]
                if veh then
                    SetSelectedPlayer(target, name)
                    ApexPendingPlate = veh.plate
                    ShowInputDialog(Strings.dialog_remove_vehicle:format(veh.label), {}, 'removeOwnedVehicle')
                end
            end
        end
        cb('ok')
    end)
end

-- ============================================================
-- GIVE PED MENU TO A PLAYER
-- ============================================================
ApexGivePedMenu = function(target)
    TriggerServerEvent('apex_adminmenu:givePedMenu', target)
end

-- Target side: open an ox_lib context menu of peds so the player
-- can pick one for themselves. SetPed is defined in selfoptions.lua.
RegisterNetEvent('apex_adminmenu:openPedMenu', function()
    if type(Peds) ~= 'table' then return end

    local options = {}
    for i = 1, #Peds do
        local ped = Peds[i]
        options[#options + 1] = {
            title = ped.label,
            icon = 'user',
            onSelect = function()
                if SetPed then SetPed(ped.value) end
            end
        }
    end

    lib.registerContext({
        id = 'apex_admin_pedmenu',
        title = Strings.pedmenu_title,
        options = options
    })
    lib.showContext('apex_admin_pedmenu')
end)
