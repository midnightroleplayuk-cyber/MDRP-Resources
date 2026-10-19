-- ============================================================
-- Object Remover — admin laser pointer for deleting world objects
-- Mirrors the Developer "Debug Mode" rendering: a single line from
-- the admin's ped to the hit point + a marker + entity outline. No
-- crosshair / NUI overlay.
-- ============================================================

local removerActive = false
local LASER_MAX_DIST = 1000.0
local LASER_PROTECTED_PEDS       = true
local LASER_PROTECTED_VEH_OWNERS = true

-- Rotation → direction vector (same maths Debug Mode uses).
local function rotationToDirection(rotation)
    local rx = (math.pi / 180) * rotation.x
    local rz = (math.pi / 180) * rotation.z
    return {
        x = -math.sin(rz) * math.abs(math.cos(rx)),
        y =  math.cos(rz) * math.abs(math.cos(rx)),
        z =  math.sin(rx)
    }
end

local function rayCastGamePlayCamera(distance)
    local camRot   = GetGameplayCamRot()
    local camCoord = GetGameplayCamCoord()
    local dir      = rotationToDirection(camRot)
    local destX = camCoord.x + dir.x * distance
    local destY = camCoord.y + dir.y * distance
    local destZ = camCoord.z + dir.z * distance
    local _, hit, coords, _, entity = GetShapeTestResult(
        StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z,
                          destX, destY, destZ, -1, -1, 1))
    return hit == 1, coords, entity
end

local function canDelete(entity)
    if not DoesEntityExist(entity) then return false, 'No entity' end
    if IsEntityAPed(entity) and IsPedAPlayer(entity) and LASER_PROTECTED_PEDS then
        return false, 'Cannot delete player peds'
    end
    if GetEntityType(entity) == 2 and LASER_PROTECTED_VEH_OWNERS then
        for i = -1, 6 do
            local p = GetPedInVehicleSeat(entity, i)
            if p ~= 0 and IsPedAPlayer(p) then
                return false, 'Vehicle has players inside'
            end
        end
    end
    return true
end

local function adminDeleteEntity(entity)
    if not DoesEntityExist(entity) then return end
    if NetworkGetEntityIsNetworked(entity) then
        local netId = NetworkGetNetworkIdFromEntity(entity)
        SetNetworkIdCanMigrate(netId, true)
        NetworkRequestControlOfEntity(entity)
        local tries = 0
        while not NetworkHasControlOfEntity(entity) and tries < 20 do
            Wait(20); tries = tries + 1
        end
    end
    SetEntityAsMissionEntity(entity, true, true)
    DeleteEntity(entity)
    if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
        TriggerServerEvent('apex_adminmenu:laserDeleteEntity',
            NetworkGetNetworkIdFromEntity(entity))
    end
end

StartObjectRemover = function()
    if removerActive then return end
    removerActive = true

    -- Close any open admin menu first so the laser thread owns input.
    TriggerEvent('apex_adminmenu:internal:closeMenu')
    SendNUIMessage({ action = 'closeMenu' })
    SetNuiFocus(false, false)

    TriggerEvent('apex_adminmenu:notify', 'Object Remover',
        'Aim and press [E] to delete · ESC to exit', 'info')

    CreateThread(function()
        local outLined

        while removerActive do
            local position = GetEntityCoords(cache.ped)
            local hit, coords, entity = rayCastGamePlayCamera(LASER_MAX_DIST)

            if hit then
                -- Beam from the admin ped's center mass to the hit point.
                DrawLine(position.x, position.y, position.z,
                         coords.x,    coords.y,    coords.z,
                         255, 0, 0, 255)
                -- Small marker at the impact point.
                DrawMarker(28,
                    coords.x, coords.y, coords.z,
                    0.0, 0.0, 0.0,  0.0, 0.0, 0.0,
                    0.135, 0.25, 0.25,
                    255, 0, 0, 50,
                    false, true, 2, true, nil, nil, false)

                if entity and entity ~= 0 and DoesEntityExist(entity) then
                    -- Highlight the entity (except peds, like Debug Mode).
                    if not IsEntityAPed(entity) and outLined ~= entity then
                        if outLined then SetEntityDrawOutline(outLined, false) end
                        outLined = entity
                        SetEntityDrawOutline(outLined, true)
                        SetEntityDrawOutlineColor(255, 0, 0, 255)
                    end

                    -- E -> delete
                    if IsControlJustReleased(0, 38) then
                        local ok, err = canDelete(entity)
                        if ok then
                            if outLined then
                                SetEntityDrawOutline(outLined, false)
                                outLined = nil
                            end
                            adminDeleteEntity(entity)
                            TriggerEvent('apex_adminmenu:notify',
                                'Removed', 'Entity deleted', 'success')
                            TriggerServerEvent('apex_adminmenu:logUtilityAction',
                                'objectRemoverDelete',
                                ('hash=%s'):format(GetEntityModel(entity)))
                        else
                            TriggerEvent('apex_adminmenu:notify',
                                'Blocked', err or 'Cannot delete this entity', 'error')
                        end
                    end
                else
                    if outLined then
                        SetEntityDrawOutline(outLined, false)
                        outLined = nil
                    end
                end
            else
                if outLined then
                    SetEntityDrawOutline(outLined, false)
                    outLined = nil
                end
            end

            -- ESC -> exit
            if IsControlJustReleased(0, 322) then
                if outLined then
                    SetEntityDrawOutline(outLined, false)
                    outLined = nil
                end
                StopObjectRemover()
                break
            end

            Wait(0)
        end

        if outLined then
            SetEntityDrawOutline(outLined, false)
            outLined = nil
        end
    end)
end

StopObjectRemover = function()
    if not removerActive then return end
    removerActive = false
    TriggerEvent('apex_adminmenu:notify', 'Object Remover', 'Disabled', 'info')
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and removerActive then
        StopObjectRemover()
    end
end)

RegisterNetEvent('apex_adminmenu:laserDeleteEntityClient', function(netId)
    local entity = NetworkDoesEntityExistWithNetworkId(netId)
        and NetworkGetEntityFromNetworkId(netId) or 0
    if entity ~= 0 and DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end)
