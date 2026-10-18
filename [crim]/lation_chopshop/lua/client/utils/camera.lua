-- Reusable scripted-camera helper shared by any minigame that needs to pan/hold
-- a camera on a point of interest (wheel removal, engine bay overlay, etc).
-- Callers are responsible for computing their own camPos/targetPos/fov pose;
-- this module only owns the native camera handle and the screen<->world math.

local Camera = {
    active = false,
    handle = nil,
}

local function applyCameraPose(camPos, targetPos, fov)
    SetCamCoord(Camera.handle, camPos.x, camPos.y, camPos.z)

    local dx, dy, dz = targetPos.x - camPos.x, targetPos.y - camPos.y, targetPos.z - camPos.z
    local dist2d = math.sqrt(dx * dx + dy * dy)
    local heading = GetHeadingFromVector_2d(dx, dy)
    local pitch = dist2d > 0.0001 and math.deg(math.atan(dz, dist2d)) or 0.0

    SetCamRot(Camera.handle, pitch, 0.0, heading, 2)
    SetCamFov(Camera.handle, fov)
end

function Camera.screenToRay(screenX, screenY)
    local camCoord = Camera.active and GetCamCoord(Camera.handle) or GetGameplayCamCoord()
    local camRot = Camera.active and GetCamRot(Camera.handle, 2) or GetGameplayCamRot(2)
    local fov = Camera.active and GetCamFov(Camera.handle) or GetGameplayCamFov()

    local pitch = math.rad(camRot.x)
    local yaw = math.rad(camRot.z)
    local cosPitch = math.cos(pitch)
    local forward = vec3(-math.sin(yaw) * cosPitch, math.cos(yaw) * cosPitch, math.sin(pitch))
    local right = vec3(forward.y, -forward.x, 0.0)
    local up = vec3(
        right.y * forward.z - right.z * forward.y,
        right.z * forward.x - right.x * forward.z,
        right.x * forward.y - right.y * forward.x
    )

    local aspect = GetAspectRatio(false)
    local tanFov = math.tan(math.rad(fov) * 0.5)
    local ndcX = (screenX - 0.5) * 2.0
    local ndcY = (screenY - 0.5) * 2.0

    local rayDir = forward + right * (ndcX * tanFov * aspect) + up * (-ndcY * tanFov)
    local len = #rayDir
    if len < 0.0001 then
        return camCoord, forward
    end

    return camCoord, rayDir / len
end

function Camera.getWorldFromScreen(screenX, screenY, distance)
    local camCoord, rayDir = Camera.screenToRay(screenX, screenY)
    return camCoord + rayDir * distance
end

--- Creates (or recreates) the scripted camera at the given pose and activates it.
function Camera.enter(camPos, targetPos, fov)
    if Camera.active then
        Camera.exit()
    end

    Camera.handle = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    applyCameraPose(camPos, targetPos, fov)
    SetCamActive(Camera.handle, true)
    RenderScriptCams(true, true, 450, true, false)
    Camera.active = true
end

--- Updates the pose of an already-active camera (e.g. per-frame follow).
function Camera.lookAt(camPos, targetPos, fov)
    if not Camera.active or not Camera.handle then return end
    applyCameraPose(camPos, targetPos, fov)
end

function Camera.exit()
    if Camera.handle then
        RenderScriptCams(false, true, 450, true, false)
        DestroyCam(Camera.handle, false)
        Camera.handle = nil
    end
    Camera.active = false
end

function Camera.isActive()
    return Camera.active
end

return Camera
