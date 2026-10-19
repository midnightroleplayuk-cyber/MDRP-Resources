-- ============================================================
-- Face shot — capture the player's character head as a base64
-- JPEG, no upload host required. Uses screenshot-basic to grab
-- the bytes after parking a scripted camera in front of the
-- ped's face.
-- ============================================================

function SnapFace(callback)
    if GetResourceState('screenshot-basic') ~= 'started' then
        return callback(nil, 'screenshot-basic is not running')
    end

    local ped = cache.ped or PlayerPedId()
    if not ped or ped == 0 then return callback(nil, 'no ped') end

    -- Stash the current ped state so we restore exactly as-is.
    local prevCoords  = GetEntityCoords(ped)
    local prevHeading = GetEntityHeading(ped)
    local prevVisible = IsEntityVisible(ped)

    -- Hide UI briefly.
    SendNUIMessage({ action = 'panel:faceshot:before' })
    Wait(120)

    -- Force the ped facing forward and freeze it so the face doesn't
    -- move during the grab.
    FreezeEntityPosition(ped, true)
    ClearPedTasksImmediately(ped)

    -- Build a camera in front of the ped's head.
    local headIdx = GetPedBoneIndex(ped, 12844) -- SKEL_Head
    local hx, hy, hz
    if headIdx ~= -1 then
        hx, hy, hz = table.unpack(GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0))
    else
        local c = GetEntityCoords(ped)
        hx, hy, hz = c.x, c.y, c.z + 0.65
    end

    local fwd = GetEntityForwardVector(ped)
    local camDist = 0.55
    local camX = hx + fwd.x * camDist
    local camY = hy + fwd.y * camDist
    local camZ = hz + 0.02

    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA',
        camX, camY, camZ, 0.0, 0.0, 0.0, 40.0, true, 2)
    PointCamAtCoord(cam, hx, hy, hz)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)

    -- Give the engine a moment to render the new frame.
    Wait(220)

    local function done(result)
        -- Restore camera + ped state.
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
        FreezeEntityPosition(ped, false)
        SetEntityCoords(ped, prevCoords.x, prevCoords.y, prevCoords.z, false, false, false, false)
        SetEntityHeading(ped, prevHeading)
        if not prevVisible then SetEntityVisible(ped, false) end
        SendNUIMessage({ action = 'panel:faceshot:after' })
        callback(result)
    end

    -- screenshot-basic returns a full data URI in modern builds,
    -- raw base64 in older ones. Normalise both.
    local function handle(result)
        if type(result) ~= 'string' or result == '' then
            return done(nil, 'capture failed')
        end
        local dataUri = result:match('^data:image/[%w%-+.]+;base64,') and result
            or ('data:image/jpeg;base64,' .. result)
        done(dataUri)
    end

    local ok = pcall(function()
        exports['screenshot-basic']:requestScreenshot({
            encoding = 'jpg',
            quality  = 0.7
        }, handle)
    end)
    if not ok then
        pcall(function()
            exports['screenshot-basic']:requestScreenshot(handle)
        end)
    end
end

-- NUI callback: returns the data URI as { dataUri = "..." }.
RegisterNUICallback('panel:faceshot', function(_, cb)
    SnapFace(function(dataUri, err)
        cb({ dataUri = dataUri, error = err })
    end)
end)
