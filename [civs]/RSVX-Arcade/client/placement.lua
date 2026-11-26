local placing = false

local function camRay(ignore)
    local rot, from = GetGameplayCamRot(2), GetGameplayCamCoord()
    local rx, rz = math.rad(rot.x), math.rad(rot.z)
    local cosx = math.abs(math.cos(rx))
    local to = from + vec3(-math.sin(rz) * cosx, math.cos(rz) * cosx, math.sin(rx)) * 12.0
    local handle = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, 17, ignore, 4)
    local _, hit, coords = GetShapeTestResult(handle)
    return hit == 1, coords
end

local function preview(game)
    local cfg = Config.Machines[game]
    local model = ArcadeModel(cfg)
    local facing = 0.0
    if not IsModelValid(model) then
        return lib.notify({ title = 'Arcade', description = 'This machine has no valid model set.', type = 'error' })
    end

    placing = true
    lib.requestModel(model, 5000)
    local ped = cache.ped
    local start = GetEntityCoords(ped)
    local ghost = CreateObjectNoOffset(model, start.x, start.y, start.z, false, false, false)
    SetEntityCollision(ghost, false, false)
    FreezeEntityPosition(ghost, true)

    lib.showTextUI('[E] Place  \n[Scroll] Rotate  \n[Backspace] Cancel')

    local turn, coords, heading = 0.0, nil, nil
    while placing do
        Wait(0)
        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)
        DisableControlAction(0, 16, true)
        DisableControlAction(0, 17, true)
        DisablePlayerFiring(cache.playerId, true)

        if IsDisabledControlJustPressed(0, 14) then turn -= 7.5 end
        if IsDisabledControlJustPressed(0, 15) then turn += 7.5 end

        local hit, pos = camRay(ghost)
        local ok = hit and #(pos - GetEntityCoords(ped)) <= Config.PlaceDistance
        if hit then
            SetEntityCoordsNoOffset(ghost, pos.x, pos.y, pos.z, false, false, false)
            SetEntityHeading(ghost, (GetEntityHeading(ped) + facing + turn) % 360.0)
        end
        SetEntityAlpha(ghost, ok and 200 or 70, false)

        if IsControlJustPressed(0, 38) and ok then
            coords, heading = GetEntityCoords(ghost), GetEntityHeading(ghost)
            break
        end
        if IsControlJustPressed(0, 177) or IsPedDeadOrDying(ped, true) or IsPedInAnyVehicle(ped, false) then
            break
        end
    end

    lib.hideTextUI()
    DeleteEntity(ghost)
    SetModelAsNoLongerNeeded(model)
    placing = false

    return coords, heading
end

local function place(game, slot)
    local coords, heading = preview(game)
    if not coords then return end
    local ok, err = lib.callback.await('rsvx_arcade:place', false, slot, coords, heading)
    if not ok then
        lib.notify({ title = 'Arcade', description = err, type = 'error' })
    end
end

RegisterCommand('arcadeplace', function(_, args)
    local game = args[1] and args[1]:lower()
    if not game or not Config.Machines[game] then
        local keys = {}
        for k in pairs(Config.Machines) do keys[#keys + 1] = k end
        table.sort(keys)
        return lib.notify({ title = 'Arcade', description = 'Usage: /arcadeplace <game>  \n' .. table.concat(keys, ', '), type = 'inform' })
    end
    if placing then return end
    CreateThread(function()
        local coords, heading = preview(game)
        if not coords then return end
        local ok, err = lib.callback.await('rsvx_arcade:placePermanent', false, game, coords, heading)
        lib.notify({ title = 'Arcade', description = ok and 'Permanent machine placed.' or err, type = ok and 'success' or 'error' })
    end)
end, false)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/arcadeplace', 'Place a permanent arcade machine (admin)', {
        { name = 'game', help = 'snake, brickfall, rally, siege, whack, hoops, strength, claw, fortune, love' },
    })
end)

exports('useMachine', function(data, slot)
    if placing then return end
    for game, cfg in pairs(Config.Machines) do
        if cfg.item == data.name then
            exports.ox_inventory:closeInventory()
            CreateThread(function() place(game, slot.slot) end)
            return
        end
    end
end)
