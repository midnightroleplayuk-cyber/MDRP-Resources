-- Qbox + ox_inventory: use the cover_sheet item to hold the original tarp.
-- Press X to put it away. The inventory item is never consumed.
local animDict, animClip, modelName = 'mdx@holdtarp', 'mdx_clip', 'mdx_tarp'
local coverSheetEntity = nil
local holding = false

local function loadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
end

local function loadModel(name)
    local hash = joaat(name)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end
    return hash
end

local function putAway()
    if not holding and not coverSheetEntity then return end
    holding = false
    local ped = PlayerPedId()
    StopAnimTask(ped, animDict, animClip, 1.0)
    if coverSheetEntity and DoesEntityExist(coverSheetEntity) then
        DetachEntity(coverSheetEntity, true, true)
        DeleteEntity(coverSheetEntity)
    end
    coverSheetEntity = nil
    RemoveAnimDict(animDict)
end

local function holdCoverSheet()
    if holding then return end
    local ped = PlayerPedId()
    if IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then return end

    loadAnimation(animDict)
    local hash = loadModel(modelName)
    local coords = GetEntityCoords(ped)
    local obj = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
    SetModelAsNoLongerNeeded(hash)
    if not DoesEntityExist(obj) then
        RemoveAnimDict(animDict)
        return
    end

    coverSheetEntity = obj
    holding = true
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 23553), -0.05, 0.3, 0.0, 180.0, 90.0, 0.0, true, false, false, false, 0, true)
    TaskPlayAnim(ped, animDict, animClip, 8.0, -8.0, -1, 49, 0.0, false, false, false)
end

-- ox_inventory invokes this export when the player uses cover_sheet.
exports('useCoverSheet', function(data, slot)
    if holding then return end
    -- Use ox_inventory's standard item-use flow; consume = 0 keeps the item.
    exports.ox_inventory:useItem(data, function(used)
        if used then holdCoverSheet() end
    end)
end)

CreateThread(function()
    while true do
        if holding then
            Wait(0)
            local ped = PlayerPedId()
            if IsControlJustPressed(0, 73) or IsDisabledControlJustPressed(0, 73)
                or IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) then
                putAway()
            end
        else
            Wait(350)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then putAway() end
end)
