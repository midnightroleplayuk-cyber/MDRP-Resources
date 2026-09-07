World = {}

World.GetPlayerLookingVector = function(playerped, radius)
	local pedyaw = GetEntityHeading(playerped)
	local camyaw = GetGameplayCamRelativeHeading()
	local pitch = 90.0-GetGameplayCamRelativePitch()
	local yaw = pedyaw + camyaw -- entity heading + relative camera heading = absolute camera heading

	if yaw > 180 then
		yaw = yaw - 360
	elseif yaw < -180 then
		yaw = yaw + 360
	end

	local pitch = pitch * math.pi / 180
	local yaw = yaw * math.pi / 180
	local x = radius * math.sin(pitch) * math.sin(yaw)
	local y = radius * math.sin(pitch) * math.cos(yaw)
	local z = radius * math.cos(pitch)

	local playerpedcoords = GetGameplayCamCoord()
	local xcorr = -x+ playerpedcoords.x
	local ycorr = y+ playerpedcoords.y
	local zcorr = z+ playerpedcoords.z
	local Vector = vector3(tonumber(xcorr), tonumber(ycorr), tonumber(zcorr))
	return Vector
end

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

World.GetCameraLookingPoint = function(distance)
    distance = distance or 1000.0
    local cameraCoord = GetFinalRenderedCamCoord()
    local cameraRotation = GetFinalRenderedCamRot(2)
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local rayHandle = StartShapeTestRay(
        cameraCoord.x, cameraCoord.y, cameraCoord.z,
        destination.x, destination.y, destination.z,
        -1,
        PlayerPedId(),
        0
    )
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    if hit then
        return endCoords, hit, entityHit, surfaceNormal
    else
        return destination, false, nil, nil
    end
end

local function normalize(v)
    local mag = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    if mag > 0.000001 then
        return vector3(v.x / mag, v.y / mag, v.z / mag)
    else
        return vector3(0.0, 0.0, 0.0)
    end
end

local function cross(a, b)
    return vector3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
end

World.normalToRotation =  function(normal)
    local mag = math.sqrt(normal.x^2 + normal.y^2 + normal.z^2)
    if mag < 0.000001 then
        return vector3(0, 0, 0)
    end
    local forward = vector3(normal.x / mag, normal.y / mag, normal.z / mag)

    local up
    if math.abs(forward.z) < 0.99 then
        up = vector3(0, 0, 1)
    else
        up = vector3(0, 1, 0)
    end

    local right = vector3(
        up.y * forward.z - up.z * forward.y,
        up.z * forward.x - up.x * forward.z,
        up.x * forward.y - up.y * forward.x
    )
    local rmag = math.sqrt(right.x^2 + right.y^2 + right.z^2)
    right = vector3(right.x / rmag, right.y / rmag, right.z / rmag)

    up = vector3(
        forward.y * right.z - forward.z * right.y,
        forward.z * right.x - forward.x * right.z,
        forward.x * right.y - forward.y * right.x
    )

    local rotX = math.deg(math.atan2(forward.z, math.sqrt(forward.x^2 + forward.y^2)))
    local rotZ = math.deg(math.atan2(forward.y, forward.x))
    local rotY = 0.0

    return vector3(-rotX + 90.0, rotY, rotZ)

end

World.render3DAxes = function(position, surface_normal)
    local axis_length = 0.15
    local z_axis = normalize(surface_normal)

    local up
    if math.abs(z_axis.z) < 0.99 then
        up = vector3(0.0, 0.0, 1.0)
    else
        up = vector3(0.0, 1.0, 0.0)
    end

    local x_axis = normalize(cross(up, z_axis))
    local y_axis = normalize(cross(z_axis, x_axis))

    DrawLine(
        position.x, position.y, position.z,
        position.x + x_axis.x * axis_length,
        position.y + x_axis.y * axis_length,
        position.z + x_axis.z * axis_length,
        255, 0, 0, 255
    )

    DrawLine(
        position.x, position.y, position.z,
        position.x + y_axis.x * axis_length,
        position.y + y_axis.y * axis_length,
        position.z + y_axis.z * axis_length,
        0, 255, 0, 255
    )

    DrawLine(
        position.x, position.y, position.z,
        position.x + z_axis.x * axis_length,
        position.y + z_axis.y * axis_length,
        position.z + z_axis.z * axis_length,
        0, 0, 255, 255
    )
end


World.GetCoordsInFrontOfCam = function(...)
	local unpack = table.unpack
	local coords,direction = GetGameplayCamCoord(), World.RotationToDirection()
	local inTable  = {...}   
	local retTable = {}    
	if (#inTable == 0) or (inTable[1] < 0.000001) then
		inTable[1] = 0.000001
	end    
	for k,distance in pairs(inTable) do     
		if (type(distance) == "number") then       
			if (distance == 0) then         
				retTable[k] = coords       
			else         
				retTable[k] = vector3(coords.x + (distance * direction.x), coords.y + (distance * direction.y), coords.z + (distance * direction.z))  
			end     
		end   
	end   
	return unpack(retTable)
end

World.RotationToDirection = function(rot)
	rot = rot or GetGameplayCamRot(2)
	local rotZ = rot.z  * ( 3.141593 / 180.0 )
	local rotX = rot.x  * ( 3.141593 / 180.0 )
	local c = math.cos(rotX)
	local multXY = math.abs(c)
	local res = vector3((math.sin(rotZ) * -1) * multXY, math.cos(rotZ) * multXY, math.sin(rotX)) 
	return res 
end

World.DrawSelectedArea = function(PointA, PointB, minZ, maxZ, r, g, b, a)
	DrawPoly(PointB.x, PointB.y, minZ, PointB.x, PointB.y, maxZ, PointA.x, PointA.y, maxZ, r, g, b, a)
	DrawPoly(PointB.x, PointB.y, minZ, PointA.x, PointA.y, maxZ, PointA.x, PointA.y, minZ, r, g, b, a)
end

-- Pixel size the given world surface works out to at 1080p, so the readout can
-- tell a player what to export before they draw anything
World.AspectAt1080p = function(width, height)
	if width >= height then
		return 1920, math.floor(1920 * (height / width) + 0.5)
	end
	return math.floor(1920 * (width / height) + 0.5), 1920
end

World.DrawText3D = function(coords, text, scale)
	local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
	if not onScreen then return end

	scale = scale or 0.35
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)

	DrawRect(x, y + 0.0125, 0.015 + (#text / 370), 0.03, 0, 0, 0, 75)
end

World.DrawImageOnArea = function(PointA, PointB, minZ, maxZ, r, g, b, a, texture, dict)
	DrawSpritePoly(PointB.x, PointB.y, minZ, PointB.x, PointB.y, maxZ, PointA.x, PointA.y, maxZ, r, g, b, a, texture, dict, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0)
	DrawSpritePoly(PointA.x, PointA.y, maxZ, PointA.x, PointA.y, minZ, PointB.x, PointB.y, minZ, r, g, b, a, texture, dict, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0)
end
