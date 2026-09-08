--- Minigames
function LootingMinigame(coords, difficulty, duration)
    if not Config.lootingMinigame.enabled then
        return exports.kq_link:ProgressBar(coords, duration, 1)
    end
    return exports.kq_link:HoldSequenceMinigame(
        coords,
        1,
        difficulty,
        math.floor(duration / difficulty),
        Config.lootingMinigame.allowSkipping,
        L('looting.minigame.label'),
        L('looting.minigame.info'),
        true
    )
end

function SmashingMinigame(coords, difficulty)
    return exports.kq_link:SequenceMinigame(
        coords,
        difficulty,
        true,
        L('smashing.minigame.label'),
        L('smashing.minigame.info')
    )
end


--- Item looting
local function IsForwardAreaFree()
    local playerPed = PlayerPedId()
    local startCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.3, 0.0)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.15, -0.2)
    
    local ray = StartShapeTestSweptSphere(startCoords, offsetCoords, 0.5, 4294967295, playerPed, 1)
    local result, hit, endCoords, normal, entity = GetShapeTestResult(ray)
    
    return not hit or hit == 0
end

local function RotateTillFree()
    local playerPed = PlayerPedId()
    local timeout = 8
    
    while timeout > 0 and not IsForwardAreaFree() do
        timeout = timeout - 1
        SetEntityHeading(playerPed, GetEntityHeading(playerPed) + 45.0)
    end
end

local function CreateLootObject(model)
    local playerPed = PlayerPedId()
    
    local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.8, 1.0)
    local got, z = GetGroundZFor_3dCoord_2(coords.x, coords.y, coords.z, true)
    
    local playerCoords = GetEntityCoords(playerPed)
    
    local bagCoords = vec3(playerCoords.x, playerCoords.y, playerCoords.z - 1.0)
    
    if got and z < (playerCoords.z + 0.5) and z + 1.5 > (playerCoords.z) then
        bagCoords = vec3(coords.x, coords.y, z)
    end
    
    if #(playerCoords - bagCoords) > 5.0 then
        return false
    end
    
    DoRequestModel(model)
    local object = CreateObject(model, bagCoords, 1, 1, 0)
    SetEntityAsMissionEntity(object, 1, 1)
    SetEntityHeading(object, GetEntityHeading(playerPed))
    FadeInEntity(object, 300)
    
    return object
end

local function PerformItemLooting(model, duration)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) or IsPedRagdoll(playerPed) or IsEntityDead(playerPed) then
        return false
    end
    
    RotateTillFree()
    
    local object = CreateLootObject(model)
    if not object then
        return false
    end

    PlayAnim('anim@heists@money_grab@duffel', 'loop', 1)
    FreezeEntityPosition(playerPed, true)
    
    exports.kq_link:ProgressBar(GetEntityCoords(object), duration, 1)
    
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(playerPed)
    
    return true, object
end

RegisterNetEvent('kq_smash_n_grab2:client:lootItem')
AddEventHandler('kq_smash_n_grab2:client:lootItem', function(model, duration)
    local success, object = PerformItemLooting(model, duration)
    
    FadeOutEntity(object, 300)
    DeleteEntity(object)
    
    -- Fallback for entity deletion. Ownership might have changed.
    local netId
    if object and DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
        netId = NetworkGetNetworkIdFromEntity(object)
    end
    
    
    TriggerServerEvent('kq_smash_n_grab2:server:lootingFinished', success, netId)
end)
---

-- Function to calculate the odds of loot spawning in a specific vehicle
function CalculateVehicleOdds(vehicle)
    local class = GetVehicleClass(vehicle)
    local odds = Config.odds[class] or 10

    return odds
end


-- Debug commands/functions
if Config.debug then
    local function GetCamForwardVector()
        local rot = GetGameplayCamRot(2)
        local radZ = math.rad(rot.z)
        local radX = math.rad(rot.x)
        local num = math.abs(math.cos(radX))

        return vector3(-math.sin(radZ) * num, math.cos(radZ) * num, math.sin(radX))
    end

    RegisterCommand("get_vehicle_offsets", function()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)

                local playerPed = PlayerPedId()
                local camCoords = GetGameplayCamCoord()
                local forwardVector = GetCamForwardVector()
                local endCoords = camCoords + (forwardVector * 10.0)

                local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, endCoords.x, endCoords.y,
                    endCoords.z, 10, playerPed, 0)
                local _, hit, hitCoords, _, entity = GetShapeTestResult(rayHandle)

                if hit == 1 and DoesEntityExist(entity) and IsEntityAVehicle(entity) then
                    DrawSphere(hitCoords.x, hitCoords.y, hitCoords.z, 0.1, 0, 100, 0, 0.5)

                    if IsControlJustPressed(0, 38) then -- Press 'E' to confirm
                        local chassisBone = GetEntityBoneIndexByName(entity, "chassis_dummy")
                        if chassisBone ~= -1 then
                            local selectedOffset = GetOffsetFromEntityGivenWorldCoords(entity, hitCoords)
                            print("Vehicle Net ID:", NetworkGetNetworkIdFromEntity(entity))
                            print("Offset from chassis:", selectedOffset)
                        else
                            print("chassis_dummy bone not found")
                        end
                        break
                    end
                end
            end
        end)
    end, false)
end

