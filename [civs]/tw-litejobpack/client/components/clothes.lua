local ClothesState = {
    active = false,
    cabin = nil,
    cabinClothes = nil,
    cabinDoor = nil,
    cam = nil,
    storedClothes = nil,
    isWearing = false,
    clothesRequired = false,
}

local CABIN_Z_OFFSET = -0.5
local DOOR_OFFSET = vector3(0.65, -0.9625, 0.62615)

local function StorePlayerClothes()
    local ped = PlayerPedId()
    local hatIndex = GetPedPropIndex(ped, 0)
    local glassesIndex = GetPedPropIndex(ped, 1)
    local earsIndex = GetPedPropIndex(ped, 2)

    ClothesState.storedClothes = {
        torso = GetPedDrawableVariation(ped, 3),
        torso_texture = GetPedTextureVariation(ped, 3),
        legs = GetPedDrawableVariation(ped, 4),
        legs_texture = GetPedTextureVariation(ped, 4),
        feet = GetPedDrawableVariation(ped, 6),
        feet_texture = GetPedTextureVariation(ped, 6),
        bags = GetPedDrawableVariation(ped, 5),
        bags_texture = GetPedTextureVariation(ped, 5),
        accessories = GetPedDrawableVariation(ped, 7),
        accessories_texture = GetPedTextureVariation(ped, 7),
        undershirt = GetPedDrawableVariation(ped, 8),
        undershirt_texture = GetPedTextureVariation(ped, 8),
        vest = GetPedDrawableVariation(ped, 9),
        vest_texture = GetPedTextureVariation(ped, 9),
        decals = GetPedDrawableVariation(ped, 10),
        decals_texture = GetPedTextureVariation(ped, 10),
        top = GetPedDrawableVariation(ped, 11),
        top_texture = GetPedTextureVariation(ped, 11),
        hat = (hatIndex ~= -1) and hatIndex or nil,
        hat_texture = (hatIndex ~= -1) and GetPedPropTextureIndex(ped, 0) or nil,
        glasses = (glassesIndex ~= -1) and glassesIndex or nil,
        glasses_texture = (glassesIndex ~= -1) and GetPedPropTextureIndex(ped, 1) or nil,
        ears = (earsIndex ~= -1) and earsIndex or nil,
        ears_texture = (earsIndex ~= -1) and GetPedPropTextureIndex(ped, 2) or nil,
    }
end

local clothingScripts = {
    { resource = 'qb-clothing',         fn = function() TriggerServerEvent("qb-clothes:loadPlayerSkin") end },
    { resource = 'illenium-appearance',  fn = function() TriggerEvent("illenium-appearance:client:reloadSkin") end },
    { resource = 'fivem-appearance',     fn = function() TriggerEvent("fivem-appearance:client:reloadSkin") end },
    { resource = 'esx_skin',            fn = function()
        TriggerEvent("esx_skin:getLastSkin", function(lastSkin)
            TriggerEvent('skinchanger:loadSkin', lastSkin)
        end)
    end },
    { resource = 'rcore_clothing',       fn = function() TriggerServerEvent('rcore_clothing:reloadSkin') end },
    { resource = 'rcore_clothes',        fn = function() TriggerServerEvent('rcore_clothing:reloadSkin') end },
    { resource = 'codem-appearance',     fn = function() TriggerEvent("codem-appearance:client:reloadSkin") end },
    { resource = 'tgiann-clothing',      fn = function() TriggerServerEvent("tgiann-clothing:reloadSkin") end },
    { resource = 'p_appearance',         fn = function() TriggerEvent("p_appearance:client:reloadSkin") end },
    { resource = 'sleek-clothestore',    fn = function() TriggerEvent("sleek-clothestore:client:reloadSkin") end },
    { resource = 'ak47_clothing',        fn = function() TriggerServerEvent("ak47_clothing:reloadSkin") end },
    { resource = 'raid_clothes',         fn = function() TriggerServerEvent("raid_clothes:reloadSkin") end },
}

local function RestoreViaClothingScript()
    for _, entry in ipairs(clothingScripts) do
        if GetResourceState(entry.resource) == 'started' then
            entry.fn()
            return true
        end
    end
    return false
end

local function RestorePlayerClothesNative()
    if not ClothesState.storedClothes then return end

    local ped = PlayerPedId()
    local clothes = ClothesState.storedClothes

    SetPedComponentVariation(ped, 3, clothes.torso, clothes.torso_texture, 0)
    SetPedComponentVariation(ped, 4, clothes.legs, clothes.legs_texture, 0)
    SetPedComponentVariation(ped, 5, clothes.bags or 0, clothes.bags_texture or 0, 0)
    SetPedComponentVariation(ped, 6, clothes.feet, clothes.feet_texture, 0)
    SetPedComponentVariation(ped, 7, clothes.accessories, clothes.accessories_texture, 0)
    SetPedComponentVariation(ped, 8, clothes.undershirt, clothes.undershirt_texture, 0)
    SetPedComponentVariation(ped, 9, clothes.vest, clothes.vest_texture, 0)
    SetPedComponentVariation(ped, 10, clothes.decals, clothes.decals_texture, 0)
    SetPedComponentVariation(ped, 11, clothes.top, clothes.top_texture, 0)

    if clothes.hat ~= nil then
        SetPedPropIndex(ped, 0, clothes.hat, clothes.hat_texture, true)
    else
        ClearPedProp(ped, 0)
    end

    if clothes.glasses ~= nil then
        SetPedPropIndex(ped, 1, clothes.glasses, clothes.glasses_texture, true)
    else
        ClearPedProp(ped, 1)
    end

    if clothes.ears ~= nil then
        SetPedPropIndex(ped, 2, clothes.ears, clothes.ears_texture, true)
    else
        ClearPedProp(ped, 2)
    end
end

local function RestorePlayerClothes()
    RestorePlayerClothesNative()
    RestoreViaClothingScript()
end

local function ApplyJobClothes(clothesData)
    if not clothesData then return end

    local ped = PlayerPedId()

    StorePlayerClothes()
    Wait(10)

    if clothesData.arms then
        SetPedComponentVariation(ped, 3, clothesData.arms, clothesData.arms_texture or 0, 0)
    end
    if clothesData.pants then
        SetPedComponentVariation(ped, 4, clothesData.pants, clothesData.pants_texture or 0, 0)
    end
    if clothesData.bags then
        SetPedComponentVariation(ped, 5, clothesData.bags, clothesData.bags_texture or 0, 0)
    end
    if clothesData.shoes then
        SetPedComponentVariation(ped, 6, clothesData.shoes, clothesData.shoes_texture or 0, 0)
    end
    if clothesData.tshirt then
        SetPedComponentVariation(ped, 8, clothesData.tshirt, clothesData.tshirt_texture or 0, 0)
    end
    if clothesData.torso then
        SetPedComponentVariation(ped, 11, clothesData.torso, clothesData.torso_texture or 0, 0)
    end
    if clothesData.chain and clothesData.chain ~= -1 then
        SetPedComponentVariation(ped, 7, clothesData.chain, clothesData.chain_texture or 0, 0)
    end
    if clothesData.bproof then
        SetPedComponentVariation(ped, 9, clothesData.bproof, clothesData.bproof_texture or 0, 0)
    else
        SetPedComponentVariation(ped, 9, 0, 0, 0)
    end
    if clothesData.decals then
        SetPedComponentVariation(ped, 10, clothesData.decals, clothesData.decals_texture or 0, 0)
    end
    if clothesData.helmet and clothesData.helmet ~= -1 then
        SetPedPropIndex(ped, 0, clothesData.helmet, clothesData.helmet_texture or 0, true)
    elseif clothesData.helmet == -1 then
        ClearPedProp(ped, 0)
    end
    if clothesData.glasses and clothesData.glasses ~= -1 then
        SetPedPropIndex(ped, 1, clothesData.glasses, clothesData.glasses_texture or 0, true)
    elseif clothesData.glasses == -1 then
        ClearPedProp(ped, 1)
    end
    if clothesData.ears and clothesData.ears ~= -1 then
        SetPedPropIndex(ped, 2, clothesData.ears, clothesData.ears_texture or 0, true)
    elseif clothesData.ears == -1 then
        ClearPedProp(ped, 2)
    end

    ClothesState.isWearing = true
end

local function LoadAnimDict(dict)
    if not dict then return false end
    if HasAnimDictLoaded(dict) then return true end

    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do
        Wait(10)
    end
    return HasAnimDictLoaded(dict)
end

local function PlayAnim(ped, dict, name, duration)
    if LoadAnimDict(dict) then
        TaskPlayAnim(ped, dict, name, 8.0, -8.0, duration or -1, 0, 0, false, false, false)
    end
end

local function AnimateDoorLocal(door, cabin, targetHeadingOffset, duration)
    if not door or not DoesEntityExist(door) then return end
    if not cabin or not DoesEntityExist(cabin) then return end

    local cabinHeading = GetEntityHeading(cabin)
    local targetHeading = cabinHeading + targetHeadingOffset

    local currentHeading = GetEntityHeading(door)
    local steps = math.floor(duration / 16)
    local diff = targetHeading - currentHeading

    if diff > 180 then diff = diff - 360 end
    if diff < -180 then diff = diff + 360 end

    local stepSize = diff / steps

    FreezeEntityPosition(door, false)
    for i = 1, steps do
        local h = currentHeading + (stepSize * i)
        SetEntityHeading(door, h)
        Wait(16)
    end
    SetEntityHeading(door, targetHeading)
    FreezeEntityPosition(door, true)
end

local function AnimateDoor(targetHeadingOffset, duration)
    local door = ClothesState.cabinDoor
    local cabin = ClothesState.cabin

    -- Broadcast to coop players only when both entities are networked.
    -- Cabins spawned by _loader.lua are local (per-player), so skip broadcast for them
    -- to avoid NETWORK_GET_NETWORK_ID_FROM_ENTITY warning spam.
    if door and DoesEntityExist(door) and cabin and DoesEntityExist(cabin)
        and NetworkGetEntityIsNetworked(door) and NetworkGetEntityIsNetworked(cabin) then
        local doorNetId = NetworkGetNetworkIdFromEntity(door)
        local cabinNetId = NetworkGetNetworkIdFromEntity(cabin)
        if doorNetId ~= 0 and cabinNetId ~= 0 then
            TriggerServerEvent(_event('server:syncCabinDoor'), doorNetId, cabinNetId, targetHeadingOffset, duration)
        end
    end

    AnimateDoorLocal(door, cabin, targetHeadingOffset, duration)
end

RegisterNetEvent(_event('client:syncCabinDoor'), function(doorNetId, cabinNetId, targetHeadingOffset, duration)
    local door = NetworkGetEntityFromNetworkId(doorNetId)
    local cabin = NetworkGetEntityFromNetworkId(cabinNetId)
    if door and DoesEntityExist(door) and cabin and DoesEntityExist(cabin) then
        CreateThread(function()
            AnimateDoorLocal(door, cabin, targetHeadingOffset, duration)
        end)
    end
end)

local function OpenDoor()
    AnimateDoor(90.0, 600)
end

local function CloseDoor()
    AnimateDoor(0.0, 500)
end

local function CreateClothesCamera(cabin)
    local px, py, pz = table.unpack(GetEntityCoords(cabin, true))
    local forwardX = GetEntityForwardX(cabin)
    local forwardY = GetEntityForwardY(cabin)

    local camPosX = px + (forwardX * -5.5)
    local camPosY = py + (forwardY * -5.5)
    local camPosZ = pz + 1.72

    local camCoords = vector3(camPosX, camPosY, camPosZ)
    local camRotation = GetEntityRotation(cabin, 2)

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords, camRotation, GetGameplayCamFov())
    SetCamFov(cam, 50.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
    ShakeCam(cam, "HAND_SHAKE", 0.3)

    return cam, camCoords, camRotation
end

local function EndClothesCamera()
    if ClothesState.cam then
        RenderScriptCams(false, true, 1000, true, false)
        SetCamActive(ClothesState.cam, false)
        DestroyCam(ClothesState.cam, false)
        ClothesState.cam = nil
    end
end

local function LoadModel(modelName)
    local model = GetHashKey(modelName)
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Wait(10)
    end
    if not HasModelLoaded(model) then
        return nil
    end
    return model
end

local function CalculateDoorCoords(coords, heading)
    local rad = math.rad(heading)
    local cosH = math.cos(rad)
    local sinH = math.sin(rad)

    local worldX = coords.x + (DOOR_OFFSET.x * cosH - DOOR_OFFSET.y * sinH)
    local worldY = coords.y + (DOOR_OFFSET.x * sinH + DOOR_OFFSET.y * cosH)
    local worldZ = coords.z + CABIN_Z_OFFSET + DOOR_OFFSET.z

    return worldX, worldY, worldZ
end

function SpawnClothesArea(coords)
    DeleteClothesArea()

    local heading = coords.w or 0.0

    -- Ensure collision is loaded at the target location (e.g. docks/port areas)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    local colTimer = GetGameTimer() + 2000
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) and GetGameTimer() < colTimer do
        Wait(10)
    end

    local cabinModel = LoadModel("tw_changing_cabin")
    if not cabinModel then return nil end

    local baseZ = coords.z + CABIN_Z_OFFSET
    local cabin = CreateObject(cabinModel, coords.x, coords.y, baseZ, true, true, false)
    if not cabin or cabin == 0 or not DoesEntityExist(cabin) then
        SetModelAsNoLongerNeeded(cabinModel)
        return nil
    end
    SetEntityAsMissionEntity(cabin, true, true)
    SetEntityRotation(cabin, 0.0, 0.0, heading, 2, true)
    FreezeEntityPosition(cabin, true)
    if NetworkGetEntityIsNetworked(cabin) then
        local cabinNetId = NetworkGetNetworkIdFromEntity(cabin)
        if cabinNetId ~= 0 then
            SetNetworkIdCanMigrate(cabinNetId, false)
        end
    end
    SetModelAsNoLongerNeeded(cabinModel)
    ClothesState.cabin = cabin

    local clothesModel = LoadModel("tw_changing_cabin_clothes")
    if clothesModel then
        local clothesProp = CreateObject(clothesModel, coords.x, coords.y, baseZ, true, true, false)
        if clothesProp and clothesProp ~= 0 and DoesEntityExist(clothesProp) then
            SetEntityAsMissionEntity(clothesProp, true, true)
            SetEntityRotation(clothesProp, 0.0, 0.0, heading, 2, true)
            FreezeEntityPosition(clothesProp, true)
            if NetworkGetEntityIsNetworked(clothesProp) then
                local clothesNetId = NetworkGetNetworkIdFromEntity(clothesProp)
                if clothesNetId ~= 0 then
                    SetNetworkIdCanMigrate(clothesNetId, false)
                end
            end
            ClothesState.cabinClothes = clothesProp
        end
        SetModelAsNoLongerNeeded(clothesModel)
    end

    local doorModel = LoadModel("tw_changing_cabin_door")
    if doorModel then
        local doorX, doorY, doorZ = CalculateDoorCoords(coords, heading)
        local door = CreateObject(doorModel, doorX, doorY, doorZ, true, true, false)
        if door and door ~= 0 and DoesEntityExist(door) then
            SetEntityAsMissionEntity(door, true, true)
            SetEntityRotation(door, 0.0, 0.0, heading, 2, true)
            if NetworkGetEntityIsNetworked(door) then
                local doorNetId = NetworkGetNetworkIdFromEntity(door)
                if doorNetId ~= 0 then
                    SetNetworkIdCanMigrate(doorNetId, false)
                end
            end
            ClothesState.cabinDoor = door
        end
        SetModelAsNoLongerNeeded(doorModel)
    end

    return cabin
end

function DeleteClothesArea()
    if ClothesState.cabinDoor and DoesEntityExist(ClothesState.cabinDoor) then
        DeleteEntity(ClothesState.cabinDoor)
        ClothesState.cabinDoor = nil
    end
    if ClothesState.cabinClothes and DoesEntityExist(ClothesState.cabinClothes) then
        DeleteEntity(ClothesState.cabinClothes)
        ClothesState.cabinClothes = nil
    end
    if ClothesState.cabin and DoesEntityExist(ClothesState.cabin) then
        DeleteEntity(ClothesState.cabin)
        ClothesState.cabin = nil
    end
end

function StartClothesChange(clothesData, callback)
    if ClothesState.active then
        return false
    end

    if not ClothesState.cabin or not DoesEntityExist(ClothesState.cabin) then
        return false
    end

    ClothesState.active = true

    CreateThread(function()
        local ped = PlayerPedId()
        local cabin = ClothesState.cabin
        local door = ClothesState.cabinDoor

        local px, py, pz = table.unpack(GetEntityCoords(cabin, true))
        local forwardX = GetEntityForwardX(cabin)
        local forwardY = GetEntityForwardY(cabin)
        local cabinHeading = GetEntityHeading(cabin)

        local groundZ = pz - CABIN_Z_OFFSET
        -- Player waits far enough so the outward-swinging door doesn't clip through them
        local playerPosX = px + (forwardX * -2.8)
        local playerPosY = py + (forwardY * -2.8)
        local stopX = px + (forwardX * -0.15)
        local stopY = py + (forwardY * -0.15)

        -- Disable door collision so it doesn't push the player
        if door and DoesEntityExist(door) then
            SetEntityCompletelyDisableCollision(door, false, true)
        end

        -- Place player at start position, facing cabin
        SetEntityCoordsNoOffset(ped, playerPosX, playerPosY, groundZ, false, false, false)
        Wait(100)
        TaskTurnPedToFaceCoord(ped, px, py, groundZ, 800)
        Wait(800)

        -- Open camera
        local cam, camCoords, camRotation = CreateClothesCamera(cabin)
        ClothesState.cam = cam
        Wait(300)

        -- Door opens (player is far enough to avoid the outward swing)
        OpenDoor()
        Wait(400)

        -- Player walks into cabin
        TaskGoStraightToCoord(ped, stopX, stopY, groundZ, 1.0, 3500, cabinHeading, 0.05)
        Wait(2800)

        -- Freeze in place (no re-teleport to avoid Z pop)
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, true)
        SetEntityHeading(ped, cabinHeading)

        -- Door closes
        CloseDoor()
        Wait(300)

        -- Clothing change animation
        PlayAnim(ped, "re@construction", "out_of_breath", 3000)
        Wait(1500)

        -- Apply or restore clothes
        local pedModel = GetEntityModel(ped)
        local isMale = pedModel == GetHashKey("mp_m_freemode_01")
        local isFemale = pedModel == GetHashKey("mp_f_freemode_01")

        local restoredClothes = false
        if ClothesState.isWearing then
            RestorePlayerClothes()
            ClothesState.isWearing = false
            restoredClothes = true
        else
            local genderData = nil
            if isMale and clothesData.male then
                genderData = clothesData.male
            elseif isFemale and clothesData.female then
                genderData = clothesData.female
            end

            if genderData then
                local jobClothes = {
                    torso = genderData.torso_1,
                    torso_texture = genderData.torso_2,
                    pants = genderData.pants_1,
                    pants_texture = genderData.pants_2,
                    shoes = genderData.shoes_1,
                    shoes_texture = genderData.shoes_2,
                    tshirt = genderData.tshirt_1,
                    tshirt_texture = genderData.tshirt_2,
                    arms = genderData.arms,
                    arms_texture = genderData.arms_2,
                    bags = genderData.bags_1,
                    bags_texture = genderData.bags_2,
                    helmet = genderData.helmet_1,
                    helmet_texture = genderData.helmet_2,
                    chain = genderData.chain_1,
                    chain_texture = genderData.chain_2,
                    decals = genderData.decals_1,
                    decals_texture = genderData.decals_2,
                    glasses = genderData.glasses_1,
                    glasses_texture = genderData.glasses_2,
                    ears = genderData.ears_1,
                    ears_texture = genderData.ears_2,
                    bproof = genderData.bproof_1,
                    bproof_texture = genderData.bproof_2,
                }
                ApplyJobClothes(jobClothes)
            end
        end

        -- Restore path triggers external clothing scripts (qb-clothing, illenium, etc.)
        -- which reload skin asynchronously and may change the ped handle or re-freeze it.
        -- Wait longer and re-fetch ped before continuing the exit sequence.
        if restoredClothes then
            Wait(1500)
            ped = PlayerPedId()
            -- Re-position at cabin stop point in case skin reload teleported/offset the ped
            SetEntityCoordsNoOffset(ped, stopX, stopY, groundZ, false, false, false)
        else
            Wait(1000)
        end

        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)

        -- Player turns 180° to face outward before door opens
        SetEntityHeading(ped, cabinHeading + 180.0)
        Wait(400)

        -- Door opens behind the player (no clipping)
        OpenDoor()
        Wait(400)

        -- Player walks out
        ped = PlayerPedId()
        ClearPedTasks(ped)
        TaskGoStraightToCoord(ped, playerPosX, playerPosY, groundZ, 1.0, 3500, cabinHeading + 180.0, 0.05)
        Wait(2800)

        -- Door closes
        CloseDoor()
        Wait(800)

        -- Re-enable door collision
        if door and DoesEntityExist(door) then
            SetEntityCollision(door, true, true)
        end

        ClearPedTasks(ped)
        EndClothesCamera()

        ClothesState.active = false

        if callback then
            callback(ClothesState.isWearing)
        end
    end)

    return true
end

function IsClothesChangeActive()
    return ClothesState.active
end

function IsWearingJobClothes()
    return ClothesState.isWearing
end

function GetClothesAreaEntity()
    return ClothesState.cabin
end

function GetClothesDoorEntity()
    return ClothesState.cabinDoor
end

function SetClothesRequired(required)
    ClothesState.clothesRequired = required
end

function IsClothesRequired()
    return ClothesState.clothesRequired
end

function DetachClothesArea()
    ClothesState.cabin = nil
    ClothesState.cabinClothes = nil
    ClothesState.cabinDoor = nil
end

function FindAndAttachCabin(coords)
    DetachClothesArea()

    local cabinHash = GetHashKey("tw_changing_cabin")
    local cabin = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, cabinHash, false, false, false)
    if not cabin or cabin == 0 or not DoesEntityExist(cabin) then
        return nil
    end
    ClothesState.cabin = cabin

    local clothesHash = GetHashKey("tw_changing_cabin_clothes")
    local clothesProp = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, clothesHash, false, false, false)
    if clothesProp and clothesProp ~= 0 and DoesEntityExist(clothesProp) then
        ClothesState.cabinClothes = clothesProp
    end

    local doorHash = GetHashKey("tw_changing_cabin_door")
    local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, doorHash, false, false, false)
    if door and door ~= 0 and DoesEntityExist(door) then
        ClothesState.cabinDoor = door
    end

    return cabin
end

function CleanupClothesComponent()
    EndClothesCamera()
    DetachClothesArea()

    if ClothesState.isWearing then
        RestorePlayerClothes()
    end

    ClothesState.active = false
    ClothesState.isWearing = false
    ClothesState.storedClothes = nil
    ClothesState.clothesRequired = false
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    CleanupClothesComponent()
end)

function ApplyAutoClothes(clothesData)
    if not clothesData then return end

    local ped = PlayerPedId()
    local pedModel = GetEntityModel(ped)
    local isMale = pedModel == GetHashKey("mp_m_freemode_01")
    local isFemale = pedModel == GetHashKey("mp_f_freemode_01")

    local genderData = nil
    if isMale and clothesData.male then
        genderData = clothesData.male
    elseif isFemale and clothesData.female then
        genderData = clothesData.female
    end

    if not genderData then return end

    local jobClothes = {
        torso = genderData.torso_1,
        torso_texture = genderData.torso_2,
        pants = genderData.pants_1,
        pants_texture = genderData.pants_2,
        shoes = genderData.shoes_1,
        shoes_texture = genderData.shoes_2,
        tshirt = genderData.tshirt_1,
        tshirt_texture = genderData.tshirt_2,
        arms = genderData.arms,
        helmet = genderData.helmet_1,
        helmet_texture = genderData.helmet_2,
        chain = genderData.chain_1,
        chain_texture = genderData.chain_2,
        decals = genderData.decals_1,
        decals_texture = genderData.decals_2,
        glasses = genderData.glasses_1,
        glasses_texture = genderData.glasses_2,
        ears = genderData.ears_1,
        ears_texture = genderData.ears_2,
        bproof = genderData.bproof_1,
        bproof_texture = genderData.bproof_2,
    }
    ApplyJobClothes(jobClothes)
end

exports('SpawnClothesArea', SpawnClothesArea)
exports('DeleteClothesArea', DeleteClothesArea)
exports('StartClothesChange', StartClothesChange)
exports('IsClothesChangeActive', IsClothesChangeActive)
exports('IsWearingJobClothes', IsWearingJobClothes)
exports('GetClothesAreaEntity', GetClothesAreaEntity)
exports('GetClothesDoorEntity', GetClothesDoorEntity)
exports('SetClothesRequired', SetClothesRequired)
exports('IsClothesRequired', IsClothesRequired)
exports('CleanupClothesComponent', CleanupClothesComponent)
exports('FindAndAttachCabin', FindAndAttachCabin)
exports('DetachClothesArea', DetachClothesArea)
exports('ApplyAutoClothes', ApplyAutoClothes)
