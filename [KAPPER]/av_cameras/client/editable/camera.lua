local inCamera = false

-- Enabled when camera view is active, disables certain controls and sets busy state for animations
function usingCamera(state)
    inCamera = state
    LocalPlayer.state:set("invBusy", state, true) -- disables ox_inventory access
    LocalPlayer.state:set("busy", state, true) -- global busy state
    if state then
        -- You can trigger your hide hud here:

    else
        -- You can trigger your show hud here:

    end
end

-- The script will run this check before rendering the camera view
-- Use it to disable camera view for certain circumstances, for example a blackout
function canView()
    local allowed = true
    -- EXAMPLE blocking camera view during blackout with av_weather:
    if GetResourceState("av_weather") == "started" then
        local blackout = exports['av_weather']:getBlackout()
        if blackout then
            allowed = false
            TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['blackout'] or "City blackout in progress, can't access cameras.", "error")
        end
    end

    dbug("Checking if camera view is allowed, result: "..tostring(allowed))
    return allowed
end

exports('usingCamera', function()
    return inCamera
end)