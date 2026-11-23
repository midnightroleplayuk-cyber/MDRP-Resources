-- Optional test helper: /aedtest spawns the cabinet 1 m in front of you, facing you.
-- Run it again to move it; it is removed when the resource stops.

local spawned = nil

RegisterCommand('aedtest', function()
    local model = `uk_aed_cabinet`
    if not IsModelInCdimage(model) then
        print('[uk_aed_cabinet] model not found - is the resource started and the .ytyp loading?')
        return
    end

    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do Wait(0) end
    if not HasModelLoaded(model) then
        print('[uk_aed_cabinet] model failed to load')
        return
    end

    if spawned and DoesEntityExist(spawned) then DeleteEntity(spawned) end

    local ped = PlayerPedId()
    -- the prop's origin is the bottom-centre of its back panel; its front faces the entity's forward (+Y)
    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.0)
    spawned = CreateObject(model, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(spawned, GetEntityHeading(ped) + 180.0)
    FreezeEntityPosition(spawned, true)
    SetModelAsNoLongerNeeded(model)
end, false)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and spawned and DoesEntityExist(spawned) then
        DeleteEntity(spawned)
    end
end)
