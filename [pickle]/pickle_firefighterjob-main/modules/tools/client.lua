local CarryingPlayer = false
local Carried = false

function CarryPlayer()
    local player = GetClosestPlayer()
    if not player then return ShowNotification(_L("nobody_near")) end
    TriggerServerEvent("pickle_firefighterjob:carryPlayer", player)
end

function BreakDoor()
    if Sawing then return end
    local vehicle = GetNearestVehicle(coords, radius) 
    if not vehicle then return ShowNotification(_L("no_vehicle_near")) end
    local door = GetClosestVehicleDoor(vehicle)
    if not door then return ShowNotification(_L("no_door_near")) end
    local Sawing = true
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local object = CreateProp(`v_ind_cs_powersaw`, coords.x, coords.y, coords.z, true, true, false)
    local boneIndex = GetPedBoneIndex(ped, 57005)
    local off, rot = vector3(0.2, 0.0, 0.0), vector3(100.0, -90.0, 15.0)
    AttachEntityToEntity(object, ped, boneIndex, off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false, true, 2, true)
    local SawEffect = PlayEffect("cut_prologue", "cs_pro_train_sparks", object, vector3(-0.5, 0.0, -0.25), vector3(0.0, 45.0, 180.0), 0.3, true)
    CreateThread(function()
        while Sawing do
            local ped = PlayerPedId()
            if not IsEntityPlayingAnim(ped, "weapons@misc@fire_ext", "aim_low_loop", 13) then
                PlayAnim(ped, "weapons@misc@fire_ext", "aim_low_loop", -8.0, 8.0, -1, 1, 1.0)
                Wait(100)
            end
            Wait(0)
        end
        local ped = PlayerPedId()
        DeleteEntity(object)
        ClearPedTasks(ped)
    end)
    local result
    for i=1, 3 do 
        result = lib.skillCheck({'easy', 'medium', 'easy'}, {'e'})
        if not result then
            break
        end
        Wait(1000)
    end
    Sawing = false
    if result then 
        TriggerServerEvent("pickle_firefighterjob:removeDoor", VehToNet(vehicle), door)
    else
        ShowNotification(_L("action_failed"))
    end
end

function DragoutPlayer()
    local player = GetClosestPlayer()
    if not player then return ShowNotification(_L("nobody_near")) end
    local ped = GetPlayerPed(GetPlayerFromServerId(player))
    if not DoesEntityExist(GetVehiclePedIsIn(ped, false)) then return ShowNotification(_L("no_vehicle_near")) end
    TriggerServerEvent("pickle_firefighterjob:dragoutPlayer", player)
end

function OpenToolsMenu()
    local id = 'firefighter_tools'
    lib.registerContext({
        id = id,
        title = _L("tools_title"),
        options = {
            {
                title = _L("tools_carry_title"),
                description = _L("tools_carry_desc"),
                onSelect = function()
                    CarryPlayer()
                end
            },
            {
                title = _L("tools_breakdoor_title"),
                description = _L("tools_breakdoor_desc"),
                onSelect = function()
                    BreakDoor()
                end
            },
            {
                title = _L("tools_dragout_title"),
                description = _L("tools_dragout_desc"),
                onSelect = function()
                    DragoutPlayer()
                end
            },
        }
    })
    lib.showContext(id)
end

RegisterNetEvent("pickle_firefighterjob:removeDoor", function(net_id, door_id)
    if not NetworkDoesNetworkIdExist(net_id) then return end
    local vehicle = NetToVeh(net_id)
    local passengers = GetVehicleNumberOfPassengers(vehicle) + (IsVehicleSeatFree(vehicle, -1) and 0 or 1)
    if passengers > 0 and GetVehiclePedIsIn(PlayerPedId(), false) == vehicle then
        SetVehicleDoorBroken(vehicle, door_id, false)
    else
        NetworkRequestControlOfNetworkId(net_id)
        for i=1, 10 do
            if NetworkHasControlOfNetworkId(net_id) then break end 
            Wait(10)
        end
        if not NetworkHasControlOfNetworkId(net_id) then return end
        SetVehicleDoorBroken(vehicle, door_id, false)
    end
end)

RegisterNetEvent("pickle_firefighterjob:startCarryEvent", function(player, isVictim)
    if isVictim then 
        local ped = PlayerPedId()
        local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
        if not DoesEntityExist(playerPed) then return end
        local boneIndex = GetPedBoneIndex(playerPed, 60309)
        local off, rot = vector3(0.15, 0.3, 0.85), vector3(-45.0, 0.0, 0.0)
        AttachEntityToEntity(ped, playerPed, boneIndex, off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false, true, 2, true)
        Carried = true
        CreateThread(function()
            while Carried do 
                local ped = PlayerPedId()
                if not IsEntityPlayingAnim(ped, "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", 13) then
                    PlayAnim(ped, "anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_idle_nowork", -8.0, 8.0, -1, 1, 1.0)
                    Wait(100)
                end
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                Wait(0)
            end
            local ped = PlayerPedId()
            ClearPedTasks(ped)
        end)
    else
        CarryingPlayer = true
        CreateThread(function()
            while CarryingPlayer do 
                local ped = PlayerPedId()
                if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 13) then
                    PlayAnim(ped, "anim@heists@box_carry@", "idle", -8.0, 8.0, -1, 49, 1.0)
                    Wait(100)
                end
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                Wait(0)
            end
            local ped = PlayerPedId()
            ClearPedTasks(ped)
        end)
    end
end)

RegisterNetEvent("pickle_firefighterjob:stopCarryEvent", function(player, isVictim)
    if isVictim then 
        Carried = false
    else
        CarryingPlayer = false
    end
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent("pickle_firefighterjob:dragoutPlayer", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not DoesEntityExist(vehicle) then return end
    TaskLeaveVehicle(ped, vehicle, 0) 
end)

RegisterCommand("firetools", function()
    OpenToolsMenu()
end)