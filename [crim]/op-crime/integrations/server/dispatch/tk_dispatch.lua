if Config.dispatchScript ~= "tk_dispatch" then return end

-- Fire addCall outside any player net-event stack.
-- tk_dispatch may otherwise resolve blip/location from `source` (the relay client).
local function pushTkCall(data)
    if GetResourceState('tk_dispatch') ~= 'started' then
        print('[op-crime] tk_dispatch is not started, alert skipped.')
        return false
    end

    if type(data) ~= "table" or not data.coords then
        return false
    end

    local x = tonumber(data.coords.x or data.coords[1])
    local y = tonumber(data.coords.y or data.coords[2])
    local z = tonumber(data.coords.z or data.coords[3])
    if not x or not y or not z then
        return false
    end

    local blip = type(data.blip) == "table" and data.blip or {}
    local callData = {
        title = tostring(data.title or "Alert"),
        code = tostring(data.code or "C04"),
        priority = tostring(data.priority or "Priority 3"),
        message = data.message and tostring(data.message) or nil,
        location = data.location and tostring(data.location) or nil,
        coords = vec3(x + 0.0, y + 0.0, z + 0.0),
        playSound = true,
        jobs = type(data.jobs) == "table" and data.jobs or { "police" },
        blip = {
            color = tonumber(blip.color) or 1,
            sprite = tonumber(blip.sprite) or 161,
            scale = tonumber(blip.scale) or 1.0,
        },
    }

    local ok, err = pcall(function()
        exports.tk_dispatch:addCall(callData)
    end)

    if not ok then
        print(('[op-crime] tk_dispatch:addCall failed: %s'):format(tostring(err)))
        return false
    end

    return true
end

-- Server-local (no player source). Use this for airdrops / scripted alerts.
AddEventHandler('op-crime:internalTkDispatchAlert', function(data)
    pushTkCall(data)
end)

function sendTkDispatchAlert(data)
    TriggerEvent('op-crime:internalTkDispatchAlert', data)
end

-- Client-relayed alerts (drugs, graffiti, etc.). Re-route through internal
-- event so tk_dispatch does not inherit the invoking player as `source`.
RegisterNetEvent('op-crime:tkDispatchAlert', function(data)
    TriggerEvent('op-crime:internalTkDispatchAlert', data)
end)
