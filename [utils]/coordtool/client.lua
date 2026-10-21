local function RotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function GetCamLookCoords(distance)
    distance = distance or 100.0
    local camPos = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local dir = RotationToDirection(camRot)
    local dest = camPos + dir * distance

    local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 0)
    local _, hit, hitCoords, _, entity = GetShapeTestResult(ray)

    if hit == 1 then
        return hitCoords, entity
    end
    return nil
end

local function Notify(msg)
    TriggerEvent('chat:addMessage', { color = { 80, 200, 120 }, args = { 'coordtool', msg } })
    print(msg)
end

-- /lookcoords [distance]: coords of the point your camera is looking at
RegisterCommand('lookcoords', function(_, args)
    local distance = tonumber(args[1]) or 100.0
    local coords = GetCamLookCoords(distance)
    if coords then
        Notify(('vector3(%.2f, %.2f, %.2f)'):format(coords.x, coords.y, coords.z))
    else
        Notify('Nothing hit within ' .. distance .. 'm')
    end
end, false)

-- /mycoords: your ped's position and heading
RegisterCommand('mycoords', function()
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local h = GetEntityHeading(ped)
    Notify(('vector4(%.2f, %.2f, %.2f, %.2f)'):format(c.x, c.y, c.z, h))
end, false)
